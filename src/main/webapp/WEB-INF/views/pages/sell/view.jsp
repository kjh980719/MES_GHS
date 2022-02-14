<%@page import="com.fasterxml.jackson.annotation.JacksonInject.Value"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript">
$(document).ready(function() {
    var setCalendarDefault = function() {
        $("#startDate").datepicker();
        $("#startDate").datepicker('setDate', '-1Y');
        $("#endDate").datepicker();
        $("#endDate").datepicker('setDate', 'today');
    }

	$(".resetFormBtn").click(function(){
		$("input[name=DIVISION_SEQ]").val(""); 
	    $('#searchForm').resetForm();
	    setCalendarDefault();
        searchmaterialList();  
	});

	$(".searchproductBtn").click(function(){
	    searchmaterialList();
	});

	$(".selectSearch").change(function(){
	    searchmaterialList();
	});

	$(".enterSearch").keydown(function(event){
	    if (event.keyCode == 13){
	        searchmaterialList();
	    }
	});

	
	//검색후 page 설정하여 띄우기	
    var searchmaterialList = function () {
		
    	var postData = $("#searchForm").serializeObject();
		postData.currentPage = 1;
        postData.rowsPerPage = $("#rowPerPage_1").val();
        
        console.log("검색 :" + postData.REMARKS_WIN);
        $("#jqGrid_1").jqGrid('setGridParam', {
            postData: JSON.stringify(postData)
        }).trigger("reloadGrid");
    }
    
    $(".registProductBtn").click(function(){
	    registProduct();
	    console.log("실행");
	});

	var registProduct = function () {
	    var targetUrl = "/product/createProduct.json";
	    if($("#ProductRegistForm input[name='rowIndex']").val() != "")
	        targetUrl = "/product/updateProduct.json";
	    
		if(checkProductValid() && confirm("저장 하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".registProductBtn").off("click");
			var param = $("#ProductRegistForm").serializeObject();
			$.ajax({
				type : "post",
				url : targetUrl,
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify(param)
			}).done(function(response) {
				if (response.success) {
					alert("저장되었습니다.");
					$("#jqGrid_1").jqGrid().trigger("reloadGrid");
		            $('#ProductRegist').popup("hide");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#ProductRegistForm input[name='"+response.code+"']").focus();
				}
    			$(".registProductBtn").on("click", function(){registProduct();});
			});
		}
	}
	
	var checkProductValid = function () {
	    var valid = true;
   		$.each($("#ProductRegistForm .required"), function(){
            if($(this).val() == '') {
	            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
    			$(this).focus();
    			valid = false;
    			return false;
            }
        });
        if(valid) {
             if($('#ProductRegistForm input[name="PROD_CD"]').val() == "") {
                //수정시 패스워드 변경
                if(!checkPassword($("#ProductRegistForm input[name='PROD_CD']").val())) {
                    alert("품목코드를 입력해주세요");
                    $("#ProductRegistForm input[name='PROD_CD']").focus();
                    return false;
                }
             
            }
           
        }
	    return valid;
	}
    
    
	setCalendarDefault();
    var colModel = [
        {label: "No", name:"rowIndex", align: "center", width: "10%", sortable: false},
        {label: "품목 코드", name:"PROD_CD", align: "center", width: "10%", sortable: false,},
        {label: "품목명", name:"PROD_DES", align: "center", width: "10%", sortable: false,},
        {label: "품목구분", name:"PROD_TYPE", align: "center", width: "10%", sortable: false,formatter : PTYPEFormat},
        {label: "규격명", name:"SIZE_DES", align: "center", width: "10%", sortable: false},
        {label: "그룹명", name:"CAT_CD", align: "center", width: "10%", sortable: false},
        {label: "검색창내용", name:"REMARKS_WIN", align: "center", width: "10%", sortable: false},
        {label: "사용여부", name:"USE_YN", align: "center", width: "10%", sortable: false,formatter : useYnFormat},
        {label: "파일관리", name:"File", align: "center", width: "10%", sortable: false}
    ];

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log("페이지 처음 들어왔을 때 : " + postData.REMARKS_WIN);
    creatJqGrid("jqGrid_1", "/product/getProductGroupList", colModel,  postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");

    //관리자 신규등록 버튼 클릭
 	$(".popLayerproductRegistBtn").click(function(){
		$("#ProductRegistForm input[name='productSeq']").val("");
		$('#ProductRegistForm input[name="productId"]').prop('readonly', false);
		$('#ProductRegistForm #changePasswordBtn').hide();
		$('#ProductRegistForm .changePasswordSpan').hide();
		$('#ProductRegistForm input[name="password"]').show();
	    $('#ProductRegistForm').resetForm();
        $('#ProductRegist').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#ProductRegist .firstFocus').focus();
            }
        });
		$('#ProductRegist').popup("show");
		$('#actionText').text("제품 등록");
	}); 

    //관리자 수정을 위해 row 클릭시
     $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
        	var row = $(this).getRowData(id);
        	var PCD=Object.values(row)[1];
        	var rowdata;
            $('ul.tabs li').removeClass('current');
    		$('.tab-content').removeClass('current');
    		$($('ul.tabs li')[0]).addClass('current');
    		$("#tab-1").addClass('current');
            $('#ProductRegistForm').resetForm();
            $.ajax({
				type : "post",
				url : '/product/selectProduct',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"CODE": PCD}),
				success : function(data) {
					 rowdata=data.storeData;
	
                    		 
                    }
			});
            console.log(rowdata);
			$('#ProductRegistForm input[name="PROD_CD"]').prop('readonly', true);
			$('#ProductRegistForm #CheckBtn').hide();
		    $('#actionText').text("관리자 수정");
            $('#ProductRegist').popup({
                focuselement: "secondFocus",
                onopen: function() {
                    $('#productRegist .secondFocus').focus();
                }
            });
            $('#ProductRegist').popup("show");
			setTableText(rowdata, "ProductRegistForm");
        }
    }); 

    //수정시 비번 변경 버튼 클릭
	$("#ProductRegistForm #changePasswordBtn").click(function(){
		$('#ProductRegistForm .changePasswordSpan').show();
		$('#ProductRegistForm input[name="changePasswordYn"]').val("Y");
	});
})
   
