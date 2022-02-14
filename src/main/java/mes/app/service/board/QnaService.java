package mes.app.service.board;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.board.QnaMapper;
import mes.app.util.Util;
import mes.security.UserInfo;

@Service
@Transactional
public class QnaService {
	@Autowired
	private QnaMapper qnaMapper;

	public void createReply(Map param, HttpServletRequest request) {
		UserInfo info = Util.getUserInfo();

		param.put("iLoginUserId", info.getManagerId());
		param.put("iLoginUserName", info.getManagerName());
		param.put("iLoginUserIp", request.getRemoteAddr());

		qnaMapper.createReply(param);
	}

	public void editReply(Map param, HttpServletRequest request) {
		UserInfo info = Util.getUserInfo();

		param.put("iLoginUserId", info.getManagerId());
		param.put("iLoginUserName", info.getManagerName());
		param.put("iLoginUserIp", request.getRemoteAddr());

		qnaMapper.editReply(param);
	}

	public List<Map> qnaList(Map param) {

		return qnaMapper.qnaList(param);
	}

	public int qnaListTotal(Map param) {

		return qnaMapper.qnaListTotal(param);
	}

	public Map qnaInfo(Map param) {

		return qnaMapper.qnaInfo(param);
	}

	public List<Map> qnaFileListSql(Map param) {

		return qnaMapper.qnaFileListSql(param);
	}
	public List<Map> qnaFileListSql2(Map param) {

		return qnaMapper.qnaFileListSql2(param);
	}
	
	public void deleteFile(Map param) {
		param.put("type", "MES");
		qnaMapper.deleteFile(param);
	}

	
}
