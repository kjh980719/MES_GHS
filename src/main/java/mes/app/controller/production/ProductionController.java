package mes.app.controller.production;

import mes.app.service.code.ComCodeService;
import mes.app.service.product.ProductionService;
import mes.app.service.productionLine.ProductionLineService;
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
@RequestMapping(value = "/production")
public class ProductionController {

    /* 생산현황(생산일보) */

    @Autowired
    private WorkPlanService workPlanService;

    @Autowired
    private ProductionService productionService;


    @Autowired
    private ProductionLineService productionLineService;

    @Autowired
    private ComCodeService comCodeService;


    @RequestMapping(value = "/list")
    public String productionList(Model model, @RequestParam Map param) {

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

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string+"&search_line="+search_line;
        String sQuery = "";

        if (search_line != 0){
            sQuery += " AND A.PRODUCT_LINE LIKE '%" + search_line + "%'";
        }

        if (search_type.equals("PRODUCTION_CODE")) {
            sQuery += " AND A.production_code = '" + search_string +"'";
        }else if(search_type.equals("PLAN_CODE")) {
            sQuery += " AND A.plan_code = '" + search_string +"'";
        }else if(search_type.equals("MANAGER")) {
            sQuery += " AND C.MANAGER_NAME like '%" + search_string + "%'" ;
        }else {
            sQuery += " AND (A.production_code = '"+ search_string +"' or A.plan_code = '"+ search_string +"' or C.MANAGER_NAME like '%" + search_string + "%')";
        }



        model.addAttribute("parameter", parameter);

        Map map = new HashMap();
        map.put("startDate", startDate);
        map.put("endDate",endDate );
        map.put("currentPage", currentPage);
        map.put("rowsPerPage", rowsPerPage);
        map.put("sQuery", sQuery);
        map.put("search_type",search_type);
        map.put("search_line",search_line);

        Map commonMap = new HashMap();
        commonMap.put("code_id","WPS");
        model.addAttribute("planStatus", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","DR");
        model.addAttribute("defectReason", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("total", productionService.productionListTotal(map));
        model.addAttribute("list", productionService.productionList(map));



        model.addAttribute("search", map);

        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        return "/production/list";
    }

    @RequestMapping(value = "/registerProduction", produces="application/json")
    @ResponseBody
    public Map registerProduction(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productionService.writeProduction(paramMap);

        return JsonResponse.asSuccess();
    }

    @GetMapping(value = "/view")
    @ResponseBody
    public Map view(@RequestParam(value="production_code", required=false) String production_code) {

        Map map = new HashMap();


        map.put("production_code", production_code);

        return JsonResponse.asSuccess("storeData", productionService.view(map));
    }


    @RequestMapping(value = "/editProduction", produces="application/json")
    @ResponseBody
    public Map editProduction(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productionService.editProduction(paramMap);

        return JsonResponse.asSuccess();
    }

    @GetMapping(value = "/delete")
    @ResponseBody
    public Map delete(@RequestParam(value="production_code", required=false) String production_code){

        Map map = new HashMap();
        map.put("production_code", production_code);


        productionService.delete(map);

        return JsonResponse.asSuccess("storeData", "");
    }


    @RequestMapping(value = "/serialList")
    public String serialList(Model model, @RequestParam Map param) {

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

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string+"&search_line="+search_line;
        String sQuery = "";

        if (search_line != 0){
            sQuery += " AND A.PRODUCT_LINE LIKE '%" + search_line + "%'";
        }

        if (search_type.equals("PRODUCTION_CODE")) {
            sQuery += " AND A.production_code = '" + search_string +"'";
        }else if(search_type.equals("PLAN_CODE")) {
            sQuery += " AND A.plan_code = '" + search_string +"'";
        }else if(search_type.equals("MANAGER")) {
            sQuery += " AND C.MANAGER_NAME like '%" + search_string + "%'" ;
        }else {
            sQuery += " AND (A.production_code = '"+ search_string +"' or A.plan_code = '"+ search_string +"' or C.MANAGER_NAME like '%" + search_string + "%')";
        }



        model.addAttribute("parameter", parameter);

        Map map = new HashMap();
        map.put("startDate", startDate);
        map.put("endDate",endDate );
        map.put("currentPage", currentPage);
        map.put("rowsPerPage", rowsPerPage);
        map.put("sQuery", sQuery);
        map.put("search_type",search_type);
        map.put("search_line",search_line);

        Map commonMap = new HashMap();
        commonMap.put("code_id","WPS");
        model.addAttribute("planStatus", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","DR");
        model.addAttribute("defectReason", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("total", productionService.productionListTotal(map));
        model.addAttribute("list", productionService.productionList(map));



        model.addAttribute("search", map);

        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        return "/production/serialList";
    }
}