function useYnFormat(cellValue, option, rowObject){
    	console.log("formatter");
    	return cellValue==1?'Y':'N';
   }
   
function CATFormat(cellValue, option, rowObject){
	console.log("formatter");
	return cellValue=='B'?'유축기':cellValue=='P'?'젖병':cellValue=='S'?'석션기':'';
}
function PTYPEFormat(cellValue, option, rowObject){
	console.log("formatter");
	return cellValue==1?'제품':'상품';
}

function myFunction(x) {
	 
    var fileValue = $("input[name='DIVISION']").length;
    var fileData = new Array(fileValue);
    for(var i=0; i<fileValue; i++){                          
         fileData[i] = $("input[name='DIVISION']")[i].value;
    }
}

function setSearchDivision(){
	var DIVISION_SEQ = "";
	$.each($("select[id^='select_group_code1']"), function(idx, item){
		DIVISION_SEQ += $(item).val();
		
	})
	console.log(DIVISION_SEQ);
	$("input[name=DIVISION_SEQ]").val(DIVISION_SEQ);
}

function setSearchDivision2(){
	var DIVISION_SEQ = "";
	$.each($("select[id^='select_group_code2']"), function(idx, item){
		DIVISION_SEQ += $(item).val();
		
	})
	console.log(DIVISION_SEQ);
	$("input[name=DIVISION_SEQ]").val(DIVISION_SEQ);
}

function setSearchDivision2(){
	$.each($("select[id^='select_group_code2']"), function(idx, item){
		DIVISION_SEQ += $(item).val();
		
	})
	console.log(DIVISION_SEQ);
	$("input[name=DIVISION_SEQ]").val(DIVISION_SEQ);
}

$(".ProductRegist_close").click(function(e){
         
     window.close();  
         
   
});

$(document).ready(function(){
	
	$('ul.tabs li').click(function(){
		var tab_id = $(this).attr('data-tab');
	    console.log(this);
		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	})

});

$(document).ready(function(){
	$('span[id=TAX]').hide();
    // 라디오버튼 클릭시 이벤트 발생
    $("input:radio[name=VAT_YN]").click(function(){
 
        if($("input[name=VAT_YN]:checked").val() == "Y"){
        	$('span[id=TAX]').show();
            // radio 버튼의 value 값이 1이라면 활성화
 
        }else if($("input[name=VAT_YN]:checked").val() == "N"){
        	$('span[id=TAX]').hide();
            // radio 버튼의 value 값이 0이라면 비활성화
        }
    });
});

