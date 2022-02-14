<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="/WEB-INF/tlds/dh-taglibs.tld" prefix="dh" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<script type="text/javascript" src="/se2/js/HuskyEZCreator.js"></script>
<script type="text/javascript">

  $(document).ready(function () {
    smartEditorOn();

    var fileForm = $('#file1');
    fileForm.on('change', function () {
      if (window.FileReader) {
        var filename = $(this)[0].files[0].name;
        $(this).siblings('.fileName1').val(filename);
        for (var i = 0; i < $(this)[0].files.length; i++) {
          //console.log($(this)[0].files[i]);
        }
        selectFile($(this)[0].files);
      } else {
        var filename = $(this).val().split('/').pop().split('\\').pop();
        $(this).siblings('.fileName1').val(filename);
        selectFile($(this)[0].files);
      }
    })

  })
  // 파일 리스트 번호
  var fileIndex = 0;
  // 등록할 전체 파일 사이즈
  var totalFileSize = 0;
  // 파일 리스트
  var fileList = new Array();
  // 파일 사이즈 리스트
  var fileSizeList = new Array();
  // 등록 가능한 파일 사이즈 MB
  var uploadSize = 20;
  // 등록 가능한 총 파일 사이즈 MB
  var maxUploadSize = 600;

  $('#file1').change(function (e) {
    // console.log($(this)[0].files);
    selectFile($(this)[0].files);
    for (var i = 0; i < $(this)[0].files.length; i++) {
      // console.log($(this)[0].files[i]);
    }

  })

  function smartEditorOn() {
    oEditors = [];
    nhn.husky.EZCreator.createInIFrame({
      oAppRef: oEditors,
      elPlaceHolder: "contents",
      sSkinURI: "/se2/SmartEditor2Skin.html",
      fCreator: "createSEditor2",
      htParams: {
        fOnBeforeUnload: function () {
        }
      },
      fOnAppLoad: function () {
        var width = "100%"; // 원하는 너비
        var height = 570; // 원하는 너비
        $("#contents").css('width', width);
        $("#contents").css('height', height);
        $("#huskey_editor_jinto_set_id").css('width', width);
        $("#huskey_editor_jinto_set_id").css('height', height);

      }

    });

  };

  function tabView(num, el) {
    $('.marter_tab li').removeClass('view');
    $(el).parents('li').addClass('view');
    $('.tab_box').css('display', 'none');
    $('.tab_box' + num).css('display', 'block');

    if (num == 6) {
      $("#tab_box").attr("class", "pop_wrap pop_wrap_01 pop_wrap_850");
      // $("#tab_box").removeClass("pop_wrap_850");
    } else {
      // $("#tab_box").addClass("pop_wrap_700");
      $("#tab_box").attr("class", "pop_wrap pop_wrap_01 pop_wrap_700");
    }
  }

  function checkvaild() {
    var value = null;
    var PROD_CD = $('#PROD_CD').val();
    var PROD_DES = $('#PROD_DES').val();

    if (isEmpty(PROD_CD)) {
      value = "품목코드";
      console.log(value);
    } else if (isEmpty(PROD_DES)) {
      value = "품목이름";
    }
    return value;
  }

  //관리자 신규등록 버튼 클릭
  function newRegister() {
    //tabView(1,this) return false;
    productInfoLayer_Open(0, "regist");
  }

  function productInfoLayer_Close() {
    $('#productInfoLayer').removeClass('view');
    $('html,body').css('overflow', '');
    $('.info_edit').removeClass('view');
    $("#tab_box").attr("class", "pop_wrap pop_wrap_01 pop_wrap_700");
  }

  function viewProductDetail(PDT_CD, type) {
    productInfoLayer_Open(PDT_CD, type);
  }

  //관리자 수정을 위해 row 클릭시
  function productInfoLayer_Open(PDT_CD, type) {

    if (!sessionCheck()) {
      location.reload();
    }

    var text = "";
    $('#category2').css("display", "none");
    $('#category3').css("display", "none");

    $('.tab_box1').css("display", "");
    $('.tab_box2').css("display", "none");
    $('.tab_box3').css("display", "none");
    $('.tab_box4').css("display", "none");
    $('.tab_box5').css("display", "none");
    $('.tab_box6').css("display", "none");
    $('#tab li').removeClass('view');
    $('#tab li:first-child').addClass('view');

    if (type == "view") { //상세보기
      $('#mode').val("edit");
      $.ajax({
        type: "get",
        url: '/product/view',
        contentType: 'application/json',
        async: false,
        data: "PDT_CD=" + PDT_CD,
        success: function (data) {
          var array = data.storeData;
          console.log(array);
          var PDT_CD = "";
          var PDT_CODE = "";
          var PDT_NAME = "";
          var PDT_STANDARD = "";
          var UNIT = "";
          var PDT_BIGO = "";
          var PROD_TYPE = "";
          var CSORD_C0001 = "";
          var CSORD_TEXT = "";
          var CSORD_C0003 = "";
          var ITEM_TYPE = "";
          var SERIAL_TYPE = "";
          var PROD_SELL_TYPE = "";
          var PROD_WHMOVE_TYPE = "";
          var QC_BUY_TYPE = "";
          var QC_YN = "";
          var SET_FLAG = "";
          var BAL_FLAG = "";
          var WH_CD = "";
          var IN_PRICE = "";
          var IN_PRICE_VAT_YN = "";
          var OUT_PRICE = "";
          var OUT_PRICE_VAT_YN = "";
          var REMARKS_WIN = "";
          var BAR_CODE = "";
          var VAT_YN = "";
          var TAX = "";
          var VAT_RATE_BY_BASE_YN = "";
          var VAT_RATE_BY = "";
          var CS_FLAG = "";
          var INSPECT_TYPE_CD = "";
          var INSPECT_STATUS = "";
          var SAMPLE_PERCENT = "";
          var SAFE_A0001 = "";
          var SAFE_A0002 = "";
          var SAFE_A0003 = "";
          var SAFE_A0004 = "";
          var SAFE_A0005 = "";
          var SAFE_A0006 = "";
          var SAFE_A0007 = "";

          var CUST_SEQ = "";
          var CUST_NAME = "";
          var EXCH_RATE = "";
          var DENO_RATE = "";
          var OUT_PRICE1 = "";
          var OUT_PRICE1_VAT_YN = "";
          var OUT_PRICE2 = "";
          var OUT_PRICE2_VAT_YN = "";
          var OUT_PRICE3 = "";
          var OUT_PRICE3_VAT_YN = "";
          var LABOR_WEIGHT = "";
          var EXPENSES_WEIGHT = "";
          var MATERIAL_COST = "";
          var EXPENSE_COST = "";
          var LABOR_COST = "";
          var OUT_COST = "";
          var CLASS_CD2 = "";
          var USE_YN = "";
          var CAT_CD = "";
          var CAT_CD_SPLIT = "";
          var cate1 = "";
          var cate2 = "";
          var cate3 = "";
          var PDT_STOCK = "";
          var SAFE_STOCK = "";
          var IN_TERM = "";
          var MIN_QTY = "";

          if (array.PDT_CD != 'undefined') {
            CAT_CD = array.CAT_CD;
            CAT_CD_SPLIT = CAT_CD.split(",")
            if (CAT_CD_SPLIT.length == 1) {
              cate1 = CAT_CD_SPLIT[0];
              choiceCategory(cate1, 1);
            } else if (CAT_CD_SPLIT.length == 2) {
              cate1 = CAT_CD_SPLIT[0];
              cate2 = CAT_CD_SPLIT[1];
              choiceCategory(cate1, 1);
              choiceCategory(cate2, 2);
            } else if (CAT_CD_SPLIT.length == 3) {
              cate1 = CAT_CD_SPLIT[0];
              cate2 = CAT_CD_SPLIT[1];
              cate3 = CAT_CD_SPLIT[2];
              choiceCategory(cate1, 1);
              choiceCategory(cate2, 2);
              choiceCategory(cate3, 3);
            }

            PDT_CD = array.PDT_CD;
            PDT_CODE = array.PDT_CODE;
            PDT_NAME = array.PDT_NAME;
            PDT_STANDARD = array.PDT_STANDARD;
            UNIT = array.UNIT;
            PDT_BIGO = array.PDT_BIGO;
            PROD_TYPE = array.PROD_TYPE;
            CSORD_C0001 = array.CSORD_C0001;
            CSORD_TEXT = array.CSORD_TEXT;
            CSORD_C0003 = array.CSORD_C0003;
            ITEM_TYPE = array.ITEM_TYPE;
            SERIAL_TYPE = array.SERIAL_TYPE;
            PROD_SELL_TYPE = array.PROD_SELL_TYPE;
            PROD_WHMOVE_TYPE = array.PROD_WHMOVE_TYPE;
            QC_BUY_TYPE = array.QC_BUY_TYPE;
            QC_YN = array.QC_YN;
            SET_FLAG = array.SET_FLAG;
            BAL_FLAG = array.BAL_FLAG;
            WH_CD = array.WH_CD;
            IN_PRICE = array.IN_PRICE;
            IN_PRICE_VAT_YN = array.IN_PRICE_VAT_YN;
            OUT_PRICE = array.OUT_PRICE;
            OUT_PRICE_VAT_YN = array.OUT_PRICE_VAT_YN;
            REMARKS_WIN = array.REMARKS_WIN;
            BAR_CODE = array.BAR_CODE;
            VAT_YN = array.VAT_YN;
            TAX = array.TAX;
            VAT_RATE_BY_BASE_YN = array.VAT_RATE_BY_BASE_YN;
            VAT_RATE_BY = array.VAT_RATE_BY;
            CS_FLAG = array.CS_FLAG;

            INSPECT_STATUS = array.INSPECT_STATUS;
            SAMPLE_PERCENT = array.SAMPLE_PERCENT;
            SAFE_A0001 = array.SAFE_A0001;
            SAFE_A0002 = array.SAFE_A0002;
            SAFE_A0003 = array.SAFE_A0003;
            SAFE_A0004 = array.SAFE_A0004;
            SAFE_A0005 = array.SAFE_A0005;
            SAFE_A0006 = array.SAFE_A0006;
            SAFE_A0007 = array.SAFE_A0007;
            PDT_STOCK = array.PDT_STOCK;
            SAFE_STOCK = array.SAFE_STOCK;

            IN_TERM = array.IN_TERM;
            MIN_QTY = array.MIN_QTY;
            CUST_SEQ = array.CUST_SEQ;
            CUST_NAME = array.CUST_NAME;
            EXCH_RATE = array.EXCH_RATE;
            DENO_RATE = array.DENO_RATE;
            OUT_PRICE1 = array.OUT_PRICE1;
            OUT_PRICE1_VAT_YN = array.OUT_PRICE1_VAT_YN;
            OUT_PRICE2 = array.OUT_PRICE2;
            OUT_PRICE2_VAT_YN = array.OUT_PRICE2_VAT_YN;
            OUT_PRICE3 = array.OUT_PRICE3;
            OUT_PRICE3_VAT_YN = array.OUT_PRICE3_VAT_YN;
            LABOR_WEIGHT = array.LABOR_WEIGHT;
            EXPENSES_WEIGHT = array.EXPENSES_WEIGHT;
            MATERIAL_COST = array.MATERIAL_COST;
            EXPENSE_COST = array.EXPENSE_COST;
            LABOR_COST = array.LABOR_COST;
            OUT_COST = array.OUT_COST;
            CLASS_CD2 = array.CLASS_CD2;

            USE_YN = array.USE_YN;

            $('#PDT_CD').val(PDT_CD);
            $('#PDT_CODE').val(PDT_CODE);
            $('#PDT_NAME').val(PDT_NAME);
            $('#PDT_STANDARD').val(PDT_STANDARD);
            $('#UNIT').val(UNIT);
            $('#PDT_BIGO').val(PDT_BIGO);
            $('#USE_YN').val(USE_YN);
            $('#CLASS_CD2').val(CLASS_CD2);
            $('#CSORD_C0001').val(CSORD_C0001);
            if (CSORD_C0001 == 'N') {
              $('#CSORD_TEXT').css("display", "none");
            } else {
              $('#CSORD_TEXT').css("display", "");
            }
            $('#CSORD_TEXT').val(CSORD_TEXT);
            $('#CSORD_C0003').val(CSORD_C0003);
            $('#ITEM_TYPE').val(ITEM_TYPE);
            $('#SERIAL_TYPE').val(SERIAL_TYPE);
            $('#PROD_SELL_TYPE').val(PROD_SELL_TYPE);
            $('#PROD_WHMOVE_TYPE').val(PROD_WHMOVE_TYPE);
            $('#QC_BUY_TYPE').val(QC_BUY_TYPE);
            $('#QC_YN').val(QC_YN);
            $('#WH_CD').val(WH_CD);

            $("input:radio[name='PROD_TYPE']:input[value='" + PROD_TYPE + "']").prop("checked", true);
            $("input:radio[name='SET_FLAG']:input[value='" + SET_FLAG + "']").prop("checked", true);
            $("input:radio[name='BAL_FLAG']:input[value='" + BAL_FLAG + "']").prop("checked", true);
            $("input:radio[name='VAT_YN']:input[value='" + VAT_YN + "']").prop("checked", true);
            $("input:radio[name='VAT_RATE_BY_BASE_YN']:input[value='" + VAT_RATE_BY_BASE_YN + "']").prop("checked", true);
            $("input:radio[name='INSPECT_STATUS']:input[value='" + INSPECT_STATUS + "']").prop("checked", true);
            $("input:radio[name='ITEM_TYPE']:input[value='" + ITEM_TYPE + "']").prop("checked", true);
            $("input:radio[name='SERIAL_TYPE']:input[value='" + SERIAL_TYPE + "']").prop("checked", true);
            $("input:radio[name='PROD_SELL_TYPE']:input[value='" + PROD_SELL_TYPE + "']").prop("checked", true);
            $("input:radio[name='PROD_WHMOVE_TYPE']:input[value='" + PROD_WHMOVE_TYPE + "']").prop("checked", true);
            $("input:radio[name='QC_BUY_TYPE']:input[value='" + QC_BUY_TYPE + "']").prop("checked", true);
            $("input:radio[name='QC_YN']:input[value='" + QC_YN + "']").prop("checked", true);

            $("input:radio[name='SAFE_A0001']:input[value='" + SAFE_A0001 + "']").prop("checked", true);
            $("input:radio[name='SAFE_A0002']:input[value='" + SAFE_A0002 + "']").prop("checked", true);
            $("input:radio[name='SAFE_A0003']:input[value='" + SAFE_A0003 + "']").prop("checked", true);
            $("input:radio[name='SAFE_A0004']:input[value='" + SAFE_A0004 + "']").prop("checked", true);
            $("input:radio[name='SAFE_A0005']:input[value='" + SAFE_A0005 + "']").prop("checked", true);
            $("input:radio[name='SAFE_A0006']:input[value='" + SAFE_A0006 + "']").prop("checked", true);
            $("input:radio[name='SAFE_A0007']:input[value='" + SAFE_A0007 + "']").prop("checked", true);

            if (VAT_RATE_BY_BASE_YN == 'Y') {
              $('.g_business_view2').removeClass('g_business_none');
            } else {
              $('.g_business_view2').addClass('g_business_none');
            }
            if (VAT_YN == 'Y') {
              $('.g_business_view3').removeClass('g_business_none');
            } else {
              $('.g_business_view3').addClass('g_business_none');
            }
            if (INSPECT_STATUS == 'S') {
              $('.g_business_view4').removeClass('g_business_none');
            } else {
              $('.g_business_view4').addClass('g_business_none');
            }

            if (IN_PRICE_VAT_YN == 'Y') {
              $("input:checkbox[name='IN_PRICE_VAT_YN_CHK']").attr("checked", true);
            }
            if (OUT_PRICE_VAT_YN == 'Y') {
              $("input:checkbox[name='OUT_PRICE_VAT_YN_CHK']").attr("checked", true);
            }
            if (OUT_PRICE1_VAT_YN == 'Y') {
              $("input:checkbox[name='OUT_PRICE1_VAT_YN_CHK']").attr("checked", true);
            }
            if (OUT_PRICE2_VAT_YN == 'Y') {
              $("input:checkbox[name='OUT_PRICE2_VAT_YN_CHK']").attr("checked", true);
            }
            if (OUT_PRICE3_VAT_YN == 'Y') {
              $("input:checkbox[name='OUT_PRICE3_VAT_YN_CHK']").attr("checked", true);
            }

            if (CS_FLAG == "1") {
              $("input:checkbox[name='CS_FLAG_CHK']").attr("checked", true);
            }

            $('#REMARKS_WIN').val(REMARKS_WIN);
            $('#BAR_CODE').val(BAR_CODE);

            $('#TAX').val(TAX);

            $('#VAT_RATE_BY').val(VAT_RATE_BY);
            $('#CS_FLAG').val(CS_FLAG);
            $('#SAMPLE_PERCENT').val(SAMPLE_PERCENT);

            $('#PDT_STOCK').val(PDT_STOCK);
            $('#SAFE_STOCK').val(SAFE_STOCK);
            $('#IN_TERM').val(IN_TERM);
            $('#MIN_QTY').val(MIN_QTY);
            $('#CUST_NAME').val(CUST_NAME);
            $('#CUST_SEQ').val(CUST_SEQ);
            $('#EXCH_RATE').val(EXCH_RATE);
            $('#DENO_RATE').val(DENO_RATE);

            $('#IN_PRICE').val(IN_PRICE);
            $('#OUT_PRICE').val(OUT_PRICE);
            $('#OUT_PRICE1').val(OUT_PRICE1);
            $('#OUT_PRICE2').val(OUT_PRICE2);
            $('#OUT_PRICE3').val(OUT_PRICE3);

            $('#LABOR_WEIGHT').val(LABOR_WEIGHT);
            $('#EXPENSES_WEIGHT').val(EXPENSES_WEIGHT);
            $('#MATERIAL_COST').val(MATERIAL_COST);
            $('#EXPENSE_COST').val(EXPENSE_COST);
            $('#LABOR_COST').val(LABOR_COST);
            $('#OUT_COST').val(OUT_COST);

          }
          $('#actionButton').text('수정');
          $('#title').text('품목수정');
        }
      });
    } else { //신규작성일때
      choiceCategory('SC10000000', 1);
      $('#mode').val("regist")
      $('#actionButton').text('등록');
      $('#productInfo_Form').resetForm();
      $('#title').text('품목등록');

      $('#CSORD_TEXT').css("display", "");

      $("input:radio[name='PROD_TYPE1']:input[value='PG001']").prop("checked", true);
      $("input:radio[name='SET_FLAG']:input[value='0']").prop("checked", true);
      $("input:radio[name='BAL_FLAG']:input[value='0']").prop("checked", true);
      $("input:radio[name='VAT_YN']:input[value='N']").prop("checked", true);
      $("input:radio[name='VAT_RATE_BY_BASE_YN']:input[value='N']").prop("checked", true);
      $("input:radio[name='INSPECT_STATUS']:input[value='L']").prop("checked", true);

      $("input:radio[name='ITEM_TYPE']:input[value='B']").prop("checked", true);
      $("input:radio[name='SERIAL_TYPE']:input[value='B']").prop("checked", true);
      $("input:radio[name='PROD_SELL_TYPE']:input[value='B']").prop("checked", true);
      $("input:radio[name='PROD_WHMOVE_TYPE']:input[value='B']").prop("checked", true);
      $("input:radio[name='QC_BUY_TYPE']:input[value='B']").prop("checked", true);
      $("input:radio[name='QC_YN']:input[value='B']").prop("checked", true);

      $("input:radio[name='SAFE_A0001']:input[value='0']").prop("checked", true);
      $("input:radio[name='SAFE_A0002']:input[value='0']").prop("checked", true);
      $("input:radio[name='SAFE_A0003']:input[value='0']").prop("checked", true);
      $("input:radio[name='SAFE_A0004']:input[value='0']").prop("checked", true);
      $("input:radio[name='SAFE_A0005']:input[value='0']").prop("checked", true);
      $("input:radio[name='SAFE_A0006']:input[value='0']").prop("checked", true);
      $("input:radio[name='SAFE_A0007']:input[value='0']").prop("checked", true);

      $('.g_business_view2').addClass('g_business_none');
      $('.g_business_view3').addClass('g_business_none');
      $('.g_business_view4').addClass('g_business_none');

    }

    $('#productInfoLayer').addClass('view');
    $('html,body').css('overflow', 'hidden');
    $('.leftNav').removeClass('view');

  }

  function choiceCategory(cat_cd, depth) {

    if (cat_cd == 'cate2') {
      $('#category3').css("display", "none");
    } else {
      $.ajax({
        type: "get",
        url: '/product/viewDepth',
        contentType: 'application/json',
        async: false,
        data: "cat_cd=" + cat_cd,
        success: function (data) {
          //console.log(data);
          var list = data.storeData;
          var text = "";
          var target = "";
          $('#cate' + depth).val(cat_cd);
          if (list.length > 0) {
            target = list[0].cat_depth;
            text += '<option value="cate' + target + '" selected >선택</option>';
            for (var i in list) {
              text += '<option value="' + list[i].cat_cd + '">' + list[i].cat_name + '</option>';
            }
            $('#cate' + target).html(text);

            if (target == 1) {
              $('#category2').css("display", "");
              $('#category3').css("display", "none");
            } else if (target == 2) {
              $('#category2').css("display", "");
              $('#category3').css("display", "none");
            } else if (target == 3) {
              $('#category2').css("display", "");
              $('#category3').css("display", "");
            }
          } else {

            if (depth == 1) {
              $('#category2').css("display", "none");
              $('#category3').css("display", "none");
            } else if (depth == 2) {
              $('#category3').css("display", "none");
            }

          }

        }

      });
    }

  }

  function productInfoLayer_Update() {
    if (isEmpty($('#PDT_CODE').val())) {
      alert("제품코드를 입력해주세요.");
      return;
    }

    if (isEmpty($('#PDT_NAME').val())) {
      alert("제품명을 입력해주세요.");
      return;
    }

    if ($("input[name='IN_PRICE_VAT_YN_CHK']").is(":checked")) {
      $("input[name='IN_PRICE_VAT_YN']").val("Y");
    } else {
      $("input[name='IN_PRICE_VAT_YN']").val("N");
    }

    if ($("input[name='OUT_PRICE_VAT_YN_CHK']").is(":checked")) {
      $("input[name='OUT_PRICE_VAT_YN']").val("Y");
    } else {
      $("input[name='OUT_PRICE_VAT_YN']").val("N");
    }

    if ($("input[name='OUT_PRICE1_VAT_YN_CHK']").is(":checked")) {
      $("input[name='OUT_PRICE1_VAT_YN']").val("Y");
    } else {
      $("input[name='OUT_PRICE1_VAT_YN']").val("N");
    }
    if ($("input[name='OUT_PRICE2_VAT_YN_CHK']").is(":checked")) {
      $("input[name='OUT_PRICE2_VAT_YN']").val("Y");
    } else {
      $("input[name='OUT_PRICE2_VAT_YN']").val("N");
    }
    if ($("input[name='OUT_PRICE3_VAT_YN_CHK']").is(":checked")) {
      $("input[name='OUT_PRICE3_VAT_YN']").val("Y");
    } else {
      $("input[name='OUT_PRICE3_VAT_YN']").val("N");
    }

    if ($("input[name='CS_FLAG_CHK']").is(":checked")) {
      $("input[name='CS_FLAG']").val("1");
    } else {
      $("input[name='CS_FLAG']").val("0");
    }



    var param = $("#productInfo_Form").serializeObject();
    $.ajax({
      type: "post",
      url: "/product/manageProduct",
      contentType: 'application/json',
      async: false,
      data: JSON.stringify(param)
    }).done(function (response) {
      if (response.success) {
        alert("저장되었습니다.");
        productInfoLayer_Close();
        location.reload();
      } else {
        alert("저장시 오류가 발생하였습니다." + response.message);
        $("#productInfo_Form input[name='" + response.code + "']").focus();
      }
    });
  }

  function setSearchDivision() {
    var DIVISION_SEQ = "";
    $.each($("select[id^='select_group_code1']"), function (idx, item) {
      DIVISION_SEQ += $(item).val();

    })
    console.log(DIVISION_SEQ);
    $("input[name=DIVISION_SEQ]").val(DIVISION_SEQ);
  }

  function setSearchDivision2() {
    var DIVISION_SEQ = "";
    $.each($("select[id^='select_group_code2']"), function (idx, item) {
      DIVISION_SEQ += $(item).val();

    })
    console.log(DIVISION_SEQ);
    $("input[name=DIVISION_SEQ]").val(DIVISION_SEQ);
  }

  function goSearch() {
    $('#search_string').val($('#search_string').val().trim());
    $('#rowsPerPage').val($('#rowPerPage_1').val());
    $('#searchForm').submit();
  }


