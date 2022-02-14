package mes.app.controller.receiving;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.workplan.WorkPlanService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/receiving")
public class ReceivingController {
	
	
	@Autowired
    private WorkPlanService workPlanService;


	@RequestMapping(value="/list")
    public String workPlanList(Model model, @RequestParam Map param) {

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
        String sQuery = "";
        
        if (search_type.equals("PLAN_CODE")) {
        	sQuery += " AND A.plan_code = '" + search_string +"'";
        }else if(search_type.equals("MANAGER")) {
        	sQuery += " AND C.MANAGER_NAME like '%" + search_string + "%'" ;
        }else if(search_type.equals("CUST_NAME")) {
        	sQuery += " AND A.cust_name like '%" + search_string + "%'" ;
        } else {
        	sQuery += "AND (A.plan_code = '"+ search_string +"' or C.MANAGER_NAME like '%" + search_string + "%'"
        			+ " or A.cust_name like '%" + search_string + "%')";
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
		
		
		model.addAttribute("total", workPlanService.workPlanListTotal(map));
		model.addAttribute("list", workPlanService.workPlanList(map));

		
		
	
		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        
        return "/receiving/list";
    }
    
  
    @RequestMapping(value = "/registerWorkPlan", produces="application/json")
    @ResponseBody
    public Map registerWorkPlan(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> materialList = (List<Map<String, Object>>)paramMap.get("materialList");
    	List<Map<String, Object>> info = (List<Map<String, Object>>)paramMap.get("info");

    	String plan_code = workPlanService.writeWorkPlan(info.get(0));
    	
    	
    	for(int i = 0; i < materialList.size(); i++) {
    		materialList.get(i).put("plan_code", plan_code);
    		workPlanService.writeWorkPlanDetail(materialList.get(i));
    	}
    
   
    	
    	return JsonResponse.asSuccess();
    }
    
    @RequestMapping(value = "/editWorkPlan", produces="application/json")
    @ResponseBody
    public Map editWorkPlan(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> materialList = (List<Map<String, Object>>)paramMap.get("materialList");
    	List<Map<String, Object>> info = (List<Map<String, Object>>)paramMap.get("info");

    	workPlanService.editWorkPlan(info.get(0));
    	
    	
    	for(int i = 0; i < materialList.size(); i++) {
    		materialList.get(i).put("plan_code", info.get(0).get("plan_code"));
    		workPlanService.editWorkPlanDetail(materialList.get(i));
    	}
    
   
    	
    	return JsonResponse.asSuccess();
    }
    
    @GetMapping(value = "/view")
    @ResponseBody
    public Map view(@RequestParam(value="plan_code", required=false) String plan_code) {
        
		Map map = new HashMap();

		
        map.put("plan_code", plan_code);

		return JsonResponse.asSuccess("storeData", workPlanService.view(map));	
    }
    

    @GetMapping(value = "/delete")
    @ResponseBody
    public Map delete(@RequestParam(value="plan_code", required=false) String plan_code){
        
		Map map = new HashMap();	
        map.put("plan_code", plan_code);
 
        
        workPlanService.delete(map);     
        
		return JsonResponse.asSuccess("storeData", "");	
    }
    
}

	
	
	
	
	


