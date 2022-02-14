package mes.app.controller.supervisor;



import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.fasterxml.jackson.core.JsonParseException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;



public class API {

    @SuppressWarnings("unchecked")
    public static String urlConnect(String uri, String method, Map<String, Object> paramMap,String key,String value) throws Exception{
        JSONObject jsonParam = new JSONObject();
        jsonParam.putAll(paramMap);
        URL url = new URL(uri);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setConnectTimeout(5000); 
        con.setReadTimeout(5000);
        con.setRequestMethod(method);
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoInput(true);
        con.setDoOutput(true); 
        con.setUseCaches(false);
        con.setDefaultUseCaches(false);
        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
        wr.write(jsonParam.toJSONString()); 
        wr.flush();
        StringBuilder sb = new StringBuilder();
        if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(con.getInputStream(), "utf-8"));
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            br.close();

        } else {

        }JSONParser parser = new JSONParser();
        System.out.println("sb.toString : " + sb.toString() + "//");
        Object obj = parser.parse( sb.toString() );
        JSONObject jsonObj = (JSONObject) obj;
        System.out.println(jsonObj);
        String data=String.valueOf((jsonObj.get(key)));
        Object dataobj = parser.parse( data );
        JSONObject ZONEVALUE=(JSONObject) dataobj;
        
        String result=String.valueOf((ZONEVALUE.get(value)));
        
        return result;
        
    }
    
    @SuppressWarnings("unchecked")
    public static String urlConnectInsert(String uri, String method, Map<String, Object> paramMap,String key) throws Exception{
    	 
        JSONObject jsonParam1 = new JSONObject();
        jsonParam1.putAll(paramMap);
        JSONObject jsonParam2 = new JSONObject();
        jsonParam2.put("Line", "0");
        jsonParam2.put("BulkDatas", jsonParam1);
        JSONArray ProductList=new JSONArray();
        ProductList.add(jsonParam2);
        System.out.println(ProductList);
        JSONObject jsonParam = new JSONObject();
        jsonParam.put(key, ProductList);
        URL url = new URL(uri);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setConnectTimeout(5000); 
        con.setReadTimeout(5000);
        con.setRequestMethod(method);
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoInput(true);
        con.setDoOutput(true); 
        con.setUseCaches(false);
        con.setDefaultUseCaches(false);
        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
        wr.write(jsonParam.toJSONString()); 
        wr.flush();
        StringBuilder sb = new StringBuilder();
        if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(con.getInputStream(), "utf-8"));
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            br.close();

        } else {

        }JSONParser parser = new JSONParser();
        System.out.println("sb.toString : " + sb.toString() + "//");
        Object obj = parser.parse( sb.toString() );
        JSONObject jsonObj = (JSONObject) obj;
        System.out.println(jsonObj);
        String data=String.valueOf((jsonObj.get(key)));
       
        return data;
        
    }
    
    @SuppressWarnings("unchecked")
    public static String urlConnect(String uri, String method, Map<String, Object> paramMap,String key1,String key2,String value) throws Exception{
        JSONObject jsonParam = new JSONObject();
        jsonParam.putAll(paramMap);
        URL url = new URL(uri);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setConnectTimeout(5000); 
        con.setReadTimeout(5000);
        con.setRequestMethod(method);
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoInput(true);
        con.setDoOutput(true); 
        con.setUseCaches(false);
        con.setDefaultUseCaches(false);
        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
        wr.write(jsonParam.toJSONString()); 
        wr.flush();
        StringBuilder sb = new StringBuilder();
        if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(con.getInputStream(), "utf-8"));
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            br.close();

        } else {

        }JSONParser parser = new JSONParser();
        Object obj = parser.parse( sb.toString() );
        JSONObject jsonObj = (JSONObject) obj;
        System.out.println(jsonObj);
        String key1data=String.valueOf((jsonObj.get(key1)));
        
        Object key2data = parser.parse(key1data);
        JSONObject KEY2=(JSONObject) key2data;
        
        String subresult=String.valueOf((KEY2.get(key2)));
        
        Object dataobj = parser.parse(subresult);
        JSONObject ZONEVALUE=(JSONObject) dataobj;
        
        String result=String.valueOf((ZONEVALUE.get(value)));
        
        return result;
        
    }

    @SuppressWarnings("unchecked")
    public static String urlConnect(String uri, String method, List<Map<String, Object>> paramMapList) throws Exception{
        JSONArray array = new JSONArray();
        array.add(paramMapList);
        URL url = new URL(uri);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setConnectTimeout(5000); 
        con.setReadTimeout(5000); 
        con.setRequestMethod(method);
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoInput(true);
        con.setDoOutput(true); 
        con.setUseCaches(false);
        con.setDefaultUseCaches(false);
        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
        wr.write(array.toJSONString()); 
        wr.flush();
        StringBuilder sb = new StringBuilder();
        if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(con.getInputStream(), "utf-8"));
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
               
            }
           
            br.close();
        } else {
        }
        return sb.toString();
    }

    @SuppressWarnings("unchecked")
    public static String urlConnect(String uri, String method, int readTimeOut, Map<String, Object> paramMap) throws Exception{
        JSONObject jsonParam = new JSONObject();
        jsonParam.putAll(paramMap);
        URL url = new URL(uri);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setConnectTimeout(5000); 
        con.setReadTimeout(readTimeOut); 
        con.setRequestMethod(method);
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoInput(true);
        con.setDoOutput(true); 
        con.setUseCaches(false);
        con.setDefaultUseCaches(false);
        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
        wr.write(jsonParam.toJSONString()); 
        wr.flush();
        StringBuilder sb = new StringBuilder();
        if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
            BufferedReader br = new BufferedReader(
                    new InputStreamReader(con.getInputStream(), "utf-8"));
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line).append("\n");
            }
            br.close();
            System.out.println(uri + "\n" + sb.toString());
        } else {
        }
        return sb.toString();
    }
    
    @SuppressWarnings("unchecked")
    public static Map<String, Object> getMapFromJsonObject( JSONObject jsonObj )
    {
        Map<String, Object> map = null;
        
        try {
            
            map = new ObjectMapper().readValue(jsonObj.toJSONString(), Map.class) ;
            
        } catch (JsonParseException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
 
        return map;
    }
    
    public static Map<String, Object> CALLAPI() {
	    Map<String, Object> paramMap2 = new HashMap<String, Object>();
	    paramMap2.put("COM_CODE","81546");
	    String ZONE=null;
	    try{
	        ZONE=API.urlConnect("https://oapi.ecounterp.com/OAPI/V2/Zone", "POST", paramMap2,"Data","ZONE");
	        }catch (Exception e) {
			e.printStackTrace();
			}
	    
	  System.out.println(ZONE);
	    paramMap2.put("ZONE",ZONE);
	    paramMap2.put("USER_ID","red-angle");
	    paramMap2.put("API_CERT_KEY","36e049b8f84954170bbc2f798ac66bad74");
	    String SESSION_ID=null;
	    try{
	    	SESSION_ID=API.urlConnect("https://oapi"+ZONE+".ecounterp.com/OAPI/V2/OAPILogin", "POST", paramMap2,"Data","Datas","SESSION_ID");
	    }catch (Exception e) {
			e.printStackTrace();
			}
	    System.out.println(SESSION_ID);
	    paramMap2.put("SESSION_ID",SESSION_ID);
	    
	    return paramMap2;
	    }



}