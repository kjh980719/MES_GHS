package mes.security;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;


public class CustomLoginFailHandler implements AuthenticationFailureHandler {

    private String LOGIN_SUCCESS_URL;

    public CustomLoginFailHandler(){}

    public CustomLoginFailHandler(String LOGIN_SUCCESS_URL){
        this.LOGIN_SUCCESS_URL = LOGIN_SUCCESS_URL;
    }

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();

		out.println("<script>alert('"+exception.getMessage()+"'); location.href='/login';</script>");
	}
}
