/** 문자열 함수 시작 *****************************************************************************/
String.prototype.s2_trim=function()
{
	var str=this.replace(/(\s+$)/g,"");
	return str.replace(/(^\s*)/g,"");
}
/** 문자열 함수 종료 *****************************************************************************/


/** 폼 검증 함수 시작 ****************************************************************************/

function s2_search_form_check()
{
	form = document.formSearch;

	if(!s2_radio_is_checked(true, form.search_target)) {alert("검색방법을 설정해주십시오."); return false;}
	if(s2_txt_is_empty(true, form.search_string)) {alert("검색어를 입력하십시오."); return false;}

	form.submit();
}

function s2_is_mb_rrn(s2_focus, s2_element1, s2_element2)   //주민등록번호 체크
{
	var rrn1 = s2_element1.value.s2_trim();
	var rrn2 = s2_element2.value.s2_trim();

	if ((rrn1.length != 6) || (rrn2.length != 7))
	{
		if (s2_focus)
			s2_element1.focus();

		return false;
	}

	var temp_num = new Array(13);
	var last_num,i,j;

	for (i=0 ; i<=5; i++)
		temp_num[i] = rrn1.charAt(i);

	for (j=0 ; j<=7; j++)
	{
		var n = j+6;
		temp_num[n] = rrn2.charAt(j);
	}

	last_num = 11 - ((temp_num[0] *2 +
		temp_num[1] *3 +
		temp_num[2] *4 +
		temp_num[3] *5 +
		temp_num[4] *6 +
		temp_num[5] *7 +
		temp_num[6] *8 +
		temp_num[7] *9 +
		temp_num[8] *2 +
		temp_num[9] *3 +
		temp_num[10]*4 +
		temp_num[11]*5) % 11);

	if (last_num > 9)
		last_num = last_num % 10;

	if (last_num != temp_num[12])
	{
		if (s2_focus)
			s2_element1.focus();

		return false;
	}
	else
		return true;
}

function s2_is_bsn(s2_focus, s2_element1, s2_element2, s2_element3)
{
	var tax_no1 = s2_element1.value.s2_trim();
	var tax_no2 = s2_element2.value.s2_trim();
	var tax_no3 = s2_element3.value.s2_trim();

	var tax_no  = tax_no1 + "" + tax_no2 + "" + tax_no3;

	var step1, step2, step3, step4, step5, step6, step7;
	var chkRule = "137137135";

	if ((tax_no1.length != 3) || (tax_no2.length != 2) || (tax_no3.length != 5))
	{
		if (s2_focus)
			s2_element1.focus();

		return false;
	}

	step1 = 0;

	for (i=0; i<7; i++)
		step1 = step1 + (tax_no.substring(i, i+1) *chkRule.substring(i, i+1));

	step2 = step1 % 10;
	step3 = (tax_no.substring(7, 8) * chkRule.substring(7, 8))% 10;
	step4 = tax_no.substring(8, 9) * chkRule.substring(8, 9);
	step5 = Math.round(step4 / 10 - 0.5);
	step6 = step4 - (step5 * 10);
	step7 = (10 - ((step2 + step3 + step5 + step6) % 10)) % 10;

	if (tax_no.substring(9, 10) != step7)
	{
		if (s2_focus)
			s2_element1.focus();

		return false;
	}
	else
		return true;
}

function s2_txt_is_domain(s2_focus, s2_element)
{
	if (s2_element.value.s2_trim().search(/(\S+)\.(\S+)/) == -1 )
	{
		if (s2_focus && !s2_element.readOnly && !s2_element.disabled)
			s2_element.focus();
		return false;
	}
	else
		return true;
}

function s2_max_length_mobile(s2_element)
{
	if (s2_element.value.length > s2_element.maxLength)
	{
		s2_element.value = s2_element.value.slice(0, s2_element.maxLength);
	}
}

function s2_txt_is_email(s2_focus, s2_element)
{
	if (s2_element.value.s2_trim().search(/(\S+)@(\S+)\.(\S+)/) == -1 )
	{
		if (s2_focus && !s2_element.readOnly && !s2_element.disabled)
			s2_element.focus();
		return false;
	}
	else
		return true;
}

function s2_txt_is_equal(s2_remove, s2_element1, s2_element2)
{
	if (s2_element1.value.s2_trim() != s2_element2.value.s2_trim())
	{
		if (s2_remove)
		{
			s2_element1.value = "";
			s2_element2.value = "";

			if (!s2_element1.readOnly && !s2_element1.disabled)
				s2_element1.focus();
		}

		return false;
	}
	else
		return true;
}

/** 폼 검증 함수 종료 ****************************************************************************/

/** input type=text 관련 스크립트 시작 ***********************************************************/
function s2_txt_is_empty(s2_focus, s2_element) {
	if ((s2_element.value.s2_trim() == "") || (s2_element.value.s2_trim().length <= 0)) {
		s2_element.value = "";

		if (s2_focus && !s2_element.readOnly && !s2_element.disabled) {
			s2_element.focus();
		}

		return true;
	} else{
		return false;
	}
}

function s2_txt_is_length(s2_focus, s2_condition, s2_element)
{
	if (eval("s2_element.value.s2_trim().length " + s2_condition))
	{
		if (s2_focus && !s2_element.readOnly && !s2_element.disabled)
			s2_element.focus();

		return true;
	}
	else
		return false;
}

