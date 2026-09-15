package com.spring.yolo;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InterruptedIOException;
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
import org.springframework.ui.Model;
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
import com.spring.dto.DroneVO;
import com.spring.dto.FlightHistoryVO;
import com.spring.service.DroneService;
import com.spring.service.FlightHistoryService;
import com.spring.service.VideoDroneMapService;
import com.spring.util.RuntimeSettings;

import jakarta.servlet.http.HttpServletResponse;

@Controller
public class AIStreamBridgeController {

	private static final String FLASK_SERVER_URL = RuntimeSettings.text(
			"SSA_FLASK_STREAM_URL", "http://localhost:5000/stream");
	private static final String FLASK_ESP32_VIDEO_URL = RuntimeSettings.text(
			"SSA_FLASK_ESP32_VIDEO_URL", "http://localhost:5000/esp32_yolov12/video_feed");
	private static final int FLASK_VIDEO_CONNECT_TIMEOUT_MS = RuntimeSettings.positiveInt(
			"SSA_FLASK_VIDEO_CONNECT_TIMEOUT_MS", 3000);
	private static final int FLASK_VIDEO_READ_TIMEOUT_MS = RuntimeSettings.positiveInt(
			"SSA_FLASK_VIDEO_READ_TIMEOUT_MS", 3000);
	private static final int FLASK_LABEL_TIMEOUT_MS = RuntimeSettings.positiveInt(
			"SSA_FLASK_LABEL_TIMEOUT_MS", 1500);
	private static final boolean LEGACY_LABEL_EVENT_SIDE_EFFECTS_ENABLED =
			RuntimeSettings.enabled("SSA_ENABLE_LEGACY_LABEL_EVENT_SIDE_EFFECTS", false);
	private static String currentMode = "local";
	private static String lastActiveSourceKey = "video_1";

	//  복잡한 다중 서비스 주입을 철폐하고 단 하나의 비즈니스 코어 서비스로 통합 단일화!
	@Autowired
	private AIStreamBridgeService aiStreamBridgeService;

	@Autowired
	private VideoDroneMapService videoDroneMapService;

	@Autowired
	private DroneService droneService;

	@Autowired
	private FlightHistoryService flightHistoryService;

	private static final Map<String, Long> activeFlightStartMap = new ConcurrentHashMap<>();

	@GetMapping("/yolo/view")
	public String showMainControlPage(Model model) {
		model.addAttribute("flaskEsp32VideoUrl", FLASK_ESP32_VIDEO_URL);
		return "main";
	}

