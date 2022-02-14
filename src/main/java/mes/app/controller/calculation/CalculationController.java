package mes.app.controller.calculation;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import mes.app.service.calculation.CalculationService;
import mes.app.util.Util;
import mes.security.UserInfo;

@Controller
@RequestMapping(value="/calculation")
public class CalculationController {
	
    @Autowired
    private CalculationService calculationService;


	@RequestMapping(value="/list")
    public String calculationList(Model model, @RequestParam Map param) {

    	Map paramMap = new HashMap();
        paramMap.put("currentPage", 1);
        paramMap.put("rowsPerPage", 999);
        
        
        String startDate = "";
        String endDate = "";
        String search_type = "";
        String search_string = "";
    
        int rowsPerPage = 0;
        int currentPage = 1;
   
        if (param.get("startDate") == null || param.get("endDate") == null) {
	        Calendar cal = Calendar.getInstance();
	        String format = "yyyy-MM-dd";
	        SimpleDateFormat sdf = new SimpleDateFormat(format);
	            	             
	        //처음 들어왔을 때
	        cal.add(cal.MONTH, -3); //세달 전
	        startDate = sdf.format(cal.getTime());   
	         
	        cal.add(cal.MONTH, +6); //세달 후
	        endDate = sdf.format(cal.getTime());                
        }else {
        	startDate = (String) param.get("startDate");
        	endDate = (String) param.get("endDate");
        }
        

        if (param.get("search_type") == null) {
        	search_type = "ALL";
        }else {
        	search_type = (String) param.get("search_type");
        }
        if(param.get("search_string") == null) {
        	search_string = "";
        }else {
        	search_string = (String) param.get("search_string");
        }
        
        if (param.get("currentPage") == null || param.get("currentPage").equals("")) {
        	currentPage = 1;
        }else {
        	currentPage = Integer.parseInt((String) param.get("currentPage"));
        }
        
        if (param.get("rowsPerPage") == null) {
        	rowsPerPage = 15;
        }else {
        	rowsPerPage = Integer.parseInt((String) param.get("rowsPerPage"));
        }
        
      
        String parameter = "&rowsPerPage="+rowsPerPage+"&search_type="+search_type+"&startDate="+startDate+"&endDate="+endDate+"&search_string="+search_string;
        String sQuery = "";
        
        if (search_type.equals("CALC_CODE")) {
        	sQuery += " AND A.calc_code = '" + search_string +"'";
        }else if(search_type.equals("CUST_NAME")) {
        	sQuery += " AND B.cust_name like '%" + search_string + "%'" ;
        } else {
        	sQuery += "AND (A.calc_code = '"+ search_string +"' or B.cust_name like '%" + search_string + "%')";
        }


        model.addAttribute("parameter", parameter);
        
        UserInfo info = Util.getUserInfo();       
		Map map = new HashMap();
		map.put("startDate", startDate); 
		map.put("endDate",endDate );
		map.put("currentPage", currentPage);	
		map.put("rowsPerPage", rowsPerPage);
		map.put("sQuery", sQuery);
		map.put("search_type",search_type);
		
		//model.addAttribute("total", calculationService.calculationListTotal(map));
		//model.addAttribute("list", calculationService.calculationList(map));
		model.addAttribute("total", 1);
		
		
		model.addAttribute("search", map);
	
        model.addAttribute("currentPage",currentPage);
        model.addAttribute("rowsPerPage",rowsPerPage);

        
        return "/calculation/list";
    }
    

}
