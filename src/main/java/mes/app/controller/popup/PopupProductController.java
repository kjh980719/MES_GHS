package mes.app.controller.popup;

import mes.app.service.code.ComCodeService;
import mes.app.service.contract.ContractService;
import mes.app.service.cust.CustService;
import mes.app.service.material.MaterialService;
import mes.app.service.order.OrderService;
import mes.app.service.product.ProductService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/order")
public class PopupProductController{

    @Autowired
    private OrderService orderService;

    @Autowired
    private ContractService contractService;

    @Autowired
    private ProductService productService;
    @Autowired
    private ComCodeService comCodeService;


    @RequestMapping(value="/popProductList")
    public String popProductList(Model model,@RequestParam Map param) {

        Map commonMap = new HashMap();
        commonMap.put("code_id","PG");
        model.addAttribute("category", productService.getProductCategory_Depth1_List());
        model.addAttribute("productGubun", comCodeService.comCodeDetailSelectList(commonMap));
        model.addAttribute("param", param);

       return "empty:/popProductList";
    }

    @RequestMapping(value="/getPopProductList")
    @ResponseBody
    public Map getPopProductList(Model model,@RequestParam Map param) {


        String search_type = "";
        String search_string = "";
        String CAT_CD ="";
        String PROD_TYPE ="";
        String type = "";
        int rowsPerPage = 0;
        int currentPage = 1;
        System.out.println(param);
        String sQuery = "";
        sQuery += " A.USE_YN = 'Y' ";

        if (param.get("CAT_CD") == null) {
            CAT_CD = "ALL";
        }else {
            CAT_CD = (String) param.get("CAT_CD");
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

        if (param.get("type") == null) {
            type = "";
        }else {
            type = (String) param.get("type");
        }

        if (param.get("PROD_TYPE") == null) {
            if (type.equals("contract") || type.equals("producePlan") || type.equals("workPlan") || type.equals("orderPlan")) {
                sQuery += " AND A.PROD_TYPE IN ('PG003', 'PG004', 'PG005', 'PG006')";
            }
        }else {
            if (param.get("PROD_TYPE").equals("ALL")) {
                if (type.equals("contract") || type.equals("producePlan") || type.equals("workPlan") || type.equals("orderPlan")) {
                    sQuery += " AND A.PROD_TYPE IN ('PG003', 'PG004', 'PG005', 'PG006')";
                }
            }else{
                sQuery += " AND A.PROD_TYPE = '"+ param.get("PROD_TYPE")+"'";
            }
        }

        if (!CAT_CD.equals("ALL")) {
            sQuery += "AND B.BYCAT_CD = '" + CAT_CD +"'";
        }

        if (search_type.equals("CODE")) {
            sQuery += "AND A.PDT_CODE = '" + search_string +"'";
        }else if(search_type.equals("PDT_NAME")) {
            sQuery += "AND A.PDT_NAME like '%" + search_string + "%'" ;
        }else if(search_type.equals("REMARKS_WIN") && !search_string.equals("")) {
            sQuery += "AND A.REMARKS_WIN like '%" + search_string + "%'" ;
        }else if(search_type.equals("ALL") && !search_string.equals("")){
            sQuery += "AND concat(A.PDT_CODE,'|',A.PDT_NAME,'|',REMARKS_WIN) like concat('%','"
                    + search_string +"','%')";
        }

        System.out.println("1 >> " + sQuery);

        Map map = new HashMap();
        map.put("currentPage", currentPage);
        map.put("rowsPerPage", 10);

        Map resultMap = new HashMap();
        resultMap.put("search", map);
        map.put("sQuery", sQuery);


        if (type.equals("orderplan") || type.equals("out")){
            resultMap.put("total", productService.getProductListTotal2(map));
            resultMap.put("list", productService.getProductList2(map));
        }else{
            resultMap.put("total", productService.getProductListTotal(map));
            resultMap.put("list", productService.getProductList(map));
        }

        return JsonResponse.asSuccess("storeData", resultMap);
    }


    @RequestMapping(value="/popOrderList")
    public String popOrderList(Model model) {

        Map commonMap = new HashMap();
        commonMap.put("code_id","OS");
        model.addAttribute("orderStatus", comCodeService.comCodeDetailSelectList(commonMap));
    	
       return "empty:/popOrderList";
    }

    @RequestMapping(value="/getPopOrderInfo")
    @ResponseBody
    public Map getPopOrderInfo(Model model,@RequestParam Map param) {
    
        
    	return JsonResponse.asSuccess("storeData", orderService.orderInfo(param));

    }
    
    @RequestMapping(value="/getPopOrderList")
    @ResponseBody
    public Map getPopOrderList(Model model,@RequestParam Map param) {

         String startDate = "";
         String endDate = "";
         String order_status = "";
         String search_type = "";
         String search_string = "";

         int rowsPerPage = 15;
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
         
         if (param.get("order_status") == null || param.get("order_status").equals("")) {
         	order_status = "ALL";
         }else {
         	order_status = (String) param.get("order_status");
         }
         if (param.get("search_type") == null || param.get("search_type").equals("")) {
         	search_type = "ALL";
         }else {
         	search_type = (String) param.get("search_type");
         }
         if(param.get("search_string") == null || param.get("search_string").equals("")) {
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
         	System.out.println(param.get("rowsPerPage"));
         }

 		Map map = new HashMap();

		map.put("startDate", startDate); //발주일자 시작
		map.put("endDate",endDate );//발주일자 종료
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("order_status",order_status);
		map.put("search_type",search_type);
		map.put("search_string",search_string);

 		Map resultMap = new HashMap();
	
		resultMap.put("list", orderService.orderList(map));
		resultMap.put("search", map);
		

        
        
        return JsonResponse.asSuccess("storeData", resultMap);  
    }

    @RequestMapping(value="/popContractList")
    public String popContractList(Model model) {
        return "empty:/popContractList";
    }

    @RequestMapping(value="/getPopContractInfo")
    @ResponseBody
    public Map getPopContractInfo(Model model,@RequestParam Map param) {
        return JsonResponse.asSuccess("storeData", contractService.contractInfo(param));
    }

    @RequestMapping(value="/getPopContractList")
    @ResponseBody
    public Map getPopContractList(Model model,@RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String contract_status = "";
        String search_type = "";
        String search_string = "";

        int rowsPerPage = 15;
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

        if (param.get("contract_status") == null || param.get("contract_status").equals("")) {
            contract_status = "ALL";
        }else {
            contract_status = (String) param.get("order_status");
        }
        if (param.get("search_type") == null || param.get("search_type").equals("")) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
        }
        if(param.get("search_string") == null || param.get("search_string").equals("")) {
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
            System.out.println(param.get("rowsPerPage"));
        }

        Map map = new HashMap();

        map.put("startDate", startDate);
        map.put("endDate",endDate );
        map.put("currentPage", currentPage);
        map.put("rowsPerPage", rowsPerPage);
        map.put("contract_status",contract_status);
        map.put("search_type",search_type);
        map.put("search_string",search_string);

        Map resultMap = new HashMap();

        Map commonMap = new HashMap();
        commonMap.put("code_id","CS");
        resultMap.put("contractStatus", comCodeService.comCodeDetailSelectList(commonMap));
        resultMap.put("list", contractService.contractList(map));
        resultMap.put("search", map);




        return JsonResponse.asSuccess("storeData", resultMap);
    }



}
