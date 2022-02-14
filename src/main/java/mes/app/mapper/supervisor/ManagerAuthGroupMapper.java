package mes.app.mapper.supervisor;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ManagerAuthGroupMapper {

    public List<Map<String, String>> Manager_Auth_Group_S1_Str(Map paramMap);

    public List<Map<String, String>> Manager_Menu_S2_Str(Map paramMap);

    public List<Map<String, String>> Manager_Auth_Group_S2_Str(Map paramMap);

    public int Manager_Auth_Group_i1_Str(Map paramMap);

    public void Manager_Auth_Group_U1_Str(Map paramMap);

    public void Manager_Menu_Group_i1_Str(Map paramMap);

    public void Manager_Menu_Group_U1_Str(Map paramMap);

    public void Manager_Auth_Group_D1_Str(Map paramMap);

    public void mes_department_update(Map paramMap);

    public void mes_department_delete(Map paramMap);
}
