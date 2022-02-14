package mes.app.util.paging;


public abstract class DefaultPaging {

    protected String prefix = "";
    protected String firstTag = "";
    protected String preTag = "";
    protected String curTag = "";
    protected String idxTag = "";
    protected String nextTag = "";
    protected String endTag = "";
    protected String suffix = "";

    protected int totalEnd;
    protected int pageStart;
    protected int pageEnd;
    protected int currentPage;
    protected int viewPageNum;

    public DefaultPaging(int totalCount, int currentPage, int rowsPerPage, int viewPageNum) {
        if(currentPage == 0)
            currentPage = 1;
        if(rowsPerPage == 0)
            rowsPerPage = 10;

        this.totalEnd = (totalCount / rowsPerPage) + ((totalCount%rowsPerPage)>0?1:0);
        this.pageStart = ((currentPage - 1) - ((currentPage-1)%viewPageNum)) + 1;
        this.pageEnd = (pageStart + (viewPageNum - 1)) > totalEnd?totalEnd:(pageStart+(viewPageNum - 1));

        this.currentPage = currentPage;
        this.viewPageNum = viewPageNum;
    }

    public String getResultTag(){
        String resultTag = "";
        resultTag += prefix;
        if(totalEnd > viewPageNum){
            resultTag += firstTag.replace("#{first}", "" + 1);
            resultTag += preTag.replace("#{pre}", "" + (pageStart-1>0?pageStart-1:1));
        }
        for(int idx = pageStart; idx < pageEnd+1; idx++){
            if(idx == currentPage){
                resultTag += curTag.replace("#{cur}", "" + idx);
            }else{
                resultTag += idxTag.replace("#{idx}", "" + idx);
            }
        }
        if(totalEnd > viewPageNum){
            resultTag += nextTag.replace("#{next}", "" + (pageEnd+1<=totalEnd?pageEnd+1:totalEnd));
            resultTag += endTag.replace("#{end}", "" + totalEnd );
        }
        resultTag += suffix;
        return resultTag;
    }


}