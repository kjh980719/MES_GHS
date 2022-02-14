package mes.app.controller.adviser;

import mes.security.UserInfo;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.InitBinder;

import java.util.List;
import java.util.Map;

/**
 * @author jklee
 * parameter 瑜� Map �뿉 �떞�쓣�븣 managerSeq�쓣 二쇱엯�븳�떎.
 */
@ControllerAdvice
public class BindAdviser {

    public static final String LOGIN_USER_SEQ = "loginUserSeq";
    public static final String LOGIN_USER_ID = "loginUserId";

    @InitBinder
    public void customizeBinding(WebDataBinder binder) {
        if (SecurityContextHolder.getContext().getAuthentication() != null) {
            Object obj = binder.getTarget();
            if (obj instanceof Map) {
                setManagerSeq((Map) obj);
            } else if (obj instanceof Map[]) {
                for (int i = 0; i < ((Map[]) obj).length; i++) {
                    setManagerSeq(((Map[]) obj)[i]);
                }
            } else if (obj instanceof List) {
                for (Object o : (List) obj) {
                    if (o instanceof Map) {
                        setManagerSeq((Map) o);
                    }
                }
            }
        }
    }

    public void setManagerSeq(Map map) {
        map.put(LOGIN_USER_SEQ, ((UserInfo)SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getManagerSeq());
        map.put(LOGIN_USER_ID, ((UserInfo)SecurityContextHolder.getContext().getAuthentication().getPrincipal()).getManagerId());
    }
}
