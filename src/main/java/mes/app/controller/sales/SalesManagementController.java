package mes.app.controller.sales;


import mes.app.service.contract.ContractService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/salesManagement")
public class SalesManagementController {

    @Autowired
    private ContractService contractService;



//    @RequestMapping(value="/makeorder")
//    public String makeorderPage(Model model) {
//    	System.out.println(Util.getUserInfo().getManagerName());
//    	model.addAttribute("MANAGER_NAME", Util.getUserInfo().getManagerName());
//        return "/order/makeorder";
//    }
//    @RequestMapping(value="/getorder")
//    public String getorderPage(Model model) {
//        return "/order/getorder";
//    }
    
    @RequestMapping(value="/list")
    public String list(Model model, @RequestParam Map param) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        
        
        String startDate = "";
        String endDate = "";
        String contract_status = "";
        String search_type = "";
        String search_string = "";
       
        System.out.println(param);
        int rowsPerPage = 0;
        int currentPage = 1;
   
        if (param.get("startDate") == null || param.get("endDate") == null) {
	        Calendar cal = Calendar.getInstance();
	        String format = "yyyy-MM-dd";
	        SimpleDateFormat sdf = new SimpleDateFormat(format);
	            	             
	        //처음 들어왔을 때
	        cal.add(cal.MONTH, -3); //세달 전
	        startDate = sdf.format(cal.getTime());   
	         
	        cal.add(cal.MONTH, +6); //세달 후
	        endDate = sdf.format(cal.getTime());                
        }else {
        	startDate = (String) param.get("startDate");
        	endDate = (String) param.get("endDate");
        }
        
        if (param.get("contract_status") == null) {
        	contract_status = "ALL";
        }else {
        	contract_status = (String) param.get("contract_status");
        }
        if (param.get("search_type") == null) {
        	search_type = "ALL";
        }else {
        	search_type = (String) param.get("search_type");
        }
        if(param.get("search_string") == null) {
        	search_string = "";
        }else {
        	search_string = (String) param.get("search_string");
        }
        
        if (param.get("currentPage") == null || param.get("currentPage").equals("")) {
        	currentPage = 1;
        }else {
        	currentPage = Integer.parseInt((String) param.get("currentPage"));
        }
        
        if (param.get("rowsPerPage") == null) {
        	rowsPerPage = 15;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&contract_status="
        +contract_status+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;
        String sQuery = "";
        
        if (search_type.equals("contract_code")) {
        	sQuery += " AND A.contract_code = '" + search_string +"'";
        }else if(search_type.equals("PDT_NAME")) {
        	sQuery += " AND B.pdt_name like '%" + search_string + "%'" ;
        }else {
        	sQuery += "AND (A.contract_code = '"+ search_string +"' or B.pdt_name like '%" + search_string + "%')";
        }

        if (!contract_status.equals("ALL")) {
        	sQuery += " AND A.contract_status = '" + contract_status +"'";
        }
        
        model.addAttribute("parameter", parameter);
        
        UserInfo info = Util.getUserInfo();       
		Map map = new HashMap();
		map.put("startDate", startDate); //발주일자 시작
		map.put("endDate",endDate );//발주일자 종료
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("contract_status",contract_status);
		map.put("search_type",search_type);
		
		//model.addAttribute("total", contractService.orderListTotal(map));
		//model.addAttribute("list", contractService.orderList(map));

		
		
		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        
        return "/sales/managementList";
    }
    
    @RequestMapping(value="/getorderview")
    public String getorderviewPage(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        return "/order/getorderview";
    }
    
    @PostMapping(value = "/writeOrder"
            , produces="application/json")
    @ResponseBody
    public void writeOrder(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> ordermaterialList = (List<Map<String, Object>>)paramMap.get("ordermaterialList");
//    	System.out.println(ordermaterialList);
    	Map<String, Object> orderlist=ordermaterialList.get(0);
//    	System.err.println(orderlist);
    	
    	//contractService.writeOrder(orderlist);
    	//for(int i = 0; i < ordermaterialList.size(); i++) {
    		//System.err.println(i + " : " + ordermaterialList.get(i));
    		//contractService.writeOrderMaterial(ordermaterialList.get(i));
    	//}
    	
    }
    
