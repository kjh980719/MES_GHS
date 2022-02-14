/*
    jqGrid 생성 function
*/

$(document).ready(function() {
	$('.pop_bg').attr("onclick",null);

	$('.layer_pop').draggable({
		handle: ".handle",
		iframeFix: true,
		scroll: false,
		start : function( event, ui ){
			$('.layer_pop').removeClass('focus');
			$(this).addClass('focus');
			
			
		},
		
	});
	
})
$(window).resize(function() {
	
	changeFrame()
	changeFrame2()
	changeFrame3()
	changeFrame4()
	changeFrame5()
	changeFrame6()
	changeFrame7()
})
$("#popupframe").onload = function(){
	changeFrame()
};
$("#product_popupframe").onload = function(){
	changeFrame2()
};
$("#manager_popupframe").onload = function(){
	changeFrame3()
};
$("#department_popupframe").onload = function(){
	changeFrame4()
};
$("#material_popupframe").onload = function(){
	changeFrame5()
};
$("#order_popupframe").onload = function(){
	changeFrame6()
};
$("#location_popupframe").onload = function(){
	changeFrame7()
};

function changeFrame() {
	var winW = $(window).innerWidth();
	$('.layer_pop').removeClass('focus')
	$('#popupframe').parent('.layer_pop').addClass('focus');
/*	setTimeout(function() {
		var frameH = $('#popupframe').contents().find(".master_body").height();
		$('#popupframe').parent('.layer_pop').css('height',frameH)
		
	},500)*/
	var frameH = $('#popupframe').contents().find(".master_body").height();
	$('#popupframe').parent('.layer_pop').css('height',frameH)
	if(winW < 1025) {
		$('#popupframe').contents().find("body").removeClass('pc');
	}else {
		$('#popupframe').contents().find("body").addClass('pc');

		
	}
}
function changeFrame2() {
	var winW = $(window).innerWidth();
	$('.layer_pop').removeClass('focus')
	$('#product_popupframe').parent('.layer_pop').addClass('focus');
/*	setTimeout(function() {
		var frameH = $('#product_popupframe').contents().find(".master_body").height();
		$('#product_popupframe').parent('.layer_pop').css('height',frameH)
	},500)
 */
	var frameH = $('#product_popupframe').contents().find(".master_body").height();
	$('#product_popupframe').parent('.layer_pop').css('height',frameH)
	if(winW < 1025) {
		$('#product_popupframe').contents().find("body").removeClass('pc');
	}else {
		$('#product_popupframe').contents().find("body").addClass('pc');

		
	}
}
function changeFrame3() {
	var winW = $(window).innerWidth();
	$('.layer_pop').removeClass('focus')
	$('#manager_popupframe').parent('.layer_pop').addClass('focus');
	setTimeout(function() {
		var frameH = $('#manager_popupframe').contents().find(".master_body").height();
		$('#manager_popupframe').parent('.layer_pop').css('height',frameH)
		
	},500)
	
	if(winW < 1025) {
		
		$('#manager_popupframe').contents().find("body").removeClass('pc');
	}else {
		$('#manager_popupframe').contents().find("body").addClass('pc');

		
	}
}
function changeFrame4() {
	var winW = $(window).innerWidth();
	$('.layer_pop').removeClass('focus')
	$('#department_popupframe').parent('.layer_pop').addClass('focus');
	setTimeout(function() {
		var frameH = $('#department_popupframe').contents().find(".master_body").height();
		$('#department_popupframe').parent('.layer_pop').css('height',frameH)
		
	},500)
	
	if(winW < 1025) {
		
		$('#department_popupframe').contents().find("body").removeClass('pc');
	}else {
		$('#department_popupframe').contents().find("body").addClass('pc');

		
	}
}
function changeFrame5() {
	var winW = $(window).innerWidth();
	$('.layer_pop').removeClass('focus')
	$('#material_popupframe').parent('.layer_pop').addClass('focus');
	setTimeout(function() {
		var frameH = $('#material_popupframe').contents().find(".master_body").height();
		$('#material_popupframe').parent('.layer_pop').css('height',frameH)
		
	},500)
	
	if(winW < 1025) {
		
		$('#material_popupframe').contents().find("body").removeClass('pc');
	}else {
		$('#material_popupframe').contents().find("body").addClass('pc');

		
	}
}

