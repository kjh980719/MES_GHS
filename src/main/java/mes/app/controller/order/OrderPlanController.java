package mes.app.controller.order;


import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.material.MaterialService;
import mes.app.service.order.OrderPlanService;
import mes.app.service.order.OrderService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller	
@RequestMapping(value="/orderPlan")
public class OrderPlanController {

    @Autowired
    private OrderPlanService orderPlanService;

    @RequestMapping(value="/list")
    public String list(Model model, @RequestParam Map param) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        
        
        String startDate = "";
        String endDate = "";
        String order_yn = "";
        String search_type = "";
        String search_string = "";

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
        
        if (param.get("order_yn") == null) {
        	order_yn = "ALL";
        }else {
        	order_yn = (String) param.get("order_status");
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
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&order_yn="
        +order_yn+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;
        String sQuery = "";
        
        if(search_type.equals("PDT_NAME")) {
        	sQuery += " AND C.pdt_name like '%" + search_string + "%'" ;
        }else if(search_type.equals("WRITER")) {
        	sQuery += " AND D.manager_name like '%" + search_string + "%'" ;
        }else {
        	sQuery += "AND (C.pdt_name like '%" + search_string + "%' || D.manager_name like '%"+ search_string +"%')";
        }

        if (!order_yn.equals("ALL")) {
        	sQuery += " AND A.ORDER_YN = '" + order_yn +"'";
        }
        
        model.addAttribute("parameter", parameter);

		Map map = new HashMap();
		map.put("startDate", startDate); //발주일자 시작
		map.put("endDate",endDate );//발주일자 종료
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("order_yn",order_yn);
		map.put("search_type",search_type);
		
		model.addAttribute("total", orderPlanService.orderPlanListTotal(map));
		model.addAttribute("list", orderPlanService.orderPlanList(map));

		
		
		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        
        return "/orderPlan/list";
    }
    
    @RequestMapping(value="/popProductList")
    public String popProductList(Model model) {
       model.addAttribute("type", "orderPlan");
    	return "empty:/popProductList";
    }
    
