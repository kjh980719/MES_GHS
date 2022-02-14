package mes.app.mapper.producePlan;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface ProducePlanMapper {

    
	//추가
    public List<Map<String, String>> producePlanList(Map paramMap);
    
    public int producePlanListTotal(Map paramMap);
    
	public String writeProducePlan(Map paramMap) ;	
	public void writeProducePlanDetail(Map<String, Object> map) ;
	public void editProducePlan(Map paramMap) ;	
	public void editProducePlanDetail(Map<String, Object> map) ;
    public List<Map> view(Map paramMap);
	public void statusUpdate(Map paramMap) ;	
	public void delete(Map paramMap) ;
}
