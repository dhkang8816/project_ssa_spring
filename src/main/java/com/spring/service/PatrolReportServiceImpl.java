package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.dao.PatrolReportDAO;
import com.spring.dto.PatrolReportVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class PatrolReportServiceImpl implements PatrolReportService {

    // 💡 생성자 주입을 위해 final 선언
    private final PatrolReportDAO patrolReportDAO;

    @Override
    public void insertReport(PatrolReportVO reportVO) throws Exception {
        patrolReportDAO.insertReport(reportVO);
    }

    @Override
    public PatrolReportVO getReportById(int reportId) throws Exception {
        return patrolReportDAO.getReportById(reportId);
    }

    @Override
    public List<PatrolReportVO> getReportList() throws Exception {
        return patrolReportDAO.getReportList();
    }

    @Override
    public void updateReport(PatrolReportVO reportVO) throws Exception {
        patrolReportDAO.updateReport(reportVO);
    }

    @Override
    public void deleteReport(int reportId) throws Exception {
        patrolReportDAO.deleteReport(reportId);
    }
}
