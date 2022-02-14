<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<sec:authentication property="principal.allowedMenuMap['MES_MENU']" var="menuItems"/>
<%
	UserInfo user = Util.getUserInfo();
%>

<div class="left_bg"></div>
<div class="left_top">
	<div class="logo">
		<a  href="/"><img src="/images/common/login_logo.png" alt="thethescm" ></a>
		<a  href="#" class="m_view"><img src="/images/common/menu_view.png" alt="메뉴보이기" ></a>
	</div>
	<div class="company_logo"><img src="/images/common/comp_logo.png" alt="thethescm" ></div>
	<div class="info">
		<div class="info_sel">
			<a href="#"><span><%=user.getManagerName()%></span></a>
			<div class="info_edit transX">
				<ul>
					<li><a href="#" onclick="updateInfoLayer_Open();" >정보수정</a></li>
					<li><a href="/logout">로그아웃</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div class="m_info">
		<div class="m_info_edit">
			<ul class="clearfix">
				<li><a href="#" onclick="updateInfoLayer_Open();" >정보수정</a></li>
				<li><a href="/logout">로그아웃</a></li>
			</ul>
		</div>
	</div>
</div>
<div class="menu_list">
	<ul>
	
		
      <c:forEach var="depth1" items="${menuItems}" varStatus="loop">


      <c:if test="${depth1.depth == 1}">
      	<li>
         <c:set var="doneLoop" value="true"/>
         <button class="dropdown-btn sub_depth1 <c:if test="${depth1.selected}">active</c:if>" data-seq="${depth1.menuSeq}">${depth1.menuName}
            <c:forEach var="depth2" items="${menuItems}" varStatus="loop">
                  <c:if test="${depth2.depth == 2 && depth1.menuSeq == depth2.parentMenuSeq && doneLoop}">
                        <c:set var="doneLoop" value="false"/>
                  </c:if>
             </c:forEach>
         </button>
         
         <div class="dropdown-container sub_depth2 childMenu-${depth1.menuSeq}" <c:if test="${depth1.selected}">style="display:block"</c:if>>
			<ul>
				<c:forEach var="depth2" items="${menuItems}" varStatus="loop">
	            	<c:if test="${depth2.depth == 2 and depth2.parentMenuSeq == depth1.menuSeq}">
			        	 <c:set var="doneLoop3" value="true"/>
			         <li>
				         <a class="dropdown-btn <c:if test="${depth2.selected}">active</c:if>" href="#" data-seq="${depth2.menuSeq}"  onclick="if('${depth2.programUrl}' != ''){location.href='${depth2.programUrl}';}else{}">${depth2.menuName}
				            <c:forEach var="depth3" items="${menuItems}" varStatus="loop">
				                  <c:if test="${depth3.depth == 3 && depth2.menuSeq == depth3.parentMenuSeq && doneLoop3}">
				                         <c:set var="doneLoop3" value="false"/>
				                  </c:if>
				             </c:forEach>
				         </a>
			         
			         <div class="dropdown-container sub_depth3 childMenu2-${depth1.menuSeq} childMenu-${depth2.menuSeq}"  <c:if test="${depth2.selected}">style="display:block"</c:if>>
			            <ul>
			            <c:forEach var="depth3" items="${menuItems}" varStatus="loop">
			               <c:if test="${depth3.depth == 3 && depth2.menuSeq == depth3.parentMenuSeq}">
			               	<li>
			                  <a href="${depth3.programUrl}" class="<c:if test="${depth3.selected}">active</c:if>" >${depth3.menuName}</a>
			                 </li>
			               </c:if>
			            </c:forEach>
			            </ul>
			         </div>
			         </li>
			      </c:if>
		</c:forEach>
		</ul>
		</div>
		
         </li>
      </c:if>
		
		
      



   </c:forEach>
   </ul>
</div>

