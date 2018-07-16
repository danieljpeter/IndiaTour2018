public class PopulateBitcoinHyperbatch implements HyperBatch {

    public HyperBatchObjects.HyperBatchStart start() {
        String query = 
        'SELECT Id, Close__c, High__c, Low__c, Open__c, Time__c, Timestamp__c, Volume_BTC__c, Volume_Currency__c, Weighted_Price__c ' +
        'FROM Bitcoin_Price__c';        
        return new HyperBatchObjects.HyperBatchStart('Bitcoin_Price__c', query);       
    }    
    
    public Object execute(List<sObject> scope) {
		List<Bitcoin_Price_Big__b> bigs = new List<Bitcoin_Price_Big__b>();
        for(sObject s: scope) {
            Bitcoin_Price__c b = (Bitcoin_Price__c)s;
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
            
		return null;        
    }
    
    public void finish(List<Object> state) {
    }   
}