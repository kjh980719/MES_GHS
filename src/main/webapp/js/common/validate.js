function isEmpty(input) {
	if (input == null || input == "" || input == "undefined") {
		return true;
	}
	return false;
}

function lengthCheck(input, start, end) {
	if (input.length < start || input.length > end) {
		return true;
	}
	return false;
}

function numberCheck(input) {

	var regex = /^[0-9]/g;

	if (regex.test(input)) {
		return true;
	}
	return false;
}


function comma(num) {
	var len, point, str;

	num = num + "";
	point = num.length % 3;
	len = num.length;

	str = num.substring(0, point);
	while (point < len) {
		if (str != "") str += ",";
		str += num.substring(point, point + 3);
		point += 3;
	}
	return str;

}
function inputPhoneNumber(obj) {
	var number = obj.value.replace(/[^0-9]/g, "");
	var phone = "";
	if (number.length < 4) {
		return number;
	} else if (number.length < 7) {
		phone += number.substr(0, 3);
		phone += "-";
		phone += number.substr(3);
	} else if (number.length < 11) {
		phone += number.substr(0, 3);
		phone += "-";
		phone += number.substr(3, 3);
		phone += "-";
		phone += number.substr(6);
	} else {
		phone += number.substr(0, 3);
		phone += "-";
		phone += number.substr(3, 4);
		phone += "-";
		phone += number.substr(7);
	}
	obj.value = phone;
}
function autoHypen(obj) { 
	$(obj).val( $(obj).val().replace(/[^0-9]/g, "").replace(/(^02|^0505|^1[0-9]{3}|^0[0-9]{2})([0-9]+)?([0-9]{4})$/,"$1-$2-$3").replace("--", "-"));
}
function regexPhone(obj) {
	obj.value = obj.value.replace(/[^0-9.-]/g, '').replace(/(\..*)\./g, '$1');
}
function regexPercent(obj) {
	obj.value = obj.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');
}

function getNumber(obj){
	var num01;
	var num02;
	num01 = obj.value;
	num02 = num01.replace(/\D/g,"");
	num01 = setComma(num02);
	obj.value =  num01;

	$('#test').text(num01);
}

function setComma(n) {
	var reg = /(^[+-]?\d+)(\d{3})/;
	n += '';
	while (reg.test(n)) {
		n = n.replace(reg, '$1' + ',' + '$2');
	}
	return n;
}

function numkeyCheck(e) {
 var keyValue = event.keyCode; 
 if( ((keyValue >= 48) && (keyValue <= 57)) ) return true;
 else return false; 
}

function idCheck(obj){
 	var val=obj.value;
   var regExp=/[^0-9a-zA-Z]/gi;
   if(regExp.test(obj.value)){
      alert("영문, 숫자만 입력 가능합니다.");
      obj.value=val.replace(regExp,"");
   }
}

function pwdCheck(obj){
   var val=obj.value;
   var regExp=/[^0-9a-zA-Z!@#$%^&*]/gi;
   if(regExp.test(obj.value)){
      alert("영문, 숫자, 특수문자(!@#$%^&*)만 입력 가능합니다.");
      obj.value=val.replace(regExp,"");
   }
};

function codeCheck(obj){  
  var str = obj.value;
  var regExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/gi
  //특수문자 검증
  if(regExp.test(str)){  
    alert("특수문자는 사용하실수 없습니다.");
    obj.value = str.replace(regExp,"");
  }  
}

function removeBlank(obj){
	var str = obj.value;
	str = str.trim().replace(/(\s*)/g, "");
	obj.value = str;
}


function Upper(obj) {
	obj.value = obj.value.toUpperCase();
}

