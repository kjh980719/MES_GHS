<%@page import="mes.app.util.Util"%>
<%@page import="mes.security.UserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>

					<h3 class="mjtit_top">
						품목별 재고현황
						<a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
					</h3>
        <!--  관리자  검색시작-->
					<div class="master_cont">
                    <form id="searchForm" action="/product/ioList">
                  		<input type="hidden" value="" name="rowsPerPage" id="rowsPerPage"/>


                    <div class="srch_all">
						<div class="sel_wrap sel_wrap1">
							<select name="prod_type" class="sel_02">
								<option value="ALL">품목구분</option>
								<c:forEach items="${productGubun}" var="result">
									<option value="${result.code}" <c:if test="${search.prod_type eq result.code}">selected</c:if> >${result.code_nm}</option>
								</c:forEach>
							</select>
						</div>

                  		<div class="sel_wrap sel_wrap1">
                    		<select name="search_type" class="sel_02"> 
	                            <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
	                            <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목명</option>
								<option value="PDT_CODE" <c:if test="${search.search_type == 'PDT_CODE'}">selected</c:if>>품목코드</option>
                            </select>
                    	</div>
                        <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}" />
                    	 <div class="srch_btn">
                    	 	 <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                              <button type="button" class="btn_01">초기화</button>
                          </div>
                          
                          <div class="register_btn">
                        	<%--<button type="button" class="btn_02" onclick="newRegister()">신규등록</button>--%>
                        </div>
                    </div>
                    </form>
                    </div><!-- 검색  끝-->


<!-- 리스트 시작--><div class="master_list ">
                   <div class="list_set ">
	                    	<div class="set_left">
								총 <span id="dataCnt_1" >${total}</span> 건
							</div>
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
	                    			<col style="width: 150px;"/>
									<col style="width: 410px;"/>
	                    			<col style="width: 150px;"/>
	                    			<col style="width: 100px;"/>
	                    			<col style="width: 100px;"/>
	                    		</colgroup>
	           		        	<thead>
	                    			<tr>
	                    				<th>품목코드</th>
										<th>품목명</th>
										<th>위치</th>
										<th>재고수량</th>
										<th>재고금액</th>
   		               			</tr>
	                    		</thead>
	                    		<tbody>
	                    			<c:forEach items="${list}" var="list" varStatus="status">
		                    			<tr>
											<td class="name">${list.io_code_no}</td>
											<td class="prod">${list.pdt_name}</td>
											<td class="name">${list.to_location}</td>
											<td class="name"><fmt:formatNumber value="${list.good_qty}" pattern="#,###,###"/></td>
											<td class="name"><fmt:formatNumber value="${list.bad_qty}" pattern="#,###,###"/></td>
		                    			</tr>
	                    			</c:forEach>
									<c:if test="${empty list }">
										<tr><td colspan="5">품목 정보가 없습니다.</td></tr>
									</c:if>
	                    			
	                    		</tbody>
	                    	</table>
	                    </div>
                    	<div class="mjpaging_comm">
            				${dh:pagingB(total, search.currentPage, search.rowsPerPage, 5, parameter)}
       					 </div>
                    </div>
     </div>
<!-- contents end -->
<script type="text/javascript">

	function goSearch() {
		$('#search_string').val($('#search_string').val().trim());
		$('#rowsPerPage').val($('#rowPerPage_1').val());
		$('#searchForm').submit();
	}

	function goReset() {
		$('#searchForm').resetForm();
	}

</script>