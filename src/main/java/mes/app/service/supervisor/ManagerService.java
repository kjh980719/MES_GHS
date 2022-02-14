package mes.app.service.supervisor;

import mes.app.mapper.supervisor.ManagerMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ManagerService {

    @Autowired
    private ManagerMapper managerMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void createManager(Map paramMap) {
        paramMap.replace("password", passwordEncoder.encode(paramMap.get("managerId") + "_" + paramMap.get("password")));
        managerMapper.Manager_List_I1_Str(paramMap);
    }

    public List<Map<String, String>> getManagerList(Map paramMap) {
        return managerMapper.Manager_List_S1_Str(paramMap);
    }

    public void updateManager(Map paramMap) {
        paramMap.replace("password", passwordEncoder.encode(paramMap.get("managerId") + "_" + paramMap.get("newPassword")));
        managerMapper.Manager_List_U1_Str(paramMap);
    }
    
    public void updatePROT(Map paramMap) {
    	managerMapper.PRO_List_U1_Str(paramMap);
    }
    
    public List<Map> getManagerInfo(Map paramMap){
    	return managerMapper.getManagerInfo(paramMap);
    }
    
    public int updateMemberInfo(Map paramMap) {
    	return managerMapper.updateMemberInfo(paramMap);
    }
    
}
