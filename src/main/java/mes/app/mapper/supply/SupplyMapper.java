package mes.app.mapper.supply;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface SupplyMapper {
    
    public List<Map<String, String>> Supply_Search_S1_Str(Map paramMap);
    public void Cust_Create_I1_Str(Map paramMap);
    public List<Map<String, String>> Cust_EXchange_S1_Str();
	public Map<String, String> Cust_Row_S1_Str(Map paramMap);
	public List<Map<String, String>> SCM_Manager_Search_S1_Str(Map paramMap);
	
	public Map<String, String> SCM_Manager_Row_S1_Str(Map paramMap);
	
	public void SCM_Manager_Update_U1_Str(Map paramMap);
	
	public Map getSupplyInfo(Map paramMap);
	public Map idCheck(Map paramMap) ;
	public void create_SCM_Account(Map paramMap); 
	public List<Map<String, String>> getSupplyList_S2_Str(Map paramMap);
	public List<Map<String, String>> getScmManagerList(Map paramMap);
	public int getScmManagerTotal(Map paramMap) ;
	public Map getSupplyAccountInfo(Map paramMap);
	public void resetPassword(Map paramMap);
	public void SCMManagerInsertAccount(Map paramMap);
	public void SCMManagerUpdateAccount(Map paramMap); 
	
}
