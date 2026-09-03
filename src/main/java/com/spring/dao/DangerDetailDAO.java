package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DangerDetailVO;

public interface DangerDetailDAO {

    // 1. 등록 (ddv 매개변수 명 수칙 반영)
    public int insertDanger(DangerDetailVO ddv);
    
    // 2. 페이징 목록 조회
    public List<DangerDetailVO> selectDangerList(PageMaker pageMaker);
    
    // 3. 전체 개수 카운트
    public int selectDangerCount(PageMaker pageMaker);
    
    // 4. 상세 단건 조회
    public DangerDetailVO selectDangerById(int dangerId);
    
    // 5. 수정
    public int updateDanger(DangerDetailVO ddv);
    
    // 6. 삭제
    public int deleteDanger(int dangerId);
}