$(document).ready(function(){
	$('span[id=VAT_RATE_BY]').hide();
    // 라디오버튼 클릭시 이벤트 발생
    $("input:radio[name=VAT_RATE_BY_BASE_YN]").click(function(){
 
        if($("input[name=VAT_YN]:checked").val() == "Y"){
        	$('span[id=VAT_RATE_BY]').show();
            // radio 버튼의 value 값이 1이라면 활성화
 
        }else if($("input[name=VAT_RATE_BY_BASE_YN]:checked").val() == "N"){
        	$('span[id=VAT_RATE_BY]').hide();
            // radio 버튼의 value 값이 0이라면 비활성화
        }
    });
});

$(document).ready(function(){
	$('input[name=SAMPLE_PERCENT]').hide();
    // 라디오버튼 클릭시 이벤트 발생
    $("input:radio[name=INSPECT_STATUS]").click(function(){
 
        if($("input[name=INSPECT_STATUS]:checked").val() == "S"){
        	$('input[name=SAMPLE_PERCENT]').show();
            // radio 버튼의 value 값이 1이라면 활성화
 
        }else if($("input[name=INSPECT_STATUS]:checked").val() == "L"){
        	$('input[name=SAMPLE_PERCENT]').hide();
            // radio 버튼의 value 값이 0이라면 비활성화
        }
    });
});







</script>
<style>



		ul.tabs{
			margin: 0px;
			padding: 0px;
			list-style: none;
		}
		ul.tabs li{
			background: none;
			color: #222;
			display: inline-block;
			padding: 10px 15px;
			cursor: pointer;
		}

		ul.tabs li.current{
			background: #ededed;
			color: #222;
		}

		.tab-content{
			display: none;
			background: #ededed;
			padding: 15px;
		}

		.tab-content.current{
			display: inherit;
		}
</style>

					<h3 class="mjtit_top">
						판매내역조회
					</h3>
        <!--  관리자  검색시작-->
                    <div class="top_mt10 bottom_mt20">
                    <form id="searchForm" onsubmit="return false">
                    <table cellpadding="0" cellspacing="0" class="mjlist_tbl01">
                  <caption>관리자 양식</caption>
<%--                         <tr>
                            <th scope="row">권한</th>
                            <td class="left_pt10">
                                <select name="authGroupSeq" class="sel_box w_228 selectSearch">
	                            <c:forEach var="authGroup" items="${authGroupList}" varStatus="status">
									<option value="${authGroup.authGroupSeq}">${authGroup.authGroupName}</option>
								</c:forEach>
                                </select>
                            </td>
                            <th scope="row">등록일자</th>
                            <td class="left_pt10">
                                <input type="text" class="text_box01 m_pointer w_20" id="startDate" name="startDate"/> <span class="keyf08 left_mt10 right_mt5">~</span> <input type="text" class="text_box01 m_pointer w_20" id="endDate" name="endDate"/>
                            </td>
                        </tr> --%>
                        <tr>
                            <th scope="row">사용여부</th>
                            <td colspan="4" class="left_pt10">
                                <select name="USE_YN" class="sel_box selectSearch">                                  
                                    <option value="1">사용</option>
                                    <option value="0">미사용</option>
                                </select>
                            </td>
                            <th scope="row">그룹코드</th>
                            <td colspan="4" class="left_pt10">
                                
                                <select name="CAT_CD" class="sel_box ">                          
                                    <option value="">전체</option>
                                    <c:forEach var="CATGORY" items="${CategoryList}">
                                    <option value="${CATGORY.CAT_CD}">${CATGORY.CAT_NAME}</option>
                                    </c:forEach>
                                </select>
                                <c:forEach var="GroupCD" items="${ProductGroupCDList}" varStatus="status">
                                <select id="select_group_code1${status.index}" name="${GroupCD.GROUP_NAME}" class="sel_box " onchange="setSearchDivision()">                                  
                                    <option value="_">전체</option>
                                    <c:forEach var="DvisionValue" items="${DivisionList}">
                                    <c:if test="${GroupCD.GROUP_CODE eq DvisionValue.GROUP_CODE}">
                                    <option value="${DvisionValue.DIVISION_CODE}">${DvisionValue.DIVISION_NAME}</option>
                                    </c:if>
                                    </c:forEach>
                                </select>
                                
                               	
                                </c:forEach>
                                <input type="hidden" name="DIVISION_SEQ" value="" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">검색</th>
                            <td colspan="4" class="left_pt10">
                                <input type="text" class="text_box01 w_30 enterSearch" name="REMARKS_WIN" />
                            </td>
                        </tr>
                    </table>
                    </form>
                            <!-- 검색 버튼-->
                            <div class="align_cen pt20">
                                    <button type="button" class="btn_gray01_2 resetFormBtn">초기화</button>
                                    <button type="button" class="btn_blue01 searchproductBtn" >검색</button>
                            </div>

                    </div><!-- 검색  끝-->


