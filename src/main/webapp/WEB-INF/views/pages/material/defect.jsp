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
	    $('#searchForm').resetForm();
	    setCalendarDefault();
        searchDefectList();  
	});

	$(".searchInBtn").click(function(){
	    searchDefectList();
	});

	$(".selectSearch").change(function(){
	    searchDefectList();
	});

	$(".enterSearch").keydown(function(event){
	    if (event.keyCode == 13){
	        searchDefectList();
	    }
	});

	
	//검색후 page 설정하여 띄우기	
    var searchDefectList = function () {
		
    	var postData = $("#searchForm").serializeObject();
		postData.currentPage = 1;
        postData.rowsPerPage = $("#rowPerPage_1").val();
        
        $("#jqGrid_1").jqGrid('setGridParam', {
            postData: JSON.stringify(postData)
        }).trigger("reloadGrid");
    }
    
    $(".updateDefectBtn").click(function(){
	    updateDefect();
	    console.log("실행");
	});

	var updateDefect = function () {
	        targetUrl = "/material/updateDefect.json";
	    
		if(checkInValid() && confirm("수정하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".updateDefectBtn").off("click");
			var param = $("#DefectRegistForm").serializeObject();
			$.ajax({
				type : "post",
				url : targetUrl,
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify(param)
			}).done(function(response) {
				if (response.success){
					alert("저장되었습니다.");
					$("#jqGrid_1").jqGrid().trigger("reloadGrid");
		            $('#DefectRegist').popup("hide");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#DefectRegistForm input[name='"+response.code+"']").focus();
				}
    			$(".updateDefectBtn").on("click", function(){updateDefect();
    			});
			});
		}
	}
	
	var checkInValid = function () {
	    var valid = true;
   		$.each($("#DefectRegistForm .required"), function(){
            if($(this).val() == '') {
	            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
    			$(this).focus();
    			valid = false;
    			return false;
            }
        });
        if(valid) {
             if($('#DefectRegistForm input[name="PROD_CD"]').val() == "") {
                //수정시 패스워드 변경
                if(!checkPassword($("#DefectRegistForm input[name='PROD_CD']").val())) {
                    alert("품목코드를 입력해주세요");
                    $("#DefectRegistForm input[name='PROD_CD']").focus();
                    return false;
                }
                /* if($("#DefectRegistForm input[name='newPassword']").val() != $("#DefectRegistForm input[name='newPasswordConfirm']").val()) {
                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
                    $("#DefectRegistForm input[name='newPasswordConfirm']").focus();
                    return false;
                } */
            }else{
            	
            } /* else if($('#DefectRegistForm input[name="managerSeq"]').val() == "") {
                //신규 등록
                if($("#DefectRegistForm input[name='managerId']").val().length > 20) {
                    alert("관리자 아이디는 최대 20자 입니다.");
                    $("#DefectRegistForm input[name='managerId']").focus();
                    return false;
                }
                if(!checkPassword($("#DefectRegistForm input[name='password']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#DefectRegistForm input[name='password']").focus();
                    return false;
                }
            }  */

           
        }
	    return valid;
	}
    
    
	setCalendarDefault();
    var colModel = [
    	{label: "부적합번호", name:"DEFECT_SEQ", align: "center", width: "10%", sortable: false, hidden: true},
        {label: "No", name:"rowIndex", align: "center", width: "10%", sortable: false},
        {label: "발주코드", name:"ORDER_CODE", align: "center", width: "10%", sortable: false},
        {label: "부적합사유", name:"DEFECT_REASON", align: "center", width: "10%", sortable: false},
        {label: "품목명", name:"PDT_NAME", align: "center", width: "10%", sortable: false},
        {label: "공급사", name:"SUPPLY_NAME", align: "center", width: "10%", sortable: false},
        {label: "작성자", name:"REGIST_MANAGER", align: "center", width: "10%", sortable: false},
        {label: "작성일자", name:"REGIST_DATE", align: "center", width: "10%", sortable: false}
        
    ];

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log(postData);
    creatJqGrid("jqGrid_1", "/material/getDefectList", colModel, postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");
    console.log(colModel);

    //관리자 수정을 위해 row 클릭시
     $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
        	var row = $(this).getRowData(id);
        	var DEFECT_SEQ=Object.values(row)[0];
        	console.log(Object.values(row)[0]);
        	var rowdata;
            $('#DefectRegistForm').resetForm();
            $("#my_tbody tr").remove(); 

            $.ajax({
				type : "post",
				url : '/material/selectDefect',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"DEFECT_SEQ": DEFECT_SEQ}),
				success : function(data) {
					 rowdata=data.storeData;		 
                    }
			});
        	
            console.log(rowdata);
            $('#DefectRegist').popup({
                focuselement: "secondFocus",
                onopen: function() {
                    $('#DefectRegist .secondFocus').focus();
                }
            });
			setTableText(rowdata, "DefectRegistForm"); 
            $('#DefectRegist').popup("show");
        }
    }); 
})


