<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>





<script type="text/javascript" src="/js/common/paging.js"></script>
<script type="text/javascript">

	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}

	function goReset(){
		$('#searchForm').resetForm();
	}

	function codeDetail(code){
		comCodeDetailInfoLayer_Open(code, "view");
	}
	function newRegister(){
		comCodeDetailInfoLayer_Open("", "");
	}

	function comCodeDetailInfoLayer_Open(code, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#actionButton').text("수정");

			$('#mode').val('edit');
			$.ajax({
				type : "get",
				url : '/code/codeDetailInfo',
				async : false,
				data: "code="+code,
				success : function(data) {
					var result = data.storeData;
					$('#code_id').val(result.code_id);
					$('#code').val(result.code);
					$('#code_nm').val(result.code_nm);
					$('#code_dc').val(result.code_dc);
					$('#use_yn').val(result.use_yn);
					//JQuery를 쓰는경우
					$("#code_id option").not(":selected").attr("disabled", true);

				}
			});

		}else{ //신규작성일때
			$('#actionButton').text("등록");

			$('#mode').val('regist');
			$('#code').val("");
			$('#code_nm').val("");
			$('#code_dc').val("");
			$('#use_yn').val("Y");
			$("#code_id option:eq(0)").prop("selected", true);
			$("#code_id option").attr("disabled", false);
		}

		$('#comCodeDetailInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}



	function comCodeDetailInfoLayer_Close(){
		$('#comCodeDetailInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('#img').removeAttr("src");

	}

	function GoActionButton(){

		var targetUrl = "/code/manageCodeDetail";
		var mode = $('#mode').val();
		var formData = $('#comCodeDetailInfo_Form').serialize();

		if(isEmpty($('#code_id').val())){
			alert("상위코드를 입력하세요.");
			return false;
		}

		if(isEmpty($('#code_nm').val())){
			alert("코드명을 입력하세요.");
			return false;
		}
		if(isEmpty($('#code_dc').val())){
			alert("코드설명을 입력하세요.");
			return false;
		}



		$.ajax({
			type : "post",
			url : targetUrl,
			async : false,
			data : formData,
			success : function(data) {

				if($("#mode").val() == "regist") {

					if (data.msg == "success"){
						alert('생성하였습니다.');
						comCodeDetailInfoLayer_Close();
						location.reload();
					}else if(data.msg == "fail"){
						alert('이미 사용중인 코드입니다.');
					}else{
						alert('데이터 에러입니다.');
					}

				}
				else if($("#mode").val() == "edit") {

					if (data.msg == "success"){
						alert('수정하였습니다.');
						comCodeDetailInfoLayer_Close();
						location.reload();
					}else{
						alert('데이터 에러입니다.');
					}
				}

			}
		});

	}
</script>

<h3 class="mjtit_top">
	공통상세코드관리
	<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>

<!--  관리자  검색시작-->
<div class="master_cont">

	<form id="searchForm" action="/code/comCodeDetailList">
		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
		<div class="srch_day">


		</div>
		<div class="srch_all">

			<div class="sel_wrap sel_wrap1">
				<select name="search_type" class="sel_02">
					<option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
					<c:forEach items="${code_list}" var="result">
						<option value="${result.code_id}" <c:if test="${search.search_type == result.code_id}">selected</c:if>>${result.code_nm}</option>
					</c:forEach>
				</select>
			</div>

			<input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string"   onkeyup="if(window.event.keyCode==13){goSearch();}" />
			<div class="srch_btn">
				<button type="button" class="btn_02" onclick='goSearch();'>검색</button>
				<button type="button" class="btn_01" onclick='goReset();'>초기화</button>
			</div>

			<div class="register_btn">
				<button type="button" class="btn_02" onclick="newRegister();">신규등록</button>

			</div>


		</div>

	</form>

</div><!-- 검색  끝-->
<!-- 리스트 시작-->

<div class="master_list ">
	<div class="list_set ">
		<div class="set_right">
			<div class="sel_wrap">
				<select name="rowPerPage_1" id="rowPerPage_1" class="sel_01">
					<option value="15"<c:if test="${search.rowsPerPage == '15'}">selected</c:if>>15개씩 보기</option>
					<option value="30"<c:if test="${search.rowsPerPage == '30'}">selected</c:if>>30개씩 보기</option>
					<option value="50"<c:if test="${search.rowsPerPage == '50'}">selected</c:if>>50개씩 보기</option>
					<option value="100"<c:if test="${search.rowsPerPage == '100'}">selected</c:if>>100개씩 보기</option>
				</select>
			</div>
		</div>
	</div>
	<div class="scroll">
		<table class="master_01 master_06">
			<colgroup>
				<col style="width: 55px;"/>
				<col style="width: 185px;"/>
				<col style="width: 350px;"/>
				<col style="width: 115px;"/>
				<col style="width: 115px;"/>
			</colgroup>
			<thead>
			<tr>
				<th>No</th>
				<th>상위코드명</th>
				<th>코드명</th>
				<th>사용여부</th>
				<th>작성일자</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${list}" var="list">
				<tr>
					<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
					<td class="code"><a href="#" onclick="codeDetail('${list.code}'); return;">${list.upper_code_nm}</a></td>
					<td class="code">
						<a href="#" onclick="codeDetail('${list.code}'); return;">${list.code_nm}</a>
						<a href="#" onclick="codeDetail('${list.code}'); return;" class="m_link">${list.code_nm}</a>
					</td>
					<td class="ing">${list.use_yn}</td>
					<td class="day">${list.reg_date}</td>

				</tr>
			</c:forEach>


			<c:if test="${empty list }">
				<tr><td colspan="5">공통상세코드가 없습니다.</td></tr>
			</c:if>


			</tbody>
		</table>
	</div>
	<div class="mjpaging_comm">
		${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
	</div>

</div>
<div class="master_pop master_pop01" id="comCodeDetailInfoLayer">
	<div class="master_body">
		<div class="pop_bg" onclick="comCodeDetailInfoLayer_Close();"></div>
		<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
			<div class="pop_inner">
				<form id="comCodeDetailInfo_Form" name="comCodeDetailInfo_Form">
					<input type="hidden" name="mode" id="mode"  value="regist"/>

					<h3>공통상세코드 등록/조회<a class="back_btn" href="#" onclick="comCodeDetailInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

					<div class="master_list master_listB">
						<table  class="master_02 master_04">
							<colgroup>
								<col style="width: 140px"/>
								<col />
								<col style="width: 140px"/>
								<col />
							</colgroup>
							<tbody>
							<tr>
								<th scope="row">상위코드</th>
								<td colspan="3">
									<div class="sel_wrap" >
										<select class="sel_02" id="code_id" name="code_id">
											<option value="">선택</option>
											<c:forEach items="${code_list}" var="result">
												<option value="${result.code_id}">${result.code_nm}</option>
											</c:forEach>
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row">하위코드</th>
								<td colspan="3"><input type="text" id="code" name="code" maxlength="6" readonly="readonly"/></td>
							</tr>
							<tr>
								<th scope="row">코드명</th>
								<td colspan="3"><input type="text" id="code_nm" name="code_nm" class="all" maxlength="30"/></td>
							</tr>
							<tr>
								<th scope="row">코드설명</th>
								<td colspan="3"><input type="text" id="code_dc" name="code_dc" class="all" maxlength="30"/></td>
							</tr>
							<tr>
								<th scope="row">사용여부</th>
								<td colspan="3">
									<div class="sel_wrap" >
										<select class="sel_02" id="use_yn" name="use_yn" >
											<option value="Y">사용</option>
											<option value="N">미사용</option>
										</select>
									</div>
								</td>
							</tr>

							</tbody>

						</table>

					</div>

					<div class="pop_btn clearfix" >
						<a href="#" class="p_btn_01" onclick="comCodeDetailInfoLayer_Close();">닫기</a>
						<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02"></a>
					</div>

				</form>
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="comCodeDetailInfoLayer_Close();"><span>닫기</span></a>
			</div>



		</div>
	</div>
</div>

