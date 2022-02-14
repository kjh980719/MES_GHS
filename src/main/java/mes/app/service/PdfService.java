package mes.app.service;

import mes.app.mapper.PdfMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class PdfService {

    @Autowired
    PdfMapper pdfMapper;

    public Map getJoinInfo(Map paramMap){ return pdfMapper.B2B_BUY_JOIN_S1_Str(paramMap); }

    public List<Map> getJoinProductInfo(Map paramMap){ return pdfMapper.B2B_BUY_JOIN_PRODUCT_S1_Str(paramMap); }

    public Map PDF_END_BID_S1_Str(Map paramMap) {
        return pdfMapper.PDF_END_BID_S1_Str(paramMap);
    }

    public List<Map> PDF_END_BID_S2_Str(Map paramMap) {
        return pdfMapper.PDF_END_BID_S2_Str(paramMap);
    }
}
