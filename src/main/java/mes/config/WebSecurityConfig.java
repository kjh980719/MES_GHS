package mes.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

import mes.security.CustomLoginFailHandler;
import mes.security.CustomLoginSuccessHandler;
import mes.security.CustomLogoutSuccessHandler;
import mes.security.authentication.CustomLoginUrlAuthenticationEntryPoint;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
	public static final String LOGIN_PAGE = "/login";
	public static final String LOGIN_PROCESS_URL = "/loginProcess";
	public static final String LOGIN_SUCCESS_URL = "/index";
	public static final String USERNAME_PARAM_NAME = "managerId";
	public static final String PASSWORD_PARAM_NAME = "password";
	public static final String MES_MENU = "MES_MENU";
	
	@Autowired
    AuthenticationProvider customAuthenticationProvider;
	@Autowired
    LoginUrlAuthenticationEntryPoint loginUrlAuthenticationEntryPoint;

	@Override
	public void configure(WebSecurity web) throws Exception {
		web
			.ignoring()
				.antMatchers("/favicon.ico", "/se2/**", "/css/**", "/js/**", "/images/**", "/pdf/**")
		;
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http
			.headers()
				.frameOptions().sameOrigin() //Spring Security �뒗 �뵒�뤃�듃濡� iframe �궗�슜�쓣 留됯퀬 �엳�떎. �룞�씪�븳 �룄硫붿씤�씪 寃쎌슦 �뿀�슜�븯�룄濡� �꽕�젙.
				.and()
			.csrf()
				.disable()
			.authorizeRequests()
				.antMatchers(LOGIN_PAGE).permitAll()
				.antMatchers("/**").authenticated()
				.antMatchers("/**").hasRole("USER")
				.anyRequest().authenticated()
				.and()
			.formLogin()
				.usernameParameter(USERNAME_PARAM_NAME)
				.passwordParameter(PASSWORD_PARAM_NAME)
                .loginPage(LOGIN_PAGE).permitAll()
                .loginProcessingUrl(LOGIN_PROCESS_URL).permitAll()
				.defaultSuccessUrl(LOGIN_SUCCESS_URL, true)
                .successHandler(new CustomLoginSuccessHandler(LOGIN_SUCCESS_URL))
                .failureHandler(new CustomLoginFailHandler(LOGIN_SUCCESS_URL))
//                .permitAll()
                .and()
            .logout()
            	.logoutUrl("/logout")
//            	.addLogoutHandler(new CustomLogoutHandler())
//            	.logoutSuccessHandler(new CustomLogoutSuccessHandler(LOGOUT_SUCCESS_URL))
				.logoutSuccessHandler(new CustomLogoutSuccessHandler())
                .permitAll()
                .and()	                
            .exceptionHandling()
                .authenticationEntryPoint(loginUrlAuthenticationEntryPoint)         
//            	.accessDeniedHandler(new CustomAccessDeniedHandler(ACCESS_DENIED_ERROR_URL))
            	.and()
            .sessionManagement()
            	//.maximumSessions(1)
            	.and()
         ;
	}

	/**
	 * session expired 諛쒖깮�떆 �빖�뱾�윭
	 */
	@Bean
	public LoginUrlAuthenticationEntryPoint loginUrlAuthenticationEntryPoint() {
		LoginUrlAuthenticationEntryPoint loginUrlAuthenticationEntryPoint = new CustomLoginUrlAuthenticationEntryPoint(LOGIN_PAGE);
		return loginUrlAuthenticationEntryPoint;
	}

/*
	@Bean
	public AuthenticationSuccessHandler authenticationSuccessHandler() {
		AuthenticationSuccessHandler authenticationSuccessHandler = new CustomSavedRequestAwareAuthenticationSuccessHandler(LOGIN_SUCCESS_URL);
		return authenticationSuccessHandler;
	}
*/

	/**
	 * �궗�슜�옄 �씤利� 愿��젴 �꽕�젙
	 */
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		//而ㅼ뒪���븳 AuthenticationProvider �꽕�젙.
		auth.authenticationProvider(customAuthenticationProvider);
	}
}
