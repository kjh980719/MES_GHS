var filter = "win16|win32|win64|mac";
var _isMobile = false;	//모바일 여부 체크
if (navigator.platform) {
	if (0 > filter.indexOf(navigator.platform.toLowerCase())) {
		_isMobile = true;
	} else {
		_isMobile = false;
	}
}

function showLayer(layerID, layerHeight) {
	var innerLayer = $("#" + layerID);

	if ($("#backgroundLayer").length == 0) {
		$("body").append($("<div/>").attr("id", "backgroundLayer")
									.css({
										"position": "fixed"
									, "background": "#000"
									, "width": "100%"
									, "height": "100%"
									, "top": 0
									, "left": 0
									, "-ms-filter": "\"progid:DXImageTransform.Microsoft.Alpha(opacity=30)\""
									, "filter": "progid:DXImageTransform.Microsoft.Alpha(opacity=30)"
									, "opacity": "0.3"
									, "-moz-opacity": "0.3"
									, "z-index": "9000"
									, "overflow": "hidden"
									, "display": "none"
									})
		);
	}

	var width = innerLayer.width();
	var marginLeft = width / 2;
	var height, marginTop;

	if (layerHeight != null) {
		if (layerHeight.toString().indexOf("%") > -1)
			height = $(window).height() * (layerHeight.split("%")[0] / 100)
		else
			height = layerHeight;
	} else {
		innerLayer.css("height", "auto");
		height = innerLayer.height() + 3;
	}

	marginTop = height / 2

	innerLayer.css({
		"position": "fixed"
		, "display": "none"
		, "background": "#FFF"
		, "width": width + "px"
		, "height": height + "px"
		, "left": "50%"
		, "top": "50%"
		, "margin-left": -marginLeft + "px"
		, "margin-top": -marginTop + "px"
		, "overflow": "hidden"
		, "-webkit-overflow-scrolling": "touch"
		, "z-index": "9001"
	});

	//백그라운드에서의 움직임을 방지
	$("html, body").css({ "overflow-y": "hidden" });

	$("#backgroundLayer").show();
	innerLayer.show();
}

function hideLayer(layerID) {
	var innerLayer = $("#" + layerID);
	$("#backgroundLayer").hide();
	innerLayer.hide();
	$("html, body").css({ "overflow-y": "auto" });
}

function getLayerTop(height){
	var innerHeight = ($(window).height() - height)/2;
	if (innerHeight < 0)
		innerHeight = 10;
	var top = $(window).scrollTop() + innerHeight;
	
	return top;
}

function getObjTop(objID){
	var height = $("#" + objID).height()
	return getLayerTop(height);
}

/* 콤마 허용 */
function onlyMoney(obj) {
	if (_isMobile) {
		onlyNumber(obj);
	} else {
		var oElement = obj;
		var charChk;

		for (var i = 0; i < oElement.value.length; i++) {
			charChk = oElement.value.charCodeAt(i);
			if ((charChk > 57 || charChk < 48) && charChk != 44 && charChk != 45) {
				alert("공백없이 숫자로만 입력해주세요.");
				oElement.value = oElement.value.substring(0, i);
				oElement.focus();
				return;
			} else {
				if (charChk == 45 && i != 0) {
					alert("음수표시( - )는 첫 자리수에만 올 수 있습니다.");
					oElement.value = oElement.value.substring(0, i);
					oElement.focus();
					return;
				}
			}
		}

		obj.value = obj.value.split(",").join("").money();
	}
}

/* 소숫점 허용 */
function onlyFloat(obj) {
	var oElement = obj;
	var charChk;

	for (var i = 0; i < oElement.value.length; i++) {
		charChk = oElement.value.charCodeAt(i);
		if ((charChk > 57 || charChk < 48) && charChk != 46) {
			alert("공백없이 숫자로만 입력해주세요.");
			oElement.value = oElement.value.substring(0, i);
			oElement.focus();
			return;
		}
	}
}

function onlyNumber() {
	var oElement = (arguments[0] != null) ? arguments[0] : this;
	var charChk;

	for (var i = 0; i < oElement.value.length; i++) {
		charChk = oElement.value.charCodeAt(i);
		if (charChk > 57 || charChk < 48) {
			alert("공백없이 숫자로만 입력해주세요.");
			oElement.value = oElement.value.substring(0, i);
			oElement.focus();
			return;
		}
	}
}
	
function autoHeight(obj, defaultHeight){
	var height = obj.scrollHeight;
	var thisObjHeight = 115;	//기본 높이값
	
	if (defaultHeight != null)
		thisObjHeight = defaultHeight;
	
	if (height > thisObjHeight)
		$(obj).css("height",obj.scrollHeight + "px");
	else
		$(obj).css("height",thisObjHeight + "px");
}
	
