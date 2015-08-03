<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="NGDocumentsUI.ascx.vb" Inherits="IntranetPortal.NGDocumentsUI" %>

<script src="/Scripts/stevenjs.js"></script>
<script type="text/javascript">

    var IsDocumentLoaded = false;
    var tmpFileId = null;

    function UploadFiles() {
        var url = "";
        if (typeof leadsInfoBBLE == undefined || leadsInfoBBLE == null)
            url = '/UploadFilePage.aspx?b=<%= LeadsBBLE%>';
        else
            url = '/UploadFilePage.aspx?b=' + leadsInfoBBLE;

        if (popupCtrUploadFiles) {
            popupCtrUploadFiles.SetContentUrl(url);
            popupCtrUploadFiles.Show();
            popupCtrUploadFiles.CloseUp.AddHandler(function (s, e) {
                if (typeof BindDocuments != "undefined")
                    BindDocuments(true);
            });
        }
        else
            window.open(url, 'Upload Files', popup_params(640, 400));
    }

    function BindDocuments(refreshDocuments) {
        
    }

    function OnFilePopUpClick(s, e) {
        if (tmpFileId == null)
            return;
        if (e.item.index == 0) {
            NavigateUrl("/DownloadFile.aspx?spFile=" + tmpFileId);
        } else if (e.item.index == 1) {
            NavigateUrl("/DownloadFile.aspx?spFile=" + tmpFileId + "&o=1");
        }
        else {

        }
    }

    function NavigateUrl(url) {
        window.open(url, '_blank');
    }

    function clickFileLink(s, docId) {
        tmpFileId = docId;
        AspFilePopupMenu.ShowAtElement(s.GetMainElement());
    }

    function GetSelectedAttachment() {
        var allFiles = [];
        $('input:checkbox.FileCheckbox').each(function () {
            if (this.checked) {
                var file = {
                    "Name": $(this).val(),
                    "UniqueId": $(this).attr("data-UniqueId")
                }
                allFiles.push(file);
            }
        });
        return allFiles;
    }

</script>

<dx:ASPxPopupMenu ID="ASPxPopupMenu11" runat="server" ClientInstanceName="AspFilePopupMenu"
    PopupElementID="numberLink" ShowPopOutImages="false" AutoPostBack="false"
    PopupHorizontalAlign="Center" PopupVerticalAlign="Below" PopupAction="LeftMouseClick"
    ForeColor="#3993c1" Font-Size="14px" CssClass="fix_pop_postion_s" Paddings-PaddingTop="15px" Paddings-PaddingBottom="18px">
    <ItemStyle Paddings-PaddingLeft="20px" />
    <Items>
        <dx:MenuItem Text="Preview" Name="Preview">
        </dx:MenuItem>
        <dx:MenuItem Text="Download" Name="Download">
        </dx:MenuItem>
    </Items>
    <ClientSideEvents ItemClick="function(s,e){OnFilePopUpClick(s,e);}" />
</dx:ASPxPopupMenu>

<style>
    #newDocumentUI {
        font-size: 14px;
    }

        #newDocumentUI row {
            margin-left: 0px;
            margin-right: 0px;
        }

        #newDocumentUI div {
            min-height: 45px;
            padding-top: 3px;
            padding-bottom: 3px;
        }

    .title {
    }
</style>


<div style='padding: 35px 20px 35px 20px' class="border_under_line">
    <div style="width: 100%">
        <div class="font_30">
            <i class="fa fa-file"></i>&nbsp;
                <span class="font_light">Documents</span>
            <span class="time_buttons" onclick="UploadFiles()" style='<%= if(viewMode, "display:none", "") %>'>Upload File</span>
        </div>
        <div style="padding-left: 39px;" class="clearfix">
            <span style="font-size: 14px;"><%= LeadsName %></span>
        </div>
    </div>
</div>

<div id="newDocumentUI" ng-controller="DocController" style="border: 1px solid red">
    <div class="content">
        <div class="row">
            <div>
                <div class="title row">
                    <div class="col-md-offset-1 col-md-7">Name</div>
                    <div class="col-md-3">Date modified</div>
                </div>
                <div class="folder-item" ng-repeat="folder in content.folders">
                    <div class="col-md-offset-1 col-md-7"><i class="fa fa-folder fa-2x" style="color: blue"></i><span ng-bind="folder.name"></span></div>
                    <div class="col-md-3">--</div>
                </div>
            </div>
        </div>
    </div>
</div>


<script type="text/javascript">
    var app = angular.module('PortalApp')
    app.controller('DocController', ['$scope', '$http', function ($scope, $http) {

        $scope.pathUrl = "";
        $scope.content = {};
        $scope.bble = 

        $scope.init = function (bble) {
            $http.post('Document.asmx/getFolderItems', { bble: $scope.bble, folderPath: $scope.pathUrl }).
                success(function (data, status, headers, config) {
                    $scope.content = JSON.parse(data.d);
                    console.log($scope.content);

                }).
                error(function () {
                    console.log("bble is blank");
                });
        }();
    }]);

</script>
