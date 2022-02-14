<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>


<style>
.img_wrap {
width: 300px;
margin: 10px;
}
.img_wrap img{
max-width: 80%;
}



</style>

<script type="text/javascript" src="/js/common/paging.js"></script>
<script type="text/javascript">
<%
UserInfo user = Util.getUserInfo();
%>

var sel_file;

$(document).ready(function() {
	
    var setCalendarDefault = function() {
        $("#purchaseDate").datepicker();
        $("#purchaseDate").datepicker('setDate', '${search.purchaseDate}');
        $("#endDate").datepicker();
        $("#endDate").datepicker('setDate', '${search.endDate}');
    }
    setCalendarDefault();
    
    
    var fileForm = $('#file1');
    fileForm.on('change', function(){
      if(window.FileReader){
        var filename = $(this)[0].files[0].name;
        $(this).siblings('.fileName1').val(filename);
        for(var i = 0; i < $(this)[0].files.length; i++){
            //console.log($(this)[0].files[i]);
          }
        selectFile($(this)[0].files);
      } else {
        var filename = $(this).val().split('/').pop().split('\\').pop();
        $(this).siblings('.fileName1').val(filename);
        selectFile($(this)[0].files);
      }
    })
    
    $("#file1").on("change", handleImgFileSelect);
    
})

      // 파일 리스트 번호
      var fileIndex = 0;
      // 등록할 전체 파일 사이즈
      var totalFileSize = 0;
      // 파일 리스트
      var fileList = new Array();
      // 파일 사이즈 리스트
      var fileSizeList = new Array();
      // 등록 가능한 파일 사이즈 MB
      var uploadSize = 20;
      // 등록 가능한 총 파일 사이즈 MB
      var maxUploadSize = 600;
      
      
   function handleImgFileSelect(e){
	   var files = e.target.files;
	   var filesArr = Array.prototype.slice.call(files);
	   
	   filesArr.forEach(function(f){
		   if(!f.type.match("image.*")){
			   alert("확장자는 이미지 확장자만 가능합니다.");
			   return;
		   }
		   sel_file = f;
		   
		   var reader = new FileReader();
		   reader.onload = function(e){
			   $("#img").attr("src", e.target.result);
			   $('.img_view').addClass('view');
		   }
		   reader.readAsDataURL(f);
	   });
	   
	   
	   
   }


	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}
	
	function hwDetail(hard_no){
		hardwareInfoLayer_Open(hard_no, "view");
	}
	function newRegister(type){
		hardwareInfoLayer_Open("", type)
	}
	
	function deleteFile(){
		$.ajax({
            type : "get",
            url : '/hardware/deleteFile',
            async : false,
            data: "hard_no="+$('#hard_no').val(), 
            success : function(data) {
            	alert('첨부파일 삭제하였습니다.');
            	$('#fileListZone').css("display","none");
        		$('#fileAddZone').css("display","");
        		
            },error : function(data){
            	alert('데이터 오류입니다.');
            }
		})
	}

	
	
	function productAdd(){
		var num = Number($('#hardwareCount').val());
		num += 1;
		var text ="";

		
		text += "<tr id='hw_"+num+"'>";
 		text += "<td class='num pctnum'><a href='#' onclick='hwDelete(\""+num+"\")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
 		text += "<td class='recodedate'><input type='text' id='recodedate_"+num+"' name='recodedate'  onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\");' placeholder=\"YYYY-MM-dd\"></td>";
 		text += "<td class='prod'>";
 		text += "<div class=\"dan\">";
 		text += "<span><input type='text' id='purpose_use_"+num+"' name='purpose_use' placeholder=\"수리/보수내역/A/S내역\"></span>";
 		text += "</div>";
 		text += "</td>";
 		text += "<td class='name'><input type='text' id='use_department_"+num+"' name='use_department' placeholder=\"부서\"></td>";
 		text += "<td class='name'><input type='text' id='mg_name_"+num+"' name='mg_name' placeholder=\"확인자\"></td>";
 		text += "<td class='name'><input type='text' id='bigo_"+num+"' name='bigo' placeholder=\"비고\" ></td>";
 		text += "</tr>";
		
 

		$('#searchResult').append(text);
		
		$('#hardwareCount').val(num);
	}
	function hwDelete(rowNum){

		$("#hw_"+rowNum).remove();
		
		
		
		

	}
	 

	
	
	function hardwareInfoLayer_Open(hard_no, type){
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');
			$('statusZone').css('display', '');
			$('#actionButton').html("수정");
			
			
			
			$.ajax({
	            type : "get",
	            url : '/hardware/view',
	            async : false,
	            data: "hard_no="+hard_no,
	            success : function(data) {
	            	var result = data.storeData;
	            	var array = result.info;
	            	var fileList = result.fileList;
	            	console.log(data);
	            	
	            	$('#hardwareInfo_Form').resetForm();
	            	
	            	$('#hard_no').val(array[0].hard_no);
	            	
	            	$('#hard_code').val(array[0].hard_code);
					$('#hard_name').val(array[0].hard_name);
					$('#manu_company').val(array[0].manu_company);
					$('#purchase_price').val(comma(array[0].purchase_price));
					$('#place').val(array[0].place);
					$('#as_phone').val(array[0].as_phone);
					$('#spec').val(array[0].spec);
					$('#part').val(array[0].part);
					$('#rating').val(array[0].rating);
					
					$('#img').attr("src", "/imageView/" + array[0].file1);

					

					var reg_date = Left(array[0].reg_date,10);
					
					var purchase_date = Left(array[0].purchase_date,10);
					
					
					$('#reg_date').val(reg_date);
					$("#purchase_date").datepicker();
				
		       		$('#purchase_date').val(purchase_date);
		       		
		       		
					
					if (fileList.length > 0){                  	
						text2 = "<a href='javascript:void(0);' onclick='self.location=\"/download/"+fileList[0].file_key+"\"; return false;'><img src='../../../../images/btn_file.gif'/>"+fileList[0].file_name+"</a>";		                   	
	                   	$('#fileList').empty();
	                   	$('#fileList').html(text2);
	                   	$('#fileListZone').css("display","");
	                   	$('#fileAddZone').css("display","none");
	                 	$("#img2").attr("src", "/download/"+fileList[0].file_key);
	                }else{
	                	$('#fileList').empty();
	                   	$('#fileListZone').css("display","none");
	                   	$('#fileAddZone').css("display","");
	                }
					

		       		if (array.length > 0){
		       			for (var i in array){
                   			
		       				hard_no = array[i].hard_no;
	                		no = array[i].no;
	                		
	                		
	                		recodedate = array[i].recodedate;
	                		
	                		
	                		purpose_use = array[i].purpose_use;
	                		use_department = array[i].use_department;
	                		mg_name = array[i].mg_name;
	                		bigo = array[i].bigo;
	                		
	                		text += "<tr id='hw_"+i+"'>";
	                 		text += "<td class='num pctnum'><a href='#' onclick='hwDelete(\""+i+"\")'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
							text += "<td class='day'><div class='day_input'><input type='text'  id='recodedate_"+i+"' name='recodedate' value='" +recodedate+"' readonly></td>";
	                 		text += "<td class='prod'>";
	                 		text += "<div class=\"dan\">";
	                 		text += "<span><input type='text' id='purpose_use_"+i+"' name='purpose_use' value='"+purpose_use+"' placeholder=\"수리/보수내역/A/S내역\"></span>";
	                 		text += "</div>";
	                 		text += "</td>";
	                 		text += "<td class='name'><input type='text' id='use_department_"+i+"' value='"+use_department+"' name='use_department' placeholder=\"부서\"></td>";
	                 		text += "<td class='name'><input type='text' id='mg_name_"+i+"' value='"+mg_name+"' name='mg_name' placeholder=\"확인자\"></td>";
	                 		text += "<td class='name'><input type='text' id='bigo_"+i+"' value='"+bigo+"' name='bigo' placeholder=\"비고\" ></td>";
	                 		text += "</tr>";
	                		
	                		
	                		
	                	}
		       		}else{
	            		text += "<tr class='all'><td colspan='8'>기록정보가 없습니다.</td></tr>";
	            	}

					$('#searchResult').html(text);
					for (var i in array){
						$('#recodedate_'+i).datepicker();
						$('#recodedate_'+i).datepicker('setDate', array[i].recodedate);
					}
	            }
	         }); 
		}else{ //신규작성일때
			$('#fileListZone').css("display","none");
			$('#fileAddZone').css("display","");
			
			$('#img').removeAttr("src");
    		$('#mode').val('register');
       		$('#button_1').css('display','inline-block');
       		$('#button_2').css('display','inline-block');

    		$('#actionButton').text('등록');
         	$('#searchResult').empty();
			$('#hardwareInfo_Form').resetForm();
			
			var today = new Date();   

			var year = today.getFullYear(); // 년도
			var month = today.getMonth() + 1;  // 월		
			var date = today.getDate();  // 날짜
			var monthChars = month.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
			var dateChars = date.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
			
			month = (monthChars[1]? month:"0"+month);// 한자리일경우 monthChars[1]은 존재하지 않기 때문에 false
			date = (dateChars[1]? date:"0"+date);// 한자리일경우 dateChars[1]은 존재하지 않기 때문에 false
			
			date = year + "-" + month + "-" + date;
			$('#reg_date').val(date);
			
		
			
       		$("#purchase_date").datepicker();
         	$("#purchase_date").datepicker('setDate', '+0');
         	
         	
            text += "<tr id='hw_1' >";
    		text += "<td class='num pctnum'><a href='#' onclick='hwDelete(1)'><img src='/images/common/miuns_icon.png'  alt='빼기아이콘'></a></td>";
			text += "<td class='day'><div class='day_input'><input type='text'  id='recodedate_1' name='recodedate' value='' readonly></td>";
    		text += "<td class='prod'>";
    		text += "<div class=\"dan\">";
    		text += "<span><input type='text' id='purpose_use_1' name='purpose_use' placeholder=\"수리/보수내역/A/S내역\"></span>";
    		text += "</div>";
    		text += "</td>";
    		text += "<td class='name'><input type='text' id='use_department_1' name='use_department' placeholder=\"부서\"></td>";
    		text += "<td class='name'><input type='text' id='mg_name_1' name='mg_name' placeholder=\"확인자\"></td>";
    		text += "<td class='name'><input type='text' id='bigo_1' name='bigo' placeholder=\"비고\" ></td>";
    		text += "</tr>";

    		$('#searchResult').html(text);

			$('#recodedate_1').datepicker();
			$('#recodedate_1').datepicker('setDate', "0");
		}

		$('#hardwareInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
	}
	

	
	function hardwareInfoLayer_Close(){
		$('#hardwareInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('#img').removeAttr("src");
			
	}
	
	function GoActionButton(){
		var targetUrl = ""
		var purpose_use = "";
		var mg_name = "";
		var recodedate = "";
		var use_department = "";
		var status = true;
		var msg = "";
		var param = "";
		
		var mode = $('#mode').val();
		if (mode == 'register') {
			targetUrl = "/hardware/create";
			msg = "설비가 등록되었습니다."
		} else if (mode == 'view'){
			targetUrl = "/hardware/edithardware";
			msg = "설비가 수정되었습니다."
		}
		
		
		var purchase_date = $('#purchase_date').val();
	
		
		
		var purchaseDay = new Date(purchase_date);

		if(isEmpty($('#hard_name').val())){
			alert("설비명을 입력해주세요.");
			$('#hard_name').focus();
			return false;
		}

		if(isEmpty($('#hard_code').val())){
			alert("설비번호를 입력해주세요.");
			$('#hard_code').focus();
			return false;
		}

		if(isEmpty($('#purchase_price').val())){
			alert("구입가격을 입력해주세요.");
			$('#purchase_price').focus();
			return false;
		}

		if(isEmpty($('#manu_company').val())){
			alert("제조사를 입력해주세요.");
			$('#manu_company').focus();
			return false;
		}

		if(isEmpty($('#place').val())){
			alert("설치장소를 입력해주세요.");
			$('#place').focus();
			return false;
		}


        var materialList =[];
        
		for (var i = 0; i < $("input[name='purpose_use']").length; i++) {
			var tmpMap = {};
			
			tmpMap.seq = i + 1;		
			
			tmpMap.purpose_use = $($("input[name='purpose_use']")[i]).val();
			tmpMap.recodedate = $($("input[name='recodedate']")[i]).val();
			tmpMap.use_department = $($("input[name='use_department']")[i]).val();
			tmpMap.mg_name = $($("input[name='mg_name']")[i]).val();
			tmpMap.bigo = $($("input[name='bigo']")[i]).val();			

			materialList.push(tmpMap)
		}
	
		var info =[];
		var tmpMap2 = {};
		tmpMap2.hard_no = $($("input[name='hard_no']")).val();
		tmpMap2.hard_code = $($("input[name='hard_code']")).val();
		tmpMap2.hard_name = $($("input[name='hard_name']")).val();
		tmpMap2.manu_company = $($("input[name='manu_company']")).val();
		tmpMap2.purchase_price = $($("input[name='purchase_price']")).val().replace(/,/g, "");
		tmpMap2.place = $($("input[name='place']")).val();	
		tmpMap2.as_phone = $($("input[name='as_phone']")).val();	
		tmpMap2.spec = $($("input[name='spec']")).val();	
		tmpMap2.part = $($("input[name='part']")).val();	
		tmpMap2.rating = $($("input[name='rating']")).val();	
		tmpMap2.file1 = $($("input[name='file1']")).val();	
		tmpMap2.purchase_date = purchase_date;
		
	
		info.push(tmpMap2);
		
		sendData = {};	
	    sendData.materialList = materialList;
	    sendData.info = info;
	    
	    var formData = new FormData();
	    
		 formData.append("content", new Blob([JSON.stringify(sendData)], {type: "application/json;charset=utf-8"}));
		 
		 var uploadFileList = Object.keys(fileList);
		    for(var i = 0; i < uploadFileList.length; i++){
		      formData.append('files', fileList[uploadFileList[i]]);
		    }
		    

       
        
        $.ajax({
        	
	        type : "post",
			url : targetUrl,
			contentType : false,
			processData : false,
			async : false,
			data : formData

		}).done(function(result) {

			if (result.success) {
				alert(msg);
				hardwareInfoLayer_Close();
				location.reload();
			} else {
				alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
			}
		});

	}
</script>

					<h3 class="mjtit_top">
						설비 관리 
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/hardware/list">
                  		<input type="hidden" name="rowsPerPage" id="rowsPerPage"/>
                  		                    <div class="srch_day">
                    	

                    </div>
                    <div class="srch_all">
                    	
        				<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="hard_code" <c:if test="${search.search_type == 'hard_code'}">selected</c:if>>설비번호</option>
	                            <option value="hard_name" <c:if test="${search.search_type == 'hard_name'}">selected</c:if>>설비명</option>                           
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string"   onkeyup="if(window.event.keyCode==13){goSearch();}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick='goSearch();'>검색</button>
                              <button type="button" class="btn_01" onclick='goReset();'>초기화</button> 
                          </div>
                          
                          <div class="register_btn">
                        	<button type="button" class="btn_02" onclick="newRegister();">신규등록</button>						
						
                        </div>
                        
                        
                    </div>
               
                    </form>
 
                    </div><!-- 검색  끝-->
					<!-- 리스트 시작-->
					
                    <div class="master_list ">
                    	<div class="list_set ">
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
	                    <div class="scroll">
                    	<table class="master_01 master_06">
                    		<colgroup>
                    			<col style="width: 55px;"/>
                    			<col style="width: 215px;"/>
                    			<col style="width: 380px;"/>
                    			<col style="width: 180px;"/>
                    			<col style="width: 120px;"/>
                    			<col style="width: 100px;"/>
                    			<col style="width: 70px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>설비번호</th>
                    				<th>설비명</th>
                    				<th>설치장소</th>
                    				<th>구입가격</th>
                    				<th>구입일자</th>

                    				<th>관리</th>  
                    			</tr>
                    		</thead>
                    		<tbody>
                    			<c:forEach items="${list}" var="list">
	                    			<tr>
	                    				<td class="num"><fmt:formatNumber value="${total + 1 - list.no}" pattern="#,###,###"/></td>
	                    				<td class="code">
	                    					<a href="#" onclick="hwDetail('${list.hard_no}'); return;">${list.hard_code}</a>
	                    				</td>
	                    				<td class="prod">
		                    				<a href="#" onclick="hwDetail('${list.hard_no}'); return;">${list.hard_name}</a>
		                    				<a href="#" onclick="hwDetail('${list.hard_no}'); return;" class="m_link">${list.hard_name}</a>
	                    				</td>
	       								<td class="name">${list.place}</td>
	       								<td class="name"><fmt:formatNumber value="${list.purchase_price}" pattern="#,###,###"/></td>
	       								<td class="day">${list.purchase_date}</td>
	                    				<td class="name"><button type="button" class="btn_03 btn_s" onclick="deletehardware('${list.hard_no}');">삭제</button></td>
	                    			</tr>
                    			</c:forEach>
                    			
                    			
								<c:if test="${empty list }">
									<tr><td colspan="7">설비 정보가 없습니다.</td></tr>
								</c:if>
                    			
                    			
                    		</tbody>
                    	</table>
                    	</div>
						<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div> 
                    
 				</div>
 			<div class="master_pop master_pop01" id="hardwareInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="hardwareInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01 pop_wrap_700" >
					<div class="pop_inner">
					<form id="hardwareInfo_Form" name="hardwareInfo_Form">
						<input type="hidden" name="hardwareCount" id="hardwareCount"  value="1"/>
						<input type="hidden" name="mode" id="mode"  value="regist"/>
						<input type="hidden" name="manager_seq" id="manager_seq"/>
						<input type="hidden" id="hard_no" name="hard_no" />
						<!-- <input type="hidden" id="cust_seq" name="cust_seq"> -->
						<h3>설비 등록/조회<a class="back_btn" href="#" onclick="hardwareInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

						<div class="master_list master_listB">
							<table  class="master_02 master_04">	
								<colgroup>
									<col style="width: 140px"/>
									<col />
									<col style="width: 140px"/>
									<col />
								</colgroup>
								<tbody>
						
								    <tr>
									<th scope="row">설 비 명  <span class="keyf01">*</span></th>
										<td colspan="3"><input type="text" id="hard_name" name="hard_name" class="all" maxlength="100" placeholder="설비명"/></td>
										
					               </tr>
					               <tr>
					               		<th scope="row">설비번호  <span class="keyf01">*</span></th>
										<td><input type="text" id="hard_code" name="hard_code" maxlength="45" placeholder="설비번호"/></td>
										<th scope="row">구입가격  <span class="keyf01">*</span></th>
										<td><input type="text" id="purchase_price" name="purchase_price" onkeyup="this.value=this.value.replace(/[^0-9]/g,''); this.value=comma(this.value);" maxlength="12" placeholder="구입가격"/></td>
					               </tr>
									<tr>
									    <th scope="row">제조사 <span class="keyf01">*</span></th>
										<td colspan="3">
											<div><input type="text"  id="manu_company" name="manu_company"  class="all" maxlength="100" placeholder="제조사"/></div>
										</td>									    									
									</tr>
						
										
									<tr>
									    <th scope="row">설치장소 <span class="keyf01">*</span></th>
										<td colspan="3"><input type="text" id="place" name="place" class="all" maxlength="100" placeholder="설치장소"/></td>
																			
									</tr>
									
									
					                 
					                  <tr>
					                     <th scope="row">작성일자</th>
										<td>
											<div class="day_input"><input type="text" id="reg_date" name="reg_date" readonly="readonly"/></div>
											
										</td>
																			
										
										<th scope="row">구입일자</th>
										<td>
											<div class="day_input"><input type="text" id="purchase_date" name="purchase_date" onchange="dateCheck(this);"/></div>											
																													
										</td>		
										
									</tr>
									<tr>		
									
									    <th scope="row">제원 </th>
										<td>
										<input type="text" id="spec" name="spec" maxlength="100" placeholder="제원"/>
										
										</td>			
			
										<th scope="row">부품 및 부속품</th>
										<td><input type="text" id="part" name="part" class="all"  maxlength="100" placeholder="부품 및 부속품"/></td>
																			
									</tr>	
									
									
									
									
								    <tr>
									
									<th scope="row">정격</th>
										<td>
											<input type="text" id="rating" name="rating" maxlength="100" placeholder="정격"/>
										</td>
										
										
										 <th scope="row">A/S 연락처</th>
										<td><input type="text" id="as_phone" name="as_phone" onkeyup="$(this).val($(this).val().replace(/\D/g,''))" maxlength="20" placeholder="연락처"/></td>
									</tr> 
									
									<tr id="fileListZone">
										
										<th scope="row">첨부파일</th>
										<td colspan="3"><div id="fileList" class="file_del"></div><a href="#" class="del_close" onclick="deleteFile();">삭제</a>
										<div class="img_view view"><a href="#" onclick="imgView(); return false;" class="txt">등록된 이미지보기</a><span class="view_pop" onclick="imgClose(); return flase;"><span><img  id="img2" name="img" src="" alt="첨부된이미지"></span></span></div>
										</td>	
									</tr>
									
									<tr id="fileAddZone">
					                    <th>파일첨부</th>
					                    <td colspan="3">
					                      <div class="file_area">				                    
					                        <input type="file" id="file1" name="file1" />
					                         <input class="fileName1 all" type="text"  value="" readonly><label for="file1" class="clr">파일첨부</label>
					                      </div>
					                      <div class="img_view"><a href="#" onclick="imgView(); return false;" class="txt">등록된 이미지보기</a><span class="view_pop" onclick="imgClose(); return flase;"><span><img  id="img" name="img" src="" alt="첨부된이미지"></span></span></div>
					              		</td>
	
									</tr>
					              		
					              	
                  					
                  					
								
									
												
								</tbody>
											
							</table>
							
							
							
						</div>
						
						
						
						<div class="master_list master_listT">
							<div class="add_btn">
								<button id="button_1" type="button" class="btn_02" onclick="productAdd();">품목추가</button>
							</div>
							<div class="scroll">
								<table class="master_01 master_05">	
									<colgroup>
										<col style="width: 55px;"/>
										<col style="width: 110px;"/>
										<col style="width: 320px;"/>
										<col style="width: 100px;"/>
										<col style="width: 100px;"/>
										<col style="width: 300px;"/>
										
									</colgroup>
									<thead>
										<tr>
											<th></th>
											<th>기록일자</th>	
											<th>수리 / 보수내용 / A/S내역</th>
											<th>사용부서</th>										
											<th>확인자</th>		
											<th>비고</th>
										</tr>
									</thead>
									<tbody id="searchResult">
	
									</tbody>
								</table>
							</div>
						</div>
						
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="hardwareInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02" >수정</a> 
						</div>
			
					</form>
				</div>
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="hardwareInfoLayer_Close();"><span>닫기</span></a>
				</div>
				
				
				
			</div>
		</div>
	</div>

<script>

function goUpload() {
    $("#uploadInput").click();
  }
$("#uploadInput").change(function (e) {
  e.preventDefault();
    for (var i = 0; i < $(this)[0].files.length; i++) {
      if (!checkImage($(this)[0].files[i].name)) {
        return false;
      }
      imageUploadProcess($(this)[0].files[i]);
    }
    $(this).val("");
 })
	
function imgView() {
	$('.view_pop').addClass('view');
	
}
function imgClose() {
	$('.view_pop').removeClass('view');
	
}	
	function deletehardware(hard_no){
		
		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/hardware/delete',
	            async : false,
	            data: "hard_no="+hard_no,
	         	success : function(data) {
		            if(data.success){
		            	alert("삭제되었습니다.");
		            	location.reload(true);
		            }else{
		            	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
		            }
		        },error : function(data){
		 
		        	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
		            location.reload(true);
	            }
			})
		}
					


	}
	
	
	function dateCheck(obj){
		
		var id = $(obj).attr('id'); 
		
		var today = new Date(); 	
		var selectDate = new Date(obj.value);
		
		today = new Date(today.getFullYear(), today.getMonth(), today.getDate(), 0)
		selectDate = new Date(selectDate.getFullYear(), selectDate.getMonth(), selectDate.getDate(), 0)

		/* if (today > selectDate){
			alert("현재날짜보다 이전날짜는 선택할 수 없습니다.")
			$('#'+id).datepicker('setDate', '+0');
		} */
		
	}
</script>