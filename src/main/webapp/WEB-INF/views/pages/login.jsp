
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta property="og:type" content="website">
	<meta property="og:title" content="EMS - Master">
	<meta property="og:description" content="EMS - Master">
	<meta property="og:image" content="/images/og_view_img.png">
	<meta property="og:url" content="https://mallmaster.pbaplay.com/">
	<meta name="viewport" content="width=device-width, user-scalable=no">
	<title>MES - Master</title>
	<script src="https://code.jquery.com/jquery-1.7.2.min.js"></script>
	<script src="/js/common/ttccLibrary.js"></script>
	<link rel="stylesheet" href="/css/reset.css"> 
	<link rel="stylesheet" href="/css/login.css">
	<style>
	

		#loading {width: 100%;height: 100%;position: absolute;top: 0;left: 0;z-index: 99999;background: rgba(0, 0, 0, 0.5);}
		#loading-image{position: absolute;top: 50%;left: 50%;margin: -32px 0 0 -32px}
	</style>
	<script>
		function s2_txt_is_empty(s2_focus, s2_element) {
			if ((s2_element.value.s2_trim() == "") || (s2_element.value.s2_trim().length <= 0)) {
				s2_element.value = "";

				if (s2_focus && !s2_element.readOnly && !s2_element.disabled) {
					s2_element.focus();
				}

				return true;
			} else{
				return false;
			}
		}

		function login(){
			var frm = document.frmL;
			if (s2_txt_is_empty(true, frm.managerId)) { alert("아이디를 입력해 주십시오."); frm.managerId.focus(); return false; }
			if (s2_txt_is_empty(true, frm.password)) { alert("비밀번호를 입력해 주십시오."); frm.password.focus(); return false; }
			var id = $('#managerId').val();
			var pw = $('#password').val();
			
			if (id.length < 4){alert("아이디는 최소 4자 이상입니다."); frm.managerId.focus(); return false;}
			if (pw.length < 4){alert("비밀번호는 영문,숫자,특수문자 4 ~ 12자 이상입니다."); frm.password.focus(); return false;}
			
			frm.action = "/loginProcess";
			frm.submit();
		}

		function check_enter_key(event) {
			if (event.keyCode == 13) {
				login();
			}
		}

		$(window).load(function() {
			$('#loading').hide();
		});
	</script>
</head>
<body>
<div class="login_wrap">
	<div class="login_hd">
		<h1 ><a href="/"><img src="/images/common/login_logo.png" alt="thetheMes"></a></h1>
	</div>
	<div class="login_cont">
		<div class="cont_in">
			<div class="cont_tit"><span>Log In</span></div>
			<form id="frmL" name="frmL" method="post" action="#">
				<input type="text" id="managerId_fake" class="hidden" autocomplete="off">
				<input type="password" id="password_fake"  class="hidden" autocomplete="off">
				<div class="cont_tb">
					<div class="cont_td">
						<div class="td_in">
							<div class="cont_input">
								<label for="managerId">아이디</label>
								<input type="text" size="20" id="managerId" name="managerId"  tabindex="1"  onkeyup="check_enter_key(event)" >
								<span class="focus_bar"></span>
							</div>
							<div class="cont_input">
								
								<label for="password">비밀번호</label>
								<input type="password" size="20" id="password" name="password"  tabindex="2" onkeyup="check_enter_key(event)"  autocomplete="off">
								<span class="focus_bar"></span>
							</div>
							<div class="cont_chk clearfix">
								<div class="chkbox">
									<label class="" for="loginChk">
										<input type="checkbox" id="loginChk"  value="" checked>
										<span>아이디 저장</span>
									</label>
								<!-- 	<label class="m_view" for="loginChk1">
										<input type="checkbox" id="loginChk1"  value="">
										<span>자동로그인</span>
									</label> -->
								</div>
								<div class="find_box">
									<a href="#">아이디 찾기</a>
									<a href="#">비밀번호 찾기</a>
								</div> 
							</div>
							<div class="cont_btn">
								<a href="#" class="btn" onclick="login();return false;">로그인</a>
								<!-- <a href="#" class="btn btn1" onclick="location.href='/signup/signup'">회원가입</a> -->
							</div>
					<div class="m_find_box">
								<a href="#">아이디 찾기</a>
								<a href="#">비밀번호 찾기</a>
							</div>
						</div>
					</div>
					<div class="cont_td"><img src="/images/common/customer_logo.png" alt="uzin medicare"></div>
				</div>
			</form>
			<div class="login_ft">
				<div class="copy">
					<span>Copyright © Uzinmedicare, Inc. All rights reserved.</span>
					<span>Powered by TheThe C&C</span>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="loading"><img id="loading-image" src="/images/loading.svg" alt="Loading..." /></div>
<script>
	$(document).ready(function() {
		loginH();
		var inputVal = $('#managerId').val();
		if (inputVal == "") {
            $('#managerId').parents('.cont_input').removeClass('focus');
        }else {
        	$('#managerId').parents('.cont_input').addClass('focus');
        	
        }
		$('.cont_input input').focus(function() {
				$(this).parents('.cont_input').addClass('focus');
				$(this).next('.focus_bar').addClass('focus');
		})
		$('.cont_input input').blur(function() {
            if ($(this).val() == "") {
                $(this).parents('.cont_input').removeClass('focus');
                $(this).next('.focus_bar').removeClass('focus');
            }else {
            	$(this).parents('.cont_input').addClass('focus');
            	$(this).next('.focus_bar').removeClass('focus');
            	
            }
        });
		
	})
	$(window).resize(function() {
		loginH();
		
	})
	function loginH() {
		var winH = $(window).height();
		var hdH = $('.login_hd').outerHeight();
		var hAll = winH - hdH;
		$('.login_cont').css('height',hAll);
		
	}
	window.onpageshow = function(event) {
		if ( event.persisted || (window.performance && window.performance.navigation.type == 2)) {
			var inputVal = $('#managerId').val();
			if (inputVal == "") {
	            $('#managerId').parents('.cont_input').removeClass('focus');
	        }else {
	        	$('#managerId').parents('.cont_input').addClass('focus');
	        	
	        }
	     }
	}
</script>
</body>
</html>
