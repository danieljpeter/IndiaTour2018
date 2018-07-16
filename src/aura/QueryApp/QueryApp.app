<aura:application extends="force:slds" controller="QueryAppController">
	
    <ltng:require scripts="{!$Resource.cometd}" afterScriptsLoaded="{!c.onCometdLoaded}"/>
    <aura:attribute name="sessionId" type="String"/>
    <aura:attribute name="cometd" type="Object"/>
    <aura:attribute name="cometdSubscriptions" type="Object[]"/>
    <aura:attribute name="notifications" type="Object[]"/>
    <aura:attribute name="eventMessage" type="String"/>
    
    <aura:attribute name="apexQuery" type="String"/>    
	<aura:attribute name="apexQueryLength" type="Integer"/>       

	<aura:attribute name="queryVF" type="String"/>    
	<aura:attribute name="queryVFlength" type="Integer"/>      
    
    <aura:attribute name="reportInstanceId" type="String"/>        
    <aura:attribute name="reportStatus" type="String"/>     
    <aura:attribute name="reportResponse" type="String"/>         

    <aura:attribute name="AJAXtoolkitQuery" type="String"/>    
	<aura:attribute name="AJAXtoolkitQueryLength" type="Integer"/>        
    
    <aura:attribute name="batchApexJobId" type="String"/>        
    <aura:attribute name="batchApexQuery" type="String"/>   
    
    <aura:attribute name="asyncJobId" type="String"/>        
    <aura:attribute name="asyncSOQLlength" type="String"/>     
    <aura:attribute name="asyncSOQLquery" type="String"/>         


	<aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
    <aura:handler event="c:RestQueryResponse" action="{!c.handleRestResponse}"/>       
    
    <aura:attribute name="params" type="Object"/>    
    <c:restQueryComponent params="{!v.params}" />
    
    <div class="slds-p-around_medium">
        Platform Event Messages<br/>
        <textarea style="width:100%; height:100px">{!v.eventMessage}</textarea><br/>    
        <br/><br/>
        
        <lightning:button label="Query Via Apex" onclick="{!c.doQueryApex}"/><br/>
        Record Count: {!v.apexQueryLength} <br/>
        <textarea style="width:100%; height:200px">{!v.apexQuery}</textarea><br/>    
        
        <br/><br/>
        
        
        <lightning:button label="Query Via VF Remote Action" onclick="{!c.doQueryVF}"/><br/>
        Record Count: {!v.queryVFlength} <br/>
        <textarea style="width:100%; height:200px">{!v.queryVF}</textarea><br/>    
        
        <br/><br/>
        
        
        <lightning:button label="Query Via Reporting API" onclick="{!c.doRunReport}"/><br/>
        Report Instance Id: {!v.reportInstanceId} <br/>
        {!v.reportStatus} <br/>
        <textarea style="width:100%; height:200px">{!v.reportResponse}</textarea><br/>
        <br/><br/> 
        
        <lightning:button label="Query Via AJAX toolkit" onclick="{!c.doAJAXtoolkitQuery}"/><br/>
        Record Count: {!v.AJAXtoolkitQueryLength} <br/>
        <textarea style="width:100%; height:200px">{!v.AJAXtoolkitQuery}</textarea><br/>        
        
        <br/><br/> 
        
        <lightning:button label="Query Via Batch Apex (QueryLocator)" onclick="{!c.doBatchApexQuery}"/><br/>
        Batch Apex Job Id: {!v.batchApexJobId} <br/>    
        <br/><br/> 
        
        <lightning:button label="Query Via Async SOQL" onclick="{!c.doAsyncSOQLquery}"/>  <lightning:button label="List Async SOQL queries" onclick="{!c.doListAsyncSOQLqueries}"/><br/>
        Async SOQL Job Id: {!v.asyncJobId} <br/>
        Record Count: {!v.asyncSOQLlength} <br/>
        <textarea style="width:100%; height:200px">{!v.asyncSOQLquery}</textarea><br/>            
        
    </div>
    

    
</aura:application>