<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DP_DALP_Request_Submitted_to_Lender</fullName>
        <description>DP: DALP Request Submitted to Lender</description>
        <protected>false</protected>
        <recipients>
            <field>Lender__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DALP_REQUEST_Lender_Request</template>
    </alerts>
    <rules>
        <fullName>DP%3A Alert Selected Lender when DALP Request Submitted</fullName>
        <actions>
            <name>DP_DALP_Request_Submitted_to_Lender</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>DALP_Request__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
