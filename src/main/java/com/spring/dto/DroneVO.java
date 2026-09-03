package com.spring.dto;

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
public class DroneVO {

	// 실물 DB 컬럼명 및 타입 정밀 매핑
	private String droneId; // DRONE_ID (VARCHAR2(30 BYTE), NOT NULL) 코멘트: 드론
	// 💡 2. 외래키 제약조건은 DB가 알아서 검증하므로, 자바는 순수 데이터 타입인 String 컬럼 변수만 추가해 줍니다!
	private String memberId;
}
