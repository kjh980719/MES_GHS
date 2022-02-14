package mes.app.service.board;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.board.NoticeMapper;
import mes.app.util.Util;
import mes.security.UserInfo;

@Service
@Transactional
public class NoticeService {

    @Autowired
    private NoticeMapper noticeMapper;
    
    public void createNotice(Map param, HttpServletRequest request) {
    	UserInfo info = Util.getUserInfo(); 
    	param.put("loginUserId", info.getManagerId());
    	param.put("iLoginUserName", info.getManagerName());
    	param.put("iLoginUserIp",request.getRemoteAddr());
    	
    	noticeMapper.createNotice(param);
    }
    public void editNotice(Map param, HttpServletRequest request) {
    	UserInfo info = Util.getUserInfo();    
    	param.put("loginUserId", info.getManagerId());
    	param.put("iLoginUserName", info.getManagerName());
    	param.put("iLoginUserIp",request.getRemoteAddr());
    	
    	noticeMapper.editNotice(param);
    }
    
    
    public List<Map> noticeList(Map param) {

    	
    	return noticeMapper.noticeList(param);
    }
    public int noticeListTotal(Map param) {

    	return noticeMapper.noticeListTotal(param);
    }
    public Map noticeInfo(Map param) {

    	return noticeMapper.noticeInfo(param);
    }
    
	public List<Map> noticeFileListSql(Map param) {

		return noticeMapper.noticeFileListSql(param);
	}
    
	
	public void deleteFile(Map param) {
		param.put("type", "MES");
		noticeMapper.deleteFile(param);
	}
	public void deleteNotice(Map param, HttpServletRequest request) {
    	UserInfo info = Util.getUserInfo();    
    	param.put("loginUserId", info.getManagerId());
    	param.put("iLoginUserName", info.getManagerName());
    	param.put("iLoginUserIp",request.getRemoteAddr());
		noticeMapper.deleteNotice(param);
	}
	
	
}
