<%@page import="mes.app.util.Util" %>
<%@page import="mes.security.UserInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld" prefix="dh" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%
    UserInfo user = Util.getUserInfo();
%>
<script type="text/javascript">


    $(document).ready(function () {

        var setCalendarDefault = function () {
            $("#startDate").datepicker();
            $("#startDate").datepicker('setDate', '${search.startDate}');
            $("#endDate").datepicker();
            $("#endDate").datepicker('setDate', '${search.endDate}');
        }
        setCalendarDefault();

    })

    function goSearch() {
        $('#search_string').val($('#search_string').val().trim());
        $('#rowsPerPage').val($('#rowPerPage_1').val());
        $('#searchForm').submit();
    }

    function goReset() {
        $('#searchForm').resetForm();
    }

    function viewOrderDetail(order_seq, type) {
        orderInfoLayer_Open(order_seq, type);
    }

    function materialRegist(type) {
        orderInfoLayer_Open("", type)
    }


    function productAdd() {
        var num = Number($('#productCount').val());
        num += 1;
        var text = "";

        text += "<tr id='product_" + num + "'>";
        text += "<td class='num pctnum'><a href='#' onclick='productDelete(\"" + num + "\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
        text += "<td class='code'><input type='text' id='code_" + num + "' name='code' ></td>";
        text += "<td class='prod'>";
        text += "<div class=\"dan\">";
        text += "<span><input type='text' id='pdt_name_" + num + "' name='pdt_name' placeholder=\"품목\"></span>";
        text += "<span><input type='text' id='pdt_standard_" + num + "' name='pdt_standard' placeholder=\"규격\"></span>";
        text += "</div>";
        text += "</td>";
        text += "<td class='name'><input type='text' id='qty_" + num + "' name='qty' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange(" + num + ");'></td>";
        text += "<td class='name'><input type='text' id='unit_" + num + "' name='unit' ></td>";
        text += "<td class='name'><input type='text' id='unit_price_" + num + "' name='unit_price' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange(" + num + ");'></td>";
        text += "<td class='name'><input type='text' id='supply_price_" + num + "' name='supply_price' readonly></td>";
        text += "<td class='ing vat'><input type='text' id='vat_" + num + "' name='vat' readonly></td>";
        text += "</tr>";


        $('#searchResult').append(text);

        $('#productCount').val(num);
    }

    function productDelete(rowNum) {

        $("#product_" + rowNum).remove();
        priceCal();
    }


    function orderInfoLayer_Open(order_seq, type) {
        var text = "";
        if (type == "view") { //상세보기
            $('#mode').val('view');

            $.ajax({
                type: "get",
                url: '/order/getOrderInfo',
                async: false,
                data: "order_seq=" + order_seq,
                success: function (data) {
                    var array = data.storeData;
                    console.log(array);
                    var pdt_code = "";
                    var no = "";
                    var pdt_name = "";
                    var supply_price = "";
                    var unit = "";
                    var unit_price = "";
                    var vat = "";
                    text = "";
                    var order_code = "";
                    var order_date = "";
                    var close_date = "";
                    var total_amount = "";
                    var tax_amount = "";
                    var supply_name = "";
                    var bigo = "";
                    var order_status = "";
                    var cancel_reason = "";
                    var order_seq = "";
                    var txt = "";

                    var manager_phoneNumber = "";
                    var supply_amount = "";
                    var manager_name = "";
                    var supply_manager_name = "";
                    var supply_phoneNumber = "";
                    var post_no = "";
                    var order_addr = "";
                    var order_addr_info = "";

                    if (array.length > 0) {
                        order_seq = array[0].order_seq;
                        order_code = array[0].order_code;
                        manager_phoneNumber = array[0].manager_phoneNumber;
                        order_date = array[0].order_date;
                        close_date = array[0].close_date;
                        total_amount = array[0].total_amount;
                        tax_amount = array[0].tax_amount;
                        supply_amount = array[0].supply_amount;
                        manager_name = array[0].manager_name;
                        supply_manager_name = array[0].supply_manager_name;
                        supply_phoneNumber = array[0].supply_phoneNumber;
                        bigo = array[0].bigo;
                        order_status = array[0].order_status;
                        post_no = array[0].post_no;
                        order_addr = array[0].order_addr;
                        order_addr_info = array[0].order_addr_info;
                        supply_name = array[0].supply_name;
                        cancel_reason = array[0].cancel_reason;


                        $('#order_seq').val(order_seq);
                        $('#order_code').val(order_code);
                        $('#supply_name').val(supply_name);
                        $('#supply_manager_name').val(supply_manager_name);
                        $('#supply_phoneNumber').val(supply_phoneNumber);
                        $('#order_date').val(order_date);
                        $("#close_date").datepicker();
                        $("#close_date").datepicker('setDate', close_date);

                        $('#order_addr').val(order_addr);
                        $('#order_addr_info').val(order_addr_info);
                        $('#post_no').val(post_no);
                        $('#manager_name').val(manager_name);
                        $('#manager_phoneNumber').val(manager_phoneNumber);

                        $('#supply_amount').val(comma(supply_amount));
                        $('#tax_amount').val(comma(tax_amount));
                        $('#total_amount').val(comma(total_amount));

                        $('#bigo').val(bigo);
                        $('#order_status').val(order_status);
                        $('#cancel_reason').val(cancel_reason);

                        for (var i in array) {

                            pdt_code = array[i].pdt_code;
                            no = array[i].no;
                            pdt_name = array[i].pdt_name;
                            pdt_standard = array[i].pdt_standard;
                            supply_price = array[i].supply_price;
                            unit = array[i].unit;
                            qty = array[i].qty
                            unit_price = array[i].unit_price;
                            vat = array[i].vat;

                            text += "<tr>";
                            text += "<td class='no'><input type='text' value='" + no + "' readonly></td>";
                            text += "<td class='code'><input type='text' value='" + pdt_code + "' readonly></td>";
                            text += "<td class='prod'><input type='text' value='" + pdt_name + "' readonly></td>";
                            text += "<td class='prod'><input type='text' value='" + pdt_standard + "' readonly></td>";
                            text += "<td class='qty'><input type='text' value='" + comma(qty) + "' readonly></td>";
                            text += "<td class='name'><input type='text' value='" + unit + "' readonly></td>";
                            text += "<td class='qty'><input type='text' value='" + comma(unit_price) + "' readonly></td>";
                            text += "<td class='qty'><input type='text' value='" + comma(supply_price) + "' readonly></td>";
                            text += "<td class='qty'><input type='text' value='" + comma(vat) + "' readonly></td>";
                            text += "</tr>";
                        }

                    } else {
                        text += "<tr class='all'><td colspan='7'>발주정보가 없습니다.</td></tr>";
                    }
                    $('#button_2').css('display', 'none');
                    $('#orderStatus').css('display', '');
                    $('#order_code').css('display', 'block');
                    $("#supply_name").removeAttr("onclick");
                    $('#actionButton').text('수정');
                    $('#searchResult').html(text);
                }
            });
        } else { //신규작성일때
            $('#mode').val('register');
            $('#button_2').css('display', 'inline-block');
            $('#order_code').css('display', 'none');
            $('#orderStatus').css('display', 'none');
            $('#sayou').css('display', 'none');
            $('#supply_name').attr("onclick", "openLayer();");
            $('#actionButton').text('등록');
            $('#searchResult').empty();
            $('#orderInfo_Form').resetForm();

            var today = new Date();

            var year = today.getFullYear(); // 년도
            var month = today.getMonth() + 1;  // 월
            var date = today.getDate();  // 날짜

            var monthChars = month.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.
            var dateChars = date.toString().split(''); //currMonth 의 문자를 나눠서 배열로 만듭니다.

            month = (monthChars[1] ? month : "0" + month);// 한자리일경우 monthChars[1]은 존재하지 않기 때문에 false
            date = (dateChars[1] ? date : "0" + date);// 한자리일경우 dateChars[1]은 존재하지 않기 때문에 false

            date = year + "-" + month + "-" + date;
            $('#manager_name').val("<%=user.getManagerName()%>");
            $('#manager_phoneNumber').val("<%=user.getManagerTel()%>")
            $('#order_date').val(date);
            $("#close_date").datepicker();
            $("#close_date").datepicker('setDate', '+7');

        }

        $('#orderInfoLayer').addClass('view');
        $('html,body').css('overflow', 'hidden');
        $('.leftNav').removeClass('view');
    }

    function reasonShow(obj) {
        var val = obj.value;
        if (val == "OS003" || val == "OS006") {
            $('#sayou').css('display', '');
            if ($('#cancel_reason').val() == "undefined" || $('#cancel_reason').val() == null) {
                $('#cancel_reason').val("");
            }
        }else{
            $('#sayou').css('display', 'none');
            $('#cancel_reason').val("");
        }
    }

    function orderInfoLayer_Close() {
        $('#orderInfoLayer').removeClass('view');
        $('#popup').css('display', 'none');
        $('#product_popup').css('display', 'none');
        $('html,body').css('overflow', '');
        $('.info_edit').removeClass('view');
    }

    function GoActionButton() {
        var targetUrl = ""
        var pdt_name = "";
        var qty = "";
        var unit_price = "";
        var status = true;

        var mode = $('#mode').val();
        if (mode == 'register') {
            targetUrl = "/order/registerOrder";
        } else {
            orderInfoUpdate();
            return;
        }

        var order_date = new Date($('#order_date').val());
        var close_date = new Date($('#close_date').val());

        if (order_date > close_date) {
            alert("납기일자는 발주일자보다 이후여야 합니다.");
            return false;
        }
        if (isEmpty($('#supply_name').val())) {
            alert("발주처를 입력해주세요");
            $('#supply_name').focus();
            return false;
        }
        if (isEmpty($('#supply_manager_name').val())) {
            alert("담당자를 입력해주세요");
            $('#supply_manager_name').focus();
            return false;
        }
        if (isEmpty($('#supply_phoneNumber').val())) {
            alert("연락처를 입력해주세요");
            $('#supply_phoneNumber').focus();
            return false;
        }
        if (isEmpty($('#post_no').val()) || isEmpty($('#order_addr').val())) {
            alert("주소를 입력해주세요");
            return false;
        }

        if ($('input[name="pdt_name"]').length == 0) {
            alert("발주할 품목이 없습니다.");
            return false;
        }

        $('input[name="pdt_name"]').each(function (idx, item) {
            pdt_name = $(item).val();
            if (isEmpty(pdt_name)) {
                alert("품목명을 입력해주세요.");
                status = false;
            }
        });
        if (status == false) return;

        $('input[name="qty"]').each(function (idx, item) {
            qty = $(item).val();
            if (isEmpty(qty)) {
                alert("수량을 입력해주세요.");
                status = false;
            }
        });
        if (status == false) return;

        $('input[name="unit_price"]').each(function (idx, item) {
            unit_price = $(item).val();
            if (isEmpty(unit_price)) {
                alert("단가를 입력해주세요.");
                status = false;
            }
        });
        if (status == false) return;

        $('input[name="unit"]').each(function (idx, item) {
            var unit = $(item).val();
            if (isEmpty(unit)) {
                alert("단위를 입력해주세요.");
                status = false;
            }
        });
        if (status == false) return;

        var orderdetailList = [];

        for (var i = 0; i < $("input[name='pdt_name']").length; i++) {
            var tmpMap = {};

            tmpMap.seq = i + 1;
            tmpMap.pdt_cd = $($("input[name='pdt_cd']")[i]).val();
            tmpMap.pdt_code = $($("input[name='pdt_code']")[i]).val();
            tmpMap.pdt_name = $($("input[name='pdt_name']")[i]).val();
            tmpMap.pdt_standard = $($("input[name='pdt_standard']")[i]).val();
            tmpMap.qty = $($("input[name='qty']")[i]).val().replace(/,/g, "");
            tmpMap.unit = $($("input[name='unit']")[i]).val();
            tmpMap.unit_price = $($("input[name='unit_price']")[i]).val().replace(/,/g, "");
            tmpMap.supply_price = $($("input[name='supply_price']")[i]).val().replace(/,/g, "");
            tmpMap.vat = $($("input[name='vat']")[i]).val().replace(/,/g, "");

            orderdetailList.push(tmpMap)
        }
        var order_info = [];
        var tmpMap2 = {};
        tmpMap2.order_date = $($("input[name='order_date']")).val();
        tmpMap2.close_date = $($("input[name='close_date']")).val();
        tmpMap2.supply_manager_name = $($("input[name='supply_manager_name']")).val();
        tmpMap2.supply_phoneNumber = $($("input[name='supply_phoneNumber']")).val();
        tmpMap2.manager_name = $($("input[name='manager_name']")).val();
        tmpMap2.manager_phoneNumber = $($("input[name='manager_phoneNumber']")).val();
        tmpMap2.supply_amount = $($("input[name='supply_amount']")).val().replace(/,/g, "");
        tmpMap2.tax_amount = $($("input[name='tax_amount']")).val().replace(/,/g, "");
        tmpMap2.total_amount = $($("input[name='total_amount']")).val().replace(/,/g, "");
        tmpMap2.bigo = $($("input[name='bigo']")).val();
        tmpMap2.order_addr = $($("input[name='order_addr']")).val();
        tmpMap2.post_no = $($("input[name='post_no']")).val();
        tmpMap2.order_addr_info = $($("input[name='order_addr_info']")).val();
        tmpMap2.cust_seq = $($("input[name='cust_seq']")).val();

        order_info.push(tmpMap2);
        sendData = {};

        sendData.orderdetailList = orderdetailList;
        sendData.order_info = order_info;

        $.ajax({
            contentType: 'application/json; charset=utf-8',
            data: JSON.stringify(sendData),
            type: "POST",
            url: targetUrl,
            dataType: "json",
            contentType: "application/json"

        }).done(function (result) {
            console.log(result);
            if (result.success) {
                alert("발주가 등록되었습니다.");
                orderInfoLayer_Close();
                location.reload();
            } else {
                alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
            }
        });

    }

    function orderInfoUpdate() {
        var msg = "";
        var returnMsg = "";
        var target = "";

        if ($('#order_status').val() == 'OS006') {
            msg = "정말 취소하시겠습니까?";
            returnMsg = "취소되었습니다.";
            target = "/order/orderInfoUpdateCancel";

        } else {
            msg = "정말 수정하시겠습니까?";
            returnMsg = "수정되었습니다.";
            target = "/order/orderInfoUpdate"
        }

        if (confirm(msg)) {
            param = $("#orderInfo_Form").serialize();
            $.ajax({
                type: "post",
                url: target,
                async: false,
                data: param,
                success: function (data) {
                    if (data.success) {
                        alert(returnMsg);
                        location.reload(true);
                    }
                }, error: function (data) {

                    orderInfoLayer_Close();
                    location.reload(true);
                }
            });
        }


    }
