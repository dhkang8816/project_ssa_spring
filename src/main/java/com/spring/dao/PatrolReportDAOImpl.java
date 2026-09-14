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
    private static final String NAMESPACE = "PatrolReport-Mapper";

    @Override
    public int insertReport(PatrolReportVO reportVO) {
        return sqlSession.insert(NAMESPACE + ".insertReport", reportVO);
    }

    @Override
    public PatrolReportVO getReportById(int reportId) {
        return sqlSession.selectOne(NAMESPACE + ".getReportById", reportId);
    }

    @Override
    public List<PatrolReportVO> getReportList() {
        // 💡 중간에 마침표(".") 수식을 정확하게 삽입하여 경로 조립 오작동을 해결합니다.
        return sqlSession.selectList(NAMESPACE + ".getReportList");
    }

    
    // 💡 전체 카운트 조회용 메서드 추가
    public int getReportListCount(PageMaker pageMaker) {
        return sqlSession.selectOne(NAMESPACE + ".getReportListCount", pageMaker);
    }

    @Override
    public int updateReport(PatrolReportVO reportVO) {
        return sqlSession.update(NAMESPACE + ".updateReport", reportVO);
    }

    @Override
    public int deleteReport(int reportId) {
        return sqlSession.delete(NAMESPACE + ".deleteReport", reportId);
    }
    @Override
    public List<PatrolReportVO> getReportListWithPaging(PageMaker pageMaker) throws Exception {
        // 매퍼 XML에 PageMaker 객체를 그대로 전달하여 startRow, endRow 수식을 쿼리에 매핑합니다.
        return sqlSession.selectList(NAMESPACE + ".getReportListWithPaging", pageMaker);
    }

    @Override
    public int getReportTotalCount(PageMaker pageMaker) throws Exception {
        // 🔥 [버그 픽스] 중복 마침표 수식 분쇄 정정 (PatrolReport-Mapper.. -> PatrolReport-Mapper.)
        return sqlSession.selectOne(NAMESPACE + ".getReportTotalCount", pageMaker);
    }

    @Override
    public List<PatrolReportVO> getPendingReportListWithPaging(PageMaker pageMaker) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".getPendingReportListWithPaging", pageMaker);
    }

    @Override
    public int getPendingReportTotalCount(PageMaker pageMaker) throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".getPendingReportTotalCount", pageMaker);
    }

    @Override
    public int updateConfirmStatus(int reportId, String confirmStatus) {
        java.util.Map<String, Object> params = new java.util.HashMap<>();
        params.put("reportId", reportId);
        params.put("confirmStatus", confirmStatus);
        return sqlSession.update(NAMESPACE + ".updateConfirmStatus", params);
    }
}
