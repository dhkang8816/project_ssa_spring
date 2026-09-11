package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.spring.cmd.PageMaker;
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
    
    @Override
    public List<PatrolReportVO> getReportListWithPaging(PageMaker pageMaker) throws Exception {
        // 1. 오라클 DB에서 현재 리포트 테이블의 전체 행 개수를 세어옵니다.
        int totalCount = patrolReportDAO.getReportTotalCount(pageMaker);
        
        // 2. 중요! 가져온 총 개수를 PageMaker에 주입하여 내부 calcData() 수식(startPage, endPage 등)을 강제 작동시킵니다.
        pageMaker.setTotalCount(totalCount);
        
        // 3. 계산 완료된 startRow, endRow 범위를 들고 매퍼로 가서 딱 10건(perPageNum)의 리스트만 수신하여 반환합니다.
        return patrolReportDAO.getReportListWithPaging(pageMaker);
    }
}
