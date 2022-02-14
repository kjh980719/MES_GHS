package mes.app.controller.hardware;

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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import mes.app.controller.supervisor.API;
import mes.app.service.board.NoticeService;
import mes.app.service.hardware.HardwareService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.common.service.CFileService;
import mes.security.UserInfo;




@Controller
@RequestMapping(value="/hardware")
public class HaredwareController {
	
	
	
    @Autowired
    private HardwareService hardwareService;

    
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
         	
			if (search_type.equals("hard_code")) {
				sQuery += "AND A.hard_code like '%" + search_string + "%'";
			} else if (search_type.equals("hard_name")) {
				sQuery += "AND A.hard_name like '%" + search_string + "%'";
			} else {
				sQuery += "AND (A.hard_code like '%" + search_string + "%' or A.hard_name like '%" + search_string + "%')";
			}
  
         model.addAttribute("parameter", parameter);
         
         UserInfo info = Util.getUserInfo();       
 		 Map map = new HashMap();

 		 map.put("currentPage", currentPage);	
 		 map.put("rowsPerPage", rowsPerPage);
 		 map.put("sQuery", sQuery);	
 		 map.put("search_type",search_type);
 		
	 	 model.addAttribute("total", hardwareService.hardwareListTotal(map));
	 	 model.addAttribute("list", hardwareService.hardwareList(map));

 		 model.addAttribute("search", map);
 	
         model.addAttribute("currentPage",currentPage);
         model.addAttribute("rowsPerPage",rowsPerPage);

    	
        return "/hardware/list";
    }
    
    @RequestMapping(value="/create" , consumes = { "multipart/form-data" })
    @ResponseBody
	public Map create(@RequestParam Map paramMap1, 
			@RequestPart(name = "content") Map paramMap,	
			@RequestPart(name = "files", required = false) MultipartFile[] multipartFile, HttpServletRequest request) {

    	
    	List<Map<String, Object>> materialList = (List<Map<String, Object>>)paramMap.get("materialList");
    	List<Map<String, Object>> info = (List<Map<String, Object>>)paramMap.get("info");
    	
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
						Map<String, String> map = cFileService.uploadFile(tmpMultipartFile, UPFILE_PATH3 + "hardware/");
						tmpMap.put("bid_file_name", map.get("fileName"));
						tmpMap.put("bid_file_ori_name", map.get("originalFileName"));
						tmpMap.put("fileKey", map.get("fileKey"));
						file_info.add(tmpMap);
						
						info.get(0).put("file" + i, map.get("fileKey"));
						fno++;
					}
					continue;
				}
			}

			
			String hard_no = hardwareService.writeHardware(info.get(0));
			
			
			for(int i=0; i< materialList.size(); i++) {
				materialList.get(i).put("hard_no", hard_no);
				hardwareService.writeHardwareDetail(materialList.get(i));
			}
			
			

		} catch (Exception e) {
			e.printStackTrace();
		}

    	
	
        return  JsonResponse.asSuccess();
    }
    
    @RequestMapping(value="/view")
    @ResponseBody
    public Map view(@RequestParam(value="hard_no", required=false) String hard_no) {
 
		Map map = new HashMap();
	
        map.put("hard_no", hard_no);

		Map resultMap = new HashMap();
		resultMap.put("info", hardwareService.hardwareInfo(map));
		resultMap.put("fileList", hardwareService.hardwareFileListSql(map));

        return JsonResponse.asSuccess("storeData", resultMap);	
    }
    
    @RequestMapping(value="/edithardware", consumes = { "multipart/form-data" })
    @ResponseBody
    public Map edit(@RequestPart(name = "content") Map paramMap,	
			@RequestPart(name = "files", required = false) MultipartFile[] multipartFile, HttpServletRequest request) {
 /*
		int result = 0;
		
		Map mMap = new HashMap<String, String>();
		String notice_seq = paramMap.get("notice_seq").toString();
		String title = paramMap.get("title").toString();
		String contents = paramMap.get("contents").toString();
		System.out.println(paramMap);
*/		
		
		List<Map<String, Object>> materialList = (List<Map<String, Object>>)paramMap.get("materialList");
    	List<Map<String, Object>> info = (List<Map<String, Object>>)paramMap.get("info");
		
		
		
		
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
						Map<String, String> map = cFileService.uploadFile(tmpMultipartFile, UPFILE_PATH3 + "edhard/");
						tmpMap.put("bid_file_name", map.get("fileName"));
						tmpMap.put("bid_file_ori_name", map.get("originalFileName"));
						tmpMap.put("fileKey", map.get("fileKey"));
						bid_file_info.add(tmpMap);
						info.get(0).put("file" + i, map.get("fileKey"));
						fno++;
					}
					continue;
				}
			}
			
			System.out.println("넘버는 넘버다:"+info.get(0).get("hard_no"));

	    	hardwareService.editHardware(info.get(0));
	    	
	    
	    	
	    	for(int i = 0; i < materialList.size(); i++) {
	    		materialList.get(i).put("hard_no", info.get(0).get("hard_no"));
	    		hardwareService.editHardwareDetail(materialList.get(i));
	    	}
	    
	   

		} catch (Exception e) {
			e.printStackTrace();
		}
    	

        return JsonResponse.asSuccess();	
    }
    

    
    
   
    
	@RequestMapping(value = "/deleteFile")
	@ResponseBody
	public Map deleteFile(@RequestParam Map paramMap,HttpServletRequest request) {

		hardwareService.deleteFile(paramMap);

		return JsonResponse.asSuccess();
	}
	
	
	
	 @GetMapping(value = "/delete")
	    @ResponseBody
	    public Map delete(@RequestParam(value="hard_no", required=false) String hard_no){
	        
			Map map = new HashMap();	
	        map.put("hard_no", hard_no);
	 
	        
	        hardwareService.delete(map);     
	        
			return JsonResponse.asSuccess("storeData", "");	
	    }

}
