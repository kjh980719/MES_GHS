<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<%
	if(request.isSecure() == true) {
		out.print("<script src='https://spi.maps.daum.net/imap/map_js_init/postcode.v2.js'></script>");
	}else {
		out.print("<script src='http://dmaps.daum.net/map_js_init/postcode.v2.js'></script>");
	}
%>
<script type="text/javascript">
<%
UserInfo user = Util.getUserInfo();
%>

$(document).ready(function() {
	
    var setCalendarDefault = function() {
        $("#startDate").datepicker();
        $("#startDate").datepicker('setDate', '${search.startDate}');
        $("#endDate").datepicker();
		$("#endDate").datepicker('setDate', '${search.endDate}');
    }
    setCalendarDefault();
    
})

	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}
	
	function viewOrderDetail(contract_seq, type){
		contractInfoLayer_Open(contract_seq, type);
	}
	function materialRegist(type){
		contractInfoLayer_Open("", type)
	}

	
	
	function productAdd(){
		var num = Number($('#productCount').val());
		num += 1;
		var text ="";

		text += "<tr id='product_"+num+"'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'><input type='text' id='code_"+num+"' name='code' ></td>";
		text += "<td class='prod'>";
		text += "<div class=\"dan\">";
		text += "<span><input type='text' id='pdt_name_"+num+"' name='pdt_name' placeholder=\"품목\"></span>";
		text += "<span><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' placeholder=\"규격\"></span>";
		text += "</div>";
		text += "</td>";
		text += "<td class='name'><input type='text' id='qty_"+num+"' name='qty' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' onChange='priceChange("+num+"); return false;'></td>";
		text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' ></td>";
		text += "<td class='name'><input type='text' id='unit_price_"+num+"' name='unit_price' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' onChange='priceChange("+num+"); return false;'></td>";
		text += "<td class='name'><input type='text' id='supply_price_"+num+"' name='supply_price' readonly></td>";
		text += "<td class='ing vat'><input type='text' id='vat_"+num+"' name='vat' readonly></td>";
		text += "</tr>";
		

		$('#searchResult').append(text);
		
		$('#productCount').val(num);
	}
	function productDelete(rowNum){

		$("#product_"+rowNum).remove();

	}
	

	
	
	function contractInfoLayer_Open(contract_seq, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');

			$.ajax({
	            type : "get",
	            url : '/contract/getContractInfo',
	            async : false,
	            data: "contract_seq="+contract_seq,
	            success : function(data) {
	            	var array = data.storeData;
	            	console.log(array);
	            	var business_no ="";
	            	var code ="";
	            	var no ="";
	            	var pdt_name ="";
	            	var supply_price ="";
	            	var unit ="";
	            	var unit_price ="";
	            	var vat ="";
	            	text = "";
	  				var contract_code ="";
	  				var phone ="";
	  				var contract_date ="";
	  				var close_date ="";
	  				var total_amount ="";
	  				var tax_amount ="";
	  				var reception ="";
	  				var contract_name ="";
	  				var buyer_name ="";
	  				var bigo ="";
	  				var contract_status ="";
	            	var cancel_reason= "";
					var contract_seq = "";
					var txt = "";
					
	            	if (array.length > 0) {
	            		contract_seq = array[0].contract_seq;
	               		business_no = array[0].business_no;
	             		contract_code = array[0].contract_code;
						contract_phonenumber = array[0].contract_phonenumber;
	               		contract_date = array[0].contract_date;
	               		close_date = array[0].close_date;
	               		total_amount = array[0].total_amount;
	               		tax_amount = array[0].tax_amount;
	               		supply_amount = array[0].supply_amount;
						contract_name = array[0].contract_name;
						contract_manager_name = array[0].contract_manager_name;
						buyer_manager_name = array[0].buyer_manager_name;
						buyer_phonenumber = array[0].buyer_phonenumber;
	               		bigo = array[0].bigo;
	               		contract_status = array[0].contract_status;
						buyer_addr = array[0].buyer_addr;
						buyer_name = array[0].buyer_name;
	               		cancel_reason = array[0].cancel_reason;
	               		cust_seq = array[0].cust_seq;
	               		
	               		$('#contract_seq').val(contract_seq);
	               		$('#contract_code').val(contract_code);
	               		$('#business_no').val(business_no);
	               		$('#cust_seq').val(cust_seq);
	             		$('#buyer_name').val(buyer_name);
	             		$('#buyer_manager_name').val(buyer_manager_name);
	             		$('#contract_manager_name').val(contract_manager_name);
	             		$('#buyer_phonenumber').val(buyer_phonenumber);
	             		
	             		$('#contract_date').val(contract_date);
	               		$("#close_date").datepicker();
	                 	$("#close_date").datepicker('setDate', close_date);
	             		
	                 	$('#buyer_addr').val(buyer_addr);
	                 	$('#contract_name').val(contract_name);
	                 	$('#contract_manager_name').val(contract_manager_name);
	                 	$('#contract_phonenumber').val(contract_phonenumber);
	               	
	                 	$('#supply_amount').val(comma(supply_amount));
	            		$('#tax_amount').val(comma(tax_amount));
	               		$('#total_amount').val(comma(total_amount));

	               		$('#bigo').val(bigo);
	
	               		if (contract_status == 'NO'){
	               			//취소면 셀렉박스 취소만 남게
	               			$('#contract_status').remove();
	               			txt += "<span style='color : red;'>취소</span>";
	               			$('#contractStatusZone').removeClass("sel_wrap");
	               			$('#contractStatusZone').html(txt);
	               		}else{
	               			$('#contract_status').remove();
	               			 txt += "<select class='sel_02' id='contract_status' name='contract_status' onchange='reasonShow(this)'>";
	               			 txt += "<option value='N'>접수</option>";
	               			 txt += "<option value='Y'>착수</option>";
	               			 // txt += "<option value='ADJ'>조정요청</option>";
	               			 // txt += "<option value='OP'>진행중</option>";
	               			 // txt += "<option value='OC'>납품완료</option>";
	               			 txt += "<option value='NO'>취소</option>";
	               			 txt += "</select>";
		               		 $('#contractStatusZone').addClass("sel_wrap");
		               		 $('#contractStatusZone').html(txt);
	               		}
	               		
	               		if(contract_status == 'ADJ' || contract_status =='NO'){
	               			//취소 , 조정요청이면 사유 칸 보이게
	               			$('#sayou').css('display', '');	               		
	               		}else{
	               			$('#sayou').css('display', 'none');	               		
	               		}
	               		
	            		$('#contract_status').val(contract_status);
	            		$('#cancel_reason').val(cancel_reason);		

	                   	for (var i in array){
	                   			
	                		code = array[i].code;
	                		no = array[i].no;
	                		pdt_name = array[i].pdt_name;
	                		pdt_standard = array[i].pdt_standard;
	                		supply_price = array[i].supply_price;
	                		unit = array[i].unit;
	                		qty = array[i].qty
	                		unit_price = array[i].unit_price;
	                		vat = array[i].vat;
	                		
                            text += "<tr>";
	                		text += "<td class='num'>"+no+"</td>";
	                		text += "<td class='code'>"+code+"</td>";
	                		text += "<td class='prod'>";
	                		text += "<div class=\"dan\">";
	                		text += "<span>"+pdt_name+"</span>"
	                		text += "<span>"+pdt_standard+"</span>"
	                		text += "</div>";
	                		text += "</td>";
	                		text += "<td class='name'>"+qty+"</td>";
	                		text += "<td class='name'>"+unit+"</td>";
	                		text += "<td class='name'>"+comma(unit_price)+"</td>";
	                		text += "<td class='name'>"+comma(supply_price)+"</td>";
	                		text += "<td class='ing vat'>"+comma(vat)+"</td>";
	                		text += "</tr>";
	                	}
	                   
	            	}else{
	            		text += "<tr class='all'><td colspan='7'>수주정보가 없습니다.</td></tr>";
	            	}
               		$('#button_1').css('display','none');
               		$('#button_2').css('display','none');
	            	$('#contractStatusZone').css('display', '');
	            	$('#contractStatus').css('display', '');
	            	$('#contract_code').css('display', 'block');
					$("#buyer_name").removeAttr("onclick");
	            	$('#actionButton').text('수정');
	            	$('#searchResult').html(text);
	            }
	         }); 
		}else{ //신규작성일때
    		$('#mode').val('register');
       		$('#button_1').css('display','inline-block');
       		$('#button_2').css('display','inline-block');
			$('#contractStatusZone').css('display', 'none');
         	$('#contract_code').css('display', 'none');
         	$('#contractStatus').css('display', 'none');
         	$('#sayou').css('display', 'none');
    		// $('#buyer_name').attr("onclick","openLayer();");
    		$('#actionButton').text('등록');
         	$('#searchResult').empty();
			$('#contractInfo_Form').resetForm();
			
			var today = new Date();   

			var year = today.getFullYear(); // 년도
			var month = today.getMonth() + 1;  // 월		
			var date = today.getDate();  // 날짜
			
			var monthChars = month.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
			var dateChars = date.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
			
			month = (monthChars[1]? month:"0"+month);// 한자리일경우 monthChars[1]은 존재하지 않기 때문에 false
			date = (dateChars[1]? date:"0"+date);// 한자리일경우 dateChars[1]은 존재하지 않기 때문에 false
			
			date = year + "-" + month + "-" + date;
			$('#contract_manager_name').val("<%=user.getManagerName()%>");
			$('#contract_phonenumber').val("<%=user.getManagerTel()%>");
			$('#contract_date').val(date);
       		$("#close_date").datepicker();
         	$("#close_date").datepicker('setDate', '+7');
         	
         	
         	text += "<tr id='product_1'>";
    		text += "<td class='num pctnum'><a href='#' onclick='productDelete(1)'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
    		text += "<td class='code'><input type='text' id='code_1' name='code' ></td>";
    		text += "<td class='prod'>";
    		text += "<div class=\"dan\">";
    		text += "<span><input type='text' id='pdt_name_1' name='pdt_name' placeholder=\"품목\"></span>";
    		text += "<span><input type='text' id='pdt_standard_1' name='pdt_standard' placeholder=\"규격\"></span>";
    		text += "</div>";
    		text += "</td>";
    		text += "<td class='name'><input type='text' id='qty_1' name='qty'onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' onChange='priceChange(1); return false;'></td>";
    		text += "<td class='name'><input type='text' id='unit_1' name='unit' ></td>";
    		text += "<td class='name'><input type='text' id='unit_price_1' name='unit_price' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' onChange='priceChange(1); return false;'></td>";
    		text += "<td class='name'><input type='text' id='supply_price_1' name='supply_price' readonly></td>";
    		text += "<td class='ing vat'><input type='text' id='vat_1' name='vat' readonly ></td>";
    		text += "</tr>";
 
    		$('#searchResult').html(text);


		}

		$('#contractInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	
	function reasonShow(obj){
		var val = obj.value;
		if (val == "ADJ" || val == "NO"){
			$('#sayou').css('display', '');			
			if ($('#cancel_reason').val() == "undefined" || $('#cancel_reason').val() == null){
				$('#cancel_reason').val("");
			}
			
		}
	}
	
	function contractInfoLayer_Close(){
		$('#contractInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}
	
	function GoActionButton(){
		var targetUrl = ""
		var pdt_name = "";
		var qty = "";
		var unit_price = "";
		var unit = "";
		var status = true;
		
		var mode = $('#mode').val();
		if (mode == 'register') {
			targetUrl = "/contract/registerContract";
		} else {
			contractInfoUpdate();
			return;
		}

		var contract_date = new Date($('#contract_date').val());
		var close_date = new Date($('#close_date').val());

		if (contract_date > close_date){
			alert("납기일자는 수주일자보다 이후여야 합니다.");
			return false;
		}

		if( isEmpty($('#contract_name').val())){
			alert("수주명을 입력해주세요");
			$('#contract_name').focus();
			return false;
		}
		if( isEmpty($('#buyer_name').val())){
			alert("수주처를 입력해주세요");
			$('#buyer_name').focus();
			return false;
		}
		if( isEmpty($('#buyer_manager_name').val())){
			alert("담당자를 입력해주세요");
			$('#buyer_manager_name').focus();
			return false;
		}
		if( isEmpty($('#buyer_phonenumber').val())){
			alert("연락처를 입력해주세요");
			$('#buyer_phonenumber').focus();
			return false;
		}

		if( isEmpty($('#buyer_addr').val()) || isEmpty($('#buyer_addr').val()) ){
			alert("주소를 입력해주세요");
			return false;
		}

        $('input[name="pdt_name"]').each(function (idx, item) {
        	pdt_name = $(item).val();
        	if (isEmpty(pdt_name)){
        		alert("품목명을 입력해주세요.");
				$('input[name="pdt_name"]').focus();
        		status = false;
        	}
       	});
        if (status == false) return;
        
        $('input[name="qty"]').each(function (idx, item) {
        	qty = $(item).val();
        	if (isEmpty(qty)){
        		alert("수량을 입력해주세요.");
				$('input[name="qty"]').focus();
        		status = false;
        	}
       	});
       if (status == false) return;
        
        $('input[name="unit_price"]').each(function (idx, item) {
        	unit_price = $(item).val();
        	if (isEmpty(unit_price)){
        		alert("단가를 입력해주세요.");
				$('input[name="unit_price"]').focus();
        		status = false;
        	}
       	});
        if (status == false) return;
        
        $('input[name="unit"]').each(function (idx, item) {
        	var unit = $(item).val();
        	if (isEmpty(unit)){
        		alert("단위를 입력해주세요.");
				$('input[name="unit"]').focus();
        		status = false;
        	}
       	});
        if (status == false) return;
        

        

        var ordermaterialList =[];
        
		for (var i = 0; i < $("input[name='pdt_name']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;		
			tmpMap.code = $($("input[name='code']")[i]).val();
			tmpMap.pdt_name = $($("input[name='pdt_name']")[i]).val();
			tmpMap.pdt_standard = $($("input[name='pdt_standard']")[i]).val();
			tmpMap.qty = $($("input[name='qty']")[i]).val().replace(/,/g, "");
			tmpMap.unit = $($("input[name='unit']")[i]).val();
			tmpMap.unit_price = $($("input[name='unit_price']")[i]).val().replace(/,/g, "");
			tmpMap.supply_price = $($("input[name='supply_price']")[i]).val().replace(/,/g, "");
			tmpMap.vat = $($("input[name='vat']")[i]).val().replace(/,/g, "");

			ordermaterialList.push(tmpMap)
		}
		var contract_info =[];
		var tmpMap2 = {};
		tmpMap2.contract_date = $($("input[name='contract_date']")).val();
		tmpMap2.close_date = $($("input[name='close_date']")).val();
		tmpMap2.business_no = $($("input[name='business_no']")).val();
		tmpMap2.buyer_name = $($("input[name='buyer_name']")).val();
		tmpMap2.buyer_manager_name = $($("input[name='buyer_manager_name']")).val();
		tmpMap2.buyer_phonenumber = $($("input[name='buyer_phonenumber']")).val();
		tmpMap2.contract_manager_name = $($("input[name='contract_manager_name']")).val();
		tmpMap2.contract_name = $($("input[name='contract_name']")).val();
		tmpMap2.contract_phonenumber = $($("input[name='contract_phonenumber']")).val();
		tmpMap2.supply_amount = $($("input[name='supply_amount']")).val().replace(/,/g, "");
		tmpMap2.tax_amount = $($("input[name='tax_amount']")).val().replace(/,/g, "");
		tmpMap2.total_amount = $($("input[name='total_amount']")).val().replace(/,/g, "");
		tmpMap2.bigo = $($("input[name='bigo']")).val();
		tmpMap2.buyer_addr = $($("input[name='buyer_addr']")).val();
		tmpMap2.cust_seq = $($("input[name='cust_seq']")).val();
		
		contract_info.push(tmpMap2);
		sendData = {};
		
	    sendData.ordermaterialList = ordermaterialList;
	    sendData.contract_info = contract_info;

        $.ajax({
        	contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(sendData),
        	type: "POST",
        	url : targetUrl,
        	dataType : "json",
        	contentType: "application/json"
        	
        }).done(function(result) {
        	console.log(result);
           if(result.success){
                alert("수주가 등록되었습니다.");
                contractInfoLayer_Close();
                location.reload();
             } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
             }
        });

	}
	
	function contractInfoUpdate(){
		var msg = "";
		var returnMsg = "";
		var target = "";
		
		if ($('#contract_status').val() == 'NO'){
			msg = "정말 취소하시겠습니까?";
			returnMsg = "취소되었습니다.";
			target = "/contract/contractInfoUpdateCancel";
			
		}else{
			msg = "정말 수정하시겠습니까?";
			returnMsg = "수정되었습니다.";
			target = "/contract/contractInfoUpdate"
		}

		if(confirm(msg)){
			param = $("#contractInfo_Form").serialize();
			 $.ajax({
		        type : "post",
		        url : target,
		        async : false,
		        data: param,
		        success : function(data) {
		            if(data.success){
		            	alert(returnMsg);
		            	location.reload(true);
		            }
		        },error : function(data){
		 
		            contractInfoLayer_Close();
		            location.reload(true);
	            }
			 });
		}
		
		
	}

</script>

					<h3 class="mjtit_top">
						매출(판매)관리
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/order/makeorderview">
                    	<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
                    <div class="srch_day">
                    	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate">기간</label>
                    		</div>
                    		<div class="day_input">
                    			<input type="text" id="startDate" name="startDate" readonly/>
                    		</div>
                    		<span class="sup">~</span>
                    		<div class="day_input">
                    			<input type="text" id="endDate" name="endDate" readonly/>
                    		</div>
                    	</div>
<!--                     	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate2">입고 요청일</label>
                    		</div>
                    		<div class="day_input">
                    			<input type="text" id="startDate2" name="startDate2" readonly/>
                    		</div>
                    		<span class="sup">~</span>
                    		<div class="day_input">
                    			<input type="text" id="endDate2" name="endDate2" readonly/>
                    		</div>
                    	</div> -->
                    </div>
                    <div class="srch_all">
                    	<div class="sel_wrap sel_wrap1">
                    		<select name="contract_status" class="sel_02">
	                            <option value="ALL" <c:if test="${search.contract_status == 'ALL'}">selected</c:if>>전체</option>
	                            <option value="NR" <c:if test="${search.contract_status == 'N'}">selected</c:if>>접수</option>
	                            <option value="YR" <c:if test="${search.contract_status == 'Y'}">selected</c:if>>착수</option>
<%--	                            <option value="ADJ" <c:if test="${search.contract_status == 'ADJ'}">selected</c:if>>조정요청</option>--%>
<%--	                            <option value="OP" <c:if test="${search.contract_status == 'OP'}">selected</c:if>>진행중</option>--%>
<%--	                            <option value="OC" <c:if test="${search.contract_status == 'OC'}">selected</c:if>>완료</option>--%>
	                            <option value="NO" <c:if test="${search.contract_status == 'NO'}">selected</c:if>>취소</option>
                            </select>
                    	</div>
                    	
                    	<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="contract_code" <c:if test="${search.search_type == 'contract_code'}">selected</c:if>>수주번호</option>
	                            <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목</option>
                                  
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch();}"/>
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                              <button type="button" class="btn_01">초기화</button> 
                          </div>
                          
                          <div class="register_btn">
                        <button type="button" class="btn_02 popLayermaterialRegistBtn" onclick="materialRegist('register');">신규등록</button>
                        </div>
                    </div>
                
                    </form>
 
                    </div><!-- 검색  끝-->


					<!-- 리스트 시작-->
 
                    
                    <div class="master_list ">
                    	<div class="list_set ">
							<div class="set_right">
								<div class="sel_wrap">
									<select name="rowPerPage_1" id="rowPerPage_1" class="sel_01">
			                            <option value="15">15개씩 보기</option>
			                            <option value="30">30개씩 보기</option>
			                            <option value="50">50개씩 보기</option>
			                            <option value="100">100개씩 보기</option>
			                        </select>
		                        </div>
							</div>
	                    </div>
	                    <div class="scroll">
	                  	<table class="master_01">
	                    		<colgroup>
	                    			<col style="width: 55px;"/>
	                    			<col style="width: 115px;"/>
	                    			<col style="width: 210px;"/>
	                    			<col style="width: 280px;"/>
	                    			<col style="width: 180px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 90px;"/>
	                    		</colgroup>
	           		        	<thead>
	                    			<tr>
	                    				<th>No</th>
	                    				<th>수주번호</th>
	                    				<th>수주명</th>
	                	   				<th>품목명</th>
										<th>수주사명</th>
	                    				<th>수주일자</th>
<%--	                    				<th>입고요청일</th>--%>
	                    				<th>진행상태</th>
    		               			</tr>
	                    		</thead>
	                    		<tbody>
	                    			<c:forEach items="${list}" var="list" varStatus="status">
		                    			<tr>
		                    				<td class="num"><fmt:formatNumber value="${total +1 - list.no}" pattern="#,###,###"/></td>
		                    				<td class="code"><a href="#" onclick="viewOrderDetail('${list.contract_seq}','view');">${list.contract_code}</a></td>
		                    				<td class="name"><a href="#" onclick="viewOrderDetail('${list.contract_seq}','view');">${list.contract_name}</a></td>
		                    				<td class="prod">
			                    				<a href="#" onclick="viewOrderDetail('${list.contract_seq}','view');">${list.pdt_name}</a>
			                    				<a href="#" onclick="viewOrderDetail('${list.contract_seq}','view');" class="m_link">${list.pdt_name}</a>
		                    				</td>
		       								<td class="sang t_left">${list.buyer_name}</td>
		                    				<td class="day">${list.contract_date}</td>
											<td class="ing">완료</td>
		                    			</tr>
	                    			</c:forEach>
									<c:if test="${empty list }">
										<tr><td colspan="7">수주 정보가 없습니다.</td></tr>
									</c:if>
	                    			
	                    		</tbody>
	                    	</table>
	                    </div>
                    	<div class="mjpaging_comm">
            				${dh:pagingB(total, currentPage, rowsPerPage, 10, parameter)}
       					 </div>
                    </div>
 					
 			<div class="master_pop master_pop01" id="contractInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="contractInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01" >
					<div class="pop_inner">
					<form id="contractInfo_Form" name="contractInfo_Form">
						<input type="hidden" name="productCount" id="productCount"  value="1"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="business_no" id="business_no" />
						<input type="hidden" name="contract_seq" id="contract_seq" />
						<input type="hidden" name="cust_seq" id="cust_seq" />
						
						<h3>수주 조회<a class="back_btn" href="#" onclick="contractInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

						<div class="master_list master_listB">
							<table  class="master_02 master_04">	
								<colgroup>
									<col style="width: 120px"/>
									<col style="width: 34.8%"/>
									<col style="width: 120px"/>
									<col style="width: 34.8%"/>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">수주번호</th>
										<td colspan="3"><input type="text" id="contract_code" name="contract_code" readonly="readonly"/></td>
										
									</tr>
									<tr>
										<th scope="row">수주명</th>
										<td colspan="3"><input type="text" id="contract_name" name="contract_name" class="all"/></td>

									</tr>
									<tr>
										<th scope="row">수주처</th>
<%--										<td colspan="3"><input type="text" id="buyer_name" name="buyer_name" onclick="openLayer();" class="all" readonly/></td>--%>
										<td colspan="3"><input type="text" id="buyer_name" name="buyer_name" class="all" /> <button type="button" class="btn_02 btn_s" id="button_4" onclick="openLayer();return false;">수주처 검색</button></td>

									</tr>
									<tr>
<%--										<th scope="row">사업자번호</th>--%>
<%--										<td><input type="text" id="business_no" name="business_no" /></td>--%>
										<th scope="row">담당자</th>
										<td><input type="text" id="buyer_manager_name" name="buyer_manager_name" maxlength="15"/></td>
										<th scope="row">연락처</th>
										<td colspan="3"><input type="text" id="buyer_phonenumber" name="buyer_phonenumber" onKeyup="autoHypen(this);" maxlength="13"/></td>

									</tr>
<%--									<tr>--%>
<%--										<th scope="row">연락처</th>--%>
<%--										<td colspan="3"><input type="text" id="buyer_phonenumber" name="buyer_phonenumber" onKeyup="autoHypen(this);" maxlength="13"/></td>--%>
<%--									</tr>--%>
									
						
									<tr>
									
										<th scope="row">수주일자</th>
										<td>
											<input type="text" id="contract_date" name="contract_date" readonly="readonly"/>
										</td>										
										<th scope="row">납기일자</th>
										<td>
											<div class="day_input"><input type="text" id="close_date" name="close_date" /></div>
										</td>	
											
									</tr>

									<tr>
										<th scope="row">주소</th>
										<td colspan="3"><input type="text" id="buyer_addr" name="buyer_addr" class="all"/> <button type="button" class="btn_02 btn_s" id="button_3" onclick="openZipSearch();return false;">주소 검색</button></td>

									</tr>
									
									<tr>
										<th scope="row">수주담당자</th>
										<td><input type="text" id="contract_manager_name" name="contract_manager_name" maxlength="15" readonly="readonly"/></td>
										
										<th scope="row">연락처</th>
										<td><input type="text" id="contract_phonenumber" name="contract_phonenumber" onKeyup="autoHypen(this);" maxlength="13"/></td>
		
									</tr>
									
									<tr>
										<th scope="row">공급가액</th>										
										<td><input type="text" id="supply_amount" name="supply_amount" readonly="readonly"/></td>			
										
										<th scope="row">VAT</th>										
										<td><input type="text" id="tax_amount" name="tax_amount" readonly="readonly"/></td>		
									</tr>
									
									<tr>	
										<th scope="row">총액</th>
										<td><input type="text" id="total_amount" name="total_amount" readonly="readonly"/></td>		
																			
										<th scope="row">비고</th>										
										<td><input type="text" id="bigo" name="bigo" class="all"/></td>						
									
											
									</tr>	
									<tr id="contractStatus">
										<th scope="row">수주상태</th>
										<td colspan="3">
											<div id="contractStatusZone" class="sel_wrap" >
												<select class="sel_02" id="contract_status" name="contract_status" onChange="reasonShow(this)">
													<option value="N">접수</option>
													<option value="Y">착수</option>
<%--													<option value="ADJ">조정요청</option>											--%>
<%--													<option value="OP">진행중</option>--%>
<%--													<option value="OC">납품완료</option>--%>
													<option value="NO">취소</option>								
												</select>															
											</div>
										</td>		
									</tr>
									<tr id="sayou" style="display : none;">
										<th scope="row">사유</th>
										<td colspan="3"><input type="text" id="cancel_reason" name="cancel_reason" class="all"/></td>
									</tr>				
									
								</tbody>
							</table>
						</div>
						
						<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_1" type="button" class="btn_02" onclick="productAdd();">신규추가</button>
								<button id="button_2" type="button" class="btn_02" onclick="productSearch();">불러오기</button>
							</div>
							<div class="scroll">
								<table class="master_01 master_05" id="product" >	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 110px;"/>
										<col style="width: 220px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
										<col style="width: 110px;"/>
										<col style="width:110px;"/>
										<col style="width: 110px;"/>
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>품목코드</th>
											<th>품목및 규격</th>
											<th>수량</th>
											<th>단위</th>
											<th>단가</th>
											<th>공급가액</th>
											<th>부가세</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="contractInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="contractInfoLayer_Close();"><span>닫기</span></a>
				</div>
				<div id="popup" class="layer_pop">	
					<div class="handle_wrap">
						<div class="handle"><span>공급사 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="closeLayer(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="popupframe"></iframe>							
				</div>
				<div id="product_popup" class="layer_pop">	
					
					<div class="handle_wrap">
						<div class="handle"><span>품목 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="productSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="product_popupframe"></iframe>							
				</div>
	

     </div>
				<div class="viewPop viewPop1 edit_pop1">
					<div class="print_body">
						<div class="print_bg" onclick="popHide();return false;"></div>
						<div class="print_wrap">
							<div class="inner_p">
								<div class="print_box">
									<h3><span>우편번호 검색</span></h3>
									<div id="layer">

									</div>
									<div class="print_close">
										<button type="button" onclick="popHide();return false;"><span><img src="/img/icon/mobile_close.png" alt="닫기"></span></button>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
	
	

<script>
	
	function openLayer() {
		var url = "/supply/popSupplyList2";
		$('#popup').css('display','block');
		$('#popupframe').attr('src',url);
		$('html,body').css('overflow','hidden');
	/* 	var frameH ;
		setTimeout(function() {
			frameH = $('#popupframe').contents().find('.pop_wrap').innerHeight();
			frameW = $('#popupframe').contents().find('.pop_wrap').innerWidth();
		
		},1000) */

	}
	
	function closeLayer() {
		$('#popup').css('display','none');
		$('#popupframe').removeAttr('src');
		$('html,body').css('overflow','');
		
	}
	
	function productSearch(){
		var url = "/contract/popProductList";
		$('#product_popup').css('display','block');
		$('#product_popupframe').attr('src',url);
		$('html,body').css('overflow','hidden');
	}
	function productSearch_close(){
		$('#product_popup').css('display','none');
		$('#product_popupframe').removeAttr('src');
		$('html,body').css('overflow','');
	}
	function PopProductAdd(data){
		
	
		var pdt = data.storeData;
		var num = Number($('#productCount').val());
		num += 1;
		var text ="";

		text += "<tr id='product_"+num+"'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'><input type='text' id='code_"+num+"' name='code' value='"+pdt.PROD_CD+"'></td>";
		text += "<td class='prod'>";
		text += "<div class=\"dan\">";
		text += "<span><input type='text' id='pdt_name_"+num+"' name='pdt_name' value='"+pdt.PROD_DES+"' placeholder=\"품목\"></span>";
		text += "<span><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' value='"+pdt.PDT_STANDARD+"' placeholder=\"규격\"></span>";
		text += "</div>";
		text += "</td>";
		text += "<td class='name'><input type='text' id='qty_"+num+"' name='qty' value='1' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' onChange='priceChange("+num+"); return false;'></td>";
		text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' value='"+pdt.UNIT+"'></td>";
		text += "<td class='name'><input type='text' id='unit_price_"+num+"' name='unit_price' value='"+comma(pdt.IN_PRICE)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' onChange='priceChange("+num+"); return false;'></td>";
		text += "<td class='name'><input type='text' id='supply_price_"+num+"' name='supply_price' value='"+comma(pdt.IN_PRICE)+"' readonly></td>";
		text += "<td class='ing vat'><input type='text' id='vat_"+num+"' name='vat' value='"+comma(Math.round(pdt.IN_PRICE * 0.1))+"' readonly></td>";
		text += "</tr>";


		$('#searchResult').append(text);
		
		$('#productCount').val(num);
		priceCal();
		
	}
	function priceChange(num){
		
		var price = $('#unit_price_'+num).val().replace(/,/gi, "");
		var qty = $('#qty_'+num).val().replace(/,/gi, "");
		var supply_price = 0;
		var vat = 0;
	
		
		if (price == "0" || price == "undefined"){
			supply_price = 0;
			vat = 0;

			$('#supply_price_'+num).val(supply_price);
			$('#vat_'+num).val(vat);
		}else{
			supply_price = price * qty;
			vat = Math.round(supply_price * 0.1);

			$('#supply_price_'+num).val(comma(supply_price));
			$('#vat_'+num).val(comma(vat));
	
			priceCal();

		}


	}
	
	function priceCal(){
		var supply_amount = 0;
		var tax_amount = 0;
		
        $('input[name="supply_price"]').each(function (idx, item) {
        	var supply_price_val = $(item).val();
        	supply_amount += Number(supply_price_val.replace(/,/gi, ""));

       	});
        $('input[name="vat"]').each(function (idx, item) {
        	var vatValue = $(item).val();
        	tax_amount += Number(vatValue.replace(/,/gi, ""));
       	});
       
        $('#supply_amount').val(comma(supply_amount));
        $('#tax_amount').val(comma(tax_amount));
        $('#total_amount').val(comma(supply_amount + tax_amount));
 
	}
	
	function openZipSearch() {

		new daum.Postcode({
			oncomplete: function(data) {
				// $('[name=order_post_no]').val(data.zonecode); // 우편번호 (5자리)
				$('[name=buyer_addr]').val("("+data.zonecode+") "+data.address);
			}
		}).open();
	}
	// function popHide() {
	//
	// 	el_all.removeClass('view');
	// 	$('html,body').css('overflow','');
	// }
	//
	// var el_layer = document.getElementById('layer');
	// var el_all = $('.edit_pop1');
	//
	// function execDaumPostcode(gubun) {
	// 	new daum.Postcode({
	// 		oncomplete: function(data) {
	// 			var fullAddr = ''; // 최종 주소 변수
	// 			var extraAddr = ''; // 조합형 주소 변수
	//
	// 			//무조건 도로명 주소 사용으로 통일
	// 			fullAddr = data.roadAddress;
	//
	// 			// 사용자가 선택한 주소가 도로명 타입일때 조합한다.
	// 			if(data.userSelectedType === 'R'){
	// 				//법정동명이 있을 경우 추가한다.
	// 				if(data.bname !== ''){
	// 					extraAddr += data.bname;
	// 				}
	// 				// 건물명이 있을 경우 추가한다.
	// 				if(data.buildingName !== ''){
	// 					extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	// 				}
	// 				// 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
	// 				fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
	// 			}
	//
	// 			switch (data.sido) {
	// 				case "제주특별자치도"  : data.sido="제주"; break;
	// 				case "세종특별자치시"  : data.sido="세종"; break;
	// 			}
	//
	// 			document.getElementById('company_saupjusocode1').value = data.zonecode;
	// 			document.getElementById('company_saupjuso1').value = fullAddr+" ";
	//
	// 			document.getElementById('com_mem_area1').value = data.sido;
	// 			//시군구
	// 			document.getElementById('com_mem_area2').value = data.sigungu;
	// 			//도로명 코드
	// 			document.getElementById('zip_road_name_code').value = data.roadnameCode;
	//
	//
	// 			document.getElementById('company_saupjuso2').focus();
	// 			el_all.removeClass('view');
	// 			$('html,body').css('overflow','');
	// 		},
	// 		width : '100%',
	// 		height : '100%',
	// 		maxSuggestItems : 5
	// 	}).embed(el_layer);
	// 	el_all.addClass('view');
	// 	$('html,body').css('overflow','hidden');
	// }
</script>
