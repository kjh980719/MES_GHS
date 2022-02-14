<%@page import="com.fasterxml.jackson.annotation.JacksonInject.Value"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">

$(document).ready(function() {
    var setCalendarDefault = function() {
        $("#startDate").datepicker();
        $("#startDate").datepicker('setDate', '-1Y');
        $("#endDate").datepicker();
        $("#endDate").datepicker('setDate', 'today');
    }
    
	$(".resetFormBtn").click(function(){
	    $('#searchForm').resetForm();
	    setCalendarDefault();
        searchmaterialList();  
	});

	$(".searchcustBtn").click(function(){
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
    
    $(".registCustBtn").click(function(){
	    registCust();
	    console.log("실행");
	});

	var registCust = function () {
	    var targetUrl = "/cust/createCust.json";
		if(checkCustValid() && confirm("저장 하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".registCustBtn").off("click");
			var param = $("#CustRegistForm").serializeObject();
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
		            $('#CustRegist').popup("hide");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#CustRegistForm input[name='"+response.code+"']").focus();
				}
    			$(".registCustBtn").on("click", function(){registCust();});
			});
		}
	}
	
	var checkCustValid = function () {
	    var valid = true;
   		$.each($("#CustRegistForm .required"), function(){
            if($(this).val() == '') {
	            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
    			$(this).focus();
    			valid = false;
    			return false;
            }
        });
        if(valid) {
            /* if($('#CustRegistForm input[name="changePasswordYn"]').val() == "Y") {
                //수정시 패스워드 변경
                if(!checkPassword($("#CustRegistForm input[name='newPassword']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#CustRegistForm input[name='newPassword']").focus();
                    return false;
                }
                if($("#CustRegistForm input[name='newPassword']").val() != $("#CustRegistForm input[name='newPasswordConfirm']").val()) {
                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
                    $("#CustRegistForm input[name='newPasswordConfirm']").focus();
                    return false;
                }
            } else if($('#CustRegistForm input[name="managerSeq"]').val() == "") {
                //신규 등록
                if($("#CustRegistForm input[name='managerId']").val().length > 20) {
                    alert("관리자 아이디는 최대 20자 입니다.");
                    $("#CustRegistForm input[name='managerId']").focus();
                    return false;
                }
                if(!checkPassword($("#CustRegistForm input[name='password']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#CustRegistForm input[name='password']").focus();
                    return false;
                }
            } */

           
        }
	    return valid;
	}
    
    
	setCalendarDefault();
    var colModel = [
        {label: "No", name:"rowIndex", align: "center", width: "10%", sortable: false},
        {label: "거래처코드", name:"BUSINESS_NO", align: "center", width: "10%", sortable: false},
        {label: "거래처명", name:"CUST_NAME", align: "center", width: "10%", sortable: false},
        {label: "대표자명", name:"BOSS_NAME", align: "center", width: "10%", sortable: false},
        {label: "전화번호", name:"TEL", align: "center", width: "10%", sortable: false},
        {label: "핸드폰번호", name:"HP_NO", align: "center", width: "10%", sortable: false},
        {label: "검색창내용", name:"REMARKS_WIN", align: "center", width: "10%", sortable: false},
        {label: "사용구분", name:"CANCEL", align: "center", width: "10%", sortable: false, formatter: CANCELFormat},
        {label: "이체정보", name:"File", align: "center", width: "10%", sortable: false}
    ];

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log("페이지 처음 들어왔을 때 : " + postData.REMARKS_WIN);
    creatJqGrid("jqGrid_1", "/cust/getCustList", colModel,  postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");

    //관리자 신규등록 버튼 클릭
 	$(".popLayercustRegistBtn").click(function(){
		$("#CustRegistForm input[name='custSeq']").val("");
		$('#CustRegistForm input[name="custId"]').prop('readonly', false);
		$('#CustRegistForm #changePasswordBtn').hide();
		$('#CustRegistForm .changePasswordSpan').hide();
		$('#CustRegistForm input[name="password"]').show();
	    $('#CustRegistForm').resetForm();
	    $('ul.tabs li').removeClass('current');
        $('#CustRegist').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#CustRegist .firstFocus').focus();
            }
        });
		$('#CustRegist').popup("show");
		$('#actionText').text("거래처 등록");
	});  

 /*    //관리자 수정을 위해 row 클릭시
    $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
            var row = $(this).getRowData(id);
            $('#custRegistForm').resetForm();
		    $('#custRegistForm input[name="password"]').hide();
		    $('#custRegistForm #changePasswordBtn').show();
		    $('#custRegistForm .changePasswordSpan').hide();
			$('#custRegistForm input[name="custId"]').prop('readonly', true);
            $('#custRegistForm select[name="authGroupSeq"] option').each(function(){
                if($(this).text() == row.authGroupName){
                    $(this).prop("selected", true);
                }
            })
		    $('#actionText').text("관리자 수정");
            $('#CustRegist').popup({
                focuselement: "secondFocus",
                onopen: function() {
                    $('#custRegist .secondFocus').focus();
                }
            });
            $('#CustRegist').popup("show");
			setTableText(row, "custRegistForm");
        }
    });  */

 		$('span[id=IO_CODE_SL]').hide();
 		$('input[name=IO_CODE_SL_BASE_YN]').change(function(){
// 			var r=$('input[name=VAT_YN]:checked').val();
 		if($("input[name=IO_CODE_SL_BASE_YN]:checked").val()=="Y"){
 			$('span[id=IO_CODE_SL]').show();
 			
// 			console.log(r);
 		}else {
// 			console.log(r);
 			$('span[id=IO_CODE_SL]').hide();
 		}

 		})
 		
 		$('span[id=IO_CODE_BY]').hide();
 		$('input[name=IO_CODE_BY_BASE_YN]').change(function(){
// 			var r=$('input[name=VAT_YN]:checked').val();
 		if($("input[name=IO_CODE_BY_BASE_YN]:checked").val()=="Y"){
 			$('span[id=IO_CODE_BY]').show();
 			
// 			console.log(r);
 		}else {
// 			console.log(r);
 			$('span[id=IO_CODE_BY]').hide();
 		}

 		})

 		function CANCELFormat(cellValue, option, rowObject){
 	    	return cellValue=='N'?'YES':'NO';
 	   };
	
})

