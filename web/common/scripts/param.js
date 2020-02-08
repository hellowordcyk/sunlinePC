// JavaScript Document
/******
****组包成为参数串，根据表单上的对象的属性
*****/

function param() 
{
	var  str="";
	var  param="";
	var  licount=document.EnterpriseForm.elements.length;
	for (i=0;i<licount;i++)
	{
		str="";
		if (document.EnterpriseForm.elements[i].type=="text") 
		{
			str=document.EnterpriseForm.elements[i].name+"="+document.EnterpriseForm.elements[i].value;		
		}
		else if (document.EnterpriseForm.elements[i].type=="checkbox") 
		{
			var chkbox=document.EnterpriseForm.elements[i];
			if (chkbox.checked==true)
			{
				str=chkbox.name+"=1";	
			}
			else
			{
				str=chkbox.name+"=0";
			}
		}
		else if (document.EnterpriseForm.elements[i].type=="radio") 
		{
			var rdobox=document.EnterpriseForm.elements[i];
			if (rdobox.checked==true)
			{
				str= rdobox.name +"=" + rdobox.value;
			}
		}
		else if (document.EnterpriseForm.elements[i].type=="password") 
		{
			str=document.EnterpriseForm.elements[i].name+"="+document.EnterpriseForm.elements[i].value;
		}
		else if (document.EnterpriseForm.elements[i].type=="select-one") 
		{
			
			var optionlist=document.EnterpriseForm.elements[i];
			//var lichoice=optionlist.selectedIndex;
			
			var liloop=optionlist.options.length;
			var tempstr="";
			for (j=0;j<liloop;j++)
			{
				if (optionlist.options[j].selected==true)
				{	
					tempstr=optionlist.options[j].value;
					break;
				}
					
			}
			str=optionlist.name+"="+tempstr;
			
		}
		else
		{
			continue;
		}
		
		if (str=="")
		{
			continue;
		}
		
		if (param=="")
		{		
			param=str;
		}
		else
		{
			param=param + "|"+str;
		}
	}
	
	
	return param;
}
