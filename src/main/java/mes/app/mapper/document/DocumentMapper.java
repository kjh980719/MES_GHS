package mes.app.mapper.document;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface DocumentMapper {
	
	
	public String writeDocument(Map paramMap);
	
	public void writeDocumentDetail(Map<String, Object> map) ;
	
	public List<Map<String, String>> documentList(Map paramMap);
	
	public int documentListTotal(Map paramMap);
	
	public void delete(Map paramMap);

	public void editDocument(Map paramMap);	
	
	public void editDocumentDetail(Map<String, Object> map) ;
	
    public List<Map> view(Map paramMap);
}
