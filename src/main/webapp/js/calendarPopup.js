<!--
// When you want to include this popup in a page you MUST:
// 1) create a named div for the popup to attach to in the page.
//    It should look like <div id="mypopup"></div>. Do not put
//    the div anywhere in a table. It should be outside tables.
// 2) create a stylesheet id selector entry for your div. It
//    MUST be position absolute and should look like:
//    #mypopup{ position: absolute;
//              visibility: hidden;
//              background-color: "#99BDDF";
//              layer-background-color: "#99BDDF"; }
// 3) call the popup with code that looks like
//    <a href="#" onClick="calPopup(this,'mypopup',-175,15,'additemform','valiDate');">
//    where -175 and 15 are your desired x and y offsets from the link.
//    The final argument indicates the validation script to run after
//    the popup makes a change to the form. This argument is optional.

var nn4 = (document.layers) ? true : false;
var ie  = (document.all) ? true : false;
var dom = (document.getElementById && !document.all) ? true : false;
var popups = new Array(); // keeps track of popup windows we create
var calHtml = '';

// language and preferences
wDay = new Array('일요일','월요일','화요일','수요일','목요일','금요일','토요일');
wDayAbbrev = new Array('<font color=#CC0000>일</font>','월','화','수','목','금','<font color=#0000CC>토</font>');
wMonth = new Array('1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월');
wMonth2 = new Array('1','2','3','4','5','6','7','8','9','10','11','12');
wOrder = new Array('첫번째','두번째','세번째','네번째','마지막');
wStart = 0;

function calPopup(obj, id, xOffset, yOffset, inputName, validationScript) {
   attachListener(id);
   registerPopup(id);
   calHtml = makeCalHtml(id,null,null,null,inputName,validationScript);
   writeLayer(id,calHtml);
   setLayerPos(obj,id,xOffset,yOffset);
   showLayer(id);
   return true;
}

function attachListener(id) {
   var layer = new pathToLayer(id)
   if (layer.obj.listening == null) {
      document.oldMouseupEvent = document.onmouseup;
      if (document.oldMouseupEvent != null) {
         document.onmouseup = new Function("document.oldMouseupEvent(); hideLayersNotClicked();");
      } else {
         document.onmouseup = hideLayersNotClicked;
      }
      layer.obj.listening = true;
   }
}

function registerPopup(id) {
   // register this popup window with the popups array
   var layer = new pathToLayer(id);
   if (layer.obj.registered == null) {
      var index = popups.length ? popups.length : 0;
      popups[index] = layer;
      layer.obj.registered = 1;
   }
}

