package mes.app.service.producePlan;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.producePlan.ProducePlanSalesMapper;
import mes.app.util.Util;
import mes.security.UserInfo;

@Service
@Transactional
public class ProducePlanSalesService {

    @Autowired
    private ProducePlanSalesMapper producePlanSalesMapper;

    public List<Map<String, String>> producePlanSalesList(Map paramMap) {
    	
        return producePlanSalesMapper.producePlanSalesList(paramMap);
    }
	
    public int producePlanSalesListTotal(Map paramMap) {
        return producePlanSalesMapper.producePlanSalesListTotal(paramMap);
    }
    
	public String writeProducePlanSales(Map paramMap) {
		UserInfo info = Util.getUserInfo();  
		paramMap.put("iManagerSeq",info.getManagerSeq());

		return producePlanSalesMapper.writeProducePlanSales(paramMap);
		
	}
	
	public void writeProducePlanSalesDetail(Map<String, Object> map) {

		producePlanSalesMapper.writeProducePlanSalesDetail(map);
	}
  
    public List<Map> view(Map paramMap) {
    	
        return producePlanSalesMapper.view(paramMap);
    }
    
    
    public void editProducePlanSales(Map paramMap) {
		UserInfo info = Util.getUserInfo();  
		paramMap.put("iManagerSeq",info.getManagerSeq());
    	producePlanSalesMapper.editProducePlanSales(paramMap);
	}
	
	public void editProducePlanSalesDetail(Map<String, Object> map) {
		producePlanSalesMapper.editProducePlanSalesDetail(map);
	}

	public void delete(Map paramMap) {
    	UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		producePlanSalesMapper.delete(paramMap);
	}
	
    
}
