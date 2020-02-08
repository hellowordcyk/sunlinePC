
                                                                                                         自定义标签说明

                               1.<h:text>标签   文本

  格式：
  <h:text id="remark" name="remark" maxlength="20"   min="1"  readonly="readonly"  hidden="true"  value="5"  validate="required digits"  style="width:50px;"/>

  属性：
            id：非必填  元素的id值
          name: 必填  元素的名称
     maxlength：非必填；输入字段中的字符的最大长度;
           min：非必填  输入字段的最小值
      readonly：非必填  是否只读  
                  readonly：只读  
                  false：可读可写  默认为false
        hidden：非必填  是否隐藏  
                  true：隐藏  
                  flase:不隐藏  默认值
         value： 非必填   默认值 
      validate： 非必填 字段校验  等于input的class
         style: 等于inputz中的style属性，可以再里面添加各种样式
 


                               2.select标签  下拉列表

  格式：
  <h:select  id ="remark" name="remark"  datasrc="knp" dicttype="pams_traffic"  nulllable ="---请选择----"  value="2" validate="required"  disabled="disabled" />

 属性：
         id：非必填  元素的id值
       name：必填  元素的名称
    datasrc：表名 如：datasrc="knp"  
              knp:代表pcmc_knp_para表 
              bdss:代表bdss_base_para表

   dicttype："_"前面为系统代号，
             "_"后面为字典类型，
                                  如:dicttype="pams_traffic"
  nulllable：非必填  前面加上请选择   如：nulllable ="---请选择----"  key=" "  value = ---请选择----
      value：非必填   默认值 
   validate: 非必填 字段校验  等于input的class
   disabled: 限定只读
             disabled--只读
 

                               3.radio标签   单选框
   格式：
    <h:radio id="remark" name="remark"  datasrc="knp" dicttype="pams_traffic" value="3" linecount="3" />

  属性：
          id: 非必填  元素的id值
        name: 必填  元素的名称
     datasrc: 表名 如：datasrc="knp" 
               knp:代表pcmc_knp_para表 
               bdss:代表bdss_base_para表

    dicttype: "_"前面为系统代号，
              "_"后面为字典类型，
                                     如:dicttype="pams_traffic"
       value: 非必填   默认值 
   linecount:选填，控制每行显示标签数量，默认显示3个


                               4.date标签   日期控件 
   格式：
  <h:date id="remark"  name="remark" dateFmt="yyyy-MM-dd HH:mm:ss" minDate="2000-01-15" maxDate="2020-12-15"  readonly="false"  
                       value="2010-01-15 23:23:23"/>

   属性：
          id: 非必填  元素的id值
        name: 必填  元素的名称
     minDate: 非必填 最小日期 如：minDate="2000-01-15"
     maxDate: 非必填 最大日期 如：maxDate="2020-12-15"
    readonly: 非必填  是否只读  
               readonly：只读  
               false：可读可写  默认为false
       value: 非必填   默认值 

     dateFmt: 非必填  日期格式 如：dateFmt="yyyy-MM-dd HH:mm:ss"
               yyyy-MM-dd HH:mm:ss  年-月-日 时:分:秒  没入职
               yyyy-MM-dd HH:mm     年-月-日 时:分
               yyyy-MM-dd HH        年-月-日 时
               yyyy-MM-dd           年-月-日
               yyyy-MM              年-月
               yyyy                 年
              
              
                                5.write标签    直接将值输出
  格式：
  <h:write  name="funcname"   value="默认值"  />

 属性：
       name：必填  元素的名称
      value：非必填   默认值 
  
              
                                6.dwrite标签    从数据字段中取值 输出
  格式：
  <h:dwrite  name="paratp"  datasrc="bdss" paramp="bdss" paratp="managerpost"  value="默认值"  />

 属性：
       name：必填  元素的名称
    datasrc：表名 如：datasrc="knp"  
              knp:代表pcmc_knp_para表 
              bdss:代表bdss_base_para表
      paramp：系统代号
      paratp: 字典类型        
      
      value：非必填   默认值 

    
                               7.iterator标签  
  格式：
  <h:iterator>
      <tr>
          <td>你好</td>
          <td><a href="hello">测试</a></td>
      </tr>
  </h:iterator>

 iterator 属性：
       target：选填
          rel：选填
 
 
                               8.doPost标签  
  格式：
<h:doPost var="tables" scope="request" sysName="funcpub" oprId="getTables" action="getAllTables" params="queryStr=${param.queryStr }"/>

 doPost 属性：
		sysName：  必填
		oprId：必填
		action：必填
		params：选填 参数形式为a=1&b=2&c=3形式
		var：选填 返回结果定义参数，默认为jrafPkg
		scope：选填 返回结果存放在JSP的哪个域对象中，默认为request
                            
           
                               9.fmt标签  
  格式：
<h:fmt type="crypto|url|date|money|string" value="funcpub" pattern=""/>

 fmt 属性：
		type：  必填
		value：必填
		pattern：
			crypto：无
            url：无
            date：与SimpleDateFormate格式一致
            money：big-中文|comm-千分号|curr-千分号加本地货币符号|自定义与DecimalFormat格式一致
            string：截取字符串的长度       
           


                               1.<h:textarea>标签   文本

  格式：
  <h:textarea id="remark" name="remark" cols="30"   rows="2"  required="required"  disabled="true"  value="5"  readonly="true" />

  属性：
        id：非必填  元素的id值
        name: 必填  元素的名称
     	rows：非必填；输入字段中的字符的最大长度;
        rows：非必填  输入字段的最小值
      	required：非必填  required 必填 
        disabled：true 只读  
                 false：可读可写  默认为false
        readonly：非必填  禁用 
                  true：禁用  
                  flase:不禁用  默认值
         value： 非必填   默认值 
      
         style: 等于inputz中的style属性，可以再里面添加各种样式
 

    