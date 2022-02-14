package mes.app.controller.check;

import mes.app.service.check.CheckService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/check")
public class CheckController {

    @Autowired
    private CheckService checkService;



    @RequestMapping(value="/import")
    public String checkimportPage(Model model) {
        
        return "/check/import";
    }
    
    @RequestMapping(value="/product")
    public String checkproductPage(Model model) {
		/*
		 * Map paramMap = new HashMap(); paramMap.put("currentPage", 1);
		 * paramMap.put("rowsPerPage", 999);
		 * 
		 * model.addAttribute("PalletList", checkService.getPalletList());
		 */
        
        return "/check/product";
    }
    
    @RequestMapping(value="/fair")
    public String checkfairPage(Model model) {
        
        return "/check/fair";
    }

	/*
	 * @PostMapping(value = "/getPalletList" , produces="application/json")
	 * 
	 * @ResponseBody public Map getPalletList(@RequestBody Map paramMap) { //
	 * System.out.println("param" + paramMap); //
	 * System.out.println(checkService.getpalletList(paramMap)); return
	 * JsonResponse.asSuccess("storeData", checkService.getPalletList(paramMap)); }
	 * 
	 * @PostMapping(value = "/createPallet" , produces="application/json")
	 * 
	 * @ResponseBody public Map createPallet(@RequestBody Map paramMap) {
	 * 
	 * checkService.createPallet(paramMap);
	 * 
	 * 
	 * 
	 * return JsonResponse.asSuccess(); }
	 * 
	 * @PostMapping(value = "/getBoxList" , produces="application/json")
	 * 
	 * @ResponseBody public Map getBoxList(@RequestBody Map paramMap) {
	 * System.out.println("pallet_num" + paramMap);
	 * System.out.println(checkService.getBoxList(paramMap));
	 * 
	 * return checkService.getBoxList(paramMap); }
	 * 
	 * 
	 */ 
      @PostMapping(value = "/getInMaterialList" , produces="application/json")
	  
	  @ResponseBody public Map getInMaterialList(@RequestBody Map paramMap) { 

	  return JsonResponse.asSuccess("storeData",checkService.getInMaterialList(paramMap)); 
	  }
      
      @PostMapping(value = "/updateImport"
              , produces="application/json")
      @ResponseBody
      public Map updateImport(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	
      	List<Map<String, Object>> checkimportList = (List<Map<String, Object>>)paramMap.get("checkimportList");
      	System.out.println(checkimportList);
      	
      	Map<String, Object> importlist=checkimportList.get(0);
      	
      	if(importlist.get("CHECK_YN").equals("CII")) {
      	
      	
  		checkService.updateImport(importlist); 
  		System.out.println(importlist);
  		for(int i = 0; i < checkimportList.size(); i++) { 
  			 System.err.println(i + " : " +checkimportList.get(i).get("QTY"));
  			 System.out.println(checkimportList.get(i));
  			checkService.updateImportMaterial(checkimportList.get(i));
  			checkService.updateStockMaterial(checkimportList.get(i));
  			checkimportList.get(i).put("WRITTEN_BY", Util.getUserInfo().getManagerName());
  			checkService.insertStock(checkimportList.get(i));
  			int QTY=Integer.valueOf((String) checkimportList.get(i).get("QTY"))-Integer.valueOf((String) checkimportList.get(i).get("REAL_QTY"));
  			
  			if(QTY != 0 ) {
  				checkimportList.get(i).remove("QTY");
  				checkimportList.get(i).put("QTY",QTY);
				/* checkService.createDefect(checkimportList.get(i)); */
  				System.out.println(checkimportList.get(i));
  			}
  			
  		}
      	}
  		 
          return JsonResponse.asSuccess();
      }
      

      
	 
    


}
