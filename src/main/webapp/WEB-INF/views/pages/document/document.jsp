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
  var clickCheckbox = function() {
   $( "#test" ).prop( "checked", true );
   }

	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}
	
	
	function productAdd(){
		var num = Number($('#documentCount').val());
		num += 1;
		var text ="";

		
		text += "<tr id='document_"+num+"'>";
 		text += "<td class='num pctnum'><a href='#' onclick='documentDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
		text += "<td class='day'><div class='day_input'><input type='text' id='amend_"+num+"' name='amend' readonly></td>";
 		text += "<td class='name'><input type='text' id='mg_name_"+num+"' name='mg_name' placeholder=\"확인자\"></td>";
 		text += "<td class='name'><input type='text' id='bigo_"+num+"' name='bigo' placeholder=\"비고\" ></td>";
 		text += "</tr>";
		
 

		$('#searchResult').append(text);
		$('#amend_'+num).datepicker();
		$('#amend_'+num).datepicker('setDate', '0');
		$('#documentCount').val(num);
	}
	function documentDelete(rowNum){

		$("#document_"+rowNum).remove();

	}
	
	
	
	
	function planDetail(document_code){
		documentInfoLayer_Open(document_code, "view");
	}
	function newRegister(type){
		documentInfoLayer_Open("", type)
	}
	
	
	
	
	

	
	function documentInfoLayer_Open(document_code, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');
			$('statusZone').css('display', '');
			$('#actionButton').html("수정");
			$.ajax({
	            type : "get",
	            url : '/document/view',
	            async : false,
	            data: "document_code="+document_code,
	            success : function(data) {
	            	var array = data.storeData;
	            	console.log(data);
					$('#document_code').val(array[0].document_code);
					$('#document_name').val(array[0].document_name);
					$('#document_type').val(array[0].document_type);
					$('#reg_date').val(array[0].reg_date);
		       		$("#enact_date").datepicker();
		       		$('#enact_date').val(array[0].enact_date);
		       		$('#writer').val(array[0].writer);

		       		var distributorArr = array[0].distributor_to.split(",");

					$("input[name='distributor_to']").each(function(){
                        if (distributorArr.indexOf(this.value) > -1) {
                            $(this).prop("checked",true);
                        }else{
							$(this).prop("checked",false);
						}
					});

		       		if (array.length > 0){
		       			for (var i in array){
		       				document_code = array[i].document_code;
	                		no = array[i].no;
	                		amend = array[i].amend;
	                		mg_name = array[i].mg_name;
	                		bigo = array[i].bigo;

	                 		text += "<tr id='document_"+i+"'>";
	                 		text += "<td class='num pctnum'><a href='#' onclick='documentDelete(\""+i+"\")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
							text += "<td class='day'><div class='day_input'><input type='text' id='amend_"+i+"' name='amend' readonly></td>";
	                 		text += "<td class='name'><input type='text' id='mg_name_"+i+"' value='"+mg_name+"' name='mg_name' placeholder=\"확인자\"></td>";
	                 		text += "<td class='name'><input type='text' id='bigo_"+i+"' value='"+bigo+"' name='bigo' placeholder=\"비고\" ></td>";
	                 		text += "</tr>";
	                	}
		       		}else{
	            		text += "<tr class='all'><td colspan='8'>개정일자 정보가 없습니다.</td></tr>";
	            	}

					$('#searchResult').html(text);
					for (var i in array){
						$('#amend_'+i).datepicker();
						$('#amend_'+i).datepicker('setDate', array[i].amend);
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
			$('#documentInfo_Form').resetForm();

       		$("#enact_date").datepicker();
         	$("#enact_date").datepicker('setDate', '+0');

			$('#writer').val("<%=user.getManagerName()%>");

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

			text += "<tr id='document_1'>";
			text += "<td class='num pctnum'><a href='#' onclick='documentDelete(1)'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
			text += "<td class='day'><div class='day_input'><input type='text' id='amend_1' name='amend' readonly></td>";
			text += "<td class='name'><input type='text' id='mg_name_1' value='' name='mg_name' placeholder=\"확인자\"></td>";
			text += "<td class='name'><input type='text' id='bigo_1' value='' name='bigo' placeholder=\"비고\" ></td>";
			text += "</tr>";

			$('#searchResult').html(text);
			$('#amend_1').datepicker();
			$('#amend_1').datepicker('setDate', "0");
 		}

		$('#documentInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	

	
	function documentInfoLayer_Close(){
		$('#documentInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}
	
	function GoActionButton(){
		var targetUrl = ""
		var status = true;
		var msg = ""
		var mode = $('#mode').val();
		if (mode == 'register') {
			targetUrl = "/document/registerDocument";
			msg = "문서가 등록되었습니다."
		} else if (mode == 'view'){
			targetUrl = "/document/editdocument";
			msg = "문서가 수정되었습니다."
		}
		
		var enact_date = $('#enact_date').val();

		if(isEmpty($('#document_name').val())){
			alert("문서명을 입력해주세요.");
			$('#document_name').focus();
			return false;
		}

		if($("input:checkbox[name=distributor_to]:checked").length == 0 ){
			alert("배포처를 선택해주세요");
			return false;
		}
		if ($('input[name="amend"]').length == 0) {
			alert("개정일자가 없습니다.");
			return false;
		}

		$('input[name="amend"]').each(function (idx, item) {
			amend = $(item).val();
			if (isEmpty(amend)){
				alert("개정일자를 입력해주세요.");
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
        
		for (var i = 0; i < $("input[name='amend']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;		
			tmpMap.amend = $($("input[name='amend']")[i]).val();
			tmpMap.mg_name = $($("input[name='mg_name']")[i]).val();
			tmpMap.bigo = $($("input[name='bigo']")[i]).val();			

			materialList.push(tmpMap)
		}

		var info = [];
		var tmpMap2 = {};
		
		tmpMap2.enact_date = enact_date;
		tmpMap2.document_name = $($("input[name='document_name']")).val();
		var distributor_to = "1";
		$("input[name='distributor_to']").each(function(i){
			console.log(this.checked);
			if(this.checked == true) {
				if (distributor_to == "1") {
					distributor_to = this.value;
				}else {
					distributor_to += "," + this.value;
				}
			}
		});

		tmpMap2.distributor_to = distributor_to;
		tmpMap2.distributor_from = ($("select[name='distributor_from']")).val();
		tmpMap2.document_type = ($("select[name='document_type']")).val();

		if (mode == "view"){
			tmpMap2.document_code = $($("input[name='document_code']")).val();
		}

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
                documentInfoLayer_Close();
                location.reload();
             } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
             }
        });

	}
	
	
</script>

					<h3 class="mjtit_top">
						문서관리대장
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/document/document">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
                  		                    
                    <div class="srch_all">

						<div class="sel_wrap sel_wrap1">
							<select name="search_group" class="sel_02">
								<option value="ALL" <c:if test="${search.search_group eq 'ALL'}">selected</c:if>>전체</option>
								<c:forEach items="${documentGroup}" var="result">
									<option value="${result.code}" <c:if test="${search.search_group eq result.code}">selected</c:if>>${result.code_nm}</option>
								</c:forEach>
							</select>
						</div>
<%--
						<c:forEach items="${documentGroup}" var="result">
							<c:if test="${result.code eq list.distributor_from}">${result.code_nm}</c:if>
						</c:forEach>
                    	--%>
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="DOCUMENT_CODE" <c:if test="${search.search_type == 'DOCUMENT_CODE'}">selected</c:if>>문서 코드</option>                           
	                            <option value="DOCUMENT_NAME" <c:if test="${search.search_type == 'DOCUMENT_NAME'}">selected</c:if>>문서명</option>                           
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
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 70px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>코드</th>
                    				<th>문서명</th>
                    				<th>작성자</th>
                    				<th>작성부서</th>
                    				<th>문서종류</th>
                    				<th>작성일자</th>
                    				<th>관리</th>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="planDetail('${list.document_code}'); return;">${list.document_code}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="planDetail('${list.document_code}'); return;">${list.document_name}</a>
		                    				<a href="#" onclick="planDetail('${list.document_code}'); return;" class="m_link">${list.document_name}</a>
	                    				</td>
	                    				<td class="name">${list.writer}</td>
										<td class="ing">
											<c:forEach items="${documentGroup}" var="result">
												<c:if test="${result.code eq list.distributor_from}">${result.code_nm}</c:if>
											</c:forEach>
										</td>
										<td class="ing">
											<c:forEach items="${documentType}" var="result">
												<c:if test="${result.code eq list.document_type}">${result.code_nm}</c:if>
											</c:forEach>
										</td>
	       								<td class="day">${list.reg_date}</td>
	                    				<td class="num"><button type="button" class="btn_03 btn_s" onclick="deleteDocument('${list.document_code}');">삭제</button></td>
	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="8">문서 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="documentInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="documentInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="documentInfo_Form" name="documentInfo_Form">
						<input type="hidden" name="documentCount" id="documentCount"  value="1"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="manager_seq" id="manager_seq"/>
						<h3>문서관리대장 등록/조회<a class="back_btn" href="#" onclick="documentInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
										<th scope="row">문서 번호</th>
										<td colspan="3"><input type="text" id="document_code" name="document_code" readonly="readonly" class="all"/></td>
									</tr>
									<tr>
										<th scope="row">작성자</th>
										<td>
											<input type="text" id="writer" name="writer" readonly="readonly"/>
										</td>
										<th scope="row">작성일자</th>
										<td>
											<div class="day_input"><input type="text" id="reg_date" name="reg_date" readonly="readonly" class="all"/></div>
										</td>
									</tr>
									<tr>
										<th scope="row">문서명 <span class="keyf01">*</span></th>
										<td colspan="3"><input type="text" id="document_name" name="document_name" class="all" placeholder="문서명"/></td>
									</tr>
									<tr>
										<th scope="row">배포처 <span class="keyf01">*</span></th>
										<td colspan="3">
											<c:forEach items="${documentGroup}" var="result" varStatus="i">
												<div class="chkbox chkbox3">
													<label for="distributor_to_${i.count}">
														<input type="checkbox" id="distributor_to_${i.count}" name="distributor_to"  value="${result.code}"/><span>${result.code_nm}</span>
													</label>
												</div>
											</c:forEach>
										</td>
									</tr>
									<tr>
										<th scope="row">작성부서</th>
										<td>
											<div class="sel_wrap" >
												<select class="sel_02" id="distributor_from" name="distributor_from">
													<c:forEach items="${documentGroup}" var="result" >
															<option value="${result.code}">${result.code_nm}</option>
													</c:forEach>
												</select>
											</div>
										</td>
										<th scope="row">문서 종류</th>
										<td>
											<div id="type" class="sel_wrap" >
												<select class="sel_02" id="document_type" name="document_type">
													<c:forEach items="${documentType}" var="result" >
														<option value="${result.code}">${result.code_nm}</option>
													</c:forEach>
												</select>
											</div>
										</td>

									</tr>
									<tr>
										<th scope="row">제정일자</th>
										<td colspan="1">
											<div class="day_input"><input type="text" id="enact_date" name="enact_date" onchange="dateCheck(this);" /></div>
										</td>
									</tr>

								</tbody>
							</table>
						</div>
						
						
						
						<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_1" type="button" class="btn_02" onclick="productAdd();">개정일자추가</button>
							</div>
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
											<th></th>
											<th>개정일자</th>
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
							<a href="#" class="p_btn_01" onclick="documentInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				
			</div>
		</div>
	</div>

<script>
	

	
	function deleteDocument(document_code){
		
		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/document/delete',
	            async : false,
	            data: "document_code="+document_code,
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

		
	}
</script>