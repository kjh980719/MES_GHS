package mes.app.service;

import mes.app.mapper.MemoMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
@Transactional
public class MemoService {

    @Autowired
    MemoMapper memoMapper;

    public List<Map> getMemo4(Map paramMap){
        return memoMapper.ADMIN_MEMO4_S1_Str(paramMap);
    }

    public void insertMemo4(Map paramMap) {
        paramMap.put("memo", paramMap.get("memo").toString().trim().replaceAll("'", "&apos;"));
        memoMapper.ADMIN_MEMO4_I1_Str(paramMap);
    }

    public void deleteMemo4(Map paramMap) {

        memoMapper.ADMIN_MEMO4_D1_Str(paramMap);
    }

}
