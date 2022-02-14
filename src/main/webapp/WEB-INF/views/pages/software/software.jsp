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
	
	function swDetail(sw_no){
		softwareInfoLayer_Open(sw_no, "view");
	}
	function newRegister(type){
		softwareInfoLayer_Open("", type)
	}

	
	
	function productAdd(){
		var num = Number($('#softwareCount').val());
		num += 1;
		var text ="";

		
		text += "<tr id='sw_"+num+"'>";
 		text += "<td class='num pctnum'><a href='#' onclick='swDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
 		text += "<td class='recodedate'><div class='day_input'><input type='text' id='recodedate_"+num+"' name='recodedate' readonly></td>";
 		text += "<td class='prod'>";
 		text += "<div class=\"dan\">";
 		text += "<span><input type='text' id='purpose_use_"+num+"' name='purpose_use' placeholder=\"사용목적\" maxlength='100' ></span>";
 		text += "</div>";
 		text += "</td>";
 		text += "<td class='name'><input type='text' id='use_department_"+num+"' name='use_department' placeholder=\"부서\" maxlength='45'></td>";
 		text += "<td class='name'><input type='text' id='mg_name_"+num+"' name='mg_name' placeholder=\"담당자\" maxlength='45'></td>";
 		text += "<td class='name'><input type='text' id='bigo_"+num+"' name='bigo' placeholder=\"비고\" maxlength='100'></td>";
 		text += "</tr>";
		
 

		$('#searchResult').append(text);
		$('#recodedate_'+num).datepicker();
		$('#recodedate_'+num).datepicker('setDate', '0');
		$('#softwareCount').val(num);
	}
	function swDelete(rowNum){

		$("#sw_"+rowNum).remove();

	}
	 

	
	
	function softwareInfoLayer_Open(sw_no, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');
			$('statusZone').css('display', '');
			$('#actionButton').html("수정");
			$.ajax({
	            type : "get",
	            url : '/software/view',
	            async : false,
	            data: "sw_no="+sw_no,
	            success : function(data) {
	            	var array = data.storeData;
	            	console.log(data);
	            	$('#sw_no').val(array[0].sw_no);
					$('#sw_name').val(array[0].sw_name);
					$('#message').val(array[0].message);								
					$('#sw_code').val(array[0].sw_code);
					$('#manager_phonenumber').val(array[0].manager_phonenumber);

					$('#manager_name').val(array[0].manager_name + " " +array[0].manager_position);
					$('#manager_seq').val(array[0].manager_seq);
					$('#auth_group_name').val(array[0].auth_group_name);

					var reg_date = array[0].reg_date;
					var start_date = array[0].startDate;
					var end_date = array[0].endDate;

					$('#reg_date').val(reg_date);

		       		$("#start_date").datepicker();
		       		$('#start_date').val(start_date);
		       		$("#end_date").datepicker();
		       		$('#end_date').val(end_date);

					$('#use_yn').val(array[0].use_yn);

		       		if (array.length > 0){
		       			for (var i in array){
                   			
		       				sw_no = array[i].sw_no;
	                		no = array[i].no;
	                		recodedate = array[i].recodedate;
	                		purpose_use = array[i].purpose_use;
	                		use_department = array[i].use_department;
	                		mg_name = array[i].mg_name;
	                		bigo = array[i].bigo;
	                		
	                		text += "<tr id='sw_"+i+"'>";
	                 		text += "<td class='num pctnum'><a href='#' onclick='swDelete(\""+i+"\")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
	                 		text += "<td class='day'><div class='day_input'><input type='text'  id='recodedate_"+i+"' name='recodedate' value='" +recodedate+"' readonly></td>";
	                 		text += "<td class='prod'>";
	                 		text += "<div class=\"dan\">";
	                 		text += "<span><input type='text' id='purpose_use_"+i+"' name='purpose_use' value='"+purpose_use+"' placeholder=\"사용목적\"></span>";
	                 		text += "</div>";
	                 		text += "</td>";
	                 		text += "<td class='name'><input type='text' id='use_department_"+i+"' value='"+use_department+"' name='use_department' placeholder=\"부서\"></td>";
	                 		text += "<td class='name'><input type='text' id='mg_name_"+i+"' value='"+mg_name+"' name='mg_name' placeholder=\"담당자\"></td>";
	                 		text += "<td class='name'><input type='text' id='bigo_"+i+"' value='"+bigo+"' name='bigo' placeholder=\"비고\" ></td>";
	                 		text += "</tr>";
	                	}
		       		}else{
	            		text += "<tr class='all'><td colspan='8'>기록정보가 없습니다.</td></tr>";
	            	}

					$('#searchResult').html(text);
					for (var i in array){
						$('#recodedate_'+i).datepicker();
						$('#recodedate_'+i).datepicker('setDate', array[i].recodedate);
					}
	            }
	         }); 
		}else{ //신규작성일때
			$('statusZone').css('display', 'none');
    		$('#mode').val('register');
       		$('#button_1').css('display','inline-block');
       		$('#button_2').css('display','inline-block');

    		$('#actionButton').text('등록');
         	$('#searchResult').empty();
			$('#softwareInfo_Form').resetForm();
			
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
         	$("#end_date").datepicker('setDate', '+365');

            text += "<tr id='sw_1' >";
    		text += "<td class='num pctnum'><a href='#' onclick='swDelete(1)'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
			text += "<td class='day'><div class='day_input'><input type='text'  id='recodedate_1' name='recodedate' value='' readonly></td>";
    		text += "<td class='prod'>";
    		text += "<div class=\"dan\">";
    		text += "<span><input type='text' id='purpose_use_1' name='purpose_use' placeholder=\"사용목적\"></span>";
    		text += "</div>";
    		text += "</td>";
    		text += "<td class='name'><input type='text' id='use_department_1' name='use_department' placeholder=\"부서\"></td>";
    		text += "<td class='name'><input type='text' id='mg_name_1' name='mg_name' placeholder=\"담당자\"></td>";
    		text += "<td class='name'><input type='text' id='bigo_1' name='bigo' placeholder=\"비고\" ></td>";
    		text += "</tr>";

    		$('#searchResult').html(text);
			$('#recodedate_1').datepicker();
			$('#recodedate_1').datepicker('setDate', "0");

		}

		$('#softwareInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	

	
	function softwareInfoLayer_Close(){
		$('#softwareInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}
	
	function GoActionButton(){
		var targetUrl = ""
		var status = true;
		var msg = ""
		var mode = $('#mode').val();
		if (mode == 'register') {
			targetUrl = "/software/registerSoftware";
			msg = "소프트웨어가 등록되었습니다."
		} else if (mode == 'view'){
			targetUrl = "/software/editSoftware";
			msg = "소프트웨어가 수정되었습니다."
		}

		var start_date = $('#start_date').val();
		var end_date = $('#end_date').val();

		var startDay = new Date(start_date);
		var endDay = new Date(end_date);


		if (startDay > endDay){
			alert("시작일 보다 종료일이 더 큽니다.");
			return false;
		}

		if(isEmpty($('#sw_code').val())){
			alert("제품번호를 입력해주세요.");
			$('#sw_code').focus();
			return false;
		}
		if(isEmpty($('#sw_name').val())){
			alert("명칭을 입력해주세요.");
			$('#sw_name').focus();
			return false;
		}
		if(isEmpty($('#manager_seq').val())){
			alert("담당자를 선택해주세요.");
			$('#auth_group_name').focus();
			return false;
		}

		if ($('input[name="recodedate"]').length == 0) {
			alert("기록이 없습니다.");
			return false;
		}


		$('input[name="recodedate"]').each(function (idx, item) {
			recodedate = $(item).val();
        	if (isEmpty(recodedate)){
        		alert("기록일자를 입력해주세요.");
        		status = false;
        	}
       	});
       	if (status == false) return;
		$('input[name="mg_name"]').each(function (idx, item) {
			mg_name = $(item).val();
			if (isEmpty(mg_name)){
				alert("확인자를 입력해주세요.");
				status = false;
			}
		});
		if (status == false) return;


		var materialList =[];
        
		for (var i = 0; i < $("input[name='purpose_use']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;		
			tmpMap.sw_no = $($("input[name='sw_no']")[i]).val();
			tmpMap.purpose_use = $($("input[name='purpose_use']")[i]).val();
			tmpMap.recodedate = $($("input[name='recodedate']")[i]).val();
			tmpMap.use_department = $($("input[name='use_department']")[i]).val();
			tmpMap.mg_name = $($("input[name='mg_name']")[i]).val();
			tmpMap.bigo = $($("input[name='bigo']")[i]).val();			

			materialList.push(tmpMap)
		}
	
		var info =[];
		var tmpMap2 = {};
		tmpMap2.sw_no = $($("input[name='sw_no']")).val();
		tmpMap2.sw_code = $($("input[name='sw_code']")).val();
		tmpMap2.sw_name = $($("input[name='sw_name']")).val();
		tmpMap2.manager_seq = $($("input[name='manager_seq']")).val();
		tmpMap2.manager_phonenumber = $($("input[name='manager_phonenumber']")).val();
		tmpMap2.message = $($("input[name='message']")).val();	
		tmpMap2.start_date = start_date;
		tmpMap2.end_date = end_date;
		tmpMap2.use_yn = $($("select[name='use_yn']")).val();
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
                softwareInfoLayer_Close();
                location.reload();
             } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
             }
        });

	}
	
	
