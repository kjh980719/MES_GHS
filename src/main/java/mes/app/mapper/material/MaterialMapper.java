package mes.app.mapper.material;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface MaterialMapper {

    public void Manager_List_i1_Str(Map paramMap);

    public List<Map<String, String>> Material_List_S1_Str(Map paramMap);
    
    public List<Map<String, String>> Material_Search_S1_Str(Map paramMap);

    public void Product_Update_U1_Str(Map paramMap);
    
    public void Material_Update_U1_Str(Map paramMap);
    
    public List<Map<String, String>> Product_Search_S1_Str(Map paramMap);
    
    public List<Map<String, String>> Product_Group_S1_Str(Map paramMap);
    
    public List<Map<String, String>> Product_Group_CD_S1_Str(Map paramMap);
    
    public List<Map<String, String>> Product_CATEGORY__S1_Str(Map paramMap);
    
    public void Product_Create_I1_Str(Map paramMap);
    
    public void Material_Create_I1_Str(Map paramMap);
    
    public Map<String, String> Product_Row_S1_Str(Map paramMap);
    
    public Map<String, String> Material_Row_S1_Str(Map paramMap);

	public void IN_Update_U1_Str(Map paramMap);
	
	public List<Map<String, String>> IN_Search_S1_Str(Map paramMap);

	public List<Map> Material_IN_Row_S1_Str(Map map);

	public List<Map<String, String>> Material_IN_Row_S2_Str(Map paramMap);

	public void IN_Material_Update_U1_Str(Map<String, Object> paramMap);
	
	public List<Map<String, String>> Defect_Search_S1_Str(Map paramMap);

	public Map<String, String> Material_Defect_Row_S1_Str(Map paramMap);

	public void Material_Defect_Update_U1_Str(Map paramMap);

	public List<Map<String, String>> Material_Stock_Search_S1_Str(Map paramMap);

	public List<Map<String, String>> Storage_SelectOption_S1_Str(Map paramMap);
	
	public List<Map<String, String>> Storage_SelectOption_S2_Str(Map paramMap);
	
	public List<Map<String, String>> Storage_SelectOption_S3_Str(Map paramMap);

	public Map<String, String> Material_Stock_Row_S1_Str(Map paramMap);

	public List<Map<String, String>> Material_Stock_Storage_Search_S1_Str(Map paramMap);

	public List<Map<String, String>> Material_Stock_Storage_Row_S1_Str(Map paramMap);

	public int materialListTotal(Map paramMap);
	
	public List<Map<String, String>> popupPartlistProduct_Search_S1_Str(Map paramMap);
	
	public int popupPartlistProductListTotal(Map paramMap);

	public int InListTotal(Map paramMap);
	
	public List<Map<String, String>> InMaterialInfo(Map paramMap);
	
	public List<Map<String, String>> StorageInfo(Map paramMap);

	public void IN_InsertIn_I1_Str(Map paramMap);
	
	public void IN_InsertInMaterial_I1_Str(Map paramMap);

	public List<Map> getBomList(Map paramMap);
	public int getBomListTotal(Map paramMap);
	public List<Map> getBomVersionList(Map paramMap);
	public List<Map> getBomDetail(Map paramMap);
	public List<Map> getBomDetail2(Map paramMap);
	public String createBOM(Map paramMap);
	public String updateBOM(Map paramMap);

    
}