function changeFrame6() {
	var winW = $(window).innerWidth();
	$('.layer_pop').removeClass('focus')
	$('#order_popupframe').parent('.layer_pop').addClass('focus');
	setTimeout(function() {
		var frameH = $('#order_popupframe').contents().find(".master_body").height();
		$('#order_popupframe').parent('.layer_pop').css('height',frameH)
	},500)

	if(winW < 1025) {

		$('#order_popupframe').contents().find("body").removeClass('pc');
	}else {
		$('#order_popupframe').contents().find("body").addClass('pc');


	}
}
function changeFrame7() {
	var winW = $(window).innerWidth();
	$('.layer_pop').removeClass('focus')
	$('#location_popupframe').parent('.layer_pop').addClass('focus');
	setTimeout(function() {
		var frameH = $('#location_popupframe').contents().find(".master_body").height();
		$('#location_popupframe').parent('.layer_pop').css('height',frameH)
	},500)

	if(winW < 1025) {

		$('#location_popupframe').contents().find("body").removeClass('pc');
	}else {
		$('#location_popupframe').contents().find("body").addClass('pc');


	}
}

function creatJqGrid(gridId, url, colModel, setPostData, pagerId, dataCntId, rowPerPage, gridParent, callback){
    
	$("#" + gridId).jqGrid({
        url : url,
        mtype : "POST",
        datatype : "json",
        rowNum : $("#" + rowPerPage).val(),
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colModel : colModel,
        postData : JSON.stringify(setPostData),
      
        jsonReader : {
            repeatitems : false,
            root : "storeData",
            records : function(response) { 	
            		if (response.success) {
                           return response.storeData.length > 0 ? response.storeData[0].totalCount : 0
                     }
                       return 0;
                    }
        },
        pgbuttons : false,
        pginput : false,
        pgtext: "",
        shrinkToFit : true,
        sortable : false,
        viewrecords: true,
        //pager : "#"+pagerId,
        onInitGrid: function () {
            $("<div class='alert-info-grid' style='border-bottom:1px solid #f4f4f4;line-height:340%;color:#333;text-align:center;font-size:12px;'>해당 내역이 없습니다.</div>")
                .insertAfter($(this).parent());
        },
        loadComplete : function(response) {
			if (response.success) {
				
                var totalCount = response.storeData.length > 0 ? response.storeData[0].totalCount : 0;

                $("#"+dataCntId).html(comma(totalCount));
                var gridParam = JSON.parse($("#" + gridId).jqGrid('getGridParam', "postData"));
                if (totalCount === 0 ) {
                    $(this).hide();
                    $(this).parent().siblings(".alert-info-grid").show();
                } else {
                    $(this).show();
                    $(this).parent().siblings(".alert-info-grid").hide();
                }

                initPage(gridId, totalCount, gridParam.currentPage, pagerId);

                if(callback != null) {
					callback(response);
				}
			} else {
				alert("조회시 오류가 발생하였습니다." + response.message);
			}
        },
        loadError: function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 401)
               alert("세션이 종료되었습니다.\n재접속 하시기 바랍니다.");
        },
        height: "auto",
        autowidth : true
    });
	
    resizeJqGridWidth(gridId, gridParent);


    function resizeJqGridWidth(gridId, gridParent){
        $('#' + gridId).setGridWidth($('#' + gridParent).width() , false);
        $(window).bind('resize', function() {
            $('#' + gridId).setGridWidth($('#' + gridParent).width() , false);
        }).trigger('resize');
    }

    $("#"+rowPerPage).on("change", function(){   
    	var gridParam = JSON.parse($("#" + gridId).jqGrid('getGridParam', "postData"));
        var changeRowPerPage = $(this).val();
        gridParam.currentPage = gridParam.currentPage;
        gridParam.rowsPerPage = parseInt(changeRowPerPage);
        $("#" + gridId).jqGrid('setGridParam', {
            postData: JSON.stringify(gridParam),
            rowNum: changeRowPerPage
        }).trigger("reloadGrid");
    });
}