function ContentHeightCK(objID){
	var content = $("#" + objID);
	
	if (content.css("height").toLowerCase().replace("px","") < content.attr("scrollHeight"))
		content.css("height",content.attr("scrollHeight") + "px");
}
	
var maxTable = 0;
function autoScroll(tableID){
	var s_Table = $("#" + tableID).html().toLowerCase().split("</table>");
	$("#" + tableID + "_view").empty();
	
	for( var i=0;i<s_Table.length;i++){
		if (s_Table[i] != ""){
			$("#" + tableID + "_view").append(s_Table[i] + "</table>")
			window.setTimeout("fadeTable("+i+", '" + tableID + "')", (i*2000));
		}
	}
	maxTable = s_Table.length;
}

function fadeTable(i, tableID){
	if (i != 0 && i%3 == 0){
		$("#" + tableID + "_view table").each(function(e){
			if (e < i)
				$(this).css("display","none");
		})
	}
		
	$($("#" + tableID + "_view table")[i]).fadeIn("slow");
	
	if ((maxTable-2) == i){
		window.setTimeout("autoScroll('" + tableID + "')", 2000);
	}
}

function fGetXY(aTag){ 
	var oTmp = aTag; 
	var pt = new Point(0,0); 
	do { 
			pt.x += oTmp.offsetLeft; 
			pt.y += oTmp.offsetTop; 
			oTmp = oTmp.offsetParent; 
	} while(oTmp.tagName!="BODY" && oTmp.tagName!="HTML"); 
	return pt; 
}

function Point(iX, iY){ 
	this.x = iX; 
	this.y = iY; 
}

// 문자열 속성

//숫자 3자리마다 쉼표 추가
String.prototype.money = function() {
    var num = this.trim();

    while ((/(-?[0-9]+)([0-9]{3})/).test(num)) {
        num = num.replace((/(-?[0-9]+)([0-9]{3})/), "$1,$2");
    }

    return num;
};

//공백제거
String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "");
};

//공백제거
String.prototype.Trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "");
};

//특정 수만큼 0 채움
String.prototype.digits = function(cnt) {
	var digit = "";

	if (this.length < cnt) {
		for(var i = 0; i < cnt - this.length; i++) {
			digit += "0";
		}
	}

	return digit + this;
};

//글쓰기 체크
function max_write(maxByte, obj) {
	var temp;
	var maxLen = maxByte;

	var len = obj.value.length;

	for (i = 0; i < len; i++) {
		temp = obj.value.charAt(i);

		if (escape(temp).length > 4)
			maxLen -= 2;
		else
			maxLen--;

		if (maxLen < 0) {
			alert("내용은 영문 " + maxByte + "자, 한글 " + maxByte / 2 + "자 이내로 작성하셔야 합니다.");
			obj.value = obj.value.substring(0, i);
			obj.focus();
			break;
		}
	}
}

//길이체크
function maxlength_check(maxlen, obj, returnYN) {
	var len = obj.value.length;
	var result;
	
	if (len > maxlen){
		alert(maxlen + "자 이상 작성하실 수 없습니다.");
		obj.value = obj.value.substring(0,maxlen);
		result = false;
	} else
		result = true;
		
	if (returnYN != null && returnYN)
		return result;
}

//pos.x x좌표, pos.y y좌표
function cfGetEventPosition(evt) {
	var e = evt || window.event;
	var b = document.body;
	var scroll = cfGetScrollOffset();
	var pos = {
 			x : e.pageX || e.clientX+scroll.x-b.clientLeft,
			y : e.pageY || e.clientY+scroll.y-b.clientTop
		}
	return pos;
}

function cfGetScrollOffset(win) {
	if (!win) win = self;
	var x = win.pageXOffset || win.document.body.scrollLeft || document.documentElement.scrollLeft || 0;
	var y = win.pageYOffset || win.document.body.scrollTop || document.documentElement.scrollTop || 0;
	return { x:x, y:y };
}

	
// 가로, 세로 최대 사이즈 설정
//classObj class명
//maxWidth, maxHeight	: 가로 * 세로 최대값
var errorCnt = 0;	//Error횟수
function imageResize(classObj, maxWidth, maxHeight){
	$("." + classObj).each(function(i){
		errorCnt = 0;
		obj = $(this)
		setImageSize(obj, maxWidth, maxHeight);
	});
}

