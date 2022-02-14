package mes.security;


import mes.common.service.APISend;
import mes.config.PropertyConfig;
import org.omg.PortableServer.REQUEST_PROCESSING_POLICY_ID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class CustomLogoutSuccessHandler implements LogoutSuccessHandler {


    private final String LOGOUT_SUCCESS_URL = "/";

    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {

        Cookie cookie = new Cookie("mCookie", "");
        cookie.setMaxAge(0);
        cookie.setDomain("mes.thethe.co.kr");
        response.addCookie(cookie);

        UserInfo user =  (UserInfo) authentication.getPrincipal();

        if(PropertyConfig.SERVER_TYPE.equals("prod")){
            APISend apiSend = new APISend();
            apiSend.sendLog("종료",0, request.getRemoteAddr(),user.getManagerId());
        }

        response.sendRedirect(LOGOUT_SUCCESS_URL);
    }
}
