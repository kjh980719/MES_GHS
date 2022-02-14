<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript">
	

$(document).ready(function() {
    var setCalendarDefault = function() {
        $("#startDate").datepicker();
		$("#startDate").datepicker('setDate', '${startDate}');
        $("#endDate").datepicker();
		$("#endDate").datepicker('setDate', '${endDate}');
    }

	$(".resetFormBtn").click(function(){
	    // $('#searchForm').resetForm();
	    // setCalendarDefault();
        // searchManagerList();
		location.href='/supervisor/supervisor';
	});

	$(".searchManagerBtn").click(function(){
	    searchManagerList();
	});

	$(".selectSearch").change(function(){
	    searchManagerList();
	});

	$(".enterSearch").keydown(function(event){
	    if (event.keyCode == 13){
	        searchManagerList();
	    }
	});

    var searchManagerList = function () {
		$('#searchText').val($('#searchText').val().trim());
		var rowsPerPage = $('#rowPerPage_1').val();
		$('#rowsPerPage').val(rowsPerPage);
		$('#searchForm').submit();
    }

	$(".registManagerBtn").click(function(){
	    registManager();
	});
	
	var registManager = function () {
	    var targetUrl = "/supervisor/createManager.json";
	    if($("#managerRegistForm input[name='managerSeq']").val() != "")
	        targetUrl = "/supervisor/updateManager.json";

		if(checkManagerValid() && confirm("저장 하시겠습니까?")){//관리자 권한정보 수정후 저장여부를묻는 스크립트
			$(".registManagerBtn").off("click");
			var param = $("#managerRegistForm").serializeObject();
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
					parent.location.reload();
		            $('#managerRegist').popup("hide");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#managerRegistForm input[name='"+response.code+"']").focus();
				}
    			$(".registManagerBtn").on("click", function(){registManager();});
			});
		}
	}
	var checkManagerValid = function () {
	    var valid = true;
   		$.each($("#managerRegistForm .required"), function(){
            if($(this).val() == '') {
	            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
    			$(this).focus();
    			valid = false;
    			return false;
            }
        });
        if(valid) {
			if($('#managerRegistForm input[name="changePasswordYn"]').val() == "Y") {
                //수정시 패스워드 변경
                if(!checkPassword($("#managerRegistForm input[name='newPassword']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#managerRegistForm input[name='newPassword']").focus();
                    return false;
                }
                if($("#managerRegistForm input[name='newPassword']").val() != $("#managerRegistForm input[name='newPasswordConfirm']").val()) {
                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
                    $("#managerRegistForm input[name='newPasswordConfirm']").focus();
                    return false;
                }
            } else if($('#managerRegistForm input[name="managerSeq"]').val() == "") {
                //신규 등록
                if($("#managerRegistForm input[name='managerId']").val().length > 20) {
                    alert("관리자 아이디는 최대 20자 입니다.");
                    $("#managerRegistForm input[name='managerId']").focus();
                    return false;
                }
                if(!checkPassword($("#managerRegistForm input[name='password']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#managerRegistForm input[name='password']").focus();
                    return false;
                }
            }

            if($("#managerRegistForm input[name='managerName']").val().length > 20) {
                alert("이름은 최대 20자 입니다.");
                $("#managerRegistForm input[name='managerName']").focus();
                return false;
            }
            if($("#managerRegistForm input[name='managerEmail']").val().length > 50) {
                alert("이메일은 최대 50자 입니다.");
                $("#managerRegistForm input[name='managerEmail']").focus();
                return false;
            }
            if(!checkEmail($("#managerRegistForm input[name='managerEmail']").val())) {
                alert("올바른 이메일 형식을 입력해 주십시오.");
                $("#managerRegistForm input[name='managerEmail']").focus();
                return false;
            }
        }
	    return valid;
	}
	setCalendarDefault();

    //관리자 신규등록 버튼 클릭
	$(".popLayerManagerRegistBtn").click(function(){
		$("#managerRegistForm input[name='managerSeq']").val("");
		$('#managerRegistForm input[name="managerId"]').prop('readonly', false);
		$('#managerRegistForm #changePasswordBtn').hide();
		$('#managerRegistForm .changePasswordSpan').hide();
		$('#managerRegistForm input[name="password"]').show();
	    $('#managerRegistForm').resetForm();
        /* $('#managerRegist').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#managerRegist .firstFocus').focus();
            }
        }); */
		$('#managerRegist').addClass("view");
		$('html,body').css('overflow','hidden');
		$('#actionText').text("관리자 등록");
	});

    //수정시 비번 변경 버튼 클릭
	$("#managerRegistForm #changePasswordBtn").click(function(){
		$('#managerRegistForm .changePasswordSpan').show();
		$('#managerRegistForm input[name="changePasswordYn"]').val("Y");
	});
    
    
    function useYnFormat(cellValue, option, rowObject){
    	console.log("formatter");
    	return cellValue==1?'Y':'N';
    }
})


