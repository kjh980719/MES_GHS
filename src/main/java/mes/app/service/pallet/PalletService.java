package mes.app.service.pallet;


import mes.app.mapper.pallet.PalletMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.annotation.JacksonInject.Value;

import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

@Service
@Transactional
public class PalletService {

    @Autowired
    private PalletMapper palletMapper;

    
    public List<Map<String, String>> getPalletList(Map paramMap) {
        return palletMapper.Pallet_Search_S1_Str(paramMap);
    }
    
    public List<Map<String, String>> getPalletList() {
    	System.out.println(palletMapper.Pallet_Num_S1_Str());
        return palletMapper.Pallet_Num_S1_Str();
    }
    
    public void createPallet(Map paramMap) {
        palletMapper.Pallet_Create_I1_Str(paramMap);
    }
    
    public Map<String, String> getBoxList(Map paramMap){
    	Map<String, String> BOX= palletMapper.Pallet_Box_S1_Str(paramMap);
    	try {
    	
    	BOX.values().removeAll(Collections.singleton(null));
    	BOX.values().removeAll(Collections.singleton("null"));
    	BOX.values().removeAll(Collections.singleton(""));
    	}catch (Exception e) {
			e.printStackTrace();
			BOX.put("값이 존재하지않습니다.", "값이 존재하지않습니다.");
		}
     	
    	System.out.println(BOX);
    	return BOX;
    };
}
