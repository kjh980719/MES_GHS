<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>


function depthInfoLayer_Open(menu_seq, depth , type, parent_menu_seq, parent_menu_name){
	//메뉴추가 및 수정시 레이어팝업 띄우는 함수
	var text = "";
	if (type == "edit"){
		$('#status').val(type);
		$.ajax({
			type : "get",
			url : '/supervisor/depthInfo',
			async : false,
			data: "menu_seq="+menu_seq,
			success : function(data) {
				var array = data.storeData;
			
				$('#depthInfo_Form').resetForm();
				$('#depthBtn').html("수정");
				$("#display_order").val(array[0].display_order);
				$("#menu_name").val(array[0].menu_name);
				$("input:radio[name=display_yn][value="+array[0].display_yn+"]").attr("checked",true);
				$("#parent_menu_seq").val(array[0].parent_menu_seq);
				$("#parent_menu_name").val(array[0].parent_menu_name);
				$("#program_url").val(array[0].program_url);	
				$("#menu_seq").val(array[0].menu_seq);
				$("#depth").val(array[0].depth);
				$('#layer_title').html("메뉴 수정");
				$('#parent_menu_name').css('display', 'block');
			}
		});
	}else{
		
		
		$('#depthInfo_Form').resetForm();
		$('#depthBtn').html("저장");
		
		$('#parent_menu_seq').val(parent_menu_seq);
		$('#parent_menu_name').val(parent_menu_name);		
		$('#depth').val(depth);		
		$('#layer_title').html("메뉴 추가");
		$('#status').val(type);
	}

	$('#depthInfoLayer').addClass('view');
	$('html,body').css('overflow','hidden');
	$('.leftNav').removeClass('view');
}

function depthInfoLayer_Close(){
	$('#depthInfoLayer').removeClass('view');
	$('html,body').css('overflow','');
	$('.info_edit').removeClass('view');		
}

function editDepthInfo(menu_seq){
	depthInfoLayer_Open(menu_seq, "" ,"edit");
}

function goRegistMenu(depth,parent_menu_seq, parent_menu_name){
	depthInfoLayer_Open("", depth, "regist", parent_menu_seq, parent_menu_name);
}

function viewDepth(menu_seq, nowDepth, menu_name){
	//메뉴명 클릭시 하위 카테고리 내용 불러오는 함수

	var buttonText = "";
	$.ajax({
		type : "get",
		url : '/supervisor/viewDepth',
		async : false,
		data: "menu_seq="+menu_seq,
		success : function(data) {
			var array = data.storeData;

			var text ="";
			
			if(nowDepth == 1) {
				$("#depth_2").empty();
				$("#depth_3").empty();
				
				$("#cate2").css("display", '');
				$("#cate2").removeAttr("onclick");
				$("#cate2").attr("onclick", "javascript:goRegistMenu('2','"+menu_seq+"','"+menu_name+"');");
				
				$("#cate3").css("display", 'none');
				$("#cate3").removeAttr("onclick");
				
			}else if (nowDepth == 2){
				$("#depth_3").empty();
				$("#cate3").css("display", '');
				
				$("#cate3").removeAttr("onclick");
				$("#cate3").attr("onclick", "javascript:goRegistMenu('3','"+menu_seq+"','"+menu_name+"');");
				
			}
			
			if (array.length < 1){
				$("#depth_"+(parseInt(nowDepth)+1)+"").empty();
				return; 
		
			}else{

				
				for (var i in array){
	        		text += "<tr>";
	        		text += "<td><input type='text' readonly class=\"read\" id='new_display_order_"+array[i].depth+"' name='new_display_order_"+array[i].detph+"' value='"+array[i].display_order+"'></input></td>";
	        		text +=	"<td class=\"al\"><a href='#' onclick='viewDepth(\""+array[i].menu_seq+"\",\""+array[i].depth+"\", \""+array[i].menu_name+"\");'>"+array[i].menu_name+"</a></td>";
	        		text += "<td>"+array[i].display_yn+"</td>";
	    			text += "<td><button type='button' class='btn_03 btn_ss' onclick='editDepthInfo("+array[i].menu_seq+");'>수정</button></td>";
	    			text += "</tr>";  	
					
				} 
				$("#depth_"+array[i].depth+"").html(text);

			}
			
		}
	});
}

function updateDepthInfo(){
	
	
    var targetUrl = "";
    if($("#status").val() == "regist") targetUrl = "/supervisor/createMenu";
    if($("#status").val() == "edit") targetUrl = "/supervisor/updateMenu";
    var param = $("#depthInfo_Form").serialize();
	$.ajax({
		type : "post",
		url : targetUrl,
		async : false,
		data: param,
		success : function(data) {
			if($("#status").val() == "regist") {
				if (data.msg == "success"){
					alert('메뉴를 추가하였습니다.');
				}else{
					alert('이미 사용중인 노출순서 이므로 임의로 변경됩니다.');
				}
				depthInfoLayer_Close();
				location.reload();

			}
			if($("#status").val() == "edit") {

				if (data.msg == "success"){
					alert('메뉴를 수정하였습니다.');
					depthInfoLayer_Close();
					location.reload();
				}else if(data.msg == "fail"){
					alert('이미 사용중인 노출순서입니다.');
				}else{
					alert('데이터 에러입니다.');
				}
			}

		}
	
	});	

}
</script>

<style type="text/css">
</style>
<h3 class="mjtit_top">
	메뉴관리
	<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>
<div class="mjinput">
	<div class="mjLeft">
		<ul>
			<li>ㆍ메뉴 수정하시고 재 로그인시 반영이 됩니다.</li>
			<li>ㆍ사용하지 않는 메뉴는 미노출로 전환하시기 바랍니다.</li>
		</ul>
	</div>
