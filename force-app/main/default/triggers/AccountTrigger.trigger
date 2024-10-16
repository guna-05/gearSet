trigger AccountTrigger on Account (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
   
    RunTriggers__mdt cmt = RunTriggers__mdt.getInstance('Account');
    if(cmt.Execute__c){
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            AccountTriggerHandler.updateFavColor(Trigger.New,Trigger.OldMap);
            AccountTriggerHandler.updateOpenOpportunity(Trigger.New,Trigger.OldMap);
        }
        if(Trigger.isBefore && Trigger.isUpdate){
            AccountTriggerHandler.updateOpenOpportunity(Trigger.New,Trigger.OldMap);
        }
        
        if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)){
            AccountTriggerHandler.updateSLAExpirationDateBeforeTrigger(Trigger.New,Trigger.OldMap);
        }
        
        if(Constants.runAccountTrigger && Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
            AccountTriggerHandler.updateSLAExpirationDateAfterTrigger(Trigger.New,Trigger.OldMap);
        }
        
        if(Trigger.isAfter && Trigger.isInsert){
            AccountTriggerHandler.createDefaultOpportunity(Trigger.New, Trigger.OldMap);
        }
    }
}