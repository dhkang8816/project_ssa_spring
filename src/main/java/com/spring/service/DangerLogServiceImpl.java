package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.DangerLogDAO;
import com.spring.dto.DangerLogVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DangerLogServiceImpl implements DangerLogService {

    private final DangerLogDAO dangerLogDAO;

    @Override
    @Transactional
    public void registerDangerLog(DangerLogVO dlv) {
        // [CREATE] 관제 탐지 로그 등록
        dangerLogDAO.insertDangerLog(dlv);
    }

    @Override
    public List<DangerLogVO> getDangerLogList(PageMaker pageMaker) {
        // [READ] 1. 전체 로그 건수를 조회하여 PageMaker에 세팅 (내부 calcData() 자동 실행)
        int totalCount = dangerLogDAO.selectDangerLogCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        
        // [READ] 2. 페이징 범위 및 다조건 검색에 맞는 목록 반환
        return dangerLogDAO.selectDangerLogList(pageMaker);
    }

    @Override
    public DangerLogVO getDangerLogById(int danlogId) {
        // [READ] 단건 상세 조회
        return dangerLogDAO.selectDangerLogById(danlogId);
    }

    @Override
    @Transactional
    public void modifyDactionStatus(DangerLogVO dlv) {
        // [UPDATE] 현장 조치 상태 및 내용 업데이트
        dangerLogDAO.updateDactionStatus(dlv);
    }
}
