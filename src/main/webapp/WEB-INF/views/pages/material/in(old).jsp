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
        searchInList();  
	});

	$(".searchInBtn").click(function(){
	    searchInList();
	});

	$(".selectSearch").change(function(){
	    searchInList();
	});

	$(".enterSearch").keydown(function(event){
	    if (event.keyCode == 13){
	        searchInList();
	    }
	});

	
	//검색후 page 설정하여 띄우기	
    var searchInList = function () {
		
    	var postData = $("#searchForm").serializeObject();
		postData.currentPage = 1;
        postData.rowsPerPage = $("#rowPerPage_1").val();
        
        $("#jqGrid_1").jqGrid('setGridParam', {
            postData: JSON.stringify(postData)
        }).trigger("reloadGrid");
    }
    
    $(".updateInBtn").click(function(){
	    updateIn();
	    console.log("실행");
	});

	var updateIn = function () {
	        targetUrl = "/material/updateIn.json";
	        
	        var InmaterialList =[];
	        
	        
	        for (var i = 0; i < $('#my_tbody tr').length; i++) {
	            var tmpMap = {};
	           
	           tmpMap.BUSINESS_NO = $($("input[name='BUSINESS_NO']")[1]).val();
	           console.log($($("input[name='BUSINESS_NO']")).val());
	           tmpMap.SUPPLY_NAME = $($("input[name='SUPPLY_NAME']")).val();
	           tmpMap.SUPPLY_MANAGER_NAME = $($("input[name='SUPPLY_MANAGER_NAME']")).val();
	           tmpMap.SUPPLY_PHONENUMBER = $($("input[name='SUPPLY_PHONENUMBER']")).val();
	           tmpMap.M_IN_DATE = $($("input[name='M_IN_DATE']")).val();
	           tmpMap.ORDER_DATE = $($("input[name='ORDER_DATE']")).val();
	           tmpMap.CLOSE_DATE = $($("input[name='CLOSE_DATE']")).val();
	           tmpMap.IN_ADDR = $($("input[name='IN_ADDR']")).val();
	           tmpMap.TAX_AMOUNT = $($("input[name='TAX_AMOUNT']")).val();
	           tmpMap.FAX_AMOUNT = $($("input[name='FAX_AMOUNT']")).val();
	           tmpMap.TOTAL_AMOUNT = $($("input[name='TOTAL_AMOUNT']")).val();
	           tmpMap.BIGO = $($("input[name='BIGO']")).val();
	           tmpMap.M_IN_STATUS=document.getElementById("M_IN_STATUS").options[document.getElementById("M_IN_STATUS").selectedIndex].value;
	           tmpMap.ORDER_CODE = $($("input[name='ORDER_CODE']")).val();
	           
	           
	           tmpMap.NO = $($("input[name='NO']")[i]).val();
	           tmpMap.CODE = $($("input[name='CODE']")[i]).val();
	           tmpMap.PDT_NAME = $($("input[name='PDT_NAME']")[i]).val();
	           tmpMap.QTY = $($("input[name='QTY']")[i]).val();
	           tmpMap.REAL_QTY = $($("input[name='REAL_QTY']")[i]).val();
	           tmpMap.PDT_STANDARD = $($("input[name='PDT_STANDARD']")[i]).val();
	           tmpMap.UNIT = $($("input[name='UNIT']")[i]).val();
	           tmpMap.UNIT_PRICE = $($("input[name='UNIT_PRICE']")[i]).val();
	           tmpMap.VAT = $($("input[name='VAT']")[i]).val();
	           tmpMap.SUPPLY_PRICE = $($("input[name='SUPPLY_PRICE']")[i]).val();
	           tmpMap.STORAGE_NAME1 = $($("input[name='STORAGE_NAME1']")[i]).val();
	           tmpMap.STORAGE_NAME2 = $($("input[name='STORAGE_NAME2']")[i]).val();
	           tmpMap.STORAGE_NAME3 = $($("input[name='STORAGE_NAME3']")[i]).val();	           
	           tmpMap.IN_CHECK=document.getElementById("IN_CHECK"+i).options[document.getElementById("IN_CHECK"+i).selectedIndex].value;

	           
	           InmaterialList.push(tmpMap);
	        }
	        
	        sendData = {};
	        sendData.InmaterialList = InmaterialList;
	        
	    
		if(checkInValid() && confirm("수정하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".updateInBtn").off("click");
			var param = $("#InRegistForm").serializeObject();
			$.ajax({
				type : "post",
				url : targetUrl,
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify(sendData)
			}).done(function(response) {
				if (response.success){
					alert("저장되었습니다.");
					$("#jqGrid_1").jqGrid().trigger("reloadGrid");
		            $('#InRegist').popup("hide");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#InRegistForm input[name='"+response.code+"']").focus();
				}
    			$(".updateInBtn").on("click", function(){updateIn();
    			});
			});
		}
	}
	
	var checkInValid = function () {
	    var valid = true;
   		$.each($("#InRegistForm .required"), function(){
            if($(this).val() == '') {
	            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
    			$(this).focus();
    			valid = false;
    			return false;
            }
        });
        if(valid) {
             if($('#InRegistForm input[name="PROD_CD"]').val() == "") {
                //수정시 패스워드 변경
                if(!checkPassword($("#InRegistForm input[name='PROD_CD']").val())) {
                    alert("품목코드를 입력해주세요");
                    $("#InRegistForm input[name='PROD_CD']").focus();
                    return false;
                }
                /* if($("#InRegistForm input[name='newPassword']").val() != $("#InRegistForm input[name='newPasswordConfirm']").val()) {
                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
                    $("#InRegistForm input[name='newPasswordConfirm']").focus();
                    return false;
                } */
            }else{
            	
            } /* else if($('#InRegistForm input[name="managerSeq"]').val() == "") {
                //신규 등록
                if($("#InRegistForm input[name='managerId']").val().length > 20) {
                    alert("관리자 아이디는 최대 20자 입니다.");
                    $("#InRegistForm input[name='managerId']").focus();
                    return false;
                }
                if(!checkPassword($("#InRegistForm input[name='password']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#InRegistForm input[name='password']").focus();
                    return false;
                }
            }  */

           
        }
	    return valid;
	}
    
    
	setCalendarDefault();
    var colModel = [
        {label: "No", name:"rowIndex", align: "center", width: "15%", sortable: false},
        {label: "발주코드", name:"ORDER_CODE", align: "center", width: "15%", sortable: false},
        {label: "품목명", name:"FIRST_PDT_NAME", align: "center", width: "15%", sortable: false},
        {label: "공급사명", name:"SUPPLY_NAME", align: "center", width: "15%", sortable: false},
        {label: "사업자번호", name:"BUSINESS_NO", align: "center", width: "15%", sortable: false},
        {label: "입고일자", name:"M_IN_DATE", align: "center", width: "15%", sortable: false}
        
    ];

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log(postData);
    creatJqGrid("jqGrid_1", "/material/getInList", colModel, postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");
    console.log(colModel);

    //관리자 수정을 위해 row 클릭시
     $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
        	var row = $(this).getRowData(id);
        	var ORDER_CODE=Object.values(row)[1];
        	console.log(Object.values(row)[1]);
        	var rowdata;
            $('#InRegistForm').resetForm();
            $("#my_tbody tr").remove(); 

            $.ajax({
				type : "post",
				url : '/material/selectInHead',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"ORDER_CODE": ORDER_CODE}),
				success : function(data) {
					 rowdata=data.storeData;		 
                    }
			});
        	
            console.log(rowdata);
            $('#InRegist').popup({
                focuselement: "secondFocus",
                onopen: function() {
                    $('#InRegist .secondFocus').focus();
                }
            });
			setTableText(rowdata, "InRegistForm");

			$.ajax({
				type : "post",
				url : '/material/selectInBody',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"ORDER_CODE": ORDER_CODE}),
				success : function(data) {
					 rowdata=data.storeData;
					 var my_tbody = document.getElementById('my_tbody');
					 var cell1 = "";
			        	for(var i=0;i < rowdata.length;i++){
			        		 console.log(i + " : " + rowdata[i].NO);
			        		 
			        		 var chk1 = "";
			        		 var chk2 = "";
			        		 var chk3 = "";
			        		 if(rowdata[i].IN_CHECK == "IW"){
			        			 chk1 = "selected";
			        		 } else if(rowdata[i].IN_CHECK == "IC"){
			        			 chk2 = "selected";
			        		 } else if(rowdata[i].IN_CHECK == "IN"){
			        			 chk3 = "selected";
			        		 }
			        		 
				            console.log("test : " + rowdata[i].IN_CHECK);
							cell1 += "<tr><td><input type='text' name='NO' id='NO"+i+"' value='"+rowdata[i].NO+"' readonly='readonly'/></td>";
							cell1 += "<td><input type='text' name='ORDER_CODE' id='ORDER_CODE"+i+"' value='"+rowdata[i].ORDER_CODE+"' readonly='readonly'/></td>";
			        		cell1 += "<td><input type='text' name='CODE' id='CODE"+i+"' value='"+rowdata[i].CODE+"'/></td>";
							cell1 += "<td><input type='text' name='PDT_NAME' id='PDT_NAME"+i+"' value='"+rowdata[i].PDT_NAME+"'/></td>";
			        		cell1 += "<td><input type='text' name='QTY' id='QTY"+i+"' value='"+rowdata[i].QTY+"'/></td>";
			        		cell1 += "<td><input type='text' name='REAL_QTY' id='REAL_QTY"+i+"' value='"+rowdata[i].REAL_QTY+"'/></td>";			        		
			        		cell1 += "<td><input type='text' name='PDT_STANDARD' id='PDT_STANDARD"+i+"' value='"+rowdata[i].PDT_STANDARD+"'/></td>";
						    cell1 += "<td><input type='text' name='UNIT' id='UNIT"+i+"' value='"+rowdata[i].UNIT+"'/></td>";
						    cell1 += "<td><input type='text' name='UNIT_PRICE' id='UNIT_PRICE"+i+"' value='"+rowdata[i].UNIT_PRICE+"'/></td>";
							cell1 += "<td><input type='text' name='VAT' id='VAT"+i+"' value='"+rowdata[i].VAT+"'/></td>";
							cell1 += "<td><input type='text' name='SUPPLY_PRICE' id='SUPPLY_PRICE"+i+"' value='"+rowdata[i].SUPPLY_PRICE+"'/></td>";
						    cell1 += "<td><input type='text' name='STORAGE_NAME1' id='STORAGE_NAME1-"+i+"' value='"+rowdata[i].STORAGE_NAME1+"'></input></td>";
						    cell1 += "<td><input type='text' name='STORAGE_NAME2' id='STORAGE_NAME2-"+i+"' value='"+rowdata[i].STORAGE_NAME2+"'></input></td>";
						    cell1 += "<td><input type='text' name='STORAGE_NAME3' id='STORAGE_NAME3-"+i+"' value='"+rowdata[i].STORAGE_NAME3+"'></input></td>";
                            cell1 += "<td><select name='IN_CHECK' id='IN_CHECK"+i+"' value='"+rowdata[i].IN_CHECK+"'>"+
                        	"<option value='IW' "+ chk1 +">입고대기</option>" +
                        	"<option value='IC' "+ chk2 +">입고완료</option>" +
                        	"<option value='IN' "+ chk3 +">미입고</option></select></td></tr>";

			        	}
// 						$('#my_tbody').append(cell1);
						$('#my_tbody').html(cell1);
                    }
			});
           	if($('#InRegistForm select[name="M_IN_STATUS"]').val=="IC"){
           		$('#InRegistForm select[name="M_IN_STATUS"]').attr('readonly', 'readonly');
           		}
            $('#InRegist').popup("show");
