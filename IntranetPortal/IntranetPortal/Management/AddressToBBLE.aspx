<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="AddressToBBLE.aspx.vb" Inherits="IntranetPortal.AddressToBBLE" MasterPageFile="~/Content.Master"%>
<asp:Content runat="server" ContentPlaceHolderID="head">

  

</asp:Content>

<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">
    
     <div>
       
         <asp:TextBox ID="JasonImportText" runat="server"></asp:TextBox>
         
         <asp:Button ID="Button1" runat="server" Text="GetBBLEs" OnClick="Button1_OnClick"/>
         <dx:ASPxCheckBox ID="aspShowError" runat="server" Text="Allow Show Error"></dx:ASPxCheckBox>
         <div>
              <p> <%= reslut%> </p> 
         </div>
         
    </div>
       
   
      
</asp:Content>