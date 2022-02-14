<%@page import="com.fasterxml.jackson.annotation.JacksonInject.Value"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script type="text/javascript">
$(document).ready(function() {
    var setCalendarDefault = function(){
        $("#startDate").datepicker();
        $("#startDate").datepicker('setDate', '-1Y');
        $("#endDate").datepicker();
        $("#endDate").datepicker('setDate', 'today');
    }
    
    function insertOrderMaterial(){
    	if(!confirm("물품을 등록하시겠습니까?")){
    	       return false;
    	    }
        
        var queryString = $("#OrderMaterialForm").serializeObject();
        
        
        var ordermaterialList = new Array();
        
        
        for (var i = 0; i < CNT; i++) {
            var tmpMap = {};
           
           tmpMap.ORDER_CODE = $($("input[name='ORDER_CODE']")).val();
           tmpMap.NO = $($("input[name='NO']")[i]).val();
           tmpMap.CODE = $($("input[name='CODE']")[i]).val();
           tmpMap.PDT_STANDARD = $($("input[name='PDT_STANDARD']")[i]).val();
           tmpMap.UNIT = $($("input[name='UNIT']")[i]).val();
           tmpMap.UNIT_PRICE = $($("input[name='UNIT_PRICE']")[i]).val();
           tmpMap.SUPPLY_PRICE = $($("input[name='SUPPLY_PRICE']")[i]).val();
           tmpMap.DELIVERY_DATE = $($("input[name='DELIVERY_DATE']")[i]).val();
           
           ordermaterialList.push(tmpMap);
        }
        queryString.ordermaterialList = ordermaterialList;
        console.log(queryString.ordermaterialList);
        var formData =JSON.stringify(queryString.ordermaterialList);
        console.log(formData);
        $.ajax({
           type : "post",
           url : "/order/writeOrderMaterial.json",
           contentType : "application/json;charset=utf-8",
           async : false,
           traditional:true,
           dataType : "json",
           data :  {"data" : formData}
        }).done(function(result) {
        	console.log(result);
           if(result == "Y"){
                alert("물품이 등록되었습니다.");
             } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
             }
        });
     }
	
	//검색후 page 설정하여 띄우기	
    
    $(".registOrderBtn").click(function(){
	    registOrder();
	    insertOrderMaterial();
	    console.log("실행");
	});

	var registOrder = function () {
		
		
	}
	
	var checkOrderValid = function () {
	    var valid = true;
   		$.each($("#OrderMaterialForm .required"), function(){
            if($(this).val() == '') {
	            alert($(this).prop('alt') + "(은)는 필수 입력 항목 입니다.");
    			$(this).focus();
    			valid = false;
    			return false;
            }
        });
        if(valid) {
             if($('#OrderMaterialForm input[name="PROD_CD"]').val() == "") {
                //수정시 패스워드 변경
                if(!checkPassword($("#OrderMaterialForm input[name='PROD_CD']").val())) {
                    alert("품목코드를 입력해주세요");
                    $("#OrderMaterialForm input[name='PROD_CD']").focus();
                    return false;
                }
                /* if($("#OrderMaterialForm input[name='newPassword']").val() != $("#OrderMaterialForm input[name='newPasswordConfirm']").val()) {
                    alert("새 비밀번호 확인 이 새 비밀번호와 다릅니다.");
                    $("#OrderMaterialForm input[name='newPasswordConfirm']").focus();
                    return false;
                } */
            }else{
            	
            } /* else if($('#OrderMaterialForm input[name="managerSeq"]').val() == "") {
                //신규 등록
                if($("#OrderMaterialForm input[name='managerId']").val().length > 20) {
                    alert("관리자 아이디는 최대 20자 입니다.");
                    $("#OrderMaterialForm input[name='managerId']").focus();
                    return false;
                }
                if(!checkPassword($("#OrderMaterialForm input[name='password']").val())) {
                    alert("비밀번호는 영문(1자이상), 숫자(1자이상)을 포함하는 8~16자를 입력해 주십시오.");
                    $("#OrderMaterialForm input[name='password']").focus();
                    return false;
                }
            }  */

           
        }
	    return valid;
	}
    
    

    
    
  

})

$(".OrderRegist_close").click(function(e){     
     window.close();  
         
   
});

