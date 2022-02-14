package mes.app.mapper.producePlan;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface ProducePlanSalesMapper {

    
	//추가
    public List<Map<String, String>> producePlanSalesList(Map paramMap);
    
    public int producePlanSalesListTotal(Map paramMap);
    
	public String writeProducePlanSales(Map paramMap) ;	
	public void writeProducePlanSalesDetail(Map<String, Object> map) ;
	public void editProducePlanSales(Map paramMap) ;	
	public void editProducePlanSalesDetail(Map<String, Object> map) ;
    public List<Map> view(Map paramMap);
	public void statusUpdate(Map paramMap) ;	
	public void delete(Map paramMap) ;
}
