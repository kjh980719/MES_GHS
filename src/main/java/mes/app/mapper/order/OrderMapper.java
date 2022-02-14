package mes.app.mapper.order;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface OrderMapper {

    public void Manager_List_i1_Str(Map paramMap);

    public List<Map<String, String>> Material_List_S1_Str(Map paramMap);

    public List<Map<String, String>> Material_Search_S1_Str(Map paramMap);

    public void Product_Update_U1_Str(Map paramMap);
    
    public void Material_Update_U1_Str(Map paramMap);
    
    public List<Map<String, String>> Product_Group_S1_Str(Map paramMap);
    
    public List<Map<String, String>> Product_Group_CD_S1_Str(Map paramMap);

	public void Order_Detail_Create_I1_Str(Map<String, Object> map);

	public String Order_Create_I2_Str(Map paramMap);

	public List<Map<String, String>> Order_Search_S1_Str(Map paramMap);

	public Map<String, String> Order_Row_S1_Str(Map paramMap);

	public void Order_Update_U1_Str(Map paramMap);

	public List<Map<String, String>> OrderMaterial_Row_S1_Str(Map paramMap);

	public void OrderMaterial_Delete_D1_Str(Map paramMap);

	public List<Map<String, String>> SCM_CustRegist_Search_S1_Str(Map paramMap);

	public List<Map<String, String>> Order_Material_Search_S1_Str(Map paramMap);
	
	//추가
    public List<Map<String, String>> orderList(Map paramMap);
    

    
    public List<Map> orderInfo(Map paramMap);
    
    public List<Map> getcustSearchListCustName(Map paramMap);
   
    public void orderInfoUpdate(Map paramMap);
   
    public void orderInfoUpdateCancel(Map paramMap);

}
