package com.spring.controller;

import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.cmd.PageMaker;
import com.spring.dto.CommonCodeVO;
import com.spring.service.CommonCodeService;

@Controller
@RequestMapping("/commoncode") // 💡 웹 브라우저 접근 주소를 폴더명과 통일합니다.
public class CommonCodeController {

	@Autowired
	private CommonCodeService commonCodeService;

	/**
	 * 1. 공통코드 리스트 조회 URL: http://localhost:8080/commoncode/list
	 */
	@RequestMapping(value = "/list", method = { RequestMethod.GET, RequestMethod.POST })
	public String getCommonCodeList(PageMaker pageMaker, Model model) throws Exception {

		// 1. 전체 개수 조회 후 PageMaker에 세팅 (calcData()가 실행되어 startPage, endPage, prev, next 등이 자동 계산됨)
		int totalCount = commonCodeService.getCommonCodeCount(pageMaker);
		pageMaker.setTotalCount(totalCount);

		// 2. 페이징 및 검색 조건이 적용된 목록 조회
		List<CommonCodeVO> codeList = commonCodeService.getCommonCodeList(pageMaker);
		PageMaker groupCodePageMaker = new PageMaker();
		groupCodePageMaker.setPerPageNum(1000);
		Set<String> groupCodes = new TreeSet<>();
		for (CommonCodeVO code : commonCodeService.getCommonCodeList(groupCodePageMaker)) {
			if (code.getGrpCode() != null && !code.getGrpCode().isEmpty()) {
				groupCodes.add(code.getGrpCode());
			}
		}

		model.addAttribute("codeList", codeList);
		model.addAttribute("groupCodes", groupCodes);
		model.addAttribute("pageMaker", pageMaker); // JSP에서 버튼과 검색 조건을 유지하기 위해 전달

		// 💡 이미지의 /WEB-INF/views/commoncode/ 하위 jsp 파일을 바라보도록 리턴 경로 유지
		return "commoncode/codeList";
	}
	
	/**
	 * 2. 공통코드 상세 조회 URL: http://localhost:8080/commoncode/detail
	 */
	@RequestMapping(value = "/detail", method = RequestMethod.GET)
	public String getCommonCodeDetail(@RequestParam("grpCode") String grpCode, @RequestParam("code") String code,
			Model model) throws Exception {

		CommonCodeVO ccVO = commonCodeService.getCommonCodeDetail(grpCode, code);
		model.addAttribute("ccVO", ccVO);

		// 💡 이미지의 폴더 구조 반영
		return "commoncode/codeDetail";
	}

	/**
	 * 3. 공통코드 등록 처리
	 */
	@RequestMapping(value = "/register", method = RequestMethod.POST)
	public String registerCommonCode(@ModelAttribute("ccVO") CommonCodeVO ccVO,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup) throws Exception {

		commonCodeService.registerCommonCode(ccVO);

		// 💡 .do가 제거된 새로운 주소 규칙 적용 리다이렉트
		return popup ? "redirect:/commoncode/list?popupSaved=true" : "redirect:/commoncode/list";
	}

	/**
	 * 4. 공통코드 수정 처리
	 */
	@RequestMapping(value = "/modify", method = RequestMethod.POST)
	public String modifyCommonCode(@ModelAttribute("ccVO") CommonCodeVO ccVO,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup) throws Exception {

		commonCodeService.modifyCommonCode(ccVO);

		return popup ? "redirect:/commoncode/list?popupSaved=true"
				: "redirect:/commoncode/detail?grpCode=" + ccVO.getGrpCode() + "&code=" + ccVO.getCode();
	}

	/**
	 * 5. 공통코드 삭제 처리
	 */
	@RequestMapping(value = "/remove", method = RequestMethod.POST)
	public String removeCommonCode(@RequestParam("grpCode") String grpCode, @RequestParam("code") String code,
			@RequestParam(value = "popup", defaultValue = "false") boolean popup)
			throws Exception {

		commonCodeService.removeCommonCode(grpCode, code);

		return popup ? "redirect:/commoncode/list?popupSaved=true" : "redirect:/commoncode/list";
	}

	// CommonCodeController.java 내부에 추가
	@RequestMapping(value = "/registerForm", method = RequestMethod.GET)
	public String registerForm() {
		// /WEB-INF/views/commoncode/codeRegister.jsp 화면을 열어줍니다.
		return "commoncode/codeRegister";
	}
}
