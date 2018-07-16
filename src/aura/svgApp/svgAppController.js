({
	doClear : function(cmp, event, helper) {    
		cmp.set( "v.bcLines", "");  
		cmp.set( "v.randCircles", "");         
		cmp.set( "v.contacts", "");         
    },      

	doDrawContacts : function(cmp, event, helper) {
        var action = cmp.get("c.contactQuery");

        action.setCallback(this, function(response) {
            var resp = response.getReturnValue();
            console.log('resp', resp);
			var svg = '';
            for (var i=0; i<resp.length; i++) {
				var c = resp[i];
        		var logo = helper.getSFlogo();     
                logo = logo.replace('{!svgId}', c.Id);
				logo = logo.replace('{!text}', c.Name);                
                svg += logo;
            }
            console.log(svg);            
            cmp.set( "v.contacts", svg);
        });
        $A.enqueueAction(action);        
	},    
    
	doDrawBitCoinLines : function(cmp, event, helper) {
        var action = cmp.get("c.bitcoinQuery");

        action.setCallback(this, function(response) {
            var resp = response.getReturnValue();
            console.log('resp', resp);
            var inner = '';
           	var height = 500;
            for (var i=0; i<resp.length; i++) {
				var bc = resp[i];
                var close = (bc.Close__c / 10);
                var x = (i * 1);
				inner += '<line x1="'+x+'" y1="'+(height-close)+'" x2="'+x+'" y2="'+height+'" style="stroke:rgb(255,0,0);stroke-width:1"/>';                
            }

			var draw1 = '<svg width="'+ (resp.length * 1) +'" height="'+height+'">';
			draw1 += inner;
            draw1 += '</svg>';  
            
            
            console.log(draw1);
            cmp.set( "v.bcLines", draw1);
        });
        $A.enqueueAction(action);        
	},
	doDrawRandomCircles : function(cmp, event, helper) {   
		var inner = '';

        var colors = ['red', 'yellow', 'black', 'white', 'green', 'blue', 'brown', 'cyan'];
        
        var width = 2000;
        var height = 1000;
            
        
        for (var i=0; i<1000; i++) {
            var cx = helper.getRandomInt(5, width);
            var cy = helper.getRandomInt(5, height);            
            var r = helper.getRandomInt(5, 50);   
            var strokeWidth = helper.getRandomInt(1, 10);   
			var strokeColor = colors[helper.getRandomInt(0, colors.length-1)];   
			var fillColor = colors[helper.getRandomInt(0, colors.length-1)];               
            
            inner += '<circle cx="'+cx+'" cy="'+cy+'" r="'+r+'" stroke="'+strokeColor+'" stroke-width="'+strokeWidth+'" fill="'+fillColor+'" />';
        }
        
        var draw1 = '<svg height="'+height+'" width="'+width+'">';
        draw1 += inner;
        draw1 += '</svg>';     
        cmp.set( "v.randCircles", draw1);        
    }
})