package mes.app.mapper.hardware;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface HardwareMapper {
	
	
	
    public String writeHardware(Map paramMap);	
	
	public void writeHardwareDetail(Map<String, Object> map);
	
	public List<Map> hardwareInfo(Map paramMap);
	 
	public List<Map> hardwareFileListSql(Map paramMap);
	
	public int hardwareListTotal(Map paramMap);
	
	public List<Map<String, String>> hardwareList(Map paramMap);
	
	public void delete(Map paramMap);
    
	public void editHardware(Map paramMap);	
		
    public void editHardwareDetail(Map<String, Object> map);
		
    public void deleteFile(Map paramMap);

}