<!-- 리스트 시작-->
                    <div class="mjinput">
											<div class="mjLeft">
												총 <span id="dataCnt_1" class="number3 keyf06"> </span> 건
											</div>
											<div class="mjRight">
						<select name="" id="rowPerPage_1" class=" sel_box">
                            <option value="15">15개씩 보기</option>
                            <option value="30">30개씩 보기</option>
                            <option value="50">50개씩 보기</option>
                            <option value="100">100개씩 보기</option>
                        </select>
											</div>
                        
                    </div>
                    <div class="col" id="gridParent_1">
                    <table id="jqGrid_1" class="display" cellspacing="0" cellpadding="0"></table>
                    <div id="paginate_1" class="mjpaging_comm" style="margin-top: 32px; margin-bottom: 42px"></div>
                    </div>
<!-- 리스트 끝-->
                     <!--하단버튼-->
            
                   <!-- <ul class="mt15">
                    	<li>ㆍ노출순서를 변경하시고 "노출순서 변경"울 클릭하셔야 프론트에 반영이 됩니다.</li>
                    	<li>ㆍ사용하지 않는 메인배너는 미노출로 전환하시기 바랍니다.</li>
                    </ul> -->

<!-- 관리자 등록 contents -->
				<div class="layer_win01" style="width:800px;display: none;" id="ProductRegist">
					<div>
						<form id="ProductRegistForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">제품 등록</span>
								<input type="hidden" id="rowIndex"/>
												</h3>
							
    <ul class="tabs">
		<li class="tab-link current" data-tab="tab-1">기본</li>
		<li class="tab-link" data-tab="tab-2">품목정보</li>
		<li class="tab-link" data-tab="tab-3">수량</li>
		<li class="tab-link" data-tab="tab-4">단가</li>
		<li class="tab-link" data-tab="tab-5">원가</li>
		<li class="tab-link" data-tab="tab-6">부가정보</li>
		<li class="tab-link" data-tab="tab-7">관리대상</li>
	</ul>

	<div id="tab-1" class="tab-content current">
	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 제품 등록 양식</caption>
								<tr>
									<th scope="row">제품코드 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="PROD_CD" class="text_box01 w_80  firstFocus required" placeholder="제품코드 입력" alt="제품코드"/>
									<button id="CheckBtn" class="btn_blue01" onclick="PDTCHECK()">중복체크</button></td>
								</tr>
								<tr>
									<th scope="row">제품이름 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="PROD_DES" class="text_box01 w_98  secondFocus" placeholder="제품이름 입력" alt="제품이름"/></td>
								</tr>
								<tr>
									<th scope="row">규격 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="SIZE_FLAG"  value="1" checked="checked"/>규격명
									<input type="radio" name="SIZE_FLAG"  value="2"/>규격그룹
									<input type="radio" name="SIZE_FLAG"  value="3"/>규격계산
									<input type="radio" name="SIZE_FLAG"  value="4"/>규격계산그룹
									<input type="text" name="SIZE_DES" class="text_box01 w_98 " placeholder="규격" alt="규격" /></td>
								</tr>
								<tr>
									<th scope="row">단위 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="UNIT" class="text_box01 w_98 " placeholder="단위" alt="단위" /></td>
								</tr>
								<tr>
									<th scope="row" rowspan="3">품목구분 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="PROD_TYPE" value="0"/>원재료
									<input type="radio" name="PROD_TYPE"  value="4"/>부재료
									<input type="radio" name="PROD_TYPE"  value="1"/>제품
									<input type="radio" name="PROD_TYPE"  value="2"/>반제품
									<input type="radio" name="PROD_TYPE"  value="3" checked="checked"/>상품
									<input type="radio" name="PROD_TYPE"  value="7"/>무형상품
									</td>
									
								</tr>
								<tr>
									<td class="left_pt10" style="width:80%">세트여부
									<input type="radio" name="SET_FLAG"  value="1"/>사용
									<input type="radio" name="SET_FLAG"  value="0" checked="checked"/>사용안함
									</td>
									
								</tr>
								<tr>
									<td class="left_pt10" style="width:80%">재고수량관리
									<input type="radio" name="BAL_FLAG"  value="1"/>사용
									<input type="radio" name="BAL_FLAG"  value="0" checked="checked"/>사용안함
									</td>
									
								</tr>
								<tr>
									<th scope="row">생산공정 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="WH_CD" class="text_box01 w_98 " placeholder="생산공정" alt="생산공정" />
									</td>
									
								</tr>
								<tr>
									<th scope="row">부가세율(매출) </th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="VAT_YN" value="N" checked="checked"/>기본설정
									<input type="radio" name="VAT_YN" value="Y"/>직접입력
									<span id="TAX">
									<input type="text" name="TAX" class="text_box01 w_70 " value="0" placeholder="부가세율(매출)" alt="출고단가" />%
									</span>
									</td>
									
								</tr>
								<tr>
									<th scope="row">부가세율(매입) </th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="VAT_RATE_BY_BASE_YN" value="N" checked="checked"/>기본설정
									<input type="radio" name="VAT_RATE_BY_BASE_YN" value="Y"/>직접입력
									<span id="VAT_RATE_BY">
									<input type="text" name="VAT_RATE_BY" class="text_box01 w_70 " value="0" placeholder="부가세율(매입)" alt="출고단가" />%</span>
									</td>
								</tr>
								<tr>
									<th scope="row">구매처 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CUST" class="text_box01 w_80 " placeholder="구매처" alt="구매처" />
									</td>
								</tr>
								<tr>
									<th scope="row">바코드 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="BAR_CODE" class="text_box01 w_80 " placeholder="바코드" alt="바코드" />
									</td>
								</tr>
								<tr>
									<th scope="row">검색창내용 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="REMARKS_WIN" class="text_box01 w_80 " placeholder="검색창내용" alt="검색창내용" />
									</td>
								</tr>
								<tr>
									<th scope="row">품목공유여부 </th>
									<td class="left_pt10" style="width:80%">
									<input type="checkbox" name="CS_FLAG"/>CS공유
									</td>
								</tr>
								<tr>
									<th scope="row">이미지 </th>
									<td class="left_pt10" style="width:80%">
								
									</td>
								</tr>
								<tr>
									<th scope="row">품목계층그룹 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="PROD_LEVEL_GROUP" class="text_box01 w_80 " placeholder="품목계층그룹" alt="품목계층그룹" />
									</td>
								</tr>
							</table>
												</div>
												</div>
