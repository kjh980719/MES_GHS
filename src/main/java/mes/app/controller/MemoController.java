package mes.app.controller;

import mes.app.service.MemoService;
import mes.common.model.JsonResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Controller
@Slf4j
@RequestMapping("/memo")
public class MemoController {

    @Autowired
    MemoService memoService;

    @GetMapping("/buyerGroupMemoList")
    public String memo4Page(@RequestParam Map paramMap, Model model){
        model.addAttribute("list", memoService.getMemo4(paramMap));
        model.addAttribute("groupCode", paramMap.get("groupCode").toString());
        return "/common/memo/admin_memo4";
    }

    @ResponseBody
    @PostMapping("/insertBuyerGroupMemo")
    public Map insertMemo4(@RequestBody Map paramMap){
        memoService.insertMemo4(paramMap);
        return JsonResponse.asSuccess();
    }

    @ResponseBody
    @PostMapping("/deleteBuyerGroupMemo")
    public Map deleteMemo4(@RequestBody Map paramMap){
        memoService.deleteMemo4(paramMap);
        return JsonResponse.asSuccess();
    }



}