function s2_txt_is_char_length(s2_element, s2_char) {
	var char_cnt = 0;
	if ((s2_element.value.s2_trim() == "") || (s2_element.value.s2_trim().length <= 0)) {
		char_cnt = 0;
	} else {
		char_length = s2_element.value.s2_trim().length;
		for (i = 0; i < char_length; i++) {
			if (s2_element.value.s2_trim().charAt(i) == s2_char) {
				char_cnt = char_cnt + 1;
			}
		}
	}
	return char_cnt;
}

function s2_txt_last_char_check(s2_element, s2_char) {
	if ((s2_element.value.s2_trim() == "") || (s2_element.value.s2_trim().length <= 0)) {
		return false;
	} else {
		if (s2_element.value.substr(s2_element.value.length-1, 1) == s2_char) {
			return true;
		} else {
			return false;
		}
	}
}
/** input type=text 관련 스크립트 시작 ***********************************************************/

/** input type=radio, checkbox 관련 스크립트 시작 ************************************************/

function s2_radio_is_checked(s2_focus, s2_element)
{
	var is_checked = false;

	if (typeof(s2_element.length) == "undefined")  // 같은 이름의 Radio, Checkbox 가 1개일 경우
	{
		if (s2_element.checked)
			is_checked = true;

		if (s2_focus && !is_checked && !s2_element.readOnly && !s2_element.disabled)
			s2_element.focus();
	}
	else                                            // 같은 이름의 Radio, Checkbox 가 2개 이상일 경우
	{
		for (i=0; i<s2_element.length; i++)
		{
			if (s2_element[i].checked)
				is_checked = true;
		}

		if (s2_focus && !is_checked && !s2_element[0].readOnly && !s2_element.disabled)
			s2_element[0].focus();
	}

	return is_checked;
}

function s2_radio_checked_value(s2_element)
{
	var checked_value = "";

	if (typeof(s2_element.length) == "undefined")  // 같은 이름의 Radio 가 1개일 경우
	{
		if (s2_element.checked)
			checked_value = s2_element.value;
	}
	else                                        // 같은 이름의 Radio 가 2개 이상일 경우
	{
		for (i=0; i<s2_element.length; i++)
		{
			if (s2_element[i].checked)
				checked_value = s2_element[i].value;
		}
	}

	return checked_value;
}

function s2_checkbox_checked_cnt(s2_element)
{
	var checkedNum = 0;

	if (typeof(s2_element.length) == "undefined")  // 같은 이름의 Checkbox 가 1개일 경우
	{
		if (s2_element.checked)
			checkedNum = checkedNum + 1;
	}
	else                                        // 같은 이름의 Checkbox 가 2개 이상일 경우
	{
		for (i=0; i<s2_element.length; i++)
		{
			if (s2_element[i].checked)
				checkedNum = checkedNum + 1;
		}
	}

	return checkedNum;
}

function s2_checkbox_count(s2_element, s2_condition)
{
	/********************************************
	 * s2_element   : 같은 name 을 사용하는 체크박스
	 * s2_condition : 조건
	 - all       : 전체 갯수
	 - checked   : 선택한 체크박스 갯수
	 - unchecked : 선택하지 않은 체크박스 갯수
	 ********************************************/

	if (s2_condition!="all" && s2_condition!="checked" && s2_condition!="unchecked")
	{
		alert("잘못된 접근입니다.")
		return false;
	}

	var countAll       = 0;
	var countChecked   = 0;
	var countUnChecked = 0;

	if (typeof(s2_element.length) == "undefined")   // 같은 이름의 Checkbox 가 1개일 경우
	{
		countAll=1;

		if (s2_element.checked)
			countChecked = 1;
	}
	else                                            // 같은 이름의 Checkbox 가 2개 이상일 경우
	{
		countAll = s2_element.length;

		for (i=0; i<s2_element.length; i++)
		{
			if (s2_element[i].checked)
				countChecked = countChecked + 1;
		}
	}

	countUnChecked = countAll - countChecked;

	switch (s2_condition)
	{
		case "all"       : return countAll;       break;
		case "checked"   : return countChecked;   break;
		case "unchecked" : return countUnChecked; break;
	}
}

function s2_checkbox_check(s2_target, s2_checked)
{
	var s2_status;

	if(s2_checked=="auto")
	{
		if(s2_checkbox_count(s2_target, "unchecked") > 0)
			s2_status=true;     //선택되지 않은게 1개라도 있을 경우 전부 선택
		else
			s2_status=false;    // 모두 선택되었을 경우 전부 해제
	}
	else if(s2_checked===true || s2_checked===false)    // true나 false 일 경우 모두 선택 또는 해제
		s2_status=s2_checked;

	for (i=0; i<s2_target.length; i++)
		s2_target[i].checked=s2_status;

	return s2_status;
}


/** input type=radio, checkbox 관련 스크립트 종료 ************************************************/

/** select 관련 스크립트 시작 ********************************************************************/

function s2_select_is_empty(s2_focus, s2_element)
{
	if ((s2_element.options[s2_element.selectedIndex].value.s2_trim() == "") || (s2_element.options[s2_element.selectedIndex].value.s2_trim().length <= 0))
	{
		if (s2_focus && !s2_element.disabled)
			s2_element.focus();

		return true;
	}
	else
		return false;
}

function s2_select_selected_value(s2_element)
{
	return s2_element.options[s2_element.selectedIndex].value.s2_trim();
}

function s2_select_selected_text(s2_element)
{
	return s2_element.options[s2_element.selectedIndex].text.s2_trim();
}

function s2_select_option_remove(s2_element)
{
	var len=s2_element.options.length-1;

	for (i=len; i>=1; i--)      // Option를 뒤에서 부터 삭제한다. 앞에서 부터 삭제하면 index값 조정이 힘들다.
		s2_element.options.remove(i);

	s2_element.selectedIndex = 0;
}

