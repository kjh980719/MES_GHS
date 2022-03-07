package mes.config;

import mes.config.interceptor.DefaultInterceptor;
import mes.config.interceptor.LoginInterceptor;
import mes.config.interceptor.ShopInterceptor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.accept.ContentNegotiationManager;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.mvc.WebContentInterceptor;
import org.springframework.web.servlet.view.ContentNegotiatingViewResolver;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesViewResolver;

import java.util.ArrayList;
import java.util.List;

@Configuration
@EnableWebMvc
public class WebMvcConfig implements WebMvcConfigurer {

	@Value("${default.upload.folder}")
	private String DefaultPath;

	@Bean
	public DefaultInterceptor defaultInter() {
		return new DefaultInterceptor();
	}

	@Autowired
	private ShopInterceptor sInterceptor;

	@Autowired
	private LoginInterceptor loginInterceptor;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/css/**", "/summernote/**", "/img/**", "/images/**", "/js/**", "/se2/**", "/shop/**", "/erp/**", "/excelDownload/**",
				"/innopayResource/**\", \"/downloadItems/**", "/home/upload/shopfile/summernote/**", "/favicon.ico")
				.addResourceLocations("/css/", "/summernote/", "/img/", "/images/", "/js/", "/se2/", "/shop/", "/erp/", "/excelDownload/", "/innopayResource/", "/downloadItems/",
						"/home/upload/shopfile/summernote/");    // 임시로 함
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	/**
	 * json 을 제외한 모든 컨트롤러의 인터셉터. 선택한 메뉴를 좌측 메뉴구조에서 활성화를 위한 작업등을 담당한다.
	 */
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		WebContentInterceptor wci = new WebContentInterceptor();
		wci.setCacheSeconds(0);
		registry.addInterceptor(wci);
		registry.addInterceptor(new DefaultInterceptor()).excludePathPatterns(
				"/*/*.json"
				, "/favicon.ico"
				, "/se2/**"
				, "/css/**"
				, "/**/css/**"
				, "/js/**"
				, "/img/**"
				, "/images/**"
				, "/common/**"
				, "/error"
				, "/shop/**"
				, "/erp/**"
				, "/master/**"
				, "/excelDownload/**"
				, "/innopayResource/**"
				, "/downloadItems/**"
		);

		registry.addInterceptor(sInterceptor).excludePathPatterns("/shop/member/**", "/board/**", "/master/**", "/**/css/**", "/css/**", "/**/font/**", "/shop/login.do")
				.addPathPatterns("/shop/**");    // shop 들어갈 때 shopInterceptor 거치기
		registry.addInterceptor(loginInterceptor).addPathPatterns("/shop/**").addPathPatterns("/master/**")
				.excludePathPatterns("/shop/login.do", "/**/css/**", "/css/**", "/master/login.do", "/favicon.ico", "/board/**", "/shop/member/**");
	}

	@Bean
	public ViewResolver contentNegotiatingViewResolver(ContentNegotiationManager manager) {
		ContentNegotiatingViewResolver resolver = new ContentNegotiatingViewResolver();
		resolver.setContentNegotiationManager(manager);

		// Define all possible view resolvers
		List<ViewResolver> resolvers = new ArrayList<ViewResolver>();

		resolvers.add(tilesViewResolver());
		resolver.setViewResolvers(resolvers);
		return resolver;
	}

	@Bean
	public ViewResolver tilesViewResolver() {
		TilesViewResolver viewResolver = new TilesViewResolver();
		viewResolver.setOrder(1);
		return viewResolver;
	}

	@Bean
	public TilesConfigurer tilesConfigurer() {
		TilesConfigurer tilesConfigurer = new TilesConfigurer();
		tilesConfigurer.setDefinitions(new String[]{"/WEB-INF/views/tiles/tiles.xml"});
		tilesConfigurer.setCheckRefresh(true);
		return tilesConfigurer;
	}

	@Bean
	public MessageSource messageSource() {
		ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
		messageSource.setBasename("classpath:/messages/message");
		messageSource.setDefaultEncoding("UTF-8");
		messageSource.setCacheSeconds(10);
		return messageSource;
	}
}
