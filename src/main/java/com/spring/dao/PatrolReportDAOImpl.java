package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.PatrolReportVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class PatrolReportDAOImpl implements PatrolReportDAO {

    // 💡 네임스페이스가 문자열일 때 데이터베이스를 직접 호출하기 위한 SqlSession 주입
    private final SqlSession sqlSession;
    
    // 매퍼 XML에 정의한 namespace 정의
    private static final String NAMESPACE = "PatrolReport-Mapper.";

    @Override
    public int insertReport(PatrolReportVO reportVO) {
        return sqlSession.insert(NAMESPACE + "insertReport", reportVO);
    }

    @Override
    public PatrolReportVO getReportById(int reportId) {
        return sqlSession.selectOne(NAMESPACE + "getReportById", reportId);
    }

    @Override
    public List<PatrolReportVO> getReportList() { // 💡 PageMaker 인자 제거
        return sqlSession.selectList(NAMESPACE + "getReportList");
    }
    
    // 💡 전체 카운트 조회용 메서드 추가
    public int getReportListCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + "getReportListCount", pageMaker);
    }

    @Override
    public int updateReport(PatrolReportVO reportVO) {
        return sqlSession.update(NAMESPACE + "updateReport", reportVO);
    }

    @Override
    public int deleteReport(int reportId) {
        return sqlSession.delete(NAMESPACE + "deleteReport", reportId);
    }
}
