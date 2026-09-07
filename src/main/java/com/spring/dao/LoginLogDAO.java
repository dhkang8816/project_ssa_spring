package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.LoginLogVO;

public interface LoginLogDAO {

    // 1. 로그인 이력 페이징 목록 조회
    List<LoginLogVO> selectLoginLogList(PageMaker pageMaker) throws Exception;

    // 2. 로그인 이력 전체 개수 조회
    int selectLoginLogListCount(PageMaker pageMaker) throws Exception;
}
