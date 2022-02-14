<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>

					<h3 class="mjtit_top">
						입고관리
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
        <!--  관리자  검색시작-->
					<div class="master_cont">
                    <form id="searchForm" action="/product/in">
                  		<input type="hidden" value="" name="rowsPerPage" id="rowsPerPage"/>
                  		
                  	<div class="srch_day">
                    	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate">입고일자</label>
                    		</div>
                    		<div class="day_input">
                    			<input type="text" id="startDate" name="startDate"/>
                    		</div>
                    		<span class="sup">~</span>
                    		<div class="day_input">
                    			<input type="text" id="endDate" name="endDate"/>
                    		</div>
                    	</div>

                    </div>

                    <div class="srch_all">
						<div class="sel_wrap sel_wrap1">
							<select name="prod_type" class="sel_02">
								<option value="ALL">품목구분</option>
								<c:forEach items="${productGubun}" var="result">
									<option value="${result.code}" <c:if test="${search.prod_type eq result.code}">selected</c:if> >${result.code_nm}</option>
								</c:forEach>
							</select>
						</div>
                  		<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
	                            <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목명</option>
								<option value="IO_CODE" <c:if test="${search.search_type == 'IO_CODE'}">selected</c:if>>입고코드</option>
                            </select>
                    	</div>
                        <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                              <button type="button" class="btn_01">초기화</button>
                          </div>
                          
                          <div class="register_btn">
                        	<button type="button" class="btn_02" onclick="newRegister()">신규등록</button>
                        </div>
                    </div>
                    </form>
                    </div><!-- 검색  끝-->


<!-- 리스트 시작--><div class="master_list ">
                   <div class="list_set ">
	                    	<div class="set_left">
								총 <span id="dataCnt_1" >${total}</span> 건
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
	                    			<col style="width: 150px;"/>
	                    			<col style="width: 150px;"/>
									<col style="width: 150px;"/>
	                    			<col style="width: 410px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 100px;"/>

	                    		</colgroup>
	           		        	<thead>
	                    			<tr>
	                    				<th>입고코드</th>
										<th>From</th>
										<th>To</th>
										<th>품목명</th>
										<th>양품수량</th>
										<th>불량수량</th>
	                    				<th>입고일자</th>
    		               			</tr>
	                    		</thead>
	                    		<tbody>
	                    			<c:forEach items="${list}" var="list" varStatus="status">
		                    			<tr>
											<td class="name"><a href="#" onclick="viewMaterialInDetail('${list.io_seq}','view');">${list.io_code_no}</a></td>
											<td class="name">${list.from_location}</td>
											<td class="name">${list.to_location}</td>
											<td class="prod">
												<a href="#" onclick="viewMaterialInDetail('${list.io_seq}','view');">${list.pdt_name}</a>
												<a href="#" onclick="viewMaterialInDetail('${list.io_seq}','view');" class="m_link">${list.pdt_name}</a>
											</td>
											<td class="name"><fmt:formatNumber value="${list.good_qty}" pattern="#,###,###"/></td>
											<td class="name"><fmt:formatNumber value="${list.bad_qty}" pattern="#,###,###"/></td>
											<td class="day day1">${list.io_date}</td>
		                    			</tr>
	                    			</c:forEach>
									<c:if test="${empty list }">
										<tr><td colspan="6">입고 정보가 없습니다.</td></tr>
									</c:if>
	                    			
	                    		</tbody>
	                    	</table>
	                    </div>
                    	<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div>
                    </div>
