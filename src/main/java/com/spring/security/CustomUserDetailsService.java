package com.spring.security;

import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.spring.dao.MemberDAO;
import com.spring.dto.MemberVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberDAO memberDAO;

    @Override
    public UserDetails loadUserByUsername(String memberId) throws UsernameNotFoundException {
        MemberVO member = null;
        try {
            // DAO 호출 시 발생하는 체크 예외를 잡아서 런타임 예외로 감싸줍니다.
            member = memberDAO.selectMemberById(memberId);
        } catch (Exception e) {
            throw new RuntimeException("회원 조회 중 DB 에러가 발생했습니다: " + e.getMessage(), e);
        }
        
        if (member == null) {
            throw new UsernameNotFoundException("해당 사번을 찾을 수 없습니다: " + memberId);
        }

        return new CustomUser(member);
    }
}