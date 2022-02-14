package mes.app.controller.supervisor;

import mes.app.service.supervisor.ManagerAuthGroupService;
import mes.app.service.supervisor.ManagerService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value="/supervisor")
public class SupervisorController {

    @Autowired
    private ManagerService managerService;

    @Autowired
    private ManagerAuthGroupService managerAuthGroupService;

    @RequestMapping(value="/supervisor")
    public String supervisorPage(Model model, @RequestParam Map param) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        model.addAttribute("authGroupList", managerAuthGroupService.getManagerAuthGroupList(paramMap));
        model.addAttribute("authGroupSeq",param.get("authGroupSeq"));
        System.out.println("param : "+param);

        int authGroupSeq;
        if (param.get("authGroupSeq") == null || param.get("authGroupSeq").equals(""))  {
            authGroupSeq = 2;
        }else {
            authGroupSeq =  Integer.parseInt(param.get("authGroupSeq").toString());
        }
        param.put("authGroupSeq",authGroupSeq);
        String useYn = "";
        String searchText = "";
        String searchKeyword = "";
        String startDate = "";
        String endDate = "";
        int rowsPerPage = 0;
        int currentPage = 1;

        if (param.get("useYn") == null) {
            useYn = "Y";
        }else {
            useYn = (String) param.get("useYn");
        }

        if(param.get("searchText") == null) {
            searchText = "";
        }else {
            searchText = (String) param.get("searchText");
        }

        if (param.get("searchKeyword") == null) {
            searchKeyword = "all";
        }else {
            searchKeyword = (String) param.get("searchKeyword");
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

        if (param.get("startDate") == null) {
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            DateFormat nDate = new SimpleDateFormat("yyyy-MM-dd");
            cal.add(Calendar.YEAR, -1);
            String now_day = nDate.format(cal.getTime());
            startDate = now_day;
        }else {
            startDate = (String) param.get("startDate");
        }

        if (param.get("endDate") == null) {
            Date nowDate = new Date();
            DateFormat nDate = new SimpleDateFormat("yyyy-MM-dd");
            String now_day = nDate.format(nowDate);
            endDate = now_day;
        }else {
            endDate = (String) param.get("endDate");
        }

//        String parameter = "&startDate="+startDate+"&endDate="+endDate+"&currentPage="+currentPage+"&rowsPerPage=" + rowsPerPage + "&searchKeyword=" + searchKeyword + "&useYN="+useYn+"&searchText="+searchText;
        String parameter = "&startDate="+startDate+"&endDate="+endDate+"&rowsPerPage=" + rowsPerPage + "&searchKeyword=" + searchKeyword + "&useYN="+useYn+"&searchText="+searchText;

        param.put("startDate",startDate);
        model.addAttribute("startDate",startDate);
        param.put("endDate",endDate);
        model.addAttribute("endDate",endDate);
        param.put("searchKeyword",searchKeyword);
        model.addAttribute("searchKeyword",searchKeyword);
        param.put("searchText",searchText);
        model.addAttribute("searchText",searchText);
        param.put("useYn",useYn);
        model.addAttribute("useYn",useYn);
        param.put("rowsPerPage",rowsPerPage);
        model.addAttribute("rowsPerPage",rowsPerPage);
        param.put("currentPage",currentPage);
        model.addAttribute("currentPage",currentPage);

        model.addAttribute("parameter", parameter);
        model.addAttribute("search", param);

        model.addAttribute("list",managerService.getManagerList(param));

        return "/supervisor/supervisor";
    }

    @PostMapping(value = "/getManagerList"
            , produces="application/json")
    @ResponseBody
    public Map getManagerList(@RequestBody Map paramMap) {
//    	System.out.println("param" + paramMap);
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

}
