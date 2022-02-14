package mes.app.service.purchase;


import mes.app.mapper.purchase.PurchaseMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class PurchaseService {

    @Autowired
    private PurchaseMapper purchaseMapper;

    


	public List<Map<String,Object>> getPurchaseList(Map paramMap) {
		return purchaseMapper.Purchase_Search_S1_Str(paramMap);
	}
	

    
}
