<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="ActivityLog.aspx.vb" Inherits="IntranetPortal.ActivityLog" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="../styles/stevencss.css" rel='stylesheet' type='text/css' />
    <link href="../css/font-awesome.css" type="text/css" rel="stylesheet" />

    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/jquery-ui.min.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

</head>
<body>
    <form id="form1" runat="server">
    <div style="font-size:14px;color:#9fa1a8;font-family:'Source Sans Pro'">
       <table>
           <tr style="height:40px;">
               <td>
                   <div class="activity_log_item_icon activity_green_bg">
                       <i class="fa fa-check"></i>
                   </div>
               </td>
               <td>
                    <div style="width:330px">
                       Deal closed
                   </div>
               </td>
               <td>
                    <div style="width:120px">
                       Andrea Taylor
                   </div>
               </td>
               <td>
                    <div style="width:130px">
                      Jun 4, 2014 5:03 pm
                   </div>
               </td>
           </tr>
           <tr style="height:40px; background:#f5f5f5">
               <td>
                   <div class="activity_log_item_icon activity_red_bg">
                       <i class="fa fa-info"></i>
                   </div>
               </td>
               <td>
                    <div style="width:330px">
                       Priority
                   </div>
               </td>
               <td>
                    <div style="width:120px">
                       Andrea Taylor
                   </div>
               </td>
               <td>
                    <div style="width:130px">
                      Jun 12, 2014 5:08 pm
                   </div>
               </td>
           </tr>
       </table>
    </div>
    </form>
</body>
</html>
