package mes.app.mapper.calculation;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface CalculationMapper {

    
	//추가
    public List<Map<String, String>> calculationList(Map paramMap);
    
    public int calculationListTotal(Map paramMap);
  
	
}