function setImageSize(obj, maxWidth, maxHeight){
	var width = obj.width();
	var height = obj.height();
	var resizeWidth, resizeHeight;

	// 가로나 세로의 길이가 최대 사이즈보다 크면 실행  
	if (width > maxWidth || height > maxHeight){
		// 가로가 세로보다 크면 가로는 최대사이즈로, 세로는 비율 맞춰 리사이즈
		if(width > height){
			resizeWidth = maxWidth;
			resizeHeight = parseInt(Math.round(parseFloat(height * resizeWidth) / parseFloat(width)));
			
			if (resizeHeight > maxHeight){
				resizeHeight = maxHeight;
				resizeWidth = parseInt(Math.round(parseFloat(width * resizeHeight) / parseFloat(height)));
			}
		// 세로가 가로보다 크면 세로는 최대사이즈로, 가로는 비율 맞춰 리사이즈
		}else{
			resizeHeight = maxHeight;
			resizeWidth = parseInt(Math.round(parseFloat(width * resizeHeight) / parseFloat(height)));
			
			if (resizeWidth > maxWidth){
				resizeWidth = maxWidth;
				resizeHeight = parseInt(Math.round(parseFloat(height * resizeWidth) / parseFloat(width)));
			}
		}
	// 최대사이즈보다 작으면 원본 그대로
	}else{
		resizeWidth = width;
		resizeHeight = height;
	}
	
	var maxErrorCnt = 3;
	//이미지 사이즈가 정상적으로 처리되지 않으면 1초 후 반복( 최대3회 )
	if ((resizeWidth < 50 || resizeHeight < 50) && errorCnt < maxErrorCnt){
		errorCnt++;
		window.setTimeout(function(){
				setImageSize(obj, maxWidth, maxHeight);
			},1000);
	}else{
		if (errorCnt < maxErrorCnt){
			if (resizeWidth > resizeHeight){
				var p = (maxHeight - resizeHeight) / 2;
				obj.css({"width":resizeWidth, "height":resizeHeight, "padding-top":p }).show();
			}else
				obj.css({"width":resizeWidth, "height":resizeHeight}).show();
		}
	}
}
	
//Width만 리사이즈		
var _complate = true;
var _errorCount = 0;

function imageResizeWidth(classObj, maxWidth){
	
	var imgs = new Array();
	$("." + classObj).each(function(idx){
		var obj = $(this);
		
		var tmpImage = new Image();
		tmpImage.src = obj.attr("src");
		
		var width = obj.width();
		var height = obj.height();
		var resizeWidth, resizeHeight;
		imgs[idx] = false;

		if (width > maxWidth){
			resizeWidth = maxWidth;
			resizeHeight = parseInt(Math.round(parseFloat(height * resizeWidth) / parseFloat(width)));
		} else {
			resizeWidth = width;
			resizeHeight = height;
		}
		
		//var li = $("<li/>").text((idx+1).toString() + ". width : " + width + ", " + "height : " + height + ", resizeWidth : " + resizeWidth + ", " + "resizeHeight : " + resizeHeight );
		//$("#debug").append(li);
		
		if (resizeWidth > 200){
			imgs[idx] = true;
			obj.css({"width":resizeWidth, "height":resizeHeight}).show();
		}
	});
	
	_complate = true;
	for( i=0; i < imgs.length; i++){
		if (!imgs[i])
			_complate = false;
	}
		
	if ( !_complate && _errorCount < 2){
		_errorCount++;
		window.setTimeout("imageResizeWidth('" + classObj + "', " + maxWidth + ")",200);
	}
}

//마우스 우측버튼 금지
function rightMouse() {
	if (event.button == 2 || event.button == 3) {  
		//alert("마우스 오른쪽 버튼을 사용하실수 없습니다.");
		return false;  
	}
	return true;  
}
function rightMouseDenial(){
	document.oncontextmenu = new Function('return false');
	document.ondragstart = new Function('return false');
	document.onselectstart = new Function('return false');
	
	document.onmousedown = rightMouse;

	//ImageToolBox 금지
	$("img").each(function(){
		$(this).attr("galleryImg",false);
	});
}

function char_filter(obj){
	var filterchar= ";$%'\"<>+\\-:=";
	var len = obj.value.length;
	var temp;
	
	if ( !$(obj).attr("readonly") ){
		for (i = 0; i < len; i++) {
			temp = obj.value.charAt(i);
			if (filterchar.indexOf(temp) > -1){
				alert("특수문자 [ " + temp + " ]은(는) 사용할수 없는 문자 입니다.");
				obj.value = obj.value.substring(0, i);
				obj.focus();
				break;
			}
		}
	}
}

//입력창 Text길이 체크
function lengthCheck(length, obj, nextObjID){
	if (obj.value.length >= length){
		$("#" + nextObjID).focus();
	}
}

