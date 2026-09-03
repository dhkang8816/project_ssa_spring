package com.spring.util;

import java.io.File;
import java.io.IOException;
import java.util.UUID;
import org.springframework.web.multipart.MultipartFile;
import com.spring.exception.EmptyMultipartFileException;

public class MultipartFileUpload {

	public static String saveFile(String uploadPath, MultipartFile multi)
			throws EmptyMultipartFileException, IllegalStateException, IOException {

		if (multi == null || multi.isEmpty()) {
			throw new EmptyMultipartFileException();
		}

		// 파일 유무 확인, 저장 파일명 결정 (대시 제거 규칙 유지)
		String uuid = UUID.randomUUID().toString().replace("-", "");
		String fileName = uuid + "$$" + multi.getOriginalFilename();
		
		File storeFile = new File(uploadPath, fileName);
		
		// ⭕ [교정]: 파일명이 아니라, 이미지가 저장될 상위 부모 폴더(member)가 없으면 생성하도록 수정
		if (!storeFile.getParentFile().exists()) {
			storeFile.getParentFile().mkdirs();
		}
		
		// 로컬 가상 톰캣 서버 HDD 에 파일 직접 쓰기 실행
		multi.transferTo(storeFile);

		return fileName;
	}

	public static String saveFile(String uploadPath, String oldFile, MultipartFile multi)
			throws EmptyMultipartFileException, IllegalStateException, IOException {
		
		// 신규 파일 업로드 먼저 수행
		String fileName = saveFile(uploadPath, multi);
		
		// ⭕ [교정]: 기존 프로필 사진 삭제 방어선 구축 (기본 이미지는 디스크에서 지워지면 안 됨)
		if (oldFile != null && !oldFile.isEmpty() && !oldFile.equals("noImage.jpg")) {
			File file = new File(uploadPath, oldFile);
			if (file.exists()) {
				file.delete();
			}
		}
		
		return fileName;
	}
}
