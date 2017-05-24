/****Developed By - Capgemini*******************/
/****W-000202- Count No. of Cases on Account****/
@IsTest
public class TestCaseCountupdate{

    Public static Testmethod void testcount(){
        Account acc = new Account();
        acc.name ='Test CaseCountTrigger';
        acc.RecordTypeId ='0124B0000004WD3';
        insert acc;
        
        Case cs = new Case();
        cs.Status = 'New';
        cs.AccountId =acc.Id;
        cs.Subject='Test11';
        insert cs;
        
        Case cs1 = new case();
        cs1.Status = 'New';
        cs1.Subject='Test12';
        insert cs1;
        
        List<Case> caseList = new List<Case>();
        caseList.add(cs);
        caseList.add(cs1);
        upsert caseList;
      
    }
    
}