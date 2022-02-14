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
						공급사계정 내역
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/supply/supplyaccount">
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
	                            <option value="BUSINESS_NO" <c:if test="${search.search_type == 'BUSINESS_NO'}">selected</c:if>>사업자번호</option>
	                            <option value="ID" <c:if test="${search.search_type == 'ID'}">selected</c:if>>아이디</option>
	                            <option value="EMAIL" <c:if test="${search.search_type == 'EMAIL'}">selected</c:if>>이메일</option>
                           		<option value="MANAGER" <c:if test="${search.search_type == 'MANAGER'}">selected</c:if>>담당자</option>
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string"   onkeyup="if(window.event.keyCode==13){goSearch();}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick='goSearch();'>검색</button>
                              <button type="button" class="btn_01">초기화</button> 
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

                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>아이디</th>
                    				<th>이메일</th>
                    				<th>담당자</th>
									<th>거래처명</th>
                    				<th>사업자번호</th>
                    				<th>사용여부</th>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="updateSupply('${list.scm_manager_seq}'); return;">${list.scm_manager_id}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="updateSupply('${list.scm_manager_seq}'); return;">${list.scm_manager_email}</a>
		                    				<a href="#" onclick="updateSupply('${list.scm_manager_seq}'); return;" class="m_link">${list.scm_manager_email}</a>
	                    				</td>
	                    				<td class="name">${list.scm_manager_name}</td>
	       								<td class="name">${list.cust_name}</td>
	                    				<td class="tel">${list.business_no}</td>                    				
	                    				<c:choose>
	                    					<c:when test="${list.scm_use_yn eq 'N'}">
	                    						<td class="ing">미사용</td>
	                    					</c:when>
	                    					<c:when test="${list.scm_use_yn eq 'Y'}">
	                    						<td class="ing">사용</td>
	                    					</c:when>	                    				
	                    				</c:choose>

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
						<input type="hidden" name="scm_manager_seq" id="scm_manager_seq" />
						
						<h3 id="title">공급사계정 정보<a class="back_btn" href="#" onclick="supplyInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

						<div class="master_list">
							<div class="tab_box tab_box1">
								<table class="master_02 ">	
									<colgroup>
										<col style="width: 130px">
										<col>					
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">아이디</th>
											<td colspan="3">
												<input type="text" name="scm_manager_id" id="scm_manager_id" readonly="readonly"/>
											</td>	
										</tr>
										<tr>
											<th scope="row">비밀번호</th>
											<td colspan="3">
											<a href="#" class="btn_02" onclick="passwordReset();">비밀번호 초기화</a>
											</td>
										</tr>
										
										<tr>
											<th scope="row">담당자</th>
											<td colspan="3">
												<input type="text" name="scm_manager_name" id="scm_manager_name" readonly="readonly"/>
											</td>														
										</tr>
										<tr>
											<th scope="row">직급</th>
											<td colspan="3">
												<input type="text" name="scm_manager_position" id="scm_manager_position" readonly="readonly"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">부서</th>
											<td colspan="3">
												<input type="text" name="scm_manager_department" id="scm_manager_department" readonly="readonly"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">연락처</th>
											<td colspan="3">
												<input type="text" name="scm_manager_tel" id="scm_manager_tel" readonly="readonly"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">이메일</th>
											<td colspan="3">
												<input type="text" name="scm_manager_email" id="scm_manager_email" readonly="readonly"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">거래처</th>
											<td colspan="3">
												<input type="text" name="cust_name" id="cust_name" readonly="readonly"/>
											</td>															
										</tr>
										<tr>
											<th scope="row">사업자번호</th>
											<td colspan="3">
												<input type="text" name="business_no" id="business_no" readonly="readonly"/>
											</td>															
										</tr>

										<tr>
											<th scope="row">사용여부</th>
											<td colspan="3">
												<div class="sel_wrap">
													<select id="scm_use_yn" name="scm_use_yn"  class="sel_02">
														<option value="Y">사용</option>
														<option value="N">미사용</option>
													</select>
												</div>
											</td>															
										</tr>
									
									</tbody>
								</table>
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
</form>

<script>


function updateSupply(seq){	
	supplyInfoLayer_Open(seq);
}

function supplyInfoLayer_Open(seq){

    var targetUrl = "/supply/getSupplyAccountInfo";

    var param = "";
    var text = "";


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
	        
	        $('#scm_manager_seq').val(info.scm_manager_seq);
			$('#scm_manager_id').val(info.scm_manager_id);
			$('#scm_manager_name').val(info.scm_manager_name);
			$('#scm_manager_position').val(info.scm_manager_position);
			$('#scm_manager_department').val(info.scm_manager_department);
			$('#scm_manager_tel').val(info.scm_manager_tel);
			$('#scm_manager_email').val(info.scm_manager_email);
			$('#scm_use_yn').val(info.scm_use_yn);
			$('#cust_name').val(info.cust_name);
			$('#business_no').val(info.business_no);
			
        },error : function(data){
            alert("세션이 종료되었습니다.\n다시 로그인 해주세요.");
        }

    }); 

	$('#supplyInfoLayer').addClass('view');
	$('html,body').css('overflow','hidden');
	$('.leftNav').removeClass('view');
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

function passwordReset(){
	if(confirm("해당 아이디의 비밀번호를 초기화 하시겠습니까?")){
	    var targetUrl = "/supply/passwordReset";


		param = $("#supplyInfo_Form").serialize();
		    
		$.ajax({
	        type : "post",
	        url : targetUrl,
	        async : false,
	        data: param,
	        success : function(data) {
				if (data.success){
					alert("사업자번호로 초기화 되었습니다.");
				}
				
	        },error : function(data){
	            alert("세션이 종료되었습니다.\n다시 로그인 해주세요.");
	        }

	    }); 

	}
}

</script>
