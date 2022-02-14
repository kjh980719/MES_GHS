package mes.app.controller;


import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.slf4j.Slf4j;
import mes.app.service.CommonService;
import mes.app.util.Util;
import mes.common.model.JsonResponse;
import mes.common.service.CFileService;

@Controller
@Slf4j
public class CommonController {
	@Value("${path.upimage}")
	public String IMAGE_UPLOAD_PATH;
	
    @Autowired
    CommonService commonService;
    @Autowired
    CFileService cFileService;
    
    @Value("default.upload.folder")
    String DEFAULT_UPLOAD_FOLDER;

    @GetMapping("/showImage/logo/{platformCode}")
    @ResponseBody
    public ResponseEntity<byte[]> showLogo(@PathVariable("platformCode") int platformCode) throws Exception{
        Map logoInfo = commonService.getPlatformLogoInfo(platformCode);
        if(logoInfo != null){
            String fileName = logoInfo.get("fileName").toString();
            Resource resource = new FileSystemResource(fileName);
            if(!resource.exists()) {
                return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
            }
            byte[] imageContent = Files.readAllBytes(Paths.get(fileName));

            final HttpHeaders headers = new HttpHeaders();

            if(fileName.toLowerCase().endsWith("jpg") || fileName.toLowerCase().endsWith("jpeg")) {
                headers.setContentType(MediaType.IMAGE_JPEG);
            }else if(fileName.toLowerCase().endsWith("gif")) {
                headers.setContentType(MediaType.IMAGE_GIF);
            }else{
                headers.setContentType(MediaType.IMAGE_PNG);
            }
            return new ResponseEntity<byte[]>(imageContent, headers, HttpStatus.OK);
        }
        return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
    }

    @ResponseBody
    @PostMapping(value = "/uploadDescImage", consumes = {"multipart/form-data"})
    public Map<String, Object> modifyGoods(@RequestPart(name = "uploadImage") MultipartFile[] uploadImages) throws Exception {
        List<String> resultData = new ArrayList<>();
        for(MultipartFile uploadImage : uploadImages){
            Map<String, String> map = new HashMap<>();
            if(uploadImage != null){
                map = cFileService.uploadFile(uploadImage, IMAGE_UPLOAD_PATH + Util.getNow("yyyyMM") + "/");
            }
            resultData.add("/imageView/" + map.get("fileKey"));
        }
        return JsonResponse.asSuccess("storeData", resultData);
    }
	
    @RequestMapping("/imageView/{fileId}")
    public ResponseEntity<byte[]> imageView(@PathVariable("fileId") String fileId) throws Exception{
        Map fileInfo = commonService.getFileInfo(fileId);
        if(fileInfo != null){
            String fileName = String.valueOf(fileInfo.get("file_path"));
            Resource resource = new FileSystemResource(fileName);
            if(!resource.exists()) {
                return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
            }
            byte[] imageContent = Files.readAllBytes(Paths.get(fileName));

            final HttpHeaders headers = new HttpHeaders();

            if(fileName.toLowerCase().endsWith("jpg") || fileName.toLowerCase().endsWith("jpeg")) {
                headers.setContentType(MediaType.IMAGE_JPEG);
            }else if(fileName.toLowerCase().endsWith("gif")) {
                headers.setContentType(MediaType.IMAGE_GIF);
            }else{
                headers.setContentType(MediaType.IMAGE_PNG);
            }
            return new ResponseEntity<byte[]>(imageContent, headers, HttpStatus.OK);
        }
        return new ResponseEntity<byte[]>(HttpStatus.NOT_FOUND);
    }

    @RequestMapping("/download/{fileId}")
    public ResponseEntity<Resource> downloadFile(@PathVariable("fileId") String fileId, @RequestHeader("user-Agent") String userAgent){
        Map fileInfo = commonService.getFileInfo(fileId);
        Resource resource = new FileSystemResource(String.valueOf(fileInfo.get("file_path")));
        if(!resource.exists())
            return new ResponseEntity<>(null, HttpStatus.NOT_FOUND);
        String resourceUidName = resource.getFilename();
        String resourceName = String.valueOf(fileInfo.get("file_name"));
        HttpHeaders headers = new HttpHeaders();
        String downloadName = null;
        if(userAgent.contains("Trident") || userAgent.contains("Edge")) {
            try {
                downloadName = URLEncoder.encode(resourceName, "utf-8").replaceAll("\\+", " ");
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }else {
            try {
                downloadName = new String(resourceName.getBytes("utf-8"), "ISO-8859-1");
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
        headers.add("Content-Disposition", "attachment;filename=\""+downloadName+"\"");
        return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
    }	
}
