package mes.common.service;


import lombok.extern.slf4j.Slf4j;
import mes.app.controller.supervisor.API;
import mes.app.util.Util;
import mes.exception.RestTemplateErrorHandler;
import mes.security.UserInfo;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import org.springframework.web.client.RestTemplate;


import java.io.*;
import java.net.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import java.util.Map;

@Service
@Slf4j
public class APISend {
    private static String CRTFCKEY = "$5$API$7SQZIAgjhmno7pzhENrZBnqEmvOEd6W7gLp9J6DPLJ.";
    private static String SENDURL = "https://log.smart-factory.kr/apisvc/sendLogData.json";

    public String send(String sendUrl, String jsonValue) {
        String inputLine = null;
        StringBuffer outResult = new StringBuffer();

        try {
            URL url = new URL(sendUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            conn.setRequestProperty("Accept-Charset", "UTF-8");
            conn.setConnectTimeout(10000);
            conn.setReadTimeout(10000);

            OutputStream os = conn.getOutputStream();
            os.write(jsonValue.getBytes("UTF-8"));
            os.flush();
            System.out.println(jsonValue);

            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            while ((inputLine = in.readLine()) != null) {
                outResult.append(inputLine);
            }
            conn.disconnect();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return outResult.toString();
    }

    public void post(Map map) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();

            headers.add("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8");

            MultiValueMap params = new LinkedMultiValueMap<String, String>();


            params.add("crtfcKey", CRTFCKEY); //로그API 인증키
            params.add("logDt", map.get("logDt")); //로그일시
            params.add("useSe", map.get("useSe")); //접속구분
            params.add("sysUser", map.get("sysUser")); //사용자
            params.add("conectIp", map.get("conectIp")); //IP번호
            params.add("dataUsgqty", map.get("dataUsgqty")); // 데이터사용량(숫자)


            HttpEntity<MultiValueMap> body = new HttpEntity<MultiValueMap>(params,headers);

            restTemplate.setErrorHandler(new RestTemplateErrorHandler());
            ResponseEntity<String> result = restTemplate.postForEntity(new URI(SENDURL), body, String.class);
            log.info("request >> " + body);
            log.info("status_code >> " + result.getStatusCode());
            log.info("response >> " + result.getBody());
        }catch (Exception e){
            System.err.println(e.toString());
        }

    }

    public static void postProduct() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();

            headers.add("Accept", MediaType.APPLICATION_JSON_VALUE);
            headers.add("Content-Type", MediaType.APPLICATION_FORM_URLENCODED_VALUE + ";charset=UTF-8");

            MultiValueMap params = new LinkedMultiValueMap<String, String>();
            params.add("SESSION_ID", API.CALLAPI().get("SESSION_ID"));

            String url = "https://oapi"+ API.CALLAPI().get("ZONE")+".ecount.com/OAPI/V2/InventoryBasic/GetBasicProductList";

            HttpEntity<MultiValueMap> body = new HttpEntity<MultiValueMap>(params,headers);

            restTemplate.setErrorHandler(new RestTemplateErrorHandler());
            ResponseEntity<String> result = restTemplate.postForEntity(new URI(url), body, String.class);
            log.info("request >> " + body);
            log.info("status_code >> " + result.getStatusCode());
            log.info("response >> " + result.getBody());
        }catch (Exception e){
            System.err.println(e.toString());
        }

    }

    public void sendLog(String useSe, int dataUsgqty, String conectIp, String sysUser){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
        Date now = new Date();
        String strDate = sdf.format(now);

        Map map = new HashMap();
        map.put("useSe",useSe);
        map.put("dataUsgqty",dataUsgqty);
        map.put("conectIp",conectIp);
        map.put("sysUser",sysUser);
        map.put("logDt",strDate);

        this.post(map);
    }


}