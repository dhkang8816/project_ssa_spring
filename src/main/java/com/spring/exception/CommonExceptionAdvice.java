package com.spring.exception;

import java.sql.SQLIntegrityConstraintViolationException;

import org.mybatis.spring.MyBatisSystemException;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

@ControllerAdvice // 💡 1. 모든 컨트롤러에서 발생하는 에러를 감시하는 스프링 전용 어노테이션
public class CommonExceptionAdvice {
    @ExceptionHandler({DataAccessException.class, MyBatisSystemException.class})
    public ModelAndView handleDatabaseException(Exception ex) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", ex);
        mav.addObject("errorMsg", "데이터베이스 처리 도중 예기치 못한 오류가 발생했습니다.");
        mav.setViewName("error/errorCommon"); // WEB-INF/views/error/errorCommon.jsp 매핑
        return mav;
    }
    @ExceptionHandler(Exception.class)
    public ModelAndView handleCommonException(Exception ex) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("exception", ex);
        mav.addObject("errorMsg", "시스템 내부 서버 오류가 발생했습니다. 관리자에게 문의하세요.");
        mav.setViewName("error/errorCommon");
        return mav;
    }
    @ExceptionHandler(SQLIntegrityConstraintViolationException.class)
    public ModelAndView handleBulkKeyException(Exception ex) {
        ModelAndView mav = new ModelAndView();
        if(ex.getMessage().contains("ORA-00001")) {
            mav.addObject("message", "🚨 중복된 식별 번호가 존재합니다. 다른 번호를 입력하세요.");
        } else if(ex.getMessage().contains("ORA-02291")) {
            mav.addObject("message", "🚨 상위 마스터 테이블에 존재하지 않는 잘못된 코드/사번 데이터입니다.");
        } else {
            mav.addObject("message", "데이터 무결성 오류가 발생했습니다.");
        }
        
        mav.setViewName("common/message"); // 500 화면 대신 alert 창이 있는 message.jsp로 전송!
        return mav;
    }
    @ExceptionHandler(DataIntegrityViolationException.class)
    public ModelAndView handleDataIntegrityException(Exception ex) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("message", "🚨 데이터 무결성 제약조건 오류가 발생했습니다. 입력한 정보(중복 여부 등)를 다시 확인해 주세요.");
        mav.setViewName("common/message"); // 500 에러 껍데기 대신 공통 메시지 팝업창 출력
        
        return mav;
    }

}