</script>

					<h3 class="mjtit_top">
						사용자(사원) 관리
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
					<div class="master_cont">
					  <form id="searchForm" >
						<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
						<div class="srch_day">
	                    	<div class="day_area">
	                    		<div class="day_label">
	                    		<label for="startDate">등록일자</label>
	                    		</div>
	                    		<div class="day_input">
	                    			<input type="text" id="startDate" name="startDate" readonly="" >
	                    		</div>
	                    		<span class="sup">~</span>
	                    		<div class="day_input">
	                    			<input type="text" id="endDate" name="endDate" readonly="" >
	                    		</div>
	                    	</div>
	                    </div>
	                    <div class="srch_all">
	                    	<div class="sel_wrap sel_wrap1">
	                    		 <select name="authGroupSeq" class="sel_02_1">
		                            <c:forEach var="authGroup" items="${authGroupList}" varStatus="status">
										<option value="${authGroup.authGroupSeq}" ${authGroupSeq == authGroup.authGroupSeq?"selected":""}>${authGroup.authGroupName}</option>
									</c:forEach>
	                               </select>
	                    	</div>
	                    	<div class="sel_wrap sel_wrap1">
	                    		 <select name="useYn" class="sel_02">
                                    <option value="Y" ${useYn == "Y"?"selected":""}>사용</option>
                                    <option value="N" ${useYn == "N"?"selected":""}>미사용</option>
                                </select>
	                    	</div>
							<div class="sel_wrap sel_wrap1">
	                    		<select name="searchKeyword" class="sel_02_1">
                                    <option value="all" ${searchKeyword == "all"?"selected":""}>전체</option>
                                    <option value="managerId" ${searchKeyword == "managerId"?"selected":""}>아이디</option>
                                    <option value="managerName" ${searchKeyword == "managerName"?"selected":""}>이름</option>
                                    <option value="managerEmail" ${searchKeyword == "managerEmail"?"selected":""}>이메일</option>
                                </select>
	                    	</div>
	                    	 <input type="text" class="srch_input01 srch_input02 enterSearch" id="searchText" name="searchText">
	                    	 <div class="srch_btn">
	                    	 	 <button type="button" class="btn_02 searchManagerBtn">검색</button>
	                              <button type="button" class="btn_01 resetFormBtn">초기화</button> 
	                          </div>
	                          
	                          <div class="register_btn">
	                        <button type="button" class="btn_02 popLayerManagerRegistBtn" >신규등록</button>
	                        </div>
	                    </div>
					  </form>
					</div>
				
        <!--  관리자  검색시작-->
          


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
		<table class="master_01 master_06" id="userTable">
			<colgroup>
				<col style="width: 55px;"/>
				<col style="width: 115px;"/>
				<col style="width: 115px;"/>
				<col style="width: 100px;"/>
				<col style="width: 160px;"/>
				<col style="width: 90px;"/>
				<col style="width: 100px;"/>
				<col style="width: 115px;"/>
				<col style="width: 100px;"/>
			</colgroup>
			<thead>
			<tr>
				<th>No</th>
				<th>관리자 아이디</th>
				<th>권한그룹</th>
				<th>이름</th>
				<th>이메일</th>
				<th>사용여부</th>
				<th>최근로그인</th>
				<th>등록자</th>
				<th>등록일</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${list}" var="list" varStatus="i">
				<tr>
					<td class="rowIndex"><fmt:formatNumber value="${list.totalCount-(list.rowIndex-1)}" pattern="#,###,###"/></td>
					<td class="managerId">${list.managerId}</td>
					<td class="authGroupName">${list.authGroupName}</td>
					<td class="managerName">${list.managerName}</td>
					<td class="managerEmail">${list.managerEmail}</td>
					<td class="useYn">${list.useYn}</td>
					<td class="loginDate">${list.loginDate}</td>
					<td class="registBy">${list.registBy}</td>
					<td class="registDate">${list.registDate}</td>
					<td class="managerSeq" hidden>${list.managerSeq}</td>
					<td class="description" hidden>${list.description}</td>
				</tr>
			</c:forEach>
			<c:if test="${empty list }">
				<tr><td colspan="9">사용자 정보가 없습니다.</td></tr>
			</c:if>

			</tbody>
		</table>
	</div>
	<div class="mjpaging_comm">
		${dh:pagingB(list[0].totalCount, search.currentPage, search.rowsPerPage, 5, parameter)}
	</div>
