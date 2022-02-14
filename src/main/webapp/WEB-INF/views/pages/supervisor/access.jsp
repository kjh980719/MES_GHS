<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	$(document).ready(function() {
        // var colModel = [
        //     { label : "No", name : "rowIndex", align : "center", width : "10%", sortable : false },
        //     { label : "권한그룹 일련번호", name : "authGroupSeq", align : "center", width : "10%", sortable : false, hidden: true },
        //     { label : "권한 이름", name : "authGroupName", align : "center", width : "10%", sortable : false },
        //     { label : "사용여부", name : "useYn", align : "center", width : "10%", sortable : false },
        //     { label : "등록자 일련번호", name : "registBy", align : "center", width : "10%", sortable : false },
        //     { label : "등록일", name : "registDate", align : "center", width : "10%", sortable : false },
        //     { label : "수정자 일련번호", name : "updateBy", align : "center", width : "10%", sortable : false },
        //     { label : "수정일", name : "updateDate", align : "center", width : "10%", sortable : false }
        // ];
		//
        // var setPostData = {
        //     currentPage : 1,
        //     rowsPerPage : 15
        // };
		//
        // //리스트 생성
        // creatJqGrid("jqGrid_1", "/supervisor/getManagerAuthGroupList", colModel,  setPostData, "paginate_1", "dataCnt_1")

        //리스트 Row 클릭시 상세, 수정 popUp 화면 이동
        $("#jqGrid_1").jqGrid('setGridParam', {
            onSelectRow: function(id) {
                var row = $(this).getRowData(id);
                $("#registManagerForm").resetForm();
		        $("input:radio[name=useYn]").attr("checked", false);
                $("#authGroupSeq").val(row.authGroupSeq);
                $("#registState").val("modify");
                goRegistPage();
            }
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
					$("#jqGrid_1").jqGrid().trigger("reloadGrid");
		            $('#registTreeMenuDiv').popup("hide");
				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
    				$("#registManagerForm input[name='"+response.code+"']").focus();
				}
    			$(".registManagerBtn").on("click", function(){goRegistSubmit();});
    			$(".deleteManagerBtn").on("click", function(){goRegistSubmit("delete");});
			});
		}
	}

    //등록 및 수정화면 분기 및 데이터 셋팅
	function goRegistPage(){
        if($("#menuGuide").val() == null){
    	    getRegistTreeMenu();
    	}
	    var state = $("#registState").val();
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

    	$('#registTreeMenuDiv').popup("show");
	}

	$(window).resize(function(){
        //$("#jqGrid_1").setGridWidth($(this).width() * .850);
    });

    //벨리데이션
    function checkManagerValid(){
        var valid = true;
        $.each($("#registMenuForm .required"), function(){
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
			    $("#registTreeMenu").append("<p id='menuGuide' class='t16 keyf0_6'>※ 접근 메뉴 설정은 메뉴의 상세 설정 하위 메뉴 중 최소 1개 이상 설정하셔야 합니다.</p>");
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
                        $("#"+menuId1+"_Dl").append("<dt id='"+menuId1+"_Dt'><input type='checkbox' id='menuLevel1_"+v.menuSeq+"' name='menuSeq' class='menuLevel1' value='"+v.menuSeq+"' onClick='checkMenu(this);'>"+v.menuName+"</input></dt>");
                        level1++;
                        if((level1%5)==0) {
                            $("#registTreeMenu").append("<hr />"); level1 = 0;
                        }
                    }
                    if(v.menuLevel == 2){
                        menuId2 = "treeMenu_"+v.menuLevel+"_"+v.parentMenuSeq+"_"+v.displayOrder;
                        $("#"+menuId1+"_Dl").append("<dd id='"+menuId2+"_Dd'><input type='checkbox' id='menuLevel2_"+v.menuSeq+"' name='menuSeq' class='menuLevel1_"+v.parentMenuSeq+"' value='"+v.menuSeq+"' onClick='checkMenu(this);'>"+v.menuName+"</input></dd>");   //2레벨 (dl에 생성)
                        $("#"+menuId2+"_Dd").append("<ul id='"+menuId2+"_Ul'></ul>");   //3레벨 (dd에 생성)
                    }
                    if(v.menuLevel == 3){
                        menuId3 = "treeMenu_"+v.menuLevel+"_"+v.parentMenuSeq+"_"+v.displayOrder;
                        $("#"+menuId2+"_Ul").append("<li id='"+menuId3+"_Li'><input type='checkbox' class='menuLevel2_"+v.parentMenuSeq+"' name='menuSeq' value='"+v.menuSeq+"' onClick='checkMenu(this);'>"+v.menuName+"</input></li>");   //3레벨 (ul에 생성)
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
        var selRow = $("#jqGrid_1").getGridParam("selrow");
        var rowParam = $("#jqGrid_1").getRowData(selRow);
        $("#authGroupSeq").val(rowParam.authGroupSeq);
		$("#authGroupName").val(rowParam.authGroupName);
        $("input:radio[name=useYn][value="+rowParam.useYn+"]").attr("checked", true);
        $("#toDate").val(rowParam.updateDate);
        var param = {
            authGroupSeq: rowParam.authGroupSeq
        }
        $.ajax({
		    type : "post",
			url : "/supervisor/getDetailTreeMenu.json",
			contentType: "application/json",
			dataType : "json",
			async : false,
			data: JSON.stringify(param),
			success : function(data){
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

</script>
<h3 class="mjtit_top">
	권한그룹
</h3>

<!-- 리스트 시작-->
<div class="mjinput">
	<div class="mjLeft">
		총 <span id="dataCnt_1" class="number3 keyf06"> </span> 건
	</div>
	<div class="mjRight">
		<button type="button" class="btn_blue01 popLayerManagerRegistBtn">등록</button>
	</div>
		
</div>
<div class="col">
	<table id="jqGrid_1" class="display" cellspacing="0" cellpadding="0"></table>
	<div id="NoData"></div>
    <div id="paginate_1" class="mjpaging_comm" style="margin-top: 32px; margin-bottom: 42px"></div>
</div>
<!-- 리스트 끝-->

<!--하단버튼-->


<!--  관리자 접근제어 등록/수정-->
<div class="layer_win01" style="width:950px;display: none;" id="registTreeMenuDiv">
	<div class="lay_tbl">
    <form id="registManagerForm">
			<input type="hidden" id="registState">
			<input type="hidden" id="authGroupSeq" name="authGroupSeq">
        
            <h3 class="mjtit_top">
               관리자 접근제어 등록</span>
                <a href="#" class="btn_close registTreeMenuDiv_close" ><!--창닫기--></a>
            </h3>
	        <table cellpadding="0" cellspacing="0" class="mjlist_tbl01">
		        <tr>
			        <th scope="row">권한명</th>
			        <td class="left_pt10" style="width:80%">
			            <input type="text" id="authGroupName" name="authGroupName" class="text_box01 w_60 required" placeholder="권한명 입력" alt="권한 명"/>
                    </td>
		        </tr>
		        <tr>
			        <th scope="row">사용여부</th>
			        <td class="left_pt10" style="width:80%">
			            <input type="radio" name="useYn" value="Y" checked/><label class="right_mt20">사용</label>
			            <input type="radio" name="useYn" value="N" /><label>미사용</label>
	                </td>
		        </tr>
		        <tr>
			        <th scope="row">등록일 (최종수정일)</th>
			        <td class="left_pt10" style="width:80%">
                        <input type="text" class="text_box01 w_30" readonly id="toDate" name="toDate"/>
			        </td>
		        </tr>
		        <tr>
			        <th scope="row">접근메뉴</th>
			        <td id="registTreeMenu" class="pt10 valign_top" style="width:80%">
			        </td>
		        </tr>
	        </table>
     

        <!-- 하단버튼 -->
        <div class="bottom_mt30 top_mt10 align_cen">
           
            
            <a href="#" class="btn_blue01 registManagerBtn">저장</a>
						<a href="#" class="btn_gray01 deleteManagerBtn modifyBtn">삭제</a>
						 <a href="#" class="btn_gray01 registTreeMenuDiv_close">닫기</a>
        </div>
    </form>
	</div>
	<div class="group_close">
		<a href="#" class="registTreeMenuDiv_close"><span>닫기</span></a>
	</div>
</div>