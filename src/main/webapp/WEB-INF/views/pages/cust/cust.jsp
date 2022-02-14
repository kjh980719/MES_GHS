<%@page import="mes.app.util.Util" %>
<%@page import="mes.security.UserInfo" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld" prefix="dh" %>

<script type="text/javascript">
  <%
  UserInfo user = Util.getUserInfo();
  %>

  function resetPassword(seq, id) {
    if (confirm("해당 아이디의 비밀번호를 초기화 하시겠습니까?")) {
      var targetUrl = "/supply/resetPassword";
      $.ajax({
        type: "post",
        url: targetUrl,
        async: false,
        data: "seq=" + seq + "&id=" + id + "&no=" + $('#business_no2').val(),
        success: function (data) {
          if (data.success) {
            alert("사업자번호로 초기화 되었습니다.");
          }
        }, error: function (data) {
          alert("세션이 종료되었습니다.\n다시 로그인 해주세요.");
        }
      });
    }
  }

  function CreateSCMAccount() {
    var no = Number($('#SCMIDCount').val());

    if ($('input[name="scm_manager_id"]').length == 0) {
      no = 1;
    } else {
      no += 1;
    }

    var text = "";

    text += "<tr>";
    text += "<input type='hidden' id='scm_manager_seq_" + no + "' name='scm_manager_seq'/></td>";
    text += "<td class='no'>" + no + "</td>";
    text += "<td class='id'><input type='text' id='scm_manager_id_" + no + "' name='scm_manager_id'/></td>";

    text += "<td class='name'><input type='text' id='scm_manager_name_" + no + "' name='scm_manager_name'/></td>";
    text += "<td class='position'><input type='text' id='scm_manager_position_" + no + "' name='scm_manager_position'/></td>";
    text += "<td class='department'><input type='text' id='scm_manager_department_" + no + "' name='scm_manager_department'/></td>";
    text += "<td class='tel'><input type='text' id='scm_manager_tel_" + no + "' name='scm_manager_tel' onkeyup='autoHypen(this);' maxlength='13'/></td>";
    text += "<td class='email'><input type='text' id='scm_manager_email_" + no + "' name='scm_manager_email'/></td>";
    text += "<td class='use_yn'><div class=\"sel_wrap_p\"><select id='scm_use_yn_" + no + "' name='scm_use_yn' class='sel_02'>"
        + "<option value='Y'>사용</option>"
        + "<option value='N'>미사용</option>"
        + "</select></div></td>";
    text += "<td class='delete_yn'><div class=\"sel_wrap_p\"><select id='scm_delete_yn_" + no + "' name='scm_delete_yn' class='sel_02'>"
        + "<option value='Y'>삭제</option>"
        + "<option value='N'>미삭제</option>"
        + "</select></div></td>";
    text += "<td class='pw'></td>";
    text += "</tr>";

    $('#SCMIDCount').val(no);

    if ($('input[name="scm_manager_id"]').length == 0) {
      $('#searchResult').html(text);
    } else {
      $('#searchResult').append(text);
    }
  }

  function CreateBuyerAccount() {
    var no = Number($('#BuyerIDCount').val());

    if ($('input[name="buyer_member_id"]').length == 0) {
      no = 1;
    } else {
      no += 1;
    }

    var text = "";

    text += "<tr>";
    text += "<input type='hidden' id='buyer_member_seq_" + no + "' name='buyer_member_seq'/></td>";
    text += "<td class='no'>" + no + "</td>";
    text += "<td class='id'><input type='text' id='buyer_member_id_" + no + "' name='buyer_member_id'/></td>";

    text += "<td class='name'><input type='text' id='buyer_member_name_" + no + "' name='buyer_member_name'/></td>";
    text += "<td class='position'><input type='text' id='buyer_member_position_" + no + "' name='buyer_member_position'/></td>";
    text += "<td class='department'><input type='text' id='buyer_member_department_" + no + "' name='buyer_member_department'/></td>";
    text += "<td class='tel'><input type='text' id='buyer_member_tel_" + no + "' name='buyer_member_tel' onkeyup='autoHypen(this);' maxlength='13'/></td>";
    text += "<td class='email'><input type='text' id='buyer_member_email_" + no + "' name='buyer_member_email'/></td>";
    text += "<td class='use_yn'><div class=\"sel_wrap_p\"><select id='buyer_member_grade_" + no + "' name='buyer_member_grade' class='sel_02'>"
        + "<option value='' selected>없음</option>"
        <c:forEach items="${memberGradeCodeList}" var="list" >
        + "<option value='${list.code}'>${list.code_nm}</option>"
        </c:forEach>
        + "</select></div></td>";
    text += "<td class='use_yn'><div class=\"sel_wrap_p\"><select id='buyer_use_yn_" + no + "' name='buyer_use_yn' class='sel_02'>"
        + "<option value='Y'>사용</option>"
        + "<option value='N'>미사용</option>"
        + "</select></div></td>";
    text += "<td class='delete_yn'><div class=\"sel_wrap_p\"><select id='buyer_delete_yn_" + no + "' name='buyer_delete_yn' class='sel_02'>"
        + "<option value='Y'>삭제</option>"
        + "<option value='N'>미삭제</option>"
        + "</select></div></td>";
    text += "<td class='pw'></td>";
    text += "</tr>";

    $('#BuyerIDCount').val(no);

    if ($('input[name="buyer_member_id"]').length == 0) {
      $('#b_searchResult').html(text);
    } else {
      $('#b_searchResult').append(text);
    }
  }

  function GoActionButton() {
    var targetUrl = ""
    var pdt_name = "";
    var status = true;

    var mode = $('#mode').val();
    targetUrl = "/supply/SupplyAccountRegister";

    $('input[name="scm_manager_id"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("아이디를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="scm_manager_name"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("담당자를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="scm_manager_position"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("직급를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="scm_manager_department"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("부서를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="scm_manager_tel"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("핸드폰번호를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="scm_manager_email"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("이메일을 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    var supplycreateList = [];

    for (var i = 0; i < $('#SCMIDCount').val(no); i++) {
      var tmpMap = {};

      tmpMap.business_no = $($("input[name='business_no']")).val();
      tmpMap.cust_name = $($("input[name='cust_name']")).val();
      tmpMap.boss_name = $($("input[name='boss_name']")).val();
      tmpMap.cust_seq = $($("input[name='cust_seq']")).val();

      tmpMap.scm_manager_seq = $($("input[name='scm_manager_seq']")[i]).val();
      tmpMap.no = $($("input[name='no']")[i]).val();
      tmpMap.scm_manager_id = $($("input[name='scm_manager_id']")[i]).val();
      tmpMap.scm_manager_name = $($("input[name='scm_manager_name']")[i]).val();
      tmpMap.scm_manager_position = $($("input[name='scm_manager_position']")[i]).val();
      tmpMap.scm_manager_department = $($("input[name='scm_manager_department']")[i]).val();
      tmpMap.scm_manager_tel = $($("input[name='scm_manager_tel']")[i]).val();
      tmpMap.scm_manager_email = $($("input[name='scm_manager_email']")[i]).val();
      tmpMap.scm_use_yn = $($("select[name='scm_use_yn']")[i]).val();
      tmpMap.scm_delete_yn = $($("select[name='scm_delete_yn']")[i]).val();

      supplycreateList.push(tmpMap)
    }

    sendData = {};

    sendData.supplycreateList = supplycreateList;

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
        alert("계정이 등록되었습니다.");
        CreateSupplyInfoLayer_Close();
        location.reload();
      } else {
        alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
      }
    });

  }

  function GoActionBuyerButton() {
    var targetUrl = ""
    var pdt_name = "";
    var status = true;

    var mode = $('#mode').val();
    targetUrl = "/buyer/BuyerAccountRegister";

    $('input[name="buyer_member_id"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("아이디를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="buyer_member_name"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("담당자를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="buyer_member_position"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("직급를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="buyer_member_department"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("부서를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="buyer_member_tel"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("핸드폰번호를 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    $('input[name="buyer_member_email"]').each(function (idx, item) {
      var unit = $(item).val();
      if (isEmpty(unit)) {
        alert("이메일을 입력해주세요.");
        status = false;
      }
    });
    if (status == false) return;

    var buyercreateList = [];

    for (var i = 0; i < $('#BuyerIDCount').val(); i++) {
      console.log(i);
      var tmpMap = {};

      tmpMap.business_no = $($("input[name='b_business_no']")).val();
      tmpMap.cust_name = $($("input[name='b_cust_name']")).val();
      tmpMap.boss_name = $($("input[name='b_boss_name']")).val();
      tmpMap.cust_seq = $($("input[name='b_cust_seq']")).val();

      tmpMap.buyer_member_seq = $($("input[name='buyer_member_seq']")[i]).val();
      tmpMap.no = $($("input[name='b_no']")[i]).val();
      tmpMap.buyer_member_id = $($("input[name='buyer_member_id']")[i]).val();
      tmpMap.buyer_member_name = $($("input[name='buyer_member_name']")[i]).val();
      tmpMap.buyer_member_position = $($("input[name='buyer_member_position']")[i]).val();
      tmpMap.buyer_member_department = $($("input[name='buyer_member_department']")[i]).val();
      tmpMap.buyer_member_tel = $($("input[name='buyer_member_tel']")[i]).val();
      tmpMap.buyer_member_email = $($("input[name='buyer_member_email']")[i]).val();
      tmpMap.buyer_member_grade = $($("select[name='buyer_member_grade']")[i]).val();
      tmpMap.buyer_use_yn = $($("select[name='buyer_use_yn']")[i]).val();
      tmpMap.buyer_delete_yn = $($("select[name='buyer_delete_yn']")[i]).val();

      buyercreateList.push(tmpMap)
    }


    sendData = {};

    sendData.buyercreateList = buyercreateList;

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
        alert("계정이 등록되었습니다.");
        CreateBuyerInfoLayer_Close();
        location.reload();
      } else {
        alert("데이터오류로 등록에 실패하였습니다.\n관리자에게 문의하세요");
      }
    });

  }

  function CreateSupplyInfoLayer_Close() {
    $('#CreateSupplyInfoLayer').removeClass('view');
    $('html,body').css('overflow', '');
    $('.info_edit').removeClass('view');
  }

  function CreateBuyerInfoLayer_Close() {
    $('#CreateBuyerInfoLayer').removeClass('view');
    $('html,body').css('overflow', '');
    $('.info_edit').removeClass('view');
  }

  function CreateSupplyInfoLayer_Open(CUST_SEQ) {
    $('#SupplyInfo_Form').resetForm();

    $.ajax({
      type: "get",
      url: '/cust/selectCust',
      contentType: 'application/json',
      async: false,
      data: "CUST_SEQ=" + CUST_SEQ,
      success: function (data) {
        var business_no = data.storeData.BUSINESS_NO;
        var boss_name = data.storeData.BOSS_NAME;
        var cust_name = data.storeData.CUST_NAME;
        var cust_seq = data.storeData.CUST_SEQ;

        $('#cust_name').val(cust_name);
        $('#business_no').val(business_no);
        $('#boss_name').val(boss_name);
        $('#cust_seq').val(cust_seq);
        $('#cust_name2').text(cust_name);
        $('#business_no2').text(business_no);
        $('#boss_name2').text(boss_name);
        $('#cust_seq2').text(cust_seq);

      }
    });

    $.ajax({
      type: "post",
      url: '/supply/popSupplyAccountCreate',
      async: false,
      data: "CUST_SEQ=" + CUST_SEQ,
      success: function (data) {
        var array = data.storeData;
        var cust_name = "";
        var business_no = "";
        var boss_name = "";
        var cust_seq = "";
        var scm_manager_seq = "";
        var scm_manager_id = "";
        var scm_manager_name = "";
        var scm_manager_position = "";
        var scm_manager_department = "";
        var scm_manager_tel = "";
        var scm_manager_email = "";
        var scm_use_yn = "";
        var scm_delete_yn = "";
        var no = "";
        var text = "";

        if (array.length > 0) {
          cust_name = array[0].cust_name;
          business_no = array[0].business_no;
          boss_name = array[0].boss_name;
          cust_seq = array[0].cust_seq;

          $('#cust_name2').val(cust_name);
          $('#business_no2').val(business_no);
          $('#boss_name2').val(boss_name);
          $('#cust_seq2').val(cust_seq);

          for (var i in array) {
            var U_chk1 = "";
            var U_chk2 = "";
            if (array[i].scm_use_yn == "Y") {
              U_chk1 = "selected";
            } else if (array[i].scm_use_yn == "N") {
              U_chk2 = "selected";
            }

            var D_chk1 = "";
            var D_chk2 = "";
            if (array[i].scm_delete_yn == "Y") {
              D_chk1 = "selected";
              D_chk2 = "";
            } else if (array[i].scm_delete_yn == "N") {
              D_chk1 = "";
              D_chk2 = "selected";
            } else {
              D_chk1 = "";
              D_chk2 = "selected";
            }

            scm_manager_seq = array[i].scm_manager_seq;
            no = 1
            scm_manager_id = array[i].scm_manager_id;
            scm_manager_name = array[i].scm_manager_name;
            scm_manager_position = array[i].scm_manager_position;
            scm_manager_department = array[i].scm_manager_department;
            scm_manager_tel = array[i].scm_manager_tel;
            scm_manager_email = array[i].scm_manager_email
            scm_use_yn = array[i].scm_use_yn;
            scm_delete_yn = array[i].scm_delete_yn;
            text += "<tr>";
            text += "<input type='hidden' id='scm_manager_seq_" + no + "' name='scm_manager_seq' value='" + scm_manager_seq + "'/>";
            text += "<td class='no'>" + no + "</td>";
            text += "<td class='id'><input type='text' id='scm_manager_id_" + no + "' name='scm_manager_id' value='" + scm_manager_id + "' readoly/></td>";
            text += "<td class='name'><input type='text' id='scm_manager_name_" + no + "' name='scm_manager_name' value='" + scm_manager_name + "'/></td>";
            text += "<td class='position'><input type='text' id='scm_manager_position_" + no + "' name='scm_manager_position' value='" + scm_manager_position + "'/></td>";
            text += "<td class='department'><input type='text' id='scm_manager_department_" + no + "' name='scm_manager_department' value='" + scm_manager_department + "'/></td>";
            text += "<td class='tel'><input type='text' id='scm_manager_tel_" + no + "' name='scm_manager_tel' value='" + scm_manager_tel
                + "' onKeyup='regexPhone(this);' maxlength='16'/></td>";
            text += "<td class='email'><input type='text' id='scm_manager_email_" + no + "' name='scm_manager_email' value='" + scm_manager_email + "'/></td>";
            text += "<td class='use_yn'><div class=\"sel_wrap_p\"><select id='scm_use_yn_" + no + "' name='scm_use_yn' class='sel_02'>"
                + "<option value='Y' " + U_chk1 + ">사용</option>"
                + "<option value='N' " + U_chk2 + ">미사용</option>"
                + "</select></div></td>";
            text += "<td class='delete_yn'><div class=\"sel_wrap_p\"><select id='scm_delete_yn_" + no + "' name='scm_delete_yn' class='sel_02'>"
                + "<option value='Y' " + D_chk1 + ">삭제</option>"
                + "<option value='N' " + D_chk2 + ">미삭제</option>"
                + "</select></div></td>";
            text += "<td class='pw'><a href='#' class='btn_02 btn_s' onclick='resetPassword(\"" + scm_manager_seq + "\" , \"" + scm_manager_id + "\");'>비밀번호 초기화</a></td>";

            text += "</tr>";
            $('#SCMIDCount').val(no);
            no++;
          }

        } else {
          text += "<tr class='all'><td colspan='10'>계정 정보가 없습니다.</td></tr>";
          $('#actionButton').text('등록');
        }

        $('#CreateSupplyInfoLayer').addClass('view');
        $("#supply_name").removeAttr("onclick");
        $('#actionButton').text('수정');
        $('#searchResult').html(text);
      }
    });

    $('#CreateSupplyInfoLayer').addClass('view');
    $('html,body').css('overflow', 'hidden');
    $('.leftNav').removeClass('view');
  }

  function CreateBuyerInfoLayer_Open(CUST_SEQ) {
    $('#BuyerInfo_Form').resetForm();

    $.ajax({
      type: "get",
      url: '/cust/selectCust',
      contentType: 'application/json',
      async: false,
      data: "CUST_SEQ=" + CUST_SEQ,
      success: function (data) {
        var business_no = data.storeData.BUSINESS_NO;
        var boss_name = data.storeData.BOSS_NAME;
        var cust_name = data.storeData.CUST_NAME;
        var cust_seq = data.storeData.CUST_SEQ;
        $('#b_cust_name').val(cust_name);
        $('#b_business_no').val(business_no);
        $('#b_boss_name').val(boss_name);
        $('#b_cust_seq').val(cust_seq);
        $('#b_cust_name2').text(cust_name);
        $('#b_business_no2').text(business_no);
        $('#b_boss_name2').text(boss_name);
        $('#b_cust_seq2').text(cust_seq);
      }
    });

    $.ajax({
      type: "post",
      url: '/buyer/getBuyerMemberList',
      async: false,
      data: "CUST_SEQ=" + CUST_SEQ,
      success: function (data) {
        var array = data.storeData;
        var cust_name = "";
        var business_no = "";
        var boss_name = "";
        var cust_seq = "";
        var buyer_member_seq = "";
        var buyer_member_id = "";
        var buyer_member_name = "";
        var buyer_member_position = "";
        var buyer_member_department = "";
        var buyer_member_tel = "";
        var buyer_member_email = "";
        var buyer_member_grade = "";
        var buyer_use_yn = "";
        var buyer_delete_yn = "";
        var no = "";
        var text = "";

        if (array.length > 0) {

          for (var i in array) {
            var U_chk1 = "";
            var U_chk2 = "";
            if (array[i].buyer_use_yn == "Y") {
              U_chk1 = "selected";
            } else if (array[i].buyer_use_yn == "N") {
              U_chk2 = "selected";
            }

            var D_chk1 = "";
            var D_chk2 = "";

            if (array[i].buyer_delete_yn == "Y") {
              D_chk1 = "selected";
              D_chk2 = "";
            } else if (array[i].buyer_delete_yn == "N") {
              D_chk1 = "";
              D_chk2 = "selected";
            } else {
              D_chk1 = "";
              D_chk2 = "selected";
            }

            buyer_member_seq = array[i].buyer_member_seq;
            no = 1
            buyer_member_id = array[i].buyer_member_id;
            buyer_member_name = array[i].buyer_member_name;
            buyer_member_position = array[i].buyer_member_position;
            buyer_member_department = array[i].buyer_member_department;
            buyer_member_tel = array[i].buyer_member_tel;
            buyer_member_email = array[i].buyer_member_email
            buyer_member_grade = array[i].buyer_member_grade
            buyer_use_yn = array[i].buyer_use_yn;
            buyer_delete_yn = array[i].buyer_delete_yn;

            text += "<tr>";
            text += "<input type='hidden' id='buyer_member_seq_" + no + "' name='buyer_member_seq' value='" + buyer_member_seq + "'/>";
            text += "<td class='no'>" + no + "</td>";
            text += "<td class='id'><input type='text' id='buyer_member_id_" + no + "' name='buyer_member_id' value='" + buyer_member_id + "' readoly/></td>";
            text += "<td class='name'><input type='text' id='buyer_member_name_" + no + "' name='buyer_member_name' value='" + buyer_member_name + "'/></td>";
            text += "<td class='position'><input type='text' id='buyer_member_position_" + no + "' name='buyer_member_position' value='" + buyer_member_position + "'/></td>";
            text += "<td class='department'><input type='text' id='buyer_member_department_" + no + "' name='buyer_member_department' value='" + buyer_member_department
                + "'/></td>";
            text += "<td class='tel'><input type='text' id='buyer_member_tel_" + no + "' name='buyer_member_tel' value='" + buyer_member_tel
                + "' onKeyup='regexPhone(this);' maxlength='16'/></td>";
            text += "<td class='email'><input type='text' id='buyer_member_email_" + no + "' name='buyer_member_email' value='" + buyer_member_email + "'/></td>";


            text +=   "<select name='bad_reason' id='bad_reason_"+array[i].no+"' class='sel_02'>";
            text += "<option value=''>없음</option>";

            text += "</select></div></td>";

            text += "<td class='use_yn'><div class=\"sel_wrap_p\"><select id='buyer_member_grade_" + no + "' name='buyer_member_grade' class='sel_02'>"
                + "<option value='' selected>없음</option>"
            <c:forEach items="${memberGradeCodeList}" var="list">
            if (buyer_member_grade == '${list.code}'){
              text += "<option value='${list.code}' selected>${list.code_nm}</option>"
            }else{
              text += "<option value='${list.code}'>${list.code_nm}</option>"
            }
            </c:forEach>
                + "</select></div></td>";
            text += "<td class='use_yn'><div class=\"sel_wrap_p\"><select id='buyer_use_yn_" + no + "' name='buyer_use_yn' class='sel_02'>"
                + "<option value='Y' " + U_chk1 + ">사용</option>"
                + "<option value='N' " + U_chk2 + ">미사용</option>"
                + "</select></div></td>";
            text += "<td class='delete_yn'><div class=\"sel_wrap_p\"><select id='buyer_delete_yn_" + no + "' name='buyer_delete_yn' class='sel_02'>"
                + "<option value='Y' " + D_chk1 + ">삭제</option>"
                + "<option value='N' " + D_chk2 + ">미삭제</option>"
                + "</select></div></td>";
            text += "<td class='pw'><a href='#' class='btn_02 btn_s' onclick='resetPassword(\"" + buyer_member_seq + "\" , \"" + buyer_member_id + "\");'>비밀번호 초기화</a></td>";

            text += "</tr>";
            $('#BuyerIDCount').val(no);
            no++;
          }

          $('#b_actionButton').text('수정');
        } else {
          text += "<tr class='all'><td colspan='11'>계정 정보가 없습니다.</td></tr>";
          $('#b_actionButton').text('등록');
        }

        $('#CreateBuyerInfoLayer').addClass('view');
        $("#supply_name").removeAttr("onclick");
        $('#b_searchResult').html(text);
      }
    });

    $('#CreateBuyerInfoLayer').addClass('view');
    $('html,body').css('overflow', 'hidden');
    $('.leftNav').removeClass('view');
  }

  function tabView(num, el) {
    $('.marter_tab li').removeClass('view');
    $(el).parents('li').addClass('view');
    $('.tab_box').css('display', 'none');
    $('.tab_box' + num).css('display', 'block');

  }

  function managerSearch_open() {
    if (sessionCheck()) {
      var url = "/workplan/popManagerList?type=cust";
      $('#manager_popup').css('display', 'block');
      $('#manager_popupframe').attr('src', url);
      $('html,body').css('overflow', 'hidden');
    } else {
      location.reload(true);
    }

  }

  function managerSearch_close() {
    $('#manager_popup').css('display', 'none');
    $('#manager_popupframe').removeAttr('src');
    $('html,body').css('overflow', '');
  }

  function openLayer() {
    var url = "/supply/popSupplyList?type=cust";
    $('#popup').css('display', 'block');
    $('#popupframe').attr('src', url);
    $('html,body').css('overflow', 'hidden');

  }

  function closeLayer() {
    $('#popup').css('display', 'none');
    $('#popupframe').removeAttr('src');
    $('html,body').css('overflow', '');

  }

  function custInfoLayer_Create() {

    var param = $("#custInfo_Form").serializeObject();
    console.log(param);
    var value = checkvaild();
    if (value == null) {
      $.ajax({
        type: "post",
        url: '/cust/createCust',
        data: JSON.stringify(param),
        contentType: 'application/json',
        async: false
      }).done(function (response) {
        if (response.success) {
          alert("저장되었습니다.");
          custInfoLayer_Close();
          location.reload();
        } else {
          alert("저장시 오류가 발생하였습니다." + response.message);
          $("#custInfo_Form input[name='" + response.code + "']").focus();
        }
        $(".registCustBtn").on("click", function () {
          registCust();
        });
      });
    } else {
      alert("[" + value + "]는 필수항목입니다.");
    }
  }

  function openZipSearch(target) {

    new daum.Postcode({
      oncomplete: function (data) {
        if (target == 1) {
          $('[name=POST_NO]').val(data.zonecode); // 우편번호 (5자리)
          $('[name=ADDR]').val(data.address);
        } else {
          $('[name=DM_POST]').val(data.zonecode); // 우편번호 (5자리)
          $('[name=DM_ADDR]').val(data.address);
        }

      }
    }).open();
  }

  function checkvaild() {
    var value = null;
    var BUSINESS_NO = $('#BUSINESS_NO').val();
    var CUST_NAME = $('#CUST_NAME').val();
    if (isEmpty(BUSINESS_NO)) {
      value = "거래처코드";
    } else if (isEmpty(CUST_NAME)) {
      value = "상호(이름)";
    }

    return value;
  }

  function goSearch() {
    $('#search_string').val($('#search_string').val().trim());
    $('#rowsPerPage').val($('#rowPerPage_1').val());
    $('#searchForm').submit();
  }

  function goReset() {
    $('#searchForm').resetForm();
  }

  function newRegister() {
    custInfoLayer_Open(0, "regist");
  }

  function custInfoLayer_Close() {
    $('#custInfoLayer').removeClass('view');
    $('html,body').css('overflow', '');
    $('.info_edit').removeClass('view');
  }

  function viewCustDetail(CUST_SEQ, type) {
    custInfoLayer_Open(CUST_SEQ, type);
  }

  function custInfoLayer_Open(CUST_SEQ, type) {
    var text = "";
    $('.tab_box1').css("display", "");
    $('.tab_box2').css("display", "none");
    $('.tab_box3').css("display", "none");

    $('#tab li').removeClass('view');
    $('#tab li:first-child').addClass('view');

    if (type == "view") { //상세보기
      $.ajax({
        type: "get",
        url: '/cust/selectCust',
        contentType: 'application/json',
        async: false,
        data: "CUST_SEQ=" + CUST_SEQ,
        success: function (data) {
          var array = data.storeData;
          var CUST_SEQ = "";
          var BUSINESS_NO = "";
          var CUST_NAME = "";
          var BOSS_NAME = "";
          var UPTAE = "";
          var JONGMOK = "";
          var TEL = "";
          var EMAIL = "";
          var POST_NO = "";
          var ADDR = "";
          var ADDR_INFO = "";
          var G_GUBUN = "";
          var G_BUSINESS_TYPE = "";
          var G_BUSINESS_CD = "";
          var TAX_REG_ID = "";
          var FAX = "";
          var HP_NO = "";
          var DM_POST = "";
          var DM_ADDR = "";
          var DM_ADDR_INFO = "";
          var REMARKS_WIN = "";
          var GUBUN = "";
          var EXCHANGE_CODE = "";
          var CUST_GROUP1 = "";
          var CUST_GROUP2 = "";
          var URL_PATH = "";
          var REMARKS = "";
          var OUTORDER_YN = "";
          var IO_CODE_SL = "";
          var MANAGER_SEQ = "";
          var MANAGER_NAME = "";
          var MANAGE_BOND_NO = "";
          var MANAGE_DEBIT_NO = "";
          var CUST_LIMIT = "";
          var O_RATE = "";
          var I_RATE = "";
          var PRICE_GROUP = "";
          var PRICE_GROUP2 = "";
          var CUST_LIMIT_TERM = "";

          var USE_YN = "";
          var PAY_DATE = "";

          text = "";

          if (array.CUST_SEQ != 'undefined') {
            CUST_SEQ = array.CUST_SEQ;
            BUSINESS_NO = array.BUSINESS_NO;
            CUST_NAME = array.CUST_NAME;
            BOSS_NAME = array.BOSS_NAME;
            UPTAE = array.UPTAE;
            JONGMOK = array.JONGMOK;
            TEL = array.TEL;
            EMAIL = array.EMAIL;
            POST_NO = array.POST_NO;
            ADDR = array.ADDR;
            ADDR_INFO = array.ADDR_INFO;
            G_GUBUN = array.G_GUBUN;
            G_BUSINESS_TYPE = array.G_BUSINESS_TYPE;
            G_BUSINESS_CD = array.G_BUSINESS_CD;
            TAX_REG_ID = array.TAX_REG_ID;
            FAX = array.FAX;
            HP_NO = array.HP_NO;
            DM_POST = array.DM_POST;
            DM_ADDR = array.DM_ADDR;
            DM_ADDR_INFO = array.DM_ADDR_INFO;
            REMARKS_WIN = array.REMARKS_WIN;
            GUBUN = array.GUBUN;
            EXCHANGE_CODE = array.EXCHANGE_CODE;
            CUST_GROUP1 = array.CUST_GROUP1;
            CUST_GROUP2 = array.CUST_GROUP2;
            URL_PATH = array.URL_PATH;
            REMARKS = array.REMARKS;
            OUTORDER_YN = array.OUTORDER_YN;
            IO_CODE_SL = array.IO_CODE_SL;
            MANAGER_SEQ = array.MANAGER_SEQ;
            MANAGER_NAME = array.MANAGER_NAME;
            MANAGE_BOND_NO = array.MANAGE_BOND_NO;
            MANAGE_DEBIT_NO = array.MANAGE_DEBIT_NO;
            CUST_LIMIT = array.CUST_LIMIT;
            O_RATE = array.O_RATE;
            I_RATE = array.I_RATE;
            PRICE_GROUP = array.PRICE_GROUP;
            PRICE_GROUP2 = array.PRICE_GROUP2;
            CUST_LIMIT_TERM = array.CUST_LIMIT_TERM;

            USE_YN = array.USE_YN;
            PAY_DATE = array.PAY_DATE;

            $('#CUST_SEQ_DB').val(CUST_SEQ);
            $('#BUSINESS_NO').val(BUSINESS_NO);
            $('#CUST_NAME').val(CUST_NAME);
            $('#BOSS_NAME').val(BOSS_NAME);
            $('#UPTAE').val(UPTAE);
            $('#JONGMOK').val(JONGMOK);
            $('#TEL').val(TEL);
            $('#EMAIL').val(EMAIL);
            $('#POST_NO').val(POST_NO);
            $('#ADDR').val(ADDR);
            $('#ADDR_INFO').val(ADDR_INFO);
            switch (G_GUBUN) {
              case "CCG001" :
                $("#G_GUBUN1").prop("checked", true);
                break;
              case "CCG002" :
                $("#G_GUBUN2").prop("checked", true);
                break;
              case "CCG003" :
                $("#G_GUBUN3").prop("checked", true);
                break;
              default :
                $("#G_GUBUN1").prop("checked", true);
                break;
            }
            $('#G_BUSINESS_CD').attr("readonly", false);
            $('#G_BUSINESS_CD').attr("onclick", "");
            switch (G_BUSINESS_TYPE) {
              case "1" :
                $("#G_BUSINESS_TYPE1").prop("checked", true);
                $('#g_business_input').addClass('g_business_none');
                break;
              case "2" :
                $("#G_BUSINESS_TYPE2").prop("checked", true);
                $('#g_business_input').removeClass('g_business_none');
                $('#G_BUSINESS_CD').attr("onclick", "openLayer();")
                $('#G_BUSINESS_CD').attr("readonly", true);
                break;
              case "3" :
                $("#G_BUSINESS_TYPE3").prop("checked", true);
                $('#g_business_input').removeClass('g_business_none');
                break;
              default :
                $("#G_BUSINESS_TYPE1").prop("checked", true);
                $('#g_business_input').addClass('g_business_none');
                break;
            }

            $('#G_BUSINESS_CD').val(G_BUSINESS_CD);
            $('#TAX_REG_ID').val(TAX_REG_ID);
            $('#FAX').val(FAX);
            $('#HP_NO').val(HP_NO);
            $('#DM_POST').val(DM_POST);
            $('#DM_ADDR').val(DM_ADDR);
            $('#DM_ADDR_INFO').val(DM_ADDR_INFO);
            $('#REMARKS_WIN').val(REMARKS_WIN);
            $('#GUBUN').val(GUBUN);
            $('#EXCHANGE_CODE').val(EXCHANGE_CODE);
            $('#CUST_GROUP1').val(CUST_GROUP1);
            $('#CUST_GROUP2').val(CUST_GROUP2);
            $('#URL_PATH').val(URL_PATH);
            $('#REMARKS').val(REMARKS);

            $("#G_BUSINESS_TYPE2").prop("checked", true);
            $("input:radio[name='OUTORDER_YN']:input[value='" + OUTORDER_YN + "']").prop("checked", true);
            $('#IO_CODE_SL').val(IO_CODE_SL);
            $('#MANAGER_SEQ').val(MANAGER_SEQ);
            isEmpty(MANAGER_SEQ) ? $('#MANAGER_SEQ').val(0) : $('#MANAGER_SEQ').val(MANAGER_SEQ);

            $('#MANAGER_NAME').val(MANAGER_NAME);
            $('#MANAGE_BOND_NO').val(MANAGE_BOND_NO);
            $('#MANAGE_DEBIT_NO').val(MANAGE_DEBIT_NO);
            $('#CUST_LIMIT').val(CUST_LIMIT);
            $('#O_RATE').val(O_RATE);
            $('#I_RATE').val(I_RATE);
            $('#PRICE_GROUP').val(PRICE_GROUP);
            $('#PRICE_GROUP2').val(PRICE_GROUP2);
            $('#CUST_LIMIT_TERM').val(CUST_LIMIT_TERM);

            $('#USE_YN').val(USE_YN);
            $('#PAY_DATE').val(PAY_DATE);

          } else {
            text += "<tr class='all'><td colspan='7'>거래처정보가 없습니다.</td></tr>";
          }
          $('#addButton').css('display', 'none');
          $('#custChoice').text('수정');
          $('#searchResult').html(text);
          $('#custChoice').attr("onclick", "custInfoLayer_Update()");

        }
      });
    } else { //신규작성일때
      $('#addButton').css('display', 'block');
      $('#custChoice').text('등록');
      $('#searchResult').empty();
      $('#custInfo_Form').resetForm();
      $('#searchResult').html(text);
      $('#custChoice').attr("onclick", "custInfoLayer_Create()");
      $("#G_BUSINESS_TYPE1").prop("checked", true);
      $('#g_business_input').addClass('g_business_none');

    }

    $('#custInfoLayer').addClass('view');
    $('html,body').css('overflow', 'hidden');
    $('.leftNav').removeClass('view');
  }

  function custInfoLayer_Close() {
    $('#custInfoLayer').removeClass('view');
    $('html,body').css('overflow', '');
    $('.info_edit').removeClass('view');
  }

  function custInfoLayer_Update() {
    var param = $("#custInfo_Form").serializeObject();
    console.log(param);
    $.ajax({
      type: "post",
      url: '/cust/updateCust',
      contentType: 'application/json',
      async: false,
      data: JSON.stringify(param)
    }).done(function (response) {
      if (response.success) {
        alert("수정되었습니다.");
        custInfoLayer_Close();
        location.reload();
      } else {
        alert("저장시 오류가 발생하였습니다." + response.message);
        $("#custInfo_Form input[name='" + response.code + "']").focus();
      }
      $(".registCustBtn").on("click", function () {
        registCust();
      });
    });

  }

  $(document).ready(function () {

    $('ul.tabs li').click(function () {
      var tab_id = $(this).attr('data-tab');

      $('ul.tabs li').removeClass('current');
      $('.tab-content').removeClass('current');

      $(this).addClass('current');
      $("#" + tab_id).addClass('current');
    })

  });


