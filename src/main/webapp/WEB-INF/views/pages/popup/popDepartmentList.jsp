<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript" src="/js/common/paging.js"></script>


<script>

	$(document).ready(function() {
		parent.changeFrame4()
		$('.master_order').click(function() {
			$('.layer_pop', parent.document).removeClass('focus');
			$('#department_popup', parent.document).addClass('focus');
		
		})
		goPopSearch();
	})
	function goPopSearchAction(){

		var formData = $('#searchPopForm').serialize();
		 $.ajax({
		       type : "post",
		       url : '/department/getDepartmentList',
		       data:  formData,
		       success : function(data) {

		    	   var map = data.storeData;
		    	   var list = map.list;
		    	   var total = map.total;
		    	   var search = map.search;
		    	   var text = "";
		    	   console.log(data);
		    	   if (list.length > 0){
		    		   for (var i in list){
			    		   text += "<tr onclick='choiceDepartment(\""+list[i].dpt_code+"\",\""+list[i].dpt_name+"\");'>";
			    		   text += "<td class='code'>"+list[i].dpt_code+"</td>";
			    		   text += "<td class='code'>"+list[i].dpt_name+"</td>";
			    		   // text += "<td class='code'>"+list[i].leader+"</td>";
			    		   // text += "<td class='name'>"+list[i].empCnt+"</td>";
			    		   text += "</tr>";
			    	   }
		    	   }else{
		    		   text ="<tr><td colspan='4'>부서 정보가 없습니다.</td></tr>"
		    	   }

		    	   $('#result2').html(text);
		    	   $('#dataCnt_1').html(total);
		    	   $('#paging').html(paging(total, search.currentPage, search.rowsPerPage, 5,""));


		       },error : function(data){

		    	   parent.departmentSearch_close();
		       }
		 });
	}
	
	function goPopReset(){
		$('#searchPopForm').resetForm();
	}
	
	function choiceDepartment(dpt_code, dpt_name){

	 	parent.document.producePlanInfo_Form.dpt_code.value = dpt_code;
		parent.document.producePlanInfo_Form.dpt_name.value = dpt_name;
		parent.departmentSearch_close();	
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
					<h3>부서 리스트<a class="back_btn" href="#" onclick="parent.departmentSearch_close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
					<div class="master_cont">
					<form id="searchPopForm" action="/department/popDepartmentList">
						<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
						<input type="hidden" id="currentPage" name="currentPage"/>
						<input type="hidden" id="param" name="param"/>
						<div class="srch_all">
	        				<div class="sel_wrap sel_wrap1">
	                    		<select name="search_type" class="sel_02"> 
		                            <option value="ALL" >전체</option>                       
		                            <option value="DPT_NAME">부서명</option>
                       				<option value="DPT_CODE">부서코드</option>
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
                    			<col style="width: 55px;"/>
                    			<col style="width: 115px;"/>

 
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>부서코드</th>
                    				<th>부서명</th>                   							
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
					<a href="#" class="p_btn_01" onclick="parent.departmentSearch_close();">닫기</a>
				</div>
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="parent.departmentSearch_close();"><span>닫기</span></a>
			</div>
		</div>
	</div>
</div>

