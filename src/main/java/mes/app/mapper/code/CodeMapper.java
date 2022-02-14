package mes.app.mapper.code;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface CodeMapper {


	

	public List<Map<String, String>> Storage_Search_S1_Str(Map paramMap);

	public List<Map<String, String>> Storage_Row_S1_Str(Map paramMap);

	public void Storage_Create_I1_Str(Map paramMap);
	
	public void Storage_Update_U1_Str(Map paramMap);

	public int StorageListTotal(Map map);

	public List<Map<String, String>> StorageList(Map map);

	public List<Map<String, String>> selectCate(Map map);

	public List<Map<String, String>> cate1Sql(Map map);
	
	public List<Map<String, String>> cate2Sql(Map map);
	
	public Map<String, String> cupSql(String stor_seq);

	public void cscSql(Map map);
	
	public int acSql(Map map);

	public int ucSql(Map map);
	
	public void ucSql2(Map map);

	public int cucSql(Map map);

	public int cucSql2(Map map);

	public int dcSql(Map map);

	public List<Map<String, String>> cateSortForSelect(Map map);

	public void cateSortForUpdate(Map map);
	
	public List<Map<String, String>> getStorageBarcodeList(Map map);

	public List<Map> selectStorageList(Map map);

	public int selectStorageListTotal(Map map);


    
}