</script>

<h3 class="mjtit_top">
    발주서 조회
    <a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>

<!-- 관리자 검색시작-->
<div class="master_cont">

    <form id="searchForm" action="/order/makeorderview">
        <input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
        <div class="srch_day">
            <div class="day_area">
                <div class="day_label">
                    <label for="startDate">발주일자</label>
                </div>
                <div class="day_input">
                    <input type="text" id="startDate" name="startDate" readonly/>
                </div>
                <span class="sup">~</span>
                <div class="day_input">
                    <input type="text" id="endDate" name="endDate" readonly/>
                </div>
            </div>
        </div>
        <div class="srch_all">
            <div class="sel_wrap sel_wrap1">
                <select name="order_status" class="sel_02">
                    <option value="ALL" <c:if test="${search.order_status eq 'ALL'}">selected</c:if>>전체</option>
                    <c:forEach items="${orderStatus}" var="result">
                        <option value="${result.code}" <c:if test="${search.order_status eq result.code}">selected</c:if>>${result.code_nm}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="sel_wrap sel_wrap1">
                <select name="search_type" class="sel_02">
                    <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
                    <option value="ORDER_CODE" <c:if test="${search.search_type == 'ORDER_CODE'}">selected</c:if>>발주번호
                    </option>
                    <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목명
                    </option>
                    <option value="SUPPLY_NAME" <c:if test="${search.search_type == 'SUPPLY_NAME'}">selected</c:if>>
                        공급사명
                    </option>
                </select>
            </div>

            <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string"
                   onkeyup="if(window.event.keyCode==13){goSearch()}"/>
            <div class="srch_btn">
                <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                <button type="button" class="btn_01">초기화</button>
            </div>

            <div class="register_btn">
                <button type="button" class="btn_02" onclick="materialRegist('register');">
                    신규등록
                </button>
            </div>
        </div>

    </form>

