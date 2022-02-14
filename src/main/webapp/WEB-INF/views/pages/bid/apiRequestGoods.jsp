<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko" lang="ko">
<fmt:setLocale value="ko_KR"/>
<fmt:setBundle basename="application" var="properties" />
<head>
	<title>씨마켓 전자 입찰 사이트</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<!--다음 에디터-->
	<link rel="stylesheet" href="/daum_editor/css/editor.css" type="text/css" charset="utf-8"/>
	<script type="text/javascript" src="/daum_editor/js/editor_loader.js" charset="utf-8"></script>
	<!--/다음 에디터-->
	<script language="javascript" src="/js/calendarPopup.js"></script>
	<link rel="stylesheet" href="/css/ori/calendarPopup.css">
	<link rel="stylesheet" type="text/css" href="/css/ori/style.css" />
	<style>
		.pm_button{width: 20px; height: 20px; line-height: 20px; display: inline-block; padding: 0px;background-color:#0086d1;color:white;border:none;cursor:pointer;}
	</style>
	<script type="text/javascript" src="/js/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="/editor/js/HuskyEZCreator.js"></script>
	<script type="text/javascript" src="/js/jquery.serialize-object.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function(){
			if("${data.buy_style}"=="A"){

				$("#step2").hide();
				$("#step3").hide();
				searchGu2('','buy_style_C2_2');
			}
			if("${data.buy_style}"=="B"){
				$("#step2").hide();
				$("#step3").show();
				searchGu2('','buy_style_C2_2');
			}
			if("${data.buy_style}"=="C1"){
				$("#step2").show();
				$("#stepC1").show();
				$("#stepC2").hide();
				$("#step3").hide();
				searchGu2('','buy_style_C2_2');
			}

			if("${data.buy_style}"=="C2"){
				$("#buy_style").val("C2");
				$("#stepC1").hide();
				$("#stepC2").show();
				searchGu2('${data.bid_area}','buy_style_C2_2');

			}
		})
		var product_cnt =${data.buy_pdt_cnt};

		function addRow(obj,num){

			if(num == "tr21" || num == "ftr21") {
				alert(" 최대 20개 까지만 추가 할수 없습니다.");
				return;
			}else{
				obj.style.display="none";
				$("#"+num).show();
			}

		}

		function ViewLayer(){
			if($("#buy_paper").css("display")!="block"){
				$("#buy_paper").show();
				document.f2.buy_paper[0].focus();
			}else{
				$("#buy_paper").hide();
			}
		}

		function ctext(obj){
			var val=$("#paper_text").text();
			if(obj.checked==true){
				val+=" "+obj.value;
			}else{
				val=val.replace(obj.value,"")
			}
			$("#paper_text").text(val);
		}

		function stepby(step){
			if(step=="A"){
				$("#buy_style").val("A");
				$("#step2").hide();
				$("#step3").hide();
				document.f2.buy_style_C2_1.options[0].selected=true;  //상세지역 초기화하기
				searchGu2('','buy_style_C2_2');
				for(i=0;i<document.f2.buy_style_C1.length;i++){     //지역제한 초기화 하기
					document.f2.buy_style_C1[i].checked=false;
				}
				$("#wanted").val("");  //지명업체 초기화 하기
				$("#selcom").text("");  //지명업체 초기화 하기
			}
			if(step=="B"){
				$("#buy_style").val("B");
				$("#step2").hide();
				$("#step3").show();
				document.f2.buy_style_C2_1.options[0].selected=true;  //상세지역 초기화하기
				searchGu2('','buy_style_C2_2');
				for(i=0;i<document.f2.buy_style_C1.length;i++){     //지역제한 초기화 하기
					document.f2.buy_style_C1[i].checked=false;
				}
			}
			if(step=="C"){
				$("#buy_style").val("C1");
				$("#step2").show();
				$("#stepC1").show();
				$("#stepC2").hide();
				$("#step3").hide();
				$("#wanted").val("");  //지명업체 초기화 하기
				$("#selcom").text("");  //지명업체 초기화 하기
			}
		}
		function stepby2(step){
			if(step=="C1"){
				$("#buy_style").val("C1");
				$("#stepC1").show();
				$("#stepC2").hide();
				document.f2.buy_style_C2_1.options[0].selected=true;  //상세지역 초기화하기
				searchGu2('','buy_style_C2_2');


			}
			if(step=="C2"){
				$("#buy_style").val("C2");
				$("#stepC1").hide();
				$("#stepC2").show();
				for(i=0;i<document.f2.buy_style_C1.length;i++){     //지역제한 초기화 하기
					document.f2.buy_style_C1[i].checked=false;
				}


			}
		}

		/////////  합계   /////////////
		function sum(i){
			if (Number($("input[name=pdt_price"+i+"]").val().replace(/,/gi,""))>=0) {   //계산할 대상이 있으면
				if ($("input[name=pdt_qty"+i+"]").val()=="" || $("input[name=pdt_qty"+i+"]").val()<=0) {  //수량이 없으면 기본1로 세팅
					$("input[name=pdt_qty"+i+"]").val("0");
				}
				var line_sum= Number($("input[name=pdt_qty"+i+"]").val().replace(/,/gi,"")) * Number($("input[name=pdt_price"+i+"]").val().replace(/,/gi,"")); // ,를 빼고 곱한다.
				if(line_sum > 2000000000 ) {   //한 라인읜 최대 금액은 20억을 넘지 않도록....int형 초과됨
					alert('품목당 최대 금액은 20억을 넘지 못합니다.');
					$("input[name=pdt_price"+i+"]").val("");
					$("input[name=pdt_sum"+i+"]").val("");
					total_sum();
					return;
				} else {
					$("input[name=pdt_sum"+i+"]").val(numchk1(line_sum));
					total_sum();
				}
			}
		}
		function total_sum(){
			var totalsum=0;
			for(i=1;i<=product_cnt;i++){
				totalsum += Number($("input[name=pdt_sum"+i+"]").val().replace(/,/gi,""));
			}
			$("input[name=totalsum]").val(numchk1(totalsum));
		}
		/// 수량 변동시 //
		function qty_chk(k){
			if($("input[name=pdt_price"+k+"]").val()=="" || $("input[name=pdt_price"+k+"]").val()<=0){  //아직 가격이 입력되지 않았으면 패스
				return;
			} else {               //합계구하기
				sum(k);
			}
		}
		//좌우공백제거
		function trim(obj){
			var val=obj.value;
			obj.value=$.trim(val);
		}
		var submitcnt=0;

		function upload() {

			oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);

			// if($.trim($("input[name=pdt_name1]").val())==""){
			// 	alert("품명을 입력해 주세요.");
			// 	$("input[name=pdt_name1]").focus();
			// 	return;
			// }
			// 품명필드 만큼  합계필드 체크
			for(i=1;i<=product_cnt;i++){
				if($("input[name=pdt_name"+i+"]").val()!=""){
					if($("input[name=pdt_sum"+i+"]").val()==""){
						alert("금액 정보가 입력되어 있지 않습니다. \n 다시 확인해 주세요.");
						$("input[name=pdt_price"+i+"]").focus();
						return;
					}
				}
			}
			// 합계필드 만큼  품명필드 체크
			for(i=1;i<=product_cnt;i++){
				if($("input[name=pdt_sum"+i+"]").val()!="" && Number($("input[name=pdt_sum"+i+"]").val().replace(/,/gi,""))>0){
					if($("input[name=pdt_name"+i+"]").val()==""){
						alert("금액 정보만 입력되어 있고 품명 정보는 없습니다. \n해당 품명을 삭제하려면 예정단가를 0원 으로 처리 하십시요.");
						$("input[name=pdt_name"+i+"]").focus();
						return;
					}
				}
			}
			// 합계필드 만큼  예정단가 체크
			for(i=1;i<=product_cnt;i++){
				if($("input[name=pdt_sum"+i+"]").val()!="" && Number($("input[name=pdt_sum"+i+"]").val().replace(/,/gi,""))>0 ){
					if($("input[name=pdt_price"+i+"]").val()==""){
						alert("예정단가 입력을 다시 확인해 주세요");
						$("input[name=pdt_price"+i+"]").focus();
						return;
					}
				}
			}
			//입찰기간 체크
			var nowdate="${data.nowDate}";  //YYYYMMDD
			var nowdate2="${data.nowTime}";  //테스트 일때는 현재시간 이후면 무조건 허가
			var sdate = $("#tps").val().split("/")[0]+$("#tps").val().split("/")[1]+$("#tps").val().split("/")[2];  //시작년월일 : 20140618
			var edate = $("#tpe").val().split("/")[0]+$("#tpe").val().split("/")[1]+$("#tpe").val().split("/")[2]; //종료
			var sdate2 = $("#buy_s_h").val()+""+$("#buy_s_b").val();  //시작시분 : 1700
			var edate2 = $("#buy_e_h").val()+""+$("#buy_e_b").val(); //종료
			var seldate=$("#payday_y").val()+$("#payday_m").val()+$("#payday_d").val()  ;// 납품일자
			/*
                if(nowdate>edate){
                    alert("입찰 종료일은 오늘("+nowdate+") 이후의 날짜 이어야 합니다.");
                    $("#tpe").focus();
                    return;
                }
                if(nowdate==edate){
                    if(nowdate2>=edate2){  //현재시간99분>=종료시간
                        alert("입찰 종료일은 현재시간 보다 최소 한시간 이후 이어야 합니다.");
                        $("#tpe").focus();
                        return;
                    }
                }
                */
			if(sdate>edate){
				alert("입찰 종료일은 입찰 시작일("+sdate+") 이후의 날짜 이어야 합니다.");
				$("#tpe").focus();
				return;
			}
			/*
            if(sdate==edate){
                if(sdate2>=edate2){
                    alert("입찰 종료일은 입찰 시작일 이후여야 합니다.");
                    $("#tpe").focus();
                    return;
                }
            }
            */
			if($('input[name=buy_deli_day_type]:checked').val()=="A"){
				if(seldate<edate){
					alert("납품일자는 입찰종료일 이전이 될수 없습니다.");
					$("#payday_y").focus();
					return;
				}
			}
			//지역제한 체크
			if($("#buy_style").val()=="C1"){  //지역제한 도체크 일때
				var chkcnt = $("input[name=buy_style_C1]:checkbox:checked").length;   //체크한 갯수
				if(chkcnt == 0){
					alert("제한입찰 지역을 선택해 주세요.");
					document.f2.buy_style_C1[0].focus();
					return;
				}
			}
			if($("#buy_style").val()=="C2"){  //지역제한 상제지역 일때
				var chkcnt = $('input:checkbox[name=buy_style_C2_2]:checked').length;
				if(chkcnt==0){
					alert("상세지역을 구단위 까지 선택해 주세요.");
					document.f2.buy_style_C2_1.focus();
					return;
				}
				if(chkcnt>5){
					alert("상세지역은 최대 5개까지 선택할수 있습니다.");
					document.f2.buy_style_C2_1.focus();
					return;
				}
			}
			if($("#buy_style").val()=="B"){  //지명입찰일때
				if($("#wanted").val()==""){
					alert("지명 업체를 선택해 주세요");
					$("#popbutton").focus();
					return;
				}
			}
			//낙찰방법이 최다수량일때는 예정가 공개 하도록
			if($("input[name=contract]:checked").val()=="D"){
				if($("input[name=price_open]:checked").val()=="B"){
					alert("최다수량 낙찰일때는 예정가를 공개해야 합니다.");
					$("input[name=price_open]")[0].focus();
					return;
				}
			}
			//낙찰방법이 최다수량일때는 품목을 한개만 등록가능하다.
			if($("input[name=contract]:checked").val()=="D"){
				for(i=2;i<=product_cnt;i++){  //2번째 품목부터 입력된 정보가 있는지 확인하고 있으면 리턴
					if(typeof $("input[name=pdt_name"+i+"]")!="undefined" && $("input[name=pdt_name"+i+"]").val()!="" || $("input[name=pdt_sum"+i+"]").val()!=""){
						if(confirm("최다수량 낙찰일때는 한개의 품목만 등록 가능합니다\n한개의 품목을 제외하고 삭제 하시겠습니까?")){
							clear_field();
							return;
						}else{
							$("input[name=pdt_name"+i+"]").focus();
							return;
						}
					}
				}
			}
			//납품일자 체크
			if(document.f2.buy_deli_day_type[1].checked){  //계약후 몇일이내 체크시
				if(document.f2.buy_deli_day_period.value==""){
					alert("납품일자를 확인해 주세요.");
					document.f2.buy_deli_day_period.focus();
					return;
				}
			}
			//납품장소
			if(document.f2.buy_deli_location.value==""){
				alert("납품장소를 입력해 주세요.");
				document.f2.buy_deli_location.focus();
				return;
			}
			//결제방식 체크
			if(document.f2.buy_payday.value==""){
				alert("결제방식을 확인해 주세요.");
				document.f2.buy_payday.focus();
				return;
			}
			//구매사정보 체크
			if(document.f2.mem_com.value==""){
				alert("구매사명을 입력해 주세요.");
				document.f2.mem_com.focus();
				return;
			}
			if(document.f2.buy_contact.value==""){
				alert("사양문의 담당자를 입력해 주세요.");
				document.f2.buy_contact.focus();
				return;
			}
			if(document.f2.buy_contact_teld.value==""||document.f2.buy_contact_tel1.value==""||document.f2.buy_contact_tel2.value==""){
				alert("사양문의 담당자의 연락처를 입력해 주세요.");
				document.f2.buy_contact_teld.focus();
				return;
			}
			if(document.f2.mem_name.value==""){
				alert("계약 담당자를 입력해 주세요.");
				document.f2.mem_name.focus();
				return;
			}
			if(document.f2.mem_name_j.value==""||document.f2.mem_name_b.value==""){
				alert("계약 담당자의 직위 및 부서를 입력해 주세요.");
				document.f2.mem_name_j.focus();
				return;
			}
			if(document.f2.mem_name_teld.value==""||document.f2.mem_name_tel1.value==""||document.f2.mem_name_tel2.value==""){
				alert("계약 담당자의 연락처를 입력해 주세요.");
				document.f2.mem_name_teld.focus();
				return;
			}
			if(document.f2.mem_name_email.value==""){
				alert("계약 담당자의 이메일을 입력해 주세요.");
				document.f2.mem_name_email.focus();
				return;
			}
			/*
            if(document.f2.mem_name_faxd.value==""||document.f2.mem_name_fax1.value==""||document.f2.mem_name_fax2.value==""){
                alert("계약 담당자의 팩스번호를 입력해 주세요.");
                document.f2.mem_name_faxd.focus();
                return;
            }
            */
			//첨부파일 진행창 표시 및 폼전송


			var sendParam = $("form[name='f2']").serializeObject();
			var buy_paper_list = $.trim($("#paper_text").text()).replace(/\s/gi, "|");

			var buy_style_C2_0 = "";
			var buy_style_C2_1 = "";
			var buy_style_C2_2_value = "";
			if($("#buy_style").val() == "C1"){
				$("input[name='buy_style_C1']").each(function(idx, item){
					if($(item).is(":checked")){
						if(buy_style_C2_0.length > 0)
							buy_style_C2_0 += ','
						buy_style_C2_0 += $(item).val();
					}
				})
			}
			if($("#buy_style").val() == "C2"){
				buy_style_C2_1 = $("select[name='buy_style_C2_1']").val();
				$("input[name='buy_style_C2_2']").each(function(idx, item){
					if($(item).is(":checked")){
						if(buy_style_C2_2_value.length > 0)
							buy_style_C2_2_value += ','
						buy_style_C2_2_value += $(item).val();
					}
				})
			}
			sendParam.buy_style_C2_0 = buy_style_C2_0;
			sendParam.buy_style_C2_1 = buy_style_C2_1;
			sendParam.buy_style_C2_2_value = buy_style_C2_2_value;
			sendParam.buy_paper = buy_paper_list;
			sendParam.buy_deli_day = $("select[name='payday_y']").val() + "-" + $("select[name='payday_m']").val() + "-" + $("select[name='payday_d']").val() + "-" + $("select[name='payday_h']").val()
			sendParam.buy_s_day = $("#tps").val().replace(/\//gi,'-')+" "+($("#buy_s_h").val()<10?"0"+$("#buy_s_h").val():$("#buy_s_h").val())+":"+$("#buy_s_b").val()+":00";
			sendParam.buy_e_day = $("#tpe").val().replace(/\//gi,'-')+" "+($("#buy_e_h").val()<10?"0"+$("#buy_e_h").val():$("#buy_e_h").val())+":"+$("#buy_e_b").val()+":00";
			var formData = new FormData;
			formData.append("content", new Blob([JSON.stringify(sendParam)], {type: "application/json"}));
			$.ajax({
				type : "post",
				url : "/bid/apiBidActivate.json",
				contentType : false,
				processData : false,
				async : false,
				data: formData
			}).done(function(response){
				if(response.success){
					alert("입찰신청 되었습니다.");
					opener.grid_reload();
					close();
				}else{
					alert(response.message);
				}
			})
		}

		//인풋내용 초기화
		function clear_field(){
			for (i=2;i<=product_cnt;i++ ){
				$("input[name=pdt_name"+i+"]").val("");
				$("input[name=pdt_size"+i+"]").val("");
				$("input[name=pdt_qty"+i+"]").val("");
				$("input[name=pdt_unit"+i+"]").val("");
				$("input[name=pdt_price"+i+"]").val("");
				$("input[name=pdt_sum"+i+"]").val("");
			}
			total_sum();  //최종합계 다시 구하기
			alert("한개의 품목을 제외하고 모두 삭제 하였습니다.\n확인후 입찰을 진행해 주십시요.");
		}
		//첨부파일 삭제
		function deletefile(buy_idx,buy_seq){
			if(confirm("해당 첨부파일을 삭제 하시겠습니까?")){
				//----------ajax----------------
				$.ajax({
					type:"POST",
					url:"/b2b/bid/bid_deletefile_ajax.asp",
					data:"buy_idx="+buy_idx+"&buy_seq="+buy_seq,  //보내는 데이터
					dataType:"JSON", //리턴받는 데이터 타입 정의
					success : function(data) {
						if(data.result=="1"){  //정상처리 되었을때
							alert("삭제되었습니다.");
							document.location.reload();
						}else{
							alert(data.alert);
						}
					},
					error : function(xhr, status, error) {
						alert("xhr:"+xhr.readyState +"\n"+"xhr:"+xhr.status +"\n"+"xhr:"+xhr.responseText +"\n"+"status:"+status+"\n"+"error:"+error);
					}
				});
				//----------ajax-----------
			}
		}

		function goCancel() {
			self.opener = self;
			self.close();
		}
	</script>
</head>
<body>
<div id="wrap">
	<div id="content">
		<div class="myPageName">
			<strong>KCL 입찰 신청 등록</strong> | KCL 입찰 신청번호: <strong>${data.buy_idx}</strong>
		</div>
		<form name="f2" method="post" enctype="multipart/form-data">
			<input type="hidden" name="bid_puchase_no" value="${data.bid_puchase_no}">
			<input type="hidden" name="member_id" value="${data.member_id}">
			<input type="hidden" name="buy_cate_code" value="${data.buy_cate_code}">
			<input type="hidden" name="GJY" value="${data.GJY_OK}">
			<input type="hidden" name="api_gubun" value="${data.api_gubun}">
			<input type="hidden" name="buy_pdt_cnt" value="${data.buy_pdt_cnt}">
			<input type="hidden" name="buy_idx" value="${data.buy_idx}">
			<!-- 레이어 팝업-->
			<div class="tooltiplayer" style="width:1000px;height:120px;border:#CCC solid 1px; background:#FFFE84; padding:10px; z-index:9999;position:absolute;display: none;">
				<b>[1] 전자입찰 방식</b><br/>
				- 공급사가 단 1회만 가격을 제시할 수 있으며, 입찰이 종료될 때까지 비공개로 가격을 경쟁하는 가장 일반적인 경쟁 방식<br/>
				<b>[2] 역경매 방식</b><br/>
				- 공급사가 여러 번 가격을 제시할 수 있으며, 입찰이 종료될 때까지 서로 공개된 가격으로 최저가 혹은 최고가를 다투는 경쟁 방식
			</div>
			<div  id="buy_paper" style="position:absolute;z-index:999;left:350px;top:1000px;width:720px;background:#dbdbdb;display:none;">
				<div style="background:#fff;margin:10px;">
					<div class="myPageName"><strong>전자 계약에 필요한 계약 서류 설정</strong></div>
					<table width="700px" cellspacing="0" cellpadding="0" >
						<tr>
							<td width="25%"><input name="buy_paper" type="checkbox" value="도장(명판)" onclick="ctext(this);" ${fn:contains(data.buy_paper, '도장(명판)')?'checked':''}/><span class="font00">도장(명판)</span></td>
							<td width="25%"><input name="buy_paper" type="checkbox" value="사업자등록증사본" onclick="ctext(this);" ${fn:contains(data.buy_paper, '사업자등록증사본')?'checked':''}/><span class="font00">사업자등록증사본</span></td>
							<td width="25%"><input name="buy_paper" type="checkbox" value="입금통장사본" onclick="ctext(this);" ${fn:contains(data.buy_paper, '입금통장사본')?'checked':''}/><span class="font00">입금통장사본</span></td>
							<td width="25%"><input name="buy_paper" type="checkbox" value="세금계산서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '세금계산서')?'checked':''}/><span class="font00">세금계산서</span></td>
						</tr>
						<tr>
							<td><input name="buy_paper" type="checkbox" value="견적서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '견적서')?'checked':''}/><span class="font00">견적서</span></td>
							<td><input name="buy_paper" type="checkbox" value="승낙사항" onclick="ctext(this);" ${fn:contains(data.buy_paper, '승낙사항')?'checked':''}/><span class="font00">승낙사항</span></td>
							<td><input name="buy_paper" type="checkbox" value="거래명세서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '거래명세서')?'checked':''}/><span class="font00">거래명세서</span></td>
							<td><input type="checkbox" name="buy_paper" value="4대보험완납증명서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '4대보험완납증명서')?'checked':''}/> 4대보험완납증명서</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="buy_paper" value="대금청구서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '대금청구서')?'checked':''}/>대금청구서</td>
							<td><input type="checkbox" name="buy_paper" value="납품확인서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '납품확인서')?'checked':''}/>납품확인서</td>
							<td><input type="checkbox" name="buy_paper" value="지출결의서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '지출결의서')?'checked':''}/>지출결의서</td>
							<td><input type="checkbox" name="buy_paper" value="인감증명서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '인감증명서')?'checked':''}/>인감증명서</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="buy_paper"  value="도급경비지급서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '도급경비지급서')?'checked':''}/>도급경비지급서</td>
							<td><input type="checkbox" name="buy_paper"  value="청렴계약이행서약서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '청렴계약이행서약서')?'checked':''}/>청렴계약이행서약서</td>
							<td><input type="checkbox" name="buy_paper"  value="하자이행보증보험" onclick="ctext(this);" ${fn:contains(data.buy_paper, '하자이행보증보험')?'checked':''}/>하자이행보증보험</td>
							<td><input type="checkbox" name="buy_paper"  value="계약이행보증보험증권" onclick="ctext(this);" ${fn:contains(data.buy_paper, '계약이행보증보험증권')?'checked':''}/>계약이행보증보험증권</td>
						</tr>
						<tr>
							<td><input type="checkbox" name="buy_paper" value="클린행정협조서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '클린행정협조서')?'checked':''}/>클린행정협조서</td>
							<td><input type="checkbox" name="buy_paper" value="클린행정서약서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '클린행정서약서')?'checked':''}/>클린행정서약서</td>
							<td><input type="checkbox" name="buy_paper" value="시설보유확인서" onclick="ctext(this);" ${fn:contains(data.buy_paper, '시설보유확인서')?'checked':''}/>시설보유확인서</td>
							<td></td>
							<td></td>
						</tr>
					</table>
					<div class="interest">
						<div class="btn_left1">체크 하신 파일을 계약시 필요한 서류로  설정하시겠습니까?</div>
						<div class="btn_right1">
							<input class="btn_submit" style="padding: 0px; width: 80px; height: 30px; line-height: 20px; display: inline-block;" onclick="ViewLayer();" type="button" value="확인">
						</div>
					</div>
				</div>
			</div>
			<!-- //레이어 팝업-->
			<!--물품정보테이블-->
			<h4 class="SubTit_blue">물품 정보</h4>
			<div class="subCon_tb">
				<table>
					<colgroup>
						<col width="42%" />
						<col width="14%" />
						<col width="8%" />
						<col width="8%" />
						<col width="12%" />
						<col width="15%" />
					</colgroup>
					<thead>
					<tr>
						<th rowspan="2" scope="col">품명</th>
						<th rowspan="2" scope="col">제조사 및 모델명</th>
						<th rowspan="2" scope="col">수량</th>
						<th rowspan="2" scope="col">단위</th>
						<th colspan="2" scope="col">예정가격(부가세포함)</th>
					</tr>
					<tr>
						<th scope="col">예정단가</th>
						<th scope="col">합계</th>
					</tr>
					</thead>
					<tbody>

					<c:if test="${!empty guds}">
						<c:forEach items="${guds}" var="item" varStatus="status">
							<tr>
								<td align="left">
									<input type="text" name="pdt_name${status.count}" id="pdt_name${status.count}" class="in_text" style="width:280px;" title="품명"  value="${item.f_name}" onblur="trim(this)" maxlength="50"/>
									<c:if test="${status.count==data.buy_pdt_cnt}">
										<input type="button" id="tr${status.count}p" value="+" class="pm_button" onclick="addRow(this,'tr${status.count+1}');">
									</c:if>
								</td>
								<td>
									<input type="text" name="pdt_size${status.count}" id="pdt_size${status.count}" class="in_text" style="width:95px" value="${item.f_maker}" title="제조사 및 모델명" maxlength="30"/>
									<input type="hidden" name="pdt_code${status.count}" id="pdt_code${status.count}" value="${item.f_norm}"><input type="hidden" name="pdt_seq${status.count}" id="pdt_seq${status.count}" value="${item.f_seq}">
								</td>
								<td><input type="text" name="pdt_qty${status.count}" id="pdt_qty${status.count}" class="in_text" style="width:45px"  maxlength="6" onkeyup="numchk(this);qty_chk('${status.count}');" value="${item.f_volume}" title="수량" /></td>
								<td><input type="text" name="pdt_unit${status.count}" id="pdt_unit${status.count}" class="in_text" style="width:45px" value="${item.f_unit}" title="단위" maxlength="5"/></td>
								<td><input type="text" name="pdt_price${status.count}" id="pdt_price${status.count}" class="in_text" style="width:75px;text-align:right;"  maxlength="12" value="<fmt:formatNumber value="${item.f_price}" pattern="#,###" />" onkeyup="numchk(this);sum('${status.count}');" title="예정단가" /></td>
								<td><input type="text" name="pdt_sum${status.count}" id="pdt_sum${status.count}" class="in_text" style="width:95px;background-color:#fafafa;text-align:right;" value="<fmt:formatNumber value="${item.f_sum}" pattern="#,###" />" readonly title="합계" /></td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty guds}">
						<tr>
							<td colspan="6">-에러 : 상품정보 누락-</td>
						</tr>
					</c:if>
					<%--<c:set var="buy_price" value="data.buy_price"></c:set>
					<c:if test="${buy_price==0}">
						<c:set var="buy_price" value=""></c:set>
					</c:if>--%>

					<tr>
						<td colspan="4">&nbsp;</td>
						<td><strong>최종합계</strong></td>
						<td><input type="text" name="totalsum" class="in_text" style="width:95px;background-color:#fafafa;text-align:right;" value="<fmt:formatNumber value="${data.buy_price}" pattern="#,###" />" readonly title="최종합계" /></td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
						<td colspan="2"><span class="font00"> 예정가:</span> &nbsp;
							<input type="radio" name="price_open" value="A"  class="in_radio" ${data.price_open=='A'?'checked':''}/>공개&nbsp;&nbsp;
							<input type="radio" name="price_open" value="B"  class="in_radio" ${data.price_open=='B'?'checked':''}/>비공개</td>
					</tr>
					</tbody>
				</table>
			</div>
			<!--공고문테이블-->
			<h4 class="SubTit_blue">공고문 및 참고자료(파일 첨부)</h4>
			<table class="tbl_blue mgt4" summary="공고문 및 참고자료(파일 첨부)">
				<colgroup>
					<col width="15%" />
					<col width="*" />
				</colgroup>
				<tbody>
				<tr style="display:none;">
					<th></th><td><textarea id="b_content">${data.buy_desc}</textarea></td>
				</tr>
				<tr>
					<th scope="row" style="text-align:center;vertical-align:middle;">공고문 및 추가설명</th>
					<td><textarea name="etcinfo" id="contents" style="width:600px; height:300px; display:none;">${data.buy_desc}</textarea></td>
				</tr>
				<tr>
					<th scope="row" style="text-align:center;vertical-align:middle;">첨부파일</th>
					<td>
						<table width="100%" cellspacing="0" cellpadding="0">



							<c:if test="${!empty filers}">
								<c:forEach items="${filers}" var="item">
									<tr height="20" bgcolor="#ffffff">
										<td width="5%" align="left">${item.file_seq}</td>
										<td width="65%" align="left">&nbsp; &nbsp;<a href="<fmt:message key="url.cmarket" bundle="${properties}" />/b2b/upload/tender/${item.folder}/${item.UFILE}" target="_blank">${item.UFILE}</a></td>
										<%--<td width="30%" align="right"><font color="red" size="1">다운 후 재 등록 필요없음</font></td>--%>
									</tr>
								</c:forEach>
							</c:if>
							<c:if test="${empty filers}">
								<tr>
									<td>첨부된 파일이 없습니다.</td>
								</tr>
							</c:if>
						</table>
					</td>
				</tr>
				</tbody>
			</table>
			<!--입찰세부조건-->
			<h4 class="SubTit_blue">세부조건</h4>
			<table class="tbl_blue mgt5" summary="세부조건">
				<colgroup>
					<col width="18%" />
					<col width="*" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row"><p>공급사 필수입찰 조건</p></th>
					<td>
						<input type="checkbox" name="precondition"  value="A" <c:if test="${fn:contains(data.precondition, 'A')}">checked</c:if>>입찰보증금제출(5%)
						<input type="button" style="width: 20px; height: 20px; line-height: 20px; display: inline-block; padding: 0px;" value="?" class="btn_submit" onclick="window.open('/b2b/bid/bid_guide_deposit.html','입찰보증금제출안내','width=740, height=370, scrollbars=yes, resizable=no,copyhistory=no,toolbar=no'); return false;">&nbsp;
						<input type="checkbox" name="precondition"  value="B" onclick="return false" <c:if test="${fn:contains(data.precondition, 'B')}">checked</c:if>/>사업자등록상 관련업체&nbsp;
						<input type="checkbox" name="precondition"  value="C" <c:if test="${fn:contains(data.precondition, 'C')}">checked</c:if>/>총판 및 대리점&nbsp;
						<input type="checkbox" name="precondition"  value="D" <c:if test="${fn:contains(data.precondition, 'D')}">checked</c:if>/>제조사
						<br/>
						<input type="checkbox" name="precondition"  value="I" <c:if test="${fn:contains(data.precondition, 'I')}">checked</c:if>/><span class="font09">중증장애인생산품</span>&nbsp;
						<input type="checkbox" name="precondition"  value="J" <c:if test="${fn:contains(data.precondition, 'J')}">checked</c:if>/><span class="font09">기술인증상품</span>&nbsp;
						<input type="checkbox" name="precondition"  value="K" <c:if test="${fn:contains(data.precondition, 'K')}">checked</c:if>/><span class="font09">중소기업제품</span>&nbsp;
						<input type="checkbox" name="precondition"  value="L" <c:if test="${fn:contains(data.precondition, 'L')}">checked</c:if>/><span class="font09">여성기업제품</span>&nbsp;
						<input type="checkbox" name="precondition"  value="M" <c:if test="${fn:contains(data.precondition, 'M')}">checked</c:if>/><span class="font09">친환경상품</span>
						<br/>
						<c:if test="${data.GJY_OK=='B'}">
							<input type="checkbox" name="precondition"  value="E" <c:if test="${fn:contains(data.precondition, 'E')}">checked</c:if>/>동일제품납품실적업체&nbsp;
							<input type="checkbox" name="precondition"  value="F" <c:if test="${fn:contains(data.precondition, 'F')}">checked</c:if>/>동일제품재고확보업체&nbsp;
							<input type="checkbox" name="precondition"  value="G" <c:if test="${fn:contains(data.precondition, 'G')}">checked</c:if>/>입찰종료전 샘플제시&nbsp;
						</c:if>
						<input type="checkbox" name="precondition"  value="H" <c:if test="${fn:contains(data.precondition, 'H')}">checked</c:if>/><span class="font09">입찰시 견적서파일 첨부요 </span>&nbsp;
						<input type="checkbox" name="buy_type" value="I" id="buy_type" ${data.buy_type=='I'?'checked':''}><label for="buy_type">품목별 단가입력(견적서 자동생성)</label>
					</td>
				</tr>
				<tr>
					<th scope="row"><p>입찰기간</p></th>
					<td>
						<c:set var="start_tps" value="${fn:replace(fn:substring(data.buy_s_day, 0, 10), '-', '/')}"></c:set>
						<c:set var="start_sb" value="${fn:substring(data.buy_s_day, 11, 19)}"></c:set>
						<c:set var="end_tpe" value="${fn:replace(fn:substring(data.buy_e_day, 0, 10), '-', '/')}"></c:set>
						<c:set var="end_sb" value="${fn:substring(data.buy_e_day, 11, 19)}"></c:set>
						<!-- 캘린더 -->
						<div id="calendarPopup"></div>
						<input name="tps" id="tps" type="text" value="${start_tps}" style="height: 19px;width:70px;" readonly>&nbsp;<a href="javascript:void(0);" onClick="calPopup(this,'calendarPopup',10,0, 'document.f2.tps','');" title="달력"><img src="/images/btn_calPop3.gif" align="absmiddle" alt="달력" hspace="2"></a>&nbsp;
						<select name="buy_s_h" id="buy_s_h" style="width:40px;">

							<c:forEach begin="0" end="23" var="i">
							<option value="${i<10?'0'+i:i}" ${fn:substring(start_sb, 0, 2)==(i<10?'0'+i:i)?'selected':''}>${i<10?'0'+i:i}</option>
							</c:forEach>

						</select> 시
						<select name="buy_s_b" id="buy_s_b" style="width:40px;">
							<option value="00" ${fn:substring(start_sb, 3, 5)=='00'?'selected':''}>00</option>
							<option value="10" ${fn:substring(start_sb, 3, 5)=='10'?'selected':''}>10</option>
							<option value="20" ${fn:substring(start_sb, 3, 5)=='20'?'selected':''}>20</option>
							<option value="30" ${fn:substring(start_sb, 3, 5)=='30'?'selected':''}>30</option>
							<option value="40" ${fn:substring(start_sb, 3, 5)=='40'?'selected':''}>40</option>
							<option value="50" ${fn:substring(start_sb, 3, 5)=='50'?'selected':''}>50</option>
						</select> 분 ~
						<input name="tpe" id="tpe" type="text" value="${end_tpe}" style="height: 19px; width:70px;"  readonly>&nbsp;<a href="javascript:void(0);"   onClick="calPopup(this,'calendarPopup',10,0, 'document.f2.tpe','');" title="달력"> <img src="/images/btn_calPop3.gif" align="absmiddle" alt="달력" hspace=2></a>&nbsp;
						<select name="buy_e_h" id="buy_e_h" style="width:40px;">
							<c:forEach begin="0" end="23" var="i">
								<option value="${i<10?'0'+i:i}" ${fn:substring(end_sb, 0, 2)==(i<10?'0'+i:i)?'selected':''}>${i<10?'0'+i:i}</option>
							</c:forEach>
						</select> 시
						<select name="buy_e_b" id="buy_e_b" style="width:40px;">
							<option value="00" ${fn:substring(end_sb, 3, 5)=='00'?'selected':''}>00</option>
							<option value="10" ${fn:substring(end_sb, 3, 5)=='10'?'selected':''}>10</option>
							<option value="20" ${fn:substring(end_sb, 3, 5)=='20'?'selected':''}>20</option>
							<option value="30" ${fn:substring(end_sb, 3, 5)=='30'?'selected':''}>30</option>
							<option value="40" ${fn:substring(end_sb, 3, 5)=='40'?'selected':''}>40</option>
							<option value="50" ${fn:substring(end_sb, 3, 5)=='50'?'selected':''}>50</option>
						</select> 분
					</td>
				</tr>
				<tr >
					<th scope="row"><p>입찰진행방법</p></th>
					<td>
						<input type="radio" name="buy_method"  id="close" class="in_radio" value="N" ${data.buy_method=='N'?'checked':''}/>전자입찰 방식&nbsp;&nbsp;&nbsp;
						<input type="radio" name="buy_method"  id="open" class="in_radio" value="Y"  ${data.buy_method=='Y'?'checked':''}/>역경매 방식
					</td>
				</tr>
				<!--지역제한-->
				<tr>
					<th scope="row">지역 제한</th>
					<td>
						<input type="hidden" name="buy_style" id="buy_style" value="${data.buy_style}">
						<input type="radio" name="sel" class="in_radio" onclick="stepby('A');" ${data.buy_style=='A'?'checked':''}/>(전국)공개입찰 &nbsp; &nbsp;
						<input type="radio" name="sel" class="in_radio" onclick="stepby('C');" ${data.buy_style=='C1'?'checked':''}${data.buy_style=='C2'?'checked':''}/>(지역)제한입찰 &nbsp;&nbsp;
						<input type="radio" name="sel" class="in_radio" onclick="stepby('B');" ${data.buy_style=='B'?'checked':''}/>지명입찰
						<!--  지역제한 / 제한입찰-->
						<div id="step2" style="${data.buy_style=='C'?'display:block;':'display:none;'}${data.buy_style=='C1'?'display:block;':'display:none;'}${data.buy_style=='C2'?'display:block;':'display:none;'}">
							<!--  지역제한 / 시도제한-->
							<div id="stepC1" style="${data.buy_style=='C'?'display:block;':'display:none;'}${data.buy_style=='C1'?'display:block;':'display:none;'}">
								<input type="checkbox" name="buy_style_C1"   value="서울" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '서울')}">checked</c:if>/>서울
								<input type="checkbox" name="buy_style_C1"   value="경기" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '경기')}">checked</c:if>/>경기
								<input type="checkbox" name="buy_style_C1"   value="인천" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '인천')}">checked</c:if>/>인천
								<input type="checkbox" name="buy_style_C1"   value="부산" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '부산')}">checked</c:if>/>부산
								<input type="checkbox" name="buy_style_C1"   value="경남" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '경남')}">checked</c:if>/>경남
								<input type="checkbox" name="buy_style_C1"   value="울산" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '울산')}">checked</c:if>/>울산
								<input type="checkbox" name="buy_style_C1"   value="대구" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '대구')}">checked</c:if>/>대구
								<input type="checkbox" name="buy_style_C1"   value="경북" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '경북')}">checked</c:if>/>경북
								<input type="checkbox" name="buy_style_C1"   value="대전" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '대전')}">checked</c:if>/>대전
								<input type="checkbox" name="buy_style_C1"   value="충남" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '충남')}">checked</c:if>/>충남
								<input type="checkbox" name="buy_style_C1"   value="충북" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '충북')}">checked</c:if>/>충북
								<input type="checkbox" name="buy_style_C1"   value="세종" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '세종')}">checked</c:if>/>세종
								<input type="checkbox" name="buy_style_C1"   value="광주" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '광주')}">checked</c:if>/>광주
								<input type="checkbox" name="buy_style_C1"   value="전남" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '전남')}">checked</c:if>/>전남
								<input type="checkbox" name="buy_style_C1"   value="전북" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '전북')}">checked</c:if>/>전북
								<input type="checkbox" name="buy_style_C1"   value="강원" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '강원')}">checked</c:if>/>강원
								<input type="checkbox" name="buy_style_C1"   value="제주" <c:if test="${(data.buy_style=='C'||data.buy_style=='C1')&&fn:contains(data.bid_area, '제주')}">checked</c:if>/>제주
								<input type="button" style="width: 125px; height: 18px; line-height: 18px; display: inline-block; padding: 0px;" value="+ 상세지역(구단위)선택" class="btn_submit" onclick="stepby2('C2');">
							</div>
							<!--  지역제한 / 구군제한-->
							<div id="stepC2" style="${data.buy_style=='C2'?'display:block;':'display:none;'}">
								<span class="font00">[상세지역(구단위)]선택</span><br/>
								<select  title="지역1" name="buy_style_C2_1"  onchange="searchGu2(this.value, 'buy_style_C2_2');">
									<option value="">지역1선택</option>
									<option value="서울" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '서울')}">selected</c:if>>서울</option>
									<option value="부산" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '부산')}">selected</c:if>>부산</option>
									<option value="인천" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '인천')}">selected</c:if>>인천</option>
									<option value="광주" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '광주')}">selected</c:if>>광주</option>
									<option value="대구" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '대구')}">selected</c:if>>대구</option>
									<option value="대전" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '대전')}">selected</c:if>>대전</option>
									<option value="울산" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '울산')}">selected</c:if>>울산</option>
									<option value="경기" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '경기')}">selected</c:if>>경기</option>
									<option value="세종" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '세종')}">selected</c:if>>세종</option>
									<option value="전남" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '전남')}">selected</c:if>>전남</option>
									<option value="전북" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '전북')}">selected</c:if>>전북</option>
									<option value="경남" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '경남')}">selected</c:if>>경남</option>
									<option value="경북" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '경북')}">selected</c:if>>경북</option>
									<option value="충남" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '충남')}">selected</c:if>>충남</option>
									<option value="충북" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '충북')}">selected</c:if>>충북</option>
									<option value="강원" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '강원')}">selected</c:if>>강원</option>
									<option value="제주" <c:if test="${data.buy_style=='C2'&&fn:contains(data.bid_area, '제주')}">selected</c:if>>제주</option>
								</select>
								<div id="buy_style_C2_2"></div>
								<input type="button" style="width: 100px; height: 18px; line-height: 18px; display: inline-block; padding: 0px;" value="+지역(시단위)선택" class="btn_submit" onclick="stepby2('C1');"/>
							</div>
						</div>
						<!-- 상세지역제한일때 두번째 체크박스 체크 -->
						<c:if test="${data.buy_style=='C2'}">
						<script>
							var bid_area = "${area.bid_area}";
							var bid_area2 = "${area.bid_area2}";
							searchGu2(bid_area,'buy_style_C2_2');
							if (window.console) console.log(bid_area2);
							$('input:checkbox[name=buy_style_C2_2]').each(function(){
								if(bid_area2.indexOf($(this).val()) != -1) this.checked=true;
							});
						</script>
						</c:if>
						<!--  지역제한 / 지명입찰-->
						<div id="step3" style="${data.buy_style=='B'?'display:block;':'display:none;'}">
							<input type="hidden" name="wanted" id="wanted" value="${data.wanted}">
							<input type="button" id="popbutton" style="width: 105px; height: 18px; line-height: 18px; display: inline-block; padding: 0px;" value="+ 지명업체 설정" class="btn_submit" onclick="window.open('/b2b/bid/bid_request_wanted.asp','wanted','width=730, height=530, scrollbars=yes, resizable=no,copyhistory=no,toolbar=no'); return false;"/>
							<span class="font00">지명된 업체명</span>: <span id="selcom">${data.selcom}</span>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row"><p>낙찰방법</p></th>
					<td>
						<input type="radio" name="contract"  class="in_radio" value="A" ${data.contract == 'A'?'checked':''}/>최저가(예정금액 이하)
						<input type="radio" name="contract"  class="in_radio" value="B" ${data.contract == 'B'?'checked':''}/>적정가
						<input type="radio" name="contract"  class="in_radio" value="D" ${data.contract == 'C'?'checked':''}/>최다수량
						<input type="radio" name="contract"  class="in_radio" value="E" ${data.contract == 'D'?'checked':''}/>협상에 의한 계약
					</td>
				</tr>
				<tr>
					<th scope="row">납품일자</th>
					<td>
						<input type="radio" name="buy_deli_day_type" value="A" class="in_radio" ${data.buy_deli_day_type=='A'?'checked':''} />직접설정
						<!--달력넣기-->
						<select name="payday_y" id="payday_y" style="width:50px;">
							<c:forEach begin="2014" end="${fn:substring(data.nowday, 0, 4)+1}" var="year_var">
							<option value='${year_var}' ${year_var==fn:split(data.buy_deli_day, "-")[0]?'selected':''} >${year_var}</option>
							</c:forEach>
						</select>년
						<select name="payday_m" id="payday_m" style="width:40px;">

							<c:forEach begin="1" end="12" var="month_var">
								<option value='${month_var<10?'0':''}${month_var}' ${month_var==fn:split(data.buy_deli_day, "-")[1]?'selected':''} >${month_var<10?'0':''}${month_var}</option>
							</c:forEach>
						</select>월
						<select name="payday_d" id="payday_d" style="width:40px;">
							<c:forEach begin="1" end="31" var="dd">
								<option value="${dd<10?'0':''}${dd}" ${dd==fn:split(data.buy_deli_day, "-")[2]?'selected':''} >${dd<10?'0':''}${dd}</option>
							</c:forEach>
						</select>일
						<select name="payday_h" id="payday_h" style="width:40px;">
							<c:forEach begin="1" end="23" var="hh">
								<option value="${hh<10?'0':''}${hh}" ${hh==fn:split(data.buy_deli_day, "-")[3]?'selected':''} ${(hh==17&&null==fn:split(data.buy_deli_day, "-")[3])?'selected':''} >${hh<10?'0':''}${hh}</option>
							</c:forEach>
						</select>시&nbsp;&nbsp;<br/>
						<input type="radio" name="buy_deli_day_type" value="B" class="in_radio" ${data.buy_deli_day_type=='B'?'checked':''}/>
						계약 후<input type="text" name="buy_deli_day_period" class="in_text" style="width:35px;padding:0;" onkeyup="SetNum(this);" value="${data.buy_deli_day_type=='B'?data.buy_deli_day_period:''}" maxlength="3" />일 이내<br />
						<input type="radio" name="buy_deli_day_type" value="C" class="in_radio" ${data.buy_deli_day_type=='C'?'checked':''}/>계약 후 협의 가능<br />
					</td>
				</tr>
				<tr>
					<th scope="row">납품방식</th>
					<td>
						<input type="radio" name="buy_deli_method" value="A" class="in_radio" ${data.buy_deli_method=='A'?'checked':''}/>택배가능
						<input type="radio" name="buy_deli_method" value="B" class="in_radio" ${data.buy_deli_method=='B'?'checked':''}/>업체직납
						<input type="radio" name="buy_deli_method" value="C" class="in_radio" ${data.buy_deli_method=='C'?'checked':''}/>납품 후 설치
					</td>
				</tr>
				<tr>
					<th scope="row">납품장소</th>
					<td><input type="text" name="buy_deli_location" class="in_text" style="width:370px" value="${data.buy_deli_location}" maxlength="100"/></td>
				</tr>
				<tr>
					<th scope="row"><p>결제방식</p></th>
					<td><input type="radio" name="buy_paymethod"  value="A" ${data.buy_paymethod=='A'?'checked':''} />현금
						<input type="radio" name="buy_paymethod"  value="B" ${data.buy_paymethod=='B'?'checked':''}/>카드 &nbsp;(납품/검수후 <input type="text" name="buy_payday" size="2" maxlength="3" value="${data.buy_payday}" onkeyup="SetNum(this);"  style="text-align=right;" class="in_text" />일이내) </td>
				</tr>
				<tr>
					<th scope="row">계약서류</th>
					<td>
						<input type="checkbox" name="" value="checkbox" checked="checked" disabled="disabled" /><strong>기본서류</strong>
						<input type="button" style="width: 90px; height: 20px; line-height: 20px; display: inline-block; padding: 0px;" value="+ 서류 추가선택" class="btn_submit" onclick="ViewLayer();"><br/>
						계약서류 선택 : <strong><span id="paper_text">${fn:replace(data.buy_paper, '|', ' ')}</span></strong> </td>
				</tr>
				</tbody>
			</table>
			<!--구매사테이블-->
			<h4 class="SubTit_blue">구매사정보</h4>
			<table class="tbl_blue mgt5" summary="구매사정보">
				<colgroup>
					<col width="18%" />
					<col width="*" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">구매사명</th>
					<td>${data.mem_com}<input type="hidden" class="in_text" name="mem_com"  style="width:165px" title="구매사명" value="${data.mem_com}"/></td>
				</tr>
				<tr>
					<th scope="row">사양문의<span class="font00">*</span></th>
					<td>
						<table width="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td width="52%"><strong>담 당 자:</strong><input type="text" name="buy_contact"  class="in_text" value="${data.buy_contact}" style="width:80px;"/></td>
								<td width="51%" height="25"><strong>전화번호:</strong>
									<input type="text" name="buy_contact_teld" size="2" maxlength="3" value="${fn:split(data.buy_contact_tel, '-')[0]}" onkeyup="SetNum(this);" class="in_text" />
									- <input type="text" name="buy_contact_tel1" size="4" maxlength="4" value="${fn:split(data.buy_contact_tel, '-')[1]}" onkeyup="SetNum(this);" class="in_text" />
									- <input type="text" name="buy_contact_tel2" size="4" maxlength="4" value="${fn:split(data.buy_contact_tel, '-')[2]}" onkeyup="SetNum(this);" class="in_text"  />
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th width="10%" scope="row">계약담당자<span class="font00">*</span></th>
					<td width="90%"><span style="margin-left: 10">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td width="52%"><strong>담 당 자:</strong>
										<input type="text" name="mem_name"  class="in_text" value="${data.mem_name}"  style="width:80px;"/> <br/>(
										<input type="text" name="mem_name_j"  class="in_text" value="${fn:split(data.mem_part, '/')[0]}"  style="width:60px;"/> /
										<input type="text" name="mem_name_b"  class="in_text" value="${fn:split(data.mem_part, '/')[1]}"  style="width:150px;"/> )
									</td>
									<td width="51%" height="25"><strong>전화번호:</strong>
										<input type="text" name="mem_name_teld"  size="2" maxlength="3" value="${fn:split(data.mem_tel, '-')[0]}" onkeyup="SetNum(this);" class="in_text" /> -
										<input type="text" name="mem_name_tel1"  size="4" maxlength="4" value="${fn:split(data.mem_tel, '-')[1]}" onkeyup="SetNum(this);" class="in_text" /> -
										<input type="text" name="mem_name_tel2"  size="4" maxlength="4" value="${fn:split(data.mem_tel, '-')[2]}" onkeyup="SetNum(this);" class="in_text"  />
									</td>
								</tr>
								<tr>
									<td><strong>이 메 일:</strong> <input type="text" name="mem_name_email"  class="in_text" value="${data.mem_email}" size="35" onblur="emailchk(this);"/></td>
									<td height="25"><strong>팩스번호:</strong><span style="margin-left:10px">
										<input type="text" name="mem_name_faxd"  size="2" maxlength="4" value="${fn:split(data.mem_fax, '-')[0]}" onkeyup="SetNum(this);" class="in_text"/>
										- <input type="text" name="mem_name_fax1"  size="4" maxlength="4" value="${fn:split(data.mem_fax, '-')[1]}" onkeyup="SetNum(this);" class="in_text"/>
										- <input type="text" name="mem_name_fax2"  size="4" maxlength="4" value="${fn:split(data.mem_fax, '-')[2]}" onkeyup="SetNum(this);" class="in_text"/></span>
									</td>
								</tr>
							</table>
					</td>
				</tr>
				</tbody>
			</table>
		</form>
		<table width="100%" class="mgt20">
			<tr>
				<td width="400" align="right"  style="padding: 0px;"></td>
				<td width="258" align="right" style="padding: 2px 0px;">
					<input type="button" style="width: 114px; height: 40px; line-height: 20px; display: inline-block; padding: 0px;" value="입찰등록" class="btn_submit" onclick="upload();" />
					<input type="button" style="width: 114px; height: 40px; line-height: 20px; display: inline-block; padding: 0px;" value="취소" class="btn_submit_g" onclick="goCancel()">
				</td>
			</tr>
		</table>

	</div>
	<!--</div>-->

