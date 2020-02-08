function openNewWindow(url)
{
    var childWin;
    var topW = eval((screen.availHeight - 400)/2);
    var leftW = eval((screen.availWidth - 650)/2);
    if(childWin==null || childWin.closed)
    {
        childWin=window.open(url,"formulaMaker", "top="+topW+"; left="+leftW+"; height=420,width=650,status=NO,toolbar=NO,menubar=NO,scrollbars=Yes,location=NO,resizable=yes");
        childWin.parentWin = this;
    }
    return childWin;
}