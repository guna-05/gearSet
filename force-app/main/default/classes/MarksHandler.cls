public class MarksHandler {
	
    public static void topperOfCollege(List<Mark__c> newList, Map<Id, Mark__c> oldMap){
        Set<Id> studentIdSet = new Set<Id>();
        Set<ID> collegeIdSet = new Set<Id>();
        if(newList != Null){
            for(Mark__c mark : newList){
                if(oldMap == Null || mark.Total_Mark__c != oldMap.get(mark.Id).Total_Mark__c){
                    studentIdSet.add(mark.Student__c);
                }
            }
        }
        else{
            for(Id markId : oldMap.keySet()){
                studentIdSet.add(oldMap.get(markId).Student__c);
            }
        }
        
        if(studentIdSet.size()>0){
            for(Student__c collegeId : [SELECT College__c FROM Student__c WHERE Id IN :studentIdSet]){
                collegeIdSet.add(collegeId.College__c);
            }
        }
        System.debug(studentIdSet);
        System.debug(collegeIdSet);
        
        
        Map<Id, String> markToCollegeMap = new Map<Id, String>();
        for(AggregateResult aggr  : [SELECT Max(Total_Mark__c), Max(Maths__c), Student__r.First_Name__c FirstName, Student__r.Last_Name__c LastName, Student__r.College__c College
                                     FROM Mark__c 
                                     WHERE Student__r.College__c IN :collegeIdSet
                                     GROUP BY Student__r.College__c, Student__r.First_Name__c, Student__r.Last_Name__c 
                                     ORDER BY Max(Maths__c) DESC 
                                     LIMIT 1]){
                                         String fullName = aggr.get('FirstName') + ' ' + aggr.get('LastName');
                                         String collegeId = String.valueOf(aggr.get('College'));
                                         if(!markToCollegeMap.containsKey(collegeId)){
                                             markToCollegeMap.put(collegeId, fullName);
                                         }
                                         System.debug(aggr);
                                         
                                     }
        System.debug(markToCollegeMap);
        List<College__c> collegeList = new List<College__c>();
        for(ID clgId : markToCollegeMap.keySet()){
            College__c college = new College__c();
            college.Id = clgId;
            college.Topper_Student_Name__c = markToCollegeMap.get(clgId);
            collegeList.add(college);
        }
        
        UPDATE collegeList;
        
    }
}