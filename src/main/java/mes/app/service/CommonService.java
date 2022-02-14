package mes.app.service;

import mes.app.mapper.CommonMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
@Transactional
public class CommonService {

    @Autowired
    CommonMapper commonMapper;

    public Map getPlatformLogoInfo(int platformCode){
        return commonMapper.PLATFORM_INFO_S4_Str(platformCode);
    }
    
    public Map getFileInfo(String fileId) { return commonMapper.getFileInfo(fileId);}

}