function s2_select_option_insert(s2_element, s2_code, s2_text)
{
	var oOption;

	oOption = document.createElement("OPTION");
	oOption.value = s2_code;
	oOption.text  = s2_text;

	s2_element.add(oOption);
}

/** select 관련 스크립트 시작 ********************************************************************/

/** 입력중인 값 관련함수 시작 ************************************************************************/

function s2_input_only_number()              // 오직 숫자만 입력
{
	if ((event.keyCode<48)||(event.keyCode>57))  // 숫자(48-57)만 허용
	{
		event.returnValue=false;
		if (event.preventDefault)
		{
			event.preventDefault();
		}
	}
	else
	{
		event.returnValue = true;
	}
}

function s2_input_only_number_check(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) {
		return;
	} else {
		return false;
	}
}

function s2_input_only_remove_char(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) {
		return;
	} else {
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}
}

function s2_input_only_bank_number(s2_element)      // 은행계좌번호 형식 입력 (ex '111-22-33333')
{
	if (((event.keyCode<48)||(event.keyCode>57)) && (event.keyCode!=45))						// 숫자(48-57)와 - (45) 만 입력 허용
	{
		event.returnValue=false;
		if (event.preventDefault)
		{
			event.preventDefault();
		}
	}
	else
	{
		if ((s2_element.value.length == 0) && (event.keyCode==45))                                 // 처음입력시 - (45) 문자 차단
		{
			event.returnValue = false;
			if (event.preventDefault)
			{
				event.preventDefault();
			}
		}
		else if ((s2_element.value.substr(s2_element.value.length-1, 1) == "-") && (event.keyCode==45))		// - (45) 문자 2번 반복 차단
		{
			event.returnValue = false;
			if (event.preventDefault)
			{
				event.preventDefault();
			}
		}
		else
		{
			event.returnValue = true;
		}
	}
}


function s2_input_only_percent(s2_element)      // 퍼센트 형식 입력 (ex '11.25')
{
	if (((event.keyCode<48)||(event.keyCode>57)) && (event.keyCode!=46))						// 숫자(48-57)와 . (46) 만 입력 허용
	{
		event.returnValue=false;
		if (event.preventDefault)
		{
			event.preventDefault();
		}
	}
	else
	{
		if ((s2_element.value.length == 0) && (event.keyCode==46)) // 처음입력시 . (46) 문자 차단
		{
			event.returnValue = false;
			if (event.preventDefault)
			{
				event.preventDefault();
			}
		}
		else if ((s2_element.value.substr(s2_element.value.length-1, 1) == ".") && (event.keyCode==46))		// . (46) 문자 2번 반복 차단
		{
			event.returnValue = false;
			if (event.preventDefault)
			{
				event.preventDefault();
			}
		}
		else if ((s2_element.value.indexOf(".") >-1) && (event.keyCode==46))		// . (46) 문자 2번 입력 차단
		{
			event.returnValue = false;
			if (event.preventDefault)
			{
				event.preventDefault();
			}
		}
		else
		{
			event.returnValue = true;
		}
	}
}

function s2_input_only_bank_number_check(s2_element)  //은행계좌번호가 '-'로 끝날 경우 제거 (ex '123-45-678-' => '123-45-678')
{
	if (s2_element.value.s2_trim().substr(s2_element.value.s2_trim().length-1,1) == "-")
	{
		s2_element.value=s2_element.value.s2_trim().substr(0,s2_element.value.s2_trim().length-1);
	}
}

function s2_move_focus(s2_length, s2_element1, s2_element2)   // Focus 이동
{
	var len = s2_element1.value.s2_trim().length;

	if(s2_length == len)
		s2_element2.focus();
}

function s2_input_number_format_on(s2_element)
{
	var num=s2_element.value;

	num=new String(num);
	num=num.replace(/,/gi,"");

	var sign="";
	if(isNaN(num)) {
		alert("숫자만 입력할 수 있습니다.");
		return 0;
	}

	if(num==0) {
		return num;
	}

	if(num<0){
		num=num*(-1);
		sign="-";
	}
	else{
		num=num*1;
	}
	num = new String(num)
	var temp="";
	var pos=3;
	num_len=num.length;
	while (num_len>0){
		num_len=num_len-pos;
		if(num_len<0) {
			pos=num_len+pos;
			num_len=0;
		}
		temp=","+num.substr(num_len,pos)+temp;
	}

	s2_element.value=sign+temp.substr(1);
}

function s2_input_number_comma(s2_element)
{
	var num = s2_element;
	num = new String(num.value)
	var temp = "";
	var pos = 3;
	num_len = num.length;

	while (num_len>0){
		num_len=num_len-pos;
		if (num_len<0) {
			pos=num_len+pos;
			num_len=0;
		}
		temp = ","+num.substr(num_len,pos)+temp;
	}

	temp = temp.substr(1);

	return temp;

}

function s2_file_img_check(s2_element) {
	var file_name = s2_element1.value.s2_trim();
	var file_parts = file_name.split('.');
	var file_ext = file_parts[file_parts.length - 1];
	switch (file_ext.toLowerCase()) {
		case 'jpg' : return true; break;
		case 'gif' : return true; break;
		case 'png' : return true; break;
		case 'jpeg' : return true; break;
		default : return false;
	}
}

