package mes.app.controller.cust;

import mes.app.service.code.ComCodeService;
import mes.app.service.cust.CustService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value="/cust")
public class CustController {

    @Autowired
    private CustService custService;

    @Autowired
    private ComCodeService comCodeService;


    @RequestMapping(value="/cust")
    public String custPage(Model model, @RequestParam Map param) {

        String use_yn = "";
        String search_string = "";
        String search_type = "";
        int rowsPerPage = 0;
        int currentPage = 1;

        if (param.get("use_yn") == null  || param.get("use_yn").equals("")) {
        	use_yn = "Y";
        }else {
        	use_yn = (String) param.get("use_yn");
        }
 
        if(param.get("search_string") == null  || param.get("search_string").equals("")) {
        	search_string = "";
        }else {
        	search_string = (String) param.get("search_string");
        }
        
        if (param.get("search_type") == null  || param.get("search_type").equals("")) {
        	search_type = "ALL";
        }else {
        	search_type = (String) param.get("search_type");
        }
        
        if (param.get("currentPage") == null || param.get("currentPage").equals("")) {
        	currentPage = 1;
        }else {
        	currentPage = Integer.parseInt((String) param.get("currentPage"));
        }
        
        if (param.get("rowsPerPage") == null || param.get("rowsPerPage").equals("")) {
        	rowsPerPage = 15;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }
        
      
        String parameter = "&rowsPerPage=" + rowsPerPage + "&search_type=" + search_type + "&useYN="+use_yn+"&search_string="+search_string;
        String sQuery = "";
        
        sQuery += " A.use_yn = '" +use_yn +"'"; 

        if (search_type.equals("CUST_NAME") && !search_string.equals("")) {
        	sQuery += " AND A.CUST_NAME like '%" + search_string +"%'";
        }else if(search_type.equals("BUSINESS_NO") && !search_string.equals("")) {
        	sQuery += " AND A.BUSINESS_NO like '%" + search_string + "%'" ;	
        }else if(search_type.equals("BOSS_NAME") && !search_string.equals("")) {
        	sQuery += " AND A.BOSS_NAME like '%" + search_string + "%'" ;
        }else if(search_type.equals("REMARKS_WIN") && !search_string.equals("")) {
        	sQuery += " AND A.REMARKS_WIN like '%" + search_string + "%'" ;
        }else if(search_type.equals("ALL") && !search_string.equals("")){
        	sQuery += "AND concat(A.CUST_NAME,'|',A.BUSINESS_NO,'|',A.BOSS_NAME,'|',REMARKS_WIN) like concat('%','"+ search_string +"','%')";	
        }

        Map paramMap = new HashMap();

        paramMap.put("currentPage", currentPage);	
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);
        paramMap.put("use_yn",use_yn);
        paramMap.put("search_type",search_type);
        
        model.addAttribute("parameter", parameter);
        model.addAttribute("search", paramMap);

        Map commonMap = new HashMap();
        //기초코드 
        commonMap.put("code_id","EX");
        model.addAttribute("custExchangeCode", comCodeService.comCodeDetailSelectList(commonMap));
        commonMap.put("code_id","CCG");
        model.addAttribute("custGubunCode", comCodeService.comCodeDetailSelectList(commonMap));
        commonMap.put("code_id","CT");
        model.addAttribute("custGroupCode", comCodeService.comCodeDetailSelectList(commonMap));
        commonMap.put("code_id","TT");
        model.addAttribute("tradeCode", comCodeService.comCodeDetailSelectList(commonMap));
        commonMap.put("code_id","CLIST");
        model.addAttribute("clist", comCodeService.comCodeDetailSelectList(commonMap));
        commonMap.put("code_id","MG");
        model.addAttribute("memberGradeCodeList", comCodeService.comCodeDetailSelectList(commonMap));

    	model.addAttribute("total", custService.custListTotal(paramMap));        
        model.addAttribute("list", custService.getCustList(paramMap));
        

        return "/cust/cust";
    }
    

    
    @PostMapping(value = "/getCustList"
            , produces="application/json")
    @ResponseBody
    public Map getCustList(@RequestBody Map paramMap) {
        System.out.println("paramMap : "+paramMap);
        return JsonResponse.asSuccess("storeData", custService.getCustList(paramMap));
    }
    
    @GetMapping(value = "/selectCust"
            , produces="application/json")
    @ResponseBody
    public Map selectCust(@RequestParam(value="CUST_SEQ", required=false) String CUST_SEQ) {
    	Map map = new HashMap();

        map.put("CUST_SEQ", Integer.parseInt(CUST_SEQ));
        return JsonResponse.asSuccess("storeData", custService.selectCust(map));
    }
    

    @PostMapping(value = "/createCust"
            , produces="application/json")
    @ResponseBody
    public Map createcust(@RequestBody Map paramMap) {
    	custService.createCust(paramMap);
    	System.out.println(paramMap);
		/*
		 * Map<String, Object> paramMap2 = new HashMap<String, Object>();
		 * paramMap2.put("COM_CODE","81546"); String ZONE=null; try{
		 * ZONE=API.urlConnect("https://oapi.ecounterp.com/OAPI/V2/Zone", "POST",
		 * paramMap2,"Data","ZONE"); }catch (Exception e) { e.printStackTrace(); }
		 * 
		 * System.out.println(ZONE); paramMap2.put("ZONE",ZONE);
		 * paramMap2.put("USER_ID","red-angle");
		 * paramMap2.put("API_CERT_KEY","36e049b8f84954170bbc2f798ac66bad74"); String
		 * SESSION_ID=null; try{ SESSION_ID=API.urlConnect("https://oapi"+ZONE+
		 * ".ecounterp.com/OAPI/V2/OAPILogin", "POST",
		 * paramMap2,"Data","Datas","SESSION_ID"); }catch (Exception e) {
		 * e.printStackTrace(); } System.out.println(SESSION_ID); try{ String
		 * a=API.urlConnectInsert("https://oapi"+ZONE+
		 * ".ecounterp.com/OAPI/V2/AccountBasic/SaveBasicCust?SESSION_ID="+SESSION_ID,
		 * "POST", paramMap,"CustList"); System.out.println(a); }catch (Exception e) {
		 * e.printStackTrace(); }
		 */
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/updateCust"
            , produces="application/json")
    @ResponseBody
    public Map updateCust(@RequestBody Map paramMap) {
    	custService.updateCust(paramMap);
        return JsonResponse.asSuccess();
    }

}