<!-- 관리자 등록 contents -->
			<div class="master_pop master_pop01" id="inmaterialInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="inmaterialInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01" >
					<div class="pop_inner">
					<form id="inmaterialInfo_Form" name="inmaterialInfo_Form">
						<input type="hidden" name="inmaterialCount" id="inmaterialCount"  value="0"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="io_seq" id="io_seq" />
						<input type="hidden" name="manager_seq" id="manager_seq" />
						<input type="hidden" name="plan_code" id="plan_code"/>
						<h3>입고관리<a class="back_btn" href="#" onclick="inmaterialInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
                                        <th scope="row">입고코드 </th>
                                        <td colspan="3">
                                            <input type="text" id="io_code" name="io_code" readonly="readonly"/>
                                            <%--<button id="button_1" type="button" class="btn_02 btn_s" onclick="openLayer();" style="margin-left: 5px;">작지서 조회</button>--%>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">입고일자 <span class="keyf01">*</span></th>
                                        <td>
                                            <div class="day_input"><input type="text" id="io_date" name="io_date" readonly/></div>
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
                                        <th scope="row">일괄적용</th>
                                        <td colspan="3">
                                            <input type="hidden" id="allFrom_type_1"/>
                                            <input type="hidden" id="allFrom_location_1"/>
                                            <input type="text" id="allFrom_txt_1" placeholder="From 일괄적용" onclick="choiceLocation_open(this);" readonly>
                                            <input type="hidden" id="allTo_type_1"/>
                                            <input type="hidden" id="allTo_location_1"/>
                                            <input type="text" id="allTo_txt_1" placeholder="To 일괄적용" onclick="choiceLocation_open(this);" readonly>
                                        </td>
                                    </tr>
								</tbody>
							</table>
						</div>



					<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_2" type="button" class="btn_02" onclick="productSearch();">품목조회</button>
							</div>
							<div class="scroll scroll3">
								<table class="master_01 master_05" id="product" >	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 200px;"/>
										<col style="width: 220px;"/>
										<col style="width: 150px;"/>
										<col style="width: 80px;"/>
										<col style="width: 150px;"/>
										<col style="width: 150px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
										<col style="width: 160px;"/>
										<col style="width: 160px;"/>

									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>품목코드</th>
											<th>품목명</th>
											<th>규격</th>
											<th>단위</th>
											<th>From</th>
											<th>To</th>
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
							<a href="#" class="p_btn_01" onclick="inmaterialInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="inmaterialInfoLayer_Close();"><span>닫기</span></a>
				</div>
				<div id="product_popup" class="layer_pop">	
					<div class="handle_wrap">
						<div class="handle ui-draggable-handle"><span>품목 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="productSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="product_popupframe"></iframe>							
				</div>
					<div id="popup" class="layer_pop">
						<div class="handle_wrap">
							<div class="handle"><span>작업지시서 리스트</span></div>
							<div class="drag_fix"><a href="#" onclick="closeLayer(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
						</div>
						<iframe src="" id="popupframe"></iframe>
					</div>
					<div id="manager_popup" class="layer_pop">
						<div class="handle_wrap">
							<div class="handle"><span>담당자 리스트</span></div>
							<div class="drag_fix"><a href="#" onclick="managerSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
						</div>
						<iframe src="" id="manager_popupframe"></iframe>
					</div>
					<div id="location_popup" class="layer_pop">
						<div class="handle_wrap">
							<div class="handle"><span>위치 선택</span></div>
							<div class="drag_fix"><a href="#" onclick="choiceLocation_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
						</div>
						<iframe src="" id="location_popupframe"></iframe>
					</div>
	</div>
	</div>
     </div>
