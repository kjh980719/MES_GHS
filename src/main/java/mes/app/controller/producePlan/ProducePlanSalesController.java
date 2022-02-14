package mes.app.controller.producePlan;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import mes.app.service.code.ComCodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.producePlan.ProducePlanSalesService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/producePlan")
public class ProducePlanSalesController {

    @Autowired
    private ProducePlanSalesService producePlanSalesService;

    @Autowired
    private ComCodeService comCodeService;


    @RequestMapping(value="/salesList")
    public String producePlanSalesList(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String plan_status = "";
        String search_type = "";
        String search_string = "";
    
        int rowsPerPage = 0;
        int currentPage = 1;
   
        if (param.get("startDate") == null || param.get("endDate") == null) {
	        Calendar cal = Calendar.getInstance();
	        String format = "yyyy-MM-dd";
	        SimpleDateFormat sdf = new SimpleDateFormat(format);

            //처음 들어왔을 때
            endDate = sdf.format(cal.getTime());
	        cal.add(cal.MONTH, -3); //세달 전
	        startDate = sdf.format(cal.getTime());   

        }else {
        	startDate = (String) param.get("startDate");
        	endDate = (String) param.get("endDate");
        }
        
        if (param.get("plan_status") == null) {
            plan_status = "ALL";
        }else {
            plan_status = (String) param.get("plan_status");
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
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&plan_status="
        +plan_status+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;
        String sQuery = " AND A.PLAN_TYPE = 'S'";
        if (search_type.equals("PLAN_CODE")) {
        	sQuery += " AND A.plan_code = '" + search_string +"'";
        }else if(search_type.equals("CUST_NAME")) {
        	sQuery += " AND F.cust_name like '%" + search_string + "%'" ;
        }else if(search_type.equals("DPT_NAME")) {
        	sQuery += " AND D.DPT_NAME like '%" + search_string + "%'" ;
        }else {
        	sQuery += "AND (A.plan_code = '"+ search_string +"' or F.cust_name like '%" + search_string + "%' or D.DPT_NAME like '%" + search_string + "%')";
        }

        if (!plan_status.equals("ALL")) {
        	sQuery += " AND A.plan_status = '" + plan_status +"'";
        }
        
        model.addAttribute("parameter", parameter);

		Map map = new HashMap();
		map.put("startDate", startDate); 
		map.put("endDate",endDate );
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("plan_status",plan_status);
		map.put("search_type",search_type);
		
		model.addAttribute("total", producePlanSalesService.producePlanSalesListTotal(map));
		model.addAttribute("list", producePlanSalesService.producePlanSalesList(map));

        Map commonMap = new HashMap();
        commonMap.put("code_id","PS");
        model.addAttribute("planStatus", comCodeService.comCodeDetailSelectList(commonMap));
		
		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);


        return "/producePlan/salesList";
    }
 
    @RequestMapping(value = "/registerProducePlanSales", produces="application/json")
    @ResponseBody
    public Map registerProducePlanSales(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> detailList = paramMap.get("detailList");
    	List<Map<String, Object>> info = paramMap.get("info");

    	String plan_code = producePlanSalesService.writeProducePlanSales(info.get(0));

    	for(int i = 0; i < detailList.size(); i++) {
            detailList.get(i).put("plan_code", plan_code);
    		producePlanSalesService.writeProducePlanSalesDetail(detailList.get(i));
    	}

    	return JsonResponse.asSuccess();
    }

    @GetMapping(value = "/viewSales")
    @ResponseBody
    public Map view(@RequestParam(value="plan_code", required=false) String plan_code) {
        Map map = new HashMap();
        map.put("plan_code", plan_code);
        return JsonResponse.asSuccess("storeData", producePlanSalesService.view(map));
    }

    @RequestMapping(value = "/editProducePlanSales", produces="application/json")
    @ResponseBody
    public Map editProducePlanSales(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

    	List<Map<String, Object>> detailList = paramMap.get("detailList");
        List<Map<String, Object>> info = paramMap.get("info");

        producePlanSalesService.editProducePlanSales(info.get(0));


        for(int i = 0; i < detailList.size(); i++) {
            detailList.get(i).put("plan_code", info.get(0).get("plan_code"));
            producePlanSalesService.editProducePlanSalesDetail(detailList.get(i));
        }

        return JsonResponse.asSuccess();
    }
    
    @GetMapping(value = "/deleteSales")
    @ResponseBody
    public Map deleteSales(@RequestParam(value="plan_code", required=false) String plan_code){
        
		Map map = new HashMap();	
        map.put("plan_code", plan_code);

        producePlanSalesService.delete(map);     
        
		return JsonResponse.asSuccess("storeData", "");	
    }
    
}
