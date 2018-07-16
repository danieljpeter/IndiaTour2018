public class SVGappController {

    @AuraEnabled
    public static List<Contact> contactQuery() {
        return [SELECT Id, Name, Title, Phone, Email FROM Contact WHERE Title != null];
    }
    
    @AuraEnabled
    public static List<Bitcoin_Price__c> bitcoinQuery() {
        return [SELECT Id, Close__c, Time__c FROM Bitcoin_Price__c ORDER BY Time__c limit 50000];
    }

}