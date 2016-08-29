<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="FollowUpItem2.ascx.vb" Inherits="IntranetPortal.FollowUpItem2" %>

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

    .round-button {
	    width:25%;
    }
    .round-button-circle {
	    width: 100%;
	    height:0;
	    padding-bottom: 100%;
        border-radius: 50%;	
        overflow:hidden;    
        background: #4679BD; 
        text-align:center;
        vertical-align:baseline;
        color:white
    }
    .round-button-circle:hover {
	    background:#30588e;
    }

</style>
<h4 id="FollowUp_<%= ClientID %>" style="padding-top: 5px">
    <%--<img src="../images/<%= If(Not IsTitleStatus, "grid_task_icon.png", "grid_upcoming_icon.png") %>" class="vertical-img" />--%>
    <label class='grid-title-icon '>TF</label>
    <a href="/TitleUI/TitleSummaryPage.aspx?f=title">
        <label class="xlink">&nbsp;Today's FollowUp</label>
        <label class="employee_lest_head_number_label" style="margin-left: 5px; color: white;"></label>
    </a>
</h4>
<div id="gridContainer" runat="server" style="margin: 3px; height: 330px"></div>
<script>
    var FollowUp_<%= Me.ClientID%> = {
        url: "/api/Followup",
        dxGridName: "#<%= gridContainer.ClientID%>",
        headName: "FollowUp_<%= ClientID%>",
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
                        rowInfo.rowElement.on('mouseenter', function () {
                            var btn = $(this).find('.round-button-circle')[0];                            
                            $(btn).css('display', 'none');
                        }).on('mouseleave', function () {
                            var btn = $(this).find('.round-button-circle')[0];
                            $(btn).css('display', 'none');
                        });
                    },
                    onContentReady: function (e) {
                        var spanTotal = $('#' + tab.headName).find('.employee_lest_head_number_label')[0];
                        if (spanTotal) {
                            $(spanTotal).html(data.count);                           
                        } 
                    },
                    showColumnHeaders: false,
                    showColumnLines: false,
                    columns: [{
                        dataField: "CaseName",                        
                        caption: "Case Name",
                        cellTemplate: function (container, options) {
                            $('<a/>').addClass('dx-link-MyIdealProp')
                                .text(options.value)
                                .on('dxclick', function () {                                    
                                    var url = options.data.URL;
                                    PortalUtility.ShowPopWindow("View FollowUp Case - "+ options.data.BBLE, url);
                                })
                                .appendTo(container);
                        },
                    }, {
                        caption: 'Clear',
                        width:35,
                        cellTemplate: function (container, options) {
                            var div = $('<div />').addClass('round-button-circle')
                                        .css('display', 'none').appendTo(container);
                            $('<i/>').addClass('fa fa-check ')
                               .css('cursor', 'pointer')                               
                               .attr('title', 'Clear')
                               .on('dxclick', function () {                                 
                                   tab.clearFollowUp(options.data.FollowUpId);
                               })
                               .appendTo(div);
                        }
                    }],
                }).dxDataGrid('instance');              
            });
        },
        clearFollowUp: function (followUpId) {
            var tab = this;
            AngularRoot.confirm("Are you sure to clear?").then(function (r) {
                if (r) {
                     $.ajax({
                                url: '/api/Followup/',
                                type: 'DELETE',
                                data: JSON.stringify(followUpId),
                                cache: false,
                                contentType:'application/json',
                                success: function (data) {                                          
                                    AngularRoot.alert('Successful.');
                                    tab.loadData();
                                },
                                error: function (data) {

                                    AngularRoot.alert('Some error Occurred!');
                                }
                          });
                }
            });
        }
    }
    
    $(function(){
        FollowUp_<%= Me.ClientID%>.loadData();    
    });    

</script>
