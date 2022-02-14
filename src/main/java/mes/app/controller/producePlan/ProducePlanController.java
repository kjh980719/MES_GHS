package mes.app.controller.producePlan;

import mes.app.service.code.ComCodeService;
import mes.app.service.producePlan.ProducePlanService;
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
@RequestMapping(value="/producePlan")
public class ProducePlanController {

    @Autowired
    private ProducePlanService producePlanService;

    @Autowired
    private ComCodeService comCodeService;


    @RequestMapping(value="/list")
    public String producePlanList(Model model, @RequestParam Map param) {

    	Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        
        
        String startDate = "";
        String endDate = "";
        String status = "";
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
        
        if (param.get("status") == null) {
        	status = "ALL";
        }else {
        	status = (String) param.get("status");
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
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&status="
        +status+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;
        String sQuery = " AND A.PLAN_TYPE = 'P'";
        
        if (search_type.equals("PLAN_CODE")) {
        	sQuery += " AND A.plan_code = '" + search_string +"'";
        }else if(search_type.equals("CUST_NAME")) {
        	sQuery += " AND F.cust_name like '%" + search_string + "%'" ;
        }else if(search_type.equals("DPT_NAME")) {
        	sQuery += " AND D.DPT_NAME like '%" + search_string + "%'" ;
        }else {
        	sQuery += "AND (A.plan_code = '"+ search_string +"' or F.cust_name like '%" + search_string + "%' or D.DPT_NAME like '%" + search_string + "%')";
        }

        if (!status.equals("ALL")) {
        	sQuery += " AND A.plan_status = '" + status +"'";
        }
        
        model.addAttribute("parameter", parameter);
        
        UserInfo info = Util.getUserInfo();       
		Map map = new HashMap();
		map.put("startDate", startDate); 
		map.put("endDate",endDate );
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("status",status);
		map.put("search_type",search_type);

        Map commonMap = new HashMap();
        commonMap.put("code_id","PS");
        model.addAttribute("planStatus", comCodeService.comCodeDetailSelectList(commonMap));
		model.addAttribute("total", producePlanService.producePlanListTotal(map));
		model.addAttribute("list", producePlanService.producePlanList(map));

		
		
		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        
        return "/producePlan/list";
    }
 
    @RequestMapping(value = "/registerProducePlan", produces="application/json")
    @ResponseBody
    public Map registerWorkPlan(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> materialList = paramMap.get("materialList");
    	List<Map<String, Object>> info = paramMap.get("info");

    	String plan_code = producePlanService.writeProducePlan(info.get(0));
    	
    	
    	for(int i = 0; i < materialList.size(); i++) {
    		materialList.get(i).put("plan_code", plan_code);
    		producePlanService.writeProducePlanDetail(materialList.get(i));
    	}
    
   
    	
    	return JsonResponse.asSuccess();
    }

    @GetMapping(value = "/view")
    @ResponseBody
    public Map view(@RequestParam(value="plan_code", required=false) String plan_code) {

        Map map = new HashMap();


        map.put("plan_code", plan_code);

        return JsonResponse.asSuccess("storeData", producePlanService.view(map));
    }

    @GetMapping(value = "/statusUpdate")
    @ResponseBody
    public Map statusUpdate(@RequestParam(value="plan_code", required=false) String plan_code,
                            @RequestParam(value="plan_status", required=false) String plan_status) {

        Map map = new HashMap();
        map.put("plan_code", plan_code);
        map.put("plan_status", plan_status);

        producePlanService.statusUpdate(map);

        return JsonResponse.asSuccess("storeData", "");
    }

    @RequestMapping(value = "/editProducePlan", produces="application/json")
    @ResponseBody
    public Map editProducePlan(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
        List<Map<String, Object>> materialList = (List<Map<String, Object>>)paramMap.get("materialList");
        List<Map<String, Object>> info = (List<Map<String, Object>>)paramMap.get("info");

        producePlanService.editProducePlan(info.get(0));


        for(int i = 0; i < materialList.size(); i++) {
            materialList.get(i).put("plan_code", info.get(0).get("plan_code"));
            producePlanService.editProducePlanDetail(materialList.get(i));
        }



        return JsonResponse.asSuccess();
    }
    
    @GetMapping(value = "/delete")
    @ResponseBody
    public Map delete(@RequestParam(value="plan_code", required=false) String plan_code){
        
		Map map = new HashMap();	
        map.put("plan_code", plan_code);
 
        
        producePlanService.delete(map);     
        
		return JsonResponse.asSuccess("storeData", "");	
    }
    
}
