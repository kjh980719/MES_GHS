package mes.app.util;


import mes.app.util.paging.MemberPaging;
import mes.app.util.paging.ShopPaging;

public class DHTaglib {


    public static String pagingA(int totalCount, int currentPage, int rowsPerPage, int viewPageNum){
        return new ShopPaging(totalCount, currentPage, rowsPerPage, viewPageNum).getResultTag();
    }

    public static String pagingB(int totalCount, int currentPage, int rowsPerPage, int viewPageNum, String param){
        return new MemberPaging(totalCount, currentPage, rowsPerPage, viewPageNum, param).getResultString();
    }
    

    
   
}
