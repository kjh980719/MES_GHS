package mes.app.service.supervisor;

import mes.app.mapper.supervisor.ManagerAuthGroupMapper;
import mes.app.util.Util;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ManagerAuthGroupService {

    @Autowired
    private ManagerAuthGroupMapper managerAuthGroupMapper;

    public List<Map<String, String>> getManagerAuthGroupList(Map paramMap) {
        return managerAuthGroupMapper.Manager_Auth_Group_S1_Str(paramMap);
    }

    public List<Map<String, String>> getTreeMenuList(Map paramMap) {
        System.err.println(paramMap.get("managerSeq"));
        if (paramMap.get("managerSeq")==""){
            paramMap.remove("managerSeq");
        }
        return managerAuthGroupMapper.Manager_Menu_S2_Str(paramMap);
    }

    public List<Map<String, String>> getDetailTreeMenuList(Map paramMap) {


        return managerAuthGroupMapper.Manager_Auth_Group_S2_Str(paramMap);
    }

    public void createAuth(Map paramMap) {
        int authgroupseq = managerAuthGroupMapper.Manager_Auth_Group_i1_Str(paramMap);
        List<Map<String, String>> menuSeqList = (List<Map<String, String>>) paramMap.get("menuSeqList");
        paramMap.put("authGroupSeq", authgroupseq);
        for(Map menuSeqMap : menuSeqList) {
            paramMap.put("menuSeq", menuSeqMap.get("menuSeq"));
            managerAuthGroupMapper.Manager_Menu_Group_i1_Str(paramMap);
        }
    }

    public void updateAuth(Map paramMap) {
        managerAuthGroupMapper.Manager_Auth_Group_U1_Str(paramMap);
        List<Map<String, String>> menuSeqList = (List<Map<String, String>>) paramMap.get("menuSeqList");
        for(Map menuSeqMap : menuSeqList) {
            paramMap.put("menuSeq", menuSeqMap.get("menuSeq"));
            managerAuthGroupMapper.Manager_Menu_Group_U1_Str(paramMap);
        }
    }

    public void deleteAuth(Map paramMap) {
        managerAuthGroupMapper.Manager_Auth_Group_D1_Str(paramMap);
    }

    public void mes_department_update(Map paramMap) { managerAuthGroupMapper.mes_department_update(paramMap); }

    public void mes_department_delete(Map paramMap) { managerAuthGroupMapper.mes_department_delete(paramMap); }
}
