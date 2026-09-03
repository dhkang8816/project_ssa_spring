package com.spring.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalCounterVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class AnimalCounterDAOImpl implements AnimalCounterDAO {

    private final SqlSession sqlSession;

    // 💡 알려주신 바뀐 네임스페이스 규칙 완벽 반영
    private static final String NAMESPACE = "AnimalCounter-Mapper";

    @Override
    public List<AnimalCounterVO> selectAnimalCounterList(PageMaker pageMaker) {
        // [READ] 축종 카운터 페이징 목록 조회
        return sqlSession.selectList(NAMESPACE + ".selectAnimalCounterList", pageMaker);
    }

    @Override
    public int selectAnimalCounterCount(PageMaker pageMaker) {
        // [READ] 페이징 계산을 위한 전체 카운터 행 개수 조회
        return sqlSession.selectOne(NAMESPACE + ".selectAnimalCounterCount", pageMaker);
    }

    @Override
    public int updateAnimalCount(int counterId, int countDiff) {
        // [UPDATE] 기존 카운터 데이터 증감 처리 (멀티 파라미터 대응을 위해 Map 활용)
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("counterId", counterId);
        paramMap.put("countDiff", countDiff);
        
        return sqlSession.update(NAMESPACE + ".updateAnimalCount", paramMap);
    }

    @Override
    public int insertNewCounter(AnimalCounterVO acv) {
        // [CREATE] 새로운 탐지 대상/축종이 추가되었을 때 새 현황판 행을 개설
        return sqlSession.insert(NAMESPACE + ".insertNewCounter", acv);
    }
}
