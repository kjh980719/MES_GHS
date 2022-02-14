package mes.app.service.order;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.order.OrderPlanMapper;
import mes.app.util.Util;
import mes.security.UserInfo;

@Service
@Transactional
public class OrderPlanService {

    @Autowired
    private OrderPlanMapper orderPlanMapper;
    
    public List<Map> orderPlanList(Map paramMap) {
        return orderPlanMapper.orderPlanList(paramMap);
    }
    public int orderPlanListTotal(Map paramMap) {
        return orderPlanMapper.orderPlanListTotal(paramMap);
    }
    public List<Map> getPartListInfo(Map paramMap) {
        return orderPlanMapper.getPartListInfo(paramMap);
    }
    
    public List<Map> Material_Search_S2_Str(Map paramMap) {
        return orderPlanMapper.Material_Search_S2_Str(paramMap);
    }
    public int materialTotal(Map paramMap) {
        return orderPlanMapper.materialTotal(paramMap);
    }

    public List<Map> searchCust(Map paramMap) {
        return orderPlanMapper.searchCust(paramMap);
    }
    public int writeOrderPlan(Map paramMap) {
		UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
    	return orderPlanMapper.writeOrderPlan(paramMap);
    }
    
    public void writeOrderPlanDetail(Map paramMap) {
    	orderPlanMapper.writeOrderPlanDetail(paramMap);
    }
    
    public List<Map> getOrderPlanInfo(Map paramMap){
    	return orderPlanMapper.getOrderPlanInfo(paramMap);
    }
    
    public void editOrderPlan(Map paramMap) {
    	UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		orderPlanMapper.editOrderPlan(paramMap);
	}
	
	public void editOrderPlanDetail(Map<String, Object> map) {
		orderPlanMapper.editOrderPlanDetail(map);
	}
	
	public void createOrder(Map paramMap) {
		UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		orderPlanMapper.createOrder(paramMap);
	}
	public void createOrderMulti(Map paramMap) {
		UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		orderPlanMapper.createOrderMulti(paramMap);
	}
	
	public void delete(Map paramMap) {
		UserInfo info = Util.getUserInfo(); 
		paramMap.put("iManagerSeq", info.getManagerSeq());
		orderPlanMapper.delete(paramMap);
	}
	
}
