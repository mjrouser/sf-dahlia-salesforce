<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>HAI_Copy_Total_Other_Income</fullName>
        <description>Copy &quot;Total Other Income Rec&apos;d Annually&quot; formula field into &quot;Total Other Income Rec&apos;d Annually (RS)&quot; currency field</description>
        <field>Total_Other_Income_Rec_d_Annually_RS__c</field>
        <formula>Total_Other_Income_Rec_d_Annually__c</formula>
        <name>HAI - Copy Total Other Income</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>HAI - Total Other Income copy for Rollup Summary</fullName>
        <actions>
            <name>HAI_Copy_Total_Other_Income</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Housing_Application_Income__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Housing Application Income - Copy the formula field for Total Other Income Rec&apos;d Annually into a separate currency field Total Other Income Rec&apos;d Annually (RS) for use on a rollup summary field</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
