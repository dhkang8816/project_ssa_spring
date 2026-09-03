package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalCounterVO;

public interface AnimalCounterDAO {
    
    // 1. 페이징 처리 및 검색이 반영된 카운터 목록 조회
    public List<AnimalCounterVO> selectAnimalCounterList(PageMaker pageMaker);
    
    // 2. 페이징 계산용 전체 카운터 행 개수
    public int selectAnimalCounterCount(PageMaker pageMaker);
    
    // 3. 카운터 수치 가감 수정을 위한 메서드 (int 기반 파라미터 매핑)
    public int updateAnimalCount(int counterId, int countDiff);
    
    // 4. 새로운 축종 카운터 신규 개설
    public int insertNewCounter(AnimalCounterVO acv);
}
