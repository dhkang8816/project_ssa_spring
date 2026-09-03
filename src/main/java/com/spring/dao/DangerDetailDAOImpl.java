package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.DangerDetailVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class DangerDetailDAOImpl implements DangerDetailDAO {

    private final SqlSession sqlSession;

    // 💡 요청하신 명칭 규칙 완벽 매핑
    private static final String NAMESPACE = "DangerDetail-Mapper";

    @Override
    public int insertDanger(DangerDetailVO ddv) {
        // [CREATE] 이상 객체 등록
        return sqlSession.insert(NAMESPACE + ".insertDanger", ddv);
    }

    @Override
    public List<DangerDetailVO> selectDangerList(PageMaker pageMaker) {
        // [READ] 페이징 처리된 목록 조회
        return sqlSession.selectList(NAMESPACE + ".selectDangerList", pageMaker);
    }

    @Override
    public int selectDangerCount(PageMaker pageMaker) {
        // [READ] 페이징 계산용 전체 데이터 개수 카운트
        return sqlSession.selectOne(NAMESPACE + ".selectDangerCount", pageMaker);
    }

    @Override
    public DangerDetailVO selectDangerById(int dangerId) {
        // [READ] 상세 단건 조회
        return sqlSession.selectOne(NAMESPACE + ".selectDangerById", dangerId);
    }

    @Override
    public int updateDanger(DangerDetailVO ddv) {
        // [UPDATE] 이상 객체 정보 수정
        return sqlSession.update(NAMESPACE + ".updateDanger", ddv);
    }

    @Override
    public int deleteDanger(int dangerId) {
        // [DELETE] 이상 객체 정보 삭제
        return sqlSession.delete(NAMESPACE + ".deleteDanger", dangerId);
    }
}
