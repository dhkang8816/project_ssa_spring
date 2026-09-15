package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.cmd.PageMaker;
import com.spring.dao.PatrolReportDAO;
import com.spring.dao.MemberDAO;
import com.spring.dao.WorkFlowDAO;
import com.spring.dto.PatrolReportVO;
import com.spring.dto.WorkFlowVO;

import org.springframework.transaction.annotation.Transactional;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class PatrolReportServiceImpl implements PatrolReportService {
    private final PatrolReportDAO patrolReportDAO;
    private final WorkFlowDAO workFlowDAO;
    private final MemberDAO memberDAO;

    @Override
    public void insertReport(PatrolReportVO reportVO) throws Exception {
        patrolReportDAO.insertReport(reportVO);
    }

    @Transactional
    @Override
    public void insertReportWithWorkflow(PatrolReportVO reportVO, String approverId) throws Exception {
        if (approverId == null || approverId.trim().isEmpty() || !memberDAO.isAdminMember(approverId)) {
            throw new IllegalArgumentException("A valid administrator approver is required.");
        }
        patrolReportDAO.insertReport(reportVO);
        workFlowDAO.insertWorkFlow(WorkFlowVO.builder()
                .reportId(reportVO.getReportId())
                .drafterId(reportVO.getMemberId())
                .approverId(approverId)
                .build());
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

    @Transactional
    @Override
    public void deleteReport(int reportId) throws Exception {
        patrolReportDAO.deletePdfCachesByReportId(reportId);
        workFlowDAO.deleteWorkFlowsByReportId(reportId);
        if (patrolReportDAO.deleteReport(reportId) != 1) {
            throw new IllegalArgumentException("The patrol report does not exist or was already deleted.");
        }
    }
    
    @Override
    public List<PatrolReportVO> getReportListWithPaging(PageMaker pageMaker) throws Exception {
        int totalCount = patrolReportDAO.getReportTotalCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return patrolReportDAO.getReportListWithPaging(pageMaker);
    }

    @Override
    public List<PatrolReportVO> getPendingReportListWithPaging(PageMaker pageMaker) throws Exception {
        pageMaker.setTotalCount(patrolReportDAO.getPendingReportTotalCount(pageMaker));
        return patrolReportDAO.getPendingReportListWithPaging(pageMaker);
    }
}
