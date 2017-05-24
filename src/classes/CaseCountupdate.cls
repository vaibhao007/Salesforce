/****Developed By - Capgemini*******************/
/****W-000202- Count No. of Cases on Account****/
public class CaseCountupdate {
public static void UpdateAccount(List<Case> newList)
{
List<Case> caseList = [select id, status,AccountId from Case];//(trigger.isDelete)? trigger.old : trigger.new;
set<Id> accountIdSet = new set<Id>();
  Integer openCases=0;
  
  for(Case cs: caseList )
  {
     if(cs.AccountId != null)
     {
      accountIdSet.add(cs.AccountId);
     }
  }
if(accountIdSet.size() > 0)
{   
    List<Account> lstAccount = [select id, OM_Number_of_Open_Cases__c, (select id, status from Cases where status != 'closed')
    from Account where id IN: accountIdSet ];
       if(lstAccount.size() > 0)
       { 
          for(Account acc: lstAccount)
          { 
             acc.OM_Number_of_Open_Cases__c = acc.Cases.size();
             
             
          }
          update lstAccount;
       }}
}
}