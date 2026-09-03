package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalCounterVO;

public interface AnimalCounterService {

    // 1. 페이징 처리된 카운터 목록 조회 (PageMaker 내부 totalCount 설정 포함)
    public List<AnimalCounterVO> getAnimalCounterList(PageMaker pageMaker);
    
    // 2. 실시간 카운터 수치 증감
    public void modifyAnimalCount(int counterId, int countDiff);
    
    // 3. 신규 축종 카운터 행 추가
    public void registerNewCounter(AnimalCounterVO acv);
}
