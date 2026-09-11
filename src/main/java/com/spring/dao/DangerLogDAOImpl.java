package com.spring.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.DangerLogVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class DangerLogDAOImpl implements DangerLogDAO {

    private final SqlSession sqlSession;

    // 💡 지정하신 단순 네임스페이스 규칙 완벽 반영
    private static final String NAMESPACE = "DangerLog-Mapper";

    @Override
    public int insertDangerLog(DangerLogVO dlv) {
        // [CREATE] 관제 탐지 로그 등록 (dlv 수칙 적용)
        return sqlSession.insert(NAMESPACE + ".insertDangerLog", dlv);
    }

    @Override
    public List<DangerLogVO> selectDangerLogList(PageMaker pageMaker) {
        // [READ] 페이징 및 다조건 검색 처리된 목록 조회
        return sqlSession.selectList(NAMESPACE + ".selectDangerLogList", pageMaker);
    }

    @Override
    public int selectDangerLogCount(PageMaker pageMaker) {
        // [READ] 페이징 계산용 전체 로그 건수 카운트
        return sqlSession.selectOne(NAMESPACE + ".selectDangerLogCount", pageMaker);
    }

    @Override
    public DangerLogVO selectDangerLogById(int danlogId) {
        // [READ] 스냅샷 열람 및 조치를 위한 단건 상세 조회
        return sqlSession.selectOne(NAMESPACE + ".selectDangerLogById", danlogId);
    }

    @Override
    public int updateDactionStatus(DangerLogVO dlv) {
        // [UPDATE] 관제원 현장 조치 상태 및 사유 내용 업데이트
        return sqlSession.update(NAMESPACE + ".updateDactionStatus", dlv);
    }
    
    @Override
    public Map<String, Object> selectTodayDangerStats() throws Exception {
        return sqlSession.selectOne(NAMESPACE + ".selectTodayDangerStats");
    }
}