// 			setTableText(rowdata, "InRegistForm");
        }
    }); 
})

$(".InRegist_close").click(function(e){
         
     window.close();  
         
});


$(window).on('resize.jqGrid', function () {
    jQuery("#jqGrid_1").jqGrid( 'setGridWidth', $("#gridParent_1").width() );
});



</script>

					<h3 class="mjtit_top">
						자재입고
					</h3>
        <!--  관리자  검색시작-->
                    <div class="top_mt10 bottom_mt20">
                    <form id="searchForm" onsubmit="return false">
                    <table cellpadding="0" cellspacing="0" class="mjlist_tbl01">
                  <caption></caption>
                  
                        <tr>
                            <th scope="row">입고일자</th>
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
                        <tr>
                        <th scope="row">상태</th>
                            <td colspan="4" class="left_pt10">
                                <select name="M_IN_STATUS" class="sel_box selectSearch">
                                	<option value=''>전체</option> 
                               	    <option value='IW'>입고대기</option>                              
                                    <option value='IC'>입고완료</option>
                                    <option value='IN'>미입고</option>
                                </select>
                            </td>
                            <th scope="row">사업자번호</th>
                            <td class="left_pt10">
                                <input type="text" class="text_box01 w_30 enterSearch" name="BUSINESS_NO" />
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
				<div class="layer_win01" style="width:800px;display: none;" id="InRegist">
					<div>
						<form id="InRegistForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">자재입고</span>
								<input type="hidden" id="rowIndex"/>
												</h3>
							


	<div id="tab-1" class="tab-content current">
	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 자재입고조회</caption>
								<tr>
									<th scope="row">발주코드<span class="keyf01">*</span></th>
									<td class="left_pt10"><input type="text" name="ORDER_CODE" class="text_box01  firstFocus required"/></td>
									<th scope="row">사업자번호<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="BUSINESS_NO" readonly="readonly"/></td>
								</tr>
								<tr>
									<th scope="row">공급사명</th>
									<td class="left_pt10">
									<input type="text" name="SUPPLY_NAME"/>
									</td>
									<th scope="row">공급자<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="SUPPLY_MANAGER_NAME" class="text_box01" readonly="readonly"/></td>
								</tr>
								<tr>
									
								</tr>
								<tr>
									<th scope="row">전화번호<span class="keyf01">*</span></th>
									<td class="left_pt10"><input type="text" name="SUPPLY_PHONENUMBER" class="text_box01"/></td>
									<th scope="row">입고일자<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="M_IN_DATE" readonly="readonly"/>
									</td>
								</tr>
								<tr>
									<th scope="row">발주일자<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="ORDER_DATE" readonly="readonly"/>
									</td>
								    <th scope="row">납기일자<span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="CLOSE_DATE" readonly="readonly"/>
									</td>
									
								</tr>
								<tr>
									<th scope="row">주소</th>
									<td class="left_pt10">
									<input type="text" name="IN_ADDR"/>
									</td>
								</tr>
								<tr>
									<th scope="row">FAX</th>
									<td class="left_pt10">
									<input type="text" name="FAX_AMOUNT" class="text_box01 w_80 "/>
									</td>
								</tr>
								<tr>
									<th scope="row">TAX</th>
									<td class="left_pt10">
									<input type="text" name="TAX_AMOUNT" class="text_box01 w_80 "/>
									</td>
								</tr>
								<tr>
									<th scope="row">총액</th>
									<td class="left_pt10">
									<input type="text" name="TOTAL_AMOUNT" class="text_box01 w_80 "/>
									</td>
								</tr>
								<tr>
									<th scope="row">비고 <span class="keyf01">*</span></th>
									<td class="left_pt10">
									<input type="text" name="BIGO"/>
									</td>
									
								</tr>
								<tr>
									<th scope="row">입고상태 </th>
									<td class="left_pt10">
									<select name="M_IN_STATUS" id="M_IN_STATUS" class="sel_box selectSearch">                                  
                                    	<option value=''>전체</option>
                                    	<option value='IW'>입고대기</option>
                                    	<option value='IC'>입고완료</option>
                                    	<option value='IN'>미입고</option>
                               		</select>
									</td>
								</tr>
							</table>
							<table class="mjlist_tbl01 mjlist_tbl011">
							  	<thead>
								  <tr>
								  <th scope="row">NO</th>
								  <th scope="row">발주코드</th>						
								  <th scope="row">품목코드</th>
								  <th scope="row">품목명</th>
								  <th scope="row">입고예정수량</th>
								  <th scope="row">입고수량</th>
								  <th scope="row">규격</th>
								  <th scope="row">단위</th>
								  <th scope="row">단가</th>
								  <th scope="row">부가세</th>
								  <th scope="row">공급가액</th>
								  <th scope="row">창고이름</th>	
								  <th scope="row">창고위치1</th>
								  <th scope="row">창고위치2</th>
								  <th scope="row">입고확인</th>
								  </tr>
							  	</thead>
								  <tbody id="my_tbody">
								  
								  </tbody>
								</table>
												</div>
												</div>
					

							<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 updateInBtn">입고확인</a>
													<a href="#" class="btn_gray01 InRegist_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="InRegist_close"><span>닫기</span></a>
					</div>
			  </div>
              <!-- contents end -->         