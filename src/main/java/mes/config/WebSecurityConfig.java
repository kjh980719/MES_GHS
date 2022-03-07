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
import org.springframework.web.context.request.RequestContextListener;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {
	public static final String ADMIN_LOGIN_PAGE = "/master/login.do";
	public static final String LOGIN_PAGE = "/shop/login.do";
	public static final String LOGIN_PROCESS_URL = "/shop/member/loginProc.do";
	public static final String ADMIN_LOGIN_SUCCESS_URL = "/master/main.do";
	public static final String LOGIN_SUCCESS_URL = "/shop/main.do";
	public static final String USERNAME_PARAM_NAME = "memberId";
	public static final String PASSWORD_PARAM_NAME = "memberPass";
	@Autowired
	AuthenticationProvider customAuthenticationProvider;
	@Autowired
	LoginUrlAuthenticationEntryPoint loginUrlAuthenticationEntryPoint;

	@Override
	public void configure(WebSecurity web) throws Exception {
		web
				.ignoring()
				.antMatchers("/favicon.ico", "/se2/**", "/css/**", "/summernote/**", "/js/**", "/img/**", "/images/**", "/logo/**", "/innopayResource/**"
				)
		;
	}

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http
				.headers()
				.frameOptions().sameOrigin() //Spring Security 는 디폴트로 iframe 사용을 막고 있다. 동일한 도메인일 경우 허용하도록 설정.
				.and()
				.headers(headers -> headers.cacheControl(cache -> cache.disable()))
				.csrf()
				.disable()

				.authorizeRequests()
				.antMatchers("/temp").permitAll()
				.antMatchers("/api/**").permitAll()
				.antMatchers("/shop/member/**").permitAll()
//				.antMatchers("/shop/**").hasAnyRole("USER", "ADMIN") // 임시로 모두허용
				.antMatchers("/shop/**").hasRole("USER")
				.antMatchers("/master/login.do").hasAnyRole("USER", "ADMIN")
				.antMatchers("/mater/**").hasRole("ADMIN")
				.antMatchers(LOGIN_PAGE).permitAll()
				.antMatchers(ADMIN_LOGIN_PAGE).permitAll()
				.antMatchers("/board/**").permitAll()
				.antMatchers("/fileDownloadPath.do").permitAll()
//				.antMatchers("/shop/main.do").hasRole("USER")
//				.antMatchers("/").hasRole("USER")
//				.antMatchers("/shop/mypage/**").hasAnyRole("USER", "ADMIN")
				.anyRequest().authenticated()
				.and()
				.formLogin()
				.usernameParameter(USERNAME_PARAM_NAME)
				.passwordParameter(PASSWORD_PARAM_NAME)
				.loginPage(LOGIN_PAGE).permitAll()
				.loginProcessingUrl(LOGIN_PROCESS_URL).permitAll()
//				.defaultSuccessUrl(LOGIN_SUCCESS_URL, true)
				.successHandler(new CustomLoginSuccessHandler())
				.failureHandler(new CustomLoginFailHandler())
//                .permitAll()
				.and()
				.logout()
				.logoutUrl("/logout")
				.invalidateHttpSession(true)
				.deleteCookies("JSESSIONID")
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
	 * session expired 발생시 핸들러
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
	 * 사용자 인증 관련 설정
	 */
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		//커스텀한 AuthenticationProvider 설정.
		auth.authenticationProvider(customAuthenticationProvider);
	}

	@Bean
	public RequestContextListener requestContextListener(){
		return new RequestContextListener();
	}

}
