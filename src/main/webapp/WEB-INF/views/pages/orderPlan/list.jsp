<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript">
<%
UserInfo user = Util.getUserInfo();
%>

var pdt_name_id = "";
var rowNum = "";

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
	
	function viewOrderPlanDetail(orderPlan_seq, type){
		orderInfoLayer_Open(orderPlan_seq, type);
	}
	function materialRegist(type){
		orderInfoLayer_Open("", type)
	}

	function createOrder(orderPlan_seq){
		if(confirm("발주생성 하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/orderPlan/createOrder',
	            async : false,
	            data: "orderPlan_seq="+orderPlan_seq,
	         	success : function(data) {
		            if(data.success){
		            	alert("발주생성 하였습니다.");
		            	location.reload(true);
		            }else{
		            	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
		            }
		        },error : function(data){
		 
		        	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
		            location.reload(true);
	            }
			})
		}
	}
	function deleteOrderPlan(orderPlan_seq){
		
		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/orderPlan/delete',
	            async : false,
	            data: "orderPlan_seq="+orderPlan_seq,
	         	success : function(data) {
		            if(data.success){
		            	alert("삭제되었습니다.");
		            	location.reload(true);
		            }else{
		            	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
		            }
		        },error : function(data){
		 
		        	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
		            location.reload(true);
	            }
			})
		}
	}

	function productDelete(rowNum){
		$("#product_"+rowNum).remove();
		priceCal();
	}
	

	function orderInfoLayer_Open(orderPlan_seq, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');

			$.ajax({
	            type : "get",
	            url : '/orderPlan/getOrderPlanInfo',
	            async : false,
	            data: "orderPlan_seq="+orderPlan_seq,
	            success : function(data) {
	            	var array = data.storeData;
	            	
					var num = 1 ;
	            	if (array.length > 0) {
	
	               		
	               		$('#orderPlan_seq').val(array[0].orderPlan_seq);
						$('#product_cd').val(array[0].product_cd);
	               		$('#pdt_cd').val(array[0].pdt_cd);

	             		$('#reg_date').val(array[0].reg_date);	         
						$('#manager_name').val(array[0].manager_name)
	                 	$('#supply_amount').val(comma(array[0].supply_amount));
	            		$('#tax_amount').val(comma(array[0].tax_amount));
	               		$('#total_amount').val(comma(array[0].total_amount));
	               		$('#productQty').val(comma(array[0].productQty));
	               		
	               		$('#bigo').val(array[0].bigo);       		
	            	/* 	$('#order_yn').val(array[0].order_yn); */
	            		
	            		text += "<tr>";
	            		text += "<td class='num pctnum'><a href='#' onclick='removeAll(); return false;'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
						text += "<td class='prod'><input type='hidden' id='productCd' name='product_cd' value='"+array[0].product_cd+"'>";
						text += "<input type='text' id='productCode' name='productCode' value='"+array[0].product_code+"' readonly></td>"
	            		text += "<td class='prod'><input type='text' id='productName' name='productName' value='"+array[0].product_name+"' readonly></td>"
	            		text += "<td class='prod'><input type='text' id='productStandard' name='productStandard' value='"+array[0].product_standard+"' readonly></td>"
						text += "<td class='qty'><input type='text' id='productQty' name='productQty' value='"+comma(array[0].productQty)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); changeProductQty(this);'></td>";
	            		text += "</tr>";

	            		for (var i in array){
							
	            	 		text += "<tr id='product_"+num+"'>";
	            			text += "<td class='num pctnum'><a style='margin-left: 20px;' href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
	            			text += "<td class='code'>";
							text += "<input type='hidden' id='pdt_cd_"+num+"' name='pdt_cd' value='"+array[i].pdt_cd+"'>";
							text += "<input type='text' id='pdt_code_"+num+"' name='pdt_code' value='"+array[i].pdt_code+"'></td>";
	            			text += "<td class='prod'><input type='text' id='pdt_name_"+num+"' name='pdt_name' value='"+array[i].pdt_name+"' placeholder=\"품목\"></td>";
	            			text += "<td class='prod'><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' value='"+array[i].pdt_standard+"' placeholder=\"규격\"></td>";
	            			text += "<td class='qty'>";
	            			text += "<input type='hidden' id='set_"+num+"' name='set' value='"+array[i].cnt+"' readonly>";
	            			text += "<input type='text' id='cnt_"+num+"' name='cnt' value='"+comma(array[i].cnt)+"' readonly>";
	            			text += "</td>";
	            			text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' value='"+array[i].unit+"'></td>";
	            			text += "<td class='qty'><input type='text' id='qty_"+num+"' name='qty' value='"+comma(array[i].qty)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange("+num+"); stockChange(this);'></td>";
	            			text += "<td class='qty'><input type='text' id='unit_price_"+num+"' name='unit_price' value='"+comma(array[i].unit_price)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange("+num+");'></td>";
	            			text += "<td class='qty'><input type='text' id='supply_price_"+num+"' name='supply_price' value='"+comma(array[i].supply_price)+"' readonly></td>";
	            			text += "<td class='name'>";
	            			text += "<input type='hidden' id='custSeq_"+num+"' name='custSeq' value='"+array[i].custSeq+"'>";
							text += "<input type='text' id='custName_"+num+"' name='custName' value='"+array[i].custName+"'></td>";
	            			text += "<td class='qty'>";
	            			text += "<input type='hidden' id='vat_"+num+"' name='vat' value='"+comma(array[i].vat)+"'>"
	            			text += "<input type='text' id='estimateStock_"+num+"' name='estimateStock' value='"+comma(array[i].pdt_stock)+"' placeholder='예상재고' readonly>";//예상재고
	            			text += "</td>";
	            			text += "<td class='qty'><input type='text' id='currentStock_"+num+"' name='currentStock' value='"+comma(array[i].pdt_stock)+"' placeholder='현재고' readonly></td>"; //현재고
	            			text += "<td class='qty'><input type='text' id='safetyStock_"+num+"' name='safetyStock' value='"+comma(array[i].safety_stock)+"' placeholder='안전재고' readonly></td>"; //안전재고
	            			text += "</tr>";

	            			num += 1;
	            		}
	                   	
	            		
	            		$('#searchResult').html(text);	            		
	            		$('#productCount').val(num);
	    
	            	}else{
	            		text += "<tr class='all'><td colspan='7'>발주계획 정보가 없습니다.</td></tr>";
	            	}
	            	
	            	$('#actionButton').text('수정');
	            	
	        		$('input[name="estimateStock"]').each(function (idx, item) {
	        	      	var splitArr = (item.id).split('_');
	        			
	        	    	var curStock = $('#currentStock_'+splitArr[1]).val().replace(/,/gi, ""); //현재고
	           			var safetyStock = $('#safetyStock_'+splitArr[1]).val().replace(/,/gi, ""); //안전재고

	           			if (Number(curStock) < Number(safetyStock)){
	        	    		$('#estimateStock_'+splitArr[1]).css("color","red");
	        	    	}else{
	        	    		$('#estimateStock_'+splitArr[1]).css("color","#76787b");
	        	    	}
	        		});
	            }
	         }); 
		}else{ //신규작성일때
    		$('#mode').val('register');
 
    		$('#actionButton').text('등록');
         	$('#searchResult').empty();
			$('#orderInfo_Form').resetForm();
			
			var today = new Date();   

			var year = today.getFullYear(); // 년도
			var month = today.getMonth() + 1;  // 월		
			var date = today.getDate();  // 날짜
			
			var monthChars = month.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
			var dateChars = date.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
			
			month = (monthChars[1]? month:"0"+month);// 한자리일경우 monthChars[1]은 존재하지 않기 때문에 false
			date = (dateChars[1]? date:"0"+date);// 한자리일경우 dateChars[1]은 존재하지 않기 때문에 false
			
			date = year + "-" + month + "-" + date;
			$('#manager_name').val("<%=user.getManagerName()%>");
			$('#reg_date').val(date);
		}

		$('#orderInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	
	function orderInfoLayer_Close(){
		$('#orderInfoLayer').removeClass('view');
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
			targetUrl = "/orderPlan/registerOrderPlan";
			msg = "발주계획서가 등록되었습니다."
		} else if (mode == 'view'){
			targetUrl = "/orderPlan/editOrderPlan";
			msg = "발주계획서가 수정되었습니다."
		}


        $('input[name="pdt_name"]').each(function (idx, item) {
        	pdt_name = $(item).val();
        	if (isEmpty(pdt_name)){
        		alert("품목명을 입력해주세요.");
        		status = false;
        		return false;
        	}
       	});
        if (status == false) return;
        
        $('input[name="qty"]').each(function (idx, item) {
        	qty = $(item).val();
        	if (isEmpty(qty)){
        		alert("발주량을 입력해주세요.");
        		status = false;
        		return false;
        	}
       	});
       if (status == false) return;
        
        $('input[name="unit_price"]').each(function (idx, item) {
        	unit_price = $(item).val();
        	if (isEmpty(unit_price)){
        		alert("단가를 입력해주세요.");
        		status = false;
        		return false;
        	}
       	});
        if (status == false) return;
        
         $('input[name="unit"]').each(function (idx, item) {
        	var unit = $(item).val();
        	if (isEmpty(unit)){
        		alert("단위를 입력해주세요.");
        		status = false;
        		return false;
        	}
       	});
        if (status == false) return;
         
		/* $('input[name="custSeq"]').each(function (idx, item) {
        	var custSeq = $(item).val();
        	if (isEmpty(custSeq)){
        		alert("업체명을 입력해주세요.");
        		status = false;
        		return false;
        	}
       	});
        if (status == false) return;
         */

        var ordermaterialList =[];

		for (var i = 0; i < $("input[name='pdt_name']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;
			tmpMap.pdt_cd = $($("input[name='pdt_cd']")[i]).val();
			tmpMap.pdt_code = $($("input[name='pdt_code']")[i]).val();
			tmpMap.pdt_name = $($("input[name='pdt_name']")[i]).val();
			tmpMap.pdt_standard = $($("input[name='pdt_standard']")[i]).val();
			tmpMap.qty = $($("input[name='qty']")[i]).val().replace(/,/g, "");
			tmpMap.unit = $($("input[name='unit']")[i]).val();
			tmpMap.unit_price = $($("input[name='unit_price']")[i]).val().replace(/,/g, "");
			tmpMap.supply_price = $($("input[name='supply_price']")[i]).val().replace(/,/g, "");
			tmpMap.vat = $($("input[name='vat']")[i]).val().replace(/,/g, "");
			
			if (isEmpty($($("input[name='cnt']")[i]).val().replace(/,/g, ""))){ //파트리스트에서 가져온수량
				tmpMap.cnt = 0;
			}else{
				tmpMap.cnt = $($("input[name='cnt']")[i]).val().replace(/,/g, "");
			}
			
			if (isEmpty($($("input[name='custSeq']")[i]).val())){
				tmpMap.custSeq = 0;
			}else{
				tmpMap.custSeq = $($("input[name='custSeq']")[i]).val();
			}

			

			ordermaterialList.push(tmpMap)
		}
		var order_info =[];
		var tmpMap2 = {};

		if (ordermaterialList.length < 1 ){
			alert("품목이 없습니다.");
			return false;
		}

		tmpMap2.writer_name = $($("input[name='writer_name']")).val();
		tmpMap2.reg_date = $($("input[name='reg_date']")).val();
		tmpMap2.supply_amount = $($("input[name='supply_amount']")).val().replace(/,/g, "");
		tmpMap2.tax_amount = $($("input[name='tax_amount']")).val().replace(/,/g, "");
		tmpMap2.total_amount = $($("input[name='total_amount']")).val().replace(/,/g, "");
		tmpMap2.product_cd = $('#product_cd').val();
		tmpMap2.bigo = $('#bigo').val();
		tmpMap2.productQty = $('#productQty').val().replace(/,/g, "");
		if (mode == "view"){
			tmpMap2.orderPlan_seq = $($("input[name='orderPlan_seq']")).val();
		}
		
		order_info.push(tmpMap2);
		sendData = {};
		
	    sendData.ordermaterialList = ordermaterialList;
	    sendData.order_info = order_info;

        $.ajax({
        	contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(sendData),
        	type: "POST",
        	url : targetUrl,
        	dataType : "json",
        	contentType: "application/json"
        	
        }).done(function(result) {

           if(result.success){
                alert(msg);
                orderInfoLayer_Close();
                location.reload();
             } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
             }
        });

	}
	
	
