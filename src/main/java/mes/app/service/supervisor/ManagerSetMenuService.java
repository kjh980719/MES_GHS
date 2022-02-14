package mes.app.service.supervisor;

import mes.app.mapper.supervisor.ManagerSetMenuMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ManagerSetMenuService {

    @Autowired
    private ManagerSetMenuMapper managerSetMenuMapper;
    

    
    public List<Map<String, String>> getManagerSetMenuList(Map paramMap) {
        return managerSetMenuMapper.Manager_Menu_S1_Str(paramMap);
    }

    public String createMenu(Map paramMap) {
      return managerSetMenuMapper.Manager_Menu_i1_Str(paramMap);
  
    }

    public String updateMenu(Map paramMap) {
        return managerSetMenuMapper.Manager_Menu_U1_Str(paramMap);
    }

    public void updateOrder(List<Map> paramList) {
        for(Map paramMap : paramList) {
            managerSetMenuMapper.Manager_Menu_U2_Str(paramMap);
        }
    }
    
    public List<Map<String, Object>> getManagerMenu_Depth1_List() {
        return managerSetMenuMapper.getManagerMenu_Depth1_List();
    }
    
    
    public List<Map> depthInfo(Map paramMap){
    	return managerSetMenuMapper.depthInfo(paramMap);
    }
    public List<Map> viewDepth(Map paramMap){
    	return managerSetMenuMapper.viewDepth(paramMap);
    }
    
    
}