	@PostMapping("/yolo/updateMapping")
	@ResponseBody
	public ResponseEntity<String> updateVideoDroneMapping(@RequestParam("sourceKey") String sourceKey,
			@RequestParam("droneId") String droneId) {
		try {
			videoDroneMapService.modifyDroneMapping(sourceKey, droneId);
			// 외부에 분리 개설된 서비스의 메모리 캐시 서랍장도 실시간 새로고침
			aiStreamBridgeService.updateInmemoryDroneCache(sourceKey, droneId);
			return new ResponseEntity<>("{\"status\":\"SUCCESS\"}", HttpStatus.OK);
		} catch (Exception e) {
			return new ResponseEntity<>("{\"status\":\"FAIL\"}", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping("/yolo/videoFeed")
	public void bridgeStream(HttpServletResponse response) {
		if (!activeFlightStartMap.containsKey(lastActiveSourceKey)) {
			activeFlightStartMap.put(lastActiveSourceKey, System.currentTimeMillis());
			System.out.println(" [최초 화면 진입 이륙] 채널 [" + lastActiveSourceKey + "]의 첫 비행 타이머가 가동되었습니다.");
		}
		String pythonServerUrl = FLASK_SERVER_URL + "/video_feed";
		executeProxy(pythonServerUrl, response, FLASK_VIDEO_CONNECT_TIMEOUT_MS, FLASK_VIDEO_READ_TIMEOUT_MS, false);
	}

	@RequestMapping("/yolo/changeVideo/{sourceKey}")
	@ResponseBody
	public String changeVideoSource(@PathVariable("sourceKey") String sourceKey) {
		System.out.println(" → [스프링] 사용자가 새로운 채널 전환 요청: " + sourceKey);
		try {
			String prevSourceKey = lastActiveSourceKey;
			if (activeFlightStartMap.containsKey(prevSourceKey)) {
				long startTimeMs = activeFlightStartMap.remove(prevSourceKey);
				long endTimeMs = System.currentTimeMillis();
				double durationHours = (double) (endTimeMs - startTimeMs) / 3600000.0;

				String prevDroneId = aiStreamBridgeService.resolveActiveDroneId(currentMode, prevSourceKey);

				FlightHistoryVO historyVO = FlightHistoryVO.builder().startTime(new Timestamp(startTimeMs))
						.endTime(new Timestamp(endTimeMs)).flightDuration(durationHours).droneId(prevDroneId).build();
				if (flightHistoryService.registerFlightHistory(historyVO) != 1) {
					System.err.println("[비행 이력 미적재] DRONE 기체 ID 또는 source 매핑을 확인하세요: " + prevDroneId);
				} else
				System.out.println(" [자동 착륙 적재 완수] 드론 [" + prevDroneId + "] 비행 이력 DB 저장 완료.");
			}

			activeFlightStartMap.put(sourceKey, System.currentTimeMillis());
			System.out.println(" [채널 전환 이륙 감지] 새 채널 [" + sourceKey + "] 비행 타이머 시작.");

			lastActiveSourceKey = sourceKey;
			RestTemplate restTemplate = new RestTemplate();
			currentMode = "esp32".equals(sourceKey) ? "esp32" : "local";

			String flaskApiUrl = FLASK_SERVER_URL + "/change_source/" + sourceKey;
			restTemplate.getForObject(flaskApiUrl, String.class);
		} catch (Exception e) {
			System.err.println("❌ 비행 이력 자동 연동 오류: " + e.getMessage());
		}
		return "OK";
	}

	@RequestMapping(value = "/yolo/labels", produces = "application/json; charset=UTF-8")
	public void bridgeLabels(HttpServletResponse response) {
		String pythonJsonUrl = FLASK_SERVER_URL + "/labels_feed";
		boolean isFlaskAlive = false;
		try {
			URL url = new URL(pythonJsonUrl);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setConnectTimeout(FLASK_LABEL_TIMEOUT_MS);
			conn.setReadTimeout(FLASK_LABEL_TIMEOUT_MS);

			if (conn.getResponseCode() == 200) {
				isFlaskAlive = true;

				if (LEGACY_LABEL_EVENT_SIDE_EFFECTS_ENABLED) {
				ObjectMapper mapper = new ObjectMapper();
				JsonNode root = mapper.readTree(conn.getInputStream());

				// ➔ 핵심 분리 포인트: 비대하던 오라클 인서트 로직 전체를 분리해낸 전문 서비스 레이어로 위임 슛!
				aiStreamBridgeService.processYoloLabels(root, currentMode, lastActiveSourceKey);
				}
			}
		} catch (Exception e) {
			// 통신 노이즈 패스
		}

		if (isFlaskAlive) {
			executeProxy(pythonJsonUrl, response, FLASK_LABEL_TIMEOUT_MS, FLASK_LABEL_TIMEOUT_MS, true);
		}
	}

	@RequestMapping(value = "/yolo/currentMappings", produces = "application/json; charset=UTF-8")
	@ResponseBody
	public ResponseEntity<Map<String, Object>> getCurrentMappings() {
		Map<String, Object> resultMap = new HashMap<>();
		try {
			resultMap.put("activeMappings", aiStreamBridgeService.getRawDroneCache());

			PageMaker dbPageMaker = new PageMaker();
			dbPageMaker.setPage(1);
			dbPageMaker.setPerPageNum(1000);
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

	private void executeProxy(String targetUrl, HttpServletResponse response, int connectTimeout, int readTimeout,
			boolean isJson) {
		HttpURLConnection connection = null;
		InputStream is = null;
		OutputStream os = null;
		try {
			URL url = new URL(targetUrl);
			connection = (HttpURLConnection) url.openConnection();
			connection.setRequestMethod("GET");
			connection.setConnectTimeout(connectTimeout);
			connection.setRequestProperty("Connection", "close");
			connection.setReadTimeout(isJson ? readTimeout : 1000);

			response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
			response.setHeader("Pragma", "no-cache");
			response.setDateHeader("Expires", 0);
			response.setContentType(
					isJson ? "application/json; charset=UTF-8" : "multipart/x-mixed-replace; boundary=frame");

			is = new BufferedInputStream(connection.getInputStream());
			os = response.getOutputStream();
			byte[] buffer = new byte[4096];
			int bytesRead;

			while (!Thread.currentThread().isInterrupted()) {
				if (!isJson && "esp32".equals(currentMode) && targetUrl.contains("/stream"))
					break;
				if (!isJson && "local".equals(currentMode) && targetUrl.contains("/esp32_yolov12"))
					break;

				try {
					bytesRead = is.read(buffer);
					if (bytesRead == -1)
						break;
					os.write(buffer, 0, bytesRead);
					if (!isJson)
						os.flush();
				} catch (SocketTimeoutException e) {
					if (Thread.currentThread().isInterrupted())
						break;
				} catch (IOException ioEx) {
					break;
				}
			}
			if (os != null)
				os.flush();
		} catch (InterruptedIOException e) {
			Thread.currentThread().interrupt();
		} catch (Exception e) {
			// 패스
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
			if (connection != null)
				connection.disconnect();
		}
	}
}
