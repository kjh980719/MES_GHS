package mes.app.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import mes.app.service.HomeService;
import mes.common.model.JsonResponse;

@Controller
public class HomeController {

    @Autowired
    HomeService homeService;

    @RequestMapping(value = "/")
    public String defaultPage(){
        return "redirect:/order/makeorderview";
    }
    
    @RequestMapping(value = "/test")
    @ResponseBody
    public String test(){
        return "test";
    }
    
	@SuppressWarnings("unchecked")
	@ResponseBody
    @RequestMapping(value = "/admin/getManagerList", method = {RequestMethod.GET, RequestMethod.POST})
    public Map<String, Object> getManagerList(@RequestBody Map paramMap){
    	return  JsonResponse.asSuccess("storeData", homeService.getManagerList(paramMap));
    }

}
