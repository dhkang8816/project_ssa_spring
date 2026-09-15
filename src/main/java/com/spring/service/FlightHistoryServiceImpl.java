package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.FlightHistoryDAO;
import com.spring.dto.FlightHistoryVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class FlightHistoryServiceImpl implements FlightHistoryService {

    private final FlightHistoryDAO flightHistoryDAO;

    @Override
    @Transactional
    public int registerFlightHistory(FlightHistoryVO fhv) {
        // [CREATE] 비행 이력 등록
        return flightHistoryDAO.insertFlightHistory(fhv);
    }

    @Override
    public List<FlightHistoryVO> getFlightHistoryList(PageMaker pageMaker) {
        // [READ] 1. 전체 비행 이력 건수를 조회하여 PageMaker에 세팅 (내부 calcData() 자동 실행)
        int totalCount = flightHistoryDAO.selectFlightHistoryCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        
        // [READ] 2. 페이징 범위 및 다조건 검색에 맞는 목록 반환
        return flightHistoryDAO.selectFlightHistoryList(pageMaker);
    }

    @Override
    public FlightHistoryVO getFlightHistoryById(int flightId) {
        // [READ] 단건 상세 조회
        return flightHistoryDAO.selectFlightHistoryById(flightId);
    }

    @Override
    @Transactional
    public void removeFlightHistory(int flightId) {
        // [DELETE] 비행 이력 삭제
        flightHistoryDAO.deleteFlightHistory(flightId);
    }
}