    @PostMapping(value = "/getOrderList"
            , produces="application/json")
    @ResponseBody
    public Map getOrderList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", contractService.getOrderList(paramMap));
    }
     

    @PostMapping(value = "/updateOrder"
            , produces="application/json")
    @ResponseBody
    public Map updateOrder(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> ordermaterialList = (List<Map<String, Object>>)paramMap.get("ordermaterialList");
    	System.out.println(ordermaterialList);
    	
    	Map<String, Object> orderlist=ordermaterialList.get(0);
		//contractService.deleteOrderMaterial(orderlist);
		//contractService.writeOrderMaterial(orderlist);
		//contractService.updateOrder(orderlist);
		System.out.println(orderlist);
		for(int i = 0; i < ordermaterialList.size(); i++) { 
			 System.err.println(i + " : " +ordermaterialList.get(i));
			 //contractService.writeOrderMaterial(ordermaterialList.get(i));
		}
		 
        return JsonResponse.asSuccess();
    }
    
    
    @PostMapping(value = "/selectOrder"
    , produces="application/json")
    @ResponseBody
    public Map selectOrder(@RequestBody Map paramMap) {

    return JsonResponse.asSuccess("storeData", contractService.getRowOrder(paramMap));
}
    
    @PostMapping(value = "/selectOrderMaterial"
    , produces="application/json")
    @ResponseBody
    public Map selectOrderMaterial(@RequestBody Map paramMap) {

    return JsonResponse.asSuccess("storeData", contractService.getRowOrderMaterial(paramMap));
}
    
    
    @PostMapping(value = "/custSearchList", produces="application/json")
    @ResponseBody
    public Map custSearchList(@RequestBody Map paramMap) {

    return JsonResponse.asSuccess("storeData", contractService.getcustSearchList(paramMap));
}
    
    
    @PostMapping(value = "/getMaterialSearchList"
    , produces="application/json")
    @ResponseBody
    public Map getMaterialSearchList(@RequestBody Map paramMap) {
    System.out.println(paramMap);
    return JsonResponse.asSuccess("storeData", contractService.getMaterialSearchList(paramMap));
}
    
    @GetMapping(value = "/getContractInfo")
    @ResponseBody
    public Map getContractInfo(@RequestParam(value="contract_seq", required=false) String contract_seq) {
        System.out.println("contract_seq : "+contract_seq);
		Map map = new HashMap();

		
        map.put("contract_seq", Integer.parseInt(contract_seq));

		return JsonResponse.asSuccess("storeData", contractService.contractInfo(map));
    }
    
    @PostMapping(value = "/custSearch", produces="application/json")
    @ResponseBody
    public Map custSearch(@RequestParam Map paramMap) {

    	String wQuery = " '%"+paramMap.get("custName")+"%' ";
    	paramMap.put("wQuery" , wQuery);
    	paramMap.put("currentPage", Integer.parseInt((String) paramMap.get("currentPage")));
    	paramMap.put("rowperPage", Integer.parseInt((String) paramMap.get("rowperpage")));
    	System.out.println(paramMap);
    	return JsonResponse.asSuccess("storeData", contractService.getcustSearchListCustName(paramMap));
    }
    
   
    
    @PostMapping(value = "/registerContract", produces="application/json")
    @ResponseBody
    public Map registerContract(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
        System.out.println("paramMap : "+paramMap);
    	List<Map<String, Object>> ordermaterialList = (List<Map<String, Object>>)paramMap.get("ordermaterialList");
    	List<Map<String, Object>> contract_info = (List<Map<String, Object>>)paramMap.get("contract_info");

        contract_info.get(0).put("code", "");

    	
    	//String contract_code = contractService.writeOrder(contract_info.get(0));
    	
    	
    //	for(int i = 0; i < ordermaterialList.size(); i++) {
    	//ordermaterialList.get(i).put("order_code", contract_code);
    		//contractService.writeOrderMaterial(ordermaterialList.get(i));
    	//}

    	return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/contractInfoUpdate")
    @ResponseBody
    public Map contractInfoUpdate(@RequestParam Map param) {
    
		System.out.println(param);
    	contractService.contractInfoUpdate(param);
		return JsonResponse.asSuccess();	
    }
    
    
    @PostMapping(value = "/contractInfoUpdateCancel")
    @ResponseBody
    public Map contractInfoUpdateCancel(@RequestParam Map param) {
    
		
    	contractService.contractInfoUpdateCancel(param);
		return JsonResponse.asSuccess();	
    }

    @RequestMapping(value="/popProductList")
    public String popProductList(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);

        return "empty:/popProductList";
    }
}
