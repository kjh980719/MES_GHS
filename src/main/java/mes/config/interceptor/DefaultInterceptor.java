package mes.config.interceptor;

import mes.common.model.MenuItem;
import mes.config.WebSecurityConfig;
import mes.security.UserInfo;
import org.springframework.http.HttpMethod;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

@Component
public class DefaultInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {


		if(!"XMLHttpRequest".equals(request.getHeader("x-requested-with"))) {
			String menuId = "";
			List<MenuItem> allowMenus = (List<MenuItem>) ((UserInfo) SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getAllowedMenuMap().get(WebSecurityConfig.MES_MENU);
			
			MenuItem selectedMenu = null;
			setAllMenuSelectedFalse(allowMenus);
			if(allowMenus != null) {
				selectedMenu = findMenuItemByURI(request.getRequestURI(), allowMenus);

				setParentMenuSelectedTrue(selectedMenu, allowMenus);
			}
		//	if(selectedMenu == null)
		//		throw new NoHandlerFoundException(HttpMethod.GET.toString(), request.getRequestURI(), null);

		}
		return super.preHandle(request, response, handler);
	}

	public MenuItem findMenuItemByURI(String requestURI, List<MenuItem> allowMenus) {
		if(allowMenus != null) {
			for(MenuItem menuItem : allowMenus) {
				if(menuItem.getProgramUrl().equals(requestURI)) {
					return menuItem;
				}
			}
		}
		return null;
	}

	private void setParentMenuSelectedTrue(MenuItem child, List<MenuItem> allowMenus) {
		if(child != null) {
			child.setSelected(true);
			if(child.getParentMenuSeq() > 0) {
				MenuItem parentMenu = findMenuItemBySeq(child.getParentMenuSeq(), allowMenus);
				setParentMenuSelectedTrue(parentMenu, allowMenus);
			}
		}
	}

	private MenuItem findMenuItemBySeq(int parentMenuSeq, List<MenuItem> allowMenus) {
		for(MenuItem menuItem : allowMenus) {
			if(parentMenuSeq == menuItem.getMenuSeq())
				return menuItem;
		}
		return null;
	}

	private void setAllMenuSelectedFalse(List<MenuItem> allowMenus) {
		if(allowMenus != null) {
			for(MenuItem menuItem : allowMenus) {
				menuItem.setSelected(false);
			}
		}
	}

}
