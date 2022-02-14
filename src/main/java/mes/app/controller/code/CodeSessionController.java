package mes.app.controller.code;

public class CodeSessionController {
	protected String returnValue = "";	
	protected String returnPage = "";
	
	public CodeSessionController() {
		returnPage = "/returnPage";
		returnValue = "";
	}
	
	public String getReturnPage() {
		return returnPage;
	}

	public void setReturnPage(String returnPage) {
		this.returnPage = returnPage;
	}
	/**
	 * 리턴 관련 메쏘드1
	 * 
	 * @return String
	 * @throws Exception
	 */
	protected String getReturnProc(String msg, String url) throws Exception {
		String strScript = "";
		strScript += "<script type='text/javaScript' language='javascript'> \n";
		if(!msg.equals(""))
			strScript += "alert('"+msg+"'); \n";
		if(!url.equals(""))
			strScript += "location.href='"+url+"';";
		strScript += "</script>";
		return strScript;
	}
	
	/**
	 * 리턴 관련 메쏘드2
	 * 
	 * @return String
	 * @throws Exception
	 */
	protected String getReturnPage(String msg, String tp) {
		String strScript = "";
		strScript += "<script type='text/javascript'>\n";
		if(!msg.equals(""))
			strScript += "alert('"+msg+"');\n";
		if(tp.equals("B")){
			strScript += "history.back();\n";	
		}else if(tp.equals("C")){
			strScript += "self.close();\n";	
		}else if(tp.equals("CO")){
			//strScript += "opener.location.reload();\n";
			strScript += "window.opener.document.location.href = window.opener.document.URL;\n";
			strScript += "self.close();\n";
		}else if(tp.equals("FC")){
			strScript += "parent.goComPopupEnd();\n";
		}else if(!tp.equals("")){
			strScript += "location.href='"+tp+"';\n";
		}
		
		strScript += "</script>";
		return strScript;
	}
	
	/** parent 리턴 
	 * @param msg
	 * @param tp
	 * @param ptarget (parent. ,opener.) 
	 * @return
	 */
	protected String getReturnPage(String msg, String tp, String ptarget) {
		
		String strScript = "";
		strScript += "<script type='text/javascript'>\n";
		
		if(!msg.equals(""))	strScript += "alert('"+msg+"');\n";
		strScript += ptarget + "location.href='"+tp+"';\n";
		if(ptarget.equals("opener.")) strScript += "self.close(); \n";
		strScript += "</script>";
		return strScript;
	}
	
	/** parent 함수 호출
	 * @param msg
	 * @param tp
	 * @param fn (goList()) 
	 * @return
	 */
	protected String getReturnFn(String msg, String fn) {
		
		String strScript = "";
		strScript += "<script type='text/javascript'>\n";
		
		if(!msg.equals(""))	strScript += "alert('"+msg+"');\n";
		strScript += "parent."+fn+";\n";
		
		strScript += "</script>";
		return strScript;
	}
	
	
	/**
	 * 로그인 리턴 관련 메쏘드
	 * 
	 * @return String
	 * @throws Exception
	 */
	protected String getReturnLogin(String rtnurl) {
		String strScript = "";
		strScript += "<script type='text/javaScript' language='javascript'>";
		strScript += "alert('로그인이 필요합니다.');";
		strScript += "location.href='/member/memberLoginForm.do";
		if(!rtnurl.equals(""))
			strScript += "?return_url="+rtnurl;
		strScript += "';";
		strScript += "</script>";
		return strScript;
	}
	

	public String getReturnValue() {
		return returnValue;
	}

	public void setReturnValue(String returnValue) {
		this.returnValue = returnValue;
	}
}
