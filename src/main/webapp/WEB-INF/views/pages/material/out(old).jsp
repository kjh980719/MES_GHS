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
        
        console.log("검색 :" + postData.REMARKS_WIN);
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
	           
	            tmpMap.In_CODE = $($("input[name='In_CODE']")).val();
	            tmpMap.In_DATE = $($("input[name='In_DATE']")).val();
	            tmpMap.SUPPLY_NAME = $($("input[name='SUPPLY_NAME']")).val();
	            tmpMap.TOTAL_AMOUNT = $($("input[name='TOTAL_AMOUNT']")).val();
	            tmpMap.TAX_AMOUNT = $($("input[name='TAX_AMOUNT']")).val();
	            tmpMap.FAX_AMOUNT = $($("input[name='FAX_AMOUNT']")).val();
	            
	            
	            tmpMap.In_ADDR = $($("input[name='In_ADDR']")).val();
	            tmpMap.BIGO = $($("input[name='BIGO']")).val();
	            tmpMap.PHONENUMBER = $($("input[name='PHONENUMBER']")).val();
	            tmpMap.MANAGER_NAME = $($("input[name='MANAGER_NAME']")).val();
	            tmpMap.RECEPTION = $($("input[name='RECEPTION']")).val();
	            tmpMap.UPTAE = $($("input[name='UPTAE']")).val();
	            tmpMap.JONGMOK = $($("input[name='JONGMOK']")).val();
	            
	           tmpMap.NO = $($("input[name='NO']")[i]).val();
	           tmpMap.PDT_NAME = $($("input[name='PDT_NAME']")[i]).val();
	           tmpMap.CODE = $($("input[name='CODE']")[i]).val();
	           tmpMap.PDT_STANDARD = $($("input[name='PDT_STANDARD']")[i]).val();
	           tmpMap.QTY = $($("input[name='QTY']")[i]).val();
	           tmpMap.UNIT = $($("input[name='UNIT']")[i]).val();
	           tmpMap.UNIT_PRICE = $($("input[name='UNIT_PRICE']")[i]).val();
	           tmpMap.SUPPLY_PRICE = $($("input[name='SUPPLY_PRICE']")[i]).val();
	           tmpMap.DELIVERY_DATE = $($("input[name='DELIVERY_DATE']")[i]).val();
	           
	           InmaterialList.push(tmpMap);
	        }
	        console.log(tmpMap);
	        
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
        {label: "No", name:"rowIndex", align: "center", width: "10%", sortable: false},
        {label: "발주코드", name:"ORDER_CODE", align: "center", width: "10%", sortable: false},
        {label: "공급사명", name:"SUPPLY_NAME", align: "center", width: "10%", sortable: false},
        {label: "사업자번호", name:"BUSINESS_NO", align: "center", width: "10%", sortable: false},
        {label: "출고일자", name:"M_IN_DATE", align: "center", width: "10%", sortable: false}
        
    ];

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log(postData);
    creatJqGrid("jqGrid_1", "/material/getInList", colModel, postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");
    console.log(colModel);
    //관리자 신규등록 버튼 클릭
 	$(".popLayerOutRegistBtn").click(function(){
	    $('#InRegistForm').resetForm();
        $('#InRegist').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#InRegist .firstFocus').focus();
            }
        });
		$('#InRegist').popup("show");
		$('#actionText').text("");
	}); 

    //관리자 수정을 위해 row 클릭시
     $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
        	var row = $(this).getRowData(id);
        	var PCD=Object.values(row)[2];
        	console.log(Object.values(row)[2]);
        	var rowdata;
            $('#InRegistForm').resetForm();
            $("#my_tbody tr").remove(); 

            $.ajax({
				type : "post",
				url : '/material/selectInHead',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"M_IN_CODE": PCD}),
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
				data: JSON.stringify({"M_IN_CODE": PCD}),
				success : function(data) {
					 rowdata=data.storeData;
					 console.log(rowdata[0]);
					 var my_tbody = document.getElementById('my_tbody');
					 var cell1 = "";
			        	for(var i=0;i < rowdata.length;i++){
			        		 console.log(i + " : " + rowdata[i].NO);
				           
							cell1 += "<tr><td><input type='text' name='NO' id='NO"+i+"' value='"+rowdata[i].NO+"' readonly='readonly'/></td>";
							cell1 += "<tr><td><input type='text' name='ORDER_CODE' id='ORDER_CODE"+i+"' value='"+rowdata[i].ORDER_CODE+"' readonly='readonly'/></td>";
			        		cell1 += "<td><input type='text' name='CODE' id='CODE"+i+"' value='"+rowdata[i].CODE+"'/></td>";
							cell1 += "<td><input type='text' name='PDT_NAME' id='PDT_NAME"+i+"' value='"+rowdata[i].PDT_NAME+"'/></td>";
			        		cell1 += "<td><input type='text' name='PDT_STANDARD' id='PDT_STANDARD"+i+"' value='"+rowdata[i].PDT_STANDARD+"'/></td>";
			        		cell1 += "<td><input type='text' name='QTY' id='QTY"+i+"' value='"+rowdata[i].PDT_STANDARD+"'/></td>";
						    cell1 += "<td><input type='text' name='UNIT' id='UNIT"+i+"' value='"+rowdata[i].UNIT+"'/></td>";
						    cell1 += "<td><input type='text' name='UNIT_PRICE' id='UNIT_PRICE"+i+"' value='"+rowdata[i].UNIT_PRICE+"'/></td>";
							cell1 += "<td><input type='text' name='SUPPLY_PRICE' id='SUPPLY_PRICE"+i+"' value='"+rowdata[i].SUPPLY_PRICE+"'/></td>";
							cell1 += "<td><input type='button' id='1' value='확인' onclick='javascript:rowDel(this);'></td></tr>"
			        	}
// 						$('#my_tbody').append(cell1);
						$('#my_tbody').html(cell1);
						console.log(cell1);
                    }
			});
           
            $('#InRegist').popup("show");
