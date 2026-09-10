package com.spring.yolo;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;
import com.spring.dto.AnimalCounterVO;
import com.spring.dto.DangerLogVO;
import com.spring.dto.DetectionLogVO;
import com.spring.dto.DroneVO;
import com.spring.dto.VideoDroneMapVO;
import com.spring.service.AlertLogService;
import com.spring.service.AnimalCounterService;
import com.spring.service.DangerLogService;
import com.spring.service.DetectionLogService;
import com.spring.service.DroneService;
import com.spring.service.VideoDroneMapService;

import jakarta.servlet.http.HttpServletResponse;

@Controller
public class AIStreamBridgeController {

	private final String FLASK_SERVER_URL = "http://localhost:5000/stream";
	private static String currentMode = "local";

	@Autowired
	private DetectionLogService detectionLogService; // 정상 축종 미달 서비스 [INDEX]

	@Autowired
	private DangerLogService dangerLogService; // 위험 이상객체 서비스 [INDEX]

	@Autowired
	private AnimalCounterService animalCounterService;

	@Autowired
	private AlertLogService alertLogService;

	@Autowired
	private VideoDroneMapService videoDroneMapService;

	@Autowired
	private DroneService droneService;

	private static final Map<String, String> videoDroneCache = new ConcurrentHashMap<>();
	private static boolean isDroneCacheLoaded = false;
	private static String lastActiveSourceKey = "video_1";

	private static int cachedDogCount = -1;
	private static int cachedCatCount = -1;
	private static boolean isMetadataLoaded = false; // 최초 1회 로드 확인용 플래그 스위치

	private static final Map<Integer, Long> lastNormalInsertTimeMap = new ConcurrentHashMap<>();
	private static final Map<Integer, Long> lastInsertTimeMap = new ConcurrentHashMap<>();

	private static final long ALARM_COOLDOWN_MS = 10000;

	@GetMapping("/yolo/view")
	public String showMainControlPage() {
		return "main";
	}

