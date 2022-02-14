package mes.app.controller.sell;

import mes.app.service.material.MaterialService;
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
@RequestMapping(value="/productionplan")
public class ProductionPlanController {

    @Autowired
    private MaterialService materialService;



    @RequestMapping(value="/write")
    public String writePage(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        model.addAttribute("DivisionList", materialService.getProductDivisionList(paramMap));
        model.addAttribute("ProductGroupCDList", materialService.getProductGroupCDList(paramMap));
        model.addAttribute("CategoryList", materialService.getProductCategoryList(paramMap));
        return "/productionplan/write";
    }
   
    @PostMapping(value = "/getProductGroupList"
            , produces="application/json")
    @ResponseBody
    public Map getProductGroupList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", materialService.getProductGroupList(paramMap));
    }
    
    @PostMapping(value = "/updateProduct"
            , produces="application/json")
    @ResponseBody
    public Map updateProduct(@RequestBody Map paramMap) {
    	materialService.updateProduct(paramMap);
        return JsonResponse.asSuccess();
    }
    
    @RequestMapping(value="/view")
    public String viewPage(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        model.addAttribute("DivisionList", materialService.getProductDivisionList(paramMap));
        model.addAttribute("ProductGroupCDList", materialService.getProductGroupCDList(paramMap));
        model.addAttribute("CategoryList", materialService.getProductCategoryList(paramMap));
        return "/productionplan/view";
    }
   

}