<div id="tab-2" class="tab-content">
 <div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 제품 등록 양식</caption>
								<tr>
									<th scope="row">사용여부 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
																		<select name="USE_YN" class="sel_box w_15">
																				<option value="1">사용</option>
																				<option value="0">미사용</option>
																		</select>
																</td>
								</tr>
								<tr>
									<th scope="row">품목그룹1 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<select name="CAT_CD" class="sel_box ">                          
                                    <c:forEach var="CATGORY" items="${CategoryList}">
                                    <option value="${CATGORY.CAT_CD}">${CATGORY.CAT_NAME}</option>
                                    </c:forEach>
                                </select>
																		
								<c:forEach var="GroupCD2" items="${ProductGroupCDList}" varStatus="status2">
                                <select id="select_group_code2${status2.index}" name="${GroupCD2.GROUP_NAME}2" class="sel_box " onchange="setSearchDivision2()">                                  
                                    <c:forEach var="DvisionValue2" items="${DivisionList}">
                                    <c:if test="${GroupCD2.GROUP_CODE eq DvisionValue2.GROUP_CODE}">
                                    <option value="${DvisionValue2.DIVISION_CODE}">${DvisionValue2.DIVISION_NAME}</option>
                                    </c:if>
                                    </c:forEach>
                                </select>
                                </c:forEach>
                                <input type="hidden" name="DIVISION_SEQ" value="" />
									</td>
								</tr>
								<tr>
									<th scope="row">품목그룹2 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CLASS_CD2" class="text_box01 w_80 " placeholder="품목그룹2" alt="품목그룹2"/>
																</td>
								</tr>
								<tr>
									<th scope="row">품목그룹3 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CLASS_CD3" class="text_box01 w_80 " placeholder="품목그룹3" alt="품목그룹3"/>
																</td>
								</tr>
								<tr>
									<th scope="row">적요</th>
									<td class="left_pt10" style="width:80%;">
									<textarea name="REMARKS" class="text_box01 w_98" placeholder="적요" ></textarea></td>
								</tr>
								<tr>
									<th scope="row">품질검사유형</th>
									<td class="left_pt10" style="width:80%;">
									<input type="text" name="INSPECT_TYPE_CD" class="text_box01 w_98" placeholder="품질검사유형" />
									</td>
								</tr>
								<tr>
									<th scope="row">품질검사방법</th>
									<td class="left_pt10" style="width:80%;">
									<input type="radio" name="INSPECT_STATUS" value="L" checked="checked"/>전수
									<input type="radio" name="INSPECT_STATUS" value="S"/>샘플링(%)
									<input type="text" name="SAMPLE_PERCENT" style = "margin-left:33px; text-align:right;" class="text_box01 w_70" value="0" placeholder="품질검사방법" />
									</td>
								</tr>
								<tr>
									<th scope="row">적요</th>
									<td class="left_pt10" style="width:80%;">
									<textarea name="REMARKS" class="text_box01 w_98" placeholder="적요" ></textarea></td>
								</tr>
							</table>
												</div>
												</div>
												
	<div id="tab-3" class="tab-content">
		<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
					
								<tr>
									<th scope="row">BOX당 수량 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="EXCH_RATE" class="text_box01  firstFocus" style = "text-align:right;" placeholder="BOX당수량" alt="제품코드"/>/
									<input type="text" name="EXCH_RATE" class="text_box01  firstFocus" style = "text-align:right;" alt="제품코드"/></td>
								</tr>
								<tr>
									<th scope="row" rowspan="7">안전재고관리 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									주문서
									<input type="radio" name="SAFE_A0001"  value="0" checked="checked"/>기본설정
									<input type="radio" name="SAFE_A0001"  value="1"/>사용
									<input type="radio" name="SAFE_A0001"  value="2"/>사용안함
									</td>
								</tr>
								<tr>
									
									<td class="left_pt10" style="width:80%">
									판매
									<input type="radio" name="SAFE_A0002"  value="0" checked="checked"/>기본설정
									<input type="radio" name="SAFE_A0002"  value="1"/>사용
									<input type="radio" name="SAFE_A0002"  value="2"/>사용안함
									</td>
								</tr>
								<tr>
									
									<td class="left_pt10" style="width:80%">
									생산불출
									<input type="radio" name="SAFE_A0003"  value="0" checked="checked"/>기본설정
									<input type="radio" name="SAFE_A0003"  value="1"/>사용
									<input type="radio" name="SAFE_A0003"  value="2"/>사용안함
									</td>
								</tr>
								<tr>
									
									<td class="left_pt10" style="width:80%">
									생산입고
									<input type="radio" name="SAFE_A0004"  value="0" checked="checked"/>기본설정
									<input type="radio" name="SAFE_A0004"  value="1"/>사용
									<input type="radio" name="SAFE_A0004"  value="2"/>사용안함
									</td>
								</tr>
								<tr>
									
									<td class="left_pt10" style="width:80%">
									창고이동
									<input type="radio" name="SAFE_A0005"  value="0" checked="checked"/>기본설정
									<input type="radio" name="SAFE_A0005"  value="1"/>사용
									<input type="radio" name="SAFE_A0005"  value="2"/>사용안함
									</td>
								</tr>
								<tr>
									
									<td class="left_pt10" style="width:80%">
									자가사용
									<input type="radio" name="SAFE_A0006"  value="0" checked="checked"/>기본설정
									<input type="radio" name="SAFE_A0006"  value="1"/>사용
									<input type="radio" name="SAFE_A0006"  value="2"/>사용안함
									</td>
								</tr>
								<tr>
									
									<td class="left_pt10" style="width:80%">
									불량처리
									<input type="radio" name="SAFE_A0007"  value="0" checked="checked"/>기본설정
									<input type="radio" name="SAFE_A0007"  value="1"/>사용
									<input type="radio" name="SAFE_A0007"  value="2"/>사용안함
									</td>
								</tr>
								<tr>
									<th scope="row">안전재고수량 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">창고별지정</td>
									
									
								</tr>
								<tr>
									<th scope="row">CS최소주문수량 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
																		<select name="CSORD_C0001" class="sel_box w_45" >
																				<option value="B">기본설정</option>
																				<option value="Y">사용</option>
																				<option value="N">사용안함</option>
																		</select>
																		<input type="text" name="CSORD_TEXT" class="text_box01 w_45" value="0" placeholder="CS최소주문수량" />
																</td>
								</tr>
								<tr>
									<th scope="row">CS최소주문단위 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
													<select name="CSORD_C0003" class="sel_box w_98">
															<option value="N">사용안함</option>
															<option value="Y">사용</option>
																		</select>
																		</td>
								</tr>
								<tr>
									<th scope="row">재고수량 <span class="keyf01">*</span></th>
									<td>입력</td>
									</tr>
								<tr>
									<th scope="row">조달기간 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="EXCH_RATE" class="text_box01  firstFocus" style = "text-align:right;" placeholder="조달기간" alt="조달기간"/>
																		</td>
								</tr>
								
								
								<tr>
									<th scope="row">최소구매단위</th>
									<td class="left_pt10" style="width:80%"><input type="text" name="description" class="text_box01 w_98" placeholder="최소구매단위" /></td>
								</tr>
							</table>
					</div>
					</div>
					
					
