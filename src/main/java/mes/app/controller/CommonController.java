package mes.app.controller;


import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Controller;

@Controller
@Slf4j
public class CommonController {

  /**
   * 브라우저 구분 얻기.
   *
   * @param request
   * @return
   */
  private String getBrowser(HttpServletRequest request) {
    String header = request.getHeader("User-Agent");
    if (header.indexOf("MSIE") > -1) {
      return "MSIE";
    } else if (header.indexOf("Trident") > -1) { // IE11 문자열 깨짐 방지
      return "Trident";
    } else if (header.indexOf("Chrome") > -1) {
      return "Chrome";
    } else if (header.indexOf("Opera") > -1) {
      return "Opera";
    }
    return "Firefox";
  }

  /**
   * Disposition 지정하기.
   *
   * @param filename
   * @param request
   * @param response
   * @throws Exception
   */
  private HttpHeaders setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
    String browser = getBrowser(request);

    String dispositionPrefix = "attachment; filename=";
    String encodedFilename = null;
    HttpHeaders headers = new HttpHeaders();

    if (browser.equals("MSIE")) {
      encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
    } else if (browser.equals("Trident")) { // IE11 문자열 깨짐 방지
      encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
    } else if (browser.equals("Firefox")) {
      encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
    } else if (browser.equals("Opera")) {
      encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
    } else if (browser.equals("Chrome")) {
      StringBuffer sb = new StringBuffer();
      for (int i = 0; i < filename.length(); i++) {
        char c = filename.charAt(i);
        if (c > '~') {
          sb.append(URLEncoder.encode("" + c, "UTF-8"));
        } else {
          sb.append(c);
        }
      }
      encodedFilename = sb.toString();
    } else {
      throw new IOException("Not supported browser");
    }
    headers.add("Content-Disposition", dispositionPrefix + encodedFilename);
    //	response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

    if ("Opera".equals(browser)) {
      response.setContentType("application/octet-stream;charset=UTF-8");
    }

    return headers;
  }
	
  /**
   * @return String
   * @brief        <pre>
   * null 값을 처리하는 메소드
   *        </pre>
   * @see
   */
  public String f_get_parm(String val) {
		if (val == null) {
			val = "";
		}
    return val;
  }

  protected String getReturnClose(String msg, String tp) {
    String strScript = "";
    strScript += "<script type='text/javascript'>\n";
    if (!"".equals(msg)) {
      strScript += "alert('" + msg + "');\n";
    }
    strScript += "opener.location.href = '" + tp + "'; \n";
    strScript += "window.parent.close(); \n";
    strScript += "</script>";
    return strScript;
  }

  public static String conPOSTFunc(String serverURL, String param) throws Exception{
    URL url;
    HttpURLConnection conn = null;
    int responseCode = 0;
    String returnS = "";
    try{
      url = new URL(serverURL);

      conn = (HttpURLConnection)url.openConnection();
      conn.setConnectTimeout(10000);
      conn.setDoOutput(true);
      conn.setRequestMethod("POST");
      conn.addRequestProperty("Content-Type", "application/json;charset=UTF-8");
      conn.addRequestProperty("Accept", "application/json");
      DataOutputStream out_stream = new DataOutputStream(conn.getOutputStream());

      OutputStream os = conn.getOutputStream();
      os.write(param.getBytes("UTF-8"));
      os.flush();
      InputStreamReader in = new InputStreamReader(conn.getInputStream(),"utf-8");
      BufferedReader br = new BufferedReader(in);
      String strLine;
      String returnString = "";
      while ((strLine = br.readLine()) != null){
        returnString = returnString.concat(strLine);
      }
      returnS = returnString;
    }catch(Exception e){
      e.printStackTrace();
    }finally{try{
      responseCode = conn.getResponseCode();
    }catch(Exception e){
      e.printStackTrace();
    }
      conn.disconnect();
    }
    return returnS;
  }

  public static String conPOSTFuncMap(String serverURL, Properties params) throws Exception{
    URL url;
    HttpURLConnection conn = null;
    int responseCode = 0;
    String returnS = "";
    try{
      url = new URL(serverURL);

      conn = (HttpURLConnection)url.openConnection();
      conn.setConnectTimeout(10000);
      conn.setDoOutput(true);
      conn.setRequestMethod("POST");
      conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");

      // parameter SET
      String paramString = "";
      if (params != null) {
        paramString = encodeString(params);
      }

      DataOutputStream out = null;
      out = new DataOutputStream(conn.getOutputStream());
      out.writeBytes(paramString);
      out.flush();
      out.close();

      InputStreamReader in = new InputStreamReader(conn.getInputStream(),"utf-8");
      BufferedReader br = new BufferedReader(in);
      String strLine;
      String returnString = "";
      while ((strLine = br.readLine()) != null){
        returnString = returnString.concat(strLine);
      }
      returnS = returnString;
    }catch(Exception e){
      e.printStackTrace();
    }finally{try{
      responseCode = conn.getResponseCode();
    }catch(Exception e){
      e.printStackTrace();
    }
      conn.disconnect();
    }
    return returnS;
  }

  public static String encodeString(Properties params) {
    StringBuffer sb = new StringBuffer(256);
    Enumeration names = params.propertyNames();

    while (names.hasMoreElements()) {
      String name = (String) names.nextElement();
      String value = params.getProperty(name);
      sb.append(URLEncoder.encode(name) + "=" + URLEncoder.encode(value) );

      if (names.hasMoreElements()) sb.append("&");
    }
    return sb.toString();
  }
}
