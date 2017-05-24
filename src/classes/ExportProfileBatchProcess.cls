global class ExportProfileBatchProcess implements Database.Batchable<SObject>, Database.Stateful {
    string[] Lines;
    string profileName;
    String ObjectfetchQuery;
    Set<id> selectProfileId;
    string type;
    string Mail;
    public set<id> ApexclassSet {get;set;}  
    public set<id> ApexPageSet {get;set;} 
    public set<id> AppSet {get;set;} 
    public List<Apexclass> ApexclassList {get;set;}  
    public List<ApexPage> ApexPageList {get;set;}  
    public List<AppMenuItem> AppsetList {get;set;} 
     
    Map<id,ObjectPermissions> MapObjectPermission {get;set;}
    
    Map<id,FieldPermissions > MapFieldPermission  {get;set;}
 
    string csvObjectHeader = 'ProfileName,SObjectType, PermissionsCreate, PermissionsRead,PermissionseDIT,PermissionsDelete,PermissionsModifyAllRecords,PermissionsViewAllRecords \n';
    string csvFieldHeader = 'ProfileName,SObjectType, Field, Read,Edit \n';
    string csvAppHeader = 'ProfileName,Type, Name \n';
    
         
    global ExportProfileBatchProcess(set<Id> profileId,string profilenme,string typ,String email)
    {
        selectProfileId = profileId;
        profileName=profilenme;
        type=typ;
        Mail = email;
        system.debug('selectProfileId :' + selectProfileId);
        if(type=='Object')
        {
        ObjectfetchQuery = 'SELECT Id,Parent.ProfileId, Parent.Profile.Name, SObjectType,PermissionsCreate, PermissionsRead, PermissionsEdit,PermissionsDelete,PermissionsModifyAllRecords,PermissionsViewAllRecords FROM ObjectPermissions WHERE parentid in (select id from permissionset where PermissionSet.Profile.Id in: selectProfileId)';
        }
        else if(type=='field')
        {
        ObjectfetchQuery = 'SELECT Id,Parent.ProfileId, Parent.Profile.Name, SObjectType, Field,PermissionsRead, PermissionsEdit FROM FieldPermissions WHERE parentid in (select id from permissionset where PermissionSet.Profile.Id in: selectProfileId)';
        }
        else if(type=='Apps')
        {
        ObjectfetchQuery = 'SELECT Id,Parent.ProfileId, Parent.Profile.Name , SetupEntityId, SetupEntityType FROM SetupEntityAccess WHERE ParentId in (select id from permissionset where PermissionSet.Profile.Id In : selectProfileId)';
        }
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        lines = new String[0];  
       return Database.getQueryLocator(ObjectfetchQuery);
    }
    global void execute(Database.BatchableContext bc, SObject[] scope) {
       
            String line = '';
            string mainContent = '';
            string fieldContent='';  
            if(type!='Apps') 
            {      
                for (Sobject objs: scope)            
                {       
                    
                        string recordString ;
                        if(type=='Object')
                        {
                            ObjectPermissions obj = (ObjectPermissions )objs;
                            recordString = obj.Parent.Profile.Name+','+obj.SObjectType+','+obj.PermissionsCreate+','+obj.PermissionsRead+','+obj.PermissionseDIT+','+obj.PermissionsDelete+','+obj.PermissionsModifyAllRecords+','+obj.PermissionsViewAllRecords+'\n';
                        }
                        else if(type=='field')
                        {
                            FieldPermissions obj = (FieldPermissions )objs;
                            recordString = obj.Parent.Profile.Name+','+obj.SObjectType+','+obj.Field+','+obj.PermissionsRead+','+obj.PermissionseDIT+'\n';                   
                        }
                       mainContent += recordString;
                }
            }
                 if(type=='Apps')
                    {
                        ApexclassList =new List<Apexclass>();
                        ApexPageList =new List<ApexPage>();
                        AppsetList =new List<AppMenuItem>();
                        if(scope.size() > 0)
                        {
                        ApexclassSet =new Set<id>();
                        ApexPageSet =new Set<id>();
                        AppSet =new Set<id>();
                        
                        string recordString;
                        for(Sobject  sea1:scope)
                        {
                         SetupEntityAccess sea=(SetupEntityAccess)sea1;
                         if(sea.SetupEntityType =='ApexClass')
                         {
                         ApexclassSet.add(sea.SetupEntityId);
                         }
                         else if(sea.SetupEntityType =='ApexPage')
                         {
                             ApexPageSet.add(sea.SetupEntityId);
                         }
                         else 
                         {
                             AppSet.add(sea.SetupEntityId);
                         }
                        }
                        
                        if(ApexclassSet.size() > 0)
                        {
                       // ApexclassList =[select id,name from apexclass where id in:ApexclassSet];
                       ApexclassList =[SELECT Id, Name,(SELECT Id,ParentId, Parent.Name, Parent.Profile.Name FROM SetupEntityAccessItems ) FROM ApexClass where id in:ApexclassSet];
                        }
                        if(ApexPageSet.size() > 0)
                        {
                       ApexPageList =[select id,name,(SELECT Id,ParentId, Parent.Name, Parent.Profile.Name FROM SetupEntityAccessItems ) from ApexPage where id in:ApexPageSet];
                        }
                        if(AppSet.size() > 0)
                        {
                        AppsetList =[select id,ApplicationId,name from AppMenuItem where ApplicationId in:AppSet];
                        System.debug('AppsetList :' + AppsetList );
                        }
                       
                        if(ApexclassList.size() > 0)
                        {
                        
                          for(apexclass cls: ApexclassList)
                          {
                            if(cls.SetupEntityAccessItems != null && cls.SetupEntityAccessItems.size() >0)
                            {
                                for(SetupEntityAccess acc: cls.SetupEntityAccessItems)
                                {
                                 
                                 recordString = acc.Parent.Profile.Name+','+ 'ApexClass'+','+cls.Name+'\n';
                                  mainContent += recordString; 
                                }
                            }
                          
                          } 
                        
                        }
                        if(ApexPageList.size() > 0)
                        {
                         
                           for(ApexPage pge: ApexPageList )
                          {
                          if(pge.SetupEntityAccessItems != null && pge.SetupEntityAccessItems.size() >0)
                            {
                                for(SetupEntityAccess acc: pge.SetupEntityAccessItems)
                                {
                                 
                                 recordString = acc.Parent.Profile.Name+','+ 'ApexPage'+','+pge.Name+'\n';
                                  mainContent += recordString; 
                                }
                            }
                          } 
                         
                        }
                        if(AppsetList.size() > 0)
                        {
                        
                          for(AppMenuItem app: AppsetList)
                          {
                           recordString =' '+','+ 'App'+','+app.Name+'\n';
                           mainContent += recordString; 
                          } 
                                              
                        }
                           
                        }
                    
                    }
            
            lines.add(mainContent);
            system.debug('mainContent$'+mainContent);
            system.debug('mainContent$'+lines);
       
    }
    global void finish(Database.batchablecontext bc) {
       String finalResults;
       String csvname='';
       if(type=='Object')
        {
        finalResults =csvObjectHeader+String.join(lines, '\n');
         csvname= ''+profileName+'-ObjectLevelPermissions'+'.csv';
        }
        else if(type=='field')
         {
          finalResults =csvFieldHeader +String.join(lines, '\n');
            csvname= ''+profileName+'-FieldLevelPermissions'+'.csv';
         }
          else if(type=='Apps')
         {
          finalResults =csvAppHeader +String.join(lines, '\n');
           csvname= ''+profileName+'-ApexClass-ApexPage-Apps'+'.csv';
         }
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        blob csvBlob = Blob.valueOf(finalResults); //updatedEntities
       
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {Mail}; 
        email.setSubject('Exported Profile Workbook Details');  
        email.setPlainTextBody('Hi , Please find the attached '+ profileName +' Profile Details...');
        email.setToAddresses( toAddresses );
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        system.debug('email sent');
        lines = null; 
    }
}