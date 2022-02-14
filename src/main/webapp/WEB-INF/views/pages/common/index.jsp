<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>



<script>
$(document).ready(function() {
    var colModel = [
       { label : "아이디", name : "mgrs_id", align : "center", width : "3%", sortable : false},
       { label : "이름", name : "mgrs_name", align : "center", width : "6%", sortable : false},
       { label : "전화번호", name : "mgrs_telno", align : "center", width : "4.5%", sortable : false},
       { label : "권한", name : "mgrs_permityn", align : "center", width : "3.5%", sortable : false},
       { label : "가입날짜", name : "mgrs_register_pnttm", align : "center", width : "3.5%", sortable : false}
      
    ];

    var setPostData = {
       currentPage : 1,
       rowsPerPage : parseInt($("#rowsPerPage_1").val()),
       searchKeyword : "unauthorized",
       searchText : "",
       sortType : "product_end"
    };

    creatJqGrid("jqGrid_1", "/admin/getManagerList", colModel,  setPostData,  "paginate_1", "dataCnt_1", "rowsPerPage_1", "gridParent_1")

 
 });

 
//지역 select 변경시
/*  $("#rowsPerPage_1").change(function(){
	reloadGrid();
 })
 
 function reloadGrid(){
    var postData = { 
    		currentPage : 1,
    		rowsPerPage : $("#rowsPerPage_1").val(),
    		searchKeyword : ,
    		searchText : ,
	};
    $("#jqGrid_1").jqGrid('setGridParam', {
       postData: JSON.stringify(postData)
    }).trigger("reloadGrid");
} */

</script>
</head>
<body>


	<div id="gridParent_1" style="margin-left: 50px; margin-right: 50px; margin-top: 50px;" >
		<table id="jqGrid_1" class="" cellspacing="0" cellpadding="0" >

		</table>
		<div id="pager"></div>
		<div id="paginate_1" class="mjpaging_comm"></div>

		<span id="dataCnt_1" style="display: none;"></span> <select
			name="rowsPerPage_1" id="rowsPerPage_1">
			<option value="3" selected>3</option>
			<option value="4">4</option>
			<option value="5">5</option>
		</select>
	</div>

	</div>
</body>
</html>