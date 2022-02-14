<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>

<script type="text/javascript" src="/js/common/paging.js"></script>
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
	
	function planDetail(plan_code){
		workplanInfoLayer_Open(plan_code, "view");
	}
	function newRegister(type){
		workplanInfoLayer_Open("", type)
	}

	
	
	function productAdd(){
		var num = Number($('#productCount').val());
		num += 1;
		var text ="";

		text += "<tr id='product_"+num+"'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'><input type='text' id='pdt_code_"+num+"' name='pdt_code' placeholder=\"품목코드\" ></td>";
		text += "<td class='prod'>";
		text += "<div class=\"dan\">";
		text += "<span><input type='text' id='pdt_name_"+num+"' name='pdt_name' placeholder=\"품목\"></span>";
		text += "<span><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' placeholder=\"규격\"></span>";
		text += "</div>";
		text += "</td>";
		text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' placeholder=\"단위\"></td>";
		text += "<td class='name'><input type='text' id='planqty_"+num+"' name='planqty' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' maxlength='7' placeholder=\"검사수량\"></td>";
 		text += "<td class='name'><input type='text' id='produceQty_"+num+"' name='produceQty'  onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' maxlength='7' placeholder=\"합격수량\"></td>";		
		text += "<td class='name'><input type='text' id='factory_code_1"+num+"' name='factory_code' placeholder=\"불합격수량\" ></td>";
		text += "<td class='name'><input type='text' id='bigo_1"+num+"' name='bigo' placeholder=\"적요\"></td>";
		text += "</tr>";
		
 

		$('#searchResult').append(text);
		
		$('#productCount').val(num);
	}
	function productDelete(rowNum){

		$("#product_"+rowNum).remove();

	}
	

	
	
	function workplanInfoLayer_Open(plan_code, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');
			$('statusZone').css('display', '');
			$('#actionButton').html("수정");
			$.ajax({
	            type : "get",
	            url : '/workplan/view',
	            async : false,
	            data: "plan_code="+plan_code,
	            success : function(data) {
	            	var array = data.storeData;
	            	console.log(data);
					$('#cust_name').val(array[0].cust_name);
					$('#message').val(array[0].message);								
					$('#plan_code').val(array[0].plan_code);
					$('#auth_group_name').val(array[0].groupName);
					$('#manager_name').val(array[0].managerName + " " +array[0].manager_position);
					$('#manager_seq').val(array[0].manager_seq);
					
					var start_date = Left(array[0].startDate,10);
					var start_hour = Left(Right(array[0].startDate, 8),2);
					var start_minute = Left(Right(array[0].startDate, 5),2);
					
					var end_date = Left(array[0].endDate,10);
					var end_hour = Left(Right(array[0].endDate, 8),2);
					var end_minute = Left(Right(array[0].endDate, 5),2);
				   
					if(array[0].work_type == 'A'){
				       $("#work_type1").prop("checked",true);
				    }else if(array[0].work_type == 'B'){
				       $("#work_type2").prop("checked",true);
				    }
					
					if(array[0].work_type2 == 'C'){
					       $("#work_type3").prop("checked",true);
					}else if(array[0].work_type2 == 'D'){
					       $("#work_type4").prop("checked",true);
					}
				
		       		$("#start_date").datepicker();
		       		$('#start_date').val(start_date);
		       		$('#start_hour').val(start_hour);
		       		$('#start_minute').val(start_minute);
	  
		       		$("#end_date").datepicker();
		       		$('#end_date').val(end_date);
		       		$('#end_hour').val(end_hour);
		       		$('#end_minute').val(end_minute);

		       		$('#plan_status').val(array[0].plan_status);
					if (array[0].plan_status == 'PC'){ //완료
						$('#button_1').css("display", "none");
						$('#button_2').css("display", "none");						

					
					}else if (array[0].plan_status == 'PR'){ //대기중
						$('#button_1').css("display", "")
						$('#button_2').css("display", "")
						

					}else if (array[0].plan_status == 'PP'){ // 진행중
						$('#button_1').css("display", "");
						$('#button_2').css("display", "");
						
	
					
					}else if(array[0].plan_status == 'PE'){ // 취소
						$('#button_1').css("display", "none");
						$('#button_2').css("display", "none");						

					
					}
					

		       		if (array.length > 0){
		       			for (var i in array){
                   			
		       				pdt_code = array[i].pdt_code;
	                		no = array[i].no;
	                		pdt_name = array[i].pdt_name;
	                		pdt_standard = array[i].pdt_standard;
	                		factory_code = array[i].factory_code;
	                		unit = array[i].unit;
	                		planqty = array[i].planqty
	                		produceQty = array[i].produceQty;
	                		bigo = array[i].bigo;
	                		
                            text += "<tr id='product_"+i+"'>";
                            text += "<td class='num pctnum'><a href='#' onclick='productDelete("+i+")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
	                		text += "<td class='code'><input type='text' name='pdt_code' id='pdt_code_"+i+"' value='"+pdt_code+"' readonly/></td>";       
	                		text += "<td class='prod'>";
	                		text += "<div class=\"dan\">";
	                		text += "<span><input type='text' id='pdt_name_"+i+"' name='pdt_name' placeholder=\"품목\" value='"+pdt_name+"' /></span>";
	                		text += "<span><input type='text' id='pdt_standard_"+i+"' name='pdt_standard' placeholder=\"규격\" value='"+pdt_standard+"'/></span>";	                		
	                		text += "</div>";
	                		text += "</td>";	                		
	                		text += "<td class='name'><input type='text' name='unit' id='unit_"+i+"' value='"+unit+"'/></td>";       
	                		text += "<td class='name'><input type='text' name='planqty' id='planqty_"+i+"' value='"+planqty+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' maxlength='7'/></td>";       				
	    					text += "<td class='name'><input type='text' name='produceQty' id='produceQty_"+i+"' value='"+produceQty+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); qtyCheck(this);' maxlength='7'/></td>";	    		       			                		        		
	                		text += "<td class='name'><input type='text' name='factory_code' id='factory_code_"+i+"' value='"+factory_code+"'/></td>";     
	                		text += "<td class='name'><input type='text' name='bigo' id='bigo_"+i+"' value='"+bigo+"'/></td>";     
	                		text += "</tr>";
	                	}
		       		}else{
	            		text += "<tr class='all'><td colspan='8'>품목정보가 없습니다.</td></tr>";
	            	}

					$('#searchResult').html(text);
	              
	            }
	         }); 
		}else{ //신규작성일때
			$('statusZone').css('display', 'none');
    		$('#mode').val('register');
       		$('#button_1').css('display','inline-block');
       		$('#button_2').css('display','inline-block');

    		$('#actionButton').text('등록');
         	$('#searchResult').empty();
			$('#workplanInfo_Form').resetForm();

       		$("#start_date").datepicker();
         	$("#start_date").datepicker('setDate', '+0');
         	$('#start_hour').val("08")
         	$('#end_hour').val("12")
       		$("#end_date").datepicker();
         	$("#end_date").datepicker('setDate', '+0');
         	
            text += "<tr id='product_1'>";
    		text += "<td class='num pctnum'><a href='#' onclick='productDelete(1)'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
    		text += "<td class='code'><input type='text' id='pdt_code_1' name='pdt_code' placeholder=\"품목코드\"></td>";
    		text += "<td class='prod'>";
    		text += "<div class=\"dan\">";
    		text += "<span><input type='text' id='pdt_name_1' name='pdt_name' placeholder=\"품목\"></span>";
    		text += "<span><input type='text' id='pdt_standard_1' name='pdt_standard' placeholder=\"규격\"></span>";
    		text += "</div>";
    		text += "</td>";
    		text += "<td class='name'><input type='text' id='unit_1' name='unit' placeholder=\"단위\"></td>";
    		text += "<td class='name'><input type='text' id='planqty_1' placeholder=\"검사수량\" name='planqty' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' maxlength='7'></td>";
    		text += "<td class='name'><input type='text' id='produceQty_1' placeholder=\"합격수량\" name='produceQty' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' maxlength='7'/></td>";
    		text += "<td class='name'><input type='text' id='factory_code_1' name='factory_code'  placeholder=\"불합격수량\"></td>";
    		text += "<td class='name'><input type='text' id='bigo_1' name='bigo' placeholder=\"적요\"></td>";
    		text += "</tr>";

    		$('#searchResult').html(text);


		}

		$('#workplanInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	

	
	function workplanInfoLayer_Close(){
		$('#workplanInfoLayer').removeClass('view');
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
		var msg = ""
		var mode = $('#mode').val();
		if (mode == 'register') {
			targetUrl = "/workplan/registerWorkPlan";
			msg = "작업지시서가 등록되었습니다."
		} else if (mode == 'view'){
			targetUrl = "/workplan/editWorkPlan";
			msg = "작업지시서가 수정되었습니다."
		}
		
		var start_date = $('#start_date').val() + " " + $('#start_hour').val() + ":" +$('#start_minute').val() + ":" + "00";
		var end_date = $('#end_date').val() + " " + $('#end_hour').val() + ":" +$('#end_minute').val() + ":" + "00";
		
		var startDay = new Date(start_date);
		var endDay = new Date(end_date);

		if (startDay > endDay){
			alert("시작일 보다 종료일이 더 큽니다.");
			return false;
		}

		$('input[name="pdt_name"]').each(function (idx, item) {
        	pdt_name = $(item).val();
        	if (isEmpty(pdt_name)){
        		alert("품목명을 입력해주세요.");
        		status = false;
        	}
       	});
        if (status == false) return;
        
        $('input[name="planqty"]').each(function (idx, item) {
        	qty = $(item).val();
        	if (isEmpty(qty)){
        		alert("수량을 입력해주세요.");
        		status = false;
        	}
       	});
       if (status == false) return;
              
        $('input[name="unit"]').each(function (idx, item) {
        	var unit = $(item).val();
        	if (isEmpty(unit)){
        		alert("단위를 입력해주세요.");
        		status = false;
        	}
       	});
        if (status == false) return;
        
        if( isEmpty($('#auth_group_name').val()) || isEmpty($('#manager_name').val()) ){
        	alert("담당자를 입력해주세요"); 
        	return false;
        }

        var materialList =[];
        
		for (var i = 0; i < $("input[name='pdt_name']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;		
			tmpMap.pdt_code = $($("input[name='pdt_code']")[i]).val();
			tmpMap.pdt_name = $($("input[name='pdt_name']")[i]).val();
			tmpMap.pdt_standard = $($("input[name='pdt_standard']")[i]).val();
			tmpMap.planqty = $($("input[name='planqty']")[i]).val().replace(/,/g, "");
			tmpMap.unit = $($("input[name='unit']")[i]).val();
			tmpMap.factory_code = $($("input[name='factory_code']")[i]).val();
			tmpMap.bigo = $($("input[name='bigo']")[i]).val();			
			
			if ( isEmpty($($("input[name='produceQty']")).val()) ){
				tmpMap.produceQty = 0;
			}else{
				tmpMap.produceQty = $($("input[name='produceQty']")[i]).val().replace(/,/g, "");
			}
			
			materialList.push(tmpMap)
		}
	
		var info =[];
		var tmpMap2 = {};
		tmpMap2.delivery_date = $($("input[name='delivery_date']")).val();
		tmpMap2.manager_seq = $($("input[name='manager_seq']")).val();
		tmpMap2.message = $($("input[name='message']")).val();	
		tmpMap2.start_date = start_date;
		tmpMap2.end_date = end_date;
		tmpMap2.cust_name = $($("input[name='cust_name']")).val();
		tmpMap2.work_type = $('input[name="work_type"]:checked').val();
		tmpMap2.plan_status = $('#plan_status option:selected').val();
		if ( isEmpty($($("input[name='cust_seq']")).val()) ){
			tmpMap2.cust_seq = 0;
		}else{
			tmpMap2.cust_seq = $($("input[name='cust_seq']")).val();
		}
		if (mode == "view"){
			tmpMap2.plan_code = $($("input[name='plan_code']")).val();
		}
		info.push(tmpMap2);
		
		sendData = {};	
	    sendData.materialList = materialList;
	    sendData.info = info;

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
                workplanInfoLayer_Close();
                location.reload();
             } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
             }
        });

	}
	
	
