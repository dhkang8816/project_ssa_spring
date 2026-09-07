package com.spring.dao;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.PatrolReportVO;

public interface PatrolReportDAO {
    int insertReport(PatrolReportVO reportVO);
    PatrolReportVO getReportById(int reportId);
    List<PatrolReportVO> getReportList();
    int getReportListCount(PageMaker pageMaker);
    int updateReport(PatrolReportVO reportVO);
    int deleteReport(int reportId);
}
