<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Marketing_Plan_Approved</fullName>
        <ccEmails>psullivan@vertiba.com</ccEmails>
        <description>Marketing Plan Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Listing_Approvals/Marketing_Plan_Accepted</template>
    </alerts>
    <alerts>
        <fullName>Marketing_Plan_Rejected</fullName>
        <ccEmails>psullivan@vertiba.com</ccEmails>
        <description>Marketing Plan Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Listing_Approvals/Marketing_Plan_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Marketing_Plan_Approval_Date</fullName>
        <field>Marketing_Plan_Approval_Date__c</field>
        <formula>Today()</formula>
        <name>Set Marketing Plan Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Marketing_Plan_Submit_Date_to_Today</fullName>
        <description>When the Marketing Plan is submitted for approval, the Marketing Plan Submit Date is set to the current day.</description>
        <field>Marketing_Plan_Submit_Date__c</field>
        <formula>Today()</formula>
        <name>Set Marketing Plan Submit Date to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Marketing_Plan_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Marketing Plan to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMarketingPlantoApproved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>UpdateMarketingPlantoApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Listing_to_Marketing_Plan_Approve</fullName>
        <field>Status__c</field>
        <literalValue>Marketing Plan Approved</literalValue>
        <name>Update Listing to Marketing Plan Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Listing__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Marketing Plan Approved</fullName>
        <actions>
            <name>Update_Listing_to_Marketing_Plan_Approve</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Marketing_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Listing__c.Status__c</field>
            <operation>equals</operation>
            <value>Pricing Request Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
