public class QueryBitcoinBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    public List<Bitcoin_Price__c> allScope;
    
    public QueryBitcoinBatch(){
        allScope = new List<Bitcoin_Price__c>();
    }    
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 
            'SELECT Id, High__c, Low__c FROM Bitcoin_Price__c WHERE Low__c >= 1782.3000 AND Low__c <= 1782.4000';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Bitcoin_Price__c> scope){
        allScope.addAll(scope);
    }
    
    public void finish(Database.BatchableContext BC){
        Map<String, Object> retObj = new Map<String, Object>{'jobId' => (BC.getJobId()+'').left(15), 'allScope' => allScope};
        Eventbus.publish(new Bitcoin_Calculation__e(Data__c=JSON.serialize(retObj)));
    }
}