</script>

					<h3 class="mjtit_top">
						발주계획 조회
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/orderPlan/list">
                    	<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
                    <div class="srch_day">
                    	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate">작성일자</label>
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
                    	<%--<div class="sel_wrap sel_wrap1">
                    		<select name="order_status" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.order_status == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="NR" <c:if test="${search.order_status == 'NR'}">selected</c:if>>미수신</option>
	                            <option value="YR" <c:if test="${search.order_status == 'YR'}">selected</c:if>>수신확인</option>
	                            <option value="ADJ" <c:if test="${search.order_status == 'ADJ'}">selected</c:if>>조정요청</option>
	                            <option value="OP" <c:if test="${search.order_status == 'OP'}">selected</c:if>>진행중</option>
	                            <option value="OC" <c:if test="${search.order_status == 'OC'}">selected</c:if>>완료</option>
	                            <option value="NO" <c:if test="${search.order_status == 'NO'}">selected</c:if>>취소</option>                                  
                            </select>
                    	</div>--%>
                    	
                    	<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="WRITER" <c:if test="${search.search_type == 'WRITER'}">selected</c:if>>작성자</option>
	                            <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목명</option>
                                  
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}"/>
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
                    		<div class="set_left">
								<button type="button" class="btn_02 popLayermaterialRegistBtn" onclick="createOrderMulti();">선택생성</button>
							</div>
							
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
	                    			<col style="width: 55px;"/>
	                    			<col style="width: 280px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 150px;"/>
	                    		</colgroup>
	           		        	<thead>
	                    			<tr>
	                    				<th>
	                    					<div class="chkbox ">
		                    					<label for="check_all" >
													<input type="checkbox" name="undefine" id="check_all" onclick="checkAll()"/>
													<span></span>
												</label>
											</div>
	                    				</th>
	                    				<th>No</th>
	                	   				<th colspan="3">품목명</th>	                    				
	                    				<th>작성자</th>
	                    				<th colspan="2">작성일자</th>
	                    				<th>관리</th>
    		               			</tr>
	                    		</thead>
	                    		<tbody>
	                    			<c:forEach items="${list}" var="list" varStatus="status">
		                    			<tr>
		                    				<td class="num">
		                    					<div class="chkbox ">
			                    					<label for="check_${status.index + 1}">
														<input type="checkbox" id="check_${status.index + 1}" name="check" value="${list.orderPlan_seq}"/>
														<span></span>
													</label>
												</div>
		                    				</td>
		                    				<td class="num"><fmt:formatNumber value="${total +1 - list.no}" pattern="#,###,###"/></td>
		                    				<td class="prod" colspan="3">
			                    				<a href="#" onclick="viewOrderPlanDetail('${list.orderPlan_seq}','view');">${list.pdt_name}</a>
			                    				<a href="#" onclick="viewOrderPlanDetail('${list.orderPlan_seq}','view');" class="m_link">${list.pdt_name}</a>
		                    				</td>
		       								<td class="name">${list.manager_name}</td>
		                    				<td class="day" colspan="2">${list.reg_date}</td>
											<td class="name">
												<button type="button" class="btn_03 btn_s" onclick="createOrder('${list.orderPlan_seq}');">생성</button>
												<button type="button" class="btn_03 btn_s" onclick="deleteOrderPlan('${list.orderPlan_seq}');">삭제</button>											
											</td>
