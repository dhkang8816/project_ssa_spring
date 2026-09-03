package com.spring.dao;

import java.util.List;
import com.spring.cmd.PageMaker;
import com.spring.dto.AlertLogVO;

public interface AlertLogDAO {
    public void insertAlertLog(AlertLogVO vo) throws Exception;
    public AlertLogVO getAlertLog(int alertId) throws Exception;
    
    // 파라미터 타입을 Map 대신 본인의 PageMaker로 변경
    public List<AlertLogVO> getAlertLogListWithPaging(PageMaker pageMaker) throws Exception;
    public int getTotalCount(PageMaker pageMaker) throws Exception;
}
