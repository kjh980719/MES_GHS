package mes.common.controller.adviser;

import mes.config.WebSecurityConfig;
import mes.exception.ServiceException;
import mes.common.model.JsonResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.NoSuchMessageException;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Locale;

/**
 * 같은 컨텍스트 내에 모든 컨트롤러에서 발생한 예외를 처리하는 리졸버. 
 * 각각의 컨트롤러에서 @ExceptionHandler 가 붙은 메서드가 있으면 그것이 우선함.
 */
@ControllerAdvice
public class ExceptionResolver {
	public static final String DEFAULT_ERROR_VIEW = "error";

    @Autowired
    private MessageSource messageSource;
	/**
	 * @param e
	 * @return
	 * @throws NoSuchMessageException
	 * @throws IOException
	 */
	@ExceptionHandler(Exception.class)
	@ResponseBody
	public Object defaultErrorHandler(HttpServletRequest request, HttpServletResponse response, Exception e) throws IOException {
		e.printStackTrace();
		response.setContentType("text/html; charset=UTF-8");
		String message = e.getCause()==null?e.getMessage():e.getCause().getMessage();
		String fieldName = "";
		if(e instanceof NoHandlerFoundException) {	//404
			message = messageSource.getMessage("fail.find.page", null, Locale.getDefault());
		} else if(e instanceof AuthenticationServiceException) {
			PrintWriter out = response.getWriter();
			out.println("<script language='javascript' type='text/javascript'>alert('" + e.getMessage() + "');location.href='" + WebSecurityConfig.LOGIN_PAGE + "';</script>");
			out.flush();
			return null;
/*
		} else if(e instanceof DuplicateKeyException) {
			message = messageSource.getMessage("fail.common.sql.dup", null, Locale.getDefault());
		} else if(e instanceof DataIntegrityViolationException) {
			message = messageSource.getMessage("fail.common.sql.toolong", null, Locale.getDefault());
		} else if(e instanceof DataAccessException) {
			message = messageSource.getMessage("fail.common.db", null, Locale.getDefault());
*/
		} else if(e instanceof SQLException) {
			Object[] rep = {((SQLException) e).getSQLState(), e.getMessage()};
			message = messageSource.getMessage("fail.common.sql", rep, Locale.getDefault());
			//message = messageSource.getMessage("fail.common.db", null, Locale.getDefault());
		} else if(e instanceof MethodArgumentNotValidException) {
			message = ((MethodArgumentNotValidException) e).getBindingResult().getAllErrors().get(0).getDefaultMessage();
			fieldName = ((MethodArgumentNotValidException) e).getBindingResult().getFieldErrors().get(0).getField();
		} else if(e instanceof ServiceException) {
			//메시지가 이미 있으면 메시지 우선, 코드가 있으면 코드로 메시지를 찾는다.
			message = ((ServiceException) e).getErrorMsg() != null ? ((ServiceException) e).getErrorMsg() : getMessage((ServiceException) e);
		}
		if( "XMLHttpRequest".equals(request.getHeader("x-requested-with")) ) {
			return JsonResponse.asFailure(fieldName, message);
		} else {
			ModelAndView mav = new ModelAndView();
			mav.setViewName(DEFAULT_ERROR_VIEW);
		    mav.addObject("exception", message);
		    mav.addObject("url", request.getRequestURL());
		    return mav;
		}
	}

	/**
	 * 예외 메시지 가져오기
	 */
	public String getMessage(ServiceException e) {
		String message = messageSource.getMessage(e.getCode(), e.getRep(), Locale.getDefault());
		if(StringUtils.isEmpty(message)) {
			return messageSource.getMessage("fail.common.msg", null, Locale.getDefault());
		}
		return message;
	}
	
}
