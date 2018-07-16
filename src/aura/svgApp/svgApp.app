<aura:application extends="force:slds" controller="SVGappController">
	
    
    <aura:attribute name="bcLines" type="String"/>
    <aura:attribute name="randCircles" type="String"/>    
    <aura:attribute name="contacts" type="String"/>
    
    <div class="slds-p-around_medium">          
        <lightning:button label="Clear" onclick="{!c.doClear}"/><br/><br/>
        <lightning:button label="Draw Bitcoin Lines" onclick="{!c.doDrawBitCoinLines}"/>
        <lightning:button label="Draw Random Circles" onclick="{!c.doDrawRandomCircles}"/>        
        <lightning:button label="Draw Contacts" onclick="{!c.doDrawContacts}"/>               
        <br/>
        <aura:unescapedHtml value="{!v.bcLines}"/>
		<br/>
        <aura:unescapedHtml value="{!v.randCircles}"/>       
		<br/>
        <aura:unescapedHtml value="{!v.contacts}"/>             
    </div>
    

    
</aura:application>