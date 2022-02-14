package mes.app.service.calculation;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.calculation.CalculationMapper;

@Service
@Transactional
public class CalculationService {

    @Autowired
    private CalculationMapper calculationMapper;

    public List<Map<String, String>> calculationList(Map paramMap) {
    	
        return calculationMapper.calculationList(paramMap);
    }
	
    public int calculationListTotal(Map paramMap) {
        return calculationMapper.calculationListTotal(paramMap);
    }
 
	
}
