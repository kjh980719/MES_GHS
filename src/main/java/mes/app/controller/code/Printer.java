package mes.app.controller.code;

import java.io.*;
import javax.print.Doc;
import javax.print.DocPrintJob;
import javax.print.DocFlavor;
import javax.print.PrintException;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.SimpleDoc;
import javax.print.attribute.standard.PrinterName;
import javax.print.attribute.PrintServiceAttribute;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.standard.JobName;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import javax.swing.JOptionPane;
import java.awt.*;

//트루타입폰트 인쇄예제 반드시 트루타입 폰트가 다운로드 되어 있어야 합니다.
//지정된 드라이명을 찾아 드라이버가 선택된 포트로 명령어를 전송
public class Printer {

public static boolean  IsDriverInstalled(String driver_name){
    // 설치된 도시바 드라이버를 찾음...
    try {
        PrintService psToshiba = null;
        String sPrinterName = driver_name;

        PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
        
		String sysPrinter = null;
		for (PrintService ps : services) 
		{
			System.out.println(ps);
			sysPrinter = ((PrinterName)ps.getAttribute(PrinterName.class)).getValue().toUpperCase();
			if(sysPrinter.indexOf(sPrinterName.toUpperCase()) >= 0){
				psToshiba = ps;
				break;
			}
		}
 	    if (psToshiba == null) {
			return false;
	    } 
	    return true;
    } catch (Exception e) {
        e.printStackTrace();
		return false;
    }
}

 /* 이미지 파일을 프린터 메모리에 저장하는 함수 */
 public static String SaveImage(int img_no, int x, int y, String fname){
	String rt = null;
	String st = null;
    File f = new File(fname);  
    if (f.exists() == false)
    {
        return rt;
    }

	BufferedImage img = null;
	try {
	    img = ImageIO.read(f);
            int aHeight;
            int aWidth;
            int i, j, k;
            Byte bb;
	    rt = "{XO;" + String.format("%02d",img_no) + ",0|}\n";  //이미지 변환 저장시작 181page
            aHeight = img.getHeight();
            aWidth = ((img.getWidth() + 7) >> 3) * 8;
            //이미지 변화 173page   
            rt += "{" + "SG;" + String.format("%04d",x) + "," + String.format("%04d",y) + "," + String.format("%04d",aWidth) + "," + String.format("%04d",aHeight) + ",0,";
            j = 0;
            while (j < aHeight)
            {
                i = 0;
                while (i < aWidth)
                {
                    bb = 0;
                    for (k = 0; k < 4; k++)
                    {
                       if ((i + k) < img.getWidth())
                       {
                           if ((img.getRGB(i + k, j) & 0x00FFFFFF) == 0)
                           {
                                bb = (byte)(bb + (1 << (3 - k)));
                           }
                       }
                    }
                    bb = (byte)(bb+48);
                    st = new String(new byte[]{bb});
                    rt += st;
                    i += 4;
                 }
                 j++;
            }
            rt += "|}\n";
			rt += "{XP|}";  //이미지 변환 저장 종료 182page
			return rt;
	} catch (IOException e) {
		System.out.println(e.toString());
	}
    return rt;
 }


//지정된 드라이버명을 찾아 문자열을 UTF-8형식으로 전송하는 함수 
public static boolean  ToshibaLabelPrintUTF8(String driver_name, String st){
    // 설치된 도시바 드라이버를 찾음...
    try {
        PrintService psToshiba = null;
        String sPrinterName = driver_name;

        PrintService[] services = PrintServiceLookup.lookupPrintServices(null, null);
        System.out.println(services);
		String sysPrinter = null;
		for (PrintService ps : services) 
		{
			sysPrinter = ((PrinterName)ps.getAttribute(PrinterName.class)).getValue().toUpperCase();
			if(sysPrinter.indexOf(sPrinterName.toUpperCase()) >= 0){
				psToshiba = ps;
				break;
			}
		}
 	    if (psToshiba == null) {
			return false;
	    }

		DocPrintJob job = psToshiba.createPrintJob();

	    byte[] by = st.getBytes("UTF-8");  //UTF-8로 변환
		DocFlavor flavor = DocFlavor.BYTE_ARRAY.AUTOSENSE;

		Doc doc = new SimpleDoc(by, flavor, null);
		PrintRequestAttributeSet attr = new HashPrintRequestAttributeSet();
		attr.add(new JobName("라벨 인쇄", null));  //Document명 지정

	    System.out.println("인쇄를 시작합니다!!!");
		job.print(doc, attr);
	    System.out.println("작업이 끝났습니다.");
		return true;

    } catch (Exception e) {
        e.printStackTrace();
		return false;
    }
}

public static Boolean main(String b) throws Exception {
	String drv_name = "TOSHIBA B-EX4T2 (300 dpi)";
	String send_data = null;
	Boolean rlt = false;
	
        System.out.println("프로그램시작!!");
        String st = "1";

        while(!st.equals("z")){
			/* st = JOptionPane.showInputDialog("출력=>1, 이미지저장=>2, 종료=>z"); */
          if(st.equals("1")){
		send_data =  "{D0930,0650,0900|}\n" +  //용지크기 지정 50x90mm,갭 3mm일때, 단위 0.1mm단위 => D + (세로길이+갭길이)4자리+,+가로길이 4자리+,+세로길이 4자리
		//	"{AY;+01,0|}\n" +  //온도지정 +1도 (범위: -10 ~ +10)
		"{C|}\n" +  //버퍼클리어
		"{XB01;0175,0075,Q,40,09,01,0|}" + 
		"{PC001;0350,0525,4,4,A,11,B|}" + 
		"{PC002;0075,0525,4,4,A,11,B|}" +
		"{RB01;"+b+"|}" +
		"{RC001;"+b.substring(0,3)+"-"+b.substring(3,6)+"|}" + 
		"{RC002;"+b.substring(6)+"|}"+
	    "{XS;I,0001,0002C5101|}";  // 발행명령어 XS;I,인쇄수량4자리,000 + 용지센서종류1자리(갭=>2, 블랙마크=>1, 없음=>0) + C + 인쇄속도1자리(6ips=>6,4ips=>4,2ips=>2) + 리본사용유무1자리(리본사용=>1, 사용안함=>0) + 01 

		System.out.println(b);
          }
          if (st.equals("2"))
	  {
		send_data = SaveImage(1, 230,50, "c:\\1001.bmp");  //프린터에 이미지저장 (이미지번호,인쇄할 X위치값, 인쇄할 Y위치값,이미지파일) *참고:이미지파일은 흑백이어야하며 bmp파일이어야함.  
                                                                  //리턴값 이미지데이터 변환된문자열값   

		if (send_data.length() < 1)
		{
			System.out.println("이미지 변환 실패!");
		}

	  }
	  if (st.equals("z"))  //종료처리
	  {
          System.out.println("프로그램종료!!");  
		  System.exit(0);
	  }
  	  if (send_data.length() > 0)  //전송할 데이터가 있으면 처리
  	  {
  	    rlt = ToshibaLabelPrintUTF8(drv_name, send_data);  //UTF-8형식으로 데이터 전송
	    if(rlt == false){
		System.out.println("전송이 실패되었습니다.");
		st = "z";
	    }
	    else{
		System.out.println("전송완료!!!");
		st = "z";
		
	    }
	    
  	  }

        }
		return rlt;
		 
}
}