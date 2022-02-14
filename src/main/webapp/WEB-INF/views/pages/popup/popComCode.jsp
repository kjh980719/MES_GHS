<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript" src="/js/common/paging.js"></script>


<script>

	$(document).ready(function() {

		$('.master_order').click(function() {
			$('.layer_pop', parent.document).removeClass('focus');
			$('#popup', parent.document).addClass('focus');
		
		})
		goPopSearchAction();
	})
	function goPopSearchAction(){	
			
		var formData = $('#searchPopForm').serialize();
		 $.ajax({
		       type : "post",            
		       url : '/code/getPopComCodeList',
		       data:  formData,
		       success : function(data) {
					console.log(data);
		    	   var map = data.storeData;
		    	   var list = map.list;
		    	   var total = map.total;
		    	   var search = map.search;
		    	   var text = "";
				   if (list.length > 0){
				   	for (var i in list){
						text += "<tr onclick='choiceCode(\""+list[i].code+"\",\""+list[i].code_nm+"\");'>";
						text += "<td class='num'>"+(total + 1 - list[i].no)+"</td>";
						text += "<td class='code'>"+list[i].code_nm+"</a></td>";
						text += "<td class='code'>"+list[i].code_dc+"</a></td>";
						text += "<td class='name'>"+list[i].use_yn+"</td>";
						text += "</tr>";
					}
				   }
		    	   $('#result2').html(text);
		    	   $('#dataCnt_1').html(total);
		    	   $('#paging').html(paging(total, search.currentPage, search.rowsPerPage, 5,""));

				   parent.changeFrame();
		       },error : function(data){

				 parent.closeLayer();
		       }
		 });
	}
	
	function goPopReset(){
		$('#searchPopForm').resetForm();
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
	function choiceCode(code, code_nm){
		if ("${code_id}" == "CT"){
			parent.document.custInfo_Form.CUST_GROUP1.value = code;
			parent.document.custInfo_Form.CUST_GROUP1_TEXT.value = code_nm;
			parent.closeLayer();
		}else if("${code_id}" == "CLIST"){
			parent.document.custInfo_Form.CUST_GROUP2.value = code;
			parent.document.custInfo_Form.CUST_GROUP2_TEXT.value = code_nm;
			parent.closeLayer();
		}


	}
	
</script>
<div class="master_pop master_order view" id="BusinessNumSearch" >
	<div class="master_body">
		<div class="pop_wrap pop_wrap_02">
			<div class="pop_inner">
				<div class="master_wrap master_layer">
					<h3>거래처 리스트<a class="back_btn" href="#" onclick="layer_close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
					<div class="master_cont">
					<form id="searchPopForm" action="/com/popComCode">
						<input type="hidden" id="rowsPerPage" name="rowsPerPage" value="5"/>
						<input type="hidden" id="currentPage" name="currentPage" value="1"/>
						<input type="hidden" id="param" name="param"/>
						<input type="hidden" id="code_id" name="code_id" value="${code_id}"/>
						<div class="srch_all">
	        				<div class="sel_wrap sel_wrap1">
	                    		<select name="use_yn" class="sel_02">
									<option value="Y">사용</option>
									<option value="N">미사용</option>
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

                    			<col style="width: 165px;"/>
                    			<col style="width: 165px;"/>
                    			<col style="width: 120px;"/>
 
                    		</colgroup>
                    		<thead>
                    			<tr>
									<th>NO</th>
									<th>코드명</th>
                    				<th>코드설명</th>
                    				<th>사용여부</th>
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
					<a href="#" class="p_btn_01" onclick="layer_close();">닫기</a>
				</div>
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="layer_close();"><span>닫기</span></a>
			</div>
		</div>
	</div>
</div>

