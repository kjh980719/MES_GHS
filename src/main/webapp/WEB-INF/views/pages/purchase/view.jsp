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
        searchorderList();  
	});

	$(".searchOrderBtn").click(function(){
	    searchorderList();
	});

	$(".selectSearch").change(function(){
	    searchorderList();
	});

	$(".enterSearch").keydown(function(event){
	    if (event.keyCode == 13){
	        searchorderList();
	    }
	});

	
	//검색후 page 설정하여 띄우기	
    var searchorderList = function () {
		
    	var postData = $("#searchForm").serializeObject();
		postData.currentPage = 1;
        postData.rowsPerPage = $("#rowPerPage_1").val();
        
        console.log("검색 :" + postData.REMARKS_WIN);
        $("#jqGrid_1").jqGrid('setGridParam', {
            postData: JSON.stringify(postData)
        }).trigger("reloadGrid");
    }
    
    $(".updateImportBtn").click(function(){
	    updateImport();
	    console.log("실행");
	});

	var updateImport = function () {
	        targetUrl = "/check/updateImport.json";
	        
	        var checkimportList =[];
	        
	        
	        for (var i = 0; i < $('#my_tbody tr').length; i++) {
	            var tmpMap = {};
	           
	            tmpMap.ORDER_CODE = $($("input[name='ORDER_CODE']")).val();
	            tmpMap.M_IN_DATE = $($("input[name='M_IN_DATE']")).val();
	            tmpMap.BUSINESS_NO = $($("input[name='BUSINESS_NO']")).val();
	            tmpMap.SUPPLY_NAME = $($("input[name='SUPPLY_NAME']")).val();
	            tmpMap.BIGO = $($("input[name='BIGO']")).val();
	            tmpMap.INSPECT_TYPE_CD = $($("input[name='INSPECT_TYPE_CD']")).val();
	            tmpMap.INSPECT_STATUS = $($("input[name='INSPECT_STATUS']")).val();
	            tmpMap.CHECK_YN=document.getElementById("CHECK_YN").options[document.getElementById("CHECK_YN").selectedIndex].value;
	            tmpMap.CHECK_MANAGER = $($("input[name='CHECK_MANAGER']")).val();
	            
	            tmpMap.NO = $($("input[name='NO']")[i]).val();
	            tmpMap.PDT_NAME = $($("input[name='PDT_NAME']")[i]).val();
	            tmpMap.CODE = $($("input[name='CODE']")[i]).val();
	            tmpMap.PDT_STANDARD = $($("input[name='PDT_STANDARD']")[i]).val();
	            tmpMap.QTY = $($("input[name='QTY']")[i]).val();
	            tmpMap.REAL_QTY = $($("input[name='REAL_QTY']")[i]).val();
	            tmpMap.UNIT = $($("input[name='UNIT']")[i]).val();
	           
	           checkimportList.push(tmpMap);
	        }
	        console.log(tmpMap);
	        
	        sendData = {};
	        sendData.checkimportList = checkimportList;
	        
	    
		if(checkOrderValid() && confirm("수정하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".updateImportBtn").off("click");
			var param = $("#OrderRegistForm").serializeObject();
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
		            $('#OrderRegist').popup("hide");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#OrderRegistForm input[name='"+response.code+"']").focus();
				}
    			$(".updateImportBtn").on("click", function(){updateImport();
    			});
			});
		}
	}
	
	var checkOrderValid = function () {
	    var valid = true;
   		$.each($("#OrderRegistForm .required"), function(){
            if($(this).val() == '') {
	            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
    			$(this).focus();
    			valid = false;
    			return false;
            }
        });
        if(valid) {
             if($('#OrderRegistForm input[name="PROD_CD"]').val() == "") {
                //수정시 패스워드 변경
                if(!checkPassword($("#OrderRegistForm input[name='PROD_CD']").val())) {
                    alert("품목코드를 입력해주세요");
                    $("#OrderRegistForm input[name='PROD_CD']").focus();
                    return false;
                }
                /* if($("#OrderRegistForm input[name='newPassword']").val() != $("#OrderRegistForm input[name='newPasswordConfirm']").val()) {
                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
                    $("#OrderRegistForm input[name='newPasswordConfirm']").focus();
                    return false;
                } */
            }else{
            	
            } /* else if($('#OrderRegistForm input[name="managerSeq"]').val() == "") {
                //신규 등록
                if($("#OrderRegistForm input[name='managerId']").val().length > 20) {
                    alert("관리자 아이디는 최대 20자 입니다.");
                    $("#OrderRegistForm input[name='managerId']").focus();
                    return false;
                }
                if(!checkPassword($("#OrderRegistForm input[name='password']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#OrderRegistForm input[name='password']").focus();
                    return false;
                }
            }  */

           
        }
	    return valid;
	}
    
    
	setCalendarDefault();
    var colModel = [
        {label: "매입일자", name:"PURCHASE_DATE", align: "center", width: "20", sortable: false,resizable:true},
        {label: "매입번호", name:"PURCHASE_NO", align: "center", width: "20", sortable: false,resizable:true},
        {label: "제품명", name:"PDT_NAME", align: "center", width: "20", sortable: false,resizable:true},
        {label: "규격", name:"PDT_STANDARD", align: "center", width: "20", sortable: false,resizable:true},
        {label: "수량", name:"QTY", align: "center", width: "20", sortable: false,resizable:true},
        {label: "단가", name:"UNIT_PRICE", align: "center", width: "20", sortable: false,resizable:true},
        {label: "공급가", name:"SUPPLY_PRICE", align: "center", width: "20", sortable: false,resizable:true},
        {label: "부가세", name:"VAT", align: "center", width: "20", sortable: false,resizable:true},
        {label: "총액", name:"TOTAL_PRICE", align: "center", width: "20", sortable: false,resizable:true},
        {label: "공급사 사업자번호", name:"BUSINESS_NO", align: "center", width: "20", sortable: false,resizable:true},
        {label: "비고", name:"BIGO", align: "center", width: "20", sortable: false,resizable:true}
        
    ];

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log(postData);
    creatJqGrid("jqGrid_1", "/purchase/getPurchaseList", colModel, postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");
    console.log(colModel);
    //관리자 신규등록 버튼 클릭
 	$(".popLayerOrderRegistBtn").click(function(){
	    $('#OrderRegistForm').resetForm();
        $('#OrderRegist').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#OrderRegist .firstFocus').focus();
            }
        });
		$('#OrderRegist').popup("show");
		$('#actionText').text("");
	}); 

    //관리자 수정을 위해 row 클릭시
     $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
        	var row = $(this).getRowData(id);
        	var INCD=Object.values(row)[1];
        	console.log(Object.values(row)[1]);
        	var rowdata;
            $('#OrderRegistForm').resetForm();
            $("#my_tbody tr").remove(); 

			$.ajax({
				type : "post",
				url : '/material/selectInBody',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"ORDER_CODE": INCD}),
				success : function(data) {
					 rowdata=data.storeData;
					 console.log(rowdata[0]);
					 var my_tbody = document.getElementById('my_tbody');
					 var cell1 = "";
			        	for(var i=0;i < rowdata.length;i++){
			        		 console.log(i + " : " + rowdata[i].NO);
				           
							cell1 += "<tr><td><input type='text' name='NO' id='NO"+i+"' value='"+rowdata[i].NO+"' readonly='readonly'/></td>";
							cell1 += "<td><input type='text' name='CODE' id='CODE"+i+"' value='"+rowdata[i].CODE+"'/></td>";
							cell1 += "<td><input type='text' name='PDT_NAME' id='PDT_NAME"+i+"' value='"+rowdata[i].PDT_NAME+"'/></td>";
			        		cell1 += "<td><input type='text' name='PDT_STANDARD' id='PDT_STANDARD"+i+"' value='"+rowdata[i].PDT_STANDARD+"'/></td>";
			        		cell1 += "<td><input type='text' name='QTY' id='QTY"+i+"' value='"+rowdata[i].QTY+"' readonly='readonly'/></td>";
			        		cell1 += "<td><input type='text' name='REAL_QTY' id='REAL_QTY"+i+"' value='"+rowdata[i].REAL_QTY+"'/></td>";
			        		cell1 += "<td><input type='text' name='UNIT' id='UNIT"+i+"' value='"+rowdata[i].UNIT+"'/></td>";
							
			        	}
// 						$('#my_tbody').append(cell1);
						$('#my_tbody').html(cell1);
						console.log(cell1);
                    }
			});

            $.ajax({
				type : "post",
				url : '/material/selectInHead',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"ORDER_CODE": INCD}),
				success : function(data) {
					 rowdata=data.storeData;		 
                    }
			});
        	
            console.log(rowdata);
			$('#OrderRegistForm input[name="PROD_CD"]').prop('readonly', true);
            $('#OrderRegist').popup({
                focuselement: "secondFocus",
                onopen: function() {
                    $('#OrderRegist .secondFocus').focus();
                }
            });
			setTableText(rowdata, "OrderRegistForm");
           
            $('#OrderRegist').popup("show");
        }
    });
})