</script>
<style>


  ul.tabs {
    margin: 0px;
    padding: 0px;
    list-style: none;
  }

  ul.tabs li {
    background: none;
    color: #222;
    display: inline-block;
    padding: 10px 15px;
    cursor: pointer;
  }

  ul.tabs li.current {
    background: #ededed;
    color: #222;
  }

  .tab-content {
    display: none;
    background: #ededed;
    padding: 15px;
  }

  .tab-content.current {
    display: inherit;
  }
</style>

<h3 class="mjtit_top">
    거래처 조회
    <a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>

<!-- 관리자 검색시작-->
<div class="master_cont">

    <form id="searchForm" action="/cust/cust">
        <input type="hidden" value="" name="rowsPerPage" id="rowsPerPage"/>
        <div class="srch_all">
            <div class="sel_wrap sel_wrap1">
                <select name="USE_YN" class="sel_02">
                    <option value="Y" <c:if test="${search.USE_YN == 'Y'}">selected</c:if>>사용</option>
                    <option value="N" <c:if test="${search.USE_YN == 'N'}">selected</c:if>>미사용</option>
                </select>
            </div>
            <div class="sel_wrap sel_wrap1">
                <select name="search_type" class="sel_02">
                    <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
                    <option value="CUST_NAME" <c:if test="${search.search_type == 'CUST_NAME'}">selected</c:if>>거래처명</option>
                    <option value="BUSINESS_NO" <c:if test="${search.search_type == 'BUSINESS_NO'}">selected</c:if>>거래처코드</option>
                    <option value="BOSS_NAME" <c:if test="${search.search_type == 'BOSS_NAME'}">selected</c:if>>대표자명</option>
                    <option value="REMARKS_WIN" <c:if test="${search.search_type == 'REMARKS_WIN'}">selected</c:if>>키워드</option>

                </select>
            </div>

            <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}"/>
            <div class="srch_btn">
                <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                <button type="button" class="btn_01">초기화</button>
            </div>

            <div class="register_btn">
                <button type="button" class="btn_02" onclick="newRegister()">신규등록</button>
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
                    <option value="15" <c:if test="${search.rowsPerPage == '15'}">selected</c:if>>15개씩 보기</option>
                    <option value="30" <c:if test="${search.rowsPerPage == '30'}">selected</c:if>>30개씩 보기</option>
                    <option value="50" <c:if test="${search.rowsPerPage == '50'}">selected</c:if>>50개씩 보기</option>
                    <option value="100" <c:if test="${search.rowsPerPage == '100'}">selected</c:if>>100개씩 보기</option>
                </select>
            </div>
        </div>
    </div>
    <div class="master_list scroll">
        <table class="master_01">
            <colgroup>
                <col style="width: 55px;"/>
                <col style="width: 115px;"/>
                <col style="width: 280px;">
                <col style="width: 100px;"/>
                <col style="width: 110px;"/>
                <col style="width: 110px;"/>
                <col style="width: 110px;"/>
                <col style="width: 90px;"/>
                <col style="width: 113px;"/>
            </colgroup>
            <thead>
            <tr>
                <th>No</th>
                <th>거래처코드</th>
                <th>거래처명</th>
                <th>대표자명</th>
                <th>전화번호</th>
                <th>핸드폰번호</th>
                <th>키워드</th>
                <th>사용구분</th>
                <th>관리</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="list">
                <tr>
                    <td class="num"><fmt:formatNumber value="${total+1-list.no}" pattern="#,###,###"/></td>
                    <td class="code">
                        <a href="#" onclick="viewCustDetail('${list.CUST_SEQ}','view');">${list.BUSINESS_NO}</a>
                        <a href="#" onclick="viewCustDetail('${list.CUST_SEQ}','view');" class="m_link">${list.BUSINESS_NO}</a>
                    </td>
                    <td class="prod">
                        <a href="#" onclick="viewCustDetail('${list.CUST_SEQ}','view');">${list.CUST_NAME}</a>
                    </td>
                    <td class="boss">${list.BOSS_NAME}</td>
                    <td class="tel">${list.TEL}</td>
                    <td class="hp_no">${list.HP_NO}</td>
                    <td class="keyword">${list.REMARKS_WIN}</td>
                    <c:choose>
                        <c:when test="${list.USE_YN eq 'Y'}">
                            <td class="use">사용</td>
                        </c:when>
                        <c:when test="${list.USE_YN eq 'N'}">
                            <td class="use">미사용</td>
                        </c:when>
                    </c:choose>
                    <c:choose>
                        <%--<c:when test="${list.CUST_GROUP1 == 'CT001' || list.CUST_GROUP1 == 'CT002'}">
                            <td class="ing"><a href="#" class="btn_02 btn_s" onclick="CreateSupplyInfoLayer_Open('${list.CUST_SEQ}');">공급사계정관리</a></td>
                        </c:when>--%>
                        <c:when test="${list.CUST_GROUP1 == 'CT003' }">
                            <td class="ing"><a href="#" class="btn_02 btn_s" onclick="CreateBuyerInfoLayer_Open('${list.CUST_SEQ}');">고객사계정관리</a></td>
                        </c:when>
                        <c:otherwise>
                            <td class="ing"></td>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </c:forEach>
            <c:if test="${empty list }">
                <tr>
                    <td colspan="9">거래처 정보가 없습니다.</td>
                </tr>
            </c:if>

            </tbody>
        </table>
    </div>
    <div class="mjpaging_comm">
        ${dh:pagingB(total, search.currentPage, search.rowsPerPage, 10, parameter)}
    </div>
