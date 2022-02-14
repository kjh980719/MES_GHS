package mes.app.controller;

import java.util.List;
import java.util.Map;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import lombok.extern.slf4j.Slf4j;
import mes.app.service.PdfService;
import mes.common.model.JsonResponse;


@Controller
@Slf4j
public class PDFController{

    @Autowired
    PdfService pdfService;

    private ProcessBuilder pb = new ProcessBuilder();

    DefaultExecutor executor = new DefaultExecutor();

    @GetMapping("/autoDown")
    public String autoDownPage(){
        return "/auto/autoDown";
    }


    public synchronized void createPDF(String url, String path) throws Exception{
        long startTime = System.currentTimeMillis();

        CommandLine cmd = new CommandLine("python3.8");
        cmd.addArgument("/cmarket_py/test.py");
        cmd.addArgument(url);
        cmd.addArgument(path);
        executor.execute(cmd);
        log.info("pdfCreate - time check : "+(System.currentTimeMillis() - startTime)+"ms");
    }



    @PostMapping("/pdf/pdftest")
    @ResponseBody
    public Map test(@RequestBody Map paramMap) throws Exception{


        createPDF(paramMap.get("url").toString(), "/tupload/嫄곕옒紐낆꽭�꽌"+paramMap.get("bidx").toString());

        return JsonResponse.asSuccess();
    }





    @GetMapping("/pdf/estimate")
    public String estimateTemplate(@RequestParam Map paramMap, Model model){

        Map joinInfo = pdfService.getJoinInfo(paramMap);
        List<Map> joinProductInfo = pdfService.getJoinProductInfo(paramMap);
        model.addAttribute("joinInfo", joinInfo);

        return "/pdf/estimate_template";
    }

    @RequestMapping("/pdf/bid_end")
    public String PDF_END_BID_S1_Str(@RequestParam Map paramMap, Model model){
        model.addAttribute("entendInfo", pdfService.PDF_END_BID_S1_Str(paramMap));
        model.addAttribute("gudsInfo", pdfService.PDF_END_BID_S2_Str(paramMap));
        return "/pdf/bid_end";
    }


}
