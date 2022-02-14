package mes.app.mapper.pallet;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface PalletMapper {

    public List<Map<String, String>> Pallet_Search_S1_Str(Map paramMap);
    
    public List<Map<String, String>> Pallet_Num_S1_Str();
    
    public void Pallet_Create_I1_Str(Map paramMap);
    
    public Map<String, String> Pallet_Box_S1_Str(Map paramMap);
    
    
    
    
    
    
}
