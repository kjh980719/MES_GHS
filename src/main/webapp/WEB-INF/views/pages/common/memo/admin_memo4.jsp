<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<title>씨마켓 전자 입찰 사이트</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type="text/javascript" src="/js/jquery-3.5.1.min.js"></script>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<link rel="stylesheet" type="text/css" href="/css/reset.css">
<link rel="stylesheet" type="text/css" href="/css/comm.css?20200527" />
<%--<link rel="stylesheet" type="text/css" href="/c-market/css/calendarPopup.css">--%>

<script type="text/javascript">

    function inmemo(){
        var str_len = $("#mem_memo").val().length;
        if(str_len <= 0)
            return false;
        if (str_len>=500){
            alert("글자수는 500자 까지 가능합니다.");
            $("#mem_memo").focus();
            return;
        }
        insert_memmo();
    }

    function delmemo(seq){
        if(confirm("메모함에서 삭제 하시겠습니까?")){
            delete_momo(seq);
        }
    }

    //글자수 체크
    function checkMsg(str){
        var max_len = 500;   //제한글자 길이
        var str_len = str.length;

        if(str_len >= max_len){
            alert("메시지 입력은 " + max_len + "자 까지 가능합니다.");
        }
        $("#strlen").text(str_len);
    }



    function insert_memmo(){
        var str_memo = $("#mem_memo").val().replace(/\n/g,"<br>"); //엔터키값은 <br>로 변경후 ajax로 보내자
        //----------ajax----------------
        $.ajax({
            type:"POST",
            url:"/memo/insertBuyerGroupMemo.json",
            async : false,
            contentType: "application/json",
            dataType : "json",
            data : JSON.stringify({
                groupCode : ${groupCode},
                memo : str_memo
            })
        }).done(function(response){
            if(response.success){
                parent.popReload();
            }else{
                alert(response.message);
            }
        })
        //----------ajax-----------
    }

    function delete_momo(seq){
        //----------ajax----------------
        $.ajax({
            type:"POST",
            url:"/memo/deleteBuyerGroupMemo.json",
            async : false,
            contentType: "application/json",
            dataType : "json",
            data : JSON.stringify({
                groupCode : ${groupCode},
                seq : seq
            })
        }).done(function(response){
            if(response.success){
                parent.popReload()
            }else{
                alert(response.message);
            }
        })
        //----------ajax-----------
    }
		function popClose() {
			 parent.goMemoEnd();
		}
</script>
<!-- <style>
    .body_pink .btn_submit_g { color: #fff; background-color: #5a3f21; width: 152px; height: 40px;  display: block; font-weight: normal; border:none; cursor: pointer;}
    #contentAreaPrint {clear:both;width:650px;/*min-height:100%;*/margin:20px auto 0 auto;/*padding-bottom:150px;*/padding-bottom:20px;}
    .myPageName strong {
        font-size: 15px;
        font-weight: 500;
        color: #000;
    }
    .myPageName {
        margin: 26px 0 30px 0;
        padding: 0px 0px 5px 0px;
        border-bottom: 1px solid #e5e5e5;
        background: none !important;
    }
    .tbl_pink {
        border-top: 1px solid #4f2f08 !important; border-bottom: 2px solid #4f2f08 !important;
    }
    .body_pink .btn_submit { color: #fff; background-color: #331f06; width: 152px; height: 40px;  display: block; font-weight: normal; border:none; cursor: pointer;}
    .SubTit_pink{clear:both;padding-left:10px;margin:20px 0 5px 0;background:url('../images/common/bg_stit_pink.gif') no-repeat 0 2px;}

    .tbl_pink td {
        padding: 5px 5px 5px 5px !important;
    }
    body {
        color: #333;
        font-size: 13px;
        font-family: "NotoSansKR","Malgun Gothic","맑은 고딕", "돋움", Dotum, "굴림", Gulim, sans-serif;
        line-height: 20px;
        min-height: 100%;
        height: 100%;
    }
    textarea.in_text {
        padding: 10px;
        border: 1px solid #a8a8a8;
        border-right-color: #e1e1e1;
        border-bottom-color: #e1e1e1;
        color: #4c4c4c;
        font-family: '돋움',dotum, sans-serif;
        font-size: 12px;
        line-height: 1.5;
        resize: none;
        overflow-y: scroll;
    }
    .tbl_pink {
        border-top: 1px solid #4f2f08 !important;
        border-bottom: 2px solid #4f2f08 !important;
    }
    table {
        border-collapse: collapse;
        border-spacing: 0;
        font-size: 13px;
    }
	
</style> -->
<style>
	body {background-color: transparent;}
</style>
</head>
<body>
<div class="layer_bg" onclick="popClose(); return false;"></div>
<div class="layer_wrap">
	<div class="layer_win01 layer_memo" style="position: relative;display: inline-block;width:550px;vertical-align: middle;text-align: left;">
		
			<div ><!--width:650-->
					<h3 class="mjtit_top"><c:out value=""></c:out> | 관리자 메모를 입력하세요.</h3>
					<div class="mjinput">
						<div class="mjLeft">
							<textarea name="textarea" class="in_text" id="mem_memo" rows="3" cols="20" onkeyup="checkMsg(this.value);"></textarea>
						</div>
						<div class="mjRight">
							<button type="button" class="btn_blue01_1" onclick="inmemo();" style="height: 70px"><span>등록</span></button>
						</div>
						<div class="mjall">
							<span id="strlen"></span> / 500
						</div>
					</div>
					<div class="top_mt10 bottom_mt20">
						 <h3 class="mjtit_top" style="padding-top: 10px;">등록된 메모</h3>
							<table class="mjlist_tbl02 mjlist_tbl0M" summary="공고문 및 참고자료(파일 첨부)">
									<colgroup>
											<col>
											<col style="width: 110px">
											<col style="width: 70px">
									</colgroup>
									<tbody>


									<c:if test="${empty list}">
											<tr><td colspan="3" align="center">등록된 메모가 없습니다.</td></tr>
									</c:if>
									<c:forEach items="${list}" var="memo">
											<tr>
													<td ><c:out value="${memo.memo}" escapeXml="false"></c:out></td>
													<td class="align_cen"><c:out value="${memo.regDate}"></c:out></td>
													<td class="align_cen"><a href="#" class="memo_del" onclick="delmemo('${memo.seq}');" title="삭제"><span>삭제</span></a></td>
											</tr>
									</c:forEach>
									</tbody>
							</table>

					</div>
					<div class="bottom_mt30 align_cen">
						<button type="button" class="btn_gray01" onclick="popClose(); return false;">닫기</button>
					</div>
			</div>
			<div class="group_close">
				<a href="#" onclick="popClose(); return false;"><span>닫기</span></a>
			</div>
	</div>
	<div class="layer_align"></div>
</div>
</body>
</html>