</script>

					<h3 class="mjtit_top">
						입고검사 조회
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/workplan/list">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
                  		                    <div class="srch_day">
                    	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate">입고일자</label>
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
                    		<select name="status" class="sel_02"> 
                    			<option value="ALL" <c:if test="${search.status == 'ALL'}">selected</c:if>>전체</option>
	                        	<option value="PR" <c:if test="${search.status == 'PR'}">selected</c:if>>대기중</option>
	                        	<option value="PP" <c:if test="${search.status == 'PP'}">selected</c:if>>진행중</option>       
	                        	<option value="PC" <c:if test="${search.status == 'PC'}">selected</c:if>>완료</option>    
	                        	<option value="PE" <c:if test="${search.status == 'PE'}">selected</c:if>>취소</option>                           
                            </select>
                    	</div>
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="PLAN_CODE" <c:if test="${search.search_type == 'PLAN_CODE'}">selected</c:if>>코드</option>
                            	<option value="CUST_NAME" <c:if test="${search.search_type == 'CUST_NAME'}">selected</c:if>>납품처</option>
                            	<option value="MANAGER" <c:if test="${search.search_type == 'MANAGER'}">selected</c:if>>담당자</option>                          
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string"   onkeyup="if(window.event.keyCode==13){goSearch();}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick='goSearch();'>검색</button>
                              <button type="button" class="btn_01">초기화</button> 
                          </div>
                          
                          <div class="register_btn">
                        	<button type="button" class="btn_02" onclick="newRegister();">신규등록</button>						
						
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
			                            <option value="15"<c:if test="${search.rowsPerPage == '15'}">selected</c:if>>15개씩 보기</option>
			                            <option value="30"<c:if test="${search.rowsPerPage == '30'}">selected</c:if>>30개씩 보기</option>
			                            <option value="50"<c:if test="${search.rowsPerPage == '50'}">selected</c:if>>50개씩 보기</option>
			                            <option value="100"<c:if test="${search.rowsPerPage == '100'}">selected</c:if>>100개씩 보기</option>
			                        </select>
		                        </div>
							</div>
	                    </div>
	                    <div class="scroll">
                    	<table class="master_01 master_06">
                    		<colgroup>
                    			<col style="width: 55px;"/>
                    			<col style="width: 120px;"/>
                    			<col style="width: 280px;"/>
                    			<col style="width: 210px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
                    	<%-- 		<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/> --%>
                    			<col style="width: 70px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>코드</th>
                    				<th>품목</th>
                    				<th>거래처</th>
                    				<th>담당자</th>
                    				<th>시작일자</th>
                    				<th>종료일자</th>		
                    			<!-- 	<th>입고창고</th>
                    				<th>담당자</th>                 				
                    				<th>검사구분</th> -->
                    				<th>관리</th> 
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="planDetail('${list.plan_code}'); return;">${list.plan_code}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="planDetail('${list.plan_code}'); return;">${list.pdt_name}</a>
		                    				<a href="#" onclick="planDetail('${list.plan_code}'); return;" class="m_link">${list.pdt_name}</a>
	                    				</td>
	                    				<td class="sang t_left">${list.cust_name}</td>
	       								<td class="name">${list.managerName}</td>
	       								<td class="day">${list.startDate}</td>
	       								<td class="day">${list.endDate}</td>
	                    				<%-- <td class="tel"><fmt:formatNumber value="${list.planQty}" pattern="#,###,###"/></td>
	                    				<td class="tel"><fmt:formatNumber value="${list.produceQty}" pattern="#,###,###"/></td>
	                    				<c:choose>
	                    					<c:when test="${list.plan_status eq 'PR'}">
	                    						<td class="ing">대기중</td>	                    						
	                    					</c:when>             
	                    					<c:when test="${list.plan_status eq 'PP'}">
	                    						<td class="ing">진행중</td>	                    						
	                    					</c:when>
	                    					<c:when test="${list.plan_status eq 'PC'}">
	                    						<td class="ing">완료</td>	                    						
	                    					</c:when>
	                    					<c:when test="${list.plan_status eq 'PE'}">
	                    						<td class="ing">취소</td>	                    						
	                    					</c:when>                			
	                    				</c:choose> --%>
	                    				<td class="num"><button type="button" class="btn_03 btn_s" onclick="deletePlan('${list.plan_code}');">삭제</button></td>
	    								

	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="11">입고검사 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="workplanInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="workplanInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="workplanInfo_Form" name="workplanInfo_Form">
						<input type="hidden" name="productCount" id="productCount"  value="1"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="manager_seq" id="manager_seq"/>
						<input type="hidden" id="cust_seq" name="cust_seq">
						<h3>입고검사 등록<a class="back_btn" href="#" onclick="workplanInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
										<th scope="row">입고코드</th>
										<td><input type="text" id="plan_code" name="plan_code" readonly="readonly"/></td>	
										
										
										<th scope="row">입고창고</th>										
										<td colspan="3"><input type="text" id="message" name="message" class="all"/></td>									
										
									</tr>
									<tr>
										<th scope="row">거래처</th>
										<td><input type="text" id="cust_name" name="cust_name" class="all" ondblclick="openLayer();"/></td>														
																	
										<th scope="row">검사담당자</th>
										<td>
											<div>
												<input type="text" id="auth_group_name" name="auth_group_name" onclick="managerSearch_open();" readonly />
											</div>
											<div class="dan">
												<input type="text" id="manager_name" name="manager_name" onclick="managerSearch_open();" readonly />
											</div>
										</td>															
									</tr>
					
									<tr>									
										<th scope="row">검사시작일자</th>
										<td>
											<div class="day_input"><input type="text" id="start_date" name="start_date" onchange="dateCheck(this);"/></div>											
											<div class="sel_wrap" >													
												<select class="sel_02" id="start_hour" name="start_hour">
													<c:forEach var="i" begin="0" end="23">
														<c:if test="${i < 10}">
															<option value="0${i}">0${i}시</option>
														</c:if>
														<c:if test="${i>=10}">
															<option value="${i}">${i}시</option>
														</c:if>													
													</c:forEach>																						
												</select>															
											</div>
											<div class="sel_wrap" >													
												<select class="sel_02" id="start_minute" name="start_minute">
													<c:forEach var="i" begin="0" end="59" step="10">
														<c:if test="${i < 10}">
															<option value="0${i}">0${i}분</option>
														</c:if>
														<c:if test="${i>=10}">
															<option value="${i}">${i}분</option>
														</c:if>																								
													</c:forEach>																						
												</select>															
											</div>	
																					
										</td>		
										<th scope="row">검사종료일자</th>
										<td>
											<div class="day_input"><input type="text" id="end_date" name="end_date" onchange="dateCheck(this);" /></div>
											<div class="sel_wrap" >													
												<select class="sel_02" id="end_hour" name="end_hour">
													<c:forEach var="i" begin="0" end="23">
														<c:if test="${i < 10}">
															<option value="0${i}">0${i}시</option>
														</c:if>
														<c:if test="${i>=10}">
															<option value="${i}">${i}시</option>
														</c:if>													
													</c:forEach>																						
												</select>															
											</div>
											<div class="sel_wrap" >													
												<select class="sel_02" id="end_minute" name="end_minute">
													<c:forEach var="i" begin="0" end="59" step="10">
														<c:if test="${i < 10}">
															<option value="0${i}">0${i}분</option>
														</c:if>
														<c:if test="${i>=10}">
															<option value="${i}">${i}분</option>
														</c:if>																								
													</c:forEach>																						
												</select>															
											</div>
										</td>	
									</tr>
	
									
									
									<tr id="statusZone">
										<th scope="row">검사유형</th>
										<td>										
											<div class="radiobox">
												<label for="work_type1">
													<input type="radio" id="work_type1" name="work_type"  value="A" checked="checked"/><span>외관검사</span>
												</label>
												<label for="work_type2">
													<input type="radio" id="work_type2" name="work_type"  value="B"/><span>성능검사</span>
												</label>
											</div>
										</td>	
										
										
										<th scope="row">검사구분</th>
										<td>										
											<div class="radiobox">
												<label for="work_type3">
													<input type="radio" id="work_type3" name="work_type2"  value="C" checked="checked"/><span>샘플검사</span>
												</label>
												<label for="work_type4">
													<input type="radio" id="work_type4" name="work_type2"  value="D"/><span>전수검사</span>
												</label>
											</div>
										</td>
										
										
																		
									</tr>
									
									<tr>	
										<th scope="row">비고</th>										
										<td colspan="3"><input type="text" id="message" name="message" class="all"/></td>															
									</tr>	
									
								</tbody>
							</table>
						</div>
						
						<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_1" type="button" class="btn_02" onclick="productAdd();">품목추가</button>
								<button id="button_2" type="button" class="btn_02" onclick="productSearch();">불러오기</button>
							</div>
							<div class="scroll">
								<table class="master_01 master_05">	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 110px;"/>
										<col style="width: 340px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
										<col style="width: 110px;"/>
										<col style="width: 110px;"/>
										<col style="width: 180px;"/>
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>품목코드</th>
											<th>품목및규격</th>										
											<th>단위</th>
											<th>검사수량</th>
											<th>합격수량</th>
											<th>불합격수량</th>
											<th>적요</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="workplanInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="workplanInfoLayer_Close();"><span>닫기</span></a>
				</div>
				<div id="popup" class="layer_pop">	
					<div class="handle_wrap">
						<div class="handle"><span>납품처 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="closeLayer(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="popupframe"></iframe>							
				</div>
				<div id="product_popup" class="layer_pop">	
					<div class="handle_wrap">
						<div class="handle"><span>물품 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="productSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="product_popupframe"></iframe>							
				</div>
				<div id="manager_popup" class="layer_pop">	
					<div class="handle_wrap">
						<div class="handle"><span>담당자 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="managerSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="manager_popupframe"></iframe>							
				</div>
				
			</div>
		</div>
	</div>

