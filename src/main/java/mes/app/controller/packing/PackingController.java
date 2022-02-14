package mes.app.controller.packing;

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
@RequestMapping(value="/packing")
public class PackingController {

    @Autowired
    private SupplyService supplyService;



    @RequestMapping(value="/packing")
    public String packingPage(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        model.addAttribute("EXchangeList", supplyService.getExchangeList());
        return "/packing/packing";
    }
    
    @RequestMapping(value="/packingview")
    public String PackingViewPage(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        model.addAttribute("EXchangeList", supplyService.getExchangeList());
        return "/packing/packingview";
    }


    
    @PostMapping(value = "/getSupplyList"
            , produces="application/json")
    @ResponseBody
    public Map getSupplyList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", supplyService.getSupplyList(paramMap));
    }
    
    @PostMapping(value = "/selectSupply"
            , produces="application/json")
    @ResponseBody
    public Map selectSupply(@RequestBody Map paramMap) {
        
        return JsonResponse.asSuccess("storeData", supplyService.getRowSupply(paramMap));
    }
    

}