$(".CustRegist_close").click(function(e){
     window.close();  
});

$(document).ready(function(){
	
	$('ul.tabs li').click(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	})

});

function setFOREIGN_FLAG(){
	var FOREIGN_FLAG = "N";
	if($("select[name=EXCHANGE_CODE]").val()!="사용안함"){
		FOREIGN_FLAG ="Y";
	//$("select[id^='select_exchange_code']")		
	}else{
		FOREIGN_FLAG ="N";
	}
	$("input[name=FOREIGN_FLAG]").val(FOREIGN_FLAG);
	console.log(FOREIGN_FLAG);
};
function openZipSearch() {
	new daum.Postcode({
		oncomplete: function(data) {
			$('[name=POST_NO]').val(data.zonecode); // 우편번호 (5자리)
			$('[name=ADDR]').val(data.address);
		}
	}).open();
}



function setG_BUSINESS_CD(){
	$("input[name=G_BUSINESS_CD]").val($("input[name=BUSINESS_NO]").val());
	console.log(FOREIGN_FLAG);
};
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
					 	거래처관리
					</h3>
					<div class="align_rgt mjinput">
						<div class="mjRight">
							<button type="button" class="btn_blue01 popLayercustRegistBtn">등록</button>
						</div>
					</div>
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
                            <th scope="row">사용구분</th>
                            <td colspan="4" class="left_pt10">
                                <select name="CANCEL" class="sel_box selectSearch">                                  
                                    <option value="N">사용</option>
                                    <option value="Y">미사용</option>
                                </select>
                            </td>
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
                                    <button type="button" class="btn_blue01 searchcustBtn" >검색</button>
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
				<div class="layer_win01" style="width:800px;display: none;" id="CustRegist">
					<div>
						<form id="CustRegistForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">제품 등록</span>
												</h3>
							
    <ul class="tabs">
		<li class="tab-link current" data-tab="tab-1">기본</li>
		<li class="tab-link" data-tab="tab-2">거래처정보</li>
		<li class="tab-link" data-tab="tab-3">여신/단가</li>
		<li class="tab-link" data-tab="tab-4">부가정보</li>
	</ul>

	<div id="tab-1" class="tab-content current">
	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 제품 등록 양식</caption>
								<tr>
									<th scope="row">거래처코드 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="BUSINESS_NO" class="text_box01 w_98  firstFocus" placeholder="제품코드 입력" alt="제품코드" onchange="setG_BUSINESS_CD()"/>
									</td>
								</tr>
								<tr>
									<th scope="row">상호(이름) <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="CUST_NAME" class="text_box01 w_98  secondFocus" placeholder="제품이름 입력" alt="제품이름"/></td>
								</tr>
								<tr>
									<th scope="row">거래처코드구분 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="G_GUBUN"  value="01" checked="checked"/>사업자등록번호
									<input type="radio" name="G_GUBUN"  value="02"/>비사업자(내국인)
									<input type="radio" name="G_GUBUN"  value="03"/>비사업자(외국인)</td>
								</tr>
								<tr>
									<th scope="row">업종별구분 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="GUBUN"  value="11" checked="checked"/>일반
									<input type="radio" name="GUBUN"  value="13"/>관세사</td>
								</tr>
								<tr>
									<th scope="row">외화거래처 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<select id="select_exchange_code" name="EXCHANGE_CODE" class="sel_box " onchange="setFOREIGN_FLAG()">
									<option value="">사용안함</option>
									<c:forEach var="EXCHANGE" items="${EXchangeList}">                               
                                    <option value="${EXCHANGE.EXCHANGE_CODE}">${EXCHANGE.EXCHANGE_DES}</option>
                                    </c:forEach>
                                </select><input type="hidden" name="FOREIGN_FLAG" value="N" />
                                </td>
								</tr>
								<tr>
									<th scope="row">대표자명 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98 " name="BOSS_NAME" placeholder="대표자명" />
									</td>
									
								</tr>
								<tr>
								<th scope="row">업태</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98 " name="UPTAE" placeholder="업태" />
									</td>
									
								</tr>
								<tr>
								<th scope="row">종목</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98 " name="JONGMOK" placeholder="종목" />
									</td>
									
								</tr>
								<tr>
									<th scope="row">전화 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98 " name="TEL" placeholder="전화" />
									</td>
								</tr>
								<tr>
									<th scope="row">Fax </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98 " name="FAX" placeholder="Fax" />
									</td>
								</tr>
								<tr>
									<th scope="row">검색창내용 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98 " name="FAX" placeholder="검색창내용" />
									</td>
								</tr>
								<tr>
									<th scope="row">모바일 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="HP_NO" class="text_box01 w_98 " placeholder="모바일" />
									</td>
								</tr>
								<tr>
									<th scope="row" rowspan="2">주소1 </th>
									<td class="left_pt10" style="width:80%"><button type="button" onclick="openZipSearch()" >우편번호검색</button>
									<input type="text" name="POST_NO" class="text_box01 w_85 " placeholder="주소1" />
									</td>
								</tr>
								<tr>
									<td class="left_pt10" style="width:80%">
									<textarea name="ADDR" class="text_box01 w_98 " style="resize: none;"></textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">영업단가그룹 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98 " name="CS_FLAG" placeholder="영업단가그룹"/>
									</td>
								</tr>
								<tr>
									<th scope="row">담당자 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98 " name="CS_FLAG" placeholder="담당자"/>
									</td>
								</tr>
								<tr>
									<th scope="row">홈페이지 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" class="text_box01 w_98" name="CS_FLAG" placeholder="홈페이지"/>
									</td>
								</tr>
								<tr>
									<th scope="row">거래처계층그룹 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="PROD_LEVEL_GROUP" class="text_box01 w_98" placeholder="거래처계층그룹" />
									</td>
								</tr>
							</table>
												</div>
												</div>
