package mes.app.mapper.partlist;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface PartlistMapper {

    public List<Map<String, String>> Partlist_Search_S1_Str(Map paramMap);
    
    public int PartlistTotal(Map paramMap);
    
    public List<Map<String, String>> Partlist_Row_S1_Str(Map paramMap);
    public List<Map<String, String>> Partlist_Row_S2_Str(Map paramMap);

    public void Partlist_Create_I1_Str(Map<String, String> map);
    public void Partlist_Create_I2_Str(Map<String, String> map);

	public void Partlist_Delete_D1_Str(String string);
    
    
    
    
    
    
    
}