function creatGridNoPage(gridId, url, colModel, setPostData){

    $("#" + gridId).jqGrid({
        url : url,
        mtype : "POST",
        datatype : "json",
        ajaxGridOptions: { contentType: 'application/json; charset=utf-8' },
        colModel : colModel,
        postData : JSON.stringify(setPostData),
        jsonReader : {
            repeatitems : false,
            root : "storeData",
            records : function(response){return response.storeData.length > 0 ? response.storeData[0].totalCount : 0}
        },
        loadError: function (jqXHR, textStatus, errorThrown) {
            if (jqXHR.status == 401)
               alert("세션이 종료되었습니다.\n재접속 하시기 바랍니다.");
        },
        shrinkToFit : true,
        sortable : false,
        hright: "auto",
        autowidth : true,
        hoverrows : true
    });

    $("#"+gridId).find("th input[type='checkbox']").hide();
}

//그리드 페이징
function initPage(gridId, totalSize, currentPage, pagerId){
    // 변수로 그리드아이디, 총 데이터 수, 현재 페이지를 받는다
    if(currentPage == ""){
        var currentPage = $('#'+gridId).getGridParam('page');
    }
    // 한 페이지에 보여줄 페이지 수 (ex:1 2 3 4 5)
    var pageCount = 10;
    // 그리드 데이터 전체의 페이지 수
    var totalPage = Math.ceil(totalSize/$('#'+gridId).getGridParam('rowNum'));
    // 전체 페이지 수를 한화면에 보여줄 페이지로 나눈다.
    var totalPageList = Math.ceil(totalPage / pageCount);
    //var totalPageList = Math.ceil(totalPage);
    // 페이지 리스트가 몇번째 리스트인지
    var pageList = Math.ceil(currentPage / pageCount);

    // 페이지 리스트가 1보다 작으면 1로 초기화
    if(pageList < 1) pageList = 1;
    // 페이지 리스트가 총 페이지 리스트보다 커지면 총 페이지 리스트로 설정
    if(pageList > totalPageList) pageList = totalPageList;
    // 시작 페이지
    var startPageList = ((pageList - 1) * pageCount) + 1;
    // 끝 페이지
    var endPageList = startPageList + pageCount - 1;
  
    // 시작 페이지와 끝페이지가 1보다 작으면 1로 설정
    // 끝 페이지가 마지막 페이지보다 클 경우 마지막 페이지값으로 설정
    if(startPageList < 1) startPageList = 1;
    if(endPageList > totalPage) endPageList = totalPage;
    if(endPageList < 1) endPageList = 1;

    // 페이징 DIV에 넣어줄 태그 생성변수
    var pageInner = "";

    // 페이지 리스트가 1이나 데이터가 없을 경우 (링크 빼고 흐린 이미지로 변경)
    if(pageList < 2){
        pageInner += '<span class="mjbtn_prev mjir_pm">이전</span> ';
        //pageInner+="<img src='prePage2.gif'>";
    }
    // 이전 페이지 리스트가 있을 경우 (링크넣고 뚜렷한 이미지로 변경)
    if(pageList > 1){
        //pageInner+="<a class='first' href='javascript:firstPage()'><img src='firstPage.gif'></a>";
        pageInner += "<a href=\"javascript:prePage('" + gridId + "', "+totalSize+", '" + pagerId + "');\" class='mjbtn_prev'><span class='mjir_pm'>이전</span></a> ";
    }
    // 페이지 숫자를 찍으며 태그생성 (현재페이지는 강조태그)
    for(var i = startPageList; i <= endPageList ; i++){
        if(i == currentPage){
            pageInner = pageInner + "<span class='mjscreen_out'>현재페이지</span><em class='mjlink_page'>"+(i)+"</em> ";
        }else{
            pageInner = pageInner + "<a href=\"javascript:goPage('" + gridId + "', "+(i)+");\" class='mjlink_page'>"+(i)+"</a> ";
        }
    }
    // 다음 페이지 리스트가 있을 경우
    if(totalPageList > pageList){
        pageInner += "<a href=\"javascript:nextPage('" + gridId + "', "+totalSize+", '" + pagerId + "');\" class='mjbtn_next'><span class='mjir_pm'>다음</span></a> ";
        //pageInner += "<a class='last' href='javascript:lastPage("+totalPage+")'><img src='lastPage.gif'></a>";
    }
    // 현재 페이지리스트가 마지막 페이지 리스트일 경우
    if(totalPageList == pageList){
        pageInner += "<span class='mjbtn_next mjir_pm'>다음</span>";
        //pageInner+="<img src='nextPage2.gif'>";
        //pageInner+="<img src='lastPage2.gif'>";
    }
    //alert(pageInner);
    // 페이징할 DIV태그에 우선 내용을 비우고 페이징 태그삽입
    $("#" + pagerId).html("");
    $("#" + pagerId).append(pageInner);
}
// 그리드 이전페이지 이동
function prePage(gridId, totalSize, pagerId){
    var gridParam = JSON.parse($("#" + gridId).jqGrid('getGridParam', "postData"));
    var currentPage = gridParam.currentPage;
    //var pageCount = gridParam.rowsPerPage;

    currentPage -= 1;
    //pageList = Math.ceil(currentPage/pageCount);
    //currentPage = (pageList - 1) * pageCount + pageCount;
    initPage(gridId, totalSize, currentPage, pagerId);

    goPage(gridId, currentPage);
}
// 그리드 다음페이지 이동
function nextPage(gridId, totalSize, pagerId){
    var gridParam = JSON.parse($("#" + gridId).jqGrid('getGridParam', "postData"));
    var currentPage = gridParam.currentPage;
    //var pageCount = gridParam.rowsPerPage;

    currentPage += 1;
    //pageList = Math.ceil(currentPage/pageCount);
    //currentPage = (pageList -1) * pageCount + 1;
    initPage(gridId, totalSize, currentPage, pagerId);

    goPage(gridId, currentPage);
}
function goPage(gridId, currentPage){
    var gridParam = JSON.parse($("#" + gridId).jqGrid('getGridParam', "postData"));
    gridParam.currentPage = currentPage;
    $("#" + gridId).jqGrid('setGridParam', {
        postData: JSON.stringify(gridParam)
    }).trigger("reloadGrid");
}

