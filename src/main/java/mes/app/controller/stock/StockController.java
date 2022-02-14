package mes.app.controller.stock;

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
@RequestMapping(value="/stock")
public class StockController {

    @Autowired
    private SupplyService supplyService;



    @RequestMapping(value="/stock")
    public String StockPage(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        model.addAttribute("EXchangeList", supplyService.getExchangeList());
        return "/stock/stock";
    }
    
    @PostMapping(value = "/getSupplyList"
            , produces="application/json")
    @ResponseBody
    public Map getSupplyList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", supplyService.getSupplyList(paramMap));
    }
    

}
