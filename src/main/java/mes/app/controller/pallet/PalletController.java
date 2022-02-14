package mes.app.controller.pallet;

import mes.app.service.pallet.PalletService;
import mes.common.model.JsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping(value="/pallet")
public class PalletController {

    @Autowired
    private PalletService palletService;



    @RequestMapping(value="/pallet")
    public String palletPage(Model model, @RequestParam Map param) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        model.addAttribute("PalletList", palletService.getPalletList());
        System.out.println("param : "+param);

        String REMARKS_WIN = "";
        int pallet_status;
        int rowsPerPage = 0;
        int currentPage = 1;

        if (param.get("pallet_status") == null) {
            pallet_status = 1;
        }else {
            pallet_status = Integer.parseInt(param.get("pallet_status").toString());
        }

        if(param.get("REMARKS_WIN") == null) {
            REMARKS_WIN = "";
        }else {
            REMARKS_WIN = (String) param.get("REMARKS_WIN");
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

        String parameter = "&currentPage="+currentPage+"&rowsPerPage="+rowsPerPage+"&pallet_status=" + pallet_status + "&REMARKS_WIN=" + REMARKS_WIN;

        param.put("pallet_status",pallet_status);
        model.addAttribute("pallet_status",pallet_status);
        param.put("REMARKS_WIN",REMARKS_WIN);
        model.addAttribute("REMARKS_WIN",REMARKS_WIN);
        param.put("currentPage",currentPage);
        model.addAttribute("currentPage",currentPage);
        param.put("rowsPerPage",rowsPerPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        model.addAttribute("parameter", parameter);
        model.addAttribute("search", param);

        model.addAttribute("list",palletService.getPalletList(param));

        return "/pallet/pallet";
    }

    @PostMapping(value = "/getPalletList"
            , produces="application/json")
    @ResponseBody
    public Map getPalletList(@RequestBody Map paramMap) {
//    	System.out.println("param" + paramMap);
//    	System.out.println(palletService.getpalletList(paramMap));
        return JsonResponse.asSuccess("storeData", palletService.getPalletList(paramMap));
    }
    
    @PostMapping(value = "/createPallet"
            , produces="application/json")
    @ResponseBody
    public Map createPallet(@RequestBody Map paramMap) {
    	
    	palletService.createPallet(paramMap);
    	
    

        return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/getBoxList"
            , produces="application/json")
    @ResponseBody
   public Map getBoxList(@RequestBody  Map paramMap) {
    	System.out.println("pallet_num" + paramMap);
    	System.out.println(palletService.getBoxList(paramMap));
   
       return palletService.getBoxList(paramMap);
   }
    
    


}