function makeCalHtml(id, calYear, calMonth, calDay, inputName, validationScript) {
   var arrDate = eval(inputName).value.split("/");
   if( calYear == null || calYear == "" ) calYear = arrDate[0];
   if( calMonth == null || calMonth == "" ) calMonth = arrDate[1];
   if( calDay == null || calDay == "" ) calDay = arrDate[2];
   var daysInMonth = new Array(0,31,28,31,30,31,30,31,31,30,31,30,31);
   if ((calYear % 4 == 0 && calYear % 100 != 0) || calYear % 400 == 0) {
      daysInMonth[2] = 29;
   }

   var calDate = new Date(calYear,calMonth-1,calDay);

   //-----------------------------------------
   // check if the currently selected day is
   // more than what our target month has
   //-----------------------------------------
   if (calMonth < calDate.getMonth()+1) {
     calDay = calDay-calDate.getDate();
     calDate = new Date(calYear,calMonth-1,calDay);
   }

   var calNextYear  = calDate.getMonth() == 11 ? calDate.getFullYear()+1 : calDate.getFullYear();
   var calNextMonth = calDate.getMonth() == 11 ? 1 : calDate.getMonth()+2;
   var calLastYear  = calDate.getMonth() == 0 ? calDate.getFullYear()-1 : calDate.getFullYear();
   var calLastMonth = calDate.getMonth() == 0 ? 12 : calDate.getMonth();
  //추가 임대선
  var calNextYear2  = calDate.getFullYear()+1;
  var calLastYear2  = calDate.getFullYear()-1;
  //	123
   var todayDate = new Date();

   //---------------------------------------------------------
   // this relies on the javascript bug-feature of offsetting
   // values over 31 days properly. Negative day offsets do NOT
   // work with Netscape 4.x, and negative months do not work
   // in Safari. This works everywhere.
   //---------------------------------------------------------
   var calStartOfThisMonthDate = new Date(calYear,calMonth-1,1);
   var calOffsetToFirstDayOfLastMonth = calStartOfThisMonthDate.getDay() >= wStart ? calStartOfThisMonthDate.getDay()-wStart : 7-wStart-calStartOfThisMonthDate.getDay()
   if (calOffsetToFirstDayOfLastMonth > 0) {
      var calStartDate = new Date(calLastYear,calLastMonth-1,1); // we start in last month
   } else {
      var calStartDate = new Date(calYear,calMonth-1,1); // we start in this month
   }
   var calStartYear = calStartDate.getFullYear();
   var calStartMonth = calStartDate.getMonth();
   var calCurrentDay = calOffsetToFirstDayOfLastMonth ? daysInMonth[calStartMonth+1]-(calOffsetToFirstDayOfLastMonth-1) : 1;

   var html = '';
   // writing the <html><head><body> causes some browsers (Konquerer) to fail
   
html += '<table border=0 cellpadding=0 cellspacing=0" align="">\n';
html += '<tr>\n';
html += '<td>\n';
   // inner
   html += '<table width=100% cellpadding="0" cellspacing="0" border="0">\n';
   html += '<tr>\n';
   html += '<td valign="top">\n';
   html += '<table width=100% cellpadding="2" cellspacing="2" border="0">\n';
   html += '<tr>\n';
   html += '<td><a href="#" onClick="updateCal(\''+id+'\','+calLastYear2+','+wMonth2[calDate.getMonth()]+','+calDay+',\''+inputName+'\',\''+validationScript+'\'); return false;"><img src=/b2b/images/btn/btn_left_cc.gif alt="이전해"></a></td>\n';
   html += '<td><a href="#" onClick="updateCal(\''+id+'\','+calLastYear+','+calLastMonth+','+calDay+',\''+inputName+'\',\''+validationScript+'\'); return false;"><img src=/b2b/images/btn/btn_left_c.gif alt="이전달"></a></td>\n';
   html += '<td class="stylecal" align="center" colspan="3">&nbsp;' +calDate.getFullYear()+'년 '+wMonth[calDate.getMonth()]+ '&nbsp;</td>\n';
   html += '<td><a href="#" onClick="updateCal(\''+id+'\','+calNextYear+','+calNextMonth+','+calDay+',\''+inputName+'\',\''+validationScript+'\'); return false;"><img src=/b2b/images/btn/btn_right_c.gif alt="다음달"></a></td>\n';
   html += '<td><a href="#" onClick="updateCal(\''+id+'\','+calNextYear2+','+wMonth2[calDate.getMonth()]+','+calDay+',\''+inputName+'\',\''+validationScript+'\'); return false;"><img src=/b2b/images/btn/btn_right_cc.gif alt="다음해"></a></td>\n';
   html += '</tr>\n';
   for (var row=1; row <= 7; row++) {
      // check if we started a new month at the beginning of this row
      upcomingDate = new Date(calStartYear,calStartMonth,calCurrentDay);
      if (upcomingDate.getDate() <= 8 && row > 5) {
         continue; // skip this row
      }

      html += '<tr>\n';
      for (var col=0; col < 7; col++) {
         //var tdColor = col % 2 ? '"#DAEDFE"' : '"#F8F8F8"';
         var tdColor = '"rgb(255,255,255)"';
         if (row == 1) {
            tdColor = '"rgb(120,120,120)"';
            html += '<td class="day">'+wDayAbbrev[(wStart+col)%7]+'</td>\n';
         } else {
            var hereDate = new Date(calStartYear,calStartMonth,calCurrentDay);
            var hereDay = hereDate.getDate();
            var aClass = '"stylecal"';

            if (hereDate.getYear() == todayDate.getYear() && hereDate.getMonth() == todayDate.getMonth() && hereDate.getDate() == todayDate.getDate()) {
               tdColor = '"#99AAFF"';
            }
            if (hereDate.getMonth() != calDate.getMonth()) {
               tdColor = '"rgb(220,220,220)"';
               var aClass = '"notmonth"';
            }

            html += '<td bgcolor='+tdColor+' width="20" align="right" onClick="changeFormDate('+hereDate.getFullYear()+','+(hereDate.getMonth()+1)+','+hereDate.getDate()+',\''+inputName+'\',\''+validationScript+'\'); hideLayer(\''+id+'\'); return false;"><a class='+aClass+' href="#" onClick="changeFormDate('+hereDate.getFullYear()+','+(hereDate.getMonth()+1)+','+hereDate.getDate()+',\''+inputName+'\',\''+validationScript+'\'); hideLayer(\''+id+'\'); return false;">'+hereDay+'</a></td>\n';
            calCurrentDay++;
         }
      }
      html += '</tr>\n';
   }
   html += '<tr>\n';
   html += '<td align="center" colspan="7" onClick="updateCal(\''+id+'\','+todayDate.getFullYear()+','+(todayDate.getMonth()+1)+','+todayDate.getDate()+',\''+inputName+'\',\''+validationScript+'\'); return false;"><a href="#" onClick="updateCal(\''+id+'\','+todayDate.getFullYear()+','+(todayDate.getMonth()+1)+','+todayDate.getDate()+',\''+inputName+'\',\''+validationScript+'\'); return false;"><span class="gray">오늘로 이동</span></a></td>\n';
   html += '</tr>\n';
   html += '</table>\n';
   html += '</td></tr>\n';
   html += '</table>\n';
// end of inner
html += '</td>\n';
html += '</tr>\n';
html += '</table>\n';
   return html;
}

