<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>

<script type="text/javascript" src="/js/common/paging.js"></script>
<script type="text/javascript">

	$(document).ready(function() {

		var setCalendarDefault = function() {
			$("#startDate").datepicker();
			$("#startDate").datepicker('setDate', '${search.startDate}');
			$("#endDate").datepicker();
			$("#endDate").datepicker('setDate', '${search.endDate}');
		}
		setCalendarDefault();
	})

	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}

	function goReset(){
		$('#searchForm').resetForm();
	}



</script>

<h3 class="mjtit_top">
	제품식별(코드)관리
	<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>

<!--  관리자  검색시작-->
<div class="master_cont">

	<form id="searchForm" action="/production/list">
		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
		<div class="srch_day">
			<div class="day_area">
				<div class="day_label">
					<label for="startDate">생산일자</label>
				</div>
				<div class="day_input">
					<input type="text" id="startDate" name="startDate" readonly/>
				</div>
				<span class="sup">~</span>
				<div class="day_input">
					<input type="text" id="endDate" name="endDate" readonly/>
				</div>
			</div>
		</div>
		<div class="srch_all">
			<div class="sel_wrap sel_wrap1">
				<select name="search_type" class="sel_02">
					<option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
					<option value="SERIAL" <c:if test="${search.search_type == 'PLAN_CODE'}">selected</c:if>>시리얼</option>
					<option value="PDT_NAME" <c:if test="${search.search_type == 'MANAGER'}">selected</c:if>>품목명</option>
				</select>
			</div>

			<input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string"   onkeyup="if(window.event.keyCode==13){goSearch();}" />
			<div class="srch_btn">
				<button type="button" class="btn_02" onclick='goSearch();'>검색</button>
				<button type="button" class="btn_01">초기화</button>
			</div>

			<div class="register_btn">

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
				<col style="width: 120px;"/>
				<col style="width: 280px;"/>
				<col style="width: 210px;"/>
				<col style="width: 210px;"/>
				<col style="width: 100px;"/>
				<col style="width: 100px;"/>
				<col style="width: 70px;"/>
			</colgroup>
			<thead>
			<tr>
				<th>No</th>
				<th>작지서코드</th>
				<th>품목명</th>
				<th>생산라인</th>
				<th>생산담당자</th>
				<th>생산일자</th>
				<th>양품수량</th>
				<th>불량수량</th>
				<th>관리</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${list}" var="list">
				<tr>
					<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
					<td class="code">
						<a href="#" onclick="productionDetail('${list.production_code}');">${list.plan_code}</a>
					</td>
					<td class="prod">
						<a href="#" onclick="productionDetail('${list.production_code}');">${list.pdt_name}</a>
						<a href="#" onclick="productionDetail('${list.production_code}');" class="m_link">${list.pdt_name}</a>
					</td>
					<td class="sang">${list.product_line}</td>
					<td class="name">${list.managerName} ${list.managerPosition} (${list.groupName})</td>
					<td class="day">${fn:substring(list.production_date, 0, 10)}</td>
					<td class="number"><fmt:formatNumber value="${list.realQty}" pattern="#,###,###"/></td>
					<td class="number"><fmt:formatNumber value="${list.defectQty}" pattern="#,###,###"/></td>
					<td class="num"><button type="button" class="btn_03 btn_s" onclick="deleteProduction('${list.production_code}');">삭제</button></td>
				</tr>
			</c:forEach>
			<c:if test="${empty list }">
				<tr><td colspan="9">생산현황 정보가 없습니다.</td></tr>
			</c:if>

			</tbody>
		</table>
	</div>
	<div class="mjpaging_comm">
		${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
	</div>

</div>

