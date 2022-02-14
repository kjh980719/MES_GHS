package mes.app.service.supply;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.supply.SupplyMapper;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class SupplyService {

    @Autowired
    private SupplyMapper supplyMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public List<Map<String, String>> getSupplyList(Map paramMap) {
        return supplyMapper.Supply_Search_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getSCMManagerAllList(Map paramMap) {
		return supplyMapper.SCM_Manager_Search_S1_Str(paramMap);
	}
    
    public void createSupply(Map paramMap) {
    	supplyMapper.Cust_Create_I1_Str(paramMap);
    }
    
    public List<Map<String, String>> getExchangeList() {
        return supplyMapper.Cust_EXchange_S1_Str();
    }

    public Map<String, String>getRowSupply(Map paramMap) {
        return supplyMapper.Cust_Row_S1_Str(paramMap);
    }
    
    public Map<String, String>getRowSCMManager(Map paramMap) {
        return supplyMapper.SCM_Manager_Row_S1_Str(paramMap);
    }

	public void updateManager(Map paramMap) {
		supplyMapper.SCM_Manager_Update_U1_Str(paramMap);
		
	}
	
	 public Map getSupplyInfo(Map paramMap) {
	      return supplyMapper.getSupplyInfo(paramMap);
	 }
	 public Map idCheck(Map paramMap) {
	      return supplyMapper.idCheck(paramMap);
	 }
	 
	 public void create_SCM_Account(Map paramMap) {
		 paramMap.put("scm_password", passwordEncoder.encode(paramMap.get("managerId") + "_" + paramMap.get("scm_password")));
		 supplyMapper.create_SCM_Account(paramMap);
	 }
	 
	 public List<Map<String, String>> getSupplyList_S2_Str(Map paramMap) {
	      return supplyMapper.getSupplyList_S2_Str(paramMap);
	  }
	 public List<Map<String, String>> getScmManagerList(Map paramMap) {
	      return supplyMapper.getScmManagerList(paramMap);
	  }
	 
	 public int getScmManagerTotal(Map paramMap) {
		 return supplyMapper.getScmManagerTotal(paramMap);
	 }
	 public Map getSupplyAccountInfo(Map paramMap) {
	      return supplyMapper.getSupplyAccountInfo(paramMap);
	  }

	 public void resetPassword(Map paramMap) {
		 paramMap.put("scm_password", passwordEncoder.encode(paramMap.get("id") + "_" + paramMap.get("no")));
		 supplyMapper.resetPassword(paramMap);
	 }
	 public void SCMManagerInsertAccount(Map paramMap) {
		 supplyMapper.SCMManagerInsertAccount(paramMap);
	 }
	 public void SCMManagerUpdateAccount(Map Map) {
		 supplyMapper.SCMManagerUpdateAccount(Map);
	 }
	 
	 
	 
}
