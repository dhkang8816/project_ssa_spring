package com.spring.service;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.MemberVO;

public interface MemberService {
	// 1. 회원가입
    void regist(MemberVO member) throws Exception;
    
    // 2. 단건 회원 조회 (로그인 인증 및 상세 조회용)
    MemberVO getMemberById(String memberId) throws Exception;
    
    // 💡 3. 전체 직원 목록 조회 추가
    List<MemberVO> getMemberList(PageMaker pageMaker) throws Exception;
    
    int getMemberListCount(PageMaker pageMaker) throws Exception;

    List<MemberVO> getAdminMembers() throws Exception;

    boolean isAdminMember(String memberId) throws Exception;
    
    // 4. 로그인 성공 후처리 (실패 카운트 리셋, 마지막 로그인 일시 갱신)
    void loginSuccess(String memberId, String ip) throws Exception;
    
    // 5. 로그인 실패 후처리 (실패 카운트 증가)
    void loginFailure(String memberId, String ip) throws Exception;
    
    int modifyMember(MemberVO member) throws Exception;
}
