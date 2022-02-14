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
	    var targetUrl = "/material/createMaterial.json";
	    if($("#MaterialStockStorageForm input[name='rowIndex']").val() != "")
	        targetUrl = "/material/updateMaterial.json";
	    
		if(checkMaterialValid() && confirm("저장 하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".registMaterialBtn").off("click");
			var param = $("#MaterialStockStorageForm").serializeObject();
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
    				$("#MaterialStockStorageForm input[name='"+response.code+"']").focus();
				}
    			$(".registMaterialBtn").on("click", function(){registMaterial();});
			});
		}
	}
	var checkMaterialValid = function () {
		 var valid = true;
	   		$.each($("#MaterialStockStorageForm .required"), function(){
	            if($(this).val() == '') {
		            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
	    			$(this).focus();
	    			valid = false;
	    			return false;
	            }
	        });
	        if(valid) {
	             if($('#MaterialStockStorageForm input[name="PROD_CD"]').val() == "") {
	                //수정시 패스워드 변경
	                if(!checkPassword($("#MaterialStockStorageForm input[name='PROD_CD']").val())) {
	                    alert("품목코드를 입력해주세요");
	                    $("#MaterialStockStorageForm input[name='PROD_CD']").focus();
	                    return false;
	                }
	                /* if($("#MaterialStockStorageForm input[name='newPassword']").val() != $("#MaterialStockStorageForm input[name='newPasswordConfirm']").val()) {
	                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
	                    $("#MaterialStockStorageForm input[name='newPasswordConfirm']").focus();
	                    return false;
	                } */
	            }else{
	            	
	            } /* else if($('#MaterialStockStorageForm input[name="managerSeq"]').val() == "") {
	                //신규 등록
	                if($("#MaterialStockStorageForm input[name='managerId']").val().length > 20) {
	                    alert("관리자 아이디는 최대 20자 입니다.");
	                    $("#MaterialStockStorageForm input[name='managerId']").focus();
	                    return false;
	                }
	                if(!checkPassword($("#MaterialStockStorageForm input[name='password']").val())) {
	                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
	                    $("#MaterialStockStorageForm input[name='password']").focus();
	                    return false;
	                }
	            }  */

	           
	        }
		    return valid;
		}
    
    
    
    setCalendarDefault();
    var colModel = [
        {label: "No", name:"rowIndex", align: "center", width: "10%", sortable: false},
        {label: "품목번호", name:"PDT_CD", align: "center", width: "10%", sortable: false},
        {label: "품목코드", name:"CODE", align: "center", width: "10%", sortable: false},
        {label: "품목명", name:"PDT_NAME", align: "center", width: "10%", sortable: false},
        {label: "총재고량", name:"PDT_STOCK", align: "center", width: "10%", sortable: false}
    ];
    
    $(window).on('resize.jqGrid', function () {
        jQuery("#jqGrid_1").jqGrid( 'setGridWidth', $("#gridParent_1").width() );
    });

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log("페이지 처음 들어왔을 때 : " + postData.REMARKS_WIN);
    creatJqGrid("jqGrid_1", "/material/getMaterialList", colModel,  postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");

    //관리자 신규등록 버튼 클릭
 	$(".popLayerMaterialStockBtn").click(function(){
	    $('#MaterialStockStorageForm').resetForm();
        $('#MaterialStock').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#MaterialStock .firstFocus').focus();
            }
        });
		$('#MaterialStock').popup("show");
		$('#actionText').text("관리자 등록");
	}); 

    //관리자 수정을 위해 row 클릭시
     $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
            var row = $(this).getRowData(id);
            var STORAGE_CODE=Object.values(row)[2];
            console.log(STORAGE_CODE);
        	var rowdata;
            $('#MaterialStockStorageForm').resetForm();
            $.ajax({
				type : "post",
				url : '/material/selectMaterialStockStorage',
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify({"STORAGE_CODE": STORAGE_CODE}),
				success : function(data){
               	 var v=1;
            	 var box=sortObject(data);
            	 
            	 console.log(data);
            	 
            	 $('#StockList').empty();
                 $.each(box , function(key, value){
                	 
           
                	 $("#StockList").append('<tr><th>' + key +'</th><th>'+ value + '</th></tr>');
                	
                	
                		 
                });
                if(Object.keys(data).length==0){
             		
             		$("#StockList").append('<tr><th> 값이 존재하지않습니다.</th></tr>');
             	}
                 console.log(Object.keys(data).length);
                

            }
			});
            console.log(rowdata);
            $('#MaterialStock').popup("show");
			setTableText(rowdata, "MaterialStockStorageForm");
        }
    }); 

    
     function sortObject(o)

  	{
  	    var sorted = {},

  	    key, a = [];
  	    // 키이름을 추출하여 배열에 집어넣음

  	    for (key in o) {

  	        if (o.hasOwnProperty(key)) a.push(key);

  	    }
  	    // 키이름 배열을 정렬

  	    a.sort(function(a,b){
  	       return (Number(a.match(/(\d+)/g)[0]) - Number((b.match(/(\d+)/g)[0])));});

  	    // 정렬된 키이름 배열을 이용하여 object 재구성

  	    for (key=0; key<a.length; key++) {

  	        sorted[a[key]] = o[a[key]];

  	    }

  	    return sorted;

  	}
   
})


