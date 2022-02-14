package mes.app.controller.buyer;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import mes.app.service.buyer.BuyerService;
import mes.app.service.cust.CustService;
import mes.app.service.supply.SupplyService;
import mes.app.util.StringUtil;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping(value = "/buyer")
public class BuyerController {

  @Autowired
  private BuyerService buyerService;
  @Autowired
  private CustService custService;

  @PostMapping(value = "/getBuyerMemberList", produces = "application/json")
  @ResponseBody
  public Map<String, Object> getBuyerMemberList(Model model, @RequestParam Map param) {
    return JsonResponse.asSuccess("storeData", buyerService.getBuyerMemberList(param));
  }

  @PostMapping(value = "/BuyerAccountRegister", produces="application/json")
  @ResponseBody
  public Map BuyerAccountRegister(@RequestBody Map<String, List<Map>> paramMap) {
    System.err.println("paramMap : " + paramMap);
    List<Map>  buyercreateList = (List<Map>)paramMap.get("buyercreateList");

    for(int i = 0; i < buyercreateList.size(); i++) {
      if(StringUtil.isNullToString(buyercreateList.get(i).get("buyer_member_seq")).equals("")) {
        buyercreateList.get(i).put("buyer_auth_group_seq", 2);
        buyerService.buyerMemberInsertAccount(buyercreateList.get(i));
      }else
        buyerService.buyerMemberUpdateAccount(buyercreateList.get(i));
    }

    return JsonResponse.asSuccess();
  }
}
