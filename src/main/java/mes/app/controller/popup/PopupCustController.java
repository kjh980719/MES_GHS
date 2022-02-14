package mes.app.controller.popup;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.cust.CustService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/cust")
public class PopupCustController{


    @Autowired
    private CustService custService;


    
    @RequestMapping(value="/popCustList")
    public String popCustList(Model model,@RequestParam Map param) {

    	model.addAttribute("param", param);
       return "empty:/popCustList";
    }
    
    @RequestMapping(value="/getCustList")
    @ResponseBody
    public Map getCustList(Model model,@RequestParam Map param) {
    	String use_yn = "";
        String search_string = "";
        String search_type = "";
        int rowsPerPage = 0;
        int currentPage = 1;

        if (param.get("use_yn") == null) {
        	use_yn = "Y";
        }else {
        	use_yn = (String) param.get("use_yn");
        }
 
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
        

        
      
        String parameter = "&rowsPerPage=" + rowsPerPage + "&search_type=" + search_type + "&useYN="+use_yn+"&search_string="+search_string;
        String sQuery = "";
        
        sQuery += " A.use_yn = '" +use_yn +"' AND (A.CUST_TYPE = 'BS' OR A.CUST_TYPE = 'B')";

        if (search_type.equals("CUST_NAME") && !search_string.equals("")) {
        	sQuery += " AND A.CUST_NAME like '%" + search_string +"%'";
        }else if(search_type.equals("REMARKS_WIN") && !search_string.equals("")) {
        	sQuery += " AND A.REMARKS_WIN like '%" + search_string + "%'" ;
        }else if(search_type.equals("ALL") && !search_string.equals("")){
        	sQuery += " AND ( A.CUST_NAME like '%" + search_string + "%' OR A.REMARKS_WIN like '%" + search_string + "%')";   	
        }


        
        UserInfo info = Util.getUserInfo();       
	
        Map paramMap = new HashMap();

        paramMap.put("currentPage", currentPage);	
        paramMap.put("rowsPerPage", 10);
        paramMap.put("sQuery", sQuery);
        paramMap.put("use_yn",use_yn);
        paramMap.put("search_type",search_type);
        
		/*
		 * model.addAttribute("parameter", parameter); model.addAttribute("search",
		 * paramMap);
		 * 
		 * model.addAttribute("total", custService.custListTotal(paramMap));
		 * model.addAttribute("list", custService.custList(paramMap));
		 */
        Map resultMap = new HashMap();
        resultMap.put("list", custService.custList(paramMap));
        resultMap.put("total", custService.custListTotal(paramMap));
        resultMap.put("search", paramMap);
        
        
        return JsonResponse.asSuccess("storeData", resultMap);  
    }
    
	
	
	
}
