public class PopulateBitcoinBatch implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        String query = 
        'SELECT Id, Close__c, High__c, Low__c, Open__c, Time__c, Timestamp__c, Volume_BTC__c, Volume_Currency__c, Weighted_Price__c ' +
        'FROM Bitcoin_Price__c ORDER BY Time__c DESC';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Bitcoin_Price__c> scope){
		List<Bitcoin_Price_Big__b> bigs = new List<Bitcoin_Price_Big__b>();
        for(Bitcoin_Price__c b : scope) {
            bigs.add(
                new Bitcoin_Price_Big__b(
            		Close__c = b.Close__c,
                    High__c = b.High__c,
                    Low__c = b.Low__c,
                    Open__c = b.Open__c,
                    Time__c = b.Time__c,
                    Timestamp__c = b.Timestamp__c,
                    Volume_BTC__c = b.Volume_BTC__c,
                    Volume_Currency__c = b.Volume_Currency__c,
                    Weighted_Price__c = b.Weighted_Price__c
            	)
            );
        }
		database.insertImmediate(bigs);            
    }
    
    public void finish(Database.BatchableContext BC){
    }
}