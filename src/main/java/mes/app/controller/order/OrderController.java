package mes.app.controller.order;


import mes.app.service.code.ComCodeService;
import mes.app.service.order.OrderService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;

import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping(value="/order")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @Autowired
    private ComCodeService comCodeService;


    @RequestMapping(value="/makeorderview")
    public String makeorderviewPage(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String order_status = "";
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
        
        if (param.get("order_status") == null) {
        	order_status = "ALL";
        }else {
        	order_status = (String) param.get("order_status");
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

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&order_status="
        +order_status+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);
        
        UserInfo info = Util.getUserInfo();       
		Map map = new HashMap();
		map.put("startDate", startDate); //발주일자 시작
		map.put("endDate",endDate );//발주일자 종료
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("order_status",order_status);
		map.put("search_type",search_type);
		map.put("search_string",search_string);

        Map commonMap = new HashMap();
        commonMap.put("code_id","OS");
        model.addAttribute("orderStatus", comCodeService.comCodeDetailSelectList(commonMap));
		model.addAttribute("list", orderService.orderList(map));
		model.addAttribute("search", map);
        
        return "/order/makeorderview";
    }

    @GetMapping(value = "/getOrderInfo")
    @ResponseBody
    public Map getOrderInfo(@RequestParam(value="order_seq", required=false) String order_seq) {
        
		Map map = new HashMap();
        map.put("order_seq", Integer.parseInt(order_seq));
		return JsonResponse.asSuccess("storeData", orderService.orderInfo(map));	
    }

    @PostMapping(value = "/registerOrder", produces="application/json")
    @ResponseBody
    public Map registerOrder(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> orderdetailList = paramMap.get("orderdetailList");
    	List<Map<String, Object>> order_info = paramMap.get("order_info");

    	order_info.get(0).put("code", "");

    	String order_code = orderService.writeOrder(order_info.get(0));

    	for(int i = 0; i < orderdetailList.size(); i++) {
            orderdetailList.get(i).put("order_code", order_code);
    		orderService.writeOrderDetail(orderdetailList.get(i));
    	}

    	return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/orderInfoUpdate")
    @ResponseBody
    public Map orderInfoUpdate(@RequestParam Map param) {

    	orderService.orderInfoUpdate(param);
		return JsonResponse.asSuccess();	
    }

    @PostMapping(value = "/orderInfoUpdateCancel")
    @ResponseBody
    public Map orderInfoUpdateCancel(@RequestParam Map param) {

    	orderService.orderInfoUpdateCancel(param);
		return JsonResponse.asSuccess();	
    }
    
}
