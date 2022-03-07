package mes.security.authentication;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import mes.app.mapper.user.common.LoginMapper;
import mes.app.util.StringUtil;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * UsernamePasswordAuthenticationFilter
 */
@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

  @Autowired
  private LoginMapper loginMapper;

  @Autowired
  private MessageSource messageSource;

  @Autowired
  MenuLoaderService menuLoaderService;

	private String pattern = "([a-z0-9\\w-]+\\.*)+[a-z0-9]{2,4}";

  @Override
  public boolean supports(Class<?> authentication) {
    return authentication.equals(UsernamePasswordAuthenticationToken.class);
  }

  @Override
  public Authentication authenticate(Authentication authentication) throws AuthenticationException {
    String memberId = authentication.getName();
    UserInfo user = null;
    UserInfo muser = null;

    ServletRequestAttributes attr = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();

    String type = attr.getRequest().getParameter("type");

    user = (UserInfo) loginMapper.selectMemberInfo(memberId, BCrypt.hashpw(authentication.getCredentials().toString(), BCrypt.gensalt()), type);
    String password = authentication.getCredentials().toString();
    if (user == null) {
      throw new BadCredentialsException(messageSource.getMessage("fail.common.login", null, Locale.getDefault()));
    } else if (!password.matches(StringUtil.isNullToString(user.getPassword()))) {
      throw new BadCredentialsException(messageSource.getMessage("fail.common.pwd.diffrent", null, Locale.getDefault()));
    }

    List<GrantedAuthority> userAuthorities = new ArrayList<GrantedAuthority>();

    String mbName = "";

    //기본 role 을 세팅
		loginMapper.uptMbrAcsRec(user.getMbCd());
		userAuthorities.add((GrantedAuthority) new SimpleGrantedAuthority("ROLE_USER"));  //로그인유저
		user.setAuthorities(userAuthorities);

    return new UsernamePasswordAuthenticationToken(user, "", user.getAuthorities());
  }

}
