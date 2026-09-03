package com.spring.security;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;

import com.spring.service.MemberService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class LoginFailureHandler implements AuthenticationFailureHandler {

	@Autowired
	private MemberService memberService;

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {

		String memberId = request.getParameter("memberId"); // form의 username 파라미터명

		// 💡 [1] 프록시/로드밸런서 환경을 고려한 IP 추출
		String ip = request.getHeader("X-Forwarded-For");
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getHeader("WL-Proxy-Client-IP");
		}
		if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			ip = request.getRemoteAddr();
		}

		// 💡 [2] 아이디 입력값이 존재하는 경우 실패 카운트 증가 및 FAIL 로그 적재
		if (memberId != null && !memberId.trim().isEmpty()) {
			try {
				memberService.loginFailure(memberId, ip);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		// 에러 메시지 전달 및 로그인 페이지 이동
		request.getSession().setAttribute("ERROR_MSG", exception.getMessage());
		response.sendRedirect(request.getContextPath() + "/login?error=true");
	}
}
