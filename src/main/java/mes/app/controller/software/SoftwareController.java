package mes.app.controller.software;

import mes.app.service.software.SoftwareService;
import mes.app.service.workplan.WorkPlanService;
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
@RequestMapping(value="/software")
public class SoftwareController {
	
    @Autowired
    private WorkPlanService workPlanService;
    
    @Autowired
    private SoftwareService softwareService; 


	@RequestMapping(value="/software")
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
        
        if (search_type.equals("SW_CODE")) {
        	sQuery += " AND A.sw_code like '%" + search_string + "%'";
        }else if(search_type.equals("SW_NAME")) {
        	sQuery += " AND A.sw_name like '%" + search_string + "%'" ;
        } else {
        	sQuery += "AND (A.sw_code like '%" + search_string + "%' or A.sw_name like '%" + search_string + "%')";
        }

        if (!status.equals("ALL")) {
        	sQuery += " AND A.sw_status = '" + status +"'";
        }
        
        model.addAttribute("parameter", parameter);

		Map map = new HashMap();
		map.put("startDate", startDate); 
		map.put("endDate",endDate );
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("status",status);
		map.put("search_type",search_type);
		
		model.addAttribute("total", softwareService.softwareListTotal(map));
		model.addAttribute("list", softwareService.softwareList(map));

		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        
        return "/software/software";
    }
    
  
    @RequestMapping(value = "/registerSoftware", produces="application/json")
    @ResponseBody
    public Map registerSoftware(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> materialList = paramMap.get("materialList");
    	List<Map<String, Object>> info = paramMap.get("info");

    	String sw_no = softwareService.writeSoftware(info.get(0));
    	
    	
    	for(int i = 0; i < materialList.size(); i++) {
    		materialList.get(i).put("sw_no", sw_no);
    		softwareService.writeSoftwareDetail(materialList.get(i));
    	}
    
   
    	
    	return JsonResponse.asSuccess();
    }
    
    @RequestMapping(value = "/editSoftware", produces="application/json")
    @ResponseBody
    public Map editWorkPlan(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> materialList = (List<Map<String, Object>>)paramMap.get("materialList");
    	List<Map<String, Object>> info = (List<Map<String, Object>>)paramMap.get("info");

    	softwareService.editSoftware(info.get(0));
    	
    	
    	
    	
    	for(int i = 0; i < materialList.size(); i++) {
    		materialList.get(i).put("sw_no", info.get(0).get("sw_no"));
    		softwareService.editSoftwareDetail(materialList.get(i));
    	}
    
   
    	
    	return JsonResponse.asSuccess();
    }
    
    @GetMapping(value = "/view")
    @ResponseBody
    public Map view(@RequestParam(value="sw_no", required=false) String sw_no) {
        
		Map map = new HashMap();

		
        map.put("sw_no", sw_no);

		return JsonResponse.asSuccess("storeData", softwareService.view(map));	
    }
    
    
    @GetMapping(value = "/delete")
    @ResponseBody
    public Map delete(@RequestParam(value="sw_no", required=false) String sw_no){
        
		Map map = new HashMap();	
        map.put("sw_no", sw_no);
 
        
        softwareService.delete(map);     
        
		return JsonResponse.asSuccess("storeData", "");	
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
