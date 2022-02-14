<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>


function depthInfoLayer_Open(line_seq, depth , type, parent_line_seq, parent_line_name){
	//메뉴추가 및 수정시 레이어팝업 띄우는 함수
	var text = "";
	if (type == "edit"){
		$('#status').val(type);
		$.ajax({
			type : "get",
			url : '/productionLine/depthInfo',
			async : false,
			data: "line_seq="+line_seq,
			success : function(data) {
				var array = data.storeData;
			
				$('#depthInfo_Form').resetForm();
				$('#depthBtn').html("수정");
				$("#display_order").val(array[0].display_order);
				$("#line_name").val(array[0].line_name);
				$("input:radio[name=use_yn][value="+array[0].use_yn+"]").attr("checked",true);
				$("#parent_line_seq").val(array[0].parent_line_seq);
				$("#parent_line_name").val(array[0].parent_line_name);
				$("#etc").val(array[0].etc);
				$("#line_seq").val(array[0].line_seq);
				$("#depth").val(array[0].depth);
				if(array[0].depth == 1){
					$('#layer_title').html("공장 수정");
					$('#depthName').html("공장명");
					$('#parentName').hide();
				}else if(array[0].depth == 2){
					$('#parentName').show();
					$('#layer_title').html("생산라인 수정");
					$('#depthName').html("생산라인명");
				}
				$('#parent_line_name').css('display', 'block');
			}
		});
	}else{
		
		
		$('#depthInfo_Form').resetForm();
		$('#depthBtn').html("저장");
		$('#parent_line_seq').val(parent_line_seq);
		$('#parent_line_name').val(parent_line_name);
		$('#depth').val(depth);
		if(depth == 1){
			$('#parentName').hide();
			$('#layer_title').html("공장 추가");
			$('#depthName').html("공장명");
		}else if(depth == 2){
			$('#parentName').show();
			$('#layer_title').html("생산라인 추가");
			$('#depthName').html("생산라인명");
		}
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

function editDepthInfo(line_seq){
	depthInfoLayer_Open(line_seq, "" ,"edit");
}

function goRegistLine(depth,parent_line_seq, parent_line_name){
	depthInfoLayer_Open("", depth, "regist", parent_line_seq, parent_line_name);
}

function viewDepth(line_seq, nowDepth, line_name){
	//메뉴명 클릭시 하위 카테고리 내용 불러오는 함수

	var buttonText = "";
	$.ajax({
		type : "get",
		url : '/productionLine/viewDepth',
		async : false,
		data: "line_seq="+line_seq,
		success : function(data) {
			var array = data.storeData;

			var text ="";
			
			if(nowDepth == 1) {
				$("#depth_2").empty();
				$("#depth_3").empty();
				
				$("#cate2").css("display", '');
				$("#cate2").removeAttr("onclick");
				$("#cate2").attr("onclick", "javascript:goRegistLine('2','"+line_seq+"','"+line_name+"');");
				
				$("#cate3").css("display", 'none');
				$("#cate3").removeAttr("onclick");
				
			}else if (nowDepth == 2){
				$("#depth_3").empty();
				$("#cate3").css("display", '');
				
				$("#cate3").removeAttr("onclick");
				$("#cate3").attr("onclick", "javascript:goRegistLine('3','"+line_seq+"','"+line_name+"');");
				
			}
			
			if (array.length < 1){
				$("#depth_"+(parseInt(nowDepth)+1)+"").empty();
				return; 
		
			}else{

				
				for (var i in array){
	        		text += "<tr>";
	        		text += "<td><input type='text' readonly class=\"read\" id='new_display_order_"+array[i].depth+"' name='new_display_order_"+array[i].detph+"' value='"+array[i].display_order+"'></input></td>";
	        		text +=	"<td class=\"al\"><a href='#' onclick='viewDepth(\""+array[i].line_seq+"\",\""+array[i].depth+"\", \""+array[i].line_name+"\");'>"+array[i].line_name+"</a></td>";
	        		text += "<td>"+array[i].use_yn+"</td>";
	    			text += "<td><button type='button' class='btn_03 btn_ss' onclick='editDepthInfo("+array[i].line_seq+");'>수정</button></td>";
	    			text += "</tr>";  	
					
				} 
				$("#depth_"+array[i].depth+"").html(text);

			}
			
		}
	});
}

function updateDepthInfo(){

	if (isEmpty($('#display_order').val())){
		alert("노출순서를 입력해주세요.")
		$('#display_order').focus();
		return false;
	}
	if (isEmpty($('#line_name').val())){
		if($("#depth").val() == 1){
			alert("공장명을 입력해주세요.")
		}
		if($("#depth").val() == 2){
			alert("라인명 입력해주세요.")
		}
		$('#line_name').focus();
		return false;
	}

    var targetUrl = "";
    if($("#status").val() == "regist") targetUrl = "/productionLine/createLine";
    if($("#status").val() == "edit") targetUrl = "/productionLine/updateLine";
    var param = $("#depthInfo_Form").serialize();
	$.ajax({
		type : "post",
		url : targetUrl,
		async : false,
		data: param,
		success : function(data) {
			console.log(data);
			if($("#depth").val() == 1){
				if($("#status").val() == "regist") alert('공장을 추가하였습니다.');
				if($("#status").val() == "edit") alert('공장을 수정하였습니다.');
			}
			if($("#depth").val() == 2){
				if($("#status").val() == "regist") alert('생산라인을 추가하였습니다.');
				if($("#status").val() == "edit") alert('생산라인을 수정하였습니다.');
			}

			depthInfoLayer_Close();
		}

	});
	if($("#depth").val() == 2){
		viewDepth($('#parent_line_seq').val(),1,$('#parent_line_name').val());
	}else{
		location.reload();
	}

}
</script>

<style type="text/css">
</style>
<h3 class="mjtit_top">
	생산라인관리
	<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>
<div class="mjinput">
	<div class="mjLeft">
		<ul>
<%--			<li>ㆍ수정하시고 재 로그인시 반영이 됩니다.</li>--%>
			<li>ㆍ사용하지 않는 라인은 미사용으로 전환하시기 바랍니다.</li>
		</ul>
	</div>
</div>
<!--  관리자 메뉴관리-->
<div class="master_list">

	<!--<p class="t16 keyf0_6">※ 1차 카테고리명 표시 클릭하면서 순차적으로 진행해 주세요</p>-->

	<!--ROW   3 col  출력 -->
	<div class="col-box01 adm_menu adm_menu2">
		<!-- 1차 카테고리 시작-->
		<div class="col">
			<h3 >공장<button type="button" class="btn_02 btn_s"  onclick="javascript:goRegistLine('1','0','');">공장추가</button></h3>
            
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
            			<th>공장명</th>
            			<th>사용여부</th>
            			<th>관리</th>
            		</tr>
            	</thead>
            	<tbody>
            	<c:forEach items="${depth1}" var="depth1" varStatus="status">
            		<tr>
            			<td><span id="new_display_order_${status.count}"></span><input type="text"  name="new_display_order" value="${depth1.display_order}" readonly class="read"></input></td>            			
            			<td class="al"><a href="#" onclick="viewDepth('${depth1.line_seq}','${depth1.depth}','${depth1.line_name}');">${depth1.line_name}</a></td>
            			<td>${depth1.use_yn}</td>
            			<td><button type="button" class="btn_03 btn_ss" onclick="editDepthInfo(${depth1.line_seq});" >수정</button></td>
            		</tr>
            	</c:forEach>     
            	</tbody>       	
            </table>
           </div>
		</div>

		<!-- 2차 카테고리 시작 //  1차카테고리 선택시출력-->
		<div class="col">
			<h3>생산라인<button id="cate2" type="button" class="btn_02 btn_s" style="display: none;">생산라인추가</button> </h3>
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
	            			<th>생산라인명</th>
	            			<th>사용여부</th>
	            			<th>관리</th>
	            		</tr>
	            	</thead>
	            	<tbody  id="depth_2">
	            	
	            	</tbody>
				</table>			
			</div>
        </div>
        
		<!-- 3차 카테고리 시작-->
<%--		<div class="col">--%>
<%--			<h3>3차 카테고리 <button id="cate3" type="button" class="btn_02 btn_s" style="display: none;">메뉴추가</button></h3>--%>
<%--			<div class="add_table">--%>
<%--	            <table  class="display" cellspacing="0" cellpadding="0">--%>
<%--	            	<colgroup>--%>
<%--	            		<col style="width: 57px;">--%>
<%--	            		<col style="width:190px;">--%>
<%--	            		<col style="width: 47px;">--%>
<%--	            		<col style="width: 61px;">--%>
<%--	            	</colgroup>--%>
<%--	            	<thead>--%>
<%--	            		<tr>--%>
<%--	            			<th>노출순서</th>--%>
<%--	            			<th>카테고리명</th>--%>
<%--	            			<th>사용여부</th>--%>
<%--	            			<th>관리</th>--%>
<%--	            		</tr>--%>
<%--	            	</thead>--%>
<%--	            	<tbody  id="depth_3">--%>
<%--		            	--%>
<%--		            	</tbody>--%>
<%--	            </table> --%>
<%--	          </div>          --%>
<%--		</div>--%>
<%--	</div>--%>

	
</div>
<!--  관리자 메뉴관리 끝-->

<div class="master_pop master_pop01" id="depthInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="depthInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="depthInfo_Form" name="depthInfo_Form">
						
						<input type="hidden" id="line_seq" name="line_seq" />
						<input type="hidden" id="parent_line_seq" name="parent_line_seq"/>
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
										<th scope="row" id="depthName"></th>
										<td><input type="text"  id="line_name"  name="line_name"/></td>
									</tr>
									<tr>	
										<th scope="row">사용여부</th>
										<td>
										<div class="radiobox">
											<label>
											<input type="radio" name="use_yn" value="Y" checked/><span>사용</span>
											</label>
											<label>
											<input type="radio" name="use_yn" value="N" /><span>미사용</span>
											</label>
											</div>
										</td>
									</tr>
									<tr id="parentName">
										<th scope="row">상위 공장명</th>
										<td><input type="text" id="parent_line_name" class="all" name="parent_line_name" readonly="readonly"/></td>
										
									</tr>
									<tr>
										<th scope="row">etc</th>
										<td><input type="text" id="etc" name="etc" class="all"/></td>
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