</div>

<div class="master_pop master_pop01" id="custInfoLayer">
    <div class="master_body">
        <div class="pop_bg" onclick="custInfoLayer_Close();"></div>
        <div class="pop_wrap pop_wrap_01 pop_wrap_700">
            <div class="pop_inner">
                <form id="custInfo_Form" name="custInfo_Form">

                    <input type="hidden" name="CUST_SEQ" id="CUST_SEQ_DB"/>
                    <h3 id="title">거래처 등록
                        <a class="back_btn" href="#" onclick="custInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
                    </h3>

                    <div class="marter_tab">
                        <ul id="tab" class="clearfix">
                            <li class="view"><a href="#" onclick="tabView(1,this);return false;">기본</a></li>
                            <li><a href="#" onclick="tabView(2,this);return false;">거래처정보</a></li>
                            <li><a href="#" onclick="tabView(3,this);return false;">여신/단가</a></li>

                        </ul>
                    </div>

                    <div class="master_list">
                        <div class="tab_box tab_box1">
                            <table class="master_02 ">
                                <colgroup>
                                    <col style="width:130px ">
                                    <col>
                                    <col>
                                    <col>
                                </colgroup>
                                <tbody>
                                <tr>

                                    <th scope="row">거래처코드 <span class="keyf01">*</span></th>
                                    <td colspan="3">
                                        <input type="text" id="BUSINESS_NO" name="BUSINESS_NO" class="text_box01 w_98  firstFocus" placeholder="거래처코드" maxlength="20"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">상호(이름) <span class="keyf01">*</span></th>
                                    <td colspan="3"><input type="text" id="CUST_NAME" name="CUST_NAME" class="all  secondFocus" placeholder="상호(이름)"/></td>
                                </tr>
                                <tr>
                                    <th scope="row">거래처코드구분</th>
                                    <td colspan="3">
                                        <div class="radiobox">
                                            <c:forEach items="${custGubunCode}" var="result" varStatus="i">
                                                <label for="G_GUBUN${i.count}">
                                                    <input type="radio" id="G_GUBUN${i.count}" name="G_GUBUN" value="${result.code}"
                                                           <c:if test="${i.count eq 1}">checked</c:if> /><span>${result.code_nm}</span>
                                                </label>
                                            </c:forEach>

                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">업종별구분</th>
                                    <td colspan="3">

                                        <div class="radiobox">

                                            <label for="GUBUN1">
                                                <input type="radio" id="GUBUN1" name="GUBUN" value="G1" checked/><span>일반</span> <%--원래11--%>
                                            </label>
                                            <label for="GUBUN2">
                                                <input type="radio" id="GUBUN2" name="GUBUN" value="G2"/><span>관세사</span> <%--원래13--%>
                                            </label>
                                        </div>

                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">외화거래처</th>
                                    <td colspan="3">
                                        <div class="sel_wrap">
                                            <select id="EXCHANGE_CODE" name="EXCHANGE_CODE" class="sel_02">
                                                <c:forEach items="${custExchangeCode}" var="result">
                                                    <option value="${result.code}">${result.code_nm}</option>
                                                </c:forEach>
                                            </select>

                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="row">거래유형</th>
                                    <td colspan="3">
                                        <div class="sel_wrap">
                                            <select id="IO_CODE_SL" name="IO_CODE_SL" class="sel_02">
                                                <option value="">사용안함</option>
                                                <c:forEach items="${tradeCode}" var="result">
                                                    <option value="${result.code}">${result.code_nm}</option>
                                                </c:forEach>
                                            </select>

                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="row">거래처그룹</th>
                                    <td colspan="3">
                                        <div class="sel_wrap">
                                            <select id="CUST_GROUP1" name="CUST_GROUP1" class="sel_02">
                                                <c:forEach items="${custGroupCode}" var="result">
                                                    <option value="${result.code}">${result.code_nm}</option>
                                                </c:forEach>
                                            </select>

                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">거래처그룹상세</th>
                                    <td colspan="3">
                                        <div class="sel_wrap">
                                            <select id="CUST_GROUP2" name="CUST_GROUP2" class="sel_02">
                                                <option value="">사용안함</option>
                                                <c:forEach items="${clist}" var="result">
                                                    <option value="${result.code}">${result.code_nm}</option>
                                                </c:forEach>
                                            </select>

                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="row">대표자명</th>
                                    <td colspan="3">
                                        <input type="text" class="text_box01 w_98 " id="BOSS_NAME" name="BOSS_NAME" placeholder="대표자명"/>
                                    </td>

                                </tr>
                                <tr>
                                    <th scope="row">업태</th>
                                    <td colspan="3">
                                        <input type="text" class="all" id="UPTAE" name="UPTAE" placeholder="업태"/>
                                    </td>

                                </tr>
                                <tr>
                                    <th scope="row">종목</th>
                                    <td colspan="3">
                                        <input type="text" class="all" id="JONGMOK" name="JONGMOK" placeholder="종목"/>
                                    </td>

                                </tr>
                                <tr>
                                    <th scope="row">전화</th>
                                    <td colspan="3">
                                        <input type="text" class="text_box01 w_98 " id="TEL" name="TEL" onkeyup="regexPhone(this);" placeholder="전화" maxlength="20"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Fax</th>
                                    <td colspan="3">
                                        <input type="text" class="text_box01 w_98 " id="FAX" name="FAX" onkeyup="regexPhone(this);" placeholder="Fax" maxlength="20"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">검색키워드</th>
                                    <td colspan="3">
                                        <input type="text" class="text_box01 w_98 " id="REMARKS_WIN" name="REMARKS_WIN" placeholder="검색키워드" class="all"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">휴대전화</th>
                                    <td colspan="3">
                                        <input type="text" id="HP_NO" name="HP_NO" class="text_box01 w_98 " onkeyup="regexPhone(this);" placeholder="휴대전화" maxlength="20"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" rowspan="2">주소</th>
                                    <td colspan="3">
                                        <input type="text" id="POST_NO" name="POST_NO" class="add" readonly/>
                                        <button type="button" class="btn_02 btn_s btn_add" onclick="openZipSearch(1)">우편번호검색</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <input type="text" id="ADDR" name="ADDR" placeholder="상세주소" class="all" style="margin-bottom: 5px;" readonly/>
                                        <input type="text" id="ADDR_INFO" name="ADDR_INFO" placeholder="상세주소" class="all" maxlength="50"/>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="row">담당자</th>
                                    <td colspan="3">
                                        <input type="hidden" id="MANAGER_SEQ" name="MANAGER_SEQ" value="0"/>
                                        <input type="text" class="text_box01 w_98" id="MANAGER_NAME" name="MANAGER_NAME" placeholder="담당자" onclick="managerSearch_open();"
                                               readonly/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">홈페이지</th>
                                    <td colspan="3">
                                        <input type="text" class="all" id="URL_PATH" name="URL_PATH" placeholder="홈페이지"/>
                                    </td>
                                </tr>


                                <tr>
                                    <th scope="row">사용여부 <span class="keyf01">*</span></th>
                                    <td colspan="3">
                                        <div class="sel_wrap">
                                            <select id="USE_YN" name="USE_YN" class="sel_02">
                                                <option value="Y">사용</option>
                                                <option value="N">미사용</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="tab_box tab_box2">
                            <table class="master_02 ">
                                <colgroup>
                                    <col style="width:130px ">
                                    <col>
                                    <col>
                                    <col>
                                </colgroup>
                                <tbody>
                                <tr>
                                    <th scope="row">세무신고거래처</th>
                                    <td colspan="3">
                                        <div class="radiobox">
                                            <label for="G_BUSINESS_TYPE1">
                                                <input type="radio" id="G_BUSINESS_TYPE1" name="G_BUSINESS_TYPE" value="1" checked="checked"/><span>거래처코드동일</span>
                                            </label>
                                            <label for="G_BUSINESS_TYPE2">
                                                <input type="radio" id="G_BUSINESS_TYPE2" name="G_BUSINESS_TYPE" value="2"/><span>검색입력</span>
                                            </label>
                                            <label for="G_BUSINESS_TYPE3">
                                                <input type="radio" id="G_BUSINESS_TYPE3" name="G_BUSINESS_TYPE" value="3"/><span>직접입력</span>
                                            </label>
                                        </div>
                                        <div id="g_business_input" class="g_business_view g_business_view1 g_business_none">
                                            <input type="text" id="G_BUSINESS_CD" name="G_BUSINESS_CD" class="all" placeholder="세무신고거래처"/>
                                        </div>
                                    </td>
                                </tr>

                                <tr>
                                    <th scope="row">종사업장번호</th>
                                    <td colspan="3">
                                        <input type="text" id="TAX_REG_ID" name="TAX_REG_ID" class="text_box01 w_98 " value="0" placeholder="종사업장번호"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">Email</th>
                                    <td colspan="3">
                                        <input type="text" id="EMAIL" name="EMAIL" class="all " placeholder="Email"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row" rowspan="2">주소2</th>
                                    <td colspan="3">
                                        <input type="text" id="DM_POST" name="DM_POST" class="add" placeholder="주소2" readonly/>
                                        <button type="button" onclick="openZipSearch(2)" class="btn_02 btn_s btn_add">우편번호검색</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="3">
                                        <input type="text" id="DM_ADDR" name="DM_ADDR" class="all" style="margin-bottom: 5px;" readonly>
                                        <input type="text" id="DM_ADDR_INFO" name="DM_ADDR_INFO" class="all" maxlength="50">
                                    </td>

                                </tr>

                                <tr>
                                    <th scope="row">적요</th>
                                    <td colspan="3">
                                        <textarea id="REMARKS" name="REMARKS" class="text_box01 w_98" placeholder="적요"></textarea></td>
                                </tr>

                                <tr>
                                    <th scope="row">출하대상거래처</th>
                                    <td colspan="3">
                                        <div class="radiobox">
                                            <label>
                                                <input type="radio" id="OUTORDER_Y" name="OUTORDER_YN" value="Y"/><span>사용</span>
                                            </label>
                                            <label>
                                                <input type="radio" id="OUTORDER_N" name="OUTORDER_YN" value="N" checked="checked"/><span>사용안함</span>
                                            </label>
                                        </div>
                                    </td>
                                </tr>

                                </tbody>
                            </table>

                        </div>

                        <div class="tab_box tab_box3">
                            <table class="master_02 ">
                                <colgroup>
                                    <col style="width:130px ">
                                    <col>
                                    <col>
                                    <col>
                                </colgroup>
                                <tbody>

                                <tr>
                                    <th scope="row">수금/지급예정일</th>
                                    <td colspan="3">
                                        <input type="text" id="PAY_DATE" name="PAY_DATE" placeholder="수금/지급예정일" maxlength="30"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">채권번호관리</th>
                                    <td colspan="3">
                                        <div class="sel_wrap">
                                            <select id="MANAGE_BOND_NO" name="MANAGE_BOND_NO" class="sel_02">
                                                <option value="B">기본설정</option>
                                                <option value="M">필수입력</option>
                                                <option value="Y">선택입력</option>
                                                <option value="N">사용안함</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">채무번호관리</th>
                                    <td colspan="3">
                                        <div class="sel_wrap">
                                            <select id="MANAGE_DEBIT_NO" name="MANAGE_DEBIT_NO" class="sel_02">
                                                <option value="B">기본설정</option>
                                                <option value="M">필수입력</option>
                                                <option value="Y">선택입력</option>
                                                <option value="N">사용안함</option>
                                            </select>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">여신한도</th>
                                    <td colspan="3">
                                        <input type="text" id="CUST_LIMIT" name="CUST_LIMIT" class="text_box01  w_98" style="text-align:right;" value="0" onkeyup="getNumber(this);"
                                               placeholder="여신한도" maxlength="10"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">출고조정률</th>
                                    <td colspan="3">
                                        <input type="text" id="O_RATE" name="O_RATE" class="small tc" onkeyup="regexPercent(this);" value="0" maxlength="4" placeholder="출고조정률"/>%
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">입고조정률</th>
                                    <td colspan="3">
                                        <input type="text" id="I_RATE" name="I_RATE" class="small tc" value="0" onkeyup="regexPercent(this);" maxlength="4" placeholder="입고조정률"/>%
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">영업단가그룹</th>
                                    <td colspan="3">
                                        <input type="text" id="PRICE_GROUP" name="PRICE_GROUP" class="text_box01  w_98" style="text-align:right;" placeholder="영업단가그룹"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">구매단가그룹</th>
                                    <td colspan="3">
                                        <input type="text" id="PRICE_GROUP2" name="PRICE_GROUP2" class="text_box01  w_98" style="text-align:right;" placeholder="구매단가그룹"/>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">여신기간</th>
                                    <td colspan="3">
                                        <input type="text" id="CUST_LIMIT_TERM" name="CUST_LIMIT_TERM" class="small tc" value="0" placeholder="여신기간"/>일 전
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>

                    </div>

                    <div class="pop_btn clearfix">
                        <a href="#" class="p_btn_01" onclick="custInfoLayer_Close();">닫기</a>
                        <a id="custChoice" href="#" class="p_btn_02" onclick="custInfoLayer_Update();">수정</a>
                    </div>

                </form>
            </div>
            <div class="group_close">
                <a href="#" class="getCustView_close" onclick="custInfoLayer_Close();"><span>닫기</span></a>
            </div>
            <div id="popup" class="layer_pop">
                <div class="handle_wrap">
                    <div class="handle"><span>거래처 리스트</span></div>
                    <div class="drag_fix"><a href="#" onclick="closeLayer(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
                </div>
                <iframe src="" id="popupframe"></iframe>
            </div>

            <div id="manager_popup" class="layer_pop">
                <div class="handle_wrap">
                    <div class="handle"><span>담당자 리스트</span></div>
                    <div class="drag_fix"><a href="#" onclick="managerSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
                </div>
                <iframe src="" id="manager_popupframe"></iframe>
            </div>
        </div>
    </div>
