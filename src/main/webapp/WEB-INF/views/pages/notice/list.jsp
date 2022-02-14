<%@page import="mes.app.util.Util"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>


<script type="text/javascript" src="/se2/js/HuskyEZCreator.js"></script>

<script>

	function smartEditorOn(){
		 oEditors = [];
		 nhn.husky.EZCreator.createInIFrame({
			 oAppRef: oEditors,
			 elPlaceHolder: "contents",
			 sSkinURI: "/se2/SmartEditor2Skin.html",
			 fCreator: "createSEditor2",
			 htParams : {fOnBeforeUnload : function(){}},
			 fOnAppLoad: function (){
				var width="100%"; // 원하는 너비
				var height=570; // 원하는 너비
 				$("#contents").css('width',width);
				$("#contents").css('height',height);
				$("#huskey_editor_jinto_set_id").css('width',width);
				$("#huskey_editor_jinto_set_id").css('height',height); 

				
			 }
			 
		});


		      
	};
</script>

<script type="text/javascript">


$(document).ready(function() {
	
    var setCalendarDefault = function() {
        $("#startDate").datepicker();
        $("#startDate").datepicker('setDate', '${search.startDate}');
        $("#endDate").datepicker();
        $("#endDate").datepicker('setDate', '${search.endDate}');
    }
    setCalendarDefault();
    smartEditorOn();
    
   
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
      
      
      $('#file1').change(function(e){
       // console.log($(this)[0].files);
        selectFile($(this)[0].files);
        for(var i = 0; i < $(this)[0].files.length; i++){
         // console.log($(this)[0].files[i]);
        }

      
})

	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}
	
	function viewNoticeDetail(notice_seq, type){
		noticeInfoLayer_Open(notice_seq, type);
	}
	function registerNotice(type){
		if (sessionCheck()){
			noticeInfoLayer_Open("", type)
		}else{		
			location.reload(true);
		}
	
	}
	function deleteNotice(notice_seq){
		if(confirm("정말 삭제하시겠습니까?")){
			$.ajax({
	            type : "get",
	            url : '/notice/deleteNotice',
	            async : false,
	            data: "notice_seq="+notice_seq, 
	            success : function(data) {
	            	alert('삭제하였습니다.');
					location.reload(true);
	            },error : function(data){
	            	alert('데이터 오류입니다.');
	            	location.reload(true);
	            }
			})
		}
	}
	function deleteFile(){
		$.ajax({
            type : "get",
            url : '/notice/deleteFile',
            async : false,
            data: "notice_seq="+$('#notice_seq').val(), 
            success : function(data) {
            	alert('첨부파일 삭제하였습니다.');
            	$('#fileListZone').css("display","none");
        		$('#fileAddZone').css("display","");
            },error : function(data){
            	alert('데이터 오류입니다.');
            }
		})
	}
	
	function noticeInfoLayer_Open(notice_seq, type){
		
		var text = "";
		if (type=="view"){ //상세보기
			$('#mode').val('view');

			$.ajax({
	            type : "get",
	            url : '/notice/view',
	            async : false,
	            data: "notice_seq="+notice_seq,
	            success : function(data) {
	            	var result = data.storeData;	            	

					var info = result.info;
	    			$('#noticeInfo_Form').resetForm();
				    var cust_seq = "";
					var fileList = result.fileList;
				    var notice_seq = "";
				    var showYN = "";
				    var title = "";
				    var contents = "";
				    var viewCnt = "";
				    var writerId = "";
				    var writerName = "";
				    var regDate = "";
				    var cust_name = "";
				    cust_seq = info.cust_seq;
				    cust_name = info.cust_name;
				    notice_seq = info.notice_seq;
				    showYN = info.showYN;
				    title = info.title;
				    contents = info.contents;
				    viewCnt = info.viewCnt;
				    writerName = info.writerName;
				    regDate = info.regDate;
				    
				    $('#contents').val(contents);
				    oEditors.getById["contents"].exec("LOAD_CONTENTS_FIELD");
				    
				    if (cust_seq == 0){
				    	$("input:radio[name='cust_choice']:radio[value='N']").prop('checked', true); 
				    	$('#custNameZone').css("display","none");
						$('#cust_name').val("");
				    }else{
				    	$("input:radio[name='cust_choice']:radio[value='Y']").prop('checked', true); 
				    	$('#custNameZone').css("display","");
						$('#cust_name').val(cust_name);
						$('#cust_seq').val(cust_seq);
				    }
				    
					if (fileList.length > 0){                  	
						text = "<a href='javascript:void(0);' onclick='self.location=\"/download/"+fileList[0].file_key+"\"; return false;'><img src='../../../../images/btn_file.gif'/>"+fileList[0].file_name+"</a>";		                   	
	                   	$('#fileList').empty();
	                   	$('#fileList').html(text);
	                   	$('#fileListZone').css("display","");
	                   	$('#fileAddZone').css("display","none");
	                }else{
	                	$('#fileList').empty();
	                   	$('#fileListZone').css("display","none");
	                   	$('#fileAddZone').css("display","");
	                }
					
				    $('#notice_seq').val(notice_seq);
				    $('#showYN').val(showYN);
				    $('#title').val(title);
				    $('#writerName').html(writerName);
				    $('#regDate').html(regDate);
				    $('#writerZone').css("display", "");
				    $('#actionButton').text('수정');
				  
				    
	            },error : function(data){
	            	
	            }
			});
			
		}else{ //신규작성일때
			

		
    		$('#mode').val('register');
    		$('#fileListZone').css("display","none");
    		$('#actionButton').text('등록');
			$('#noticeInfo_Form').resetForm();
			$('#custNameZone').css("display","none");
			$('#cust_name').val("");
			$('#writerZone').css("display", "none");
			$('#contents').val("");
		    oEditors.getById["contents"].exec("LOAD_CONTENTS_FIELD");

		}
	
		$('#noticeInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
		oEditors.getById["contents"].exec("CHANGE_EDITING_MODE",['WYSIWYG']);

	}
		


	
	function noticeInfoLayer_Close(){
		$('#noticeInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}
	
	function GoActionButton(){
		var mode = $('#mode').val();
		var target = '';
		var msg = "";
		var param = "";

		
		if (mode == "register"){
			target = "/notice/create";
			msg = "등록하였습니다.";
		}else if (mode == "view"){
			target = "/notice/edit";
			msg = "수정하였습니다.";
		}
		 
		
		    
		if ( isEmpty($('input[name="cust_choice"]:checked').val()) ){
			alert("분류를 선택하세요.")
			return false;
		}else{
			var choice = $('input[name="cust_choice"]:checked').val();
			if (choice =='Y'){
				if (isEmpty($('#cust_name').val())) {
					alert("공급사를 선택하세요.")
					return false;
				}
			}
		}
		
		if (isEmpty($('#title').val())){
			alert("제목을 입력하세요.");
			return false;
		}

		param = $("#noticeInfo_Form").serializeObject();

	    oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);
	    
	    var bodyVal = $("#contents").val();
	    bodyVal = bodyVal.replace(unescape("%uFEFF"), "");
	    text = bodyVal.replace("<br>", ""); 
	
		if (isEmpty(text)) {
			alert("내용을 입력하세요.");
			return false;
		}

	    param.contents = bodyVal;
	    var formData = new FormData();
	    formData.append("content", new Blob([JSON.stringify(param)], {type: "application/json;charset=utf-8"}));
	   
	    var uploadFileList = Object.keys(fileList);
	    for(var i = 0; i < uploadFileList.length; i++){
	      formData.append('files', fileList[uploadFileList[i]]);
	    }
	    
	    $.ajax({
	        type: "post",
	        url: target,
	        contentType: false,
	        processData: false,
	        async: false,
	        data: formData
	      }).done(function (response) {
	        if (response.success) {
	            alert(msg);
	            noticeInfoLayer_Close();
	            location.reload(true);
	        } else {
	        	alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
	        	location.reload();
	        }
	      });
		
		
	}

function choiceCust(cust_seq, no, cust_name){
	$('#cust_seq').val(cust_seq);
	$('#cust_name').val(cust_name);
}
	
</script>

					<h3 class="mjtit_top">
						공지사항
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/notice/list">
                    	<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>

                    <div class="srch_all">

                    	<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>                       
	                            <option value="TITLE" <c:if test="${search.search_type == 'TITLE'}">selected</c:if>>제목</option>                                 
                            </select>
                    	</div>

                    	 <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}"/>
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                              <button type="button" class="btn_01">초기화</button> 
                          </div>
                          
                          <div class="register_btn">
                        <button type="button" class="btn_02 popLayermaterialRegistBtn" onclick="registerNotice('register');">신규등록</button>
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
			                            <option value="15">15개씩 보기</option>
			                            <option value="30">30개씩 보기</option>
			                            <option value="50">50개씩 보기</option>
			                            <option value="100">100개씩 보기</option>
			                        </select>
		                        </div>
							</div>
	                    </div>
	                    <div class="scroll">
	                  	<table class="master_01">
	                    		<colgroup>
	                    			<col style="width: 55px;"/>
	                    			<col style="width: 115px;"/>
	                    			<col style="width: 280px;"/>
	                    			<col style="width: 210px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 90px;"/>
	                    		</colgroup>
	           		        	<thead>
	                    			<tr>
	                    				<th>No</th>
	                    				<th>분류</th>
	                    				<th colspan="2">제목</th>
	                	   				<th>작성자</th>
										<th>등록일</th>
	                    				<th>관리</th>
    		               			</tr>
	                    		</thead>
	                    		<tbody>
	                    			<c:forEach items="${list}" var="list" varStatus="status">
		                    			<tr>
		                    				<td class="num"><fmt:formatNumber value="${total +1 - list.no}" pattern="#,###,###"/></td>
		                    				<td class="day">
		                    				<c:if test="${list.cust_name == null}">
		                    					<span>전체</span>
		                    				</c:if>
		                    				<c:if test="${list.cust_name != null}">
		                    					<span>공급사</span>
		                    				</c:if>
		                    				</td>
		                    				<td class="prod" colspan="2">
			                    				<a href="#" onclick="viewNoticeDetail('${list.notice_seq}','view');">${list.title}</a>
			                    				<a href="#" onclick="viewNoticeDetail('${list.notice_seq}','view');" class="m_link">${list.title}</a>
		                    				</td>
		       								<td class="sang t_left">${list.writerName}</td>
		                    				<td class="day">${list.regDate}</td>
		                    				<td class="num"><a href="#" class="btn_03 btn_s" onclick="deleteNotice('${list.notice_seq}');">삭제</a></td>
		                    			</tr>
	                    			</c:forEach>
									<c:if test="${empty list }">
										<tr><td colspan="7">등록된 공지사항이 없습니다.</td></tr>
									</c:if>
	                    			
	                    		</tbody>
	                    	</table>
	                    </div>
                     	<div class="mjpaging_comm">
            				${dh:pagingB(total, currentPage, rowsPerPage, 10, parameter)}
       					 </div> 
                    </div>
 					
 			<div class="master_pop master_pop01" id="noticeInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="noticeInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01"  >
					<div class="pop_inner" style="min-width: 800px;">
					<form id="noticeInfo_Form" name="noticeInfo_Form" >
						<input type="hidden" id="mode" name="mode"/>
						<input type="hidden" id="cust_seq" name="cust_seq" value="0"/>
						<input type="hidden" id="notice_seq" name="notice_seq"/>
						
						<h3>공지사항 등록/조회<a class="back_btn" href="#" onclick="noticeInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

						<div class="master_list master_listB">
							<table class="master_02 master_04">	
								<colgroup>
									<col style="width: 150px"/>
									<col style="width: 34.8%"/>
									<col style="width: 150px"/>
									<col style="width: 34.8%"/>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">분류</th>
										<td colspan="3">
											<div class="radiobox"> 
											<label>
											<input type="radio" id="cust_choiceN" name="cust_choice" checked value="N" onclick="chkCust(this);"/>
											<span>전체</span>
											</label>
											<label>
											<input type="radio" id="cust_choiceY" name="cust_choice" value="Y" onclick="chkCust(this);"/>
											<span>선택</span>
											</label>
											</div>
										</td>															
									</tr>
									
									<tr id="custNameZone" style="display:none;">
										<th scope="row">공급사명</th>
										<td colspan="3"><input type="text" id="cust_name" name="cust_name" class="all" onclick="openLayer();" readonly /></td>															
									</tr>
									
									<tr>
										<th scope="row">게시여부</th>
										<td colspan="3">
											<div class="sel_wrap">													
												<select class="sel_02" id="showYN" name="showYN">
													<option value="Y">게시</option>
													<option value="N">미게시</option>
																			
												</select>															
											</div>
										</td>	
									</tr>
									<tr id="writerZone" style="display:none;">
										<th scope="row">작성자</th>
										<td><span id="writerName"></span></td>
										
										<th scope="row">작성일자</th>
										<td><span id="regDate"></span></td>																	
									</tr>
								
									<tr>
										<th scope="row">제목</th>
										<td colspan="3"><input type="text" id="title" name="title" class="all"/></td>					
										
									</tr>
									
									<tr id="fileListZone">
										<th scope="row">첨부파일</th>
										<td colspan="3"><div id="fileList" class="file_del"></div><a href="#" class="del_close" onclick="deleteFile();">삭제</a>
										</td>	
									</tr>
									
									<tr id="fileAddZone">
					                    <th>파일첨부</th>
					                    <td colspan="3">
					                      <div class="file_area">				                    
					                        <input type="file" id="file1" name="file1" />
					                         <input class="fileName1" type="text"  value="" readonly/><label for="file1" class="clr">파일첨부</label><br/>
					                      </div>
					              		</td>
                  					</tr>
                  					
									<tr>
										<th scope="row">내용</th>
										<td colspan="3">
						                <textarea id="contents" name="contents" rows="10" cols="30" style="width:100%;height:500px;"></textarea>
										</td>
									</tr>
								

									<input type="file" name="" id="uploadInput" style="display:none" multiple>
									
								</tbody>
							</table>
						</div>
	
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="noticeInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02"></a> 
						</div>
						<div id="popup" class="layer_pop">	
							<div class="handle_wrap">
								<div class="handle"><span>공급사 리스트</span></div>
								<div class="drag_fix"><a href="#" onclick="closeLayer(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
							</div>
							<iframe src="" id="popupframe"></iframe>							
						</div>
						
					</form>
				</div>
		
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="noticeInfoLayer_Close();"><span>닫기</span></a>
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
 
 function chkCust(obj){
	var value = obj.value;
	
	if (value=='Y'){
		$('#custNameZone').css("display", "");
	}else{
		$('#custNameZone').css("display", "none");
	}
 }
 

function openLayer() {
	if (sessionCheck()){
		var url = "/supply/popSupplyList?type=notice";
		$('#popup').css('display','block');
		$('#popupframe').attr('src',url);
		$('html,body').css('overflow','hidden');
	}else{
		location.reload(true);
	}

	
	/* 	var frameH ;
	setTimeout(function() {
	frameH = $('#popupframe').contents().find('.pop_wrap').innerHeight();
	frameW = $('#popupframe').contents().find('.pop_wrap').innerWidth();
			
	},1000) */

}
		
function closeLayer() {
	$('#popup').css('display','none');
	$('#popupframe').removeAttr('src');
	$('html,body').css('overflow','');
}

</script>
	