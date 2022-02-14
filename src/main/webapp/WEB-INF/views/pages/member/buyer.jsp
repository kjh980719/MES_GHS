<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--<style type="text/css">
	.ui-jqgrid .ui-jqgrid-htable th div { height: 40px; font-size: 12px; }
	.ui-jqgrid tr.jqgrow td { height: 40px; font-size: 12px; }
</style>--%>
<style type="text/css" >
	.mjlist_tbl01 td {width:auto; padding:10px 0 10px 25px;border-bottom:1px solid #ededed;color:#333; font-size:12px;}
	.left_pt10 {border-right:1px #ededed solid; background:#fdfdfd}
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
<script>

	$(document).ready(function() {
		var colModel = [
			{ label : "<input type='checkbox' name='all' value='all' checked>", name : "check", align : "center", width : "8.3%", sortable : false},
			{ label : "API구매번호", name : "bid_puchase_no", align : "center", width : "8.3%", sortable : false},
			{ label : "구매사ID", name : "bid_branch_id", align : "center", width : "8.3%", sortable : false },
			{ label : "입찰기한", name : "bid_endde_dt", align : "center", width : "8.3%", sortable : false},
			{ label : "입찰방식", name : "bid_scsbid_mthd_txt", align : "center", width : "8.3%", sortable : false },
			{ label : "납품방식", name : "bid_dvyfg_mthd", align : "center", width : "8.3%", sortable : false },
			{ label : "납품기한", name : "bid_dvyfg_dt", align : "center", width : "8.3%", sortable : false},
			{ label : "결제방식", name : "exposureAreaType", align : "center", width : "8.3%", sortable : false },
			{ label : "결제기한", name : "paymentOncePrice", align : "center", width : "8.3%", sortable : false},
			{ label : "등록일시", name : "bid_rgsde", align : "center", width : "8.3%", sortable : false},
			{ label : "응찰결과", name : "bid_buy_join_count", align : "center", width : "8.3%", sortable : false},
			{ label : "상태", name : "sortNumber", align : "center", width : "8.3%", sortable : false},
			{ label : "관리", name : "bid_status", align : "center", width : "8.3%", sortable : false, formatter : APIFormat},
			//{ label : "카테고리", name : "sortNumber", align : "center", width : "8.3%", sortable : false}
		];

		var setPostData = {
			currentPage : 1,
			rowsPerPage : 15,
			searchKeyword : "all",
			searchText : ""
		};

		creatJqGrid("jqGrid_1", "/member/getBuyerList", colModel,  setPostData,  "paginate_1", "dataCnt_1", "rowsPerPage", "gridParent_1")

	});

  function pop_api_bid_entry(bidx){
    var apiUrl="/member/api";
    //var apiUrl="/b2b/admin/bid/cmarketapi_request_goods.asp?bidx="+bidx;
    var pop_api_bid=window.open(apiUrl,"_popApiEntryBid","width=850,height=950,top=0,left=100,scrollbars=1,resizable=1");
    pop_api_bid.focus();
  }
	  
  function APIFormat(cellvalue, options, rowObject){
	  return "<button class='btn_blue01_1 grid_platform_button' type='button' >입찰 신청</button>";
	  //return "<input type='button' class='btn_blue01_1' onclick='pop_api_bid_entry("+rowObject.bid_puchase_no+"); return false;' value='입찰 신청'/>";
  }
/*   function APIFormat(cellvalue, options, rowObject){
    return "<input type='button' style='width: 60px; height: 20px; line-height: 20px; display: inline-block; padding: 0px;' value=' 입찰 신청 ' "
    +"onclick='pop_api_bid_entry("+rowObject.bid_puchase_no+"); return false;' />"
  } */
  
  $("#jqGrid_1").on("click", ".grid_platform_button", function(){
    $("#platformRegisterForm").resetForm();
    $("input[name='groupCode']").val($(this).data("groupCode"));
    $("input[name='platformCode']").val($(this).data("platformCode"));

    if($(this).data("platformCode")>0){
      $.ajax({
        type : "post",
        url : "/member/apiRegister.json",
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
	
  $("#closeButton,#closeButton1").click(function(e){
    e.preventDefault();
    $("#platformDiv").popup("hide");
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
	  
	$(window).resize(function(){
		$("#jqGrid_1").setGridWidth($(this).width() - $(".sidenav").width() - 65);
	});
	  
</script>
</body>
</html>