function onlyDecimal(element, event) {
	event = event || window.event;
	var code = (event.which) ? event.which : event.keyCode; // Firefox는 event.which 사용
	if ((code >= 48 && code <= 57) || (code >= 96 && code <= 105) || code == 8 || code == 9 || code == 46 || code == 37 || code == 39 || code == 110 || code == 116 || code == 190) {
		if ((element.value.length == 0) && (code == 110 || code == 190)) { // 처음입력시 . (190) 문자 차단
			event.returnValue = false;
			if (event.preventDefault) {
				event.preventDefault();
			}
		} else if ((element.value.substr(element.value.length - 1, 1) == ".") && (code == 110 || code == 190)) { // . (190) 문자 2번 반복 차단
			event.returnValue = false;
			if (event.preventDefault) {
				event.preventDefault();
			}
		} else if ((element.value.indexOf(".") > -1) && (code == 110 || code == 190)) { // . (190) 문자 2번 입력 차단
			event.returnValue = false;
			if (event.preventDefault) {
				event.preventDefault();
			}
		} else {
			event.returnValue = true;
		}
	} else {
		event.returnValue = false;
	}
}

function removeChar(event) {
	event = event || window.event;

	var code = (event.which) ? event.which : event.keyCode;
	if (code == 8 || code == 46 || code == 37 || code == 39) {
		return;
	} else {
		event.target.value = event.target.value.replace(/[^\.0-9]/g, "");
	}
}

/** 입력중인 값 관련함수 종료 ************************************************************************/

/** blink 관련함수 ************************************************************************/

/**━━ Blink 관련함수 시작 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━**/

function s2_blink()
{
	setInterval( "s2_blink_sub()", 500 ); //속도
}

function s2_blink_sub()
{
	var blinkArr = document.getElementsByTagName("BLINK");
	var blinkCnt = blinkArr.length;
	for( var i=0; i<blinkCnt; i++ )
	{
		blinkArr[i].style.visibility = (blinkArr[i].style.visibility == "hidden") ? "" : "hidden";
	}
}

/**━━ Blink 관련함수 종료 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━**/

/**━━ Cookie 관련함수 시작 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━**/

function s2_cookie_set_expire_date(year,day,hour,minute,second)
{
	var today = new Date();
	var exprs = new Date();
	exprs.setTime( today.getTime()
		+1000*60*60*24*365*year
		+1000*60*60*24    *day
		+1000*60*60       *hour
		+1000*60          *minute
		+1000             *second );
	return exprs;
}

function s2_cookie_set(name,value,expires,path,domain,secure)
{
	document.cookie =   name + '=' + escape(value)         + ';'       +
		((expires) ? ' expires='  + expires.toGMTString() + ';' : '') +
		((path)    ? ' path='     + path                  + ';' : '') +
		((domain)  ? ' domain='   + domain                + ';' : '') +
		((secure)  ? ' secure'                            + ';' : '');
}

// Returns a string or false
function s2_cookie_get(name)
{
	var srch = name + '=';
	if (document.cookie.length > 0)
	{
		offset = document.cookie.indexOf(srch);
		if (offset != -1)
		{
			offset += srch.length;
			end = document.cookie.indexOf(';', offset);
			if (end == -1)
				end = document.cookie.length;

			return unescape(document.cookie.substring(offset, end));
		}
		else
			return '';
	}
	else
		return '';
}

// Optional: path,domain
function s2_cookie_delete(name,path,domain)
{
	if (s2_cookie_get(name))
	{
		document.cookie = name                + '=;'             +
			' expires=Thu, 01-Jan-70 00:00:01 GMT;'  +
			((path)   ? ' path='    + path    + ';' : '')        +
			((domain) ? ' domain='  + domain  + ';' : '');
	}
}

/**━━ Cookie 관련함수 종료 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━**/


/** 날짜관련 함수 : 시작 ***************************************************************************************************/

function s2_date_text2time(timeString)          //Time 스트링을 자바스크립트 Date 객체로 변환
{                                               //Parameter time: Time 형식의 String (고정폭 년월일시분초)
	var chkPattern = /-/g;                      //ex) 2005-01-02 또는 20050102 : '-' 사용은 편한대로
	var chkString  = timeString.replace(chkPattern, "")

	var chkYear  = chkString.substr(0,4);
	var chkMonth = chkString.substr(4,2) - 1;   // 1월=0,12월=11
	var chkDay   = chkString.substr(6,2);

	return new Date(chkYear, chkMonth, chkDay);
}

function s2_date_time2text(chkDate)             //Date 객체를 TimeString(ex 2005-01-02)로 변경
{
	var chkYear  = chkDate.getFullYear();
	var chkMonth = chkDate.getMonth() + 1;      //1월=0,12월=11이므로 1 더함
	var chkDay   = chkDate.getDate();

	if (("" + chkMonth).length == 1) { chkMonth = "0" + chkMonth; }
	if (("" + chkDay).length   == 1) { chkDay   = "0" + chkDay;   }

	return (chkYear + "-" + chkMonth + "-" + chkDay)
}

function s2_date_time3text(chkDate)             //Date 객체를 TimeString(ex 20050102)로 변경
{
	var chkYear  = chkDate.getFullYear();
	var chkMonth = chkDate.getMonth() + 1;      //1월=0,12월=11이므로 1 더함
	var chkDay   = chkDate.getDate();

	if (("" + chkMonth).length == 1) { chkMonth = "0" + chkMonth; }
	if (("" + chkDay).length   == 1) { chkDay   = "0" + chkDay;   }

	return (chkYear + "" + chkMonth + "" + chkDay)
}

