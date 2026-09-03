package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AnimalDetailVO;

public interface AnimalDetailService {

    // 1. 동물 등록
    public void registerAnimal(AnimalDetailVO adv);
    
    // 2. 페이징 처리된 동물 목록 조회 (PageMaker 내부 totalCount 설정까지 포함)
    public List<AnimalDetailVO> getAnimalList(PageMaker pageMaker);
    
    // 3. 동물 상세 조회
    public AnimalDetailVO getAnimalById(int animalId);
    
    // 4. 동물 정보 수정
    public void modifyAnimal(AnimalDetailVO adv);
    
    // 5. 동물 정보 삭제
    public void removeAnimal(int animalId);
}
