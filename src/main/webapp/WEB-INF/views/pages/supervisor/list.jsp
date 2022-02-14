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
						권한그룹
					<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/supervisor/access">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
                    <div class="srch_all">
                    	<div class="sel_wrap sel_wrap1">
                    		<select name="useYn" class="sel_02">
	                        	<option value="Y" <c:if test="${search.use_yn == 'Y'}">selected</c:if>>사용</option>
	                        	<option value="N" <c:if test="${search.use_yn == 'N'}">selected</c:if>>미사용</option>                                   
                            </select>
                    	</div>
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02">
								<%--
								<option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
                                <option value="DPT_CODE" <c:if test="${search.search_type == 'DPT_CODE'}">selected</c:if>>부서코드</option>
                                --%>
	                            <option value="authGroupName" <c:if test="${search.search_type == 'authGroupName'}">selected</c:if>>권한이름</option>
                                  
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_String" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch();}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick='goSearch();'>검색</button>
                        	<button type="button" class="btn_01">초기화</button>
                          </div>
                          
                          <div class="register_btn">
                        	<button type="button" class="btn_02 popLayerManagerRegistBtn">신규등록</button>
                        </div>
                        
                        
                    </div>
               
                    </form>
 
                    </div><!-- 검색  끝-->
					<!-- 리스트 시작-->
					
                    <div class="master_list ">
                    	<div class="list_set ">
	                    	<div class="set_left">
								총 <span id="dataCnt_1" >${list[0].totalCount}</span> 건
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
                    	<table class="master_01 master_06" id="authTable">
                    		<colgroup>
                    			<col style="width: 55px;"/>
                    			<col style="width: 185px;"/>
                    			<col style="width: 90px;"/>
                    			<col style="width: 115px;"/>
                    			<col style="width: 115px;"/>
                    			<col style="width: 115px;"/>
                    			<col style="width: 115px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>권한이름</th>
                    				<th>사용여부</th>
                    				<th>등록자 일련번호</th>
                    				<th>등록일</th>
									<th>수정자 일련번호</th>
									<th>수정일</th>
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="rowIndex"><fmt:formatNumber value="${list.rowIndex}" pattern="#,###,###"/></td>
	                    				<td class="authGroupName">${list.authGroupName}</td>
	                    				<td class="useYn">${list.useYn}</td>
	                    				<td class="registBy">${list.registBy}</td>
	                    				<td class="registDate">${list.registDate}</td>
	                    				<td class="updateBy">${list.updateBy}</td>
	       								<td class="updateDate">${list.updateDate}</td>
	       								<td class="updateDate" hidden>${list.authGroupSeq}</td>
	                    			</tr>
                    			</c:forEach>
								<c:if test="${empty list }">
									<tr><td colspan="7">그룹 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(list[0].totalCount, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>

<!--  관리자 접근제어 등록/수정-->
<div class="master_pop master_pop01" id="registTreeMenuDiv">
	<div class="master_body">
		<div class="pop_bg " onclick="orderInfoLayer_Close();"></div>
		<div class="pop_wrap pop_wrap_01 ">
			<div class="pop_inner">
				<form id="registManagerForm">
					<input type="hidden" name="managerSeq" id="managerSeq">
					<input type="hidden" name="authGroupSeq" id="authGroupSeq">
					<input type="hidden" name="changePasswordYn" value="N">
					<input type="hidden" id="registState" name="registState" value="">

					<h3 >관리자 접근제어 등록<a class="back_btn" href="#" onclick="orderInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
					<div class="master_list master_listB">
						<table class="master_02 master_04">	
							<colgroup>
								<col style="width: 136px">
								<col >
								<col>
								<col >
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">권한명</th>
									<td colspan="3"><input type="text" id="authGroupName" class="all required" name="authGroupName" placeholder="권한명 입력" maxlength="100"></td>
								</tr>
								<tr>
									<th scope="row">사용여부</th>
									<td colspan="3">
										<div class="radiobox">
											<label>
												<input type="radio" name="useYn" value="Y" checked/><span>사용</span>
											</label>
											<label>
												<input type="radio" name="useYn" value="N" /><span>미사용</span>
											</label>
										</div>
								</tr>
								<tr>
									<th scope="row">등록일 <i>(최종수정일)</i></th>
									<td colspan="3"><input type="text" readonly id="toDate" name="toDate" readonly></td>
								</tr>
								<tr>
									<th scope="row" class="vt">접근메뉴</th>
									<td colspan="3" id="registTreeMenu" class="access_menu"></td>			
								</tr>
							</tbody>
						</table>
						
					</div>
					<div class="pop_btn clearfix">
						<a href="#" class="p_btn_01" onclick="orderInfoLayer_Close();">닫기</a>
						<a href="#" class="p_btn_03 deleteManagerBtn modifyBtn">삭제</a>
						<a href="#" class="p_btn_02 registManagerBtn" >저장</a> 
					</div>
				</form>				
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="orderInfoLayer_Close();"><span>닫기</span></a>
			</div>
		</div>
	</div>
</div>


				<div id="popup" class="layer_pop">
					<div class="handle"></div>
					<iframe src="" id="popupframe"></iframe>							
				</div>
<script>

	// 테이블의 Row 클릭시 값 가져오기
	$("#authTable tr").click(function(){
		var tdArr = new Array();	// 배열 선언

		// 현재 클릭된 Row(<tr>)
		var tr = $(this);
		var td = tr.children();
		let str = "No";

		if ( str == td.eq(0).text() ){
			return false;
		}


		// tr.text()는 클릭된 Row 즉 tr에 있는 모든 값을 가져온다.
		// console.log("클릭한 Row의 모든 데이터 : "+tr.text());

		// 반복문을 이용해서 배열에 값을 담아 사용할 수 도 있다.
		td.each(function(i){
			tdArr.push(td.eq(i).text());
		});

		// console.log("배열에 담긴 값 : "+tdArr);

		// td.eq(index)를 통해 값을 가져올 수도 있다.
		var rowIndex = td.eq(0).text();
		var authGroupName = td.eq(1).text();
		var useYn = td.eq(2).text();
		var registBy = td.eq(3).text();
		var registDate = td.eq(4).text();
		var updateBy = td.eq(5).text();
		var updateDate = td.eq(6).text();
		var authGroupSeq = td.eq(7).text();

		// console.log(authGroupSeq);

		$("#registManagerForm").resetForm();
		$("input:radio[name=useYn]").attr("checked", false);
		$("#authGroupSeq").val(authGroupSeq);
		$("#authGroupName").val(authGroupName);
		$("#oldAuthGroupName").val(authGroupName);
		$("#updateDate").val(updateDate);
		$("#useYn").val(useYn);
		$("#registState").val("modify");
		goRegistPage();
	});


	//등록 버튼 클릭 시 PopUp 화면 이동
	$(".popLayerManagerRegistBtn").click(function(){
		$("#registManagerForm").resetForm();
		$("input:radio[name=useYn]").attr("checked", false);
		$("input:radio[name=useYn][value=Y]").attr("checked", true);
		$("#registState").val("regist");
		goRegistPage();
	});

	//저장(등록, 수정) 버튼 클릭시
	$(".registManagerBtn").on("click", function(){
		var state = $("#registState").val();
		goRegistSubmit(state);
	});

	//삭제버튼 클릭시
	$(".deleteManagerBtn").on("click", function(){
		goRegistSubmit("delete");
	});

	//등록, 수정, 삭제 버튼 이벤트
	function goRegistSubmit(state){
		var targetUrl = "";
		if(state == null){ state = $("#registState").val(); }
		if(state == "modify"){ targetUrl = "/supervisor/updateAuth.json" }
		if(state == "regist"){ targetUrl = "/supervisor/createAuth.json" }
		if(state == "delete"){ targetUrl = "/supervisor/deleteAuth.json" }

		if(checkManagerValid() && confirm("저장 하시겠습니까?")){
			$(".registManagerBtn").off("click");
			$(".deleteManagerBtn").off("click");

			var param = $("#registManagerForm").serializeObject();
			var menuSeqList = [];
			var checkMenuSeq = $("#registManagerForm input[name=menuSeq]:checked").each(function(){
				var menuSeqVal = {
					"menuSeq": $(this).val()
				}
				menuSeqList.push(menuSeqVal);
			});

			param.menuSeqList = menuSeqList;

			$.ajax({
				type : "post",
				url : targetUrl,
				contentType: "application/json",
				dataType : "json",
				async : false,
				data: JSON.stringify(param)
			}).done(function(response) {
				if (response.success) {
					alert("저장되었습니다.");
					$('#registTreeMenuDiv').removeClass("view");
					$('html,body').css('overflow','');
					location.reload();
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
					$("#registManagerForm input[name='"+response.code+"']").focus();
				}
				$(".registManagerBtn").on("click", function(){goRegistSubmit();});
				$(".deleteManagerBtn").on("click", function(){goRegistSubmit("delete");});
			});
		}
	}
	//오늘 날짜 text로 출력
	function setToDay(){
		var today = new Date();
		var dd = today.getDate();
		var mm = today.getMonth()+1;
		var yyyy= today.getFullYear();

		if(dd<10) { dd="0"+dd; }
		if(mm<10) { mm="0"+mm; }

		today = yyyy+"-"+mm+"-"+dd;

		$("#toDate").val(today);
	}

	//등록 및 수정화면 분기 및 데이터 셋팅
	function goRegistPage(){
		if($("#menuGuide").val() == null){
			getRegistTreeMenu();
		}
		var state = $("#registState").val();
		console.log(state);
		if(state == "modify") {
			$("#actionText").text("관리자 접근제어 수정");
			getDetailTreeMenu();
			$(".modifyBtn").css("display", "");
		}
		if(state == "regist") {
			$("#actionText").text("관리자 접근제어 등록");
			setToDay();
			$(".modifyBtn").css("display", "none");
		}

		$('#registTreeMenuDiv').addClass("view");
		$('html,body').css('overflow','hidden');
		
	}

	//벨리데이션
	function checkManagerValid(){
		var valid = true;
		$.each($("#registManagerForm .required"), function(){
			if($(this).val() == '') {
				alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
				$(this).focus();
				valid = false;
				return false;
			}
		});

		return valid;
	}

	//등록 및 수정 화면 진입 시 등록된 사용 메뉴들 호출
	function getRegistTreeMenu(){
		var param = $("#registManagerForm").serializeObject();
		$.ajax({
			type : "post",
			url : "/supervisor/getTreeMenu.json",
			contentType: "application/json",
			dataType : "json",
			async : false,
			data: JSON.stringify(param),
			success : function(data){

				var level1 = 0;
				var menuId1, menuId2, menuId3, colBoxMenu = "";
				$("#registTreeMenu").append("<p id='menuGuide' class='sup'>※ 접근 메뉴 설정은 메뉴의 상세 설정 하위 메뉴 중 최소 1개 이상 설정하셔야 합니다.</p>");
				 for(var i in data.data){
	                    var v = data.data[i];
	                    if(v.menuLevel == 1){
	                        menuId1 = "treeMenu_"+v.menuLevel+"_"+v.displayOrder;
	                        if(level1 == 0){
	                            colBoxMenu = menuId1;
	                            $("#registTreeMenu").append("<div id='"+menuId1+"' class='col-box'></div>");
	                        }
	                        $("#"+colBoxMenu).append("<div id='"+menuId1+"_Div' class='col'></div>");
	                        $("#"+menuId1+"_Div").append("<dl id='"+menuId1+"_Dl'></dl>");
	                        $("#"+menuId1+"_Dl").append("<dt id='"+menuId1+"_Dt'><input type='checkbox' id='menuLevel1_"+v.menuSeq+"' name='menuSeq' class='menuLevel1' value='"+v.menuSeq+"' onClick='checkMenu(this);'><label for='menuLevel1_"+v.menuSeq+"'>"+v.menuName+"</label></dt>");
	                        level1++;
	                        if((level1%3)==0) {
	                            $("#registTreeMenu").append("<div class=\"bar\"></div>"); level1 = 0;
	                        }
	                    }
	                    if(v.menuLevel == 2){
	                        menuId2 = "treeMenu_"+v.menuLevel+"_"+v.parentMenuSeq+"_"+v.displayOrder;
	                        $("#"+menuId1+"_Dl").append("<dd id='"+menuId2+"_Dd'><input type='checkbox' id='menuLevel2_"+v.menuSeq+"' name='menuSeq' class='menuLevel1_"+v.parentMenuSeq+"' value='"+v.menuSeq+"' onClick='checkMenu(this);'><label for='menuLevel2_"+v.menuSeq+"'>"+v.menuName+"</label></dd>");   //2레벨 (dl에 생성)
	                        $("#"+menuId2+"_Dd").append("<ul id='"+menuId2+"_Ul'></ul>");   //3레벨 (dd에 생성)
	                    }
	                    if(v.menuLevel == 3){
	                        menuId3 = "treeMenu_"+v.menuLevel+"_"+v.parentMenuSeq+"_"+v.displayOrder;
	                        $("#"+menuId2+"_Ul").append("<li id='"+menuId3+"_Li'><input type='checkbox' class='menuLevel2_"+v.parentMenuSeq+"' id='menuLevel3_"+v.menuSeq+"' name='menuSeq' value='"+v.menuSeq+"' onClick='checkMenu(this);'><label for='menuLevel3_"+v.menuSeq+"'>"+v.menuName+"</label></li>");   //3레벨 (ul에 생성)
	                    }
				    }
			},
			error : function(e){
				alert("조회시 오류가 발생하였습니다." + e.responseText);
			}
		});
	}

	//상세 및 수정 화면진입 시 정보 호출
	function getDetailTreeMenu(){
		$("input:radio[name=useYn][value="+$("#useYn").val()+"]").attr("checked", true);
		$("#toDate").val($("#updateDate").val());
		var param = {
			authGroupSeq: $("#authGroupSeq").val()
		}
		$.ajax({
			type : "post",
			url : "/supervisor/getDetailTreeMenu.json",
			contentType: "application/json",
			dataType : "json",
			async : false,
			data: JSON.stringify(param),
			success : function(data){
				$("#toDate").val(data.data[0].toDate);
				$("input:radio[name=useYn][value="+data.data[0].useYn+"]").attr("checked", true);

				for(var i in data.data){
					var v = data.data[i];
					$("#registTreeMenu input:checkbox[name=menuSeq]:input[value="+v.menuSeq+"]").prop("checked", true);
				}
			},
			error : function(e){
				alert("조회시 오류가 발생하였습니다." + e.responseText);
			}
		});
	}

	//checkBox 선택 시 상위 및 하위 checked 컨트롤
	function checkMenu(elem){
		var menuId = $(elem).attr("id");
		var menuClass = $(elem).attr("class");
		var menuClass2 = $("#"+menuClass).attr("class");
		var menuChecked =  $("#"+menuId).prop("checked");
		var menu1Checked =  $("#"+menuClass).prop("checked");
		var menu2Checked =  $("#"+menuClass2).prop("checked");
		var checkLength = $("input:checkbox[class="+menuClass+"]:checked").length;
		var checkLength2 = $("input:checkbox[class="+menuClass2+"]:checked").length;
		//1레벨 선택시 전체 선택 or 해제
		if(menuClass == "menuLevel1"){
			var parentId = $("#"+menuId).parent().parent().attr("id");
			if(menuChecked == true){
				$("#"+parentId+" input:checkbox[name=menuSeq]").prop("checked", true);
			}else if(menuChecked == false){
				$("#"+parentId+" input:checkbox[name=menuSeq]").prop("checked", false);
			}
		}
		//2레벨 선택시 전체 선택 or 해제
		if(menuId != null){
			if(menuChecked == true){
				$("."+menuId).prop("checked", true);
			}else if(menuChecked == false){
				$("."+menuId).prop("checked", false);
			}
		}
		//상위 메뉴 체크 or 해제
		if(menu1Checked == false){
			$("#"+menuClass).prop("checked", true);
			if(menu2Checked == false){
				$("#"+menuClass2).prop("checked", true);
			}
		}else if(menu1Checked == true && checkLength == 0 ){
			$("#"+menuClass).prop("checked", false);
			if(menu2Checked == true && checkLength2 == 1){
				$("#"+menuClass2).prop("checked", false);
			}
		}
	}
	function orderInfoLayer_Close(){
		$('#registTreeMenuDiv').removeClass("view");
		$('html,body').css('overflow','');
		
	}

</script>
