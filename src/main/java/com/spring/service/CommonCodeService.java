package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;

public interface CommonCodeService {
    
    // 공통코드 목록 조회 (검색 및 페이징 파라미터 포함)
    List<CommonCodeVO> getCommonCodeList(PageMaker pageMaker) throws Exception;
    
    // 공통코드 전체 개수 조회
    int getCommonCodeCount(PageMaker pageMaker) throws Exception;
    
    List<CommonCodeVO> getCodeListByGroup(String grpCode) throws Exception;
    
    // 공통코드 상세 조회
    CommonCodeVO getCommonCodeDetail(String grpCode, String code) throws Exception;
    
    // 공통코드 등록
    void registerCommonCode(CommonCodeVO ccVo) throws Exception;
    
    // 공통코드 수정
    void modifyCommonCode(CommonCodeVO ccVo) throws Exception;
    
    // 공통코드 삭제
    void removeCommonCode(String grpCode, String code) throws Exception;
}