package mes.app.controller.member;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.supervisor.ManagerAuthGroupService;
import mes.app.service.supervisor.ManagerService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import mes.security.authentication.MenuLoaderService;

@Controller
@RequestMapping(value="/member")
public class MemberController {
	

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    @Autowired
    private ManagerService managerService;
    

    @Autowired
    private ManagerAuthGroupService managerAuthGroupService;

    @RequestMapping(value="/employee")
    public String supervisorPage(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
      
        model.addAttribute("authGroupList", managerAuthGroupService.getManagerAuthGroupList(paramMap));
        
        return "/member/employee";
    }

    @PostMapping(value = "/getManagerList"
            , produces="application/json")
    @ResponseBody
    public Map getManagerList(@RequestBody Map paramMap) {
       return JsonResponse.asSuccess("storeData", managerService.getManagerList(paramMap));
    }

    @PostMapping(value = "/createManager"
            , produces="application/json")
    @ResponseBody
    public Map createManager(@RequestBody Map paramMap) {
        managerService.createManager(paramMap);
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/updateManager"
            , produces="application/json")
    @ResponseBody
    public Map updateManager(@RequestBody Map paramMap) {
        managerService.updateManager(paramMap);
        return JsonResponse.asSuccess();
    }
    
    
    @ResponseBody
    @PostMapping("/getMemberInfo")
    public Map getMemberInfo(){
    	
    	UserInfo user = Util.getUserInfo();
    	
    	Map paramMap = new HashMap();
    	paramMap.put("currentPage", 1);
    	paramMap.put("rowsPerPage", 15);
 
      	Map map = new HashMap();
    	
 
    	map.put("user", user);
    	
    	return JsonResponse.asSuccess("storeData", map); 
    	
    }
    
    @ResponseBody
    @RequestMapping("/updateInfo")
    public Map updateInfo(HttpServletRequest req , HttpServletResponse rep, @RequestParam Map map){
    	System.out.println(map);
 	
    	Map paramMap = new HashMap();
    	paramMap.put("managerTel", map.get("managerTel"));
    	paramMap.put("managerName", map.get("managerName"));
    	paramMap.put("managerEmail", map.get("managerEmail"));
    	paramMap.put("managerId", map.get("managerId"));
    	paramMap.put("managerDepartment", map.get("managerDepartment"));
    	paramMap.put("managerPosition", map.get("managerPosition"));
    	
    	UserInfo user = Util.getUserInfo();
    	paramMap.put("managerSeq", user.getManagerSeq());
    	
    	if (!map.get("password").equals("") &&  map.get("password") != null) {
    		paramMap.put("password", map.get("password"));
            paramMap.replace("password", passwordEncoder.encode(map.get("managerId") + "_" + map.get("password")));
    	}
    	
    	int result = managerService.updateMemberInfo(paramMap);
    
    	
    	if (result != 1) {
    		return JsonResponse.asFailure("정보 수정에 실패하였습니다.");
    	}
    	
    	
    	return JsonResponse.asSuccess("storeData", ""); 
    	
    }
}
