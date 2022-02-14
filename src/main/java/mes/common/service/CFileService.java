package mes.common.service;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import mes.app.mapper.CommonMapper;
import mes.app.util.Util;

@Service
public class CFileService {
    @Autowired
    CommonMapper commonMapper;

    @Value("${default.upload.folder}")
    String DEFAULT_PATH;

    public Map<String, String> uploadFile(MultipartFile multipartFile, String path) throws Exception{

        File uploadPath = new File(DEFAULT_PATH, path);
        if(!uploadPath.exists())
            uploadPath.mkdirs();
        String uploadFileName = multipartFile.getOriginalFilename();
        uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
        int tmpIdx;
        String uuid = Util.getUUID();
        if(uploadFileName.lastIndexOf(".") < 0){
            tmpIdx = uploadFileName.length();
        }else{
            tmpIdx = uploadFileName.lastIndexOf(".");
        }
        String resultFileName = uploadFileName.substring(0, tmpIdx) + "_" + uuid + uploadFileName.substring(tmpIdx);
        Path pathFile = Paths.get(uploadPath.getPath(), resultFileName);
        multipartFile.transferTo(pathFile);
        commonMapper.insertFileInfo(uuid, uploadFileName, uploadPath.getPath() + File.separator + resultFileName, multipartFile.getSize());
        Map<String, String> map = new HashMap<>();
        map.put("fileName", resultFileName);
        map.put("originalFileName", uploadFileName);
        map.put("fileKey", uuid);
        return map;
    }
}
