package com.spring.service;

import java.net.URI;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.spring.dto.EnvironmentVO;
import com.spring.util.RuntimeSettings;

/** Kakao Local REST API를 EnvironmentVO 검색 결과로 변환한다. */
public class GeocodingServiceImpl implements GeocodingService {

    private static final String KAKAO_LOCAL_URL =
            "https://dapi.kakao.com/v2/local/search/keyword.json";
    private static final int SEARCH_RESULT_SIZE = 10;

    private final RestTemplate restTemplate;

    public GeocodingServiceImpl() {
        this.restTemplate = new RestTemplate();
    }

    @Override
    @SuppressWarnings("unchecked")
    public List<EnvironmentVO> searchLocation(String keyword) throws Exception {
        List<EnvironmentVO> resultList = new ArrayList<>();
        if (keyword == null || keyword.trim().isEmpty()) {
            return resultList;
        }

        String apiKey = RuntimeSettings.kakaoRestApiKey();
        if (apiKey.isEmpty()) {
            throw new IllegalStateException("KAKAO_REST_API_KEY가 설정되지 않았습니다.");
        }

        URI uri = UriComponentsBuilder
                .fromUriString(KAKAO_LOCAL_URL)
                .queryParam("query", keyword.trim())
                .queryParam("size", SEARCH_RESULT_SIZE)
                .build()
                .encode()
                .toUri();

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "KakaoAK " + apiKey);
        HttpEntity<Void> request = new HttpEntity<>(headers);
        ResponseEntity<Map<String, Object>> response =
                restTemplate.exchange(
                        uri,
                        HttpMethod.GET,
                        request,
                        new ParameterizedTypeReference<Map<String, Object>>() {
                        }
                );
        Map<String, Object> body = response.getBody();
        if (body == null) {
            return resultList;
        }

        for (Object document : (List<?>) body.get("documents")) {
            if (!(document instanceof Map)) {
                continue;
            }
            Map<String, Object> item = (Map<String, Object>) document;
            Double longitude = parseCoordinate(item.get("x"));
            Double latitude = parseCoordinate(item.get("y"));
            if (longitude == null || latitude == null) {
                continue;
            }

            String placeName = getString(item.get("place_name"));
            String address = firstNonBlank(
                    getString(item.get("road_address_name")),
                    getString(item.get("address_name")),
                    placeName);

            EnvironmentVO environment = new EnvironmentVO();
            environment.setLocationName(firstNonBlank(placeName, address));
            environment.setAddress(address);
            environment.setLatitude(latitude);       // Kakao y: latitude
            environment.setLongitude(longitude);     // Kakao x: longitude
            environment.setTimezone("Asia/Seoul");
            resultList.add(environment);
        }
        
        return resultList;
    }

    private Double parseCoordinate(Object value) {
        String text = getString(value);
        if (text == null || text.trim().isEmpty()) {
            return null;
        }
        try {
            return Double.parseDouble(text.trim());
        } catch (NumberFormatException ignored) {
            return null;
        }
    }

    private String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return "";
    }

    private String getString(Object value) {
        return value == null ? null : String.valueOf(value);
    }
    
    
}
