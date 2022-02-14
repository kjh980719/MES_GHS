package mes.app.controller.code;

import mes.app.code.utill.XssFilter;
import mes.app.service.code.CodeService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;




@Controller
@RequestMapping(value="/code")
public class CodeController extends CodeSessionController {

    @Autowired
    private CodeService codeService;



    @RequestMapping(value="/code")
    public String CodePage(Model model) {
        return "/code/code";
    }
    
    @RequestMapping(value="/storage")
    public String StoragePage(Model model, HttpServletRequest req, @RequestParam Map param) {
    	Map map = new HashMap();
		
     
    	String STOR_LOOP = req.getParameter("STOR_LOOP");
    	String mode = "entry";
    	String btnName = "추가";
    	String STOR_UPPER = null;
    	String STOR_DEPTH = "1";
    	String readonly="";
    	String add2="none";
    	String add3="none";

try {

	if (StringUtils.isEmpty(STOR_LOOP)) {
		STOR_LOOP = "1";
		
	}
	int loop_cnt = Integer.parseInt(STOR_LOOP); // STOR_LOOP
	map.put("STOR_LOOP", STOR_LOOP);
	map.put("mode", mode);
	map.put("STOR_UPPER", STOR_UPPER);
	map.put("STOR_LOOP", STOR_LOOP);
	if (loop_cnt > 0) { // 1Depth		
		List<Map<String,String>> cate1 = codeService.cate1Sql(map);								
		
		if (cate1.size() != 0) {
			STOR_UPPER = cate1.get(0).get(STOR_UPPER);
			STOR_DEPTH = cate1.get(0).get(STOR_DEPTH);
			map.put("STOR_UPPER", STOR_UPPER);
			map.put("STOR_DEPTH", STOR_DEPTH);
		}
		
		model.addAttribute("cate1", cate1);
	}
	if (loop_cnt > 1) { // 2Depth				
		String STOR2_DEPTH = req.getParameter("STOR2_DEPTH");
		String STOR2_UPPER = req.getParameter("STOR2_UPPER");
		add2="";
		
		if(STOR2_DEPTH=="") {
			STOR2_DEPTH="0";
		}		
		map.put("STOR_DEPTH",STOR2_DEPTH);
		map.put("STOR_NEXT_DEPTH",Integer.parseInt(STOR2_DEPTH) + 1);
		System.out.println(STOR2_DEPTH);
		map.put("STOR_UPPER",STOR2_UPPER);
		List<Map<String,String>> cate2 = codeService.cate2Sql(map);
		System.out.println(map);
		System.out.println(cate2);
		
		if (cate2.size() != 0) {
			STOR_UPPER = cate2.get(0).get(STOR_UPPER);
			STOR_DEPTH = cate2.get(0).get(STOR_DEPTH);					
		} else {
			STOR_UPPER = STOR2_UPPER;
			STOR_DEPTH = STOR2_DEPTH;
		}
		
		model.addAttribute("STOR2_DEPTH", STOR2_DEPTH);
		model.addAttribute("STOR2_UPPER", STOR2_UPPER);				
		model.addAttribute("cate2", cate2);
		model.addAttribute("add2", add2);
		model.addAttribute("add3", add3);
	}
	if (loop_cnt > 2) {
		String STOR3_DEPTH = req.getParameter("STOR3_DEPTH");
		String STOR3_UPPER = req.getParameter("STOR3_UPPER");	
		add2="";
		add3="";
		
		map.put("STOR_DEPTH",STOR3_DEPTH);
		map.put("STOR_NEXT_DEPTH",(Integer.parseInt(STOR3_DEPTH) + 1));
		map.put("STOR_UPPER",STOR3_UPPER);
		
		List<Map<String,String>> cate3 = codeService.cate2Sql(map);
		
		if (cate3.size() != 0) {
			STOR_UPPER = cate3.get(0).get(STOR_UPPER);
			STOR_DEPTH = cate3.get(0).get(STOR_DEPTH);					
		} else {
			STOR_UPPER = STOR3_UPPER;
			STOR_DEPTH = STOR3_DEPTH;
		}
		
		model.addAttribute("STOR3_DEPTH", STOR3_DEPTH);
		model.addAttribute("STOR3_UPPER", STOR3_UPPER);
		model.addAttribute("cate3", cate3);
		model.addAttribute("add2", add2);
		model.addAttribute("add3", add3);
	}
	if (loop_cnt > 3) {
		String STOR4_DEPTH = req.getParameter("STOR4_DEPTH");
		String STOR4_UPPER = req.getParameter("STOR4_UPPER");				
		
		map.put("STOR_DEPTH",Integer.parseInt(STOR4_DEPTH));
		map.put("STOR_NEXT_DEPTH",(Integer.parseInt(STOR4_DEPTH) + 1));
		map.put("STOR_UPPER",STOR4_UPPER);
		
		List<Map<String,String>> cate4 = codeService.cate2Sql(map);
		
		if (cate4.size() != 0) {
			STOR_UPPER = cate4.get(0).get(STOR_UPPER);
			STOR_DEPTH = cate4.get(0).get(STOR_DEPTH);				
		} else {
			STOR_UPPER = STOR4_UPPER;
			STOR_DEPTH = STOR4_DEPTH;
		}
		
		model.addAttribute("STOR4_DEPTH", STOR4_DEPTH);
		model.addAttribute("STOR4_UPPER", STOR4_UPPER);
		model.addAttribute("cate4", cate4);
	}
	
	String STOR_SEQ = req.getParameter("STOR_SEQ");			
	System.err.println("STOR_SEQ : " + STOR_SEQ);
	if (!StringUtils.isEmpty(STOR_SEQ)) {
		mode = "edit";
		btnName = "수정";
		readonly= "readonly";
		System.out.println(STOR_SEQ);
		System.out.println(readonly);
		
		Map<String, String> cateEdit = codeService.cupSql(STOR_SEQ); // 카테고리 수정
		
		model.addAttribute("STOR_SEQ", STOR_SEQ);
		model.addAttribute("edit_name", cateEdit.get("STOR_NAME"));
		model.addAttribute("edit_sort", cateEdit.get("STOR_SORT"));	
		model.addAttribute("edit_cd", cateEdit.get("STOR_CD"));
		
	}
			
	
	System.err.println("map : " + map);
	System.err.println("mode : " + mode);
	model.addAttribute("STOR_LOOP", loop_cnt);
	model.addAttribute("STOR_UPPER", STOR_UPPER);
	model.addAttribute("STOR_DEPTH", STOR_DEPTH);
	model.addAttribute("mode", mode);
	model.addAttribute("btnName", btnName);
	model.addAttribute("read", readonly);
} catch (Exception e) {
	e.printStackTrace();
}
	
	
        return "/code/storage";
    }
    
    
	/*
	 * @PostMapping(value = "/getStorageInfo" , produces="application/json")
	 * 
	 * @ResponseBody public Map getStorageInfo(@RequestBody Map paramMap) {
	 * 
	 * return JsonResponse.asSuccess("storeData",
	 * codeService.getStorageInfo(paramMap)); }
	 */
    
