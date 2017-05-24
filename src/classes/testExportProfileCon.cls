@isTest(seeAlldata = true)
public class testExportProfileCon
{
   static testmethod void testExportProfile()
    {
    
        ExportProfileCon exprt = new ExportProfileCon();
        exprt.getProfiles();
        Profile prof=[select id from Profile where Name = 'System Administrator' limit 1];
        exprt.SelectedProfileId=prof.id; //exprt.getProfiles()[2].getValue();
        exprt.EnteredEmail ='abc@salesforce.com';
        exprt.fetchProfilePermissions();
        test.startTest();
        exprt.exportAll();
        exprt.SelectedProfileId=prof.id;
        exprt.EnteredEmail ='abc@salesforce.com';
        set<id> selectedprofileidset=new set<id>();
        selectedprofileidset.add(exprt.SelectedProfileId);
       
      // database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,'ProfileName','Apps',exprt.EnteredEmail),200);
        test.stopTest();
    }
    
   
}