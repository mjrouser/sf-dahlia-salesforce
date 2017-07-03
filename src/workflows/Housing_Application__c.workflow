<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>HA_Denied_Incomplete</fullName>
        <description>HA:Denied Incomplete</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/HA_Denied_Incomplete</template>
    </alerts>
    <alerts>
        <fullName>HA_Denied_Under_Appeal</fullName>
        <description>HA:Denied Under Appeal</description>
        <protected>false</protected>
        <recipients>
            <recipient>michael.solomon@sfgov.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/HA_Denied_Under_Appeal</template>
    </alerts>
    <alerts>
        <fullName>HA_Loan_Officer_Submits</fullName>
        <description>HA:Loan Officer Submits</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/HA_Loan_Officer_Submits</template>
    </alerts>
    <fieldUpdates>
        <fullName>HA_Application_Status_Prior_Value</fullName>
        <field>Application_Status_Prior_Value__c</field>
        <formula>TEXT( Application_Status__c )</formula>
        <name>HA:Application Status Prior Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>HA%3A Set E-Sig Timestamp</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Housing_Application__c.Housing_Application_E_Signed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Housing_Application__c.Application_Status__c</field>
            <operation>notEqual</operation>
            <value>Not Yet Submitted</value>
        </criteriaItems>
        <description>Sets Housing Application E-Signature timestamp upon submittal of application</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HA%3ADenied Incomplete</fullName>
        <actions>
            <name>HA_Denied_Incomplete</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Housing_Application__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Denied</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>MOHCD - Property Agent</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>HA%3ADenied Under Appeal</fullName>
        <actions>
            <name>HA_Denied_Under_Appeal</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL( Application_Status__c ,&quot;Denied&quot;),  ISPICKVAL(PRIORVALUE(Application_Status__c), &quot;Under Appeal&quot;)    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>HA%3ALoan Officer Submits</fullName>
        <actions>
            <name>HA_Loan_Officer_Submits</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Housing_Application__c.Application_Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>MOHCD - Lender</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