<div id="tab-4" class="tab-content">
	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
								<tr>
									<th scope="row">입고단가 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="IN_PRICE" class="text_box01 w_80 " value="0" placeholder="입고단가" alt="입고단가" />
									<input type="checkbox" name="IN_PRICE_VAT"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">출고단가 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE" class="text_box01 w_80 " value="0" placeholder="출고단가" alt="출고단가" />
									<input type="checkbox" name="OUT_PRICE_VAT"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">원가 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE1" class="text_box01 w_80 " value="0" placeholder="원가" alt="원가" />
									<input type="checkbox" name="OUT_PRICE1_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">대리점가</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE2" class="text_box01 w_80 " value="0" placeholder="대리점가" alt="대리점가" />
									<input type="checkbox" name="OUT_PRICE2_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">소비자가 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE3" class="text_box01 w_80 " value="0" placeholder="소비자가" alt="소비자가" />
									<input type="checkbox" name="OUT_PRICE3_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">단가D</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE4" class="text_box01 w_80 " value="0" placeholder="단가D" alt="단가D" />
									<input type="checkbox" name="OUT_PRICE4_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">단가E</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE5" class="text_box01 w_80 " value="0" placeholder="단가E" alt="단가E" />
									<input type="checkbox" name="OUT_PRICE5_VAT_YN" />VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">단가F</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE6" class="text_box01 w_80 " value="0" placeholder="단가F" alt="단가F" />
									<input type="checkbox" name="OUT_PRICE6_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">단가G </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE7" class="text_box01 w_80 " value="0" placeholder="단가G" alt="단가G" />
									<input type="checkbox" name="OUT_PRICE7_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">단가H </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE8" class="text_box01 w_80 " value="0" placeholder="단가H" alt="단가H" />
									<input type="checkbox" name="OUT_PRICE8_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">단가I </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE9" class="text_box01 w_80 " value="0" placeholder="단가I" alt="단가I" />
									<input type="checkbox" name="OUT_PRICE9_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">단가J </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_PRICE10" class="text_box01 w_80 " value="0" placeholder="단가J" alt="단가J" />
									<input type="checkbox" name="OUT_PRICE10_VAT_YN"/>VAT포함
									</td>
									
								</tr>
								
								</table>
												</div>
							</div>