<div id="tab-2" class="tab-content">
 <div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
								<tr>
									<th scope="row" rowspan="2">세무신고거래처 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="G_BUSINESS_TYPE" value="1" checked="checked"/>거래처코드동일
									<input type="radio" name="G_BUSINESS_TYPE" value="2"/>검색입력
									<input type="radio" name="G_BUSINESS_TYPE" value="3"/>직접입력
											
																</td></tr>
								<tr>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="G_BUSINESS_CD" class="text_box01 w_98" placeholder="세무신고거래처" readonly="readonly" />	
																</td>
								</tr>
								<tr>
									<th scope="row">종사업장번호 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="TAX_REG_ID" class="text_box01 w_98 " value="0" placeholder="종사업장번호" />
																</td>
								</tr>
								<tr>
									<th scope="row">Email <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="EMAIL" class="text_box01 w_98 " placeholder="Email" />
																</td>
								</tr>
								<tr>
									<th scope="row" rowspan="2">주소2 </th>
									<td class="left_pt10" style="width:80%"><button type="button" onclick="openZipSearch()" >우편번호검색</button>
									<input type="text" name="DM_POST" class="text_box01 w_85 " placeholder="주소2" />
									</td>
								</tr>
								<tr>
									<td class="left_pt10" style="width:80%">
									<textarea name="DM_ADDR" class="text_box01 w_98 " style="resize: none;"></textarea>
									</td>
								</tr>
								<tr>
									<th scope="row">거래처그룹1</th>
									<td class="left_pt10" style="width:80%;">
									<input type="text" name="CUST_GROUP1" class="text_box01 w_98" placeholder="거래처그룹1" />
									</td>
								</tr>
								<tr>
									<th scope="row">거래처그룹2</th>
									<td class="left_pt10" style="width:80%;">
									<input type="text" name="CUST_GROUP2" class="text_box01 w_98" placeholder="거래처그룹2" />

									</td>
								</tr>
								<tr>
									<th scope="row">적요</th>
									<td class="left_pt10" style="width:80%;">
									<textarea name="REMARKS" class="text_box01 w_98" placeholder="적요" ></textarea></td>
								</tr>
																	
								<tr>
									<th scope="row">출하대상거래처</th>
									<td class="left_pt10" style="width:80%;">
									<input type="radio" name="OUTORDER_YN" value="Y"/>사용
									<input type="radio" name="OUTORDER_YN" value="N" checked="checked"/>사용안함
									</td>
								</tr>
								<tr>
									<th scope="row">거래유형(영업)</th>
									<td class="left_pt10" style="width:80%;">
									<input type="radio" name="IO_CODE_SL_BASE_YN" value="N" checked="checked"/>기본설정
									<input type="radio" name="IO_CODE_SL_BASE_YN" value="Y" />직접입력
									<span id="IO_CODE_SL">
									<select>
									<option></option>
									<option>세금계산서</option>
									<option>계산서</option>
									<option>카드</option>
									<option>카드(면세)</option>
									<option>소매</option>
									<option>소매(면세)</option>
									<option>현금영수증</option>
									<option>현금영수증(면세)</option>
									<option>영세율</option>
									<option>추가</option>
									</select>
									</span>
									</td>
								</tr>
								<tr>
									<th scope="row">거래유형(구매)</th>
									<td class="left_pt10" style="width:80%;">
									<input type="radio" name="IO_CODE_BY_BASE_YN" value="N" checked="checked"/>기본설정
									<input type="radio" name="IO_CODE_BY_BASE_YN" value="Y" />직접입력
									<span id="IO_CODE_BY">
									
									<select name="IO_CODE_BY">
									<option></option>
									<option>세금계산서</option>
									<option>계산서</option>
									<option>카드</option>
									<option>카드(면세)</option>
									<option>소매</option>
									<option>소매(면세)</option>
									<option>현금영수증</option>
									<option>현금영수증(면세)</option>
									<option>영세율</option>
									<option>추가</option>
									</select>
									</span>
									</td>
								</tr>
							</table>
												</div>
												</div>
												
	<div id="tab-3" class="tab-content">
		<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
					
								<tr>
									<th scope="row">담당자 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="EMP_CD" class="text_box01  w_98" placeholder="담당자"/>
									</td>
								</tr>
								<tr>
									<th scope="row">수금/지급예정일 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="radio" name="SAFE_A0001"  value="0" checked="checked"/>기본설정
									<input type="radio" name="SAFE_A0001"  value="1"/>사용
									<input type="radio" name="SAFE_A0001"  value="2"/>사용안함
									</td>
								</tr>
								<tr>
									<th scope="row">채권번호관리 <span class="keyf01">*</span></th>
									<td class="left_pt10 " style="width:80%">
									<select name="MANAGE_BOND_NO" class="text_box01  w_98">
									<option value="B">기본설정</option>
									<option value="M">필수입력</option>
									<option value="Y">선택입력</option>
									<option value="N">사용안함</option>
									</select>
									</td>
								</tr>
								<tr>
									<th scope="row">채무번호관리 <span class="keyf01">*</span></th>
									<td class="left_pt10 " style="width:80%">
									<select name="MANAGE_DEBIT_NO" class="text_box01  w_98">
									<option value="B">기본설정</option>
									<option value="M">필수입력</option>
									<option value="Y">선택입력</option>
									<option value="N">사용안함</option>
									</select>
									</td>
								</tr>
								<tr>
									<th scope="row">여신한도 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CUST_LIMIT" class="text_box01  w_98" style = "text-align:right;" value="0" placeholder="여신한도"/>
									</td>
								</tr>
								<tr>
									<th scope="row">출고조정률 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="O_RATE" class="text_box01  w_95" style = "text-align:right;" value="0" placeholder="출고조정률"/>%
									</td>
								</tr>
								<tr>
									<th scope="row">입고조정률 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="I_RATE" class="text_box01  w_95" style = "text-align:right;" value="0" placeholder="입고조정률"/>%
									</td>
								</tr>
								<tr>
									<th scope="row">영업단가그룹 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="PRICE_GROUP" class="text_box01  w_98" style = "text-align:right;" placeholder="영업단가그룹"/>
									</td>
								</tr>
								<tr>
									<th scope="row">구매단가그룹 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="PRICE_GROUP2" class="text_box01  w_98" style = "text-align:right;" placeholder="구매단가그룹"/>
									</td>
								</tr>
								<tr>
									<th scope="row">여신기간 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CUST_LIMIT_TERM" class="text_box01  w_90" style = "text-align:right;" value="0" placeholder="여신기간"/>일 전
									</td>
								</tr>
							</table>
					</div>
					</div>
					
					
<div id="tab-4" class="tab-content">
	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
								<tr>
									<th scope="row">문자형추가항목1 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CONT1" class="text_box01 w_98 " placeholder="문자형추가항목1" />
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
									<td class="left_pt10" style="width:80%; text-align:right;">
									<input type="text" name="NO_CUST_USER1" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목1" />
									</td>
								</tr>
								<tr>
									<th scope="row">숫자형추가항목2 </th>
									<td class="left_pt10" style="width:80%; text-align:right;">
									<input type="text" name="NO_CUST_USER2" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목2" />
									</td>
								</tr>
								<tr>
									<th scope="row">숫자형추가항목3 </th>
									<td class="left_pt10" style="width:80%; text-align:right;">
									<input type="text" name="NO_CUST_USER3" class="text_box01 w_98 " value="0" placeholder="숫자형추가항목3" />
									</td>
								</tr>
								</table>
												</div>
							</div>

		
								
							
							<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 registCustBtn">저장</a>
													<a href="#" class="btn_gray01 CustRegist_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="CustRegist_close"><span>닫기</span></a>
					</div>
			  </div>
              <!-- contents end -->         