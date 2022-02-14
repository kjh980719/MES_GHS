package mes.app.service.workplan;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.workplan.WorkPlanMapper;
import mes.app.util.Util;
import mes.security.UserInfo;

@Service
@Transactional
public class WorkPlanService {

    @Autowired
    private WorkPlanMapper workPlanMapper;

    public List<Map<String, String>> workPlanList(Map paramMap) {
    	
        return workPlanMapper.workPlanList(paramMap);
    }
	
    public int workPlanListTotal(Map paramMap) {
        return workPlanMapper.workPlanListTotal(paramMap);
    }
    
    public List<Map<String, String>> getMangerList(Map paramMap) {
    	
        return workPlanMapper.getMangerList(paramMap);
    }
	
    public int getMangerListTotal(Map paramMap) {
        return workPlanMapper.getMangerListTotal(paramMap);
    }

	public String writeWorkPlan(Map paramMap) {
		UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		return workPlanMapper.writeWorkPlan(paramMap);
		
	}
	
	public void writeWorkPlanDetail(Map<String, Object> map) {
	    workPlanMapper.writeWorkPlanDetail(map);
	}
  
    public List<Map> view(Map paramMap) {
    	
        return workPlanMapper.view(paramMap);
    }
    
    
    public void editWorkPlan(Map paramMap) {
    	UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		 workPlanMapper.editWorkPlan(paramMap);
	}
	
	public void editWorkPlanDetail(Map<String, Object> map) {
	    workPlanMapper.editWorkPlanDetail(map);
	}

	public void delete(Map paramMap) {
    	UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
	    workPlanMapper.delete(paramMap);
	}
	public void finish(Map paramMap) {
		UserInfo info = Util.getUserInfo();
		paramMap.put("iManagerSeq", info.getManagerSeq());
		workPlanMapper.finish(paramMap);
	}

	public List<Map<String, String>> getSerialProductList(Map paramMap) {

		return workPlanMapper.getSerialProductList(paramMap);
	}
	public List<Map<String, String>> getSerialList(Map paramMap) {

		return workPlanMapper.getSerialList(paramMap);
	}

	public String manageSerial (Map paramMap){
		UserInfo info = Util.getUserInfo();
		paramMap.put("iManagerSeq", info.getManagerSeq());
    	return workPlanMapper.manageSerial(paramMap);
	}

}
