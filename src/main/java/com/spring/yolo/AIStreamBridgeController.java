package com.spring.yolo;

import java.io.BufferedInputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class AIStreamBridgeController {

    private final String FLASK_SERVER_URL = "http://localhost:5000/stream";
    private final String FLASK_ESP_URL = "http://localhost:5000/esp32_yolov12";

    // 스트리밍 모드 플래그 (local / esp32)
    private static String currentMode = "local";

    @GetMapping("/yolo/view")
    public String showMainControlPage() {
        return "main"; 
    }

    // ========================================================
    // 🔄 [버그 수정] 비동기 모드 스위칭 시 기존 연결을 확실히 차단하는 컨트롤러
    // ========================================================
    @RequestMapping("/yolo/changeVideo/{sourceKey}")
    @ResponseBody
    public String changeVideoSource(@PathVariable("sourceKey") String sourceKey) {
        try {
            System.out.println("🔄 [스프링] 사용자가 새로운 채널 전환 요청: " + sourceKey);
            
            // 1. 파이썬 서버에 현재 모드가 완전히 변경되었음을 리셋하는 신호 먼저 전송
            RestTemplate restTemplate = new RestTemplate();
            
            if ("esp32".equals(sourceKey)) {
                currentMode = "esp32";
                // 파이썬 Flask 서버의 esp32 모드 가동 상태 통지
                String flaskApiUrl = FLASK_ESP_URL + "/change_mode/esp32";
                restTemplate.getForObject(flaskApiUrl, String.class);
            } else {
                currentMode = "local";
                // 파이썬 Flask 서버의 동영상 소스 체인지 API 호출
                String flaskApiUrl = FLASK_SERVER_URL + "/change_source/" + sourceKey;
                restTemplate.getForObject(flaskApiUrl, String.class);
            }
        } catch (Exception e) {
            System.err.println("❌ [스프링] 파이썬 서버 연동 체인지 실패: " + e.getMessage());
        }
        return "OK"; 
    }

    @RequestMapping("/yolo/videoFeed")
    public void bridgeStream(HttpServletResponse response) { 
        String pythonServerUrl = "esp32".equals(currentMode) 
            ? FLASK_ESP_URL + "/video_feed" 
            : FLASK_SERVER_URL + "/video_feed"; 
            
        // readTimeout을 기존 60초에서 3초로 대폭 줄여 소스 변경 시 이전 빨대(스트림)가 즉시 툭 끊어지게 만듭니다.
        executeProxy(pythonServerUrl, response, 3000, 3000, false);
    }

    @RequestMapping(value = "/yolo/labels", produces = "application/json; charset=UTF-8")
    public void bridgeLabels(HttpServletResponse response) {
        String pythonJsonUrl = "esp32".equals(currentMode) 
            ? FLASK_ESP_URL + "/labels_feed" 
            : FLASK_SERVER_URL + "/labels_feed"; 
            
        executeProxy(pythonJsonUrl, response, 2000, 2000, true);
    }

    @RequestMapping(value = "/yolo/espLabels", produces = "application/json; charset=UTF-8")
    public void bridgeEspLabels(HttpServletResponse response) {
        String pythonJsonUrl = FLASK_ESP_URL + "/labels_feed"; 
        executeProxy(pythonJsonUrl, response, 2000, 2000, true);
    }

    private void executeProxy(String targetUrl, HttpServletResponse response, int connectTimeout, int readTimeout, boolean isJson) {
        HttpURLConnection connection = null;
        try {
            URL url = new URL(targetUrl);
            connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(connectTimeout);
            connection.setReadTimeout(readTimeout); // 👈 지연 방지 핵심 잠금 장치
            
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
                
                while ((bytesRead = is.read(buffer)) != -1) {
                    // 모드가 도중에 스위칭되면 즉시 현재 중계 루프를 강제로 탈출(Break)하여 스트림을 반환합니다.
                    if (!isJson && "esp32".equals(currentMode) && targetUrl.contains("/stream/")) break;
                    if (!isJson && "local".equals(currentMode) && targetUrl.contains("/esp32_yolov12/")) break;
                    
                    os.write(buffer, 0, bytesRead);
                    if (!isJson) os.flush(); 
                }
                os.flush();
            }
        } catch (Exception e) {
            // 스트림 단절 시 일어나는 정상적인 익셉션이므로 로그 생략
        } finally {
            if (connection != null) connection.disconnect(); 
        }
    }
}
