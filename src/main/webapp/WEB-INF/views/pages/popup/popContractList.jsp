<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript" src="/js/common/paging.js"></script>

<script>
	$(document).ready(function() {
		parent.changeFrame6()
		$('.master_order').click(function() {
			$('.layer_pop', parent.document).removeClass('focus');
			$('#order_popup', parent.document).addClass('focus');

		})
		goPopSearch();
	})
	function goPopSearchAction(){
		var formData = $('#searchPopForm').serialize();
		 $.ajax({
		       type : "post",            
		       url : '/order/getPopContractList',
		       data:  formData,
		       success : function(data) {
		    	   var map = data.storeData;
		    	   var list = map.list;
		    	   var total = 0;
		    	   var search = map.search;
				   var contractStatus = map.contractStatus;
				   var text = "";

				   if (list.length > 0){
					   total = list[0].total;
		    		   for (var i in list){
			    		   text += "<tr onclick='choiceorder(\""+list[i].contract_seq+"\")'>";
			    		   text += "<td class='num'>"+list[i].no+"</td>";
			    		   text += "<td class='code'>"+list[i].contract_code+"</td>";
			    		   text += "<td class='sang t_left'>"+list[i].pdt_name+"</td>";
			    		   text += "<td class='name'>"+ list[i].buyer_name+"</td>";
			    		   text += "<td class='name'>"+ list[i].contract_date+"</td>";
						   text += "<td class='ing'>";
						   for(var j in contractStatus){
							   if (contractStatus[j].code == list[i].contract_status){
								   text += contractStatus[j].code_nm;
							   }
						   }
						   text += "</td></tr>";
			    	   }
		    	   }else{
		    		   text ="<tr><td colspan='6'>수주 정보가 없습니다.</td></tr>";
		    	   } 
		    	  
		    	   $('#result2').html(text);
		    	   $('#dataCnt_1').html(total);
		    	   $('#paging').html(paging(total, search.currentPage, search.rowsPerPage, 5,""));

		       },beforeSend : function(){
		    	   $('.wrap-loading').removeClass('display-none');
		       },complete : function(){
		    	   $('.wrap-loading').addClass('display-none');
		       },error : function(data){
				 order_close();
		       }
		       
		 });
	}
	
	function goPopReset(){
		$('#searchPopForm').resetForm();
	}
	
	function choiceorder(contract_seq){
	
		$.ajax({
		       type : "get",            
		       url : '/order/getPopContractInfo',
		       data:  "contract_seq="+contract_seq,
		       success : function(data) {
		    		parent.PopOrderAdd(data);
		    		order_close();
		       },error : function(data){
					order_close();
		       }
		      
		});

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
	    if(e.keyCode == 13) { 
	        goPopSearch();
	        return false; // 추가적인 이벤트 실행을 방지하기 위해 false 리턴
	    } else {
	        return true;
	    }
	}

</script>
<div class="master_pop master_order view" id="orderSearch" >
	<div class="master_body">
		<div class="pop_wrap pop_wrap_02">
			<div class="pop_inner">
				<div class="master_wrap master_layer">
					<h3>수주 리스트<a class="back_btn" href="#" onclick="order_close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
					<div class="master_cont">
					<form id="searchPopForm" action="/order/getPopOrderList">
						<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
						<input type="hidden" id="currentPage" name="currentPage"/>
						<div class="srch_all">
							<div class="sel_wrap sel_wrap1">
								<select name="search_type" class="sel_02">
									<option value="ALL" selected="selected">전체</option>
									<option value="CONTRACT_CODE">수주번호</option>
									<option value="PDT_NAME">품목명</option>
									<option value="SUPPLY_NAME">공급사명</option>
								</select>
							</div>
							 <input type="text" class="srch_input01 srch_input02" name="search_string" onkeypress="return runScript(event)"/>
							 <div class="srch_btn">
								 <button type="button" class="btn_02" onclick="goPopSearch();">검색</button>
								  <button type="button" class="btn_01" onclick="goPopReset();">초기화</button>
							  </div>
						</div>
		              </form>
		              </div>
                    <div class="master_list " id="list">
                    	<div class="list_set ">
	                    	<div class="set_left">
								총 <span id="dataCnt_1" ></span> 건
							</div>
							
	                    </div>
	                    
	              		<div class="scroll">
                    	<table class="master_01">
                    		<colgroup>
                    			<col style="width: 55px;"/>
                    			<col style="width: 150px;"/>
                    			<col style="width: 300px;"/>
                    			<col style="width: 200px;"/>
                    			<col style="width: 120px;"/>
                     			<col style="width: 100px;"/>
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
									<th>수주번호</th>
									<th>품목명</th>
									<th>공급사명</th>
									<th>발주일자</th>
									<th>진행상태</th>
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
					<a href="#" class="p_btn_01" onclick="order_close();">닫기</a>
				</div>
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="order_close();"><span>닫기</span></a>
			</div>

		</div>
	</div>
</div>



