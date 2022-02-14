package mes.app.controller.contract;


import lombok.extern.slf4j.Slf4j;
import mes.app.service.code.ComCodeService;
import mes.app.service.contract.ContractService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@Slf4j
@RequestMapping(value="/contract")
public class ContractController {

    @Autowired
    private ContractService contractService;
    @Autowired
    private ComCodeService comCodeService;

    
    @RequestMapping(value="/contract")
    public String contractPage(Model model, @RequestParam Map param) {
        String startDate = "";
        String endDate = "";
        String contract_status = "";
        String search_type = "";
        String search_string = "";

        int rowsPerPage = 0;
        int currentPage = 1;
   
        if (param.get("startDate") == null || param.get("endDate") == null) {
	        Calendar cal = Calendar.getInstance();
	        String format = "yyyy-MM-dd";
	        SimpleDateFormat sdf = new SimpleDateFormat(format);
	            	             
	        //처음 들어왔을 때
	        cal.add(cal.MONTH, -3); //세달 전
	        startDate = sdf.format(cal.getTime());   
	         
	        cal.add(cal.MONTH, +6); //세달 후
	        endDate = sdf.format(cal.getTime());                
        }else {
        	startDate = (String) param.get("startDate");
        	endDate = (String) param.get("endDate");
        }
        
        if (param.get("contract_status") == null) {
        	contract_status = "ALL";
        }else {
        	contract_status = (String) param.get("contract_status");
        }
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
        
        if (param.get("rowsPerPage") == null) {
        	rowsPerPage = 15;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&contract_status="
        +contract_status+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

		Map map = new HashMap();
		map.put("startDate", startDate); //발주일자 시작
		map.put("endDate",endDate );//발주일자 종료
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("contract_status",contract_status);
		map.put("search_type",search_type);
        map.put("search_string",search_string);


        Map commonMap = new HashMap();
        commonMap.put("code_id","CS");
        model.addAttribute("contractStatus", comCodeService.comCodeDetailSelectList(commonMap));
		model.addAttribute("search", map);
        model.addAttribute("list", contractService.contractList(map));

        return "/contract/contract";
    }

    @GetMapping(value = "/getContractInfo")
    @ResponseBody
    public Map getContractInfo(@RequestParam(value="contract_seq", required=false) String contract_seq) {
		Map map = new HashMap();
        map.put("contract_seq", Integer.parseInt(contract_seq));
		return JsonResponse.asSuccess("storeData", contractService.contractInfo(map));
    }
    

    @PostMapping(value = "/registerContract", produces="application/json")
    @ResponseBody
    public Map registerContract(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        List<Map<String, Object>> contractDetailList = paramMap.get("contractDetailList");
        List<Map<String, Object>> contract_info = paramMap.get("contract_info");

        contract_info.get(0).put("code", "");

        //System.out.println(contract_info.get(0));
        //System.out.println(contractDetailList.get(0));

        String contract_code = contractService.writeContract(contract_info.get(0));


        for (int i = 0; i < contractDetailList.size(); i++) {
            contractDetailList.get(i).put("contract_code", contract_code);
            contractService.writeContractDetail(contractDetailList.get(i));
        }

    	return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/contractInfoUpdate")
    @ResponseBody
    public Map contractInfoUpdate(@RequestParam Map param) {
    
		System.out.println(param);
    	contractService.contractInfoUpdate(param);
		return JsonResponse.asSuccess();	
    }
    
    
    @PostMapping(value = "/contractInfoUpdateCancel")
    @ResponseBody
    public Map contractInfoUpdateCancel(@RequestParam Map param) {
    
		
    	contractService.contractInfoUpdateCancel(param);
		return JsonResponse.asSuccess();	
    }

}