<script>
$(document).ready(function() {
	
	var masterLayer = $('.master_wrap').outerWidth(true);
	contW()
	$('.info_sel>a').click(function() {
		if ($(this).next('div').hasClass('view')) {
			$(this).next('div').removeClass('view');
		} else {
			$(this).next('div').addClass('view');
			
		}

	})
	$('.info_edit').mouseleave(function() {
		
		$(this).removeClass('view');
	})
	$('.m_view').click(function() {
		
		$('.leftNav').addClass('view');
	})
	
	$('.left_bg').click(function() {
		
		$('.leftNav').removeClass('view');
	})
	
})
window.onload=function() {
	menuH();
	
}
$(window).resize(function() {
	var masterLayer = $('.master_wrap').outerWidth(true);
	menuH();
	contW()

})
	var winW;
	var masterW;
	var masterIn;
	var masterM;
   var dropdown = document.getElementsByClassName("dropdown-btn");
   var i;

   for (i = 0; i < dropdown.length; i++) {
      dropdown[i].addEventListener("click", function() {
    	  this.classList.toggle("active");
    	  if ($(".childMenu-"+$(this).data("seq")).css("display") != "none") {
    		  $(".childMenu-"+$(this).data("seq")).css("display", "none");
    		  $(".childMenu-"+$(this).data("seq")).removeClass("active");
    		  $(".childMenu2-"+$(this).data("seq")).css("display", "none");
    		  
           } else {
        	  
        	   $(".childMenu-"+$(this).data("seq")).css("display", "block");
              
           }
    	  
         /* this.classList.toggle("active");
         var dropdownContent = this.nextElementSibling;
         if (dropdownContent.style.display === "block") {
            dropdownContent.style.display = "none";
         } else {
            dropdownContent.style.display = "block";
         } */
      });
   }
   function menuH() {
		var winH = $(window).height();
		var menuTop = $('.leftNav .left_top').outerHeight();
		var listH = winH - menuTop;
	
		$('.menu_list').css('height', listH);

	}
	function contW() {
		if ($('div').hasClass('master_pop')) {
		    winW = $(window).width();
			masterW = $('.master_wrap ').outerWidth(true) - $('.master_wrap ').width();
			masterIn = $('.master_list').innerWidth();
			var masterPop = winW - masterIn  - masterW;
			$('.master_body').each(function() {
				$(this).css('padding-right',masterPop);
				
			})
		}
		
	}
   function tabOpen(num) {
      var idx = num;
      $('.group_box').css('display','none');
      $('.group_box'+idx).css('display','block');
      $('.group_tab button').removeClass('tab');
      $('.group_tab button:nth-child('+idx+')').addClass('tab');

   }
	
   function updateInfoLayer_Open(){
	
		 $.ajax({
           type : "post",
           url : '/member/getMemberInfo',
           contentType: "application/json",
           dataType : "json",
           async : false,
           data: "",
           success : function(data) {
	           var store = data.storeData;
	           var user = store.user;
           	   var managerTelArray = user.managerTel.split('-');   
			   $('#managerName').val(user.managerName);
		       $('#managerId').val(user.managerId);
			   $('#managerEmail').val(user.managerEmail);
			   $('#managerDepartment').val(user.groupName);
			   $('#managerPosition').val(user.managerPosition);
			   $('#managerTel').val(user.managerTel);
			   $('#managerTel1').val(managerTelArray[0]);		
			   $('#managerTel2').val(managerTelArray[1]);
			   $('#managerTel3').val(managerTelArray[2]);
				
			   $('#updateInfoLayer').addClass('view');
			   $('html,body').css('overflow','hidden');
			   $('.leftNav').removeClass('view');
           },error : function (e){
          	 location.reload(true);
           }
        });
      
		

	}
	
	
	function updateInfoLayer_Close(){
		$('#updateInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');
		
	}
	
	function updateInfo(){
		var managerName = $('#managerName').val().trim();
		$('#managerName').val(managerName);
		var managerEmail = $('#managerEmail').val();
		var managerTel1 = $('#managerTel1').val();
		var managerTel2 = $('#managerTel2').val();
		var managerTel3 = $('#managerTel3').val();
		var password = $('#password').val();
		var passwordChk = $('#passwordChk').val();
		
		
		if(password.length != 0){
			if(password != passwordChk){
				alert("비밀번호가 다릅니다.");
				return false;
			}
			if(password.length < 4){
				alert("비밀번호는 최소 4자 이상입니다.");
				return false;
			}			
		}
	
		if (isEmpty(managerName)){
			alert("담당자명을 입력해주세요.");
			return false;
		}
		if (isEmpty(managerEmail)){
			alert("담당자 이메일을 입력해주세요.");
			return false;
		}
		if (isEmpty(managerTel1)){
			alert("연락처를 입력해주세요.");
			return false;
		}
		if (isEmpty(managerTel2)){
			alert("연락처를 입력해주세요.");
			return false;
		}
		if (isEmpty(managerTel3)){
			alert("연락처를 입력해주세요.");
			return false;
		}
		
		var managerTel = managerTel1 + '-' + managerTel2 + '-' + managerTel3;
		
		$('#managerTel').val(managerTel);
		
		var formData = $('#updateInfo_Form').serialize();
	
		 $.ajax({
           type : "post",            
           url : '/member/updateInfo',            
           dataType:"json",
           data:  formData,
           success : function(data) {
				if (data.success == true){
					alert("회원정보가 수정되었습니다.\n다시 로그인 해주세요.");
					logOut();
				}
           },error : function(data){
          	 updateInfoLayer_Close();
          	 location.reload(true);
           }
        });

		
	}
	
	function logOut(){
		location.href = "/logout";
	}
	
	function passchk(){
      var pwd1 = $("#password").val();
      var pwd2 = $("#passwordChk").val();
		
      if (pwd1.length<4 || pwd2.length<4){
	       $("#rPassText").css("color","#F00");
	       $("#rPassText").text("비밀번호는 4자리 이상입니다.");
      }else{
      	
      	  if ( pwd1 != '' && pwd2 == '' ) {
                null;
            } else if (pwd1 != "" || pwd2 != "") {
                if (pwd1 == pwd2) {
                    // 비밀번호 일치 이벤트 실행
                    $("#rPassText").css("color","#2e61b4");
                    $("#rPassText").text(" 비밀번호가 일치합니다. ");
                } else {
                    // 비밀번호 불일치 이벤트 실행
                	 $("#rPassText").css("color","#F00");
                     $("#rPassText").text(" 비밀번호가 다릅니다. ");
                }
            }
     
      }
      
    
  };

</script>