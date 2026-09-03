package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.FlightHistoryVO;

public interface FlightHistoryDAO {

    // 1. 등록 (fhv 수칙 반영)
    public int insertFlightHistory(FlightHistoryVO fhv);
    
    // 2. 다조건 페이징 목록 조회
    public List<FlightHistoryVO> selectFlightHistoryList(PageMaker pageMaker);
    
    // 3. 전체 행 카운트
    public int selectFlightHistoryCount(PageMaker pageMaker);
    
    // 4. 단건 상세 조회
    public FlightHistoryVO selectFlightHistoryById(int flightId);
    
    // 5. 삭제
    public int deleteFlightHistory(int flightId);
}
