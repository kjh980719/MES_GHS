package mes.app.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import mes.app.mapper.HomeMapper;

@Service
public class HomeService {

    @Autowired
    HomeMapper homeMapper;

    public String getTime(){
        return homeMapper.getTime();
    }
    
    public List<Map<String, Object>> getManagerList(Map paramMap){
    
    	
        return homeMapper.getManagerList(paramMap);
    }
  
    
    
}
