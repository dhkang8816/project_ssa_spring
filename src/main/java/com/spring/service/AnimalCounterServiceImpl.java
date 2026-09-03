package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.AnimalCounterDAO;
import com.spring.dto.AnimalCounterVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class AnimalCounterServiceImpl implements AnimalCounterService {

    private final AnimalCounterDAO animalCounterDAO;

    @Override
    public List<AnimalCounterVO> getAnimalCounterList(PageMaker pageMaker) {
        // [READ] 1. 전체 카운터 행 개수를 조회하여 PageMaker에 세팅
        int totalCount = animalCounterDAO.selectAnimalCounterCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        
        // [READ] 2. 페이징 범위에 맞는 카운터 데이터 목록 반환
        return animalCounterDAO.selectAnimalCounterList(pageMaker);
    }

    @Override
    @Transactional
    public void modifyAnimalCount(int counterId, int countDiff) {
        // [UPDATE] 실시간 카운트 증감 처리
        animalCounterDAO.updateAnimalCount(counterId, countDiff);
    }

    @Override
    @Transactional
    public void registerNewCounter(AnimalCounterVO acv) {
        // [CREATE] 신규 축종 현황판 행 개설
        animalCounterDAO.insertNewCounter(acv);
    }
}
