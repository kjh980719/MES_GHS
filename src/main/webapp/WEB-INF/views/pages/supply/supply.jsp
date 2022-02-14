<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>

<script type="text/javascript" src="/js/common/paging.js"></script>
<%
UserInfo user = Util.getUserInfo();
%>

<script type="text/javascript">

	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		var rowsPerPage = $('#rowPerPage_1').val();
		$('#rowsPerPage').val(rowsPerPage);
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}
	

	

</script>

					<h3 class="mjtit_top">
						공급사 조회
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/supply/supply">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
                    <div class="srch_all">
                    	<div class="sel_wrap sel_wrap1">
                    		<select name="use_yn" class="sel_02"> 
	                        	<option value="Y" <c:if test="${search.use_yn == 'Y'}">selected</c:if>>사용</option>
	                        	<option value="N" <c:if test="${search.use_yn == 'N'}">selected</c:if>>미사용</option>                                   
                            </select>
                    	</div>
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="CUST_NAME" <c:if test="${search.search_type == 'CUST_NAME'}">selected</c:if>>거래처명</option>
	                            <option value="REMARKS_WIN" <c:if test="${search.search_type == 'REMARKS_WIN'}">selected</c:if>>키워드</option>
                                  
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string"   onkeyup="if(window.event.keyCode==13){goSearch();}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick='goSearch();'>검색</button>
                              <button type="button" class="btn_01">초기화</button> 
                          </div>
                          
                          <div class="register_btn">
                        	<button type="button" class="btn_02" onclick="newRegister();">신규등록</button>						
							<!-- <button type="button" class="btn_02" onclick="openLayer();">전체 계정내역</button> -->
                        </div>
                        
                        
                    </div>
               
                    </form>
 
                    </div><!-- 검색  끝-->
					<!-- 리스트 시작-->
					
                    <div class="master_list ">
                    	<div class="list_set ">
	                    	<div class="set_left">
								총 <span id="dataCnt_1" >${total}</span> 건
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
	                    <div class="scroll">
                    	<table class="master_01 master_06">
                    		<colgroup>
                    			<col style="width: 55px;"/>
                    			<col style="width: 110px;"/>
                    			<col style="width: 185px;"/>
                    			<col style="width: 165px;"/>
                    			<col style="width: 120px;"/>
                    			<col style="width: 115px;"/>
                    			<col style="width: 115px;"/>
                    			<col style="width: 75px;"/>
                    			<col style="width: 100px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>거래처코드</th>
                    				<th>거래처명</th>
                    				<th>거래처그룹</th>
									<th>대표자명</th>
                    				<th>전화번호</th>
                    				<th>핸드폰번호</th>                 				
                    				<th>사용구분</th>
                    				<th>관리</th>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list" varStatus="status">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${total+1-list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="updateSupply('${list.CUST_SEQ}'); return;">${list.BUSINESS_NO}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="updateSupply('${list.CUST_SEQ}'); return;">${list.CUST_NAME}</a>
		                    				<a href="#" onclick="updateSupply('${list.CUST_SEQ}'); return;" class="m_link">${list.CUST_NAME}</a>
	                    				</td>
	                    				<td class="name"></td>
	       								<td class="name">${list.BOSS_NAME}</td>
	                    				<td class="tel">${list.TEL}</td>
	                    				<td class="tel">${list.HP_NO}</td>
	                    				<c:choose>
	                    					<c:when test="${list.USE_YN eq 'N'}">
	                    						<td class="ing">미사용</td>
	                    					</c:when>
	                    					<c:when test="${list.USE_YN eq 'Y'}">
	                    						<td class="ing">사용</td>
	                    					</c:when>	                    				
	                    				</c:choose>
	    								<td class="ing"><a href="#" class="btn_02" onclick="openLayer('${list.CUST_SEQ}');">계정생성</a></td>
	                    				 
	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="8">거래처 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="supplyInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="supplyInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01" >
					<div class="pop_inner">
					<form id="supplyInfo_Form" name="supplyInfo_Form">
						<input type="hidden" name="cust_seq" id="cust_seq" />
						
						<h3 id="title">공급사 등록 및 수정<a class="back_btn" href="#" onclick="supplyInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
						<div class="marter_tab">
							<ul class="clearfix">
								<li class="view"><a href="#" onclick="tabView(1,this);return false;">기본</a></li>	
								<li><a href="#" onclick="tabView(2,this);return false;">탭2</a></li>	
								<li><a href="#" onclick="tabView(3,this);return false;">탭3</a></li>	
								<li><a href="#" onclick="tabView(4,this);return false;">탭4</a></li>	
							</ul>
						</div>
						<div class="master_list">
							<div class="tab_box tab_box1">
								<table class="master_02 ">	
									<colgroup>
										<col style="width: 130px">
										<col>					
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">사업자번호</th>
											<td colspan="3">
												<input type="text" name="business_no" id="business_no" />
											</td>	
										</tr>
										<tr>
											<th scope="row">거래처이름</th>
											<td colspan="3">
												<input type="text" name="cust_name" id="cust_name"/>
											</td>	
										</tr>
										
										<tr>
											<th scope="row">대표자명</th>
											<td colspan="3">
												<input type="text" name="boss_name" id="boss_name"/>
											</td>														
										</tr>
										<tr>
											<th scope="row">업태</th>
											<td colspan="3">
												<input type="text" name="uptae" id="uptae"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">종목</th>
											<td colspan="3">
												<input type="text" name="uptae" id="uptae"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">전화번호</th>
											<td colspan="3">
												<input type="text" name="tel" id="tel"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">핸드폰번호</th>
											<td colspan="3">
												<input type="text" name="hp_no" id="hp_no"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">이메일</th>
											<td colspan="3">
												<input type="text" name="email" id="email"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">팩스번호</th>
											<td colspan="3">
												<input type="text" name="fax" id="fax"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">우편번호</th>
											<td colspan="3">
												<input type="text" name="post_no" id="post_no" readonly="readonly"/>
												<button type="button" class="btn_01 btn_s" onclick="openZipSearch();">우편번호검색</button>
											</td>															
										</tr>
										<tr>
											<th scope="row">주소</th>
											<td colspan="3">
												<input type="text" name="addr" id="addr" readonly="readonly"/>
											</td>
																									
										</tr>
										<tr>
											<th scope="row">상세주소</th>
											<td colspan="">
												<input type="text" name="addr_info" id="addr_info"/>
											</td>																
										</tr>
										<tr>
											<th scope="row">검색 키워드</th>
											<td colspan="3">
												<input type="text" name="remarks_win" id="remarks_win"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">구분</th>
											<td colspan="3">
												<input type="text" name="gubun" id="gubun"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">외환거래처사용여부</th>
											<td colspan="3">
												<div class="sel_wrap">
													<select id="foreign_flag" name="foreign_flag"  class="sel_02">
														<option value="N">사용안함</option>
														<option value="N">미사용</option>
													</select>
												</div>
											</td>															
										</tr>
										<tr>
											<th scope="row">외화코드</th>
											<td colspan="3">
												<input type="text" name="exchange_code" id="exchange_code" />
											</td>															
										</tr>
										<tr>
											<th scope="row">비고</th>
											<td colspan="3">
												<input type="text" name="cont1" id="cont1"/>
											</td>															
										</tr>										
										<tr>
											<th scope="row">사용여부</th>
											<td colspan="3">
												<div class="sel_wrap">
													<select id="use_yn" name="use_yn"  class="sel_02">
														<option value="Y">사용</option>
														<option value="N">미사용</option>
													</select>
												</div>
											</td>															
										</tr>
									</tbody>
								</table>
							</div>
							<div class="tab_box tab_box2">
								<table class="master_02 ">	
									<colgroup>
										<col style="width: 130px">
										<col>					
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">업무관련그룹</th>
											<td colspan="3">
												<input type="text" name="cust_group" id="cust_group"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">회계관련그룹</th>
											<td colspan="3">
												<input type="text" name="cust_group2" id="cust_group2"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">홈페이지</th>
											<td colspan="3">
												<input type="text" name="url_path" id="url_path"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">적요</th>
											<td colspan="3">
												<input type="text" name="remarks" id="remarks"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">출하대상 거래처 구분</th>
											<td colspan="3">
												<input type="text" name="outorder_yn" id="outorder_yn"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">거래유형(영업) 기본여부</th>
											<td colspan="3">
												<div class="sel_wrap">
													<select id="io_code_sl_base_yn" name="io_code_sl_base_yn"  class="sel_02">
														<option value="Y">사용</option>
														<option value="N">미사용</option>
													</select>
												</div>
											</td>															
										</tr>
										<tr>
											<th scope="row">거래유형(영업)</th>
											<td colspan="3">
												<input type="text" name="io_code_sl" id="io_code_sl"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">거래유형(구매) 기본여부</th>
											<td colspan="3">
												<div class="sel_wrap">
													<select id="io_code_by_base_yn" name="io_code_by_base_yn"  class="sel_02">
														<option value="Y">사용</option>
														<option value="N">미사용</option>
													</select>	
												</div>
											</td>															
										</tr>
										<tr>
											<th scope="row">거래유형(구매)</th>
											<td colspan="3">
												<input type="text" name="io_code_by" id="io_code_by"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">채권번호관리</th>
											<td colspan="3">
												<input type="text" name="manage_bond_no" id="manage_bond_no"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">채무번호관리</th>
											<td colspan="3">
												<input type="text" name="manage_debit_no" id="manage_debit_no"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">거래처별여신한도</th>
											<td colspan="3">
												<input type="text" name="cust_limit" id="cust_limit"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">출고조정률</th>
											<td colspan="3">
												<input type="text" name="o_rate" id="o_rate"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">입고조정률</th>
											<td colspan="3">
												<input type="text" name="i_rate" id="i_rate"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">영업단가그룹</th>
											<td colspan="3">
												<input type="text" name="price_group" id="price_group"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">구매단가그룹</th>
											<td colspan="3">
												<input type="text" name="price_group2" id="price_group2"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">여신기간</th>
											<td colspan="3">
												<input type="text" name="cust_limit_term" id="cust_limit_term"/>
											</td>															
										</tr>	
										
									</tbody>
								</table>
							</div>
							<div class="tab_box tab_box3">
								탭3
							</div>
							<div class="tab_box tab_box4">
								탭4
							</div>
						</div>
			
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="supplyInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" class="p_btn_02" onclick="goRegister();">등록</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="supplyInfoLayer_Close();"><span>닫기</span></a>
				</div>
			</div>
		</div>
	</div>

