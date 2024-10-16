public class LWCSelfLearning2Controller {
    
    
    public static List<Account> getAccountDetailsBySearch(String seachedString) {
        String tempString = '%'+seachedString+'%';
        List<Account> accountList = [SELECT Id, Name, Type, Industry, Rating 
                                     FROM Account 
                                     WHERE Name Like :tempString];
        return accountList;
    }
}