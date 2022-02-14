<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<fmt:setBundle basename="application" var="properties" />
<%--<style type="text/css">
	.ui-jqgrid .ui-jqgrid-htable th div { height: 40px; font-size: 12px; }
	.ui-jqgrid tr.jqgrow td { height: 40px; font-size: 12px; }
</style>--%>
<style type="text/css" >
	.mjlist_tbl01 td {width:auto; padding:10px 0 10px 25px;border-bottom:1px solid #ededed;color:#333; font-size:12px;}
	.left_pt10 {border-right:1px #ededed solid; background:#fdfdfd}
	.circle{width:15px;height:15px;border-radius:50%;background-color:blue;display:inline-block}
</style>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko">
<head>
	<!-- #include virtual="/includes/header.asp"-->
</head>
<script>
	function pop_api_bid_entry(bidx){
    var apiUrl="/api.jsp";
    //var apiUrl="/b2b/admin/bid/cmarketapi_request_goods.asp?bidx="+bidx;
    var pop_api_bid=window.open(apiUrl,"_popApiEntryBid","width=850,height=950,top=0,left=100,scrollbars=1,resizable=1");
    pop_api_bid.focus();
  }
</script>
<body>
  
	<h3 class="mjtit_top">
		기본 상품등록

	</h3>

<!-- 리스트 시작-->
	<div class="pt10 posi_rel">
		<select name="rowsPerPage" id="rowsPerPage" class="left00 top15 sel_box">
			<option value="10">10개씩 보기</option>
			<option value="20">20개씩 보기</option>
			<option value="30">30개씩 보기</option>
			<option value="40">40개씩 보기</option>
			<option value="50">50개씩 보기</option>
		</select>
		<input type="checkbox" name="" id=""><label for="">가입일</label>
		<input type="text" name="" id=""> ~
		<input type="text" name="" id="">
		<select name="" id="">
			<option value="">전체</option>
			<option value="">가능</option>
			<option value="">정지</option>
			<option value="">대기</option>
		</select>
		<select name="" id="">
			<option value="">전체</option>
			<option value="">서울</option>
		</select>
		<select name="" id="">
			<option value="">업체명</option>
			<option value="">서울</option>
		</select>
		<input type="text" name="" id="">
		<button type="button">검색</button>
		<div>
			<div class="circle" id="api_check"></div>
			<span>API Server</span>
		</div>
	</div>
	<div id="gridParent_1" class="col">
			<table id="jqGrid_1" class="display" cellspacing="0" cellpadding="0"></table>

			총 <span class="number3 keyf06" id="dataCnt_1"></span> 개

			<div id="paginate_1" class="mjpaging_comm"></div>
	</div>
<!-- 리스트 끝-->
	<!-- 하단버튼-->
	<div class="bottom_mt30 align_rgt">
		<button type="button" class="btn_blue01 popLayergoodsRegisterButton">등록</button>
	</div>

  <%-- 그룹추가 --%>
  <div class="layer_win01" style="width:1000px;display: none;" id="platformDiv">
    <div>
      <div class="bigjtit_top">API 입찰 신청 등록</div>

      <h3 class="mjtit_top">
                  물품 정보
      </h3>
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
  
<%-- 상품 등록/수정 --%>
<div class="layer_win01" style="width:1000px; padding: 12px;display: none;" id="goodsRegister">
<div class="bigjtit_top">상품관리</div>
<h3 class="mjtit_top">
	<span class="mjbul mjbul_0001"></span>기본상품 등록/수정
</h3>

<!--  상품 등록-->
	<div class="top_mt10 bottom_mt20">
		<form action="" method="post" id="goodsRegisterForm" >
		<table cellpadding="0" cellspacing="0" class="mjlist_tbl01" >
			<caption>등록/수정 양식</caption>
			<tr>
				<th rowspan="24" scope="row">제휴상품</th>

				<td colspan="2" class="left_pt10 align_cen">상품코드</td>
				<td><span id="productCode"></span></td>
			</tr>
			<tr>
				<td colspan="2" class="left_pt10 align_cen">상품명</td>
				<td><input type="text" class="text_box01 w_30 firstFocus" placeholder="상품명을 입력해 주세요" name="productName" value=""/> </td>
			</tr>
			<tr>
				<td colspan="2" class="left_pt10 align_cen">상품설명</td>
				<td><textarea rows="2" cols="100" class="text_box01 w_30" placeholder="상품설명을 입력해 주세요" name="productDescription" style="resize : none"></textarea> </td>
			</tr>
			<tr>
				<td rowspan="3" class="left_pt10" style="width:10%">상품 이미지</td>
				<td class="left_pt10" style="width:10%">아이콘</td>
				<td style="width:70%">
					<a href="" class="right_mt20 product_image_name" id="productImageIconName"></a>
					<input type="file" name="productImageIcon" id="">
				</td>
			</tr>
			<tr>
				<td class="left_pt10">설명 (pc)</td>
				<td>
					<a href="" class="right_mt20 product_image_name" id="productImagePcName"></a>
					<input type="file" name="productImagePc">
				</td>
			</tr>
			<tr>
				<td class="left_pt10">설명 (mob)</td>
				<td>
					<a href="" class="right_mt20 product_image_name" id="productImageMobileName"></a>
					<input type="file" name="productImageMobile">
				</td>
			</tr>
			<tr>
				<td colspan="2" class="left_pt10 align_cen">구입대상</td>
				<td>
					<input type="radio" name="productBuyerTarget" value="A" /> <label class="right_mt20">빌리보드업체</label>
					<input type="radio" name="productBuyerTarget" value="B" /> <label class="right_mt20">미이용업체</label>
					<input type="radio" name="productBuyerTarget" value="C" /> <label>전체</label>
				</td>
			</tr>
			<tr>
				<td rowspan="2" class="left_pt10" style="width:10%">노출지역</td>
				<td class="left_pt10" style="width:10%">지역개수</td>
				<td style="width:70%">
					<input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="exposureAreaCount" value="" /> 개
				</td>
			</tr>
			<tr>
				<td class="left_pt10">노출지역</td>
				<td>
					<input type="radio" name="exposureAreaType" value="A" /> <label class="right_mt20">시/도</label>
					<input type="radio" name="exposureAreaType" value="B" /> <label class="">시/군/구</label>
				</td>
			</tr>
			<tr>
				<td rowspan="2" class="left_pt10">할인쿠폰</td>
				<td class="left_pt10">쿠폰매수</td>
				<td>
					<input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="couponCount" value=""/> 매 / 월
					<input type="checkbox"  class="left_mt20" value="Y" id="maxCouponCount" />
					<label class="right_mt20">무제한</label>
				</td>
			</tr>
			<tr>
				<td class="left_pt10">쿠폰발행지역</td>
				<td>
					<input type="radio" name="couponAreaType" value="A" /> <label class="right_mt20">시/도</label>
					<input type="radio" name="couponAreaType" value="B" /> <label class="">시/군/구</label>
				</td>
			</tr>
			<tr>
				<td rowspan="3" class="left_pt10">DM</td>
				<td class="left_pt10">발송회수</td>
				<td><input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="dmSendCount" value=""/> 회 / 월</td>
			</tr>
			<tr>
				<td class="left_pt10">발송지역</td>
				<td>
					<input type="radio" name="dmSendAreaType" value="A" /> <label class="right_mt20">시/도</label>
					<input type="radio" name="dmSendAreaType" value="B" /> <label class="right_mt20">시/군/구</label>
					<input type="radio" name="dmSendAreaType" value="C" /> <label>읍/면/동</label>
				</td>
			</tr>
			<tr>
				<td class="left_pt10">발송대상</td>
				<td>
					<input type="radio" name="dmSendTarget" value="A" /> <label class="right_mt20">전체</label>
					<input type="radio" name="dmSendTarget" value="B" /> <label class="right_mt20">마이클럽</label>
					<input type="radio" name="dmSendTarget" value="C" /> <label>무소속</label>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="left_pt10 align_cen">이벤트</td>
				<td>
					<input type="checkbox" name="ynEventCoupon" value="Y" /> <label class="right_mt20">할인쿠폰 이벤트</label>
					<input type="checkbox" name="ynEventAttend" value="Y" /> <label class="right_mt20">출석이벤트</label>
					<input type="checkbox" name="ynEventStamp" value="Y" /> <label class="right_mt20">응원스템프</label>
					<input type="checkbox" name="ynEventRoullette" value="Y" /> <label>패자룰렛</label>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="left_pt10 align_cen">피플코인</td>
				<td><input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="peoplecoinInGame" value=""/> 코인 / 1게임</td>
			</tr>
			<tr>
				<td class="left_pt10">적립금</td>
				<td class="left_pt10">쇼핑몰 적립금</td>
				<td>
					<input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="mallBuySaving" value=""/> 원 / 월
					<span class="right_mt20"></span>
					<input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="gradDscnt" value=""/> %
				</td>
			</tr>
			<tr>
				<td rowspan="2" class="left_pt10">상품금액</td>
				<td class="left_pt10">1회 결제</td>
				<td><input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="paymentOncePrice" value=""/> 원 (VAT 포함)</td>
			</tr>
			<tr>
				<td class="left_pt10">카드 정기결제</td>
				<td><input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="automaticPaymentPrice" value=""/> 원 (VAT 포함)</td>
			</tr>
			<tr>
				<td rowspan="2" class="left_pt10">피플배너</td>
				<td class="left_pt10">기본배너</td>
				<td>
					<input type="radio" name="ynBasicBanner" value="Y" /> <label class="right_mt20">제공</label>
					<input type="radio" name="ynBasicBanner" value="N" /> <label>미제공</label>
				</td>
			</tr>
			<tr>
				<td class="left_pt10">메인배너</td>
				<td>
					<input type="radio" name="ynMainBanner" value="Y" /> <label class="right_mt20">제공</label>
					<input type="radio" name="ynMainBanner" value="N" /> <label>미제공</label>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="left_pt10 align_cen">클럽미니홈피</td>
				<td>
					<input type="radio" name="clubHomeType" value="B" /> <label class="right_mt20">기본형 미니홈피</label>
					<input type="radio" name="clubHomeType" value="C" /> <label class="right_mt20">고급형 미니홈피</label>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="left_pt10 align_cen">클럽번개 개수</td>
				<td>
					<input type="text" class="text_box01 w_10 align_rgt" placeholder="0" name="clubGatheringCount" value=""/> 회
					<input type="checkbox"  class="left_mt20" id="maxClubGatheringCount"/>
					<label class="right_mt20">무제한</label>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="left_pt10 align_cen" >상품 노출여부</td>
				<td>
					<input type="radio" name="ynProductExposure" value="Y" /> <label class="right_mt20">노출</label>
					<input type="radio" name="ynProductExposure" value="N" /> <label>미노출</label>
				</td>
			</tr>
		</table>
			<input type="hidden" name="productSeq">
		</form>
	</div>
	<!-- 하단버튼 -->
	<div class="bottom_mt30 align_rgt">
		<!-- 상품명 클릭시 클릭시 -->
		<button type="button" class="btn_blue01" id="goodsModifyButton" >수정</button>
		<!-- 등록버튼 클릭시 -->
		<button type="button" class="btn_blue01" id="goodsRegisterButton">등록</button>
		<button type="button" class="btn_gray01" id="goodsCloseButton">닫기</button>

	</div>

</div>
<div class="layer_win01" style="padding: 12px;display : none;position:absolute;max-width:1000px;max-height:1000px;z-index:2100000000" id="productImageDiv">
	<img src="" alt="product Image" style="width:100%;height:100%" id="productImageView">
</div>
<div class="pop_box">
	<iframe src="about:blank" frameborder="0" id="popFrame"></iframe>
</div>
<script>

	$(document).ready(function() {
		var colModel = [
			{ label : "입찰번호", name : "buy_idx", align : "center", width : "10%", sortable : false, formatter : buyIdxFormat},
			{ label : "구매사ID", name : "member_id", align : "center", width : "7%", sortable : false },
			{ label : "구분", name : "bid_endde_dt", align : "center", width : "8.3%", sortable : false},
			{ label : "유형", name : "bid_scsbid_mthd_txt", align : "center", width : "8.3%", sortable : false },
			{ label : "입찰기한", name : "buy_e_day", align : "center", width : "8.3%", sortable : false, formatter : gridDateFormat },
			{ label : "입찰방식", name : "buy_method", align : "center", width : "4%", sortable : false, formatter : buyMethodFormat},
			{ label : "납품방식", name : "buy_deli_method", align : "center", width : "6%", sortable : false, formatter : buyDeliMethodFormat },
			{ label : "납품기한", name : "buy_deli_day", align : "center", width : "8.3%", sortable : false},
			{ label : "결제방식", name : "buy_paymethod", align : "center", width : "4%", sortable : false},
			{ label : "결제기한", name : "buy_payday", align : "center", width : "4%", sortable : false},
			{ label : "등록일시", name : "buy_date", align : "center", width : "8.3%", sortable : false, formatter : gridDateFormat},
			{ label : "낙찰번호<br>수신일시", name : "", align : "center", width : "8.3%", sortable : false},
			{ label : "씨마켓반영여부<br>반영일시", name : "", align : "center", width : "8.3%", sortable : false},
			{ label : "검수일시", name : "", align : "center", width : "8.3%", sortable : false},
			{ label : "응찰결과<br>(전송/응찰)", name : "", align : "center", width : "5%", sortable : false, formatter : sendFormat},
			{ label : "상태", name : "status", align : "center", width : "8.3%", sortable : false, formatter : statusFormat},
			{ label : "관리", name : "", align : "center", width : "8.3%", sortable : false, formatter : apiFormat}
		];

		var setPostData = {
			currentPage : 1,
			rowsPerPage : $("#rowsPerPage").val(),
			searchKeyword : "all",
			searchText : ""
		};

		creatJqGrid("jqGrid_1", "/bid/getApiBidList", colModel,  setPostData,  "paginate_1", "dataCnt_1", "rowsPerPage", "gridParent_1")
		api_check()
	});
	//일시 형식,(시간 줄바꿈)
	function gridDateFormat(cellvalue, options, rowObject){
		return "<strong>"+cellvalue.replace(" ", "</strong><br>");
	}
	//입찰방식
	function buyMethodFormat(cellvalue, options, rowObject){
		if(cellvalue == 'N'){
			return "전자입찰";
		}else if(cellvalue == 'Y'){
			return "역경매";
		}
	}
	//납품방법
	function buyDeliMethodFormat(cellvalue, options, rowObject){
		if(cellvalue == 'A'){
			return "택배가능";
		}else if(cellvalue == 'B'){
			return "직접납품";
		}else if(cellvalue == 'C'){
			return "납품 및 설치";
		}
	}
	function statusFormat(cellvalue, options, rowObject){
		if(cellvalue == 'A'){
			return "<strong style='color:#000000;'>진행중</strong>";
		}else if(cellvalue == 'B'){
			return "<strong style='color:#000000;'>낙찰대기</strong>";
		}else if(cellvalue == 'C'){
			return "<strong style='color:green;'>낙찰</strong>";
		}else if(cellvalue == 'D'){
			return "<strong style='color:green;'>낙찰</strong>"
		}else if(cellvalue == 'E'){
			return "<strong style='color:red;'>유찰</strong>"
		}else if(cellvalue == 'R'){
			return "<strong style='color:blue;'>승인대기</strong>"
		}else if(cellvalue == 'X'){
			return "<strong style='color:#000000;'>입찰취소</strong>"
		}
	}
	function pop_api_bid_entry(bidx){
		var apiUrl="/member/api";
		var pop_api_bid=window.open(apiUrl,"_popApiEntryBid","width=850,height=950,top=0,left=100,scrollbars=1,resizable=1");
		pop_api_bid.focus();
	}

	function buyIdxFormat(cellvalue, options, rowObject){
		return cellvalue+(rowObject.bid_puchase_no==null?"":"<br>("+rowObject.bid_puchase_no+")");
	}

	function sendFormat(cellvalue, options, rowObject){
		return rowObject.sendCount+" / "+rowObject.joinCount+(rowObject.api_send_date==null?"":rowObject.api_send_date);
	}
	function apiFormat(cellvalue, options, rowObject){
		if(rowObject.status == "R")
			return "<button class='btn_blue01_1 grid_api_button' type='button' data-bidx='"+rowObject.buy_idx+"' >입찰 신청</button>";
		return "";
	}
	$("#jqGrid_1").on("click", ".grid_api_button", function(){
		var apiUrl="/bid/apiRequestGoods?bidx="+$(this).data("bidx");
		var test_req_go=window.open(apiUrl,"_popApiEntryBid","width=850,height=950,top=0,left=100,scrollbars=1,resizable=1");
	})

	$("#closeButton,#closeButton1").click(function(e){
		e.preventDefault();
		$("#platformDiv").popup("hide");
	})

	function init_default(){
		$("select[name^='default']").each(function(idx, item){
			var tmpStr = "<option value=''>기본값 설정</option>";
			$(item).closest("tr").find(".has-default:checked").each(function(idx2, item2){
				tmpStr += "<option value='"+$(item2).val()+"' "+($(item2).data("default")=='Y'?'selected':'')+">"+$(this).closest("tr").find("label[for='"+$(item2).attr("id")+"']").text()+"</option>";
			})
			$(item).html("").html(tmpStr);
		})
	}
	function grid_reload(){
		$("#jqGrid_1").trigger("reloadGrid");
	}

	$(window).resize(function(){
		$("#jqGrid_1").setGridWidth($(this).width() - $(".sidenav").width() - 65);
	});

	function api_check(){
		$("#api_check").css("background-color", "blue");
		$.ajax({
			type : "post",
			url : "/bid/apiCheck"
		}).done(function(response){
			console.log(response)
			if(response.storeData == "online"){
				$("#api_check").css("background-color", "green");
			}else{
				$("#api_check").css("background-color", "red");
			}
		})
	}
	$("#api_check").click(api_check)


</script>
</body>
</html>