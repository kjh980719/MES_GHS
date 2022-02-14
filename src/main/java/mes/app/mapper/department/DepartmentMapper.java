package mes.app.mapper.department;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@Mapper
public interface DepartmentMapper {
    
   

	public List<Map> departmentList(Map paramMap);

	public int departmentListTotal(Map paramMap) ;
	
	public void createDepartment(Map paramMap);
	public Map departmentInfo(Map paramMap);
	public void editDepartment(Map paramMap);

	
	//팝업용
	public List<Map> employeeList(Map paramMap);
	public int employeeListTotal(Map paramMap) ;
	
	public int employeeInsert(Map paramMap);
}