function updateCal(id, calYear, calMonth, calDay, inputName, validationScript) {
   calHtml = makeCalHtml(id,calYear,calMonth,calDay,inputName,validationScript);
   writeLayer(id,calHtml);
}

function writeLayer(id, html) {
   var layer = new pathToLayer(id);
   if (nn4) {
      layer.obj.document.open();
      layer.obj.document.write(html);
      layer.obj.document.close();
   } else {
      layer.obj.innerHTML = '';
      layer.obj.innerHTML = html;
   }
}

function setLayerPos(obj, id, xOffset, yOffset) {
   var newX = 0;
   var newY = 0;
   if (obj.offsetParent) {
      // if called from href="setLayerPos(this,'example')" then obj will
      // have no offsetParent properties. Use onClick= instead.
      while (obj.offsetParent) {
         newX += obj.offsetLeft;
         newY += obj.offsetTop;
         obj = obj.offsetParent;
      }
   } else if (obj.x) {
      // nn4 - only works with "a" tags
      newX += obj.x;
      newY += obj.y;
   }

   // apply the offsets
   newX += xOffset;
   newY += yOffset;

   // apply the new positions to our layer
//   var layer = new pathToLayer(id);
   var layer = document.getElementById( id );
   if (nn4) {
      layer.style.left = newX;
      layer.style.top  = newY;
   } else {
      // the px avoids errors with doctype strict modes
      layer.style.left = newX + 'px';
      layer.style.top  = newY + 'px';
   }
}

function hideLayersNotClicked(e) {
   if (!e) var e = window.event;
   e.cancelBubble = true;
   if (e.stopPropagation) e.stopPropagation();
   if (e.target) {
      var clicked = e.target;
   } else if (e.srcElement) {
      var clicked = e.srcElement;
   }

   // go through each popup window,
   // checking if it has been clicked
   for (var i=0; i < popups.length; i++) {
      if (nn4) {
         if ((popups[i].style.left < e.pageX) &&
             (popups[i].style.left+popups[i].style.clip.width > e.pageX) &&
             (popups[i].style.top < e.pageY) &&
             (popups[i].style.top+popups[i].style.clip.height > e.pageY)) {
            return true;
         } else {
            hideLayer(popups[i].obj.id);
            return true;
         }
      } else if (ie) {
         while (clicked.parentElement != null) {
            if (popups[i].obj.id == clicked.id) {
               return true;
            }
            clicked = clicked.parentElement;
         }
         hideLayer(popups[i].obj.id);
         return true;
      } else if (dom) {
         while (clicked.parentNode != null) {
            if (popups[i].obj.id == clicked.id) {
               return true;
            }
            clicked = clicked.parentNode;
         }
         hideLayer(popups[i].obj.id);
         return true;
      }
      return true;
   }
   return true;
}

function pathToLayer(id) {
   if (nn4) {
      this.obj = document.layers[id];
      this.style = document.layers[id];
   } else if (ie) {
      this.obj = document.all[id];
      this.style = document.all[id].style;
   } else {
      this.obj = document.getElementById(id);
      this.style = document.getElementById(id).style;
   }
}

function showLayer(id) {
   var layer = new pathToLayer(id)
   layer.style.visibility = "visible";

}
 
function hideLayer(id) {
   var layer = new pathToLayer(id);
   layer.style.visibility = "hidden";

}

function changeFormDate(changeYear,changeMonth,changeDay,inputName,validationScript) {
	//수정//
	if(changeMonth<10) changeMonth="0"+changeMonth
	if(changeDay<10) changeDay="0"+changeDay
	//
   eval(inputName).value = changeYear + "/" + changeMonth + "/" + changeDay;
   if (validationScript) {
      eval(validationScript+"('"+inputName+"')"); // to update the other selection boxes in the form
   }
}
// -->