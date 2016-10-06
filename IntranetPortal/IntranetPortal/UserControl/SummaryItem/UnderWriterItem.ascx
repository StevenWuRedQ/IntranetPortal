<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="UnderWriterItem.ascx.vb" Inherits="IntranetPortal.UnderWriterItem" %>

<style type="text/css">
    a.dx-link-MyIdealProp:hover {
        font-weight: 500;
        cursor: pointer;
    }

    .myRow:hover {
        background-color: #efefef;
    }

    label.xlink {
        color: black;
    }

    label.xlink:hover {
        color: blue;
    }
</style>
<h4 id="NewOffer_<%= ClientID %>" style="padding-top: 5px">
    <%--<img src="../images/<%= If(Not IsTitleStatus, "grid_task_icon.png", "grid_upcoming_icon.png") %>" class="vertical-img" />--%>
    <% If CaseStatus = IntranetPortal.Data.LeadInfoDocumentSearch.UnderWriterStatus.PendingSearch Then %>
     <label class='grid-title-icon'>NS</label>
    <% ElseIf CaseStatus = IntranetPortal.Data.LeadInfoDocumentSearch.UnderWriterStatus.CompletedSearch %>
     <label class='grid-title-icon'>CS</label>
    <% ElseIf CaseStatus = IntranetPortal.Data.LeadInfoDocumentSearch.UnderWriterStatus.PendingUnderwriting %>
     <label class='grid-title-icon'>PU</label>
    <% ElseIf CaseStatus = IntranetPortal.Data.LeadInfoDocumentSearch.UnderWriterStatus.CompletedUnderwriting %>
     <label class='grid-title-icon'>CU</label>
     <% ElseIf CaseStatus = IntranetPortal.Data.LeadInfoDocumentSearch.UnderWriterStatus.RejectUnderwriting %>
     <label class='grid-title-icon'>RU</label>
    <% End if %>
   
    <%-- do not use link to jump now --%>
    <%--href="/NewOffer/NewOfferList.aspx?view=<%=CInt(CaseStatus)%>"--%>
    <a href="/UnderWriter/DocSearchList.aspx#/<%=CInt(CaseStatus) + 1 %>">
        <label class="xlink">&nbsp;<%= HumanizeEnum(CaseStatus)  %></label>
        <label class="employee_lest_head_number_label" style="margin-left: 5px; color: white;"></label>
    </a>
</h4>
<div id="gridContainer" runat="server" style="margin: 3px; height: 330px"></div>
<script>
    var CategoryItem_<%= Me.ClientID%> = {
        url: "/api/LeadInfoDocumentSearches/UnderWritingStatus/<%=CInt(CaseStatus)%>",
        dxGridName: "#<%= gridContainer.ClientID%>",
        headName: "NewOffer_<%= ClientID%>",
        loadData: function () {
            var tab = this;
            $.getJSON(tab.url).done(function (data) {                
                var dataGrid = $(tab.dxGridName).dxDataGrid({
                    dataSource: data.data,
                    rowAlternationEnabled: true,
                    pager: {
                        showInfo: true
                    },
                    paging: {
                        enabled: true,
                    },
                    onRowPrepared: function (rowInfo) {
                        if (rowInfo.rowType != 'data')
                            return;
                        rowInfo.rowElement
                        .addClass('myRow');
                    },
                    onContentReady: function (e) {
                        var spanTotal = $('#' + tab.headName).find('.employee_lest_head_number_label')[0];
                        if (spanTotal) {
                            $(spanTotal).html(data.count);
                        }
                    },
                    showColumnHeaders:false,
                    columns: [{
                        dataField: "CaseName",
                        caption: "Name",
                        cellTemplate: function (container, options) {
                            $('<a/>').addClass('dx-link-MyIdealProp')
                                .text(options.value)
                                .attr("href", "/UnderWriter/DocSearchList.aspx#/<%=CInt(CaseStatus) + 1 %>/" + options.data.BBLE)
                                //.on('dxclick', function(){
                                //    //Do something with options.data;
                                //    var url = '/PopupControl/LeadTaxSearchRequest.aspx?si=1&BBLE=' + options.data.BBLE;
                                    
                                //    PortalUtility.ShowPopWindow("View Case - " + options.data.BBLE, url);                                                                       
                                //})
                                .appendTo(container);
                        },
                    }],
                }).dxDataGrid('instance');              
            });
        }
    }
    
    $(function(){
        CategoryItem_<%= Me.ClientID%>.loadData();    
    });    

</script>
