<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AssignApplicationSubmissionDateToToday</fullName>
        <description>Assign Application Submission Date to TODAY</description>
        <field>Application_Submitted_Date__c</field>
        <formula>TODAY()</formula>
        <name>AssignApplicationSubmissionDateToToday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AssignApplicationSubmissionDateToToday</fullName>
        <actions>
            <name>AssignApplicationSubmissionDateToToday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Application__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Application__c.Application_Submission_Type__c</field>
            <operation>equals</operation>
            <value>Electronic</value>
        </criteriaItems>
        <description>Assign Application Submission Date to TODAY upon Submitted.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
