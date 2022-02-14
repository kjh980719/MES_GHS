package mes.app.mapper.board;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface NoticeMapper {

  
	 public void createNotice(Map paramMap);
	 public List<Map> noticeList(Map paramMap);
	 public int noticeListTotal(Map paramMap);
	 public Map noticeInfo(Map paramMap);
	 public Map editNotice(Map paramMap);
	 public List<Map> noticeFileListSql(Map paramMap);
	 public void deleteFile(Map paramMap);
	 public void deleteNotice(Map paramMap);
	 
	 
}