</div>
<!-- //contents -->



</div>
<!--다음 에디터 스크립트-->
<script type="text/javascript">
	var config = {
		txHost: '',
		txPath: '',
		txService: 'sample',
		txProject: 'sample',
		initializedId: "",
		wrapper: "tx_trex_container",
		form: "f2",                                  /* 등록하기 위한 Form 이름 */
		txIconPath: "/b2b/daum_editor/images/icon/editor/",
		txDecoPath: "/b2b/daum_editor/images/deco/contents/",
		canvas: {
			exitEditor:{
			},
			styles: {
				color: "#123456", /* 기본 글자색 */
				fontFamily: "굴림", /* 기본 글자체 */
				fontSize: "10pt", /* 기본 글자크기 */
				backgroundColor: "#fff", /*기본 배경색 */
				lineHeight: "1.5", /*기본 줄간격 */
				padding: "8px" /* 위지윅 영역의 여백 */
			},
			showGuideArea: false
		},
		events: {
			preventUnload: false
		},
		sidebar: {
			attachbox: {
				show: true,
				confirmForDeleteAll: true
			}
		},
		size: {
			contentWidth: 600 /* 지정된 본문영역의 넓이가 있을 경우에 설정 */
		}
	};

	EditorJSLoader.ready(function(Editor) {
		var editor = new Editor(config);
		Editor.getCanvas().setCanvasSize({height:150});  //에디터 생성시 크기지정
		Editor.modify({   //에디터에 내용 출력
			content: $tx('b_content')
		});
	});

	//Editor.save() 호출후 첫번째 에디터 내용 체크
	function validForm(editor) {
		var validator = new Trex.Validator();
		var content = editor.getContent();
		if (!validator.exists(content)) {
			submitcnt--;
			alert('내용을 입력하세요');
			return false;
		}

		return true;
	}
	//Editor.save() 호출후 두번째 textarea 생성후 내용 세팅
	function setForm(editor) {
		var i, input;
		var form = editor.getForm();
		var content = editor.getContent();

		// 본문 내용을 필드를 생성하여 값을 할당하는 부분
		var textarea = document.createElement('textarea');
		textarea.name = 'etcinfo';      //리퀘스트할 textarea name
		textarea.style.display="none";
		textarea.value = content;
		form.createField(textarea);
		return true;
	}

	//넘어온 도 명에 따라 구군 체크박스 생성
	function searchGu2(cityName, targetId){
		divArea = document.getElementById(targetId);
		var tag="";
		divArea.innerHTML='';

		if (cityName == "강원") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="강릉시"/>강릉시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="고성군"/>고성군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동해시"/>동해시</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="삼척시"/>삼척시</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="속초시"/>속초시</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="양구군"/>양구군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="양양군"/>양양군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="원주시"/>원주시</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="인제군"/>인제군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="정선군"/>정선군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="철원군"/>철원군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="춘천시"/>춘천시</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="태백시"/>태백시</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="평창군"/>평창군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="홍천군"/>홍천군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="화천군"/>화천군</li> ';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="횡성군"/>횡성군</li> ';
		} else if (cityName == "경기") {
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="가평군"/>가평군</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="고양시 덕양구"/>고양시 덕양구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="고양시 일산동구"/>고양시 일산동구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="고양시 일산서구"/>고양시 일산서구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="과천시"/>과천시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="광명시"/>광명시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="광주시"/>광주시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="구리시"/>구리시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="군포시"/>군포시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="김포시"/>김포시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="남양주시"/>남양주시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="동두천시"/>동두천시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="부천시 소사구"/>부천시 소사구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="부천시 오정구"/>부천시 오정구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="부천시 원미구"/>부천시 원미구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="성남시 분당구"/>성남시 분당구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="성남시 수정구"/>성남시 수정구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="성남시 중원구"/>성남시 중원구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="수원시 권선구"/>수원시 권선구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="수원시 영통구"/>수원시 영통구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="수원시 장안구"/>수원시 장안구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="수원시 팔달구"/>수원시 팔달구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="안산시 단원구"/>안산시 단원구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="안산시 상록구"/>안산시 상록구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="안성시"/>안성시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="안양시 동안구"/>안양시 동안구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="안양시 만안구"/>안양시 만안구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="양주시"/>양주시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="양평군"/>양평군</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="여주시"/>여주시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="연천군"/>연천군</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="오산시"/>오산시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="용인시 기흥구"/>용인시 기흥구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="용인시 수지구"/>용인시 수지구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="용인시 처인구"/>용인시 처인구</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="의왕시"/>의왕시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="의정부시"/>의정부시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="이천시"/>이천시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="파주시"/>파주시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="평택시"/>평택시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="포천시"/>포천시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="하남시"/>하남시</li> ';
			tag+='<li class="box02"><input type="checkbox" name="buy_style_C2_2"   value="화성시"/>화성시</li>';
		} else if (cityName == "경남") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="거제시"/>거제시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="거창군"/>거창군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="고성군"/>고성군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="김해시"/>김해시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="남해군"/>남해군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="밀양시"/>밀양시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="사천시"/>사천시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="산청군"/>산청군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="양산시"/>양산시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="의령군"/>의령군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="진주시"/>진주시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="창녕군"/>창녕군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="창원시 마산합포구"/>창원시 마산합포구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="창원시 마산회원구"/>창원시 마산회원구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="창원시 성산구"/>창원시 성산구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="창원시 의창구"/>창원시 의창구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="창원시 진해구"/>창원시 진해구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="통영시"/>통영시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="하동군"/>하동군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="함안군"/>함안군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="함양군"/>함양군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="합천군"/>합천군</li>';
		} else if (cityName == "경북") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="경산시"/>경산시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="경주시"/>경주시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="고령군"/>고령군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="구미시"/>구미시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="군위군"/>군위군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="김천시"/>김천시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="문경시"/>문경시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="봉화군"/>봉화군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="상주시"/>상주시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="성주군"/>성주군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="안동시"/>안동시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영덕군"/>영덕군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영양군"/>영양군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영주시"/>영주시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영천시"/>영천시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="예천군"/>예천군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="울릉군"/>울릉군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="울진군"/>울진군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="의성군"/>의성군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="청도군"/>청도군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="청송군"/>청송군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="칠곡군"/>칠곡군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="포항시 남구"/>포항시 남구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="포항시 북구"/>포항시 북구</li>';
		} else if (cityName == "광주") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="광산구"/>광산구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="남구"/>남구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동구"/>동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="북구"/>북구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서구"/>서구</li>';
		} else if (cityName == "대구") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="남구"/>남구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="달서구"/>달서구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="달성군"/>달성군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동구"/>동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="북구"/>북구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서구"/>서구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="수성구"/>수성구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="중구"/>중구</li>';
		} else if (cityName == "대전") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="대덕구"/>대덕구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동구"/>동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서구"/>서구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="유성구"/>유성구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="중구"/>중구</li>';
		} else if (cityName == "부산") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="강서구"/>강서구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="금정구"/>금정구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="기장군"/>기장군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="남구"/>남구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동구"/>동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동래구"/>동래구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="부산진구"/>부산진구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="북구"/>북구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="사상구"/>사상구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="사하구"/>사하구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서구"/>서구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="수영구"/>수영구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="연제구"/>연제구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영도구"/>영도구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="중구"/>중구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="해운대구"/>해운대구</li>';
		} else if (cityName == "서울") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="강남구"/>강남구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="강동구"/>강동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="강북구"/>강북구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="강서구"/>강서구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="관악구"/>관악구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="광진구"/>광진구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="구로구"/>구로구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="금천구"/>금천구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="노원구"/>노원구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="도봉구"/>도봉구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동대문구"/>동대문구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동작구"/>동작구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="마포구"/>마포구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서대문구"/>서대문구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서초구"/>서초구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="성동구"/>성동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="성북구"/>성북구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="송파구"/>송파구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="양천구"/>양천구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영등포구"/>영등포구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="용산구"/>용산구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="은평구"/>은평구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="종로구"/>종로구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="중구"/>중구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="중랑구"/>중랑구</li>';
		} else if (cityName == "울산") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="남구"/>남구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동구"/>동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="북구"/>북구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="울주군"/>울주군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="중구"/>중구</li>';
		} else if (cityName == "인천") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="강화군"/>강화군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="계양구"/>계양구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="남구"/>남구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="남동구"/>남동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="동구"/>동구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="부평구"/>부평구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서구"/>서구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="연수구"/>연수구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="옹진군"/>옹진군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="중구"/>중구</li>';
		} else if (cityName == "전남") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="강진군"/>강진군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="고흥군"/>고흥군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="곡성군"/>곡성군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="광양시"/>광양시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="구례군"/>구례군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="나주시"/>나주시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="담양군"/>담양군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="목포시"/>목포시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="무안군"/>무안군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="보성군"/>보성군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="순천시"/>순천시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="신안군"/>신안군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="여수시"/>여수시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영광군"/>영광군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영암군"/>영암군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="완도군"/>완도군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="장성군"/>장성군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="장흥군"/>장흥군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="진도군"/>진도군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="함평군"/>함평군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="해남군"/>해남군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="화순군"/>화순군</li>';
		} else if (cityName == "전북") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="고창군"/>고창군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="군산시"/>군산시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="김제시"/>김제시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="남원시"/>남원시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="무주군"/>무주군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="부안군"/>부안군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="순창군"/>순창군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="완주군"/>완주군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="익산시"/>익산시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="임실군"/>임실군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="장수군"/>장수군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="전주시 덕진구"/>전주시 덕진구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="전주시 완산구"/>전주시 완산구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="정읍시"/>정읍시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="진안군"/>진안군</li>';
		} else if (cityName == "제주") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서귀포시"/>서귀포시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="제주시"/>제주시</li>';
		} else if (cityName == "충남") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="계룡시"/>계룡시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="공주시"/>공주시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="금산군"/>금산군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="논산시"/>논산시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="당진시"/>당진시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="보령시"/>보령시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="부여군"/>부여군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서산시"/>서산시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="서천군"/>서천군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="아산시"/>아산시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="예산군"/>예산군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="천안시 동남구"/>천안시 동남구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="천안시 서북구"/>천안시 서북구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="청양군"/>청양군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="태안군"/>태안군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="홍성군"/>홍성군</li>';
		} else if (cityName == "충북") {
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="괴산군"/>괴산군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="단양군"/>단양군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="보은군"/>보은군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="영동군"/>영동군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="옥천군"/>옥천군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="음성군"/>음성군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="제천시"/>제천시</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="증평군"/>증평군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="진천군"/>진천군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="청원군"/>청원군</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="청주시 상당구"/>청주시 상당구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="청주시 흥덕구"/>청주시 흥덕구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="청주시 서원구"/>청주시 서원구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="청주시 청원구"/>청주시 청원구</li>';
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="충주시"/>충주시 ';
		}else if (cityName == "세종"){
			tag+='<li><input type="checkbox" name="buy_style_C2_2"   value="세종시"/>세종시</li>';
		}
		divArea.innerHTML=tag;

		$("input[name='buy_style_C2_2']").each(function(idx, item){
			if("${data.bid_area}" == $("select[name='buy_style_C2_1']").val() && "${data.bid_area2}".includes($(item).val())){
				$(item).prop("checked", true)
			}
		})

	}






</script>
<script type="text/javascript">
	var oEditors = [];
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "contents",
		sSkinURI: "../../../editor/SmartEditor2Skin.html",
		htParams : {bUseToolbar : true,
			fOnBeforeUnload : function(){
				//alert("아싸!");
			}
		}, //boolean
		fOnAppLoad : function(){
			//예제 코드
			//oEditors.getById["contents"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
		},
		fCreator: "createSEditor2"
	});

</script>
</body>
</html>