<div id="tab-5" class="tab-content">
	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
								<tr>
									<th scope="row">외주비단가</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUTSIDE_PRICE" class="text_box01 w_80 " value="0" placeholder="외주비단가" alt="외주비단가" />
									<input type="checkbox" name="OUTSIDE_PRICE_VAT"/>VAT포함
									</td>
									
								</tr>
								<tr>
									<th scope="row">표준노무시간(노무비가중치)</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="LABOR_WEIGHT" class="text_box01 w_98" value="1" placeholder="표준노무시간(노무비가중치)" alt="표준노무시간(노무비가중치)" />
									</td>
									
								</tr>
								<tr>
									<th scope="row">경비가중치</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="EXPENSES_WEIGHT" class="text_box01 w_98 " value="1" placeholder="경비가중치" alt="경비가중치" />
									</td>
									
								</tr>
								<tr>
									<th scope="row">재료비표준원가 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="MATERIAL_COST" class="text_box01 w_98 " value="0" placeholder="재료비표준원가" alt="재료비표준원가" />
									</td>
									
								</tr>
								<tr>
									<th scope="row">경비표준원가 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="EXPENSE_COST" class="text_box01 w_98 " value="0" readonly="readonly" value="0" />
									</td>
									
								</tr>
								<tr>
									<th scope="row">노무비표준원가 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="LABOR_COST" class="text_box01 w_98 " value="0" readonly="readonly" value="0" />
									</td>
									
								</tr>
								<tr>
									<th scope="row">외주비표준원가 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="OUT_COST" class="text_box01 w_98 " value="0" readonly="readonly" value="0" />

									</td>
									
								</tr>
								
								</table>
												</div>
							</div>
