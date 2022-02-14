package mes.app.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class FileUploadService {

    @Value("${default.upload.folder}")
    String DEFAULT_UPLOAD_FOLDER;


    public Map fileUpload(MultipartFile file, String...dirs) throws Exception{
        Map resultMap = new HashMap();

        String uploadFileName = null;
        String uploadFolderPath = String.join(File.separator, dirs);

        File uploadPath = new File(DEFAULT_UPLOAD_FOLDER, uploadFolderPath);
        if(!uploadPath.exists()) {
            uploadPath.mkdirs();
        }

        uploadFileName = file.getOriginalFilename();
        uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\")+1);
        UUID uuid = UUID.randomUUID();
        resultMap.put("fileOriginName", uploadFileName);
        uploadFileName = uuid.toString()+"_"+uploadFileName;


        Path pathFile = Paths.get(uploadPath.getPath(), uploadFileName);
        file.transferTo(pathFile);
        resultMap.put("fileName", pathFile.toString());
        return resultMap;
    }

    private String getFolder() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String str = sdf.format(date);
        return str.replace("-", File.separator);
    }

}
