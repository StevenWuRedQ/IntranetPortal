<%@ Control Language="vb" AutoEventWireup="false" CodeBehind="PublishProperty.ascx.vb" Inherits="IntranetPortal.PublishProperty" %>
<div style="width: 100%; align-content: center; height: 100%">
    <!-- Nav tabs -->
    <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 16px; color: white">
        <li class="active short_sale_head_tab">
            <a href="#generalInfo" role="tab" data-toggle="tab" class="tab_button_a">
                <i class="fa fa-info-circle head_tab_icon_padding"></i>
                <div class="font_size_bold" style="font-weight: 900;">General Info</div>
            </a>
        </li>
        <li class="short_sale_head_tab">
            <a href="#keyDetails" role="tab" data-toggle="tab" class="tab_button_a">
                <i class="fa fa-home head_tab_icon_padding"></i>
                <div class="font_size_bold" style="font-weight: 900;">Details</div>
            </a>
        </li>
        <li class="short_sale_head_tab">
            <a href="#PropertyImages" role="tab" data-toggle="tab" class="tab_button_a">
                <i class="fa fa-file head_tab_icon_padding"></i>
                <div class="font_size_bold" style="font-weight: 900;">Images</div>
            </a>
        </li>
        <%--<li><a role="tab" data-toggle="tab">Settings</a></li>--%>
        <li style="margin-right: 30px; color: #ffa484; float: right">
            <i class="fa fa-save sale_head_button sale_head_button_left tooltip-examples" title="Save Draft" onclick="cpProperty.PerformCallback('Save')"></i>
            <i class="fa fa-paper-plane sale_head_button sale_head_button_left tooltip-examples" title="Publish" onclick=""></i>
            <i class="fa fa-print sale_head_button sale_head_button_left tooltip-examples" title="Print" onclick=""></i>
            <i class="fa fa-eye sale_head_button sale_head_button_left tooltip-examples" title="Preview" onclick=""></i>
        </li>
    </ul>

    <dx:ASPxCallbackPanel runat="server" ID="cpPropertyContent" ClientInstanceName="cpProperty" OnCallback="cpPropertyContent_Callback">
        <PanelCollection>
            <dx:PanelContent>
                <asp:HiddenField ID="hfBBLE" runat="server" />
                <div class="tab-content">
                    <div class="tab-pane active" id="generalInfo">
                        <div style="margin: 20px">
                            <h4 class="ss_form_title">Basic Data</h4>
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">BBLE</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.BBLE %>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Block/Lot</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.Block & "/" & ListPropertyData.Lot %>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Property Class</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.PropertyClass%>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">AptNo.</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.AptNo %>">
                                </li>
                                <li class="ss_form_item">
                                    <span class="ss_form_input_title">Number</span>
                                    <input class="ss_form_input" value="<%= ListPropertyData.Number%>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Street Name</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.StreetName%>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">NeighName</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.NeighName%>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">State</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.State%>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">ZipCode</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.Zipcode%>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Latitude</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.Latitude%>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Longitude</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.Longitude%>">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Agent</label>
                                    <input class="ss_form_input" value="<%= ListPropertyData.Agent%>">
                                </li>
                            </ul>
                            <h4 class="ss_form_title">Sales Data</h4>
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Num of BedRooms</label>
                                    <dx:ASPxComboBox runat="server" ID="cbNumOfBed" Native="true" CssClass="ss_form_input" Height="40px">
                                        <Items>
                                            <dx:ListEditItem Text="" Value="" />
                                            <dx:ListEditItem Text="1" Value="1" />
                                            <dx:ListEditItem Text="2" Value="2" />
                                            <dx:ListEditItem Text="3" Value="3" />
                                            <dx:ListEditItem Text="4" Value="4" />
                                            <dx:ListEditItem Text="5" Value="5" />
                                            <dx:ListEditItem Text="6" Value="6" />
                                            <dx:ListEditItem Text="7" Value="7" />
                                            <dx:ListEditItem Text="8" Value="8" />
                                        </Items>
                                    </dx:ASPxComboBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Num of BathRooms</label>
                                    <dx:ASPxComboBox runat="server" ID="cbNumOfBath" Native="true" CssClass="ss_form_input" Height="40px">
                                        <Items>
                                            <dx:ListEditItem Text="" Value="" />
                                            <dx:ListEditItem Text="1" Value="1" />
                                            <dx:ListEditItem Text="2" Value="2" />
                                            <dx:ListEditItem Text="3" Value="3" />
                                            <dx:ListEditItem Text="4" Value="4" />
                                            <dx:ListEditItem Text="5" Value="5" />
                                            <dx:ListEditItem Text="6" Value="6" />
                                            <dx:ListEditItem Text="7" Value="7" />
                                            <dx:ListEditItem Text="8" Value="8" />
                                        </Items>
                                    </dx:ASPxComboBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Sale Price</label>
                                    <dx:ASPxTextBox runat="server" ID="txtSalePrice" DisplayFormatString="C" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Annual Tax</label>
                                    <dx:ASPxTextBox runat="server" ID="txtAnnualTax" DisplayFormatString="C" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Avaiable Date</label>
                                    <input class="ss_form_input ss_date color_blue_edit" runat="server" id="txtAvaiableDate">
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">TransitLines</label>
                                    <dx:ASPxTextBox runat="server" ID="txtTransitLines" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                    <dx:ASPxTokenBox ID="tokenBoxTransitLines" runat="server" Width="100%" CssClass="ss_form_input" Visible="false">
                                        <Items>
                                            <dx:ListEditItem Text="1" />
                                            <dx:ListEditItem Text="2" />
                                            <dx:ListEditItem Text="3" />
                                            <dx:ListEditItem Text="4" />
                                            <dx:ListEditItem Text="5" />
                                            <dx:ListEditItem Text="6" />
                                            <dx:ListEditItem Text="7" />
                                            <dx:ListEditItem Text="A" />
                                            <dx:ListEditItem Text="B" />
                                            <dx:ListEditItem Text="C" />
                                            <dx:ListEditItem Text="D" />
                                            <dx:ListEditItem Text="E" />
                                            <dx:ListEditItem Text="F" />
                                            <dx:ListEditItem Text="G" />
                                            <dx:ListEditItem Text="H" />
                                            <dx:ListEditItem Text="R" />
                                            <dx:ListEditItem Text="N" />
                                            <dx:ListEditItem Text="Q" />
                                            <dx:ListEditItem Text="J" />
                                            <dx:ListEditItem Text="Z" />
                                            <dx:ListEditItem Text="LIRR" />
                                        </Items>
                                    </dx:ASPxTokenBox>
                                </li>
                                <li class="ss_form_item" style="width: 100%; height: 190px">
                                    <label class="ss_form_input_title">Description</label>
                                    <textarea class="ss_form_input" runat="server" id="txtDescription" style="width: 90%; height: 150px; border-top: 1px solid #dde0e7; border-left: 1px solid #dde0e7; border-right: 1px solid #dde0e7"></textarea>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="tab-pane" id="keyDetails">
                        <div style="margin: 20px">
                            <h4 class="ss_form_title">Features</h4>
                            <dx:ASPxCheckBoxList ID="cblFeatures" runat="server" RepeatColumns="5" RepeatLayout="Table" TextField="Name" ValueField="FeatureId" Height="100px">
                            </dx:ASPxCheckBoxList>
                            <h4 class="ss_form_title">Key Details</h4>
                            <ul class="ss_form_box clearfix">
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Common Charges</label>
                                    <dx:ASPxTextBox runat="server" ID="txtCommonCharges" DisplayFormatString="C" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Taxes</label>
                                    <dx:ASPxTextBox runat="server" ID="txtTaxes" DisplayFormatString="C" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Price per Sqft</label>
                                    <dx:ASPxTextBox runat="server" ID="txtPriceSqft" DisplayFormatString="C" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Min.Down Payment</label>
                                    <dx:ASPxTextBox runat="server" ID="txtDownPayment" DisplayFormatString="C" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Dog</label>
                                    <dx:ASPxRadioButtonList runat="server" ID="rblDog" RepeatDirection="Horizontal" Border-BorderStyle="None">
                                        <Items>
                                            <dx:ListEditItem Text="Yes" Value="Yes" />
                                            <dx:ListEditItem Text="No" Value="No" />
                                        </Items>
                                    </dx:ASPxRadioButtonList>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Cat</label>
                                    <dx:ASPxRadioButtonList runat="server" ID="rblCat" RepeatDirection="Horizontal" Border-BorderStyle="None">
                                        <Items>
                                            <dx:ListEditItem Text="Yes" Value="Yes" />
                                            <dx:ListEditItem Text="No" Value="No" />
                                        </Items>
                                    </dx:ASPxRadioButtonList>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Square Feet</label>
                                    <dx:ASPxTextBox runat="server" ID="txtSqft" DisplayFormatString="C" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Units in Building</label>
                                    <dx:ASPxTextBox runat="server" ID="txtNumOfUnit" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">Building Floors</label>
                                    <dx:ASPxTextBox runat="server" ID="txtNumOfFloor" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                                <li class="ss_form_item">
                                    <label class="ss_form_input_title">School District</label>
                                    <dx:ASPxTextBox runat="server" ID="txtSchoolDistrict" Native="true" CssClass="ss_form_input"></dx:ASPxTextBox>
                                </li>
                            </ul>

                            <%--  <ul class="ss_form_box clearfix">
                                <li class="ss_form_item" style="width: 20%; height: 35px">
                                    <input type="checkbox" checked="checked" id="test" /><label for="test">Northern Exposure</label>
                                </li>
                                <li class="ss_form_item" style="width: 20%; height: 35px">
                                    <input type="checkbox" checked="checked" id="test1" /><label for="test1">Estern Exposure</label>
                                </li>
                                <li class="ss_form_item" style="width: 20%; height: 35px">
                                    <input type="checkbox" checked="checked" id="test2" /><label for="test2">Southern Exposure</label>
                                </li>
                                <li class="ss_form_item" style="width: 20%; height: 35px">
                                    <input type="checkbox" checked="checked" id="test3" /><label for="test3">Total Renovation</label>
                                </li>
                                <li class="ss_form_item" style="width: 20%; height: 35px">
                                    <input type="checkbox" checked="checked" id="test4" /><label for="test4">Open Views</label>
                                </li>
                                <li class="ss_form_item" style="width: 20%; height: 35px">
                                    <input type="checkbox" checked="checked" id="test5" /><label for="test5">Bay Windows</label>
                                </li>
                            </ul>--%>
                        </div>
                    </div>
                    <div class="tab-pane" id="PropertyImages">
                        <script type="text/javascript">
                            function onFileUploadComplete(s, e) {
                                if (e.callbackData) {
                                    gridImages.PerformCallback("Upload|" + e.callbackData);
                                }
                            }
                        </script>
                        <div style="margin: 20px">
                            <dx:ASPxImageSlider ID="imageSlider" runat="server" ClientInstanceName="ImageSlider" EnableViewState="False" EnableTheming="False" ImageContentBytesField="ImageData" Visible="false"
                                TextField="FileName" BinaryImageCacheFolder="~\TempDataFile\">
                                <SettingsNavigationBar ThumbnailsModeNavigationButtonVisibility="None" />
                                <SettingsAutoGeneratedImages ImageCacheFolder="~\TempDataFile\" />
                                <Styles>
                                    <ImageArea Width="600px" Height="400px" />
                                </Styles>                                 
                            </dx:ASPxImageSlider>                         
                            <h4 class="ss_form_title">Image List</h4>
                            <dx:ASPxGridView runat="server" ID="gridImages" ClientInstanceName="gridImages" OnCustomCallback="gridImages_CustomCallback" KeyFieldName="ImageId" OnRowDeleting="gridImages_RowDeleting">
                                <Columns>
                                    <dx:GridViewDataTextColumn FieldName="OrderId"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="FileName"></dx:GridViewDataTextColumn>
                                    <dx:GridViewDataTextColumn FieldName="Description"></dx:GridViewDataTextColumn>
                                    <dx:GridViewCommandColumn ShowDeleteButton="true" ShowEditButton="true"></dx:GridViewCommandColumn>                                    
                                </Columns>
                            </dx:ASPxGridView>
                            <br />
                            <h4 class="ss_form_title">Upload Files</h4>                       
                            <dx:ASPxUploadControl ID="UploadControl" runat="server" ClientInstanceName="UploadControl" Width="320"
                                NullText="Select multiple files..." UploadMode="Advanced" ShowUploadButton="True" ShowProgressPanel="True"
                                OnFileUploadComplete="UploadControl_FileUploadComplete">
                                <AdvancedModeSettings EnableMultiSelect="True" />
                                <ValidationSettings MaxFileSize="4194304" AllowedFileExtensions=".jpg,.jpeg,.gif,.png">
                                </ValidationSettings>
                                <ClientSideEvents FileUploadComplete="onFileUploadComplete" />
                            </dx:ASPxUploadControl>
                        </div>
                    </div>
                </div>

            </dx:PanelContent>
        </PanelCollection>
        <ClientSideEvents EndCallback="function(s,e){alert('Success.');}" />
    </dx:ASPxCallbackPanel>


</div>
