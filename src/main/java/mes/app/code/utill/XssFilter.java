package mes.app.code.utill;

import java.util.StringTokenizer;

import org.apache.commons.lang3.StringUtils;

public class XssFilter {

	public static String strFilter(String str){ //XSS 필터링
		StringBuffer sb = null;
		String[] checkStr_arr = {"<script>","</script>","<javascript>","</javascript>","<vbscript>","</vbscript>", "onerror","<textarea>","</textarea>","-->","<!--"
								,"window.top",".log","()","\"","=","<",">",";","//"};
		for(String checkStr : checkStr_arr){
			while(str.indexOf(checkStr)!=-1){
				str = str.replaceAll(checkStr, "");
			}
			while(str.toLowerCase().indexOf(checkStr)!=-1){
				sb = new StringBuffer(str);
				sb = sb.replace(str.toLowerCase().indexOf(checkStr),str.toLowerCase().indexOf(checkStr)+ checkStr.length(), "");
				str = sb.toString();
			}
		}
		return str;
	}
	
	public static boolean refererCheck(String str){ //Referer 체크
		if(StringUtils.isEmpty(str)){
			return false;
		}else{
			String[] sb = new String[str.length()];
			int index = 0;
			StringTokenizer st = new StringTokenizer(str,"/");
			while(st.hasMoreTokens()){
				sb[index] = st.nextToken();
				index++;
			}
			if(sb[1].equals("tmallmaster.pbaplay.com") || sb[1].equals("tmallscm.pbaplay.com") || sb[1].equals("tclubmall.pbaplay.com")
					|| sb[1].equals("tstore.pbaplay.com") || sb[1].equals("localhost:8080") || sb[1].equals("tsso.pbaplay.com")
					|| sb[1].equals("store.pbaplay.com") || sb[1].equals("clubmall.pbaplay.com") 
					|| sb[1].equals("sso.pbaplay.com") || sb[1].equals("mallmaster.pbaplay.com") || sb[1].equals("mallscm.pbaplay.com")){
//				|| sb[1].equals("tstore.pbaplay.com")){
				return true;
			}else{
				System.out.println("str :::::::::::::::: " + str);
				return false;
			}
		}
	}
}