</script>

					<h3 class="mjtit_top">
						소프트웨어목록 관리 
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/software/software">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/><div class="srch_day">
                    	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate">취득일자</label>
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
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="SW_CODE" <c:if test="${search.search_type == 'SW_CODE'}">selected</c:if>>제품번호</option>
	                            <option value="SW_NAME" <c:if test="${search.search_type == 'SW_NAME'}">selected</c:if>>명칭</option>                           
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
                    			<col style="width: 65px;"/>
                    			<col style="width: 285px;"/>
                    			<col style="width: 300px;"/>
                    			<col style="width: 115px;"/>
                    			<col style="width: 115px;"/>
								<col style="width: 115px;"/>
                    			<col style="width: 115px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>제품번호</th>
                    				<th>명칭</th>
                    				<th>담당자</th>
                    				<th>취득일</th>
									<th>만료일</th>
                    				<th>관리</th>  
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="swDetail('${list.sw_no}'); return;">${list.sw_code}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="swDetail('${list.sw_no}'); return;">${list.sw_name}</a>
		                    				<a href="#" onclick="swDetail('${list.sw_no}'); return;" class="m_link">${list.sw_name}</a>
	                    				</td>
	       								<td class="sang t_left">${list.managerName}</td>
	       								<td class="day">${list.startDate}</td>
										<td class="day">${list.endDate}</td>
	                    				<td class="num"><button type="button" class="btn_03 btn_s" onclick="deletePlan('${list.sw_no}');">삭제</button></td>
	                    			</tr>
                    			</c:forEach>

								<c:if test="${empty list }">
									<tr><td colspan="6">소프트웨어 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="softwareInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="softwareInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="softwareInfo_Form" name="softwareInfo_Form">
						<input type="hidden" name="softwareCount" id="softwareCount"  value="1"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="manager_seq" id="manager_seq"/>
						<input type="hidden" name="sw_no" id="sw_no"/>
						<h3>소프트웨어목록 등록/조회<a class="back_btn" href="#" onclick="softwareInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
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
										<th scope="row">제품번호 <span class="keyf01">*</span></th>
										<td><input type="text" id="sw_code" class="all" name="sw_code" maxlength="45" placeholder="제품번호"/></td>

										<th scope="row">작성일자</th>
										<td>
											<input type="text" id="reg_date" name="reg_date" readonly="readonly"/>
										</td>
									</tr>
									
									<tr>
										<th scope="row">명칭 <span class="keyf01">*</span></th>
										<td><input type="text" id="sw_name" name="sw_name" class="all" maxlength="100" placeholder="명칭"/></td>
										<th scope="row">사용여부 <span class="keyf01">*</span></th>
										<td>
											<div class="sel_wrap">
												<select id="use_yn" name="use_yn" class="sel_02">
													<option value="Y">사용</option>
													<option value="N">미사용</option>
												</select>
											</div>
										</td>
										
									</tr>
									<tr>

										<th scope="row">담당자 <span class="keyf01">*</span></th>
										<td>
											<div><input type="text" id="auth_group_name" name="auth_group_name" onclick="managerSearch_open();" placeholder="담당자" readonly/></div>
											<div class="dan"><input type="text" id="manager_name" name="manager_name" onclick="managerSearch_open();" placeholder="담당자" readonly /></div>
											
										</td>	
										
										<th scope="row">연락처</th>
										<td>
											<input type="text" id="manager_phonenumber" name="manager_phonenumber" maxlength="20" placeholder="연락처"/>
										</td>															
									</tr>

									<tr>									
										<th scope="row">취득일 <span class="keyf01">*</span></th>
										<td>
											<div class="day_input"><input type="text" id="start_date" name="start_date" onchange="dateCheck(this);" readonly/></div>
										</td>		
										<th scope="row">만료일 <span class="keyf01">*</span></th>
										<td>
											<div class="day_input"><input type="text" id="end_date" name="end_date" onchange="dateCheck(this);" readonly/></div>
										</td>	
									</tr>
	
									<tr>
										<th scope="row">비고</th>										
										<td colspan=""><input type="text" id="message" name="message" class="all"/></td>
									</tr>
								</tbody>
							</table>
						</div>
						
						<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_1" type="button" class="btn_02" onclick="productAdd();">기록추가</button>
								<!-- <button id="button_2" type="button" class="btn_02" onclick="productSearch();">불러오기</button> -->
							</div>
							<div class="scroll">
								<table class="master_01 master_05">	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 110px;"/>
										<col style="width: 340px;"/>
										<col style="width: 180px;"/>
										<col style="width: 180px;"/>
										<col style="width: 200px;"/>
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>기록일자</th>	
											<th>사용목적</th>
											<th>사용부서</th>										
											<th>확인자</th>		
											<th>비고</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="softwareInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="softwareInfoLayer_Close();"><span>닫기</span></a>
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
	

	function managerSearch_open(){		
		if (sessionCheck()){
			var url = "/software/popManagerList";
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

	
	
	function deletePlan(sw_no){
		
		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/software/delete',
	            async : false,
	            data: "sw_no="+sw_no,
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

		/* if (today > selectDate){
			alert("현재날짜보다 이전날짜는 선택할 수 없습니다.")
			$('#'+id).datepicker('setDate', '+0');
		} */
		
	}
</script>