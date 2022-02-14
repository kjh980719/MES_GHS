<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript" src="/js/common/paging.js"></script>


<script>


	function goRegister(){

		if(isEmpty($('#e_code').val())){
			alert("사원코드를 입력하세요");
			return false;
		}
		if(isEmpty($('#e_name').val())){
			alert("사원명을 입력하세요");
			return false;
		}
		if(isEmpty($('#e_position').val())){
			alert("직책을 입력하세요");
			return false;
		}
		
		
		var formData = $('#create_Form').serialize();
		$.ajax({
	        type : "post",            
	        url : '/department/createEmployee',              
	        data:  formData,
	        success : function(data) {
	        	alert("사원이 추가되었습니다.")
	       	 	layer_close();
	        },        
	        error : function(data){
				alert("사원이 추가되지 않았습니다.")
		       	layer_close();		       	
	        }
	        
		 })
	}

</script>
<div class="master_pop master_order view" id="BusinessNumSearch" >
	<div class="master_body">
		<div class="pop_wrap pop_wrap_02">
			<div class="pop_inner">
				<div class="master_wrap master_layer">
                   	<form id="create_Form" name="create_Form">

						<h3>사원추가<a class="back_btn" href="#" onclick="updateInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
						<div class="master_list">
							<table  class="master_02">	
								<colgroup>
									<col style="width: 130px">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">부서코드</th>
										<td>
											<input type="text" id="dpt_code" name="dpt_code" class="inputName" value="${info.dpt_code}" readonly = "readonly"/>
										</td>			
									</tr>
									<tr>
										<th scope="row">부서명</th>
										<td>
											<input type="text" id="dpt_name" name="dpt_name" class="inputName" value="${info.dpt_name}" readonly = "readonly"/>
										</td>			
									</tr>
									<tr>
										<th scope="row">사원코드</th>
										<td>
											<input type="text" id="e_code" name="e_code" class="inputName"/>
										</td>			
									</tr>
									<tr>
										<th scope="row">사원명</th>
										<td>
											<input type="text" id="e_name" name="e_name" class="inputName"/>
										</td>			
									</tr>
									
									<tr>
										<th scope="row">직책</th>
										<td>
											<input type="text" id="e_position" name="e_position" class="inputName"/>
										</td>			
									</tr>
									<tr>
										<th scope="row">성별</th>
										<td>
											<div class="sel_wrap">
												<select id="e_sex" name="e_sex"  class="sel_02">
													<option></option>
													<option value="M">남자</option>
													<option value="L">여자</option>
												</select>
											</div>
										</td>			
									</tr>
									<tr>
										<th scope="row">연락처</th>
										<td>
											<input type="text" id="e_tel" name="e_tel" class="inputName"/>
										</td>			
									</tr>
									<tr>
										<th scope="row">이메일</th>
										<td>
											<input type="text" id="e_email" name="e_email" class="inputName"/>
										</td>			
									</tr>
									

									
								</tbody>
							</table>
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

