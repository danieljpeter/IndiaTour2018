({
    makeRequest : function(component, event) {
        //This is to handle 'call before load' scenario.
        //Most of the times iframe is already loaded for user-click scenarios 
        //and there wont be any wait
        var interval = setInterval(function(){ waitForiFrameAndMakeRequest() }, 10);

        function waitForiFrameAndMakeRequest() {
            if(!component.iframeReady) return;
            
            clearInterval(interval);//stop setInterval
            var vfIframe = component.find("restQueryIframe").getElement().contentWindow;
            vfIframe.postMessage(component.get("v.params"), '*');   
        } 
    },
    extractDomain : function (url) {
        var domain;
        //find & remove protocol (http, ftp, etc.) and get domain
        if (url.indexOf("://") > -1) {
            domain = url.split('/')[2];
        }
        else {
            domain = url.split('/')[0];
        }
        
        //find & remove port number
        domain = domain.split(':')[0];
        
        return domain;
    }    
    
})