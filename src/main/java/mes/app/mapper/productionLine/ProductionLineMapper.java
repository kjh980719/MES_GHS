package mes.app.mapper.productionLine;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ProductionLineMapper {

    public List<Map<String, String>> Production_Line_S1_Str(Map paramMap);

    public void Production_Line_i1_Str(Map paramMap);

    public void Production_Line_U1_Str(Map paramMap);

    public void Production_Line_U2_Str(Map paramMap);
    
    public List<Map<String, Object>> getProduction_Line_Depth1_List();
    
    public List<Map> depthInfo(Map paramMap);
   
    public List<Map> viewDepth(Map paramMap);
    public List<Map<String, String>> getProductionList(Map paramMap);

    public int getProductionListTotal(Map paramMap);

}
