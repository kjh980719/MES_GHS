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
		producePlanInfoLayer_Open(plan_code, "view");
	}
	function newRegister(type){
		producePlanInfoLayer_Open("", type)
	}

	
	
	function productAdd(){
		var num = Number($('#productCount').val());
		num += 1;
		var text ="";

		text += "<tr id='product_"+num+"'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'><input type='text' id='pdt_code_"+num+"' name='pdt_code' placeholder=\"품목코드\"></td>";
		text += "<td class='prod'>";
		text += "<div class=\"dan\">";
		text += "<span><input type='text' id='pdt_name_"+num+"' name='pdt_name' placeholder=\"품목\"></span>";
		text += "<span><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' placeholder=\"규격\"></span>";
		text += "</div>";
		text += "</td>";
		text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' placeholder=\"단위\" ></td>";
		text += "<td class='name'><input type='text' id='planqty_"+num+"' name='planqty' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"계획수량\"></td>";
		text += "<td class='name'><input type='text' id='bigo_1"+num+"' name='bigo' placeholder=\"적요\"></td>";
		text += "</tr>";
		

		$('#searchResult').append(text);
		
		$('#productCount').val(num);
	}
	function productDelete(rowNum){

		$("#product_"+rowNum).remove();

	}
	

	
	
	function producePlanInfoLayer_Open(plan_code, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');
			$('#statusZone').css('display','');
			$('#actionButton').html("수정");
			$.ajax({
	            type : "get",
	            url : '/producePlan/viewSales',
	            async : false,
	            data: "plan_code="+plan_code,
	            success : function(data) {
	            	var array = data.storeData;
	            	$('#cust_seq').val(array[0].cust_seq);
	            	$('#cust_name').val(array[0].cust_name);

					$('#dpt_code').val(array[0].dpt_code);
					$('#dpt_name').val(array[0].dpt_name);

					$('#message').val(array[0].message);

			       if(array[0].work_type == 'A'){
			            $("#work_type1").prop("checked",true);
			       }else if(array[0].work_type == 'B'){
			            $("#work_type2").prop("checked",true);
			        }

					$('#plan_code').val(array[0].plan_code);

					$("#start_date").datepicker();
		       		$('#start_date').val(array[0].startDate);

		       		$("#end_date").datepicker();
		       		$('#end_date').val(array[0].endDate);
					$('#reg_date').html(array[0].reg_date);

					$('#plan_status').val(array[0].plan_status);
					
					if (array[0].plan_status == 'PC'){
						$('#button_1').css("display", "none");
						$('#button_2').css("display", "none");
					}else if (array[0].plan_status == 'PR' || array[0].plan_status == 'PP'){
						$('#button_1').css("display", "")
						$('#button_2').css("display", "")
					}
					var pdt_code = "";
					var no = "";
					var pdt_cd = "";
					var pdt_name = "";
					var pdt_standard = "";
					var unit = "";
					var planqty = "";
					var bigo = "";
					var number = 1;
		       		if (array.length > 0){
		       			for (var i in array){
		       				
		       				pdt_code = array[i].pdt_code;
	                		no = array[i].no;
							pdt_cd = array[i].pdt_cd;
	                		pdt_name = array[i].pdt_name;
	                		pdt_standard = array[i].pdt_standard;
	                		unit = array[i].unit;
	                		planqty = array[i].planqty
	                		bigo = array[i].bigo;
							
                            text += "<tr id='product_"+(number)+"'>";
                            text += "<td class='num pctnum'><a href='#' onclick='productDelete("+number+")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
	                		text += "<td class='code'>";
	                		text += "<input type='hidden' id='pdt_cd_"+number+"' name='pdt_cd' value='"+pdt_cd+"'><input type='text' name='pdt_code' id='pdt_code_"+number+"' value='"+pdt_code+"' readonly placeholder=\"품목코드\"/></td>";
	                		text += "<td class='prod'><input type='text' id='pdt_name_"+number+"' name='pdt_name' placeholder=\"품목\" value='"+pdt_name+"' /></td>";
	                		text += "<td class='prod'><input type='text' id='pdt_standard_"+number+"' name='pdt_standard' placeholder=\"규격\" value='"+pdt_standard+"'/></td>";
	                		text += "<td class='name'><input type='text' name='unit' id='unit_"+number+"' value='"+unit+"' placeholder=\"단위\"/></td>";
	                		text += "<td class='qty'><input type='text' name='planqty' id='planqty_"+number+"' value='"+comma(planqty)+" ' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"계획수량\"/></td>";
	                		text += "<td class='name'><input type='text' name='bigo' id='bigo_"+number+"' value='"+bigo+"' placeholder=\"적요\"/></td>";
	                		text += "</tr>";
							number += 1;
	                	}
		       		}else{
	            		text += "<tr class='all'><td colspan='7'>품목정보가 없습니다.</td></tr>";
	            	}
					$('#productCount').val(array.length)
	            	$('#searchResult').html(text);

	            }
	         });
		}else{ //신규작성일때
			
    		$('#mode').val('register');
       		$('#button_1').css('display','inline-block');
       		$('#button_2').css('display','inline-block');
       	 	$("#work_type1").prop("checked",true);
			$('#productCount').val("1");
    		$('#actionButton').text('등록');
         	$('#searchResult').empty();
			$('#producePlanInfo_Form').resetForm();
			
       		$("#start_date").datepicker();
         	$("#start_date").datepicker('setDate', '+0M');

       		$("#end_date").datepicker();
         	$("#end_date").datepicker('setDate', '+3M');

			let today = new Date();
			var now = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
			$("#reg_date").html(now);
/*

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
    		text += "<td class='name'><input type='text' id='planqty_1' placeholder=\"계획수량\" name='planqty'onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12'></td>";
    		text += "<td class='name'><input type='text' id='bigo_1' name='bigo' placeholder=\"적요\"></td>";
    		text += "</tr>";

    		$('#searchResult').html(text);*/


		}

		$('#producePlanInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	

	
	function producePlanInfoLayer_Close(){
		$('#producePlanInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}
	
	function GoActionButton(){
		var targetUrl = ""
		var pdt_name = "";
		var qty = "";
		var status = true;
		var msg = ""
		var mode = $('#mode').val();

		if (mode == 'register') {
			targetUrl = "/producePlan/registerProducePlanSales";
			msg = "생산계획이 등록되었습니다."
		} else if (mode == 'view'){
			targetUrl = "/producePlan/editProducePlanSales";
			msg = "생산계획이 수정되었습니다."
		}
		
		var startDate = $('#start_date').val();
		var endDate = $('#end_date').val();


		
		var startDay = new Date(startDate);
		var endDay = new Date(endDate);

		if (startDay > endDay){
			alert("시작일 보다 종료일이 더 큽니다.");
			return false;
		}

		if( isEmpty($('#cust_name').val())){
			alert("납품처를 선택해주세요");
			$('#buyer_name').focus();
			return false;
		}

		if( $('input[name="pdt_name"]').length == 0){
			alert("품목이 없습니다.");
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
        		alert("계획수량을 입력해주세요.");
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

        var detailList =[];
        
		for (var i = 0; i < $("input[name='pdt_name']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;
			tmpMap.pdt_cd = $($("input[name='pdt_cd']")[i]).val();
			tmpMap.pdt_code = $($("input[name='pdt_code']")[i]).val();
			tmpMap.pdt_name = $($("input[name='pdt_name']")[i]).val();
			tmpMap.pdt_standard = $($("input[name='pdt_standard']")[i]).val();
			tmpMap.planqty = $($("input[name='planqty']")[i]).val().replace(/,/g, "");
			tmpMap.unit = $($("input[name='unit']")[i]).val();
			tmpMap.bigo = $($("input[name='bigo']")[i]).val();


			detailList.push(tmpMap)
		}
		
		var info =[];
		var tmpMap2 = {};
		tmpMap2.delivery_date = $($("input[name='delivery_date']")).val();
		tmpMap2.dpt_code = $($("input[name='dpt_code']")).val();
		tmpMap2.message = $($("input[name='message']")).val();	
		tmpMap2.start_date = startDate;
		tmpMap2.end_date = endDate;	
		tmpMap2.cust_seq = $($("input[name='cust_seq']")).val();
		tmpMap2.plan_status = $('#plan_status option:selected').val();
		if (mode == "view"){
			tmpMap2.plan_code = $($("input[name='plan_code']")).val();
		}
		tmpMap2.work_type = $('input[name="work_type"]:checked').val();
		tmpMap2.plan_type = "S";
		info.push(tmpMap2);
		
		sendData = {};	
	    sendData.detailList = detailList;
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
                producePlanInfoLayer_Close();
                location.reload();
             } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
             }
        });

	}

	function deletePlan(plan_code){
		
		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/producePlan/delete',
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

</script>

					<h3 class="mjtit_top">
						생산계획 조회
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/producePlan/salesList">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
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

                    </div>
                    <div class="srch_all">
                    	<div class="sel_wrap sel_wrap1">
							<select name="plan_status" class="sel_02">
								<option value="ALL" <c:if test="${search.plan_status eq 'ALL'}">selected</c:if>>전체</option>
								<c:forEach items="${planStatus}" var="result">
									<option value="${result.code}" <c:if test="${search.plan_status eq result.code}">selected</c:if>>${result.code_nm}</option>
								</c:forEach>
							</select>
                    	</div>
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="PLAN_CODE" <c:if test="${search.search_type == 'PLAN_CODE'}">selected</c:if>>코드</option>                        
                            	<option value="CUST_NAME" <c:if test="${search.search_type == 'CUST_NAME'}">selected</c:if>>납품처</option>
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
                    	<div class="list_set">

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
								<col style="width: 120px;"/>
								<col style="width: 70px;"/>
                    			<col style="width: 70px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>생산계획코드</th>
                    				<th>품목</th>
                    				<th>납품처</th>
									<th>작성일자</th>
									<th>상태</th>
                    				<th>관리</th>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list" varStatus="status">
	                    			<tr>
	                    				
	                    				<td class="num"><fmt:formatNumber value="${total+1-list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="planDetail('${list.plan_code}'); return;">${list.plan_code}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="planDetail('${list.plan_code}'); return;">${list.pdt_name}</a>
		                    				<a href="#" onclick="planDetail('${list.plan_code}'); return;" class="m_link">${list.pdt_name}</a>
	                    				</td>
	                    				<td class="sang">${list.cust_name}</td>
										<td class="code">${list.reg_date}</td>


										<td class="ing">
											<c:forEach items="${planStatus}" var="result">
												<c:if test="${result.code eq list.plan_status}">${result.code_nm}</c:if>
											</c:forEach>
										</td>

	    								<td class="num"><button type="button" class="btn_03 btn_s" onclick="deletePlan('${list.plan_code}');">삭제</button></td>

	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="7">생산계획 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="producePlanInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="producePlanInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="producePlanInfo_Form" name="producePlanInfo_Form">
						<input type="hidden" name="productCount" id="productCount"  value="0"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" id="dpt_code" name="dpt_code"/>
						<input type="hidden" id="cust_seq" name="cust_seq"/>
						<h3>생산계획 등록/조회<a class="back_btn" href="#" onclick="producePlanInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
										<th scope="row">생산계획코드</th>
										<td><input type="text" id="plan_code" name="plan_code" readonly="readonly"/></td>
										<th scope="row">작업분류 <span class="keyf01">*</span></th>
										<td>
											<div class="radiobox">
												<label for="work_type1">
													<input type="radio" id="work_type1" name="work_type"  value="A" checked="checked"/><span>정기생산</span>
												</label>
												<label for="work_type2">
													<input type="radio" id="work_type2" name="work_type"  value="B"/><span>수주생산</span>
												</label>
											</div>
										</td>									
									</tr>
									<tr>
										<th scope="row">납품처 <span class="keyf01">*</span></th>
										<td><input type="text" id="cust_name" name="cust_name" class="all" onclick="openLayer();" readonly/></td>
										<th scope="row">담당부서</th>
										<td>
											<input type="text" id="dpt_name" name="dpt_name" onclick="departmentSearch_open();" class="all" readonly />											
										</td>															
									</tr>
																
									<tr>									
										<th scope="row">시작일자 <span class="keyf01">*</span></th>
										<td>
											<div class="day_input"><input type="text" id="start_date" name="start_date" onchange="dateCheck(this);" /></div>									
										</td>		
										<th scope="row">종료일자 <span class="keyf01">*</span></th>
										<td>
											<div class="day_input"><input type="text" id="end_date" name="end_date" onchange="dateCheck(this);"/></div>									
										</td>	
									</tr>

									<tr id="statusZone">
										<th scope="row">진행현황 <span class="keyf01">*</span></th>
										<td>
											<div id="status" class="sel_wrap">
												<select class="sel_02" id="plan_status" name="plan_status" onChange="reasonShow(this)">
													<c:forEach items="${planStatus}" var="result">
														<option value="${result.code}">${result.code_nm}</option>
													</c:forEach>
												</select>
											</div>
										</td>

										<th scope="row">작성일자</th>
										<td>
											<div id="reg_date" name="reg_date"></div>
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
								<button id="button_2" type="button" class="btn_02" onclick="productSearch();">불러오기</button>
							</div>
							<div class="scroll">
								<table class="master_01 master_05">	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 200px;"/>
										<col style="width: 250px;"/>
										<col style="width: 200px;"/>
										<col style="width: 80px;"/>
										<col style="width: 100px;"/>
										<col style="width: 180px;"/>
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>품목코드</th>
											<th>품목명</th>
											<th>규격</th>
											<th>단위</th>
											<th>계획수량</th>
											<th>적요</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="producePlanInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="producePlanInfoLayer_Close();"><span>닫기</span></a>
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
				<div id="department_popup" class="layer_pop">
					<div class="handle_wrap">
						<div class="handle"><span>부서 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="departmentSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="department_popupframe"></iframe>							
				</div>
				
			</div>
		</div>
	</div>

<script>

	function openLayer() {
		if (sessionCheck()) {
			var url = "/supply/popSupplyList?type=producePlan";
			$('#popup').css('display', 'block');
			$('#popupframe').attr('src', url);
			$('html,body').css('overflow', 'hidden');
		} else {
			location.reload();
		}
	}

	function closeLayer() {
		$('#popup').css('display','none');
		$('#popupframe').removeAttr('src');
		$('html,body').css('overflow','');
		
	}
	
	function productSearch(){
		if (sessionCheck()){
			var url = "/order/popProductList?type=producePlan";
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
		console.log(pdt);
		var num = Number($('#productCount').val());
		num += 1;
		var text ="";
		text += "<tr id='product_"+num+"'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'>";
		text += "<input type='hidden' id='pdt_cd_"+num+"' name='pdt_cd' value='"+pdt.PDT_CD+"'>";
		text +=	"<input type='text' id='pdt_code_"+num+"' name='pdt_code' readonly value='"+pdt.PDT_CODE+"'></td>";
		text += "<td class='prod'><span><input type='text' id='pdt_name_"+num+"' name='pdt_name' value='"+pdt.PDT_NAME+"' placeholder=\"품목\"></span></td>";
		text += "<td class='prod'><span><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' value='"+pdt.PDT_STANDARD+"' placeholder=\"규격\"></span></td>";
		text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' value='"+pdt.UNIT+"' placeholder=\"단위\"></td>";
		text += "<td class='name'><input type='text' id='planqty_"+num+"' name='planqty' value='' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"계획수량\"></td>";
		text += "<td class='name'><input type='text' id='bigo_"+num+"' name='bigo' value='' placeholder=\"적요\"></td>";
		text += "</tr>";
		$('#searchResult').append(text);
		$('#productCount').val(num);
	
		
	}
	

	function departmentSearch_open(){		
		if (sessionCheck()){
			var url = "/department/popDepartmentList";
			$('#department_popup').css('display','block');
			$('#department_popupframe').attr('src',url);
			$('html,body').css('overflow','hidden');
		}else{
			location.reload(true);
		}
		
	}
	
	function departmentSearch_close(){
		$('#department_popup').css('display','none');
		$('#department_popupframe').removeAttr('src');
		$('html,body').css('overflow','');
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

	function choiceCust(cust_seq, no, cust_name){
		$('#cust_seq').val(cust_seq);
		$('#cust_name').val(cust_name);
	}

</script>