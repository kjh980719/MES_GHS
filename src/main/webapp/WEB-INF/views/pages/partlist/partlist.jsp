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
	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		var rowsPerPage = $('#rowPerPage_1').val();
		$('#rowsPerPage').val(rowsPerPage);
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}

 	function partlistInfoLayer_Close(){
		$('#partlistInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}
	
	function viewPartlistDetail(CODE, type){
		partlistInfoLayer_Open(CODE, type);
	}
	

	function partlistInfoLayer_Open(PDT_CD, type){
		var text = "";
		if (type=="view"){ //상세보기
			$.ajax({
	            type : "get",
	            url : '/partlist/getPartListRow',
	            async : false,
	            data:"PDT_CD="+PDT_CD,
	            success : function(data) {
					var array = data.storeData;
					var NO="";
					var PDT_CD="";
					var PDT_CODE="";
					var PDT_NAME="";
					var M_CD="";
					var MTR_CODE="";
					var MTR_NAME="";
					var MTR_STANDARD="";
					var UNIT="";
					var QTY="";
					var PRICE="";
					var BIGO ="";


					if (array.length > 0) {
						BASIC_YN = array[0].BASIC_YN;
						STOCK_MINUS_YN = array[0].STOCK_MINUS_YN;

						NO = array[0].NO;
						PDT_CD = array[0].PDT_CD;
						PDT_CODE = array[0].PDT_CODE;
						PDT_NAME = array[0].PDT_NAME;


						$('#PDT_CD').val(PDT_CD);
						$('#PDT_CODE').val(PDT_CODE);
						$('#PDT_NAME').val(PDT_NAME);


						for (var i in array){

							NO = array[i].NO;
							M_CD = array[i].M_CD;
							MTR_CODE = array[i].MTR_CODE;
							MTR_NAME = array[i].MTR_NAME;
							MTR_STANDARD = array[i].MTR_STANDARD;
							UNIT = array[i].UNIT;
							QTY = array[i].QTY;
							PRICE = array[i].PRICE;
							BIGO = array[i].BIGO;

							text += "<tr id='partlist_"+NO+"' class='partlist_"+NO+"'>";
							text += "<td class='no'><input type='text' value='"+NO+"' readonly></td>";
							text += "<td class='code'><input type='hidden' id='mcd_"+NO+"' name='mcd' value='"+M_CD+"'>";
							text += "<input type='text' id='mtr_code_"+NO+"' name='mtr_code' value='"+MTR_CODE+"' readonly></td>";
							text += "<td class='prod'><input type='text' id='mname_"+NO+"' name='mname' value='"+MTR_NAME+"' readonly></td>";
							text += "<td class='prod'><input type='text' id='mstandard_"+NO+"' name='mstan' value='"+MTR_STANDARD+"' readonly></td>";
							text += "<td class='name'><input type='text' id='unit_"+NO+"' name='unit' value='"+UNIT+"' readonly></td>";
							text += "<td class='qty'><input type='text' id='qty_"+NO+"' name='qty' value='"+QTY+"' readonly></td>";
							text += "<td class='qty'><input type='text' id='price_"+NO+"' name='price' value='"+comma(PRICE)+"' readonly></td>"
							text += "<td class='name'><input type='text' id='bigo_"+NO+"' name='bigo' value='"+BIGO+"' readonly></td>";
							text += "</tr>";
						}
						$('#partlistCount').val(NO);
					}else{
						text += "<tr class='all'><td colspan='8'>품목정보가 없습니다.</td></tr>";
					}
					$('#searchResult').html(text);
					priceCal();
	            }
				
	         });
			
		}

		$('#partlistInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	
	
	function partlistInfoLayer_Close(){
		$('#partlistInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}


function priceCal() {
	var total_price = 0;
	var price_val = 0;
	$('input[name="price"]').each(function (idx, item) {

		var splitArr = (item.id).split('_');
		price_val = $(item).val();
		total_price += Number(price_val.replace(/,/gi, "")) * Number($('#qty_'+splitArr[1]).val());
	});

	$('#TOTAL_PRICE').val(comma(total_price));


}
	
</script>
<style>

		ul.tabs{
			margin: 0px;
			padding: 0px;
			list-style: none;
		}
		ul.tabs li{
			background: none;
			color: #222;
			display: inline-block;
			padding: 10px 15px;
			cursor: pointer;
		}

		ul.tabs li.current{
			background: #ededed;
			color: #222;
		}

		.tab-content{
			display: none;
			background: #ededed;
			padding: 15px;
		}

		.tab-content.current{
			display: inherit;
		}
		
</style>

					<h3 class="mjtit_top">
						PartList 조회
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                    <form id="searchForm" action="/partlist/partlist">
                  		<input type="hidden" value="" name="rowsPerPage" id="rowsPerPage"/>
                    <div class="srch_all">
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
	                            <option value="CODE" <c:if test="${search.search_type == 'CODE'}">selected</c:if>>품목코드</option>
	                            <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목명</option>
	                            <option value="M_CODE" <c:if test="${search.search_type == 'M_CODE'}">selected</c:if>>원자재코드</option>
	                            <option value="MTR_NAME" <c:if test="${search.search_type == 'MTR_NAME'}">selected</c:if>>원자재명</option>
                                  
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                              <button type="button" class="btn_01">초기화</button> 
                          </div>

                          <div class="register_btn">

                        </div>
                    </div>
                
                    </form>
 
                    </div><!-- 검색  끝-->


					<!-- 리스트 시작-->
 
                    <div class="master_list ">
                    	<div class="list_set ">
	                    	<div class="set_left">

							</div>

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
                    <div class="master_list scroll">
                    	<table class="master_01">
                    		<colgroup>
                    			<col style="width: 55px;"/>
                    			<col style="width: 150px;"/>
                    			<col style="width: 280px;"/>
                    			<col style="width: 280px;"/>
                    			<col style="width: 125px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>품목코드</th>
                    				<th colspan="2">품목명</th>
									<th>원재료갯수</th>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="no"><fmt:formatNumber value="${total +1 - list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="viewPartlistDetail('${list.PDT_CD}','view');">${list.PDT_CODE}</a>
	                    					<a href="#" onclick="viewPartlistDetail('${list.PDT_CD}','view');" class="m_link">${list.PDT_CODE}</a>
	                    					</td>
	                    				<td class="sang t_left" colspan="2">
		                    				<a href="#" onclick="viewPartlistDetail('${list.PDT_CD}','view');">${list.PDT_NAME}</a>
	                    				</td>
	       								<td class="mcode">${list.CNT}</td>
	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="7">파트리스트 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 10, parameter)}
       					 </div> 
                    </div>
                    </div>
 					
 	<div class="master_pop master_pop01" id="partlistInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="partlistInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="partlistInfo_Form" name="partlistInfo_Form">
						<input type="hidden" name="PDT_CD" id="PDT_CD" />
						<input type="hidden" name="partlistCount" id="partlistCount"  value="0"/>
						<h3>Partlist 등록/조회<a class="back_btn" href="#" onclick="orderInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

						<div class="master_list master_listB">
							<table  class="master_02 master_04">

								<colgroup>
									<col style="width: 120px">
									<col style="width: 34.8%">
									<col style="width: 120px">
									<col style="width: 34.8%">
								</colgroup>

								<tbody>
									<tr>
										<th scope="row">품목코드</th>
										<td colspan="3"><input type="text" id="PDT_CODE" name="PDT_CODE" readonly="readonly"/></td>

									</tr>
									<tr>
										<th scope="row">품목명</th>
										<td colspan="3"><input type="text" id="PDT_NAME" name="PDT_NAME" class="all" readonly="readonly" /></td>
									</tr>
									<tr>
										<th scope="row">총액</th>
										<td colspan="3"><input type="text" id="TOTAL_PRICE" name="TOTAL_PRICE" class="all right" readonly="readonly" /></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="master_list master_listT">
							<div class="scroll">
								<table class="master_01 master_05" id="product" >
									<colgroup>
										<col style="width: 50px;"/>
										<col style="width: 200px;"/>
										<col style="width: 250px;"/>
										<col style="width: 200px;"/>
										<col style="width: 60px;"/>
										<col style="width: 100px;"/>
										<col style="width: 200px;"/>
										<col style="width: 100px;"/>
									</colgroup>
									<thead>
									<tr>
										<th>NO</th>
										<th>품목코드</th>
										<th>품목명</th>
										<th>규격</th>
										<th>단위</th>
										<th>수량</th>
										<th>단가</th>
										<th>적요</th>

									</tr>
									</thead>

									<tbody id="searchResult">

									</tbody>
								</table>
								
							</div>
						</div>

							
							<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="partlistInfoLayer_Close();">닫기</a>
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getCustView_close" onclick="partlistInfoLayer_Close();"><span>닫기</span></a>
				</div>
				<div id="material_popup" class="layer_pop">
					<div class="handle_wrap">
						<div class="handle ui-draggable-handle"><span>품목 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="materialSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="material_popupframe"></iframe>
				</div>
				<div id="product_popup" class="layer_pop">
					<div class="handle_wrap">
						<div class="handle ui-draggable-handle"><span>원자재 리스트</span></div>
						<div class="drag_fix"><a href="#" onclick="productSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
					</div>
					<iframe src="" id="product_popupframe"></iframe>
				</div>
			</div>
		</div>
	</div>			