    @RequestMapping(value="/getPopProductList")
    @ResponseBody
    public Map getPopProductList(Model model,@RequestParam Map param) {

        String search_type = "";
        String search_string = "";
        String USE_YN = "Y";
        String CAT_CD ="";
        String DIVISION_SEQ = "";
        String PROD_TYPE ="";
        
        //System.out.println(param);
        int rowsPerPage = 0;
        int currentPage = 1;
  
        
        if (param.get("CAT_CD") == null) {
        	CAT_CD = "ALL";
        }else {
        	CAT_CD = (String) param.get("CAT_CD");
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
        
        if (param.get("rowsPerPage") == null || param.get("rowsPerPage").equals("")) {
        	rowsPerPage = 10;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }
        
        if (param.get("DIVISION_SEQ") == null || param.get("DIVISION_SEQ").equals("")) {
        	DIVISION_SEQ = "ALL";  
        }else{
        	DIVISION_SEQ = (String) param.get("DIVISION_SEQ");
        }
        
        if (param.get("PROD_TYPE") == null || param.get("PROD_TYPE").equals("")) {
        	PROD_TYPE = "";   	
        }else {
        	PROD_TYPE = (String) param.get("PROD_TYPE");
        }
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&CAT_CD="
                +CAT_CD+"&USE_YN="+USE_YN+"&DIVISION_SEQ="+DIVISION_SEQ+"&PROD_TYPE="+PROD_TYPE+"&search_string="+search_string;
        String sQuery = "";
      
        sQuery += " A.USE_YN = '" + USE_YN +"'" ;
     

        if (!CAT_CD.equals("ALL")) {
        	sQuery += " AND D.BYCAT_CD = '" + CAT_CD +"'";
        }
        if (!DIVISION_SEQ.equals("ALL")) {
        	sQuery += " AND A.DIVISION_SEQ = '" + DIVISION_SEQ +"'";
        }

        if (search_type.equals("CODE")) {
        	sQuery += " AND A.CODE = '" + search_string +"'";
        }else if(search_type.equals("PDT_NAME")) {
        	sQuery += " AND B.PDT_NAME like '%" + search_string + "%'" ;
        }
        
        if (!PROD_TYPE.equals("")) {
        	sQuery += " AND A.PROD_TYPE = '" + PROD_TYPE +"'";
        }else {
        	sQuery += " AND A.PROD_TYPE IN (1,3)";
        }

        
        model.addAttribute("parameter", parameter);
        
        UserInfo info = Util.getUserInfo();       
		Map map = new HashMap();
		map.put("currentPage", currentPage);		
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_type",search_type);
		map.put("search_string",search_string);
		map.put("USE_YN",USE_YN);
		map.put("CAT_CD",CAT_CD);
		map.put("DIVISION_SEQ",DIVISION_SEQ);
		map.put("PROD_TYPE",PROD_TYPE);
		
		
		Map resultMap = new HashMap();
		resultMap.put("total", orderPlanService.materialTotal(map));
		resultMap.put("list", orderPlanService.Material_Search_S2_Str(map));
		resultMap.put("search", map);

        return JsonResponse.asSuccess("storeData", resultMap);  
    }

  
    @RequestMapping(value="/getPartListInfo")
    @ResponseBody
    public Map getPartListInfo(Model model, @RequestParam Map param) {
       Map resultMap = new HashMap();
       resultMap.put("list", orderPlanService.getPartListInfo(param));
       return JsonResponse.asSuccess("storeData", resultMap); 
    }
    
    @RequestMapping(value="/registerOrderPlan")
    @ResponseBody
    public Map registerOrderPlan(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> ordermaterialList = paramMap.get("ordermaterialList");
    	List<Map<String, Object>> order_info = paramMap.get("order_info");

    	int orderPlan_seq = orderPlanService.writeOrderPlan(order_info.get(0));

    	for(int i = 0; i < ordermaterialList.size(); i++) {
    		ordermaterialList.get(i).put("orderPlan_seq", orderPlan_seq);
    		orderPlanService.writeOrderPlanDetail(ordermaterialList.get(i));
    	}
    
   
    	
    	return JsonResponse.asSuccess();
    }
    
    @RequestMapping(value = "/editOrderPlan", produces="application/json")
    @ResponseBody
    public Map editOrderPlan(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> ordermaterialList = paramMap.get("ordermaterialList");
    	List<Map<String, Object>> order_info = paramMap.get("order_info");

    	orderPlanService.editOrderPlan(order_info.get(0));
    	
    	
    	for(int i = 0; i < ordermaterialList.size(); i++) {
    		ordermaterialList.get(i).put("orderPlan_seq", order_info.get(0).get("orderPlan_seq"));
    		orderPlanService.editOrderPlanDetail(ordermaterialList.get(i));
    	}
    
   
    	
    	return JsonResponse.asSuccess();
    }
    
    
    
    @RequestMapping(value="/searchCust")
    @ResponseBody
    public Map searchCust(Model model, @RequestParam Map param) {

       return JsonResponse.asSuccess("storeData", orderPlanService.searchCust(param)); 
    }
    
    @GetMapping(value = "/getOrderPlanInfo")
    @ResponseBody
    public Map getOrderPlanInfo(@RequestParam(value="orderPlan_seq", required=false) String orderPlan_seq) {      
		Map map = new HashMap();
        map.put("orderPlan_seq", Integer.parseInt(orderPlan_seq));
		return JsonResponse.asSuccess("storeData", orderPlanService.getOrderPlanInfo(map));	
    }
    
    @GetMapping(value = "/createOrder")
    @ResponseBody
    public Map createOrder(@RequestParam(value="orderPlan_seq", required=false) String orderPlan_seq) {       
		Map map = new HashMap();
		map.put("orderPlan_seq", Integer.parseInt(orderPlan_seq));
		orderPlanService.createOrder(map);
		return JsonResponse.asSuccess();	
    }
    @GetMapping(value = "/createOrderMulti")
    @ResponseBody
    public Map createOrderMulti(@RequestParam(value="orderPlan_seq", required=false) String orderPlan_seq) {       
		Map map = new HashMap();
		map.put("orderPlan_seq", orderPlan_seq);
	
		orderPlanService.createOrderMulti(map);
		return JsonResponse.asSuccess();	
    }
    
    
    @GetMapping(value = "/delete")
    @ResponseBody
    public Map delete(@RequestParam(value="orderPlan_seq", required=false) String orderPlan_seq) {      
		Map map = new HashMap();
        map.put("orderPlan_seq", Integer.parseInt(orderPlan_seq));
        orderPlanService.delete(map);
		return JsonResponse.asSuccess();	
    }
}
