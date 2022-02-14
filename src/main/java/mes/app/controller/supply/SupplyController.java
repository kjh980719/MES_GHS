package mes.app.controller.supply;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.cust.CustService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/supply")
public class SupplyController {

    @Autowired
    private SupplyService supplyService;
    @Autowired
    private CustService custService;



    @RequestMapping(value="/supply")
    public String supplyPage(Model model, @RequestParam Map param) {

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
        
        if (param.get("rowsPerPage") == null || param.get("rowsPerPage").equals("")) {
        	rowsPerPage = 15;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }
        
      
        String parameter = "&rowsPerPage=" + rowsPerPage + "&search_type=" + search_type + "&useYN="+use_yn+"&search_string="+search_string;
        String sQuery = "";
        
        sQuery += " A.use_yn = '" +use_yn +"' AND (A.CUST_TYPE = 'BS' OR A.CUST_TYPE = 'B')";

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


        
        UserInfo info = Util.getUserInfo();       
	
        Map paramMap = new HashMap();

        paramMap.put("currentPage", currentPage);	
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);
        paramMap.put("use_yn",use_yn);
        paramMap.put("search_type",search_type);
        
        model.addAttribute("parameter", parameter);
        model.addAttribute("search", paramMap);
        
    	model.addAttribute("total", custService.custListTotal(paramMap));        
        model.addAttribute("list", custService.getCustList(paramMap));
        
        model.addAttribute("EXchangeList", custService.getExchangeList());
        
        return "/supply/supply";
    }
    
    @RequestMapping(value="/supplyaccount")
    public String supplyaccountPage(Model model , @RequestParam Map param) {

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
        
        if (param.get("rowsPerPage") == null || param.get("rowsPerPage").equals("")) {
        	rowsPerPage = 15;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }
        
      
        String parameter = "&rowsPerPage=" + rowsPerPage + "&search_type=" + search_type + "&useYN="+use_yn+"&search_string="+search_string;
        String sQuery = "";
        
        sQuery += "AND B.use_yn = '" +use_yn +"' AND (B.CUST_TYPE = 'BS' OR B.CUST_TYPE = 'B')";

        if (search_type.equals("CUST_NAME") && !search_string.equals("")) {
        	sQuery += " AND B.CUST_NAME like '%" + search_string +"%'";
        }else if(search_type.equals("BUSINESS_NO") && !search_string.equals("")) {
        	sQuery += " AND B.BUSINESS_NO like '%" + search_string + "%'" ;	
        }else if(search_type.equals("ID") && !search_string.equals("")) {
        	sQuery += " AND A.scm_manager_id like '%" + search_string + "%'" ;
        }else if(search_type.equals("EMAIL") && !search_string.equals("")){
        	sQuery += " AND A.scm_manager_email like '%" + search_string + "%'" ;
        }else if(search_type.equals("MANAGER") && !search_string.equals("")){
        	sQuery += " AND A.scm_manager_name like '%" + search_string + "%'" ;
        }else if(search_type.equals("ALL") && !search_string.equals("")){
        	sQuery += " AND "
        			+ "("
        			+ " B.CUST_NAME like '%" + search_string + "%' OR B.BUSINESS_NO like '%" + search_string + "%'"
        			+ " OR A.scm_manager_id like '%" + search_string + "%' OR A.scm_manager_email like '%" + search_string + "%'"
        			+ " OR A.scm_manager_name like '%" + search_string + "%'"
        			+ ")";   	
        }
        
    
        
        UserInfo info = Util.getUserInfo();       
	
        Map paramMap = new HashMap();

        paramMap.put("currentPage", currentPage);	
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);
        paramMap.put("use_yn",use_yn);
        paramMap.put("search_type",search_type);
        
        model.addAttribute("parameter", parameter);
        model.addAttribute("search", paramMap);
        
    	model.addAttribute("list", supplyService.getScmManagerList(paramMap));        
        model.addAttribute("total", supplyService.getScmManagerTotal(paramMap));

        return "/supply/supplyaccount";
    }


    
    @PostMapping(value = "/getSupplyList"
            , produces="application/json")
    @ResponseBody
    public Map getSupplyList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", supplyService.getSupplyList(paramMap));
    }
    
    @PostMapping(value = "/getScmManagerAllList"
            , produces="application/json")
    @ResponseBody
    public Map getScmManagerAllList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", supplyService.getSCMManagerAllList(paramMap));
    }
    
    
    
    @PostMapping(value = "/selectSupply"
            , produces="application/json")
    @ResponseBody
    public Map selectSupply(@RequestBody Map paramMap) {
        
        return JsonResponse.asSuccess("storeData", supplyService.getRowSupply(paramMap));
    }
    
    @PostMapping(value = "/selectSCMManager"
            , produces="application/json")
    @ResponseBody
    public Map selectSCMManager(@RequestBody Map paramMap) {
        
        return JsonResponse.asSuccess("storeData", supplyService.getRowSCMManager(paramMap));
    }
    
    @PostMapping(value = "/updateManager"
            , produces="application/json")
    @ResponseBody
    public Map updateManager(@RequestBody Map paramMap) {
    	supplyService.updateManager(paramMap);
    	return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/getSupplyInfo" )
    @ResponseBody
    public Map getSupplyInfo(Model model,@RequestParam Map param) {   	
    	return JsonResponse.asSuccess("storeData", supplyService.getSupplyInfo(param));  	
    }
    
    @PostMapping(value = "/getSupplyAccountInfo" )
    @ResponseBody
    public Map getSupplyAccountInfo(Model model,@RequestParam Map param) {   	
    	return JsonResponse.asSuccess("storeData", supplyService.getSupplyAccountInfo(param));  	
    }
    

    

	

}
