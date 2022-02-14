<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript">
	<%
    UserInfo user = Util.getUserInfo();
    %>


	function partlistInfoLayer_Create(){
		var qty = "";
		var status = true;

		if (isEmpty($('#PDT_CODE').val())){
			alert("품목을 선택해주세요.");
			return false;
		}
		if (isEmpty($('#BOM_VERSION').val())){
			alert("BOM버전명을 입력해주세요.");
			return false;
		}

		if ($('input[name="mname"]').length == 0) {
			alert("품목이 없습니다.");
			return false;
		}

		$('input[name="qty"]').each(function (idx, item) {
			qty = $(item).val();
			if (isEmpty(qty)){
				alert("수량을 입력해주세요.");
				status = false;
			}
		});
		if (status == false) return false;

		if ($("input[name='BASIC_YN_CHK']").is(":checked")) {
			$("input[name='BASIC_YN']").val("Y");
		} else {
			$("input[name='BASIC_YN']").val("N");
		}

		if ($("input[name='STOCK_MINUS_YN_CHK']").is(":checked")) {
			$("input[name='STOCK_MINUS_YN']").val("Y");
		} else {
			$("input[name='STOCK_MINUS_YN']").val("N");
		}

		var param = $("#partlistInfo_Form").serializeObject();
		var material = new Array();

		$.each($("#searchResult tr[id^='partlist_']"), function(idx, item){
			var tmpDic = {};
			tmpDic.PDT_CD = $('#PDT_CD').val();
			tmpDic.BOM_VERSION = $('#BOM_VERSION').val();
			tmpDic.BASIC_YN = $('#BASIC_YN').val();
			tmpDic.STOCK_MINUS_YN = $('#STOCK_MINUS_YN').val();
			tmpDic.PRODUCE_QTY = $('#PRODUCE_QTY').val().replace(/,/g, "");
			tmpDic.M_CD = $(item).find("input[id^='mcd_']").val();
			tmpDic.QTY = $(item).find("input[id^='qty_']").val().replace(/,/g, "");
			tmpDic.BIGO = $(item).find("input[id^='bigo_']").val();
			material.push(tmpDic);
		})
		//console.log(material);
		param.material = material;
		//console.log(param.material);
		var value=checkvaild();
		if(value==true){
			$.ajax({
				type : "post",
				url : '/material/createBOM',
				data:  JSON.stringify(param.material),
				contentType :'application/json',
				async : false
			}).done(function(response) {
				console.log(response);
				if (response.success) {
					if (response.msg == 'OK'){
						alert("저장되었습니다.");
						partlistInfoLayer_Close();
						location.reload();
					}else{
						alert(response.msg);
					}

				} else {
					alert("저장시 오류가 발생하였습니다." + response.message);
					$("#partlistInfo_Form input[name='"+response.code+"']").focus();
				}

			});
		}else{

		}
	}

	function checkvaild(){
		var value= true;
		var PDT_CODE=$('#PDT_CODE').val();
		var PDT_NAME=$('#PDT_NAME').val();


		if(isEmpty(PDT_CODE)){
			alert("[품목코드]는 필수항목입니다.");
			value=false;
			console.log(value);
		}else if(isEmpty(PDT_NAME)){
			value="품목이름";
			value=false;
		}else if($('#partlistCount').val() == 0){
			alert("원자재를 입력해주세요.");
			value=false;
			console.log($('#partlistCount').val());
		}
		$.each($("#searchResult tr[id^='partlist_']"), function(idx, item){
			var bom = $(item).find("input[id^='bom_']").val();
			if(bom==0){
				alert("수량이 0개입니다.");
				value=false;
			}

		});
		/* $.each($("#searchResult tr[id^='partlist_']"), function(idx, item){
            var tmpDic = {};
            tmpDic.CODE = $('#CODE').val();
            tmpDic.PDT_NAME = $('#PDT_NAME').val();
            tmpDic.M_CODE = $(item).find("input[id^='mcode_']").val();
            tmpDic.MTR_NAME = $(item).find("input[id^='mname_']").val();
            tmpDic.PDT_STANDARD = $(item).find("input[id^='mstan_']").val();
            tmpDic.UNIT = $(item).find("input[id^='unit_']").val();
            tmpDic.BOM = $(item).find("input[id^='bom_']").val();
            material.push(tmpDic);
            console.log(tmpDic);
        }) */

		return value;
	}

	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		var rowsPerPage = $('#rowPerPage_1').val();
		$('#rowsPerPage').val(rowsPerPage);
		$('#searchForm').submit();
	}

	function goReset(){
		$('#searchForm').resetForm();
	}

	function newRegister(){
		bomInfoLayer_Open(0, "regist");
	}

	function partlistInfoLayer_Close(){
		$('#partlistInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');
	}

	function viewBomDetail(CODE, type){
		bomInfoLayer_Open(CODE, type);
	}


	function materialDelete(rowNum){

		$("#partlist_"+rowNum).remove();
		$('#partlistCount').val($('#partlistCount').val()-1);

	}

	function productSearch(){
		if (sessionCheck()){
			var url = "/popPartlistProduct/popPartlistProductList";

			$('#material_popup').css('display','block');
			$('#material_popupframe').attr('src',url);
			$('html,body').css('overflow','hidden');
		}else{
			location.reload();
		}

	}

	function materialSearch(){
		if (sessionCheck()){
			if (!isEmpty($('#PDT_CODE').val())){
				var url = "/order/popProductList?type=partlist";
				$('#product_popup').css('display','block');
				$('#product_popupframe').attr('src',url);
				$('html,body').css('overflow','hidden');
			}else{
				alert("품목이 없습니다.");
				$('#PDT_CODE').focus();
				return false;
			}
		}
		else{
			location.reload();
		}
	}

	function productSearch_close(){
		$('#product_popup').css('display','none');
		$('#product_popupframe').removeAttr('src');
		$('html,body').css('overflow','');
	}

	function materialSearch_close(){
		$('#material_popup').css('display','none');
		$('#material_popupframe').removeAttr('src');
		$('html,body').css('overflow','');
	}

	function popPartlistProductAdd(data){


		var pdt = data.storeData;
		$('#PDT_CD').val(pdt.PDT_CD);
		$('#PDT_CODE').val(pdt.PDT_CODE);
		$('#PDT_NAME').val(pdt.PDT_NAME);


	}

	function popPartlistMaterialAdd(data){


		var pdt = data.storeData;
		var NO = Number($('#partlistCount').val());
		NO += 1;
		var text ="";

		text += "<tr id='partlist_"+NO+"' class='partlist_"+NO+"'>";
		text += "<td class='no'><input type='text' value='"+NO+"' readonly></td>";
		text += "<td class='code'><input type='hidden' id='mcd_"+NO+"' name='mcd' value='"+pdt.PDT_CD+"'>";
		text += "<span class=\"un_down\"></span><input type='text' id='mtr_code_"+NO+"' name='mtr_code' value='"+pdt.PDT_CODE+"' readonly></td>";
		text += "<td class='prod'><input type='text' id='mname_"+NO+"' name='mname' value='"+pdt.PDT_NAME+"' readonly></td>";
		text += "<td class='prod'><input type='text' id='mstan_"+NO+"' name='mstan' value='"+pdt.PDT_STANDARD+"' readonly></td>";
		text += "<td class='name'><input type='text' id='unit_"+NO+"' name='unit' value='"+pdt.UNIT+"' readonly></td>";
		text += "<td class='qty'><input type='text' id='qty_"+NO+"' name='qty' value='1' onkeyup='this.value=this.value.replace(/[^0-9.]/g,\"\");'></td>";
		text += "<td class='name'><input type='text' id='bigo_"+NO+"' name='bigo' value=''></td>";
		text += "<td class='manage'><a href='#' onclick='materialDelete(\""+NO+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>"
		text += "</tr>";

		$('#searchResult').prepend(text);
		$('#partlistCount').val(NO);

	}

	function bomInfoLayer_Open(PDT_CD, type, BOM_VERSION){
		var text = "";
		var targetUrl = "";
		var data = "";
		if (isEmpty(BOM_VERSION)) {
			targetUrl='/material/getBomDetail';
			data = "PDT_CD="+PDT_CD;
		} else{
			targetUrl='/material/getBomDetail2' ;
			data = "PDT_CD="+PDT_CD+"&BOM_VERSION="+BOM_VERSION;
		}

		if (type=="view"){ //상세보기
			$.ajax({
				type : "get",
				url : targetUrl,
				async : false,
				data: data,
				success : function(data) {
					var array = data.storeData;
					var NO="";
					var PDT_CD="";
					var PDT_CODE="";
					var PDT_NAME="";
					var M_CD="";
					var MTR_CODE="";
					var MTR_NAME="";
					var MTR_STANDARD="";
					var UNIT="";
					var QTY="";
					var BOM_VERSION="";
					var PRODUCE_QTY="";
					var BIGO ="";
					var underCount ="";
					var BASIC_YN = "";
					var STOCK_MINUS_YN = "";
					var OLD_BOM_VERSION = "";

					if (array.length > 0) {
						BASIC_YN = array[0].BASIC_YN;
						STOCK_MINUS_YN = array[0].STOCK_MINUS_YN;

						NO = array[0].NO;
						PDT_CD = array[0].PDT_CD;
						PDT_CODE = array[0].PDT_CODE;
						PDT_NAME = array[0].PDT_NAME;
						BOM_VERSION = array[0].BOM_VERSION;
						OLD_BOM_VERSION =  array[0].BOM_VERSION;
						PRODUCE_QTY = array[0].PRODUCE_QTY;

						if (BASIC_YN == "Y") {
							$("input[name='BASIC_YN_CHK']").prop("checked", true);
						} else {
							$("input[name='BASIC_YN_CHK']").prop("checked", false);
						}

						if (STOCK_MINUS_YN == "Y") {
							$("input[name='STOCK_MINUS_YN_CHK']").prop("checked", true);
						} else {
							$("input[name='STOCK_MINUS_YN_CHK']").prop("checked", false);
						}


						$('#PDT_CD').val(PDT_CD);
						$('#PDT_CODE').val(PDT_CODE);
						$('#PDT_NAME').val(PDT_NAME);
						$('#BOM_VERSION').val(BOM_VERSION);
						$('#OLD_BOM_VERSION').val(OLD_BOM_VERSION);
						$('#PRODUCE_QTY').val(PRODUCE_QTY);

						for (var i in array){

							NO = array[i].NO;
							TOTAL = array[i].TOTAL;
							M_CD = array[i].M_CD;
							MTR_CODE = array[i].MTR_CODE;
							MTR_NAME = array[i].MTR_NAME;
							MTR_STANDARD = array[i].MTR_STANDARD;
							UNIT = array[i].UNIT;
							QTY = array[i].QTY;
							BIGO = array[i].BIGO;
							underCount = array[i].UNDER_COUNT;
							text += "<tr id='partlist_"+NO+"' class='partlist_"+NO+"'>";
							text += "<td class='no'><input type='text' value='"+(TOTAL + 1 - NO)+"' readonly></td>";
							text += "<td class='code'><input type='hidden' id='mcd_"+NO+"' name='mcd' value='"+M_CD+"'>";
							if(underCount > 0) {
								text += "<a href='#' class=\"down\" onclick='underView(\""+M_CD+"\", \"1\", \""+NO+"\", \"partlist_"+NO+"\", \"partlist_"+NO+"\")'><img src='/images/common/sel_arrow.png'></a><input type='text' id='mtr_code_"+NO+"' name='mtr_code' value='"+MTR_CODE+"' readonly></td>";
							}else {
								text += "<span class=\"un_down\"></span><input type='text' id='mtr_code_"+NO+"' name='mtr_code' value='"+MTR_CODE+"' readonly></td>";
							}
							text += "<td class='prod'><input type='text' id='mname_"+NO+"' name='mname' value='"+MTR_NAME+"' readonly></td>";
							text += "<td class='prod'><input type='text' id='mstandard_"+NO+"' name='mstan' value='"+MTR_STANDARD+"' readonly></td>";
							text += "<td class='name'><input type='text' id='unit_"+NO+"' name='unit' value='"+UNIT+"' readonly></td>";
							text += "<td class='qty'><input type='text' id='qty_"+NO+"' name='qty' value='"+QTY+"' onkeyup='this.value=this.value.replace(/[^0-9.]/g,\"\");'></td>";
							text += "<td class='name'><input type='text' id='bigo_"+NO+"' name='bigo' value='"+BIGO+"'></td>";
							text += "<td class='manage'><a href='#' onclick='materialDelete(\""+NO+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>"
							text += "</tr>";
						}
						$('#partlistCount').val(NO);
					}else{
						text += "<tr class='all'><td colspan='8'>품목정보가 없습니다.</td></tr>";
					}
					$('#addButton').css('display','none');
					$('#partlistChoice').text('수정');
					$('#searchResult').html(text);
					$('#partlistChoice').attr("onclick","partlistInfoLayer_Update()");
					$("#button_1").hide();

				}

			});

		}else{ //신규작성일때
			$('#partlistCount').val('0');
			$('#addButton').css('display','block');
			$('#partlistChoice').text('등록');
			$('#searchResult').empty();
			$('#partlistInfo_Form').resetForm();
			$('#searchResult').html(text);
			$('#partlistChoice').attr("onclick","partlistInfoLayer_Create()");
			$("#button_1").show();

		}

		$('#partlistInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}


	function partlistInfoLayer_Close(){
		$('#partlistInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');
	}

	function versionInfoLayer_Open(PDT_CD){
		var text = "";

		$.ajax({
			type: "get",
			url: '/material/getBomVersionList',
			async: false,
			data: "PDT_CD=" + PDT_CD,
			success: function (data) {
				var array = data.storeData;

				if (array.length > 0) {
					for (var i in array) {
						text += "<tr>";
						text += "<td class='manage'>" + array[i].NO + "</td>";
						text += "<td class='manage'>" + array[i].BOM_VERSION + "</td>";
						text += "<td class='manage'>" + array[i].PDT_CODE + "</td>";
						text += "<td class='manage'>" + array[i].PDT_NAME + " </td>";
						text += "<td class='manage'>" + array[i].PDT_STANDARD + "</td>";
						text += "<td class='manage'>" + comma(array[i].CNT) + "</td>"
						text += "<td class='manage'>" + array[i].BASIC_YN_TXT +"</td>"
						text += "<td class='manage'><button type='button' class='btn_03 btn_s' onclick='viewBomVersionDetail(\""+array[i].PDT_CD+"\",\""+array[i].BOM_VERSION+"\");'>조회</button></td>";
						text += "</tr>";
					}
				} else {
					text += "<tr class='all'><td colspan='8'>품목정보가 없습니다.</td></tr>";
				}


				$('#searchResult2').html(text);

			}

		});
		$('#versionInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}

	function versionInfoLayer_Close(){
		$('#versionInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
	}

	function viewBomVersionDetail(PDT_CD,BOM_VERSION){
		bomInfoLayer_Open(PDT_CD,'view', BOM_VERSION);
	}

	function underView(PDT_CD, DEPTH, NUM, ID, CLS){

			if (DEPTH == 1){
				if ($('.'+ID+'_'+1).length){
					if ($('.'+ID+'_'+1).css("display") == "none") {
						$('.'+ID+'_'+1).css("display", "");
					} else {
						$('.'+ID+'_'+1).css("display", "none");
						$("tr[class*='"+ID+"_"+1+"']").css("display", "none");
					}
					return false;
				}
			}else{
				if ($('.'+ID).length){
					if ($('.'+ID).css("display") == "none") {
						$('.'+ID).css("display", "");
					} else {
						$('.'+ID).css("display", "none");
						$("tr[class*='"+ID+"']").css("display", "none");
					}
					return false;
				}
			}




		$.ajax({
			type: "get",
			url: '/material/getBomDetail',
			async: false,
			data: "PDT_CD=" + PDT_CD,
			success: function (data) {
				var text = "";
				var array = data.storeData;
				var tag_id = "";
				var tag_cls = "";
				for (var i in array){
					NO = array[i].NO;
					M_CD = array[i].M_CD;
					PARENT_CD = array[i].PDT_CD;
					MTR_CODE = array[i].MTR_CODE;
					MTR_NAME = array[i].MTR_NAME;
					MTR_STANDARD = array[i].MTR_STANDARD;
					UNIT = array[i].UNIT;
					QTY = array[i].QTY;
					underCount = array[i].UNDER_COUNT;


					if (DEPTH == 1 ){
						tag_id = ID+"_"+NUM+"_"+NO;
					}else{
						tag_id = ID+"_"+NO;
					}
					tag_cls = CLS+"_"+NUM;
					text += "<tr id='"+tag_id+"' class='"+tag_cls+"'>";
					text += "<td></td>";
					text += "<td class='code'>";
					if (underCount > 0){
						text += "<a href='#' class='down down"+DEPTH+"' onclick='underView(\""+M_CD+"\", \""+(Number(DEPTH)+1)+"\", \""+NO+"\", \""+tag_id+"\", \""+tag_cls+"\")'><img src='/images/common/sel_arrow.png'></a><input type='text' value='"+MTR_CODE+"' readonly></td>";
					}else{
						text += "<span class='un_down un_down"+DEPTH+"'></span><input type='text' value='"+MTR_CODE+"' readonly></td>";
					}
					text += "<td class='prod'><input type='text' value='"+MTR_NAME+"' readonly></td>";
					text += "<td class='prod'><input type='text' value='"+MTR_STANDARD+"' readonly></td>";
					text += "<td class='name'><input type='text' value='"+UNIT+"' readonly></td>";
					text += "<td class='qty'><input type='text' value='"+QTY+"' readonly></td>";
					text += "<td></td>";
					text += "<td></td>";
					text += "</tr>";
				}

				$('#'+ID).after(text);


			}
		});

	}

	function partlistInfoLayer_Update(){
		var qty = "";
		var status = true;

		if (isEmpty($('#PDT_CODE').val())){
			alert("품목을 선택해주세요.");
			return false;
		}
		if (isEmpty($('#BOM_VERSION').val())){
			alert("BOM버전명을 입력해주세요.");
			return false;
		}

		if ($('input[name="mname"]').length == 0) {
			alert("품목이 없습니다.");
			return false;
		}

		$('input[name="qty"]').each(function (idx, item) {
			qty = $(item).val();
			if (isEmpty(qty)){
				alert("수량을 입력해주세요.");
				status = false;
			}
		});
		if (status == false) return false;

		if ($("input[name='BASIC_YN_CHK']").is(":checked")) {
			$("input[name='BASIC_YN']").val("Y");
		} else {
			$("input[name='BASIC_YN']").val("N");
		}

		if ($("input[name='STOCK_MINUS_YN_CHK']").is(":checked")) {
			$("input[name='STOCK_MINUS_YN']").val("Y");
		} else {
			$("input[name='STOCK_MINUS_YN']").val("N");
		}

		var param = $("#partlistInfo_Form").serializeObject();
		var material = new Array();

		$.each($("#searchResult tr[id^='partlist_']"), function(idx, item){
			var tmpDic = {};
			tmpDic.PDT_CD = $('#PDT_CD').val();
			tmpDic.OLD_BOM_VERSION = $('#OLD_BOM_VERSION').val();
			tmpDic.BOM_VERSION = $('#BOM_VERSION').val();
			tmpDic.BASIC_YN = $('#BASIC_YN').val();
			tmpDic.STOCK_MINUS_YN = $('#STOCK_MINUS_YN').val();
			tmpDic.PRODUCE_QTY = $('#PRODUCE_QTY').val().replace(/,/g, "");
			tmpDic.M_CD = $(item).find("input[id^='mcd_']").val();
			tmpDic.QTY = $(item).find("input[id^='qty_']").val().replace(/,/g, "");
			tmpDic.BIGO = $(item).find("input[id^='bigo_']").val();


			material.push(tmpDic);
		})
		param.material = material;
		$.ajax({
			type : "post",
			url : '/material/updateBOM',
			contentType :'application/json',
			async : false,
			data: JSON.stringify(param.material)
		}).done(function(response) {
			if (response.success) {
				if (response.msg == 'OK'){
					alert("저장되었습니다.");
					partlistInfoLayer_Close();
					location.reload();
				}else{
					alert(response.msg);
				}
			} else {
				alert("저장시 오류가 발생하였습니다." + response.message);
				$("#partlistInfo_Form input[name='"+response.code+"']").focus();
			}
		});

	}

	function partlistInfo_delete(PDT_CD){

		var param = {};
		param.PDT_CD=PDT_CD;
		if(confirm("정말 삭제하시겠습니까 ?") == true){
			$.ajax({
				type : "post",
				url : '/partlist/deletePartlist',
				contentType :'application/json',
				async : false,
				data: JSON.stringify(param)
			}).done(function(response) {
				if (response.success) {
					alert("삭제되었습니다.");
					partlistInfoLayer_Close();
					location.reload();
				} else {
					alert("삭제시 오류가 발생하였습니다." + response.message);
				}
			});
		}
		else{
			return ;
		}




	}

</script>
<style>

	ul.tabs{
		margin: 0px;
		padding: 0px;
		list-style: none;
	}
	ul.tabs li{
		background: none;
		color: #222;
		display: inline-block;
		padding: 10px 15px;
		cursor: pointer;
	}

	ul.tabs li.current{
		background: #ededed;
		color: #222;
	}

	.tab-content{
		display: none;
		background: #ededed;
		padding: 15px;
	}

	.tab-content.current{
		display: inherit;
	}

</style>

<h3 class="mjtit_top">
	BOM관리
	<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>

<!--  관리자  검색시작-->
<div class="master_cont">
	<form id="searchForm" action="/partlist/partlist">
		<input type="hidden" value="" name="rowsPerPage" id="rowsPerPage"/>
		<div class="srch_all">
			<div class="sel_wrap sel_wrap1">
				<select name="search_type" class="sel_02">
					<option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
					<option value="CODE" <c:if test="${search.search_type == 'CODE'}">selected</c:if>>품목코드</option>
					<option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목명</option>
				</select>
			</div>

			<input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}" />
			<div class="srch_btn">
				<button type="button" class="btn_02" onclick="goSearch();">검색</button>
				<button type="button" class="btn_01">초기화</button>
			</div>

			<div class="register_btn">
				<button type="button" class="btn_02" onclick="newRegister()">신규등록</button>
			</div>
		</div>

	</form>

</div><!-- 검색  끝-->


<!-- 리스트 시작-->

<div class="master_list ">
	<div class="list_set ">
		<div class="set_left">

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
	<div class="master_list scroll">
		<table class="master_01">
			<colgroup>
				<col style="width: 55px;"/>
				<col style="width: 115px;"/>
				<col style="width: 280px;"/>
				<col style="width: 125px;"/>
				<col style="width: 100px;"/>
				<col style="width: 100px;"/>
				<col style="width: 80px;"/>
			</colgroup>
			<thead>
			<tr>
				<th>No</th>
				<th>품목코드</th>
				<th colspan="2">품목명</th>
				<th>BOM버전개수</th>
				<th>소모품목개수</th>
				<th>버전조회</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${list}" var="list">
				<tr>
					<td class="no"><fmt:formatNumber value="${total +1 - list.no}" pattern="#,###,###"/></td>
					<td class="code">
						<a href="#" onclick="viewBomDetail('${list.PDT_CD}','view');">${list.PDT_CODE}</a>
						<a href="#" onclick="viewBomDetail('${list.PDT_CD}','view');" class="m_link">${list.PDT_CODE}</a>
					</td>
					<td class="sang t_left" colspan="2">
						<a href="#" onclick="viewBomDetail('${list.PDT_CD}','view');">${list.PDT_NAME}</a>
					</td>
					<td class="number">${list.BOM_CNT}</td>
					<td class="number">${list.CNT}</td>
					<td class="name">
						<button type="button" class="btn_03 btn_s" onclick="versionInfoLayer_Open('${list.PDT_CD}');">조회</button>
					</td>
				</tr>
			</c:forEach>
			<c:if test="${empty list }">
				<tr><td colspan="7">BOM 정보가 없습니다.</td></tr>
			</c:if>

			</tbody>
		</table>
		<div class="mjpaging_comm">
			${dh:pagingB(total, search.currentPage, search.rowsPerPage, 10, parameter)}
		</div>
	</div>
</div>



<div class="master_pop master_pop01" id="versionInfoLayer">
	<div class="master_body">
		<div class="pop_bg" onclick="versionInfoLayer_Close();"></div>
		<div class="pop_wrap pop_wrap_01">
			<div class="pop_inner">
				<form id="bomInfo_Form" name="SupplyInfo_Form">

					<h3>버전리스트<a class="back_btn" href="#" onclick="versionInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

					<div class="master_list master_listT">
						<div class="scroll">
							<table class="master_01 master_05">
								<colgroup>
									<col style="width: 55px;"/>
									<col style="width: 110px;"/>
									<col style="width: 200px;"/>
									<col style="width: 280px;"/>
									<col style="width: 100px;"/>
									<col style="width: 100px;"/>
									<col style="width: 100px;"/>
								</colgroup>
								<thead>
								<tr>
									<th>NO</th>
									<th>BOM버전명</th>
									<th>품목코드</th>
									<th>품목명</th>
									<th>규격</th>
									<th>소모품목개수</th>
									<th>기본여부</th>
									<th>관리</th>
								</tr>
								</thead>
								<tbody id="searchResult2">

								</tbody>
							</table>
						</div>
					</div>

					<div class="pop_btn clearfix" >
						<a href="#" class="p_btn_01" onclick="versionInfoLayer_Close();">닫기</a>
					</div>

				</form>
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="versionInfoLayer_Close();"><span>닫기</span></a>
			</div>

		</div>
	</div>
</div>

<div class="master_pop master_pop01" id="partlistInfoLayer">
	<div class="master_body">
		<div class="pop_bg" onclick="partlistInfoLayer_Close();"></div>
		<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
			<div class="pop_inner">
				<form id="partlistInfo_Form" name="partlistInfo_Form">
					<input type="hidden" name="PDT_CD" id="PDT_CD" />
					<input type="hidden" name="OLD_BOM_VERSION" id="OLD_BOM_VERSION" />
					<input type="hidden" name="partlistCount" id="partlistCount"  value="0"/>
					<h3>BOM 등록/조회<a class="back_btn" href="#" onclick="orderInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

					<div class="master_list master_listB">
						<table  class="master_02 master_04">

							<colgroup>
								<col style="width: 120px">
								<col style="width: 34.8%">
								<col style="width: 120px">
								<col style="width: 34.8%">
							</colgroup>

							<tbody>
							<tr>
								<th scope="row">품목코드</th>
								<td colspan="3"><input type="text" id="PDT_CODE" name="PDT_CODE" readonly="readonly" class="all"/>
									<button id="button_1" type="button" class="btn_02 btn_s" style="margin-left: 5px;" onclick="productSearch();">품목불러오기</button>
								</td>
							</tr>
							<tr>
								<th scope="row">품목명</th>
								<td colspan="3"><input type="text" id="PDT_NAME" name="PDT_NAME" class="all" readonly="readonly" /></td>
							</tr>
							<tr>
								<th scope="row">BOM버전명</th>
								<td><input type="text" id="BOM_VERSION" name="BOM_VERSION" class="" placeholder="버전명" value="1"/></td>
								<th scope="row">생산수량</th>
								<td ><input type="text" id="PRODUCE_QTY" name="PRODUCE_QTY" class="" style="text-align: right" onkeyup="this.value=this.value.replace(/[^0-9.]/g,'');" maxlength="12" value="1"/></td>
							</tr>
							<tr>
								<th scope="row">관리</th>
								<td>
									<div class="chkbox chkbox">
										<input type="hidden" id="BASIC_YN" name="BASIC_YN">
										<label for="BASIC_YN_CHK">
											<input type="checkbox" id="BASIC_YN_CHK" name="BASIC_YN_CHK" checked>
											<span>기본 BOM버전</span>
										</label>
									</div>
									<div class="chkbox chkbox1">
										<input type="hidden" id="STOCK_MINUS_YN" name="STOCK_MINUS_YN">
										<label for="STOCK_MINUS_YN_CHK">
											<input type="checkbox" id="STOCK_MINUS_YN_CHK" name="STOCK_MINUS_YN_CHK" checked>
											<span>BOM 재고감소여부</span>
										</label>
									</div>
								</td>
							</tr>
							</tbody>
						</table>
					</div>
					<div class="master_list master_listT">
						<div class="add_btn">	<button id="button_2" type="button" class="btn_02" onclick="materialSearch();">품목추가</button></div>
						<div class="scroll">
							<table class="master_01 master_05" id="product" >
								<colgroup>
									<col style="width: 50px;"/>
									<col style="width: 200px;"/>
									<col style="width: 250px;"/>
									<col style="width: 200px;"/>
									<col style="width: 60px;"/>
									<col style="width: 100px;"/>
									<col style="width: 200px;"/>
									<col style="width: 55px;"/>
								</colgroup>
								<thead>
								<tr>
									<th>NO</th>
									<th>품목코드</th>
									<th>품목명</th>
									<th>규격</th>
									<th>단위</th>
									<th>수량</th>
									<th>적요</th>
									<th>관리</th>
								</tr>
								</thead>

								<tbody id="searchResult">

								</tbody>
							</table>

						</div>
					</div>


					<div class="pop_btn clearfix" >
						<a href="#" class="p_btn_01" onclick="partlistInfoLayer_Close();">닫기</a>
						<a id="partlistChoice" href="#" class="p_btn_02" onclick="partlistInfoLayer_Update();" >수정</a>
					</div>

				</form>
			</div>
			<div class="group_close">
				<a href="#" class="getCustView_close" onclick="partlistInfoLayer_Close();"><span>닫기</span></a>
			</div>
			<div id="material_popup" class="layer_pop">
				<div class="handle_wrap">
					<div class="handle ui-draggable-handle"><span>품목 리스트</span></div>
					<div class="drag_fix"><a href="#" onclick="materialSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
				</div>
				<iframe src="" id="material_popupframe"></iframe>
			</div>
			<div id="product_popup" class="layer_pop">
				<div class="handle_wrap">
					<div class="handle ui-draggable-handle"><span>원자재 리스트</span></div>
					<div class="drag_fix"><a href="#" onclick="productSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
				</div>
				<iframe src="" id="product_popupframe"></iframe>
			</div>
		</div>
	</div>
</div>