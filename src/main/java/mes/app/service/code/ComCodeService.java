package mes.app.service.code;

import mes.app.mapper.code.CodeMapper;
import mes.app.mapper.code.ComCodeMapper;
import mes.app.util.Util;
import mes.security.UserInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class ComCodeService {

    @Autowired
    private ComCodeMapper comCodeMapper;

    public List<Map<String, String>> comCodeList(Map paramMap) {

        return comCodeMapper.comCodeList(paramMap);
    }

    public int comCodeListTotal(Map paramMap) {
        return comCodeMapper.comCodeListTotal(paramMap);
    }



    public String Code_Manage_V1_Str(Map paramMap){
        UserInfo info = Util.getUserInfo();
        paramMap.put("manager_seq",info.getManagerSeq());
        return comCodeMapper.Code_Manage_V1_Str(paramMap);
    }
    public Map codeInfo(Map paramMap){
        return comCodeMapper.codeInfo(paramMap);
    }

    public List<Map<String, String>> comCodeSelectList(Map paramMap){
        return comCodeMapper.comCodeSelectList(paramMap);
    }

    public String CodeDetail_Manage_V1_Str(Map paramMap){
        UserInfo info = Util.getUserInfo();
        paramMap.put("manager_seq",info.getManagerSeq());
        return comCodeMapper.CodeDetail_Manage_V1_Str(paramMap);
    }
    public Map codeDetailInfo(Map paramMap){
        return comCodeMapper.codeDetailInfo(paramMap);
    }

    public List<Map<String, String>> selectComCodeDetail(Map paramMap){
        return comCodeMapper.selectComCodeDetail(paramMap);
    }

    public int deleteComCodeDetail(Map paramMap){
        UserInfo info = Util.getUserInfo();
        paramMap.put("manager_seq",info.getManagerSeq());
        return comCodeMapper.deleteComCodeDetail(paramMap);
    }


    public List<Map<String, String>> comCodeDetailList(Map paramMap) {

        return comCodeMapper.comCodeDetailList(paramMap);
    }

    public int comCodeDetailListTotal(Map paramMap) {
        return comCodeMapper.comCodeDetailListTotal(paramMap);
    }



    public List<Map> comCodeDetailSelectList(Map paramMap){
        return comCodeMapper.comCodeDetailSelectList(paramMap);
    }
}
