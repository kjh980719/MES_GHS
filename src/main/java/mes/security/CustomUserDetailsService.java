package mes.security;


import mes.app.mapper.HomeMapper;
import mes.app.mapper.LoginMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

	@Autowired
	LoginMapper loginMapper;

	public UserDetails loadUserByUsername(String managerId) {
		return loginMapper.Manager_List_For_Login_S1_Str(managerId);
	}


}
