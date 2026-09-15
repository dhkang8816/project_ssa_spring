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
        droneDAO.insertDrone(dvo);
    }

    @Override
    public List<DroneVO> getDroneList(PageMaker pageMaker) {
        int totalCount = droneDAO.selectDroneCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return droneDAO.selectDroneList(pageMaker);
    }

    @Override
    public DroneVO getDroneById(String droneId) {
        return droneDAO.selectDroneById(droneId);
    }

    @Override
    @Transactional
    public void modifyDrone(DroneVO dvo) {
        droneDAO.updateDrone(dvo);
    }

    @Override
    @Transactional
    public void removeDrone(String droneId) {
        droneDAO.deleteDrone(droneId);
    }
}
