package mes.app.controller.purchase;


import mes.app.service.purchase.PurchaseService;
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
@RequestMapping(value="/purchase")
public class PurchaseController {

    @Autowired
    private PurchaseService purchaseService;



    @RequestMapping(value="/view")
    public String purchaseviewPage(Model model) {
        
        return "/purchase/view";
    }
    
    @PostMapping(value = "/getPurchaseList"
            , produces="application/json")
    @ResponseBody
    public Map getPurchaseList(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", purchaseService.getPurchaseList(paramMap));
    }
   
    

      

      

      
	 
    


}
