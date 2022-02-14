package mes.app.controller.material;

import mes.app.controller.supervisor.API;
import mes.app.service.code.CodeService;
import mes.app.service.code.ComCodeService;
import mes.app.service.material.MaterialService;
import mes.app.service.partlist.PartlistService;
import mes.app.service.product.ProductService;
import mes.app.service.productionLine.ProductionLineService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.common.service.APISend;
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
@RequestMapping(value = "/material")
public class MaterialController {

    @Autowired
    private MaterialService materialService;

    @Autowired
    private ComCodeService comCodeService;

    @Autowired
    private ProductService productService;


    @Autowired
    private ProductionLineService productionLineService;

    @Autowired
    private CodeService codeService;


    @RequestMapping(value = "/material")
    public String materialPage(Model model, @RequestParam Map param) {

        String search_type = "";
        String search_string = "";
        String USE_YN ="";
        String CAT_CD ="";
        String DIVISION_SEQ = "";
        String PROD_TYPE ="";

        int rowsPerPage = 0;
        int currentPage = 1;

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

        if (param.get("search_type") == null  || param.get("search_type").equals("")) {
            search_type = "ALL";
        }else {
            search_type = (String) param.get("search_type");
        }

        if(param.get("search_string") == null  || param.get("search_string").equals("")) {
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
        } else{
            DIVISION_SEQ = (String) param.get("DIVISION_SEQ");
        }

        if (param.get("PROD_TYPE") == null || param.get("PROD_TYPE").equals("")){
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
            sQuery += "AND A.PROD_TYPE IN ('PG001','PG002','PG004')";
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

        model.addAttribute("total",productService.getProductListTotal(map));
        model.addAttribute("list",productService.getProductList(map));

        model.addAttribute("search", map);
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        return "/material/material";
    }

    @RequestMapping(value = "/bom")
    public String bomPage(Model model, @RequestParam Map param) {
        String search_string = "";
        String search_type = "";
        int rowsPerPage = 0;
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


        String parameter = "&rowsPerPage=" + rowsPerPage + "&search_type=" + search_type +"&search_string="+search_string;
        String sQuery = "";

        sQuery += "1=1";
/*

        if (search_type.equals("CODE")) {
            sQuery += " AND D.PDT_CD like '%" + search_string +"%'";
        }else if(search_type.equals("PDT_NAME")) {
            sQuery += " AND D.PDT_NAME like '%" + search_string + "%'" ;
        }else if(search_type.equals("M_CODE")) {
            sQuery += " AND D.M_CD like '%" + search_string + "%'" ;
        }else if(search_type.equals("MTR_NAME")) {
            sQuery += " AND D.MTR_NAME like '%" + search_string + "%'" ;
        }else if(search_type.equals("ALL")){
            sQuery += " AND concat(D.PDT_CD,'|',D.PDT_NAME,'|',D.M_CD,'|',D.MTR_NAME) like concat('%','"+ search_string +"','%')";
        }
*/


        Map paramMap = new HashMap();

        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);
        paramMap.put("search_type",search_type);

        model.addAttribute("parameter", parameter);
        model.addAttribute("search", paramMap);

        model.addAttribute("total", materialService.getBomListTotal(paramMap));
        model.addAttribute("list", materialService.getBomList(paramMap));

        return "/material/bom";
    }

    @GetMapping(value = "/getBomDetail")
    @ResponseBody
    public Map bomDetail(@RequestParam(value = "PDT_CD", required = false) int PDT_CD) {

        Map map = new HashMap();
        map.put("PDT_CD", PDT_CD);
        return JsonResponse.asSuccess("storeData", materialService.getBomDetail(map));
    }
    @GetMapping(value = "/getBomDetail2")
    @ResponseBody
    public Map bomDetail2(@RequestParam(value = "PDT_CD", required = false) int PDT_CD, @RequestParam(value = "BOM_VERSION", required = false) String BOM_VERSION) {
        Map map = new HashMap();
        map.put("PDT_CD", PDT_CD);
        map.put("BOM_VERSION", BOM_VERSION);
        return JsonResponse.asSuccess("storeData", materialService.getBomDetail2(map));
    }


