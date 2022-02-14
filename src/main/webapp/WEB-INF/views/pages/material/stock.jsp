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
        searchMaterialList();
	});

	$(".searchMaterialBtn").click(function(){
	    searchMaterialList();
	});

	$(".selectSearch").change(function(){
	    searchMaterialList();
	});

	$(".enterSearch").keydown(function(event){
	    if (event.keyCode == 13){
	        searchMaterialList();
	    }
	});

	
	//검색후 page 설정하여 띄우기	
    var searchMaterialList = function () {
		
    	var postData = $("#searchForm").serializeObject();
		postData.currentPage = 1;
        postData.rowsPerPage = $("#rowPerPage_1").val();
        
        console.log("검색 :" + postData.REMARKS_WIN);
        $("#jqGrid_1").jqGrid('setGridParam', {
            postData: JSON.stringify(postData)
        }).trigger("reloadGrid");
    }
	
    $(".registMaterialBtn").click(function(){
	    registMaterial();
	    console.log("실행");
	});

	var registMaterial = function () {
	    var targetUrl = "/material/createMaterialStock.json";
	    if($("#MaterialStockForm input[name='rowIndex']").val() != "")
	        targetUrl = "/material/updateMaterialStock.json";
	    
		if(checkMaterialValid() && confirm("저장 하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".registMaterialBtn").off("click");
			var param = $("#MaterialStockForm").serializeObject();
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
		            $('#MaterialStock').popup("hide");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#MaterialStockForm input[name='"+response.code+"']").focus();
				}
    			$(".registMaterialBtn").on("click", function(){registMaterial();});
			});
		}
	}
	var checkMaterialValid = function () {
		 var valid = true;
	   		$.each($("#MaterialStockForm .required"), function(){
	            if($(this).val() == '') {
		            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
	    			$(this).focus();
	    			valid = false;
	    			return false;
	            }
	        });
	        if(valid) {
	             if($('#MaterialStockForm input[name="PROD_CD"]').val() == "") {
	                //수정시 패스워드 변경
	                if(!checkPassword($("#MaterialStockForm input[name='PROD_CD']").val())) {
	                    alert("품목코드를 입력해주세요");
	                    $("#MaterialStockForm input[name='PROD_CD']").focus();
	                    return false;
	                }
	                /* if($("#MaterialStockForm input[name='newPassword']").val() != $("#MaterialStockForm input[name='newPasswordConfirm']").val()) {
	                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
	                    $("#MaterialStockForm input[name='newPasswordConfirm']").focus();
	                    return false;
	                } */
	            }else{
	            	
	            } /* else if($('#MaterialStockForm input[name="managerSeq"]').val() == "") {
	                //신규 등록
	                if($("#MaterialStockForm input[name='managerId']").val().length > 20) {
	                    alert("관리자 아이디는 최대 20자 입니다.");
	                    $("#MaterialStockForm input[name='managerId']").focus();
	                    return false;
	                }
	                if(!checkPassword($("#MaterialStockForm input[name='password']").val())) {
	                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
	                    $("#MaterialStockForm input[name='password']").focus();
	                    return false;
	                }
	            }  */

	           
	        }
		    return valid;
		}
    
    
    
    setCalendarDefault();
    var colModel = [
        {label: "No", name:"rowIndex", align: "center", width: "10%", sortable: false},
        {label: "재고번호", name:"STOCK_SEQ", align: "center", width: "10%", sortable: false, hidden: true},
        {label: "품목 코드", name:"CODE", align: "center", width: "10%", sortable: false},
        {label: "품목명", name:"PDT_NAME", align: "center", width: "10%", sortable: false,},
        {label: "규격명", name:"PDT_STANDARD", align: "center", width: "10%", sortable: false},
        {label: "현재재고수량", name:"QTY", align: "center", width: "10%", sortable: false},
        {label: "변경수량", name:"CHANGE_QTY", align: "center", width: "10%", sortable: false},
        {label: "최종재고수량", name:"PDT_STOCK", align: "center", width: "10%", sortable: false},
        {label: "창고", name:"STORAGE_CODE", align: "center", width: "10%", sortable: false},
        {label: "작성일자", name:"WRITTEN_DATE", align: "center", width: "10%", sortable: false},
        {label: "작성자", name:"WRITTEN_BY", align: "center", width: "10%", sortable: false}
    ];

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log("페이지 처음 들어왔을 때 : " + postData.REMARKS_WIN);
    creatJqGrid("jqGrid_1", "/material/getMaterialStockList", colModel,  postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");

    //관리자 신규등록 버튼 클릭
 	$(".popLayerMaterialStockBtn").click(function(){
		$('#MaterialStockForm input[name="password"]').show();
	    $('#MaterialStockForm').resetForm();
        $('#MaterialStock').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#MaterialStock .firstFocus').focus();
            }
        });
		$('#MaterialStock').popup("show");
		$('#actionText').text("재고 등록");
	}); 

    //관리자 수정을 위해 row 클릭시
     $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
            var row = $(this).getRowData(id);
            var STOCK_SEQ=Object.values(row)[1];
            console.log(STOCK_SEQ);
        	var rowdata;
            $('#MaterialStockForm').resetForm();
            $.ajax({
				type : "post",
				url : '/material/selectMaterialStock',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"STOCK_SEQ": STOCK_SEQ}),
				success : function(data) {
					 rowdata=data.storeData;
	
                    		 
                    }
			});
            console.log(rowdata);
            $('#MaterialStock').popup("show");
			setTableText(rowdata, "MaterialStockForm");
        }
    }); 

    //수정시 비번 변경 버튼 클릭
	$("#MaterialStockForm #changePasswordBtn").click(function(){
		$('#MaterialStockForm .changePasswordSpan').show();
		$('#MaterialStockForm input[name="changePasswordYn"]').val("Y");
	});
   
})
$(document).ready(function(){
	
	$('ul.tabs li').click(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	})

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
						자재재고관리
					</h3>
					<div class="align_rgt mjinput">
						<div class="mjRight">
							<button type="button" class="btn_blue01 popLayerMaterialStockBtn">등록</button>
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
                            </td>--%>
                            <tr>
                            <th scope="row">등록일자</th>
                            <td class="left_pt10">
                                <input type="text" class="text_box01 m_pointer w_20" id="startDate" name="startDate"/>
                                <span class="keyf08 left_mt10 right_mt5">~</span> <input type="text" class="text_box01 m_pointer w_20" id="endDate" name="endDate"/>
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
                                    <button type="button" class="btn_blue01 searchMaterialBtn" >검색</button>
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
				<div class="layer_win01" style="width:800px;display: none;" id="MaterialStock">
					<div>
						<form id="MaterialStockForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">자재재고 확인</span>
								<input type="hidden" id="rowIndex"/>
												</h3>
							


	<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 자재 재고</caption>
								<tr>
									<th scope="row">품목명 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="CODE" class="text_box01 w_98  firstFocus" placeholder="제품코드 입력" alt="제품코드"/></td>
								</tr>
								<tr>
									<th scope="row">품목이름 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="PDT_NAME" class="text_box01 w_98  secondFocus" placeholder="제품이름 입력" alt="제품이름"/></td>
								</tr>
								<tr>
									<th scope="row">규격 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="PDT_STANDARD" class="text_box01 w_98 " placeholder="규격" alt="규격" /></td>
								</tr>
								<tr>
									<th scope="row">단위 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="UNIT" class="text_box01 w_98 " placeholder="단위" alt="단위" /></td>
								</tr>
								<tr>
									<th scope="row">현재재고수량 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="QTY" class="text_box01 w_98 "/>
									</td>
									
								</tr>
								<tr>
									<th scope="row">입고수량 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="CHANGE_QTY" class="text_box01 w_70 " value="0"/>
									
									</td>
									
								</tr>
								<tr>
									<th scope="row">최종재고량 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="PDT_STOCK" class="text_box01 w_70 " value="0"/>
									</td>
								</tr>
								<tr>
									<th scope="row">창고 </th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="STORAGE" class="text_box01 w_80 "/>
									</td>
								</tr>
								<tr>
									<th scope="row">입력일자</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="WRITTEN_DATE" class="text_box01 w_80 " placeholder="검색창내용" alt="검색창내용" />
									</td>
								</tr>
								<tr>
									<th scope="row">작성자</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="WRITTEN_BY"/>
									</td>
								</tr>
								<tr>
									<td>
									<input type="text" name=" ORDER_CODE" class="text_box01 w_80 " hidden= true/>
									</td>
								</tr>
							</table>
												</div>





						
							<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 registMaterialBtn">저장</a>
													<a href="#" class="btn_gray01 MaterialStock_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="MaterialStock_close"><span>닫기</span></a>
					</div>
			  </div>
              <!-- contents end -->