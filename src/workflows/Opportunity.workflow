<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>OM_Large_Deal_Alert</fullName>
        <description>Opportunity Large Deal Alert</description>
        <protected>false</protected>
        <recipients>
            <field>OM_Managers_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>O_M_Sales_Templates/OM_Opportunity_large_Deal_Alert</template>
    </alerts>
    <alerts>
        <fullName>OM_Margin_threshold_email_alert</fullName>
        <description>Opportunity Margin threshold email alert</description>
        <protected>false</protected>
        <recipients>
            <field>OM_Managers_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>O_M_Sales_Templates/OM_Opportunity_Margin_Percentage_Threshold</template>
    </alerts>
    <alerts>
        <fullName>OM_Opportunity_Close_Alert</fullName>
        <description>Opportunity Close Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>O_M_Sales_Templates/OM_Opportunity_Close_Date</template>
    </alerts>
    <fieldUpdates>
        <fullName>OM_Update_Manager_Email</fullName>
        <field>OM_Managers_Email__c</field>
        <formula>Owner.Manager.Email</formula>
        <name>Opportunity Update Manager Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Product_Margin</fullName>
        <description>Update the Margin % field with the calculated value based on individual product margins</description>
        <field>OM_Margin_Percentage__c</field>
        <formula>OM_Product_Margin_Revenue__c / Amount</formula>
        <name>Update Product Margin %</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity Close Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>OM_Opportunity_Close_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.CloseDate</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity Large Deal Alert</fullName>
        <actions>
            <name>OM_Large_Deal_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>If the opportunity amount &gt; manager&apos;s threshold value, send them an email</description>
        <formula>Amount &gt;  Owner.Manager.OM_Deal_Alert_Threshold__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Margin Percentage Threshold Alert</fullName>
        <actions>
            <name>OM_Margin_threshold_email_alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OM_Margin_Percentage__c &lt; $User.OM_Margin_Percentage_Threshold__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Update Manager Email</fullName>
        <actions>
            <name>OM_Update_Manager_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.OM_Managers_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Product Margin %25</fullName>
        <actions>
            <name>Update_Product_Margin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Count__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>If an opportunity has products, override the Margin % field with the calculated value based on Product Margin</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