	@PostMapping("/yolo/updateMapping")
	@ResponseBody
	public ResponseEntity<String> updateVideoDroneMapping(@RequestParam("sourceKey") String sourceKey,
			@RequestParam("droneId") String droneId) {
		try {
			videoDroneMapService.modifyDroneMapping(sourceKey, droneId);
			return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping("/yolo/changeVideo/{sourceKey}")
	@ResponseBody
	public String changeVideoSource(@PathVariable("sourceKey") String sourceKey) {
		try {
			System.out.println(" [스프링] 사용자가 새로운 채널 전환 요청: " + sourceKey);
			lastActiveSourceKey = sourceKey;

			RestTemplate restTemplate = new RestTemplate();
			if ("esp32".equals(sourceKey)) {
				currentMode = "esp32";
			} else {
				currentMode = "local";
			}
			String flaskApiUrl = FLASK_SERVER_URL + "/change_source/" + sourceKey;
			restTemplate.getForObject(flaskApiUrl, String.class);
		} catch (Exception e) {
			System.err.println("❌ 파이썬 엔진 연동 통지 실패: " + e.getMessage());
		}
		return "OK";
	}

	@RequestMapping("/yolo/videoFeed")
	public void bridgeStream(HttpServletResponse response) {
		String pythonServerUrl = FLASK_SERVER_URL + "/video_feed";
		executeProxy(pythonServerUrl, response, 3000, 3000, false);
	}

	@RequestMapping(value = "/yolo/labels", produces = "application/json; charset=UTF-8")
	public void bridgeLabels(HttpServletResponse response) {
		String pythonJsonUrl = FLASK_SERVER_URL + "/labels_feed";
		long currentTime = System.currentTimeMillis();
		boolean isFlaskAlive = false;
		try {
			if (!isMetadataLoaded) {
				System.out.println(" [스프링 전역 캐시] 오라클 ANIMAL_COUNTER 초기화 로드 개시.");
				PageMaker dummyPageMaker = new com.spring.cmd.PageMaker();
				dummyPageMaker.setPage(1);
				List<AnimalCounterVO> dbCounterList = animalCounterService
						.getAnimalCounterList(dummyPageMaker);
				if (dbCounterList != null) {
					for (AnimalCounterVO cvo : dbCounterList) {
						if (cvo.getCounterId() == 0)
							cachedDogCount = cvo.getCurrentCount();
						if (cvo.getCounterId() == 1)
							cachedCatCount = cvo.getCurrentCount();
					}
				}
				if (cachedDogCount == -1)
					cachedDogCount = 2;
				if (cachedCatCount == -1)
					cachedCatCount = 1;
				isMetadataLoaded = true;
			}

			URL url = new URL(pythonJsonUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setConnectTimeout(1500);
			conn.setReadTimeout(1500);

			if (conn.getResponseCode() == 200) {
				isFlaskAlive = true;
				ObjectMapper mapper = new ObjectMapper();
				JsonNode root = mapper.readTree(conn.getInputStream());
				JsonNode boxesNode = root.get("boxes");
				List<String> detectedLabels = new ArrayList<>();

				if (boxesNode != null && boxesNode.isArray()) {
					for (JsonNode box : boxesNode) {
						if (box.size() >= 5) {
							detectedLabels.add(box.get(4).asText());
						}
					}
				}

				// 동적으로 채널에 할당된 진짜 드론 ID를 조회합니다.
				String currentActiveDroneId = resolveActiveDroneId();

				int dogTargetLimit = 2;
				int catTargetLimit = 1;

				synchronized (lastNormalInsertTimeMap) {
					// [트랙 A - 1] 반려견 개체수 부족 체크
					if (cachedDogCount < dogTargetLimit) {
						long lastDogTime = lastNormalInsertTimeMap.getOrDefault(0, 0L);
						if ((currentTime - lastDogTime) >= ALARM_COOLDOWN_MS) {
							lastNormalInsertTimeMap.put(0, currentTime);
							DetectionLogVO nvo = new DetectionLogVO();
							nvo.setAnimalType("0");
							nvo.setDetectCount(cachedDogCount);
							nvo.setDroneId(currentActiveDroneId); // 동적 드론 매핑 적용
							nvo.setActionStatus("0");
							nvo.setActionReason("반려견 개체수 부족 자동 감지 로그");
							detectionLogService.registerDetectionLog(nvo);

							try {
								Integer finalDlogId = (nvo.getDlogId() > 0) ? nvo.getDlogId() : null;
								AlertLogVO avo = AlertLogVO.builder().alertType("0")
										.alertMsg("⚠ [관제 경보] 모니터링 구역 내 기본 반려견 개체수 부족 현상 발생!").sendStatus("1")
										.dlogId(finalDlogId).firstSendTime(new Timestamp(System.currentTimeMillis()))
										.build();
								alertLogService.registerAlertLog(avo);
								System.out
										.println(" [10초 쿨다운] '반려견 미달(0)' 동적 드론 [" + currentActiveDroneId + "] 연동 성공!");
							} catch (Exception ex) {
								System.err.println("❌ 반려견 경보 적재 에러: " + ex.getMessage());
							}
						}
					}

					// [트랙 A - 2] 고양이 개체수 부족 체크
					if (cachedCatCount < catTargetLimit) {
						long lastCatTime = lastNormalInsertTimeMap.getOrDefault(1, 0L);
						if ((currentTime - lastCatTime) >= ALARM_COOLDOWN_MS) {
							lastNormalInsertTimeMap.put(1, currentTime);
							DetectionLogVO nvo = new DetectionLogVO();
							nvo.setAnimalType("1");
							nvo.setDetectCount(cachedCatCount);
							nvo.setDroneId(currentActiveDroneId); // 동적 드론 매핑 적용
							nvo.setActionStatus("0");
							nvo.setActionReason("고양이 개체수 부족 자동 감지 로그");
							detectionLogService.registerDetectionLog(nvo);

							try {
								Integer finalDlogId = (nvo.getDlogId() > 0) ? nvo.getDlogId() : null;
								AlertLogVO avo = AlertLogVO.builder().alertType("0")
										.alertMsg("⚠ [관제 경보] 모니터링 구역 내 기본 고양이 개체수 부족 현상 발생!").sendStatus("1")
										.dlogId(finalDlogId).firstSendTime(new Timestamp(System.currentTimeMillis()))
										.build();
								alertLogService.registerAlertLog(avo);
								System.out
										.println(" [10초 쿨다운] '고양이 미달(1)' 동적 드론 [" + currentActiveDroneId + "] 연동 성공!");
							} catch (Exception ex) {
								System.err.println("❌ 고양이 경보 적재 에러: " + ex.getMessage());
							}
						}
					}
				}

				// [트랙 B] 유해 야생동물(이상객체) 체크
				if (detectedLabels.contains("pink_dragon") || detectedLabels.contains("tiger")
						|| detectedLabels.contains("blue_alien")) {
					int currentDangerType = 0;
					String dangerName = "이상 객체";

					if (detectedLabels.contains("blue_alien")) {
						currentDangerType = 2;
						dangerName = "외계 생물(블루)";
					} else if (detectedLabels.contains("pink_dragon")) {
						currentDangerType = 4;
						dangerName = "유해 비행체(드래곤)";
					} else if (detectedLabels.contains("tiger")) {
						currentDangerType = 5;
						dangerName = "맹수(호랑이)";
					}

					if (currentDangerType != 0) {
						long lastInsertTime = lastInsertTimeMap.getOrDefault(currentDangerType, 0L);
						if ((currentTime - lastInsertTime) >= ALARM_COOLDOWN_MS) {
							DangerLogVO dvo = new DangerLogVO();
							dvo.setDangerType(currentDangerType);
							dvo.setDactionStatus("0");
							dvo.setDactionReason("스프링 고속 라벨 중계 허브 엔진 실시간 객체 가로채기 기록");
							dvo.setDroneId(currentActiveDroneId); // 동적 드론 매핑 적용
							dangerLogService.registerDangerLog(dvo);

							try {
								Integer finalDanlogId = (dvo.getDanlogId() > 0) ? dvo.getDanlogId() : null;
								AlertLogVO avo = AlertLogVO.builder().alertType("1")
										.alertMsg(" [비상 경보] 관제 구역 내 위험 이상객체 [" + dangerName + "] 실시간 출현! 대피 요망.")
										.sendStatus("1").danlogId(finalDanlogId)
										.firstSendTime(new Timestamp(System.currentTimeMillis())).build();
								alertLogService.registerAlertLog(avo);
								System.out.println(" [통합 연동] '이상객체(1)' 동적 드론 [" + currentActiveDroneId + "] 연동 성공!");
							} catch (Exception ex) {
								System.err.println("❌ 위험 경보 적재 에러: " + ex.getMessage());
							}
							lastInsertTimeMap.put(currentDangerType, currentTime);
						}
					}
				}
			} else {
				return;
			}
		} catch (Exception e) {
			return;
		}

		if (isFlaskAlive) {
			executeProxy(pythonJsonUrl, response, 2000, 2000, true);
		}
	}

	public static void updateInmemoryDroneCache(String sourceKey, String droneId) {
		videoDroneCache.put(sourceKey, droneId);
		System.out.println("✈ [인메모리 동기화 완수] 서비스 레이어 요청으로 캐시 갱신: " + sourceKey + " -> " + droneId);
	}

	private synchronized void initDroneCache() {
		if (!isDroneCacheLoaded) {
			try {
				List<VideoDroneMapVO> list = videoDroneMapService.getAllMappings();
				if (list != null) {
					for (VideoDroneMapVO vo : list) {
						videoDroneCache.put(vo.getSourceKey(), vo.getDroneId());
					}
				}
				isDroneCacheLoaded = true;
				System.out.println("✈ [캐시 로드 완료] DB 매핑 정보 적재 성공.");
			} catch (Exception e) {
				System.err.println("❌ 드론 매핑 초기 캐싱 실패: " + e.getMessage());
			}
		}
	}

	private String resolveActiveDroneId() {
		if (!isDroneCacheLoaded) {
			initDroneCache();
		}
		String activeKey = "esp32".equals(currentMode) ? "esp32" : lastActiveSourceKey;
		return videoDroneCache.getOrDefault(activeKey, "DRONE01");
	}

	public static void refreshAnimalCounterCache(int dogCount, int catCount) {
		cachedDogCount = dogCount;
		cachedCatCount = catCount;
		isMetadataLoaded = true;
	}

	private void executeProxy(String targetUrl, HttpServletResponse response, int connectTimeout, int readTimeout,
			boolean isJson) {
		HttpURLConnection connection = null;
		InputStream is = null;
		OutputStream os = null;
		try {
			URL url = new URL(targetUrl);
			int targetReadTimeout = isJson ? readTimeout : 1000;
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setConnectTimeout(connectTimeout);
			connection.setRequestProperty("Connection", "close");
			connection.setReadTimeout(targetReadTimeout);

			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);

			if (isJson) {
				response.setContentType("application/json; charset=UTF-8");
			} else {
				response.setContentType("multipart/x-mixed-replace; boundary=frame");
			}

			is = new BufferedInputStream(connection.getInputStream());
			os = response.getOutputStream();

			byte[] buffer = new byte[4096];
			int bytesRead;

			// 스레드 인터럽트 감시 루프
			while (!Thread.currentThread().isInterrupted()) {

				// 화면에서 사용자가 채널 버튼을 바꾸면 즉시 중계 루프 탈출
				if (!isJson && "esp32".equals(currentMode) && targetUrl.contains("/stream"))
					break;
				if (!isJson && "local".equals(currentMode) && targetUrl.contains("/esp32_yolov12"))
					break;

				try {
					bytesRead = is.read(buffer);
					if (bytesRead == -1)
						break;

					os.write(buffer, 0, bytesRead);
					if (!isJson) {
						os.flush();
					}
				} catch (SocketTimeoutException e) {
					if (Thread.currentThread().isInterrupted()) {
						break;
					}
				} catch (IOException ioEx) {
					break;
				}
			}
			if (os != null)
				os.flush();

		} catch (java.io.InterruptedIOException e) {
			Thread.currentThread().interrupt();
		} catch (Exception e) {
		} finally {
			try {
				if (is != null)
					is.close();
			} catch (Exception e) {
			}
			try {
				if (os != null)
					os.close();
			} catch (Exception e) {
			}
			if (connection != null) {
				connection.disconnect();
			}
		}
	}

	@RequestMapping(value = "/yolo/currentMappings", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getCurrentMappings() {
		Map<String, Object> resultMap = new HashMap<>();
		try {
			if (!isDroneCacheLoaded) {
				initDroneCache();
			}

			resultMap.put("activeMappings", videoDroneCache);

			PageMaker dbPageMaker = new PageMaker();
			dbPageMaker.setPage(1);
			dbPageMaker.setPerPageNum(1000); // 1000개 행 타겟 세팅으로 getEndRow() 연산 완벽 매핑

			List<DroneVO> dbDroneList = droneService.getDroneList(dbPageMaker);

			List<String> droneIdList = new ArrayList<>();
			if (dbDroneList != null) {
				for (DroneVO dvo : dbDroneList) {
					if (dvo.getDroneId() != null) {
						droneIdList.add(dvo.getDroneId());
					}
				}
			}

			resultMap.put("dbDroneList", droneIdList);

		} catch (Exception e) {
			System.err.println("❌ 서비스 레이어 재활용 동적 조회 최종 실패: " + e.getMessage());
		}
		return new ResponseEntity<>(resultMap, HttpStatus.OK);
	}

}
