package mes.security.authentication;

import mes.config.WebSecurityConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;

public class CustomLoginUrlAuthenticationEntryPoint extends LoginUrlAuthenticationEntryPoint {

	@Autowired
	private MessageSource messageSource;

	public CustomLoginUrlAuthenticationEntryPoint(String loginFormUrl) {
		super(loginFormUrl);
	}

	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {
		response.setContentType("text/html; charset=UTF-8");
		response.setStatus(HttpStatus.UNAUTHORIZED.value());
		boolean ajaxFlag = false;
		if( "XMLHttpRequest".equals(request.getHeader("x-requested-with")) ) {
			ajaxFlag = true;
		}
		if(ajaxFlag) {
			//ajax request�뿉 ���븳 �꽭�뀡 醫낅즺硫붿떆吏��뒗 commonScript.js ajaxSetup() �뿉�꽌 蹂댁뿬以��떎.
			response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
		} else {
			PrintWriter out = response.getWriter();
			if(request.getRequestURI().equals("/")) {
				out.println("<script language='javascript' type='text/javascript'>location.href='" + WebSecurityConfig.LOGIN_PAGE + "';</script>");
			}else {
				out.println("<script language='javascript' type='text/javascript'>alert('" + messageSource.getMessage("fail.common.session.expired", null, Locale.getDefault()) + "');location.href='" + WebSecurityConfig.LOGIN_PAGE + "';</script>");
			}
			out.flush();
		}
	}
}
