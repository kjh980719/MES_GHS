package mes.app.mapper.buyer;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface BuyerMapper {

  List<Map> getBuyerMemberList(Map param);

  void buyerMemberInsertAccount(Map map);

  void buyerMemberUpdateAccount(Map map);
}