//단건, 다건 구분....
var setTableText = function(arr, formid, type){
	if(Array.isArray(arr)){
		$.each(arr, function(i, data){
			getFormData(data, formid,i,type);
		 });
	} else {
		getFormData(arr, formid,0,type);
	}
};

function getFormData(data, formid, i, arr){
	for (var key in data) {
		 if (data.hasOwnProperty(key)) {

			 if(data[key]!=""||data[key]!=null){
				 var obj = $("#"+formid+" [name='"+key+"']");
				 if(obj.length==0){
					 obj = $("#"+formid+" [id='"+key+"']");
				 }
				 if(obj.length==1){
					 setTagValue(obj, data[key], data, arr);
				 } else if(obj.length>1){
					 $.each(obj, function(j, item){
						 setTagValue(item, data[key], data, arr);
					 });
				 }
			 }
		}
	}
}
function setTagValue(obj, val, addValue, arr){
	var tag = $(obj).prop("tagName");
	var value = val;
	if(value =="0000.00.00"|| value == null) value = "";
	switch ($(obj).attr("format")) {
		case "currency":
			if(val==""||val==null){
				value = Number("");
			} else {
				value = val.format();
			}
			break;
		case "emptyCur":
			if(value == "0"||val==""||val==null){
				value = "";
			} else {
				value = val.format();
			}
			break;
		case "resNo":
			if(val==""||val==null){
				value = "";
			} else {
				value = addResBar(val);
			}
			break;
		case "curWon":
			if(val==""||val==null){
				value = "";
			} else {
				value = Math.floor(val).format() + " 원";
			}
			break;
		case "bizNo":
			if(val==""||val==null){
				value = "";
			} else {
				value = addBizNo(val);
			}
			break;
		case "daysKR":
			if(val==""||val==null){
				value = "";
			} else {
				value = numberOnly(val) + " 일";
			}
			break;
		case "dateKR":
			if(val==""||val==null){
				value = "";
			} else {
				val = numberOnly(val);
				value = val.substring(0,4) + "년 " + Number(val.substring(4,6)) + "월 " + Number(val.substring(6,8)) + "일";
			}
			break;
		case "dateB":
			if(val==""||val==null){
				value = "";
			} else {
				val = numberOnly(val);
				value = val.substring(0,4) + "." + val.substring(4,6) + "." + val.substring(6,8);
			}
			break;
		case "yearMonth":
			if(val==""||val==null){
				value = "";
			} else {
				val = numberOnly(val);
				value = val.substring(0,4) + "." + val.substring(4,6);
			}
			break;
		case "year":
			if(val==""||val==null||val=="0000"){
				value = "";
			}
			break;
		case "replace":
			var code = $(obj).attr("code");
			var codeNm = $(obj).attr("codeNm");
			var type = $(obj).attr("name");

			var codeArr;
			//코드 꺼냄
			$.each(arr,function(i, data){
				for (var key in data) {
					if(key==type) {
						codeArr = data[key];
						return false;
					}
				}
			});

			var chk = true;
			//코드 돌림
			$.each(codeArr,function(j, cdata){
				for (var key in cdata) {
					if(cdata[code]==val) {
						value = cdata[codeNm];
						chk = false;
						return false;
					}
				}
			});

			if(chk) value = "";
			break;
		case "time":
			if(val==""||val==null){
				value = "";
			} else {
				if(val.length<4){
					value = "";
				} else {
					val = numberOnly(val);
					value = val.substring(0,2) + ":" + val.substring(2,4);
				}
			}
			break;
	}

	switch (tag) {
		case "INPUT":
			var type = $(obj).prop("type");
			if(type =="checkbox" && (value!="" && (value=="Y" || value==1 || value== "1" || value==true))){
				$(obj).prop("checked",true);
			}

			if(type =="radio"){
				var name = $(obj).prop("name");
				var radios = $('input:radio[name="'+name+'"]');
				$.each(radios, function(i, radio){
					if($(radio).val() == value)
						$(radio).prop("checked",true);
				});
				break;
			}
			if(type =="file"){
				break;
			}
		case "SELECT":
			$(obj).val(value);
			break;
		default :
			$(obj).text(value);
			var add = $(obj).attr("addValue");
			if(add != undefined && value!=""){
				$addVal = addValue[add];
				if($addVal== "0000.00.00") $addVal = "";

				if($(obj).attr("addformat") == "period" && $addVal != ""){
					$addVal = $(obj).text()+" ~ "+$addVal;
				} else if($(obj).attr("addformat") == "bracket" && $addVal != ""){
					$addVal = $(obj).text()+"("+$addVal+")";
				} else if($(obj).attr("addformat") == "blank" && $addVal != ""){
					$addVal = $(obj).text()+" "+$addVal;
				} else {
					$addVal = $(obj).text()+$addVal;
				}
				$(obj).text($addVal);
			}
	}

}

