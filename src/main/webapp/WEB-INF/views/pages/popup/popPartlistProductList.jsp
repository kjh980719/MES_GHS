<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript" src="/js/common/paging.js"></script>

<style type="text/css" >

	#loading {width: 100%;height: 100%;position: absolute;top: 0;left: 0;z-index: 99999;background: rgba(0, 0, 0, 0.5);}
	#loading-image{position: absolute;top: 50%;left: 50%;margin: -32px 0 0 -32px}
	.display-none {display: none}
</style>

<script>


$(document).ready(function() {
	parent.changeFrame5()
	$('.master_order').click(function() {
		$('.layer_pop', parent.document).removeClass('focus');
		$('#material_popup', parent.document).addClass('focus');
	
	})
	goPopSearch();
})
	
	function goPopSearchAction(){	
			
		var formData = $('#searchPopForm').serialize();
		 $.ajax({
		       type : "post",            
		       url : '/popPartlistProduct/getpopPartlistProductList',            
		       data:  formData,
		       success : function(data) {

		    	   var map = data.storeData;
		    	   var list = map.list;
		    	   var total = map.total;
		    	   var search = map.search;
		    	   var text = "";
   			
		    	 	if (list.length > 0){
		    		   for (var i in list){
						   text += "<tr onclick='choiceProduct(\""+list[i].PDT_CD+"\")'>";
			    		   text += "<td class='num'>"+list[i].no+"</td>";
			    		   text += "<td class='name'>"+list[i].PROD_CD+"</td>";
			    		   text += "<td class='prod'><div class='dan'><span>"+list[i].PROD_DES+"</span><span>"+ list[i].SIZE_DES+"</span></div></td>";
						   text += "<td class='name'>"+ list[i].PROD_TYPE+"</td>";
						   text += "<td class='name'>"+ list[i].CAT_NAME+"</td>";

			    	   }
		    	   }else{
		    		   text ="<tr><td colspan='5'>품목 정보가 없습니다.</td></tr>"
		    	   } 
		    	  
		    	   $('#result2').html(text);
		    	   $('#dataCnt_1').html(total);
		    	   $('#paging').html(paging(total, search.currentPage, search.rowsPerPage, 5,""));
		    	  
		    	   
		       },beforeSend : function(){
		    	   $('.wrap-loading').removeClass('display-none');
		       },complete : function(){
		    	   $('.wrap-loading').addClass('display-none');
		    	   parent.changeFrame2()
		       },error : function(data){
					 material_close();
		       }
		       
		 });
	}
	
	function goPopReset(){
		$('#searchPopForm').resetForm();
	}
	
	function choiceProduct(pdt_cd){
	
		$.ajax({
		       type : "get",            
		       url : '/popPartlistProduct/getpopPartlistProductInfo',            
		       data:  "PDT_CD="+pdt_cd,
		       success : function(data) {

		    		parent.popPartlistProductAdd(data);
		    		material_close();
		       },error : function(data){
					material_close();
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
<div class="master_pop master_order view" id="productSearch" >
	<div class="master_body">
		<div class="pop_wrap pop_wrap_02">
			<div class="pop_inner">
				<div class="master_wrap master_layer">
					<h3>품목 리스트<a class="back_btn" href="#" onclick="product_close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
					<div class="master_cont master_contP">
					<form id="searchPopForm" action="/popPartlistProduct/getpopPartlistProductList">
						<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
						<input type="hidden" id="currentPage" name="currentPage"/>
						<div class="srch_all">
							<div class="sel_wrap sel_wrap1">
								<select name="CAT_CD" class="sel_02">
									<option value="ALL">카테고리</option>
									<c:forEach var="list" items="${category}">
										<option value="${list.cat_cd}"> ${list.cat_name}</option>
									</c:forEach>
								</select>
							</div>

							<div class="sel_wrap sel_wrap1">
								<select id="PROD_TYPE" name="PROD_TYPE" class="sel_02">
									<option value="ALL">품목구분</option>
									<c:forEach items="${productGubun}" var="result">
										<c:if test="${result.code ne 'PG001' and result.code ne 'PG002'}">
											<option value="${result.code}">${result.code_nm}</option>
										</c:if>
									</c:forEach>
								</select>
							</div>
							<div class="sel_wrap sel_wrap1">
								<select name="search_type" class="sel_02">
									<option value="ALL">전체</option>
									<option value="CODE">품목코드</option>
									<option value="PDT_NAME">품목이름</option>
									<option value="REMARKS_WIN">키워드</option>
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
	                    	<div class="set_left">
								총 <span id="dataCnt_1" ></span> 건
							</div>
							
	                    </div>
	                    
	              		<div class="scroll">
                    	<table class="master_01 master_05">
                    		<colgroup>
                    			<col style="width: 55px;">
                    			<col style="width: 90px;">
                    			<col>
                    			<col style="width: 115px;">
                     			<col style="width: 120px;">
 
 
                    		</colgroup>
                    		<thead>
                    			<tr>
                    				<th>No</th>
                    				<th>품목코드</th>
                    				<th>품목 및 규격</th>
									<th>품목구분</th>
                    				<th>그룹명</th>      				
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
					<a href="#" class="p_btn_01" onclick="product_close();">닫기</a>
				</div>
			</div>
			<div class="group_close">
				<a href="#" class="getpopPartlistProductView_close" onclick="product_close();"><span>닫기</span></a>
			</div>
			
		<div class="wrap-loading display-none">
		
		    <div><img src="/images/loading.gif" /></div>
		
		</div>    
			
		</div>
	</div>
</div>