var CNT=0
function addRow(){
	var tableData=document.getElementById('testTable');
	var row=tableData.insertRow(tableData.rows.length);
	CNT++;	
	
	$("#testTable").append(
			"<tr><td class='left_pt10' id='NO"+CNT+"' value='"+CNT+"' name='NO' >"+CNT+"</td>"
			+"<td class='left_pt10'><input id='PDT_NAME"+CNT+"' name='PDT_NAME' type='text'/></td>"
			+"<td class='left_pt10'><input id='CODE"+CNT+"' name='CODE' type='text'/></td>"
			+"<td class='left_pt10'><input id='PDT_STANDARD"+CNT+"' name='PDT_STANDARD' type='text'/></td>"
			+"<td class='left_pt10'><input id='UNIT"+CNT+"' name='UNIT' type='text'/></td>"
			+"<td class='left_pt10'><input id='UNIT_PRICE"+CNT+"' name='UNIT_PRICE' type='text'/></td>"
			+"<td class='left_pt10'><input id='SUPPLY_PRICE"+CNT+"' name='SUPPLY_PRICE' type='text'/></td>"
			+"<td class='left_pt10'><input id='DELIVERY_DATE"+CNT+"' name='DELIVERY_DATE' type='text'/></td>"
			+"</tr>");
	
}





</script>
<style>



		ul.tabs{
			margin: 0px;
			padding: 0px;
			list-style: none;
		}
		ul.tabs li{
			background: none;
			color: #222;
			display: inline-block;
			padding: 10px 15px;
			cursor: pointer;
		}

		ul.tabs li.current{
			background: #ededed;
			color: #222;
		}

		.tab-content{
			display: none;
			background: #ededed;
			padding: 15px;
		}

		.tab-content.current{
			display: inherit;
		}
</style>

					<h3 class="mjtit_top">
						공지사항
					</h3>
        <!--  관리자  검색시작-->
                    <div class="top_mt10 bottom_mt20">
                    <form id="OrderForm" onsubmit="return false">
                    <table cellpadding="0" cellspacing="0" class="mjlist_tbl02">
                        <tr>
                            <th scope="row">발행일자</th>
                            <td class="left_pt10">
                                <input type="text" name=""/>
                            </td>
                            <th scope="row">발주번호</th>
                            <td  colspan="4" class="left_pt10">                                                
                                <input type="text" name='ORDER_CODE' value="" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">상호</th>
                            <td  class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">주소</th>
                            <td class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">발주 No.</th>
                            <td  colspan="4" class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">담당자</th>
                            <td class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">전화</th>
                            <td  class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">FAX</th>
                            <td  class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">공급가액</th>
                            <td class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">세액</th>
                            <td class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">총액</th>
                            <td class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                        </tr>
                        <tr>
                            <th scope="row">수신</th>
                            <td class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">업태</th>
                            <td class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                            <th scope="row">종목</th>
                            <td  colspan="4" class="left_pt10">
                                <input type="text" class="sel_box selectSearch" name="REMARKS_WIN" />
                            </td>
                        </tr>
                    </table>
                    </form>
                    
                    
                    <form id="OrderMaterialForm" onsubmit="return false">
                    <input class="align_lft" type="button" value="품목추가" onclick="addRow()"/>
                            <!-- 검색 버튼-->

                    <!-- 검색  끝-->
                        <table id="testTable" align="center"  class="mjlist_tbl02" border="1px;solid;black">
                        	<tr>
                        		<td class="left_pt10">NO</td>
                        		<td class="left_pt10">품목명</td>
                        		<td class="left_pt10">품목코드</td>
                        		<td class="left_pt10">규격</td>
                        		<td class="left_pt10">수량</td>
                        		<td class="left_pt10">단가</td>
                        		<td class="left_pt10">공급가액</td>
                        		<td class="left_pt10">납품일자</td>
                        	</tr>
                        </table>
                          <div class="bottom_mt30 align_rgt">
													
													<a href="#" class="btn_blue01 registOrderBtn">저장</a>
												</div>
                        </form>
						</div>
<!-- 리스트 시작-->             
<!-- 리스트 끝-->
                     <!--하단버튼-->
            
                   <!-- <ul class="mt15">
                    	<li>ㆍ노출순서를 변경하시고 "노출순서 변경"울 클릭하셔야 프론트에 반영이 됩니다.</li>
                    	<li>ㆍ사용하지 않는 메인배너는 미노출로 전환하시기 바랍니다.</li>
                    </ul> -->
						
<!-- 관리자 등록 contents -->
              <!-- contents end -->         