<!-- contents end -->
<script type="text/javascript">
	<%
	UserInfo user = Util.getUserInfo();
	%>

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

	function viewDepth(line_seq, nowDepth, line_name){
		//메뉴명 클릭시 하위 카테고리 내용 불러오는 함수
		var buttonText = "";
		$.ajax({
			type : "get",
			url : '/productionLine/viewDepth',
			async : false,
			data: "line_seq="+line_seq,
			success : function(data) {
				console.log(data);
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



	function productSearch() {
		if (sessionCheck()) {
			var url = "/order/popProductList?type=order";
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
		var num = Number($('#inmaterialCount').val());
		num += 1;
		var text ="";

		text += "<tr id='product_" + num + "'>";
		text += "<td class='num pctnum'><a href='#' onclick='productDelete(\"" + num + "\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
		text += "<td class='code'>";
		text += "<input type='hidden' id='pdt_cd_" + num + "' name='pdt_cd' value='" + pdt.PDT_CD + "'>";
		text += "<input type='text' id='pdt_code_" + num + "' name='pdt_code' readonly value='" + pdt.PDT_CODE + "'></td>";
		text += "<td class='prod'><input type='text' id='pdt_name_" + num + "' name='pdt_name' value='" + pdt.PDT_NAME + "' placeholder=\"품목\"></td>";
		text += "<td class='prod'><input type='text' id='pdt_standard_" + num + "' name='pdt_standard' value='" + pdt.PDT_STANDARD + "' placeholder=\"규격\"></td>";
		text += "<td class='name'><input type='text' id='unit_" + num + "' name='unit' value='" + pdt.UNIT + "'></td>";
		text += "<td class='name'>";
		text += "<input type='hidden' id='from_type_"+num+"' name='from_type' value='"+$('#allFrom_type_1').val()+"'>";
		text += "<input type='hidden' id='from_location_"+num+"' name='from_location' value='"+$('#allFrom_location_1').val()+"'>";
		text += "<input type='text' id='from_txt_"+num+"' name='from_txt' onclick='choiceLocation_open(this);' readonly placeholder='선택' value='"+$('#allFrom_txt_1').val()+"'>";
		text += "</td>";
		text += "<td class='name'>";
		text += "<input type='hidden' id='to_type_"+num+"' name='to_type' value='"+$('#allTo_type_1').val()+"'>";
		text += "<input type='hidden' id='to_location_"+num+"' name='to_location' value='"+$('#allTo_location_1').val()+"'>";
		text += "<input type='text' id='to_txt_"+num+"' name='to_txt' onclick='choiceLocation_open(this);' readonly placeholder='선택' value='"+$('#allTo_txt_1').val()+"'>";
		text += "</td>";
		text += "<td class='qty'><input type='text' id='good_qty_" + num + "' name='good_qty' placeholder='양품수량' value='' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);'></td>";
		text += "<td class='qty'><input type='text' id='bad_qty_" + num + "' name='bad_qty' placeholder='불량수량' value='' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);'></td>";
		text += "<td class='name'><div class='sel_wrap sel_wrap1'>";
		text +=	"<select name='bad_reason' id='bad_reason_"+num+"' class='sel_02'>";
		text += "<option value=''>없음</option>";
		<c:forEach items="${defectReason}" var="result">
			text += "<option value='${result.code}'>${result.code_nm}</option>";
		</c:forEach>
		text += "</select></div></td>";
		text += "<td class='name'><input type='text' id='bigo_"+num+"' name='bigo'></td>";
		text += "</tr>";
		$('#searchResult').append(text);

		$('#inmaterialCount').val(num);

	}
	function categoryChange(obj){
		var objId = obj.id;
		var objValue = obj.value;
		var objsplit = objId.split("_");
		var objsplit1 = objsplit[1];
		var objsplit2 = objsplit[2];

		var storagelist = "<option value=''>선택</option>";

		var depth = "";
		if (objsplit1 == "NAME1"){
			depth = "2";
			$('#STORAGE_NAME2'+"_"+objsplit2).html(storagelist);
			$('#STORAGE_NAME3'+"_"+objsplit2).html(storagelist);
		}else if(objsplit1 == "NAME2"){
			depth = "3";
			$('#STORAGE_NAME3'+"_"+objsplit2).html(storagelist);
		}
		var target ="STORAGE_NAME" +depth + "_" +objsplit2;


		$.ajax({
			type: 'post',
			url:'/material/StorageList',
			contentType :'application/json',
			data: JSON.stringify ({'STOR_DEPTH':depth,'STOR_UPPER':objValue}),
			async: false,
			success: function (data) {
				$.each(data.storeData , function (key, value) {
					storagelist += "<option value='" + value.STOR_SEQ + "'>" + value.STOR_NAME + "</option>";
				});
			}
		});

		$('#'+target).html(storagelist);

	}
	function StorageList(STOR_UPPER,STOR_DEPTH){
		var storagelist="";
		$.ajax({
			type: 'post',
			url:'/material/StorageList',
			contentType :'application/json',
			data: JSON.stringify ({'STOR_DEPTH':STOR_DEPTH,'STOR_UPPER':STOR_UPPER}),
			async: false,
			success: function (data) {
				$.each(data.storeData , function (key, value) {
					storagelist += "<option value='" + value.STOR_SEQ + "'>" + value.STOR_NAME + "</option>";
				});
			}
		});
		return storagelist;
	}

	function priceChange(num){

		var PRICE = $('#unit_price_'+num).val().replace(/,/gi, "");
		var QTY = $('#qty_'+num).val().replace(/,/gi, "");
		var SUPPLY_PRICE = 0;
		var VAT = 0;


		if (PRICE == "0" || PRICE == "undefined"){
			SUPPLY_PRICE = 0;
			VAT = 0;

			$('#supply_price_'+num).val(SUPPLY_PRICE);
			$('#vat_'+num).val(VAT);
		}else{
			SUPPLY_PRICE = PRICE * QTY;
			VAT = Math.round(SUPPLY_PRICE * 0.1);

			$('#supply_price_'+num).val(comma(SUPPLY_PRICE));
			$('#vat_'+num).val(comma(VAT));

			priceCal();

		}


	}

	function priceCal(){
		var supply_amount = 0;
		var tax_amount = 0;

        $('input[name="supply_price"]').each(function (idx, item) {
        	var SUPPLY_PRICE_val = $(item).val();
        	supply_amount += Number(SUPPLY_PRICE_val.replace(/,/gi, ""));

       	});
        $('input[name="vat"]').each(function (idx, item) {
        	var vatValue = $(item).val();
        	tax_amount += Number(vatValue.replace(/,/gi, ""));
       	});

        $('#supply_amount').val(comma(supply_amount));
        $('#tax_amount').val(comma(tax_amount));
        $('#total_amount').val(comma(supply_amount + tax_amount));

	}


	$(document).ready(function() {

	    var setCalendarDefault = function() {
	        $("#startDate").datepicker();
	        $("#startDate").datepicker('setDate', '${search.startDate}');
	        $("#endDate").datepicker();
	        $("#endDate").datepicker('setDate', '${search.endDate}');

	    }
	    setCalendarDefault();
		$('#popup').css("max-width","850px");
		$('#popup').css("left","50%");
		$('#location_popup').css("max-width","650px");
		$('#location_popup').css("left","50%");
		$('#product_popup').css("left","50%");
		$('#manager_popup').css("left","40%");

	})

		function goSearch(){
			$('#search_string').val($('#search_string').val().trim());
			$('#rowsPerPage').val($('#rowPerPage_1').val());
			$('#searchForm').submit();
		}

		function goReset(){
			$('#searchForm').resetForm();
		}

		function viewMaterialInDetail(io_seq, type){
			InmaterialInfoLayer_Open(io_seq, type);
		}

		function productDelete(rowNum){

			$("#product_"+rowNum).remove();
			priceCal();
		}

	function newRegister(){
		InmaterialInfoLayer_Open(0, "regist");
	}

	function InmaterialInfoLayer_Open(io_seq, type){
		$('#inmaterialInfo_Form').resetForm();
			var text = "";
			if (type=="view"){ //상세보기
				$('#mode').val('view');
				$.ajax({
		            type : "post",
		            url : '/product/getIODetailInfo',
		            async : false,
		            data: "io_seq="+io_seq,
		            success : function(data) {
						text = "";
		            	var array = data.storeData;

		            	if (array.length > 0) {
		            		$('#io_seq').val(array[0].io_seq);
							$('#io_code').val(array[0].io_code);
							$('#plan_code').val(array[0].plan_code);
							$('#io_date').val(array[0].io_date);
							$('#inmaterialCount').val(array.length);

							$('#auth_group_name').val(array[0].groupName);
							$('#manager_name').val(array[0].managerName + " " +array[0].manager_position);
							$('#manager_seq').val(array[0].manager_seq);
							$("#io_date").datepicker();

		                   	for (var i in array){
								text += "<tr id='product_" + array[i].no + "'>";
								text += "<td class='num pctnum'><a href='#' onclick='productDelete(\"" + array[i].no + "\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
								text += "<td class='code'>";
								text += "<input type='hidden' id='pdt_cd_" + array[i].no + "' name='pdt_cd' value='" + array[i].pdt_cd + "'>";
								text += "<input type='text' id='pdt_code_" + array[i].no + "' name='pdt_code' readonly value='" + array[i].pdt_code + "'></td>";
								text += "<td class='prod'><input type='text' id='pdt_name_" + array[i].no + "' name='pdt_name' value='" + array[i].pdt_name + "' placeholder=\"품목\"></td>";
								text += "<td class='prod'><input type='text' id='pdt_standard_" + array[i].no + "' name='pdt_standard' value='" + array[i].pdt_standard + "' placeholder=\"규격\"></td>";
								text += "<td class='name'><input type='text' id='unit_" + array[i].no + "' name='unit' value='" + array[i].unit + "'></td>";
								text += "<td class='name'>";
								text += "<input type='hidden' id='from_type_"+array[i].no+"' name='from_type' value='"+array[i].from_type+"'>";
								text += "<input type='hidden' id='from_location_"+array[i].no+"' name='from_location' value='"+array[i].from_location+"'>";
								text += "<input type='text' id='from_txt_"+array[i].no+"' name='from_txt' onclick='choiceLocation_open(this);' readonly placeholder='선택' value='"+array[i].from_location_txt+"'>";
								text += "</td>";
								text += "<td class='name'>";
								text += "<input type='hidden' id='to_type_"+array[i].no+"' name='to_type' value='"+array[i].to_type+"'>";
								text += "<input type='hidden' id='to_location_"+array[i].no+"' name='to_location' value='"+array[i].to_location+"'>";
								text += "<input type='text' id='to_txt_"+array[i].no+"' name='to_txt' onclick='choiceLocation_open(this);' readonly placeholder='선택' value='"+array[i].to_location_txt+"'>";
								text += "</td>";
								text += "<td class='qty'><input type='text' id='good_qty_" + array[i].no + "' name='good_qty' placeholder='양품수량' value='"+array[i].good_qty+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);'></td>";
								text += "<td class='qty'><input type='text' id='bad_qty_" + array[i].no + "' name='bad_qty' placeholder='불량수량' value='"+array[i].bad_qty+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value);'></td>";
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
								text += "<td class='name'><input type='text' id='bigo_"+array[i].no+"' name='bigo' value='"+array[i].bigo+"'></td>";
								text += "</tr>";
		                   	}
							$('#searchResult').html(text);

		            	}else{
		            		text += "<tr class='all'><td colspan='11'>입고정보가 없습니다.</td></tr>";
		            	}

		            	$('#actionButton').text('수정');
		            }
		         });
			}else{ //신규작성일때
	    		$('#mode').val('register');
	    		$('#actionButton').text('등록');
	         	$('#searchResult').empty();

				$('#SUPPLY_LINE_WRAP').hide();
				$("#io_date").datepicker();
				$("#io_date").datepicker('setDate', '0');
			}

			$('#inmaterialInfoLayer').addClass('view');
			$('html,body').css('overflow','hidden');
			$('.leftNav').removeClass('view');
		}

		function inmaterialInfoLayer_Close(){
			$('#inmaterialInfoLayer').removeClass('view');
			$('html,body').css('overflow','');
			$('.info_edit').removeClass('view');
			$('#inmaterialCount').val(0);
		}

		function GoActionButton(){
			var targetUrl = ""
			var pdt_name = "";
			var qty = "";
			var status = true;

			var mode = $('#mode').val();
			if (mode == 'register') {
				targetUrl = "/product/registerIn";
			} else {
				targetUrl = "/product/updateIn";
			}


			if( isEmpty($('#auth_group_name').val()) || isEmpty($('#manager_name').val()) ){
				alert("담당자를 입력해주세요");
				$('#auth_group_name').focus();
				return false;
			}
			if ($('input[name="pdt_name"]').length == 0) {
				alert("입고 품목이 없습니다.");
				return false;
			}


	        $('input[name="pdt_name"]').each(function (idx, item) {
	        	pdt_name = $(item).val();
	        	if (isEmpty(pdt_name)){
	        		alert("품목명을 입력해주세요.");
					$('input[name="pdt_name"]')[idx].focus();
	        		status = false;
					return false;
	        	}
	       	});
	        if (status == false) return;

	        $('input[name="good_qty"]').each(function (idx, item) {
	        	qty = $(item).val();
	        	if (isEmpty(qty)){
	        		alert("양품수량을 입력해주세요.");
					$('input[name="good_qty"]')[idx].focus();
	        		status = false;
					return false;
	        	}
	       	});
	       if (status == false) return;

			$('input[name="bad_qty"]').each(function (idx, item) {
				qty = $(item).val();
				if (isEmpty(qty)){
					alert("불량수량을 입력해주세요.");
					$('input[name="bad_qty"]')[idx].focus();
					status = false;
					return false;
				}
			});
			if (status == false) return;

			$('input[name="unit"]').each(function (idx, item) {
				var unit = $(item).val();
				if (isEmpty(unit)){
					alert("단위를 입력해주세요.");
					$('input[name="unit"]')[idx].focus();
					status = false;
					return false;
				}
			});

	        if (status == false) return;

			$('input[name="from_location"]').each(function (idx, item) {
				var from_location = $(item).val();
				if (isEmpty(from_location)){
					alert("From 선택해주세요.");
					$('input[name="from_location"]')[idx].focus();
					status = false;
					return false;
				}
			});
			if (status == false) return;

			$('input[name="to_location"]').each(function (idx, item) {
				var to_location = $(item).val();
				if (isEmpty(to_location)){
					alert("To 선택해주세요.");
					$('input[name="to_location"]')[idx].focus();
					status = false;
					return false;
				}
			});
			if (status == false) return;

	        var inmaterialList =[];
			for (var i = 0; i < $("input[name='pdt_name']").length; i++) {
				var tmpMap = {};

				tmpMap.seq = i + 1;
				tmpMap.pdt_cd = $($("input[name='pdt_cd']")[i]).val();
				tmpMap.pdt_code = $($("input[name='pdt_code']")[i]).val();
				tmpMap.pdt_name = $($("input[name='pdt_name']")[i]).val();
				tmpMap.pdt_standard = $($("input[name='pdt_standard']")[i]).val();
				tmpMap.good_qty = $($("input[name='good_qty']")[i]).val().replace(/,/g, "");
				tmpMap.bad_qty = $($("input[name='bad_qty']")[i]).val().replace(/,/g, "");
				tmpMap.unit = $($("input[name='unit']")[i]).val();
				tmpMap.from_type = $($("input[name='from_type']")[i]).val();
				tmpMap.from_location = $($("input[name='from_location']")[i]).val();
				tmpMap.to_type = $($("input[name='to_type']")[i]).val();
				tmpMap.to_location = $($("input[name='to_location']")[i]).val();
				tmpMap.bad_reason = $($("select[name='bad_reason']")[i]).val();
				tmpMap.bigo = $($("input[name='bigo']")[i]).val();
				inmaterialList.push(tmpMap);
			}
			var inmaterial_info =[];
			var tmpMap2 = {};
			tmpMap2.io_seq = $('#io_seq').val();
			tmpMap2.io_date = $($("input[name='io_date']")).val();
			tmpMap2.plan_code = $($("input[name='plan_code']")).val();
			tmpMap2.manager_seq = $($("input[name='manager_seq']")).val();
			inmaterial_info.push(tmpMap2);
			sendData = {};

		    sendData.inmaterialList = inmaterialList;
		    sendData.inmaterial_info = inmaterial_info;

	        $.ajax({
	        	contentType: 'application/json; charset=utf-8',
	            data: JSON.stringify(sendData),
	        	type: "POST",
	        	url : targetUrl,
	        	dataType : "json",
	        	contentType: "application/json"

	        }).done(function(result) {
	           if(result.success){
				   if (mode == 'register') {
					   alert("입고가 등록되었습니다.");
				   }else {
					   alert("입고가 수정되었습니다.");
				   }
	                inmaterialInfoLayer_Close();
	                location.reload();
	             } else {
	                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
	             }
	        });

		}

		function updateIn(){
			var msg = "수정하시겠습니까?";
			if ($('#order_status').val() == 'NO'){
				msg = "정말 취소하시겠습니까?";
			}

			if(confirm(msg)){
				param = $("#inmaterialInfo_Form").serialize();
				 $.ajax({
			        type : "post",
			        url : '/product/updateIn',
			        async : false,
			        data: param,
			        success : function(data) {
			            if(data.success){
			            	alert("수정되었습니다.");
			            	location.reload(true);
			            }
			        },error : function(data){

			            inmaterialInfoLayer_Close();
			            location.reload(true);
		            }
				 });
			}


		}
	function managerSearch_open(){
		if (sessionCheck()){
			var url = "/workplan/popManagerList?type=in";
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

	function PopWorkPlanAdd(data){

		var array = data.storeData;
		var product_line_arr = "";
		$('#plan_code').val(array[0].plan_code);

		$('#auth_group_name').val(array[0].groupName);
		$('#manager_name').val(array[0].managerName + " " +array[0].manager_position);
		$('#manager_seq').val(array[0].manager_seq);
		$('#production_date').val(array[0].startDate);
		product_line_arr = array[0].product_line.split(",");
		$('#supply_line_1').val(product_line_arr[0]);
		viewDepth(product_line_arr[0], '', '');
		$('#SUPPLY_LINE_WRAP').show();
		$('#supply_line_2').val(product_line_arr[1]);
		$('#productCount').val(array.length);
		var num = 0;
		var text ="";

		for (var i in array){
			num += 1;

			text += "<tr id='product_" + num + "'>";
			text += "<td class='num pctnum'><a href='#' onclick='productDelete(\"" + num + "\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
			text += "<td class='code'>";
			text += "<input type='hidden' id='pdt_cd_" + num + "' name='pdt_cd' value='" + array[i].pdt_cd + "'>";
			text += "<input type='text' id='pdt_code_" + num + "' name='pdt_code' readonly value='" + array[i].pdt_code + "'></td>";
			text += "<td class='prod'><input type='text' id='pdt_name_" + num + "' name='pdt_name' value='" + array[i].pdt_name + "' placeholder=\"품목\"></td>";
			text += "<td class='prod'><input type='text' id='pdt_standard_" + num + "' name='pdt_standard' value='" + array[i].pdt_standard + "' placeholder=\"규격\"></td>";
			text += "<td class='name'><input type='text' id='unit_" + num + "' name='unit' value='" + array[i].unit + "'></td>";
			text += "<td class='qty'><input type='text' id='qty_" + num + "' name='qty' value='"+comma(array[i].planqty)+"' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); this.value=comma(this.value); priceChange(" + num + ");' maxlength='12' placeholder='입고수량'></td>";
			text += "<td><div class='sel_wrap sel_wrap1'><select name='STORAGE_NAME1' id='STORAGE_NAME1_"+num+"' onchange='categoryChange(this)'class='sel_02'>";
			text += StorageList(0,1);
			text +="</select></div></td>";
			text += "<td><div class='sel_wrap sel_wrap1'><select name='STORAGE_NAME2' id='STORAGE_NAME2_"+num+"'onchange='categoryChange(this)' class='sel_02'>";
			text +='<option value="all">선택</option></select></div></td>';
			text += "<td><div class='sel_wrap sel_wrap1'><select name='STORAGE_NAME3' id='STORAGE_NAME3_"+num+"' class='sel_02'>";
			text +='<option value="all">선택</option></select></div></td>';
			text += "</tr>";
		}

		$('#searchResult').html(text);

		$('#inmaterialCount').val(num);
		priceCal();
		for (var j = 1; j<=num; j++){
			var obj = document.getElementById("STORAGE_NAME1_"+j);
			categoryChange(obj);
		}
	}

	function choiceLocation_open(obj) {
		if (sessionCheck()){
			var url = "/popup/popLocationList?target="+obj.id;
			$('#location_popup').css('display','block');
			$('#location_popupframe').attr('src',url);
			$('html,body').css('overflow','hidden');
		}else{
			location.reload();
		}

	}
	function choiceLocation_close() {
		$('#location_popup').css('display','none');
		$('#location_popupframe').removeAttr('src');
		$('html,body').css('overflow','');

	}

	function choiceCust(name,target, cust_seq){
		var splitArr = target.split('_');
		$('#'+splitArr[0]+'_type_'+splitArr[2]).val("C");
		$('#'+splitArr[0]+'_location_'+splitArr[2]).val(cust_seq);
		$('#'+target).val(name);
	}
	function choiceLine(name,target, line_seq){
		var splitArr = target.split('_');
		$('#'+splitArr[0]+'_type_'+splitArr[2]).val("L");
		$('#'+splitArr[0]+'_location_'+splitArr[2]).val(line_seq);
		$('#'+target).val(name);
	}
	function choiceStorage(name,target, stor_seq){
		var splitArr = target.split('_');
		$('#'+splitArr[0]+'_type_'+splitArr[2]).val("S");
		$('#'+splitArr[0]+'_location_'+splitArr[2]).val(stor_seq);
		$('#'+target).val(name);
	}

</script>