</script>

					<h3 class="mjtit_top">
						창고별재고현황
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
 
                            <tr>
                            <th scope="row">검색</th>
                            <td colspan="4" class="left_pt10">
                                <input type="text" class="text_box01 w_30 enterSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">창고</th>
                            <td colspan="4" class="left_pt10">
                                <input type="text" class="text_box01 w_30 enterSearch" name="STORAGE_CODE" />
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
						<form id="MaterialStockStorageForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">품목별재고현황</span>
								<input type="hidden" id="rowIndex"/>
												</h3>
							


							<div class="top_mt10 bottom_mt20">
							<table id="BoxList" cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							
							<thead><tr class="ui-jqgrid-labels" role="row">
							<th id="jqGrid_1_rowIndex" role="columnheader" class="ui-state-default ui-th-column ui-th-ltr" style="width: 144px;"><span class="ui-jqgrid-resize ui-jqgrid-resize-ltr" style="cursor: col-resize;">&nbsp;</span>
							<div id="jqgh_jqGrid_1_rowIndex" class="ui-jqgrid-sortable">창고번호<span class="s-ico" style="display:none">
							<span sort="asc" class="ui-grid-ico-sort ui-icon-asc ui-state-disabled ui-icon ui-icon-triangle-1-n ui-sort-ltr"></span>
							<span sort="desc" class="ui-grid-ico-sort ui-icon-desc ui-state-disabled ui-icon ui-icon-triangle-1-s ui-sort-ltr"></span></span>
							</div></th>
							<th id="jqGrid_1_managerId" role="columnheader" class="ui-state-default ui-th-column ui-th-ltr" style="width: 144px;"><span class="ui-jqgrid-resize ui-jqgrid-resize-ltr" style="cursor: col-resize;">&nbsp;</span><div id="jqgh_jqGrid_1_managerId" class="ui-jqgrid-sortable">창고코드<span class="s-ico" style="display:none"><span sort="asc" class="ui-grid-ico-sort ui-icon-asc ui-state-disabled ui-icon ui-icon-triangle-1-n ui-sort-ltr"></span><span sort="desc" class="ui-grid-ico-sort ui-icon-desc ui-state-disabled ui-icon ui-icon-triangle-1-s ui-sort-ltr"></span></span></div></th>
							<th id="jqGrid_1_managerId" role="columnheader" class="ui-state-default ui-th-column ui-th-ltr" style="width: 144px;"><span class="ui-jqgrid-resize ui-jqgrid-resize-ltr" style="cursor: col-resize;">&nbsp;</span><div id="jqgh_jqGrid_1_managerId" class="ui-jqgrid-sortable">품목코드<span class="s-ico" style="display:none"><span sort="asc" class="ui-grid-ico-sort ui-icon-asc ui-state-disabled ui-icon ui-icon-triangle-1-n ui-sort-ltr"></span><span sort="desc" class="ui-grid-ico-sort ui-icon-desc ui-state-disabled ui-icon ui-icon-triangle-1-s ui-sort-ltr"></span></span></div></th>
							<th id="jqGrid_1_managerId" role="columnheader" class="ui-state-default ui-th-column ui-th-ltr" style="width: 144px;"><span class="ui-jqgrid-resize ui-jqgrid-resize-ltr" style="cursor: col-resize;">&nbsp;</span><div id="jqgh_jqGrid_1_managerId" class="ui-jqgrid-sortable">품목명<span class="s-ico" style="display:none"><span sort="asc" class="ui-grid-ico-sort ui-icon-asc ui-state-disabled ui-icon ui-icon-triangle-1-n ui-sort-ltr"></span><span sort="desc" class="ui-grid-ico-sort ui-icon-desc ui-state-disabled ui-icon ui-icon-triangle-1-s ui-sort-ltr"></span></span></div></th>
							<th id="jqGrid_1_managerId" role="columnheader" class="ui-state-default ui-th-column ui-th-ltr" style="width: 144px;"><span class="ui-jqgrid-resize ui-jqgrid-resize-ltr" style="cursor: col-resize;">&nbsp;</span><div id="jqgh_jqGrid_1_managerId" class="ui-jqgrid-sortable">수량<span class="s-ico" style="display:none"><span sort="asc" class="ui-grid-ico-sort ui-icon-asc ui-state-disabled ui-icon ui-icon-triangle-1-n ui-sort-ltr"></span><span sort="desc" class="ui-grid-ico-sort ui-icon-desc ui-state-disabled ui-icon ui-icon-triangle-1-s ui-sort-ltr"></span></span></div></th>
							<th id="jqGrid_1_managerId" role="columnheader" class="ui-state-default ui-th-column ui-th-ltr" style="width: 144px;"><span class="ui-jqgrid-resize ui-jqgrid-resize-ltr" style="cursor: col-resize;">&nbsp;</span><div id="jqgh_jqGrid_1_managerId" class="ui-jqgrid-sortable">창고코드<span class="s-ico" style="display:none"><span sort="asc" class="ui-grid-ico-sort ui-icon-asc ui-state-disabled ui-icon ui-icon-triangle-1-n ui-sort-ltr"></span><span sort="desc" class="ui-grid-ico-sort ui-icon-desc ui-state-disabled ui-icon ui-icon-triangle-1-s ui-sort-ltr"></span></span></div></th></tr></thead>
									
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