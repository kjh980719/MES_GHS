package mes.security;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mes.app.util.Util;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;


public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

  @Override
  public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
    HttpSession session = request.getSession();

    session.setAttribute("mbCd", Util.getUserInfo().getMbCd());
    session.setAttribute("mbType", Util.getUserInfo().getMbType());
    session.setAttribute("mbAuth", Util.getUserInfo().getMbAuthYn());

    String idsave = null;

    if (request.getParameter("memSaveId") == null) {
      idsave = "N";
    } else {
      idsave = request.getParameter("memSaveId");
    }

    try {
      Cookie[] cookies = request.getCookies();
      Cookie enCookie = null;
      for (Cookie c : cookies) {
        if ("memSaveId".equals(c.getName())) {
          enCookie = c;
        }
      }
      if (idsave.equals("Y")) {
        Cookie cookie = new Cookie("memSaveId", "");
        cookie = new Cookie("memSaveId", Util.getUserInfo().getMemberId());
        cookie.setMaxAge(8 * 60 * 60);
        cookie.setPath("/shop/");
        response.addCookie(cookie);
      } else {
        Cookie cookie = new Cookie("memSaveId", "");
        cookie.setMaxAge(0);
        cookie.setPath("/shop/");
        response.addCookie(cookie);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    String reqUrl = request.getParameter("reqUrl");
    if (reqUrl != null && reqUrl.length() > 0) {
      response.sendRedirect(request.getParameter("reqUrl"));
    } else {
        response.sendRedirect("/");
        return;
    }
  }

}
