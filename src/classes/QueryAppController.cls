global class QueryAppController {

    @AuraEnabled
    public static List<Bitcoin_Price__c> queryApex() {
        return [SELECT Id, Close__c, Time__c FROM Bitcoin_Price__c ORDER BY Time__c limit 50001];
    }
    
    @RemoteAction @ReadOnly
    global static List<Bitcoin_Price__c> queryVFremote() {
        return [SELECT Id, Close__c, Time__c FROM Bitcoin_Price__c ORDER BY Time__c LIMIT 100000];
    }    
    
    @AuraEnabled
    public static String batchApexQuery() {
		return Database.executeBatch(new QueryBitcoinBatch(), 2000)+'';        
    }    
    
    @RemoteAction @ReadOnly
    global static String asyncSOQLquery() {

        String query =
        '{'+
        '  "query": "SELECT Time__c, High__c FROM Bitcoin_Price_Big__b WHERE High__c=8117.02",'+
        '  "operation": "insert",'+
        '  "targetObject": "Bitcoin_Query_Result__c",'+
        '  "targetFieldMap": {'+
        '    "Time__c": "Time__c",'+
        '    "High__c": "High__c"'+
        '  },'+
        '  "targetValueMap": {'+
        '    "$JOB_ID": "Background_Operation__c"'+
        '  }'+
        '}';    
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setEndpoint('https://indiatour-dev-ed.my.salesforce.com/services/data/v43.0/async-queries');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        req.setBody(query);
        
        res = http.send(req);
        String rBody = res.getBody();
		Map<String, Object> resObj = (Map<String, Object>)JSON.deserializeUntyped(rBody); 
		String jobId = (String)resObj.get('jobId');                
        
        return jobId;
    }        
    
    @RemoteAction @ReadOnly
    global static String asyncSOQLqueries() {
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();

        req.setEndpoint('https://indiatour-dev-ed.my.salesforce.com/services/data/v43.0/async-queries');
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
        
        res = http.send(req);
        String rBody = res.getBody();
		//Map<String, Object> resObj = (Map<String, Object>)JSON.deserializeUntyped(rBody); 
		//String jobId = (String)resObj.get('jobId');                
        return rBody;
    }           
    
    
    

/*
    @AuraEnabled
    public static List<Bitcoin_Price_Big__b> queryApex() {
        return [SELECT Id, Close__c, Time__c FROM Bitcoin_Price_Big__b ORDER BY Close__c LIMIT 1];
    }    
*/    
    
    @AuraEnabled
    public static Id runReport() {
        return reports.ReportManager.runAsyncReport('00Of2000005tGnLEAU', true).getId();
    }    
    
    @AuraEnabled
    public static Object getReportResults(Id instanceId) {
        Reports.ReportInstance instanceObj = Reports.ReportManager.getReportInstance(instanceId);
        if (instanceObj.getStatus() == 'Success') {
			return JSON.serialize(instanceObj.getReportResults());
        } else {
            return false;
        }
    }        

    
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }    

    @RemoteAction
    global static Object doBulkQuery() {
		String reqBody =
        '{'+
        '  "operation": "query",'+
        '  "object": "Bitcoin_Price__c",'+
        '  "concurrencyMode": "Parallel",'+
        '  "contentType": "JSON"'+
        '}';            

        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        
        req.setEndpoint('https://indiatour-dev-ed.my.salesforce.com/services/async/43.0/job');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('X-SFDC-Session', UserInfo.getSessionId());

        req.setBody(reqBody);
        res = http.send(req);
		String rBody = res.getBody();
		Map<String, Object> resObj = (Map<String, Object>)JSON.deserializeUntyped(rBody); 
		String theId = (String)resObj.get('id');
        
        
        
        String query = 'SELECT Id, Close__c, Time__c FROM Bitcoin_Price__c ORDER BY Time__c LIMIT 1000';
        req = new HttpRequest();
        res = new HttpResponse();
        http = new Http();
        
        req.setEndpoint('https://indiatour-dev-ed.my.salesforce.com/services/async/43.0/job/'+theId+'/batch');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json; charset=utf-8');
        req.setHeader('X-SFDC-Session', UserInfo.getSessionId());

        req.setBody(query);
        res = http.send(req);
		rBody = res.getBody();
        
		resObj = (Map<String, Object>)JSON.deserializeUntyped(rBody); 
		String jobId = (String)resObj.get('jobId');        
        
        return jobId;
    }    

    
}