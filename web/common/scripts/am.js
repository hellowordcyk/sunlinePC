
var childWin;
function openNewWindow(url)
{
    var topW = eval((screen.availHeight - 400)/2);
    var leftW = eval((screen.availWidth - 650)/2);
    if(childWin==null || childWin.closed)
    {
        childWin=window.open(url,"formulaMaker", "top="+topW+"; left="+leftW+"; height=420,width=650,status=YES,toolbar=NO,menubar=NO,scrollbars=Yes,location=NO,resizable=yes");
        childWin.parentWin = this;
    }
    return childWin;
}
//itemno:科目编码元素,itemna:科目编码名称,num:标志第几对科目编码(当页面有有一组科目编码/科目名称),isSelected:"true"代表末级编码可选,"false"代表末级编码不可选
function getItemInfo(itemno,itemna,num,isSelected)
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=am_BaseInfoVoucher&actions=getItemInfo&itemno="+itemno.value+"&itemtp=-1&desc="+itemna.getAttribute("name") + "&value="+itemno.getAttribute("name")+"&num="+num+"&isSelected="+isSelected+"&forward=/am/getItemInfo.jsp";
    openNewWindow(urlStr);
}
function getSmryInfo(smryno,smryna,num)
{
    var urlStr = null;
    if(num ==0)
    {
         urlStr = "/platform/httpProcesser.jsp?oprID=am_BaseInfoVoucher&actions=getSmrynoInfo&smryno="+smryno.value+"&desc="+smryno.getAttribute("name") + "&value="+smryna.getAttribute("name")+"&num="+num+"&forward=/vm/vmGetSmry.jsp";
    }
    else
    {
    	 urlStr = "/platform/httpProcesser.jsp?oprID=am_BaseInfoVoucher&actions=getSmrynoInfo&smryno="+smryno.value+"&desc="+smryno.getAttribute("name") + "&value="+smryna.getAttribute("name")+"&num="+num+"&forward=/vm/vmGetSmry.jsp";
    }
    openNewWindow(urlStr);
}
function getDetInfo(itemno,num,jdiflag)
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=am_BaseInfoVoucher&actions=getAssisInfo&itemno="+itemno.value+"&num="+num+"&jdflag="+jdiflag+"&forward=/vm/vmGetCodevaInfo.jsp";
    openNewWindow(urlStr);
}
function getCodeInfo(assisname,assitg,codeva,prptva,num)
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=am_BaseInfoVoucher&actions=getCodevaInfo&assisname="+assisname.value+"&assitg="+assitg.value+"&codeva="+codeva.value+"&desc="+codeva.getAttribute("name") + "&value="+prptva.getAttribute("name")+"&num="+num+"&forward=/vm/vmGetDetailCode.jsp";
    var topW = eval((screen.availHeight - 300)/2);
    var leftW = eval((screen.availWidth - 450)/2);
    if(childWin==null || childWin.closed)
    {
        childWin=window.open(urlStr,"new", "top="+topW+"; left="+leftW+"; height=420,width=650,status=NO,toolbar=NO,menubar=NO,scrollbars=Yes,location=NO,resizable=yes");
        childWin.parentWin = this;
    }
    return childWin;
}
function openQueryWin(flag)
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=vm_QueryLedger&actions=easyQueryVoucherInit&flag="+flag+"&empcode=&forward=/vm/vmEasyQueryCon.jsp";
    var topW = eval((screen.availHeight - 300)/2);
    var leftW = eval((screen.availWidth - 450)/2);
    if(childWin==null || childWin.closed)
    {
        childWin=window.open(urlStr,"new", "top="+topW+"; left="+leftW+"; height=300,width=400,status=NO,toolbar=NO,menubar=NO,scrollbars=Yes,location=NO,resizable=yes");
        childWin.parentWin = this;
    }
    return childWin;
}
function openRecheckWin()
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=vm_QueryLedger&actions=easyQueryVoucherInit&empcode=&forward=/vm/vmRecheckAllVoucher.jsp";
    var topW = eval((screen.availHeight - 300)/2);
    var leftW = eval((screen.availWidth - 450)/2);
    if(childWin==null || childWin.closed)
    {
        childWin=window.open(urlStr,"new", "top="+topW+"; left="+leftW+"; height=300,width=400,status=NO,toolbar=NO,menubar=NO,scrollbars=Yes,location=NO,resizable=yes");
        childWin.parentWin = this;
    }
    return childWin;
}
function openUnRecheckWin()
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=vm_QueryLedger&actions=easyQueryVoucherInit&empcode=&forward=/vm/vmUnRecheckAllVoucher.jsp";
    var topW = eval((screen.availHeight - 300)/2);
    var leftW = eval((screen.availWidth - 450)/2);
    if(childWin==null || childWin.closed)
    {
        childWin=window.open(urlStr,"new", "top="+topW+"; left="+leftW+"; height=300,width=400,status=NO,toolbar=NO,menubar=NO,scrollbars=Yes,location=NO,resizable=yes");
        childWin.parentWin = this;
    }
    return childWin;
}

function getHaveDetInfo(acetid)
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=vm_QueryLedger&actions=getAchieveAssisInfo&acetid="+acetid.value+"&forward=/vm/vmGetCodevaInfo.jsp";
    openNewWindow(urlStr);
}
function getHaveDetNewInfo(num,assis0,assis1,assis2,assis3,assis4,assis5,assis6,assis7,assis8,assis9,debtam,crdtam,debtnm,crdtnm,occudt,vchrtg)
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=vm_QueryLedger&actions=getNoAchieveAssisInfo&num="+num+"&assis0="+assis0.value+"&assis1="+assis1.value+"&assis2="+assis2.value+"&assis3="+assis3.value+"&assis4="+assis4.value+"&assis5="+assis5.value+"&assis6="+assis6.value+"&assis7="+assis7.value+"&assis8="+assis8.value+"&assis9="+assis9.value+"&debtam="+debtam.value+"&crdtam="+crdtam.value+"&debtnm="+debtnm.value+"&crdtnm="+crdtnm.value+"&occudt="+occudt.value+"&vchrtg="+vchrtg.value+"&forward=/vm/vmGetCodevaInfo.jsp";
    openNewWindow(urlStr);	
}
function getVmItemInfo(itemno,itemna,num)
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=am_BaseInfoVoucher&actions=getItemInfo&itemno="+itemno.value+"&itemtp=-1&desc="+itemna.getAttribute("name") + "&value="+itemno.getAttribute("name")+"&num="+num+"&forward=/vm/vmGetItemInfo.jsp";
    openNewWindow(urlStr);	
}
function openAdjustVchrnoWin()
{
    var urlStr = "/platform/httpProcesser.jsp?oprID=vm_AccRecheckVoucher&actions=adjustVoucherNoInit&empcode=&forward=/vm/vmAdjustVchrno.jsp";
    openNewWindow(urlStr);
}
function openCalculateWin()
{
    var urlStr = "/vm/vmCalculateBlanc.jsp";
    openNewWindow(urlStr);	
}
