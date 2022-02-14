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

      



	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}
	
	function codeDetail(code_id){
		comCodeInfoLayer_Open(code_id, "view");
	}
	function newRegister(){
		comCodeInfoLayer_Open("", "");
	}

	function codeDetail2(code_id, code_nm){
		comCodeDetailInfoLayer(code_id, code_nm);
	}

	function comCodeDetailInfoLayer(code_id, code_nm){

		$('#actionButton2').text("수정");

		$.ajax({
			type : "get",
			url : '/code/codeDetailList',
			async : false,
			data: "code_id="+code_id,
			success : function(data) {
				var array = data.storeData;
				var text = "";
				var no = 0;
				var U_chk1 = "";
				var U_chk2 = "";
				$('#codeName').text(code_nm);
				$('#insert_code_id').val(code_id);
				if (array.length > 0) {
					$('#insert_code_nm').val("");
					$('#insert_code_dc').val("");
					for (var i in array){
						if (array[i].use_yn == 'N'){
							U_chk2 = "selected";
							U_chk1 = "";
						}else{
							U_chk1 = "selected";
							U_chk2 = "";
						}


						text += "<tr>";
						text += "<input type='hidden' id='code_"+no+"' name='code' value='"+array[i].code+"'>";
						text += "<td class='num'>"+array[i].no+"</td>";
						text += "<td class='name'><input type='text' id='code_nm_"+no+"' name='code_nm' value='"+array[i].code_nm+"'/></td>";
						text += "<td class='name'><input type='text' id='code_dc_"+no+"' name='code_dc' value='"+array[i].code_dc+"'/></td>";
						text += "<td class='use_yn'><div class=\"sel_wrap_p\"><select id='use_yn_"+no+"' name='use_yn' class='sel_02'>"
						text += "<option value='Y' "+ U_chk1 +">사용</option>"
						text += "<option value='N' "+ U_chk2 +">미사용</option>"
						text += "</select></div></td>";
						if (array[i].system_yn == 'N'){
							text += "<td class='use_yn'><button class='btn_03 btn_s' onclick='manageCodeDetail(\"edit\", \""+no+"\");'>수정</button>";
							text += "<button class='btn_03 btn_s' onclick='deleteCodeDetail(\""+array[i].code+"\");'>삭제</button></td>";
						}else{
							text += "<td class='use_yn'>시스템</td>";
						}
						text += "<tr>";
						no++;
					}

				}

				$('#searchResult').html(text);
			}
		});
		$('#comCodeDetailInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');

	}



	function comCodeInfoLayer_Open(code_id, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#actionButton').text("수정");
			$("#code_id").attr("readonly",true);
			$('#mode').val('edit');
			$.ajax({
	            type : "get",
	            url : '/code/codeInfo',
	            async : false,
	            data: "code_id="+code_id,
	            success : function(data) {
	            	var result = data.storeData;
					$('#code_id').val(result.code_id);
					$('#code_nm').val(result.code_nm);
					$('#code_dc').val(result.code_dc);
					$('#use_yn').val(result.use_yn);

	            }
	         });

		}else{ //신규작성일때
			$('#actionButton').text("등록");
			$("#code_id").attr("readonly",false);
			$('#mode').val('regist');
			$('#code_id').val("");
			$('#code_nm').val("");
			$('#code_dc').val("");
			$('#use_yn').val("Y");
		}

		$('#comCodeInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	

	
	function comCodeInfoLayer_Close(){
		$('#comCodeInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('#img').removeAttr("src");
			
	}
	function comCodeDetailInfoLayer_Close(){
		$('#comCodeDetailInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('#img').removeAttr("src");
	}

	function GoActionButton(){

		var targetUrl = "/code/manageCode" ;
		var mode = $('#mode').val();
		var formData = $('#comCodeInfo_Form').serialize();

		if(isEmpty($('#code_id').val())){
			alert("코드를 입력하세요.");
			return false;
		}
		if(isEmpty($('#code_nm').val())){
			alert("코드명을 입력하세요.");
			return false;
		}
		if(isEmpty($('#code_dc').val())){
			alert("코드설명을 입력하세요.");
			return false;
		}

		$.ajax({
	        type : "post",
			url : targetUrl,
			async : false,
			data : formData,
			success : function(data) {

				if($("#mode").val() == "regist") {

					if (data.msg == "success"){
						alert('생성하였습니다.');
						comCodeInfoLayer_Close();
						location.reload();
					}else{
						alert('이미 사용중인 코드입니다.');
					}

				}
				else if($("#mode").val() == "edit") {

					if (data.msg == "success"){
						alert('수정하였습니다.');
						comCodeInfoLayer_Close();
						location.reload();
					}else{
						alert('데이터 에러입니다.');
					}
				}

			}
		});

	}
</script>

					<h3 class="mjtit_top">
						공통코드관리
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/code/comCodeList">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
				   <div class="srch_day">
                    	

                    </div>
                    <div class="srch_all">
                    	
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="codeID" <c:if test="${search.search_type == 'codeID'}">selected</c:if>>코드</option>
	                            <option value="code_nm" <c:if test="${search.search_type == 'code_nm'}">selected</c:if>>코드명</option>
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string"   onkeyup="if(window.event.keyCode==13){goSearch();}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick='goSearch();'>검색</button>
                              <button type="button" class="btn_01" onclick='goReset();'>초기화</button> 
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
								<col style="width: 185px;"/>
								<col style="width: 350px;"/>
								<col style="width: 115px;"/>
								<col style="width: 115px;"/>
								<col style="width: 115px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>코드</th>
                    				<th>코드명</th>
                    				<th>사용여부</th>
                    				<th>작성일자</th>
									<th>관리</th>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="codeDetail('${list.code_id}'); return;">${list.code_id}</a>
	                    				</td>
	                    				<td class="code">
		                    				<a href="#" onclick="codeDetail('${list.code_id}'); return;">${list.code_nm}</a>
		                    				<a href="#" onclick="codeDetail('${list.code_id}'); return;" class="m_link">${list.code_nm}</a>
	                    				</td>
	       								<td class="ing">${list.use_yn}</td>
	       								<td class="day">${list.reg_date}</td>
										<td class="sang">
											<button type="button" class="btn_03 btn_s" onclick="codeDetail2('${list.code_id}','${list.code_nm}');">관리</button>
										</td>
	                    			</tr>
                    			</c:forEach>
                    			
                    			
								<c:if test="${empty list }">
									<tr><td colspan="6">공통코드가 없습니다.</td></tr>
								</c:if>
                    			
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="comCodeInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="comCodeInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="comCodeInfo_Form" name="comCodeInfo_Form">
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="manager_seq" id="manager_seq"/>


						<h3>코드 등록/조회<a class="back_btn" href="#" onclick="comCodeInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

						<div class="master_list master_listB">
							<table  class="master_02 master_04">	
								<colgroup>
									<col style="width: 140px"/>
									<col />
									<col style="width: 140px"/>
									<col />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">코드</th>
										<td colspan="3"><input type="text" id="code_id" name="code_id" maxlength="6" onkeyup="Upper(this);"/></td>
									</tr>
								    <tr>
										<th scope="row">코드명</th>
										<td colspan="3"><input type="text" id="code_nm" name="code_nm" class="all" maxlength="30"/></td>
									</tr>
									<tr>
										<th scope="row">코드설명</th>
										<td colspan="3"><input type="text" id="code_dc" name="code_dc" class="all" maxlength="30"/></td>
									</tr>
									<tr>
										<th scope="row">사용여부</th>
										<td colspan="3">
											<div class="sel_wrap" >
												<select class="sel_02" id="use_yn" name="use_yn" >
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
							<a href="#" class="p_btn_01" onclick="comCodeInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02"></a> 
						</div>
			
						</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="comCodeInfoLayer_Close();"><span>닫기</span></a>
				</div>

			</div>
		</div>


	</div>

<div class="master_pop master_pop01" id="comCodeDetailInfoLayer">
	<div class="master_body">
		<div class="pop_bg" onclick="comCodeDetailInfoLayer_Close();"></div>
		<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
			<div class="pop_inner">
				<form id="comCodeDetailInfo_Form" name="comCodeDetailInfo_Form">
					<input type="hidden" name="code_id" id="insert_code_id"/>
					<h3 id="codeName"><a class="back_btn" href="#" onclick="comCodeDetailInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
					<div class="master_list master_listB">
						<table  class="master_02 master_04">
							<colgroup>
								<col style="width: 140px"/>
								<col />
								<col >
								<col />
							</colgroup>
							<tbody>
							<tr>
								<th scope="row">코드명</th>
								<td colspan="3"><input type="text" id="insert_code_nm" name="code_nm" class="" maxlength="30"/>
									<button id="button_1" type="button" class="btn_02 btn_s" onclick="manageCodeDetail('regist','');">신규추가</button>
								</td>
							</tr>

							<tr>
								<th scope="row">코드설명</th>
								<td colspan="3">
									<input type="text" id="insert_code_dc" name="code_dc" class="all" maxlength="30"/></td>
								</td>
							</tr>

							</tbody>

						</table>

					</div>

				</form>
					<div class="master_list master_listT">

						<div class="scroll">
							<table class="master_01 master_05 master_vm">
								<colgroup>
									<col style="width: 50px;"/>
									<col style="width: 150px;"/>
									<col style="width: 150px;"/>
									<col style="width: 100px;"/>
									<col style="width: 150px;"/>
								</colgroup>
								<thead>
								<tr>
									<th></th>
									<th>코드명</th>
									<th>코드설명</th>
									<th>사용여부</th>
									<th>관리</th>

								</tr>
								</thead>
								<tbody id="searchResult">

								</tbody>
							</table>
						</div>

				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="comCodeDetailInfoLayer_Close();"><span>닫기</span></a>
				</div>
			</div>
		</div>
	</div>
<form id="codeDetailForm" name="codeDetailForm">
	<input type="hidden" name="mode" id="detailMode"/>
	<input type="hidden" name="code_id" id="modify_code_id" />
	<input type="hidden" name="code" id="modify_code" />
	<input type="hidden" name="code_nm" id="modify_code_nm" />
	<input type="hidden" name="code_dc" id="modify_code_dc" />
	<input type="hidden" name="use_yn" id="modify_use_yn" />
</form>
<script>
	function manageCodeDetail(type,code) {


		var frmB = document.codeDetailForm;
		if (type=="regist"){
			if(isEmpty($('#insert_code_nm').val())){
				alert("코드명을 입력하세요.");
				return false;
			}

			var frmA = document.comCodeDetailInfo_Form;
			frmB.mode.value = 'regist';
			frmB.code_id.value = frmA.insert_code_id.value;
			frmB.code.value = '';
			frmB.code_nm.value = frmA.code_nm.value;
			frmB.code_dc.value = frmA.code_dc.value;
			frmB.use_yn.value = 'Y';
		}else if (type=="edit"){
			if(isEmpty($("#code_nm_"+code).val())){
				alert("코드명을 입력하세요.");
				return false;
			}

			frmB.mode.value = 'edit';
			frmB.code_id.value = $('#insert_code_id').val();
			frmB.code.value = $("#code_"+code).val();
			frmB.code_nm.value = $("#code_nm_"+code).val();
			frmB.code_dc.value = $("#code_dc_"+code).val();
			frmB.use_yn.value = $("#use_yn_"+code+" option:selected").val();
		}

		var targetUrl = "/code/manageCodeDetail";
		var formData = $('#codeDetailForm').serialize();
		console.log(formData);
		$.ajax({
			type : "post",
			url : targetUrl,
			async : false,
			data : formData,
			success : function(data) {

				if(frmB.mode.value == "regist") {

					if (data.msg == "success"){
						alert('생성하였습니다.');
						comCodeDetailInfoLayer_Close();
						codeDetail2(frmB.code_id.value);

					}else if(data.msg == "fail"){
						alert('이미 사용중인 코드입니다.');
					}else{
						alert('데이터 에러입니다.');
					}

				}
				else if(frmB.mode.value == "edit") {

					if (data.msg == "success"){
						alert('수정하였습니다.');
						comCodeDetailInfoLayer_Close();
						codeDetail2(frmB.code_id.value);

					}else{
						alert('데이터 에러입니다.');
					}
				}

			}
		});


	}
	function deleteCodeDetail(code){
		if(isEmpty(code)){
			alert("데이터 오류입니다.");
			return false;
		}
		if (confirm("정말 삭제하시겠습니까?")){
			$.ajax({
				type : "get",
				url : "/code/deleteCodeDetail",
				async : false,
				data : "code="+code+"&code_id="+$('#insert_code_id').val(),
				success : function(data) {
					if (data.storeData == '1'){
						alert('삭제 하였습니다.');
					}else{
						alert('데이터 오류입니다.');
					}
					comCodeDetailInfoLayer_Close();
					codeDetail2($('#insert_code_id').val());
				}

			});
		}

	}
</script>
