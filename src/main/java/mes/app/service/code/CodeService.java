package mes.app.service.code;

import mes.app.mapper.code.CodeMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CodeService {

    @Autowired
    private CodeMapper codeMapper;


	public List<Map<String, String>> selectStorage(Map paramMap) {
		return codeMapper.Storage_Row_S1_Str(paramMap);
	}


	public void createStorage(Map paramMap) {
		codeMapper.Storage_Create_I1_Str(paramMap);
	}
	
	public void updateStorage(Map paramMap) {
		codeMapper.Storage_Update_U1_Str(paramMap);
	}

	public int storageListTotal(Map map) {
		return codeMapper.StorageListTotal(map);
	}
	
	public List<Map<String, String>> storageList(Map map) {
		return codeMapper.StorageList(map);
	}

	public List<Map<String, String>> selectDepth3(Map map){
		return null;
	}
	
	public List<Map<String, String>> selectCode(Map map){
		return null;
	}
	
	public List<Map<String, String>> selectCate(Map map){
		return codeMapper.selectCate(map);
	}

	public List<Map<String, String>> cate1Sql(Map map){
		return codeMapper.cate1Sql(map);
	}
	
	public List<Map<String, String>> cate2Sql(Map map){
		return codeMapper.cate2Sql(map);
	}
	
	public Map<String, String> cupSql(String stor_seq){
		return codeMapper.cupSql(stor_seq);
	}
	
	public void cscSql(Map map){
		codeMapper.cscSql(map);
	}
	
	public int acSql(Map map){
		return codeMapper.acSql(map);
	}
	
	public int ucSql(Map map){
		return codeMapper.ucSql(map);
	}


	public int cucSql(Map map) {
		return codeMapper.cucSql(map);
	}


	public int cucSql2(Map map) {
		return codeMapper.cucSql2(map);
	}


	public void ucSql2(Map map) {
		codeMapper.ucSql2(map);
	}

	public int dcSql(Map map) {
		return codeMapper.dcSql(map);
	}


	public List<Map<String, String>> cateSortForSelect(Map map) {
		return codeMapper.cateSortForSelect(map);
	}


	public void cateSortForUpdate(Map map) {
		codeMapper.cateSortForUpdate(map);
		
	}


	public List<Map<String, String>> getStorageBarcodeList(Map map) {
		
		return codeMapper.getStorageBarcodeList(map);
	}


	public List<Map> selectStorageList(Map map){
		return codeMapper.selectStorageList(map);
	}
	public int selectStorageListTotal(Map map){
		return codeMapper.selectStorageListTotal(map);
	}

	
    
}
