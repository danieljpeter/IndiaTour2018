<aura:application extends="force:slds" controller="SVGappController">
	
    
    <aura:attribute name="draw1" type="String"/>
    <aura:attribute name="draw2" type="String"/>
    
    <div class="slds-p-around_medium">          
        <lightning:button label="SURPISE" onclick="{!c.doDrawSurprise}"/><lightning:button label="WHAT IS IT?" onclick="{!c.doDrawSurprise2}"/><lightning:button label="NO SURPRISE" onclick="{!c.doHide}"/><br/>
        <aura:unescapedHtml value="{!v.draw1}"/>
        <br/>
        <aura:unescapedHtml value="{!v.draw2}"/>        
    </div>
    

    
</aura:application>