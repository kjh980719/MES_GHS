package mes.security.controller;

import mes.security.UserInfo;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import mes.app.util.Util;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class SecurityController {

  @RequestMapping("/shop/login.do")
  public String loginRequired(HttpServletRequest request, ModelMap model, @ModelAttribute("reqUrl") String reqUrl) {
    UserInfo user = Util.getUserInfo();
    if(user != null){  // 사용자로 로그인 되어 있을 경우에만 main페이지로 이동시킴
      return "redirect:/shop/main.do";
    }
    return "join:/login/loginOpen";
  }

}