<%-- 		                    				<c:choose>
		                    					<c:when test="${list.order_yn eq 'N'}">
		                    						<td class="ing">발주대기</td>
		                    					</c:when>
		                    					<c:when test="${list.order_yn eq 'Y'}">
		                    						<td class="ing">발주완료</td>
		                    					</c:when>

		                    				</c:choose> --%>
		                    			</tr>
	                    			</c:forEach>
									<c:if test="${empty list }">
										<tr><td colspan="9">등록된 발주계획이 없습니다.</td></tr>
									</c:if>
	                    			
	                    		</tbody>
	                    	</table>
	                    </div>
                    	<div class="mjpaging_comm">
            				${dh:pagingB(total, currentPage, rowsPerPage, 10, parameter)}
       					 </div>
                    </div>
 					
 			<div class="master_pop master_pop01" id="orderInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="orderInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01" >
					<div class="pop_inner">
					<form id="orderInfo_Form" name="orderInfo_Form">
						<input type="hidden" name="productCount" id="productCount"  value="1"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="orderPlan_seq" id="orderPlan_seq" />
						<input type="hidden" name="product_cd" id="product_cd"/>
						<input type="hidden" name="tax_amount" id="tax_amount"/>
						<input type="hidden" name="total_amount" id="total_amount"/>

						<h3>발주계획 등록/조회<a class="back_btn" href="#" onclick="orderInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
										<th scope="row">최종수정자</th>
										<td><input type="text" id="manager_name" name="manager_name" readonly="readonly"/></td>
										<th scope="row">작성일자</th>
										<td>
											<input type="text" id="reg_date" name="reg_date" readonly="readonly"/>
										</td>	
									</tr>

									<tr>
										<th scope="row">합계</th>
										<td colspan="3">
											<input type="text" name="supply_amount" id="supply_amount" readonly="readonly"/>
										</td>
									</tr>
									<tr>
										<th scope="row">비고</th>
										<td colspan="3">
											<input type="text" name="bigo" id="bigo" class="all"/>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_2" type="button" class="btn_02" onclick="productSearch();">품목 불러오기</button>
							</div>
							
							<div class="scroll">
								<table class="master_01 master_05" id="product" >	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 220px;"/>
										<col style="width: 220px;"/>
										<col style="width: 220px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
										<col style="width: 100px;"/>
										<col style="width: 150px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>품목코드</th>
											<th>품목명</th>
											<th>규격</th>
											<th>수량</th>
											<th>단위</th>
											<th>발주량</th>
											<th>단가</th>
											<th>합계</th>
											<th>업체명</th>											
											<th>예상재고</th>
											<th>현재고</th>
											<th>안전재고</th>
										</tr>
									</thead>
									<tbody id="searchResult">
										
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="orderInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="orderInfoLayer_Close();"><span>닫기</span></a>
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
			</div></div>
	
	

