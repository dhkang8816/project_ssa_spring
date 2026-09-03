<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공통코드 상세 및 수정</title>
<style>
    body { font-family: sans-serif; padding: 20px; }
    .form-group { margin-bottom: 15px; }
    label { display: inline-block; width: 100px; font-weight: bold; }
    input, select { padding: 6px; width: 250px; }
    input[readonly] { background-color: #f0f0f0; cursor: not-allowed; }
</style>
<script>
    // 삭제 요청 시 한 번 더 안전하게 물어보는 자바스크립트 함수
    function fnDelete() {
        if(confirm("정말로 이 코드를 삭제하시겠습니까?")) {
            var form = document.detailForm;
            form.action = "${pageContext.request.contextPath}/commoncode/remove";
            form.submit();
        }
    }
</script>
</head>
<body>

    <h2>🔍 공통코드 상세 및 정보 변경</h2>
    
    <form:form name="detailForm" method="post">
        <!-- 💡 중요: 복합키인 그룹코드와 상세코드는 수정되면 안 되므로 readonly 처리하되, 
             삭제/수정 요청 시 컨트롤러로 데이터가 반드시 넘어가야 하므로 hidden 또는 readonly 인풋으로 유지합니다. -->
        <div class="form-group">
            <label>그룹코드:</label>
            <input type="text" name="grpCode" value="${ccVO.grpCode}" readonly />
        </div>
        <div class="form-group">
            <label>상세코드:</label>
            <input type="text" name="code" value="${ccVO.code}" readonly />
        </div>
        
        <!-- 수정 가능한 영역 -->
        <div class="form-group">
            <label>코드명칭:</label>
            <input type="text" name="codeName" value="${ccVO.codeName}" required />
        </div>
        <div class="form-group">
            <label>정렬순서:</label>
            <input type="number" name="sortSeq" value="${ccVO.sortSeq}" required />
        </div>
        <div class="form-group">
            <label>사용여부:</label>
            <select name="useYn">
                <option value="Y" ${ccVO.useYn == 'Y' ? 'selected' : ''}>사용 (Y)</option>
                <option value="N" ${ccVO.useYn == 'N' ? 'selected' : ''}>미사용 (N)</option>
            </select>
        </div>
        
        <div style="margin-top: 20px;">
            <!-- 수정 완료 처리 -->
            <button type="submit" onclick="this.form.action='${pageContext.request.contextPath}/commoncode/modify'">정보 수정</button>
            <!-- 삭제 처리 (자바스크립트 함수 호출) -->
            <button type="button" onclick="fnDelete();" style="background-color: #ff4d4d; color: white; border: none; padding: 6px 12px; cursor: pointer;">코드 삭제</button>
            <button type="button" onclick="location.href='${pageContext.request.contextPath}/commoncode/list'">목록으로</button>
        </div>
    </form:form>

</body>
</html>
