package mes.app.mapper.product;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ProductMapper {

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

	public void IO_Update_U1_Str(Map paramMap);
	public void IO_Update_U2_Str(Map paramMap);

	public void IO_Update_U3_Str(Map paramMap);

	public void IO_Update_U4_Str(Map paramMap);

	public void Out_Update_U1_Str(Map paramMap);

	public List<Map<String, String>> IoList(Map paramMap);
	public int IoListTotal(Map paramMap);
	public List<Map<String, String>> IoList2(Map paramMap);
	public int IoListTotal2(Map paramMap);

	public List<Map<String, String>> Out_Search_S1_Str(Map paramMap);

	public List<Map> Material_IN_Row_S1_Str(Map map);

	public List<Map<String, String>> Material_IN_Row_S2_Str(Map paramMap);

	public void IO_UpdateDetail_U1_Str(Map<String, Object> paramMap);

	public void Out_Material_Update_U1_Str(Map<String, Object> paramMap);

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

	public int OutListTotal(Map paramMap);

	public List<Map<String, String>> getIODetailInfo(Map paramMap);

	public List<Map<String, String>> getIODetailInfo2(Map paramMap);

	public List<Map<String, String>> OutMaterialInfo(Map paramMap);

	public List<Map<String, String>> StorageInfo(Map paramMap);

	public int IO_Insert_I1_Str(Map paramMap);
	public int IO_Insert_I2_Str(Map paramMap);
	public int IO_Insert_I3_Str(Map paramMap);
	public int IO_Insert_I4_Str(Map paramMap);

	public String Out_InsertOut_I1_Str(Map paramMap);

	public void IO_InsertDetail_I1_Str(Map paramMap);

	public void IO_InsertDetail_I2_Str(Map paramMap);


	public void Out_InsertOutMaterial_I1_Str(Map paramMap);

	public List<Map<String, String>> getProductCategory_Depth1_List();

	public List<Map> depthInfo(Map paramMap);

	public List<Map> viewDepth(Map paramMap);
	public String Product_Category_i1_Str(Map paramMap);

	public String Product_Category_U1_Str(Map paramMap);

	public List<Map> getProductList(Map paramMap);
	public int getProductListTotal(Map paramMap);

	public List<Map> getProductList2(Map paramMap);
	public int getProductListTotal2(Map paramMap);
	public List<Map> getProductList3(Map paramMap);
	public int getProductListTotal3(Map paramMap);


	public Map getProductInfo(Map paramMap);
	public void Product_Create_I2_Str(Map paramMap);
	public void Product_Update_U2_Str(Map paramMap);

}
