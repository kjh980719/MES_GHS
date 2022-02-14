package mes.security.authentication;

import mes.app.mapper.LoginMapper;
import mes.config.WebSecurityConfig;
import mes.security.UserInfo;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * UsernamePasswordAuthenticationFilter
 */
@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

	@Autowired
	private UserDetailsService detailsService;

	@Autowired
	private MenuLoaderService menuLoaderService;

	@Autowired
	private LoginMapper loginMapper;

	@Autowired
	private PasswordEncoder passwordEncoder;

	@Autowired
	private MessageSource messageSource;

	@Override
	public boolean supports(Class<?> authentication) {
		return authentication.equals(UsernamePasswordAuthenticationToken.class);
	}

	@Override
	public Authentication authenticate(Authentication authentication) throws AuthenticationException {
		Map paramMap = new HashMap();
		String managerId = authentication.getName();
		String password = managerId + "_" + authentication.getCredentials().toString();
		UserInfo user = (UserInfo) detailsService.loadUserByUsername(managerId);
		if(user == null) {
			throw new BadCredentialsException(messageSource.getMessage("fail.common.login", null, Locale.getDefault()));
		} else if(user.getUseYn().equals("N")) {
			throw new BadCredentialsException(messageSource.getMessage("fail.common.login", null, Locale.getDefault()));
		} else if(user.getGroupUseYn().equals("N")) {
			throw new BadCredentialsException(messageSource.getMessage("fail.common.auth.group", null, Locale.getDefault()));
		} else if(user.getLoginFailCount() > 4) {
			throw new BadCredentialsException(messageSource.getMessage("fail.common.account.lock", null, Locale.getDefault()));
		} else if(!passwordEncoder.matches(password, user.getPassword())) {
			paramMap.put("managerId", managerId);
			paramMap.put("loginFailCount", user.getLoginFailCount() + 1);
			loginMapper.Manager_List_For_FailCount_U1_Str(paramMap);
			throw new BadCredentialsException(messageSource.getMessage("fail.common.pwd.diffrent", Arrays.asList(user.getLoginFailCount() + 1).toArray(), Locale.getDefault()));
		}
		paramMap.put("managerId", managerId);
		paramMap.put("loginFailCount", 0);
		loginMapper.Manager_List_For_FailCount_U1_Str(paramMap);
		
		user.getAllowedMenuMap().put(WebSecurityConfig.MES_MENU, menuLoaderService.setUserMenu(user));

		List<GrantedAuthority> userAuthorities = new ArrayList<GrantedAuthority>();
		//湲곕낯 role �쓣 �꽭�똿
		userAuthorities.add((GrantedAuthority)new SimpleGrantedAuthority("ROLE_USER"));	//濡쒓렇�씤�쑀��
		user.setAuthorities(userAuthorities);

		return new UsernamePasswordAuthenticationToken(user, "", user.getAuthorities());
	}


}
