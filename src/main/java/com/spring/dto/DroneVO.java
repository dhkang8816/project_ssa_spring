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
	private String droneId; // DRONE_ID (VARCHAR2(30 BYTE), NOT NULL) 코멘트: 드론
	private String memberId;
}
