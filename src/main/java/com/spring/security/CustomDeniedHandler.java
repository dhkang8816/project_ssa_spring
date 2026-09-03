package com.spring.security;

import java.io.IOException;

// 💡 Tomcat 10 이상이므로 jakarta 패키지를 사용합니다.
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.access.AccessDeniedHandler;

public class CustomDeniedHandler implements AccessDeniedHandler {

    @Override
    public void handle(HttpServletRequest request, HttpServletResponse response,
            AccessDeniedException accessDeniedException) throws IOException, ServletException {

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();

        if (auth != null) {
            // 💡 사용자가 미승인 권한(ROLE_GUEST)인 경우 대기 안내 페이지로 이동
            boolean isGuest = auth.getAuthorities().stream()
                    .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_GUEST"));

            if (isGuest) {
                response.sendRedirect(request.getContextPath() + "/guest/waiting");
                return;
            }
        }

        // 일반적인 권한 부족(403) 상황일 경우 공통 Access Denied 페이지로 이동
        response.sendRedirect(request.getContextPath() + "/accessDenied");
    }
}