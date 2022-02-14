package mes.security.controller;

import mes.app.util.Util;
import mes.common.model.MenuItem;
import mes.config.WebSecurityConfig;
import mes.security.UserInfo;
import org.json.simple.JSONObject;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.jws.soap.SOAPBinding;
import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
public class SecurityController {


    @RequestMapping(value = WebSecurityConfig.LOGIN_PAGE)
    public String loginRequired(HttpServletRequest request) {
        return "/login";
    }



    @RequestMapping(value = WebSecurityConfig.LOGIN_SUCCESS_URL)
    public String determineDefaultUrl(HttpServletRequest request) {
        List<MenuItem> allowMenus = (List<MenuItem>) ((UserInfo) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getAllowedMenuMap().get(WebSecurityConfig.MES_MENU);
       
		
		// 첫번째 메뉴를 default 로 
		for (MenuItem menuItem : allowMenus) {
			if (!menuItem.getProgramUrl().equals("")) {
				return "redirect:" + menuItem.getProgramUrl();
			}
		}

		UserInfo user = ((UserInfo) SecurityContextHolder.getContext().getAuthentication().getPrincipal());

        return "redirect:/";
    }

}
