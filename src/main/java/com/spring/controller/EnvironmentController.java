package com.spring.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.dto.EnvironmentVO;
import com.spring.dto.WeatherStatusVO;
import com.spring.service.EnvironmentService;
import com.spring.service.GeocodingService;
import com.spring.service.WeatherApiService;
import com.spring.service.SpaceWeatherService;
import lombok.AllArgsConstructor;

@Controller
@RequestMapping("/yolo/environment")
@AllArgsConstructor
public class EnvironmentController {

    private EnvironmentService environmentService;
    private GeocodingService geocodingService;
    private WeatherApiService weatherApiService;
    private SpaceWeatherService spaceWeatherService;
    
    @GetMapping("/location")
    @ResponseBody
    public ResponseEntity<?> getEnvironment() {

        try {

            EnvironmentVO environment =
                    environmentService.getEnvironment();

            if (environment == null) {

                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("environment", null);

                return ResponseEntity.ok(result);
            }

            return ResponseEntity.ok(environment);

        } catch (SQLException e) {

            e.printStackTrace();

            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "관제지역 조회 중 오류가 발생했습니다.");

            return ResponseEntity.status(
                    HttpStatus.INTERNAL_SERVER_ERROR
            ).body(result);
        }
    }

    /** 활성 관제지역 좌표로 Open-Meteo 현재 날씨 및 일사량을 조회한다. */
    @GetMapping("/weather")
    @ResponseBody
    public ResponseEntity<?> getCurrentWeather() {

        Map<String, Object> result = new HashMap<>();

        try {
            EnvironmentVO environment = environmentService.getEnvironment();
            if (environment == null
                    || environment.getLatitude() == null
                    || environment.getLongitude() == null) {
                result.put("success", false);
                result.put("message", "관제지역이 설정되지 않았습니다.");
                return ResponseEntity.ok(result);
            }

            WeatherStatusVO weather = weatherApiService.getCurrentWeather(
                    environment.getLatitude(),
                    environment.getLongitude(),
                    environment.getTimezone());
            return ResponseEntity.ok(weather);

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "기상정보를 불러오지 못했습니다.");
            return ResponseEntity.ok(result);
        }
    }

    @GetMapping("/location/list")
    @ResponseBody
    public ResponseEntity<?> getEnvironmentList() {

        try {

            List<EnvironmentVO> list =
                    environmentService.getEnvironmentList();

            return ResponseEntity.ok(list);

        } catch (SQLException e) {

            e.printStackTrace();

            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "관제지역 목록 조회 중 오류가 발생했습니다.");

            return ResponseEntity.status(
                    HttpStatus.INTERNAL_SERVER_ERROR
            ).body(result);
        }
    }

    @PostMapping("/location")
    @ResponseBody
    public ResponseEntity<?> registEnvironment(
            @RequestBody EnvironmentVO environment) {

        Map<String, Object> result = new HashMap<>();

        try {

            if (environment == null
                    || environment.getLocationName() == null
                    || environment.getLatitude() == null
                    || environment.getLongitude() == null) {

                result.put("success", false);
                result.put("message", "관제지역 정보가 올바르지 않습니다.");

                return ResponseEntity
                        .badRequest()
                        .body(result);
            }


            if (environment.getTimezone() == null
                    || environment.getTimezone().trim().isEmpty()) {

                environment.setTimezone("Asia/Seoul");
            }


            environmentService.registEnvironment(environment);

            result.put("success", true);
            result.put("message", "관제지역이 설정되었습니다.");

            return ResponseEntity.ok(result);

        } catch (SQLException e) {

            e.printStackTrace();

            result.put("success", false);
            result.put("message", "관제지역 저장 중 오류가 발생했습니다.");

            return ResponseEntity.status(
                    HttpStatus.INTERNAL_SERVER_ERROR
            ).body(result);
        }
    }

    @PutMapping("/location/{environmentId}")
    @ResponseBody
    public ResponseEntity<?> modifyEnvironment(
            @PathVariable int environmentId,
            @RequestBody EnvironmentVO environment) {

        Map<String, Object> result = new HashMap<>();

        try {

            if (environment == null) {

                result.put("success", false);
                result.put("message", "수정할 관제지역 정보가 없습니다.");

                return ResponseEntity
                        .badRequest()
                        .body(result);
            }

            environment.setEnvironmentId(environmentId);

            if (environment.getTimezone() == null
                    || environment.getTimezone().trim().isEmpty()) {

                environment.setTimezone("Asia/Seoul");
            }

            environmentService.modifyEnvironment(environment);

            result.put("success", true);
            result.put("message", "관제지역 정보가 수정되었습니다.");

            return ResponseEntity.ok(result);

        } catch (SQLException e) {

            e.printStackTrace();

            result.put("success", false);
            result.put("message", "관제지역 수정 중 오류가 발생했습니다.");

            return ResponseEntity.status(
                    HttpStatus.INTERNAL_SERVER_ERROR
            ).body(result);
        }
    }

    @PatchMapping("/location/{environmentId}/activate")
    @ResponseBody
    public ResponseEntity<?> activateEnvironment(
            @PathVariable int environmentId) {

        Map<String, Object> result = new HashMap<>();

        try {

            environmentService.activateEnvironment(environmentId);

            result.put("success", true);
            result.put("message", "관제지역이 변경되었습니다.");

            return ResponseEntity.ok(result);

        } catch (SQLException e) {

            e.printStackTrace();

            result.put("success", false);
            result.put("message", "관제지역 변경 중 오류가 발생했습니다.");

            return ResponseEntity.status(
                    HttpStatus.INTERNAL_SERVER_ERROR
            ).body(result);
        }
    }

    @DeleteMapping("/location/{environmentId}")
    @ResponseBody
    public ResponseEntity<?> removeEnvironment(
            @PathVariable int environmentId) {

        Map<String, Object> result = new HashMap<>();

        try {

            environmentService.removeEnvironment(environmentId);

            result.put("success", true);
            result.put("message", "관제지역이 삭제되었습니다.");

            return ResponseEntity.ok(result);

        } catch (SQLException e) {

            e.printStackTrace();

            result.put("success", false);
            result.put("message", "관제지역 삭제 중 오류가 발생했습니다.");

            return ResponseEntity.status(
                    HttpStatus.INTERNAL_SERVER_ERROR
            ).body(result);
        }
    }
    
    @GetMapping("/location/search")
    @ResponseBody
    public ResponseEntity<?> searchLocation(
            @RequestParam String keyword) {

        try {

            return ResponseEntity.ok(
                    geocodingService.searchLocation(keyword)
            );

        } catch (Exception e) {

            e.printStackTrace();

            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "지역 검색 중 오류가 발생했습니다.");

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(result);
        }
    }
    @GetMapping("/space-weather")
    @ResponseBody
    public ResponseEntity<?> getSpaceWeather() {

        try {

            return ResponseEntity.ok(
                    spaceWeatherService.getCurrentSpaceWeather()
            );

        } catch (Exception e) {

            e.printStackTrace();

            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "우주환경 정보를 불러오지 못했습니다.");

            return ResponseEntity
                    .status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(result);
        }
    }
}
