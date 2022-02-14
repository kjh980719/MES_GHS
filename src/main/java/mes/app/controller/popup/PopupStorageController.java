package mes.app.controller.popup;

import mes.app.service.code.CodeService;

import mes.app.service.cust.CustService;
import mes.app.service.productionLine.ProductionLineService;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/popup")
public class PopupStorageController {

    @Autowired
    private CodeService codeService;

    @Autowired
    private CustService custService;

    @Autowired
    private ProductionLineService lineService;

    @RequestMapping(value="/popStorageList")
    public String popStorageList(Model model,@RequestParam Map param) {
       model.addAttribute("param", param);
       return "empty:/popStorageList";
    }
    
    @RequestMapping(value="/getStorageList")
    @ResponseBody
    public Map getStorageList(@RequestParam Map param) {


         String search_string = "";
         String search_type = "";
         int rowsPerPage = 15;
         int currentPage = 1;

  
         if(param.get("search_string") == null || param.get("search_string").equals("")) {
         	search_string = "";
         }else {
         	search_string = (String) param.get("search_string");
         }
         
         if (param.get("search_type") == null || param.get("search_type").equals("")) {
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
         	rowsPerPage = 10;
         }else {
         	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
         }


         Map paramMap = new HashMap();


         paramMap.put("currentPage", currentPage);	
         paramMap.put("rowsPerPage", rowsPerPage);
         paramMap.put("search_type",search_type);
         paramMap.put("search_string",search_string);
         
         Map resultMap = new HashMap();

         List<Map> list = codeService.selectStorageList(paramMap);

         resultMap.put("list", list);
         resultMap.put("total", list.get(0).get("total"));
         resultMap.put("search", paramMap);
         
         
         return JsonResponse.asSuccess("storeData", resultMap);  
    }
    @RequestMapping(value="/popLocationList")
    public String popLocationList(Model model, HttpServletRequest req) {
        model.addAttribute("target",req.getParameter("target"));
        Map commonMap = new HashMap();
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));
        return "empty:/popLocationList";
    }


    @RequestMapping(value="/getLocationList")
    @ResponseBody
    public Map getLocationList(Model model,@RequestParam Map param) {

        System.err.println(param);

        String search_type = "";
        String search_type2 = "";
        String search_string = "";

        int rowsPerPage = 15;
        int currentPage = 1;

        if (param.get("search_type") == null || param.get("search_type").equals("")) {
            search_type = "CUST";
        }else {
            search_type = (String) param.get("search_type");
        }

        if (param.get("search_type2") == null || param.get("search_type2").equals("")) {
            search_type2 = "ALL";
        }else {
            search_type2 = (String) param.get("search_type2");
        }

        if(param.get("search_string") == null || param.get("search_string").equals("")) {
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
        Map resultMap = new HashMap();
        String sQuery = "";


        if (param.get("search_type").equals("C")){

            sQuery += "A.USE_YN = 'Y' ";

            if (search_type2.equals("CUST_NAME") && !search_string.equals("")) {
                sQuery += " AND A.CUST_NAME like '%" + search_string +"%'";
            }else if(search_type2.equals("REMARKS_WIN") && !search_string.equals("")) {
                sQuery += " AND A.REMARKS_WIN like '%" + search_string + "%'" ;
            }else if(search_type2.equals("ALL") && !search_string.equals("")){
                sQuery += " AND ( A.CUST_NAME like '%" + search_string + "%' OR A.REMARKS_WIN like '%" + search_string + "%')";
            }

            Map paramMap = new HashMap();

            paramMap.put("currentPage", currentPage);
            paramMap.put("rowsPerPage", 10);
            paramMap.put("sQuery", sQuery);
            paramMap.put("search_type2",search_type2);
            paramMap.put("search_type",search_type);

            resultMap.put("list", custService.custList(paramMap));
            resultMap.put("total", custService.custListTotal(paramMap));
            resultMap.put("search", paramMap);

        }else if(param.get("search_type").equals("L")){

            sQuery += " A.line_name like '%"+search_string+"%' OR B.line_name like '%"+search_string+"%' ";

            Map paramMap = new HashMap();

            paramMap.put("currentPage", currentPage);
            paramMap.put("rowsPerPage", 10);
            paramMap.put("search_type2",search_type2);
            paramMap.put("search_type",search_type);
            paramMap.put("sQuery",sQuery);

            resultMap.put("list",  lineService.getProductionList(paramMap));
            resultMap.put("total", lineService.getProductionListTotal(paramMap));
            resultMap.put("search", paramMap);

        }else if(param.get("search_type").equals("S")){
            sQuery += " A.stor_name like '%"+search_string+"%' OR B.stor_name like '%"+search_string+"%' OR C.stor_name like '%"+search_string+"%' ";

            Map paramMap = new HashMap();

            paramMap.put("currentPage", currentPage);
            paramMap.put("rowsPerPage", 10);
            paramMap.put("search_type2",search_type2);
            paramMap.put("search_type",search_type);
            paramMap.put("sQuery",sQuery);

            Map commonMap = new HashMap();
            List<Map<String, String>> list = codeService.cate1Sql(commonMap);
            resultMap.put("list", list);
            resultMap.put("total",list.size());
            resultMap.put("search", paramMap);
        }

        return JsonResponse.asSuccess("storeData", resultMap);
    }

}
