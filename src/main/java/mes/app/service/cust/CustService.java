package mes.app.service.cust;

import mes.app.mapper.cust.CustMapper;
import mes.app.mapper.material.MaterialMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CustService {

    @Autowired
    private CustMapper custMapper;

    
    public List<Map<String, String>> getCustList(Map paramMap) {
        return custMapper.Cust_Search_S1_Str(paramMap);
    }
    
    public void createCust(Map paramMap) {
        custMapper.Cust_Create_I1_Str(paramMap);
    }
    
    public List<Map<String, String>> getExchangeList() {
        return custMapper.Cust_EXchange_S1_Str();
    }
    
    
	public void updateCust(Map paramMap) {
		custMapper.Cust_Update_U1_Str(paramMap);
		
	}
	
    public int custListTotal(Map paramMap) {
        return custMapper.custListTotal(paramMap);
    }
    
    public List<Map<String, Object>> custList(Map paramMap) {
        return custMapper.custList(paramMap);
    }
    public Map<String, String> selectCust(Map paramMap) {
        return custMapper.Cust_Row_S1_Str(paramMap);
    }
}