function s2_date_add(chkString, yy, mo, dd)     //문자열 받아서 문자열로 반환
{                                               //ex) 2007-01-01 + 2개월 => 2007-03-01
	if (typeof(yy) == "undefined") yy=0;
	if (typeof(mo) == "undefined") mo=0;
	if (typeof(dd) == "undefined") dd=0;

	var date = s2_date_text2time(chkString);

	date.setFullYear(date.getFullYear() + yy);  //yy년을 더함
	date.setMonth(date.getMonth()       + mo);  //mo월을 더함
	date.setDate(date.getDate()         + dd);  //dd일을 더함

	return s2_date_time2text(date);
}

function s2_date_term_month(time1, time2)       //measureMonthInterval(time1,time2)
{                                               //두 Time이 몇 개월 차이나는지 구함
	var date1 = s2_date_text2time(time1);
	var date2 = s2_date_text2time(time2);

	var years  = date2.getFullYear() - date1.getFullYear();
	var months = date2.getMonth() - date1.getMonth();
	var days   = date2.getDate() - date1.getDate();

	return (years * 12 + months + (days >= 0 ? 0 : -1) );
}

/** 생년월일 유효성 체크 */
function s2_isValidDate_birth(iDate) {
	if( iDate.length != 8 ) {
		return false;
	}

	oDate = new Date();

	if( parseInt(s2_date_time3text(oDate)) < parseInt(iDate) ) {	/*현재 년도와 비교 */
		return false;
	}

	if(!s2_isValidDate(iDate)) {	/* 날짜 형식 유효성 */
		return false;
	}

	return true;
}
/**yyyymmdd 형식의 날짜값을 입력받아서 유효한 날짜인지 체크한다. ex) isValidDate("20070415"); */
function s2_isValidDate(iDate) {
	if( iDate.length != 8 ) {
		return false;
	}

	month_int = parseInt(iDate.substring(4, 6), 10);
	month_value = month_int - 1;
	oDate = new Date();
	oDate.setFullYear( iDate.substring(0, 4));
	oDate.setMonth(month_value);
	oDate.setDate(parseInt(iDate.substring(6), 10));
	oDate_getYear = oDate.getFullYear();
	oDate_getDate = oDate.getDate();
	if (oDate.getMonth() == 2 || oDate.getMonth() == 4 || oDate.getMonth() == 6 || oDate.getMonth() == 9 || oDate.getMonth() == 11 )
	{
		if (month_value == 2 || month_value == 4 || month_value == 6 || month_value == 9 || month_value == 11 )
		{
			oDate_getMonth = oDate.getMonth() + 1;
		}
		else
		{
			oDate_getMonth = oDate.getMonth();
		}
	}
	else
	{
		oDate_getMonth = oDate.getMonth() + 1;
	}

	if( oDate_getYear     != iDate.substring(0, 4)
		|| oDate_getMonth != parseInt(iDate.substring(4, 6), 10)
		|| oDate_getDate      != parseInt(iDate.substring(6), 10) ) {


		return false;
	}

	return true;
}


/** 날짜관련 함수 : 종료 ***************************************************************************************************/

function s2_window_open_center(popUrl, popName, popWidth, popHeight, popAddFeatures)
{
	var popTop  = (screen.availHeight - popHeight) / 2;
	var popLeft = (screen.availWidth  - popWidth)  / 2;

	if (popAddFeatures)
		var popFeatures = "top="+popTop+", left="+popLeft+", width="+popWidth+", height="+popHeight+", "+popAddFeatures;
	else
		var popFeatures = "top="+popTop+", left="+popLeft+", width="+popWidth+", height="+popHeight;

	window.open(popUrl, popName, popFeatures);
}

function s2_movie_play(chkUrl, chkWidth, chkHeight)
{
	var s2_element_width  = (chkWidth  ? chkWidth  : 320);
	var s2_element_height = (chkHeight ? chkHeight : 240) + 67; // 플레이어 버튼영역

	str = "<object id=\"MovePlay\" width="+s2_element_width+" height="+s2_element_height+" viewastext style=\"z-index:1\" classid=\"CLSID:22D6f312-B0F6-11D0-94AB-0080C74C7E95\" codebase=\"http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701\" standby=\"Loading Microsoft Windows Media Player components...\" type=\"application/x-oleobject\">"
		+ "  <param name=\"FileName\"           value=\""+chkUrl+"\">"
		+ "  <param name=\"ANIMATIONATSTART\"   value=\"1\">"
		+ "  <param name=\"AUTOSTART\"          value=\"1\">"
		+ "  <param name=\"BALANCE\"            value=\"0\">"
		+ "  <param name=\"CURRENTMARKER\"      value=\"0\">"
		+ "  <param name=\"CURRENTPOSITION\"    value=\"0\">"
		+ "  <param name=\"DISPLAYMODE\"        value=\"4\">"
		+ "  <param name=\"ENABLECONTEXTMENU\"  value=\"0\">"
		+ "  <param name=\"ENABLED\"            value=\"1\">"
		+ "  <param name=\"FULLSCREEN\"         value=\"0\">"
		+ "  <param name=\"INVOKEURLS\"         value=\"1\">"
		+ "  <param name=\"PLAYCOUNT\"          value=\"1\">"
		+ "  <param name=\"RATE\"               value=\"1\">"
		+ "  <param name=\"SHOWCONTROLS\"       value=\"1\">"
		+ "  <param name=\"SHOWSTATUSBAR\"      value=\"-1\">"
		+ "  <param name=\"STRETCHTOFIT\"       value=\"0\">"
		+ "  <param name=\"TRANSPARENTATSTART\" value=\"1\">"
		+ "  <param name=\"UIMODE\"             value=\"FULL\">"
		+ "  <param name=\"displaybackcolor\"   value=\"0\">"
		+ "</object>"

	document.write(str);
}


