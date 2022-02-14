package mes.app.controller.popup;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.cust.CustService;
import mes.app.service.material.MaterialService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/popPartlistMaterial")
public class PopupPartlistMaterialController{

    @Autowired
    private SupplyService supplyService;
    @Autowired
    private CustService custService;
    @Autowired
    private MaterialService materialService;
    String M_CODE;

    @RequestMapping(value="/popPartlistMaterialList")
    public String popPartlistMaterialList(Model model,@RequestParam(value="CODE", required=false) String CODE) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        M_CODE=CODE;
        
/*       model.addAttribute("DivisionList", materialService.getProductDivisionList(paramMap));
       model.addAttribute("ProductGroupCDList", materialService.getProductGroupCDList(paramMap));*/
       model.addAttribute("CategoryList", materialService.getProductCategoryList(paramMap));
       return "empty:/popPartlistMaterialList";
    }
    
    
    @RequestMapping(value="/getpopPartlistMaterialList")
    @ResponseBody
    public Map getpopPartlistMaterialList(Model model,@RequestParam Map param) {

        String search_type = "";
        String search_string = "";
        String USE_YN = "Y";
        String CAT_CD ="";
        String DIVISION_SEQ = "";
        String PROD_TYPE ="";
        
        System.out.println(param);
        int rowsPerPage = 0;
        int currentPage = 1;
  
        
        if (param.get("CAT_CD") == null) {
        	CAT_CD = "ALL";
        }else {
        	CAT_CD = (String) param.get("CAT_CD");
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
        	rowsPerPage = 10;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }
        
        if (param.get("DIVISION_SEQ") == null || param.get("DIVISION_SEQ").equals("")) {
        	DIVISION_SEQ = "ALL";  
        }else{
        	DIVISION_SEQ = (String) param.get("DIVISION_SEQ");
        }
        
        if (param.get("PROD_TYPE") == null || param.get("PROD_TYPE").equals("")) {
        	PROD_TYPE = "0";
        }else {
        	PROD_TYPE = (String) param.get("PROD_TYPE");
        }
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&CAT_CD="
                +CAT_CD+"&USE_YN="+USE_YN+"&DIVISION_SEQ="+DIVISION_SEQ+"&PROD_TYPE="+PROD_TYPE+"&search_string="+search_string;
        String sQuery = "";
      
        sQuery += " A.USE_YN = '" + USE_YN +"'AND NOT CODE IN (select M_CODE from partlist where CODE='"+M_CODE+"')" ;
     

        if (!CAT_CD.equals("ALL")) {
        	sQuery += " AND D.BYCAT_CD = '" + CAT_CD +"'";
        }
        if (!DIVISION_SEQ.equals("ALL")) {
        	sQuery += " AND A.DIVISION_SEQ = '" + DIVISION_SEQ +"'";
        }

        if (search_type.equals("CODE")) {
        	sQuery += " AND A.CODE = '" + search_string +"'";
        }else if(search_type.equals("PDT_NAME")) {
        	sQuery += " AND B.PDT_NAME like '%" + search_string + "%'" ;
        }
        
        if (!PROD_TYPE.equals("")) {
        	sQuery += " AND A.PROD_TYPE = '" + PROD_TYPE +"'";
        }

        
        model.addAttribute("parameter", parameter);
        
        UserInfo info = Util.getUserInfo();       
		Map map = new HashMap();
		map.put("currentPage", currentPage);		
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_type",search_type);
		map.put("search_string",search_string);
		map.put("USE_YN",USE_YN);
		map.put("CAT_CD",CAT_CD);
		map.put("DIVISION_SEQ",DIVISION_SEQ);
		map.put("PROD_TYPE",PROD_TYPE);

		Map resultMap = new HashMap();
		resultMap.put("total", materialService.materialListTotal(map));
		resultMap.put("list", materialService.getMaterialGroupList(map));
		resultMap.put("search", map);

        
        
        return JsonResponse.asSuccess("storeData", resultMap);  
    }
    
    
    @RequestMapping(value="/getpopPartlistMaterialInfo")
    @ResponseBody
    public Map getpopPartlistMaterialInfo(Model model,@RequestParam Map param) {
    
        
    	return JsonResponse.asSuccess("storeData", materialService.getRowMaterial(param));

    }
    
    
}