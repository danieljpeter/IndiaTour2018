({
    doInit: function(component, event, helper) {
        var baseURL = 'https://' + helper.extractDomain(window.location.href);
		console.log('baseURL');
		console.log(baseURL);	
        
        var iframeURL = baseURL + '/apex/' + 'restQueryPage';

        component.set("v.iframeURL", iframeURL);     
        console.log('URL : ' + iframeURL);
        
        //listen to iframe's message
        addEventListener("message", 
          function(event) {
			if(component.isValid()) {              
                if(event.data.type === 'ready' && component.find("restQueryIframe")) {//iframe loaded
                    component.iframeReady = true;   
                } else if ((event.data.type === 'doAsyncSOQLquery') || 
                           (event.data.type === 'doQueryVF') || 
                           (event.data.type === 'doAsyncSOQL') || 
                           (event.data.type === 'doListAsyncSOQLqueries') || 
                           (event.data.type === 'doAJAXtoolkitQuery')) {
					//console.log('addEventListener type', event.data.type);
                    //console.log('addEventListener event', event);
					//console.log('addEventListener payload', JSON.stringify(event.data.payload));
                    var appEvent = $A.get("e.c:RestQueryResponse");
                    var data = {};
                    data.type = event.data.type;
                    data.payload = event.data.payload;
                    appEvent.setParams({ "data" : data});
                    appEvent.fire();                          
                }               
            }
    	  }, 
        false);
    },
	makeRequest : function(component, event, helper) {
       helper.makeRequest(component, event); 
	}
})