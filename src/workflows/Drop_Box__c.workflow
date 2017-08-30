<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Upload_Reject_Reason</fullName>
        <description>Upload Reject Reason</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Upload_Reject_Reason</template>
    </alerts>
    <rules>
        <fullName>UPLOADS%3A Send Reject Reason</fullName>
        <actions>
            <name>Upload_Reject_Reason</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Drop_Box__c.Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Email reason for rejection of upload to user uploading</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
