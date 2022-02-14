<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<script>


function depthInfoLayer_Open(cat_cd, cat_depth ,type, cat_upper, parent_cat_name){

	//메뉴추가 및 수정시 레이어팝업 띄우는 함수
	var text = "";
	if (type == "edit"){
		$('#status').val(type);
		$.ajax({
			type : "get",
			url : '/product/depthInfo',
			async : false,
			data: "cat_cd="+cat_cd,
			success : function(data) {
				var array = data.storeData;

				$('#depthInfo_Form').resetForm();
				$('#depthBtn').html("수정");
				$("#cat_sort").val(array[0].cat_sort);
				$("#cat_name").val(array[0].cat_name);

				$("#cat_upper").val(array[0].cat_upper);
				$("#parent_cat_name").val(array[0].parent_cat_name);

				$("#cat_key").val(array[0].cat_key);
				$("#cat_depth").val(array[0].cat_depth);
				$('#layer_title').html("카테고리 수정");
				$('#parent_cat_name').css('display', 'block');
			}
		});
	}else{


		$('#depthInfo_Form').resetForm();
		$('#depthBtn').html("저장");

		$('#cat_upper').val(cat_upper);
		$('#parent_cat_name').val(parent_cat_name);
		$('#cat_depth').val(cat_depth);
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

function editDepthInfo(cat_cd){
	depthInfoLayer_Open(cat_cd, "" ,"edit");
}

function goRegistCategory(cat_depth,cat_upper, parent_cat_name){
	depthInfoLayer_Open("", cat_depth, "regist", cat_upper, parent_cat_name);
}

function viewDepth(cat_cd, nowDepth, cat_name){
	//메뉴명 클릭시 하위 카테고리 내용 불러오는 함수

	var buttonText = "";
	$.ajax({
		type : "get",
		url : '/product/viewDepth',
		async : false,
		data: "cat_cd="+cat_cd,
		success : function(data) {
			var array = data.storeData;

			var text ="";

			if(nowDepth == 1) {
				$("#depth_2").empty();
				$("#depth_3").empty();

				$("#cate2").css("display", '');
				$("#cate2").removeAttr("onclick");
				$("#cate2").attr("onclick", "javascript:goRegistCategory('2','"+cat_cd+"','"+cat_name+"');");

				$("#cate3").css("display", 'none');
				$("#cate3").removeAttr("onclick");

			}else if (nowDepth == 2){
				$("#depth_3").empty();
				$("#cate3").css("display", '');

				$("#cate3").removeAttr("onclick");
				$("#cate3").attr("onclick", "javascript:goRegistCategory('3','"+cat_cd+"','"+cat_name+"');");

			}

			if (array.length < 1){
				text += "<tr><td colspan='3'>카테고리가 없습니다.</td></tr>";
				$("#depth_"+(parseInt(nowDepth)+1)+"").html(text);
				return;

			}else{

				for (var i in array){
	        		text += "<tr>";
	        		text += "<td><input type='text' readonly class=\"read\" id='new_cat_sort_"+array[i].cat_depth+"' name='new_cat_sort_"+array[i].cat_depth+"' value='"+array[i].cat_sort+"'></input></td>";
	        		text +=	"<td class=\"al\"><a href='#' onclick='viewDepth(\""+array[i].cat_cd+"\",\""+array[i].cat_depth+"\", \""+array[i].cat_name+"\");'>"+array[i].cat_name+"</a></td>";
	    			text += "<td><button type='button' class='btn_03 btn_ss' onclick='editDepthInfo(\""+array[i].cat_cd+"\");'>수정</button></td>";
	    			text += "</tr>";
				}
				$("#depth_"+array[i].cat_depth+"").html(text);

			}

		}
	});
}

function updateDepthInfo(){



	if (isEmpty($('#cat_sort').val())){
		alert("노출순서를 입력해주세요.")
		$('#cate_sort').focus();
		return false;
	}
	if (isEmpty($('#cat_name').val())){
		alert("카테고리명을 입력해주세요.")
		$('#cat_name').focus();
		return false;
	}
    var targetUrl = "";
    if($("#status").val() == "regist") targetUrl = "/product/createCategory";
    if($("#status").val() == "edit") targetUrl = "/product/updateCategory";
    var param = $("#depthInfo_Form").serialize();
	$.ajax({
		type : "post",
		url : targetUrl,
		async : false,
		data: param,
		success : function(data) {
			if($("#status").val() == "regist") {

				if (!isEmpty(data.msg)){
					alert('카테고리를 등록하였습니다.');
				}else{
					alert('데이터 오류입니다.');
				}
			}
			if($("#status").val() == "edit") {
				if (!isEmpty(data.msg)){
					alert('카테고리를 수정하였습니다.');
				}else{
					alert('데이터 오류입니다.');
				}
			}

			depthInfoLayer_Close();

			if ($('#cat_depth').val() == "1"){
				location.reload();
			}else{
				viewDepth($('#cat_upper').val(),(Number($('#cat_depth').val()) - 1),$('#parent_cat_name').val());
			}

		}

	});

}
</script>

<style type="text/css">
</style>
<h3 class="mjtit_top">
	카테고리관리
	<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>

<!--  관리자 메뉴관리-->
<div class="master_list">

	<!--<p class="t16 keyf0_6">※ 1차 카테고리명 표시 클릭하면서 순차적으로 진행해 주세요</p>-->

	<!--ROW   3 col  출력 -->
	<div class="col-box01 adm_menu">
		<!-- 1차 카테고리 시작-->
		<div class="col">
			<h3 >1차 카테고리<button type="button" class="btn_02 btn_s"  onclick="javascript:goRegistCategory('1','','');">카테고리추가</button></h3>

            <div class="add_table">
            <table id="depth_1" class="display" cellspacing="0" cellpadding="0">
            	<colgroup>
            		<col style="width: 57px;">
            		<col style="width:190px;">
            		<col style="width: 61px;">
            	</colgroup>
            	<thead>
            		<tr>
            			<th>노출순서</th>
            			<th>카테고리명</th>

            			<th>관리</th>
            		</tr>
            	</thead>
            	<tbody>
            	<c:forEach items="${depth1}" var="depth1" varStatus="status">
            		<tr>
            			<td><span id="new_cat_sort_${status.count}"></span><input type="text"  name="new_cat_sort" value="${depth1.cat_sort}" readonly class="read"></input></td>
            			<td class="al"><a href="#" onclick="viewDepth('${depth1.cat_cd}','${depth1.cat_depth}','${depth1.cat_name}');">${depth1.cat_name}</a></td>
            			<td><button type="button" class="btn_03 btn_ss" onclick="editDepthInfo('${depth1.cat_cd}');" >수정</button></td>
            		</tr>
            	</c:forEach>
            	</tbody>
            </table>
           </div>
		</div>

		<!-- 2차 카테고리 시작 //  1차카테고리 선택시출력-->
		<div class="col">
			<h3>2차 카테고리<button id="cate2" type="button" class="btn_02 btn_s" style="display: none;">카테고리추가</button> </h3>
			 <div class="add_table">
				<table class="display" cellspacing="0" cellpadding="0">
					<colgroup>
	            		<col style="width: 57px;">
	            		<col style="width:190px;">

	            		<col style="width: 61px;">
	            	</colgroup>
	            	<thead>
	            		<tr>
	            			<th>노출순서</th>
	            			<th>카테고리명</th>

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
			<h3>3차 카테고리 <button id="cate3" type="button" class="btn_02 btn_s" style="display: none;">카테고리추가</button></h3>
			<div class="add_table">
	            <table  class="display" cellspacing="0" cellpadding="0">
	            	<colgroup>
	            		<col style="width: 57px;">
	            		<col style="width:190px;">
	            		<col style="width: 61px;">
	            	</colgroup>
	            	<thead>
	            		<tr>
	            			<th>노출순서</th>
	            			<th>카테고리명</th>
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

						<input type="hidden" id="cat_key" name="cat_key" />
						<input type="hidden" id="cat_upper" name="cat_upper"/>
						<input type="hidden" id="cat_depth" name="cat_depth" />
						<input type="hidden" id="status" name="status"/>
						
						<h3 id="layer_title">카테고리 수정<a class="back_btn" href="#" onclick="depthInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
						<div class="master_list">
							<table  class="master_02 master_04">	
								<colgroup>
								<col style="width: 120px"/>
								<col />								
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">노출순서</th>
										<td><input type="text" id="cat_sort" name="cat_sort"/></td>
									</tr>
									<tr>
										<th scope="row">카테고리명</th>
										<td><input type="text"  id="cat_name"  name="cat_name"/></td>
									</tr>
									<tr>
										<th scope="row">상위 카테고리</th>
										<td><input type="text" id="parent_cat_name" class="all" name="parent_cat_name" readonly="readonly"/></td>
										
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