function setCookie( name, value, expiredays )
{
	var todayDate = new Date();
	todayDate.setDate( todayDate.getDate() + expiredays );
	document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}

function getCookie(name)
{
	var nameOfCookie = name + "=";
	var x = 0;
	while ( x <= document.cookie.length )
	{
		var y = (x+nameOfCookie.length);
		if ( document.cookie.substring( x, y ) == nameOfCookie )
		{
			if ( (endOfCookie=document.cookie.indexOf( ";", y )) == -1 )
				endOfCookie = document.cookie.length;
			return unescape( document.cookie.substring( y, endOfCookie ));
		}
		x = document.cookie.indexOf( " ", x ) + 1;
		if ( x == 0 )
			break;
	}
	return "";
}

function bookmarksite(title,url) {
	// Internet Explorer

	if(document.all)
	{
		window.external.AddFavorite(url, title);
	}
	// Google Chrome
	else if(window.chrome){
		alert("Ctrl+D키를 누르시면 즐겨찾기에 추가하실 수 있습니다.");
	}
	// Firefox
	else if (window.sidebar) // firefox
	{
		window.sidebar.addPanel(title, url, "");
	}
	// Opera
	else if(window.opera && window.print)
	{ // opera
		var elem = document.createElement('a');
		elem.setAttribute('href',url);
		elem.setAttribute('title',title);
		elem.setAttribute('rel','sidebar');
		elem.click();
	}
}

