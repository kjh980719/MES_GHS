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
	
	function planDetail(as_code){
		asplanInfoLayer_Open(as_code, "view");
	}
	function newRegister(type){
		asplanInfoLayer_Open("", type)
	}

	
	
	function productAdd(){
		var num = Number($('#productCount').val());
		num += 1;
		var text ="";

		text += "<tr id='product_"+num+"'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'><input type='text' id='pdt_code_"+num+"' name='pdt_code' placeholder=\"품목코드\" ></td>";
		text += "<td class='prod'><input type='text' id='pdt_name_"+num+"' name='pdt_name' placeholder=\"품목\"></span></td>";
		text += "<td class='prod'><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' placeholder=\"규격\"></span></td>";
 		text += "<td class='qty'><input type='text' id='asQty_"+num+"' name='asQty'  onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"수량\"></td>";
		text += "<td class='name'><input type='text' id='bigo_1"+num+"' name='bigo' placeholder=\"적요\"></td>";
		text += "</tr>";
		
 

		$('#searchResult').append(text);
		
		$('#productCount').val(num);
	}
	function productDelete(rowNum){

		$("#product_"+rowNum).remove();

	}

	function asplanInfoLayer_Open(as_code, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');
			$('#actionButton').html("수정");
			$.ajax({
	            type : "get",
	            url : '/as/view',
	            async : false,
	            data: "as_code="+as_code,
	            success : function(data) {
	            	var array = data.storeData;

					$('#cust_seq').val(array[0].cust_seq);
					$('#cust_name').val(array[0].cust_name);
					$('#reason').val(array[0].reason);								
					$('#as_code').val(array[0].as_code);
					$('#auth_group_name').val(array[0].groupName);
					$('#manager_name').val(array[0].managerName + " " +array[0].manager_position);
					$('#manager_seq').val(array[0].manager_seq);
					
					$('#title').val(array[0].title);		
					$('#cost').val(comma(array[0].cost));
					
					var start_date = Left(array[0].startDate,10);
					var end_date = Left(array[0].endDate,10);
					var reg_date = Left(array[0].regDate,10);

		       		$("#start_date").datepicker();
		       		$('#start_date').val(start_date);

		       		$("#end_date").datepicker();
		       		$('#end_date').val(end_date);
		       		
		       		$('#reg_date').val(reg_date);

		       		$('#as_status').val(array[0].as_status);
					$('#div_work').val(array[0].div_work);

		       		if (array.length > 0){
		       			for (var i in array){
							pdt_cd = array[i].pdt_cd;
		       				pdt_code = array[i].pdt_code;
	                		no = array[i].no;
	                		pdt_name = array[i].pdt_name;
	                		pdt_standard = array[i].pdt_standard;
	                		asqty = array[i].asqty
	                		bigo = array[i].bigo;
	                		
                            text += "<tr id='product_"+i+"'>";
                            text += "<td class='num pctnum'><a href='#' onclick='productDelete("+i+")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
	                		text += "<td class='code'>";
							text += "<input type='hidden' name='pdt_cd' id='pdt_cd_"+i+"' value='"+pdt_cd+"'/>";
	                		text += "<input type='text' name='pdt_code' id='pdt_code_"+i+"' value='"+pdt_code+"' readonly/></td>";
	                		text += "<td class='prod'><input type='text' id='pdt_name_"+i+"' name='pdt_name' placeholder=\"품목\" value='"+pdt_name+"' /></td>";
	                		text += "<td class='prod'><input type='text' id='pdt_standard_"+i+"' name='pdt_standard' placeholder=\"규격\" value='"+pdt_standard+"'/></td>";
	    					text += "<td class='qty'><input type='text' name='asqty' id='asqty_"+i+"' value='"+comma(asqty)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12'/></td>";
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
    		$('#mode').val('register');

    		$('#actionButton').text('등록');
         	$('#searchResult').empty();
			$('#asplanInfo_Form').resetForm();
			
			
			var today = new Date();   

			var year = today.getFullYear(); // 년도
			var month = today.getMonth() + 1;  // 월		
			var date = today.getDate();  // 날짜
			var monthChars = month.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
			var dateChars = date.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
			
			month = (monthChars[1]? month:"0"+month);// 한자리일경우 monthChars[1]은 존재하지 않기 때문에 false
			date = (dateChars[1]? date:"0"+date);// 한자리일경우 dateChars[1]은 존재하지 않기 때문에 false
			
			date = year + "-" + month + "-" + date;
			$('#reg_date').val(date);
			

       		$("#start_date").datepicker();
         	$("#start_date").datepicker('setDate', '+0');
       		$("#end_date").datepicker();
         	$("#end_date").datepicker('setDate', '+0');

    		$('#searchResult').html(text);
		}

		$('#asplanInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	

	
	function asplanInfoLayer_Close(){
		$('#asplanInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}
	
	function GoActionButton(){
		var targetUrl = ""
		var status = true;
		var msg = ""
		var mode = $('#mode').val();

		if (mode == 'register') {
			targetUrl = "/as/registerAsPlan";
			msg = "AS가 등록되었습니다."
		} else if (mode == 'view'){
			targetUrl = "/as/editAsPlan";
			msg = "AS가 수정되었습니다."
		}
		
		var start_date = $('#start_date').val();
		var end_date = $('#end_date').val();
		
		var startDay = new Date(start_date);
		var endDay = new Date(end_date);


		if( isEmpty($('#title').val())){
			alert("제목을 입력해주세요");
			$('#title').focus();
			return false;
		}

		if( isEmpty($('#cust_seq').val()) ){
			alert("거래처를 입력해주세요");
			$('#cust_name').focus();
			return false;
		}

		if( isEmpty($('#auth_group_name').val()) || isEmpty($('#manager_name').val()) ){
			alert("담당자를 입력해주세요");
			$('#auth_group_name').focus();
			return false;
		}

		if (startDay > endDay){
			alert("시작일 보다 종료일이 더 큽니다.");
			$('#auth_group_name').focus();
			return false;
		}
		if ($('input[name="pdt_name"]').length == 0) {
			alert("품목이 없습니다.");
			return false;
		}

		 $('input[name="asqty"]').each(function (idx, item) {
			 asqty = $(item).val();
	        	if (isEmpty(asqty)){
	        		alert("수량을 입력해주세요");
	        		$(item).focus();
	        		status = false;
	        	}
	       	});
		 if (status == false) return;

             

        var materialList =[];
        
		for (var i = 0; i < $("input[name='pdt_name']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;
			tmpMap.pdt_cd = $($("input[name='pdt_cd']")[i]).val();
			tmpMap.pdt_code = $($("input[name='pdt_code']")[i]).val();
			tmpMap.pdt_name = $($("input[name='pdt_name']")[i]).val();
			tmpMap.pdt_standard = $($("input[name='pdt_standard']")[i]).val();
			tmpMap.asqty = $($("input[name='asqty']")[i]).val().replace(/,/g, "");
			tmpMap.bigo = $($("input[name='bigo']")[i]).val();			
			
			if ( isEmpty($($("input[name='asqty']")).val()) ){
				tmpMap.asqty = 0;
			}else{
				tmpMap.asqty = $($("input[name='asqty']")[i]).val().replace(/,/g, "");
			}
			
			materialList.push(tmpMap)
		}
	
		var info =[];
		var tmpMap2 = {};
		tmpMap2.reason = $($("input[name='reason']")).val();
		tmpMap2.manager_seq = $($("input[name='manager_seq']")).val();
		tmpMap2.div_work = $($('#div_work option:selected')).val();	
		tmpMap2.title = $($("input[name='title']")).val();	
		tmpMap2.cost = $($("input[name='cost']")).val().replace(/,/g, "");
		tmpMap2.start_date = start_date;
		tmpMap2.end_date = end_date;
		tmpMap2.as_status = $('#as_status option:selected').val();
		if ( isEmpty($($("input[name='cust_seq']")).val()) ){
			tmpMap2.cust_seq = 0;
		}else{
			tmpMap2.cust_seq = $($("input[name='cust_seq']")).val(); 
		}
		if (mode == "view"){
			tmpMap2.as_code = $($("input[name='as_code']")).val();
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
                asplanInfoLayer_Close();
                location.reload();
             } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
             }
        });

	}
	
	
</script>

					<h3 class="mjtit_top">
						CS(A/S)관리
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/as/as">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
                  		                    <div class="srch_day">
                    	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate">A/S일자</label>
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
                    		<select name="status" class="sel_02">
								<option value="ALL" <c:if test="${search.status eq 'ALL'}">selected</c:if>>전체</option>
								<c:forEach items="${asStatus}" var="result">
									<option value="${result.code}" <c:if test="${search.status eq result.code}">selected</c:if>>${result.code_nm}</option>
								</c:forEach>
                            </select>



                    	</div>
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="AS_CODE" <c:if test="${search.search_type == 'AS_CODE'}">selected</c:if>>코드</option>
	                            <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목명</option>                           
	                            <option value="CUST_NAME" <c:if test="${search.search_type == 'CUST_NAME'}">selected</c:if>>거래처명</option>                           
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
                    			<col style="width: 130px;"/>
                    			<col style="width: 200px;"/>
                    			<col style="width: 150px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 110px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>AS코드</th>
                    				<th>제품명</th>		
                    				<th>거래처명</th>
                    				<th>작성일</th>
                    				<th>구분</th>
                    				<th>상태</th>
                    				<th>관리</th> 
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="planDetail('${list.as_code}')">${list.as_code}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="planDetail('${list.as_code}')">${list.pdt_name}</a>
		                    				<a href="#" onclick="planDetail('${list.as_code}')" class="m_link">${list.pdt_name}</a>
	                    				</td>
	                    				<td class="name">${list.cust_name}</td>
	       								<td class="day">${list.regDate}</td>
										<td class="ing">
											<c:forEach items="${asGubunStatus}" var="result">
												<c:if test="${result.code eq list.div_work}">${result.code_nm}</c:if>
											</c:forEach>
										</td>
										<td class="ing">
											<c:forEach items="${asStatus}" var="result">
												<c:if test="${result.code eq list.as_status}">${result.code_nm}</c:if>
											</c:forEach>
										</td>
	                    				<td class="num"><button type="button" class="btn_03 btn_s" onclick="deletePlan('${list.as_code}');">삭제</button></td>
	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="9">A/S 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="asplanInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="asplanInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="asplanInfo_Form" name="asplanInfo_Form">
						<input type="hidden" name="productCount" id="productCount"  value="1"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="manager_seq" id="manager_seq"/>
						<input type="hidden" id="cust_seq" name="cust_seq">
						<h3>CS(A/S) 등록/조회<a class="back_btn" href="#" onclick="asplanInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
										<th scope="row">A/S코드</th>
										<td><input type="text" id="as_code" name="as_code" readonly="readonly"/></td>	
																		
										<th scope="row">작업구분</th>
										<td colspan="1">
											<div class="sel_wrap" >
												<select class="sel_02" id="div_work" name="div_work">
													<c:forEach items="${asGubunStatus}" var="result">
														<option value="${result.code}">${result.code_nm}</option>
													</c:forEach>
												</select>
											</div>
										</td>		
									</tr>
									
									<tr>

									<th scope="row">제목 <span class="keyf01">*</span></th>
									<td><input type="text" id="title" name="title" class="all" maxlength="100" placeholder="제목"/></td>


									<th scope="row">비용</th>
									<td><input type="text" id="cost" name="cost" onkeyup="this.value=this.value.replace(/[^0-9]/g,''); this.value=comma(this.value);" maxlength="12" placeholder="비용"/></td>
								    </tr>
									
									<tr>
										<th scope="row">거래처  <span class="keyf01">*</span></th>
										<td><input type="text" id="cust_name" name="cust_name" class="all" onclick="openLayer();" readonly placeholder="거래처"/></td>
																	
										<th scope="row">담당자  <span class="keyf01">*</span></th>
										<td>
											<input type="text" style="margin-bottom : 5px;" id="auth_group_name" name="auth_group_name" onclick="managerSearch_open();" readonly  placeholder="담당부서"/>
											<input type="text" id="manager_name" name="manager_name" onclick="managerSearch_open();" readonly placeholder="담당자"/>
										</td>															
									</tr>

									<tr>
										<th scope="row">작성일자</th>
										<td><div class="day_input"><input type="text" id="reg_date" name="reg_date" readonly="readonly"/></div></td>

										<th scope="row">진행현황</th>
										<td colspan="1">
											<div id="status" class="sel_wrap" >
												<select class="sel_02" id="as_status" name="as_status">
													<c:forEach items="${asStatus}" var="result">
														<option value="${result.code}">${result.code_nm}</option>
													</c:forEach>
												</select>
											</div>
										</td>
									</tr>
					
									<tr>									
										<th scope="row">A/S시작일</th>
										<td>
											<div class="day_input"><input type="text" id="start_date" name="start_date" onchange="dateCheck(this);" readonly/></div>
										</td>		
										<th scope="row">A/S완료일</th>
										<td>
											<div class="day_input"><input type="text" id="end_date" name="end_date" onchange="dateCheck(this);" readonly/></div>
										</td>	
									</tr>
									<tr>
										<th scope="row">A/S사유</th>										
										<td colspan="1"><input type="text" id="reason" name="reason" class="all" maxlength="100" placeholder="사유"/></td>
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
										<col style="width: 300px;"/>
										<col style="width: 250px;"/>
										<col style="width: 100px;"/>
										<col style="width: 150px;"/>
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>품목코드</th>
											<th>품목명</th>
											<th>규격</th>
											<th>수량</th>
											<th>적요</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="asplanInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="asplanInfoLayer_Close();"><span>닫기</span></a>
				</div>
				<div id="popup" class="layer_pop">	
					<div class="handle_wrap">
						<div class="handle"><span>거래처 리스트</span></div>
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
		if (sessionCheck()) {
			var url = "/supply/popSupplyList";
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
		if (sessionCheck()) {
			var url = "/order/popProductList?type=as";
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
	
	function PopProductAdd(data){

		var pdt = data.storeData;
		console.log(data);
		var num = Number($('#productCount').val());
		num += 1;
		var text ="";

		text += "<tr id='product_"+num+"'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'>";
		text += "<input type='hidden' id='pdt_cd_"+num+"' name='pdt_cd' value='"+pdt.PDT_CD+"' >";
		text += "<input type='text' id='pdt_code_"+num+"' name='pdt_code' value='"+pdt.PDT_CODE+"' placeholder=\"품목코드\"></td>";
		text += "<td class='prod'><input type='text' id='pdt_name_"+num+"' name='pdt_name' value='"+pdt.PDT_NAME+"' placeholder=\"품목\"></td>";
		text += "<td class='prod'><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' value='"+pdt.PDT_STANDARD+"' placeholder=\"규격\"></td>";
    	text += "<td class='qty'><input type='text' id='asqty_"+num+"' name='asqty' value='' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"수량\"></td>";
		text += "<td class='name'><input type='text' id='bigo_"+num+"' name='bigo' value='' placeholder=\"적요\"></td>";
		text += "</tr>";


		$('#searchResult').append(text);
		
		$('#productCount').val(num);
	
		
	}
	

	function managerSearch_open(){		
		if (sessionCheck()){
			var url = "/as/popManagerList";
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

	
	
	function deletePlan(as_code){
		
		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/as/delete',
	            async : false,
	            data: "as_code="+as_code,
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

	function choiceCust(cust_seq, no, cust_name){
		$('#cust_seq').val(cust_seq);
		$('#cust_name').val(cust_name);
	}
</script>