<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitlesByCategoryItem.ascx.vb" Inherits="IntranetPortal.TitlesByCategoryItem" %>

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
<h4 id="title_<%= ClientID %>" style="padding-top: 5px">
    <%--<img src="../images/<%= If(Not IsTitleStatus, "grid_task_icon.png", "grid_upcoming_icon.png") %>" class="vertical-img" />--%>
    <label class='grid-title-icon <%= If(Not IsTitleStatus, "", "grid-title-title") %>'><%= If(Not IsTitleStatus, "SS", "TI") %></label>
    <a href="/TitleUI/TitleSummaryPage.aspx?c=<%= CategoryId %>">
        <label class="xlink">&nbsp;<%= Category %></label>
        <label class="employee_lest_head_number_label" style="margin-left: 5px; color: white;"></label>
    </a>
</h4>
<div id="gridContainer" runat="server" style="margin: 3px; height: 330px"></div>
<script>
    var CategoryItem_<%= Me.ClientID%> = {
        url: "/api/Title/TitleCasesSummary/<%=If(IsTitleStatus, "Status/", "") %><%= CategoryId%>",
        dxGridName: "#<%= gridContainer.ClientID%>",
        headName:"title_<%= ClientID%>",
        categoryId:<%= CategoryId%>,
        category:"<%= Category%>",
        IsTitleStatus: <%= IsTitleStatus.ToString.ToLower%>,
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
                            
                            if(tab.IsTitleStatus)
                            {
                                var link = $('#' + tab.headName).find('a')[0];
                                if(link)
                                    $(link).attr("href","/TitleUI/TitleSummaryPage.aspx?c=-1");
                            }
                        } 
                    },
                    showColumnHeaders:false,
                    columns: [{
                        dataField: "CaseName",                        
                        caption: "Case Name",
                        cellTemplate: function (container, options) {
                            $('<a/>').addClass('dx-link-MyIdealProp')
                                .text(options.value)
                                .on('dxclick', function () {
                                    //
                                    //Do something with options.data;
                                    var url = '/BusinessForm/Default.aspx?tag=' + options.data.BBLE;
                                    PortalUtility.ShowPopWindow("View Title Case - "+ options.data.BBLE, url);
                                })
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
