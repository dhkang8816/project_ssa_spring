package com.spring.service;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.DangerDetailVO;

public interface DangerDetailService {

    // 1. 등록
    public void registerDanger(DangerDetailVO ddv);
    
    // 2. 페이징 처리된 목록 조회 (PageMaker 세팅 포함)
    public List<DangerDetailVO> getDangerList(PageMaker pageMaker);
    
    // 3. 상세 조회
    public DangerDetailVO getDangerById(int dangerId);
    
    // 4. 수정
    public void modifyDanger(DangerDetailVO ddv);
    
    // 5. 삭제
    public void removeDanger(int dangerId);
}
