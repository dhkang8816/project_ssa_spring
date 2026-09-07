package com.spring.service;

import java.util.List;

import com.spring.dto.PatrolReportVO;

public interface PatrolReportService {

    // 1. 등록
    void insertReport(PatrolReportVO reportVO) throws Exception;

    // 2. 단건 상세 조회
    PatrolReportVO getReportById(int reportId) throws Exception;

    // 3. 전체 목록 조회
    List<PatrolReportVO> getReportList() throws Exception;

    // 4. 수정
    void updateReport(PatrolReportVO reportVO) throws Exception;

    // 5. 삭제
    void deleteReport(int reportId) throws Exception;
}
