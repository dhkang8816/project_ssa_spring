package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalDetailVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class AnimalDetailDAOImpl implements AnimalDetailDAO {

    private SqlSession sqlSession;

    // 매퍼 XML의 namespace 경로 정의
    private static final String NAMESPACE = "AnimalDetail-Mapper";

    @Override
    public int insertAnimal(AnimalDetailVO adv) {
        // [CREATE] 동물 정보 등록
        return sqlSession.insert(NAMESPACE + ".insertAnimal", adv);
    }

    @Override
    public List<AnimalDetailVO> selectAnimalList(PageMaker pageMaker) {
        // [READ] 페이징 처리된 동물 목록 조회
        return sqlSession.selectList(NAMESPACE + ".selectAnimalList", pageMaker);
    }

    @Override
    public int selectAnimalCount(PageMaker pageMaker) {
        // [READ] 페이징 계산용 전체 데이터 개수 카운트
        return sqlSession.selectOne(NAMESPACE + ".selectAnimalCount", pageMaker);
    }

    @Override
    public AnimalDetailVO selectAnimalById(int animalId) {
        // [READ] 동물 상세 정보 조회 (단건)
        return sqlSession.selectOne(NAMESPACE + ".selectAnimalById", animalId);
    }

    @Override
    public int updateAnimal(AnimalDetailVO adv) {
        // [UPDATE] 동물 정보 수정
        return sqlSession.update(NAMESPACE + ".updateAnimal", adv);
    }

    @Override
    public int deleteAnimal(int animalId) {
        // [DELETE] 동물 정보 삭제
        return sqlSession.delete(NAMESPACE + ".deleteAnimal", animalId);
    }
}
