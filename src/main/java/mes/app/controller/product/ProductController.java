package mes.app.controller.product;

import mes.app.service.code.CodeService;
import mes.app.service.code.ComCodeService;
import mes.app.service.material.MaterialService;
import mes.app.service.product.ProductService;
import mes.app.service.productionLine.ProductionLineService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/product")
public class ProductController {

    @Autowired
    private MaterialService materialService;

    @Autowired
    private ProductService productService;

    @Autowired
    private ProductionLineService productionLineService;

    @Autowired
    private ComCodeService comCodeService;

    @Autowired
    private CodeService codeService;

    @RequestMapping(value="/product")
    public String productPage(Model model, @RequestParam Map param) {

        String search_type = "";
        String search_string = "";
        String USE_YN ="";
        String CAT_CD ="";
        String DIVISION_SEQ = "";
        String PROD_TYPE ="";

        int rowsPerPage = 0;
        int currentPage = 1;
        System.out.println(param);
        if (param.get("USE_YN") == null || param.get("USE_YN").equals("")) {
        	USE_YN = "Y";
        }else {
        	USE_YN = (String) param.get("USE_YN");
        }
        
        if (param.get("CAT_CD") == null || param.get("CAT_CD").equals("")) {
        	CAT_CD = "ALL";
        }else {
        	CAT_CD = (String) param.get("CAT_CD");
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
        }
        
        if (param.get("DIVISION_SEQ") == null || param.get("DIVISION_SEQ").equals("")) {
        	DIVISION_SEQ = "ALL";
        }else{
        	DIVISION_SEQ = (String) param.get("DIVISION_SEQ");
        }
        
        if (param.get("PROD_TYPE") == null || param.get("PROD_TYPE").equals("")) {
        	PROD_TYPE = "ALL";
        }else {
        	PROD_TYPE = (String) param.get("PROD_TYPE");
        }
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&CAT_CD="
                +CAT_CD+"&USE_YN="+USE_YN+"&DIVISION_SEQ="+DIVISION_SEQ+"&PROD_TYPE="+PROD_TYPE+"&search_string="+search_string;
        String sQuery = "";
        
        sQuery += " A.USE_YN = '" +USE_YN+"'";

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
        
        if (!PROD_TYPE.equals("ALL")) {
        	sQuery += "AND A.PROD_TYPE = '" + PROD_TYPE +"'";
        }else{
            sQuery += "AND A.PROD_TYPE IN ('PG003','PG004','PG005','PG006')";
        }

        
        model.addAttribute("parameter", parameter);

		Map map = new HashMap();
		map.put("currentPage", currentPage);		
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_type",search_type);
		map.put("search_string",search_string);
		map.put("USE_YN",USE_YN);
		map.put("CAT_CD",CAT_CD);
		map.put("DIVISION_SEQ",DIVISION_SEQ);
		map.put("PROD_TYPE",PROD_TYPE);

		Map commonMap = new HashMap();
        commonMap.put("code_id","PG");
        model.addAttribute("productGubun", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","PGR");
        model.addAttribute("productGroup", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("category",productService.getProductCategory_Depth1_List());
        //model.addAttribute("total", materialService.materialListTotal(map));
	 	//model.addAttribute("list", materialService.getMaterialGroupList(map));

        model.addAttribute("total",productService.getProductListTotal(map));
        model.addAttribute("list",productService.getProductList(map));

        model.addAttribute("search", map);
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);
        

        
        return "/product/product";
    }

//    @PostMapping(value = "/getMaterialList"
//            , produces="application/json")
//    @ResponseBody
//    public Map getMaterialList(@RequestBody Map paramMap) {
////    	System.out.println("param" + paramMap);
////    	System.out.println(materialService.getMaterialList(paramMap));
//        return JsonResponse.asSuccess("storeData", materialService.getMaterialList(paramMap));
//    }
    
    @PostMapping(value = "/getProductGroupList"
            , produces="application/json")
    @ResponseBody
    public Map getProductGroupList(@RequestBody Map paramMap) {
//    	System.out.println("param" + paramMap);
//   	System.out.println(materialService.getProductGroupList(paramMap));
        return JsonResponse.asSuccess("storeData", materialService.getProductGroupList(paramMap));
    }
    
    

    @PostMapping(value = "/manageProduct"
            , produces="application/json")
    @ResponseBody
    public Map manageProduct(@RequestBody Map paramMap) {
        System.out.println(paramMap);
        if (paramMap.get("mode").equals("regist")){
            productService.createProduct_V2(paramMap);
        }else if (paramMap.get("mode").equals("edit")){
            productService.updateProduct_V2(paramMap);
        }
//           try{
//           	String a=API.urlConnectInsert("https://oapi"+API.CALLAPI().get("ZONE")+".ecounterp.com/OAPI/V2/InventoryBasic/SaveBasicProduct?SESSION_ID="+API.CALLAPI().get("SESSION_ID"), "POST", paramMap,"ProductList");
//           	System.out.println(a);
//           }catch (Exception e) {
//   		e.printStackTrace();
//   		}

        return JsonResponse.asSuccess();
    }

//    public Map<String, Object> CALLAPI() {
//    Map<String, Object> paramMap2 = new HashMap<String, Object>();
//    paramMap2.put("COM_CODE","81546");
//    String ZONE=null;
//    try{
//        ZONE=API.urlConnect("https://oapi.ecounterp.com/OAPI/V2/Zone", "POST", paramMap2,"Data","ZONE");
//        }catch (Exception e) {
//		e.printStackTrace();
//		}
//    
//  System.out.println(ZONE);
//    paramMap2.put("ZONE",ZONE);
//    paramMap2.put("USER_ID","red-angle");
//    paramMap2.put("API_CERT_KEY","36e049b8f84954170bbc2f798ac66bad74");
//    String SESSION_ID=null;
//    try{
//    	SESSION_ID=API.urlConnect("https://oapi"+ZONE+".ecounterp.com/OAPI/V2/OAPILogin", "POST", paramMap2,"Data","Datas","SESSION_ID");
//    }catch (Exception e) {
//		e.printStackTrace();
//		}
//    System.out.println(SESSION_ID);
//    paramMap2.put("SESSION_ID",SESSION_ID);
//    
//    return paramMap2;
//    }

    @GetMapping(value = "/view", produces="application/json")
    @ResponseBody
    public Map view(@RequestParam(value="PDT_CD", required=false) String PDT_CD) {
        Map map = new HashMap();
        map.put("PDT_CD", Integer.parseInt(PDT_CD));
        return JsonResponse.asSuccess("storeData", productService.getProductInfo(map));
    }

    @RequestMapping(value="/in")
    public String inPage(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_string = "";
        String search_type = "";
        String prod_type = "";
        String sQuery = "";
        int rowsPerPage = 15;
        int currentPage = 1;


        if(param.get("search_string") == null || param.get("search_string").equals("")) {
            search_string = "";
        }else {
            search_string = (String) param.get("search_string");
        }

        if (param.get("search_type") == null || param.get("search_type").equals("")) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
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

        if (param.get("prod_type") == null || param.get("prod_type").equals("")) {
            prod_type = "ALL";
        }else {
            prod_type = (String) param.get("prod_type");
        }

        if (param.get("startDate") == null || param.get("endDate") == null) {
            Calendar cal = Calendar.getInstance();
            String format = "yyyy-MM-dd";
            SimpleDateFormat sdf = new SimpleDateFormat(format);

            //처음 들어왔을 때
            cal.add(cal.DATE, -7);
            startDate = sdf.format(cal.getTime());
            cal.add(cal.DATE, +7);
            endDate = sdf.format(cal.getTime());
        }else {
            startDate = (String) param.get("startDate");
            endDate = (String) param.get("endDate");
        }

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

        sQuery += " A.IO_TYPE = 'IN' AND A.IO_DATE BETWEEN '" + startDate + "' AND '" + endDate + "' ";


        if (search_type.equals("PDT_NAME")) {
            sQuery += " AND B.PDT_NAME LIKE '%" + search_string +"%'";
        }else if(search_type.equals("CODE")) {
            sQuery += " AND B.PDT_CODE LIKE '%" + search_string + "%'" ;
        }else if(search_type.equals("IO_CODE")) {
            sQuery += " AND A.IO_CODE LIKE '%" + search_string + "%'" ;
        }

        if (!prod_type.equals("ALL")) {
            sQuery += " AND C.PROD_TYPE = '" + prod_type +"'";
        }



        Map paramMap = new HashMap();

        paramMap.put("io_type", "IN");
        paramMap.put("search_type",search_type);
        paramMap.put("search_string",search_string);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate",endDate );
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("prod_type", prod_type);
        paramMap.put("sQuery", sQuery);

        Map commonMap = new HashMap();
       /* model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));
        */
        commonMap.put("code_id","PG");
        model.addAttribute("productGubun", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","DR");
        model.addAttribute("defectReason", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("search", paramMap);
        model.addAttribute("total", productService.IoListTotal(paramMap));
        model.addAttribute("list", productService.IoList(paramMap));


        return "/product/in";
    }
    @RequestMapping(value="/move")
    public String movePage(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_string = "";
        String search_type = "";
        String prod_type = "";
        String sQuery = "";
        int rowsPerPage = 15;
        int currentPage = 1;


        if(param.get("search_string") == null || param.get("search_string").equals("")) {
            search_string = "";
        }else {
            search_string = (String) param.get("search_string");
        }

        if (param.get("search_type") == null || param.get("search_type").equals("")) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
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

        if (param.get("prod_type") == null || param.get("prod_type").equals("")) {
            prod_type = "ALL";
        }else {
            prod_type = (String) param.get("prod_type");
        }

        if (param.get("startDate") == null || param.get("endDate") == null) {
            Calendar cal = Calendar.getInstance();
            String format = "yyyy-MM-dd";
            SimpleDateFormat sdf = new SimpleDateFormat(format);

            //처음 들어왔을 때
            cal.add(cal.DATE, -7);
            startDate = sdf.format(cal.getTime());
            cal.add(cal.DATE, +7);
            endDate = sdf.format(cal.getTime());
        }else {
            startDate = (String) param.get("startDate");
            endDate = (String) param.get("endDate");
        }

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

        sQuery += " A.IO_TYPE = 'MOVE' AND A.IO_DATE BETWEEN '" + startDate + "' AND '" + endDate + "' ";


        if (search_type.equals("PDT_NAME")) {
            sQuery += " AND B.PDT_NAME LIKE '%" + search_string +"%'";
        }else if(search_type.equals("CODE")) {
            sQuery += " AND B.PDT_CODE LIKE '%" + search_string + "%'" ;
        }else if(search_type.equals("IO_CODE")) {
            sQuery += " AND A.IO_CODE LIKE '%" + search_string + "%'" ;
        }

        if (!prod_type.equals("ALL")) {
            sQuery += " AND C.PROD_TYPE = '" + prod_type + "'";
        }

        Map paramMap = new HashMap();

        paramMap.put("io_type", "MOVE");
        paramMap.put("search_type",search_type);
        paramMap.put("prod_type ",prod_type);
        paramMap.put("search_string",search_string);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate",endDate );
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);

        Map commonMap = new HashMap();
       /* model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));
        */
        commonMap.put("code_id","PG");
        model.addAttribute("productGubun", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","DR");
        model.addAttribute("defectReason", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("search", paramMap);
        model.addAttribute("total", productService.IoListTotal(paramMap));
        model.addAttribute("list", productService.IoList(paramMap));


        return "/product/move";
    }

    @RequestMapping(value="/ioList")
    public String ioListPage(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_string = "";
        String search_type = "";
        String prod_type  = "";
        String io_type = "";

        String sQuery = "";


        int rowsPerPage = 15;
        int currentPage = 1;


        if(param.get("search_string") == null || param.get("search_string").equals("")) {
            search_string = "";
        }else {
            search_string = (String) param.get("search_string");
        }

        if (param.get("search_type") == null || param.get("search_type").equals("")) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
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

        if (param.get("prod_type") == null || param.get("prod_type").equals("")) {
            prod_type = "ALL";
        }else {
            prod_type = (String) param.get("prod_type");
        }

        if (param.get("io_type") == null || param.get("io_type").equals("")) {
            io_type = "ALL";
        }else {
            io_type = (String) param.get("io_type");
        }


        if (param.get("startDate") == null || param.get("endDate") == null) {
            Calendar cal = Calendar.getInstance();
            String format = "yyyy-MM-dd";
            SimpleDateFormat sdf = new SimpleDateFormat(format);

            //처음 들어왔을 때
            cal.add(cal.DATE, -7);
            startDate = sdf.format(cal.getTime());
            cal.add(cal.DATE, +7);
            endDate = sdf.format(cal.getTime());
        }else {
            startDate = (String) param.get("startDate");
            endDate = (String) param.get("endDate");
        }

        String parameter = "&rowsPerPage="+rowsPerPage+"&io_type="+io_type+"&prod_type="+prod_type+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

        sQuery += " A.IO_DATE BETWEEN '" + startDate + "' AND '" + endDate + "' ";


        if (search_type.equals("PDT_NAME")) {
            sQuery += " AND B.PDT_NAME LIKE '%" + search_string +"%'";
        }else if(search_type.equals("CODE")) {
            sQuery += " AND B.PDT_CODE LIKE '%" + search_string + "%'" ;
        }else if(search_type.equals("IO_CODE")) {
            sQuery += " AND A.IO_CODE LIKE '%" + search_string + "%'" ;
        }

        if (!prod_type.equals("ALL")) {
            sQuery += " AND C.PROD_TYPE = '" + prod_type + "'";
        }

        if (!io_type.equals("ALL")){
            sQuery += " AND A.IO_TYPE = '" + io_type + "'";
        }

        Map paramMap = new HashMap();

        paramMap.put("search_type",search_type);
        paramMap.put("search_string",search_string);
        paramMap.put("prod_type",prod_type);
        paramMap.put("io_type",io_type);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate",endDate );
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);

        Map commonMap = new HashMap();
       /* model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));
        */
        commonMap.put("code_id","PG");
        model.addAttribute("productGubun", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","DR");
        model.addAttribute("defectReason", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("search", paramMap);
        model.addAttribute("total", productService.IoListTotal(paramMap));
        model.addAttribute("list", productService.IoList(paramMap));


        return "/product/ioList";
    }


    @RequestMapping(value="/popProductList")
    public String popProductList(Model model) {
        Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
//        model.addAttribute("CategoryList", materialService.getProductCategoryList(paramMap));
        return "empty:/popProductList2";
    }


    @PostMapping(value = "/registerIn", produces="application/json")
    @ResponseBody
    public Map registerIn(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Insert_I1_Str(paramMap);

        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/registerOut", produces="application/json")
    @ResponseBody
    public Map registerOut(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Insert_I2_Str(paramMap);

        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/registerMove", produces="application/json")
    @ResponseBody
    public Map registerMove(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Insert_I3_Str(paramMap);

        return JsonResponse.asSuccess();
    }


    @PostMapping(value = "/updateIn", produces="application/json")
    @ResponseBody
    public Map updateIn(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Update_U1_Str(paramMap);

        return JsonResponse.asSuccess();

    }
    @PostMapping(value = "/updateOut", produces="application/json")
    @ResponseBody
    public Map updateOut(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Update_U2_Str(paramMap);

        return JsonResponse.asSuccess();
    }
    @PostMapping(value = "/updateMove", produces="application/json")
    @ResponseBody
    public Map updateMove(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Update_U3_Str(paramMap);

        return JsonResponse.asSuccess();
    }


    @PostMapping(value = "/getIODetailInfo")
    @ResponseBody
    public Map getIODetailInfo(@RequestParam(value="io_seq", required=false) String io_seq) {

        Map map = new HashMap();


        map.put("io_seq", Integer.parseInt(io_seq));

        return JsonResponse.asSuccess("storeData", productService.getIODetailInfo(map));
    }


    @PostMapping(value = "/getOutMaterialInfo")
    @ResponseBody
    public Map getOutMaterialInfo(@RequestParam(value="M_OUT_SEQ", required=false) String M_OUT_SEQ) {

        Map map = new HashMap();


        map.put("M_OUT_SEQ", Integer.parseInt(M_OUT_SEQ));

        return JsonResponse.asSuccess("storeData", productService.OutMaterialInfo(map));
    }

    @RequestMapping(value="/out")
    public String outPage(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_string = "";
        String search_type = "";
        String prod_type = "";
        String sQuery = "";
        int rowsPerPage = 15;
        int currentPage = 1;


        if(param.get("search_string") == null || param.get("search_string").equals("")) {
            search_string = "";
        }else {
            search_string = (String) param.get("search_string");
        }

        if (param.get("search_type") == null || param.get("search_type").equals("")) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
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

        if (param.get("prod_type") == null || param.get("prod_type").equals("")) {
            prod_type = "ALL";
        }else {
            prod_type = (String) param.get("prod_type");
        }

        if (param.get("startDate") == null || param.get("endDate") == null) {
            Calendar cal = Calendar.getInstance();
            String format = "yyyy-MM-dd";
            SimpleDateFormat sdf = new SimpleDateFormat(format);

            //처음 들어왔을 때
            cal.add(cal.DATE, -7);
            startDate = sdf.format(cal.getTime());
            cal.add(cal.DATE, +7);
            endDate = sdf.format(cal.getTime());
        }else {
            startDate = (String) param.get("startDate");
            endDate = (String) param.get("endDate");
        }

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

        sQuery += " A.IO_TYPE = 'OUT' AND A.IO_DATE BETWEEN '" + startDate + "' AND '" + endDate + "' ";


        if (search_type.equals("PDT_NAME")) {
            sQuery += " AND B.PDT_NAME LIKE '%" + search_string +"%'";
        }else if(search_type.equals("CODE")) {
            sQuery += " AND B.PDT_CODE LIKE '%" + search_string + "%'" ;
        }else if(search_type.equals("IO_CODE")) {
            sQuery += " AND A.IO_CODE LIKE '%" + search_string + "%'" ;
        }


        if (!prod_type.equals("ALL")) {
            sQuery += " AND C.PROD_TYPE = '" + prod_type + "'";
        }


        Map paramMap = new HashMap();

        paramMap.put("io_type", "OUT");
        paramMap.put("prod_type", prod_type);
        paramMap.put("search_type",search_type);
        paramMap.put("search_string",search_string);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate",endDate );
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);

        Map commonMap = new HashMap();
       /* model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));
        */
        commonMap.put("code_id","PG");
        model.addAttribute("productGubun", comCodeService.comCodeDetailSelectList(commonMap));


        commonMap.put("code_id","DR");
        model.addAttribute("defectReason", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("search", paramMap);
        model.addAttribute("total", productService.IoListTotal(paramMap));
        model.addAttribute("list", productService.IoList(paramMap));


        return "/product/out";
    }


    @RequestMapping(value="/catagoryList")
    public String catagoryList(Model model) {
        model.addAttribute("depth1", productService.getProductCategory_Depth1_List());
        return "/product/categoryList";
    }

    @GetMapping(value = "/depthInfo")
    @ResponseBody
    public Map depthInfo(@RequestParam(value="cat_cd", required=false) String cat_cd) {

        Map map = new HashMap();

        map.put("cat_cd", cat_cd);

        return JsonResponse.asSuccess("storeData", productService.depthInfo(map));
    }
    @GetMapping(value = "/viewDepth")
    @ResponseBody
    public Map viewDepth(@RequestParam(value="cat_cd", required=false) String cat_cd) {
        Map map = new HashMap();
        map.put("cat_cd", cat_cd);
        return JsonResponse.asSuccess("storeData", productService.viewDepth(map));
    }


    @PostMapping(value = "/createCategory"
            , produces="application/json")
    @ResponseBody
    public Map createCategory(@RequestParam Map paramMap) {
        String result = productService.createCategory(paramMap);
        return JsonResponse.asSuccess("msg",result);
    }

    @PostMapping(value = "/updateCategory", produces="application/json")
    @ResponseBody
    public Map updateCategory(@RequestParam Map paramMap) {
        String result = productService.updateCategory(paramMap);
        return JsonResponse.asSuccess("msg",result);
    }

    @RequestMapping(value="/stockByProduct")
    public String stockByProduct(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_string = "";
        String search_type = "";
        String prod_type  = "";
        String io_type = "";

        String sQuery = "";


        int rowsPerPage = 15;
        int currentPage = 1;


        if(param.get("search_string") == null || param.get("search_string").equals("")) {
            search_string = "";
        }else {
            search_string = (String) param.get("search_string");
        }

        if (param.get("search_type") == null || param.get("search_type").equals("")) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
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

        if (param.get("prod_type") == null || param.get("prod_type").equals("")) {
            prod_type = "ALL";
        }else {
            prod_type = (String) param.get("prod_type");
        }

        if (param.get("io_type") == null || param.get("io_type").equals("")) {
            io_type = "ALL";
        }else {
            io_type = (String) param.get("io_type");
        }


        if (param.get("startDate") == null || param.get("endDate") == null) {
            Calendar cal = Calendar.getInstance();
            String format = "yyyy-MM-dd";
            SimpleDateFormat sdf = new SimpleDateFormat(format);

            //처음 들어왔을 때
            cal.add(cal.DATE, -7);
            startDate = sdf.format(cal.getTime());
            cal.add(cal.DATE, +7);
            endDate = sdf.format(cal.getTime());
        }else {
            startDate = (String) param.get("startDate");
            endDate = (String) param.get("endDate");
        }

        String parameter = "&rowsPerPage="+rowsPerPage+"&io_type="+io_type+"&prod_type="+prod_type+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

        sQuery += " A.IO_DATE BETWEEN '" + startDate + "' AND '" + endDate + "' ";


        if (search_type.equals("PDT_NAME")) {
            sQuery += " AND B.PDT_NAME LIKE '%" + search_string +"%'";
        }else if(search_type.equals("CODE")) {
            sQuery += " AND B.PDT_CODE LIKE '%" + search_string + "%'" ;
        }else if(search_type.equals("IO_CODE")) {
            sQuery += " AND A.IO_CODE LIKE '%" + search_string + "%'" ;
        }

        if (!prod_type.equals("ALL")) {
            sQuery += " AND C.PROD_TYPE = '" + prod_type + "'";
        }

        if (!io_type.equals("ALL")){
            sQuery += " AND A.IO_TYPE = '" + io_type + "'";
        }

        Map paramMap = new HashMap();

        paramMap.put("search_type",search_type);
        paramMap.put("search_string",search_string);
        paramMap.put("prod_type",prod_type);
        paramMap.put("io_type",io_type);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate",endDate );
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);

        Map commonMap = new HashMap();
       /* model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));
        */
        commonMap.put("code_id","PG");
        model.addAttribute("productGubun", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","DR");
        model.addAttribute("defectReason", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("search", paramMap);
        model.addAttribute("total", productService.IoListTotal(paramMap));
        model.addAttribute("list", productService.IoList(paramMap));


        return "/product/stockByProduct";
    }
    @RequestMapping(value="/stockByStorage")
    public String stockByStorage(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_string = "";
        String search_type = "";
        String prod_type  = "";
        String io_type = "";

        String sQuery = "";


        int rowsPerPage = 15;
        int currentPage = 1;


        if(param.get("search_string") == null || param.get("search_string").equals("")) {
            search_string = "";
        }else {
            search_string = (String) param.get("search_string");
        }

        if (param.get("search_type") == null || param.get("search_type").equals("")) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
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

        if (param.get("prod_type") == null || param.get("prod_type").equals("")) {
            prod_type = "ALL";
        }else {
            prod_type = (String) param.get("prod_type");
        }

        if (param.get("io_type") == null || param.get("io_type").equals("")) {
            io_type = "ALL";
        }else {
            io_type = (String) param.get("io_type");
        }


        if (param.get("startDate") == null || param.get("endDate") == null) {
            Calendar cal = Calendar.getInstance();
            String format = "yyyy-MM-dd";
            SimpleDateFormat sdf = new SimpleDateFormat(format);

            //처음 들어왔을 때
            cal.add(cal.DATE, -7);
            startDate = sdf.format(cal.getTime());
            cal.add(cal.DATE, +7);
            endDate = sdf.format(cal.getTime());
        }else {
            startDate = (String) param.get("startDate");
            endDate = (String) param.get("endDate");
        }

        String parameter = "&rowsPerPage="+rowsPerPage+"&io_type="+io_type+"&prod_type="+prod_type+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

        sQuery += " A.IO_DATE BETWEEN '" + startDate + "' AND '" + endDate + "' ";


        if (search_type.equals("PDT_NAME")) {
            sQuery += " AND B.PDT_NAME LIKE '%" + search_string +"%'";
        }else if(search_type.equals("CODE")) {
            sQuery += " AND B.PDT_CODE LIKE '%" + search_string + "%'" ;
        }else if(search_type.equals("IO_CODE")) {
            sQuery += " AND A.IO_CODE LIKE '%" + search_string + "%'" ;
        }

        if (!prod_type.equals("ALL")) {
            sQuery += " AND C.PROD_TYPE = '" + prod_type + "'";
        }

        if (!io_type.equals("ALL")){
            sQuery += " AND A.IO_TYPE = '" + io_type + "'";
        }

        Map paramMap = new HashMap();

        paramMap.put("search_type",search_type);
        paramMap.put("search_string",search_string);
        paramMap.put("prod_type",prod_type);
        paramMap.put("io_type",io_type);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate",endDate );
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);

        Map commonMap = new HashMap();
       /* model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));
        */
        commonMap.put("code_id","PG");
        model.addAttribute("productGubun", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","DR");
        model.addAttribute("defectReason", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("search", paramMap);
        model.addAttribute("total", productService.IoListTotal(paramMap));
        model.addAttribute("list", productService.IoList(paramMap));


        return "/product/stockByStorage";
    }

}
