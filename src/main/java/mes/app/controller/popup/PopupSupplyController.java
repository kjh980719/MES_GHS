package mes.app.controller.popup;

import mes.app.service.cust.CustService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/supply")
public class PopupSupplyController{

    @Autowired
    private SupplyService supplyService;
    @Autowired
    private CustService custService;



    @PostMapping(value = "/popSupplyAccountCreate"
            , produces="application/json")
    @ResponseBody 
    public Map<String,Object> popSupplyAccountCreate(Model model,@RequestParam Map param) {

       return  JsonResponse.asSuccess("storeData", supplyService.getScmManagerList(param));
    }
    
    @RequestMapping(value="/popSupplyList")
    public String popSupplyList(Model model,@RequestParam Map param) {
    	System.out.println("param >> " + param);
    	model.addAttribute("param", param);
       return "empty:/popSupplyList";
    }

    @RequestMapping(value="/popSupplyList2")
    public String popSupplyList2(Model model,@RequestParam Map param) {
        System.out.println("param >> " + param);
        model.addAttribute("param", param);
        return "empty:/popSupplyList2";
    }
    
    @RequestMapping(value="/getSupplyList")
    @ResponseBody
    public Map getSupplyList(Model model,@RequestParam Map param) {

        String search_string = "";
        String search_type = "";

        int currentPage = 1;


        if(param.get("search_string") == null) {
        	search_string = "";
        }else {
        	search_string = (String) param.get("search_string");
        }
        
        if (param.get("search_type") == null) {
        	search_type = "ALL";
        }else {
        	search_type = (String) param.get("search_type");
        }
        
        if (param.get("currentPage") == null || param.get("currentPage").equals("")) {
        	currentPage = 1;
        }else {
        	currentPage = Integer.parseInt((String) param.get("currentPage"));
        }


        String sQuery = "";
        
        sQuery += "A.USE_YN = 'Y' ";

        if (search_type.equals("CUST_NAME") && !search_string.equals("")) {
        	sQuery += " AND A.CUST_NAME like '%" + search_string +"%'";
        }else if(search_type.equals("REMARKS_WIN") && !search_string.equals("")) {
        	sQuery += " AND A.REMARKS_WIN like '%" + search_string + "%'" ;
        }else if(search_type.equals("ALL") && !search_string.equals("")){
        	sQuery += " AND ( A.CUST_NAME like '%" + search_string + "%' OR A.REMARKS_WIN like '%" + search_string + "%')";   	
        }

        Map paramMap = new HashMap();

        paramMap.put("currentPage", currentPage);	
        paramMap.put("rowsPerPage", 10);
        paramMap.put("sQuery", sQuery);
        paramMap.put("search_type",search_type);

        Map resultMap = new HashMap();
        resultMap.put("list", custService.custList(paramMap));
        resultMap.put("total", custService.custListTotal(paramMap));
        resultMap.put("search", paramMap);
        
        
        return JsonResponse.asSuccess("storeData", resultMap);  
    }

    @RequestMapping(value="/getCustList")
    @ResponseBody
    public Map getCustList(Model model,@RequestParam Map param) {

        String search_string = "";
        String search_type = "";
        int rowsPerPage = 0;
        int currentPage = 1;

        if(param.get("search_string") == null) {
            search_string = "";
        }else {
            search_string = (String) param.get("search_string");
        }

        if (param.get("search_type") == null) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
        }

        if (param.get("currentPage") == null || param.get("currentPage").equals("")) {
            currentPage = 1;
        }else {
            currentPage = Integer.parseInt((String) param.get("currentPage"));
        }


        String sQuery = "A.USE_YN = 'Y'";

        if (search_type.equals("CUST_NAME") && !search_string.equals("")) {
            sQuery += " AND A.CUST_NAME like '%" + search_string +"%'";
        }else if(search_type.equals("REMARKS_WIN") && !search_string.equals("")) {
            sQuery += " AND A.REMARKS_WIN like '%" + search_string + "%'" ;
        }else if(search_type.equals("ALL") && !search_string.equals("")){
            sQuery += " AND ( A.CUST_NAME like '%" + search_string + "%' OR A.REMARKS_WIN like '%" + search_string + "%')";
        }

        Map paramMap = new HashMap();

        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", 10);
        paramMap.put("sQuery", sQuery);
        paramMap.put("search_type",search_type);

        Map resultMap = new HashMap();
        resultMap.put("list", custService.custList(paramMap));
        resultMap.put("total", custService.custListTotal(paramMap));
        resultMap.put("search", paramMap);


        return JsonResponse.asSuccess("storeData", resultMap);
    }

	@PostMapping(value = "/idCheck", produces="application/json")
	@ResponseBody
	public Map idCheck(@RequestParam Map map) {
			
		  return JsonResponse.asSuccess("result",supplyService.idCheck(map));
	}
	
	@PostMapping(value = "/createAccount" )
    @ResponseBody
    public Map createAccount(Model model,@RequestParam Map param) {   		 
		supplyService.create_SCM_Account(param);		
    	return JsonResponse.asSuccess();  	
    }
	
    @PostMapping(value = "/SupplyAccountRegister"
            , produces="application/json")
    @ResponseBody
    public Map SupplyAccountRegister(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>>  supplycreateList = (List<Map<String, Object>> )paramMap.get("supplycreateList");
    	System.out.println(supplycreateList);
    	
		/* supplyService.SCMManagerInsertAccount(SCMAccountList); */
		
		 for(int i = 0; i < supplycreateList.size(); i++) {
		System.err.println(i +
		 " : " +supplycreateList);
			if(supplycreateList.get(i).get("scm_manager_seq").equals(null) || supplycreateList.get(i).get("scm_manager_seq").equals("")) {
				supplycreateList.get(i).put("scm_auth_group_seq", 2);
				supplyService.SCMManagerInsertAccount(supplycreateList.get(i));
				
			}else
				supplyService.SCMManagerUpdateAccount(supplycreateList.get(i));
				
		 }
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/resetPassword" )
    @ResponseBody
    public Map resetPassword(@RequestParam Map param) {

        supplyService.resetPassword(param);
        return JsonResponse.asSuccess();
    }

}
