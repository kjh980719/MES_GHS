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
			 elPlaceHolder: "contents2",
			 sSkinURI: "/se2/SmartEditor2Skin.html",
			 fCreator: "createSEditor2",
			 htParams : {fOnBeforeUnload : function(){}},

			 fOnAppLoad: function (){
				var width="100%"; // 원하는 너비
				var height=570; // 원하는 너비
 				$("#contents2").css('width',width);
				$("#contents2").css('height',height);
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
    
    $(document).ready(function() {
        var fileForm = $('#file2');
        fileForm.on('change', function(){
          if(window.FileReader){
            var filename = $(this)[0].files[0].name;
            $(this).siblings('.fileName2').val(filename);
            for(var i = 0; i < $(this)[0].files.length; i++){
               // console.log($(this)[0].files[i]);
              }
            selectFile($(this)[0].files);
          } else {
            var filename = $(this).val().split('/').pop().split('\\').pop();
            $(this).siblings('.fileName2').val(filename);
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
      
      
      $('#file2').change(function(e){
        //console.log($(this)[0].files);
        selectFile($(this)[0].files);
        for(var i = 0; i < $(this)[0].files.length; i++){
          //console.log($(this)[0].files[i]);
        }
      })

      
})

	function goSearch(){
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}
	
	function goReset(){
		$('#searchForm').resetForm();
	}
	
	function viewQnaDetail(qna_seq, type){
		qnaInfoLayer_Open(qna_seq, type);
	}
	function registerQna(type){
	
		if (sessionCheck()){
			qnaInfoLayer_Open("", type)
		}else{		
			location.reload(true);
		}
	
	}
	function deleteFile(){
	
		
		$.ajax({
            type : "get",
            url : '/qna/deleteFile',
            async : false,
            data: "qna_seq="+$('#qna_seq').val(), 
            success : function(data) {
            	alert('첨부파일 삭제하였습니다.');
            	$('#fileListZone').css("display","none");
        		$('#fileAddZone').css("display","");
            },error : function(data){
            	alert('데이터 오류입니다.');
            }
		})
	}
	function viewAnswer(){
		$('#replyZone').css("display", "");
		$('#actionButton').css("display","")
		$('#goAnswer').css("display","none");

		oEditors.getById["contents2"].exec("LOAD_CONTENTS_FIELD");
		oEditors.getById["contents2"].exec("CHANGE_EDITING_MODE",['WYSIWYG']);

		
	}
	function qnaInfoLayer_Open(qna_seq, type){
		
		var text = "";
		if (type=="view"){ //상세보기


			$.ajax({
	            type : "get",
	            url : '/qna/view',
	            async : false,
	            data: "qna_seq="+qna_seq, 
	            success : function(data) {

	            	var result = data.storeData;
					var info = result.info;
					var fileList =result.fileList;
					var fileList2 =result.fileList2;
					var text = "";
					
					var replyYN = info.replyYN;
					var qna_seq = info.qna_seq;
					var cust_seq = info.cust_seq;
					
					var replyDate = info.replyDate;
					var replyName = info.replyName;				
					var regDate = info.regDate;
					var writerName = info.writerName;
					
					var title = info.title;
					var contents = info.contents;
					var title2 = info.title2;
					var contents2 = info.contents2;

					$('#qna_seq').val(qna_seq);
					$('#cust_seq').val(cust_seq);
					
					$('#writerName').empty();
				    $('#regDate').empty();
					$('#title').empty();
				    $('#contents').empty();
				    
					$('#writerName').html(writerName);
				    $('#regDate').html(regDate);
					$('#replyName').html(replyName);
				    $('#replyDate').html(replyDate);
				    
					$('#title').html(title);
				    $('#contents').html(contents);
				
					if (fileList.length > 0){                  	
						text = "<a href='javascript:void(0);' onclick='self.location=\"/download/"+fileList[0].file_key+"\"; return false;'><img src='../../../../images/btn_file.gif'/>"+fileList[0].file_name+"</a>";		                   	
	                   	$('#fileList').empty();
	                   	$('#fileList').html(text);
	                }else{
	                	$('#fileList').empty();
	                }
					
					if (fileList2.length > 0){	                   	
						text = "<a href='javascript:void(0);' onclick='self.location=\"/download/"+fileList2[0].file_key+"\"; return false;'><img src='../../../../images/btn_file.gif'/>"+fileList2[0].file_name+"</a>";		                   	
	                   	$('#fileList2').empty();
	                   	$('#fileList2').html(text);
						$('#fileAddZone').css("display", "none");
						$('#fileListZone').css("display", "");
	                }else{
	                	$('#fileList2').empty();
	                	$('#fileAddZone').css("display", "");
						$('#fileListZone').css("display", "none");
	                }
					
					if (replyYN == 'Y'){

						$('#mode').val('view');
						$('#title2').val(title2);					   
						$('#actionButton').text('답변수정');
						$('#contents2').val(contents2);
					    oEditors.getById["contents2"].exec("LOAD_CONTENTS_FIELD");		
					    
						$('#writerZone').css("display", "");
						$('#goAnswer').css("display","none");
						$('#actionButton').css("display","");
						$('#replyZone').css("display", "");
					
					}else {
					
						$('#mode').val('register');					
						$('#title2').val("");
						$('#file2').val("");
						$('#contents2').val("");
						
					   
						$('#actionButton').text('답변작성');
						
						$('#writerZone').css("display", "none");
						$('#fileAddZone').css("display", "");
						$('#fileListZone').css("display", "none");
						$('#goAnswer').css("display", "");
						$('#actionButton').css("display","none");
						$('#replyZone').css("display", "none");
						 
					}
					

	            },error : function(data){
	            	
	            }
			});
			
		}
		oEditors.getById["contents2"].exec("LOAD_CONTENTS_FIELD");
		$('#qnaInfoLayer').addClass('view');
		$('html,body').css('overflow','hidden');
		$('.leftNav').removeClass('view');
		oEditors.getById["contents2"].exec("CHANGE_EDITING_MODE",['WYSIWYG']);

	}
		


	
	function qnaInfoLayer_Close(){
		$('#qnaInfoLayer').removeClass('view');
		$('html,body').css('overflow','');
		$('.info_edit').removeClass('view');		
	}
	
	function GoActionButton(){
		var mode = $('#mode').val();
		var target = '';
		var msg = "";
		var param = "";

		
		if (mode == "register"){
			target = "/qna/reply?qna_seq=" + $('#qna_seq').val();
			msg = "등록하였습니다.";
		}else if (mode == "view"){
			target = "/qna/replyEdit?qna_seq=" + $('#qna_seq').val();
			msg = "수정하였습니다.";
		}
		 

		if (isEmpty($('#title2').val())){
			alert("제목을 입력하세요.");
			return false;
		}

		param = $("#qnaInfo_Form").serializeObject();

	    oEditors.getById["contents2"].exec("UPDATE_CONTENTS_FIELD", []);
	    
	    var bodyVal = $("#contents2").val();
	    bodyVal = bodyVal.replace(unescape("%uFEFF"), "");
	    text = bodyVal.replace("<br>", ""); 
	
		if (isEmpty(text)) {
			alert("내용을 입력하세요.");
			return false;
		}
		
	    param.contents2 = bodyVal;
	    var formData = new FormData();
	    formData.append("content", new Blob([JSON.stringify(param)], {type: "application/json;charset=utf-8"}));

	    var uploadFileList = Object.keys(fileList);
	    for(var i = 0; i < uploadFileList.length; i++){
	      formData.append('files', fileList[uploadFileList[i]]);
	    }
	    
	    $.ajax({
	        type : "post",
	        url : target,
	        contentType : false,
	        processData : false,
	        async : false,
	        data : formData,
	        success : function(result) {
	 
	                if(result.success){
	                	alert(msg);
	     	            qnaInfoLayer_Close();
	     	            location.reload(true);
	                }else{
	                    alert("오류로 정상처리 되지 못하였습니다.\n관리자에게 문의해 주세요.");
	                    location.reload();
	                }
	            },
	            error : function(xhr, status, error) {
	                alert("xhr:"+xhr.readyState +"\n"+"xhr:"+xhr.status +"\n"+"xhr:"+xhr.responseText +"\n"+"status:"+status+"\n"+"error:"+error);
	            }
	      })
		
	}
	
	
	
</script>

					<h3 class="mjtit_top">
						1:1문의
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
				
        <!--  관리자  검색시작-->
        			<div class="master_cont">
                   
                    <form id="searchForm" action="/qna/list">
                    	<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
						<input type="text" style="display:none;"/>
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
	                    				<th colspan="3">제목</th>
	                	   				<th>작성자</th>
										<th>등록일</th>
	                    				<th>답변여부</th>
    		               			</tr>
	                    		</thead>
	                    		<tbody>
	                    			<c:forEach items="${list}" var="list" varStatus="status">
		                    			<tr>
		                    				<td class="num"><fmt:formatNumber value="${total +1 - list.no}" pattern="#,###,###"/></td>
		                    				<td class="prod" colspan="3">
			                    				<a href="#" onclick="viewQnaDetail('${list.qna_seq}','view');">${list.title}</a>
			                    				<a href="#" onclick="viewQnaDetail('${list.qna_seq}','view');" class="m_link">${list.title}</a>
		                    				</td>
		       								<td class="sang t_left">${list.writerName}</td>
		                    				<td class="day">${list.regDate}</td>
		       								<td class="day">
		       									<c:choose>
		       										<c:when test="${list.replyYN == 'Y'}">
		       											답변완료
		       										</c:when>
		       										<c:when test="${list.replyYN == 'N'}">
		       											문의중
		       										</c:when>
		       									</c:choose>
		       								</td>
		                    			</tr>
	                    			</c:forEach>
									<c:if test="${empty list }">
										<tr><td colspan="5">등록된 1:1문의가 없습니다.</td></tr>
									</c:if>
	                    			
	                    		</tbody>
	                    	</table>
	                    </div>
                     	<div class="mjpaging_comm">
            				${dh:pagingB(total, currentPage, rowsPerPage, 10, parameter)}
       					 </div> 
                    </div>
 					
 			<div class="master_pop master_pop01" id="qnaInfoLayer">
			<div class="master_body">
			<div class="pop_bg" onclick="qnaInfoLayer_Close();"></div>
				<div class="pop_wrap pop_wrap_01" >
					<div class="pop_inner" style="min-width: 800px;">
					<form id="qnaInfo_Form" name="qnaInfo_Form" >
						<input type="hidden" id="mode" name="mode"/>
						<input type="hidden" id="cust_seq" name="cust_seq" value="0"/>
						<input type="hidden" id="qna_seq" name="qna_seq"/>
						
						<h3>1:1문의 조회<a class="back_btn" href="#" onclick="qnaInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
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
										<th scope="row">작성자</th>
										<td><span id="writerName"></span></td>
										
										<th scope="row">작성일자</th>
										<td><span id="regDate"></span></td>																	
									</tr>
								
									<tr>
										<th scope="row">제목</th>
										<td colspan="3"><span id="title"></span></td>					
										
									</tr>
									<tr>
										<th scope="row">첨부파일</th>
										<td colspan="3"><div id="fileList" class="file_del"></div>
										</td>	
									</tr>

									<tr>
										<th scope="row">내용</th>
										<td colspan="3">
						                <div id="contents"></div>
										</td>
									</tr>
								
						
									

								</tbody>
							</table>
						</div>
						<div id="replyZone" class="answer_box">
						<h3>답변</h3>
							<div class="master_list master_listB">
							<table class="master_02 master_04">
									<colgroup>
										<col style="width: 150px"/>
										<col style="width: 34.8%"/>
										<col style="width: 150px"/>
										<col style="width: 34.8%"/>
									</colgroup>
									<tbody>
									<tr id="writerZone" style="display:none;">
										<th scope="row">작성자</th>
										<td><span id="replyName"></span></td>
										
										<th scope="row">작성일자</th>
										<td><span id="replyDate"></span></td>																	
									</tr>
									
									<tr>
										<th scope="row">제목</th>
										<td colspan="3"><input type="text" id="title2" name="title2" class="all"/></td>					
										
									</tr>
									<tr id="fileListZone">
										<th scope="row">첨부파일</th>
										<td colspan="3"><div id="fileList2" class="file_del"></div><a href="#" class="del_close" onclick="deleteFile();">삭제</a>
										</td>	
									</tr>
									<tr id="fileAddZone">
					                    <th>파일첨부</th>
					                    <td colspan="3">
					                      <div class="file_area">				                    
					                        <input type="file" id="file2" name="file2" />
					                         <input class="fileName2 " type="text"  value="" readonly/><label for="file2" class="clr">파일첨부</label><br/>
					                      </div>
					              		</td>
                  					</tr>
									<tr>
										<th scope="row">내용</th>
										<td colspan="3">
						                <textarea id="contents2" name="contents2" rows="10" cols="30" style="width:100%;height:500px;"></textarea>
										</td>
									</tr>
								

									<input type="file" name="" id="uploadInput" style="display:none" multiple>
									
									</tbody>
								</table>
							
						</div>
						</div>
						<div class="pop_btn clearfix" >
							<a href="#" class="p_btn_01" onclick="qnaInfoLayer_Close();">닫기</a>
							<a id="actionButton" href="#" class="p_btn_02" onclick="GoActionButton();" ></a> 
							<a id="goAnswer" href="#" class="p_btn_02" onclick="viewAnswer();" >답변하기</a> 
						</div>

					</form>
				</div>
		
				<div class="group_close">
					<a href="#" class="getOrderView_close" onclick="qnaInfoLayer_Close();"><span>닫기</span></a>
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
      imageUploadProcess2($(this)[0].files[i]);
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
	