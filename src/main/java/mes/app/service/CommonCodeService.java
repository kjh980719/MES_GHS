package mes.app.service;

import mes.app.mapper.CommonCodeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class CommonCodeService {

    @Autowired
    CommonCodeMapper commonCodeMapper;

    public List<Map> getCommonCode(Map paramMap) { return commonCodeMapper.COMMON_CODE_INFO_List_S2_Str(paramMap); }

    public void insertCommonCode(Map paramMap){ commonCodeMapper.COMMON_CODE_INFO_I1_Str(paramMap);}

    public void updateUseFixed(Map paramMap){ commonCodeMapper.COMMON_CODE_INFO_U1_Str(paramMap);}

    public void changeSortNumber(Map paramMap){ commonCodeMapper.COMMON_CODE_INFO_U2_Str(paramMap); }

    public void updateCodeName(Map paramMap){ commonCodeMapper.COMMON_CODE_INFO_U3_Str(paramMap);}
}
