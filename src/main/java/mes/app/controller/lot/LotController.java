package mes.app.controller.lot;

import mes.app.controller.supervisor.API;
import mes.app.service.supply.SupplyService;
import mes.common.model.JsonResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value="/lot")
public class LotController {

    @Autowired
    private SupplyService supplyService;



    @RequestMapping(value="/lot")
    public String LotPage(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        model.addAttribute("EXchangeList", supplyService.getExchangeList());
        return "/lot/lot";
    }
    
    @PostMapping(value = "/getSupplyList"
            , produces="application/json")
    @ResponseBody
    public Map getSupplyList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", supplyService.getSupplyList(paramMap));
    }
    
    

    @PostMapping(value = "/createSupply"
            , produces="application/json")
    @ResponseBody
    public Map createsupply(@RequestBody Map paramMap) {
    	supplyService.createSupply(paramMap);
    	System.out.println(paramMap);
    	 Map<String, Object> paramMap2 = new HashMap<String, Object>();
       paramMap2.put("COM_CODE","81546");
       String ZONE=null;
       try{
           ZONE=API.urlConnect("https://oapi.ecounterp.com/OAPI/V2/Zone", "POST", paramMap2,"Data","ZONE");
           }catch (Exception e) {
    		e.printStackTrace();
   		}
       
     System.out.println(ZONE);
       paramMap2.put("ZONE",ZONE);
       paramMap2.put("USER_ID","red-angle");
       paramMap2.put("API_CERT_KEY","36e049b8f84954170bbc2f798ac66bad74");
       String SESSION_ID=null;
       try{
       	SESSION_ID=API.urlConnect("https://oapi"+ZONE+".ecounterp.com/OAPI/V2/OAPILogin", "POST", paramMap2,"Data","Datas","SESSION_ID");
       }catch (Exception e) {
		e.printStackTrace();
		}
       System.out.println(SESSION_ID);
           try{
           	String a=API.urlConnectInsert("https://oapi"+ZONE+".ecounterp.com/OAPI/V2/AccountBasic/SaveBasicCust?SESSION_ID="+SESSION_ID, "POST", paramMap,"CustList");
           	System.out.println(a);
          }catch (Exception e) {
  		e.printStackTrace();
   		}

        return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/selectSupply"
            , produces="application/json")
    @ResponseBody
    public Map selectSupply(@RequestBody Map paramMap) {
        
        return JsonResponse.asSuccess("storeData", supplyService.getRowSupply(paramMap));
    }
    

}
