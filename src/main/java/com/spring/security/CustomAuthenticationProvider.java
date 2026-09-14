package com.spring.security;

import java.util.ArrayList;
import java.util.List;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import com.spring.dao.MemberDAO;
import com.spring.dto.MemberRoleVO;
import com.spring.dto.MemberVO;

public class CustomAuthenticationProvider implements AuthenticationProvider {

	private final MemberDAO memberDAO;
	private final BCryptPasswordEncoder encoder;

	public CustomAuthenticationProvider(MemberDAO memberDAO, BCryptPasswordEncoder encoder) {
		this.memberDAO = memberDAO;
		this.encoder = encoder;
	}

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		String memberId = authentication.getName();
		String password = (String) authentication.getCredentials();

		try {
			MemberVO member = memberDAO.selectMemberById(memberId);
			if (member == null) {
				throw new BadCredentialsException("존재하지 않는 사번입니다.");
			}

			if (!encoder.matches(password, member.getPassword())) {
				throw new BadCredentialsException("비밀번호가 일치하지 않습니다.");
			}

			List<MemberRoleVO> roleList = memberDAO.selectMemberRoles(memberId);

			List<GrantedAuthority> authorities = new ArrayList<>();
			
			if (roleList != null && !roleList.isEmpty()) {
				for (MemberRoleVO roleVo : roleList) {
					// 💡 roleVo나 roleCode가 null인 경우를 방어하기 위한 안전장치
					if (roleVo != null && roleVo.getRoleCode() != null) {
						authorities.add(new SimpleGrantedAuthority(roleVo.getRoleCode()));
					}
				}
			} 
			
			// 만약 유효한 권한이 하나도 안 담겼다면 기본 권한 부여
			if (authorities.isEmpty()) {
				authorities.add(new SimpleGrantedAuthority("ROLE_GUEST"));
			}

			return new UsernamePasswordAuthenticationToken(new CustomUser(member), password, authorities);

		} catch (Exception e) {
			e.printStackTrace();

			if (e instanceof BadCredentialsException) {
				throw (BadCredentialsException) e;
			}
			throw new BadCredentialsException("로그인 처리 중 오류가 발생했습니다: " + e.getMessage());
		}
	}

	@Override
	public boolean supports(Class<?> authentication) {
		return UsernamePasswordAuthenticationToken.class.isAssignableFrom(authentication);
	}
}