<script>
	
	function openLayer() {
		if (sessionCheck()){
			var url = "/cust/popCustList";
			$('#popup').css('display','block');
			$('#popupframe').attr('src',url);
			$('html,body').css('overflow','hidden');
		}else{
			location.reload(true);
		}
		
	}
	
	function closeLayer() {
		$('#popup').css('display','none');
		$('#popupframe').removeAttr('src');
		$('html,body').css('overflow','');
		
	}
	
	function productSearch(){
		if (sessionCheck()){
			var url = "/workplan/popProductList";
			$('#product_popup').css('display','block');
			$('#product_popupframe').attr('src',url);
			$('html,body').css('overflow','hidden');
		}else{
			location.reload(true);
		}
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
		text += "<td class='code'><input type='text' id='pdt_code_"+num+"' name='pdt_code' value='"+pdt.PROD_CD+"' placeholder=\"품목코드\"></td>";
		text += "<td class='prod'>";
		text += "<div class=\"dan\">";
		text += "<span><input type='text' id='pdt_name_"+num+"' name='pdt_name' value='"+pdt.PROD_DES+"' placeholder=\"품목\"></span>";
		text += "<span><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' value='"+pdt.PDT_STANDARD+"' placeholder=\"규격\"></span>";
		text += "</div>";
		text += "</td>";
		text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' value='"+pdt.UNIT+"' placeholder=\"단위\"></td>";
		text += "<td class='name'><input type='text' id='planqty_"+num+"' name='planqty' value='' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' maxlength='7' placeholder=\"검사수량\"></td>";  	
    	text += "<td class='name'><input type='text' id='produceQty_"+num+"' name='produceQty' value='' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); qtyCheck(this)' maxlength='7' placeholder=\"합격수량\"></td>";	
		text += "<td class='name'><input type='text' id='factory_code_"+num+"' name='factory_code' value='' placeholder=\"불합격수량\"></td>";		
		text += "<td class='name'><input type='text' id='bigo_"+num+"' name='bigo' value='' placeholder=\"적요\"></td>";
		text += "</tr>";


		$('#searchResult').append(text);
		
		$('#productCount').val(num);
	
		
	}
	

	function managerSearch_open(){		
		if (sessionCheck()){
			var url = "/workplan/popManagerList";
			$('#manager_popup').css('display','block');
			$('#manager_popupframe').attr('src',url);
			$('html,body').css('overflow','hidden');
		}else{
			location.reload(true);
		}
		
	}
	
	function managerSearch_close(){
		$('#manager_popup').css('display','none');
		$('#manager_popupframe').removeAttr('src');
		$('html,body').css('overflow','');
	}

	function qtyCheck(obj){
	
		var produceQty = obj.value;
		var id = $(obj).attr('id'); 	
		var i = id.split('_');
		var planQty = $('#planqty_'+i[1]).val();
		
		if (Number(produceQty) > Number(planQty)){
			obj.value = planQty;
		}
		
	}
	function statusChange(){
		var status = $('#plan_status').val();
		var plan_code = $('#plan_code').val();
		
		if (status == 'PR'){
			status = "PP";			
		}else if (status == 'PP'){
			status = "PC";
		}
		
		$.ajax({
            type : "get",
            url : '/workplan/statusUpdate',
            async : false,
            data: "plan_code="+plan_code+"&plan_status="+status,
         	success : function(data) {
	            if(data.success){
	            	alert("수정되었습니다.");
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
	
	function deletePlan(plan_code){
		
		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/workplan/delete',
	            async : false,
	            data: "plan_code="+plan_code,
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
	
	
	function dateCheck(obj){
		
		var id = $(obj).attr('id'); 
		
		var today = new Date(); 	
		var selectDate = new Date(obj.value);
		
		today = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0)
		selectDate = new Date(selectDate.getFullYear(), selectDate.getMonth(), selectDate.getDate(), 0)

		if (today > selectDate){
			alert("현재날짜보다 이전날짜는 선택할 수 없습니다.")
			$('#'+id).datepicker('setDate', '+0');
		}
		
	}
</script>