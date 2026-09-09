package com.spring.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.spring.security.CustomUser;
import com.spring.dto.MemberVO;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class UserApiController {

    @GetMapping("/user/me")
    public ResponseEntity<Map<String, Object>> getCurrentUser() {
        Map<String, Object> response = new HashMap<>();
        
        // 1. 스프링 시큐리티 전역 컨텍스트에서 인증 정보 안전하게 획득
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        // 2. 비로그인 상태(인증 없음, 익명 사용자)인 경우 예외 처리
        if (authentication == null || !authentication.isAuthenticated() 
                || "anonymousUser".equals(authentication.getPrincipal())) {
            response.put("isLoggedIn", false);
            return ResponseEntity.ok(response);
        }
        
        // 3. 로그인 성공 상태인 경우 정보 추출
        try {
            // Principal 객체를 프로젝트의 CustomUser 클래스로 캐스팅
            CustomUser customUser = (CustomUser) authentication.getPrincipal();
            
            // CustomUser 내부의 롬복 @Getter로 생성된 getMember() 메서드 호출
            MemberVO memberVO = customUser.getMember(); 
            
            response.put("isLoggedIn", true);
            response.put("memberId", memberVO.getMemberId());   // 사번
            response.put("name", memberVO.getName());           // 이름
            response.put("picture", memberVO.getPicture());     // 사진 파일명
            
        } catch (ClassCastException e) {
            // 형변환 예외 방어를 위한 안전 장치
            response.put("isLoggedIn", false);
        }
        
        return ResponseEntity.ok(response);
    }
    
    // 메인 페이지 이동 컨트롤러 메서드 내부
    @GetMapping("/main") // 메인 주소에 맞게 변경하세요
    public String mainPage() {
        // 현재 로그인된 인증 정보 가져오기
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        
        // 콘솔에 로그인된 사용자 이름(사번) 출력
        System.out.println("====== 로그인 상태 확인 ======");
        System.out.println("현재 로그인된 사용자: " + auth.getName());
        System.out.println("권한 목록: " + auth.getAuthorities());
        System.out.println("============================");
        
        return "main"; 
    }

}
