package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.DetectionLogVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class DetectionLogDAOImpl implements DetectionLogDAO {

    private final SqlSession sqlSession;

    // 💡 지정하신 단순 네임스페이스 규칙 완벽 바인딩
    private static final String NAMESPACE = "DetectionLog-Mapper";

    @Override
    public int insertDetectionLog(DetectionLogVO dlv) {
        // [CREATE] 관제 탐지 로그 등록 (dlv 수칙 반영)
        return sqlSession.insert(NAMESPACE + ".insertDetectionLog", dlv);
    }

    @Override
    public List<DetectionLogVO> selectDetectionLogList(PageMaker pageMaker) {
        // [READ] 페이징 및 다조건 검색 처리된 목록 조회
        return sqlSession.selectList(NAMESPACE + ".selectDetectionLogList", pageMaker);
    }

    @Override
    public int selectDetectionLogCount(PageMaker pageMaker) {
        // [READ] 페이징 계산용 전체 로그 건수 카운트
        return sqlSession.selectOne(NAMESPACE + ".selectDetectionLogCount", pageMaker);
    }

    @Override
    public DetectionLogVO selectDetectionLogById(int dlogId) {
        // [READ] 스냅샷 열람 및 조치를 위한 단건 상세 조회
        return sqlSession.selectOne(NAMESPACE + ".selectDetectionLogById", dlogId);
    }

    @Override
    public int updateActionStatus(DetectionLogVO dlv) {
        // [UPDATE] 현장 조치 상태 및 내용 업데이트
        return sqlSession.update(NAMESPACE + ".updateActionStatus", dlv);
    }
}
