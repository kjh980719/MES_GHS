package mes.app.controller.partlist;

import mes.app.service.partlist.PartlistService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/partlist")
public class PartlistController {

    @Autowired
    private PartlistService partlistService;



    @RequestMapping(value="/partlist")
    public String PartlistPage(Model model, @RequestParam Map param) {
         String search_string = "";
         String search_type = "";
         int rowsPerPage = 0;
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
         	rowsPerPage = 15;
         }else {
         	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
         }
         
       
         String parameter = "&rowsPerPage=" + rowsPerPage + "&search_type=" + search_type +"&search_string="+search_string;
         String sQuery = "";
         
         sQuery += "1=1";
/*
         if (search_type.equals("CODE")) {
         	sQuery += " AND D.PDT_CD like '%" + search_string +"%'";
         }else if(search_type.equals("PDT_NAME")) {
         	sQuery += " AND D.PDT_NAME like '%" + search_string + "%'" ;	
         }else if(search_type.equals("M_CODE")) {
         	sQuery += " AND D.M_CD like '%" + search_string + "%'" ;
         }else if(search_type.equals("MTR_NAME")) {
         	sQuery += " AND D.MTR_NAME like '%" + search_string + "%'" ;
         }else if(search_type.equals("ALL")){
         	sQuery += " AND concat(D.PDT_CD,'|',D.PDT_NAME,'|',D.M_CD,'|',D.MTR_NAME) like concat('%','"+ search_string +"','%')";
         }
*/

         Map paramMap = new HashMap();

         paramMap.put("currentPage", currentPage);	
         paramMap.put("rowsPerPage", rowsPerPage);
         paramMap.put("sQuery", sQuery);
         paramMap.put("search_type",search_type);
         
         model.addAttribute("parameter", parameter);
         model.addAttribute("search", paramMap);
         
     	 model.addAttribute("total", partlistService.partlistTotal(paramMap));        
         model.addAttribute("list", partlistService.getPartList(paramMap));
         
        return "/partlist/partlist";
    }
    
    

    @GetMapping(value = "/getPartListRow")
    @ResponseBody
    public Map getPartListRow(@RequestParam(value="PDT_CD", required=false) String PDT_CD) {
    	Map map = new HashMap();
        map.put("PDT_CD", PDT_CD);
        return JsonResponse.asSuccess("storeData", partlistService.getPartListRow(map));
    }


    @PostMapping(value = "/createPartlist", produces="application/json")
    @ResponseBody
    public Map createPartlist(@RequestBody List<Map<String, String>> paramMap) {

        for(int i = 0; i < paramMap.size(); i++) {
    	//System.out.println(paramMap.get(i));
    	  partlistService.createPartlist(paramMap.get(i));
    	}
		
        return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/updatePartlist", produces="application/json")
    @ResponseBody
    public Map updatePartlist(@RequestBody List<Map<String, String>> paramMap) {
    	//System.out.println(paramMap.get(0));
		 partlistService.deletePartlist(paramMap.get(0).get("PDT_CD"));
		
		 for(int i = 0; i < paramMap.size(); i++) {
		 //System.out.println(paramMap.get(i));
		 partlistService.createPartlist(paramMap.get(i)); }
		 
		
        return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/deletePartlist", produces="application/json")
    @ResponseBody
    public Map deletePartlist(@RequestBody Map<String, String> paramMap) {
    	//System.out.println(paramMap.get("PDT_CD"));
		 partlistService.deletePartlist(paramMap.get("PDT_CD"));
		 
        return JsonResponse.asSuccess();
    }

    
    
}
