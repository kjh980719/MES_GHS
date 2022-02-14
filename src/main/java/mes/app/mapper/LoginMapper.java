package mes.app.mapper;

import mes.security.UserInfo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface LoginMapper {

    public UserInfo Manager_List_For_Login_S1_Str(String managerId);

    public void Manager_List_For_Password_U1_Str(Map paramMap);

    public void Manager_List_For_FailCount_U1_Str(Map paramMap);

    public List Manager_Menu_S4_Str(int authGroupSeq);

}
