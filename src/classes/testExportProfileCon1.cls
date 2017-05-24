@isTest(seeAlldata = true)
public class testExportProfileCon1
{
  
    
    static testmethod void testExportProfile1()
    {
    
        Profile prof=[select id from Profile where Name = 'System Administrator' limit 1];
        test.startTest();
         set<id> selectedprofileidset=new set<id>();
        selectedprofileidset.add(prof.id);
       
        database.executebatch(new ExportProfileBatchProcess(selectedprofileidset,'ProfileName','Apps','softramki@gmail.com'),2000);
        test.stopTest();
    }
}