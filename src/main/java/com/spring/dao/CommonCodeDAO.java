package com.spring.dao;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;

public interface CommonCodeDAO {
    
    // 💡 Map을 PageMaker로 변경
    List<CommonCodeVO> selectCommonCodeList(PageMaker pageMaker) throws Exception;
    
    List<CommonCodeVO> getCodeListByGroup(String grpCode) throws Exception;
    
    // 💡 Map을 PageMaker로 변경
    int selectCommonCodeCount(PageMaker pageMaker) throws Exception;
    
    // ... 이하 기존 메서드들 동일
    CommonCodeVO selectCommonCodeDetail(String grpCode, String code) throws Exception;
    int insertCommonCode(CommonCodeVO ccVo) throws Exception;
    int updateCommonCode(CommonCodeVO ccVo) throws Exception;
    int deleteCommonCode(String grpCode, String code) throws Exception;
}
