<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<style type="text/css" >
	.mjlist_tbl01 td {width:auto; padding:10px 25px;border-bottom:1px solid #ededed;color:#333; font-size:12px;}
	.mjlist_tbl01 td.left_pt10 {width: 160px !important;padding: 10px;border-right:1px #ededed solid; background:#f6f6f6;text-align: left;	}
	.grid_input {border : none;background-color:inherit;width:100%;text-align:center;overflow:hidden}
	.nb_input{border : none;background-color:inherit;text-align:left;overflow:hidden}
</style>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>

</head>
<body>
	<h3 class="mjtit_top">
		구매사 그룹 관리
	</h3>
<!-- 리스트 시작-->
	<div class="align_rgt mjinput">
		<div class="mjLeft">
			<input type="text" name="" id="insertGroupName" placeholder="그룹명">
			<button type="button" class="btn_blue01" id="insertButton">그룹 추가</button>
		</div>

		<div class="mjLeft">
			<a href="#" class="btn_blue01_1" onclick="getRandomSecret()" ><span>Secret 생성(임시)</span></a>
			<label for="randomSecret_id">ID:</label>
			<input type="text" name="" id="randomSecret_id" readonly>
			<label for="randomSecret_secret">Secret:</label>
			<input type="text" name="" id="randomSecret_secret" readonly style="width:300px">
		</div>
		<div class="mjRight">
			<button type="button" class="btn_blue01_1" id="platformAddCodeButton">계약서류항목</button>
		</div>
	</div>
	<select name="rowsPerPage" id="rowsPerPage" class="left00 top15 sel_box" style="display:none">
		<option value="10">10개씩 보기</option>
	</select>
	<div id="gridParent_1" class="col">
			<table id="jqGrid_1" class="display" cellspacing="0" cellpadding="0"></table>
			<span class="number3 keyf06" id="dataCnt_1"></span>건 검색
			<div id="paginate_1" class="mjpaging_comm"></div>
	</div>

	<%-- 그룹추가 --%>
	<div class="layer_win01" style="width:1000px;display: none;" id="platformDiv">

		<div>
			<div class="bigjtit_top">플랫폼관리</div>

			<h3 class="mjtit_top">
				제공서비스
			</h3>
			<div class="top_mt10 bottom_mt20">
				<form action="/member/buyerGroup/updatePlatformInfo.json" method="post" id="platformRegisterForm" >
					<table cellpadding="0" cellspacing="0" class="mjlist_tbl01" >
						<caption>등록/수정 양식</caption>
						<tr>
							<td class="left_pt10 align_cen">그룹명</td>
							<td><input type="text" class="nb_input" name="groupName" id=""></td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">사용여부</td>
							<td>
								<input type="radio" name="useAt" value="Y" id="useAt_y" checked /> <label class="right_mt20" for="useAt_y">사용</label>
								<input type="radio" name="useAt" value="N" id="useAt_n" /> <label class="right_mt20" for="useAt_n">사용 안함</label>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">제공형태 선택</td>
							<td>
								<c:set value="true" var="isFirst"></c:set>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFA'}">
										<input type="radio" class="${code.classification}" name="platformType" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${isFirst?'checked':''}/> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
										<c:set var="isFirst" value="false"></c:set>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr class="setting_api">
							<td class="left_pt10 align_cen">API 등록방법</td>
							<td>
								<input type="radio" class="apiAdminCheck" name="apiAdminCheck" id="apiAdminCheck_Y" value="Y" checked/> <label class="apiAdminCheck" for="apiAdminCheck_Y">관리자 승인 후 등록</label>
								<input type="radio" class="apiAdminCheck" name="apiAdminCheck" id="apiAdminCheck_N" value="N"/> <label class="apiAdminCheck" for="apiAdminCheck_N">즉시 등록</label>

							</td>
						</tr>
						<tr class="setting_api">
							<td class="left_pt10 align_cen">API ID</td>
							<td>
								<span id="platform_api_id"></span>
							</td>
						</tr>
						<tr class="setting_api">
							<td class="left_pt10 align_cen">API Secret</td>
							<td>
								<span id="platform_api_secret"></span>
							</td>
						</tr>
						<tr>
							<td rowspan="3" class="left_pt10" style="width:10%">도메인 주소 설정</td>
							<td>
								<c:set value="true" var="isFirst"></c:set>
								<c:forEach items="${commonCode}" var="code" varStatus="j">
									<c:if test="${code.classification=='PFB'}">
										<input type="radio" class="${code.classification}" name="addressType" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${isFirst?'checked':''} /> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
										<c:set var="isFirst" value="false"></c:set>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td>
								<input type="text" class="text_box01 w_10"  name="platformId" id="platformId">
								<label for="platformId">.c-market.net</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="text" class="text_box01 w_25"  name="internetAddress" id="internetAddress" placeholder="예) Moguchon.c-market.net">
								<label for="internetAddress"></label>
							</td>
						</tr>

						<%--<tr>
							<td class="left_pt10 align_cen" style="width:10%">도메인 주소 설정</td>
							<td>
								<input type="text" class="text_box01 w_25"  name="internetAddress" id="internetAddress" placeholder="예) Moguchon.c-market.net">
								<label for="internetAddress"></label>
							</td>
						</tr>--%>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">로고 / 타이틀</td>
							<td>
								<a href="" class="right_mt20 product_image_name" id="logoImage">(미등록)</a>
								<button type="button" id="logoImageButton" class="btn_gray01_4 right_mt20" >찾기</button>
								<input type="text" class="text_box01 w_20 align_rgt" name="platformTitle" placeholder="예) 전자입찰시스템">
								<input type="file" name="logoImageFile" id="logoImageFile" style="display:none">
							</td>
						</tr>
						<%--
						<tr>
							<td rowspan="2" class="left_pt10" style="width:10%">수수료 설정</td>
							<td>
								<input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="feeRate" value="" id="feeRate" />
								<label for="feeRate">% (부가세 제외)</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="maxFee" value="" id="maxFee" disabled />
								<label class="right_mt20" for="maxFee">원</label>
								<input type="checkbox" name="maxFeeUseAt" id="maxFeeUseAt" value="Y">
								<label for="maxFeeUseAt">최대 수수료 사용</label>
							</td>
						</tr>
						--%>
						<tr>
							<td class="left_pt10 align_cen">제공 서비스 선택</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFC'}">
										<input type="checkbox" class="${code.classification}" name="provide_service${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}/> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-낙찰방법</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFD'}">
										<input type="checkbox" class="${code.classification}" name="bid_successful${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}/> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
					</table>
					<h3 class="mjtit_top">
						물품
					</h3>
					<table cellpadding="0" cellspacing="0" class="mjlist_tbl01" >
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">물품정보-인수도 설정</td>
							<td>
								<input type="radio" name="thingUndertakingUseAt" id="thingUndertakingUseAt-N" value="N" checked>
								<label class="right_mt20" for="thingUndertakingUseAt-N">사용안함</label>
								<input type="radio" name="thingUndertakingUseAt" id="thingUndertakingUseAt-Y" value="Y">
								<label for="thingUndertakingUseAt-Y">사용</label>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">물품정보-과세구분</td>
							<td>
								<input type="radio" name="thingTaxUseAt" id="thingTaxUseAt-N" value="N" checked>
								<label class="right_mt20" for="thingTaxUseAt-N">사용안함</label>
								<input type="radio" name="thingTaxUseAt" id="thingTaxUseAt-Y" value="Y">
								<label for="thingTaxUseAt-Y">사용</label>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">물품정보-엑셀업로드</td>
							<td>
								<input type="radio" name="thingRegisterExcelUseAt" id="thingRegisterExcelUseAt-N" value="N" checked>
								<label class="right_mt20" for="thingRegisterExcelUseAt-N">사용안함</label>
								<input type="radio" name="thingRegisterExcelUseAt" id="thingRegisterExcelUseAt-Y" value="Y">
								<label for="thingRegisterExcelUseAt-Y">사용</label>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-참가자격</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFE'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">입찰방식</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFF'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-가격제시방법</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFG'}">
										<input type="checkbox" class="${code.classification} has-default" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
								<select name="default_G" id="default_G">
									<option value="">기본값 설정</option>
								</select>
							</td>
						</tr>

						<tr>
							<td class="left_pt10 align_cen">세부조건-계약서류</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFH'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>





						<tr>
							<td class="left_pt10 align_cen">기타-마감결과 공개방식</td>
							<td>
								<c:set value="true" var="isFirst"></c:set>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFO'}">
										<input type="radio" class="${code.classification}" name="thingResultOpenType" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${isFirst?'checked':''}/> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
										<c:set var="isFirst" value="false"></c:set>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">마감일시 조건 설정</td>
							<td>
								<span>(가) 일반 입찰 및 복사 입찰 : +</span>
								<input type="text" name="thingBidClosTimeD" id="thingBidClosTimeD" class="text_box01 w_05 align_rgt timeD" value="0" maxlength="2">
								<label for="thingBidClosTimeD">일</label>
								<input type="text" name="thingBidClosTimeH" id="thingBidClosTimeH" class="text_box01 w_05 align_rgt timeH" value="0" maxlength="2">
								<label for="thingBidClosTimeH">시</label>
								<input type="text" name="thingBidClosTimeM" id="thingBidClosTimeM" class="text_box01 w_05 align_rgt timeM" value="0" maxlength="2">
								<label for="thingBidClosTimeM">분</label>
								<input type="hidden" name="thingBidClosTimeMin">

								<span class="left_mt10">(나) 재입찰 : +</span>
								<input type="text" name="thingRebidClosTimeD" id="thingRebidClosTimeD" class="text_box01 w_05 align_rgt timeD" value="0" maxlength="2">
								<label for="thingRebidClosTimeD">일</label>
								<input type="text" name="thingRebidClosTimeH" id="thingRebidClosTimeH" class="text_box01 w_05 align_rgt timeH" value="0" maxlength="2">
								<label for="thingRebidClosTimeH">시</label>
								<input type="text" name="thingRebidClosTimeM" id="thingRebidClosTimeM" class="text_box01 w_05 align_rgt timeM" value="0" maxlength="2">
								<label for="thingRebidClosTimeM">분</label>
								<input type="hidden" name="thingRebidClosTimeMin">

							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">기타-재입찰 동의/비동의 설정</td>
							<td>
								<input type="radio" name="thingRebidAt" id="thingRebidAt-N" value="N" checked>
								<label class="right_mt20" for="thingRebidAt-N">사용안함</label>
								<input type="radio" name="thingRebidAt" id="thingRebidAt-Y" value="Y">
								<label for="thingRebidAt-Y">사용</label>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">기타-1순위 자동추첨 기능 사용</td>
							<td>
								<input type="radio" name="thingPriortAutoDrwtAt" id="thingPriortAutoDrwtAtc-N" value="N" checked>
								<label class="right_mt20" for="thingPriortAutoDrwtAtc-N">사용안함</label>
								<input type="radio" name="thingPriortAutoDrwtAt" id="thingPriortAutoDrwtAtc-Y" value="Y">
								<label for="thingPriortAutoDrwtAtc-Y">사용</label>
							</td>
						</tr>
					</table>

					<h3 class="mjtit_top">
						용역
					</h3>
					<table cellpadding="0" cellspacing="0" class="mjlist_tbl01" >
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">낙찰방법-제한적최저가</td>
							<td>
								<input type="radio" name="cntrwkLimitLowestUseAt" id="cntrwkLimitLowestUseAt-N" value="N" checked>
								<label class="right_mt20" for="cntrwkLimitLowestUseAt-N">사용안함</label>
								<input type="radio" name="cntrwkLimitLowestUseAt" id="cntrwkLimitLowestUseAt-Y" value="Y">
								<label for="cntrwkLimitLowestUseAt-Y">사용</label>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-참가자격</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFI'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-가격제시방법</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFJ'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-계약서류</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFK'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">기타-마감결과 공개방식</td>
							<td>
								<c:set value="true" var="isFirst"></c:set>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFP'}">
										<input type="radio" class="${code.classification}" name="serviceResultOpenType" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${isFirst?'checked':''}/> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
										<c:set var="isFirst" value="false"></c:set>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">마감일시 조건 설정</td>
							<td>
								<span>(가) 일반 입찰 및 복사 입찰 : +</span>
								<input type="text" name="serviceBidClosTimeD" id="serviceBidClosTimeD" class="text_box01 w_05 align_rgt timeD" value="0" maxlength="2">
								<label for="serviceBidClosTimeD">일</label>
								<input type="text" name="serviceBidClosTimeH" id="serviceBidClosTimeH" class="text_box01 w_05 align_rgt timeH" value="0" maxlength="2">
								<label for="serviceBidClosTimeH">시</label>
								<input type="text" name="serviceBidClosTimeM" id="serviceBidClosTimeM" class="text_box01 w_05 align_rgt timeM" value="0" maxlength="2">
								<label for="serviceBidClosTimeM">분</label>
								<input type="hidden" name="serviceBidClosTimeMin">

								<span class="left_mt10">(나) 재입찰 : +</span>
								<input type="text" name="serviceRebidClosTimeD" id="serviceRebidClosTimeD" class="text_box01 w_05 align_rgt timeD" value="0" maxlength="2">
								<label for="serviceRebidClosTimeD">일</label>
								<input type="text" name="serviceRebidClosTimeH" id="serviceRebidClosTimeH" class="text_box01 w_05 align_rgt timeH" value="0" maxlength="2">
								<label for="serviceRebidClosTimeH">시</label>
								<input type="text" name="serviceRebidClosTimeM" id="serviceRebidClosTimeM" class="text_box01 w_05 align_rgt timeM" value="0" maxlength="2">
								<label for="serviceRebidClosTimeM">분</label>
								<input type="hidden" name="serviceRebidClosTimeMin">

							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">기타-1순위 자동추첨 기능 사용</td>
							<td>
								<input type="radio" name="servicePriortAutoDrwtAt" id="servicePriortAutoDrwtAtc-N" value="N" checked>
								<label class="right_mt20" for="servicePriortAutoDrwtAtc-N">사용안함</label>
								<input type="radio" name="servicePriortAutoDrwtAt" id="servicePriortAutoDrwtAtc-Y" value="Y">
								<label for="servicePriortAutoDrwtAtc-Y">사용</label>
							</td>
						</tr>
					</table>
					<h3 class="mjtit_top">
						공사
					</h3>
					<table cellpadding="0" cellspacing="0" class="mjlist_tbl01" >
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">낙찰방법-제한적최저가</td>
							<td>
								<input type="radio" name="serviceLimitLowestPriceUseAt" id="serviceLimitLowestUseAt-N" value="N" checked>
								<label class="right_mt20" for="serviceLimitLowestUseAt-N">사용안함</label>
								<input type="radio" name="serviceLimitLowestPriceUseAt" id="serviceLimitLowestUseAt-Y" value="Y">
								<label for="serviceLimitLowestUseAt-Y">사용</label>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-참가자격</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFL'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-가격제시방법</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFM'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">세부조건-계약서류</td>
							<td>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFN'}">
										<input type="checkbox" class="${code.classification}" name="bid_detail${code.no}" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${code.fixedAt=='Y'?'checked disabled':''}> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen">기타-마감결과 공개방식</td>
							<td>
								<c:set value="true" var="isFirst"></c:set>
								<c:forEach items="${commonCode}" var="code">
									<c:if test="${code.classification=='PFQ'}">
										<input type="radio" class="${code.classification}" name="cntrwkResultOpenType" id="${code.classification}_${code.commonCode}" value="${code.commonCode}" ${isFirst?'checked':''}/> <label class="right_mt20" for="${code.classification}_${code.commonCode}">${code.codeName}</label>
										<c:set var="isFirst" value="false"></c:set>
									</c:if>
								</c:forEach>
							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">마감일시 조건 설정</td>
							<td>
								<span>(가) 일반 입찰 및 복사 입찰 : +</span>
								<input type="text" name="cntrwkBidClosTimeD" id="cntrwkBidClosTimeD" class="text_box01 w_05 align_rgt timeD" value="0" maxlength="2">
								<label for="cntrwkBidClosTimeD">일</label>
								<input type="text" name="cntrwkBidClosTimeH" id="cntrwkBidClosTimeH" class="text_box01 w_05 align_rgt timeH" value="0" maxlength="2">
								<label for="cntrwkBidClosTimeH">시</label>
								<input type="text" name="cntrwkBidClosTimeM" id="cntrwkBidClosTimeM" class="text_box01 w_05 align_rgt timeM" value="0" maxlength="2">
								<label for="cntrwkBidClosTimeM">분</label>
								<input type="hidden" name="cntrwkBidClosTimeMin">

								<span class="left_mt10">(나) 재입찰 : +</span>
								<input type="text" name="cntrwkRebidClosTimeD" id="cntrwkRebidClosTimeD" class="text_box01 w_05 align_rgt timeD" value="0" maxlength="2">
								<label for="cntrwkRebidClosTimeD">일</label>
								<input type="text" name="cntrwkRebidClosTimeH" id="cntrwkRebidClosTimeH" class="text_box01 w_05 align_rgt timeH" value="0" maxlength="2">
								<label for="cntrwkRebidClosTimeH">시</label>
								<input type="text" name="cntrwkRebidClosTimeM" id="cntrwkRebidClosTimeM" class="text_box01 w_05 align_rgt timeM" value="0" maxlength="2">
								<label for="cntrwkRebidClosTimeM">분</label>
								<input type="hidden" name="cntrwkRebidClosTimeMin">

							</td>
						</tr>
						<tr>
							<td class="left_pt10 align_cen" style="width:10%">기타-1순위 자동추첨 기능 사용</td>
							<td>
								<input type="radio" name="cntrwkPriortAutoDrwtAt" id="cntrwkPriortAutoDrwtAtc-N" value="N" checked>
								<label class="right_mt20" for="cntrwkPriortAutoDrwtAtc-N">사용안함</label>
								<input type="radio" name="cntrwkPriortAutoDrwtAt" id="cntrwkPriortAutoDrwtAtc-Y" value="Y">
								<label for="cntrwkPriortAutoDrwtAtc-Y">사용</label>
							</td>
						</tr>
					</table>
					<input type="hidden" name="platformCode">
					<input type="hidden" name="groupCode">
				</form>
			</div>
			<!-- 하단버튼 -->
			<div class="bottom_mt30 align_cen">
				<button type="button" class="btn_blue01" id="registerButton">등록 및 수정</button>
				<button type="button" class="btn_gray01" id="closeButton">닫기</button>

			</div>
		</div>
		<div class="group_close">
			<a href="#" id="closeButton1"><span>닫기</span></a>
		</div>
	</div>
	<div class="layer_win01" style="width:500px;left:-100000000px" id="platformAddCodeDiv">
		<div>
			<div class="bigjtit_top">계약서류 항목관리</div>
			<h3 class="mjtit_top">
				항목관리
			</h3>
			<table class="mjlist_tbl01" >
				<tr>
					<td>항목 구분</td>
					<td>
						<select name="" id="platformAddCodeSelect" class="left00 top15 sel_box">
							<option value="">선택</option>
							<option value="PFA">제공형태 선택</option>
							<option value="PFB">도메인 주소 설정</option>
							<option value="PFC">제공서비스 선택</option>
							<option value="PFD">낙찰방법 선택</option>
							<option value="PFE">물품:세부조건-참가자격</option>
							<option value="PFF">물품:입찰방식</option>
							<option value="PFG">물품:세부조건-가격제시방법</option>
							<option value="PFO">물품:기타-마감결과 공개방식</option>
							<option value="PFL">공사:세부조건-참가자격</option>
							<option value="PFM">공사:세부조건-가격제시방법</option>
							<option value="PFQ">공사:기타-마감결과 공개방식</option>
							<option value="PFI">용역:세부조건-참가자격</option>
							<option value="PFJ">용역:세부조건-가격제시방법</option>
							<option value="PFP">용역:기타-마감결과 공개방식</option>

							<option value="PFH">물품:세부조건-계약서류</option>
							<option value="PFK">용역:세부조건-계약서류</option>
							<option value="PFN">공사:세부조건-계약서류</option>

						</select>
					</td>
				</tr>
				<tr>
					<td>항목 추가</td>
					<td><input type="text" name="" id="platformAddCodeName" class="text_box01 w_50"><button type="button" class="btn_blue01_1" id="platformAddCodeButton2" >추가</button></td>
				</tr>
			</table>

			<select name="rowsPerPage_2" id="rowsPerPage_2" class="left00 top15 sel_box" style="display:none">
				<option value="210000"></option>
			</select>
			<div id="gridParent_2" class="col">
				<span class="number3 keyf06" id="dataCnt_2"></span>건 검색
				<table id="jqGrid_2" class="display" cellspacing="0" cellpadding="0"></table>
				
				<div id="paginate_2" class="mjpaging_comm"></div>
				<div class="align_cen mt20" style="border-top:1px solid #fafafa"><button type="button" class="btn_gray01_1 close_popup">닫기</button></div>
			</div>
		</div>
		<div class="group_close">
			<a href="#" class="close_popup"><span>닫기</span></a>
		</div>
	</div>
	<div id="modCodeNameDiv" style="display:none;background-color:#ffffff;border:2px solid;padding:22px;width:auto">
		<div>
			<span class="mjbul mjbul_0001"></span>이름, 값 변경
		</div>
		<table>
			<tr>
				<td><label for="modCodeName" class="right_mt10">이름</label></td>
				<td><input type="text" name="codeName" id="modCodeName" class="text_box01 w_55 align_lft"></td>
			</tr>
			<tr>
				<td><label for="modCodeValue" class="right_mt10">값</label></td>
				<td><input type="text" name="codeValue" id="modCodeValue" class="text_box01 w_55 align_lft"></td>
			</tr>
		</table>
		<input type="hidden" name="commonCode" id="modCommonCode">
		<div class="align_cen mt20" >
			<button type="button" class="btn_blue01_1" id="modCodeButton" >저장</button>
		</div>
	</div>

	<div class="layer_win01" style="width:500px;left:-200000000px" id="feeDiv">
		<div>
			<div class="bigjtit_top" id="feeGroupName"></div>
			<h3 class="mjtit_top">
				수수료 관리</span>
			</h3>
			<select name="rowsPerPage_3" id="rowsPerPage_3" class="left00 top15 sel_box" style="display:none">
				<option value="210000"></option>
			</select>
			<div id="gridParent_3" class="col">
				<form action="" id="feeRateForm">
					<table id="jqGrid_3" class="display" cellspacing="0" cellpadding="0"></table>
					<input type="hidden" name="groupCode" id="feeGroupCode">
				</form>
				<span class="number3 keyf06" id="dataCnt_3" style="display:none"></span>
				<div id="paginate_3" class="mjpaging_comm"></div>
				<div class="align_cen mt20" style="border-top:1px solid #fafafa">
					<button type="button" class="btn_blue01_1" id="feeSaveButton">저장</button>
					<button type="button" class="btn_gray01_1 close_popup2">닫기</button>
				</div>
			</div>
		</div>
		<div class="group_close">
			<a href="#" class="close_popup2"><span>닫기</span></a>
		</div>
	</div>
	<div class="pop_box">
		<iframe src="about:blank" frameborder="0" id="memoPop"></iframe>
	</div>
	<div id="logoImageViewDiv" class="layer_win01" style="padding: 12px;display : none;position:absolute;z-index:2100000000;height:auto;width:auto" >
		<img src="" alt="" id="logoImageViewImg">
	</div>

<script>

	$(document).ready(function() {
		var colModel = [
			{ label : "번호", name : "no", align : "center", width : "3%", sortable : false},
			{ label : "메모", name : "memoCount", align : "center", width : "2%", sortable : false, formatter : memoFormat },
			{ label : "명칭", name : "groupName", align : "center", width : "10%", sortable : false, formatter : groupNameFormat},
			{ label : "소속 구매사 수", name : "memberCount", align : "center", width : "5%", sortable : false, formatter : function(x){return "<span class='memberCount'>"+(x==null?'0':x)+"</span>";} },
			{ label : "입찰1", name : "", align : "center", width : "8%", sortable : false },
			{ label : "입찰2", name : "", align : "center", width : "6%", sortable : false },
			{ label : "입찰3", name : "", align : "center", width : "8%", sortable : false },
			{ label : "그룹상태", name : "useAt", align : "center", width : "6", sortable : false, formatter : useAtFormat },
			{ label : "생성일자", name : "registPnttm", align : "center", width : "8%", sortable : false },
			{ label : "", name : "", align : "center", width : "13%", sortable : false, formatter : modifyFormat }
		];

		var setPostData = {
			currentPage : 1,
			rowsPerPage : 10,
		};

		creatJqGrid("jqGrid_1", "/member/buyerGroup/getBuyerGroupList", colModel,  setPostData,  "paginate_1", "dataCnt_1", "rowsPerPage", "gridParent_1")



		var colModel_2 = [
			{ label : "이름", name : "codeName", align : "center", width : "10%", sortable : false, formatter : codeNameFormat },
			{ label : "활성", name : "commonCode", align : "center", width : "3%", sortable : false, formatter : codeUseAtFormat },
			{ label : "fix", name : "deleteAt", align : "center", width : "5%", sortable : false, formatter : codeFixedAtFormat },
			{ label : "정렬", name : "useAt", align : "center", width : "8%", sortable : false, formatter : codeSortNumberFormat }
		];

		var setPostData_2 = {
			classification : $("#platformAddCodeSelect").val()
		};

		creatJqGrid("jqGrid_2", "/commonCode/getCommonCode.json", colModel_2,  setPostData_2,  "paginate_2", "dataCnt_2", "rowsPerPage_2", "gridParent_2")

		var colModel_3 = [
			{ label : "구분", name : "gubun", align : "center", width : "25%", sortable : false },
			{ label : "수수료율", name : "feeRate", align : "center", width : "25%", sortable : false, formatter : feeRateFormat },
			{ label : "최대수수료 사용", name : "maxFeeUseAt", align : "center", width : "25%", sortable : false, formatter : maxFeeUseAtFormat },
			{ label : "최대 수수료", name : "maxFee", align : "center", width : "25%", sortable : false, formatter : maxFeeFormat }
		];

		var setPostData_3 = {
			classification : $("#platformAddCodeSelect").val()
		};

		creatJqGrid("jqGrid_3", "/member/buyerGroup/getGroupFeeInfo.json", colModel_3,  setPostData_3,  "paginate_3", "dataCnt_3", "rowsPerPage_3", "gridParent_3", gridCallBack3)
	});

	$(window).resize(function(){
		$("#jqGrid_1").setGridWidth($(this).width() - $(".sidenav").width() - 65);
	});
	function goMemoEnd() {
		$('.pop_box').css('display','none');
		$('#memoPop').attr('src','about:blank');
	}
	function popReload() {
		document.getElementById('memoPop').contentWindow.location.reload();
	}
	function memoFormat(cellvalue, options, rowObject){
		return "<a href='javascript:pop_memo4(\""+rowObject.groupCode+"\");'><img src='/images/note"+(rowObject.memoCount>0?'_on':'')+".gif' title='메모보기'></a>"
	}

	function groupNameFormat(cellvalue, options, rowObject){
		return "<input class='grid_input groupName' type='text' value='"+nts(cellvalue)+"'>";
	}

	function useAtFormat(cellvalue, options, rowObject){
		return "<select class='useAt sel_box w_65'><option value='Y' "+(cellvalue=='Y'?'selected':'')+">활성</option><option value='N' "+(cellvalue=='N'?'selected':'')+">비활성</option></select>";
	}

	function modifyFormat(cellvalue, options, rowObject){
		var platformBtn = "";
		if(rowObject.platformCode > 0){
			platformBtn = "<button class='btn_orange01_1 grid_platform_button' type='button' data-group-code='"+rowObject.groupCode+"' data-platform-code='"+rowObject.platformCode+"' >플랫폼 정보</button>";
		}else{
			platformBtn = "<button class='btn_orange01_1 grid_platform_button' type='button' data-group-code='"+rowObject.groupCode+"' data-platform-code='"+rowObject.platformCode+"'     style='background-color:#379392;'>플랫폼 등록</button>";
		}


		return  platformBtn +
				"<button class='btn_blue01_1 grid_fee_button' type='button' data-group-code='"+rowObject.groupCode+"'>수수료설정</button>" +
				"<button class='btn_gray01_1 grid_delete_button' type='button' data-group-code='"+rowObject.groupCode+"'>삭제</button>"
				;
	}

	function codeNameFormat(cellvalue, options, rowObject){
		return "<a href='' class='codeName' data-code='"+rowObject.commonCode+"' data-value='"+rowObject.codeValue+"'>"+cellvalue+"</a>"
	}

	function codeUseAtFormat(cellvalue, options, rowObject){
		return "<input type='checkbox' class='codeUseAt' data-code='"+cellvalue+"' "+(rowObject.useAt=='Y'?'checked':'')+" "+(rowObject.isUsingCode=='Y'?'disabled':'')+">"
	}

	function codeFixedAtFormat(cellvalue, options, rowObject){
		return "<input type='checkbox' class='codeFixedAt' data-code='"+rowObject.commonCode+"' "+(rowObject.fixedAt=='Y'?'checked':'')+">"
	}

	function codeSortNumberFormat(cellvalue, options, rowObject){
		return "<button type='button' class='changeSortNumber btn_gray01_5' data-code='"+rowObject.commonCode+"' data-change='1' >▲</button>  <button type='button' class='changeSortNumber btn_gray01_5' data-code='"+rowObject.commonCode+"' data-change='-1' >▼</button>";
	}

	//수수료율
	function feeRateFormat(cellvalue, options, rowObject){
		return "<input class='text_box01 w_40 align_rgt feeRate3' name='"+rowObject.gubun2+"_feeRate' type='text' value='"+cellvalue+"' pattern='^[0-9]{0,2}(\\.[0-9]{1,3}){0,1}$' maxlength='6'> %";
	}
	//최대수수료 사용여부
	function maxFeeUseAtFormat(cellvalue, options, rowObject){
		return "<input type='checkbox' class='maxFeeUseAt3' name='"+rowObject.gubun2+"_maxFeeUseAt' "+(cellvalue=='Y'?'checked':'')+" value='Y' >";
	}
	//최대수수료
	function maxFeeFormat(cellvalue, options, rowObject){
		return "<input class='text_box01 w_60 align_rgt maxFee3' name='"+rowObject.gubun2+"_maxFee' type='text' value='"+cellvalue+"' maxlength='8' data-val='"+cellvalue+"' "+(rowObject.maxFeeUseAt=='Y'?'':'disabled')+"> 원";
	}

	function gridCallBack3(response){
		if(response.storeData.length > 0) {
			// console.log(response.storeData[0]);
			$("#feeGroupName").html("").text(response.storeData[0].groupName);
		}
	}


	//수수료 설정 팝업
	$("#jqGrid_1").on("click", ".grid_fee_button", function(e){
		$("#feeDiv").css("position", "static");
		$("#feeDiv").css("left", "0");
		$("#feeGroupCode").val($(this).data("groupCode"));
		var postData_3 = {
			groupCode : $(this).data("groupCode")
		};
		$("#jqGrid_3").jqGrid('setGridParam', {
			postData: JSON.stringify(postData_3)
		}).trigger("reloadGrid");
		$("#feeDiv").popup({
			autoopen : true,
			escape : false,
			blur : false
		});
	})

	$("#jqGrid_1").on("click", ".grid_delete_button", function(e){
		e.preventDefault();
		var targetCode = $(this).data("groupCode");
		if($(this).closest("tr").find(".memberCount").text()>0){
			alert("소속 구매사가 있어 삭제할 수 없습니다.");
			return false;
		}

		if(!confirm("삭제하시겠습니까?"))
			return false;

		$.ajax({
			type : "post",
			url : "/member/buyerGroup/deleteBuyerGroup.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify({
				groupCode : targetCode
			})
		}).done(function(response){
			if(response.success){
				alert("삭제되었습니다.");
				$("#jqGrid_1").jqGrid().trigger("reloadGrid");
			}else{
				alert(response.message);
			}
		})
	})

	$("#insertButton").click(function(e){
		e.preventDefault();
		$.ajax({
			type : "post",
			url : "/member/buyerGroup/insertBuyerGroup.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify({
				groupName : $("#insertGroupName").val()
			})
		}).done(function(response){
			if(response.success){
				$("#jqGrid_1").jqGrid().trigger("reloadGrid");
			}else{
				alert(response.message);
			}
		})
	})

	$("#jqGrid_1").on("click", ".grid_platform_button", function(){
		$("#platformRegisterForm").resetForm();
		$("input[name='groupCode']").val($(this).data("groupCode"));
		$("input[name='platformCode']").val($(this).data("platformCode"));
		$("#logoImage").text("(미등록)")
		if($(this).data("platformCode")>0){
			$.ajax({
				type : "post",
				url : "/member/buyerGroup/getPlatformInfo.json",
				async : false,
				contentType: "application/json",
				dataType : "json",
				data : JSON.stringify({
					platformCode : $(this).data("platformCode")
				})
			}).done(function(response){
				if(response.success){
					var defaultInfo = response.storeData[0]
					for(key in defaultInfo){
						if($("input[name='"+key+"']").length > 0){
							if($("input[name='"+key+"']").attr("type")=="radio" || $("input[name='"+key+"']").attr("type")=="checkbox" ) {
								$("input[name='" + key + "'][value='" + defaultInfo[key] + "']").prop("checked", true);
							}else if($("input[name='"+key+"']").attr("type")=="text"){
								$("input[name='" + key + "']").val(defaultInfo[key]);
							}
						}
					}
					$("#logoImage").text(defaultInfo["fileOriginName"]);
					$("#logoImage").data("platformCode", defaultInfo["platformCode"]);
					$("#platform_api_id").text(defaultInfo["api_id"])
					$("#platform_api_secret").text(defaultInfo["api_secret"])
					//입찰 서비스 항목
					for(idx in response.storeData){
						$("input[value='"+response.storeData[idx].serviceCode+"']").prop("checked", true).data("default", response.storeData[idx].defaultAt);
					}


				}else{
					alert(response.message);
				}
			})
		}
		if($("input[name='addressType']:checked").val() != "10004"){
			//씨마켓 도메인 미선택
			$("input[name='platformId']").prop("disabled", true).val("");
			$("input[name='internetAddress']").prop("disabled", false);
		}else if($("input[name='addressType']:checked").val() != "10005"){
			$("input[name='internetAddress']").prop("disabled", true).val("");
			$("input[name='platformId']").prop("disabled", false);
		}
		if($("#maxFeeUseAt").prop("checked")){
			$("input[name='maxFee']").prop("disabled", false);
		}else{
			$("input[name='maxFee']").val("0").prop("disabled", true);
		}
		init_default();
		// $("#platformDiv").popup("show");
		$("#platformDiv").popup({
			autoopen : true,
			escape : false,
			blur : false
		});
	})

	$("#logoImageButton").click(function(){
		$("#logoImageFile").click();
	})
	$("#logoImageFile").change(function(e){
		$("#logoImage").text("").text($("#logoImageFile")[0].files[0].name);
	})


	$("#closeButton,#closeButton1").click(function(e){
		e.preventDefault();
		$("#platformDiv").popup("hide");
	})
	//저장
	$("#registerButton").click(function(e){
		e.preventDefault();
		// if(isNaN($("input[name='feeRate']").val()) || $("input[name='feeRate']").val().length <= 0)
		// 	$("input[name='feeRate']").val("0")
		// if(isNaN($("input[name='maxFee']").val()) || $("input[name='maxFee']").val().length <= 0)
		// 	$("input[name='maxFee']").val("0")
		var focusTarget;
		$(".timeD").each(function(idx, item){
			if($(item).val() != parseInt($(item).val()) || $(item).val() < 0){
				focusTarget = item;
				return false;
			}
		});
		if(focusTarget!=null){
			$(focusTarget).focus();
			return false;
		}
		$(".timeH").each(function(idx, item){
			if($(item).val() < 0 || $(item).val() != parseInt($(item).val()) || $(item).val() >= 24){
				focusTarget = item;
				return false;
			}
		})
		if(focusTarget!=null){
			$(focusTarget).focus();
			return false;
		}
		$(".timeM").each(function(idx, item){
			if($(item).val() < 0 || $(item).val() != parseInt($(item).val()) || $(item).val() >= 60){
				focusTarget = item;
				return false;
			}
		})
		if(focusTarget!=null){
			$(focusTarget).focus();
			return false;
		}
		$("input[name='thingBidClosTimeMin']").val($("#thingBidClosTimeD").val()*24*60 + $("#thingBidClosTimeH").val()*60 + parseInt($("#thingBidClosTimeM").val()/10)*10);
		$("input[name='thingRebidClosTimeMin']").val($("#thingRebidClosTimeD").val()*24*60 + $("#thingRebidClosTimeH").val()*60 + parseInt($("#thingRebidClosTimeM").val()/10)*10);
		$("input[name='cntrwkBidClosTimeMin']").val($("#cntrwkBidClosTimeD").val()*24*60 + $("#cntrwkBidClosTimeH").val()*60 + parseInt($("#cntrwkBidClosTimeM").val()/10)*10);
		$("input[name='cntrwkRebidClosTimeMin']").val($("#cntrwkRebidClosTimeD").val()*24*60 + $("#cntrwkRebidClosTimeH").val()*60 + parseInt($("#cntrwkRebidClosTimeM").val()/10)*10);
		$("input[name='serviceBidClosTimeMin']").val($("#serviceBidClosTimeD").val()*24*60 + $("#serviceBidClosTimeH").val()*60 + parseInt($("#serviceBidClosTimeM").val()/10)*10);
		$("input[name='serviceRebidClosTimeMin']").val($("#serviceRebidClosTimeD").val()*24*60 + $("#serviceRebidClosTimeH").val()*60 + parseInt($("#serviceRebidClosTimeM").val()/10)*10);
		var disabled = $(":disabled").removeAttr("disabled");
		var param = $("#platformRegisterForm").serializeObject();
		disabled.attr("disabled", "disabled");

		var formData = new FormData;
		formData.append("content", new Blob([JSON.stringify(param)], {type: "application/json"}));
		if($("#logoImageFile").val() != ""){
			formData.append("logoImageFile", $("#logoImageFile")[0].files[0]);
		}
		$.ajax({
			type : "post",
			url : "/member/buyerGroup/updatePlatformInfo.json",
			contentType : false,
			processData : false,
			async : false,
			data: formData
		}).done(function(response){
			if(response.success){
				$("#jqGrid_1").jqGrid().trigger("reloadGrid");
				alert("저장되었습니다.");
				$("#platformDiv").popup("hide");
			}else{
				alert(response.message);
			}
		})

	})

	$("input[name='addressType']").change(function(){
		if($("input[name='addressType']:checked").val() != "10004"){
			//씨마켓 도메인 미선택
			$("input[name='platformId']").prop("disabled", true).val("");
			$("input[name='internetAddress']").prop("disabled", false);
		}else if($("input[name='addressType']:checked").val() != "10005"){
			$("input[name='internetAddress']").prop("disabled", true).val("");
			$("input[name='platformId']").prop("disabled", false);
		}
	})

	$("#maxFeeUseAt").change(function(){
		if($(this).prop("checked")){
			$("input[name='maxFee']").prop("disabled", false);
		}else{
			$("input[name='maxFee']").val("0").prop("disabled", true);
		}
	})

	$(".has-default").change(function(){
		var defaultSelect = $(this).closest("tr").find("select");

		var tmpStr = "<option value='' selected>기본값 설정</option>";
		$(this).closest("tr").find("input").each(function(idx, item){
			if($(item).prop("checked")){
				tmpStr += "<option value='"+$(item).val()+"'>"+$(this).closest("tr").find("label[for='"+$(item).attr("id")+"']").text()+"</option>";
			}
		})
		defaultSelect.html("").html(tmpStr);

	})

	function init_default(){
		$("select[name^='default']").each(function(idx, item){
			// $(item).html("").html("<option value='' selected>기본값 설정</option>");

			var tmpStr = "<option value=''>기본값 설정</option>";
			$(item).closest("tr").find(".has-default:checked").each(function(idx2, item2){
				tmpStr += "<option value='"+$(item2).val()+"' "+($(item2).data("default")=='Y'?'selected':'')+">"+$(this).closest("tr").find("label[for='"+$(item2).attr("id")+"']").text()+"</option>";
			})
			$(item).html("").html(tmpStr);
		})
	}

	$("#platformAddCodeButton").click(function(){
		$("#platformAddCodeDiv").css("position", "static");
		$("#platformAddCodeDiv").css("left", "0");
		$("#platformAddCodeSelect").resetForm();
		var postData_2 = {
			classification : $("#platformAddCodeSelect").val()
		};
		$("#jqGrid_2").jqGrid('setGridParam', {
			postData: JSON.stringify(postData_2)
		}).trigger("reloadGrid");
		$("#platformAddCodeDiv").popup({
			autoopen : true,
			escape : false,
			blur : false
		});
	})

	$("#platformAddCodeSelect").change(function(){
		$("#platformAddCodeTd").html("");

		var postData_2 = {
			classification : $("#platformAddCodeSelect").val()
		};
		$("#jqGrid_2").jqGrid('setGridParam', {
			postData: JSON.stringify(postData_2)
		}).trigger("reloadGrid");

	})

	$("#platformAddCodeButton2").click(function(){
		if($("#platformAddCodeSelect").val() == ""){
			alert("항목구분을 선택해 주세요.");
			return false;
		}

		if($("#platformAddCodeName").val().length <= 0){
			alert("항목이름을 입력해 주세요.");
			return false;
		}
		$.ajax({
			type : "post",
			url : "/commonCode/insertCommonCode.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify({
				classification : $("#platformAddCodeSelect").val(),
				codeName : $("#platformAddCodeName").val()
			})
		}).done(function(response){
			if(response.success){
				$("#platformAddCodeName").val("");
				var postData_2 = {
					classification : $("#platformAddCodeSelect").val()
				};
				$("#jqGrid_2").jqGrid('setGridParam', {
					postData: JSON.stringify(postData_2)
				}).trigger("reloadGrid");

			}else{
				alert(response.message);
			}
		})
	})

	function codeUseFixed(code, use, fixed){
		$.ajax({
			type : "post",
			url : "/commonCode/updateUseFixed.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify({
				commonCode : code,
				useAt : use,
			})
		}).done(function(response){
			if(response.success){
				var postData_2 = {
					classification : $("#platformAddCodeSelect").val()
				};
				$("#jqGrid_2").jqGrid('setGridParam', {
					postData: JSON.stringify(postData_2)
				}).trigger("reloadGrid");

			}else{
				alert(response.message);
			}
		})
	}

	$("#jqGrid_2").on("click", ".codeUseAt", function(){
		$.ajax({
			type : "post",
			url : "/commonCode/updateUseFixed.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify({
				commonCode : $(this).data("code"),
				useAt : $(this).prop("checked")?'Y':'N'
			})
		}).done(function(response){
			if(!response.success){
				alert(response.message);
				grid_reload2()
			}
		})
	})

	$("#jqGrid_2").on("click", ".codeFixedAt", function(){
		$.ajax({
			type : "post",
			url : "/commonCode/updateUseFixed.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify({
				commonCode : $(this).data("code"),
				fixedAt : $(this).prop("checked")?'Y':'N'
			})
		}).done(function(response){
			if(!response.success){
				alert(response.message);
				grid_reload2()
			}
		})
	})

	$("#jqGrid_2").on("click", ".changeSortNumber", function(){
		$.ajax({
			type : "post",
			url : "/commonCode/changeSortNumber.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify({
				commonCode : $(this).data("code"),
				change : $(this).data("change")
			})
		}).done(function(response){
			grid_reload2()
			if(!response.success){
				alert(response.message);
			}
		})
	})



	$(".close_popup").click(function(){
		$("#platformAddCodeDiv").popup("hide");
		location.reload();
	})
	$(".close_popup2").click(function(){
		$("#feeDiv").popup("hide");
	})

	function grid_reload(){
		$("#jqGrid_1").trigger("reloadGrid");
	}
	function grid_reload2(){
		$("#jqGrid_2").trigger("reloadGrid");
	}

	$("#jqGrid_2").on("click", ".codeName", function(e){
		e.preventDefault();
		$("#modCommonCode").val($(this).data("code"));
		$("#modCodeName").val($(this).text());
		$("#modCodeValue").val($(this).data("value"));
		$("#modCodeNameDiv").popup("show");
	})

	$("#modCodeButton").click(function(){
		$.ajax({
			type : "post",
			url : "/commonCode/updateCodeName.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify({
				commonCode : $("#modCommonCode").val(),
				codeName : $("#modCodeName").val(),
				codeValue : $("#modCodeValue").val()
			})
		}).done(function(response){
			grid_reload()
			if(response.success){
				alert("저장되었습니다.");
				$("#modCodeNameDiv").popup("hide");
				grid_reload2();
			}else{
				alert(response.message);
			}
		})
	})

	$("#feeSaveButton").click(function(){
		var param = $("#feeRateForm").serializeObject();
		var targetItem;
		$(".feeRate3").each(function(idx, item){
			if(!/^[0-9]{0,2}(\.[0-9]{1,3}){0,1}$/.test($(item).val())){
				targetItem = item;
				return false;
			}
		})
		if(targetItem != null){
			$(targetItem).focus();
			return false;
		}
		$(".maxFee3").each(function(idx, item){
			if(isNaN($(item).val())){
				targetItem = item;
				return false;
			}
		})
		if(targetItem != null){
			$(targetItem).focus();
			return false;
		}

		$.ajax({
			type : "post",
			url : "/member/buyerGroup/updateGroupFeeInfo.json",
			async : false,
			contentType: "application/json",
			dataType : "json",
			data : JSON.stringify(param)
		}).done(function(response){
			grid_reload()
			if(response.success){
				alert("수정되었습니다.");
				$("#jqGrid_3").jqGrid().trigger("reloadGrid");
			}else{
				alert(response.message);
			}
		})
	})

	$("#jqGrid_3").on("click", ".maxFeeUseAt3", function(){
		if($(this).prop("checked")){
			$(this).closest("tr").find(".maxFee3").prop("disabled", false).val($(this).closest("tr").find(".maxFee3").data("val"));
		}else{
			$(this).closest("tr").find(".maxFee3").prop("disabled", true).val("0");
		}
	})

	//플랫폼정보 - 로고이미지 클릭 or 마우스오버
	$("#logoImage").on("click mouseover", function(e){
		e.preventDefault();
		if($(this).text() == "(미등록)" || $(this).data("platformCode") == null)
			return false;
		$("#logoImageViewImg").prop("src", "/showImage/logo/"+$(this).data("platformCode"));
		$("#logoImageViewDiv").css({
			"top":e.pageY+10+"px",
			"left":e.pageX+10+"px"
		})
		$("#logoImageViewDiv").fadeIn(0);
	}).on("mouseout", function(){
		$("#logoImageViewDiv").fadeOut(0);
	}).on("mousemove", function(e){
		$("#logoImageViewDiv").css({
			"top":e.pageY+10+"px",
			"left":e.pageX+10+"px"
		})
	})

	function getRandomSecret(){
		$.ajax({
			type : "post",
			url : "/member/buyerGroup/getRandomSecret.json",
			async : false,
			contentType: "application/json",
			dataType : "json"
		}).done(function(response){
			if(response.success){
				$("#randomSecret_id").val(response.storeData.ID);
				$("#randomSecret_secret").val(response.storeData.Secret);
			}else{
				alert(response.message);
			}
		})
	}

</script>
</body>
</html>