</script>


<h3 class="mjtit_top">
    품목관리
    <a class="back_btn" href="#"><img src="/images/common/back_arrow.png" alt="뒤로가기"></a>
</h3>
<div class="master_cont">
    <!--  관리자  검색시작-->
    <form id="searchForm" action="/product/product">
        <input type="hidden" id="rowsPerPage" name="rowsPerPage"/>
        <div class="srch_all">
            <div class="sel_wrap sel_wrap1">
                <select name="USE_YN" class="sel_02">
                    <option value="Y" <c:if test="${search.USE_YN eq 'Y'}">selected</c:if>>사용</option>
                    <option value="N" <c:if test="${search.USE_YN eq 'N'}">selected</c:if>>미사용</option>
                </select>
            </div>
            <div class="sel_wrap sel_wrap1">
                <select name="CAT_CD" class="sel_02">
                    <option value="ALL">카테고리</option>
                    <c:forEach var="list" items="${category}">
                        <option value="${list.cat_cd}"
                                <c:if test="${search.CAT_CD eq list.cat_cd}">selected</c:if>> ${list.cat_name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="sel_wrap sel_wrap1">
                <select name="PROD_TYPE" class="sel_02">
                    <option value="ALL">품목구분</option>
                    <c:forEach items="${productGubun}" var="result">
                        <c:if test="${result.code ne 'PG001' and result.code ne 'PG002'}">
                            <option value="${result.code}"
                                    <c:if test="${search.PROD_TYPE eq result.code}">selected</c:if> >${result.code_nm}</option>
                        </c:if>
                    </c:forEach>
                </select>
            </div>
            <div class="sel_wrap sel_wrap1">
                <select name="search_type" class="sel_02">
                    <option value="ALL" <c:if test="${search.search_type == 'ALL'}">selected</c:if>>전체</option>
                    <option value="CODE" <c:if test="${search.search_type == 'CODE'}">selected</c:if>>품목코드</option>
                    <option value="PDT_NAME" <c:if test="${search.search_type == 'PDT_NAME'}">selected</c:if>>품목이름</option>
                    <option value="REMARKS_WIN" <c:if test="${search.search_type == 'REMARKS_WIN'}">selected</c:if>>키워드</option>
                </select>
            </div>

            <input type="text" class="srch_input01 srch_input02" id="search_string" name="search_string" onkeyup="if(window.event.keyCode==13){goSearch()}"/>
            <div class="srch_btn">
                <button type="button" class="btn_02" onclick="goSearch();">검색</button>
                <button type="button" class="btn_01">초기화</button>
            </div>
            <div class="register_btn">
                <button type="button" class="btn_02 popLayermaterialRegistBtn" onclick="newRegister()">신규등록</button>
            </div>
        </div>
    </form>

</div>
<!-- 검색 끝-->


<!-- 리스트 시작-->
<div class="master_list ">
    <div class="list_set ">
        <div class="set_left">

        </div>
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
        <table class="master_01 master_06">
            <colgroup>
                <col style="width: 65px;"/>
                <col style="width: 150px;"/>
                <col style="width: 115px;"/>
                <col style="width: 100px;">
                <col style="width: 280px;">
                <col style="width: 150px;"/>
                <col style="width: 160px;"/>
                <col style="width: 90px;"/>
            </colgroup>
            <thead>
            <tr>
                <th>No</th>
                <th>품목코드</th>
                <th>카테고리</th>
                <th>품목구분</th>
                <th>품목명</th>
                <th>규격명</th>
                <th>키워드</th>
                <th>사용여부</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${list}" var="list">
                <tr>
                    <td class="num"><fmt:formatNumber value="${total+1-list.no}" pattern="#,###,###"/></td>
                    <td class="code">
                        <a href="#" onClick="viewProductDetail('${list.PDT_CD}','view');">${list.PROD_CD}</a>
                    </td>
                    <td class="code">${list.CAT_NAME}</td>
                    <td class="code">${list.PROD_TYPE}</td>
                    <td class="prod">
                        <a href="#" onClick="viewProductDetail('${list.PDT_CD}','view');">${list.PROD_DES}</a>
                        <a href="#" onClick="viewProductDetail('${list.PDT_CD}','view');"
                           class="m_link">${list.PROD_DES}</a>
                    </td>

                    <td class="sang t_left">${list.SIZE_DES}</td>
                    <td class="sang t_left">${list.REMARKS_WIN}</td>
                    <td class="sang">${list.USE_YN}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty list }">
                <tr>
                    <td colspan="8">품목 정보가 없습니다.</td>
                </tr>
            </c:if>

            </tbody>
        </table>
        <div class="mjpaging_comm">
            ${dh:pagingB(total, currentPage, rowsPerPage, 10, parameter)}
        </div>
    </div>
    <!-- 리스트 끝-->
    <!--하단버튼-->

    <!-- <ul class="mt15">
         <li>ㆍ노출순서를 변경하시고 "노출순서 변경"울 클릭하셔야 프론트에 반영이 됩니다.</li>
         <li>ㆍ사용하지 않는 메인배너는 미노출로 전환하시기 바랍니다.</li>
     </ul> -->

    <!-- 관리자 등록 contents -->
    <div class="master_pop master_pop01" id="productInfoLayer">
        <div class="master_body">
            <div class="pop_bg" onclick="productInfoLayer_Close();"></div>
            <div class="pop_wrap pop_wrap_01 pop_wrap_700" id="tab_box">
                <div class="pop_inner">
                    <form id="productInfo_Form" name="productInfo_Form">
                        <input type="hidden" id="mode" name="mode"/>
                        <input type="hidden" id="PDT_CD" name="PDT_CD"/>

                        <h3 id="title">품목등록<a class="back_btn" href="#" onclick="productInfoLayer_Close();"><img
                                src="/images/common/back_arrow.png" alt="뒤로가기"></a></h3>

                        <div class="marter_tab">
                            <ul id="tab" class="clearfix">
                                <li class="view"><a href="#" onclick="tabView(1,this);return false;">기본</a></li>
                                <li><a href="#" onclick="tabView(2,this);return false;">품목정보</a></li>
                                <li><a href="#" onclick="tabView(3,this);return false;">수량</a></li>
                                <li><a href="#" onclick="tabView(4,this);return false;">단가</a></li>
                                <li><a href="#" onclick="tabView(5,this);return false;">관리대상</a></li>
                                <li><a href="#" onclick="tabView(6,this);return false;">쇼핑몰</a></li>
                            </ul>
                        </div>

                        <div class="master_list">
                            <div id="tab-1" class="tab_box tab_box1">
                                <table class="master_02 ">
                                    <colgroup>
                                        <col style="width:135px ">
                                        <col>
                                        <col>
                                        <col>
                                    </colgroup>
                                    <caption>
                                        제품 등록 양식
                                    </caption>
                                    <tbody>
                                    <tr>
                                        <th scope="row">제품코드 <span class="keyf01">*</span></th>
                                        <td colspan="3" style="width:80%">
                                            <input type="text" id="PDT_CODE" name="PDT_CODE" class="all" placeholder="제품코드 입력" alt="제품코드" maxlength="100"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">카테고리 <span class="keyf01">*</span></th>
                                        <td colspan="3">
                                            <div class="sel_wrap">
                                                <select id="cate1" name="CATE1" class="sel_02" onchange="choiceCategory(this.value, 1)">
                                                    <c:forEach var="list" items="${category}">
                                                        <option value="${list.cat_cd}">${list.cat_name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div id="category2" class="sel_wrap" style="display: none">
                                                <select id="cate2" name="CATE2" class="sel_02" onchange="choiceCategory(this.value, 2)">

                                                </select>
                                            </div>
                                            <div id="category3" class="sel_wrap" style="display: none">
                                                <select id="cate3" name="CATE3" class="sel_02">
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">제품명 <span class="keyf01">*</span></th>
                                        <td colspan="3"><input type="text" id="PDT_NAME" name="PDT_NAME" class="all"
                                                               placeholder="제품명 입력" alt="제품명"/></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">규격</th>
                                        <td colspan="3">
                                            <input type="text" id="PDT_STANDARD" name="PDT_STANDARD" class="all"
                                                   placeholder="규격" alt="규격" maxlength="100"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">단위</th>
                                        <td colspan="3"><input type="text" id="UNIT" name="UNIT" class="all"
                                                               placeholder="단위" alt="단위" maxlength="100"/></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">품목구분 <span class="keyf01">*</span></th>
                                        <td colspan="3">
                                            <div class="radiobox">
                                                <c:forEach items="${productGubun}" var="result" varStatus="i">
                                                    <label for="PROD_TYPE${i.count}">
                                                        <input type="radio" id="PROD_TYPE${i.count}" name="PROD_TYPE"
                                                               value="${result.code}"
                                                               <c:if test="${i.count eq 1}">checked</c:if> ><span>${result.code_nm}</span>
                                                    </label>
                                                </c:forEach>

                                            </div>

                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">세트여부</th>
                                        <td colspan="3">
                                            <div class="radiobox">
                                                <label for="SET_FLAG1">
                                                    <input type="radio" id="SET_FLAG1" name="SET_FLAG" value="1"><span>사용</span>
                                                </label>
                                                <label for="SET_FLAG2">
                                                    <input type="radio" id="SET_FLAG2" name="SET_FLAG" value="0"
                                                           checked="checked"><span>사용안함</span>
                                                </label>

                                            </div>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">재고수량관리</th>
                                        <td colspan="3">
                                            <div class="radiobox">
                                                <label for="BAL_FLAG1">
                                                    <input type="radio" id="BAL_FLAG1" name="BAL_FLAG" value="1"><span>사용</span>
                                                </label>
                                                <label for="BAL_FLAG2">
                                                    <input type="radio" id="BAL_FLAG2" name="BAL_FLAG" value="0"
                                                           checked="checked"><span>사용안함</span>
                                                </label>
                                            </div>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">생산공정</th>
                                        <td colspan="3">
                                            <input type="text" id="WH_CD" name="WH_CD" class="text_box01 w_98 "
                                                   placeholder="생산공정" alt="생산공정"/>
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

                                    <tr>
                                        <th scope="row">쇼핑몰 판매여부 <span class="keyf01">*</span></th>
                                        <td colspan="3">
                                            <div class="sel_wrap">
                                                <select id="SHOP_USE_YN" name="SHOP_USE_YN" class="sel_02" onchange="shopUseCheck();">
                                                    <option value="Y">사용</option>
                                                    <option value="N" selected>미사용</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th scope="row">구매처</th>
                                        <td colspan="3">
                                            <input type="hidden" id="CUST_SEQ" name="CUST_SEQ" value="0">
                                            <input type="text" id="CUST_NAME" name="CUST_NAME" class="all" placeholder="구매처" alt="구매처" onclick="openLayer();" readonly/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">바코드</th>
                                        <td colspan="3">
                                            <input type="text" id="BAR_CODE" name="BAR_CODE" class="all"
                                                   placeholder="바코드" alt="바코드"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">검색키워드</th>
                                        <td colspan="3">
                                            <input type="text" id="REMARKS_WIN" name="REMARKS_WIN"
                                                   class="all" placeholder="검색키워드" alt="검색키워드"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">품목공유여부</th>
                                        <td colspan="3">
                                            <div class="chkbox chkbox1">
                                                <input type="hidden" id="CS_FLAG" name="CS_FLAG">
                                                <label for="CS_FLAG_CHK">
                                                    <input type="checkbox" id="CS_FLAG_CHK" name="CS_FLAG_CHK">

                                                    <span>CS공유</span>
                                                </label>
                                            </div>

                                        </td>
                                    </tr>

                                    </tbody>
                                </table>
                            </div>

                            <div id="tab-2" class="tab_box tab_box2">
                                <table class="master_02 ">
                                    <colgroup>
                                        <col style="width:135px ">
                                        <col>
                                        <col>
                                        <col>
                                    </colgroup>
                                    <tbody>

                                    <tr>
                                        <th scope="row">부가세율(매출)</th>
                                        <td colspan="3">
                                            <div class="radiobox">
                                                <label for="VAT_N">
                                                    <input type="radio" id="VAT_N" name="VAT_YN" value="N"
                                                    ><span>기본설정</span>
                                                </label>
                                                <label for="VAT_Y">
                                                    <input type="radio" id="VAT_Y" name="VAT_YN" value="Y"
                                                           class="sel_view sel_view2"><span>직접입력</span>
                                                </label>

                                            </div>
                                            <span class="g_business_view g_business_view2 g_business_none">

										<input type="text" id="TAX" name="TAX" class="small tc" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" value="0"/>%
									</span>

                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">부가세율(매입)</th>
                                        <td colspan="3">

                                            <div class="radiobox">
                                                <label for="VAT_RATE_BY_BASE_N">
                                                    <input type="radio" id="VAT_RATE_BY_BASE_N"
                                                           name="VAT_RATE_BY_BASE_YN" value="N"><span>기본설정</span>
                                                </label>
                                                <label for="VAT_RATE_BY_BASE_Y">
                                                    <input type="radio" id="VAT_RATE_BY_BASE_Y"
                                                           name="VAT_RATE_BY_BASE_YN" value="Y" class="sel_view sel_view3"><span>직접입력</span>
                                                </label>

                                            </div>
                                            <span id="VAT_RATE_BYX"
                                                  class="g_business_view g_business_view3 g_business_none">

											<input type="text" id="VAT_RATE_BY" name="VAT_RATE_BY" class="small tc" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                   value="0"/>%
										</span>

                                    </tr>
                                    <tr>
                                        <th scope="row">품목그룹</th>
                                        <td colspan="3">
                                            <div class="sel_wrap">
                                                <select id="CLASS_CD2" name="CLASS_CD2" class="sel_02">
                                                    <option value="">사용안함</option>
                                                    <c:forEach items="${productGroup}" var="result">
                                                        <option value="${result.code}">${result.code_nm}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th scope="row">적요</th>
                                        <td colspan="3">
                                            <input type="text" id="PDT_BIGO" name="PDT_BIGO" class="all" placeholder="적요"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">품질검사방법</th>
                                        <td colspan="3">
                                            <div class="radiobox">
                                                <label for="INSPECT_STATUS_L">
                                                    <input type="radio" id="INSPECT_STATUS_L" name="INSPECT_STATUS" value="L"><span>전수</span>
                                                </label>
                                                <label for="INSPECT_STATUS_S">
                                                    <input type="radio" id="INSPECT_STATUS_S" name="INSPECT_STATUS" value="S" class="sel_view sel_view4"><span>샘플링</span>
                                                </label>

                                            </div>
                                            <span class="g_business_view g_business_view4 g_business_none">
                                                <input type="text" id="SAMPLE_PERCENT" name="SAMPLE_PERCENT" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="small tc"
                                                       value="0"/>%
                                            </span>
                                        </td>
                                    </tr>

                                    </tbody>
                                </table>

                            </div>

                            <div id="tab-3" class="tab_box tab_box3">
                                <table class="master_02 ">
                                    <colgroup>
                                        <col style="width:135px ">
                                        <col>
                                        <col>
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th scope="row" rowspan="2">BOX당 수량</th>
                                        <td colspan="3">
                                            <span class="tit">BOX</span>
                                            <input type="text" id="DENO_RATE" name="DENO_RATE" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="text_box01 w_98"
                                                   placeholder="BOX"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <span class="tit">수량</span>
                                            <input type="text" id="EXCH_RATE" name="EXCH_RATE" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" class="text_box01 w_98"
                                                   placeholder="수량"/>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th scope="row" rowspan="7">안전재고관리</th>
                                        <td colspan="3">
                                            <span class="tit">주문서</span>
                                            <div class="radiobox">
                                                <label for="SAFE_A0001_1">
                                                    <input type="radio" id="SAFE_A0001_1" name="SAFE_A0001" value="0"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="SAFE_A0001_2">
                                                    <input type="radio" id="SAFE_A0001_2" name="SAFE_A0001"
                                                           value="1"><span>사용</span>
                                                </label>
                                                <label for="SAFE_A0001_3">
                                                    <input type="radio" id="SAFE_A0001_3" name="SAFE_A0001"
                                                           value="2"><span>사용안함</span>
                                                </label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>

                                        <td colspan="3">
                                            <span class="tit">판매</span>
                                            <div class="radiobox">
                                                <label for="SAFE_A0002_1">
                                                    <input type="radio" id="SAFE_A0002_1" name="SAFE_A0002" value="0"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="SAFE_A0002_2">
                                                    <input type="radio" id="SAFE_A0002_2" name="SAFE_A0002"
                                                           value="1"><span>사용</span>
                                                </label>
                                                <label for="SAFE_A0002_3">
                                                    <input type="radio" id="SAFE_A0002_3" name="SAFE_A0002"
                                                           value="2"><span>사용안함</span>
                                                </label>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>

                                        <td colspan="3">
                                            <span class="tit">생산불출</span>
                                            <div class="radiobox">
                                                <label for="SAFE_A0003_1">
                                                    <input type="radio" id="SAFE_A0003_1" name="SAFE_A0003" value="0"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="SAFE_A0003_2">
                                                    <input type="radio" id="SAFE_A0003_2" name="SAFE_A0003"
                                                           value="1"><span>사용</span>
                                                </label>
                                                <label for="SAFE_A0003_3">
                                                    <input type="radio" id="SAFE_A0003_3" name="SAFE_A0003"
                                                           value="2"><span>사용안함</span>
                                                </label>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>

                                        <td colspan="3">
                                            <span class="tit">생산입고</span>
                                            <div class="radiobox">
                                                <label for="SAFE_A0004_1">
                                                    <input type="radio" id="SAFE_A0004_1" name="SAFE_A0004" value="0"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="SAFE_A0004_2">
                                                    <input type="radio" id="SAFE_A0004_2" name="SAFE_A0004"
                                                           value="1"><span>사용</span>
                                                </label>
                                                <label for="SAFE_A0004_3">
                                                    <input type="radio" id="SAFE_A0004_3" name="SAFE_A0004"
                                                           value="2"><span>사용안함</span>
                                                </label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>

                                        <td colspan="3">
                                            <span class="tit">창고이동</span>
                                            <div class="radiobox">
                                                <label for="SAFE_A0005_1">
                                                    <input type="radio" id="SAFE_A0005_1" name="SAFE_A0005" value="0"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="SAFE_A0005_2">
                                                    <input type="radio" id="SAFE_A0005_2" name="SAFE_A0005"
                                                           value="1"><span>사용</span>
                                                </label>
                                                <label for="SAFE_A0005_3">
                                                    <input type="radio" id="SAFE_A0005_3" name="SAFE_A0005"
                                                           value="2"><span>사용안함</span>
                                                </label>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>

                                        <td colspan="3">
                                            <span class="tit">자가사용</span>
                                            <div class="radiobox">
                                                <label for="SAFE_A0006_1">
                                                    <input type="radio" id="SAFE_A0006_1" name="SAFE_A0006" value="0"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="SAFE_A0006_2">
                                                    <input type="radio" id="SAFE_A0006_2" name="SAFE_A0006"
                                                           value="1"><span>사용</span>
                                                </label>
                                                <label for="SAFE_A0006_3">
                                                    <input type="radio" id="SAFE_A0006_3" name="SAFE_A0006"
                                                           value="2"><span>사용안함</span>
                                                </label>
                                            </div>
                                        </td>

                                    </tr>
                                    <tr>

                                        <td colspan="3">
                                            <span class="tit">불량처리</span>
                                            <div class="radiobox">
                                                <label for="SAFE_A0007_1">
                                                    <input type="radio" id="SAFE_A0007_1" name="SAFE_A0007" value="0"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="SAFE_A0007_2">
                                                    <input type="radio" id="SAFE_A0007_2" name="SAFE_A0007"
                                                           value="1"><span>사용</span>
                                                </label>
                                                <label for="SAFE_A0007_3">
                                                    <input type="radio" id="SAFE_A0007_3" name="SAFE_A0007"
                                                           value="2"><span>사용안함</span>
                                                </label>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">안전재고수량</th>
                                        <td colspan="3"><input type="text" id="SAFE_STOCK" name="SAFE_STOCK" value="0" placeholder="안전재고수량"
                                                               onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"/></td>

                                    </tr>
                                    <tr>
                                        <th scope="row">CS최소주문수량</th>
                                        <td colspan="3">
                                            <div class="sel_wrap">
                                                <select id="CSORD_C0001" name="CSORD_C0001" class="sel_02" onchange="ChangeCSORD(this);">
                                                    <option value="B">기본설정</option>
                                                    <option value="Y">사용</option>
                                                    <option value="N">사용안함</option>
                                                </select>
                                            </div>
                                            <input type="text" id="CSORD_TEXT" name="CSORD_TEXT" class="text_box01 w_45"
                                                   value="0" placeholder="CS최소주문수량" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">CS최소주문단위</th>
                                        <td colspan="3">
                                            <div class="sel_wrap">
                                                <select id="CSORD_C0003" name="CSORD_C0003" class="sel_02">
                                                    <option value="N">사용안함</option>
                                                    <option value="Y">사용</option>
                                                </select>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">재고수량</th>
                                        <td colspan="3"><input type="text" name="PDT_STOCK" id="PDT_STOCK" value="0" placeholder="재고수량"
                                                               onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"/></td>
                                    </tr>
                                    <tr>
                                        <th scope="row">조달기간</th>
                                        <td colspan="3">
                                            <input type="text" id="IN_TERM" name="IN_TERM" class="text_box01  firstFocus" placeholder="조달기간"/>
                                        </td>
                                    </tr>


                                    <tr>
                                        <th scope="row">최소구매단위</th>
                                        <td colspan="3"><input type="text" id="MIN_QTY" name="MIN_QTY" class="text_box01 w_98" placeholder="최소구매단위"/></td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>


                            <div id="tab-4" class="tab_box tab_box4">
                                <table class="master_02 ">
                                    <colgroup>
                                        <col style="width:135px ">
                                        <col>
                                        <col>
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th scope="row">입고단가</th>
                                        <td colspan="3">
                                            <input type="text" id="IN_PRICE" name="IN_PRICE" class="text_box01 w_80 "
                                                   value="0" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" placeholder="입고단가" alt="입고단가"/>
                                            <div class="chkbox chkbox1">
                                                <input type="hidden" id="IN_PRICE_VAT_YN" name="IN_PRICE_VAT_YN">
                                                <label for="IN_PRICE_VAT_YN_CHK">
                                                    <input type="checkbox" id="IN_PRICE_VAT_YN_CHK" name="IN_PRICE_VAT_YN_CHK">

                                                    <span>VAT포함</span>
                                                </label>
                                            </div>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">출고단가</th>
                                        <td colspan="3">
                                            <input type="text" id="OUT_PRICE" name="OUT_PRICE" class="text_box01 w_80 "
                                                   value="0" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" placeholder="출고단가" alt="출고단가"/>
                                            <div class="chkbox chkbox1">
                                                <input type="hidden" id="OUT_PRICE_VAT_YN" name="OUT_PRICE_VAT_YN"/>
                                                <label for="OUT_PRICE_VAT_YN_CHK">
                                                    <input type="checkbox" id="OUT_PRICE_VAT_YN_CHK" name="OUT_PRICE_VAT_YN_CHK">

                                                    <span>VAT포함</span>
                                                </label>
                                            </div>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">원가</th>
                                        <td colspan="3">
                                            <input type="text" id="OUT_PRICE1" name="OUT_PRICE1"
                                                   class="text_box01 w_80 " value="0" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" placeholder="원가" alt="원가"/>
                                            <div class="chkbox chkbox1">
                                                <input type="hidden" id="OUT_PRICE1_VAT_YN" name="OUT_PRICE1_VAT_YN"/>
                                                <label for="OUT_PRICE1_VAT_YN_CHK">
                                                    <input type="checkbox" id="OUT_PRICE1_VAT_YN_CHK" name="OUT_PRICE1_VAT_YN_CHK">

                                                    <span>VAT포함</span>
                                                </label>
                                            </div>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">대리점가</th>
                                        <td colspan="3">
                                            <input type="text" id="OUT_PRICE2" name="OUT_PRICE2"
                                                   class="text_box01 w_80 " value="0" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" placeholder="대리점가" alt="대리점가"/>
                                            <div class="chkbox chkbox1">
                                                <input type="hidden" id="OUT_PRICE2_VAT_YN" name="OUT_PRICE2_VAT_YN"/>
                                                <label for="OUT_PRICE2_VAT_YN_CHK">
                                                    <input type="checkbox" id="OUT_PRICE2_VAT_YN_CHK" name="OUT_PRICE2_VAT_YN_CHK">

                                                    <span>VAT포함</span>
                                                </label>
                                            </div>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">소비자가</th>
                                        <td colspan="3">
                                            <input type="text" id="OUT_PRICE3" name="OUT_PRICE3"
                                                   class="text_box01 w_80 " value="0" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');" placeholder="소비자가" alt="소비자가"/>
                                            <div class="chkbox chkbox1">
                                                <input type="hidden" id="OUT_PRICE3_VAT_YN" name="OUT_PRICE3_VAT_YN"/>
                                                <label for="OUT_PRICE3_VAT_YN_CHK">
                                                    <input type="checkbox" id="OUT_PRICE3_VAT_YN_CHK" name="OUT_PRICE3_VAT_YN_CHK">

                                                    <span>VAT포함</span>
                                                </label>
                                            </div>
                                        </td>

                                    </tr>

                                    <tr>
                                        <th scope="row">표준노무시간<i>(노무비가중치)</i></th>
                                        <td colspan="3">
                                            <input type="text" id="LABOR_WEIGHT" name="LABOR_WEIGHT" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                   class="text_box01 w_98" value="1" placeholder="표준노무시간(노무비가중치)"
                                                   alt="표준노무시간(노무비가중치)"/>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">경비가중치</th>
                                        <td colspan="3">
                                            <input type="text" id="EXPENSES_WEIGHT" name="EXPENSES_WEIGHT" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                   class="text_box01 w_98 " value="1" placeholder="경비가중치" alt="경비가중치"/>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">재료비표준원가</th>
                                        <td colspan="3">
                                            <input type="text" id="MATERIAL_COST" name="MATERIAL_COST" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                   class="text_box01 w_98 " value="0" placeholder="재료비표준원가"
                                                   alt="재료비표준원가"/>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">경비표준원가</th>
                                        <td colspan="3">
                                            <input type="text" id="EXPENSE_COST" name="EXPENSE_COST" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                   class="text_box01 w_98 " value="0"/>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">노무비표준원가</th>
                                        <td colspan="3">
                                            <input type="text" id="LABOR_COST" name="LABOR_COST" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                   class="text_box01 w_98 " value="0"/>
                                        </td>

                                    </tr>
                                    <tr>
                                        <th scope="row">외주비표준원가</th>
                                        <td colspan="3">
                                            <input type="text" id="OUT_COST" name="OUT_COST" class="text_box01 w_98 " onkeyup="this.value=this.value.replace(/[^0-9]/g,'');"
                                                   value="0"/>

                                        </td>

                                    </tr>

                                    </tbody>
                                </table>
                            </div>


                            <div id="tab-5" class="tab_box tab_box5">
                                <table class="master_02 ">
                                    <colgroup>
                                        <col style="width:135px ">
                                        <col>
                                        <col>
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th scope="row">관리항목</th>
                                        <td colspan="3">
                                            <div class="radiobox">
                                                <label for="ITEM_TYPE1">
                                                    <input type="radio" id="ITEM_TYPE1" name="ITEM_TYPE" value="B"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="ITEM_TYPE2">
                                                    <input type="radio" id="ITEM_TYPE2" name="ITEM_TYPE"
                                                           value="Y"><span>필수입력</span>
                                                </label>
                                                <label for="ITEM_TYPE3">
                                                    <input type="radio" id="ITEM_TYPE3" name="ITEM_TYPE"
                                                           value="M"><span>선택입력</span>
                                                </label>
                                                <label for="ITEM_TYPE4">
                                                    <input type="radio" id="ITEM_TYPE4" name="ITEM_TYPE"
                                                           value="N"><span>사용안함</span>
                                                </label>
                                            </div>

                                        </td>
                                    </tr>
                                    <tr>

                                        <th scope="row">시리얼</th>
                                        <td colspan="3">
                                            <div class="radiobox">
                                                <label for="SERIAL_TYPE1">
                                                    <input type="radio" id="SERIAL_TYPE1" name="SERIAL_TYPE" value="Y"
                                                           checked="checked"><span>사용</span>
                                                </label>
                                                <label for="SERIAL_TYPE2">
                                                    <input type="radio" id="SERIAL_TYPE2" name="SERIAL_TYPE"
                                                           value="N"><span>미사용</span>
                                                </label>

                                            </div>

                                        </td>
                                    </tr>

                                    <tr>
                                        <th scope="row" rowspan="2">생산전표생성대상</th>
                                        <td colspan="3">
                                            <span class="tit">판매</span>
                                            <div class="radiobox">
                                                <label for="PROD_SELL_TYPE1">
                                                    <input type="radio" id="PROD_SELL_TYPE1" name="PROD_SELL_TYPE"
                                                           value="B"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="PROD_SELL_TYPE2">
                                                    <input type="radio" id="PROD_SELL_TYPE2" name="PROD_SELL_TYPE"
                                                           value="Y"><span>사용</span>
                                                </label>
                                                <label for="PROD_SELL_TYPE3">
                                                    <input type="radio" id="PROD_SELL_TYPE3" name="PROD_SELL_TYPE"
                                                           value="N"><span>사용안함</span>
                                                </label>
                                            </div>

                                        </td>

                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <span class="tit">창고이동</span>
                                            <div class="radiobox">
                                                <label for="PROD_WHMOVE_TYPE1">
                                                    <input type="radio" id="PROD_WHMOVE_TYPE1" name="PROD_WHMOVE_TYPE"
                                                           value="B"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="PROD_WHMOVE_TYPE2">
                                                    <input type="radio" id="PROD_WHMOVE_TYPE2" name="PROD_WHMOVE_TYPE"
                                                           value="Y"><span>사용</span>
                                                </label>
                                                <label for="PROD_WHMOVE_TYPE3">
                                                    <input type="radio" id="PROD_WHMOVE_TYPE3" name="PROD_WHMOVE_TYPE"
                                                           value="N"><span>사용안함</span>
                                                </label>
                                            </div>


                                        </td>
                                    </tr>

                                    <tr>
                                        <th scope="row" rowspan="2">품질검사요청대상</th>
                                        <td colspan="3">

                                            <span class="tit">구매</span>
                                            <div class="radiobox">
                                                <label for="QC_BUY_TYPE1">
                                                    <input type="radio" id="QC_BUY_TYPE1" name="QC_BUY_TYPE" value="B"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="QC_BUY_TYPE2">
                                                    <input type="radio" id="QC_BUY_TYPE2" name="QC_BUY_TYPE"
                                                           value="Y"><span>사용</span>
                                                </label>
                                                <label for="QC_BUY_TYPE3">
                                                    <input type="radio" id="QC_BUY_TYPE3" name="QC_BUY_TYPE"
                                                           value="N"><span>사용안함</span>
                                                </label>
                                            </div>

                                        </td>

                                    </tr>
                                    <tr>
                                        <td colspan="3">
                                            <span class="tit">생산입고</span>
                                            <div class="radiobox">
                                                <label for="QC_YN1">
                                                    <input type="radio" id="QC_YN1" name="QC_YN" value="B"
                                                           checked="checked"><span>기본설정</span>
                                                </label>
                                                <label for="QC_YN2">
                                                    <input type="radio" id="QC_YN2" name="QC_YN"
                                                           value="Y"><span>사용</span>
                                                </label>
                                                <label for="QC_YN3">
                                                    <input type="radio" id="QC_YN3" name="QC_YN"
                                                           value="N"><span>사용안함</span>
                                                </label>
                                            </div>

                                        </td>
                                    </tr>
                                    </tbody>
                                </table>
                            </div>

                            <div id="tab-6" class="tab_box tab_box6">
                                <table class="master_02 ">
                                    <colgroup>
                                        <col style="width:135px ">
                                        <col>
                                        <col>
                                        <col>
                                    </colgroup>
                                    <tbody>
                                    <tr>
                                        <th scope="row">옵션 <span class="keyf01">*</span></th>
                                        <td colspan="3">
                                            <div class="radiobox">
                                                <label>
                                                    <input type="radio" id="optionN" name="pdt_option" value="N" onclick="optionCheck(this.value);" checked/>
                                                    <span>사용안함</span>
                                                </label>
                                                <label>
                                                    <input type="radio" id="optionY" name="pdt_option" value="Y" onclick="optionCheck(this.value);"/>
                                                    <span>사용</span>
                                                </label>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id="fileAddZone">
                                        <th scope="row">상품이미지 <span class="keyf01">*</span></th>
                                        <td colspan="3">
                                            <div class="file_area">
                                                <input type="file" id="file1" name="file1"/>
                                                <input class="fileName1" type="text" value="" readonly/><label for="file1" class="clr">파일첨부</label><br/>
                                            </div>
                                        </td>
                                    </tr>

                                    <tr>
                                        <th scope="row">상품상세정보 <span class="keyf01">*</span></th>
                                        <td colspan="3">
                                            <textarea id="contents" name="contents" rows="10" cols="30" style="width:100%;height:500px;"></textarea>
                                        </td>
                                    </tr>

                                    </tbody>
                                </table>
                            </div>
                        </div>
                        <div class="pop_btn clearfix">
                            <a href="#" class="p_btn_01" onclick="productInfoLayer_Close();">닫기</a>
                            <a id="actionButton" href="#" class="p_btn_02" onclick="productInfoLayer_Update();">수정</a>
                        </div>

                    </form>
                </div>
                <div class="group_close">
                    <a href="#" class="getOrderView_close" onclick="productInfoLayer_Close();"><span>닫기</span></a>
                </div>
                <div id="popup" class="layer_pop">
                    <div class="handle_wrap">
                        <div class="handle"><span>구매처 리스트</span></div>
                        <div class="drag_fix"><a href="#" onclick="closeLayer(); return false"><img src="/images/common/drag_close.png" alt="닫기"></a></div>
                    </div>
                    <iframe src="" id="popupframe"></iframe>
                </div>

            </div>
        </div>
    </div>
    <!-- contents end -->
    <script>
      $('.radiobox label').click(function () {
        if ($(this).find('input').hasClass('sel_view')) {
          var string = $(this).find('.sel_view').attr('class');
          var num = string.replace(/[^0-9]/g, '');
          $('.g_business_view' + num).removeClass('g_business_none');
          console.log(num)
        } else {
          $(this).parent('.radiobox').next('.g_business_view').addClass('g_business_none')

        }

      })

      function openLayer() {
        var url = "/supply/popSupplyList?type=product";
        $('#popup').css('display', 'block');
        $('#popupframe').attr('src', url);
        $('html,body').css('overflow', 'hidden');
        /* 	var frameH ;
            setTimeout(function() {
                frameH = $('#popupframe').contents().find('.pop_wrap').innerHeight();
                frameW = $('#popupframe').contents().find('.pop_wrap').innerWidth();

            },1000) */

      }

      function closeLayer() {
        $('#popup').css('display', 'none');
        $('#popupframe').removeAttr('src');
        $('html,body').css('overflow', '');

      }

      function ChangeCSORD(obj) {
        var csord = obj.value;
        if (csord == 'N') {
          $('#CSORD_TEXT').val("");
          $('#CSORD_TEXT').css("display", "none");
        } else {
          $('#CSORD_TEXT').val("");
          $('#CSORD_TEXT').css("display", "");
        }
      }

      function choiceCust(cust_seq, no, cust_name) {
        $('#CUST_SEQ').val(cust_seq);
        $('#CUST_NAME').val(cust_name);
      }

      function shopUseCheck() {
        if ($("input[name='PROD_TYPE']:checked").val() != "PG003") {
          alert("품목구분이 제품인 경우에만 사용 가능합니다.");
        }
      }
    </script>
</div>