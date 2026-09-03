package com.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CommonController {

	// 1. 루트 경로 접속 시 기본 화면(또나 로그인)으로 이동
	public String index() {
		return "redirect:/login";
	}

	// 2. 로그인 페이지 이동
	@GetMapping("/login")
	public String loginForm(@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "logout", required = false) String logout, Model model) {

		if (error != null) {
			model.addAttribute("msg", "사번 또는 비밀번호가 올바르지 않습니다.");
		}
		if (logout != null) {
			model.addAttribute("msg", "정상적으로 로그아웃되었습니다.");
		}

		return "common/login"; // WEB-INF/views/common/login.jsp
	}

	// 3. 권한 부족(403 Access Denied) 예외 페이지
	@GetMapping("/accessDenied")
	public String accessDenied() {
		return "common/accessDenied"; // WEB-INF/views/common/accessDenied.jsp
	}

	// 4. 승인 대기(ROLE_GUEST) 전용 대기 안내 페이지 (security-context에 있던 경로)
	@GetMapping("/guest/waiting")
	public String guestWaiting() {
		return "common/waiting"; // WEB-INF/views/common/waiting.jsp
	}
}