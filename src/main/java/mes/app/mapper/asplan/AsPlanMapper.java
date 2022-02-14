package mes.app.mapper.asplan;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface AsPlanMapper {
	
	public String writeAsPlan(Map paramMap);

	public void writeAsPlanDetail(Map<String, Object> map);
	
	public List<Map<String, String>> asPlanList(Map paramMap);
	
	public int asPlanListTotal(Map paramMap);
	
	public void delete(Map paramMap) ;
	
	public List<Map> view(Map paramMap);

    public void editAsPlan(Map paramMap) ;	
	
	public void editAsPlanDetail(Map<String, Object> map) ;
	
    public List<Map<String, String>> getMangerList(Map paramMap);
    
    public int getMangerListTotal(Map paramMap);
	
}
