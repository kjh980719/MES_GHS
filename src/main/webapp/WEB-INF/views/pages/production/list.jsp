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
		$('#popup').css("max-width","850px");
		$('#popup').css("left","50%");
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

	function productionDetail(production_code){
		workplanInfoLayer_Open(production_code, "view");
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

	function workplanInfoLayer_Open(production_code, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');
			$('statusZone').css('display', '');
			$('#actionButton').html("수정");
			$.ajax({
				type : "get",
				url : '/production/view',
				async : false,
				data: "production_code="+production_code,
				success : function(data) {
					var array = data.storeData;

					$('#message').val(array[0].message);
					$('#production_code').val(array[0].production_code);
					$('#plan_code').val(array[0].plan_code);
					$('#auth_group_name').val(array[0].groupName);
					$('#manager_name').val(array[0].managerName + " " +array[0].manager_position);
					$('#manager_seq').val(array[0].manager_seq);

					var production_date = array[0].production_date;

					$("#production_date").datepicker();
					$('#production_date').val(production_date);
					$('#product_line').val(array[0].product_line);

					product_line_arr = array[0].product_line.split(",");
					$('#supply_line_1').val(product_line_arr[0]);
					viewDepth(product_line_arr[0], '', '');
					$('#SUPPLY_LINE_WRAP').show();
					$('#supply_line_2').val(product_line_arr[1]);
					$('#productCount').val(array.length);
					$('#planButton').css('display','none');
					if (array[0].plan_status == 'WPS003'){
						$('#actionButton').css('display','none');
					}
					if (array.length > 0){
						for (var i in array){
							pdt_cd = array[i].pdt_cd;
							pdt_code = array[i].pdt_code;
							no = array[i].no;
							pdt_name = array[i].pdt_name;
							serial_from = array[i].serial_from;
							serial_to = array[i].serial_to;
							planqty = array[i].planqty
							realqty = array[i].realqty;
							defectqty = array[i].defectqty;
							bad_reason = array[i].bad_reason;
							bigo = array[i].bigo;

							text += "<tr id='product_"+i+"'>";
							text += "<td class='code'>";
							text += "<input type='hidden' id='pdt_cd_"+i+"' name='pdt_cd' value='"+array[i].pdt_cd+"'>";
							text += "<input type='text' id='pdt_code_"+i+"' name='pdt_code' value='"+array[i].pdt_code+"' placeholder=\"품목코드\"></td>";
							text += "<td class='prod'><input type='text' id='pdt_name_"+i+"' name='pdt_name' value='"+array[i].pdt_name+"' placeholder=\"품목\"></td>";
							text += "<td class='qty'><input type='text' id='planqty_"+i+"' name='planqty' value='"+comma(array[i].planqty)+"' maxlength='12' placeholder=\"지시수량\" readonly></td>";
							text += "<td class='qty'><input type='text' id='realqty_"+i+"' name='realqty' value='"+comma(array[i].realqty)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"양품수량\" ></td>";
							text += "<td class='qty'><input type='text' id='defectqty_"+i+"' name='defectqty' value='"+comma(array[i].defectqty)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"불량수량\" ></td>";
							text += "<td class='name'><div class='sel_wrap sel_wrap1'>";
							text +=	"<select name='bad_reason' id='bad_reason_"+array[i].no+"' class='sel_02'>";
							text += "<option value=''>없음</option>";
							<c:forEach items="${defectReason}" var="result">
							if (array[i].bad_reason == '${result.code}'){
								text += "<option value='${result.code}' selected='selected'>${result.code_nm}</option>";
							}else{
								text += "<option value='${result.code}'>${result.code_nm}</option>";
							}

							</c:forEach>
							text += "</select></div></td>";
							text += "<td class='prod'><input type='text' id='bigo_"+array[i].no+"' name='bigo' value='"+array[i].bigo+"'></td>";
							text += "</tr>"
						}
					}else{
						text += "<tr class='all'><td colspan='8'>품목정보가 없습니다.</td></tr>";
					}

					$('#searchResult').html(text);

				}
			});
		}else{ //신규작성일때
			$('#planButton').css('display','');
			$('#actionButton').css('display','');
			$('#mode').val('register');
			$('#button_2').css('display','inline-block');
			$('#SUPPLY_LINE_WRAP').hide();
			$('#actionButton').text('등록');
			$('#searchResult').empty();
			$('#workplanInfo_Form').resetForm();

			$("#production_date").datepicker();
			$("#production_date").datepicker('setDate', '+0');

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
		var status = true;
		var msg = ""
		var mode = $('#mode').val();
		if (mode == 'register') {
			targetUrl = "/production/registerProduction";
			msg = "생산현황이 등록되었습니다."
		} else if (mode == 'view'){
			targetUrl = "/production/editProduction";
			msg = "생산현황이 수정되었습니다."
		}
		if(isEmpty($("#plan_code").val())){
			alert("작지서가 없습니다.");
			$("#plan_code").focus();
			return false;
		}

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

		$('input[name="realqty"]').each(function (idx, item) {
			var realqty = $(item).val();
			if (isEmpty(realqty)){
				alert("양품수량을 입력해주세요.");
				status = false;
			}else{
				var pqty = $($("input[name='planqty']")[idx]).val().replace(/,/g, "");
				if (pqty > realqty){
					if(!confirm("부분완료 처리하시겠습니까?")){
						status = false;
					}
				}
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
			tmpMap.bad_reason = $($("select[name='bad_reason']")[i]).val();
			tmpMap.bigo = $($("input[name='bigo']")[i]).val();
			planqty = $($("input[name='planqty']")[i]).val().replace(/,/g, "");
			if (isEmpty(planqty)){
				tmpMap.planqty = 0;
			}else{
				tmpMap.planqty = $($("input[name='planqty']")[i]).val().replace(/,/g, "");
			}

			realqty = $($("input[name='realqty']")[i]).val().replace(/,/g, "");
			if (isEmpty(realqty)){
				tmpMap.realqty = 0;
			}else{
				tmpMap.realqty = $($("input[name='realqty']")[i]).val().replace(/,/g, "");
			}

			defectqty = $($("input[name='defectqty']")[i]).val().replace(/,/g, "");
			if (isEmpty(defectqty)){
				tmpMap.defectqty = 0;
			}else{
				tmpMap.defectqty = $($("input[name='defectqty']")[i]).val().replace(/,/g, "");
			}

			materialList.push(tmpMap)
		}

		var info =[];
		var tmpMap2 = {};
		tmpMap2.manager_seq = $($("input[name='manager_seq']")).val();
		tmpMap2.production_date = $('#production_date').val();
		tmpMap2.product_line = $('#product_line').val();

		if (mode == "view"){
			tmpMap2.production_code = $($("input[name='production_code']")).val();
		}
		tmpMap2.plan_code = $($("input[name='plan_code']")).val();
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
	생산현황 조회
	<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>

<!--  관리자  검색시작-->
<div class="master_cont">

	<form id="searchForm" action="/production/list">
		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
		<div class="srch_day">
			<div class="day_area">
				<div class="day_label">
					<label for="startDate">생산일자</label>
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
					<option value="0" <c:if test="${search.search_line eq 0}">selected</c:if>>생산라인</option>
					<c:forEach items="${depth1}" var="depth1" varStatus="status">
						<option value="${depth1.line_seq}" <c:if test="${depth1.line_seq eq search.search_line }">selected</c:if>>${depth1.line_name}</option>
					</c:forEach>
				</select>
			</div>
			<div class="sel_wrap sel_wrap1">
				<select name="search_type" class="sel_02">
					<option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
					<option value="PRODUCTION_CODE" <c:if test="${search.search_type == 'PLAN_CODE'}">selected</c:if>>생산현황코드</option>
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
				<col style="width: 100px;"/>
				<col style="width: 100px;"/>
				<col style="width: 100px;"/>
			</colgroup>
			<thead>
			<tr>
				<th>No</th>
				<th>작지서코드</th>
				<th>품목명</th>
				<th>생산라인</th>
				<th>생산담당자</th>
				<th>생산일자</th>
				<th>양품수량</th>
				<th>불량수량</th>
				<th>관리</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${list}" var="list">
				<tr>
					<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
					<td class="code">
						<a href="#" onclick="productionDetail('${list.production_code}');">${list.plan_code}</a>
					</td>
					<td class="prod">
						<a href="#" onclick="productionDetail('${list.production_code}');">${list.pdt_name}</a>
						<a href="#" onclick="productionDetail('${list.production_code}');" class="m_link">${list.pdt_name}</a>
					</td>
					<td class="sang">${list.product_line}</td>
					<td class="name">${list.managerName} ${list.managerPosition} (${list.groupName})</td>
					<td class="day">${fn:substring(list.production_date, 0, 10)}</td>
					<td class="number"><fmt:formatNumber value="${list.realQty}" pattern="#,###,###"/></td>
					<td class="number"><fmt:formatNumber value="${list.defectQty}" pattern="#,###,###"/></td>
					<td class="manage">
						<c:if test="${list.plan_status ne 'WPS003'}">
							<button type="button" class="btn_03 btn_s" onclick="deleteProduction('${list.production_code}');">삭제</button>
						</c:if>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty list }">
				<tr><td colspan="9">생산현황 정보가 없습니다.</td></tr>
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
					<input type="hidden" name="productCount" id="productCount"  value="0"/>
					<input type="hidden" name="mode" id="mode"  value="regist"/>
					<input type="hidden" name="manager_seq" id="manager_seq"/>
					<input type="hidden" name="product_line" id="product_line"/>

					<h3>생산현황 등록/조회<a class="back_btn" href="#" onclick="workplanInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
								<th scope="row">생산현황코드</th>
								<td colspan="3"><input type="text" id="production_code" name="production_code" readonly="readonly"/>
							</tr>
							<tr>
								<th scope="row">작지서코드 <span class="keyf01">*</span></th>
								<td><input type="text" id="plan_code" name="plan_code" readonly="readonly"/>
								<button id="planButton" type="button" class="btn_02 btn_s" onclick="openLayer();" style="margin-left: 5px;">작지서 불러오기</button>
								</td>
								<th scope="row">생산일자 <span class="keyf01">*</span></th>
								<td>
									<div class="day_input"><input type="text" id="production_date" name="production_date"/></div>
								</td>
							</tr>

							<tr>
								<th scope="row">생산라인 <span class="keyf01">*</span></th>
								<td>
									<div class="sel_wrap" >
										<select class="sel_02" id="supply_line_1" name="supply_line_1" disabled>
											<option>선택</option>
											<c:forEach items="${depth1}" var="depth1" varStatus="status">
												<option value="${depth1.line_seq}" data-depth="${depth1.depth}" data-name="${depth1.line_name}">${depth1.line_name}</option>
											</c:forEach>
										</select>
									</div>
									<div class="sel_wrap" style="display: none" id="SUPPLY_LINE_WRAP" >
										<select class="sel_02"  name="supply_line_2" id="supply_line_2" disabled>
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

							</tbody>
						</table>
					</div>

					<div class="master_list master_listT">
						<div class="add_btn">
						</div>
						<div class="scroll">
							<table class="master_01 master_05">
								<colgroup>
									<col style="width: 200px;"/>
									<col style="width: 250px;"/>
									<col style="width: 100px;"/>
									<col style="width: 100px;"/>
									<col style="width: 100px;"/>
									<col style="width: 100px;"/>
									<col style="width: 250px;"/>
								</colgroup>
								<thead>
								<tr>
									<th>품목코드</th>
									<th>품목명</th>
									<th>지시수량</th>
									<th>양품수량</th>
									<th>불량수량</th>
									<th>불량사유</th>
									<th>비고</th>
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
					<div class="handle"><span>작업지시서 리스트</span></div>
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
			var url = "/workplan/popWorkPlanList";
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
	function PopWorkPlanAdd(data){

		var array = data.storeData;
		var product_line_arr = "";
		$('#plan_code').val(array[0].plan_code);

		$('#auth_group_name').val(array[0].groupName);
		$('#manager_name').val(array[0].managerName + " " +array[0].manager_position);
		$('#manager_seq').val(array[0].manager_seq);
		$('#production_date').val(array[0].startDate);
		$('#product_line').val(array[0].product_line);

		product_line_arr = array[0].product_line.split(",");
		$('#supply_line_1').val(product_line_arr[0]);
		viewDepth(product_line_arr[0], '', '');
		$('#SUPPLY_LINE_WRAP').show();
		$('#supply_line_2').val(product_line_arr[1]);

		$('#productCount').val(array.length);

		var num = 0;
		var text ="";
		var planqty = "";
		for (var i in array){
			if (Number(array[i].planqty) > Number(array[i].realqty)){
				planqty = (Number(array[i].planqty) - Number(array[i].realqty));
				num += 1;
				text += "<tr id='product_"+num+"'>";
				text += "<td class='code'>";
				text += "<input type='hidden' id='pdt_cd_"+num+"' name='pdt_cd' value='"+array[i].pdt_cd+"'>";
				text += "<input type='text' id='pdt_code_"+num+"' name='pdt_code' value='"+array[i].pdt_code+"' placeholder=\"품목코드\"></td>";
				text += "<td class='prod'><input type='text' id='pdt_name_"+num+"' name='pdt_name' value='"+array[i].pdt_name+"' placeholder=\"품목\"></td>";
				text += "<td class='qty'><input type='text' id='planqty_"+num+"' name='planqty' value='"+comma(planqty)+"' maxlength='12' placeholder=\"지시수량\" readonly></td>";
				text += "<td class='qty'><input type='text' id='realqty_"+num+"' name='realqty' value='"+comma(planqty)+"' onkeyup='qtyCheck(this); this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"양품수량\" ></td>";
				text += "<td class='qty'><input type='text' id='defectqty_"+num+"' name='defectqty' value='0' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);' maxlength='12' placeholder=\"불량수량\" ></td>";
				text += "<td class='name'><div class='sel_wrap sel_wrap1'>";
				text +=	"<select name='bad_reason' id='bad_reason_"+num+"' class='sel_02'>";
				text += "<option value=''>없음</option>";
				<c:forEach items="${defectReason}" var="result">
				text += "<option value='${result.code}'>${result.code_nm}</option>";
				</c:forEach>
				text += "</select></div></td>";
				text += "<td class='prod'><input type='text' id='bigo_"+num+"' name='bigo' placeholder='비고'></td>";
				text += "</tr>";
			}

		}


		$('#searchResult').html(text);


		$('#productCount').val(num);


	}



	function managerSearch_open(){
		if (sessionCheck()){
			var url = "/workplan/popManagerList";
			$('#manager_popup').css('display','block');
			$('#manager_popupframe').attr('src',url);
			$('html,body').css('overflow','hidden');
		}else{
			location.reload();
		}

	}

	function managerSearch_close(){
		$('#manager_popup').css('display','none');
		$('#manager_popupframe').removeAttr('src');
		$('html,body').css('overflow','');
	}

	function qtyCheck(obj){

		var realqty = obj.value.replace(/,/g, "");
		var id = $(obj).attr('id');
		var i = id.split('_');
		var planQty = $('#planqty_'+i[1]).val().replace(/,/g, "");

		if (Number(realqty) > Number(planQty)){
			obj.value = comma(planQty);
		}

	}


	function deleteProduction(production_code){

		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
				type : "get",
				url : '/production/delete',
				async : false,
				data: "production_code="+production_code,
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