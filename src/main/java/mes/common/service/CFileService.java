package mes.common.service;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import mes.app.mapper.user.common.CommonMapper;
import mes.app.util.Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class CFileService {

  @Value("${default.upload.folder}")
  String DEFAULT_PATH;
  @Value("${default.upload.path}")
  String DEFAULT_PATH_CONTEXT;

  public Map<String, String> uploadFile(MultipartFile multipartFile, String path) throws Exception {

    File uploadPath = new File(DEFAULT_PATH, path);
    File uploadPathContext = new File(DEFAULT_PATH_CONTEXT, path);
    if (!uploadPath.exists()) {
      uploadPath.mkdirs();
    }
    String uploadFileName = multipartFile.getOriginalFilename();
    uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
    int tmpIdx;
    String uuid = Util.getUUID();
    if (uploadFileName.lastIndexOf(".") < 0) {
      tmpIdx = uploadFileName.length();
    } else {
      tmpIdx = uploadFileName.lastIndexOf(".");
    }
    long fileSize = multipartFile.getSize();
    String resultFileName = uploadFileName.substring(0, tmpIdx) + "_" + uuid + uploadFileName.substring(tmpIdx);
    Path pathFile = Paths.get(uploadPath.getPath(), resultFileName);
    Path contextPathFile = Paths.get(uploadPathContext.getPath(), resultFileName);
    multipartFile.transferTo(pathFile);
    Map<String, String> map = new HashMap<>();
    map.put("fileName", resultFileName);
    map.put("pathFile", String.valueOf(pathFile));
    map.put("contextPathFile", String.valueOf(contextPathFile));
    map.put("originalFileName", uploadFileName);
    map.put("fileSize", fileSize + "");
    map.put("fileKey", uuid);
    return map;
  }

  public Boolean deleteFile(String path, String fileName) {

    File deleteFile = new File(DEFAULT_PATH + path + "/" + fileName);

    Boolean result = false;
    try {
      if (deleteFile.exists()) {
        if (deleteFile.delete()) {
          result = true;
        } else {
          result = false;
        }
      } else {
        result = false;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return result;
  }

}
