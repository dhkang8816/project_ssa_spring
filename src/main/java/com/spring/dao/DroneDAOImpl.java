package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.DroneVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class DroneDAOImpl implements DroneDAO {

    private final SqlSession sqlSession;

    // 💡 지정하신 단순 네임스페이스 규칙 완벽 반영
    private static final String NAMESPACE = "Drone-Mapper";

    @Override
    public int insertDrone(DroneVO dvo) {
        // [CREATE] 신규 드론 등록 (dvo 수칙 적용)
        return sqlSession.insert(NAMESPACE + ".insertDrone", dvo);
    }

    @Override
    public List<DroneVO> selectDroneList(PageMaker pageMaker) {
        // [READ] 페이징 처리된 드론 목록 조회
        return sqlSession.selectList(NAMESPACE + ".selectDroneList", pageMaker);
    }

    @Override
    public int selectDroneCount(PageMaker pageMaker) {
        // [READ] 페이징 계산용 전체 드론 대수 카운트
        return sqlSession.selectOne(NAMESPACE + ".selectDroneCount", pageMaker);
    }

    @Override
    public DroneVO selectDroneById(String droneId) {
        // [READ] 드론 상세 단건 조회
        return sqlSession.selectOne(NAMESPACE + ".selectDroneById", droneId);
    }

    @Override
    public int updateDrone(DroneVO dvo) {
        // [UPDATE] 드론 담당 관제원 배정 수정
        return sqlSession.update(NAMESPACE + ".updateDrone", dvo);
    }

    @Override
    public int deleteDrone(String droneId) {
        // [DELETE] 드론 정보 삭제
        return sqlSession.delete(NAMESPACE + ".deleteDrone", droneId);
    }
}