</div>

<div class="master_pop master_pop01" id="CreateSupplyInfoLayer">
    <div class="master_body">
        <div class="pop_bg" onclick="CreateSupplyInfoLayer_Close();"></div>
        <div class="pop_wrap pop_wrap_01" style>
            <div class="pop_inner">
                <form id="SupplyInfo_Form" name="SupplyInfo_Form">
                    <input type="hidden" name="SCMIDCount" id="SCMIDCount" value="1"/>
                    <input type="hidden" name="cust_seq" id="cust_seq"/>

                    <h3>계정관리<a class="back_btn" href="#" onclick="CreateSupplyInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
                                <th scope="row">사업자 번호</th>
                                <td><input type="text" id="business_no2" name="business_no" class="all"/></td>
                                <th scope="row">대표자</th>
                                <td><input type="text" id="boss_name2" name="boss_name" class="all"/></td>
                            </tr>
                            <tr>
                                <th scope="row">상호명</th>
                                <td colspan="3"><input type="text" id="cust_name2" name="cust_name" class="all"/></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="master_list master_listT">
                        <div class="add_btn">
                            <button id="button_1" type="button" class="btn_02" onclick="CreateSCMAccount();">계정추가</button>
                        </div>
                        <div class="scroll">
                            <table class="master_01 master_05 master_vm" id="product">
                                <colgroup>
                                    <col style="width: 55px;"/>
                                    <col style="width: 110px;"/>
                                    <col style="width: 110px;"/>
                                    <col style="width: 100px;"/>
                                    <col style="width: 110px;"/>
                                    <col style="width:125px;"/>
                                    <col style="width: 140px;"/>
                                    <col style="width: 88px;"/>
                                    <col style="width: 88px;"/>
                                    <col style="width: 130px;"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>no</th>
                                    <th>아이디</th>
                                    <th>담당자</th>
                                    <th>직급</th>
                                    <th>부서</th>
                                    <th>연락처</th>
                                    <th>이메일</th>
                                    <th>사용유무</th>
                                    <th>삭제유무</th>
                                    <th>관리</th>
                                </tr>
                                </thead>
                                <tbody id="searchResult">

                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="pop_btn clearfix">
                        <a href="#" class="p_btn_01" onclick="CreateSupplyInfoLayer_Close();">닫기</a>
                        <a id="actionButton" href="#" onclick="GoActionButton();" class="p_btn_02">등록</a>
                    </div>

                </form>
            </div>
            <div class="group_close">
                <a href="#" class="getOrderView_close" onclick="CreateSupplyInfoLayer_Close();"><span>닫기</span></a>
            </div>


            <div class="layer_pop">
                <div class="handle_wrap">
                    <div class="handle"><span>품목 리스트</span></div>
                    <div class="drag_fix"><a href="#" onclick="productSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
                </div>
                <iframe src=""></iframe>
            </div>


        </div>
    </div>
