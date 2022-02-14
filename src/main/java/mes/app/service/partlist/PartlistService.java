package mes.app.service.partlist;


import mes.app.mapper.partlist.PartlistMapper;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.annotation.JacksonInject.Value;

import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

@Service
@Transactional
public class PartlistService {

    @Autowired
    private PartlistMapper partlistMapper;

	public List<Map<String, String>> getPartList(Map paramMap) {
		return partlistMapper.Partlist_Search_S1_Str(paramMap);
	};
	
	public int partlistTotal(Map paramMap) {
		return partlistMapper.PartlistTotal(paramMap);
	};
	
	public List<Map<String, String>> getPartListRow(Map paramMap) {
		return partlistMapper.Partlist_Row_S1_Str(paramMap);
	};
	public List<Map<String, String>> getPartListRow2(Map paramMap) {
		return partlistMapper.Partlist_Row_S2_Str(paramMap);
	};
	public void createPartlist(Map<String, String> map) {
		partlistMapper.Partlist_Create_I1_Str(map);
	}

	public void deletePartlist(String string) {
		partlistMapper.Partlist_Delete_D1_Str(string);
		
	};


}
