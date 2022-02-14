package mes.app.util.paging;

public class MemberPaging extends DefaultPaging {

    public int GetPageCount(int totalCount, int page_size){
        int retVal;
        retVal = (int)Math.floor(totalCount/page_size);
        if((totalCount % page_size) > 0){
            retVal = retVal + 1;
        }
        return retVal;
    }


    public MemberPaging(int totalCount, int curPage, int page_size, int viewPageNum, String param) {
        super(totalCount, curPage, page_size, viewPageNum);
        int nPREV = ((int)Math.floor(((curPage - 1) / viewPageNum)) -1) * viewPageNum +1;
        int nCUR = ((int)Math.floor((curPage - 1) / viewPageNum)) * viewPageNum + 1;
        int nNEXT = ((int)Math.floor((curPage - 1) / viewPageNum) + 1) * viewPageNum + 1;
        int nPageCount = GetPageCount(totalCount,page_size);
//        System.out.println("nPageCount:::"+nPageCount);
//        System.out.println("nPREV:::"+nPREV);
//        System.out.println("nCUR:::"+nCUR);
//        System.out.println("nNEXT:::"+nNEXT);
//        System.out.println("param:::"+param);
        String strFirstLink;
        String strLastLink;
        String retVal;
        String strLink;
        String strLinkOne;
        String pageKubun;

        if(nPREV > 0){
            strFirstLink = "?currentPage=1" + param;
            retVal = "<a href=\"" + strFirstLink + "\" title=\"처음 페이지\" class=\"first\">[처음]</a>";

            strLink = "?currentPage=" + nPREV + param;
            retVal = retVal + "<a href=\"" + strLink + "\" class=\"fast_prev\"><img src='/images/common/first_prev.gif'></a>";

        }else {
            retVal = "<img class=\"fast_prev\" src='/images/common/first_prev.gif'>";
        }

        if(curPage > 1){
            strLinkOne = "?currentPage="+(curPage - 1)+param;
            retVal = retVal + "<a href=\"" + strLinkOne + "\" class=\"prev\"><img src='/images/common/paging_prev.gif'></a>";

        }else {
            retVal = retVal + "<img class=\"prev\" src='/images/common/paging_prev.gif'>";
        }
        int i = 1;

        while(i <= viewPageNum && nCUR <= nPageCount){
                if(nCUR == nPageCount || i==viewPageNum){
                    pageKubun = " ";
                }else if(i == viewPageNum){
                	pageKubun = " ";
                }else {              
                   pageKubun = "  ";
                }
                if(curPage == nCUR){
                    retVal = retVal + "<span class=\"active\">" + nCUR + "</span>" + pageKubun;
                }else {
                    strLink = "?currentPage=" + nCUR + param;
                    retVal = retVal + "<a href=\"" + strLink + "\" class=\"page\">" + nCUR + "</a>" + pageKubun;
                }
                nCUR = nCUR + 1;
                i = i + 1;
            }

        if(curPage<nPageCount){
            strLinkOne = "?currentPage=" +  (curPage +1) + param;
            retVal = retVal + "<a href=\"" + strLinkOne + "\" class=\"next\"><img src='/images/common/paging_next.gif'></a>";
        }else{
            retVal = retVal + "<img class=\"next\" src='/images/common/paging_next.gif'>";
        }

        if(nNEXT <= nPageCount){
            strLink = "?currentPage=" + nNEXT + param;
            retVal = retVal + "<a href=\"" + strLink + "\" class=\"fast_next\"><img src='/images/common/last_next.gif'></a>";

            strLastLink = "?currentPage=" + nPageCount + param;
            retVal = retVal + "<a href=\"" + strLastLink + "\" title=\"마지막 페이지\" class=\"last\">[마지막]</a>";
        }else {
            retVal = retVal + "<img class=\"fast_next\" src='/images/common/last_next.gif' >";
        }

//        this.firstTag = "<a href='?curPage=1' onclick='linkPage(1);return false;' class='page_img first_img'><span>처음</span></a>";
//        this.preTag = "<a href='?curPage=#{pre}' onclick='linkPage(#{pre});return false;' class='page_img prev_img'><span>이전</span></a>";
//        this.curTag = "<em class='page_list'><i class='blind'></i><span>#{cur}</span></em>";
//        this.idxTag = "<a href='?curPage=#{idx}' onclick='linkPage(#{idx});return false;' class='page_list'>#{idx}</a>";
//        this.nextTag = "<a href='?curPage=#{next}' onclick='linkPage(#{next});return false;' class='page_img next_img'><span>다음</span></a>";
//        this.endTag = "<a href='?curPage=#{end}' onclick='linkPage(#{end});return false;' class='page_img last_img'><span>마지막</span></a>";
        this.firstTag = retVal;

    }

    public String getResultString(){
        String resultString = "";
        resultString=firstTag;
        return resultString;
    }
    
    
    
    
    
}