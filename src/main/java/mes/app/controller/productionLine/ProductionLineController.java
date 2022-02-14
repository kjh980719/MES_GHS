package mes.app.controller.productionLine;

import mes.app.controller.code.CodeSessionController;
import mes.app.service.productionLine.ProductionLineService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value="/productionLine")
public class ProductionLineController extends CodeSessionController {

	@Autowired
    ProductionLineService productionLineService;



	@RequestMapping(value="/productionLine")
	public String setProductionLinePage(Model model) {
		System.out.println(productionLineService.getProduction_Line_Depth1_List());
		model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
		return "/productionLine/productionLine";
	}

	@PostMapping(value = "/getLineList"
			, produces="application/json")
	@ResponseBody
	public Map getLineList(@RequestBody Map paramMap) {
		return JsonResponse.asSuccess("storeData", productionLineService.getProductionSetLineList(paramMap));
	}

	@PostMapping(value = "/createLine"
			, produces="application/json")
	@ResponseBody
	public Map createLine(@RequestParam Map paramMap) {
		System.out.println("1: " + paramMap);

		UserInfo info = Util.getUserInfo();


		paramMap.put("loginUserSeq", info.getManagerSeq());

        productionLineService.createLine(paramMap);
		return JsonResponse.asSuccess();
	}

	@PostMapping(value = "/updateLine", produces="application/json")
	@ResponseBody
	public Map updateLine(@RequestParam Map paramMap) {

		UserInfo info = Util.getUserInfo();
		paramMap.put("loginUserSeq", info.getManagerSeq());
        productionLineService.updateLine(paramMap);
		return JsonResponse.asSuccess();
	}

	@PostMapping(value = "/updateOrder"
			, produces="application/json")
	@ResponseBody
	public Map updateOrder(@RequestBody List<Map> paramList) {
        productionLineService.updateOrder(paramList);
		return JsonResponse.asSuccess();
	}

	@GetMapping(value = "/depthInfo")
	@ResponseBody
	public Map depthInfo(@RequestParam(value="line_seq", required=false) String line_seq) {

		Map map = new HashMap();


		map.put("line_seq", Integer.parseInt(line_seq));

		return JsonResponse.asSuccess("storeData", productionLineService.depthInfo(map));
	}
	@GetMapping(value = "/viewDepth")
	@ResponseBody
	public Map viewDepth(@RequestParam(value="line_seq", required=false) String line_seq) {

		Map map = new HashMap();


		map.put("line_seq", Integer.parseInt(line_seq));

		return JsonResponse.asSuccess("storeData", productionLineService.viewDepth(map));
	}


}
