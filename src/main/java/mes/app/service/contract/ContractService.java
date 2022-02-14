package mes.app.service.contract;

import mes.app.mapper.contract.ContractMapper;
import mes.app.util.Util;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ContractService {

    @Autowired
    private ContractMapper contractMapper;

    public void writeContractDetail(Map<String, Object> map) {

        contractMapper.Contract_Detail_Create_I1_Str(map);
    }
    public String writeContract(Map paramMap) {
        UserInfo info = Util.getUserInfo();
        paramMap.put("iManager_seq",info.getManagerSeq());
        return contractMapper.Contract_Create_I2_Str(paramMap);

    }


    public List<Map<String, String>> getMaterialList(Map paramMap) {
        return contractMapper.Material_List_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getMaterialGroupList(Map paramMap) {
        return contractMapper.Material_Search_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getOrderList(Map paramMap) {
        return contractMapper.Order_Search_S1_Str(paramMap);
    }

    
    public List<Map<String, String>> getProductDivisionList(Map paramMap) {
        return contractMapper.Product_Group_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getProductGroupCDList(Map paramMap) {
        return contractMapper.Product_Group_CD_S1_Str(paramMap);
    }

    public void updateOrder(Map paramMap) {
        contractMapper.Order_Update_U1_Str(paramMap);
    }
    
    public void updateMaterial(Map paramMap) {
        contractMapper.Material_Update_U1_Str(paramMap);
    }



    public Map<String, String> getRowOrder(Map paramMap) {
        return contractMapper.Order_Row_S1_Str(paramMap);
    }
    
    public List<Map<String, String>>getRowOrderMaterial(Map paramMap) {
        return contractMapper.OrderMaterial_Row_S1_Str(paramMap);
    }
    
    public void deleteOrderMaterial(Map paramMap) {
        contractMapper.OrderMaterial_Delete_D1_Str(paramMap);
    }

	public List<Map<String, String>> getcustSearchList(Map paramMap) {
		return contractMapper.SCM_CustRegist_Search_S1_Str(paramMap);
	}

	public List<Map<String, String>> getMaterialSearchList(Map paramMap) {
		return contractMapper.Order_Material_Search_S1_Str(paramMap);
	}
    
    public List<Map<String, String>> contractList(Map paramMap) {
    	
        return contractMapper.contractList(paramMap);
    }
	
    public int contractListTotal(Map paramMap) {
        return contractMapper.contractListTotal(paramMap);
    }
    
    public List<Map> contractInfo(Map paramMap){
    	return contractMapper.contractInfo(paramMap);
    }
    
    public List<Map> getcustSearchListCustName(Map paramMap){
    	return contractMapper.getcustSearchListCustName(paramMap);
    }
    public void contractInfoUpdate(Map paramMap){
        UserInfo info = Util.getUserInfo();
        paramMap.put("iManager_seq",info.getManagerSeq());
    	contractMapper.contractInfoUpdate(paramMap);
    }
    
    public void contractInfoUpdateCancel(Map paramMap){
        UserInfo info = Util.getUserInfo();
        paramMap.put("iManager_seq",info.getManagerSeq());
    	contractMapper.contractInfoUpdateCancel(paramMap);
    }
}
