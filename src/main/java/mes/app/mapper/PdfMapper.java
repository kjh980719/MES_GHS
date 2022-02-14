package mes.app.mapper;

import mes.security.UserInfo;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface PdfMapper {

    Map B2B_BUY_JOIN_S1_Str(Map paramMap);

    List<Map> B2B_BUY_JOIN_PRODUCT_S1_Str(Map paramMap);

    Map PDF_END_BID_S1_Str(Map paramMap);
    List<Map> PDF_END_BID_S2_Str(Map paramMap);
}
