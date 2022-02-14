package mes.app.controller.popup;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import mes.app.service.productionLine.ProductionLineService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.cust.CustService;
import mes.app.service.material.MaterialService;
import mes.app.service.supply.SupplyService;
import mes.app.service.workplan.WorkPlanService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/workplan")
public class PopupWorkPlanController{

	@Autowired
	private WorkPlanService workPlanService;

    @Autowired
    private MaterialService materialService;

    @Autowired
    private ProductionLineService productionLineService;

 
    @RequestMapping(value="/popManagerList")
    public String popManagerList(Model model,@RequestParam Map param) {
    
    	model.addAttribute("param", param.get("type"));
       return "empty:/popManagerList";
    }
    
    @RequestMapping(value="/getManagerList")
    @ResponseBody
    public Map getManagerList(Model model,@RequestParam Map param) {
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
         
         sQuery += " A.use_yn = '" +use_yn +"'";
 		
 		if (search_type.equals("MANAGER_NAME") && !search_string.equals("")) {
 			sQuery += " AND A.MANAGER_NAME like '%" + search_string + "%'";
 		} else if (search_type.equals("GROUP_NAME") && !search_string.equals("")) {
 			sQuery += " AND B.AUTH_GROUP_NAME like '%" + search_string + "%'";
 		} else {
         	sQuery += " AND (A.MANAGER_NAME like '%"+ search_string +"%' or B.AUTH_GROUP_NAME like '%" + search_string + "%')";
         }
 		 

         
         UserInfo info = Util.getUserInfo();       
 	
         Map paramMap = new HashMap();

         paramMap.put("currentPage", currentPage);	
         paramMap.put("rowsPerPage", rowsPerPage);
         paramMap.put("sQuery", sQuery);
         paramMap.put("use_yn",use_yn);
         paramMap.put("search_type",search_type);
  
         
         Map resultMap = new HashMap();
         resultMap.put("list", workPlanService.getMangerList(paramMap));
         resultMap.put("total", workPlanService.getMangerListTotal(paramMap));
         resultMap.put("search", paramMap);
         
         
         return JsonResponse.asSuccess("storeData", resultMap);  
    }
    
    @RequestMapping(value="/popWorkPlanList")
    public String popWorkPlanList(Model model) {
        model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
       return "empty:/popWorkPlanList";
    }
    
    
    @RequestMapping(value="/getPopWorkPlanList")
    @ResponseBody
    public Map getPopWorkPlanList(Model model,@RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_type = "";
        String search_string = "";

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

        if (param.get("rowsPerPage") == null || param.get("rowsPerPage").equals("")) {
            rowsPerPage = 15;
        }else {
            rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }

        if (param.get("search_line") == null || param.get("search_line").equals("")) {
            search_line = 0;
        }else {
            search_line = Integer.parseInt((String) param.get("search_line"));
        }

        String sQuery = "";

        sQuery += " AND A.PLAN_STATUS IN ('WPS001','WPS002')";

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

        Map map = new HashMap();
        map.put("startDate", startDate);
        map.put("endDate",endDate );
        map.put("currentPage", currentPage);
        map.put("rowsPerPage", rowsPerPage);
        map.put("sQuery", sQuery);
        map.put("search_type",search_type);
        map.put("search_line",search_line);

        Map resultMap = new HashMap();
        resultMap.put("list", workPlanService.workPlanList(map));
        resultMap.put("total", workPlanService.workPlanListTotal(map));
        resultMap.put("search", map);

        return JsonResponse.asSuccess("storeData", resultMap);  
    }
    

    @RequestMapping(value="/getPopWorkPlanInfo")
    @ResponseBody
    public Map getPopWorkPlanInfo(@RequestParam Map param) {
        return JsonResponse.asSuccess("storeData", workPlanService.view(param));
    }

}
