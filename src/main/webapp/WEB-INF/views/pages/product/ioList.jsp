<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>

					<h3 class="mjtit_top">
						입출고현황
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
        <!--  관리자  검색시작-->
					<div class="master_cont">
                    <form id="searchForm" action="/product/ioList">
                  		<input type="hidden" value="" name="rowsPerPage" id="rowsPerPage"/>
                  		
                  	<div class="srch_day">
                    	<div class="day_area">
                    		<div class="day_label">
                    		<label for="startDate">입출고일자</label>
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
							<select name="io_type" class="sel_02">
								<option value="ALL">입출고구분</option>
								<option value="IN" <c:if test="${search.io_type == 'IN'}">selected</c:if>>입고</option>
								<option value="OUT" <c:if test="${search.io_type == 'OUT'}">selected</c:if>>출고</option>
								<option value="MOVE" <c:if test="${search.io_type == 'MOVE'}">selected</c:if>>자재이동</option>
							</select>
						</div>

                  		<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
	                            <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목명</option>
								<option value="IO_CODE" <c:if test="${search.search_type == 'IO_CODE'}">selected</c:if>>입출고코드</option>
                            </select>
                    	</div>
                        <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                              <button type="button" class="btn_01">초기화</button>
                          </div>
                          
                          <div class="register_btn">
                        	<%--<button type="button" class="btn_02" onclick="newRegister()">신규등록</button>--%>
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
									<col style="width: 70px;"/>
	                    			<col style="width: 150px;"/>
									<col style="width: 150px;"/>
	                    			<col style="width: 410px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 100px;"/>

	                    		</colgroup>
	           		        	<thead>
	                    			<tr>
	                    				<th>입출고코드</th>
										<th>구분</th>
										<th>From</th>
										<th>To</th>
										<th>품목명</th>
										<th>양품수량</th>
										<th>불량수량</th>
	                    				<th>입출고일자</th>
    		               			</tr>
	                    		</thead>
	                    		<tbody>
	                    			<c:forEach items="${list}" var="list" varStatus="status">
		                    			<tr>
											<td class="name"><a href="#" onclick="viewMaterialInDetail('${list.io_seq}','view');">${list.io_code_no}</a></td>
											<td class="name">${list.io_type_txt}</td>
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
										<tr><td colspan="7">입출고 정보가 없습니다.</td></tr>
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
						<h3>입출고현황<a class="back_btn" href="#" onclick="inmaterialInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
                                        <th scope="row">입출고코드 </th>
                                        <td colspan="3">
                                            <input type="text" id="io_code" name="io_code" readonly="readonly"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">입출고일자 <span class="keyf01">*</span></th>
                                        <td>
                                           <input type="text" id="io_date" name="io_date"  readonly="readonly"/>
                                        </td>
                                        <th scope="row">담당자 <span class="keyf01">*</span></th>
                                        <td>
                                            <div>
                                                <input type="text" id="auth_group_name" name="auth_group_name" readonly="readonly" />
                                            </div>
                                            <div class="dan">
                                                <input type="text" id="manager_name" name="manager_name" readonly="readonly" />
                                            </div>
                                        </td>
                                    </tr>
								</tbody>
							</table>
						</div>



					<div class="master_list master_listT">
							<div class="add_btn">

							</div>
							<div class="scroll scroll3">
								<table class="master_01 master_05" id="product" >	
									<colgroup>
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

						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="inmaterialInfoLayer_Close();"><span>닫기</span></a>
				</div>


	</div>
	</div>
     </div>
<!-- contents end -->
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

		function viewMaterialInDetail(io_seq, type){
			InmaterialInfoLayer_Open(io_seq, type);
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

		                   	for (var i in array){
								text += "<tr id='product_" + array[i].no + "'>";
								text += "<td class='code'>";
								text += "<input type='text' id='pdt_code_" + array[i].no + "' name='pdt_code' readonly='readonly' value='" + array[i].pdt_code + "' ></td>";
								text += "<td class='prod'><input type='text' id='pdt_name_" + array[i].no + "' name='pdt_name' value='" + array[i].pdt_name + "' placeholder=\"품목\" readonly='readonly'></td>";
								text += "<td class='prod'><input type='text' id='pdt_standard_" + array[i].no + "' name='pdt_standard' value='" + array[i].pdt_standard + "' placeholder=\"규격\" readonly='readonly'></td>";
								text += "<td class='name'><input type='text' id='unit_" + array[i].no + "' name='unit' value='" + array[i].unit + "' readonly='readonly'></td>";
								text += "<td class='name'>";
								text += "<input type='text' id='from_txt_"+array[i].no+"' name='from_txt' readonly='readonly' placeholder='선택' value='"+array[i].from_location_txt+"'>";
								text += "</td>";
								text += "<td class='name'>";
								text += "<input type='text' id='to_txt_"+array[i].no+"' name='to_txt'  readonly='readonly' placeholder='선택' value='"+array[i].to_location_txt+"'>";
								text += "</td>";
								text += "<td class='qty'><input type='text' id='good_qty_" + array[i].no + "' name='good_qty' placeholder='양품수량' value='"+array[i].good_qty+"' readonly='readonly'></td>";
								text += "<td class='qty'><input type='text' id='bad_qty_" + array[i].no + "' name='bad_qty' placeholder='불량수량' value='"+array[i].bad_qty+"'readonly='readonly'></td>";
								text += "<td class='name'>";
								<c:forEach items="${defectReason}" var="result">
									if (array[i].bad_reason == '${result.code}'){
										text += "<input type='text' id='bad_reason_"+array[i].no+"' name='bad_reason' value='${result.code_nm}'></td>";
									}else{
										text += "";
									}
								</c:forEach>
								text += "<td class='name'><input type='text' id='bigo_"+array[i].no+"' name='bigo' value='"+array[i].bigo+"' readonly='readonly'></td>";
								text += "</td>";
								text += "</tr>";
		                   	}
							$('#searchResult').html(text);

		            	}else{
		            		text += "<tr class='all'><td colspan='11'>입출고정보가 없습니다.</td></tr>";
		            	}

		            }
		         });
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



</script>