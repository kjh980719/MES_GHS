package mes.app.controller;

import mes.app.service.CommonCodeService;
import mes.common.model.JsonResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/commonCode")
public class CommonCodeController {

    @Autowired
    CommonCodeService commonCodeService;

    @ResponseBody
    @PostMapping("/getCommonCode")
    public Map getPlatformCommonCode2(@RequestBody Map paramMap){
        return JsonResponse.asSuccess("storeData", commonCodeService.getCommonCode(paramMap));
    }

    @ResponseBody
    @PostMapping("/insertCommonCode")
    public Map insertPlatformCommonCode(@RequestBody Map paramMap){
        commonCodeService.insertCommonCode(paramMap);
        return JsonResponse.asSuccess();
    }

    @ResponseBody
    @PostMapping("/updateUseFixed")
    public Map updateUseFixed(@RequestBody Map paramMap){
        commonCodeService.updateUseFixed(paramMap);
        return JsonResponse.asSuccess();
    }

    @ResponseBody
    @PostMapping("/changeSortNumber")
    public Map changeSortNumber(@RequestBody Map paramMap){
        commonCodeService.changeSortNumber(paramMap);
        log.info("aaa"+paramMap);
        return JsonResponse.asSuccess();
    }

    @ResponseBody
    @PostMapping("/updateCodeName")
    public Map updateCodeName(@RequestBody Map paramMap){
        commonCodeService.updateCodeName(paramMap);
        return JsonResponse.asSuccess();
    }
}
