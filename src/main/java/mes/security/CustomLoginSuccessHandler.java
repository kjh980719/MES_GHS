package mes.security;

import mes.app.util.Util;
import mes.common.service.APISend;
import mes.config.PropertyConfig;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;


public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler {

    private String LOGIN_SUCCESS_URL;

    public CustomLoginSuccessHandler(){}

    public CustomLoginSuccessHandler(String LOGIN_SUCCESS_URL){
        this.LOGIN_SUCCESS_URL = LOGIN_SUCCESS_URL;
    }

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
        UserInfo user =  (UserInfo) authentication.getPrincipal();
        JSONObject json = new JSONObject();
        json.put("seq", user.getManagerSeq());
        json.put("id", user.getManagerId());
        json.put("name", user.getManagerName());
        Cookie cookie = new Cookie("mCookie", URLEncoder.encode(json.toJSONString(), "utf-8"));
        cookie.setDomain("mes.thethe.co.kr");
        cookie.setMaxAge(12*60*60);
        response.addCookie(cookie);

        if(PropertyConfig.SERVER_TYPE.equals("prod")){
            APISend apiSend = new APISend();
            apiSend.sendLog("접속",0, request.getRemoteAddr(), user.getManagerId());
        }

        response.sendRedirect(LOGIN_SUCCESS_URL);

    }

}
