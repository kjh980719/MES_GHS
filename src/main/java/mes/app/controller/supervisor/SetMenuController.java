package mes.app.controller.supervisor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.supervisor.ManagerSetMenuService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/supervisor")
public class SetMenuController {

    @Autowired
    private ManagerSetMenuService managerSetMenuService;

    @RequestMapping(value="/setMenu")
    public String setMenuPage(Model model) {
    	System.out.println(managerSetMenuService.getManagerMenu_Depth1_List());
    	model.addAttribute("depth1", managerSetMenuService.getManagerMenu_Depth1_List());
        return "/supervisor/setMenu";
    }

    @PostMapping(value = "/getMenuList"
            , produces="application/json")
    @ResponseBody
    public Map getManagerList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", managerSetMenuService.getManagerSetMenuList(paramMap));
    }

    @PostMapping(value = "/createMenu"
            , produces="application/json")
    @ResponseBody
    public Map createMenu(@RequestParam Map paramMap) {
    	UserInfo info = Util.getUserInfo();
        paramMap.put("loginUserSeq", info.getManagerSeq());
        String result = managerSetMenuService.createMenu(paramMap);
        return JsonResponse.asSuccess("msg",result);
    }

    @PostMapping(value = "/updateMenu", produces="application/json")
    @ResponseBody
    public Map updateMenu(@RequestParam Map paramMap) {
  
    	UserInfo info = Util.getUserInfo();
        paramMap.put("loginUserSeq", info.getManagerSeq());
    	String result = managerSetMenuService.updateMenu(paramMap);

    	return JsonResponse.asSuccess("msg",result);
    }

    @PostMapping(value = "/updateOrder"
            , produces="application/json")
    @ResponseBody
    public Map updateOrder(@RequestBody List<Map> paramList) {
        managerSetMenuService.updateOrder(paramList);
        return JsonResponse.asSuccess();
    }
    
    @GetMapping(value = "/depthInfo")
    @ResponseBody
    public Map depthInfo(@RequestParam(value="menu_seq", required=false) String menu_seq) {
        
		Map map = new HashMap();

		
        map.put("menu_seq", Integer.parseInt(menu_seq));

		return JsonResponse.asSuccess("storeData", managerSetMenuService.depthInfo(map));	
    }
    @GetMapping(value = "/viewDepth")
    @ResponseBody
    public Map viewDepth(@RequestParam(value="menu_seq", required=false) String menu_seq) {
        
		Map map = new HashMap();

		
        map.put("menu_seq", Integer.parseInt(menu_seq));

		return JsonResponse.asSuccess("storeData", managerSetMenuService.viewDepth(map));	
    }
    
    
}
