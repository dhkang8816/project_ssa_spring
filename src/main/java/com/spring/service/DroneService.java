package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DroneVO;

public interface DroneService {

    // 1. 신규 드론 등록 (dvo 명명 규칙 반영)
    public void registerDrone(DroneVO dvo);
    
    // 2. 페이징 처리된 드론 목록 조회 (PageMaker 세팅 포함)
    public List<DroneVO> getDroneList(PageMaker pageMaker);
    
    // 3. 드론 상세 조회
    public DroneVO getDroneById(String droneId);
    
    // 4. 드론 담당 관제원 배정 수정
    public void modifyDrone(DroneVO dvo);
    
    // 5. 드론 정보 삭제
    public void removeDrone(String droneId);
}
