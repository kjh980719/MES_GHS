package mes.app.controller.workplan;

import mes.app.service.code.ComCodeService;
import mes.app.service.productionLine.ProductionLineService;
import mes.app.service.workplan.WorkPlanService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/workplan")
public class WorkPlanController {
	
    @Autowired
    private WorkPlanService workPlanService;

    @Autowired
    private ProductionLineService productionLineService;

    @Autowired
    private ComCodeService comCodeService;

    @RequestMapping(value="/list")
    public String workPlanList(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_type = "";
        String search_string = "";
        String search_status = "";

        int search_line = 0;
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

        if (param.get("search_status") == null || param.get("search_status").equals("")) {
            search_status = "ALL";
        }else {
            search_status = (String) param.get("search_status");
        }

        if (param.get("rowsPerPage") == null) {
        	rowsPerPage = 15;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }

        if (param.get("search_line") == null || param.get("search_line").equals("")) {
            search_line = 0;
        }else {
            search_line = Integer.parseInt((String) param.get("search_line"));
        }

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string+"&search_status="+search_status+"&search_line="+search_line;
        String sQuery = "";

        if (!search_status.equals("ALL")){
            sQuery += " AND A.PLAN_STATUS = '" + search_status + "'";
        }

        if (search_line != 0){
            sQuery += " AND A.PRODUCT_LINE LIKE '%" + search_line + "%'";
        }

        if (search_type.equals("PLAN_CODE")) {
        	sQuery += " AND A.plan_code = '" + search_string +"'";
        }else if(search_type.equals("MANAGER")) {
        	sQuery += " AND C.MANAGER_NAME like '%" + search_string + "%'" ;
        }else {
        	sQuery += "AND (A.plan_code = '"+ search_string +"' or C.MANAGER_NAME like '%" + search_string + "%')";
        }


        
        model.addAttribute("parameter", parameter);

		Map map = new HashMap();
		map.put("startDate", startDate); 
		map.put("endDate",endDate );
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_type",search_type);
        map.put("search_status",search_status);
        map.put("search_line",search_line);

		Map commonMap = new HashMap();
        commonMap.put("code_id","WPS");
        model.addAttribute("planStatus", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
		model.addAttribute("total", workPlanService.workPlanListTotal(map));
		model.addAttribute("list", workPlanService.workPlanList(map));

		
		
		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        
        return "/workplan/list";
    }

    @Transactional
    @RequestMapping(value = "/registerWorkPlan", produces="application/json")
    @ResponseBody
    public Map registerWorkPlan(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> materialList = paramMap.get("materialList");
    	List<Map<String, Object>> info = paramMap.get("info");

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

    @GetMapping(value = "/finish")
    @ResponseBody
    public Map finish(@RequestParam(value="plan_code", required=false) String plan_code){

        Map map = new HashMap();
        map.put("plan_code", plan_code);

        workPlanService.finish(map);

        return JsonResponse.asSuccess("storeData", "");
    }

    @GetMapping(value = "/getSerialProductList")
    @ResponseBody
    public Map getSerialProductList(@RequestParam(value="plan_code", required=false) String plan_code) {

        Map map = new HashMap();

        map.put("plan_code", plan_code);

        return JsonResponse.asSuccess("storeData", workPlanService.getSerialProductList(map));
    }

    @GetMapping(value = "/getSerialList")
    @ResponseBody
    public Map getSerialList(@RequestParam(value="plan_code", required=false) String plan_code, @RequestParam(value="pdt_cd", required=false) String pdt_cd, @RequestParam(value="package_yn", required=false) String package_yn) {

        Map map = new HashMap();

        map.put("plan_code", plan_code);
        map.put("pdt_cd", pdt_cd);
        map.put("package_yn", package_yn);

        return JsonResponse.asSuccess("storeData", workPlanService.getSerialList(map));
    }
    @PostMapping(value = "/manageSerial")
    @ResponseBody
    public Map manageSerial(@RequestParam Map param) {
        String msg = workPlanService.manageSerial(param);
        return JsonResponse.asSuccess("msg",msg);
    }

}
