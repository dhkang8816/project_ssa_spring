package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.FlightHistoryVO;

public interface FlightHistoryService {

    // 1. 비행 이력 등록 (fhv 명명 규칙 반영)
    public int registerFlightHistory(FlightHistoryVO fhv);
    
    // 2. 페이징 및 다조건 검색 처리된 목록 조회 (PageMaker 세팅 포함)
    public List<FlightHistoryVO> getFlightHistoryList(PageMaker pageMaker);
    
    // 3. 단건 상세 조회
    public FlightHistoryVO getFlightHistoryById(int flightId);
    
    // 4. 비행 이력 삭제
    public void removeFlightHistory(int flightId);
}
