package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.DetectionLogDAO;
import com.spring.dto.DetectionLogVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DetectionLogServiceImpl implements DetectionLogService {

    private final DetectionLogDAO detectionLogDAO;

    @Override
    @Transactional
    public void registerDetectionLog(DetectionLogVO dlv) {
        // [CREATE] 관제 탐지 로그 등록
        detectionLogDAO.insertDetectionLog(dlv);
    }

    @Override
    public List<DetectionLogVO> getDetectionLogList(PageMaker pageMaker) {
        // [READ] 1. 전체 로그 건수를 조회하여 PageMaker에 세팅 (내부 calcData() 자동 실행)
        int totalCount = detectionLogDAO.selectDetectionLogCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        
        // [READ] 2. 페이징 범위 및 다조건 검색에 맞는 목록 반환
        return detectionLogDAO.selectDetectionLogList(pageMaker);
    }

    @Override
    public DetectionLogVO getDetectionLogById(int dlogId) {
        // [READ] 단건 상세 조회
        return detectionLogDAO.selectDetectionLogById(dlogId);
    }

    @Override
    @Transactional
    public void modifyActionStatus(DetectionLogVO dlv) {
        // [UPDATE] 현장 조치 상태 및 내용 업데이트
        detectionLogDAO.updateActionStatus(dlv);
    }
}
