package mes.app.mapper.order;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface OrderPlanMapper {
	
    public List<Map> orderPlanList(Map paramMap);
    
    public int orderPlanListTotal(Map paramMap);
  
    public List<Map> getPartListInfo(Map paramMap);
    
    public List<Map> searchCust(Map paramMap);
   
    public int writeOrderPlan(Map paramMap);

    public void writeOrderPlanDetail(Map paramMap);
    
    public List<Map> getOrderPlanInfo(Map paramMap);
    
    public void editOrderPlan(Map paramMap);

    public void editOrderPlanDetail(Map paramMap);
    
    public List<Map> Material_Search_S2_Str(Map paramMap);
    
    public int materialTotal(Map paramMap);
    
    public void createOrder(Map paramMap);
    
    public void createOrderMulti(Map paramMap);
    
    public void delete(Map paramMap);
    
}
