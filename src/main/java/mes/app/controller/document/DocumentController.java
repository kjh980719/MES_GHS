package mes.app.controller.document;

import mes.app.controller.supervisor.API;
import mes.app.service.code.ComCodeService;
import mes.app.service.document.DocumentService;
import mes.app.service.supply.SupplyService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.security.UserInfo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/document")
public class DocumentController {

    @Autowired
    private DocumentService documentService;
    @Autowired
    private ComCodeService comCodeService;


	@RequestMapping(value="/document")
    public String documentList(Model model, @RequestParam Map param) {


        String search_group = "";
        String search_type = "";
        String search_string = "";
    
        int rowsPerPage = 0;
        int currentPage = 1;
   
      
        
        if (param.get("search_group") == null || param.get("search_group") == "") {
            search_group = "ALL";
        }else {
            search_group = (String) param.get("search_group");
        }
        if (param.get("search_type") == null || param.get("search_group") == "") {
        	search_type = "ALL";
        }else {
        	search_type = (String) param.get("search_type");
        }
        if(param.get("search_string") == null || param.get("search_string") == "") {
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
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&search_group="+search_group+"&search_string="+search_string;
        String sQuery = "";

        if (!search_group.equals("ALL")) {
            sQuery += " AND A.DISTRIBUTOR_FROM = '" + search_group + "'";
        }

        if (search_type.equals("DOCUMENT_CODE")) {
			sQuery += " AND A.DOCUMENT_CODE like '%" + search_string + "%'";
		} else if (search_type.equals("DOCUMENT_NAME")) {
			sQuery += " AND A.DOCUMENT_NAME like '%" + search_string + "%'";
		} else {
			sQuery += " AND (A.DOCUMENT_CODE like '%" + search_string + "%' or A.DOCUMENT_NAME like '%" + search_string + "%')";
		}

        model.addAttribute("parameter", parameter);

		Map map = new HashMap();
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_group",search_group);
		map.put("search_type",search_type);

        Map commonMap = new HashMap();
        commonMap.put("code_id","DG");
        model.addAttribute("documentGroup", comCodeService.comCodeDetailSelectList(commonMap));

        commonMap.put("code_id","DT");
        model.addAttribute("documentType", comCodeService.comCodeDetailSelectList(commonMap));

        model.addAttribute("total", documentService.documentListTotal(map));
		model.addAttribute("list", documentService.documentList(map));

		
		
		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        
        return "/document/document";
    }
    
  
    @RequestMapping(value = "/registerDocument", produces="application/json")
    @ResponseBody
    public Map registerDocument(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> materialList = paramMap.get("materialList");
    	List<Map<String, Object>> info = paramMap.get("info");

    	String document_code = documentService.writeDocument(info.get(0));
    	
    	
    	for(int i = 0; i < materialList.size(); i++) {
    		materialList.get(i).put("document_code", document_code);
    		documentService.writeDocumentDetail(materialList.get(i));
    	}
    	
    	
    	
   
    	
    	return JsonResponse.asSuccess();
    }
    
    @RequestMapping(value = "/editdocument", produces="application/json")
    @ResponseBody
    public Map editDocument(@RequestBody Map<String, List<Map<String, Object>>> paramMap) {
    	List<Map<String, Object>> materialList = paramMap.get("materialList");
    	List<Map<String, Object>> info = paramMap.get("info");

    	documentService.editDocument(info.get(0));

    	for(int i = 0; i < materialList.size(); i++) {
    		materialList.get(i).put("document_code", info.get(0).get("document_code"));
    		documentService.editDocumentDetail(materialList.get(i));
    	}

    	return JsonResponse.asSuccess();
    }
    
    @GetMapping(value = "/view")
    @ResponseBody
    public Map view(@RequestParam(value="document_code", required=false) String document_code) {
        
		Map map = new HashMap();

		
        map.put("document_code", document_code);

		return JsonResponse.asSuccess("storeData", documentService.view(map));	
    }
    
  
    @GetMapping(value = "/delete")
    @ResponseBody
    public Map delete(@RequestParam(value="document_code", required=false) String document_code){
        
		Map map = new HashMap();	
        map.put("document_code", document_code);
 
        
        documentService.delete(map);     
        
		return JsonResponse.asSuccess("storeData", "");	
    }

}
