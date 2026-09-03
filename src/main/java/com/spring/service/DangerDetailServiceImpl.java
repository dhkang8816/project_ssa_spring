package com.spring.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.cmd.PageMaker;
import com.spring.dao.DangerDetailDAO;
import com.spring.dto.DangerDetailVO;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class DangerDetailServiceImpl implements DangerDetailService {

    private final DangerDetailDAO dangerDetailDAO;

    @Override
    @Transactional
    public void registerDanger(DangerDetailVO ddv) {
        // [CREATE] 이상 객체 등록
        dangerDetailDAO.insertDanger(ddv);
    }

    @Override
    public List<DangerDetailVO> getDangerList(PageMaker pageMaker) {
        // [READ] 전체 행의 개수를 조회하여 PageMaker에 세팅 (내부 calcData() 자동 실행)
        int totalCount = dangerDetailDAO.selectDangerCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        
        // [READ] 페이징 범위에 맞는 리스트 반환
        return dangerDetailDAO.selectDangerList(pageMaker);
    }

    @Override
    public DangerDetailVO getDangerById(int dangerId) {
        // [READ] 상세 단건 조회
        return dangerDetailDAO.selectDangerById(dangerId);
    }

    @Override
    @Transactional
    public void modifyDanger(DangerDetailVO ddv) {
        // [UPDATE] 이상 객체 정보 수정
        dangerDetailDAO.updateDanger(ddv);
    }

    @Override
    @Transactional
    public void removeDanger(int dangerId) {
        // [DELETE] 이상 객체 정보 삭제
        dangerDetailDAO.deleteDanger(dangerId);
    }
}
