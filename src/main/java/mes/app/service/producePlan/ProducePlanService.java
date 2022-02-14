package mes.app.service.producePlan;

import mes.app.mapper.producePlan.ProducePlanMapper;
import mes.app.util.Util;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ProducePlanService {

    @Autowired
    private ProducePlanMapper producePlanMapper;

    public List<Map<String, String>> producePlanList(Map paramMap) {
    	
        return producePlanMapper.producePlanList(paramMap);
    }
	
    public int producePlanListTotal(Map paramMap) {
        return producePlanMapper.producePlanListTotal(paramMap);
    }
    
	public String writeProducePlan(Map paramMap) {
		UserInfo info = Util.getUserInfo();  
		paramMap.put("iManagerSeq",info.getManagerSeq());
		return producePlanMapper.writeProducePlan(paramMap);
		
	}
	
	public void writeProducePlanDetail(Map<String, Object> map) {

		producePlanMapper.writeProducePlanDetail(map);
	}
  
    public List<Map> view(Map paramMap) {
    	
        return producePlanMapper.view(paramMap);
    }
    
    
    public void editProducePlan(Map paramMap) {
		UserInfo info = Util.getUserInfo();  
		paramMap.put("iManagerSeq",info.getManagerSeq());
    	producePlanMapper.editProducePlan(paramMap);
	}
	
	public void editProducePlanDetail(Map<String, Object> map) {
		producePlanMapper.editProducePlanDetail(map);
	}
    public void statusUpdate(Map paramMap) {
		UserInfo info = Util.getUserInfo();  
		paramMap.put("iManagerSeq",info.getManagerSeq());
    	producePlanMapper.statusUpdate(paramMap);
	}
	
	public void delete(Map paramMap) {
    	UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		producePlanMapper.delete(paramMap);
	}
	
    
}
