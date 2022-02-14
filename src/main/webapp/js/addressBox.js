/*
	주소검색 SelectBox
	
	사용법( jquery 필수 )
	******************
	<div>
		<select name="addr_si" id="addr_si"></select>
		<select name="addr_gu" id="addr_gu"></select>
		<select name="addr_dong" id="addr_dong"></select>
	</div>
	
	var addr = new addressBox("addr","addr_si", "addr_gu", "addr_dong");
	//파라메터로 인스턴스명, 시ID, 구ID, 동ID 값을 넘기면 된다. 없을경우 생략.
	
	초기 선택값이 있을경우 아래와 같이 setAddr메소드를 이용하면 된다.
	Ex ) addr.setAddr("서울"), addr.setAddr("서울","마포구");, addr.setAddr("서울", "마포구", "상암동");
	
	******************

*/

function addressBox(objname, area_si_id, area_gu_id, area_dong_id){

	if (objname != null && objname == ""){
		alert("객체명을 입력해 주세요");
		return;
	}

	if (area_si_id == null){
		alert("도시정보를 입력해 주세요");
		return;
	}

	this.area_si = $("#" + area_si_id)[0];
	this.area_gu = (area_gu_id != null) ? $("#" + area_gu_id)[0] : "";
	this.area_dong = (area_dong_id != null) ? $("#" + area_dong_id)[0] : "";
	this.objName = objname;
	this.selectedGu = "";
	this.selectedDong = "";
	
	var citys = ["시/도","서울","경기","인천","광주","대구","대전","부산","세종","울산","강원","경남","경북","전남","전북","충남","충북","제주"];
	var objectName = objname;

	for(i=0;i<citys.length;i++){
		var option;
		if (citys[i] == "시/도")
			option = new Option(citys[i], "");
		else
			option = new Option(citys[i], citys[i]);
		
		if ($.browser.msie)
			this.area_si.add(option);
		else
			this.area_si.add(option, null);
	}
	
	if (this.area_gu != null && this.area_gu != ""){
		if ($.browser.msie)
			this.area_gu.add(new Option("시/구/군", ""));
		else
			this.area_gu.add(new Option("시/구/군", ""), null);
		
		$(this.area_si).change(function(){
			var func = eval(objectName);
			func.getAddrGu(objectName);
			
			func.area_dong.length = 0;
			if (func.area_dong != null && func.area_dong != ""){
				if ($.browser.msie)
					func.area_dong.add(new Option("동/읍/면", ""));
				else
					func.area_dong.add(new Option("동/읍/면", ""), null);
			}
		});
	}
	
	if (this.area_dong != null && this.area_dong != ""){
		if ($.browser.msie)
			this.area_dong.add(new Option("동/읍/면", ""));
		else
			this.area_dong.add(new Option("동/읍/면", ""), null);
		
		$(this.area_gu).change(function(){
			var func = eval(objectName)
			func.getAddrDong(objectName);
		});
	}
}

addressBox.prototype.getAddrGu = function(objname){
	if ($(this.area_si).val() != ""){
		$.ajax({
			type: "POST",
			url: "/code_behind/getAddress.asp",
			data: "mode=1&Addr_Si=" + escape($(this.area_si).val()) + "&Addr_Gu=",
			dataType: "json",
			success: function(data){
				var gu = eval(objname + ".area_gu");
				if (gu != null && gu != ""){
					gu.length = 0;
					
					if ($.browser.msie)
						gu.add(new Option("시/구/군", ""));
					else
						gu.add(new Option("시/구/군", ""), null);
						
					$.each(data.dataList, function(idx, item){
						var option = new Option(item.option, item.option);
						if ($.browser.msie)
							gu.add(option);
						else
							gu.add(option, null);
					});
					
					var selected = eval(objname + ".selectedGu");
					if (selected != ""){
						$(gu).val(selected);
						var dong = eval(objname + ".area_dong");
						if (dong != null && dong != ""){
							var func = eval(objname);
							func.getAddrDong(objname);
						}
					}
				}
			}
		});
	} else {
		this.area_gu.length = 0;
		if ($.browser.msie)
			this.area_gu.add(new Option("시/구/군", ""));
		else
			this.area_gu.add(new Option("시/구/군", ""), null);
			
		if (this.area_dong != null && this.area_dong != ""){
			this.area_dong.length = 0;
			if ($.browser.msie)
				this.area_dong.add(new Option("동/읍/면", ""));
			else
				this.area_dong.add(new Option("동/읍/면", ""), null);
		}
	}
}

addressBox.prototype.getAddrDong = function(objname){
	if ($(this.area_gu).val() != ""){
		$.ajax({
			type: "POST",
			url: "/code_behind/getAddress.asp",
			data: "mode=0&Addr_Si=" + escape($(this.area_si).val()) + "&Addr_Gu=" + escape($(this.area_gu).val()),
			dataType: "json",
			success: function(data){
				var dong = eval(objname + ".area_dong");
				if (dong != null && dong != ""){
					dong.length = 0;
					
					if ($.browser.msie)
						dong.add(new Option("동/읍/면", ""));
					else
						dong.add(new Option("동/읍/면", ""), null);
						
					$.each(data.dataList, function(idx, item){
						var option = new Option(item.option, item.option);
						if ($.browser.msie)
							dong.add(option);
						else
							dong.add(option, null);
					});
					
					var selected = eval(objname + ".selectedDong");
					if (selected != "")
						$(dong).val(selected);
				}
			}
		});
	} else {
		this.area_dong.length = 0;
		if ($.browser.msie)
			this.area_dong.add(new Option("동/읍/면", ""));
		else
			this.area_dong.add(new Option("동/읍/면", ""), null);
	}
}

addressBox.prototype.setAddr = function(set_si, set_gu, set_dong){
	$(this.area_si).val(set_si);
	this.selectedGu = set_gu;
	this.selectedDong = set_dong;
	if (set_si != null && set_si != "")
		this.getAddrGu(this.objName);
}