//입력항목 검사
function objValidate(objID, alertMsg){
	if ( $("#" + objID).val() == ""){
		alert(alertMsg);
		$("#" + objID).focus();
		return true;
	}
	return false;
}

//머니형태를 숫자 형태로
function toNumber(val){
	var reslut = 0;
	if (val != null)
		reslut = Number(val.toString().split(",").join(""));
	return reslut;
}

//숫자인지 확인
function isNumber(s) {
  s += ''; // 문자열로 변환
  s = s.replace(/^\s*|\s*$/g, ''); // 좌우 공백 제거
  if (s == '' || isNaN(s)) return false;
  return true;
}

/* 값 찍어보기 */
function printLog(tag, val) {
	var log = $("<div/>").text(tag + " : " + val);
	$("body").append(log);
}

/* 전화번호 자동 변환 시작*/
function autoHypenPhone(str, field) {
	var str;
	str = checkDigit(str);
	len = str.length;

	if (len == 8) {
		if (str.substring(0, 2) == 02) {
			error_numbr(str, field);
		} else {
			field.value = phone_format(1, str);
		}
	} else if (len == 9) {
		if (str.substring(0, 2) == 02) {
			field.value = phone_format(2, str);
		} else {
			error_numbr(str, field);
		}
	} else if (len == 10) {
		if (str.substring(0, 2) == 02) {
			field.value = phone_format(2, str);
		} else {
			field.value = phone_format(3, str);
		}
	} else if (len == 11) {
		if (str.substring(0, 2) == 02) {
			error_numbr(str, field);
		} else {
			field.value = phone_format(3, str);
		}
	} else {
		error_numbr(str, field);
	}
}
function checkDigit(num) {
	var Digit = "1234567890";
	var string = num;
	var len = string.length
	var retVal = "";
	for (i = 0; i < len; i++) {
		if (Digit.indexOf(string.substring(i, i + 1)) >= 0) {
			retVal = retVal + string.substring(i, i + 1);
		}
	}
	return retVal;
}
function phone_format(type, num) {
	if (type == 1) {
		return num.replace(/([0-9]{4})([0-9]{4})/, "$1-$2");
	} else if (type == 2) {
		return num.replace(/([0-9]{2})([0-9]+)([0-9]{4})/, "$1-$2-$3");
	} else {
		return num.replace(/(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3");
	}
}
function error_numbr(str, field) {
	if (field.value != "") {
		alert("정상적인 번호가 아닙니다.");
		field.value = "";
		$(field).removeAttr("readonly");	//정상적인 번호가 아닐경우 읽기전용 해제
		//
		field.focus();
		return;
	}
}
function phoneNumberCheck(phone) {
	var rgEx = /(01[016789])[-](\d{4}|\d{3})[-]\d{4}$/g;
	var strValue = phone;
	var chkFlg = rgEx.test(strValue);
	if (!chkFlg) {
		return false;
	} else {
		return true;
	}
}
/* 전화번호 자동 변환 끝*/


//문선균 추가 시작
//영문만 입력 처리
function onlyEng(obj){
	if (!(event.keyCode >=37 && event.keyCode<=40)) {
		var inputVal = obj.value;
		obj.value = inputVal.replace(/[^a-z]/gi,'');
	}
}

//영문, 숫자만 입력 처리(하이픈,점 허용)
function onlyEngNumber(obj){
	if (!(event.keyCode >=37 && event.keyCode<=40)) {
		var inputVal = obj.value;
		obj.value = inputVal.replace(/[^-._A-Za-z0-9]/gi,'');
	}
}

//숫자만 입력 처리(점은 허용)
function onlyNumber2(obj){
	if (!(event.keyCode >=37 && event.keyCode<=40)) {
		var inputVal = obj.value;
		obj.value = inputVal.replace(/[^.0-9]/gi,'');
	}
}

//숫자만 입력 처리
function NumberChk(obj){
	if (!(event.keyCode >=37 && event.keyCode<=40)) {
		var inputVal = obj.value;
		obj.value = inputVal.replace(/[^0-9]/gi,'');
	}
}

//숫자, 하이픈(-) 입력 처리
function NumberHyphen(obj){
	if (!(event.keyCode >=37 && event.keyCode<=40)) {
		var inputVal = obj.value;
		obj.value = inputVal.replace(/[^-0-9]/gi,'');
	}
}

//숫자만 입력 및 세자리마다 콤마찍기(점은 허용)
function numberComma(obj) {
    obj.value = comma(uncomma(obj.value));
}
function comma(str) {
    str = String(str);
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}
function uncomma(str) {
    str = String(str);
    return str.replace(/[^.\d]+/g, '');
}
//문선균 추가 끝