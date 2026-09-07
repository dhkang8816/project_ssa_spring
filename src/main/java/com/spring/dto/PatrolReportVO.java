package com.spring.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
public class PatrolReportVO {

    // 리포트시퀀스 (NUMBER(38,0))
    private int reportId;

    // 리포트기준일자 (DATE)
    private Date reportDate;

    // 당일드론총비행시간 (NUMBER(5,2))
    private double totalFlightTime; 

    // 당일탐지총건수 (NUMBER(38,0))
    private int totalDetectCount;

    // 당일조치완료율 (NUMBER(5,2))
    private int completionRate;

    // 관제원확정여부 (VARCHAR2(1 BYTE))
    private String confirmStatus;

    // 최초수집일시 (DATE)
    private Date patrolDate;

    // 수동강제재실행 (DATE)
    private Date modDate;

    // 사번 (VARCHAR2(50 BYTE))
    private String memberId;
}