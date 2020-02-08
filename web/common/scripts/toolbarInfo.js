function createToolbarInfo(PageCount,PageNo)
{
    var toolbarInfo = '<a href="#" onClick="javascript:add();"><img src="/images/ICON_NEW.gif" alt="新增信息" align="absmiddle" border=0></a>';
    toolbarInfo += '<img src="/images/ICON_SELECTALL.gif" alt="选择或取消所列出的信息" align="absmiddle">';
    toolbarInfo += '<a href="#" onClick="javascript:deleteSelected();"><img src="/images/ICON_DELETE.gif" alt="删除所选择的信息" align="absmiddle" border=0></a>';
    
    if ((PageCount==null)||(PageCount==0)||(PageCount==1)) 
    {
        toolbarInfo += '<img src="/images/ICON_FIRST.gif" alt="首页" align="absmiddle" border=0>';
        toolbarInfo += '<img src="/images/ICON_PRIOR.gif" alt="上页" align="absmiddle" border=0>';
        toolbarInfo += '<img src="/images/ICON_NEXT.gif" alt="下页" align="absmiddle" border=0>';
        toolbarInfo += '<img src="/images/ICON_LAST.gif" alt="末页" align="absmiddle" border=0>';
    }
    else
    {
        if (PageNo==1)
        {
            toolbarInfo += '<img src="/images/ICON_FIRST.gif" alt="首页" align="absmiddle" border=0>';
            toolbarInfo += '<img src="/images/ICON_PRIOR.gif" alt="上页" align="absmiddle" border=0>';
            toolbarInfo += '<a href="#" onClick="javascript:next();"><img src="/images/ICON_NEXT.gif" alt="下页" align="absmiddle" border=0></a>';
            toolbarInfo += '<a href="#" onClick="javascript:last();"><img src="/images/ICON_LAST.gif" alt="末页" align="absmiddle" border=0></a>';
            
        }
        else if (PageNo == PageCount)
        {
            toolbarInfo += '<a href="#" onClick="javascript:first();"><img src="/images/ICON_FIRST.gif" alt="首页" align="absmiddle" border=0></a>';
            toolbarInfo += '<a href="#" onClick="javascript:prior();"><img src="/images/ICON_PRIOR.gif" alt="上页" align="absmiddle" border=0></a>';
            toolbarInfo += '<img src="/images/ICON_NEXT.gif" alt="下页" align="absmiddle" border=0>';
            toolbarInfo += '<img src="/images/ICON_LAST.gif" alt="末页" align="absmiddle" border=0>';
        
        }
        else
        {
            toolbarInfo += '<a href="#" onClick="javascript:first();"><img src="/images/ICON_FIRST.gif" alt="首页" align="absmiddle" border=0></a>';
            toolbarInfo += '<a href="#" onClick="javascript:prior();"><img src="/images/ICON_PRIOR.gif" alt="上页" align="absmiddle" border=0></a>';
            toolbarInfo += '<a href="#" onClick="javascript:next();"><img src="/images/ICON_NEXT.gif" alt="下页" align="absmiddle" border=0></a>';
            toolbarInfo += '<a href="#" onClick="javascript:last();"><img src="/images/ICON_LAST.gif" alt="末页" align="absmiddle" border=0></a>';
        
        }
    }
    return toolbarInfo;

}

function createToolbar(toolbar,PageCount,PageNo)
{
    var toolbarInfo = createToolbarInfo(PageCount,PageNo);
    toolbar.innerHTML = toolbarInfo;
}