$(".DefectRegist_close").click(function(e){
         
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


</script>

					<h3 class="mjtit_top">
						불량/파손/부적합관리
					</h3>
        <!--  관리자  검색시작-->
                    <div class="top_mt10 bottom_mt20">
                    <form id="searchForm" onsubmit="return false">
                    <table cellpadding="0" cellspacing="0" class="mjlist_tbl01">
                  <caption></caption>
                        <tr>
                            <th scope="row">작성일자</th>
                            <td colspan="4" class="left_pt10">
                                <input type="text" class="text_box01 m_pointer w_20" id="startDate" name="startDate"/>
                                <span class="keyf08 left_mt10 right_mt5">~</span>
                                <input type="text" class="text_box01 m_pointer w_20" id="endDate" name="endDate"/>
                            </td>
                            <th scope="row">검색</th>
                            <td  class="left_pt10">
                                <input type="text" class="text_box01 w_30 enterSearch" name="REMARKS_WIN" />
                            </td>
                        </tr>
                    </table>
                    </form>
                            <!-- 검색 버튼-->
                            <div class="align_cen pt20">
                                    <button type="button" class="btn_gray01_2 resetFormBtn">초기화</button>
                                    <button type="button" class="btn_blue01 searchInBtn" >검색</button>
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
				<div class="layer_win01" style="width:800px;display: none;" id="DefectRegist">
					<div>
						<form id="DefectRegistForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">부적합품목</span>
								<input type="hidden" id="rowIndex"/>
												</h3>
							


	<div id="tab-1" class="tab-content current">
	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 부적합품조회</caption>
								<tr>
									<th scope="row">발주코드<span class="keyf01">*</span></th>
									<td class="left_pt10"><input type="text" name="ORDER_CODE" class="firstFocus required"/></td>
								
									<th scope="row">비고 <span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="BIGO"/>
									</td>
								</tr>
								<tr>
									<th scope="row">공급사명</th>
									<td class="left_pt10">
									<input type="text" name="SUPPLY_NAME"/>
									</td>
									<th scope="row">사업자번호<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="BUSINESS_NO"/></td>
								</tr>
								<tr>
									
								</tr>
								<tr>
									<th scope="row">작성일자<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="REGIST_DATE"/>
									</td>
									
									<th scope="row">작성자<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="REGIST_MANAGER"/>
									</td>
									
								</tr>
																<tr>
									<th scope="row">품목코드<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="CODE"/>
									</td>
								    <th scope="row">품목명<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="PDT_NAME"/>
									</td>
									</tr>	
								<tr>						
									<th scope="row">전화번호<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="REGIST_PHONENUMBER"/>
									</td>
									
									<th scope="row">규격<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="PDT_STANDARD"/></td>
									
									
								</tr>
								<tr>
								
									<th scope="row">수량<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="QTY" readonly="readonly"/></td>
									
									<th scope="row">단위<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="UNIT" readonly="readonly"/></td>
									
								</tr>
								<tr>
									<th scope="row">부적합사유<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="DEFECT_REASON"/>
									</td>
									
									<th scope="row">처리방법<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="DEFECT_WAY"/>
									</td>
								</tr>
						
							</table>
												</div>
												</div>
					

							<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 updateDefectBtn">확인</a>
													<a href="#" class="btn_gray01 DefectRegist_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="DefectRegist_close"><span>닫기</span></a>
					</div>
			  </div>
              <!-- contents end -->         