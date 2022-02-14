package mes.app.controller.board;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import mes.app.service.board.QnaService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.common.service.CFileService;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/qna")
public class QnaController {

	 @Autowired
	 private QnaService qnaService;
	    
	 @Value("${path.upfile}")
	 public String UPFILE_PATH3;
	    
	 @Value("${limit.upfile}")
	 public int UPFILE_LIMIT;


	@Autowired
	private CFileService cFileService;
		
	@RequestMapping(value = "/list")
	public String list(Model model, @RequestParam Map param) {

		Map paramMap = new HashMap();
		paramMap.put("currentPage", 1);
		paramMap.put("rowsPerPage", 999);

		String search_type = "";
		String search_string = "";

		int rowsPerPage = 0;
		int currentPage = 1;

		if (param.get("search_type") == null || param.get("search_type").equals("")) {
			search_type = "ALL";
		} else {
			search_type = (String) param.get("search_type");
		}
		if (param.get("search_string") == null || param.get("search_string").equals("")) {
			search_string = "";
		} else {
			search_string = (String) param.get("search_string");
		}

		if (param.get("currentPage") == null || param.get("currentPage").equals("")) {
			currentPage = 1;
		} else {
			currentPage = Integer.parseInt((String) param.get("currentPage"));
		}

		if (param.get("rowsPerPage") == null || param.get("rowsPerPage").equals("")) {
			rowsPerPage = 15;
		} else {
			rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
		}

		String parameter = "&rowsPerPage=" + rowsPerPage + "&search_type=" + search_type + "&search_string="
				+ search_string;
		String sQuery = "";

		if (search_type.equals("TITLE")) {
			sQuery += " AND A.TITLE = '" + search_string + "'";
		} else {
			sQuery += "AND (A.TITLE like '%" + search_string + "%')";
		}

		model.addAttribute("parameter", parameter);

		Map map = new HashMap();
		map.put("currentPage", currentPage);
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_type", search_type);

		model.addAttribute("total", qnaService.qnaListTotal(map));
		model.addAttribute("list", qnaService.qnaList(map));

		model.addAttribute("search", map);

		model.addAttribute("currentPage", currentPage);
		model.addAttribute("rowsPerPage", rowsPerPage);

		return "/qna/list";
	}
	    
	@RequestMapping(value = "/reply", consumes = { "multipart/form-data" })
	@ResponseBody
	public Map create(@RequestParam Map paramMap1,
			@RequestPart(name = "content") Map paramMap,
			@RequestPart(name = "files", required = false) MultipartFile[] multipartFile, HttpServletRequest request) {
		int result = 0;
		/* String result = ""; */
		Map mMap = new HashMap<String, String>();
		String qna_seq = paramMap1.get("qna_seq").toString();
		String title2 = paramMap.get("title2").toString();
		String contents2 = paramMap.get("contents2").toString();

		try {
			Iterator<MultipartFile> iterator = Arrays.asList(multipartFile).iterator();
			int fno = 0;
			List<Map> file_info = new ArrayList<>();
			/*
			 * for(int i = 1; i <= 3; i++){ if(paramMap.get("FILE"+i) != null){ Map tmpMap =
			 * bidMapper.B2B_BUY_UPFILE_S1_Str(paramMap.get("buy_idx").toString(),
			 * paramMap.get("UFILE"+i).toString()); tmpMap.put("bid_file_seq", fno+1);
			 * bid_file_info.add(tmpMap); fno++; continue; } }
			 */
			int loopCount = UPFILE_LIMIT - file_info.size();
			for (int i = 1; i <= 1; i++) {
				if (iterator.hasNext()) {
					MultipartFile tmpMultipartFile = iterator.next();
					if (!tmpMultipartFile.isEmpty()) {
						Map tmpMap = new HashMap();
						tmpMap.put("bid_file_seq", fno + 1);
						tmpMap.put("bid_file_size", tmpMultipartFile.getSize());
						Map<String, String> map = cFileService.uploadFile(tmpMultipartFile, UPFILE_PATH3 + "qna/");
						tmpMap.put("bid_file_name", map.get("fileName"));
						tmpMap.put("bid_file_ori_name", map.get("originalFileName"));
						tmpMap.put("fileKey", map.get("fileKey"));
						file_info.add(tmpMap);
						paramMap.put("file" + i, map.get("fileKey"));
						fno++;
					}
					continue;
				}
			}

			qnaService.createReply(paramMap, request);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return JsonResponse.asSuccess();
	}

	@RequestMapping(value = "/view")
	@ResponseBody
	public Map view(@RequestParam(value = "qna_seq", required = false) String qna_seq) {

		UserInfo info = Util.getUserInfo();
		Map map = new HashMap();
		map.put("qna_seq", Integer.parseInt(qna_seq));
		Map resultMap = new HashMap();
		resultMap.put("info", qnaService.qnaInfo(map));
		resultMap.put("fileList", qnaService.qnaFileListSql(map));
		resultMap.put("fileList2", qnaService.qnaFileListSql2(map));
		
		return JsonResponse.asSuccess("storeData", resultMap);
	}

	@RequestMapping(value = "/replyEdit", consumes = { "multipart/form-data" })
	@ResponseBody
	public Map edit(@RequestParam Map paramMap1, @RequestPart(name = "content") Map paramMap,
			@RequestPart(name = "files", required = false) MultipartFile[] multipartFile, HttpServletRequest request) {
		int result = 0;
		/* String result = ""; */
		Map mMap = new HashMap<String, String>();
		String qna_seq = paramMap1.get("qna_seq").toString();
		String title2 = paramMap.get("title2").toString();
		String contents2 = paramMap.get("contents2").toString();

		try {
			Iterator<MultipartFile> iterator = Arrays.asList(multipartFile).iterator();
			int fno = 0;
			List<Map> bid_file_info = new ArrayList<>();
			/*
			 * for(int i = 1; i <= 3; i++){ if(paramMap.get("FILE"+i) != null){ Map tmpMap =
			 * bidMapper.B2B_BUY_UPFILE_S1_Str(paramMap.get("buy_idx").toString(),
			 * paramMap.get("UFILE"+i).toString()); tmpMap.put("bid_file_seq", fno+1);
			 * bid_file_info.add(tmpMap); fno++; continue; } }
			 */
			int loopCount = UPFILE_LIMIT - bid_file_info.size();
			for (int i = 1; i <= 1; i++) {
				if (iterator.hasNext()) {
					MultipartFile tmpMultipartFile = iterator.next();
					if (!tmpMultipartFile.isEmpty()) {
						Map tmpMap = new HashMap();
						tmpMap.put("bid_file_seq", fno + 1);
						tmpMap.put("bid_file_size", tmpMultipartFile.getSize());
						Map<String, String> map = cFileService.uploadFile(tmpMultipartFile, UPFILE_PATH3 + "qna/");
						tmpMap.put("bid_file_name", map.get("fileName"));
						tmpMap.put("bid_file_ori_name", map.get("originalFileName"));
						tmpMap.put("fileKey", map.get("fileKey"));
						bid_file_info.add(tmpMap);
						paramMap.put("file" + i, map.get("fileKey"));
						fno++;
					}
					continue;
				}
			}
			qnaService.editReply(paramMap, request);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return JsonResponse.asSuccess();
	}
	
	@RequestMapping(value = "/deleteFile")
	@ResponseBody
	public Map deleteFile(@RequestParam Map paramMap) {

		qnaService.deleteFile(paramMap);

		return JsonResponse.asSuccess();
	}
	
}
