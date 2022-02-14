<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

	$("#supply_line_1").change(function() {
		var line_seq = $("#supply_line_1 option:selected").val();
		var nowDepth = $("#supply_line_1 option:selected").data("depth");
		var line_name = $("#supply_line_1 option:selected").data("name");
		if(line_seq == undefined){
			$("#SUPPLY_LINE_WRAP").hide();
		}else {
			viewDepth(line_seq, nowDepth, line_name);
		}
	});
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


	function viewDepth(line_seq, nowDepth, line_name){
		//메뉴명 클릭시 하위 카테고리 내용 불러오는 함수
		var buttonText = "";
		$.ajax({
			type : "get",
			url : '/productionLine/viewDepth',
			async : false,
			data: "line_seq="+line_seq,
			success : function(data) {
				var array = data.storeData;
				var text ="";
				if (array.length < 1){
					$("#SUPPLY_LINE_WRAP").show();
					text = "<option>없음</option>";
					$("#supply_line_2").html(text);
				}else{
					$("#SUPPLY_LINE_WRAP").show();
					text = "<option>선택</option>";
					for (var i in array){
						text += '<option value="'+array[i].line_seq+'" data-depth="'+array[i].depth+'" data-name="'+array[i].line_name+'">'+array[i].line_name+'</option>';
					}
					$("#supply_line_2").html(text);
				}
			}
		});
	}

	function productDelete(rowNum){

		$("#product_"+rowNum).remove();

	}

	function workplanInfoLayer_Open(plan_code, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');
			$('#actionButton').html("수정");
			$.ajax({
	            type : "get",
	            url : '/workplan/view',
	            async : false,
	            data: "plan_code="+plan_code,
	            success : function(data) {
	            	var array = data.storeData;

					$('#message').val(array[0].message);								
					$('#plan_code').val(array[0].plan_code);
					$('#auth_group_name').val(array[0].groupName);
					$('#manager_name').val(array[0].managerName + " " +array[0].manager_position);
					$('#manager_seq').val(array[0].manager_seq);

					var start_date = array[0].startDate;
					var end_date = array[0].endDate;
				   
					if(array[0].work_type == 'A'){
				       $("#work_type1").prop("checked",true);
				    }else if(array[0].work_type == 'B'){
				       $("#work_type2").prop("checked",true);
				    }
		       		$("#start_date").datepicker();
		       		$('#start_date').val(start_date);

		       		$("#end_date").datepicker();
		       		$('#end_date').val(end_date);

					if (array[0].plan_status == 'WPS001'){
						$('#deleteButton').attr("onclick", "deletePlan('"+array[0].plan_code+"');");
						$('#deleteButton').css('display','');
						$('#actionButton').css('display','');
						$('#button_2').css('display','');
					}else{
						$('#deleteButton').removeAttr("onclick");
						$('#deleteButton').css('display','none');
						$('#actionButton').css('display','none');
						$('#button_2').css('display','none');

					}

					product_line_arr = array[0].product_line.split(",");
					$('#supply_line_1').val(product_line_arr[0]);
					viewDepth(product_line_arr[0], '', '');
					$('#SUPPLY_LINE_WRAP').show();
					$('#supply_line_2').val(product_line_arr[1]);

		       		if (array.length > 0){
		       			for (var i in array){
							pdt_cd = array[i].pdt_cd;
		       				pdt_code = array[i].pdt_code;
	                		no = array[i].no;
	                		pdt_name = array[i].pdt_name;
	                		pdt_standard = array[i].pdt_standard;
	                		factory_code = array[i].factory_code;
	                		unit = array[i].unit;
	                		planqty = array[i].planqty;
							realqty = array[i].realqty;
	                		produceQty = array[i].produceQty;
	                		bigo = array[i].bigo;
							serial_yn = array[i].serial_yn;
							package_yn = array[i].package_yn;

                            text += "<tr id='product_"+i+"'>";
                            text += "<td class='num pctnum'><a href='#' onclick='productDelete("+i+")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
	                		text += "<td class='code'>"
							text += "<input type='hidden' name='pdt_cd' id='pdt_cd_"+i+"' value='"+pdt_cd+"'/>";
							text += "<input type='text' name='pdt_code' id='pdt_code_"+i+"' value='"+pdt_code+"' readonly/></td>";
	                		text += "<td class='prod'><input type='text' id='pdt_name_"+i+"' name='pdt_name' placeholder=\"품목\" value='"+pdt_name+"' /></td>";
	                		text += "<td class='prod'><input type='text' id='pdt_standard_"+i+"' name='pdt_standard' placeholder=\"규격\" value='"+pdt_standard+"'/></td>";
	                		text += "<td class='name'><input type='text' name='unit' id='unit_"+i+"' value='"+unit+"'/></td>";
	                		text += "<td class='qty'><input type='text' name='planqty' id='planqty_"+i+"' value='"+comma(planqty)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12'/></td>";
							text += "<td class='qty'><input type='text' value='"+comma(realqty)+"' readonly /></td>";
							text += "<td class='manage'>"
							text += "<div class='chkbox chkbox1'><input type='hidden' id='serial_yn_"+i+"' name='serial_yn' value='"+serial_yn+"'>" ;
							text += "<input type='hidden' id='package_yn_"+i+"' name='package_yn' value='"+package_yn+"'>"
							text += "<label for='package_yn_chk_"+i+"'>";
							if (package_yn == 'Y'){
								text +="<input type='checkbox' id='package_yn_chk_"+i+"' name='package_yn_chk' checked='checked'>";
							}else{
								text +="<input type='checkbox' id='package_yn_chk_"+i+"' name='package_yn_chk'>";
							}
							text += "<span></span></label></div></td></tr>"
							text += "</tr>";
	                	}
		       		}else{
	            		text += "<tr class='all'><td colspan='9'>품목정보가 없습니다.</td></tr>";
	            	}

					$('#searchResult').html(text);
	              
	            }
	         }); 
		}else{ //신규작성일때
			$('#deleteButton').css('display','none');
			$('#deleteButton').removeAttr("onclick");
			$('#actionButton').css('display','');
    		$('#mode').val('register');
       		$('#button_1').css('display','');
       		$('#button_2').css('display','');
			$('#SUPPLY_LINE_WRAP').hide();
    		$('#actionButton').text('등록');
         	$('#searchResult').empty();
			$('#workplanInfo_Form').resetForm();

       		$("#start_date").datepicker();
         	$("#start_date").datepicker('setDate', '+0');
       		$("#end_date").datepicker();
         	$("#end_date").datepicker('setDate', '+0');

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
		var status = true;
		var msg = ""
		var mode = $('#mode').val();
		if (mode == 'register') {
			targetUrl = "/workplan/registerWorkPlan";
			msg = "작업지시서가 등록되었습니다.";
		} else if (mode == 'view'){
			targetUrl = "/workplan/editWorkPlan";
			msg = "작업지시서가 수정되었습니다.";
		}
		
		var start_date = $('#start_date').val();
		var end_date = $('#end_date').val();
		
		var startDay = new Date(start_date);
		var endDay = new Date(end_date);

		if($("#supply_line_1 option:selected").val() == "선택"){
			alert("생산공장을 선택해 주세요.");
			$("#supply_line_1").focus();
			return false;
		}
		if($("#supply_line_2 option:selected").val() == "선택"){
			alert("생산라인을 선택해 주세요.");
			$("#supply_line_2").focus();
			return false;
		}
		if($("#supply_line_2 option:selected").val() == "없음"){
			alert($("#supply_line_1 option:selected").data("name") + "에 등록된 라인이 없습니다.");
			return false;
		}

		if (startDay > endDay){
			alert("작업일자가 정확하지 않습니다.");
			return false;
		}

		if( isEmpty($('#auth_group_name').val()) || isEmpty($('#manager_name').val()) ){
			alert("담당자를 입력해주세요");
			return false;
		}

		if ($('input[name="pdt_name"]').length == 0) {
			alert("작업 품목이 없습니다.");
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
        


        var materialList =[];
        
		for (var i = 0; i < $("input[name='pdt_name']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;
			tmpMap.pdt_cd = $($("input[name='pdt_cd']")[i]).val();
			tmpMap.pdt_code = $($("input[name='pdt_code']")[i]).val();
			tmpMap.pdt_name = $($("input[name='pdt_name']")[i]).val();
			tmpMap.pdt_standard = $($("input[name='pdt_standard']")[i]).val();
			tmpMap.planqty = $($("input[name='planqty']")[i]).val().replace(/,/g, "");
			tmpMap.unit = $($("input[name='unit']")[i]).val();
			if ($($("input[name='package_yn_chk']")[i]).is(":checked")) {
				$($("input[name='package_yn']")[i]).val("Y");
			} else {
				$($("input[name='package_yn']")[i]).val("N");
			}
			tmpMap.serial_yn = $($("input[name='serial_yn']")[i]).val();
			tmpMap.package_yn = $($("input[name='package_yn']")[i]).val();
			materialList.push(tmpMap)
		}
	
		var info =[];
		var tmpMap2 = {};
		tmpMap2.manager_seq = $($("input[name='manager_seq']")).val();
		tmpMap2.bigo = $($("input[name='bigo']")).val();
		tmpMap2.start_date = start_date;
		tmpMap2.end_date = end_date;
		tmpMap2.work_type = $('input[name="work_type"]:checked').val();
		tmpMap2.product_line = 	$("#supply_line_1 option:selected").val() + "," + $("#supply_line_2 option:selected").val();

		if (mode == "view"){

			tmpMap2.plan_code = $($("input[name='plan_code']")).val();
		}
		info.push(tmpMap2);
		
		sendData = {};	
	    sendData.materialList = materialList;
	    sendData.info = info;
		if (mode == "view"){
			if(confirm("수정하시면 기존 시리얼 데이터는 사라집니다\n그래도 진행하시겠습니까?")){
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
		}else{
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


	}


</script>

					<h3 class="mjtit_top">
						작업지시서 조회
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/workplan/list">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
						<div class="srch_day">
							<div class="day_area">
								<div class="day_label">
								<label for="startDate">작업일자</label>
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
                    		<select name="search_line" class="sel_02">
                    			<option value="0" <c:if test="${search.search_line eq 0}">selected</c:if>>전체공장</option>
								<c:forEach items="${depth1}" var="depth1" varStatus="status">
									<option value="${depth1.line_seq}" <c:if test="${depth1.line_seq eq search.search_line }">selected</c:if>>${depth1.line_name}</option>
								</c:forEach>
                            </select>
                    	</div>
						<div class="sel_wrap sel_wrap1">
							<select name="search_status" class="sel_02">
								<option value="ALL">전체</option>
								<c:forEach items="${planStatus}" var="result">
									<option value="${result.code}" <c:if test="${result.code eq search.search_status}">selected</c:if>>${result.code_nm}</option>
								</c:forEach>
							</select>
						</div>
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="PLAN_CODE" <c:if test="${search.search_type == 'PLAN_CODE'}">selected</c:if>>작지서코드</option>
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
                    			<col style="width: 210px;"/>
                    			<col style="width: 200px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
								<col style="width: 200px;"/>

                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>작지서코드</th>
                    				<th>품목명</th>
                    				<th>생산라인</th>
                    				<th>생산담당자</th>
                    				<th>작업일자</th>
                    				<th>지시수량</th>
									<th>진행상태</th>
									<th>관리</th>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="planDetail('${list.plan_code}');">${list.plan_code}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="planDetail('${list.plan_code}');">${list.pdt_name}</a>
		                    				<a href="#" onclick="planDetail('${list.plan_code}');" class="m_link">${list.pdt_name}</a>
	                    				</td>
	                    				<td class="sang">${list.product_line}</td>
	       								<td class="name">${list.managerName} ${list.managerPosition} (${list.groupName})</td>
	       								<td class="day">${fn:substring(list.startDate, 0, 10)} ~ ${fn:substring(list.endDate, 0, 10)} </td>
	                    				<td class="number"><fmt:formatNumber value="${list.planQty}" pattern="#,###,###"/></td>
										<td class="ing">
											<c:forEach items="${planStatus}" var="result">
												<c:if test="${result.code eq list.plan_status}">${result.code_nm}</c:if>
											</c:forEach>
										</td>
										<td class="name">
											<button type="button" class="btn_02 btn_s" onclick="serialInfoLayer_Open('${list.plan_code}','${list.plan_status}');">시리얼</button>
											<c:if test="${list.plan_status eq 'WPS001' || list.plan_status eq 'WPS002'}">
												<button type="button" class="btn_03 btn_s" onclick="finishPlan('${list.plan_code}');">완료</button>
											</c:if>
										</td>
	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="10">작업지시서 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>

				<div class="master_pop master_pop01" id="serialInfoLayer">
					<div class="master_body">
						<div class="pop_bg" onclick="serialInfoLayer_Close();"></div>
						<div class="pop_wrap pop_wrap_01">
							<div class="pop_inner">
								<form id="serialInfo_Form" name="serialInfo_Form">
									<input type="hidden" id="serial_planCode" name="serial_planCode">
									<input type="hidden" id="serial_real_pdt_cd" name="serial_real_pdt_cd">
									<input type="hidden" id="serial_package_yn" name="serial_package_yn">
									<input type="hidden" id="plan_status" name="plan_status">

									<h3>시리얼 관리<a class="back_btn" href="#" onclick="serialInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
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
												<th scope="row">품목</th>
												<td colspan="3">
													<div class="sel_wrap" >
														<select class="sel_04" id="serial_pdt_cd" name="serial_pdt_cd" onchange="showSerial(this.value);">

														</select>
													</div>
												</td>
											</tr>
												<tr id="serial_zone1" style="display: none;">
													<th scope="row">지시수량</th>
													<td colspan="3">
														<input type="text" id="serial_plan_qty" name="serial_plan_qty" class="" placeholder="지시수량" maxlength="10" readonly>
													</td>

												</tr>
												<tr id="serial_zone2" style="display: none;">
													<th scope="row">파레트당 적재량</th>
													<td colspan="3">
														<input type="text" id="serial_pallet_qty" name="serial_pallet_qty" value="0" class="" placeholder="파레트당 적재량" maxlength="10" onkeyup='this.value=this.value.replace(/[^0-9]/g,"");'>
													</td>
												</tr>
												<tr id="serial_zone3" style="display: none;">
													<th scope="row">시리얼 시작번호</th>
													<td colspan="3">
														<input type="text"  id="serial_1" name="serial_1" casls="" placeholder="공통"  maxlength="100">
														<input type="text"  id="serial_2" name="serial_2" class="" placeholder="시작번호"  maxlength="10" onkeyup='this.value=this.value.replace(/[^0-9]/g,"");' onchange="convertSerial();">
														<div class="sel_wrap" >
														<select class="sel_01" id="serial_3" name="serial_3" onchange="convertSerial();">
															<option value="0" selected="selected">앞자리0갯수</option>
															<option value="1">1</option>
															<option value="2">2</option>
															<option value="3">3</option>
															<option value="4">4</option>
															<option value="5">5</option>
															<option value="6">6</option>
															<option value="7">7</option>
															<option value="8">8</option>
															<option value="9">9</option>
															<option value="10">10</option>
														</select>
														</div>
														<button type="button" class="btn_02 btn_s" onclick="serial_manage()">시리얼저장</button>
													</td>

												</tr>

											</tbody>
										</table>
									</div>
								</form>

									<div class="master_list master_listT">
										<div class="scroll">
											<table class="master_01 master_05">
												<colgroup>
													<col style="width: 55px;"/>
													<col style="width: 150px;"/>
													<col style="width: 200px;"/>
													<col style="width: 400px;"/>
												</colgroup>
												<thead>
												<tr>
													<th>NO</th>
													<th>품목코드</th>
													<th>품목명</th>
													<th>시리얼</th>
												</tr>
												</thead>
												<tbody id="searchResult2">
				
												</tbody>
											</table>
										</div>
									</div>
				
									<div class="pop_btn clearfix" >
										<a href="#" class="p_btn_01" onclick="serialInfoLayer_Close();">닫기</a>
									</div>
				
								</form>
							</div>
							<div class="group_close">
								<a href="#" class="getOrderView_close" onclick="serialInfoLayer_Close();"><span>닫기</span></a>
							</div>
				
						</div>
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
						<h3>작업지시서 등록/조회<a class="back_btn" href="#" onclick="workplanInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
										<th scope="row">작업지시서코드</th>
										<td><input type="text" id="plan_code" name="plan_code" readonly="readonly"/></td>									
										<th scope="row">작업분류</th>
										<td>										
											<div class="radiobox">
												<label for="work_type1">
													<input type="radio" id="work_type1" name="work_type"  value="A" checked="checked"/><span>정기생산</span>
												</label>
												<label for="work_type2">
													<input type="radio" id="work_type2" name="work_type"  value="B"/><span>발주생산</span>
												</label>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row">생산라인 <span class="keyf01">*</span></th>
										<td>
											<div class="sel_wrap" >
												<select class="sel_02" id="supply_line_1" name="supply_line_1">
													<option>선택</option>
													<c:forEach items="${depth1}" var="depth1" varStatus="status">
														<option value="${depth1.line_seq}" data-depth="${depth1.depth}" data-name="${depth1.line_name}">${depth1.line_name}</option>
													</c:forEach>
												</select>
											</div>
											<div class="sel_wrap" style="display: none" id="SUPPLY_LINE_WRAP">
												<select class="sel_02"  name="supply_line_2" id="supply_line_2">
													<option>선택</option>
												</select>
											</div>
										</td>
										<th scope="row">담당자 <span class="keyf01">*</span></th>
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
										<th scope="row">시작일자</th>
										<td>
											<div class="day_input"><input type="text" id="start_date" name="start_date" onchange="dateCheck(this);"/></div>
										</td>		
										<th scope="row">종료일자</th>
										<td>
											<div class="day_input"><input type="text" id="end_date" name="end_date" onchange="dateCheck(this);" /></div>
										</td>	
									</tr>


									<tr>	
										<th scope="row">비고</th>										
										<td colspan="3"><input type="text" id="bigo" name="bigo" class="all"/></td>
									</tr>
									
								</tbody>
							</table>
						</div>
						
						<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_2" type="button" class="btn_02" onclick="productSearch();">품목조회</button>
							</div>
							<div class="scroll">
								<table class="master_01 master_05">	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 300px;"/>
										<col style="width: 300px;"/>
										<col style="width: 220px;"/>
										<col style="width: 80px;"/>
										<col style="width: 100px;"/>
										<col style="width: 100px;"/>
										<col style="width: 100px;"/>
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>품목코드</th>
											<th>품목명</th>
											<th>규격</th>
											<th>단위</th>
											<th>지시수량</th>
											<th>생산수량</th>
											<th>시리얼 패키지</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="workplanInfoLayer_Close();">닫기</a>
							<a id="deleteButton" class="p_btn_03" href="#" >삭제</a>
							<a id="actionButton" class="p_btn_02" href="#" onclick="GoActionButton();" >수정</a>
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
			var url = "/supply/popSupplyList?type=workPlan";
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
		if (sessionCheck()) {
			var url = "/order/popProductList?type=workplan";
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
		var num = Number($('#productCount').val());

		num += 1;
		var text ="";

		text += "<tr id='product_"+num+"'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'>";
		text += "<input type='hidden' id='pdt_cd_"+num+"' name='pdt_cd' value='"+pdt.PDT_CD+"'>";
		text += "<input type='text' id='pdt_code_"+num+"' name='pdt_code' value='"+pdt.PDT_CODE+"' placeholder=\"품목코드\"></td>";
		text += "<td class='prod'><input type='text' id='pdt_name_"+num+"' name='pdt_name' value='"+pdt.PDT_NAME+"' placeholder=\"품목\"></td>";
		text += "<td class='prod'><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' value='"+pdt.PDT_STANDARD+"' placeholder=\"규격\"></td>";
		text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' value='"+pdt.UNIT+"' placeholder=\"단위\"></td>";
		text += "<td class='qty'><input type='text' id='planqty_"+num+"' name='planqty' value='' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"지시수량\"></td>";
		text += "<td class='qty'><input type='text' value='0' readonly></td>";
		text += "<td class='manage'>"
		text += "<div class='chkbox chkbox1'><input type='hidden' id='serial_yn_"+num+"' name='serial_yn' value='"+pdt.SERIAL_TYPE+"'>" ;
		text += "<input type='hidden' id='package_yn_"+num+"' name='package_yn' value=''>"
		text += "<label for='package_yn_chk_"+num+"'>";
		if (pdt.SERIAL_TYPE == 'Y'){
			text +="<input type='checkbox' id='package_yn_chk_"+num+"' name='package_yn_chk' checked='checked'>";
		}
		text += "<span></span></label></div></td></tr>"


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
	function finishPlan(plan_code){

		if(confirm("완료 하시겠습니까?")){
			$.ajax({
				type : "get",
				url : '/workplan/finish',
				async : false,
				data: "plan_code="+plan_code,
				success : function(data) {
					if(data.success){
						alert("완료하였습니다.");
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
	

	function serialInfoLayer_Open(plan_code, plan_status){
		var text = "";
		var packageTxt = "";
		$('#searchResult2').html('');
		$('#serial_zone1').css('display','none');
		$('#serial_zone2').css('display','none');
		$('#serial_zone3').css('display','none');
		$.ajax({
			type: "get",
			url: '/workplan/getSerialProductList',
			async: false,
			data: "plan_code=" + plan_code,
			success: function (data) {
				var array = data.storeData;
				if (array.length > 0) {
					text = '<option value="">선택</option>';
					for (var i in array) {
						if (array[i].package_yn == 'Y'){
							packageTxt = "[패키지]";
						}else{
							packageTxt = "";
						}

						text += '<option value="'+array[i].pdt_cd+'_'+array[i].plan_qty+'_'+array[i].package_yn+'">'+packageTxt+array[i].pdt_name+'</option>';

					}
				} else {
					text += "<tr class='all'><td colspan='8'>품목정보가 없습니다.</td></tr>";
				}
				$('#serial_pdt_cd').html(text);
				$('#serial_planCode').val(plan_code);
				$('#plan_status').val(plan_status);

			}

		});
		$('#serialInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	
	function serialInfoLayer_Close(){
		$('#serialInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
	}

	function showSerial(obj){
		var splitArr = obj.split('_');
		var pdt_cd = splitArr[0];
		var plan_qty = splitArr[1];
		var packageYN = splitArr[2];
		if (isEmpty(pdt_cd)){
			$('#serial_zone1').css('display','none');
			$('#serial_zone2').css('display','none');
			$('#serial_zone3').css('display','none');
			$('#searchResult2').html('');
			return false;
		}

		var plan_code = $('#serial_planCode').val();

		$('#serial_plan_qty').val(comma(plan_qty));
		$('#serial_package_yn').val(packageYN);
		$('#serial_pallet_qty').val("0");
		$('#serial_1').val("");
		$('#serial_2').val("");
		$('#serial_3').val("0");

		var text = "";
		var packageTxt ="";
		$.ajax({
			type: "get",
			url: '/workplan/getSerialList',
			async: false,
			data: "plan_code=" + plan_code +"&pdt_cd=" + pdt_cd + "&package_yn=" + packageYN,
			success: function (data) {
				var array = data.storeData;
				var num = 1;
				if (array.length > 0 ) {
					if (isEmpty(array[0].serial_seq)) {
						text += '<tr><td class="manage" colspan="6">시리얼이 없습니다.</td></tr>';
					} else {
						for (var i in array){
							text += '<tr>';
							text += '<td class="manage">'+num+'</td>';
							text += '<td class="manage">'+array[i].pdt_code+'</td>';
							text += '<td class="manage">'+array[i].pdt_name+'</td>';
							text += '<td class="manage">'+array[i].serial_from+' ~ '+array[i].serial_to+'</td>';
							text += '</tr>'
							num++;
						}
					}
				}
				$('#searchResult2').html(text);
				if($('#plan_status').val() == 'WPS001'){
					$('#serial_zone1').css('display','');
					if (packageYN == 'Y'){
						$('#serial_zone2').css('display','');
					}else{
						$('#serial_zone2').css('display','none');
					}

					$('#serial_zone3').css('display','');
				}else{
					$('#serial_zone1').css('display','none');
					$('#serial_zone2').css('display','none');
					$('#serial_zone3').css('display','none');
				}


			}

		});
		$('#serialInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}

	function serial_manage(){
		var targetUrl = "/workplan/manageSerial";
		if (isEmpty($('#serial_plan_qty').val())){
			alert("지시수량을 입력해주세요.");
			$('#serial_plan_qty').focus();
			return false;
		}
		if ($('#serial_package_yn').val()== "Y"){
			if ($('#serial_pallet_qty').val() == '0'){
				alert("파레트당 적재량을 입력해주세요.");
				$('#serial_pallet_qty').focus();
				return false;
			}
		}

		if (isEmpty($('#serial_1').val())){
			alert("시리얼 시작번호를 정확히 입력해주세요.");
			$('#serial_1').focus();
			return false;
		}
		if (isEmpty($('#serial_2').val())){
			alert("시리얼 시작번호를 정확히 입력해주세요.");
			$('#serial_2').focus();
			return false;
		}

		$('#serial_plan_qty').val($('#serial_plan_qty').val().replace(/,/g, ""));
		var pdt_cd = $('#serial_pdt_cd option:selected').val().split("_");
		$('#serial_real_pdt_cd').val(pdt_cd[0]);

		if(confirm("기존 시리얼 데이터는 사라집니다\n그래도 진행하시겠습니까?")){
			var param = $("#serialInfo_Form").serialize();
			$.ajax({
				type: "POST",
				url: targetUrl,
				async: false,
				data: param,
				success: function (data) {
					if (data.success){
						if (data.msg == "OK"){
							alert("저장하였습니다");
							showSerial($('#serial_pdt_cd option:selected').val())
						}else{
							alert(data.msg);
						}
					}else{
						alert("데이터오류로 실패하였습니다.");
					}
				}

			});
		}
	}

	function convertSerial(){
		let number = Number($('#serial_2').val());
		let digit = Number($('#serial_3').val());
		if (!isEmpty(number)){
			$('#serial_2').val(leadingZeros(number, digit));
		}
	}
	function leadingZeros(n, digits) {
		var zero = '';
		n = n.toString();
		for (var i = 1; i <= digits; i++){
				zero += '0';
		}
		return zero + n;
	}

	function pdtCheck(obj){
		var status = true
		var pdt_cd = "";
		$('input[name="pdt_cd"]').each(function (idx, item) {
			pdt_cd = $(item).val();
			if (pdt_cd == obj.PDT_CD){
				status = false;
			}
		});
		if (status == false) return "N";

	}

</script>