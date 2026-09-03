package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DroneVO;

public interface DroneDAO {

    // 1. 등록 (dvo 명명 규칙 적용)
    public int insertDrone(DroneVO dvo);
    
    // 2. 페이징 목록 조회
    public List<DroneVO> selectDroneList(PageMaker pageMaker);
    
    // 3. 전체 개수 카운트
    public int selectDroneCount(PageMaker pageMaker);
    
    // 4. 상세 단건 조회
    public DroneVO selectDroneById(String droneId);
    
    // 5. 수정
    public int updateDrone(DroneVO dvo);
    
    // 6. 삭제
    public int deleteDrone(String droneId);
}
