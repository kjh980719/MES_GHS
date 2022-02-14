package mes.app.controller.board;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import mes.app.controller.supervisor.API;
import mes.app.service.board.NoticeService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.common.service.CFileService;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/notice")
public class NoticeController {

    @Autowired
    private SupplyService supplyService;

    @Autowired
    private NoticeService noticeService;
    
    @Value("${path.upfile}")
	public String UPFILE_PATH3;
	    
	@Value("${limit.upfile}")
	public int UPFILE_LIMIT;

	@Autowired
	private CFileService cFileService;
	
    @RequestMapping(value="/list")
    public String list(Model model, @RequestParam Map param) {
    	
    	 Map paramMap = new HashMap();
         paramMap.put("currentPage", 1);
         paramMap.put("rowsPerPage", 999);
         
         String search_type = "";
         String search_string = "";
        

         int rowsPerPage = 0;
         int currentPage = 1;
    

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
         
       
         String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&search_string="+search_string;
         String sQuery = "";
         
         if (search_type.equals("TITLE")) {
         	sQuery += " AND A.TITLE = '" + search_string +"'";
         }else {
         	sQuery += "AND (A.TITLE like '%" + search_string + "%')";
         }
  
         model.addAttribute("parameter", parameter);
         

 		 Map map = new HashMap();

 		 map.put("currentPage", currentPage);	
 		 map.put("rowsPerPage", rowsPerPage);
 		 map.put("sQuery", sQuery);	
 		 map.put("search_type",search_type);
 		
	 	 model.addAttribute("total", noticeService.noticeListTotal(map));
	 	 model.addAttribute("list", noticeService.noticeList(map));

 		 model.addAttribute("search", map);
 	
         model.addAttribute("currentPage",currentPage);
         model.addAttribute("rowsPerPage",rowsPerPage);

    	
        return "/notice/list";
    }
    
    @RequestMapping(value="/create" , consumes = { "multipart/form-data" })
    @ResponseBody
    public Map create(@RequestParam Map paramMap1,
			@RequestPart(name = "content") Map paramMap,
			@RequestPart(name = "files", required = false) MultipartFile[] multipartFile, HttpServletRequest request) {
		int result = 0;
		/* String result = ""; */
		Map mMap = new HashMap<String, String>();
		String notice = paramMap.get("notice_seq").toString();
		String title = paramMap.get("title").toString();
		String contents = paramMap.get("contents").toString();
		try {
			Iterator<MultipartFile> iterator = Arrays.asList(multipartFile).iterator();
			int fno = 0;
			List<Map> file_info = new ArrayList<>();
			/*
			 * for(int i = 1; i <= 3; i++){ if(paramMap.get("FILE"+i) != null){ Map tmpMap =
			 * bidMapper.B2B_BUY_UPFILE_S1_Str(paramMap.get("buy_idx").toString(),
			 * paramMap.get("UFILE"+i).toString()); tmpMap.put("bid_file_seq", fno+1);
			 * bid_file_info.add(tmpMap); fno++; continue; } }
			 */
			int loopCount = UPFILE_LIMIT - file_info.size();
			for (int i = 1; i <= 1; i++) {
				if (iterator.hasNext()) {
					MultipartFile tmpMultipartFile = iterator.next();
					if (!tmpMultipartFile.isEmpty()) {
						Map tmpMap = new HashMap();
						tmpMap.put("bid_file_seq", fno + 1);
						tmpMap.put("bid_file_size", tmpMultipartFile.getSize());
						Map<String, String> map = cFileService.uploadFile(tmpMultipartFile, UPFILE_PATH3 + "notice/");
						tmpMap.put("bid_file_name", map.get("fileName"));
						tmpMap.put("bid_file_ori_name", map.get("originalFileName"));
						tmpMap.put("fileKey", map.get("fileKey"));
						file_info.add(tmpMap);
						paramMap.put("file" + i, map.get("fileKey"));
						fno++;
					}
					continue;
				}
			}

			noticeService.createNotice(paramMap, request);

		} catch (Exception e) {
			e.printStackTrace();
		}

    	
	
        return  JsonResponse.asSuccess();
    }
    
    @RequestMapping(value="/view")
    @ResponseBody
    public Map view(@RequestParam(value="notice_seq", required=false) String notice_seq) {
 
		Map map = new HashMap();
	
        map.put("notice_seq", Integer.parseInt(notice_seq));

		Map resultMap = new HashMap();
		resultMap.put("info", noticeService.noticeInfo(map));
		resultMap.put("fileList", noticeService.noticeFileListSql(map));

        return JsonResponse.asSuccess("storeData", resultMap);	
    }
    