</div>
<!-- 검색 끝-->


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
                <th>발주번호</th>
                <th>품목명</th>
                <th>공급사명</th>
                <th>발주일자</th>
                <th>입고요청일</th>
                <th>진행상태</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="list" varStatus="status">
                <tr>
                    <td class="num"><fmt:formatNumber value="${list.total +1 - list.no}" pattern="#,###,###"/></td>
                    <td class="code"><a href="#" onclick="viewOrderDetail('${list.order_seq}','view');">${list.order_code}</a></td>
                    <td class="prod">
                        <a href="#" onclick="viewOrderDetail('${list.order_seq}','view');">${list.pdt_name}</a>
                        <a href="#" onclick="viewOrderDetail('${list.order_seq}','view');" class="m_link">${list.pdt_name}</a>
                    </td>
                    <td class="sang t_left">${list.supply_name}</td>
                    <td class="day">${list.order_date}</td>
                    <td class="day day1">${list.close_date}</td>
                    <td class="ing">
                        <c:forEach items="${orderStatus}" var="result">
                            <c:if test="${result.code eq list.order_status}">${result.code_nm}</c:if>
                        </c:forEach>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty list }">
                <tr>
                    <td colspan="7">발주 정보가 없습니다.</td>
                </tr>
            </c:if>

            </tbody>
        </table>
    </div>
    <div class="mjpaging_comm">
        ${dh:pagingB(list[0].total, search.currentPage, search.rowsPerPage, 10, parameter)}
    </div>
