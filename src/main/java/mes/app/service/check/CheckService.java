package mes.app.service.check;

import mes.app.mapper.check.CheckMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CheckService {

    @Autowired
    private CheckMapper checkMapper;

    

	public Map<String, String> selectInHead(Map paramMap) {
		return checkMapper.Material_IN_Row_S1_Str(paramMap);
	}

	public List<Map<String, String>> selectInBody(Map paramMap) {
		return checkMapper.Material_IN_Row_S2_Str(paramMap);
	}
	
	public List<Map<String, String>> getInMaterialList(Map paramMap) {
		return checkMapper.IN_Check_Search_S1_Str(paramMap);
	}

	public void updateImport(Map<String, Object> paramMap) {
		checkMapper.Import_Update_U1_Str(paramMap);
	}

	public void updateImportMaterial(Map<String, Object> paramMap) {
		checkMapper.Import_Material_Update_U1_Str(paramMap);
		
	}

	public void createDefect(Map<String, Object> paramMap) {
		checkMapper.Defect_Insert_I1_Str(paramMap);
		
	}

	public void updateStockMaterial(Map<String, Object> paramMap) {
		checkMapper.Stock_Material_Update_U1_Str(paramMap);
		
	}

	public void insertStock(Map<String, Object> paramMap) {
		checkMapper.Stock_Create_I1_Str(paramMap);
		
	}

    
}