<div id="popup" class="layer_pop">	
	<iframe src="" id="popupframe"></iframe>							
</div>


<form id="supplyForm">
	<input type="hidden" name="seq" id="seq"/>
	<input type="hidden" name="no" id="no"/>
</form>

<script>
function tabView(num,el) {
	
	$('.marter_tab li').removeClass('view');
	$(el).parents('li').addClass('view');
	$('.tab_box').css('display','none');
	$('.tab_box'+num).css('display','block');
	
}
function openLayer(cust_seq) {

 	if(sessionCheck()){
    	var url = "/supply/popSupplyAccountCreate?seq="+cust_seq;
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

function newRegister(){	
	supplyInfoLayer_Open(0, "regist");
}
function updateSupply(seq){	
	supplyInfoLayer_Open(seq, "edit");
}

function supplyInfoLayer_Open(seq, type){

    var targetUrl = "/supply/getSupplyInfo";

    var param = "";
    var text = "";

	if (type == "edit"){ //상세보기
		$('#actionButton').html("수정");
	    $('#seq').val(seq);
	    param = $("#supplyForm").serialize();
	    
		$.ajax({
            type : "post",
            url : targetUrl,
            async : false,
            data: param,
            success : function(data) {
            	var info = data.storeData;
            	
            	$('#addr').val(info.addr);
            	$('#addr_info').val(info.addr_info);
            	
            	$('#business_no').val(info.business_no);
            	$('#boss_name').val(info.boss_name);
            	$('#cont1').val(info.cont1);
            	$('#cust_group1').val(info.cust_group1);
            	$('#cust_group2').val(info.cust_group2);
            	$('#cust_limit').val(info.cust_limit);
            	$('#cust_limit_term').val(info.cust_limit_term);
            	$('#cust_name').val(info.cust_name);
            	$('#cust_seq').val(info.cust_seq);
            	$('#dm_addr').val(info.dm_addr);
            	$('#dm_post').val(info.dm_post);
            	
            	$('#email').val(info.email);
            	$('#emp_cd').val(info.emp_cd);
            	$('#exchange_code').val(info.exchange_code);
            	$('#fax').val(info.fax);
            	$('#foreign_flag').val(info.foreign_flag);
            	$('#g_business_cd').val(info.g_business_cd);
            	$('#g_business_type').val(info.g_business_type);
            	$('#g_gubun').val(info.g_gubun);
            	$('#gubun').val(info.gubun);
            	
            	$('#hp_no').val(info.hp_no);
            	$('#i_rate').val(info.i_rate);
            	$('#io_code_by').val(info.io_code_by);
            	$('#io_code_by_base_yn').val(info.io_code_by_base_yn);
            	$('#io_code_sl').val(info.io_code_sl);
            	$('#io_code_sl_base_yn').val(info.io_code_sl_base_yn);
            	
            	$('#jongmok').val(info.jongmok);
            	$('#manage_bond_no').val(info.manage_bond_no);
            	$('#manage_debit_no').val(info.manage_debit_no);
            	$('#o_rate').val(info.o_rate);
            	$('#post_no').val(info.post_no);
            	$('#price_group').val(info.price_group);
            	$('#price_group2').val(info.price_group2);
            	
            	$('#remarks').val(info.remarks);
            	$('#remarks_win').val(info.remarks_win);
            	$('#tax_reg_id').val(info.tax_reg_id);
            	$('#tel').val(info.tel);
            	$('#uptae').val(info.uptae);
            	$('#url_path').val(info.url_path);
            	$('#use_yn').val(info.use_yn);
            	
            	$('#supplyInfoLayer').addClass('view');
            	$('html,body').css('overflow','hidden');            	
            	$('.leftNav').removeClass('view');
            	
            },error : function(data){
           	 
            	supplyInfoLayer_Close();
	            location.reload(true);
            }

         }); 
	
	}else{
		$('#actionButton').html("등록");
		$('#supplyInfo_Form').resetForm();
		$('#supplyInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}

}


function supplyInfoLayer_Close(){
	$('#supplyInfoLayer').removeClass('view');
	$('html,body').css('overflow','');
	$('.info_edit').removeClass('view');		
}



function openZipSearch() {

	new daum.Postcode({
		oncomplete: function(data) {
			$('[name=post_no]').val(data.zonecode); // 우편번호 (5자리)
			$('[name=addr]').val(data.address);
		}
	}).open();
}



</script>
