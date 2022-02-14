package mes.app.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface MemoMapper {

    List<Map> ADMIN_MEMO4_S1_Str(Map paramMap);

    void ADMIN_MEMO4_I1_Str(Map paramMap);

    void ADMIN_MEMO4_D1_Str(Map paramMap);

}
