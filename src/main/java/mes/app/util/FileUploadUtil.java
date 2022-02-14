package mes.app.util;

import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Component;

import java.io.File;

@Component
public class FileUploadUtil {

//	@Autowired
//	private MessageSourceAccessor messageSourceAccessor;
//
//	public void makeDir(String saveDir) throws Exception{
//		File dir = new File(messageSourceAccessor.getMessage("file.upload.path") + saveDir);
//
//		if(!dir.exists()){
//			dir.mkdirs();
//		}
//	}
//
//	public void makeDirFullPath(String saveDir) throws Exception{
//		File dir = new File(saveDir);
//
//		if(!dir.exists()){
//			dir.mkdirs();
//		}
//	}
//
//	public void deleteDir(String saveDir) throws Exception {
//		File dir = new File(messageSourceAccessor.getMessage("file.upload.path") + saveDir);
//
//		if(dir.exists()){
//			File[] innerFileList = dir.listFiles();
//			if(innerFileList != null){
//				for (File innerdir : innerFileList) {
//					if(innerdir.isDirectory()) {
//						deleteDir(innerdir.getAbsolutePath());//
//					} else {
//						innerdir.delete();
//					}
//				}
//				dir.delete();
//			}
//		}
//	}

	public void deleteFile(String delDir, String fileNm) throws Exception {
		File dFile = new File(delDir + File.separatorChar + fileNm);
		if(dFile != null){
			dFile.delete();
		}
	}
	
}
