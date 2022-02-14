/**
*-------------------------------------------------------------------------------------------------------------------------
* File Name : UbiDateUtil.java
* Description :
* Special Logics :
* @author : jihhong
* @version : $Revision$, $Date$
*-------------------------------------------------------------------------------------------------------------------------
* Copyright (c) 2009-2009 by LG CNS, Inc.
* All rights reserved.
*-------------------------------------------------------------------------------------------------------------------------
* DATE                  AUTHOR               DESCRIPTION
*-------------------------------------------------------------------------------------------------------------------------
* $Date$            jihhong
*-------------------------------------------------------------------------------------------------------------------------
*/
package mes.app.util;

import java.security.SecureRandom;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class DateUtil {

    /**
     * <p>yyyyMMdd �샊�� yyyy-MM-dd �삎�떇�쓽 �궇吏� 臾몄옄�뿴�쓣 �엯�젰 諛쏆븘 �뀈, �썡, �씪�쓣 
     * 利앷컧�븳�떎. �뀈, �썡, �씪�� 媛�媛먰븷 �닔瑜� �쓽誘명븯硫�, �쓬�닔瑜� �엯�젰�븷 寃쎌슦 媛먰븳�떎.</p>
     * 
     * <pre>
     * DateUtil.addYearMonthDay("19810828", 0, 0, 19)  = "19810916"
     * DateUtil.addYearMonthDay("20060228", 0, 0, -10) = "20060218"
     * DateUtil.addYearMonthDay("20060228", 0, 0, 10)  = "20060310"
     * DateUtil.addYearMonthDay("20060228", 0, 0, 32)  = "20060401"
     * DateUtil.addYearMonthDay("20050331", 0, -1, 0)  = "20050228"
     * DateUtil.addYearMonthDay("20050301", 0, 2, 30)  = "20050531"
     * DateUtil.addYearMonthDay("20050301", 1, 2, 30)  = "20060531"
     * DateUtil.addYearMonthDay("20040301", 2, 0, 0)   = "20060301"
     * DateUtil.addYearMonthDay("20040229", 2, 0, 0)   = "20060228"
     * DateUtil.addYearMonthDay("20040229", 2, 0, 1)   = "20060301"
     * </pre>
     * 
     * @param  dateStr �궇吏� 臾몄옄�뿴(yyyyMMdd, yyyy-MM-dd�쓽 �삎�떇)
     * @param  year 媛�媛먰븷 �뀈. 0�씠 �엯�젰�맆 寃쎌슦 媛�媛먯씠 �뾾�떎
     * @param  month 媛�媛먰븷 �썡. 0�씠 �엯�젰�맆 寃쎌슦 媛�媛먯씠 �뾾�떎
     * @param  day 媛�媛먰븷 �씪. 0�씠 �엯�젰�맆 寃쎌슦 媛�媛먯씠 �뾾�떎
     * @return  yyyyMMdd �삎�떇�쓽 �궇吏� 臾몄옄�뿴
     * @throws IllegalArgumentException �궇吏� �룷留룹씠 �젙�빐吏� 諛붿� �떎瑜� 寃쎌슦. 
     *         �엯�젰 媛믪씠 <code>null</code>�씤 寃쎌슦.
     */
    public static String addYearMonthDay(String sDate, int year, int month, int day) {

    	String dateStr = validChkDate(sDate);
        
        Calendar cal = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Locale.getDefault());
        try {
            cal.setTime(sdf.parse(dateStr));
        } catch (ParseException e) {
            throw new IllegalArgumentException("Invalid date format: " + dateStr);
        }
        
        if (year != 0) 
            cal.add(Calendar.YEAR, year);
        if (month != 0) 
            cal.add(Calendar.MONTH, month);
        if (day != 0) 
            cal.add(Calendar.DATE, day);
        return sdf.format(cal.getTime());
    }
    
    /**
     * <p>yyyyMMdd �샊�� yyyy-MM-dd �삎�떇�쓽 �궇吏� 臾몄옄�뿴�쓣 �엯�젰 諛쏆븘 �뀈�쓣 
     * 利앷컧�븳�떎. <code>year</code>�뒗 媛�媛먰븷 �닔瑜� �쓽誘명븯硫�, �쓬�닔瑜� �엯�젰�븷 寃쎌슦 媛먰븳�떎.</p>
     * 
     * <pre>
     * DateUtil.addYear("20000201", 62)  = "20620201"
     * DateUtil.addYear("20620201", -62) = "20000201"
     * DateUtil.addYear("20040229", 2)   = "20060228"
     * DateUtil.addYear("20060228", -2)  = "20040228"
     * DateUtil.addYear("19000101", 200) = "21000101"
     * </pre>
     * 
     * @param  dateStr �궇吏� 臾몄옄�뿴(yyyyMMdd, yyyy-MM-dd�쓽 �삎�떇)
     * @param  year 媛�媛먰븷 �뀈. 0�씠 �엯�젰�맆 寃쎌슦 媛�媛먯씠 �뾾�떎
     * @return  yyyyMMdd �삎�떇�쓽 �궇吏� 臾몄옄�뿴
     * @throws IllegalArgumentException �궇吏� �룷留룹씠 �젙�빐吏� 諛붿� �떎瑜� 寃쎌슦. 
     *         �엯�젰 媛믪씠 <code>null</code>�씤 寃쎌슦.
     */
    public static String addYear(String dateStr, int year) {
        return addYearMonthDay(dateStr, year, 0, 0);
    }
    
    /**
     * <p>yyyyMMdd �샊�� yyyy-MM-dd �삎�떇�쓽 �궇吏� 臾몄옄�뿴�쓣 �엯�젰 諛쏆븘 �썡�쓣 
     * 利앷컧�븳�떎. <code>month</code>�뒗 媛�媛먰븷 �닔瑜� �쓽誘명븯硫�, �쓬�닔瑜� �엯�젰�븷 寃쎌슦 媛먰븳�떎.</p>
     * 
     * <pre>
     * DateUtil.addMonth("20010201", 12)  = "20020201"
     * DateUtil.addMonth("19800229", 12)  = "19810228"
     * DateUtil.addMonth("20040229", 12)  = "20050228"
     * DateUtil.addMonth("20050228", -12) = "20040228"
     * DateUtil.addMonth("20060131", 1)   = "20060228"
     * DateUtil.addMonth("20060228", -1)  = "20060128"
     * </pre>
     * 
     * @param  dateStr �궇吏� 臾몄옄�뿴(yyyyMMdd, yyyy-MM-dd�쓽 �삎�떇)
     * @param  month 媛�媛먰븷 �썡. 0�씠 �엯�젰�맆 寃쎌슦 媛�媛먯씠 �뾾�떎
     * @return  yyyyMMdd �삎�떇�쓽 �궇吏� 臾몄옄�뿴
     * @throws IllegalArgumentException �궇吏� �룷留룹씠 �젙�빐吏� 諛붿� �떎瑜� 寃쎌슦. 
     *         �엯�젰 媛믪씠 <code>null</code>�씤 寃쎌슦.
     */
    public static String addMonth(String dateStr, int month) {
        return addYearMonthDay(dateStr, 0, month, 0);
    }
    
    /**
     * <p>yyyyMMdd �샊�� yyyy-MM-dd �삎�떇�쓽 �궇吏� 臾몄옄�뿴�쓣 �엯�젰 諛쏆븘 �씪(day)瑜�  
     * 利앷컧�븳�떎. <code>day</code>�뒗 媛�媛먰븷 �닔瑜� �쓽誘명븯硫�, �쓬�닔瑜� �엯�젰�븷 寃쎌슦 媛먰븳�떎.
     * <br/><br/>
     * �쐞�뿉 �젙�쓽�맂 addDays 硫붿꽌�뱶�뒗 �궗�슜�옄媛� ParseException�쓣 諛섎뱶�떆 泥섎━�빐�빞 �븯�뒗 遺덊렪�븿�씠
     * �엳湲� �븣臾몄뿉 異붽��맂 硫붿꽌�뱶�씠�떎.</p>
     * 
     * <pre>
     * DateUtil.addDay("19991201", 62) = "20000201"
     * DateUtil.addDay("20000201", -62) = "19991201"
     * DateUtil.addDay("20050831", 3) = "20050903"
     * DateUtil.addDay("20050831", 3) = "20050903"
     * // 2006�뀈 6�썡 31�씪�� �떎�젣濡� 議댁옱�븯吏� �븡�뒗 �궇吏쒖씠�떎 -> 20060701濡� 媛꾩＜�맂�떎
     * DateUtil.addDay("20060631", 1) = "20060702"
     * </pre>
     * 
     * @param  dateStr �궇吏� 臾몄옄�뿴(yyyyMMdd, yyyy-MM-dd�쓽 �삎�떇)
     * @param  day 媛�媛먰븷 �씪. 0�씠 �엯�젰�맆 寃쎌슦 媛�媛먯씠 �뾾�떎
     * @return  yyyyMMdd �삎�떇�쓽 �궇吏� 臾몄옄�뿴
     * @throws IllegalArgumentException �궇吏� �룷留룹씠 �젙�빐吏� 諛붿� �떎瑜� 寃쎌슦. 
     *         �엯�젰 媛믪씠 <code>null</code>�씤 寃쎌슦.
     */
    public static String addDay(String dateStr, int day) {
        return addYearMonthDay(dateStr, 0, 0, day);
    }
    
    /**
     * <p>yyyyMMdd �샊�� yyyy-MM-dd �삎�떇�쓽 �궇吏� 臾몄옄�뿴 <code>dateStr1</code>怨� <code>
     * dateStr2</code> �궗�씠�쓽 �씪 �닔瑜� 援ы븳�떎.<br>
     * <code>dateStr2</code>媛� <code>dateStr1</code> 蹂대떎 怨쇨굅 �궇吏쒖씪 寃쎌슦�뿉�뒗
     * �쓬�닔瑜� 諛섑솚�븳�떎. �룞�씪�븳 寃쎌슦�뿉�뒗 0�쓣 諛섑솚�븳�떎.</p>
     * 
     * <pre>
     * DateUtil.getDaysDiff("20060228","20060310") = 10
     * DateUtil.getDaysDiff("20060101","20070101") = 365
     * DateUtil.getDaysDiff("19990228","19990131") = -28
     * DateUtil.getDaysDiff("20060801","20060802") = 1
     * DateUtil.getDaysDiff("20060801","20060801") = 0
     * </pre>
     * 
     * @param  dateStr1 �궇吏� 臾몄옄�뿴(yyyyMMdd, yyyy-MM-dd�쓽 �삎�떇)
     * @param  dateStr2 �궇吏� 臾몄옄�뿴(yyyyMMdd, yyyy-MM-dd�쓽 �삎�떇)
     * @return  �씪 �닔 李⑥씠.
     * @throws IllegalArgumentException �궇吏� �룷留룹씠 �젙�빐吏� 諛붿� �떎瑜� 寃쎌슦. 
     *         �엯�젰 媛믪씠 <code>null</code>�씤 寃쎌슦.
     */
    public static int getDaysDiff(String sDate1, String sDate2) {
    	String dateStr1 = validChkDate(sDate1);
    	String dateStr2 = validChkDate(sDate2);
    	
        if (!checkDate(sDate1) || !checkDate(sDate2)) {
            throw new IllegalArgumentException("Invalid date format: args[0]=" + sDate1 + " args[1]=" + sDate2);
        }
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Locale.getDefault());
        
        Date date1 = null;
        Date date2 = null;
        try {
            date1 = sdf.parse(dateStr1);
            date2 = sdf.parse(dateStr2);
        } catch (ParseException e) {
            throw new IllegalArgumentException("Invalid date format: args[0]=" + dateStr1 + " args[1]=" + dateStr2);
        }
        int days1 = (int)((date1.getTime()/3600000)/24);
        int days2 = (int)((date2.getTime()/3600000)/24);
        
        return days2 - days1;
    }
        
    /**
     * <p>yyyyMMdd �샊�� yyyy-MM-dd �삎�떇�쓽 �궇吏� 臾몄옄�뿴�쓣 �엯�젰 諛쏆븘 �쑀�슚�븳 �궇吏쒖씤吏� 寃��궗.</p>
     * 
     * <pre>
     * DateUtil.checkDate("1999-02-35") = false
     * DateUtil.checkDate("2000-13-31") = false
     * DateUtil.checkDate("2006-11-31") = false
     * DateUtil.checkDate("2006-2-28")  = false
     * DateUtil.checkDate("2006-2-8")   = false
     * DateUtil.checkDate("20060228")   = true
     * DateUtil.checkDate("2006-02-28") = true
     * </pre>
     * 
     * @param  dateStr �궇吏� 臾몄옄�뿴(yyyyMMdd, yyyy-MM-dd�쓽 �삎�떇)
     * @return  �쑀�슚�븳 �궇吏쒖씤吏� �뿬遺�
     */
    public static boolean checkDate(String sDate) {
    	String dateStr = validChkDate(sDate);

        String year  = dateStr.substring(0,4);
        String month = dateStr.substring(4,6);
        String day   = dateStr.substring(6);
   
        return checkDate(year, month, day);
    }   

    /**
     * <p>�엯�젰�븳 �뀈, �썡, �씪�씠 �쑀�슚�븳吏� 寃��궗.</p>
     * 
     * @param  year �뿰�룄
     * @param  month �썡
     * @param  day �씪
     * @return  �쑀�슚�븳 �궇吏쒖씤吏� �뿬遺�
     */
    public static boolean checkDate(String year, String month, String day) {
        try {
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd", Locale.getDefault());
            
            Date result = formatter.parse(year + "." + month + "." + day);
            String resultStr = formatter.format(result);
            if (resultStr.equalsIgnoreCase(year + "." + month + "." + day))
                return true;
            else
                return false;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * �궇吏쒗삎�깭�쓽 String�쓽 �궇吏� �룷留� 諛� TimeZone�쓣 蹂�寃쏀빐 二쇰뒗 硫붿꽌�뱶
     *
     * @param  strSource       諛붽� �궇吏� String
     * @param  fromDateFormat  湲곗〈�쓽 �궇吏� �삎�깭
     * @param  toDateFormat    �썝�븯�뒗 �궇吏� �삎�깭
     * @param  strTimeZone     蹂�寃쏀븷 TimeZone(""�씠硫� 蹂�寃� �븞�븿)
     * @return  �냼�뒪 String�쓽 �궇吏� �룷留룹쓣 蹂�寃쏀븳 String
     */
    public static String convertDate(String strSource, String fromDateFormat, 
            String toDateFormat, String strTimeZone) {
        SimpleDateFormat simpledateformat = null;
        Date date = null;
        String _fromDateFormat = fromDateFormat;
        String _toDateFormat = toDateFormat;
        
        if(StringUtil.isNullToString(strSource).trim().equals("")) {
            return "";
        }
        if(StringUtil.isNullToString(fromDateFormat).trim().equals(""))
        	_fromDateFormat = "yyyyMMddHHmmss";                    // default媛�
        if(StringUtil.isNullToString(toDateFormat).trim().equals(""))
        	_toDateFormat = "yyyy-MM-dd HH:mm:ss";                 // default媛�

        try {
        	simpledateformat = new SimpleDateFormat(_fromDateFormat, Locale.getDefault());
            date = simpledateformat.parse(strSource);
            if (!StringUtil.isNullToString(strTimeZone).trim().equals("")) {
                simpledateformat.setTimeZone(TimeZone.getTimeZone(strTimeZone));
            }
            simpledateformat = new SimpleDateFormat(_toDateFormat, Locale.getDefault());
        }
        catch(Exception exception) {
            exception.printStackTrace();
        }        
        return simpledateformat.format(date);
        
    }    
    
    public static String defaultFormatDate(String sDate) {
    	return formatDate(sDate, ".");
    }
    /**
     * yyyyMMdd �삎�떇�쓽 �궇吏쒕Ц�옄�뿴�쓣 �썝�븯�뒗 罹먮┃�꽣(ch)濡� 履쇨컻 �룎�젮以��떎<br/>
    * <pre>
    * ex) 20030405, ch(.) -> 2003.04.05
    * ex) 200304, ch(.) -> 2003.04
    * ex) 20040101,ch(/) --> 2004/01/01 濡� 由ы꽩
    * </pre>
    * 
    * @param date yyyyMMdd �삎�떇�쓽 �궇吏쒕Ц�옄�뿴
    * @param ch 援щ텇�옄
    * @return 蹂��솚�맂 臾몄옄�뿴
     */
    public static String formatDate(String sDate, String ch) {
    	String dateStr = validChkDate(sDate);

        String str = dateStr.trim();
        String yyyy = "";
        String mm = "";
        String dd = "";

        if (str.length() == 8) {
            yyyy = str.substring(0, 4);
            if (yyyy.equals("0000"))
                return "";

            mm = str.substring(4, 6);
            if (mm.equals("00"))
                return yyyy;

            dd = str.substring(6, 8);
            if (dd.equals("00"))
                return yyyy + ch + mm;

            return yyyy + ch + mm + ch + dd;
        } else if (str.length() == 6) {
            yyyy = str.substring(0, 4);
            if (yyyy.equals("0000"))
                return "";

            mm = str.substring(4, 6);
            if (mm.equals("00"))
                return yyyy;

            return yyyy + ch + mm;
        } else if (str.length() == 4) {
            yyyy = str.substring(0, 4);
            if (yyyy.equals("0000"))
                return "";
            else
                return yyyy;
        } else
            return "";
    }    
    
    /**
     * HH24MISS �삎�떇�쓽 �떆媛꾨Ц�옄�뿴�쓣 �썝�븯�뒗 罹먮┃�꽣(ch)濡� 履쇨컻 �룎�젮以��떎 <br>
     * <pre>
     *     ex) 151241, ch(/) -> 15/12/31
     * </pre>
     *
     * @param str HH24MISS �삎�떇�쓽 �떆媛꾨Ц�옄�뿴
     * @param ch 援щ텇�옄
     * @return 蹂��솚�맂 臾몄옄�뿴
     */
     public static String formatTime(String sTime, String ch) {
     	String timeStr = validChkTime(sTime);
        return timeStr.substring(0, 2) + ch + timeStr.substring(2, 4) + ch + timeStr.substring(4, 6);
     }    
    
     /**
      * �뿰�룄瑜� �엯�젰 諛쏆븘 �빐�떦 �뿰�룄 2�썡�쓽 留먯씪(�씪�닔)瑜� 臾몄옄�뿴濡� 諛섑솚�븳�떎.
      * 
      * @param year
      * @return �빐�떦 �뿰�룄 2�썡�쓽 留먯씪(�씪�닔)
      */
     public String leapYear(int year) {
         if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
             return "29";
         }

         return "28";
     }    
    
     /**
      * <p>�엯�젰諛쏆� �뿰�룄媛� �쑄�뀈�씤吏� �븘�땶吏� 寃��궗�븳�떎.</p>
      * 
      * <pre>
      * DateUtil.isLeapYear(2004) = false
      * DateUtil.isLeapYear(2005) = true
      * DateUtil.isLeapYear(2006) = true
      * </pre>
      * 
      * @param  year �뿰�룄
      * @return  �쑄�뀈 �뿬遺�
      */
     public static boolean isLeapYear(int year) {
         if (year % 4 == 0 && year % 100 != 0 || year % 400 == 0) {
             return false;
         }
         return true;
     }     
     
     
     /**
      * �쁽�옱(�븳援�湲곗�) �궇吏쒖젙蹂대�� �뼸�뒗�떎.                     <BR>
      * �몴湲곕쾿�� yyyy-mm-dd                                  <BR>
      * @return  String      yyyymmdd�삎�깭�쓽 �쁽�옱 �븳援��떆媛�.   <BR>
      */
     public static String getToday(){
         return getCurrentDate("");
     }

     /**
      * �쁽�옱(�븳援�湲곗�) �궇吏쒖젙蹂대�� �뼸�뒗�떎.                     <BR>
      * �몴湲곕쾿�� yyyy-mm-dd                                  <BR>
      * @return  String      yyyymmdd�삎�깭�쓽 �쁽�옱 �븳援��떆媛�.   <BR>
      */
     public static String getCurrentDate(String dateType) {
         Calendar aCalendar = Calendar.getInstance();

         int year = aCalendar.get(Calendar.YEAR);
         int month = aCalendar.get(Calendar.MONTH) + 1;
         int date = aCalendar.get(Calendar.DATE);
         String strDate = Integer.toString(year) +
                 ((month<10) ? "0" + Integer.toString(month) : Integer.toString(month)) +
                 ((date<10) ? "0" + Integer.toString(date) : Integer.toString(date));
         
         if(!"".equals(dateType)) strDate = convertDate(strDate, "yyyyMMdd", dateType, "");

         return  strDate;
     }
     
     /**
      * �쁽�옱(�븳援�湲곗�) �뀈�룄�젙蹂대�� �뼸�뒗�떎.                     <BR>
      * �몴湲곕쾿�� yyyy                                  <BR>
      * @return  String      yyyy�삎�깭�쓽 �쁽�옱 �븳援��뀈�룄.   <BR>
      */
     public static String getCurrentYear() {
    	 Calendar aCalendar = Calendar.getInstance();
    	 int year = aCalendar.get(Calendar.YEAR);
    	 return  Integer.toString(year);
     }
     
	/**
	 * �궇吏쒗삎�깭�쓽 String�쓽 �궇吏� �룷留룸쭔�쓣 蹂�寃쏀빐 二쇰뒗 硫붿꽌�뱶
	 * @param sDate �궇吏�
	 * @param sTime �떆媛�
	 * @param sFormatStr �룷硫� �뒪�듃留� 臾몄옄�뿴
	 * @return 吏��젙�븳 �궇吏�/�떆媛꾩쓣 吏��젙�븳 �룷留룹쑝濡� 異쒕젰
	 * @See Letter  Date or Time Component  Presentation  Examples  
	           G  Era designator  Text  AD  
	           y  Year  Year  1996; 96  
	           M  Month in year  Month  July; Jul; 07  
	           w  Week in year  Number  27  
	           W  Week in month  Number  2  
	           D  Day in year  Number  189  
	           d  Day in month  Number  10  
	           F  Day of week in month  Number  2  
	           E  Day in week  Text  Tuesday; Tue  
	           a  Am/pm marker  Text  PM  
	           H  Hour in day (0-23)  Number  0  
	           k  Hour in day (1-24)  Number  24  
	           K  Hour in am/pm (0-11)  Number  0  
	           h  Hour in am/pm (1-12)  Number  12  
	           m  Minute in hour  Number  30  
	           s  Second in minute  Number  55  
	           S  Millisecond  Number  978  
	           z  Time zone  General time zone  Pacific Standard Time; PST; GMT-08:00  
	           Z  Time zone  RFC 822 time zone  -0800  
	           
	            
	           
	           Date and Time Pattern  Result  
	           "yyyy.MM.dd G 'at' HH:mm:ss z"  2001.07.04 AD at 12:08:56 PDT  
	           "EEE, MMM d, ''yy"  Wed, Jul 4, '01  
	           "h:mm a"  12:08 PM  
	           "hh 'o''clock' a, zzzz"  12 o'clock PM, Pacific Daylight Time  
	           "K:mm a, z"  0:08 PM, PDT  
	           "yyyyy.MMMMM.dd GGG hh:mm aaa"  02001.July.04 AD 12:08 PM  
	           "EEE, d MMM yyyy HH:mm:ss Z"  Wed, 4 Jul 2001 12:08:56 -0700  
	           "yyMMddHHmmssZ"  010704120856-0700  
	
	 */
    public static String convertDate(String sDate, String sTime, String sFormatStr) {
    	String dateStr = validChkDate(sDate);
    	String timeStr = validChkTime(sTime);
    	
    	Calendar cal = null;
    	cal = Calendar.getInstance() ;
    	
    	cal.set(Calendar.YEAR        , Integer.parseInt(dateStr.substring(0,4)));
    	cal.set(Calendar.MONTH       , Integer.parseInt(dateStr.substring(4,6))-1 );
    	cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dateStr.substring(6,8)));
    	cal.set(Calendar.HOUR_OF_DAY , Integer.parseInt(timeStr.substring(0,2)));
    	cal.set(Calendar.MINUTE      , Integer.parseInt(timeStr.substring(2,4)));
    	
    	SimpleDateFormat sdf = new SimpleDateFormat(sFormatStr,Locale.ENGLISH);
    	
    	return sdf.format(cal.getTime());
    }   

    /**
     * �엯�젰諛쏆� �씪�옄 �궗�씠�쓽 �엫�쓽�쓽 �씪�옄瑜� 諛섑솚
     * @param sDate1 �떆�옉�씪�옄
     * @param sDate2 醫낅즺�씪�옄
     * @return �엫�쓽�씪�옄
     */
    public static String getRandomDate(String sDate1, String sDate2) {    
    	String dateStr1 = validChkDate(sDate1);
    	String dateStr2 = validChkDate(sDate2);

    	String randomDate   = null;
    	
    	int sYear, sMonth, sDay;
    	int eYear, eMonth, eDay;
    	
    	sYear  = Integer.parseInt(dateStr1.substring(0, 4));
    	sMonth = Integer.parseInt(dateStr1.substring(4, 6));
    	sDay   = Integer.parseInt(dateStr1.substring(6, 8));
    	
    	eYear  = Integer.parseInt(dateStr2.substring(0, 4));
    	eMonth = Integer.parseInt(dateStr2.substring(4, 6));
    	eDay   = Integer.parseInt(dateStr2.substring(6, 8));
    	
    	GregorianCalendar beginDate = new GregorianCalendar(sYear, sMonth-1, sDay,    0, 0);
    	GregorianCalendar endDate   = new GregorianCalendar(eYear, eMonth-1, eDay,   23,59);
    	
    	if (endDate.getTimeInMillis() < beginDate.getTimeInMillis()) {
    	    throw new IllegalArgumentException("Invalid input date : " + sDate1 + "~" + sDate2);
    	}
    	
    	SecureRandom r = new SecureRandom();

    	long rand = ((r.nextLong()>>>1)%( endDate.getTimeInMillis()-beginDate.getTimeInMillis() + 1)) + beginDate.getTimeInMillis();
    	
    	GregorianCalendar cal = new GregorianCalendar();
    	//SimpleDateFormat calformat = new SimpleDateFormat("yyyy-MM-dd");
    	SimpleDateFormat calformat = new SimpleDateFormat("yyyyMMdd",Locale.ENGLISH);
    	cal.setTimeInMillis(rand);
    	randomDate = calformat.format(cal.getTime()); 
    	
    	// �옖�뜡臾몄옄�뿴瑜� 由ы꽩
    	return  randomDate;
    }
       
    /**
     * �엯�젰諛쏆� �슂�씪�쓽 �쁺臾몃챸�쓣 援�臾몃챸�쓽 �슂�씪濡� 諛섑솚 
     * @param sWeek �쁺臾� �슂�씪紐�
     * @return 援�臾� �슂�씪紐�
     */
	public static String convertWeek(String sWeek) {
		String retStr = null;
		
		if        (sWeek.equals("SUN")   ) { retStr = "�씪�슂�씪";
		} else if (sWeek.equals("MON")   ) { retStr = "�썡�슂�씪";
		} else if (sWeek.equals("TUE")   ) { retStr = "�솕�슂�씪";
		} else if (sWeek.equals("WED")   ) { retStr = "�닔�슂�씪";
		} else if (sWeek.equals("THR")   ) { retStr = "紐⑹슂�씪";
		} else if (sWeek.equals("FRI")   ) { retStr = "湲덉슂�씪";
		} else if (sWeek.equals("SAT")   ) { retStr = "�넗�슂�씪";
		}
		   
		return retStr;
	}

    /**
     * �엯�젰�씪�옄�쓽 �쑀�슚 �뿬遺�瑜� �솗�씤
     * @param sDate �씪�옄
     * @return �쑀�슚 �뿬遺�
     */
    public static boolean validDate(String sDate) {
    	String dateStr = validChkDate(sDate);

		Calendar cal ;
		boolean ret  = false;
		
		cal = Calendar.getInstance() ;
		
		cal.set(Calendar.YEAR        , Integer.parseInt(dateStr.substring(0,4)));
		cal.set(Calendar.MONTH       , Integer.parseInt(dateStr.substring(4,6))-1 );
		cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dateStr.substring(6,8)));
		
		String year  = String.valueOf(cal.get(Calendar.YEAR        )    );
		String month = String.valueOf(cal.get(Calendar.MONTH       ) + 1);
		String day   = String.valueOf(cal.get(Calendar.DAY_OF_MONTH)    );
		
		String pad4Str = "0000";
		String pad2Str = "00";
		
		String retYear  = (pad4Str + year ).substring(year .length());
		String retMonth = (pad2Str + month).substring(month.length());
		String retDay   = (pad2Str + day  ).substring(day  .length());
		
		String retYMD = retYear+retMonth+retDay;
		
		if(sDate.equals(retYMD)) {
			ret  = true;
		}
		
		return ret;
	}
    
    /**
     * �엯�젰�씪�옄, �슂�씪�쓽 �쑀�슚 �뿬遺�瑜� �솗�씤
     * @param     sDate �씪�옄
     * @param     sWeek �슂�씪 (DAY_OF_WEEK)
     * @return    �쑀�슚 �뿬遺�
     */
    public static boolean validDate(String sDate, int sWeek) {
    	String dateStr = validChkDate(sDate);

		Calendar cal ;
		boolean ret  = false;
		
		cal = Calendar.getInstance() ;
		
		cal.set(Calendar.YEAR        , Integer.parseInt(dateStr.substring(0,4)));
		cal.set(Calendar.MONTH       , Integer.parseInt(dateStr.substring(4,6))-1 );
		cal.set(Calendar.DAY_OF_MONTH, Integer.parseInt(dateStr.substring(6,8)));
		
		int    Week  =                cal.get(Calendar.DAY_OF_WEEK      );
		
		if (validDate(sDate)) {
			if (sWeek == Week) {
				ret = true;
			}
		}
		
		return ret;
	}

    /**
     * �엯�젰�떆媛꾩쓽 �쑀�슚 �뿬遺�瑜� �솗�씤
     * @param     sTime �엯�젰�떆媛�
     * @return    �쑀�슚 �뿬遺�
     */
    public static boolean validTime(String sTime) {
    	String timeStr = validChkTime(sTime);

		Calendar cal ;
		boolean ret = false;
		
		cal = Calendar.getInstance() ;
		
		cal.set(Calendar.HOUR_OF_DAY  , Integer.parseInt(timeStr.substring(0,2)));
		cal.set(Calendar.MINUTE       , Integer.parseInt(timeStr.substring(2,4)));
		
		String HH     = String.valueOf(cal.get(Calendar.HOUR_OF_DAY  ));
		String MM     = String.valueOf(cal.get(Calendar.MINUTE       ));
		
		String pad2Str = "00";
		
		String retHH = (pad2Str + HH).substring(HH.length());
		String retMM = (pad2Str + MM).substring(MM.length());
		
		String retTime = retHH + retMM;
		
		if(sTime.equals(retTime)) {
			ret  = true;
		}
		
		return ret;
	}
    
    /**
     * �엯�젰�맂 �씪�옄�뿉 �뿰, �썡, �씪�쓣 媛�媛먰븳 �궇吏쒖쓽 �슂�씪�쓣 諛섑솚
     * @param sDate �궇吏�
     * @param year �뿰
     * @param month �썡
     * @param day �씪
     * @return 怨꾩궛�맂 �씪�옄�쓽 �슂�씪(DAY_OF_WEEK)
     */
    public static String addYMDtoWeek(String sDate, int year, int month, int day) {
    	String dateStr = validChkDate(sDate);
    	
		dateStr = addYearMonthDay(dateStr, year, month, day);
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd",Locale.ENGLISH);
		try {
			cal.setTime(sdf.parse(dateStr));
		} catch (ParseException e) {
			throw new IllegalArgumentException("Invalid date format: " + dateStr);
		}
		
		SimpleDateFormat rsdf = new SimpleDateFormat("E",Locale.ENGLISH);
		
		return rsdf.format(cal.getTime());
	}

    /**
     * �엯�젰�맂 �씪�옄�뿉 �뿰, �썡, �씪, �떆媛�, 遺꾩쓣 媛�媛먰븳 �궇吏�, �떆媛꾩쓣 �룷硫㏃뒪�듃留� �삎�떇�쑝濡� 諛섑솚
     * @param sDate �궇吏�
     * @param sTime �떆媛�
     * @param year �뿰
     * @param month �썡
     * @param day �씪
     * @param hour �떆媛�
     * @param minute 遺�
     * @param formatStr �룷硫㏃뒪�듃留�
     * @return
     */
    public static String addYMDtoDayTime(String sDate, String sTime, int year, int month, int day, int hour, int minute, String formatStr) {
    	String dateStr = validChkDate(sDate);
    	String timeStr = validChkTime(sTime);
    	
		dateStr = addYearMonthDay(dateStr, year, month, day);
		
		dateStr = convertDate(dateStr, timeStr, "yyyyMMddHHmm");      
		
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmm",Locale.ENGLISH);

        try {
    		cal.setTime(sdf.parse(dateStr));
        } catch (ParseException e) {
            throw new IllegalArgumentException("Invalid date format: " + dateStr);
        }
		
		if (hour != 0) {
			cal.add(Calendar.HOUR, hour);
		}

		if (minute != 0) {
			cal.add(Calendar.MINUTE, minute);
		}
		
		SimpleDateFormat rsdf = new SimpleDateFormat(formatStr,Locale.ENGLISH);
		
		return rsdf.format(cal.getTime());
	}
 
    /**
     * �엯�젰�맂 �씪�옄瑜� int �삎�쑝濡� 諛섑솚
     * @param sDate �씪�옄
     * @return int(�씪�옄)
     */
    public static int datetoInt(String sDate) {
    	return Integer.parseInt(convertDate(sDate, "0000", "yyyyMMdd"));
    }
    
    /**
     * �엯�젰�맂 �떆媛꾩쓣 int �삎�쑝濡� 諛섑솚
     * @param sTime �떆媛�
     * @return int(�떆媛�)
     */
    public static int timetoInt(String sTime) {
        return Integer.parseInt(convertDate("00000101", sTime, "HHmm"));
    }

    /**
     * �엯�젰�맂 �씪�옄 臾몄옄�뿴�쓣 �솗�씤�븯怨� 8�옄由щ줈 由ы꽩   
     * @param sDate
     * @return
     */
    public static String validChkDate(String dateStr) {
    	String _dateStr = dateStr;
    	
        if (dateStr == null || !(dateStr.trim().length() == 6 || dateStr.trim().length() == 8 || dateStr.trim().length() == 10)) {
            throw new IllegalArgumentException("Invalid date format: " + dateStr);
        }
        if (dateStr.length() == 10) {
        	_dateStr = StringUtil.removeMinusChar(dateStr);
        }
        return _dateStr;
    }
 
    /**
     * �엯�젰�맂 �씪�옄 臾몄옄�뿴�쓣 �솗�씤�븯怨� 8�옄由щ줈 由ы꽩   
     * @param sDate
     * @return
     */
    public static String validChkTime(String timeStr) {
    	String _timeStr = timeStr;
    	
    	if (timeStr.length() == 5) {
    	    timeStr = StringUtil.remove(timeStr,':');
    	}
    	if (timeStr == null || !(timeStr.trim().length() == 4)) {
    	    throw new IllegalArgumentException("Invalid time format: " + timeStr);
    	}

    	return _timeStr;
    }



	
	/**
	  * �쁽�옱(�븳援�湲곗�) �뀈�룄List�젙蹂대�� �뼸�뒗�떎.                     <BR>
	  * �몴湲곕쾿�� yyyy                                  <BR>
	  * @param  prev �쁽�옱 �씠�쟾 紐뉕컻 �뀈�룄 源뚯�   <BR>
	  * @param  next �쁽�옱 �씠�썑 紐뉕컻 �뀈�룄 源뚯�   <BR>
	  * @return  List      yyyy�삎�깭�쓽 �쁽�옱 �븳援��뀈�룄.   <BR>
	  */
	public static List<String> getYearList(int prev, int next) {// �삱�빐瑜쇨린以��쑝濡� �쟾�썑 紐뉖뀈媛�吏�怨� �삱吏� �엯�젰�븯�뿬 由ъ뒪�듃濡� 戮묐뒗 硫붿꽌�뱶
	    List<String> result = new ArrayList<String>();
	    Calendar aCalendar = Calendar.getInstance();
	   	
	   	int year = aCalendar.get(Calendar.YEAR);

	   	for (int i = year + next; i > year - prev ; i--) {
			
	   		result.add(String.valueOf(i));
		}
		return result;
	}
	
	
	/**
	  * �쁽�옱(�븳援�湲곗�) �뀈�룄List�젙蹂대�� �뼸�뒗�떎.<BR>
	  * �몴湲곕쾿�� yyyy                      <BR>
	  * @param  prev �쁽�옱 �씠�쟾 紐뉕컻 �뀈�룄 源뚯�   <BR>
	  * @param  next �쁽�옱 �씠�썑 紐뉕컻 �뀈�룄 源뚯�   <BR>
	  * @return  List      yyyy�삎�깭�쓽 �쁽�옱 �븳援��뀈�룄.  
	  * @default prev : 3, next : 0       <BR>
	  */
	public static List<String> getYearList(){ 
			return getYearList(3, 0);
	}
    
	/**
	  * 吏��궃�떖�쓽 留덉�留� �궇吏쒕�� 媛��졇�삩�떎
	  * @return  Date  
	  */
	public static Date getLastMonthLastDate() {
		Calendar calendar = Calendar.getInstance();
		calendar.add(Calendar.MONTH, -1);

		int max = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		calendar.set(Calendar.DAY_OF_MONTH, max);

		return calendar.getTime();
	}

	/**
	 * 吏��궃�떖�쓽 留덉�留� �궇吏쒕�� 媛��졇�삩�떎
	 * @return  Date  
	 */
	public static Date getLastDate() {
		Calendar calendar = Calendar.getInstance();
		int max = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
		calendar.set(Calendar.DAY_OF_MONTH, max);
		
		return calendar.getTime();
	}
	
	public static String formatDate(Date date, String ch) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Locale.getDefault());
        String formattedDate = sdf.format(date);
		return formatDate(formattedDate, ch);
	}
}