</div>
<div class="master_pop master_pop01" id="CreateBuyerInfoLayer">
    <div class="master_body">
        <div class="pop_bg" onclick="CreateBuyerInfoLayer_Close();"></div>
        <div class="pop_wrap pop_wrap_01" style>
            <div class="pop_inner">
                <form id="BuyerInfo_Form" name="BuyerInfo_Form">
                    <input type="hidden" name="BuyerIDCount" id="BuyerIDCount" value="1"/>
                    <input type="hidden" name="b_cust_seq" id="b_cust_seq"/>
                    <input type="hidden" name="b_business_no" id="b_business_no" class="all"/>
                    <input type="hidden" name="b_boss_name" id="b_boss_name" class="all"/>
                    <input type="hidden" name="b_cust_name" id="b_cust_name" class="all"/>
                    <h3>계정관리<a class="back_btn" href="#" onclick="CreateBuyerInfoLayer_Close();"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

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
                                <th scope="row">사업자 번호</th>
                                <td><span id="b_business_no2"/></td>
                                <th scope="row">대표자</th>
                                <td><span id="b_boss_name2"/></td>
                            </tr>
                            <tr>
                                <th scope="row">상호명</th>
                                <td colspan="3"><span id="b_cust_name2"/></td>
                            </tr>
                            </tbody>
                        </table>
                    </div>

                    <div class="master_list master_listT">
                        <div class="add_btn">
                            <button type="button" class="btn_02" onclick="CreateBuyerAccount();">계정추가</button>
                        </div>
                        <div class="scroll">
                            <table class="master_01 master_05 master_vm">
                                <colgroup>
                                    <col style="width: 55px;"/>
                                    <col style="width: 110px;"/>
                                    <col style="width: 110px;"/>
                                    <col style="width: 100px;"/>
                                    <col style="width: 110px;"/>
                                    <col style="width:125px;"/>
                                    <col style="width: 140px;"/>
                                    <col style="width: 90px;"/>
                                    <col style="width: 88px;"/>
                                    <col style="width: 88px;"/>
                                    <col style="width: 130px;"/>
                                </colgroup>
                                <thead>
                                <tr>
                                    <th>no</th>
                                    <th>아이디</th>
                                    <th>담당자</th>
                                    <th>직급</th>
                                    <th>부서</th>
                                    <th>연락처</th>
                                    <th>이메일</th>
                                    <th>거래처 등급</th>
                                    <th>사용유무</th>
                                    <th>삭제유무</th>
                                    <th>관리</th>
                                </tr>
                                </thead>
                                <tbody id="b_searchResult">

                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="pop_btn clearfix">
                        <a href="#" class="p_btn_01" onclick="CreateBuyerInfoLayer_Close();">닫기</a>
                        <a id="b_actionButton" href="#" onclick="GoActionBuyerButton();" class="p_btn_02">등록</a>
                    </div>

                </form>
            </div>
            <div class="group_close">
                <a href="#" class="getOrderView_close" onclick="CreateBuyerInfoLayer_Close();"><span>닫기</span></a>
            </div>


            <div id="product_popup" class="layer_pop">
                <div class="handle_wrap">
                    <div class="handle"><span>품목 리스트</span></div>
                    <div class="drag_fix"><a href="#" onclick="productSearch_close(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
                </div>
                <iframe src="" id="product_popupframe"></iframe>
            </div>


        </div>
    </div>
