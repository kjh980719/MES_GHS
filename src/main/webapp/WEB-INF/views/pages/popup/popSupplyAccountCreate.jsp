<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript" src="/js/common/paging.js"></script>


<script>
function productAdd(){
	var num = Number($('#productCount').val());
	num += 1;
	var text ="";

	text += "<tr id='product_"+num+"'>";
	text += "<td class='num pctnum'><a href='#' onclick='productDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
	text += "<td class='code'><input type='text' id='code_"+num+"' name='code' ></td>";
	text += "<td class='prod'>";
	text += "<div class=\"dan\">";
	text += "<span><input type='text' id='pdt_name_"+num+"' name='pdt_name' placeholder=\"품목\"></span>";
	text += "<span><input type='text' id='pdt_standard_"+num+"' name='pdt_standard' placeholder=\"규격\"></span>";
	text += "</div>";
	text += "</td>";
	text += "<td class='name'><input type='text' id='qty_"+num+"' name='qty' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' onChange='priceChange("+num+"); return false;'></td>";
	text += "<td class='name'><input type='text' id='unit_"+num+"' name='unit' ></td>";
	text += "<td class='name'><input type='text' id='unit_price_"+num+"' name='unit_price' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' onChange='priceChange("+num+"); return false;'></td>";
	text += "<td class='name'><input type='text' id='supply_price_"+num+"' name='supply_price' readonly></td>";
	text += "<td class='ing vat'><input type='text' id='vat_"+num+"' name='vat' readonly></td>";
	text += "</tr>";
	

	$('#searchResult').append(text);
	
	$('#productCount').val(num);
}


	
	function checkId(){
		if ($('#managerId').val() == '' || $('#managerId').val() == 'undefined'){
			 $("#idCheckMsg").css("color","#F00");
	         $("#idCheckMsg").text("아이디는 최소 4자 이상입니다.");
	         $('#idYN').val("N");
	         return;
		}
		if ($('#managerId').val().length < 4){
			 $("#idCheckMsg").css("color","#F00");
	         $("#idCheckMsg").text("아이디는 최소 4자 이상입니다.");
	         $('#idYN').val("N");
	         return;
		}
		
		var formData = $('#create_Form').serialize();
		 $.ajax({
	         type : "post",            
	         url : '/supply/idCheck',            
	         dataType:"json",
	         data:  formData,
	         success : function(data) {
	        	
	         	var result = data.result;
	         	if (result.cnt == 0){
	         		 $("#idCheckMsg").css("color","#1a75bc");
	                 $("#idCheckMsg").text("사용 가능한 아이디입니다.");
	                 $('#idYN').val("Y");
	         	}else{
	         		 $("#idCheckMsg").css("color","#F00");
	                 $("#idCheckMsg").text("이미 사용중인 아이디입니다.");
	                 $('#idYN').val("N");
	         	}
	         },error : function(data){
	        	         	 
			         	layer_Close();			           
			      
	         }
	         
		 })
	}

	function goRegister(){
		if ($('#idYN').val() == "N") {
			alert("아이디를 올바르게 입력해주세요."); 
			return;
		}

		var formData = $('#create_Form').serialize();
		$.ajax({
	        type : "post",            
	        url : '/supply/createAccount',              
	        data:  formData,
	        success : function(data) {
	        	alert("공급사 계정이 생성되었습니다.")
	       	 	layer_close();
	        },        
	        error : function(data){		      
		       	layer_close();		       	
	        }
	        
		 })
	}

</script>
<div class="master_pop master_pop01 view" id="BusinessNumSearch" >
	<div class="master_body" style="padding-right:0px;">
		<div class="pop_wrap pop_wrap_01">
			<div class="pop_inner">
				<div class="master_wrap master_layer">
                   	<form id="create_Form" name="create_Form">
						<input type="hidden" id="scm_password" name="scm_password" value="${info.business_no}">
					
						<input type="text" id="managerId_fake" class="hidden" autocomplete="off">
						<input type="password" id="password_fake" class="hidden" autocomplete="off">
						<h3>공급사 계정조회 <a class="back_btn" href="#" ><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
<div class="master_list master_listB">
							<table class="master_02 master_04">	
								<tbody>
									<tr>
										<th scope="row">사업자번호</th>
										<td><input type="text" id="BUSINSESS_NO" name="BUSINSESS_NO" readonly="readonly"></td>		
										<th scope="row">대표자</th>
										<td><input type="text" id="BOSS_NAME" name="BOSS_NAME"></td>
									</tr>
									<tr>
										<th scope="row">상호(법인명)</th>
										<td colspan="3"><input type="text" id="CUST_NAME" name="CUST_NAME"></td>								
									</tr>
									<tr id="orderStatus" style="display: none;">
										<th scope="row">발주상태</th>
										<td colspan="3">
											<div id="orderStatusZone" class="sel_wrap" style="display: none;">													
												<select class="sel_02" id="order_status" name="order_status" onchange="reasonShow(this)">
													<option value="NR">미수신</option>
													<option value="YR">수신확인</option>
													<option value="ADJ">조정요청</option>											
													<option value="OP">진행중</option>
													<option value="OC">납품완료</option>
													<option value="NO">취소</option>								
												</select>															
											</div>
										</td>		
									</tr>
									<tr id="sayou" style="display : none;">
										<th scope="row">사유</th>
										<td colspan="3"><input type="text" id="cancel_reason" name="cancel_reason" class="all"></td>
									</tr>				
									
								</tbody>
							</table>
						</div>
						
						<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_1" type="button" class="btn_02" onclick="productAdd();">품목추가</button>
								<button id="button_2" type="button" class="btn_02" onclick="productSearch();">불러오기</button>
							</div>
							<div class="scroll">
								<table class="master_01 master_05" id="product" >	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 110px;"/>
										<col style="width: 220px;"/>
										<col style="width: 80px;"/>
										<col style="width: 80px;"/>
										<col style="width: 110px;"/>
										<col style="width:110px;"/>
										<col style="width: 110px;"/>
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>품목코드</th>
											<th>품목및 규격</th>
											<th>수량</th>
											<th>단위</th>
											<th>단가</th>
											<th>공급가액</th>
											<th>부가세</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>

			
					</form>
                   
                   
                   
                   
				</div>
				
				<div class="pop_btn clearfix">
					<a href="#" class="p_btn_01" onclick="layer_close();">닫기</a>
					<a href="#" class="p_btn_02" onclick="goRegister();">등록</a> 
				</div>
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="layer_close();"><span>닫기</span></a>
			</div>
		</div>
	</div>
</div>

