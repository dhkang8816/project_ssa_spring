package com.spring.dao;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.MemberRoleVO; // 권한VO 임포트
import com.spring.dto.MemberVO;

public interface MemberDAO {

	// 1. ⚠️ 사번은 PK이므로 시큐리티 검증을 위해 반드시 단건 객체로 받아야 합니다.
	MemberVO selectMemberById(String memberId) throws Exception;

	// 💡 전체 직원 목록 조회 추가
	List<MemberVO> selectMemberList(PageMaker pageMaker) throws Exception;
	
	int selectMemberListCount(PageMaker pageMaker) throws Exception;

	// 2. 로그인 실패 횟수 1 증가 연산
	void incrementFailCount(String memberId) throws Exception;

	// 3. 로그인 성공 시 실패 횟수 초기화(0) 연산
	void resetFailCount(String memberId) throws Exception;

	// 4. 로그인 성공 시 마지막 로그인 일시 업데이트
	void updateLastLogDate(String memberId) throws Exception;

	// 5. ⭕ 한 직원이 여러 권한을 가질 수 있으므로 List 구조가 완벽히 맞습니다.
	List<MemberRoleVO> selectMemberRoles(String memberId) throws Exception;

	// 6. 회원 정보 등록
	void insertMember(MemberVO member) throws Exception;

	// 7. 회원 권한 등록
	void insertMemberRole(MemberRoleVO memberRole) throws Exception;

	// 로그인 이력 적재
	void insertMemberLog(String memberId, String loginIp, String loginStatus) throws Exception;

	int updateMember(MemberVO member) throws Exception;
	
	// 실패 5회시 상태 변경용
    int updateMemberStatus(MemberVO member) throws Exception;
}