    @GetMapping(value = "/getBomVersionList")
    @ResponseBody
    public Map bomVersionList(@RequestParam(value = "PDT_CD", required = false) int PDT_CD) {

        Map map = new HashMap();
        map.put("PDT_CD", PDT_CD);
        return JsonResponse.asSuccess("storeData", materialService.getBomVersionList(map));
    }

    @RequestMapping(value = "/in")
    public String inPage(Model model, @RequestParam Map param) {

        String startDate = "";
        String endDate = "";
        String search_string = "";
        String search_type = "";
        int search_line = 0;
        int search_storage = 0;

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
        if (param.get("search_line") == null || param.get("search_line").equals("")) {
            search_line = 0;
        }else {
            search_line = Integer.parseInt((String) param.get("search_line"));
        }
        if (param.get("search_storage") == null || param.get("search_storage").equals("")) {
            search_storage = 0;
        }else {
            search_storage = Integer.parseInt((String) param.get("search_storage"));
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

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&search_line="
                +search_line+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

        sQuery += " A.IO_TYPE = 'IN' AND A.IO_PROD_TYPE = 'M' AND A.IN_DATE BETWEEN '" + startDate + "' AND '" + endDate + "' ";

        if (search_storage != 0){
            sQuery += " AND B.STORAGE = '" + search_storage + "' ";
        }

        if (search_type.equals("PDT_NAME")) {
            sQuery += " AND B.PDT_NAME LIKE '%" + search_string +"%'";
        }else if(search_type.equals("CODE")) {
            sQuery += " AND A.PDT_CODE ='" + search_string + "%'" ;
        }else if(search_type.equals("CUST_NAME")) {
            sQuery += " AND F.CUST_NAME LIKE '%" + search_string +"%'";
        }

        Map paramMap = new HashMap();

        paramMap.put("io_type", "IN");
        paramMap.put("io_prod_type", "M");
        paramMap.put("search_type",search_type);
        paramMap.put("search_line",search_line);
        paramMap.put("search_storage",search_storage);
        paramMap.put("search_string",search_string);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate",endDate );
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);

        Map commonMap = new HashMap();
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));

        model.addAttribute("search", paramMap);
        model.addAttribute("total", productService.IoListTotal2(paramMap));
        model.addAttribute("list", productService.IoList2(paramMap));

        return "/material/in";
    }
    @PostMapping(value = "/getIODetailInfo")
    @ResponseBody
    public Map getIODetailInfo(@RequestParam(value="io_seq", required=false) String io_seq) {

        Map map = new HashMap();


        map.put("io_seq", Integer.parseInt(io_seq));

        return JsonResponse.asSuccess("storeData", productService.getIODetailInfo2(map));
    }


    @RequestMapping(value = "/defect")
    public String defectPage(Model model) {


        return "/material/defect";
    }

    @RequestMapping(value = "/stock")
    public String stockPage(Model model) {


        return "/material/stock";
    }

    @RequestMapping(value = "/stockstorage")
    public String stockstoragePage(Model model) {


        return "/material/stockstorage";
    }

    @RequestMapping(value = "/stockmaterial")
    public String stockmaterialPage(Model model) {


        return "/material/stockmaterial";
    }


    @RequestMapping(value = "/out")
    public String outPage(Model model, @RequestParam Map param) {
        String startDate = "";
        String endDate = "";
        String search_string = "";
        String search_type = "";
        int search_line = 0;
        int search_storage = 0;

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
        if (param.get("search_line") == null || param.get("search_line").equals("")) {
            search_line = 0;
        }else {
            search_line = Integer.parseInt((String) param.get("search_line"));
        }
        if (param.get("search_storage") == null || param.get("search_storage").equals("")) {
            search_storage = 0;
        }else {
            search_storage = Integer.parseInt((String) param.get("search_storage"));
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

        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&search_line="
                +search_line+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;

        model.addAttribute("parameter", parameter);

        sQuery += " A.IO_TYPE = 'OUT' AND A.IO_PROD_TYPE = 'M' AND A.OUT_DATE BETWEEN '" + startDate + "' AND '" + endDate + "' ";

        if (search_line != 0){
            sQuery += " AND A.PRODUCT_LINE LIKE '%" + search_line + "%'";
        }
        if (search_storage != 0){
            sQuery += " AND B.STORAGE = '" + search_storage + "' ";
        }

        if (search_type.equals("PDT_NAME")) {
            sQuery += " AND B.PDT_NAME LIKE '%" + search_string +"%'";
        }else if(search_type.equals("CODE")) {
            sQuery += " AND A.PDT_CODE ='" + search_string + "%'" ;
        }

        Map paramMap = new HashMap();

        paramMap.put("search_type",search_type);
        paramMap.put("search_line",search_line);
        paramMap.put("search_storage",search_storage);
        paramMap.put("search_string",search_string);
        paramMap.put("startDate", startDate);
        paramMap.put("endDate",endDate );
        paramMap.put("currentPage", currentPage);
        paramMap.put("rowsPerPage", rowsPerPage);
        paramMap.put("sQuery", sQuery);

        Map commonMap = new HashMap();
        model.addAttribute("depth1", productionLineService.getProduction_Line_Depth1_List());
        model.addAttribute("storageDepth1", codeService.cate1Sql(commonMap));

        model.addAttribute("search", paramMap);
        model.addAttribute("total", productService.IoListTotal(paramMap));
        model.addAttribute("list", productService.IoList(paramMap));
        return "/material/out";
    }


    @PostMapping(value = "/getMaterialList"
            , produces = "application/json")
    @ResponseBody
    public Map getMaterialList(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.getMaterialList(paramMap));
    }

    @PostMapping(value = "/getMaterialGroupList"
            , produces = "application/json")
    @ResponseBody
    public Map getMaterialGroupList(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.getMaterialGroupList(paramMap));
    }

    @PostMapping(value = "/getMaterialStockList"
            , produces = "application/json")
    @ResponseBody
    public Map getMaterialStockList(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.getMaterialStockList(paramMap));
    }


    @GetMapping(value = "/selectMaterial"
            , produces = "application/json")
    @ResponseBody
    public Map selectMaterial(@RequestParam(value = "PDT_CD", required = false) String PDT_CD) {

        Map map = new HashMap();
        map.put("PDT_CD", Integer.parseInt(PDT_CD));

        return JsonResponse.asSuccess("storeData", materialService.getRowMaterial(map));
    }


    @PostMapping(value = "/updateMaterial"
            , produces = "application/json")
    @ResponseBody
    public Map updateMaterial(@RequestBody Map paramMap) {
        materialService.updateMaterial(paramMap);
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/createMaterial"
            , produces = "application/json")
    @ResponseBody
    public Map createMaterial(@RequestBody Map paramMap) {
        materialService.createMaterial(paramMap);
        System.out.println(paramMap);
         try{
            // APISend.postProduct();
           //	String a= API.urlConnectInsert("https://oapi"+API.CALLAPI().get("ZONE")+".ecount.com/OAPI/V2/InventoryBasic/GetBasicProductList?SESSION_ID="+API.CALLAPI().get("SESSION_ID"), "POST", paramMap,"ProductList");
          // 	System.out.println(a);
         }catch (Exception e) {
  		e.printStackTrace();
   		}

        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/updateIn"
            , produces="application/json")
    @ResponseBody
    public Map updateIn(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Update_U2_Str(paramMap);

        return JsonResponse.asSuccess();

    }
    @PostMapping(value = "/updateOut"
            , produces="application/json")
    @ResponseBody
    public Map updateOut(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Update_U2_Str(paramMap);

        return JsonResponse.asSuccess();

    }


    @PostMapping(value = "/registerIn", produces="application/json")
    @ResponseBody
    public Map registerIn(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Insert_I2_Str(paramMap);

        return JsonResponse.asSuccess();
    }
    @PostMapping(value = "/registerOut", produces="application/json")
    @ResponseBody
    public Map registerOut(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {

        productService.IO_Insert_I4_Str(paramMap);

        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/getInList"
            , produces = "application/json")
    @ResponseBody
    public Map getInList(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.getInList(paramMap));
    }


    @PostMapping(value = "/getInMaterialInfo")
    @ResponseBody
    public Map getOrderInfo(@RequestParam(value = "M_IN_SEQ", required = false) String M_IN_SEQ) {

        Map map = new HashMap();


        map.put("M_IN_SEQ", Integer.parseInt(M_IN_SEQ));

        return JsonResponse.asSuccess("storeData", materialService.InMaterialInfo(map));
    }

    @PostMapping(value = "/selectInBody"
            , produces = "application/json")
    @ResponseBody
    public Map selectInBody(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.selectInBody(paramMap));
    }

    @PostMapping(value = "/getDefectList"
            , produces = "application/json")
    @ResponseBody
    public Map getDefectList(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.getDefectList(paramMap));
    }

    @PostMapping(value = "/selectDefect"
            , produces = "application/json")
    @ResponseBody
    public Map selectDefect(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.selectDefect(paramMap));
    }

    /*
     * @PostMapping(value = "/StorageSelectOption2" , produces="application/json")
     *
     * @ResponseBody public Map StorageSelectOption2(@RequestBody Map paramMap) {
     *
     * return JsonResponse.asSuccess("storeData",
     * materialService.StorageSelectOption2(paramMap)); }
     *
     * @PostMapping(value = "/StorageSelectOption3" , produces="application/json")
     *
     * @ResponseBody public Map StorageSelectOption3(@RequestBody Map paramMap) {
     *
     * return JsonResponse.asSuccess("storeData",
     * materialService.StorageSelectOption3(paramMap)); }
     */

    @PostMapping(value = "/updateDefect"
            , produces = "application/json")
    @ResponseBody
    public Map updateDefect(@RequestBody Map paramMap) {
        materialService.updateDefect(paramMap);
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/selectMaterialStock"
            , produces = "application/json")
    @ResponseBody
    public Map selectMaterialStock(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.getRowMaterialStock(paramMap));
    }

    @PostMapping(value = "/getMaterialStockStorageList"
            , produces = "application/json")
    @ResponseBody
    public Map getMaterialStockStorageList(@RequestBody Map paramMap) {

        return JsonResponse.asSuccess("storeData", materialService.getMaterialStockStorageList(paramMap));
    }

    @PostMapping(value = "/selectMaterialStockStorage"
            , produces = "application/json")
    @ResponseBody
    public List<Map<String, String>> selectMaterialStockStorage(@RequestBody Map paramMap) {

        return materialService.selectMaterialStockStorage(paramMap);
    }

    @PostMapping(value = "/updateMaterialStock"
            , produces = "application/json")
    @ResponseBody
    public Map updateMaterialStock(@RequestBody Map paramMap) {
        materialService.updateMaterialStock(paramMap);
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/createMaterialStock"
            , produces = "application/json")
    @ResponseBody
    public Map createMaterialStock(@RequestBody Map paramMap) {
        materialService.createMaterialStock(paramMap);
        return JsonResponse.asSuccess();
    }

    @PostMapping(value = "/StorageList"
            , produces = "application/json")
    @ResponseBody
    public Map StorageList(@RequestBody Map paramMap) {
        System.out.println(paramMap);
        return JsonResponse.asSuccess("storeData", materialService.StorageSelectOption1(paramMap));
    }

    @PostMapping(value = "/ZoneList"
            , produces = "application/json")
    @ResponseBody
    public Map ZoneList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", materialService.StorageSelectOption2(paramMap));
    }


    @PostMapping(value = "/createBOM", produces="application/json")
    @ResponseBody
    public Map createBOM(@RequestBody List<Map> paramMap) {
        String message = "";
        for(int i = 0; i < paramMap.size(); i++) {
            //System.out.println(paramMap.get(i));
            paramMap.get(i).put("sort", i);
            message =  materialService.createBOM(paramMap.get(i));
            if (!message.equals("OK")){
                break;
            }
        }

        return JsonResponse.asSuccess("msg",message);
    }

    @PostMapping(value = "/updateBOM", produces="application/json")
    @ResponseBody
    public Map updateBOM(@RequestBody List<Map> paramMap) {
        String message = "";
        for(int i = 0; i < paramMap.size(); i++) {
            //System.out.println(paramMap.get(i));
            paramMap.get(i).put("sort", i);
            message =  materialService.updateBOM(paramMap.get(i));
            if (!message.equals("OK")){
                break;
            }
        }

        return JsonResponse.asSuccess("msg",message);
    }


}