function checkPassword(passwordStr) {
    var regexPattern = /^.*(?=^.{8,16}$)(?=.*\d)(?=.*[a-zA-Z]).*$/;
    return (new RegExp(regexPattern)).test(passwordStr);
}

function checkEmail(emailStr) {
    var regexPattern =  /[a-z0-9]{2,}@[a-z0-9-]{2,}.[a-z0-9]{2,}/i;
    return (new RegExp(regexPattern)).test(emailStr);
}

function getFileExtension(filePath){  // 파일의 확장자를 가져옮
    var lastIndex = -1;
    lastIndex  = filePath.lastIndexOf('.');
    var extension = "";

    if(lastIndex != -1){
        extension = filePath.substring( lastIndex+1, filePath.len);
    }else{
        extension = "";
    }
    return extension;
}

function checkImage(value){   // 파일 확장자 체크하기.
    var src = getFileExtension(value);
    if(!((src.toLowerCase() == "gif") || (src.toLowerCase() == "jpg") || (src.toLowerCase() == "jpeg") || (src.toLowerCase() == "png"))){
        alert('gif, jpg, png 파일만 지원합니다.');
        return false;
    }
    return true;
}

function checkOnlyNumber(){
    if(event.keyCode<48 || event.keyCode>57){
        event.returnValue=false;
    }
}

