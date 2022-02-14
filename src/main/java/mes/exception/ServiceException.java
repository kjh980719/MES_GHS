package mes.exception;

public class ServiceException extends RuntimeException
{
	private String errorCode;
	private String errorMsg;
	private Object[] rep;
	private Object details;
	/**
	 * �깮�꽦�옄 - 湲곕낯
	 */
	public ServiceException() 
	{
		
	}

	/**
	 * �깮�꽦�옄 - 肄붾뱶
	 */
	public ServiceException(String errorCode)
	{
		this.errorCode = errorCode;
	}

	/**
	 * �깮�꽦�옄 - 肄붾뱶 + 硫붿떆吏�
	 */
	public ServiceException(String errorCode, String errorMsg)
	{
		this.errorCode = errorCode;
		this.setErrorMsg(errorMsg);
	}
	
	/**
	 * �깮�꽦�옄 - 肄붾뱶 + 移섑솚 臾몄옄 諛곗뿴
	 */
	public ServiceException(String errorCode, Object[] rep)
	{
		this.errorCode = errorCode;
		this.setRep(rep);
	}

	/**
	 * �깮�꽦�옄 - 肄붾뱶 + 硫붿떆吏� + 移섑솚 臾몄옄 諛곗뿴
	 */
	public ServiceException(String errorCode, String errorMsg, Object[] rep)
	{
		this.errorCode = errorCode;
		this.setErrorMsg(errorMsg);
		this.setRep(rep);
	}
	
	/**
	 * �깮�꽦�옄 - �떎瑜� �삁�쇅 以묒젒
	 */
	public ServiceException(Throwable th)
	{
		super(th);
	}
	
	/**
	 * �긽�꽭 �젙蹂� 異붽�
	 */
	public void setDetails(Object details) {
		this.details = details;
	}
	
	public Object getDetails() {
		return this.details;
	}

	/**
	 * �삁�쇅 硫붿떆吏� 媛��졇�삤湲�
	 */
	public String getCode()
	{	
		return this.errorCode;
	}
	
	/**
	 * static - 理쒖큹 諛쒖깮 �삁�쇅 李얘린
	 */
	public static Throwable getRootCause(Throwable ex)
	{
		Throwable cause = ex.getCause();
		Throwable rootCause = cause==null?ex:null;
		while(cause != null)
		{
			rootCause = cause;
			cause = cause.getCause();
		}
		return rootCause;
	}

	public Object[] getRep() {
		return rep;
	}

	public void setRep(Object[] rep) {
		this.rep = rep;
	}

	public String getErrorMsg() {
		return errorMsg;
	}

	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}	
}
