package mes.app.mapper.cust;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface CustMapper {
    
    public List<Map<String, String>> Cust_Search_S1_Str(Map paramMap);
    public void Cust_Create_I1_Str(Map paramMap);
    public List<Map<String, String>> Cust_EXchange_S1_Str();
	public void Cust_Update_U1_Str(Map paramMap);
	public int custListTotal(Map paramMap);
	public List<Map<String, Object>> custList(Map paramMap);
	  public Map<String, String> Cust_Row_S1_Str(Map paramMap);
	

}
