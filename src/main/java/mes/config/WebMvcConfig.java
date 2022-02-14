package mes.config;

import mes.config.interceptor.DefaultInterceptor;
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

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/css/**", "/images/**", "/js/**", "/se2/**", "/c-market/**", "/daum_editor/**", "/editor/**")
				.addResourceLocations("/css/", "/images/", "/js/", "/se2/", "/c-market/", "/daum_editor/", "/editor/");
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	/**
	 * json �쓣 �젣�쇅�븳 紐⑤뱺 而⑦듃濡ㅻ윭�쓽 �씤�꽣�뀎�꽣. �꽑�깮�븳 硫붾돱瑜� 醫뚯륫 硫붾돱援ъ“�뿉�꽌 �솢�꽦�솕瑜� �쐞�븳 �옉�뾽�벑�쓣 �떞�떦�븳�떎.
	 */
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		WebContentInterceptor wci = new WebContentInterceptor();
		wci.setCacheSeconds(0);
		registry.addInterceptor(wci);
		registry.addInterceptor(new DefaultInterceptor()).excludePathPatterns(
				"/*/*.json"
				,"/favicon.ico"
				, "/se2/**"
				, "/css/**"
				, "/js/**"
				, "/images/**"
				, "/common/**"
				, "/login"
				, "/error"
				, "/determineDefaultUrl"
				, "/index"
				, "/memo/**"
				, "/c-market/**"
				, "/showImage/**"
				, "/daum_editor/**"
				, "/editor/**"
				, "/pdftest"
				, "/pdf/**"
				, "/"

		);
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
	public TilesConfigurer tilesConfigurer(){
		TilesConfigurer tilesConfigurer = new TilesConfigurer();
		tilesConfigurer.setDefinitions(new String[] {"/WEB-INF/views/tiles/tiles.xml"});
		tilesConfigurer.setCheckRefresh(true);
		return tilesConfigurer;
	}

	@Bean
	public MessageSource messageSource(){
		ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
		messageSource.setBasename("classpath:/messages/message");
		messageSource.setDefaultEncoding("UTF-8");
		messageSource.setCacheSeconds(10);
		return messageSource;
	}

}