// 			setTableText(rowdata, "InRegistForm");
        }
    }); 
    
     $(".ProductSearchBtn").click(function(){
    		searchProductList();
    	 }); 
})


$(".InRegist_close").click(function(e){
         
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

function rowDel(obj)
{
    var tr = obj.parentNode.parentNode;
    tr.parentNode.removeChild(tr);
}
var CNT=0
function addRow(){
	var tableData=document.getElementById('testTable');
/* 	var row=tableData.insertRow(tableData.rows.length); */
	CNT++;	
	
	$("#testTable").append(
			"<tr><td class='left_pt10'><input type='text' id='NO"+CNT+"' value='"+CNT+"' name='NO' readonly/></td>"
			+"<td class='left_pt10'><input id='PDT_NAME"+CNT+"' name='PDT_NAME' type='text' onclick='button1_click(PDT_NAME"+CNT+")'/></td>"
			+"<td class='left_pt10'><input id='CODE"+CNT+"' name='CODE' type='text'/></td>"
			+"<td class='left_pt10'><input id='PDT_STANDARD"+CNT+"' name='PDT_STANDARD' type='text'/></td>"
			+"<td class='left_pt10'><input id='QTY"+CNT+"' name='QTY' type='text'/></td>"
			+"<td class='left_pt10'><input id='UNIT"+CNT+"' name='UNIT' type='text'/></td>"
			+"<td class='left_pt10'><input id='UNIT_PRICE"+CNT+"' name='UNIT_PRICE' type='text'/></td>"
			+"<td class='left_pt10'><input id='SUPPLY_PRICE"+CNT+"' name='SUPPLY_PRICE' type='text'/></td>"
			+"<td class='left_pt10'><input id='VAT"+CNT+"' name='VAT' type='text'/></td>"
			+"</tr>");
	
};

function revertRow(){
	var tableData=document.getElementById('testTable');
	console.log(tableData.rows.length);
	if(tableData.rows.length > 1){
	var row=tableData.deleteRow(tableData.rows.length-1);
	CNT--;	
	}
};

function button1_click(s) {
    $('#ProductSearchForm').resetForm(); 
    $('#ProductSearch').popup({
        focuselement: "firstFocus",
        onopen: function() {
            $('#custRegist .firstFocus').focus();
        }
    });
    
    
  $('#ProductSearch').popup("show");
	console.log(s);
	console.log(s.id);

};


var searchProductList = function () {
    
    var postData2 = $("#ProductSearchForm").serializeObject();
  	 postData2.currentPage = 1;
     postData2.rowsPerPage = 10;
        /* $("#rowPerPage_1").val(); */
     
     console.log("검색 :" + postData2.REMARKS_WIN);
     $("#jqGrid_2").jqGrid('setGridParam', {
         postData2: JSON.stringify(postData2)
     }).trigger("reloadGrid");
 }
 
var colModel2 = [
    {label: "No", name:"rowIndex", align: "center", width: "160%", sortable: false},
    {label: "품목명", name:"PDT_NAME", align: "center", width: "160%", sortable: false},
    {label: "품목 코드", name:"CODE", align: "center", width: "160%", sortable: false},
    {label: "규격", name:"PDT_STANDARD", align: "center", width: "160%", sortable: false},
    {label: "단위", name:"UNIT", align: "center", width: "160%", sortable: false},
    {label: "단가", name:"IN_PRICE", align: "center", width: "160%", sortable: false},
    {label: "공급가", name:"PDT_BUY_PRICE", align: "center", width: "160%", sortable: false},
    {label: "부가세", name:"VAT_RATE_BY", align: "center", width: "160%", sortable: false}
     
];

 $("#jqGrid_2").jqGrid('setGridParam', {
     onSelectRow: function(id) {
        var row = $(this).getRowData(id);
        /* var pallet_num=$(this)[0].rows[rownum].cells[1].innerHTML; */
         console.log(row);
       $('#ProductSearch').popup("hide");
       if($(this).text() == row.authGroupName){
           $(this).prop("selected", true);
       }
       
       setTableText(row, "OrderForm"); 
        
     }
 });  


var postData2 = $("#ProductSearchForm").serializeObject();
postData2.currentPage = 1;
postData2.rowsPerPage = 10;
console.log(postData2);
creatJqGrid("jqGrid_2", "/order/getMaterialSearchList", colModel2,  postData2, "paginate_2", "dataCnt_2", "rowPerPage_2", "gridParent_2");
console.log(colModel2);


$(window).on('resize.jqGrid', function () {
    jQuery("#jqGrid_1").jqGrid( 'setGridWidth', $("#gridParent_1").width() );
});




</script>

					<h3 class="mjtit_top">
						자재출고
					</h3>
					
					<div class="align_rgt mjinput">
						<div class="mjRight">
							<button type="button" class="btn_blue01 popLayerOutRegistBtn">등록</button>
						</div>
					</div>
        <!--  관리자  검색시작-->
                    <div class="top_mt10 bottom_mt20">
                    <form id="searchForm" onsubmit="return false">
                    <table cellpadding="0" cellspacing="0" class="mjlist_tbl01">
                  <caption></caption>
                        <tr>
                            <th scope="row">출고일자</th>
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
                                <select name="DEL_STATUS" class="sel_box selectSearch">
                                	<option value=''>전체</option> 
                               	    <option value=''>출고예정</option>                              
                                    <option value='DC'>출고</option>
                                    <option value='NC'>완료</option>
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
								<span id="actionText">자재출고</span>
								<input type="hidden" id="rowIndex"/>
												</h3>
							


	<div id="tab-1" class="tab-content current">
	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 자재출고조회</caption>
								<tr>
									<th scope="row">공급자<span class="keyf01">*</span></th>
									<td colspan="4" class="left_pt10" style="width:80%">
									<input type="text" name="DEL_MANAGER_NAME" class="text_box01 w_98" readonly="readonly"/></td>
								</tr>
								
							</table>
							<input class="align_lft" type="button" value="품목추가" onclick="addRow()"/>
                     		<input class="align_lft" type="button" value="품목삭제" onclick="revertRow()"/>
							<table id="testTable" class="mjlist_tbl01 mjlist_tbl011">
								  <tr>
								  <th scope="row">NO</th>
								  <th scope="row">발주코드</th>						
								  <th scope="row">품목코드</th>
								  <th scope="row">품목명</th>
								  <th scope="row">출고수량</th>
								  <th scope="row">단위</th>
								  <th scope="row">단가</th>
								  <th scope="row">공급가액</th>	
								  <th scope="row">출고확인</th>
								  </tr>
								</table>
												</div>
												</div>
					

							<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 updateInBtn">저장</a>
													<a href="#" class="btn_gray01 InRegist_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="InRegist_close"><span>닫기</span></a>
					</div>
			  </div>
			  
			  <div class="layer_win01" style="width:1300px;display: none;" id="ProductSearch">
               <div>
                  <form id="ProductSearchForm">
                     <h3 class="mjtit_top">
                        <span id="actionText">원자재검색</span>
                                    </h3>

                     <!--  관리자 등록-->
                     <div class="top_mt10 bottom_mt20">
                     <table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
                     <caption>
                      제품검색 양식</caption>
                        
                        <tr>
                           <th scope="row">원자재 <span class="keyf01">*</span></th>
                           <td class="left_pt10" style="width:80%"><input type="text" name="REMARKS_WIN" class="text_box01 w_85 custEnterSearch" />
                           <button type="button" class="ProductSearchBtn" >검색</button>
                           
                           </td>
                        </tr>
                     </table>
                     
                     </div>
                                    
                        </form>
                                      <div class="mjinput">
											<div class="mjLeft">
												총 <span id="dataCnt_2" class="number3 keyf06"> </span> 건
											</div>
											<div class="mjRight">
						<select name="" id="rowPerPage_2" class=" sel_box">
                            <option value="15">15개씩 보기</option>
                            <option value="30">30개씩 보기</option>
                            <option value="50">50개씩 보기</option>
                            <option value="100">100개씩 보기</option>
                        </select>
											</div>
                        
                    </div>
                    <div class="col" id="gridParent_2">
                    <table id="jqGrid_2" class="display" cellspacing="0" cellpadding="0"></table>
                    <div id="paginate_2" class="mjpaging_comm" style="margin-top: 32px; margin-bottom: 42px"></div>
                    </div>
                          
                          <!-- 하단버튼 -->
                                    <div class="bottom_mt30 align_cen">
                                       <a href="#" class="btn_gray01 ProductSearch_close">닫기</a>
                                    </div>
                                    <div class="group_close">
						<a href="#" class="btn_gray01 ProductSearch_close">닫기</a>
					</div>
                  
               </div>
               </div>
              <!-- contents end -->         