function searchGu2(cityName, targetId){
	divArea = document.getElementById(targetId);
	var tag="";
	divArea.innerHTML='';

	if (cityName == "강원") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'강릉시\');return false;\">강릉시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'고성군\');return false;\">고성군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동해시\');return false;\">동해시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'삼척시\');return false;\">삼척시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'속초시\');return false;\">속초시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'양구군\');return false;\">양구군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'양양군\');return false;\">양양군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'원주시\');return false;\">원주시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'인제군\');return false;\">인제군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'정선군\');return false;\">정선군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'철원군\');return false;\">철원군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'춘천시\');return false;\">춘천시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'태백시\');return false;\">태백시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'평창군\');return false;\">평창군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'홍천군\');return false;\">홍천군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'화천군\');return false;\">화천군</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'횡성군\');return false;\">횡성군</a></span></li> ';
		tag+='</ul>';

	} else if (cityName == "경기") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'가평군\');return false;\">가평군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'고양시 덕양구\');return false;\">고양시 덕양구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'고양시 일산동구\');return false;\">고양시 일산동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'고양시 일산서구\');return false;\">고양시 일산서구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'과천시\');return false;\">과천시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'광명시\');return false;\">광명시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'광주시\');return false;\">광주시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'구리시\');return false;\">구리시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'군포시\');return false;\">군포시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'김포시\');return false;\">김포시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남양주시\');return false;\">남양주시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동두천시\');return false;\">동두천시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'부천시 소사구\');return false;\">부천시 소사구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'부천시 오정구\');return false;\">부천시 오정구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'부천시 원미구\');return false;\">부천시 원미구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'성남시 분당구\');return false;\">성남시 분당구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'성남시 수정구\');return false;\">성남시 수정구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'성남시 중원구\');return false;\">성남시 중원구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'수원시 권선구\');return false;\">수원시 권선구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'수원시 영통구\');return false;\">수원시 영통구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'수원시 장안구\');return false;\">수원시 장안구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'수원시 팔달구\');return false;\">수원시 팔달구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'안산시 단원구\');return false;\">안산시 단원구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'안산시 상록구\');return false;\">안산시 상록구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'안양시 동안구\');return false;\">안양시 동안구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'안양시 만안구\');return false;\">안양시 만안구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'용인시 기흥구\');return false;\">용인시 기흥구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'용인시 수지구\');return false;\">용인시 수지구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'용인시 처인구\');return false;\">용인시 처인구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'의왕시\');return false;\">의왕시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'의정부시\');return false;\">의정부시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'이천시\');return false;\">이천시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'파주시\');return false;\">파주시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'평택시\');return false;\">평택시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'포천시\');return false;\">포천시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'하남시\');return false;\">하남시</a></span></li> ';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'화성시\');return false;\">화성시</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "경남") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'거제시\');return false;\">거제시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'거창군\');return false;\">거창군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'고성군\');return false;\">고성군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'김해시\');return false;\">김해시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남해군\');return false;\">남해군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'밀양시\');return false;\">밀양시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'사천시\');return false;\">사천시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'산청군\');return false;\">산청군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'양산시\');return false;\">양산시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'의령군\');return false;\">의령군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'진주시\');return false;\">진주시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'창녕군\');return false;\">창녕군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'창원시 마산합포구\');return false;\">창원시 마산합포구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'창원시 마산회원구\');return false;\">창원시 마산회원구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'창원시 성산구\');return false;\">창원시 성산구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'창원시 의창구\');return false;\">창원시 의창구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'창원시 진해구\');return false;\">창원시 진해구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'통영시\');return false;\">통영시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'하동군\');return false;\">하동군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'함안군\');return false;\">함안군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'함양군\');return false;\">함양군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'합천군\');return false;\">합천군</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "경북") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'경산시\');return false;\">경산시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'경주시\');return false;\">경주시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'고령군\');return false;\">고령군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'구미시\');return false;\">구미시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'군위군\');return false;\">군위군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'김천시\');return false;\">김천시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'문경시\');return false;\">문경시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'봉화군\');return false;\">봉화군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'상주시\');return false;\">상주시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'성주군\');return false;\">성주군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'안동시\');return false;\">안동시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영덕군\');return false;\">영덕군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영양군\');return false;\">영양군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영주시\');return false;\">영주시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영천시\');return false;\">영천시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'예천군\');return false;\">예천군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'울릉군\');return false;\">울릉군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'울진군\');return false;\">울진군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'의성군\');return false;\">의성군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'청도군\');return false;\">청도군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'청송군\');return false;\">청송군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'칠곡군\');return false;\">칠곡군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'포항시 남구\');return false;\">포항시 남구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'포항시 북구\');return false;\">포항시 북구</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "광주") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'광산구\');return false;\">광산구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남구\');return false;\">남구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동구\');return false;\">동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'북구\');return false;\">북구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서구\');return false;\">서구</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "대구") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남구\');return false;\">남구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'달서구\');return false;\">달서구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'달성군\');return false;\">달성군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동구\');return false;\">동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'북구\');return false;\">북구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서구\');return false;\">서구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'수성구\');return false;\">수성구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'중구\');return false;\">중구</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "대전") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'대덕구\');return false;\">대덕구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동구\');return false;\">동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서구\');return false;\">서구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'유성구\');return false;\">유성구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'중구\');return false;\">중구</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "부산") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'강서구\');return false;\">강서구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'금정구\');return false;\">금정구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'기장군\');return false;\">기장군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남구\');return false;\">남구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동구\');return false;\">동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동래구\');return false;\">동래구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'부산진구\');return false;\">부산진구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'북구\');return false;\">북구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'사상구\');return false;\">사상구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'사하구\');return false;\">사하구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서구\');return false;\">서구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'수영구\');return false;\">수영구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'연제구\');return false;\">연제구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영도구\');return false;\">영도구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'중구\');return false;\">중구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'해운대구\');return false;\">해운대구</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "서울") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'강남구\');return false;\">강남구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'강동구\');return false;\">강동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'강북구\');return false;\">강북구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'강서구\');return false;\">강서구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'관악구\');return false;\">관악구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'광진구\');return false;\">광진구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'구로구\');return false;\">구로구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'금천구\');return false;\">금천구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'노원구\');return false;\">노원구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'도봉구\');return false;\">도봉구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동대문구\');return false;\">동대문구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동작구\');return false;\">동작구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'마포구\');return false;\">마포구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서대문구\');return false;\">서대문구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서초구\');return false;\">서초구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'성동구\');return false;\">성동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'성북구\');return false;\">성북구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'송파구\');return false;\">송파구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'양천구\');return false;\">양천구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영등포구\');return false;\">영등포구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'용산구\');return false;\">용산구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'은평구\');return false;\">은평구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'종로구\');return false;\">종로구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'중구\');return false;\">중구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'중랑구\');return false;\">중랑구</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "울산") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남구\');return false;\">남구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동구\');return false;\">동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'북구\');return false;\">북구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'울주군\');return false;\">울주군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'중구\');return false;\">중구</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "인천") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'강화군\');return false;\">강화군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'계양구\');return false;\">계양구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남구\');return false;\">남구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남동구\');return false;\">남동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'동구\');return false;\">동구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'부평구\');return false;\">부평구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서구\');return false;\">서구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'연수구\');return false;\">연수구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'옹진군\');return false;\">옹진군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'중구\');return false;\">중구</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "전남") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'강진군\');return false;\">강진군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'고흥군\');return false;\">고흥군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'곡성군\');return false;\">곡성군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'광양시\');return false;\">광양시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'구례군\');return false;\">구례군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'나주시\');return false;\">나주시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'담양군\');return false;\">담양군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'목포시\');return false;\">목포시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'무안군\');return false;\">무안군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'보성군\');return false;\">보성군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'순천시\');return false;\">순천시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'신안군\');return false;\">신안군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'여수시\');return false;\">여수시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영광군\');return false;\">영광군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영암군\');return false;\">영암군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'완도군\');return false;\">완도군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'장성군\');return false;\">장성군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'장흥군\');return false;\">장흥군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'진도군\');return false;\">진도군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'함평군\');return false;\">함평군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'해남군\');return false;\">해남군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'화순군\');return false;\">화순군</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "전북") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'고창군\');return false;\">고창군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'군산시\');return false;\">군산시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'김제시\');return false;\">김제시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'남원시\');return false;\">남원시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'무주군\');return false;\">무주군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'부안군\');return false;\">부안군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'순창군\');return false;\">순창군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'완주군\');return false;\">완주군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'익산시\');return false;\">익산시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'임실군\');return false;\">임실군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'장수군\');return false;\">장수군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'전주시 덕진구\');return false;\">전주시 덕진구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'전주시 완산구\');return false;\">전주시 완산구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'정읍시\');return false;\">정읍시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'진안군\');return false;\">진안군</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "제주") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서귀포시\');return false;\">서귀포시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'제주시\');return false;\">제주시</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "충남") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'계룡시\');return false;\">계룡시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'공주시\');return false;\">공주시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'금산군\');return false;\">금산군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'논산시\');return false;\">논산시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'당진시\');return false;\">당진시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'보령시\');return false;\">보령시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'부여군\');return false;\">부여군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서산시\');return false;\">서산시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'서천군\');return false;\">서천군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'아산시\');return false;\">아산시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'예산군\');return false;\">예산군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'천안시 동남구\');return false;\">천안시 동남구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'천안시 서북구\');return false;\">천안시 서북구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'청양군\');return false;\">청양군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'태안군\');return false;\">태안군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'홍성군\');return false;\">홍성군</a></span></li>';
		tag+='</ul>';

	} else if (cityName == "충북") {
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'괴산군\');return false;\">괴산군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'단양군\');return false;\">단양군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'보은군\');return false;\">보은군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'영동군\');return false;\">영동군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'옥천군\');return false;\">옥천군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'음성군\');return false;\">음성군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'제천시\');return false;\">제천시</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'증평군\');return false;\">증평군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'진천군\');return false;\">진천군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'청원군\');return false;\">청원군</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'청주시 상당구\');return false;\">청주시 상당구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'청주시 흥덕구\');return false;\">청주시 흥덕구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'청주시 서원구\');return false;\">청주시 서원구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'청주시 청원구\');return false;\">청주시 청원구</a></span></li>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'충주시\');return false;\">충주시</a></span></li>';
		tag+='</ul>';

	}else if (cityName == "세종"){
		tag+='<ul>';
		tag+='<li><span><a href=\"#\" onclick=\"addgugun(\'세종시\');return false;\">세종시</a></span></li>';
		tag+='</ul>';
	}
	divArea.innerHTML=tag;
}

