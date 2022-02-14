package mes.app.service.product;

import mes.app.mapper.material.MaterialMapper;
import mes.app.mapper.product.ProductMapper;
import mes.app.util.Util;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ProductService {

    @Autowired
    private MaterialMapper materialMapper;

    @Autowired
	private ProductMapper productMapper;

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

    //제품입고 업데이트
	public void IO_Update_U1_Str(Map<String, List<Map<String, Object>>> paramMap) {
		List<Map<String, Object>> inmaterialList = paramMap.get("inmaterialList");
		List<Map<String, Object>> inmaterial_info = paramMap.get("inmaterial_info");

		UserInfo info = Util.getUserInfo();
		inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());
		inmaterial_info.get(0).put("io_type", "IN");
		productMapper.IO_Update_U1_Str(inmaterial_info.get(0));

		for(int i = 0; i < inmaterialList.size(); i++) {
			inmaterialList.get(i).put("io_seq", inmaterial_info.get(0).get("io_seq"));
			inmaterialList.get(i).put("io_type", "IN");
			productMapper.IO_UpdateDetail_U1_Str(inmaterialList.get(i));
		}

	}

	//출고 업데이트
	public void IO_Update_U2_Str(Map<String, List<Map<String, Object>>> paramMap) {
		List<Map<String, Object>> inmaterialList = paramMap.get("inmaterialList");
		List<Map<String, Object>> inmaterial_info = paramMap.get("inmaterial_info");

		UserInfo info = Util.getUserInfo();
		inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());
		inmaterialList.get(0).put("io_type", "OUT");
		productMapper.IO_Update_U1_Str(inmaterial_info.get(0));

		for(int i = 0; i < inmaterialList.size(); i++) {
			inmaterialList.get(i).put("io_seq", inmaterial_info.get(0).get("io_seq"));
			inmaterialList.get(i).put("io_type", "OUT");
			productMapper.IO_UpdateDetail_U1_Str(inmaterialList.get(i));
		}
	}
	//재고이동 업데이트
	public void IO_Update_U3_Str(Map<String, List<Map<String, Object>>> paramMap) {
		List<Map<String, Object>> inmaterialList = paramMap.get("inmaterialList");
		List<Map<String, Object>> inmaterial_info = paramMap.get("inmaterial_info");

		UserInfo info = Util.getUserInfo();
		inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());
		inmaterialList.get(0).put("io_type", "MOVE");
		productMapper.IO_Update_U1_Str(inmaterial_info.get(0));

		for(int i = 0; i < inmaterialList.size(); i++) {
			inmaterialList.get(i).put("io_seq", inmaterial_info.get(0).get("io_seq"));
			inmaterialList.get(i).put("io_type", "MOVE");
			productMapper.IO_UpdateDetail_U1_Str(inmaterialList.get(i));
		}
	}


	public void updateOut(Map paramMap) {
		System.out.println(paramMap.get(9));
		productMapper.Out_Update_U1_Str(paramMap);
	}
	

	public List<Map<String, String>> IoList(Map paramMap) {
		return productMapper.IoList(paramMap);
	}
	public int IoListTotal(Map paramMap) {
		return productMapper.IoListTotal(paramMap);
	}
	public List<Map<String, String>> IoList2(Map paramMap) {
		return productMapper.IoList2(paramMap);
	}
	public int IoListTotal2(Map paramMap) {
		return productMapper.IoListTotal2(paramMap);
	}

	public List<Map<String, String>> getOutList(Map paramMap) {
		return productMapper.Out_Search_S1_Str(paramMap);
	}

	public List<Map> selectInHead(Map map) {
		return materialMapper.Material_IN_Row_S1_Str(map);
	}

	public List<Map<String, String>> selectInBody(Map paramMap) {
		return materialMapper.Material_IN_Row_S2_Str(paramMap);
	}

	public void IO_UpdateDetail_U1_Str(Map<String, Object> paramMap) {
		productMapper.IO_UpdateDetail_U1_Str(paramMap);
		
	}

	public void updateOutMaterial(Map<String, Object> paramMap) {
		productMapper.Out_Material_Update_U1_Str(paramMap);

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
		return productMapper.InListTotal(paramMap);
	}
	public int OutlistTotal(Map paramMap) {
		return productMapper.OutListTotal(paramMap);
	}

	public List<Map<String, String>> getIODetailInfo(Map paramMap) {
		return productMapper.getIODetailInfo(paramMap);
	}
	public List<Map<String, String>> getIODetailInfo2(Map paramMap) {
		return productMapper.getIODetailInfo2(paramMap);
	}
	public List<Map<String, String>> OutMaterialInfo(Map paramMap) {
		return productMapper.OutMaterialInfo(paramMap);
	}

	public void Out_InsertOutMaterial_I1_Str(Map paramMap) {
		productMapper.Out_InsertOutMaterial_I1_Str(paramMap);
	}

	//입고
	public void IO_Insert_I1_Str(Map<String, List<Map<String, Object>>> param) {

    	List<Map<String, Object>> inmaterialList = param.get("inmaterialList");
		List<Map<String, Object>> inmaterial_info = param.get("inmaterial_info");

		UserInfo info = Util.getUserInfo();
		inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());
		inmaterial_info.get(0).put("io_type", "IN");
		int io_seq = productMapper.IO_Insert_I1_Str(inmaterial_info.get(0));

		for(int i = 0; i < inmaterialList.size(); i++) {
			inmaterialList.get(i).put("io_seq",io_seq);
			inmaterialList.get(i).put("io_type","IN");
			productMapper.IO_InsertDetail_I1_Str(inmaterialList.get(i));
		}
	}
	//출고
	public void IO_Insert_I2_Str(Map<String, List<Map<String, Object>>> param) {

		List<Map<String, Object>> inmaterialList = param.get("inmaterialList");
		List<Map<String, Object>> inmaterial_info = param.get("inmaterial_info");

		UserInfo info = Util.getUserInfo();
		inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());
		inmaterial_info.get(0).put("io_type", "OUT");
		int io_seq = productMapper.IO_Insert_I1_Str(inmaterial_info.get(0));

		for(int i = 0; i < inmaterialList.size(); i++) {
			inmaterialList.get(i).put("io_seq",io_seq);
			inmaterialList.get(i).put("io_type","OUT");
			productMapper.IO_InsertDetail_I1_Str(inmaterialList.get(i));
		}
	}
	//재고이동
	public void IO_Insert_I3_Str(Map<String, List<Map<String, Object>>> param) {

		List<Map<String, Object>> inmaterialList = param.get("inmaterialList");
		List<Map<String, Object>> inmaterial_info = param.get("inmaterial_info");

		UserInfo info = Util.getUserInfo();
		inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());
		inmaterial_info.get(0).put("io_type", "MOVE");
		int io_seq = productMapper.IO_Insert_I1_Str(inmaterial_info.get(0));

		for(int i = 0; i < inmaterialList.size(); i++) {
			inmaterialList.get(i).put("io_seq",io_seq);
			inmaterialList.get(i).put("io_type","MOVE");
			productMapper.IO_InsertDetail_I1_Str(inmaterialList.get(i));
		}
	}

	//자재출고
	public void IO_Insert_I4_Str(Map<String, List<Map<String, Object>>> param) {

		List<Map<String, Object>> inmaterialList = param.get("inmaterialList");
		List<Map<String, Object>> inmaterial_info = param.get("inmaterial_info");

		UserInfo info = Util.getUserInfo();
		inmaterial_info.get(0).put("iManager_seq", info.getManagerSeq());

		int io_seq = productMapper.IO_Insert_I4_Str(inmaterial_info.get(0));

		for(int i = 0; i < inmaterialList.size(); i++) {
			inmaterialList.get(i).put("io_seq",io_seq);
			inmaterialList.get(i).put("io_type","OUT");
			productMapper.IO_InsertDetail_I1_Str(inmaterialList.get(i));
		}
	}

	public String Out_InsertOut_I1_Str(Map paramMap) {
		return productMapper.Out_InsertOut_I1_Str(paramMap);
	}



	public List<Map<String, String>> getProductCategory_Depth1_List() {
		return productMapper.getProductCategory_Depth1_List();
	}



	public List<Map> depthInfo(Map paramMap){
		return productMapper.depthInfo(paramMap);
	}
	public List<Map> viewDepth(Map paramMap){
		return productMapper.viewDepth(paramMap);
	}
	public String createCategory(Map paramMap) {
		return productMapper.Product_Category_i1_Str(paramMap);
	}

	public String updateCategory(Map paramMap) {
		return productMapper.Product_Category_U1_Str(paramMap);
	}



	public List<Map> getProductList(Map paramMap) {
		return productMapper.getProductList(paramMap);
	}

	public int getProductListTotal(Map paramMap) {
		return productMapper.getProductListTotal(paramMap);
	}

	public List<Map> getProductList2(Map paramMap) {
		return productMapper.getProductList2(paramMap);
	}

	public int getProductListTotal2(Map paramMap) {
		return productMapper.getProductListTotal2(paramMap);
	}

	public List<Map> getProductList3(Map paramMap) {
		return productMapper.getProductList3(paramMap);
	}

	public int getProductListTotal3(Map paramMap) {
		return productMapper.getProductListTotal3(paramMap);
	}





	public Map getProductInfo(Map paramMap){
    	return productMapper.getProductInfo(paramMap);
	}


	public void createProduct_V2(Map paramMap) {
		productMapper.Product_Create_I2_Str(paramMap);
	}
	public void updateProduct_V2(Map paramMap) {
		productMapper.Product_Update_U2_Str(paramMap);
	}

}
