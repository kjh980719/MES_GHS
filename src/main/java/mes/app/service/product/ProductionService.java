package mes.app.service.product;

import mes.app.mapper.material.MaterialMapper;
import mes.app.mapper.product.ProductMapper;
import mes.app.mapper.product.ProductionMapper;
import mes.app.util.Util;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ProductionService {


    @Autowired
	private ProductionMapper productionMapper;

    public void writeProduction(Map<String, List<Map<String, Object>>> paramMap) {
        List<Map<String, Object>> materialList = paramMap.get("materialList");
        List<Map<String, Object>> inmaterial_info = paramMap.get("info");

        UserInfo info = Util.getUserInfo();
        inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());
        String production_code = productionMapper.Production_Create_I1_Str(inmaterial_info.get(0));

        for(int i = 0; i < materialList.size(); i++) {
            materialList.get(i).put("production_code", production_code);
            materialList.get(i).put("product_line", inmaterial_info.get(0).get("product_line"));
            productionMapper.Production_Detail_Create_I1_Str(materialList.get(i));
        }

        productionMapper.Production_Update_WorkPlan_U1_Str(inmaterial_info.get(0));
    }

    public List<Map<String, String>> productionList(Map paramMap) {

        return productionMapper.productionList(paramMap);
    }

    public int productionListTotal(Map paramMap) {
        return productionMapper.productionListTotal(paramMap);
    }

    public List<Map> view(Map paramMap) {

        return productionMapper.view(paramMap);
    }
    public void editProduction(Map<String, List<Map<String, Object>>> paramMap) {
        List<Map<String, Object>> materialList = paramMap.get("materialList");
        List<Map<String, Object>> inmaterial_info = paramMap.get("info");

        UserInfo info = Util.getUserInfo();
        inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());
        productionMapper.editProduction(inmaterial_info.get(0));

        for(int i = 0; i < materialList.size(); i++) {
            materialList.get(i).put("production_code", inmaterial_info.get(0).get("production_code"));
            materialList.get(i).put("product_line", inmaterial_info.get(0).get("product_line"));
            productionMapper.editProductionDetail(materialList.get(i));
        }
        productionMapper.Production_Update_WorkPlan_U1_Str(inmaterial_info.get(0));
    }


    public void delete(Map paramMap) {
        UserInfo info = Util.getUserInfo();
        paramMap.put("iManagerSeq", info.getManagerSeq());
        productionMapper.delete(paramMap);
    }

}
