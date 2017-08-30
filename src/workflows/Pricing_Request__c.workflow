<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Pricing_Request_Accepted</fullName>
        <ccEmails>psullivan@vertiba.com</ccEmails>
        <description>Pricing Request Accepted</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Listing_Approvals/Pricing_Request_Accepted</template>
    </alerts>
    <alerts>
        <fullName>Pricing_Request_Rejected</fullName>
        <ccEmails>psullivan@vertiba.com</ccEmails>
        <description>Pricing Request Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Listing_Approvals/Pricing_Request_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Listing_Status_to_PR_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Pricing Request Approved</literalValue>
        <name>Set Listing Status to PR Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Listing__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Pricing_Request_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Pricing Request Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Pricing_Request_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Pricing Request Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Pricing_Request_Submit_Date</fullName>
        <description>Updates the Pricing Request submit date when pricing request is submitted</description>
        <field>Pricing_Request_Submit_Date__c</field>
        <formula>Today()</formula>
        <name>Update Pricing Request Submit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Pricing Request Set to Approved</fullName>
        <actions>
            <name>Set_Listing_Status_to_PR_Approved</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Pricing_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
