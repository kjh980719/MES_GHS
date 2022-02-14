package mes.app.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import mes.security.UserInfo;

@Repository
@Mapper
public interface HomeMapper {

    public String getTime();

    public void updateLoginFailCount(Map paramMap);

    public UserInfo getUserInfo(String id);
    
    public List<Map<String, Object>> getManagerList(Map paramMap);
}
