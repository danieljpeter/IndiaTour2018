({
	doDrawSurprise : function(cmp, event, helper) {
		cmp.set( "v.draw1", helper.getSurprise());        
	},
	doDrawSurprise2 : function(cmp, event, helper) {
		cmp.set( "v.draw2", helper.getWhat());        
	},        
	doHide : function(cmp, event, helper) {
		cmp.set( "v.draw1", "");        
		cmp.set( "v.draw2", "");          
	}
})