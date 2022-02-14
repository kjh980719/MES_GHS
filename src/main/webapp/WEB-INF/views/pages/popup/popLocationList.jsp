<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld"  prefix="dh"%>
<script type="text/javascript" src="/js/common/paging.js"></script>


<script>

	$(document).ready(function() {
		parent.changeFrame7()
		$('.master_order').click(function() {
			$('.layer_pop', parent.document).removeClass('focus');
			$('#location_popup', parent.document).addClass('focus');
		
		})
		goPopSearch();
	})
	function goPopSearchAction(){	
			
		var formData = $('#searchPopForm').serialize();
		 $.ajax({
		       type : "post",            
		       url : '/popup/getLocationList',
		       data:  formData,
		       success : function(data) {
		    	   var map = data.storeData;
		    	   var list = map.list;
		    	   var total = map.total;
		    	   var search = map.search;
		    	   var text = "";
				   if (search.search_type == 'C'){
					   $('#srch_zone').css("display","");
					   $('#list').css("display","");
					   $('#storageZone').css("display","none");
					   text += '<table class="master_01">';
					   text += '<colgroup>';
					   text += '<col style="width: 55px;"/>';
					   text += '<col style="width: 115px;"/>';
					   text += '<col >';
					   text += '<col style="width: 120px;"/>';
					   text += '</colgroup>';
					   text += '<thead>';
					   text += '<tr>'
					   text += '<th>No</th>'
					   text += '<th>거래처코드</th>'
					   text += '<th>거래처명</th>'
					   text += '<th>대표자명</th>'
					   text += '</thead>'
					   if (list.length > 0){
						   for (var i in list){
							   text += '<tbody>'
							   text += "<tr onclick='choiceSupply(\""+list[i].CUST_NAME+"\",\"${target}\",\""+list[i].CUST_SEQ+"\");'>";
							   text += "<td class='num'>"+(total + 1 - list[i].no)+"</td>";
							   text += "<td class='code'>"+list[i].BUSINESS_NO+"</td>";
							   text += "<td class='code'>"+list[i].CUST_NAME+"</td>";
							   text += "<td class='name'>"+list[i].BOSS_NAME+"</td>";
							   text += "</tr>";
						   }
					   }else{
						   text += "<tr><td colspan='4'>거래처 정보가 없습니다.</td></tr>"
					   }
					   text += '</table>';
				   }

				   if (search.search_type == 'L'){
					   $('#srch_zone').css("display","");
					   $('#list').css("display","");
					   $('#storageZone').css("display","none");
					   text += '<table class="master_01">';
					   text += '<colgroup>';
					   text += '<col style="width: 50px;"/>';
					   text += '<col style="width: 300px;"/>';
					   text += '<col >';
					   text += '</colgroup>';
					   text += '<thead>';
					   text += '<tr>'
					   text += '<th>No</th>'
					   text += '<th>공장명</th>'
					   text += '<th>라인명</th>'
					   text += '</thead>'
					   if (list.length > 0){
						   for (var i in list){
							   text += '<tbody>'
							   text += "<tr onclick='choiceLine(\""+list[i].name+"\",\"${target}\",\""+list[i].seq+"\")'>";
							   text += "<td class='num'>"+(total + 1 - list[i].no)+"</td>";
							   text += "<td class='code'>"+list[i].factory_name+"</td>";
							   text += "<td class='code'>"+list[i].line_name+"</td>";
							   text += "</tr>";
						   }
					   }else{
						   text += "<tr><td colspan='3'>라인 정보가 없습니다.</td></tr>"
					   }
					   text += '</table>';
				   }
				   if (search.search_type == 'S'){
					   $('#srch_zone').css("display","none");
					   $('#storageZone').css("display","");
					   $('#list').css("display","none");

					   var obj = document.getElementById("STORAGE_NAME1_1");
					   $('#STORAGE_NAME1_1').val();
					   categoryChange(obj);

/*
					   text += '<table class="master_01">';
					   text += '<colgroup>';
					   text += '<col style="width: 150px;"/>';
					   text += '<col style="width: 150px;" >';
					   text += '<col style="width: 150px;"/>';
					   text += '<col />';
					   text += '</colgroup>';
					   text += '<thead>';
					   text += '<tr>';
					   text += '<th>창고</th>';
					   text += '<th>존</th>';
					   text += '<th>상세위치</th>';
					   text += '<th>관리</th>';
					   text += '</thead>';

					   if (list.length > 0){
							   text += "<td><div class='sel_wrap sel_wrap1'><select name='STORAGE_NAME1' id='STORAGE_NAME1_1' onchange='categoryChange(this)'class='sel_02'>";
							   text += StorageList(0,1);
							   text +="</select></div></td>";
							   text += "<td><div class='sel_wrap sel_wrap1'><select name='STORAGE_NAME2' id='STORAGE_NAME2_1'onchange='categoryChange(this)' class='sel_02'>";
							   text +='<option value="all">선택</option></select></div></td>';
							   text += "<td><div class='sel_wrap sel_wrap1'><select name='STORAGE_NAME3' id='STORAGE_NAME3_1' class='sel_02'>";
							   text +='<option value="all">선택</option></select></div></td>';
							   text +="<td><button type='button' class='btn_02' onclick='choiceStorage(\"${target}\");'>적용</button></td>";

							   text += "</tr>";
					   }else{
						   text += "<tr><td colspan='4'>창고 정보가 없습니다.</td></tr>"
					   }
					   text += '</table>';*/
				   }

				   if (search.search_type != 'S'){
					   $('#result2').html(text);
					   $('#dataCnt_1').html(total);
					   $('#paging').html(paging(total, search.currentPage, search.rowsPerPage, 5,""));
				   }

			   },error : function(data){
		    	   parent.choiceLocation_close();
		       }
		 });
	}
	
	function goPopReset(){
		$('#searchPopForm').resetForm();
	}

	function choiceSupply(name, target, cust_seq){
		parent.choiceCust(name,target, cust_seq);
		parent.choiceLocation_close();
	}
	function choiceLine(name, target, line_seq){
		parent.choiceLine(name,target, line_seq);
		parent.choiceLocation_close();
	}
	function choiceStorage(target){
		let seq1 = $('#STORAGE_NAME1_1').val();
		let seq2 = $('#STORAGE_NAME2_1').val();
		let seq3 = $('#STORAGE_NAME3_1').val();
		let name1 = $("#STORAGE_NAME1_1 option:checked").text();
		let name2 = $("#STORAGE_NAME2_1 option:checked").text();
		let name3 = $("#STORAGE_NAME3_1 option:checked").text();
		let storage_seq ="";
		let name= "";
		if (!isEmpty(seq1)){
			storage_seq += seq1;
			if (!isEmpty(seq2)){
				storage_seq += "," + seq2;
				if (!isEmpty(seq3)){
					storage_seq += "," + seq3;
				}
			}
		}
		if (!isEmpty(name1)){
			name += name1;
			if (name2 != '선택'){
				name += "/" + name2;
				if (name3 != '선택'){
					name += "/" + name3;
				}
			}
		}
		parent.choiceStorage(name,target, storage_seq);
		parent.choiceLocation_close();
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
	function typeChange(value){
		let type = value;
		var text = "";
		if (type=="C"){ //거래처
			text += "<option value='ALL'>전체</option>";
			text += "<option value='CUST_NAME'>거래처명</option>";
			text += "<option value='REMARKS_WIN'>키워드</option>";
			$('#search_type2').html(text);
		}else if (type=="L"){ //생산라인
			text += "<option value='ALL'>전체</option>";
			$('#search_type2').html(text);
		}else if (type=="S"){ //창고
			text += "<option value='ALL'>전체</option>";
			$('#search_type2').html(text);
		}
	}

	function categoryChange(obj){
		var objId = obj.id;
		var objValue = obj.value;
		var objsplit = objId.split("_");
		var objsplit1 = objsplit[1];
		var objsplit2 = objsplit[2];

		var storagelist = "<option value=''>선택</option>";

		var depth = "";
		if (objsplit1 == "NAME1"){
			depth = "2";
			$('#STORAGE_NAME2'+"_"+objsplit2).html(storagelist);
			$('#STORAGE_NAME3'+"_"+objsplit2).html(storagelist);
		}else if(objsplit1 == "NAME2"){
			depth = "3";
			$('#STORAGE_NAME3'+"_"+objsplit2).html(storagelist);
		}
		var target ="STORAGE_NAME" +depth + "_" +objsplit2;


		$.ajax({
			type: 'post',
			url:'/material/StorageList',
			contentType :'application/json',
			data: JSON.stringify ({'STOR_DEPTH':depth,'STOR_UPPER':objValue}),
			async: false,
			success: function (data) {
				$.each(data.storeData , function (key, value) {
					storagelist += "<option value='" + value.STOR_SEQ + "'>" + value.STOR_NAME + "</option>";
				});
			}
		});

		$('#'+target).html(storagelist);

	}

	function StorageList(STOR_UPPER,STOR_DEPTH){
		var storagelist="";
		$.ajax({
			type: 'post',
			url:'/material/StorageList',
			contentType :'application/json',
			data: JSON.stringify ({'STOR_DEPTH':STOR_DEPTH,'STOR_UPPER':STOR_UPPER}),
			async: false,
			success: function (data) {
				$.each(data.storeData , function (key, value) {
					storagelist += "<option value='" + value.STOR_SEQ + "'>" + value.STOR_NAME + "</option>";
				});
			}
		});
		return storagelist;
	}
</script>
<div class="master_pop master_order view" id="BusinessNumSearch" >
	<div class="master_body">
		<div class="pop_wrap pop_wrap_02">
			<div class="pop_inner">
				<div class="master_wrap master_layer">
					<h3>위치 선택<a class="back_btn" href="#" onclick="parent.choiceLocation_close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>
					<div class="master_cont">
					<form id="searchPopForm" action="/popup/popLocationList">
						<input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
						<input type="hidden" id="currentPage" name="currentPage"/>
						<input type="hidden" id="param" name="param"/>
						<div class="srch_all">
							<div class="radiobox">
								<label for="search_type_C">
									<input type="radio" id="search_type_C" class="blind" name="search_type" value="C" onclick="typeChange(this.value); goPopSearch();" checked="checked">
									<span>거래처</span>
								</label>
								<label for="search_type_L">
									<input type="radio" id="search_type_L" class="blind" name="search_type" value="L" onclick="typeChange(this.value); goPopSearch();">
									<span>생산라인</span>
								</label>
								<label for="search_type_S">
									<input type="radio" id="search_type_S" class="blind" name="search_type" value="S" onclick="typeChange(this.value);  goPopSearch();">
									<span>창고</span>
								</label>
							</div>
						</div>
						<div class="srch_all" id="srch_zone">
							<div class="sel_wrap sel_wrap1">
								<select id="search_type2" name="search_type2" class="sel_02">
									<option value="ALL" selected="selected">전체</option>
									<option value="CUST_NAME">거래처명</option>
									<option value="REMARKS_WIN">키워드</option>
								</select>
							</div>
							<input type="text" class="srch_input01 srch_input02"  name="search_string"   onkeypress="return runScript(event)" />
							<div class="srch_btn">
								<button type="button" class="btn_02" onclick="goPopSearch();">검색</button>
								<%--   <button type="button" class="btn_01" onclick="goPopReset();">초기화</button> --%>
							</div>
						</div>
		              </form>
		              </div>
					<div class="master_list master_listB" id="storageZone" style="display: none">
						<table  class="master_02 master_04">
							<colgroup>
								<col style="width: 120px"/>
								<col style="width: 34.8%"/>
								<col style="width: 120px"/>
								<col style="width: 34.8%"/>
							</colgroup>
							<tbody>
							<tr>
								<th scope="row"></th>
								<td colspan="3">
									<div class='sel_wrap sel_wrap1'>
										<select name='STORAGE_NAME1' id='STORAGE_NAME1_1' onchange='categoryChange(this)'class='sel_02'>
												<c:forEach items="${storageDepth1}" var="depth1" varStatus="status">
													<option value="${depth1.STOR_SEQ}">${depth1.STOR_NAME}</option>
												</c:forEach>
											</select>
										</select>
									</div>

									<div class='sel_wrap sel_wrap1'>
										<select name='STORAGE_NAME2' id='STORAGE_NAME2_1'onchange='categoryChange(this)' class='sel_02'>
											<option value="all">선택</option>
										</select>
									</div>
									<div class='sel_wrap sel_wrap1'>
										<select name='STORAGE_NAME3' id='STORAGE_NAME3_1' class='sel_02'>
											<option value="all">선택</option>
										</select>
									</div>
									<button type="button" class="btn_02" onclick="choiceStorage('${target}');">적용</button>
								</td>
							</tr>
							</tbody>
						</table>
					</div>

                    <div class="master_list" id="list">
						<div class="list_set ">
	                    
	                    </div>
	              		<div id= "result2" class="scroll">

                    	</div>
						<div id="paging" class="mjpaging_comm">
            				
       					 </div>  
	                  
                   </div>
				</div>
				
				<div class="pop_btn clearfix">
					<a href="#" class="p_btn_01" onclick="parent.choiceLocation_close();">닫기</a>
				</div>
			</div>
			<div class="group_close">
				<a href="#" class="getOrderView_close" onclick="parent.choiceLocation_close();"><span>닫기</span></a>
			</div>
		</div>
	</div>
</div>

