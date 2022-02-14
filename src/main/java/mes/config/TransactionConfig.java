package mes.config;

import com.zaxxer.hikari.HikariDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

/**
 * @brief main db mybatis �뿰寃곗꽕�젙
 */
@Configuration
@EnableTransactionManagement
public class TransactionConfig
{
	@Autowired
	private Environment env;

	@Bean
	@ConfigurationProperties(prefix = "spring.datasource")
	public DataSource mainDataSource() {
		HikariDataSource ds = (HikariDataSource) DataSourceBuilder.create().build();
		ds.setConnectionTestQuery("SELECT 1");		
		return ds;
	}

	@Bean
	public SqlSessionFactory mainMybatisSqlSessionFactory(
			@Qualifier("mainDataSource") DataSource mainDataSource,
			ApplicationContext applicationContext) throws Exception {
		SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
		sqlSessionFactoryBean.setDataSource(mainDataSource);
		sqlSessionFactoryBean.setMapperLocations(applicationContext.getResources("classpath:com/mes/bid/mapper/*.xml"));
		SqlSessionFactory sqlSessionFactory = sqlSessionFactoryBean.getObject();
		sqlSessionFactory.getConfiguration().setMapUnderscoreToCamelCase(true);
		return sqlSessionFactoryBean.getObject();
	}

	@Bean(name = "mainSession")
	public SqlSessionTemplate mainMybatisSqlSessionTemplate(@Qualifier("mainMybatisSqlSessionFactory") SqlSessionFactory mainMybatisSqlSessionFactory) throws Exception {
		return new SqlSessionTemplate(mainMybatisSqlSessionFactory);
	}

}


