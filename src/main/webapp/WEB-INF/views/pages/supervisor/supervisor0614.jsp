<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript">
	

$(document).ready(function() {
    var setCalendarDefault = function() {
        $("#startDate").datepicker();
        $("#startDate").datepicker('setDate', '-1Y');
        $("#endDate").datepicker();
        $("#endDate").datepicker('setDate', 'today');
    }

	$(".resetFormBtn").click(function(){
	    $('#searchForm').resetForm();
	    setCalendarDefault();
        searchManagerList();
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
		
    	var postData = $("#searchForm").serializeObject();
		postData.currentPage = 1;
        postData.rowsPerPage = $("#rowPerPage_1").val();
        
        console.log("검색 :" + postData.authGroupSeq);
        $("#jqGrid_1").jqGrid('setGridParam', {
            postData: JSON.stringify(postData)
        }).trigger("reloadGrid");
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
					$("#jqGrid_1").jqGrid().trigger("reloadGrid");
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
    var colModel = [
        {label: "No", name:"rowIndex", align: "center", width: "10%", sortable: false},
        {label: "관리자 일련번호", name:"managerSeq", align: "center", width: "10%", sortable: false, hidden: true},
        {label: "비고", name:"description", align: "center", width: "10%", sortable: false, hidden: true},
        {label: "관리자 아이디", name:"managerId", align: "center", width: "10%", sortable: false},
        {label: "권한그룹", name:"authGroupName", align: "center", width: "10%", sortable: false},
        {label: "이름", name:"managerName", align: "center", width: "10%", sortable: false},
        {label: "이메일", name:"managerEmail", align: "center", width: "10%", sortable: false},
        {label: "사용여부", name:"useYn", align: "center", width: "10%", sortable: false},
        {label: "최근로그인", name:"loginDate", align: "center", width: "10%", sortable: false},
        {label: "등록자", name:"registBy", align: "center", width: "10%", sortable: false},
        {label: "등록일", name:"registDate", align: "center", width: "10%", sortable: false}
    ];

    var postData = $("#searchForm").serializeObject();
    postData.currentPage = 1;
    postData.rowsPerPage = $("#rowPerPage_1").val();
	console.log("페이지 처음 들어왔을 때 : " + postData.authGroupSeq);
    creatJqGrid("jqGrid_1", "/supervisor/getManagerList", colModel,  postData, "paginate_1", "dataCnt_1", "rowPerPage_1", "gridParent_1");

    //관리자 신규등록 버튼 클릭
	$(".popLayerManagerRegistBtn").click(function(){
		$("#managerRegistForm input[name='managerSeq']").val("");
		$('#managerRegistForm input[name="managerId"]').prop('readonly', false);
		$('#managerRegistForm #changePasswordBtn').hide();
		$('#managerRegistForm .changePasswordSpan').hide();
		$('#managerRegistForm input[name="password"]').show();
	    $('#managerRegistForm').resetForm();
        $('#managerRegist').popup({
            focuselement: "firstFocus",
            onopen: function() {
                $('#managerRegist .firstFocus').focus();
            }
        });
		$('#managerRegist').popup("show");
		$('#actionText').text("관리자 등록");
	});

    //관리자 수정을 위해 row 클릭시
    $("#jqGrid_1").jqGrid('setGridParam', {
        onSelectRow: function(id) {
            var row = $(this).getRowData(id);
            $('#managerRegistForm').resetForm();
		    $('#managerRegistForm input[name="password"]').hide();
		    $('#managerRegistForm #changePasswordBtn').show();
		    $('#managerRegistForm .changePasswordSpan').hide();
			$('#managerRegistForm input[name="managerId"]').prop('readonly', true);
            $('#managerRegistForm select[name="authGroupSeq"] option').each(function(){
                if($(this).text() == row.authGroupName){
                    $(this).prop("selected", true);
                }
            })
		    $('#actionText').text("관리자 수정");
            $('#managerRegist').popup({
                focuselement: "secondFocus",
                onopen: function() {
                    $('#managerRegist .secondFocus').focus();
                }
            });
            $('#managerRegist').popup("show");
			setTableText(row, "managerRegistForm");
        }
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
						관리자 권한
					</h3>
					<div class="align_rgt mjinput">
						<div class="mjRight">
							<button type="button" class="btn_blue01 popLayerManagerRegistBtn">등록</button>
						</div>
					</div>
        <!--  관리자  검색시작-->
                    <div class="top_mt10 bottom_mt20">
                    <form id="searchForm">
                    <table cellpadding="0" cellspacing="0" class="mjlist_tbl01">
                    <caption>관리자 양식</caption>
                        <tr>
                            <th scope="row">권한</th>
                            <td class="left_pt10">
                                <select name="authGroupSeq" class="sel_box w_228 selectSearch">
	                            <c:forEach var="authGroup" items="${authGroupList}" varStatus="status">
									<option value="${authGroup.authGroupSeq}">${authGroup.authGroupName}</option>
								</c:forEach>
                                </select>
                            </td>
                            <th scope="row">발주일자</th>
                            <td class="left_pt10">
                                <input type="text" class="text_box01 m_pointer w_20" id="startDate" name="startDate"/> <span class="keyf08 left_mt10 right_mt5">~</span> <input type="text" class="text_box01 m_pointer w_20" id="endDate" name="endDate"/>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">사용여부</th>
                            <td colspan="4" class="left_pt10">
                                <select name="useYn" class="sel_box w_10 selectSearch">                                  
                                    <option value="Y">사용</option>
                                    <option value="N">미사용</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">키워드</th>
                            <td colspan="4" class="left_pt10">
                                <select name="searchKeyword" class="sel_box w_10">
                                    <option value="all">전체</option>
                                    <option value="managerId">아이디</option>
                                    <option value="managerName">이름</option>
                                    <option value="managerEmail">이메일</option>                                  
                                </select>
                                <input type="text" class="text_box01 w_30 enterSearch" name="searchText" />
                            </td>
                        </tr>
                    </table>
                    </form>
                            <!-- 검색 버튼-->
                            <div class="align_cen pt20">
                                    <button type="button" class="btn_gray01_2 resetFormBtn">초기화</button>
                                    <button type="button" class="btn_blue01 searchManagerBtn" >검색</button>
                            </div>

                    </div><!-- 검색  끝-->


<!-- 리스트 시작-->
                    <div class="mjinput">
											<div class="mjLeft">
												총 <span id="dataCnt_1" class="number3 keyf06"> </span> 건
											</div>
											<div class="mjRight">
												<select name="" id="rowPerPage_1" class=" sel_box">
                            <option value="15">15개씩 보기</option>
                            <option value="30">30개씩 보기</option>
                            <option value="50">50개씩 보기</option>
                            <option value="100">100개씩 보기</option>
                        </select>
											</div>
                        
                    </div>
                    <div class="col" id="gridParent_1">
                    <table id="jqGrid_1" class="display" cellspacing="0" cellpadding="0"></table>
                    <div id="paginate_1" class="mjpaging_comm" style="margin-top: 32px; margin-bottom: 42px"></div>
                    </div>
<!-- 리스트 끝-->
                     <!--하단버튼-->
            
                   <!-- <ul class="mt15">
                    	<li>ㆍ노출순서를 변경하시고 "노출순서 변경"울 클릭하셔야 프론트에 반영이 됩니다.</li>
                    	<li>ㆍ사용하지 않는 메인배너는 미노출로 전환하시기 바랍니다.</li>
                    </ul> -->

<!-- 관리자 등록 contents -->
				<div class="layer_win01" style="width:800px;display: none;" id="managerRegist">
					<div>
						<form id="managerRegistForm">
								<input type="hidden" name="managerSeq">
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
									<th scope="row">아이디 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="managerId" class="text_box01 w_98 required firstFocus" placeholder="아이디 입력" alt="아이디"/></td>
								</tr>
								<tr>
									<th scope="row">이름 <span class="keyf01">*</span></th>
									<td class="left_pt10" style="width:80%"><input type="text" name="managerName" class="text_box01 w_98 required secondFocus" placeholder="이름 입력" alt="이름"/></td>
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
									<td class="left_pt10" style="width:80%"><input type="text" name="managerEmail" class="text_box01 w_98 required" placeholder="sample@its-new.co.kr" alt="이메일" /></td>
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
									<td class="left_pt10" style="width:80%"><input type="text" name="description" class="text_box01 w_98" placeholder="( 예: 게시판 운영을 위함 )" /></td>
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
			  </div>
              <!-- contents end -->