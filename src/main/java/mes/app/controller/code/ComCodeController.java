package mes.app.controller.code;

import mes.app.service.code.ComCodeService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping(value="/code")
public class ComCodeController extends CodeSessionController {

    @Autowired
    private ComCodeService comCodeService;

	private static Logger logger = LoggerFactory.getLogger(ComCodeController.class);

	@RequestMapping(value="/comCodeList")
    public String comCodeList(Model model, HttpServletRequest req, @RequestParam Map param) {
		Map paramMap = new HashMap();
		paramMap.put("currentPage", 1);
		paramMap.put("rowsPerPage", 999);

		String search_type = "";
		String search_string = "";


		int rowsPerPage = 0;
		int currentPage = 1;


		if (param.get("search_type") == null) {
			search_type = "ALL";
		}else {
			search_type = (String) param.get("search_type");
		}
		if(param.get("search_string") == null) {
			search_string = "";
		}else {
			search_string = (String) param.get("search_string");
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


		String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&search_string="+search_string;
		String sQuery = "";

		if (search_type.equals("codeID")) {
			sQuery += "AND A.CODE_ID like '%" + search_string + "%'";
		} else if (search_type.equals("code_nm")) {
			sQuery += "AND A.CODE_NM like '%" + search_string + "%'";
		} else {
			sQuery += "AND (A.CODE_ID like '%" + search_string + "%' or A.CODE_NM like '%" + search_string + "%')";
		}

		model.addAttribute("parameter", parameter);

		UserInfo info = Util.getUserInfo();
		Map map = new HashMap();

		map.put("currentPage", currentPage);
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_type",search_type);

		model.addAttribute("total", comCodeService.comCodeListTotal(map));
		model.addAttribute("list", comCodeService.comCodeList(map));

		model.addAttribute("search", map);

		model.addAttribute("currentPage",currentPage);
		model.addAttribute("rowsPerPage",rowsPerPage);

    	return "/code/comCodeList";
	}

	/*@RequestMapping(value="/comCodeDetailList")
	public String comCodeDetailList(Model model, HttpServletRequest req, @RequestParam Map param) {
		Map paramMap = new HashMap();
		paramMap.put("currentPage", 1);
		paramMap.put("rowsPerPage", 999);

		String search_type = "";

		String search_string = "";


		int rowsPerPage = 0;
		int currentPage = 1;


		if (param.get("search_type") == null) {
			search_type = "ALL";
		}else {
			search_type = (String) param.get("search_type");
		}


		if(param.get("search_string") == null) {
			search_string = "";
		}else {
			search_string = (String) param.get("search_string");
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


		String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&search_string="+search_string;
		String sQuery = "";

		if(!search_type.equals("ALL")){
			sQuery += " AND B.CODE_ID = '" + search_type + "'";
		}


		sQuery += " AND (A.code like '%" + search_string + "%' or A.code_nm like '%" + search_string + "%')";


		Map map = new HashMap();
		map.put("currentPage", currentPage);
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_type",search_type);



		model.addAttribute("parameter", parameter);
		model.addAttribute("total", comCodeService.comCodeDetailListTotal(map));
		model.addAttribute("list", comCodeService.comCodeDetailList(map));
		model.addAttribute("code_list", comCodeService.comCodeSelectList(map));
		model.addAttribute("search", map);


    	return "/code/comCodeDetailList";
	}*/
 


	@PostMapping(value="/manageCode" , produces="application/json")
	@ResponseBody
	public Map manageCode(@RequestParam Map param, HttpServletRequest request ){
    	logger.debug("param >> " + param);
		String result = comCodeService.Code_Manage_V1_Str(param);
		return JsonResponse.asSuccess("msg",result);
	}


	@GetMapping(value = "/codeInfo")
	@ResponseBody
	public Map codeInfo(@RequestParam(value="code_id", required=false) String code_id) {

		Map map = new HashMap();
		map.put("code_id", code_id);

		return JsonResponse.asSuccess("storeData", comCodeService.codeInfo(map));
	}

	@PostMapping(value="/manageCodeDetail" , produces="application/json")
	@ResponseBody
	public Map manageCodeDetail(@RequestParam Map param, HttpServletRequest request ){
		logger.debug("param >> " + param);
		String result = comCodeService.CodeDetail_Manage_V1_Str(param);
		return JsonResponse.asSuccess("msg",result);

	}

/*	@GetMapping(value = "/codeDetailInfo")
	@ResponseBody
	public Map codeDetailInfo(@RequestParam(value="code", required=false) String code) {

		Map map = new HashMap();
		map.put("code", code);

		return JsonResponse.asSuccess("storeData", comCodeService.codeDetailInfo(map));
	}*/

	@RequestMapping(value="/codeDetailList")
	@ResponseBody
	public Map codeDetailList(Model model, @RequestParam Map param) {
		param.put("currentPage",1);
		param.put("rowsPerPage",15);
		return JsonResponse.asSuccess("storeData", comCodeService.selectComCodeDetail(param));
	}

	@GetMapping(value="/deleteCodeDetail")
	@ResponseBody
	public Map deleteCodeDetail(Model model, @RequestParam Map param) {

		return JsonResponse.asSuccess("storeData", comCodeService.deleteComCodeDetail(param));
	}


	@RequestMapping(value="/popComCodeList")
	public String popComCodeList(Model model, @RequestParam Map param) {

		model.addAttribute("code_id", param.get("code_id"));

		return "/popup/popComCode";
	}

	@PostMapping(value="/getPopComCodeList")
	@ResponseBody
	public Map getPopComCodeList(Model model, @RequestParam Map param) {
		logger.debug(">> " + param);
		List<Map<String,String>> list = comCodeService.comCodeDetailList(param);
		int total = comCodeService.comCodeDetailListTotal(param);
		Map map = new HashMap();
		map.put("list",list);
		map.put("total",total);
		map.put("search",param);

		return JsonResponse.asSuccess("storeData",map);
	}
}
