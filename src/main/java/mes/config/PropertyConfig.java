package mes.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

@Component
public class PropertyConfig{

    public static String SERVER_TYPE;

    @Value("${spring.profiles.active}")
    public void setServerType(String value) {
        SERVER_TYPE = value;
    }

}
