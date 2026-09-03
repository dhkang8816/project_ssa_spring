package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;

public interface AlertLogService {

    // 1. 페이징 및 검색 조건이 반영된 경보 이력 목록 조회 (PageMaker 연산 포함)
    public List<AlertLogVO> getAlertLogList(PageMaker pageMaker) throws Exception;

    // 2. 단건 경보 이력 상세 조회
    public AlertLogVO getAlertLogDetail(int alertId) throws Exception;

    // 3. 신규 경보 이력 등록 (필요 시 공통 로그 기록 비즈니스 로직 연계)
    public void registerAlertLog(AlertLogVO vo) throws Exception;
}
