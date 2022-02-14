package mes.app.controller.supervisor;

import mes.app.service.supervisor.ManagerAuthGroupService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value="/supervisor")
public class AccessController {

    @Autowired
    private ManagerAuthGroupService managerAuthGroupService;

//    @GetMapping(value="/access")
//    public String accessPage() { return "/supervisor/access"; }

    @PostMapping(value = "/getManagerAuthGroupList"
        , produces="application/json")
    @ResponseBody
    public Map getManagerAuthGroupList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", managerAuthGroupService.getManagerAuthGroupList(paramMap));
    }

    @PostMapping(value = "/getTreeMenu"
            , produces="application/json")
    @ResponseBody
    public Map getTreeMenuList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("data", managerAuthGroupService.getTreeMenuList(paramMap));
    }

    @PostMapping(value = "/getDetailTreeMenu"
            , produces="application/json")
    @ResponseBody
    public Map getDetailTreeMenuList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("data", managerAuthGroupService.getDetailTreeMenuList(paramMap));
    }

    @PostMapping(value = "/createAuth"
            , produces="application/json")
    @ResponseBody
    public Map createAuth(@RequestBody Map paramMap) {
        System.out.println("paramMap : "+paramMap);
        managerAuthGroupService.createAuth(paramMap);
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/updateAuth"
            , produces="application/json")
    @ResponseBody
    public Map updateAuth(@RequestBody Map paramMap) {
        System.out.println("paramMap : "+paramMap);
        managerAuthGroupService.updateAuth(paramMap);
        managerAuthGroupService.mes_department_update(paramMap);
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/deleteAuth"
            , produces="application/json")
    @ResponseBody
    public Map deleteAuth(@RequestBody Map paramMap) {
        managerAuthGroupService.deleteAuth(paramMap);
        managerAuthGroupService.mes_department_delete(paramMap);
        return JsonResponse.asSuccess();
    }

    @RequestMapping(value="/access")
    public String departmentList(Model model, @RequestParam Map param) {

        String useYn = "";
        String search_string = "";
        String search_type = "";
        int rowsPerPage = 0;
        int currentPage = 1;

        if (param.get("useYn") == null) {
            useYn = "Y";
        }else {
            useYn = (String) param.get("useYn");
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


        String parameter = "&rowsPerPage=" + rowsPerPage + "&search_type=" + search_type + "&useYN="+useYn+"&search_string="+search_string;
//        String sQuery = "";
//
//        sQuery += " A.use_yn = '" +useYn +"'";
//
//        if (search_type.equals("DPT_NAME") && !search_string.equals("")) {
//            sQuery += " AND A.DPT_NAME like '%" + search_string + "%'";
//        } else if (search_type.equals("DPT_CODE") && !search_string.equals("")) {
//            sQuery += " AND A.DPT_CODE like '%" + search_string + "%'";
//        } else {
//            sQuery += " AND (A.DPT_CODE like '%"+ search_string +"%' or A.DPT_NAME like '%" + search_string + "%')";
//        }



        UserInfo info = Util.getUserInfo();

        Map paramMap = new HashMap();

        if (search_type.equals("authGroupName") && !search_string.equals("")){
            paramMap.put("authGroupName",search_string);
        }
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
//        paramMap.put("sQuery", sQuery);
        paramMap.put("useYn",useYn);
        paramMap.put("search_type",search_type);
        paramMap.put("search_string",search_string);

        model.addAttribute("parameter", parameter);
        model.addAttribute("search", paramMap);

//        model.addAttribute("total", managerAuthGroupService.getManagerAuthGroupList(paramMap));
        model.addAttribute("list", managerAuthGroupService.getManagerAuthGroupList(paramMap));


        return "/supervisor/list";
    }


}
