package com.spring.service;

import java.util.List;
import java.util.Map;

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
        if (detectionLogDAO.insertDetectionLog(dlv) != 1) {
            throw new IllegalStateException("Detection log was not inserted.");
        }
    }

    @Override
    public List<DetectionLogVO> getDetectionLogList(PageMaker pageMaker) {
        int totalCount = detectionLogDAO.selectDetectionLogCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return detectionLogDAO.selectDetectionLogList(pageMaker);
    }

    @Override
    public DetectionLogVO getDetectionLogById(int dlogId) {
        return detectionLogDAO.selectDetectionLogById(dlogId);
    }

    @Override
    @Transactional
    public void modifyActionStatus(DetectionLogVO dlv) {
        detectionLogDAO.updateActionStatus(dlv);
    }
    
    @Override
    public Map<String, Object> getTodayDetectionStats() throws Exception {
        return detectionLogDAO.selectTodayDetectionStats();
    }
}