function checkYnText(cellValue, options, rowObject) {
    return cellValue == "Y" ? "노출" : "미노출";
}

function checkYnBoolean(cellValue, options, rowObject) {
    return cellValue == true ? "노출" : "미노출";
}

function checkYnDelete(cellValue, options, rowObject) {
    return cellValue == true ? "Y" : "N";
}

// url 형식인지를 체크( http, https 를 포함하는 형식 )
function checkUrlForm(strUrl) {
    var expUrl = /^http[s]?\:\/\//i;
    return expUrl.test(strUrl);
}

function nts(str){
	return str==null?'':str;
}



function sessionCheck(){

	var status = true;
	$.ajax({
        type : "post",
        url : "/test",
        async : false,
        data : "",
     	error : function (result){            
            status = false;     	
        }
	})
	
	return status;
}

function imageUploadProcess(image){
	var formData = new FormData;
	formData.append("uploadImage", image);
	$.ajax({
		type : "post",
		url : "/uploadDescImage",
		contentType : false,
		processData : false,
		async : false,
		data: formData
	}).done(function(response) {
		if (response.success) {

			for(var i = 0; i < response.storeData.length; i++){
				oEditors.getById["contents"].exec("PASTE_HTML", ["<p class='buy_desc_images' onclick='return false;'><img src='"+response.storeData[i]+"' alt='image' style='max-width:100%'></p><br>"]);
			}

		}
	});
}

function imageUploadProcess2(image){
	var formData = new FormData;
	formData.append("uploadImage", image);
	$.ajax({
		type : "post",
		url : "/uploadDescImage",
		contentType : false,
		processData : false,
		async : false,
		data: formData
	}).done(function(response) {
		if (response.success) {

			for(var i = 0; i < response.storeData.length; i++){
				oEditors.getById["contents2"].exec("PASTE_HTML", ["<p class='buy_desc_images' onclick='return false;'><img src='"+response.storeData[i]+"' alt='image' style='max-width:100%'></p><br>"]);
			}

		}
	});
}







function pop_memo4(groupCode){
	var url = "/memo/buyerGroupMemoList?groupCode="+groupCode;
	$('#memoPop').attr('src',url);
	$('.pop_box').css('display','block');
	//var pop_memo4 = window.open(url,'pop_memo4','width=700,height=500,top=50,left=140, resizable=1, scrollbars=1');
	//pop_memo4.focus();
}

function popFrame(url){
	$('#popFrame').attr('src',url);
	$('.pop_box').css('display','block');
}

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



// 파일 드롭 다운
function fileDropDown(){
	var dropZone = $("#dropZone");
	//Drag기능
	dropZone.on('dragenter',function(e){
		e.stopPropagation();
		e.preventDefault();
		// 드롭다운 영역 css
		dropZone.css('background-color','#E3F2FC');
	});
	dropZone.on('dragleave',function(e){
		e.stopPropagation();
		e.preventDefault();
		// 드롭다운 영역 css
		dropZone.css('background-color','#FFFFFF');
	});
	dropZone.on('dragover',function(e){
		e.stopPropagation();
		e.preventDefault();
		// 드롭다운 영역 css
		dropZone.css('background-color','#E3F2FC');
	});
	dropZone.on('drop',function(e){
		e.preventDefault();
		// 드롭다운 영역 css
		dropZone.css('background-color','#FFFFFF');

		var files = e.originalEvent.dataTransfer.files;
		if(files != null){
			if(files.length < 1){
				alert("폴더 업로드 불가");
				return;
			}
			selectFile(files)
		}else{
			alert("ERROR");
		}
	});
}