</div>

<div class="master_pop master_pop01" id="orderInfoLayer">
    <div class="master_body">
        <div class="pop_bg" onclick="orderInfoLayer_Close();"></div>
        <div class="pop_wrap pop_wrap_01">
            <div class="pop_inner">
                <form id="orderInfo_Form" name="orderInfo_Form">
                    <input type="hidden" name="productCount" id="productCount" value="1"/>
                    <input type="hidden" name="mode" id="mode" value="regist"/>
                    <input type="hidden" name="order_seq" id="order_seq"/>
                    <input type="hidden" name="cust_seq" id="cust_seq"/>

                    <h3>발주 등록/조회<a class="back_btn" href="#" onclick="orderInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

                    <div class="master_list master_listB">
                        <table class="master_02 master_04">
                            <colgroup>
                                <col style="width: 120px"/>
                                <col style="width: 34.8%"/>
                                <col style="width: 120px"/>
                                <col style="width: 34.8%"/>
                            </colgroup>
                            <tbody>
                            <tr>
                                <th scope="row">발주번호</th>
                                <td colspan="3">
                                    <input type="text" id="order_code" name="order_code" readonly="readonly"/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">발주처 <span class="keyf01">*</span></th>
                                <td colspan="3">
                                    <input type="text" id="supply_name" name="supply_name" onclick="openLayer();" class="all" readonly/>
                                </td>

                            </tr>
                            <tr>
                                <th scope="row">담당자 <span class="keyf01">*</span></th>
                                <td>
                                    <input type="text" id="supply_manager_name" name="supply_manager_name" maxlength="20"/>
                                </td>
                                <th scope="row">연락처 <span class="keyf01">*</span></th>
                                <td>
                                    <input type="text" id="supply_phoneNumber" name="supply_phoneNumber" onkeyup="autoHypen(this);" maxlength="13"/>
                                </td>
                            </tr>

                            <tr>
                                <th scope="row">발주일자 <span class="keyf01">*</span></th>
                                <td>
                                    <input type="text" id="order_date" name="order_date" readonly="readonly"/>
                                </td>
                                <th scope="row">납기일자 <span class="keyf01">*</span></th>
                                <td>
                                    <div class="day_input"><input type="text" id="close_date" name="close_date"/></div>
                                </td>

                            </tr>

                            <tr>
                                <th scope="row" rowspan="2">주소 <span class="keyf01">*</span></th>
                                <td colspan="3">
                                    <input type="text" id="post_no" name="post_no" class="add" readonly/>
                                    <button type="button" class="btn_02 btn_s" id="button_3" onclick="openZipSearch();return false;">주소 검색</button>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3">
                                    <input type="text" id="order_addr" name="order_addr" placeholder="상세주소" class="all" style="margin-bottom: 5px;" readonly/>
                                  </br>  <input type="text" id="order_addr_info" name="order_addr_info" placeholder="상세주소" class="all" maxlength="50"/>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">발주담당자</th>
                                <td>
                                    <input type="text" id="manager_name" name="manager_name" maxlength="15" readonly="readonly"/>
                                </td>

                                <th scope="row">연락처</th>
                                <td>
                                    <input type="text" id="manager_phoneNumber" name="manager_phoneNumber" onkeyup="autoHypen(this);" maxlength="13"/>
                                </td>

                            </tr>

                            <tr>
                                <th scope="row">공급가액</th>
                                <td>
                                    <input type="text" id="supply_amount" name="supply_amount" readonly="readonly"/>
                                </td>

                                <th scope="row">VAT</th>
                                <td>
                                    <input type="text" id="tax_amount" name="tax_amount" readonly="readonly"/>
                                </td>
                            </tr>

                            <tr>
                                <th scope="row">총액</th>
                                <td><input type="text" id="total_amount" name="total_amount" readonly="readonly"/></td>

                                <th scope="row">비고</th>
                                <td><input type="text" id="bigo" name="bigo" class="all"/></td>


                            </tr>
                            <tr id="orderStatus">
                                <th scope="row">발주상태</th>
                                <td colspan="3">
                                    <div id="orderStatusZone" class="sel_wrap">
                                        <select class="sel_02" id="order_status" name="order_status" onChange="reasonShow(this)">
                                            <c:forEach items="${orderStatus}" var="result">
                                                <option value="${result.code}">${result.code_nm}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr id="sayou" style="display : none;">
                                <th scope="row">사유</th>
                                <td colspan="3">
                                    <input type="text" id="cancel_reason" name="cancel_reason" class="all"/>
                                </td>
                            </tr>

                            </tbody>
                        </table>
                    </div>

                    <div class="master_list master_listT">
                        <div class="add_btn">
                            <button id="button_2" type="button" class="btn_02" onclick="productSearch();">품목 불러오기
                            </button>
                        </div>
                        <div class="scroll">
                            <table class="master_01 master_05" id="product">
                                <colgroup>
                                    <col style="width: 55px;"/>
                                    <col style="width: 200px;"/>
                                    <col style="width: 220px;"/>
                                    <col style="width: 220px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 80px;"/>
                                    <col style="width: 110px;"/>
                                    <col style="width:110px;"/>
                                    <col style="width: 110px;"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th></th>
                                    <th>품목코드</th>
                                    <th>품목명</th>
                                    <th>규격</th>
                                    <th>수량</th>
                                    <th>단위</th>
                                    <th>단가</th>
                                    <th>공급가액</th>
                                    <th>부가세</th>
                                </tr>
                                </thead>
                                <tbody id="searchResult">

                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="pop_btn clearfix">
                        <a href="#" class="p_btn_01" onclick="orderInfoLayer_Close();">닫기</a>
                        <a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02">수정</a>
                    </div>

                </form>
            </div>
            <div class="group_close">
                <a href="#" class="getOrderView_close" onclick="orderInfoLayer_Close();"><span>닫기</span></a>
            </div>
            <div id="popup" class="layer_pop">
                <div class="handle_wrap">
                    <div class="handle"><span>공급사 리스트</span></div>
                    <div class="drag_fix"><a href="#" onclick="closeLayer(); return false"><img
                            src="/images/common/drag_close.png" alt="닫기"></a></div>
                </div>
                <iframe src="" id="popupframe"></iframe>
            </div>
            <div id="product_popup" class="layer_pop">

                <div class="handle_wrap">
                    <div class="handle"><span>품목 리스트</span></div>
                    <div class="drag_fix"><a href="#" onclick="productSearch_close(); return false"><img
                            src="/images/common/drag_close.png" alt="닫기"></a></div>
                </div>
                <iframe src="" id="product_popupframe"></iframe>
            </div>


        </div>
    </div></div>

        <script>

            function openLayer() {
                if (sessionCheck()) {
                    var url = "/supply/popSupplyList";
                    $('#popup').css('display', 'block');
                    $('#popupframe').attr('src', url);
                    $('html,body').css('overflow', 'hidden');
                } else {
                    location.reload();
                }
            }

            function closeLayer() {
                $('#popup').css('display', 'none');
                $('#popupframe').removeAttr('src');
                $('html,body').css('overflow', '');

            }

            function productSearch() {
                if (sessionCheck()) {
                    var url = "/order/popProductList?type=order";
                    $('#product_popup').css('display', 'block');
                    $('#product_popupframe').attr('src', url);
                    $('html,body').css('overflow', 'hidden');
                } else {
                    location.reload();
                }

            }

            function productSearch_close() {
                $('#product_popup').css('display', 'none');
                $('#product_popupframe').removeAttr('src');
                $('html,body').css('overflow', '');
            }

            function PopProductAdd(data) {


                var pdt = data.storeData;
                var num = Number($('#productCount').val());
                num += 1;
                var text = "";

                text += "<tr id='product_" + num + "'>";
                text += "<td class='num pctnum'><a href='#' onclick='productDelete(\"" + num + "\")'><img src='/images/common/miuns_icon.png' alt='빼기아이콘'></a></td>";
                text += "<td class='code'>";
                text += "<input type='hidden' id='pdt_cd_" + num + "' name='pdt_cd' value='" + pdt.PDT_CD + "'>";
                text += "<input type='text' id='pdt_code_" + num + "' name='pdt_code' readonly value='" + pdt.PDT_CODE + "'></td>";
                text += "<td class='prod'><input type='text' id='pdt_name_" + num + "' name='pdt_name' value='" + pdt.PDT_NAME + "' placeholder=\"품목\"></td>";
                text += "<td class='prod'><input type='text' id='pdt_standard_" + num + "' name='pdt_standard' value='" + pdt.PDT_STANDARD + "' placeholder=\"규격\"></td>";
                text += "<td class='qty'><input type='text' id='qty_" + num + "' name='qty' value='1' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange(" + num + ");'></td>";
                text += "<td class='name'><input type='text' id='unit_" + num + "' name='unit' value='" + pdt.UNIT + "'></td>";
                if (pdt.IN_PRICE == 0) {
                    text += "<td class='qty'><input type='text' id='unit_price_" + num + "' name='unit_price' value='' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange(" + num + ");'></td>";
                } else {
                    text += "<td class='qty'><input type='text' id='unit_price_" + num + "' name='unit_price' value='" + comma(pdt.IN_PRICE) + "' onkeyup='this.value=this.value.replace(/[^0-9]/g,\"\"); priceChange(" + num + ");'></td>";
                }

                text += "<td class='qty'><input type='text' id='supply_price_" + num + "' name='supply_price' value='" + comma(pdt.IN_PRICE) + "' readonly></td>";
                text += "<td class='qty'><input type='text' id='vat_" + num + "' name='vat' value='" + comma(Math.round(pdt.IN_PRICE * 0.1)) + "' readonly></td>";
                text += "</tr>";


                $('#searchResult').append(text);

                $('#productCount').val(num);
                priceCal();

            }

            function priceChange(num) {

                var price = $('#unit_price_' + num).val().replace(/,/gi, "");
                var qty = $('#qty_' + num).val().replace(/,/gi, "");
                var supply_price = 0;
                var vat = 0;


                if (price == "0" || price == "undefined") {
                    supply_price = 0;
                    vat = 0;

                    $('#supply_price_' + num).val(supply_price);
                    $('#vat_' + num).val(vat);
                    $('#unit_price_' + num).val(comma(price));
                    $('#qty_' + num).val(comma(qty));
                } else {
                    supply_price = price * qty;
                    vat = Math.round(supply_price * 0.1);

                    $('#supply_price_' + num).val(comma(supply_price));
                    $('#vat_' + num).val(comma(vat));
                    $('#unit_price_' + num).val(comma(price));
                    $('#qty_' + num).val(comma(qty));

                    priceCal();

                }


            }

            function priceCal() {
                var supply_amount = 0;
                var tax_amount = 0;

                $('input[name="supply_price"]').each(function (idx, item) {
                    var supply_price_val = $(item).val();
                    supply_amount += Number(supply_price_val.replace(/,/gi, ""));

                });
                $('input[name="vat"]').each(function (idx, item) {
                    var vatValue = $(item).val();
                    tax_amount += Number(vatValue.replace(/,/gi, ""));
                });

                $('#supply_amount').val(comma(supply_amount));
                $('#tax_amount').val(comma(tax_amount));
                $('#total_amount').val(comma(supply_amount + tax_amount));

            }

            function openZipSearch() {
                if (sessionCheck()) {
                    new daum.Postcode({
                        oncomplete: function (data) {
                            $('[name=post_no]').val(data.zonecode); // 우편번호 (5자리)
                            $('[name=order_addr]').val(data.address);
                            $('[name=order_addr_info]').val('');
                        }
                    }).open();
                } else {
                    location.reload();
                }

            }
            function choiceCust(cust_seq, no, cust_name){
                $('#cust_seq').val(cust_seq);
                $('#supply_name').val(cust_name);
            }
        </script>
