<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="DoorknockChart.aspx.vb" Inherits="IntranetPortal.DoorknockChart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900' rel='stylesheet' type='text/css' />

    <link href="/css/font-awesome.min.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap-theme.min.css" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
    <link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/jqueryui/1.11.0/themes/smoothness/jquery-ui.css" />
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="/scrollbar/jquery.mCustomScrollbar.css" />
    <script src="/scrollbar/jquery.mCustomScrollbar.js"></script>
    <link href="/styles/stevencss.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">

        <div style="color: #231f20">
            <div class="bs-docs-grid">
                <div class="row" >
                    <div class="col-md-1">
                        <div style="background: #158ccd; height: 60px; width: 40px;">
                            &nbsp;
                        </div>
                    </div>
                    <div class="col-md-11">
                        <div style="font-size: 48px; font-weight: 200">
                            <span class="upcase_text">Door Knock chart</span>
                        </div>
                        <div style="font-size: 14px;">
                            <i class="fa fa-map-marker" style="border: 2px solid; padding: 4px 6px; border-radius: 14px;"></i>&nbsp;&nbsp; Homes to visit: <span style="font-weight: 900">5</span>
                        </div>
                        <table class="table table-striped" style="font-size: 10px; margin-top: 25px;">
                            <thead class="upcase_text">
                                <tr>
                                    <th><i class="fa fa-check" /></th>
                                    <th>Address</th>
                                    <th>Home owner (age)</th>
                                    <th>Best Phone #</th>
                                    <th>Other Addresses</th>
                                    <th>Mortgage(s)</th>
                                    <th>ECB/DOB</th>
                                    <th>Taxes</th>
                                    <th>Commets</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td></td>
                                    <td>
                                        <span class="font_black">123 Main St,
                                        </span>
                                        <br />
                                        Bellerose, NY 12345
                                    </td>
                                    <td>Matha Cantey (43)</td>
                                    <td><span class="font_black">(718) 123-1234</span><br />
                                        (ET) Land line (28%)                                </td>
                                    <td>&nbsp;</td>
                                    <td>$593,012.12</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <span class="font_black">22-06 101 Avenue
                                        </span>
                                        <br />
                                        Flushing, NY 11353
                                    </td>
                                    <td>Slyburn Sowell (45)<br />
                                        Ruth Sowell (51)<br />
                                        Anne Sowell (34)<br />
                                    </td>
                                    <td>
                                        <span class="font_black">(718) 123-1234</span><br />
                                        (ET) Land line (28%)
                                    </td>
                                    <td>929 Saint Johns Pl,<br />
                                        Brooklyn, NY 11213</td>
                                    <td>$593,012.12</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                    <td>&nbsp;</td>
                                </tr>

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>


        </div>
    </form>
</body>
</html>
