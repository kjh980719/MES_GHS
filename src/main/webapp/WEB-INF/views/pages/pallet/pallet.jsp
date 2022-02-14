<%@page import="com.fasterxml.jackson.annotation.JacksonInject.Value"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript">
$(document).ready(function() {
    
	$(".resetFormBtn").click(function(){
	    // $('#searchForm').resetForm();
        // searchpalletList();
		location.href='/pallet/pallet';
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
		
    	// var postData = $("#searchForm").serializeObject();
		// postData.currentPage = 1;
        // postData.rowsPerPage = $("#rowPerPage_1").val();

		var rowsPerPage = $('#rowPerPage_1').val();
		$('#rowsPerPage').val(rowsPerPage);
		$('#searchForm').submit();


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
					parent.location.reload();
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
            /* if($('#palletRegistForm input[name="changePasswordYn"]').val() == "Y") {
                //수정시 패스워드 변경
                if(!checkPassword($("#palletRegistForm input[name='newPassword']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#palletRegistForm input[name='newPassword']").focus();
                    return false;
                }
                if($("#palletRegistForm input[name='newPassword']").val() != $("#palletRegistForm input[name='newPasswordConfirm']").val()) {
                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
                    $("#palletRegistForm input[name='newPasswordConfirm']").focus();
                    return false;
                }
            } else if($('#palletRegistForm input[name="managerSeq"]').val() == "") {
                //신규 등록
                if($("#palletRegistForm input[name='managerId']").val().length > 20) {
                    alert("관리자 아이디는 최대 20자 입니다.");
                    $("#palletRegistForm input[name='managerId']").focus();
                    return false;
                }
                if(!checkPassword($("#palletRegistForm input[name='password']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#palletRegistForm input[name='password']").focus();
                    return false;
                }
            } */

           
        }
	    return valid;
	} 

    //관리자 수정을 위해 row 클릭시

    
 	$('input[name=pallet_barcode]').change(function(e){
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



 	
})

 	function CreateBarCode(){
		
 		var gap=$('#endnum').val()-$('#startnum').val();
 		console.log(i);
 		if(i>0){
    	if (confirm("파레트를 생성 하시겠습니까? ")) {
    		for(var i = 0; i < $("input:checkbox[name='STOR_SEQ']:checked").length ; i++){
    			$("input:checkbox[name='STOR_SEQ']:checked"[i]).val;
    		
    		  $.ajax({
 	            type : "post",
 	            url : '/pallet/CreatePallet',
 	            async : false,
 	            data: "pallet_num="+pallet_num,
 	            success : function(data) {
 	            	alert(" 파레트가 생성되었습니다. ")
 	            }
 	            });
    		};
  	      
  	    }
 		}else if($('#startnum').val()=="" || Number.isInteger(($('#startnum').val())+0)){
 			alert("시작번호를 다시입력해주세요")
 			
 		}else if($('#endnum').val()=="" || Number.isInteger(($('#endnum').val())+0)){
 			alert("끝번호를 다시입력해주세요")
 		}
 	}
</script>



					<h3 class="mjtit_top">
						파레트 관리
								<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
                <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/pallet/pallet">
                    	<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
                    <div class="srch_all">
                    	
                    	<div class="sel_wrap sel_wrap1">
                    		    <select name="pallet_status" class="sel_02">
                    		        <option value="" ${pallet_status == ""?"selected":""}>전체</option>     
                                    <option value="SP" ${pallet_status == SP?"selected":""}>창고</option>                              
                                    <option value="WP" ${pallet_status == WP?"selected":""}>대기</option>
                                    <option value="N" ${pallet_status == N?"selected":""}>미사용</option>
                                </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" name="search_string" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                              <button type="button" class="btn_01">초기화</button> 
                          </div>
                    </div>
                
                    </form>
                     <div class="srch_day srch_day1">
                    	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate">바코드 번호</label>
                    		</div>
                    		<div class="day_input">
                    			<input type="text" id="startnum" name="startnum" />
                    		</div>
                    		<span class="sup">~</span>
                    		<div class="day_input">
                    			<input type="text" id="endnum" name="endnum" />
                    			

                    		</div>
                    		<button type="button" class="btn_02" onclick="CreateBarCode();">생성</button>
							
                    	</div>
                    	
                    </div>
                    
                    </div><!-- 검색  끝-->


<!-- 리스트 시작-->


<div class="master_list ">
	<div class="list_set ">
		<div class="set_left">
			총 <span id="dataCnt_1" >${list[0].totalCount}</span> 건
		</div>
		<div class="set_right">
			<div class="sel_wrap">
				<select name="rowPerPage_1" id="rowPerPage_1" class="sel_01">
					<option value="15"<c:if test="${search.rowsPerPage == '15'}">selected</c:if>>15개씩 보기</option>
					<option value="30"<c:if test="${search.rowsPerPage == '30'}">selected</c:if>>30개씩 보기</option>
					<option value="50"<c:if test="${search.rowsPerPage == '50'}">selected</c:if>>50개씩 보기</option>
					<option value="100"<c:if test="${search.rowsPerPage == '100'}">selected</c:if>>100개씩 보기</option>
				</select>
			</div>
		</div>
	</div>
	<div class="scroll">
		<table class="master_01 master_06" id="palletTable">
			<colgroup>

				<col style="width: 55px">
				<col style="width: 90px">
				<col style="width: 120px">
				<col style="width: 400px">
				<col style="width: 110px">
				<col style="width: 100px">
			</colgroup>
			<thead>
			<tr>
				<th>No</th>
				<th>파레트번호</th>
				<th>파레트바코드</th>
				<th>박스정보</th>
				<th>생성일자</th>
				<th>상태</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${list}" var="list" varStatus="i">
				<tr>
					<td class="rowIndex"><fmt:formatNumber value="${list.totalCount-(list.rowIndex-1)}" pattern="#,###,###"/></td>
				<td class="pallet_num">${list.pallet_num}</td> 
					<td class="prod">${list.pallet_barcode}</td>
					<td class="box">${list.box_data1}</td>
					<td class="regist"><fmt:formatDate value="${list.regist_day}" pattern="yyyy-MM-dd"/></td>
					<td class="pallet_status">${list.pallet_status}</td>
				</tr>
			</c:forEach>
			<c:if test="${empty list }">
				<tr><td colspan="4">파레트 정보가 없습니다.</td></tr>
			</c:if>

			</tbody>
		</table>
	</div>
	<div class="mjpaging_comm">
		${dh:pagingB(list[0].totalCount, search.currentPage, search.rowsPerPage, 5, parameter)}
	</div>
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

<div class="bottom_mt30 align_cen" style="margin-top: 32px;">

													<a href="#"  class="btn_gray01 BarcordRegist_close">닫기</a>
												</div>
</form>
</div>
</div>

<!-- 관리자 등록 contents -->
				<div class="layer_win01" style="width:800px;display: none;" id="PalletRegist">
					<div>
						<form id="PalletRegistForm">
						
							<h3 class="mjtit_top">
								<span id="actionText">파레트 등록</span>
												</h3>

							<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
								<tr>
									<th scope="row">파레트 바코드정보</th>
									<td class="left_pt10" style="width:80%"><input type="text" name="pallet_barcode" id="pallet_barcode" class="text_box01 firstFocus" placeholder="" alt=""/></td>
								</tr>
								<tr>
								<td class="left_pt10" style="width:80%">
													파레트번호
									<select name="pallet_num" class="sel_box ">                          
                                    <c:forEach begin="1" end="160" step="1" var="Pallet_Num">
                                    	<c:set var="contains_flag" value="false"></c:set>
                              			<c:forEach items="${PalletList}" var="ex_num" varStatus="status">
                              				<c:if test="${ex_num.pallet_num == Pallet_Num}">
                              					<c:set var="contains_flag" value="true"/>
                              				</c:if>
                              			</c:forEach>
                              			<c:if test="${!contains_flag}">
                              				<option value="${Pallet_Num}">${Pallet_Num}번</option>
                              			</c:if>
                                    </c:forEach>
                                	</select>
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
							<table id="BoxList" cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							
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
<script>
	// 테이블의 Row 클릭시 값 가져오기
	$("#palletTable tr").click(function(){
		var tdArr = new Array();	// 배열 선언

		// 현재 클릭된 Row(<tr>)
		var tr = $(this);
		var td = tr.children();

		// 반복문을 이용해서 배열에 값을 담아 사용할 수 도 있다.
		td.each(function(i){
			tdArr.push(td.eq(i).text());
		});

		// td.eq(index)를 통해 값을 가져올 수도 있다.
		var rowIndex = td.eq(0).text();
		var pallet_num = td.eq(1).text();
		var pallet_barcode = td.eq(2).text();
		var pallet_status = td.eq(3).text();

		$.ajax({
			type: "POST",
			url: "/pallet/getBoxList",
			data: JSON.stringify({"pallet_num": pallet_num}),
			contentType: "application/json",
			dataType : "json",
			success : function(data) {
				var v=1;
				var box=sortObject(data);

				$('#BoxList').empty();
				$.each(box , function(key, value){


					$("#BoxList").append('<tr><th>' + key +'</th><th>'+ value + '</th></tr>');



				});
				if(Object.keys(data).length==0){

					$("#BoxList").append('<tr><th> 값이 존재하지않습니다.</th></tr>');
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
</script>