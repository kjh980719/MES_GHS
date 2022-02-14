package mes.app.controller.department;

import mes.app.service.department.DepartmentService;
import mes.app.service.supervisor.ManagerAuthGroupService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/department")
public class DepartmentController {

    @Autowired
    private DepartmentService departmentService;

    @Autowired
    private ManagerAuthGroupService managerAuthGroupService;

    @RequestMapping(value="/list")
    public String departmentList(Model model, @RequestParam Map param) {

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
        
        model.addAttribute("parameter", parameter);
        model.addAttribute("search", paramMap);
        
    	model.addAttribute("total", departmentService.departmentListTotal(paramMap));        
        model.addAttribute("list", departmentService.departmentList(paramMap));

        return "/department/list";
    }
    
    @RequestMapping(value="/create" , produces="application/json")
    @ResponseBody
    public Map create(@RequestParam Map param, HttpServletRequest request ) {
    	departmentService.createDepartment(param);
        Map paramMap = new HashMap();
        List menuSeqList = new ArrayList();
        paramMap.put("loginUserSeq",Util.getUserInfo().getAuthGroupSeq());
        paramMap.put("useYn",param.get("use_yn"));
        paramMap.put("authGroupName",param.get("dpt_name"));
        paramMap.put("menuSeqList",menuSeqList);
        managerAuthGroupService.createAuth(paramMap);
        return  JsonResponse.asSuccess();
    }
    
    @RequestMapping(value="/view")
    @ResponseBody
    public Map view(@RequestParam(value="dpt_code", required=false) String dpt_code) {
 
		Map map = new HashMap();
	
        map.put("dpt_code", dpt_code);
        return JsonResponse.asSuccess("storeData", departmentService.departmentInfo(map));	
    }
    
    @RequestMapping(value="/edit", produces="application/json")
    @ResponseBody
    public Map edit(@RequestParam Map param) {
    	departmentService.editDepartment(param);

        Map paramMap = new HashMap();
        paramMap.put("loginUserSeq",Util.getUserInfo().getAuthGroupSeq());
        paramMap.put("useYn",param.get("use_yn"));
        paramMap.put("authGroupName",param.get("dpt_name"));
        paramMap.put("authGroupSeq",param.get("authGroupSeq"));
        paramMap.put("menuSeqList",managerAuthGroupService.getDetailTreeMenuList(paramMap));

        managerAuthGroupService.updateAuth(paramMap);

        return JsonResponse.asSuccess();
    }
    
    @RequestMapping(value="/codeCheck")
    @ResponseBody
    public Map codeCheck(@RequestParam(value="dpt_code", required=false) String dpt_code) {
 
		Map map = new HashMap();
        map.put("dpt_code", dpt_code);
        System.out.println(departmentService.departmentInfo(map));
        return JsonResponse.asSuccess("storeData", departmentService.departmentInfo(map));	
    }

    @RequestMapping(value="/employeeCreate")
    public String employeeCreate(@RequestParam(value="dpt_code", required=false) String dpt_code, Model model) {
    	Map map = new HashMap();
    	
        map.put("dpt_code", dpt_code);
    	model.addAttribute("info", departmentService.departmentInfo(map));
    	
       return "empty:/popEmployeeCreate";
    }


    @RequestMapping(value="/createEmployee")
    @ResponseBody
    public Map createEmployee(@RequestParam Map paramMap) {
        System.out.println("paramMap : "+paramMap);
        int employeeInsert = departmentService.employeeInsert(paramMap);
        if(employeeInsert == 1){
            return JsonResponse.asSuccess("storeData", 1);
        }else {
            return JsonResponse.asFailure("storeData", "fail");
        }
    }
	

}
