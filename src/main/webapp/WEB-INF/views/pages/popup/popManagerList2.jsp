<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript" src="/js/common/paging.js"></script>


<script>

	$(document).ready(function() {
		parent.changeFrame3()
		$('.master_order').click(function() {
			$('.layer_pop', parent.document).removeClass('focus');
			$('#manager_popup', parent.document).addClass('focus');
		
		})
		goPopSearch();
	})
	function goPopSearchAction(){	
			
		var formData = $('#searchPopForm').serialize();
		 $.ajax({
		       type : "post",            
		       url : '/as/getManagerList',            
		       data:  formData,
		       success : function(data) {
		    	   var map = data.storeData;
		    	   var list = map.list;
		    	   var total = map.total;
		    	   var search = map.search;
		    	   var text = "";
		    	   
		    	   if (list.length > 0){
		    		   for (var i in list){
			    		   text += "<tr onclick='choiceManager(\""+list[i].manager_seq+"\",\""+list[i].auth_group_name+"\",\""+list[i].manager_name+"\",\"" + list[i].manager_position +"\");'>";
			    		   text += "<td class='code'>"+list[i].auth_group_name+"</td>";
			    		   text += "<td class='code'>"+list[i].manager_name+"</td>";
			    		   text += "<td class='code'>"+list[i].manager_position+"</td>";
			    		   text += "</tr>";
			    	   }
		    	   }else{
		    		   text ="<tr><td colspan='4'>담당자 정보가 없습니다.</td></tr>"
		    	   }
		    	  
		    	   $('#result2').html(text);
		    	   $('#dataCnt_1').html(total);
		    	   $('#paging').html(paging(total, search.currentPage, search.rowsPerPage, 5,""));
		    	  
		    	   
		       },error : function(data){
		           
		    	   parent.managerSearch_close();
		       }
		 });
	}
	
	function goPopReset(){
		$('#searchPopForm').resetForm();
	}
	
	function choiceManager(manager_seq, auth_group_name, manager_name, manager_position){

	 	parent.document.asplanInfo_Form.manager_seq.value = manager_seq;
		parent.document.asplanInfo_Form.auth_group_name.value = auth_group_name;
		parent.document.asplanInfo_Form.manager_name.value = manager_name + " " + manager_position;
		parent.managerSearch_close();	
	}
    
	function linkpage(no){
		$('#currentPage').val(no);
		goPopSearchAction();
	}
	
	function goPopSearch(){
		$('#currentPage').val(1);
		goPopSearchAction();
	}
	function runScript(e) {
	    if(e.keyCode == 13) { // enter는 13이다!
	        goPopSearch();
	        return false; // 추가적인 이벤트 실행을 방지하기 위해 false 리턴
	    } else {
	        return true;
	    }
	}
	
</script>
<div class="master_pop master_order view" id="BusinessNumSearch" >
	<div class="master_body">
		<div class="pop_wrap pop_wrap_02">
			<div class="pop_inner">
				<div class="master_wrap master_layer">
					<h3>담당자 리스트<a class="back_btn" href="#" onclick="parent.managerSearch_close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
					<div class="master_cont">
					<form id="searchPopForm" action="/as/popManagerList">
						<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
						<input type="hidden" id="currentPage" name="currentPage"/>
						<input type="hidden" id="param" name="param"/>
						<div class="srch_all">
	        				<div class="sel_wrap sel_wrap1">
	                    		<select name="search_type" class="sel_02"> 
		                            <option value="ALL" >전체</option>                       
		                            <option value="DPT_NAME">부서명</option>
		                            <option value="E_NAME">담당자명</option>
	                                  
	                            </select>
	                    	</div>
	
	                    	 <input type="text" class="srch_input01 srch_input02"  name="search_string"   onkeypress="return runScript(event)" />
	                    	 <div class="srch_btn">
	                    	 	 <button type="button" class="btn_02" onclick="goPopSearch();">검색</button>
	                              <button type="button" class="btn_01" onclick="goPopReset();">초기화</button> 
	                          </div>
	                      </div>
		              </form>
		              </div>
                    <div class="master_list " id="list">
						<div class="list_set ">
	                    
	                    </div>
	              		<div class="scroll">
                    	<table class="master_01">
                    		<colgroup>
                    			<col/>
                    			<col style="width: 140px;">
                    			<col style="width: 150px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>부서명</th>                   													       
									<th>사원명</th> 
									<th>직책</th>   				
                    			</tr>
                    		</thead>
                    		<tbody id="result2">
		
                    		</tbody>
                    	</table>
                    	</div>
						<div id="paging" class="mjpaging_comm">
            				
       					 </div>  
	                  
                   </div>
				</div>
				
				<div class="pop_btn clearfix">
					<a href="#" class="p_btn_01" onclick="parent.managerSearch_close();">닫기</a>
				</div>
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="parent.managerSearch_close();"><span>닫기</span></a>
			</div>
		</div>
	</div>
</div>

