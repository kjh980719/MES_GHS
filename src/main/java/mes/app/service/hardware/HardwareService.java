package mes.app.service.hardware;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.hardware.HardwareMapper;
import mes.app.mapper.software.SoftwareMapper;
import mes.app.util.Util;
import mes.security.UserInfo;


@Service
@Transactional
public class HardwareService {
	
	
	@Autowired
	private HardwareMapper hardwareMapper;
	
	
	
	public String writeHardware(Map<String, Object> paramMap) {
		
		UserInfo info = Util.getUserInfo();
		paramMap.put("iManagerSeq", info.getManagerSeq());

		return hardwareMapper.writeHardware(paramMap);
	}
	
	
	public void writeHardwareDetail(Map<String, Object> map) {
		hardwareMapper.writeHardwareDetail(map);
	}
	
	public List<Map> hardwareInfo(Map param) {

    	return hardwareMapper.hardwareInfo(param);
    }
    
	public List<Map> hardwareFileListSql(Map param) {

		return hardwareMapper.hardwareFileListSql(param);
	}
	
	 public List<Map<String, String>> hardwareList(Map paramMap) {
	     	
	        return hardwareMapper.hardwareList(paramMap);
	 }
	 
	 
	 public int hardwareListTotal(Map paramMap) {
	        return hardwareMapper.hardwareListTotal(paramMap);
	 }
	 
	 public void delete(Map paramMap) {
	    	UserInfo info = Util.getUserInfo(); 
			paramMap.put("iManagerSeq", info.getManagerSeq());
			hardwareMapper.delete(paramMap);
	}
	 
	public void editHardware(Map paramMap) {
	    	UserInfo info = Util.getUserInfo(); 
			paramMap.put("iManagerSeq", info.getManagerSeq());
			hardwareMapper.editHardware(paramMap);
	}
		
    public void editHardwareDetail(Map<String, Object> map) {
    	hardwareMapper.editHardwareDetail(map);
	}
    
    public void deleteFile(Map param) {
		param.put("type", "MES");
		hardwareMapper.deleteFile(param);
	}
	

}
