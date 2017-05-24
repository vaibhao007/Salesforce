/*************************************************************************************/
/****Developed By - Capgemini*******************/
/****W-000202- Count No. of Cases on Account****/
/*************************************************************************************/
trigger CaseTrigger on Case (after insert, after update, after delete, after undelete) 
{
  if(Trigger.isAfter && Trigger.isInsert) {

   CaseCountupdate.UpdateAccount(Trigger.new);
  }
     if((Trigger.isAfter && Trigger.isupdate )||(Trigger.isAfter && Trigger.isdelete) || (Trigger.isAfter && Trigger.isundelete)) {

    CaseCountupdate.UpdateAccount(Trigger.old);

  }
   
    
}