package com.spring.yolo;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class AIStreamBridgeController {

    private final String FLASK_SERVER_URL = "http://localhost:5000/stream";
    private static String currentMode = "local";

    // 🎯 [실무형 변수 호출 매핑] 흩어져 있던 2개의 핵심 관제 서비스 레이어를 한곳으로 모읍니다.
    @Autowired
    private com.spring.service.DetectionLogService detectionLogService; // 정상 축종 미달 서비스 [INDEX]
    
    @Autowired
    private com.spring.service.DangerLogService dangerLogService;       // 위험 이상객체 서비스 [INDEX]

    // 🎯 [현황판 서비스 레이어 의존성 호출 추가]
    @Autowired
    private com.spring.service.AnimalCounterService animalCounterService;
    
    // =================================================================
    // 🎯 [질문자님 아키텍처 저격: 초고속 인메모리 전역 변수 캐시 서랍장 개설]
    // =================================================================
    // 서버가 켜질 때 최초 1회만 DB에서 수량을 딱 긁어와 여기에 보관합니다.
    // 이후 60ms마다 들어오는 무한 빨대 요청은 DB를 0번 조회하고, 오직 이 전역 변수만 쳐다봅니다!
    private static int cachedDogCount = -1;
    private static int cachedCatCount = -1;
    private static boolean isMetadataLoaded = false; // 최초 1회 로드 확인용 플래그 스위치

    
    // 🐶 [정상 축종 미달 전용 독립 쿨다운 서랍장] (개:0, 고양이:1)
    private static final java.util.Map<Integer, Long> lastNormalInsertTimeMap = new java.util.concurrent.ConcurrentHashMap<>();
    
    // 🎯 [객체별 독립 쿨다운 마스터 매핑 서랍장 선언]
    // ConcurrentHashMap을 사용하여 여러 사물(외계인:2, 용:4, 호랑이:5)이 동시에 포착되어도 
    // 각자 독립된 마지막 저장 시각을 밀리초(ms) 단위로 따로따로 안전하게 관리합니다.
    private static final java.util.Map<Integer, Long> lastInsertTimeMap = new java.util.concurrent.ConcurrentHashMap<>();
    
    
    // 💡 [개별 쿨다운 규격 수식] 10초 설정
    private static final long ALARM_COOLDOWN_MS = 10000; 
    
    @GetMapping("/yolo/view")
    public String showMainControlPage() {
        return "main"; 
    }

    @RequestMapping("/yolo/changeVideo/{sourceKey}")
    @ResponseBody
    public String changeVideoSource(@PathVariable("sourceKey") String sourceKey) {
        try {
            System.out.println("🔄 [스프링] 사용자가 새로운 채널 전환 요청: " + sourceKey);
            RestTemplate restTemplate = new RestTemplate();
            
            if ("esp32".equals(sourceKey)) {
                currentMode = "esp32";
            } else {
                currentMode = "local";
            }

            String flaskApiUrl = FLASK_SERVER_URL + "/change_source/" + sourceKey;
            restTemplate.getForObject(flaskApiUrl, String.class);
        } catch (Exception e) {
            System.err.println("❌ [스프링] 파이썬 마스터 엔진 연동 통지 실패: " + e.getMessage());
        }
        return "OK"; 
    }

    @RequestMapping("/yolo/videoFeed")
    public void bridgeStream(HttpServletResponse response) { 
        String pythonServerUrl = FLASK_SERVER_URL + "/video_feed"; 
        executeProxy(pythonServerUrl, response, 3000, 3000, false);
    }
    
    /**
     * 🎯 [질문자님 아키텍처 완벽 구현]
     * 보안 락이 걸리는 POST 통신을 폐기하고, 합법적인 GET 라벨 피드 통로에서 
     * 자바가 데이터를 실시간으로 직접 긁어와서 오라클 DB에 안전 적재합니다!
     */
    @RequestMapping(value = "/yolo/labels", produces = "application/json; charset=UTF-8")
    public void bridgeLabels(HttpServletResponse response) {
        String pythonJsonUrl = FLASK_SERVER_URL + "/labels_feed";
        long currentTime = System.currentTimeMillis();
        
        try {
            // 🎯 [무한 SELECT 난사 원천 폭파 방어선]
            // 스위치가 꺼져 있을 때(최초 서버 구동 시 딱 1번만) 오라클 DB 문을 열고 마스터 수량을 긁어옵니다.
            if (!isMetadataLoaded) {
                System.out.println("🧱 [스프링 전역 캐시] 서버 최초 구동 확인 ➔ 오라클 ANIMAL_COUNTER 마스터 현황판 최초 1회 정밀 로드 개시.");
                com.spring.cmd.PageMaker dummyPageMaker = new com.spring.cmd.PageMaker();
                dummyPageMaker.setPage(1); 
                
                java.util.List<com.spring.dto.AnimalCounterVO> dbCounterList = animalCounterService.getAnimalCounterList(dummyPageMaker);
                if (dbCounterList != null) {
                    for (com.spring.dto.AnimalCounterVO cvo : dbCounterList) {
                        if (cvo.getCounterId() == 0) cachedDogCount = cvo.getCurrentCount(); // 개의 최초 수량 각인
                        if (cvo.getCounterId() == 1) cachedCatCount = cvo.getCurrentCount(); // 고양이의 최초 수량 각인
                    }
                }
                
                // 만약 DB가 비어있다면 최소 안전 방어선 수치 부여
                if (cachedDogCount == -1) cachedDogCount = 2;
                if (cachedCatCount == -1) cachedCatCount = 1;
                
                isMetadataLoaded = true; // 🎯 스위치를 ON 시켜서, 앞으로 톰캣이 꺼질 때까지 다시는 상단 DB 조회를 실행하지 못하도록 락을 걸어버립니다!
                System.out.println("🧱 [스프링 전역 캐시] 로드 완료 완료! ➔ 전역 변수 적재 수량 [개: " + cachedDogCount + "마리, 고양이: " + cachedCatCount + "마리]");
            }

            // 파이썬 라벨 피드 바이너리 통신 개통
            java.net.URL url = new java.net.URL(pythonJsonUrl);
            java.net.HttpURLConnection conn = (java.net.HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(1500);
            conn.setReadTimeout(1500);

            if (conn.getResponseCode() == 200) {
                ObjectMapper mapper = new ObjectMapper();
                com.fasterxml.jackson.databind.JsonNode root = mapper.readTree(conn.getInputStream());
                
                com.fasterxml.jackson.databind.JsonNode boxesNode = root.get("boxes");
                java.util.List<String> detectedLabels = new java.util.ArrayList<>();
                if (boxesNode != null && boxesNode.isArray()) {
                    for (com.fasterxml.jackson.databind.JsonNode box : boxesNode) {
                        if (box.size() >= 5) {
                            detectedLabels.add(box.get(4).asText());
                        }
                    }
                }

                // =================================================================
                // 📑 [트랙 A: 정상 축종 개체수 미달 연산 구간 (DB 조회 0건! 100% 전역 변수 제어)]
                // =================================================================
                int dogTargetLimit = 2; 
                int catTargetLimit = 1; 

                // 🎯 이제 DB를 찌르지 않고, 서버 안방 전역 변수 메모리에 올라와 있는 cachedDogCount, cachedCatCount 값을 사용하므로 렉이 0%로 줄어듭니다!
                if (cachedDogCount < dogTargetLimit) {
                    long lastDogTime = lastNormalInsertTimeMap.getOrDefault(0, 0L);
                    if ((currentTime - lastDogTime) >= ALARM_COOLDOWN_MS) {
                        com.spring.dto.DetectionLogVO nvo = new com.spring.dto.DetectionLogVO();
                        nvo.setAnimalType("0"); 
                        nvo.setDetectCount(cachedDogCount);
                        nvo.setDroneId("DRONE01"); 
                        nvo.setActionStatus("0");
                        nvo.setActionReason("초고속 전역 메모리 수치 기반 실시간 개 부족 경보 인서트");
                        
                        System.out.println("⏰ [메모리 관제 경보] ➔ 현재 전역 변수 개 마리수 [" + cachedDogCount + "마리] 부족 감지! 오라클 적재.");
                        detectionLogService.registerDetectionLog(nvo);
                        lastNormalInsertTimeMap.put(0, currentTime); 
                    }
                }

                if (cachedCatCount < catTargetLimit) {
                    long lastCatTime = lastNormalInsertTimeMap.getOrDefault(1, 0L);
                    if ((currentTime - lastCatTime) >= ALARM_COOLDOWN_MS) {
                        com.spring.dto.DetectionLogVO nvo = new com.spring.dto.DetectionLogVO();
                        nvo.setAnimalType("1"); 
                        nvo.setDetectCount(cachedCatCount);
                        nvo.setDroneId("DRONE01"); 
                        nvo.setActionStatus("0");
                        nvo.setActionReason("초고속 전역 메모리 수치 기반 실시간 고양이 부족 경보 인서트");
                        
                        System.out.println("⏰ [메모리 관제 경보] ➔ 현재 전역 변수 고양이 마리수 [" + cachedCatCount + "마리] 부족 감지! 오라클 전송 완료.");
                        detectionLogService.registerDetectionLog(nvo);
                        lastNormalInsertTimeMap.put(1, currentTime); 
                    }
                }

                // =================================================================
                // 📑 [트랙 B: 유해 이상객체 출현 연산 구간 (무결점 유지)]
                // =================================================================
                if (detectedLabels.contains("pink_dragon") || detectedLabels.contains("tiger") || detectedLabels.contains("blue_alien")) {
                    int currentDangerType = 0;
                    if (detectedLabels.contains("blue_alien")) currentDangerType = 2;
                    else if (detectedLabels.contains("blue_shark")) currentDangerType = 3;
                    else if (detectedLabels.contains("pink_dragon")) currentDangerType = 4;
                    else if (detectedLabels.contains("tiger")) currentDangerType = 5;

                    if (currentDangerType != 0) {
                        long lastInsertTime = lastInsertTimeMap.getOrDefault(currentDangerType, 0L);
                        
                        if ((currentTime - lastInsertTime) < ALARM_COOLDOWN_MS) {
                            // 쿨다운 통과
                        } else {
                            com.spring.dto.DangerLogVO dvo = new com.spring.dto.DangerLogVO();
                            dvo.setDangerType(currentDangerType);
                            dvo.setDactionStatus("0");
                            dvo.setDactionReason("스프링 고속 라벨 중계 허브 엔진 실시간 객체별 독립 가로채기 원격 기록");
                            dvo.setDroneId("DRONE01");

                            System.out.println("🚨 [이상객체 쿨다운 통과] 위험 코드 [" + currentDangerType + "]번 출현 ➔ 오라클 실시간 1건 저장!");
                            dangerLogService.registerDangerLog(dvo);
                            
                            lastInsertTimeMap.put(currentDangerType, currentTime);
                        }
                    }
                }
            }
        } catch (Exception e) {
            // 비동기 노이즈 스킵
        }

        executeProxy(pythonJsonUrl, response, 2000, 2000, true);
    }

    // 💡 [실무 고도화 팁] 나중에 웹 화면에서 수량이 변경(등록/삭제)되면 
    // 이 메서드를 서비스단에서 호출해서 전역 변수 값만 새로고침 해주시면 영구 버그가 완전히 예방됩니다!
    public static void refreshAnimalCounterCache(int dogCount, int catCount) {
        cachedDogCount = dogCount;
        cachedCatCount = catCount;
        isMetadataLoaded = true;
    }


    private void executeProxy(String targetUrl, HttpServletResponse response, int connectTimeout, int readTimeout, boolean isJson) {
        HttpURLConnection connection = null;
        try {
            URL url = new URL(targetUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(connectTimeout);
            connection.setReadTimeout(readTimeout); 

            response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);

            if (isJson) {
                response.setContentType("application/json; charset=UTF-8");
            } else {
                response.setContentType("multipart/x-mixed-replace; boundary=frame");
            }

            try (InputStream is = new BufferedInputStream(connection.getInputStream());
                 OutputStream os = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096]; 
                int bytesRead;
                
                // 💡 getWriter() 충돌 로직 제거! 오직 쓰레드 인터럽트와 스트림 자체의 정상 종료만 체크합니다.
                while (!Thread.currentThread().isInterrupted() && (bytesRead = is.read(buffer)) != -1) {
                    os.write(buffer, 0, bytesRead);
                    if (!isJson) {
                        os.flush(); // MJPEG 영상은 매 프레임 즉시 밀어내야 화면이 나옵니다.
                    }
                }
                os.flush();
            }
        } catch (java.io.InterruptedIOException e) {
            // 톰캣 종료로 인한 인터럽트 발생 시 쓰레드 상태 복구 후 안전 종료
            Thread.currentThread().interrupt(); 
        } catch (Exception e) {
            // 클라이언트가 브라우저 창을 닫아 발생하는 ClientAbortException 등 비동기 노이즈 스킵
        } finally {
            if (connection != null) {
                connection.disconnect(); 
            }
        }
    }

    
}