$(".OrderRegist_close").click(function(e){
         
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

$(window).on('resize.jqGrid', function () {
    jQuery("#jqGrid_1").jqGrid( 'setGridWidth', $("#gridParent_1").width() );
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
						매입내역
					</h3>
        <!--  관리자  검색시작-->
                    <div class="top_mt10 bottom_mt20">
                    <form id="searchForm" onsubmit="return false">
                    <table cellpadding="0" cellspacing="0" class="mjlist_tbl01">
                  <caption></caption>
                        <tr>
                            <th scope="row">매입일자</th>
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
                                    <button type="button" class="btn_blue01 searchOrderBtn" >검색</button>
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
				<div class="layer_win01" style="width:1300px;display: none;" id="OrderRegist">
					<div>
						<form id="OrderRegistForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">수입검사</span>
								<input type="hidden" id="rowIndex"/>
												</h3>
							


	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 입고조회</caption>
								<tr>
									<th scope="row">발주코드<span class="keyf01">*</span></th>
									<td colspan="1" class="left_pt10"><input type="text" name="ORDER_CODE" class="text_box01 w_80  firstFocus required"/></td>
								</tr>
								<tr>
									<th scope="row">입고일자<span class="keyf01">*</span></th>
									<td colspan="1" class="left_pt10">
									<input type="text" name="M_IN_DATE" class="text_box01" readonly="readonly"/></td>
									<th scope="row">사업자번호<span class="keyf01">*</span></th>
									<td colspan="1" class="left_pt10">
									<input type="text" name="BUSINESS_NO" readonly="readonly"/></td>
								</tr>
								<tr>
									<th scope="row">공급사명</th>
									<td colspan="1" class="left_pt10">
									<input type="text" name="SUPPLY_NAME"/>
									</td>
									<th scope="row">비고<span class="keyf01">*</span></th>
									<td colspan="1" class="left_pt10">
									<input type="text" name="BIGO"/>
									</td>
								</tr>
								<tr>
									<th scope="row">검사유형</th>
									<td colspan="1" class="left_pt10">
									<input type="text" name="INSPECT_TYPE_CD"/>
									</td>
									<th scope="row">검사방법</th>
									<td colspan="1" class="left_pt10">
									<input type="text" name="INSPECT_STATUS"/>
									</td>
								</tr>
								<tr>
									<th scope="row">검사여부</th>
									<td colspan="1" class="left_pt10">
										<select name='CHECK_YN' id="CHECK_YN" >
										<option value='UII'>미검사</option>
						    			<option value='CII'>검사완료</option>
                                    	<option value='NII'>무검사품</option></select>
                                    
									</td>
									<th scope="row">검사자</th>
									<td colspan="1" class="left_pt10">
									<input type="text" name="CHECK_MANAGER"/>
									</td>
								</tr>
							</table>
							<table class="mjlist_tbl01 mjlist_tbl011">
							  	<thead>
								  <tr>
								  <th scope="row">NO</th>
								  <th scope="row">품목코드</th>	
								  <th scope="row">품목명</th>						
								  <th scope="row">규격</th>
								  <th scope="row">입고예정수량</th>
								  <th scope="row">입고수량</th>
								  <th scope="row">단위</th>

								  
								  </tr>
							  	</thead>
								  <tbody id="my_tbody">
								  
								  </tbody>
								</table>
												</div>
										
					

							<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 updateImportBtn">저장</a>
													<a href="#" class="btn_gray01 OrderRegist_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="OrderRegist_close"><span>닫기</span></a>
					</div>
			  </div>
              <!-- contents end -->         