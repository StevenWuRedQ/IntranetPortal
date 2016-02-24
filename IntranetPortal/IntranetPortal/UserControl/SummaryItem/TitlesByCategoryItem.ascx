<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="TitlesByCategoryItem.ascx.vb" Inherits="IntranetPortal.TitlesByCategoryItem" %>

<style type="text/css">
    a.dx-link-MyIdealProp:hover {
        font-weight: 500;
    }

    .myRow:hover {
        background-color: #efefef;
    }
</style>
<h4 id="title_<%= ClientID %>">
    <img src="../images/<%= If(Not IsTitleStatus, "grid_task_icon.png", "grid_upcoming_icon.png") %>" class="vertical-img" /><span class="heading_text"><%= Category %></span>
    <span class="heading_text employee_lest_head_number_label" style="margin-left:25px;"><a href="/BusinessForm/Default.aspx?c=<%= CategoryId %>" style="color:white;"></a></span>
</h4>
<div id="gridContainer" runat="server" style="margin: 10px; margin-top: 50px; height: 300px"></div>
<script>
    var CategoryItem_<%= Me.ClientID%> = {
        url: "/api/Title/TitleCases/<%=If(IsTitleStatus, "Status/", "") %><%= CategoryId%>",
        dxGridName: "#<%= gridContainer.ClientID%>",
        headName:"title_<%= ClientID%>",
        categoryId:<%= CategoryId%>,
        category:"<%= Category%>",
        IsTitleStatus: <%= IsTitleStatus.ToString.ToLower%>,
        loadData: function () {
            var tab = this;
            $.getJSON(tab.url).done(function (data) {
                
                var dataGrid = $(tab.dxGridName).dxDataGrid({
                    dataSource: data,                  
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
                        var spanTotal = $('#' + tab.headName).find('a')[0];
                        if (spanTotal) {
                            $(spanTotal).html(e.component.totalCount());
                            
                            if(tab.IsTitleStatus)
                            {
                                $(spanTotal).attr("href","#");
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
                                    var url = '/BusinessForm/Default.aspx?showList=true&c='+tab.categoryId +'&tag=' + options.data.BBLE;
                                    GoToCase(url);
                                })
                                .appendTo(container);
                        },
                    }],                       
                }).dxDataGrid('instance');              
            });
        }
    }
    
    CategoryItem_<%= Me.ClientID%>.loadData();    

    function GoToCase(url) {     
        window.location.href = url;
    }

    //var fileWindows = {};
    //function ShowCaseInfo(CaseId) {
    //    for (var win in fileWindows) {
    //        if (fileWindows.hasOwnProperty(win) && win == CaseId) {
    //            var caseWin = fileWindows[win];
    //            if (!caseWin.closed) {
    //                caseWin.focus();
    //                return;
    //            }
    //        }
    //    }

    //    var url = '/BusinessForm/Default.aspx?tag=' + CaseId;
    //    var left = (screen.width / 2) - (1350 / 2);
    //    var top = (screen.height / 2) - (930 / 2);
    //    debugger;
    //    var win = window.open(url, 'View Title Case - ' + CaseId, 'Width=1350px,Height=930px, top=' + top + ', left=' + left);
    //    fileWindows[CaseId] = win;
    //}



</script>
