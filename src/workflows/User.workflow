<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Confirmation_of_Contact_Account_Registration</fullName>
        <description>Confirmation of Contact Account Registration</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Confirmation_of_Contact_Account_Registration</template>
    </alerts>
    <rules>
        <fullName>USER%3A Portal Enabled Alert</fullName>
        <actions>
            <name>Confirmation_of_Contact_Account_Registration</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.IsPortalEnabled</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Email alert to notify User (Real Estate Agent primarily) that their login is now active for use.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