</div>

<form id="supplyForm">
    <input type="hidden" name="seq" id="seq"/>
    <input type="hidden" name="no" id="no"/>
</form>

<form id="buyerForm">
    <input type="hidden" name="b_seq" id="b_seq"/>
    <input type="hidden" name="b_no" id="b_no" />
</form>
<script>

  $(document).on("change", "input[name='G_BUSINESS_TYPE']", function () {
    var value = $("input[name='G_BUSINESS_TYPE']:checked").val();

    if (value == 1) {
      var business_no = $('#BUSINESS_NO').val();
      $('#g_business_input').addClass('g_business_none');
      $('#G_BUSINESS_CD').val(business_no);
      $('#G_BUSINESS_CD').attr("onclick", "");
    } else {
      value == 2 ? $('#G_BUSINESS_CD').attr("onclick", "openLayer();") : $('#G_BUSINESS_CD').attr("onclick", "");
      value == 2 ? $('#G_BUSINESS_CD').attr("readonly", true) : $('#G_BUSINESS_CD').attr("readonly", false);
      $('#g_business_input').removeClass('g_business_none');
      $('#G_BUSINESS_CD').val("")
    }
  })

  function choiceCust(cust_seq, no, cust_name) {
    $('#G_BUSINESS_CD').val(no);
  }

</script>
