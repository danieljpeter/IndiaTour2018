({
    doInit : function(component, event, helper) {

        component.set('v.cometdSubscriptions', []);
        component.set('v.notifications', []);
        // Disconnect CometD when leaving page
        window.addEventListener('unload', function(event) {
            helper.disconnectCometd(component);
        });
        // Retrieve session id
        var action = component.get('c.getSessionId');
        action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === 'SUCCESS') {
                component.set('v.sessionId', response.getReturnValue());
                if (component.get('v.cometd') != null)
                    helper.connectCometd(component);
            }
            else
                console.error(response);
        });
        $A.enqueueAction(action);
    },    
    onCometdLoaded : function(component, event, helper) {
        var cometd = new org.cometd.CometD();
        component.set('v.cometd', cometd);
        if (component.get('v.sessionId') != null) {
            helper.connectCometd(component);
        }
    },    
    doQueryApex: function(cmp, event, helper) {
        var action = cmp.get("c.queryApex");
        
        console.log('queryApex');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set( "v.apexQuery", JSON.stringify(response.getReturnValue()) );
		        cmp.set( "v.apexQueryLength", response.getReturnValue().length);                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    cmp.set( "v.apexQuery", JSON.stringify(errors) );
                }
            }
        });
        $A.enqueueAction(action);
    },
    doQueryVF: function(cmp, event, helper) {
        var params = {};
        params.type = 'doQueryVF';
        cmp.set("v.params", params);   		
    },       
    doRunReport: function(cmp, event, helper) {
        cmp.set("v.reportStatus", "");
        var action = cmp.get("c.runReport");
        action.setCallback(this, function(response) {
            cmp.set("v.reportInstanceId", response.getReturnValue()); 

            var interval = setInterval(function() {
                cmp.set("v.reportStatus", cmp.get("v.reportStatus")+'.');
                var checkAction = cmp.get("c.getReportResults");
                checkAction.setParams({instanceId: cmp.get("v.reportInstanceId")});
                checkAction.setCallback(this, function(checkResponse) {
                    var checkResponse = checkResponse.getReturnValue();
                    if (checkResponse !== false) {
                        cmp.set("v.reportResponse", checkResponse);
                        clearInterval(interval);                        
                    }
                });
                $A.enqueueAction(checkAction);
            }, 2000);    
            
        });
        $A.enqueueAction(action);
    },    
    doAJAXtoolkitQuery: function(cmp, event, helper) {
        var params = {};
        params.type = 'doAJAXtoolkitQuery';
        cmp.set("v.params", params);   		
    },
    handleRestResponse: function(cmp, event, helper) {
		var data = event.getParam("data");
        //console.log('data', data);
        if (data.type === 'doAJAXtoolkitQuery') {
            cmp.set( "v.AJAXtoolkitQueryLength", JSON.parse(data.payload).length);
            cmp.set( "v.AJAXtoolkitQuery", data.payload );            
        }
        
        if (data.type === 'doQueryVF') {
            cmp.set( "v.queryVFlength", JSON.parse(data.payload).length);
            cmp.set( "v.queryVF", data.payload );            
        }  
        
        if (data.type === 'doAsyncSOQLquery') {
            //cmp.set( "v.query2Length", JSON.parse(data.payload).length);
            cmp.set( "v.asyncJobId", data.payload );            
        }       
        
        if (data.type === 'doAsyncSOQL') {
            //cmp.set( "v.query2Length", JSON.parse(data.payload).length);
            cmp.set( "v.asyncJobId", data.payload );            
        }               

        if (data.type === 'doListAsyncSOQLqueries') {
            //cmp.set( "v.query2Length", JSON.parse(data.payload).length);
            cmp.set( "v.asyncSOQLquery", data.payload );            
        }            
        
    },
    doBatchApexQuery: function(cmp, event, helper) {
        var action = cmp.get("c.batchApexQuery");
        action.setCallback(this, function(response) {
            cmp.set( "v.batchApexJobId", response.getReturnValue());
        });
        $A.enqueueAction(action);	
    },          
    doAsyncSOQLquery: function(cmp, event, helper) {
        var params = {};
        params.type = 'doAsyncSOQL';
        cmp.set("v.params", params);   		
    },    
    doListAsyncSOQLqueries: function(cmp, event, helper) {
        var params = {};
        params.type = 'doListAsyncSOQLqueries';
        cmp.set("v.params", params);   		
    },        
    
    
})