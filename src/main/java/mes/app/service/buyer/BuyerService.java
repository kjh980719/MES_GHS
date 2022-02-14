package mes.app.service.buyer;


import java.util.List;
import java.util.Map;
import mes.app.mapper.buyer.BuyerMapper;
import mes.app.mapper.supply.SupplyMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class BuyerService {

	@Autowired
	private BuyerMapper buyerMapper;

	public List<Map> getBuyerMemberList(Map param) {
		return buyerMapper.getBuyerMemberList(param);
	}

	public void buyerMemberInsertAccount(Map map) {
		buyerMapper.buyerMemberInsertAccount(map);
	}

	public void buyerMemberUpdateAccount(Map map) {
		buyerMapper.buyerMemberUpdateAccount(map);
	}
}