</div>
<!--  관리자 메뉴관리-->
<div class="master_list">

	<!--<p class="t16 keyf0_6">※ 1차 카테고리명 표시 클릭하면서 순차적으로 진행해 주세요</p>-->

	<!--ROW   3 col  출력 -->
	<div class="col-box01 adm_menu">
		<!-- 1차 카테고리 시작-->
		<div class="col">
			<h3 >1차 카테고리<button type="button" class="btn_02 btn_s"  onclick="javascript:goRegistMenu('1','0','');">메뉴추가</button></h3>
            
            <div class="add_table">
            <table id="depth_1" class="display" cellspacing="0" cellpadding="0">
            	<colgroup>
            		<col style="width: 57px;">
            		<col style="width:190px;">
            		<col style="width: 47px;">
            		<col style="width: 61px;">
            	</colgroup>
            	<thead>
            		<tr>
            			<th>노출순서</th>
            			<th>카테고리명</th>
            			<th>노출여부</th>
            			<th>관리</th>
            		</tr>
            	</thead>
            	<tbody>
            	<c:forEach items="${depth1}" var="depth1" varStatus="status">
            		<tr>
            			<td><span id="new_display_order_${status.count}"></span><input type="text"  name="new_display_order" value="${depth1.display_order}" readonly class="read"></input></td>            			
            			<td class="al"><a href="#" onclick="viewDepth('${depth1.menu_seq}','${depth1.depth}','${depth1.menu_name}');">${depth1.menu_name}</a></td>
            			<td>${depth1.display_yn}</td>
            			<td><button type="button" class="btn_03 btn_ss" onclick="editDepthInfo(${depth1.menu_seq});" >수정</button></td>
            		</tr>
            	</c:forEach>     
            	</tbody>       	
            </table>
           </div>
		</div>

		<!-- 2차 카테고리 시작 //  1차카테고리 선택시출력-->
		<div class="col">
			<h3>2차 카테고리<button id="cate2" type="button" class="btn_02 btn_s" style="display: none;">메뉴추가</button> </h3>
			 <div class="add_table">
				<table class="display" cellspacing="0" cellpadding="0">
					<colgroup>
	            		<col style="width: 57px;">
	            		<col style="width:190px;">
	            		<col style="width: 47px;">
	            		<col style="width: 61px;">
	            	</colgroup>
	            	<thead>
	            		<tr>
	            			<th>노출순서</th>
	            			<th>카테고리명</th>
	            			<th>노출여부</th>
	            			<th>관리</th>
	            		</tr>
	            	</thead>
	            	<tbody  id="depth_2">
	            	
	            	</tbody>
				</table>			
			</div>
        </div>
        
		<!-- 3차 카테고리 시작-->
		<div class="col">
			<h3>3차 카테고리 <button id="cate3" type="button" class="btn_02 btn_s" style="display: none;">메뉴추가</button></h3>
			<div class="add_table">
	            <table  class="display" cellspacing="0" cellpadding="0">
	            	<colgroup>
	            		<col style="width: 57px;">
	            		<col style="width:190px;">
	            		<col style="width: 47px;">
	            		<col style="width: 61px;">
	            	</colgroup>
	            	<thead>
	            		<tr>
	            			<th>노출순서</th>
	            			<th>카테고리명</th>
	            			<th>노출여부</th>
	            			<th>관리</th>
	            		</tr>
	            	</thead>
	            	<tbody  id="depth_3">
		            	
		            	</tbody>
	            </table> 
	          </div>          
		</div>
	</div>

	
</div>
<!--  관리자 메뉴관리 끝-->

<div class="master_pop master_pop01" id="depthInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="depthInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="depthInfo_Form" name="depthInfo_Form">
						
						<input type="hidden" id="menu_seq" name="menu_seq" />		
						<input type="hidden" id="parent_menu_seq" name="parent_menu_seq"/>
						<input type="hidden" id="depth" name="depth" />
						<input type="hidden" id="status" name="status"/>
						
						<h3 id="layer_title">메뉴 수정<a class="back_btn" href="#" onclick="depthInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
						<div class="master_list">
							<table  class="master_02 master_04">	
								<colgroup>
								<col style="width: 120px"/>
								<col />								
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">노출순서</th>
										<td><input type="text" id="display_order" name="display_order"/></td>															
									</tr>
									<tr>
										<th scope="row">메뉴명</th>
										<td><input type="text"  id="menu_name"  name="menu_name"/></td>
									</tr>
									<tr>	
										<th scope="row">사용여부</th>
										<td>
										<div class="radiobox">
											<label>
											<input type="radio" name="display_yn" value="Y" checked/><span>노출</span>
											</label>
											<label>
											<input type="radio" name="display_yn" value="N" /><span>미노출</span>
											</label>
											</div>
										</td>
									</tr>
									<tr>
										<th scope="row">상위 카테고리</th>
										<td><input type="text" id="parent_menu_name" class="all" name="parent_menu_name" readonly="readonly"/></td>
										
									</tr>
									<tr>
										<th scope="row">url</th>
										<td><input type="text" id="program_url" name="program_url" class="all"/></td>
									</tr>
									
								</tbody>
							</table>
						</div>
						
						
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="depthInfoLayer_Close();">닫기</a>
							<a href="#" id="depthBtn" class="p_btn_02" onclick="updateDepthInfo();">수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="depthInfoLayer_Close();"><span>닫기</span></a>
				</div>
			</div>
		</div>
	</div>
