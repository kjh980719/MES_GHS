package mes.app.service.department;


import mes.app.mapper.department.DepartmentMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class DepartmentService {

    @Autowired
    private DepartmentMapper departmentMapper;

  
    public List<Map> departmentList(Map paramMap) {
        return departmentMapper.departmentList(paramMap);
    }
    
    public int departmentListTotal(Map paramMap) {
        return departmentMapper.departmentListTotal(paramMap);
    }
    
    public void createDepartment(Map paramMap) {
    	departmentMapper.createDepartment(paramMap);
    }
    
    public Map departmentInfo(Map paramMap) {
        return departmentMapper.departmentInfo(paramMap);
    }
    
    public void editDepartment(Map paramMap) {
    	departmentMapper.editDepartment(paramMap);
    }

    
   
    
    public List<Map> employeeList(Map paramMap) {
        return departmentMapper.employeeList(paramMap);
    }
    
    public int employeeListTotal(Map paramMap) {
        return departmentMapper.employeeListTotal(paramMap);
    }

    public int employeeInsert(Map ParamMap) { return departmentMapper.employeeInsert(ParamMap); }
}
