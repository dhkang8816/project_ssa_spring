package com.spring.service;

import java.util.List; // 💡 List 임포트 추가

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.MemberDAO;
import com.spring.dto.MemberRoleVO;
import com.spring.dto.MemberVO;

import lombok.AllArgsConstructor;

@AllArgsConstructor
@Service("memberService")
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberDAO memberDAO;

    @Autowired
    @Qualifier("encoder")
    private PasswordEncoder passwordEncoder;

    // 회원가입
    @Transactional
    @Override
    public void regist(MemberVO member) throws Exception {
        // 1. 비밀번호 암호화
        String encodedPwd = passwordEncoder.encode(member.getPassword());
        member.setPassword(encodedPwd);

        // 2. 사진 미선택 시 기본값 세팅
        if (member.getPicture() == null || member.getPicture().trim().isEmpty()) {
            member.setPicture("noImage.jpg");
        }

        // 3. 회원 정보 저장
        memberDAO.insertMember(member);

        // 4. 기본 권한 등록 (초기 승인 대기 권한 ROLE_GUEST)
        MemberRoleVO role = MemberRoleVO.builder()
                .memberId(member.getMemberId())
                .roleCode(member.getRole() != null ? member.getRole() : "ROLE_GUEST")
                .build();

        memberDAO.insertMemberRole(role);
    }

    // 로그인 인증용 회원 데이터 조회 및 상세 조회용
    @Override
    public MemberVO getMemberById(String memberId) throws Exception {
        return memberDAO.selectMemberById(memberId);
    }

    // 💡 전체 직원 목록 조회 구현 추가
    @Override
    public List<MemberVO> getMemberList(PageMaker pageMaker) throws Exception {
        return memberDAO.selectMemberList(pageMaker);
    }
    
    @Override
    public int getMemberListCount(PageMaker pageMaker) throws Exception {
        return memberDAO.selectMemberListCount(pageMaker);
    }
    
    // 로그인 성공 후처리
    @Transactional
    @Override
    public void loginSuccess(String memberId, String ip) throws Exception {
        memberDAO.resetFailCount(memberId);
        memberDAO.updateLastLogDate(memberId);
        memberDAO.insertMemberLog(memberId, ip, "SUCCESS"); // 이력 적재
    }

    // 로그인 실패 후처리
    @Transactional
    @Override
    public void loginFailure(String memberId, String ip) throws Exception {
        // 1. 기존에 있는 실패 횟수 증가 쿼리 실행
        memberDAO.incrementFailCount(memberId);
        
        // 2. 현재 회원의 실패 횟수 조회
        MemberVO member = memberDAO.selectMemberById(memberId);
        if (member != null && member.getFailCount() >= 5) {
            // 3. 실패 횟수가 5회 이상이면 계정 상태를 정지('1')로 변경
            member.setStatus("1"); // '1'은 정지 상태 코드
            memberDAO.updateMemberStatus(member); // 또는 상태만 변경하는 전용 쿼리 실행
        }
        
        // 4. 로그인 실패 이력 적재
        memberDAO.insertMemberLog(memberId, ip, "FAIL");
    }
    
    
    @Transactional
    @Override
    public int modifyMember(MemberVO memberVO) throws Exception{
        return memberDAO.updateMember(memberVO);
    }
}