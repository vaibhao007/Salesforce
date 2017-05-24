<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CaseOwner_Purchasing_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>OM_Purchasing_Cases</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>CaseOwner Purchasing Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>EmailMessage Assignment-Purchasing</fullName>
        <actions>
            <name>CaseOwner_Purchasing_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Description</field>
            <operation>contains</operation>
            <value>Purchasing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>contains</operation>
            <value>Email</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