<div id="tab-6" class="tab-content">
							<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<tr>
									<th scope="row">변경사항 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CONT1" class="text_box01 w_98 " placeholder="변경사항" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">문자형추가항목2 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CONT2" class="text_box01 w_98 " placeholder="문자형추가항목2" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">문자형추가항목3 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CONT3" class="text_box01 w_98 " placeholder="문자형추가항목3" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">문자형추가항목4 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CONT4" class="text_box01 w_98 " placeholder="문자형추가항목4" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">문자형추가항목5 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CONT5" class="text_box01 w_98 " placeholder="문자형추가항목5" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">문자형추가항목6 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CONT6" class="text_box01 w_98 " placeholder="문자형추가항목6" />

									</td>
									
								</tr>
							<tr>
									<th scope="row">숫자형추가항목1 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER1" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목1" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목2 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER2" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목2" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목3 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER3" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목3" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목4 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER4" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목4" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목5 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER5" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목5" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목6 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER6" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목6" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목7 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER7" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목7" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목8 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER8" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목8" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목9 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER9" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목9" />

									</td>
									
								</tr>
								<tr>
									<th scope="row">숫자형추가항목10 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="NO_USER10" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목10" />

									</td>
									
								</tr>
								
								</table>
							</div>
							</div>
							<div id="tab-7" class="tab-content">
							<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<tr>
									<th scope="row">관리항목 </th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="ITEM_TYPE"  value="B" checked="checked"/>기본설정
									<input type="radio" name="ITEM_TYPE"  value="Y"/>필수입력
									<input type="radio" name="ITEM_TYPE"  value="M"/>선택입력
									<input type="radio" name="ITEM_TYPE"  value="N"/>사용안함
									</td>
								</tr>
								<tr>
								
									<th scope="row">시리얼/로트No. </th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="SERIAL_TYPE"  value="B" checked="checked"/>기본설정
									<input type="radio" name="SERIAL_TYPE"  value="Y"/>필수입력
									<input type="radio" name="SERIAL_TYPE"  value="M"/>선택입력
									<input type="radio" name="SERIAL_TYPE"  value="N"/>사용안함
									</td>
								</tr>
								
								<tr>
									<th scope="row" rowspan="2">생산전표생성대상 </th>
									<td class="left_pt10" style="width:80%">
									판매
									<input type="radio" name="PROD_SELL_TYPE"  value="B" checked="checked"/>기본설정
									<input type="radio" name="PROD_SELL_TYPE"  value="Y"/>사용
									<input type="radio" name="PROD_SELL_TYPE"  value="N"/>사용안함
									</td>
									
								</tr>
								<tr>
								<td class="left_pt10" style="width:80%">
								창고이동
									<input type="radio" name="PROD_WHMOVE_TYPE"  value="B" checked="checked"/>기본설정
									<input type="radio" name="PROD_WHMOVE_TYPE"  value="Y"/>사용
									<input type="radio" name="PROD_WHMOVE_TYPE"  value="N"/>사용안함
									</td></tr>
									
									<tr>
									<th scope="row" rowspan="2">품질검사요청대상 </th>
									<td class="left_pt10" style="width:80%">
									구매
									<input type="radio" name="QC_BUY_TYPE"  value="B" checked="checked"/>기본설정
									<input type="radio" name="QC_BUY_TYPE"  value="Y"/>사용
									<input type="radio" name="QC_BUY_TYPE"  value="N"/>사용안함
									</td>
									
								</tr>
								<tr>
								<td class="left_pt10" style="width:80%">
								생산입고
									<input type="radio" name="QC_YN"  value="B" checked="checked"/>기본설정
									<input type="radio" name="QC_YN"  value="Y"/>사용
									<input type="radio" name="QC_YN"  value="N"/>사용안함
									</td></tr>
		
								</table>
							</div>
							</div>
							<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 registProductBtn">저장</a>
													<a href="#" class="btn_gray01 ProductRegist_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="ProductRegist_close"><span>닫기</span></a>
					</div>
			  </div>
              <!-- contents end -->         