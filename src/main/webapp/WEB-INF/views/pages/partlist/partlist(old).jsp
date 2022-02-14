<%@page import="com.fasterxml.jackson.annotation.JacksonInject.Value"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript">
$(document).ready(function() {
    
	$(".resetFormBtn").click(function(){
	    $('#searchForm').resetForm();
        searchpalletList();  
	});

	$(".searchPalletBtn").click(function(){
	    searchpalletList();
	});

	$(".selectSearch").change(function(){
	    searchpalletList();
	});

	$(".enterSearch").keydown(function(event){
	    if (event.keyCode == 13){
	        searchpalletList();
	    }
	});
	$(".PalletRegist_close").click(function(e){
        
		 $('#PalletBox').popup("hide");
	     window.close();  
	         
	   
	});

	
	//검색후 page 설정하여 띄우기	
    var searchpalletList = function () {
		
    	var postData = $("#searchForm").serializeObject();
		postData.currentPage = 1;
        postData.rowsPerPage = $("#rowPerPage_1").val();
        
        console.log("검색 :" + postData.REMARKS_WIN);
        $("#jqGrid_1").jqGrid('setGridParam', {
            postData: JSON.stringify(postData)
        }).trigger("reloadGrid");
    }
    
    $(".registpalletBtn").click(function(){
	    registpallet();
	    console.log("실행");
	});

	var registpallet = function () {
	    var targetUrl = "/pallet/createPallet.json";
		if(checkpalletValid() && confirm("저장 하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".registpalletBtn").off("click");
			var param = $("#PalletRegistForm").serializeObject();
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
		            $('#PalletRegist').popup("hide");
		            $('#PalletBarcord').popup("show");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#PalletRegistForm input[name='"+response.code+"']").focus();
				}
    			$(".registpalletBtn").on("click", function(){registpallet();});
			});
		}
	}
	
	var checkpalletValid = function () {
	    var valid = true;
   		$.each($("#palletRegistForm .required"), function(){
            if($(this).val() == '') {
	            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
    			$(this).focus();
    			valid = false;
    			return false;
            }
        });
        if(valid) { 
        }
	    return valid;
	}
    
    var PalletColModel = [
    	{label: "No", name:"rowIndex", align: "center", width: "10%", sortable: false},
        {label: "완제품코드", name:"CODE", align: "center", width: "10%", sortable: false},
        {label: "완제품명", name:"PDT_NAME", align: "center", width: "10%", sortable: false},
        {label: "원자재코드", name:"M_CODE", align: "center", width: "10%", sortable: false}
    ];

    
    
    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log("페이지 처음 들어왔을 때 : " + postData.REMARKS_WIN);
    creatJqGrid("jqGrid_1", "/partlist/getPartList", PalletColModel,  postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");

    //관리자 신규등록 버튼 클릭
 	$(".popLayerPalletRegistBtn").click(function(){
	    $('#PalletRegistForm').resetForm();
        $('#PalletRegist').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#PalletRegist .firstFocus').focus();
            }
        });
		$('#PalletRegist').popup("show");
		$('#actionText').text("파레트 등록");
	});  

    //관리자 수정을 위해 row 클릭시
    $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(rownum) {
        	var pallet_num=$(this)[0].rows[rownum].cells[1].innerHTML;
        	 console.log($(this)[0].rows[rownum].cells[1].innerHTML);
                var row=$.ajax({
                    type: "POST",
                    url: "/pallet/getPartList",
                    data: JSON.stringify({"pallet_num": pallet_num}),
                    contentType: "application/json",
    				dataType : "json",
                success : function(data) {
                	 var v=1;
                	 var box=sortObject(data);
                	 
                	 $('#PartList').empty();
                     $.each(box , function(key, value){
                    	 
               
                    	 $("#PartList").append('<tr><th>' + key +'</th><th>'+ value + '</th></tr>');
                    	
                    	
                    		 
                    });
                    if(Object.keys(data).length==0){
                 		
                 		$("#PartList").append('<tr><th> 값이 존재하지않습니다.</th></tr>');
                 	}
                     console.log(Object.keys(data).length);
                    

                }
                });
            
            
            $('#PalletBoxForm').resetForm();
		    $('#actionText').text("박스 정보");
            $('#PalletBox').popup({
                focuselement: "secondFocus",
                onopen: function() {
                    $('#PalletBox .secondFocus').focus();
                }
            });
            $('#PalletBox').popup("show");
           
        }
    });  
    
    
 	$('input[name=pallet_data]').change(function(e){
 		var src="https://barcode.tec-it.com/barcode.ashx?data="+$('input[name=pallet_data]').val()+"&code=DataMatrix&translate-esc=on";
 		document.getElementById("barcord").src=src;
 		console.log(src);
 	});
 	
 	$(".BarcordRegist_close").click(function(e){
 		$('#PalletBarcord').popup("hide");  
 	});
 	
 	function useYnFormat(cellValue, option, rowObject){
    	console.log("formatter");
    	return cellValue==1?'Y':'N';
   }

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
						PartList
					</h3>
					<div class="align_rgt mjinput">
						<div class="mjRight">
							<button type="button" class="btn_blue01 popLayerPalletRegistBtn">등록</button>
						</div>
					</div>
        <!--  관리자  검색시작-->
                    <div class="top_mt10 bottom_mt20">
                    <form id="searchForm" onsubmit="return false">
                    <table cellpadding="0" cellspacing="0" class="mjlist_tbl01">
                  <caption>PartList</caption>
                        <tr>
                            <th scope="row">사용여부</th>
                            <td colspan="4" class="left_pt10">
                                <select name="pallet_using" class="sel_box selectSearch">                                  
                                    <option value="1">사용</option>
                                    <option value="0">미사용</option>
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
                                    <button type="button" class="btn_blue01 searchPalletBtn" >검색</button>
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
                    <div class="layer_win01" style="width:800px;display: none;" id="PalletBarcord">
					<div>
						<form id="PalletBarcordForm">
