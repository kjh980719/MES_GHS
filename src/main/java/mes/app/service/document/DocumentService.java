package mes.app.service.document;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.document.DocumentMapper;
import mes.app.util.Util;
import mes.security.UserInfo;

@Service
@Transactional
public class DocumentService {
	
	
	@Autowired
	private DocumentMapper documentMapper;
	
	
	public String writeDocument(Map map) {
		UserInfo info = Util.getUserInfo();
		map.put("iManagerSeq", info.getManagerSeq());
		
		
		
		return documentMapper.writeDocument(map);
	}
	
	
	public void writeDocumentDetail(Map<String, Object> map) {
		documentMapper.writeDocumentDetail(map);
	}
	
	
	 public List<Map<String, String>> documentList(Map paramMap) {
	     	
	        return documentMapper.documentList(paramMap);
	    }
	 
	  public int documentListTotal(Map paramMap) {
	        return documentMapper.documentListTotal(paramMap);
	    }
	    
	  public void delete(Map paramMap) {
	    	UserInfo info = Util.getUserInfo(); 
			paramMap.put("iManagerSeq", info.getManagerSeq());
		    documentMapper.delete(paramMap);
		}
	  
	  public void editDocument(Map paramMap) {
	    	UserInfo info = Util.getUserInfo(); 
			paramMap.put("iManagerSeq", info.getManagerSeq());
			 documentMapper.editDocument(paramMap);
		}
	  
	  public void editDocumentDetail(Map<String, Object> map) {
		  documentMapper.editDocumentDetail(map);
		}
	  
	  
	  public List<Map> view(Map paramMap) {
	    	
	        return documentMapper.view(paramMap);
	    }
	

}