</div>

<!-- 관리자 등록 contents -->
<div class="master_pop master_pop01" id="managerRegist">
	<div class="master_body">
		<div class="pop_bg " onclick="orderInfoLayer_Close();"></div>
		<div class="pop_wrap pop_wrap_01 pop_wrap_650">
			<div class="pop_inner">
				<form id="managerRegistForm">
					<input type="hidden" name="managerSeq" id="managerSeq">
					<input type="hidden" name="changePasswordYn" value="N">
					<h3 id="actionText">관리자 등록<a class="back_btn" href="#" ><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
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
									<th scope="row">아이디 <span class="sup">*</span></th>
									<td colspan="3"><input type="text" class="required" name="managerId" id="managerId" placeholder="아이디 입력" maxlength="10" alt="아이디"></td>
								</tr>
								<tr>
									<th scope="row">이름<span class="sup">*</span></th>
									<td colspan="3"><input type="text" class="required" name="managerName" id="managerName" placeholder="이름 입력" maxlength="50" alt="이름"></td>
								</tr>
								<tr>
									<th scope="row">비밀번호<span class="sup">*</span></th>
									<td colspan="3">
										<button type="button" id="changePasswordBtn" class="btn_02 btn_s" >비밀번호변경</button>
										<div class="view_pw changePasswordSpan" style="display:none">
											<div ><label>새 비밀번호</label><input type="password" name="newPassword"  placeholder="새 비밀번호 입력" /></div>
											 <div> <label>새 비밀번호 확인</label><input type="password" name="newPasswordConfirm"  placeholder="새 비밀번호 확인" /></div>	
										</div>
										<input type="password" name="password" placeholder="비밀번호 입력"/>
									</td>			
								</tr>
								<tr>
									<th scope="row">이메일<span class="sup">*</span></th>
									<td colspan="3"><input type="text" name="managerEmail" id="managerEmail"  placeholder="sample@its-new.co.kr" maxlength="50"></td>
								</tr>
								<tr>
									<th scope="row">권한<span class="sup">*</span></th>
									<td colspan="3">
										<div class="sel_wrap">
											<select name="authGroupSeq" class="sel_02">
												<c:forEach var="authGroup" items="${authGroupList}" varStatus="status">
													<option value="${authGroup.authGroupSeq}">${authGroup.authGroupName}</option>
												</c:forEach>
											</select>
										</div>
									</td>			
								</tr>
								<tr>
									<th scope="row">사용여부<span class="sup">*</span></th>
									<td colspan="3">
										<div class="sel_wrap">
											<select name="useYn" class="sel_02">
													<option value="Y">사용</option>
													<option value="N">미사용</option>
											</select>
										</div>
									</td>			
								</tr>
								<tr>
									<th scope="row">비고</th>
									<td colspan="3"><input type="text" name="description" id="description" class="all" placeholder="( 예: 생산관리를 위함 )" maxlength="200"></td>
								</tr>
							</tbody>
						</table>
						
					</div>
					<div class="pop_btn clearfix">
						<a href="#" class="p_btn_01" onclick="orderInfoLayer_Close();">닫기</a>
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
				<%-- <div class="layer_win01" style="width:800px;display: none;" id="managerRegist">
					<div>
						<form id="managerRegistForm">
								<input type="hidden" name="managerSeq" id="managerSeq">
								<input type="hidden" name="changePasswordYn" value="N">
							<h3 class="mjtit_top">
								<span id="actionText">관리자 등록</span>
												</h3>
							
							<!--  관리자 등록-->
							<div class="top_mt10 bottom_mt20">
							<table cellpadding="0" cellspacing="0" class="mjlist_tbl01 mjlist_tbl011">
							<caption>
							 관리자 등록 양식</caption>
								<tr>
									<th scope="row">아이디 <span class="sup">*</span></th>
									<td colspan="3"><input type="text" name="managerId" id="managerId" class="text_box01 w_98 required firstFocus" placeholder="아이디 입력" alt="아이디"/></td>
								</tr>
								<tr>
									<th scope="row">이름 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="managerName" id="managerName" class="text_box01 w_98 required secondFocus" placeholder="이름 입력" alt="이름"/></td>
								</tr>
								<tr>
									<th scope="row">비밀번호 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
									<span style="white-space:nowrap;">
											<button type="button" id="changePasswordBtn" class="btn_orange01_1" >비밀번호변경</button>
											<span class="spbox w_90 changePasswordSpan" style="display:none"><label>ㆍ새 비밀번호</label>
													<input type="password" name="newPassword" class="text_box01 w_20 right_mt15" placeholder="새 비밀번호 입력" /> <label>ㆍ새 비밀번호 확인</label>
													<input type="password" name="newPasswordConfirm" class="text_box01 w_20" placeholder="새 비밀번호 확인" />
											</span>
									</span>
									<input type="password" name="password" class="text_box01 w_60" placeholder="비밀번호 입력" alt="비밀번호" /></td>
								</tr>
								<tr>
									<th scope="row">이메일 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="managerEmail" id="managerEmail" class="text_box01 w_98 required" placeholder="sample@its-new.co.kr" alt="이메일" /></td>
								</tr>
								<tr>
									<th scope="row">권한 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
																		<select name="authGroupSeq" class="sel_box w_20">
																	<c:forEach var="authGroup" items="${authGroupList}" varStatus="status">
																			<c:if test="${authGroup.useYn eq 'Y'}">
											<option value="${authGroup.authGroupSeq}">${authGroup.authGroupName}</option>
											</c:if>
										</c:forEach>
																		</select>
																</td>
								</tr>
								<tr>
									<th scope="row">사용여부 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%">
																		<select name="useYn" class="sel_box w_15">
																				<option value="Y">사용</option>
																				<option value="N">미사용</option>
																		</select>
																</td>
								</tr>
								<tr>
									<th scope="row">비고</th>
									<td class="left_pt10" style="width:80%"><input type="text" name="description" id="description" class="text_box01 w_98" placeholder="( 예: 게시판 운영을 위함 )" /></td>
								</tr>
							</table>

							</div>
												<!-- 하단버튼 -->
												<div class="bottom_mt30 align_cen">
													
													<a href="#" class="btn_blue01 registManagerBtn">저장</a>
													<a href="#" class="btn_gray01 managerRegist_close">닫기</a>
												</div>
						</form>
					</div>
					<div class="group_close">
						<a href="#" class="managerRegist_close"><span>닫기</span></a>
					</div>
			  </div> --%>
              <!-- contents end -->
