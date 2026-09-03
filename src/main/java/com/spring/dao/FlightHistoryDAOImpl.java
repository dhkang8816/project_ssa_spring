package com.spring.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import com.spring.cmd.PageMaker;
import com.spring.dto.FlightHistoryVO;

import lombok.AllArgsConstructor;

@Repository
@AllArgsConstructor
public class FlightHistoryDAOImpl implements FlightHistoryDAO {

    private final SqlSession sqlSession;

    // 💡 지정하신 단순 네임스페이스 규칙 완벽 바인딩
    private static final String NAMESPACE = "FlightHistory-Mapper";

    @Override
    public int insertFlightHistory(FlightHistoryVO fhv) {
        // [CREATE] 비행 이력 등록 (fhv 수칙 반영)
        return sqlSession.insert(NAMESPACE + ".insertFlightHistory", fhv);
    }

    @Override
    public List<FlightHistoryVO> selectFlightHistoryList(PageMaker pageMaker) {
        // [READ] 페이징 및 다조건 검색 처리된 목록 조회
        return sqlSession.selectList(NAMESPACE + ".selectFlightHistoryList", pageMaker);
    }

    @Override
    public int selectFlightHistoryCount(PageMaker pageMaker) {
        // [READ] 페이징 계산용 전체 이력 건수 카운트
        return sqlSession.selectOne(NAMESPACE + ".selectFlightHistoryCount", pageMaker);
    }

    @Override
    public FlightHistoryVO selectFlightHistoryById(int flightId) {
        // [READ] 단건 상세 조회
        return sqlSession.selectOne(NAMESPACE + ".selectFlightHistoryById", flightId);
    }

    @Override
    public int deleteFlightHistory(int flightId) {
        // [DELETE] 잘못 적재된 비행 이력 정보 삭제
        return sqlSession.delete(NAMESPACE + ".deleteFlightHistory", flightId);
    }
}
