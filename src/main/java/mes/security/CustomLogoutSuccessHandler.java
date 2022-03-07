package mes.security;


import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {

  private final String LOGOUT_SUCCESS_URL = "/";

  @Override
  public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
    String mb_type = request.getParameter("mb_type");
    if (mb_type == null) {
      response.sendRedirect(LOGOUT_SUCCESS_URL);
      return;
    } else if (mb_type.equals("M")) {
      request.setAttribute("menuSeq", null);
      response.sendRedirect("/master/login.do");
    } else if (mb_type.equals("C") || mb_type.equals("P")) {
      response.sendRedirect(LOGOUT_SUCCESS_URL);
    } else {
      response.sendRedirect(LOGOUT_SUCCESS_URL);
    }
  }
}