function isEmpty(value){
	if(value.length == 0 || value == null){
		return true;
	}else{
		return false;
	}
}

function isNumeric(value){
	var regExp = /^[0-9]+$/g;
	return regExp.test(value);
}

// 소수 2자리까지
function isPrimeNumeric(evt){
	var charCode = (evt.which) ? evt.which : evt.keyCode;
	var _value = event.srcElement.value;

	if (charCode < 48 || charCode > 57) {
		if (charCode != 46) { // 숫자와 . 만 입력가능
			return false;
		}
	}

	var _pattern0 = /^\d*[.]\d*$/; // 현재 value에 소수점(.) 이 있으면 . 입력불가
	if (_pattern0.test(_value)) {
		if (charCode == 46) {
			return false;
		}
	}

	// 두자리 이하의 숫자만 입력가능
	var _pattern1 = /^\d{2}$/; // 현재 value가 2자리 숫자이면 . 만 입력가능
	// {숫자}의 값을 변경하면 자리수를 조정할 수 있다.
	if (_pattern1.test(_value)) {
		if (charCode != 46) {
			alert("두자리 이하의 숫자만 입력가능합니다.");
			return false;
		}
	}

	// 소수점 둘째자리까지만 입력가능
	var _pattern2 = /^\d*[.]\d{2}$/; // 현재 value가 소수점 둘째자리 숫자면 더이상 입력불가
	if (_pattern2.test(_value)) {
		alert("소수점 둘째자리까지만 입력가능합니다.");
		return false;
	}

	return true;
}

function currencyFormatter(amount){
	return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g,',');
}

function numberBlur(el){
	var val = $(el).val();
	if(!isEmpty(val) && isNumeric(val)){
		val = currencyFormatter(val);
		$(el).val(val);
	}
}

function inputNumberAutoComma(obj) {

	// 콤마( , )의 경우도 문자로 인식되기때문에 콤마를 따로 제거한다.
	var deleteComma = obj.value.replace(/\,/g, "");

	// 콤마( , )를 제외하고 문자가 입력되었는지를 확인한다.
	if(isFinite(deleteComma) == false) {
		alert("문자는 입력하실 수 없습니다.");
		obj.value = "";
		return false;
	}

	// 기존에 들어가있던 콤마( , )를 제거한 이 후의 입력값에 다시 콤마( , )를 삽입한다.
	obj.value = inputNumberWithComma(inputNumberRemoveComma(obj.value));
}

// 천단위 이상의 숫자에 콤마( , )를 삽입하는 함수
function inputNumberWithComma(str) {

	str = String(str);
	return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, "$1,");
}

// 콤마( , )가 들어간 값에 콤마를 제거하는 함수
function inputNumberRemoveComma(str) {

	str = String(str);
	return str.replace(/[^\d]+/g, "");
}

function hangul(){ //한글 입력(onkeyPress)
	if((event.keyCode < 12592) || (event.keyCode > 12687)){
		event.returnValue = false;
	}
}

function summernoteSet (id){
	$("#"+id).summernote({
		tabsize: 2,
		height: 750,
		lang: "ko-KR",
		toolbar: [
			// [groupName, [list of button]]
			['fontname', ['fontname']],
			['fontsize', ['fontsize']],
			['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
			['color', ['forecolor','color']],
			['table', ['table']],
			['para', ['ul', 'ol', 'paragraph']],
			['height', ['height']],
			['insert',['picture','link','video']],
			['view', ['codeview','help']]
		],
		fontNames: ['Arial', 'Arial Black', 'Comic Sans MS', 'Courier New','맑은 고딕','궁서','굴림체','굴림','돋움체','바탕체'],
		fontSizes: ['8','9','10','11','12','14','16','18','20','22','24','28','30','36','50','72'] ,
		callbacks: {
			onImageUpload: function(files, editor, welEditable) {
				for (var i = files.length - 1; i >= 0; i--) {
					summernotSendFile(files[i], $("#"+id));
				}
			}
		}
	});
}

function summernotSendFile(file, el) {
	var form_data = new FormData();
	form_data.append('file', file);
	$.ajax({
		data: form_data,
		type: "POST",
		url: '/master/file/editorUpload.json',
		cache: false,
		contentType: false,
		enctype: 'multipart/form-data',
		processData: false,
		success: function (data) {
			if (data.success) {
				$(el).summernote('editor.insertImage', data.resultMap.contextPathFile);
				console.log(data.resultMap);
				$('#imageBoard > ul').append('<li><img src="'+data.resultMap.contextPathFile+'" width="480" height="auto"/></li>');
			} else {
				alert("오류가 발생하였습니다." + data.message);
			}
		}
	});
}