    @PostMapping(value = "/createStorage"
            , produces="application/json")
    @ResponseBody
    public Map createStorage(@RequestBody Map paramMap) {

         codeService.createStorage(paramMap);
         return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/updateStorage"
            , produces="application/json")
    @ResponseBody
    public Map updateStorage(@RequestBody Map paramMap) {

         codeService.updateStorage(paramMap);
         return JsonResponse.asSuccess();
    }
    
	/*
	 * @PostMapping(value = "/storageCategoryList" , produces="application/json")
	 * 
	 * @ResponseBody public Map StorageCategoryList(@RequestBody Map paramMap) {
	 * 
	 * return JsonResponse.asSuccess("storeData",
	 * codeService.StorageCategoryList(paramMap)); }
	 */
    @RequestMapping(value="/StorageList")
    public String storageSearch(Model model, HttpServletRequest req, @RequestParam Map param) {
    String STOR_DEPTH = "";
    String search_string = "";

    
    if (param.get("order_status") == null) {
   	 STOR_DEPTH = "1";
    }else {
   	 STOR_DEPTH = (String) param.get("order_status");
    }
    if(param.get("search_string") == null) {
    	search_string = "";
    }else {
    	search_string = (String) param.get("search_string");
    }
    
  
    String parameter = "&STOR_DEPTH="+STOR_DEPTH+"&search_string="+search_string;
    String sQuery = "";
    
		/*
		 * if { sQuery += "(A.STOR_NM = '"+ search_string +"' or A.STOR_CD like '%" +
		 * search_string + "%')"; }
		 */
    
    model.addAttribute("parameter", parameter);
    
    UserInfo info = Util.getUserInfo();       
		Map map = new HashMap();
		map.put("sQuery", sQuery);
		map.put("STOR_DEPTH",STOR_DEPTH);
    
    

	String list_empty_title = null;
	
	try{	
		

		String i ="1";
		/*if (i="1") { */// 카테고리로 검색
			String cate1 = req.getParameter("cate1");
			String cate2 = req.getParameter("cate2");
			String cate3 = req.getParameter("cate3");
			
			list_empty_title = "등록된 카테고리가 없습니다.";
			List<Map<String,String>> catelist1 = codeService.selectCate(map);								
			model.addAttribute("catelist1", catelist1);
			model.addAttribute("cList", catelist1);
											
			if (!StringUtils.isEmpty(cate1)) {
				List<Map<String,String>> catelist2 = codeService.selectCate(map);
														
				model.addAttribute("c1_code", cate1);
				model.addAttribute("catelist2", catelist2);
				model.addAttribute("cList", catelist2);
			}
			if (!StringUtils.isEmpty(cate2)) {
				List<Map<String,String>> catelist3 = codeService.selectCate(map);
														
				model.addAttribute("c2_code", cate2);
				model.addAttribute("catelist3", catelist3);
				model.addAttribute("cList", catelist3);
			}
			if (!StringUtils.isEmpty(cate3)) {
				List<Map<String,String>> catelist4 = codeService.selectCate(map);
				List<Map<String,String>> cate3depth = codeService.selectDepth3(map); // 3Depth 자기 자신 보여주기
														
				model.addAttribute("c3_code", cate3);
				model.addAttribute("catelist4", catelist4);
				// model.addAttribute("cList", catelist4);
				model.addAttribute("cList", cate3depth); // 3Depth 자기 자신 보여주기
			}
		/*} else if (search_type.equals("K")) { */// 키워드로 검색				
			search_string = req.getParameter("search_string");
			list_empty_title = "찾고 싶은 카테고리명을 입력하세요. 예) 청바지, MP3";
			
			if (!StringUtils.isEmpty(search_string)) {
				list_empty_title = "검색된 카테고리가 없습니다.";
			}
			List<Map<String,String>> cateList = codeService.selectCode(map);
							
			model.addAttribute("search_string", search_string);
			model.addAttribute("cList", cateList);
			/* } */
		
		model.addAttribute("list_empty_title", list_empty_title);
	}catch(Exception e){			
		e.printStackTrace();
	}
	return "/master/popup/mrStorage";
    }
    
    
	@RequestMapping(value = "/StorageCategoryProc.do")
	public String categoryProc(ModelMap model, HttpServletRequest req, HttpServletResponse res, RedirectAttributes rttr) {
		String mode = req.getParameter("mode");
		System.out.println(mode);
		String STOR_SEQ = req.getParameter("STOR_SEQ");
		String STOR_CD = req.getParameter("STOR_CD");
		String STOR_NAME = req.getParameter("STOR_NAME");
		String STOR_SORT = req.getParameter("STOR_SORT");
		String STOR_UPPER = req.getParameter("STOR_UPPER");
		String STOR_DEPTH = req.getParameter("STOR_DEPTH");
		
		
		String STOR2_DEPTH = req.getParameter("STOR2_DEPTH");
		String STOR2_UPPER = req.getParameter("STOR2_UPPER");
		String STOR3_DEPTH = req.getParameter("STOR3_DEPTH");
		String STOR3_UPPER = req.getParameter("STOR3_UPPER");
		String STOR4_DEPTH = req.getParameter("STOR4_DEPTH");
		String STOR4_UPPER = req.getParameter("STOR4_UPPER");
		String STOR_LOOP = req.getParameter("STOR_LOOP");
		String msg = null;
		
		Map map=new HashMap();
		
		map.put("STOR_SEQ", STOR_SEQ);
		map.put("STOR_CD", STOR_CD);
		map.put("STOR_NAME", STOR_NAME);
		map.put("STOR_SORT", STOR_SORT);
		map.put("STOR_DEPTH", STOR_DEPTH);
		map.put("STOR_UPPER", STOR_UPPER);
		map.put("STOR2_DEPTH", STOR2_DEPTH);
		map.put("STOR2_UPPER", STOR2_UPPER);
		map.put("STOR3_DEPTH", STOR3_DEPTH);
		map.put("STOR3_UPPER", STOR3_UPPER);
		map.put("STOR4_DEPTH", STOR4_DEPTH);
		map.put("STOR4_UPPER", STOR4_UPPER);
		map.put("STOR_LOOP", STOR_LOOP);
		map.put("msg", msg);
		
		System.out.println("MAP :"+map);
		
		try {
			if (StringUtils.isEmpty(mode) || (!mode.equals("entry") && !mode.equals("edit") && !mode.equals("del"))) {
				model.addAttribute("strScript", super.getReturnProc("잘못된 접근입니다.\\n확인하시고 다시 시도해 주십시오.", "javascript:history.back()"));
				return super.returnPage;
			}
			if (mode.equals("entry")) {  //카테고리 추가				
				if (StringUtils.isEmpty(STOR_NAME)) {
					model.addAttribute("strScript", super.getReturnProc("분류명이 입력되지 않았습니다.", "javascript:history.back()"));
					return super.returnPage;
				} else if (StringUtils.isEmpty(STOR_CD)) {
					model.addAttribute("strScript", super.getReturnProc("창고코드가 입력되지 않았습니다.", "javascript:history.back()"));
					return super.returnPage;
				}else if (StringUtils.isEmpty(STOR_SORT)) {
					model.addAttribute("strScript", super.getReturnProc("정렬순서가 입력되지 않았습니다.", "javascript:history.back()"));
					return super.returnPage;
				}else{
					map.put("STOR_NAME",XssFilter.strFilter(req.getParameter("STOR_NAME")));   
				}
				codeService.cscSql(map);  //STOR_SORT 체크
				
				int i = codeService.acSql(map);  //카테고리 추가
				msg = "추가 되었습니다.";
			} else if (mode.equals("edit")) {  //카테고리 수정
				if (StringUtils.isEmpty(STOR_SEQ)) {
					model.addAttribute("strScript", super.getReturnProc("잘못된 접근입니다.\\n확인하시고 다시 시도해 주십시오.", "javascript:history.back()"));
					return super.returnPage;
				}
				if (StringUtils.isEmpty(STOR_NAME)) {
					model.addAttribute("strScript", super.getReturnProc("분류명이 입력되지 않았습니다.", "javascript:history.back()"));
					return super.returnPage;
				} else if (StringUtils.isEmpty(STOR_SORT)) {
					model.addAttribute("strScript", super.getReturnProc("정렬순서가 입력되지 않았습니다.", "javascript:history.back()"));
					return super.returnPage;
				}else{
					map.put("STOR_NAME",XssFilter.strFilter(req.getParameter("STOR_NAME")));   
				}
				System.out.println("1"+map);
				codeService.cscSql(map);  //STOR_SORT 체크
				int u = codeService.ucSql(map);  //카테고리 수정
				if (u <= 0) {
					model.addAttribute("strScript", super.getReturnProc("카테고리 수정이 실패하였습니다\\n다시 시도해 주십시오.", "javascript:history.back()"));
					return super.returnPage;
				}else{
					msg = "수정 되었습니다.";
				}
			} else if (mode.equals("del")) {  //카테고리 삭제
				if (StringUtils.isEmpty(STOR_SEQ)) {
					model.addAttribute("strScript", super.getReturnProc("잘못된 접근입니다.\\n확인하시고 다시 시도해 주십시오.", "javascript:history.back()"));
					return super.returnPage;
				}
				
				 int upperCnt = codeService.cucSql(map);   //삭제 전 하위 카테고리 체크// 삭제 전 물려있는 상품 있는지 체크
				
				if (upperCnt > 0) {
					model.addAttribute("strScript", super.getReturnProc("하위분류가 존재합니다.\\n확인하시고 다시 시도해 주십시오.", "javascript:history.back()"));
					return super.returnPage;
					
					 }else {
					if(StringUtils.isEmpty((CharSequence) map.get("STOR_UPPER"))){
						codeService.ucSql2(map); 
					}
						int d = codeService.dcSql(map); // 카테고리 삭제 (SHOP_BYCATEGORY 기록이 남아 있는 경우) bycategory, 
						System.out.println("int d :::::::::::::::::::::::::: " + d);
					if (d < 0) {
						model.addAttribute("strScript", super.getReturnProc("카테고리 삭제가 실패하였습니다\\n다시 시도해 주십시오.", "javascript:history.back()"));
						return super.returnPage;
					}else{
						msg = "삭제 되었습니다.";
					}
				}
			}
			List <Map<String,String>> csfs = codeService.cateSortForSelect(map);
			for(int i=1;i<=csfs.size();i++){
				map.put("STOR_CD",csfs.get(i-1).get("STOR_CD"));
				map.put("STOR_SORT", i);
				codeService.cateSortForUpdate(map);
			}
			model.addAttribute("strScript", super.getReturnProc(msg, "/code/storage?&STOR2_DEPTH="+STOR2_DEPTH+ "&STOR2_UPPER="+STOR2_UPPER
					+ "&STOR3_DEPTH="+STOR3_DEPTH + "&STOR3_UPPER="+STOR3_UPPER+ "&STOR4_DEPTH="+STOR4_DEPTH+ "&STOR4_UPPER="+STOR4_UPPER+ "&STOR_LOOP="+STOR_LOOP));
			//return super.returnPage;
			return "redirect:/code/storage?&STOR2_DEPTH="+STOR2_DEPTH+ "&STOR2_UPPER="+STOR2_UPPER+ "&STOR3_DEPTH="+STOR3_DEPTH+ "&STOR3_UPPER="+STOR3_UPPER+ "&STOR4_DEPTH="+STOR4_DEPTH+ "&STOR4_UPPER="+STOR4_UPPER+ "&STOR_LOOP="+STOR_LOOP;
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return "redirect:/code/storage?&STOR2_DEPTH="+STOR2_DEPTH+ "&STOR2_UPPER="+STOR2_UPPER+ "&STOR3_DEPTH="+STOR3_DEPTH+ "&STOR3_UPPER="+STOR3_UPPER+ "&STOR4_DEPTH="+STOR4_DEPTH+ "&STOR4_UPPER="+STOR4_UPPER+ "&STOR_LOOP="+STOR_LOOP;
	}
    
    
    @PostMapping(value = "/getStorageBarcodeList",produces="application/json")
    @ResponseBody
    public Map getStorageBarcodeList(@RequestParam(value="STOR_SEQ", required=false) String STOR_SEQ) {
    	
    	Map map = new HashMap();

		
        map.put("STOR_SEQ", STOR_SEQ);
    	System.out.println(STOR_SEQ);
    	for(int i=0;i<codeService.getStorageBarcodeList(map).size();i++) {
    	String b=codeService.getStorageBarcodeList(map).get(i).get("STOR_BARCODE");

    	}
    	
        return JsonResponse.asSuccess("storeData", codeService.getStorageBarcodeList(map));
    }
    
    @PostMapping(value = "/PrintBarCode",produces="application/json")
    @ResponseBody
    public Boolean PrintBarCode(@RequestParam(value="STOR_BARCODE", required=false) String STOR_BARCODE) {
    	
    	try {
    		return Printer.main(STOR_BARCODE);
    	} catch (Exception e) {
    		// TODO Auto-generated catch block
    		e.printStackTrace();
    	}
        
    	
        return null; 
    }

	
    
 

}
