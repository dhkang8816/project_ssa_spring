package com.spring.dao;

import java.util.List;

import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalDetailVO;

public interface AnimalDetailDAO {

    // 1. 등록
    public int insertAnimal(AnimalDetailVO vo);
    
    // 2. 페이징 목록 조회
    public List<AnimalDetailVO> selectAnimalList(PageMaker pageMaker);
    
    // 3. 전체 카운트
    public int selectAnimalCount(PageMaker pageMaker);
    
    // 4. 상세 단건 조회
    public AnimalDetailVO selectAnimalById(int animalId);
    
    // 5. 수정
    public int updateAnimal(AnimalDetailVO adv);
    
    // 6. 삭제
    public int deleteAnimal(int animalId);
}
