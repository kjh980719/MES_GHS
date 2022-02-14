<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xml:lang="ko" xmlns="http://www.w3.org/1999/xhtml" lang="ko">
<tiles:insertTemplate template="/WEB-INF/views/tiles/layouts/defaultHead.jsp" ></tiles:insertTemplate>
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="author" content="">
</head>
<body>

	<div class="wrap">
		<!-- <div class="bg_top">
			<tiles:insertAttribute name="header" />
		</div> -->
		<div class="container">
			
			<div class="sidenav leftNav">
				<tiles:insertAttribute name="menu" />
			</div>
			
			<div class="content master_wrap" id="page-wrapper">
				<tiles:insertAttribute name="body" />
			</div>	
			
		</div>
		
		<div class="bottom">
			<tiles:insertAttribute name="footer" />
		</div>
		
				<div class="master_pop" id="updateInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="updateInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_650 " >
					<div class="pop_inner">
					<form id="updateInfo_Form" name="updateInfo_Form">
						<input type="hidden" id="tel" name="tel"/>
						<input type="hidden" id="managerTel" name="managerTel"/>
						 <input type="text" id="managerId_fake" class="hidden" autocomplete="off">
						<input type="password" id="password_fake" class="hidden" autocomplete="off">
						<h3>정보수정 <a class="back_btn" href="#" onclick="updateInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
						<div class="master_list">
							<table  class="master_02">	
								<colgroup>
									<col style="width: 130px">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">아이디</th>
										<td>
											<input type="text" id="managerId" name="managerId" class="inputName" readonly = "readonly"/>
										</td>			
									</tr>
									
									<tr>
										<th scope="row">비밀번호</th>
										<td>
											<input type="password" id="password" name="password"  maxlength="12"
											onkeyUp="pwdCheck(this); passchk();"/>
											<span class="sup01">영문, 숫자, 특수문자 4~12자</span>
										</td>			
									</tr>
									
									<tr>
										<th scope="row">비밀번호 확인</th>
										<td>
											<input type="password" id="passwordChk" name="passwordChk"  maxlength="12"
											onkeyUp="pwdCheck(this); passchk();"/>
											<span id="rPassText" class="sup01"></span>
										</td>			
									</tr>
									
									<tr>
										
										<th scope="row">담당자명 <span class="sup" >*</span></th>
										<td>
											<input type="text" id="managerName" name="managerName"  class="inputName"/>
										</td>			
									</tr>
									<tr>
										<th scope="row">부서</th>
										<td >
											<input type="text"  id="managerDepartment" name="managerDepartment" class="inputName"/>
										</td>			
									</tr>
									<tr>
										<th scope="row">직급</th>
										<td>
											<input type="text"  id="managerPosition" name="managerPosition" class="inputName"/>
										</td>			
									</tr>
									<tr>										
										<th scope="row">이메일 <span class="sup">*</span></th>
										<td >
											
											<!-- <input type="text" id="managerId_fake1" class="hidden" autocomplete="off">  -->
											<input type="text" id="managerEmail" name="managerEmail" onkeyup="removeBlank(this);"/>
										</td>			
									</tr>
									<tr>
										
										<th scope="row">전화번호 <span class="sup">*</span></th>
										<td >
											<div class="tel">
												
												<div class="sel_wrap">
													
												<select class="sel_03" id="managerTel1" name="managerTel1">
													<option>선택</option>
													<option>010</option>
													<option>02</option>											
													<option>031</option>
													<option>032</option>
													<option>033</option>
													<option>041</option>
													<option>042</option>
													<option>043</option>
													<option>044</option>
													<option>051</option>
													<option>052</option>
													<option>053</option>
													<option>054</option>
													<option>055</option>
													<option>061</option>
													<option>062</option>
													<option>063</option>
													<option>064</option>
													<option>070</option>																						
												</select>
													
												</div>
												
												<!-- <input type="text" id="managerTel1" name="managerTel1"  maxlength="3" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/> -->
												<span class="sup02">-</span>
												<input type="text" id="managerTel2" name="managerTel2"  maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
												<span class="sup02">-</span>
												<input type="text" id="managerTel3" name="managerTel3"  maxlength="4" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
											</div>
											
										</td>			
									</tr>


								</tbody>
							</table>
						</div>
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="updateInfoLayer_Close();">닫기</a>
							<a href="#" class="p_btn_02" onclick="updateInfo();">수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="updateInfoLayer_Close();"><span>닫기</span></a>
				</div>
			</div>
		</div>
	</div>
<!-- contents end -->

	</div>

</body>
</html>
