package mes.app.mapper.code;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ComCodeMapper {

	public List<Map<String, String>> comCodeList(Map paramMap);
	public int comCodeListTotal(Map paramMap) ;
	public List<Map<String, String>> comCodeDetailList(Map paramMap);
	public int comCodeDetailListTotal(Map paramMap) ;
	public String Code_Manage_V1_Str(Map paramMap);
	public Map codeInfo(Map paramMap);
	public List<Map<String, String>> comCodeSelectList(Map paramMap);
	public String CodeDetail_Manage_V1_Str(Map paramMap);
	public Map codeDetailInfo(Map paramMap);
	public List<Map<String, String>> selectComCodeDetail(Map paramMap);
	public int deleteComCodeDetail(Map paramMap) ;
	public int selectComCodeDetailTotal(Map paramMap) ;
	public List<Map> comCodeDetailSelectList(Map paramMap);
}
