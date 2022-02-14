package mes.app.service.order;

import mes.app.mapper.order.OrderMapper;

import mes.app.util.Util;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;

    public void writeOrderDetail(Map<String, Object> map) {
        orderMapper.Order_Detail_Create_I1_Str(map);
    }

    
    public List<Map<String, String>> getProductDivisionList(Map paramMap) {
        return orderMapper.Product_Group_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getProductGroupCDList(Map paramMap) {
        return orderMapper.Product_Group_CD_S1_Str(paramMap);
    }

	public String writeOrder(Map paramMap) {
        UserInfo user = Util.getUserInfo();
        paramMap.put("regist_by", user.getManagerSeq());

		return orderMapper.Order_Create_I2_Str(paramMap);
	}

    
    public List<Map<String, String>> orderList(Map paramMap) {
    	
        return orderMapper.orderList(paramMap);
    }

    public List<Map> orderInfo(Map paramMap){
    	return orderMapper.orderInfo(paramMap);
    }

    public void orderInfoUpdate(Map paramMap){
        UserInfo user = Util.getUserInfo();
        paramMap.put("mod_by", user.getManagerSeq());
    	orderMapper.orderInfoUpdate(paramMap);
    }
    
    public void orderInfoUpdateCancel(Map paramMap){
        UserInfo user = Util.getUserInfo();
        paramMap.put("mod_by", user.getManagerSeq());
    	orderMapper.orderInfoUpdateCancel(paramMap);
    }
}
