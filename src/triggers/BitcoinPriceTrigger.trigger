trigger BitcoinPriceTrigger on Bitcoin_Price__c (before insert) {

    for (Bitcoin_Price__c b: Trigger.New) {
        b.Time__c = Datetime.newInstance(b.Timestamp__c.longValue() * 1000);
    }
    
}