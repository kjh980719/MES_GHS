package mes.app.util;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.regex.Pattern;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.ContextLoader;
import org.springframework.web.context.WebApplicationContext;

import mes.exception.ServiceException;
import mes.security.UserInfo;

public class Util {
	
	/**
	 * 로깅용 로거
	 * log4j.xml 에 로거명 일치할 것.
	 */
	private static Logger logger = LoggerFactory.getLogger("***** My Debug !!! *****"); 

	public static void main(String[] args) {
	//	System.out.println("1.23--41.23-4".replaceAll("[.-]", ""));
		System.out.println("00--34..1.2345".replaceAll("[.-]", "").matches("^([1-9])[0-9]{8}$"));
		System.out.println(getUUID());
	}

	/**
	 * 스프링 시큐리티에 의해 만들어진 사용자 정보 가져오기. 
	 */
	public static UserInfo getUserInfo()
	{
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if(authentication != null) {
			Object userInfo = authentication.getPrincipal();
			if(userInfo instanceof UserInfo) {
				return (UserInfo)userInfo;
			}
		}
		return null;	
	}

	/**
	 * 스프링 시큐리티에 의해 만들어진 사용자 정보 가져오기. 
	 */
	public static String getUserInfo(String field) 
	{
		UserInfo userInfo = getUserInfo();
		if(userInfo != null) {
			String value = "";
			try{
				value = (String) userInfo.getClass().getMethod(toGetterMethodName(field)).invoke(userInfo);				
			}catch(Exception e){
				e.printStackTrace();
			}
			return value;
		}else{
			return "";
		}
	}
	
	/**
	 * UUID 만들기.
	 */
	public static String getUUID() {
		return UUID.randomUUID().toString().replace("-", "");
	}

	/**
	 * 나노 타임
	 */
	public static String getNanoTimeStr() {
		return String.valueOf(System.nanoTime());
	}
	public static String getNanoTimeStr(int length) {
		String nano = getNanoTimeStr();
		return nano.substring(0, Math.min(length, nano.length()));
	}
	
	/**
	 * DTO 등의 getter 메서드명 만들기. 
	 */
	public static String toGetterMethodName(String key)
	{
		return "get" + key.toUpperCase().charAt(0) + key.substring(1);
	}
	
	/**
	 * Map 의 값을 지정한 클래스 객체로(주로 DTO) 생성.
	 */
//	public static <T> T mapToBean(Map map, Class<T> c)
//	{
//		try {
//			T t = c.newInstance();
//			BeanUtils.populate(t, map);
//			return t;
//		} catch (Exception e) {
//			throw new ServiceException(e);
//		}
//	}
	
	/**
	 * 값 동일 여부 확인.
	 */
//	public static boolean is(Object thisValue, Object thatValue)
//	{
//		thisValue = thisValue instanceof PeriodCodes ? ((PeriodCodes)thisValue).getCode() : thisValue;
//		thatValue = thatValue instanceof PeriodCodes ? ((PeriodCodes)thatValue).getCode() : thatValue;
//		return (thisValue == null || thatValue == null) ? false : thisValue.equals(thatValue);
//	}

	/**
	 * 값 포함 여부 확인.
	 */
//	public static boolean isIn(Object thisValue, Object...thatValues)
//	{
//		thisValue = thisValue instanceof PeriodCodes ? ((PeriodCodes)thisValue).getCode() : thisValue;
//		for(int n=0; n<thatValues.length; n++)
//		{
//			Object thatValue = thatValues[n];
//			thatValue = thatValue instanceof PeriodCodes ? ((PeriodCodes)thatValue).getCode() : thatValue;
//			if( (thisValue == null || thatValue == null) ? false : thisValue.equals(thatValue) )
//			{
//				return true;
//			}
//		}
//		return false;
//	}
	
