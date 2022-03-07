package mes.security.authentication;

import mes.app.mapper.user.common.LoginMapper;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MenuLoaderService {

	@Autowired
	private LoginMapper loginMapper;

	public List setUserMenu(UserInfo user) {
		return loginMapper.Manager_Menu_S4_Str(user.getAuthGroupSeq());
	}
}
