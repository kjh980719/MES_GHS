package mes.app.mapper.purchase;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface PurchaseMapper {


	public void IN_Update_U1_Str(Map paramMap);

	public Map<String, String> Material_IN_Row_S1_Str(Map paramMap);

	public List<Map<String, String>> Material_IN_Row_S2_Str(Map paramMap);

	public List<Map<String, String>> IN_Check_Search_S1_Str(Map paramMap);

	public void Import_Update_U1_Str(Map<String, Object> paramMap);

	public void Import_Material_Update_U1_Str(Map<String, Object> paramMap);

	public void Defect_Insert_I1_Str(Map<String, Object> paramMap);

	public void Stock_Material_Update_U1_Str(Map<String, Object> paramMap);

	public void Stock_Create_I1_Str(Map<String, Object> paramMap);

	public List<Map<String, Object>> Purchase_Search_S1_Str(Map paramMap);
    
    
}