	/**
	 * 널/빈 문자열 여부 확인. 문자열 "null" 도 포함.
	 */
	public static boolean isNull(Object str)
	{
		if(str == null || "".equals(str) || "null".equals(str))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	
	/**
	 * 값이 널이면 빈 문자열 리턴, 아니면 해당 값 그대로 리턴.
	 */
	public static <T> T nvl(T source)
	{
		return (T) nvl(source, "");
	}
	
	/**
	 * 값이 널이면 지정한 대체 값 리턴, 아니면 해당 값 그대로 리턴.
	 */
	public static <T> T nvl(T source, T defaultValue)
	{
		if(isNull(source))
		{
			return defaultValue;
		}
		else
		{
			return source;
		}		
	}
	
	/**
	 * 디버그용 로그 남기기.
	 */
//	public static void debug(Object content)
//	{
//		if(logger.isDebugEnabled()) Util.debug(3, "{}", content);
//	}

	/**
	 * 지정한 포멧으로 디버그용 로그 남기기. 
	 */
//	public static void debugFormat(String format, Object...param)
//	{
//		if(logger.isDebugEnabled()) Util.debug(3, format, param);
//	}
	
	/**
	 * Json 포멧으로 디버그용 로그 남기기.
	 */
//	public static void debugJson(Object content)
//	{
//		if(logger.isDebugEnabled())
//		{
//			try
//			{
//				ObjectMapper om = new ObjectMapper();
//				om.enable(SerializationFeature.INDENT_OUTPUT);
//				Util.debug(3, "{}", om.writeValueAsString(content));
//			}
//			catch(Exception e)
//			{
//				e.printStackTrace();
//				throw new ServiceException(e);
//			}
//		}
//	}
	
	/**
	 * private. 디버그용 로그 남기기.
	 */
//	private static void debug(int callerStackIdx, String format, Object...params)
//	{
//		StackTraceElement caller = Thread.currentThread().getStackTrace()[callerStackIdx];
//		Object[] defaultParam = new Object[] {caller.getClassName(), caller.getMethodName(), caller.getLineNumber()};
//		logger.debug("{}.{} [{} line]\n"+format, ArrayUtils.addAll(defaultParam, params));
//	}
	
	/**
	 * 현재 서버 아이피 가져오기.
	 * @throws UnknownHostException 
	 */
	public static String getLocalHostAddress()
	{
		try{
			return InetAddress.getLocalHost().getHostAddress();			
		}catch(Exception e){
			return "";
		}
	}
	
	/**
	 * 오늘 날짜 문자열로 리턴
	 */
	public static final String Ymd = "yyyyMMdd";
	public static final String YmdHms = "yyyyMMddHHmmss";
	public static final String YmdHmsS = "yyyyMMddHHmmssSSS";
	public static final String YmdFmt = "yyyy.MM.dd";
	public static final String YmdHmsFmt = "yyyy.MM.dd HH:mm:ss";
	public static final String YmdHmsSFmt = "yyyy.MM.dd. HH:mm:ss SSS";	
	public static String getToday()
	{
		return getToday(Ymd);
	}
	public static String getToday(String format)
	{
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		return sdf.format(new Date());
	}
	public static String convertDateStrFormat(String value, String fromFmt, String toFmt)
	{
		try{
			Date d = new SimpleDateFormat(fromFmt).parse(value);
			return new SimpleDateFormat(toFmt).format(d);
		}catch(Exception e){
			return value;
		}
	}

	public static String toString(Object o) 
	{
		if(o instanceof Object[]) {
			return Arrays.toString((Object[])o);
		}else if(o instanceof List) {
			return Arrays.toString(((List)o).toArray());
		}else{
			return o.toString();
		}
	}
	
	//비밀번호 체크용
	public static void validatePasswordRegex(String newPwd)
	{
		//유효성 체크
		if(!Pattern.compile("((?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^A-Za-z0-9]).{8,20})").matcher(newPwd).matches())
		{
			throw new ServiceException("ERROR_NEW_PWD_INVALID_REGEX1");
		}
		//동일한 숫자, 문자 입력 체크
		if(Pattern.compile("([a-zA-Z\\d])\\1\\1+"/*, Pattern.CASE_INSENSITIVE*/).matcher(newPwd).find())
		{
			throw new ServiceException("ERROR_NEW_PWD_INVALID_REGEX2");
		}
		//연속된 숫자, 문자 체크
		boolean testRes = true;
		for(int n=0; n<newPwd.length()-2; n++)
		{
			char c1 = newPwd.charAt(n);
			char c2 = newPwd.charAt(n+1);
			char c3 = newPwd.charAt(n+2);
			if( Math.abs(c1-c2) == 1 && Math.abs(c2-c3) == 1)
			{
				testRes = false;
				break;
			}			
		}
		if(!testRes) 
		{
			throw new ServiceException("ERROR_NEW_PWD_INVALID_REGEX3");
		}		
	}
	
	//Vector 금액필드 전환용 double -> String 시 .90 -> .89999999999999999
	public static String parseForWon(String AMT, boolean pYN){
		if(AMT.equals("")) return "";
		
		NumberFormat nf = NumberFormat.getInstance(); //NumberFormat 객체 생성
		nf.setGroupingUsed(false);
		Double d_value = Double.parseDouble(AMT.replaceAll(",",""));
		if(pYN){
			d_value = d_value * 100;
		} else {
			nf.setMaximumFractionDigits(2); // 2 dp floating
			nf.setMinimumFractionDigits(2); // as above
			d_value = d_value / 100;
		}
		
		String value = nf.format(d_value); //포맷에 맞춤 
		
		return value;
	}
	
	//SAP 숫자필드 0 채운 값 제거
	public static String removeIntZero(String Str){
		if(Str.equals("")) return "";
		
		Integer ii = Integer.parseInt(Str);
		return String.valueOf(ii);
	}
	//현재 년도가 아닌경우 exception 을 thorow 한다. 체크할 vo는 getYyyy() 메소드가 있어야 한다. 
//	public static void checkCurrentYear(Object vo) throws Exception {
//		Class<?> clazz = vo.getClass();
//		String result = "";
//		Method getYyyy = clazz.getDeclaredMethod("getYyyy");
//		result = (String) getYyyy.invoke(vo);
//		if(!result.equals(DateUtil.getCurrentYear())) {
//			WebApplicationContext context = ContextLoader.getCurrentWebApplicationContext();
//			MessageSourceAccessor msa = context.getBean(MessageSourceAccessor.class);
//			throw new Exception(msa.getMessage("fail.common.year"));
//		}
//	}

	public static Object getBean(String beanName) {
		WebApplicationContext context = ContextLoader.getCurrentWebApplicationContext();
		return context.getBean(beanName);
	}

	public static String getNow(String format){
		return LocalDateTime.now().format(DateTimeFormatter.ofPattern(format));
	}

	public static boolean isPositiveNumber(String number){
		try{
			return Integer.parseInt(number) > 0;
		}catch(Exception e){
			return false;
		}
	}

	public static void setPageInfo(Map paramMap, String...defaultArr){
		if(paramMap.get("currentPage") == null || !Util.isPositiveNumber(paramMap.get("currentPage").toString())) {
			paramMap.put("currentPage", 1);
		}
		if(paramMap.get("rowsPerPage") == null  || !Util.isPositiveNumber(paramMap.get("rowsPerPage").toString())) {
			paramMap.put("rowsPerPage", 15);
		}
		if(paramMap.get("searchText") == null) {
			paramMap.put("searchText", "");
		}
		if(paramMap.get("searchKeyword") == null) {
			paramMap.put("searchKeyword", "");
		}
		if(paramMap.get("searchType") == null) {
			paramMap.put("searchType", "");
		}
		if(paramMap.get("startDate") == null || "".equals(String.valueOf(paramMap.get("startDate")))) {
			paramMap.put("startDate", getNow("yyyy-MM-dd"));
		}
		if(paramMap.get("endDate") == null || "".equals(String.valueOf(paramMap.get("endDate")))){
			paramMap.put("endDate", getNow("yyyy-MM-dd"));
		}
		if(defaultArr != null && defaultArr.length % 2 == 0){
			for(int i = 0; i < defaultArr.length; i += 2){
				if(paramMap.get(defaultArr[i]) == null || paramMap.get(defaultArr[i]).toString().length() == 0){
					paramMap.put(defaultArr[i], defaultArr[i+1]);
				}
			}
		}
	}

	public static String timeFormat00(Object obj, int maxTime){
		String str = obj.toString();
		int time = -1;
		try{
			time = Integer.parseInt(str);
		}catch (NumberFormatException e){
			return "00";
		}
		if(str.length() == 1 && time < 10)
			return "0" + str;
		else if(str.length() == 1 && time < 10)
			return str;
		else if(time < maxTime)
			return str;
		else
			return "00";
	}
}
