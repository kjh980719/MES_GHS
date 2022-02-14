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
		$('#rowsPerPage').val(rowsPerPage);
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}
	

</script>

					<h3 class="mjtit_top">
						부서관리
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/department/list">
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
	                            <option value="DPT_CODE" <c:if test="${search.search_type == 'DPT_CODE'}">selected</c:if>>부서코드</option>
	                            <option value="DPT_NAME" <c:if test="${search.search_type == 'DPT_NAME'}">selected</c:if>>부서명</option>
                                  
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
                    			<col style="width: 185px;"/>
                    			<col style="width: 350px;"/>
                    			<col style="width: 115px;"/>

                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>부서코드</th>
                    				<th>부서명</th>          				
<%--                    				<th>팀장</th>--%>
<%--                    				<th>사원수</th> 				--%>
									<th>등록일자</th>
<%--									<th>관리</th>--%>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="no"><fmt:formatNumber value="${list.no}" pattern="#,###,###"/></td>
	                    				<td class="dpt_code">
	                    					<a href="#" onclick="updateDepartment('${list.dpt_code}','${list.authGroupSeq}'); return;">${list.dpt_code}</a>
	                    				</td>
	                    				<td>
		                    				<a href="#" onclick="updateDepartment('${list.dpt_code}','${list.authGroupSeq}'); return;">${list.dpt_name}</a>
<%--		                    				<a href="#" onclick="updateDepartment('${list.dpt_code}'); return;" class="m_link">${list.dpt_name}</a>--%>
	                    				</td>
<%--	                    				<td class="name">${list.leader}</td>--%>
<%--	                    				<td class="num">${list.empCnt}</td>                    				--%>
	       								<td class="regDate">${list.regDate}</td>
	       								<td class="authGroupSeq" hidden>${list.authGroupSeq}</td>
<%--	       								<td class="code"><button type="button" class="btn_02" onclick="openLayer('${list.dpt_code}');">사원추가</button></td>		 --%>
	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="4">부서 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="departmentInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="departmentInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01" >
					<div class="pop_inner">
					<form id="departmentInfo_Form" name="departmentInfo_Form">
						<input type="hidden" name="mode" id="mode" />
						<input type="hidden" name="old_dpt_code" id="old_dpt_code" />
						<input type="hidden" name="authGroupSeq" id="authGroupSeq" />

						<h3 id="title">부서 등록 및 수정<a class="back_btn" href="#" onclick="departmentInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
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
										<th scope="row">부서코드</th>
										<td colspan="3"><input type="text" id="dpt_code" name="dpt_code" maxlength="10"  onkeyup="codeCheck(this);"/></td>
									</tr>
									<tr>
										<th scope="row">부서명</th>
										<td colspan="3"><input type="text" id="dpt_name" name="dpt_name" class="all" maxlength="20"/></td>
									</tr>

									<tr id="status">
										<th scope="row">사용여부</th>
										<td colspan="3">
											<div class="sel_wrap sel_wrap1">
												<select class="sel_02" id="use_yn" name="use_yn">
													<option value="Y">사용</option>
													<option value="N">미사용</option>
												</select>
											</div>
										</td>
									</tr>

								</tbody>
							</table>
						</div>

						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="departmentInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" class="p_btn_02" onclick="GoActionButton();">등록</a>
						</div>

					</form>

				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="departmentInfoLayer_Close();"><span>닫기</span></a>
				</div>

			</div>
		</div>
	</div>
				<div id="popup" class="layer_pop">
					<div class="handle"></div>
					<iframe src="" id="popupframe"></iframe>							
				</div>
<script>

function openLayer(dpt_code) {

 	if(sessionCheck()){
 		var url = "/department/employeeCreate?dpt_code="+dpt_code;
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
	departmentInfoLayer_Open(0, "","register");
}
function updateDepartment(code, authGroupSeq){
	departmentInfoLayer_Open(code, authGroupSeq, "view");
}

function departmentInfoLayer_Open(code, authGroupSeq, type){

    var targetUrl = "/department/view?dpt_code="+code;

    var param = "";
    var text = "";

	if (type == "view"){ //상세보기
		$('#actionButton').html("수정");
		$('#mode').val(type);
		$('#old_dpt_code').val(code);
		$('#authGroupSeq').val(authGroupSeq);
		$.ajax({
            type : "post",
            url : targetUrl,
            async : false,
            success : function(data) {
            	var info = data.storeData;
				$("#dpt_code").val(info.dpt_code);
				$("#dpt_name").val(info.dpt_name);
				$("#use_yn").val(info.use_yn);
            },error : function(data){
           	 
            	departmentInfoLayer_Close();
	            location.reload(true);
            }

         }); 
	
	}else{
		$('#actionButton').html("등록");
		$('#mode').val(type);
		$('#departmentInfo_Form').resetForm();

	}
	$('#departmentInfoLayer').addClass('view');
	$('html,body').css('overflow','hidden');
	$('.leftNav').removeClass('view');
}


function departmentInfoLayer_Close(){
	$('#departmentInfoLayer').removeClass('view');
	$('html,body').css('overflow','');
	$('.info_edit').removeClass('view');		
}

function GoActionButton(){
	var mode = $('#mode').val();
	var target = '';
	var msg = "";
	var param = "";
    var existYN = "Y";
	
	if (mode == "register"){
		target = "/department/create"; 
		msg = "등록하였습니다.";
	}else if (mode == "view"){
		target = "/department/edit?old_dpt_code="+ $('#old_dpt_code').val();
		msg = "수정하였습니다.";
	}
	 

	if (isEmpty($('#dpt_code').val())){
		alert("부서코드를 입력하세요.");
		return false;
	}
	if (isEmpty($('#dpt_name').val())){
		alert("부서명을 입력하세요.");
		return false;
	}
	if (mode == "register"){
		$.ajax({
	        type : "post",
	        url : "/department/codeCheck?dpt_code="+$('#dpt_code').val(),
	        async : false,
	        success : function(data) {
	        	var info = data.storeData;

	 			if (info != null){
	 				existYN = "Y";
	 			}else{
	 				existYN = "N";
	 			}


	        },error : function(data){
	       	 
	        	departmentInfoLayer_Close();
	            location.reload(true);
	        }

	     }); 
	}else{
		existYN = "N";
	}

	if (existYN == "Y"){
		alert("이미 존재하는 부서코드입니다."); 
		return false;
	}else{
		
		param = $("#departmentInfo_Form").serialize();

	    $.ajax({
	        type : "post",
	        url : target,
	        async : false,
	        data : param,
	        success : function(result) {
				if (result.success) {
					alert(msg);
					departmentInfoLayer_Close();
					location.reload(true);
				} else {
					alert("오류로 정상처리 되지 못하였습니다.\n관리자에게 문의해 주세요.");
					location.reload();
				}
			},
			error : function(xhr, status, error) {
				alert("xhr:" + xhr.readyState + "\n" + "xhr:" + xhr.status
					+ "\n" + "xhr:" + xhr.responseText + "\n" + "status:"
					+ status + "\n" + "error:" + error);
			}
		})
	}
	
	

}
</script>
