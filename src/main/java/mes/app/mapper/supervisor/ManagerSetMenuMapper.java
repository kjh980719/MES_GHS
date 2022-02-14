package mes.app.mapper.supervisor;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ManagerSetMenuMapper {

    public List<Map<String, String>> Manager_Menu_S1_Str(Map paramMap);

    public String Manager_Menu_i1_Str(Map paramMap);

    public String Manager_Menu_U1_Str(Map paramMap);

    public void Manager_Menu_U2_Str(Map paramMap);
    
    public List<Map<String, Object>> getManagerMenu_Depth1_List();
    
    public List<Map> depthInfo(Map paramMap);
   
    public List<Map> viewDepth(Map paramMap);
    
}
