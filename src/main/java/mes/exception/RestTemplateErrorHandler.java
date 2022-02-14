package mes.exception;

import org.springframework.http.client.ClientHttpResponse;
import org.springframework.web.client.ResponseErrorHandler;

import java.io.IOException;

public class RestTemplateErrorHandler implements ResponseErrorHandler {

	public boolean hasError(ClientHttpResponse response) throws IOException{
		return false;
	}

	public void handleError(ClientHttpResponse response) throws IOException{

	}
}
