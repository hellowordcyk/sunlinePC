
                                                                                                         �Զ����ǩ˵��

                               1.<h:text>��ǩ   �ı�

  ��ʽ��
  <h:text id="remark" name="remark" maxlength="20"   min="1"  readonly="readonly"  hidden="true"  value="5"  validate="required digits"  style="width:50px;"/>

  ���ԣ�
            id���Ǳ���  Ԫ�ص�idֵ
          name: ����  Ԫ�ص�����
     maxlength���Ǳ�������ֶ��е��ַ�����󳤶�;
           min���Ǳ���  �����ֶε���Сֵ
      readonly���Ǳ���  �Ƿ�ֻ��  
                  readonly��ֻ��  
                  false���ɶ���д  Ĭ��Ϊfalse
        hidden���Ǳ���  �Ƿ�����  
                  true������  
                  flase:������  Ĭ��ֵ
         value�� �Ǳ���   Ĭ��ֵ 
      validate�� �Ǳ��� �ֶ�У��  ����input��class
         style: ����inputz�е�style���ԣ�������������Ӹ�����ʽ
 


                               2.select��ǩ  �����б�

  ��ʽ��
  <h:select  id ="remark" name="remark"  datasrc="knp" dicttype="pams_traffic"  nulllable ="---��ѡ��----"  value="2" validate="required"  disabled="disabled" />

 ���ԣ�
         id���Ǳ���  Ԫ�ص�idֵ
       name������  Ԫ�ص�����
    datasrc������ �磺datasrc="knp"  
              knp:����pcmc_knp_para�� 
              bdss:����bdss_base_para��

   dicttype��"_"ǰ��Ϊϵͳ���ţ�
             "_"����Ϊ�ֵ����ͣ�
                                  ��:dicttype="pams_traffic"
  nulllable���Ǳ���  ǰ�������ѡ��   �磺nulllable ="---��ѡ��----"  key=" "  value = ---��ѡ��----
      value���Ǳ���   Ĭ��ֵ 
   validate: �Ǳ��� �ֶ�У��  ����input��class
   disabled: �޶�ֻ��
             disabled--ֻ��
 

                               3.radio��ǩ   ��ѡ��
   ��ʽ��
    <h:radio id="remark" name="remark"  datasrc="knp" dicttype="pams_traffic" value="3" linecount="3" />

  ���ԣ�
          id: �Ǳ���  Ԫ�ص�idֵ
        name: ����  Ԫ�ص�����
     datasrc: ���� �磺datasrc="knp" 
               knp:����pcmc_knp_para�� 
               bdss:����bdss_base_para��

    dicttype: "_"ǰ��Ϊϵͳ���ţ�
              "_"����Ϊ�ֵ����ͣ�
                                     ��:dicttype="pams_traffic"
       value: �Ǳ���   Ĭ��ֵ 
   linecount:ѡ�����ÿ����ʾ��ǩ������Ĭ����ʾ3��


                               4.date��ǩ   ���ڿؼ� 
   ��ʽ��
  <h:date id="remark"  name="remark" dateFmt="yyyy-MM-dd HH:mm:ss" minDate="2000-01-15" maxDate="2020-12-15"  readonly="false"  
                       value="2010-01-15 23:23:23"/>

   ���ԣ�
          id: �Ǳ���  Ԫ�ص�idֵ
        name: ����  Ԫ�ص�����
     minDate: �Ǳ��� ��С���� �磺minDate="2000-01-15"
     maxDate: �Ǳ��� ������� �磺maxDate="2020-12-15"
    readonly: �Ǳ���  �Ƿ�ֻ��  
               readonly��ֻ��  
               false���ɶ���д  Ĭ��Ϊfalse
       value: �Ǳ���   Ĭ��ֵ 

     dateFmt: �Ǳ���  ���ڸ�ʽ �磺dateFmt="yyyy-MM-dd HH:mm:ss"
               yyyy-MM-dd HH:mm:ss  ��-��-�� ʱ:��:��  û��ְ
               yyyy-MM-dd HH:mm     ��-��-�� ʱ:��
               yyyy-MM-dd HH        ��-��-�� ʱ
               yyyy-MM-dd           ��-��-��
               yyyy-MM              ��-��
               yyyy                 ��
              
              
                                5.write��ǩ    ֱ�ӽ�ֵ���
  ��ʽ��
  <h:write  name="funcname"   value="Ĭ��ֵ"  />

 ���ԣ�
       name������  Ԫ�ص�����
      value���Ǳ���   Ĭ��ֵ 
  
              
                                6.dwrite��ǩ    �������ֶ���ȡֵ ���
  ��ʽ��
  <h:dwrite  name="paratp"  datasrc="bdss" paramp="bdss" paratp="managerpost"  value="Ĭ��ֵ"  />

 ���ԣ�
       name������  Ԫ�ص�����
    datasrc������ �磺datasrc="knp"  
              knp:����pcmc_knp_para�� 
              bdss:����bdss_base_para��
      paramp��ϵͳ����
      paratp: �ֵ�����        
      
      value���Ǳ���   Ĭ��ֵ 

    
                               7.iterator��ǩ  
  ��ʽ��
  <h:iterator>
      <tr>
          <td>���</td>
          <td><a href="hello">����</a></td>
      </tr>
  </h:iterator>

 iterator ���ԣ�
       target��ѡ��
          rel��ѡ��
 
 
                               8.doPost��ǩ  
  ��ʽ��
<h:doPost var="tables" scope="request" sysName="funcpub" oprId="getTables" action="getAllTables" params="queryStr=${param.queryStr }"/>

 doPost ���ԣ�
		sysName��  ����
		oprId������
		action������
		params��ѡ�� ������ʽΪa=1&b=2&c=3��ʽ
		var��ѡ�� ���ؽ�����������Ĭ��ΪjrafPkg
		scope��ѡ�� ���ؽ�������JSP���ĸ�������У�Ĭ��Ϊrequest
                            
           
                               9.fmt��ǩ  
  ��ʽ��
<h:fmt type="crypto|url|date|money|string" value="funcpub" pattern=""/>

 fmt ���ԣ�
		type��  ����
		value������
		pattern��
			crypto����
            url����
            date����SimpleDateFormate��ʽһ��
            money��big-����|comm-ǧ�ֺ�|curr-ǧ�ֺżӱ��ػ��ҷ���|�Զ�����DecimalFormat��ʽһ��
            string����ȡ�ַ����ĳ���       
           


                               1.<h:textarea>��ǩ   �ı�

  ��ʽ��
  <h:textarea id="remark" name="remark" cols="30"   rows="2"  required="required"  disabled="true"  value="5"  readonly="true" />

  ���ԣ�
        id���Ǳ���  Ԫ�ص�idֵ
        name: ����  Ԫ�ص�����
     	rows���Ǳ�������ֶ��е��ַ�����󳤶�;
        rows���Ǳ���  �����ֶε���Сֵ
      	required���Ǳ���  required ���� 
        disabled��true ֻ��  
                 false���ɶ���д  Ĭ��Ϊfalse
        readonly���Ǳ���  ���� 
                  true������  
                  flase:������  Ĭ��ֵ
         value�� �Ǳ���   Ĭ��ֵ 
      
         style: ����inputz�е�style���ԣ�������������Ӹ�����ʽ
 

    