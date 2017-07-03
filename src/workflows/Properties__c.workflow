<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LISTING_Marketing_Plan_Approved</fullName>
        <description>LISTING:Marketing Plan Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LISTING_Marketing_Plan_Approved</template>
    </alerts>
    <alerts>
        <fullName>LISTING_Marketing_Plan_MOHCD_Follow_up_Details</fullName>
        <description>LISTING:Marketing Plan MOHCD Follow-up Details</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LISTING_Marketing_Plan_Follow_up_Details</template>
    </alerts>
    <alerts>
        <fullName>LISTING_Marketing_Plan_Submit_Reply</fullName>
        <ccEmails>aissia.ashoori@sfgov.org</ccEmails>
        <description>LISTING:Marketing Plan Submitted.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LISTING_Marketing_Plan_Submit_Reply</template>
    </alerts>
    <alerts>
        <fullName>LISTING_Pricing_Request_Approved</fullName>
        <description>LISTING:Pricing Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LISTING_Pricing_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>LISTING_Pricing_Request_MOHCD_Follow_up_Details</fullName>
        <description>LISTING:Pricing Request MOHCD Follow-up Details</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LISTING_Pricing_Request_MOHCD_Follow_up_Details</template>
    </alerts>
    <alerts>
        <fullName>LISTING_Pricing_Request_Submit_Reply</fullName>
        <ccEmails>aissia.ashoori@sfgov.org</ccEmails>
        <description>LISTING:Pricing Request Submitted.</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LISTING_Pricing_Request_Submit_Reply</template>
    </alerts>
    <fieldUpdates>
        <fullName>PROPERTY_Marketing_Plan_Approval_Date</fullName>
        <description>Update Marketing Plan Approval Date with today&apos;s date.</description>
        <field>Marketing_Plan_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>PROPERTY:Marketing Plan Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PROPERTY_Marketing_Plan_Submit_Date</fullName>
        <description>Update Marketing Plan Submit Date with today&apos;s date.</description>
        <field>Marketing_Plan_Submit_Date__c</field>
        <formula>TODAY()</formula>
        <name>PROPERTY:Marketing Plan Submit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PROPERTY_Marketing_Plan_Submitted</fullName>
        <description>Update Marketing Plan Approval Status to &quot;Submitted&quot; when the Marketing Plan Ready for Approval checkbox is checked.</description>
        <field>Marketing_Plan_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>PROPERTY:Marketing Plan Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PROPERTY_Pricing_Request_Approval_Date</fullName>
        <description>Update Pricing Request Approval Date with today&apos;s date.</description>
        <field>Pricing_Request_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>PROPERTY:Pricing Request Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PROPERTY_Pricing_Request_Submit_Date</fullName>
        <description>Update Pricing Request Submit Date with today&apos;s date.</description>
        <field>Pricing_Request_Submit_Date__c</field>
        <formula>TODAY()</formula>
        <name>PROPERTY:Pricing Request Submit Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Request_Submitted</fullName>
        <description>Update Pricing Request Approval Status to &quot;Submitted&quot; when the Pricing Request Ready for Approval checkbox is checked.</description>
        <field>Pricing_Request_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>PROPERTY:Pricing Request Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>LISTING%3AMarketing Plan Approved</fullName>
        <actions>
            <name>LISTING_Marketing_Plan_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Properties__c.Marketing_Plan_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Marketing Plan is approved. Email is sent to the PA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3AMarketing Plan Status - Submitted</fullName>
        <actions>
            <name>LISTING_Marketing_Plan_Submit_Reply</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Properties__c.Marketing_Plan_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>PA submits Marketing Plan and uploads supporting documents. Send email notification to PA and to MOHCD Team for review.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3AMarketing Plan Update Approval Status - Submitted</fullName>
        <actions>
            <name>PROPERTY_Marketing_Plan_Submit_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PROPERTY_Marketing_Plan_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Properties__c.Marketing_Plan_Ready_for_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update Marketing Plan Approval Status to &quot;Submitted&quot; when the Marketing Plan Ready for Approval checkbox is checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3AMarketing Request MOHCD Follow-up Details - Addl</fullName>
        <actions>
            <name>LISTING_Marketing_Plan_MOHCD_Follow_up_Details</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Marketing Request MOHCD Follow-up details are emailed when status is updated to Additional Information Required.</description>
        <formula>ISPICKVAL( Pricing_Request_Approval_Status__c, &quot;Additional Information Required&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3AMarketing Request MOHCD Follow-up Details - Cxl</fullName>
        <actions>
            <name>LISTING_Marketing_Plan_MOHCD_Follow_up_Details</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Marketing Request MOHCD Follow-up details are emailed when status is updated to Cancelled.</description>
        <formula>ISPICKVAL( Pricing_Request_Approval_Status__c, &quot;Cancelled&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3AMarketing Request MOHCD Follow-up Details - Denied</fullName>
        <actions>
            <name>LISTING_Marketing_Plan_MOHCD_Follow_up_Details</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Marketing Request MOHCD Follow-up details are emailed when status is updated to Denied.</description>
        <formula>ISPICKVAL( Pricing_Request_Approval_Status__c, &quot;Denied&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3APricing Request Approved</fullName>
        <actions>
            <name>LISTING_Pricing_Request_Approved</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PROPERTY_Pricing_Request_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Properties__c.Pricing_Request_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Pricing Request is approved. Email is sent to the PA</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3APricing Request MOHCD Follow-up Details - Addl</fullName>
        <actions>
            <name>LISTING_Pricing_Request_MOHCD_Follow_up_Details</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Pricing Request MOHCD Follow-up details are emailed when status is updated to Additional Information Required.</description>
        <formula>ISPICKVAL( Pricing_Request_Approval_Status__c, &quot;Additional Information Required&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3APricing Request MOHCD Follow-up Details - Cxl</fullName>
        <actions>
            <name>LISTING_Pricing_Request_MOHCD_Follow_up_Details</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Pricing Request MOHCD Follow-up details are emailed when status is updated to Cancelled.</description>
        <formula>ISPICKVAL( Pricing_Request_Approval_Status__c, &quot;Cancelled&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3APricing Request MOHCD Follow-up Details - Denied</fullName>
        <actions>
            <name>LISTING_Pricing_Request_MOHCD_Follow_up_Details</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Pricing Request MOHCD Follow-up details are emailed when status is updated to Denied.</description>
        <formula>ISPICKVAL( Pricing_Request_Approval_Status__c, &quot;Denied&quot; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3APricing Request Status - Submitted</fullName>
        <actions>
            <name>LISTING_Pricing_Request_Submit_Reply</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Properties__c.Pricing_Request_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <description>PA submits Pricing Request and uploads supporting documents. Send email notification to PA and to MOHCD Team for review.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LISTING%3APricing Request Update Status - Submitted</fullName>
        <actions>
            <name>PROPERTY_Pricing_Request_Submit_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Pricing_Request_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Properties__c.Pricing_Request_Ready__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update Pricing_Request_Approval_Status__c to Submitted when the Pricing_Request_Ready_for_Approval checkbox is checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
