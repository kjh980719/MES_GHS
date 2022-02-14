package mes.app.service.asplan;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import mes.app.mapper.asplan.AsPlanMapper;
import mes.app.util.Util;
import mes.security.UserInfo;

@Service
@Transactional
public class AsPlanService {

	@Autowired
	private AsPlanMapper asplanMapper;

	public String writeAsPlan(Map paramMap) {
		UserInfo info = Util.getUserInfo();
		paramMap.put("iManagerSeq", info.getManagerSeq());
		return asplanMapper.writeAsPlan(paramMap);

	}

	public void writeAsPlanDetail(Map<String, Object> map) {
		asplanMapper.writeAsPlanDetail(map);
	}

	public List<Map<String, String>> asPlanList(Map paramMap) {

		return asplanMapper.asPlanList(paramMap);
	}

	public int asPlanListTotal(Map paramMap) {
		return asplanMapper.asPlanListTotal(paramMap);
	}

	public void delete(Map paramMap) {
		UserInfo info = Util.getUserInfo();
		paramMap.put("iManagerSeq", info.getManagerSeq());
		asplanMapper.delete(paramMap);
	}

	public List<Map> view(Map paramMap) {

		return asplanMapper.view(paramMap);
	}

	public void editAsPlan(Map paramMap) {
		UserInfo info = Util.getUserInfo();
		paramMap.put("iManagerSeq", info.getManagerSeq());
		asplanMapper.editAsPlan(paramMap);
	}

	public void editAsPlanDetail(Map<String, Object> map) {
		asplanMapper.editAsPlanDetail(map);

	}

	public List<Map<String, String>> getMangerList(Map paramMap) {

		return asplanMapper.getMangerList(paramMap);
	}

	public int getMangerListTotal(Map paramMap) {
		return asplanMapper.getMangerListTotal(paramMap);
	}

}
