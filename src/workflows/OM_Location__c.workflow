<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>OM_Update_Facility_Address</fullName>
        <description>Updates the field OM_Facility_Street_Address_Search on the location object to allow searching locations by address</description>
        <field>OM_Facility_Street_Address_Search__c</field>
        <formula>OM_Facility__r.ShippingStreet</formula>
        <name>Update Facility Address</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Location Facility Address Update</fullName>
        <actions>
            <name>OM_Update_Facility_Address</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates OM_Facility_Street_Address_Search on location object to allow searching on address</description>
        <formula>NOT( ISNULL( OM_Facility__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
