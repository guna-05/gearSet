public class AccountTriggerHandler {
    
    public static void updateOpenOpportunity(List<Account> newList, Map<Id, Account> oldMap){
        Id currentUserProfileId = UserInfo.getProfileId();
        List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Id =: currentUserProfileId];
        if(profileList.size()>0 && profileList.get(0).Name == 'Demo Profile'){
            Set<Id> accountIdSet = new Set<Id>();
            for(Account acc : newList){
                if(oldMap == Null || (acc.Active__c != oldMap.get(acc.Id).Active__c)){
                    if(acc.Active__c == 'No'){
                        accountIdSet.add(acc.Id);
                    }
                }
            }
            if(profileList.size()>0){
                List<Opportunity> opportunityList = [SELECT Id, isClosed, StageName 
                                                    FROM Opportunity
                                                    WHERE AccountId IN :accountIdSet
                                                    AND isClosed = false];
                for(Opportunity opp : opportunityList){
                    opp.StageName = 'Closed Lost';
                    opp.Closed_Lost_Reason__c = 'Opportunity is closed!';
                }
                UPDATE opportunityList;
                
            }
        }
    }
    
    public static void updateFavColor(List<Account> newList, Map<Id, Account> oldMap){
        Set<Id> ownerIdSet = new Set<Id>();
        for(Account acc : newList){
            if(oldMap == Null || acc.OwnerId != oldMap.get(acc.Id).ownerId){
                ownerIdSet.add(acc.OwnerId);    
            }
        }
        if(ownerIdSet.size() > 0 ){
            Map<ID, String> userToFavColor = new Map<ID,String>();
            for(User usr : [SELECT Id, Favorite_Color__c FROM User WHERE Id IN :ownerIdSet]){
                userToFavColor.put(usr.Id, usr.Favorite_Color__c);
            }
            for(Account acc : newList){
                if(oldMap == Null || acc.OwnerId != oldMap.get(acc.Id).ownerId){
                    acc.Favorite_Color__c = userToFavColor.get(acc.OwnerId);
                }
            }
            //System.assert(false, 'This is a Test Message');
        }
    }
    
    public static void updateSLAExpirationDateBeforeTrigger(List<Account> newList, Map<Id, Account> oldMap){
        for(Account acc : newList){
            acc.SLAExpirationDate__c = Date.today() + 180;
        }
    }
    
    public static void updateSLAExpirationDateAfterTrigger(List<Account> newList, Map<Id, Account> oldMap){
        List<Account> accountList = new List<Account>();
        for(Account acc : newList){
            Account temp = new Account();
            temp.Id = acc.Id;
            temp.SLAExpirationDate__c = Date.today() + 180;
            accountList.add(temp);
        }
        if(accountList.size() > 0){
            Constants.runAccountTrigger = false;
            UPDATE accountList;
        }
    }
    
    public static void createDefaultOpportunity(List<Account> newList, Map<Id, Account> oldMap){
        List<Opportunity> oppList = new List<Opportunity>();
        for(Account acc : newList){
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name + '- Default Opp';
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today() + 30;
            opp.AccountId = acc.Id;
            oppList.add(opp);
        }
        if(oppList.size() > 0){
            Constants.runOpportunityTrigger = false;
            INSERT oppList;
        }
    }
}