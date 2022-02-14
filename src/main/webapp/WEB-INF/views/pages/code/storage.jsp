<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript">
    <%
    UserInfo user = Util.getUserInfo();
    %>
    
	
	
    function updateDepthInfo(){
    	
    	
        var param = $("#storageInfo_Form").serialize();
        console.log(param);
        var frmL = eval('document.storageInfo_Form');   
	    var frmP = document.frmProc;
	    console.log(param.STOR_UPPER);
	  
	    if (frmL.STOR_NAME.value == '') {
	      alert("분류명을 입력하세요.");
	      frmL.STOR_NAME.focus();
	      return false;
	    }
	    if (frmL.STOR_CD.value == '') {
		      alert("창고코드를 입력하세요.");
		      frmL.STOR_CD.focus();
		      return false;
		    }
	    if (frmL.STOR_SORT.value == '') {
	      alert("정렬순서를 입력하세요.");
	      frmL.STOR_SORT.focus();
	      return false;
	    }
	    
	    if (confirm(" 완료 하시겠습니까? ")) {
	      frmP.STOR_SEQ.value = frmL.STOR_SEQ.value;
	      frmP.STOR_DEPTH.value = frmL.STOR_DEPTH.value;
	      frmP.STOR_UPPER.value = frmL.STOR_UPPER.value;
	      frmP.STOR_NAME.value = frmL.STOR_NAME.value;
	      frmP.STOR_SORT.value = frmL.STOR_SORT.value;
	      frmP.STOR_CD.value = frmL.STOR_CD.value;
	      frmP.mode.value = frmL.type.value;
		    
	        frmP.submit();
	    }
    }
    
    
    function editDepthInfo(STOR_SEQ,STOR_NAME,STOR_CD,STOR_DEPTH,STOR_SORT,STOR_UPPER){
    	storageInfoLayer_Open(STOR_SEQ,STOR_NAME,STOR_CD,STOR_DEPTH,STOR_SORT,STOR_UPPER,"edit");
    }
    
    
    function storageInfoLayer_Close(){
    	$('#storageInfoLayer').removeClass('view');
    	$('html,body').css('overflow','');
    	$('.info_edit').removeClass('view');		
    }
    
    function storageInfoLayer_Open(STOR_SEQ,STOR_NAME,STOR_CD,STOR_DEPTH,STOR_SORT,STOR_UPPER,type){
    	//메뉴추가 및 수정시 레이어팝업 띄우는 함수
    	
    	var frmC = document.frmCate;    
        frmC.STOR_LOOP.value = STOR_DEPTH;
        frmC.STOR_SEQ.value = STOR_SEQ;
        var a=$('#STOR_CD1').val();
        console.log(a);
       
        console.log($('#STOR_CD1').val());
        
        if (STOR_DEPTH == '2') {
          frmC.STOR2_UPPER.value = STOR_UPPER;
          frmC.STOR2_DEPTH.value = STOR_DEPTH;
          var a=document.getElementsByName("STOR_CD");
          console.log(a);
          console.log("aaa");
        }
        if (STOR_DEPTH == '3') {
          frmC.STOR3_UPPER.value = STOR_UPPER;
          frmC.STOR3_DEPTH.value = STOR_DEPTH;  
        }
        if (STOR_DEPTH == '4') {
          frmC.STOR4_UPPER.value = STOR_UPPER;
          frmC.STOR4_DEPTH.value = STOR_DEPTH;
        }
        
        $('#STOR_SEQ').val(STOR_SEQ);
		$('#STOR_UPPER').val(STOR_UPPER);
		$('#STOR_DEPTH').val(STOR_DEPTH);
		$('#type').val(type);
		 
    	var text = "";
    	if (type == "edit"){
    		/* editCate(STOR_SEQ, STOR_DEPTH, STOR_UPPER); */
    			 $('#storageInfo_Form').resetForm();
    			 $('#STOR_DEPTH').val(STOR_DEPTH);
    			 $('#STOR_CD').val(STOR_CD);
    			 $('#STOR_SORT').val(STOR_SORT);
    			 $('#STOR_NAME').val(STOR_NAME);
    			 
    		     $('#depthBtn').html("수정");
    		     $('#layer_title').html("메뉴 수정");
    			
    		
    	}else{
    		
    		
    		$('#storageInfo_Form').resetForm();
    		$('#depthBtn').html("저장");
    		
    		$('#layer_title').html("창고 추가");
    		$('#status').val(type);
    		if(STOR_DEPTH == '1'){
    		  $('#STOR_CD').val("KR");
    		}
    	}

    	$('#storageInfoLayer').addClass('view');
    	$('html,body').css('overflow','hidden');
    	$('.leftNav').removeClass('view');
    }
    
    function PrintBarCode(){
    	if (confirm(" 바코드를 출력 하시겠습니까? ")) {
    		for(var i = 0; i < $("input:checkbox[name='STOR_SEQ']:checked").length ; i++){
    			$("input:checkbox[name='STOR_SEQ']:checked"[i]).val;
    			
    			console.log($("input:checkbox[name='STOR_SEQ']:checked").eq(i).attr("value"));
    			console.log($("input:checkbox[name='STOR_BARCODE']").eq(i).attr("value"));
    		
    		  $.ajax({
 	            type : "post",
 	            url : '/code/PrintBarCode',
 	            async : false,
 	            data: "STOR_BARCODE="+$("input:checkbox[name='STOR_BARCODE']"[i]).val,
 	            success : function(data) {
 	            	alert(" 바코드가 출력되었습니다. ")
 	            }
 	            });
    		};
  	      
  	    }
    }
	
	 function storageChange(STOR_SEQ) {
	    location.href = "/code/storage";
	  }
	  
	 
	  
	function entrySub(STOR_LOOP, STOR_SEQ) {
	    var frmC = document.frmCate;    
	    frmC.STOR_LOOP.value = STOR_LOOP; 
	    console.log(STOR_LOOP);
	    
	    if (STOR_LOOP == '2') {
	      frmC.STOR2_UPPER.value = STOR_SEQ;
	      frmC.STOR2_DEPTH.value = STOR_LOOP; 
	    }
	    if (STOR_LOOP == '3') {
	      frmC.STOR3_UPPER.value = STOR_SEQ;
	      frmC.STOR3_DEPTH.value = STOR_LOOP; 
	    }
	    if (STOR_LOOP == '4') {
		  alert("최하위 카테고리입니다.");
	      return false;
	      /* frmC.str4_upper.value = STOR_SEQ;
	      frmC.str4_depth.value = STOR_LOOP; */
	    }
/* 	    if (STOR_LOOP == '5') {
	      alert("최하위 카테고리입니다.");
	      return false;
	    } */
	                
	    frmC.submit();
	  }
	
	
	  function delCate(STOR_SEQ, STOR_DEPTH, STOR_UPPER) {
		    if (confirm("삭제 하시겠습니까?")) {
		      var frmD = document.frmDel;
		              
		      frmD.mode.value = 'del';  
		      frmD.STOR_SEQ.value = STOR_SEQ;
		      frmD.STOR_DEPTH.value = STOR_DEPTH;
		      frmD.STOR_UPPER.value = STOR_UPPER; 
		      console.log(frmD);
		      frmD.submit();
		      
		    }
		  }
	
	  function barcodelist(STOR2_SEQ,STOR2_NAME) {
		  $.ajax({
	            type : "post",
	            url : '/code/getStorageBarcodeList',
	            async : false,
	            data: "STOR_SEQ="+STOR2_SEQ,
	            success : function(data) {

	            	
	            	
	            	var array = data.storeData;
	            	console.log(array);
	            	var STOR_SEQ ="";
	            	var STOR_CD ="";
	            	var STOR_NAME ="";
	            	var STOR_DEPTH ="";
	            	var STOR_UPPER ="";
	            	var STOR_SORT ="";
	            	var STOR_BARCODE ="";
	            	var NO=1;
	            	text = "";
	            	
/* 
               		$('#STOR_SEQ').val(STOR_SEQ);
               		$('#STOR_CD').val(STOR_CD);
               		$('#STOR_NAME').val(STOR_NAME);
               		$('#STOR_DEPTH').val(STOR_DEPTH);
               		$('#STOR_UPPER').val(STOR_UPPER);
               		$('#STOR_SORT').val(STOR_SORT);
               		$('#STOR_BARCODE').val(STOR_BARCODE); */
               		
               		$('#ZONE').val(STOR2_NAME);
                    if (array.length > 0) {
	               		  	
	                   	for (var i in array){
	                   		
	    	            	STOR_SEQ = array[i].STOR_SEQ;
	    	            	STOR_CD = array[i].STOR_CD;
	    	            	STOR_NAME = array[i].STOR_NAME;
	    	            	STOR_DEPTH = array[i].STOR_DEPTH;
	    	            	STOR_UPPER = array[i].STOR_UPPER;
	    	            	STOR_SORT = array[i].STOR_SORT;
	    	            	STOR_BARCODE = array[i].STOR_BARCODE;
	                		
	                		text += "<tr id='BarCodeList_"+NO+"'>";
	                		text += "<td class='NO'>"+NO+"</td>";
		              		text += "<td class='STOR_NAME'>"+STOR_NAME+"</td>";
	                		text += "<td class='STOR_CD'>"+STOR_CD+"</td>";
	                		text += "<td class='STOR_BARCODE'>"+STOR_BARCODE+"</td>";
	                		text += "<td class='STOR_SEQ'><div class='chkbox chkbox2'><label for='bacodeChk"+STOR_SEQ+"'><input type='checkbox' id='bacodeChk"+STOR_SEQ+"' name='STOR_SEQ' value="+STOR_SEQ+"><span></span></label></div></td>";
	                		text += "</tr>";
	                		NO++;
	                   	}
	                   	 
	            	}else{
	            		text += "<tr class='all'><td colspan='5'>바코드정보가 없습니다.</td></tr>";
	            	}

	                 	       


               		$('#searchResult').empty();
        			$('#productInfo_Form').resetForm();
	            	$('#searchResult').html(text);
	            	
	            }
	         }); 
		    $('#StorageBarCodeList').addClass('view');
			$('html,body').css('overflow','hidden');
			$('.leftNav').removeClass('view');
	  }
	
	
	//검색후 page 설정하여 띄우기	

 	function StorageBarCodeList_Close(){
		$('#StorageBarCodeList').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}



    function goInit() {
        location.href = "/code/storage";
      }
    

