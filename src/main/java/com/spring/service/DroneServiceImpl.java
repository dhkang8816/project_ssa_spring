package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.DroneDAO;
import com.spring.dto.DroneVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DroneServiceImpl implements DroneService {

    private final DroneDAO droneDAO;

    @Override
    @Transactional
    public void registerDrone(DroneVO dvo) {
        // [CREATE] 신규 드론 등록
        droneDAO.insertDrone(dvo);
    }

    @Override
    public List<DroneVO> getDroneList(PageMaker pageMaker) {
        // [READ] 1. 전체 드론 대수를 조회하여 PageMaker에 세팅 (내부 calcData() 자동 실행)
        int totalCount = droneDAO.selectDroneCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        
        // [READ] 2. 페이징 범위에 맞는 드론 목록 반환
        return droneDAO.selectDroneList(pageMaker);
    }

    @Override
    public DroneVO getDroneById(String droneId) {
        // [READ] 드론 상세 단건 조회
        return droneDAO.selectDroneById(droneId);
    }

    @Override
    @Transactional
    public void modifyDrone(DroneVO dvo) {
        // [UPDATE] 드론 담당자 배정 정보 수정
        droneDAO.updateDrone(dvo);
    }

    @Override
    @Transactional
    public void removeDrone(String droneId) {
        // [DELETE] 드론 정보 삭제
        droneDAO.deleteDrone(droneId);
    }
}
