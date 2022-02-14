    function GetPageCount( totalCount,  page_size){
        var retVal;
        retVal = Math.floor(totalCount/page_size);
        if((totalCount % page_size) > 0){
            retVal = retVal + 1;
        }
        return retVal;
    }
    
   function paging( totalCount,  curPage,  page_size,  viewPageNum,  param) {
 
		var nPREV = (Math.floor(((curPage - 1) / viewPageNum)) -1) * viewPageNum +1;
        var nCUR = (Math.floor((curPage - 1) / viewPageNum)) * viewPageNum + 1;
        var nNEXT = (Math.floor((curPage - 1) / viewPageNum) + 1) * viewPageNum + 1;
        var nPageCount = GetPageCount(totalCount,page_size);
		
		/*console.log(nPREV);
		console.log(nCUR);
		console.log(nNEXT);
		console.log(nPageCount);*/
		
        var strFirstLink;
        var strLastLink;
        var retVal;
        var strLink;
        var strLinkOne;
        var pageKubun;

        if(nPREV > 0){         
            retVal = "<a href='#' onclick='linkpage(1); return false;' title=\"처음 페이지\" class=\"first\">[처음]</a> ";     
            retVal = retVal + "<a href='#' onclick='linkpage(\""+(curPage-5)+"\"); return false;'class=\"fast_prev\">><img src='/images/common/first_prev.gif'></a>";
        }else {
            retVal = "<img class=\"fast_prev\" src='/images/common/first_prev.gif'>";
        }

        if(curPage > 1){
            retVal = retVal + "<a href='#' class=\"prev\" onclick='linkpage(\""+(curPage-1)+"\"); return false;'><img src='/images/common/paging_prev.gif'></a>";
        }else {
            retVal = retVal + "<img class=\"prev\" src='/images/common/paging_prev.gif'>";
        }
        var i = 1;

        while(i <= viewPageNum && nCUR <= nPageCount){
                if(nCUR == nPageCount || i==viewPageNum){
                    pageKubun = " ";
                }else if(i == viewPageNum){
                	pageKubun = " ";
                }else {              
                   pageKubun = " ";
                }
                if(curPage == nCUR){
                    retVal = retVal + "<span class=\"active\">" + nCUR + "</span>" + pageKubun;
                }else {
                    strLink = "?currentPage=" + nCUR + param;
                    retVal = retVal + "<a href='#' onclick='linkpage(\""+nCUR+"\");' class=\"page\">" + nCUR + "</a>" + pageKubun;
                    
                }
                nCUR = nCUR + 1;
                i = i + 1;
            }

        if(curPage<nPageCount){
            strLinkOne = "?currentPage=" +  (curPage +1) + param;
            retVal = retVal + "<a href='#' class=\"next\" onclick='linkpage(\""+(curPage+1)+"\"); return false;'><img src='/images/common/paging_next.gif'></a>";
        }else{
            retVal = retVal + "<img class=\"next\" src='/images/common/paging_next.gif'>";
        }

        if(nNEXT <= nPageCount){
            strLink = "?currentPage=" + nNEXT + param;
            retVal = retVal + "<a href='#' onclick='linkpage(\""+(curPage+5)+"\"); return false;' class=\"fast_next\"><img src='/images/common/last_next.gif'></a>";

            strLastLink = "?currentPage=" + nPageCount + param;
            retVal = retVal + "<a href='#' class=\"last\" title=\"마지막 페이지\">[마지막]</a>";
        }else {
            retVal = retVal + "<img class=\"fast_next\" src='/images/common/last_next.gif' >";
        }


        return retVal;
   }