</script>

			  
					<h3 class="mjtit_top">
						창고 관리 
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"/></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont"></div>
                   
<!-- 검색  끝-->


					<!-- 리스트 시작-->
 
                 
<!--  관리자 메뉴관리-->
<div class="master_list">

	<!--<p class="t16 keyf0_6">※ 1차 카테고리명 표시 클릭하면서 순차적으로 진행해 주세요</p>-->

	<!--ROW   3 col  출력 -->
	<div class="col-box01 adm_menu">
		<!-- 1차 카테고리 시작-->
		<div class="col">
			<h3 >창고<button type="button" class="btn_02 btn_s"  onclick="storageInfoLayer_Open('','','','1','','','entry');">메뉴추가</button></h3>
            
            <div class="add_table">
            <table id="depth_1" class="display" cellspacing="0" cellpadding="0">
            	<colgroup>
            		<col style="width: 57px;">
            		<col style="width: 210px">
            		<col style="width: 100px;">
            	</colgroup>
            	<thead>
            		<tr>
            			<th>노출순서</th>
            			<th>카테고리명</th>
            			<th>관리</th>
            		</tr>
            	</thead>
            	<tbody>
            	<c:forEach items="${cate1}" var="cate1">
            	 <c:choose>
                              <c:when test="${cate1.STOR_SEQ eq STOR2_UPPER}">
                              	<c:set var="display1" value="background-color:#c1c1c1;" />
                              </c:when>
                              <c:otherwise>
                              	<c:set var="display1" value="" />
                              </c:otherwise>
                            </c:choose>
                            <tr style="${display1}">
                            <td >
                            	<input type="text" name="new_display_order" value="${cate1.STOR_SORT}" readonly class="read">
                            </td>
                              <td class="al">
                                 <a href="javascript:entrySub('2','${cate1.STOR_SEQ}');" onclick="" ">${cate1.STOR_NAME} (${cate1.STOR_SUB_CNT})</a>
                              </td>
                              <td>
                                <div class="tr">
                                  <button class="btn_03 btn_ss"  onclick="javascript:editDepthInfo('${cate1.STOR_SEQ}','${cate1.STOR_NAME}','${cate1.STOR_CD}','${cate1.STOR_DEPTH}','${cate1.STOR_SORT}','${cate1.STOR_UPPER}');">수정</button>
                                  <button class="btn_01 btn_ss"  onclick="javascript:delCate('${cate1.STOR_SEQ}','${cate1.STOR_NAME}','${cate1.STOR_CD}','${cate1.STOR_DEPTH}','${cate1.STOR_SORT}','${cate1.STOR_UPPER}');">삭제</button>
                                
                                </div>                                
                              </td>
                            </tr>
            	</c:forEach>     
            	</tbody>       	
            </table>
           </div>
		</div>

		<!-- 2차 카테고리 시작 //  1차카테고리 선택시출력-->
		<div class="col">
			<h3>ZONE<button id="cate2" type="button" class="btn_02 btn_s" style="display: ${add2};" onclick="storageInfoLayer_Open('','','','2','','','entry');">ZONE추가</button> </h3>
			 <div class="add_table">
				<table class="display" cellspacing="0" cellpadding="0">
					<colgroup>
	            		<col style="width: 57px;">
	            		<col style="width: 140px">
	            		<col style="width: 68px;">
	            		<col style="width: 100px;">
	            	</colgroup>
	            	<thead>
	            		<tr>
	            			<th>노출순서</th>
	            			<th>카테고리명</th>
	            			<th>바코드</th>
	            			<th>관리</th>
	            		</tr>
	            	</thead>
	            <c:forEach items="${cate2}" var="cate2">
                            <c:choose>
                              <c:when test="${cate2.STOR_SEQ eq STOR3_UPPER}">
                              	<c:set var="display2" value="background-color:#c1c1c1;" />
                              </c:when>
                              <c:otherwise>
                              	<c:set var="display2" value="" />
                              </c:otherwise>
                            </c:choose>
                            <tr  style="${display2}">
                              <td>
                              	<input type="text" name="new_display_order" value="${cate2.STOR_SORT}" readonly class="read"></td> 
                                
                                <td class="al"><a href="javascript:entrySub('3','${cate2.STOR_SEQ}');" >${cate2.STOR_NAME} (${cate2.STOR_SUB_CNT})</a>
                              </td>
                              <td>
                                   <button class="btn_02 btn_ss" onclick="barcodelist('${cate2.STOR_SEQ}','${cate2.STOR_NAME}');">바코드</button>
                              </td>
                              <td>
                                <div class="tc">
                                  <button class="btn_03 btn_ss"  onclick="javascript:editDepthInfo('${cate2.STOR_SEQ}','${cate2.STOR_NAME}','${cate2.STOR_CD}','${cate2.STOR_DEPTH}','${cate2.STOR_SORT}','${cate2.STOR_UPPER}');">수정</button>
                                  <button class="btn_01 btn_ss"  onclick="javascript:delCate('${cate2.STOR_SEQ}','${cate2.STOR_NAME}','${cate2.STOR_CD}','${cate2.STOR_DEPTH}','${cate2.STOR_SORT}','${cate2.STOR_UPPER}');">삭제</button>
                                </div>                                
                              </td>
                            </tr>
                            </c:forEach>
				</table>			
			</div>
        </div>
        
		<!-- 3차 카테고리 시작-->
		<div class="col">
			<h3>상세 위치 <button id="cate3" type="button" class="btn_02 btn_s" style="display: ${add3};" onclick="storageInfoLayer_Open('','','','3','','','entry');">상세위치추가</button></h3>
			<div class="add_table">
	            <table  class="display" cellspacing="0" cellpadding="0">
	            	<colgroup>
	            		<col style="width: 57px;">
	            		<col style="width: 210px">
	            		<col style="width: 100px;">
	            	</colgroup>
	            	<thead>
	            		<tr>
	            			<th>노출순서</th>
	            			<th>카테고리명</th>
	            			<th>관리</th>
	            		</tr>
	            	</thead>
	            	<c:forEach items="${cate3}" var="cate3">
                            <c:choose>
                              <c:when test="${cate3.STOR_SEQ eq STOR4_UPPER}">
                              	<c:set var="display3" value="background-color:#c1c1c1;" />
                              </c:when>
                              <c:otherwise>
                              	<c:set var="display3" value="" />
                              </c:otherwise>
                            </c:choose>
                            <tr style="${display3}">
                              <td >
                              	<input type="text" name="new_display_order" value="${cate3.STOR_SORT}" readonly class="read">
                                <td class="al"> <a href="javascript:entrySub('4','${cate3.STOR_SEQ}');" >${cate3.STOR_NAME} (${cate3.STOR_SUB_CNT})</a>
                              </td>
                              <td>
                                <div class="tr">
                                  <button class="btn_03 btn_ss"  onclick="javascript:editDepthInfo('${cate3.STOR_SEQ}','${cate3.STOR_NAME}','${cate3.STOR_CD}','${cate3.STOR_DEPTH}','${cate3.STOR_SORT}','${cate3.STOR_UPPER}');">수정</button>
                                  <button class="btn_01 btn_ss"  onclick="javascript:delCate('${cate3.STOR_SEQ}','${cate3.STOR_DEPTH}','${cate3.STOR_UPPER}');">삭제</button>
                                </div>                                
                              </td>
                            </tr>
                            </c:forEach>
	            </table> 
	          </div>          
		</div>

              
    
    </div> 
    <form name="frmCate" method="post" action="/code/storage">     
      <input type="hidden" name="STOR_LOOP" value="">
      <input type="hidden" name="STOR_SEQ" value="">       
      <input type="hidden" name="STOR2_DEPTH" value="${STOR2_DEPTH}">
      <input type="hidden" name="STOR2_UPPER" value="${STOR2_UPPER}">     
      <input type="hidden" name="STOR3_DEPTH" value="${STOR3_DEPTH}">
      <input type="hidden" name="STOR3_UPPER" value="${STOR3_UPPER}">
      <input type="hidden" name="STOR4_DEPTH" value="${STOR4_DEPTH}">
      <input type="hidden" name="STOR4_UPPER" value="${STOR4_UPPER}">
    </form>   
    
    <form name="frmProc" method="post" action="/code/StorageCategoryProc.do">
      <input type="hidden" name="mode" value="">
      <input type="hidden" name="STOR_SEQ" value="${STOR_SEQ}">
      <input type="hidden" name="STOR_CD" value="${STOR_CD}">     
      <input type="hidden" name="STOR_DEPTH" value="${STOR_DEPTH}">
      <input type="hidden" name="STOR_UPPER" value="${STOR_UPPER}">
      <input type="hidden" name="STOR_NAME" value="">
      <input type="hidden" name="STOR_SORT" value="">
      
      <input type="hidden" name="STOR2_DEPTH" value="${STOR2_DEPTH}">
      <input type="hidden" name="STOR2_UPPER" value="${STOR2_UPPER}">     
      <input type="hidden" name="STOR3_DEPTH" value="${STOR3_DEPTH}">
      <input type="hidden" name="STOR3_UPPER" value="${STOR3_UPPER}">
      <input type="hidden" name="STOR4_DEPTH" value="${STOR4_DEPTH}">
      <input type="hidden" name="STOR4_UPPER" value="${STOR4_UPPER}">
      <input type="hidden" name="STOR_LOOP" value="${STOR_LOOP}">
    </form>
    
    <form name="frmDel" method="post" action="/code/StorageCategoryProc.do">
      <input type="hidden" name="mode" value="">
      <input type="hidden" name="STOR_SEQ" value="">
      <input type="hidden" name="STOR_CD" value="">
      <input type="hidden" name="STOR_DEPTH" value="">
      <input type="hidden" name="STOR_UPPER" value="">
      
      <input type="hidden" name="STOR2_DEPTH" value="${STOR2_DEPTH}">
      <input type="hidden" name="STOR2_UPPER" value="${STOR2_UPPER}">     
      <input type="hidden" name="STOR3_DEPTH" value="${STOR3_DEPTH}">
      <input type="hidden" name="STOR3_UPPER" value="${STOR3_UPPER}">
      <input type="hidden" name="STOR4_DEPTH" value="${STOR4_DEPTH}">
      <input type="hidden" name="STOR4_UPPER" value="${STOR4_UPPER}">
      <input type="hidden" name="STOR_LOOP" value="${STOR_LOOP}">
      
    </form>  
  </div><!-- /.article -->
 			
     			<div class="master_pop master_pop01" id="StorageBarCodeList">
			<div class="master_body">
			<div class="pop_bg" onclick="StorageBarCodeList_Close();"></div>
				<div class="pop_wrap pop_wrap_01" >
					<div class="pop_inner">
					<form id="StorageBarcodeInfo_Form" name="StorageBarcodeInfo_Form">
						<input type="hidden" name="StorageBarcodeCount" id="StorageBarcodeCount"  value="0"/>
						<h3>바코드 리스트<a class="back_btn" href="#" onclick="StorageBarCodeList_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

						<div class="master_list master_listB">
							<table  class="master_02 master_04">	
								<colgroup>
									<col style="width: 120px"/>
									<col/>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">ZONE</th>
										<td ><input type="text" id="ZONE" name="ZONE" readonly="readonly"/></td>		
									</tr>		
									
								</tbody>
							</table>
						</div>


	<div class="master_list master_listT">
							<div class="scroll">
								<table class="master_01 " id="product" >	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 150px;"/>
										<col style="width: 150px;"/>
										<col style="width: 150px;"/>
										<col style="width: 80px;"/>
									</colgroup>
									<thead>
										<tr>
											<th>NO</th>
											<th>상세위치명</th>
											<th>상세위치코드</th>
											<th>바코드정보</th>
											<th>체크</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>
					
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="StorageBarCodeList_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="PrintBarCode();" class="p_btn_02" >출력</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="StorageBarCodeList_Close();"><span>닫기</span></a>
				</div>
				<div id="popup" class="layer_pop">	
					<div class="handle"></div>
					<iframe src="" id="popupframe"></iframe>							
				</div>
				<div id="product_popup" class="layer_pop">	
					<div class="handle"></div>
					<iframe src="" id="product_popupframe"></iframe>							
				</div>
				<div id="order_popup" class="layer_pop">	
					<div class="handle"></div>
					<iframe src="" id="order_popupframe"></iframe>							
				</div>
	</div>
	</div>
     </div>

	<div class="master_pop master_pop01" id="storageInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="storageInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="storageInfo_Form" name="storageInfo_Form">
						
						<input type="hidden" id="STOR_SEQ" name="STOR_SEQ" />		
						<input type="hidden" id="STOR_UPPER" name="STOR_UPPER"/>
						<input type="hidden" id="STOR_DEPTH" name="STOR_DEPTH" />
						<input type="hidden" id="type" name="type"/>
						
						<h3 id="layer_title">메뉴 수정<a class="back_btn" href="#" onclick="storageInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
						<div class="master_list">
							<table  class="master_02 master_04">	
								<colgroup>
								<col style="width: 120px"/>
								<col />								
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">노출순서</th>
										<td><input type="text" id="STOR_SORT" name="STOR_SORT"/></td>															
									</tr>
									<tr>
										<th scope="row">메뉴명</th>
										<td><input type="text"  id="STOR_NAME"  name="STOR_NAME"/></td>
									</tr>
									<tr>	
										<th scope="row">창고코드</th>
										<td>
										<div class="radiobox">
											<label>
											<input type="text" id="STOR_CD" name="STOR_CD" ${read} maxlength='3'/>
											</label>
											</div>
										</td>
									</tr>
									
								</tbody>
							</table>
						</div>
						
						
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="storageInfoLayer_Close();">닫기</a>
							<a href="#" id="depthBtn" class="p_btn_02" onclick="updateDepthInfo();">수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="storageInfoLayer_Close();"><span>닫기</span></a>
				</div>
			</div>
		</div>
	</div>
              <!-- contents end -->         