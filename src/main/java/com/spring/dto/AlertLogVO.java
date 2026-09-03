package com.spring.dto;

import java.sql.Timestamp;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString; // 디버깅용 로그 확인을 위해 추가 추천합니다!

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@ToString
public class AlertLogVO {

    // 1. 경보이력시퀀스 (NUMBER -> Nullable: No)
    private int alertId;
    
    // 2. 경보알림메세지내용 (VARCHAR2)
    private String alertMsg;
    
    // 3. 전송성공여부 (VARCHAR2)
    private String sendStatus;
    
    // 4. 경보전송일시 (DATE)
    private Date sendDate;
    
    // 5. 탐지이력시퀀스 (NUMBER -> Nullable: Yes 이므로 Integer 권장)
    private Integer dlogId;
    
    // 6. 최초경보시각 (TIMESTAMP)
    private Timestamp firstSendTime;
    
    // 7. 경보대상구분 (VARCHAR2)
    private String alertType;
    
    // 8. 이상객체탐지시퀀스 (NUMBER -> Nullable: Yes 이므로 Integer 권장)
    private Integer danlogId;
}