    @RequestMapping(value="/edit", consumes = { "multipart/form-data" })
    @ResponseBody
    public Map edit(@RequestParam Map paramMap1, @RequestPart(name = "content") Map paramMap,
			@RequestPart(name = "files", required = false) MultipartFile[] multipartFile, HttpServletRequest request) {
 
		int result = 0;
		/* String result = ""; */
		Map mMap = new HashMap<String, String>();
		String notice_seq = paramMap.get("notice_seq").toString();
		String title = paramMap.get("title").toString();
		String contents = paramMap.get("contents").toString();
		System.out.println(paramMap);
		try {
			Iterator<MultipartFile> iterator = Arrays.asList(multipartFile).iterator();
			int fno = 0;
			List<Map> bid_file_info = new ArrayList<>();
			/*
			 * for(int i = 1; i <= 3; i++){ if(paramMap.get("FILE"+i) != null){ Map tmpMap =
			 * bidMapper.B2B_BUY_UPFILE_S1_Str(paramMap.get("buy_idx").toString(),
			 * paramMap.get("UFILE"+i).toString()); tmpMap.put("bid_file_seq", fno+1);
			 * bid_file_info.add(tmpMap); fno++; continue; } }
			 */
			int loopCount = UPFILE_LIMIT - bid_file_info.size();
			for (int i = 1; i <= 1; i++) {
				if (iterator.hasNext()) {
					MultipartFile tmpMultipartFile = iterator.next();
					if (!tmpMultipartFile.isEmpty()) {
						Map tmpMap = new HashMap();
						tmpMap.put("bid_file_seq", fno + 1);
						tmpMap.put("bid_file_size", tmpMultipartFile.getSize());
						Map<String, String> map = cFileService.uploadFile(tmpMultipartFile, UPFILE_PATH3 + "qna/");
						tmpMap.put("bid_file_name", map.get("fileName"));
						tmpMap.put("bid_file_ori_name", map.get("originalFileName"));
						tmpMap.put("fileKey", map.get("fileKey"));
						bid_file_info.add(tmpMap);
						paramMap.put("file" + i, map.get("fileKey"));
						fno++;
					}
					continue;
				}
			}
			noticeService.editNotice(paramMap, request);

		} catch (Exception e) {
			e.printStackTrace();
		}
    	
    	
    	
    	
    	
    	
   
        return JsonResponse.asSuccess();	
    }
    

    @PostMapping(value = "/getSupplyList"
            , produces="application/json")
    @ResponseBody
    public Map getSupplyList(@RequestBody Map paramMap) {
        return JsonResponse.asSuccess("storeData", supplyService.getSupplyList(paramMap));
    }
    
    

    @PostMapping(value = "/createSupply"
            , produces="application/json")
    @ResponseBody
    public Map createsupply(@RequestBody Map paramMap) {
    	supplyService.createSupply(paramMap);
    	System.out.println(paramMap);
    	 Map<String, Object> paramMap2 = new HashMap<String, Object>();
       paramMap2.put("COM_CODE","81546");
       String ZONE=null;
       try{
           ZONE=API.urlConnect("https://oapi.ecounterp.com/OAPI/V2/Zone", "POST", paramMap2,"Data","ZONE");
           }catch (Exception e) {
    		e.printStackTrace();
   		}
       
     System.out.println(ZONE);
       paramMap2.put("ZONE",ZONE);
       paramMap2.put("USER_ID","red-angle");
       paramMap2.put("API_CERT_KEY","36e049b8f84954170bbc2f798ac66bad74");
       String SESSION_ID=null;
       try{
       	SESSION_ID=API.urlConnect("https://oapi"+ZONE+".ecounterp.com/OAPI/V2/OAPILogin", "POST", paramMap2,"Data","Datas","SESSION_ID");
       }catch (Exception e) {
		e.printStackTrace();
		}
       System.out.println(SESSION_ID);
           try{
           	String a=API.urlConnectInsert("https://oapi"+ZONE+".ecounterp.com/OAPI/V2/AccountBasic/SaveBasicCust?SESSION_ID="+SESSION_ID, "POST", paramMap,"CustList");
           	System.out.println(a);
          }catch (Exception e) {
  		e.printStackTrace();
   		}

        return JsonResponse.asSuccess();
    }
    
    @PostMapping(value = "/selectSupply"
            , produces="application/json")
    @ResponseBody
    public Map selectSupply(@RequestBody Map paramMap) {
        
        return JsonResponse.asSuccess("storeData", supplyService.getRowSupply(paramMap));
    }
    
	@RequestMapping(value = "/deleteFile")
	@ResponseBody
	public Map deleteFile(@RequestParam Map paramMap,HttpServletRequest request) {

		noticeService.deleteFile(paramMap);

		return JsonResponse.asSuccess();
	}
	@RequestMapping(value = "/deleteNotice")
	@ResponseBody
	public Map deleteNotice(@RequestParam Map paramMap, HttpServletRequest request) {

		noticeService.deleteNotice(paramMap,request);

		return JsonResponse.asSuccess();
	}
	
	
}