<div style='text-align: center;'>
  <!-- insert your custom barcode setting your data in the GET parameter "data" -->
  <img id="barcord" alt='Barcode Generator TEC-IT'
       src=""/>
</div>
<div class="bottom_mt30 align_cen" style="margin-top: 32px;">

													<a href="#"  class="btn_gray01 BarcordRegist_close">닫기</a>
												</div>
</form>
</div>
</div>

<!-- 관리자 등록 contents -->
				<div class="layer_win01" style="width:800px;display: none;" id="PartListRegist">
					<div>
						<form id="PalletRegistForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">PartList 등록</span>
												</h3>

							<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<tr>
									<th scope="row">PartList</th>
									<td class="left_pt10" style="width:80%">
									<input type="text" name="pallet_data" class="sel_box w_98"/>
									</td>
								</tr>
								<tr>
								<th scope="row">완제품명</th>
								<td>
								<input type="text" class="sel_box w_98" name="PARTLIST_SEQ"  /></td>
								<td class="left_pt10" style="width:80%">
													품목번호
				
									</td></tr>
		
								</table>
							</div>
							<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 registpalletBtn">저장</a>
													<a href="#" class="btn_gray01 PalletRegist_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="PalletRegist_close"><span>닫기</span></a>
					</div>
			  </div>
			  
			  <div class="layer_win01" style="width:800px; display: none;" id="PalletBox">
					<div>
						<form id="PalletBoxForm">
							<h3 class="mjtit_top">
								<span id="actionText">박스정보 확인</span>
												</h3>

							<div class="top_mt10 bottom_mt20">
							<table id="PartList" cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							
							<thead><tr class="ui-jqgrid-labels" role="row"><th id="jqGrid_1_rowIndex" role="columnheader" class="ui-state-default ui-th-column ui-th-ltr" style="width: 144px;"><span class="ui-jqgrid-resize ui-jqgrid-resize-ltr" style="cursor: col-resize;">&nbsp;</span>
							<div id="jqgh_jqGrid_1_rowIndex" class="ui-jqgrid-sortable">박스번호<span class="s-ico" style="display:none">
							<span sort="asc" class="ui-grid-ico-sort ui-icon-asc ui-state-disabled ui-icon ui-icon-triangle-1-n ui-sort-ltr"></span>
							<span sort="desc" class="ui-grid-ico-sort ui-icon-desc ui-state-disabled ui-icon ui-icon-triangle-1-s ui-sort-ltr"></span></span>
							</div></th>
							<th id="jqGrid_1_managerId" role="columnheader" class="ui-state-default ui-th-column ui-th-ltr" style="width: 144px;"><span class="ui-jqgrid-resize ui-jqgrid-resize-ltr" style="cursor: col-resize;">&nbsp;</span><div id="jqgh_jqGrid_1_managerId" class="ui-jqgrid-sortable">바코드데이터<span class="s-ico" style="display:none"><span sort="asc" class="ui-grid-ico-sort ui-icon-asc ui-state-disabled ui-icon ui-icon-triangle-1-n ui-sort-ltr"></span><span sort="desc" class="ui-grid-ico-sort ui-icon-desc ui-state-disabled ui-icon ui-icon-triangle-1-s ui-sort-ltr"></span></span></div></th></tr></thead>
									
								</table>
							</div>
							<div class="bottom_mt30 align_cen">

													<a href="#" class="btn_gray01 PalletRegist_close">닫기</a>
												</div>
							</form>
							</div>
					
					<div class="group_close">
						<a href="#" class="PalletRegist_close"><span>닫기</span></a>
					</div>
			  </div>
              <!-- contents end -->         