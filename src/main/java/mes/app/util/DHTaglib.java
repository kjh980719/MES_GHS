package mes.app.util;


import mes.app.util.paging.MemberPaging;
public class DHTaglib {

   

    public static String pagingB(int totalCount, int currentPage, int rowsPerPage, int viewPageNum, String param){
        return new MemberPaging(totalCount, currentPage, rowsPerPage, viewPageNum, param).getResultString();
    }
    

    
   
}
