package mes.app.controller.popup;

import mes.app.service.department.DepartmentService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value="/department")
public class PopupDepartmentController{

	@Autowired
	private DepartmentService departmentService;

 
    @RequestMapping(value="/popEmployeeList")
    public String popEmployeeList(Model model,@RequestParam Map param) {
    	System.out.println("param >> " + param);
    	model.addAttribute("param", param);
       return "empty:/popSupplyList";
    }
    
    @RequestMapping(value="/getEmployeeList")
    @ResponseBody
    public Map getEmployeeList(Model model,@RequestParam Map param) {
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
 		
 		if (search_type.equals("DPT_NAME") && !search_string.equals("")) {
 			sQuery += " AND A.DPT_NAME like '%" + search_string + "%'";
 		} else if (search_type.equals("DPT_CODE") && !search_string.equals("")) {
 			sQuery += " AND A.DPT_CODE like '%" + search_string + "%'";
 		} else {
         	sQuery += " AND (A.DPT_CODE like '%"+ search_string +"%' or A.DPT_NAME like '%" + search_string + "%')";
         }
 		 

         
         UserInfo info = Util.getUserInfo();       
 	
         Map paramMap = new HashMap();

         paramMap.put("currentPage", currentPage);	
         paramMap.put("rowsPerPage", rowsPerPage);
         paramMap.put("sQuery", sQuery);
         paramMap.put("use_yn",use_yn);
         paramMap.put("search_type",search_type);
  
         
         Map resultMap = new HashMap();
         resultMap.put("list", departmentService.employeeList(paramMap));
         resultMap.put("total", departmentService.employeeListTotal(paramMap));
         resultMap.put("search", paramMap);
         
         
         return JsonResponse.asSuccess("storeData", resultMap);  
    }


    @RequestMapping(value="/popDepartmentList")
    public String popDepartmentList(Model model,@RequestParam Map param) {

        model.addAttribute("param", param);
        return "empty:/popDepartmentList";
    }


    @RequestMapping(value="/getDepartmentList")
    @ResponseBody
    public Map getDepartmentList(Model model,@RequestParam Map param) {
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

        if (search_type.equals("DPT_NAME") && !search_string.equals("")) {
            sQuery += " AND A.DPT_NAME like '%" + search_string + "%'";
        } else if (search_type.equals("DPT_CODE") && !search_string.equals("")) {
            sQuery += " AND A.DPT_CODE like '%" + search_string + "%'";
        } else {
            sQuery += " AND (A.DPT_NAME like '%"+ search_string +"%' or A.DPT_CODE like '%" + search_string + "%')";
        }



        UserInfo info = Util.getUserInfo();

        Map paramMap = new HashMap();

        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);
        paramMap.put("use_yn",use_yn);
        paramMap.put("search_type",search_type);


        Map resultMap = new HashMap();
        resultMap.put("list", departmentService.departmentList(paramMap));
        resultMap.put("total", departmentService.departmentListTotal(paramMap));
        resultMap.put("search", paramMap);


        return JsonResponse.asSuccess("storeData", resultMap);
    }
}
