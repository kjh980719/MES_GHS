package mes.app.mapper.product;

import mes.app.util.Util;
import mes.security.UserInfo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface ProductionMapper {

	public String Production_Create_I1_Str(Map paramMap);
	public void Production_Update_WorkPlan_U1_Str(Map paramMap);
	public void Production_Detail_Create_I1_Str(Map paramMap);
	public List<Map<String, String>> productionList(Map paramMap);
	public int productionListTotal(Map paramMap);
	public List<Map> view(Map paramMap);
	public void editProduction(Map paramMap);
	public void editProductionDetail(Map paramMap);
	public void delete(Map paramMap);
}
