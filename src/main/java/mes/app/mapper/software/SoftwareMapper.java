package mes.app.mapper.software;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface SoftwareMapper {
	
	
	public String writeSoftware(Map paramMap);	
	
	public void writeSoftwareDetail(Map<String, Object> map);
	
	public List<Map<String, String>> softwareList(Map paramMap);
	   
    public List<Map> view(Map paramMap);
	
	public int softwareListTotal(Map paramMap);
	
	public void delete(Map paramMap);
	
    public void editSoftware(Map paramMap);	
	
	public void editSoftwareDetail(Map<String, Object> map);
	
	public void statusUpdate(Map paramMap);
	

    public List<Map<String, String>> getMangerList(Map paramMap);
    
    public int getMangerListTotal(Map paramMap);
    
	
	
	

}