<script>
	
	function openLayer(num) {
		rowNum = num;
		if(sessionCheck()){
			var url = "/supply/popSupplyList?type=orderPlan";
			$('#popup').css('display','block');
			$('#popupframe').attr('src',url);
			$('html,body').css('overflow','hidden');
		}else{
			location.reload();
		}
	}
	
	function closeLayer() {
		$('#popup').css('display','none');
		$('#popupframe').removeAttr('src');
		$('html,body').css('overflow','');
		
	}
	function choiceCust(cust_seq, no, cust_name){
		$('#custSeq_'+rowNum).val(cust_seq);
		$('#custName_'+rowNum).val(cust_name);
	}

	function productSearch(){
		if (sessionCheck()) {
			var url = "/order/popProductList?type=orderplan";
			$('#product_popup').css('display', 'block');
			$('#product_popupframe').attr('src', url);
			$('html,body').css('overflow', 'hidden');

		} else {
			location.reload();
		}
	}
	
	function productSearch_close(){
		$('#product_popup').css('display','none');
		$('#product_popupframe').removeAttr('src');
		$('html,body').css('overflow','');
	}

	function PopPartListAdd(data){
		if(!sessionCheck()){location.reload(); return false;}
		
		var storeData = data.storeData;
		var array = storeData.list;
		var num = 1;
		if(array.length > 0){
			var text ="";
			$('#product_cd').val(array[0].PDT_CD);
			text += "<tr>";
			text += "<td class='num pctnum'><a href='#' onclick='removeAll(); return false;'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
			text += "<td class='prod'><input type='hidden' id='product_cd' name='product_cd' value='"+array[0].PDT_CD+"'/>";
			text += "<input type='text' id='productCode' name='productCode' value='"+array[0].PDT_CODE+"' readonly></td>"
			text += "<td class='prod'><input type='text' id='productName' name='productName' value='"+array[0].PDT_NAME+"' readonly></td>"
			text += "<td class='prod'> <input type='text' id='productStandard' name='productStandard' value='"+array[0].PDT_STANDARD+"' readonly></td>"
			text += "<td class='qty'><input type='text' id='productQty' name='productQty' value='1' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); changeProductQty(this);'></td>";
			text += "</tr>";
			for (var i in array){

		 		text += "<tr id='product_"+num+"'>";
				text += "<td class='num pctnum'><a style='margin-left: 20px;' href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
				text += "<td class='code'>"
				text += "<input type='hidden' id='pdt_cd_"+num+"' name='pdt_cd' value='"+array[i].M_CD+"'>";
				text += "<input type='text' id='pdt_code_"+num+"' name='pdt_code' value='"+array[i].MTR_CODE+"'></td>";
				text += "<td class='prod'><input type='text' id='pdt_name_"+num+"' name='pdt_name' value='"+array[i].MTR_NAME+"' placeholder=\"품목\"></td>";
				text += "<td class='prod'><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' value='"+array[i].MTR_STANDARD+"' placeholder=\"규격\"></td>";
				text += "<td class='qty'>";
				text += "<input type='hidden' id='set_"+num+"' name='set' value='"+array[i].QTY+"' readonly>";
				text += "<input type='text' id='cnt_"+num+"' name='cnt' value='"+comma(array[i].QTY)+"' readonly>";
				text += "</td>";
				text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' value='"+array[i].UNIT+"'></td>";
				text += "<td class='qty'><input type='text' id='qty_"+num+"' name='qty' value='"+comma(array[i].QTY)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange("+num+"); stockChange(this);'></td>";
				text += "<td class='qty'><input type='text' id='unit_price_"+num+"' name='unit_price' value='"+comma(array[i].IN_PRICE)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange("+num+");'></td>";
				text += "<td class='qty'><input type='text' id='supply_price_"+num+"' name='supply_price' value='"+comma(array[i].IN_PRICE * array[i].QTY)+"' readonly></td>";
				text += "<td class='name'>";
				text += "<input type='hidden' id='custSeq_"+num+"' name='custSeq' value=''>";
				text += "<input type='text' id='custName_"+num+"' name='custName' value='' onclick='openLayer("+num+");' placeholder='선택' readonly></td>";
				text += "<td class='qty'>";
				text += "<input type='hidden' id='vat_"+num+"' name='vat' value='"+comma(Math.round(array[i].IN_PRICE * array[i].QTY * 0.1))+"'>"
				text += "<input type='text' id='estimateStock_"+num+"' name='estimateStock' value='"+comma(array[i].PDT_STOCK)+"' placeholder='예상재고' readonly>";//예상재고
				text += "</td>";
				text += "<td class='qty'><input type='text' id='currentStock_"+num+"' name='currentStock' value='"+comma(array[i].PDT_STOCK)+"' placeholder='현재고' readonly></td>"; //현재고
				text += "<td class='qty'><input type='text' id='safetyStock_"+num+"' name='safetyStock' value='"+comma(array[i].SAFETY_STOCK)+"' placeholder='안전재고' readonly></td>"; //안전재고
				text += "</tr>";
				
				num += 1;
				

			}
			$('#productCount').val(num);
			$('#searchResult').html(text);

			priceCal();
			
			$('input[name="estimateStock"]').each(function (idx, item) {
		      	var splitArr = (item.id).split('_');
				
		    	var curStock = $('#currentStock_'+splitArr[1]).val().replace(/,/gi, ""); //현재고
	   			var safetyStock = $('#safetyStock_'+splitArr[1]).val().replace(/,/gi, ""); //안전재고

	   			if (Number(curStock) < Number(safetyStock)){
		    		$('#estimateStock_'+splitArr[1]).css("color","red");
		    	}else{
		    		$('#estimateStock_'+splitArr[1]).css("color","#76787b");
		    	}
			});
		}else{
			alert("해당 품목의 파트리스트가 존재하지 않습니다.")
		}
	
		
	}

	function removeAll(){
		$('#searchResult').empty();
		priceCal();
	}
	
	function changeProductQty(obj){
		var num = obj.value.replace(/,/gi, "");
		obj.value = comma(obj.value);
	 	$('input[name="cnt"]').each(function (idx, item) {
	      	var splitArr = (item.id).split('_');
	      	var setCnt = $('#set_'+splitArr[1]).val();
	      	var price = $('#unit_price_'+splitArr[1]).val().replace(/,/gi, "");
	    	var cnt = setCnt * num; //파트리스트 수량 * 입력한 상품수량
	    	
	    	$(item).val(comma(cnt)); //수량
	    	$('#qty_'+splitArr[1]).val( comma(cnt) ); //발주수량
	    	$('#supply_price_'+splitArr[1]).val( comma(cnt * price) ); //발주수량 * 단가
	    	$('#vat_'+splitArr[1]).val( comma(cnt * price * 0.1) );
	    	

	    	var curStock = $('#currentStock_'+splitArr[1]).val().replace(/,/gi, ""); //현재고
   			var safetyStock = $('#safetyStock_'+splitArr[1]).val().replace(/,/gi, ""); //안전재고
	    	$('#estimateStock_'+splitArr[1]).val(comma(curStock));
	    	
   			if (Number(curStock) < Number(safetyStock)){
	    		$('#estimateStock_'+splitArr[1]).css("color","red");
	    	}else{
	    		$('#estimateStock_'+splitArr[1]).css("color","#76787b");
	    	}
   			
   			
	 	});
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
			$('#unit_price_'+num).val(comma(price));
			$('#qty_'+num).val(comma(qty));
		}else{
			supply_price = price * qty;
			vat = Math.round(supply_price * 0.1);

			$('#supply_price_'+num).val(comma(supply_price));
			$('#vat_'+num).val(comma(vat));
			$('#unit_price_'+num).val(comma(price));
			$('#qty_'+num).val(comma(qty));
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
				$('[name=order_post_no]').val(data.zonecode); // 우편번호 (5자리)
				$('[name=order_addr]').val(data.address);
			}
		}).open();
	}

	function stockChange(obj){
		var splitArr = (obj.id).split('_');

		
		var safetyStock = Number($('#safetyStock_'+splitArr[1]).val().replace(/,/g, "")); //안전재고
		var curStock = Number($('#currentStock_'+splitArr[1]).val().replace(/,/g, "")); //현재고
		var qty = Number(obj.value.replace(/,/g, "")); // 발주량
		var cnt = Number($('#cnt_'+splitArr[1]).val().replace(/,/g, "")); //수량
		
		var estimateStock = curStock - (cnt - qty);// 예상재고 = 현재고 - (수량 - 발주량)

		$('#estimateStock_'+splitArr[1]).val(comma(estimateStock)); 
		if (estimateStock < safetyStock){
			$('#estimateStock_'+splitArr[1]).css("color","red");
		}else{
			$('#estimateStock_'+splitArr[1]).css("color","#76787b");
		}
	} 
	
	function searchCust(obj){
		
		var searchMsg = obj.value;
      	var splitArr = (obj.id).split('_');
        var result = "";
      	
      	
        if (searchMsg.length >= 2){
            for (var i in custArr){
          		var str = custArr[i].cust_name;
          		if (str.indexOf(searchMsg) != -1){
    			    result += "<li><a href=\"#\" onclick='choiceCust(\""+custArr[i].cust_seq+"\", \""+custArr[i].cust_name+"\", \""+obj.id+"\");'>"+custArr[i].cust_name+"</a></li>";
    		    }
          	}
           	
            if (result != ""){
                $('#searchText_'+splitArr[1]).html(result);
                $(obj).next('.auto_srch').addClass('view')
            }else{
            	$(obj).next('.auto_srch').removeClass('view')
            }
            
        }else{
        	$(obj).next('.auto_srch').removeClass('view')
        }


     }
	
	

	function checkAll(){
		var is_check = $("input:checkbox[name=check]:checked").length
		var checkCount = $("input:checkbox[name=check]:checkbox").length
		
		if(is_check < checkCount){
			$("input:checkbox[name='check']").attr("checked", true);
			$("input:checkbox[name='undefine']").attr("checked", true);
			
			
		}else{
			
			$("input:checkbox[name='check']").attr("checked", false);
			$("input:checkbox[name='undefine']").attr("checked", false);
		}
	}
	
	function createOrderMulti(){
		
		var is_check = $("input:checkbox[name=check]:checked").length
		
		if (is_check == 0){
			alert("선택 된 항목이 없습니다.");
			return;
		}

		
		var checkArr;
		
		$("input[name=check]:checked").each(function() { 
	        if(checkArr == undefined){
	        	checkArr = $(this).val()
	        }else{
	        	checkArr = checkArr + "_" +$(this).val();
	        }
	    });

		
		if(confirm("발주생성 하시겠습니까?")){
		    $.ajax({
				type : "GET",
				url : "/orderPlan/createOrderMulti?orderPlan_seq="+checkArr,
				async : false,
	         	success : function(data) {
		            if(data.success){
		            	alert("발주생성 하였습니다.");
		            	location.reload(true);
		            }else{
		            	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
		            }
		        },error : function(data){
		 
		        	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
		            location.reload(true);
	            }
			});
		}

	}
</script>
