package mes.app.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface CommonCodeMapper {

    List<Map> COMMON_CODE_INFO_List_S1_Str(Map paramMap);

    List<Map> COMMON_CODE_INFO_List_S2_Str(Map paramMap);

    void COMMON_CODE_INFO_I1_Str(Map paramMap);

    void COMMON_CODE_INFO_U1_Str(Map paramMap);

    void COMMON_CODE_INFO_U2_Str(Map paramMap);

    void COMMON_CODE_INFO_U3_Str(Map paramMap);

}
