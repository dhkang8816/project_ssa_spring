package com.spring.service;

import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.spring.cmd.PageMaker;
import com.spring.dao.AnimalCounterDAO;
import com.spring.dao.AnimalDetailDAO;
import com.spring.dto.AnimalCounterVO;
import com.spring.dto.AnimalDetailVO;
import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class AnimalDetailServiceImpl implements AnimalDetailService {

    private final AnimalDetailDAO animalDetailDAO;
    private final AnimalCounterDAO animalCounterDAO; 

    @Override
    @Transactional
    public void registerAnimal(AnimalDetailVO adv) {
        // [CREATE] 1. 동물 상세 테이블에 무조건 신규 등록
        animalDetailDAO.insertAnimal(adv);
        
        // 💡 [스프링 내부 자동 처리] 축종 코드 추출 (0=개, 1=고양이, 나중에 추가될 신규 코드 등)
        int counterId = Integer.parseInt(adv.getAnimalType());
        
        // 임시 PageMaker 객체를 만들어 해당 counterId가 이미 테이블에 존재하는지 확인
        PageMaker pm = new PageMaker();
        pm.setSearchType("c");
        pm.setKeyword(String.valueOf(counterId));
        int existCount = animalCounterDAO.selectAnimalCounterCount(pm);
        
        if (existCount > 0) {
            // A. 💡 이미 해당 축종 행이 존재한다면 -> 기존 수치에 +1 자동 증가 (UPDATE)
            animalCounterDAO.updateAnimalCount(counterId, 1);
        } else {
            // B. 💡 완전히 처음 들어온 축종이라 행이 없다면 -> 자동으로 1마리 데이터 최초 개설 (INSERT)
            AnimalCounterVO acv = AnimalCounterVO.builder()
                    .counterId(counterId)
                    .currentCount(1) // 처음이니까 1마리로 시작
                    .build();
            animalCounterDAO.insertNewCounter(acv);
        }
    }

    @Override
    public List<AnimalDetailVO> getAnimalList(PageMaker pageMaker) {
        int totalCount = animalDetailDAO.selectAnimalCount(pageMaker);
        pageMaker.setTotalCount(totalCount);
        return animalDetailDAO.selectAnimalList(pageMaker);
    }

    @Override
    public AnimalDetailVO getAnimalById(int animalId) {
        return animalDetailDAO.selectAnimalById(animalId);
    }

    @Override
    @Transactional
    public void modifyAnimal(AnimalDetailVO adv) {
        animalDetailDAO.updateAnimal(adv);
    }

    @Override
    @Transactional
    public void removeAnimal(int animalId) {
        AnimalDetailVO adv = animalDetailDAO.selectAnimalById(animalId);
        if (adv != null) {
            animalDetailDAO.deleteAnimal(animalId);
            int counterId = Integer.parseInt(adv.getAnimalType());
            // 삭제 시에는 항상 -1 가감
            animalCounterDAO.updateAnimalCount(counterId, -1);
        }
    }
}