<script>
	function orderInfoLayer_Close(){
		$('#managerRegist').removeClass("view");
		$('html,body').css('overflow','');
		
	}
	// 테이블의 Row 클릭시 값 가져오기
	$("#userTable tr").click(function(){
		var tdArr = new Array();	// 배열 선언

		// 현재 클릭된 Row(<tr>)
		var tr = $(this);
		var td = tr.children();

		// 반복문을 이용해서 배열에 값을 담아 사용할 수 도 있다.
		td.each(function(i){
			tdArr.push(td.eq(i).text());
		});

		// td.eq(index)를 통해 값을 가져올 수도 있다.
		var rowIndex = td.eq(0).text();
		var managerId = td.eq(1).text();
		var authGroupName = td.eq(2).text();
		var managerName = td.eq(3).text();
		var managerEmail = td.eq(4).text();
		var useYn = td.eq(5).text();
		var loginDate = td.eq(6).text();
		var registBy = td.eq(7).text();
		var registDate = td.eq(8).text();
		var managerSeq = td.eq(9).text();
		var description = td.eq(10).text();
		$('#managerRegistForm').resetForm();
		$('#managerId').val(managerId)
		$('#managerName').val(managerName)
		$('#managerEmail').val(managerEmail)
		$('#description').val(description)
		$('#managerSeq').val(managerSeq)
		$('#managerRegistForm input[name="password"]').hide();
		$('#managerRegistForm #changePasswordBtn').show();
		$('#managerRegistForm .changePasswordSpan').hide();
		$('#managerRegistForm input[name="managerId"]').prop('readonly', true);
		$('#managerRegistForm select[name="authGroupSeq"] option').each(function(){
			if($(this).text() == authGroupName){
				$(this).prop("selected", true);
			}
		})
		$('#managerRegistForm select[name="useYn"] option').each(function(){
			if($(this).val() == useYn){
				$(this).prop("selected", true);
			}
		})
		$('#actionText').text("관리자 수정");
		/* $('#managerRegist').popup({
			focuselement: "secondFocus",
			onopen: function() {
				$('#managerRegist .secondFocus').focus();
			}
		}); */
/* 
		$('#managerRegist').popup("show"); */
		$('#managerRegist').addClass("view");
		$('html,body').css('overflow','hidden');
	});
</script>