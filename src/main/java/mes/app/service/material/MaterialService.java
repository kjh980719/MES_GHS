package mes.app.service.material;

import mes.app.mapper.material.MaterialMapper;
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
public class MaterialService {

    @Autowired
    private MaterialMapper materialMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void createProduct(Map paramMap) {
        materialMapper.Product_Create_I1_Str(paramMap);
    }
    
    public void createMaterial(Map paramMap) {
        materialMapper.Material_Create_I1_Str(paramMap);
    }

    public List<Map<String, String>> getMaterialList(Map paramMap) {
        return materialMapper.Material_List_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getMaterialGroupList(Map paramMap) {
        return materialMapper.Material_Search_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getProductGroupList(Map paramMap) {
        return materialMapper.Product_Search_S1_Str(paramMap);
    }

    
    public List<Map<String, String>> getProductDivisionList(Map paramMap) {
        return materialMapper.Product_Group_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getProductGroupCDList(Map paramMap) {
        return materialMapper.Product_Group_CD_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getProductCategoryList(Map paramMap) {
        return materialMapper.Product_CATEGORY__S1_Str(paramMap);
    }
    
    public Map<String, String> getRowProduct(Map paramMap) {
        return materialMapper.Product_Row_S1_Str(paramMap);
    }
    
    public Map<String, String> getRowMaterial(Map paramMap) {
        return materialMapper.Material_Row_S1_Str(paramMap);
    }

    public void updateProduct(Map paramMap) {
        materialMapper.Product_Update_U1_Str(paramMap);
    }
    
    public void updateMaterial(Map paramMap) {
        materialMapper.Material_Update_U1_Str(paramMap);
    }

	public void updateIn(Map paramMap) {
		System.out.println(paramMap.get(9));
		materialMapper.IN_Update_U1_Str(paramMap);
	}
	

	public List<Map<String, String>> getInList(Map paramMap) {
		return materialMapper.IN_Search_S1_Str(paramMap);
	}

	public List<Map> selectInHead(Map map) {
		return materialMapper.Material_IN_Row_S1_Str(map);
	}

	public List<Map<String, String>> selectInBody(Map paramMap) {
		return materialMapper.Material_IN_Row_S2_Str(paramMap);
	}

	public void updateInMaterial(Map<String, Object> paramMap) {
		materialMapper.IN_Material_Update_U1_Str(paramMap);
		
	}
	
	public List<Map<String, String>> getDefectList(Map paramMap) {
		return materialMapper.Defect_Search_S1_Str(paramMap);
	}

	public Map<String, String> selectDefect(Map paramMap) {
		return materialMapper.Material_Defect_Row_S1_Str(paramMap);
	}

	public void updateDefect(Map paramMap) {
		 materialMapper.Material_Defect_Update_U1_Str(paramMap);
		
	}

	public List<Map<String, String>> getMaterialStockList(Map paramMap) {
		return materialMapper.Material_Stock_Search_S1_Str(paramMap);
	}


	public Map<String, String> getRowMaterialStock(Map paramMap) {
		// TODO Auto-generated method stub
		return materialMapper.Material_Stock_Row_S1_Str(paramMap);
	}

	public List<Map<String, String>> getMaterialStockStorageList(Map paramMap) {
		// TODO Auto-generated method stub
		return materialMapper.Material_Stock_Storage_Search_S1_Str(paramMap);
	}

	public List<Map<String, String>> selectMaterialStockStorage(Map paramMap) {
		// TODO Auto-generated method stub
		return materialMapper.Material_Stock_Storage_Row_S1_Str(paramMap);
	}
	
	
	
	
	
	public  List<Map<String, String>> StorageSelectOption1(Map paramMap) {
		return materialMapper.Storage_SelectOption_S1_Str(paramMap);
	}
	
	public  List<Map<String, String>> StorageSelectOption2(Map paramMap) {
		return materialMapper.Storage_SelectOption_S2_Str(paramMap);
	}
	
	public  List<Map<String, String>> StorageSelectOption3(Map paramMap) {
		return materialMapper.Storage_SelectOption_S3_Str(paramMap);
	}

	public void createMaterialStock(Map paramMap) {
		materialMapper.Storage_SelectOption_S3_Str(paramMap);
		
	}

	public void updateMaterialStock(Map paramMap) {
		materialMapper.Storage_SelectOption_S3_Str(paramMap);
		
	}
	
	 public int materialListTotal(Map paramMap) {
        return materialMapper.materialListTotal(paramMap);
    }
	
	 
	 public List<Map<String, String>> popupPartlistProductList(Map paramMap) {
	        return materialMapper.popupPartlistProduct_Search_S1_Str(paramMap);
	    }
	 public int popupPartlistProductListTotal(Map paramMap) {
	        return materialMapper.popupPartlistProductListTotal(paramMap);
	    }

	public int InlistTotal(Map paramMap) {
		return materialMapper.InListTotal(paramMap);
	}
	
	public List<Map<String, String>> InMaterialInfo(Map paramMap) {
		return materialMapper.InMaterialInfo(paramMap);
	}
	
	public void IN_InsertInMaterial_I1_Str(Map paramMap) {
		materialMapper.IN_InsertInMaterial_I1_Str(paramMap);
	}
	
	public void IN_InsertIn_I1_Str(Map paramMap) {
		materialMapper.IN_InsertIn_I1_Str(paramMap);
	}

	
	public List<Map> getBomList(Map paramMap){
    	return materialMapper.getBomList(paramMap);
	}
	public int getBomListTotal(Map paramMap){
		return materialMapper.getBomListTotal(paramMap);
	}
	public List<Map> getBomVersionList(Map paramMap){
		return materialMapper.getBomVersionList(paramMap);
	}
	public List<Map> getBomDetail(Map paramMap){
		return materialMapper.getBomDetail(paramMap);
	}
	public List<Map> getBomDetail2(Map paramMap){
		return materialMapper.getBomDetail2(paramMap);
	}

	public String createBOM(Map paramMap) {
		UserInfo user = Util.getUserInfo();
		paramMap.put("regist_by", user.getManagerSeq());

		return materialMapper.createBOM(paramMap);
	}
	public String updateBOM(Map paramMap) {
		UserInfo user = Util.getUserInfo();
		paramMap.put("regist_by", user.getManagerSeq());

		return materialMapper.updateBOM(paramMap);
	}



}
