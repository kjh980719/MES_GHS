package mes.app.service.software;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.software.SoftwareMapper;
import mes.app.util.Util;
import mes.security.UserInfo;


@Service
@Transactional
public class SoftwareService {
	
	@Autowired
	private SoftwareMapper softwareMapper;
	
	
	
	public String writeSoftware(Map<String, Object> paramMap) {
		
		UserInfo info = Util.getUserInfo();
		paramMap.put("iManagerSeq", info.getManagerSeq());

		return softwareMapper.writeSoftware(paramMap);
	}
	
	
	public void writeSoftwareDetail(Map<String, Object> map) {
		softwareMapper.writeSoftwareDetail(map);
	}
	
    public List<Map<String, String>> softwareList(Map paramMap) {
     	
        return softwareMapper.softwareList(paramMap);
    }
	
    public int softwareListTotal(Map paramMap) {
        return softwareMapper.softwareListTotal(paramMap);
    }
    
    public void delete(Map paramMap) {
    	UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
	    softwareMapper.delete(paramMap);
	}
    
    public List<Map> view(Map paramMap) {
    	
        return softwareMapper.view(paramMap);
    }
    
    
    public void editSoftware(Map paramMap) {
    	UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		 softwareMapper.editSoftware(paramMap);
	}
	
	public void editSoftwareDetail(Map<String, Object> map) {
	    softwareMapper.editSoftwareDetail(map);
	}
	
	 public void statusUpdate(Map paramMap) {
	    	UserInfo info = Util.getUserInfo(); 
			paramMap.put("iManagerSeq", info.getManagerSeq());
			 softwareMapper.statusUpdate(paramMap);
    }
	 
	 public List<Map<String, String>> getMangerList(Map paramMap) {
	    	
	        return softwareMapper.getMangerList(paramMap);
    }
		
	    public int getMangerListTotal(Map paramMap) {
	        return softwareMapper.getMangerListTotal(paramMap);
	}

	
	
	
	

}
