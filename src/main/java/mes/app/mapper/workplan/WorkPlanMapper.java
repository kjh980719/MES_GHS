package mes.app.mapper.workplan;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface WorkPlanMapper {

    
	//추가
    public List<Map<String, String>> workPlanList(Map paramMap);
    
    public int workPlanListTotal(Map paramMap);
    
    public List<Map<String, String>> getMangerList(Map paramMap);
    
    public int getMangerListTotal(Map paramMap);
    
	public String writeWorkPlan(Map paramMap) ;	
	public void writeWorkPlanDetail(Map<String, Object> map) ;
	public void editWorkPlan(Map paramMap) ;	
	public void editWorkPlanDetail(Map<String, Object> map) ;
    public List<Map> view(Map paramMap);

	public void delete(Map paramMap) ;
	public void finish(Map paramMap) ;
	public List<Map<String, String>> getSerialProductList(Map paramMap);
	public List<Map<String, String>> getSerialList(Map paramMap);
	public String manageSerial(Map paramMap);
}
