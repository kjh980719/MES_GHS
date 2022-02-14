package mes.app.controller.popup;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.asplan.AsPlanService;
import mes.app.service.cust.CustService;
import mes.app.service.material.MaterialService;
import mes.app.service.supply.SupplyService;
import mes.app.service.workplan.WorkPlanService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/as")
public class PopupAsPlanController{

	@Autowired
	private AsPlanService asPlanService;
    @Autowired
    private SupplyService supplyService;
    @Autowired
    private CustService custService;
    @Autowired
    private MaterialService materialService;

 
    @RequestMapping(value="/popManagerList")
    public String popManagerList(Model model,@RequestParam Map param) {
    
    	model.addAttribute("param", param);
       return "empty:/popManagerList2";
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
         resultMap.put("list", asPlanService.getMangerList(paramMap));
         resultMap.put("total", asPlanService.getMangerListTotal(paramMap));
         resultMap.put("search", paramMap);
         
         
         return JsonResponse.asSuccess("storeData", resultMap);  
    }
    
    @RequestMapping(value="/popProductList")
    public String popProductList(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        
       model.addAttribute("DivisionList", materialService.getProductDivisionList(paramMap));
       model.addAttribute("ProductGroupCDList", materialService.getProductGroupCDList(paramMap));
       model.addAttribute("CategoryList", materialService.getProductCategoryList(paramMap));
       model.addAttribute("type","asplan");
       return "empty:/popProductList3";
    }
    
    
    @RequestMapping(value="/getPopProductList")
    @ResponseBody
    public Map getPopProductList(Model model,@RequestParam Map param) {

        String search_type = "";
        String search_string = "";
        String USE_YN = "Y";
        String CAT_CD ="";
        String DIVISION_SEQ = "";
        String PROD_TYPE ="";
        
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
        	PROD_TYPE = "1";
        }else {
        	PROD_TYPE = (String) param.get("PROD_TYPE");
        }
        

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&CAT_CD="
                +CAT_CD+"&USE_YN="+USE_YN+"&DIVISION_SEQ="+DIVISION_SEQ+"&PROD_TYPE="+PROD_TYPE+"&search_string="+search_string;
        String sQuery = "";
      
        sQuery += " A.USE_YN = '" + USE_YN +"'" ;
     

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
    
    
    @RequestMapping(value="/getPopProductInfo")
    @ResponseBody
    public Map getPopProductInfo(Model model,@RequestParam Map param) {
    
        
    	return JsonResponse.asSuccess("storeData", materialService.getRowMaterial(param));

    }
	
}
