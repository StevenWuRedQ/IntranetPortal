<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="LeadSearchSummery.ascx.vb" Inherits="IntranetPortal.LeadSearchSummery" %>
<table class="table table-striped">
    <tr>
        <td>Property tax search - {{DocSearch.LeadResearch.propertyTaxes?'':'No'}} {{DocSearch.LeadResearch.propertyTaxes | currency}}
        </td>
    </tr>
    <tr>
        <td>Water charges - {{DocSearch.LeadResearch.waterCharges?'':'No'}} {{DocSearch.LeadResearch.waterCharges | currency}}
        </td>
    </tr>
    <tr>
        <td>ECB Violation - {{DocSearch.LeadResearch.ecbViolation?'':'No'}} {{DocSearch.LeadResearch.ecbViolation | currency}}
        </td>
    </tr>
    <tr>
        <td>DOB Violation - {{DocSearch.LeadResearch.dobWebsites?'':'No'}} {{DocSearch.LeadResearch.dobWebsites | currency}}
        </td>
    </tr>
    <tr>
        <td>Has Co - {{DocSearch.LeadResearch.hasCO?'Yes':'No'}}
        </td>
    </tr>
    <tr>
        <td>Has Judgment {{DocSearch.LeadResearch.judgments?'Yes':'No'}}</td>
    </tr>
    <tr>
        <td>Judgment Amount-  {{DocSearch.LeadResearch.judgments | currency}}
        </td>
    </tr>
    <tr>
        <td>ECB On JdmtSearch - {{DocSearch.LeadResearch.judgementSearch}}
        </td>
    </tr>
    <tr>
        <td>IRS Tax Liens - {{DocSearch.LeadResearch.irsTaxLien?'':'No'}} {{DocSearch.LeadResearch.irsTaxLien | currency}}
        </td>
    </tr>
    <tr>
        <td>NYS Tax Liens - {{DocSearch.LeadResearch.hasNysTaxLien?'Yes':'No'}} 
        </td>
    </tr>
    
    <tr>
        <td>Judgement Doc - <a ng-if="DocSearch.LeadResearch.judgementSearchDoc.path" src="{{DocSearch.LeadResearch.judgementSearchDoc.path}}">Judgement Search </a></td>
    </tr>
    <tr>
        <td>Court Date - {{DocSearch.LeadResearch.courtDate | date:'MM/dd/yyyy'}}
        </td>
    </tr>

    <tr>
        <td>Mortgage - {{DocSearch.LeadResearch.mortgageAmount?'':'No'}} {{DocSearch.LeadResearch.mortgageAmount | currency}}
        </td>
    </tr>
    <tr>
        <td>2nd Mortgage - {{DocSearch.LeadResearch.secondMortgageAmount?'':'No'}} {{DocSearch.LeadResearch.secondMortgageAmount | currency}}
        </td>
    </tr>
    <tr>
        <td>{{ DocSearch.LeadResearch.fannie?"Has FANNIE":'Not Fannie' }} {{ DocSearch.LeadResearch.fha?" Has FHA":' Not FHA' }} 
        </td>
    </tr>
    <tr>
        <td>Servicer - {{DocSearch.LeadResearch.servicer}}
        </td>
    </tr>
    <tr>
        <td>
          Servicer is Wells Fargo - {{ DocSearch.LeadResearch.wellsFargo?'Yes':'No'}}
        </td>
    </tr>
</table>
