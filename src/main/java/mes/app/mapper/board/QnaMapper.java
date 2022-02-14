package mes.app.mapper.board;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface QnaMapper {

  
	 public void createReply(Map paramMap);
	 public List<Map> qnaList(Map paramMap);
	 public int qnaListTotal(Map paramMap);
	 public Map qnaInfo(Map paramMap);
	 public Map editReply(Map paramMap);
	 public List<Map> qnaFileListSql(Map paramMap);
	 public List<Map> qnaFileListSql2(Map paramMap);
	 public void deleteFile(Map paramMap);
}
