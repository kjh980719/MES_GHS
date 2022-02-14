package mes.app.service.productionLine;

import mes.app.mapper.productionLine.ProductionLineMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ProductionLineService {

    @Autowired
    private ProductionLineMapper productionLineMapper;
    

    
    public List<Map<String, String>> getProductionSetLineList(Map paramMap) {
        return productionLineMapper.Production_Line_S1_Str(paramMap);
    }

    public void createLine(Map paramMap) {
        productionLineMapper.Production_Line_i1_Str(paramMap);
  
    }

    public void updateLine(Map paramMap) {
        productionLineMapper.Production_Line_U1_Str(paramMap);
    }

    public void updateOrder(List<Map> paramList) {
        for(Map paramMap : paramList) {
            productionLineMapper.Production_Line_U2_Str(paramMap);
        }
    }
    
    public List<Map<String, Object>> getProduction_Line_Depth1_List() {
        return productionLineMapper.getProduction_Line_Depth1_List();
    }
    
    
    public List<Map> depthInfo(Map paramMap){
    	return productionLineMapper.depthInfo(paramMap);
    }
    public List<Map> viewDepth(Map paramMap){
    	return productionLineMapper.viewDepth(paramMap);
    }

    public List<Map<String, String>> getProductionList(Map paramMap) {
        return productionLineMapper.getProductionList(paramMap);
    }
    public int getProductionListTotal(Map paramMap) {
        return productionLineMapper.getProductionListTotal(paramMap);
    }
}
