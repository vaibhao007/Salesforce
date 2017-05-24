public class ExportProfileCon
{

    public String paginate { get; set; }

   public string SelectedProfileId {get;set;}
   public string EnteredEmail {get;set;}
   public set<id> ApexclassSet {get;set;}  
   public set<id> ApexPageSet {get;set;} 
   public set<id> AppSet {get;set;} 
   public List<Apexclass> ApexclassList {get;set;}  
   public List<ApexPage> ApexPageList {get;set;}  
   public List<AppMenuItem> AppsetList {get;set;}  
   public set<id> profileidset {get;set;}
   private set<id> selectedprofileidset {get;set;}
   private string profileAllName {get;set;}
   Public string profilename {get;set;}
   private Map<id,string> profilenameMap {get;set;}
   
   public ExportProfileCon(){
   
           ApexclassList =new List<Apexclass>();
           ApexPageList =new List<ApexPage>();
           AppsetList =new List<AppMenuItem>();
           SelectedProfileId ='None';
       }
   
   public String xlsHeader {
        get {
            String strHeader = '';
            strHeader += '<?xml version="1.0"?>';
            strHeader += '<?mso-application progid="Excel.Sheet"?>';
            return strHeader;
        }
    }
    public List<SelectOption> getProfiles() 
    {
         
                List<SelectOption> options = new List<SelectOption>();
                options.add(new SelectOption('None','--None--'));
                 options.add(new SelectOption('All','All'));
                List<Profile> profileList=[Select id,Name from  Profile];
                profileidset =new Set<id>();
                profilenameMap =new Map<id,string>();
                profileAllName='';
                for(Profile profil:profileList)
                {
                   // if(profil.id != null)
                  //  {
                    options.add(new SelectOption(profil.id,profil.name));
                    profileidset.add(profil.id);
                    profileAllName+=profil.name+',';
                    profilenameMap.put(profil.id,profil.name);
                  //  }
                }
            
                return options;
    }
    
    public void fetchProfilePermissions()
    {
     System.debug('SelectedProfileId$'+SelectedProfileId);
      if(string.isNotBlank(SelectedProfileId) && SelectedProfileId != 'None')
      {
          selectedprofileidset =new set<id>();
          
          if(SelectedProfileId == 'All')
          { 
            selectedprofileidset.addAll(profileidset);
            //profilename ='All';
          }
          else
          {
          selectedprofileidset.add(SelectedProfileId);
         // profilename =profilenameMap.get(SelectedProfileId);
          }
      getfetchObjectPermissions();
      getfetchFieldPermissions();
      fetchSetupEntityAccess();
      }
      else
      {
      
       ApexclassList =new List<Apexclass>();
           ApexPageList =new List<ApexPage>();
           AppsetList =new List<AppMenuItem>();
      }
    
    }
    
    public List<ObjectPermissions> getfetchObjectPermissions()
    {
     
           return [SELECT Id, SObjectType,PermissionsCreate, PermissionsRead, PermissionseDIT,PermissionsDelete,PermissionsModifyAllRecords,PermissionsViewAllRecords
    FROM ObjectPermissions WHERE parentid in (select id from permissionset where
    PermissionSet.Profile.Id in: selectedprofileidset ) limit 10000];
   }

    public List<FieldPermissions> getfetchFieldPermissions()
    {
    
return [SELECT Id, SObjectType, Field,PermissionsRead, PermissionsEdit FROM FieldPermissions WHERE parentid in (select id from permissionset where
PermissionSet.Profile.Id in: selectedprofileidset ) limit 10000];
   }

    public void fetchSetupEntityAccess()
    {
    
      List<SetupEntityAccess> SetupEntityAccessList=[SELECT Id, SetupEntityId, SetupEntityType
FROM SetupEntityAccess
WHERE ParentId in (select id from permissionset where
PermissionSet.Profile.Id In : selectedprofileidset )limit 10000];
ApexclassList =new List<Apexclass>();
           ApexPageList =new List<ApexPage>();
           AppsetList =new List<AppMenuItem>();
        if(SetupEntityAccessList.size() > 0)
        {
           ApexclassSet =new Set<id>();
           ApexPageSet =new Set<id>();
           AppSet =new Set<id>();
           
            
           
           for(SetupEntityAccess sea:SetupEntityAccessList)
           {
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
          ApexclassList =[select id,name from apexclass where id in:ApexclassSet];
          }
          if(ApexPageSet.size() > 0)
          {
          ApexPageList =[select id,name from ApexPage where id in:ApexPageSet];
          }
          if(AppSet.size() > 0)
          {
          AppsetList =[select id,ApplicationId,name from AppMenuItem where ApplicationId in:AppSet];
          System.debug('AppsetList :' + AppsetList );
          }
        
        }
    
        
   }
   
   public void exportAll()
   {
   try
   {
    if(SelectedProfileId != 'None' && SelectedProfileId != NULL)
    {
      if(Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}[.]{0,1}[a-zA-Z]{0,2}', EnteredEmail))
      {
          selectedprofileidset =new set<id>();
          
          if(SelectedProfileId == 'All')
          { 
            selectedprofileidset.addAll(profileidset);
           
            if(!Test.isRunningTest())
            {
           database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,'All','Object',EnteredEmail),2000);
           database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,'All','field',EnteredEmail),2000);
           database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,'All','Apps',EnteredEmail),2000);
           }
           else
           {
          // database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,'Apps',EnteredEmail));
           }
            
            
          }
          else
          {
          selectedprofileidset.add(SelectedProfileId);
           
            if(!Test.isRunningTest())
            {
           database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,profilenameMap.get(SelectedProfileId),'Object',EnteredEmail),2000);
           database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,profilenameMap.get(SelectedProfileId),'field',EnteredEmail),2000);
           database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,profilenameMap.get(SelectedProfileId),'Apps',EnteredEmail),2000);
           }
           else
           {
           //database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,'Apps',EnteredEmail));
           }
          }
           ApexclassList =new List<Apexclass>();
           ApexPageList =new List<ApexPage>();
           AppsetList =new List<AppMenuItem>();
           SelectedProfileId ='None';
           EnteredEmail='';
      }
      else
      {
           ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter valid email address')); 
      }
    }
    else
    {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please select a profile.');
        ApexPages.addMessage(myMsg);
    }
    } 
    catch(Exception ex)
    {
    system.debug('Export All Method$:'+ex);
    }
}


}