// 파일 선택시
function selectFile(files){
	// 다중파일 등록
	if(files != null){
		for(var i = 0; i < files.length; i++){
			if($("[id^='fileTr_']").length >= 30){
				alert("파일은 30개까지만 등록할 수 있습니다.");
				return false;
			}


			// 파일 이름
			var fileName = files[i].name;
			var fileNameArr = fileName.split("\.");
			// 확장자
			var ext = fileNameArr[fileNameArr.length - 1];
			// 파일 사이즈(단위 :MB)
			var fileSize = files[i].size / 1024 / 1024;
			var fileSize2 = 0;
			if(files[i].size / 1024 / 1024 >= 1) {
				fileSize2 = (files[i].size / 1024 / 1024).toFixed(2) + "MB"
			}else{
				fileSize2 = (files[i].size / 1024).toFixed(2) + "KB";
			}
			if($.inArray(ext, ['exe', 'bat', 'sh', 'java', 'jsp', 'html', 'js', 'css', 'xml']) >= 0){
				// 확장자 체크
				alert("등록 불가 확장자");
				break;
			}else if(fileSize > uploadSize){
				// 파일 사이즈 체크
				alert("용량 초과\n업로드 가능 용량 : " + uploadSize + " MB");
				break;
			}else{
				// 전체 파일 사이즈
				totalFileSize += fileSize;

				// 파일 배열에 넣기
				fileList[fileIndex] = files[i];

				// 파일 사이즈 배열에 넣기
				fileSizeList[fileIndex] = fileSize;

				// 업로드 파일 목록 생성
				addFileList(fileIndex, fileName, fileSize2);

				// 파일 번호 증가
				fileIndex++;
			}
		}
	}else{
		alert("ERROR");
	}
}

// 업로드 파일 목록 생성
function addFileList(fIndex, fileName, fileSize){
	$('.file_input .sup_info').addClass('none');
	var html = "";

	html += "<li id='fileTr_" + fIndex + "'>";
	html +=  "<a href='#' onclick='deleteFile(" + fIndex + "); return false;'>삭제</a><span>"+fileName+"</span><span>"+ fileSize +"</span> ";
	html += "</li>"

	$('#fileTableTbody').append(html);
}

// 업로드 파일 삭제
function deleteFile(fIndex){
	var liLength = $('.sup_inner li').length;
	if(liLength == 1) {
		$('.file_input .sup_info').removeClass('none');
	}
	// 전체 파일 사이즈 수정
	totalFileSize -= fileSizeList[fIndex];

	// 파일 배열에서 삭제
	delete fileList[fIndex];

	// 파일 사이즈 배열 삭제
	delete fileSizeList[fIndex];

	// 업로드 파일 테이블 목록에서 삭제
	$("#fileTr_" + fIndex).remove();
}

//매개변수로 문자열 값과 바꿀 n번째문자열
function Left(str, n){
    if (n<= 0) // 만약 n 이 0보다 작거나 같다면 Left함수에서 0보다 작은경우는 없기에
        return "";
    else if (n>String(str).length) //n이 바꿀 문자열보다 짧다면
        return str; // str을 그냥 리턴
    else // 정상적이라면
        return String(str).substring(0,n); // 0번째 문자열 부터 n번째 문자열을 substring한다
}

function Right(str, n){ //매개변수로 문자열 값과 바꿀 n번째문자열
    if (n<= 0) // 만약 n 이 0보다 작거나 같다면 Right 함수에서 0보다 작은경우는 없기에
        return "";
    else if (n>String(str).length) //n이 바꿀 문자열보다 짧다면
        return str;
    else { //정상적이라면
        var iLen = String(str).length;
        return String(str).substring(iLen, iLen - n); // 문자열 끝에서 문자열의 길이 - n까지
    }
}
