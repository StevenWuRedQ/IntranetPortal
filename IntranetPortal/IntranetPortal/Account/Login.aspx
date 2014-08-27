<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Login.aspx.vb" Inherits="IntranetPortal.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title>My Ideal Property Portal</title>
    <meta name="description" content="" />

    <link rel="stylesheet" href="/css/normalize.min.css" />
    <link href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900,200italic,300italic,400italic,600italic,700italic,900italic' rel='stylesheet' type='text/css' />
    <link href="/css/font-awesome.css" type="text/css" rel="stylesheet" />
    <link rel="stylesheet" href="/scrollbar/jquery.mCustomScrollbar.css" />
    <link rel="stylesheet" href="/css/main.css" />

    <script src="/scripts/js/vendor/modernizr-2.6.2-respond-1.1.0.min.js"></script>
    <script>
        function onLogIn()
        {
            alert("run on log in -> " + $('#username').val() + '|' + $('#password').val());
            LogInCallBackClinet.PerformCallback($('#username').val() + '|' + $('#password').val())
        }

        function LogInComplete(result)
        {          
            if(result)
            {
                window.location.replace("/default.aspx");
            }
            else
            {
                alert("log in failed!");
            }
        }
    </script>
</head>
<body style="min-height: 100%;">
    <form id="form1" runat="server" >

        <div style="height: 100%; left: 0; position: fixed; top: 0; width: 100%;background-color:#f9f9f9; display:none ">
            <div style="top: 22%; left: 40%; position: absolute; z-index: 10; background-color:#efefef;">
                <dx:ASPxRoundPanel runat="server" HeaderText="Log In" HorizontalAlign="Center">
                    <PanelCollection>
                        <dx:PanelContent>
                            <div class="accountHeader">
                                <img src="/images/MyIdealProptery.png" style="height: 152px; width: 137px" />
                                <p>
                                    Please enter your username and password. 	
                                </p>
                            </div>
                            <table style="width: 100%; padding: 2px;text-align:left;">
                                <tr>
                                    <td style="padding:2px;">
                                        <dx:ASPxLabel ID="lblUserName" runat="server" AssociatedControlID="tbUserName" Text="User Name:" />
                                    </td>
                                    <td style="padding:2px;">
                                        <dx:ASPxTextBox ID="tbUserName" runat="server" Width="200px">
                                            <ValidationSettings ValidationGroup="LoginUserValidationGroup" Display="Dynamic" ErrorTextPosition="Bottom">
                                                <RequiredField ErrorText="User Name is required." IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding:2px;">
                                        <dx:ASPxLabel ID="lblPassword" runat="server" AssociatedControlID="tbPassword" Text="Password:" />
                                    </td>
                                    <td style="padding:2px;">
                                        <dx:ASPxTextBox ID="tbPassword" runat="server" Password="true" Width="200px">
                                            <ValidationSettings ValidationGroup="LoginUserValidationGroup" Display="Dynamic" ErrorTextPosition="Bottom">
                                                <RequiredField ErrorText="Password is required." IsRequired="true" />
                                            </ValidationSettings>
                                        </dx:ASPxTextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align:center;padding:2px;"">
                                        <dx:ASPxButton ID="btnLogin" runat="server" Text="Log In" ValidationGroup="LoginUserValidationGroup"
                                            OnClick="btnLogin_Click">
                                        </dx:ASPxButton>
                                        &nbsp;
                                        <dx:ASPxButton ID="ASPxButton1" runat="server" Text="Clear" AutoPostBack="false">
                                            <ClientSideEvents Click="function(){ASPxClientEdit.ClearEditorsInContainer(form1);}" />
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                        </dx:PanelContent>
                    </PanelCollection>
                </dx:ASPxRoundPanel>
            </div>
        </div>
        <!--[if lt IE 7]>
            <p class="browsehappy">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
        <![endif]-->

        <!--BEGIN LANDING-->
        
        <%--  --%>
        <script>
            document.write('<div id="landing-loader"><i class="fa fa-spinner fa-spin"></i></div>');
        </script>

        <div class="landing">
            <div class="landing-bg landing-bg-ani"></div>
            <article class="sign-in">
                <section id="sign-in-box" class="sign-in-box-ani">
                    <header class="logo-landing">
                        <img id="logo-landing" src="/images/img/logo_landing.png" alt="My Ideal Property Portal" class="go-retina logo-ani" width="114"/>
                    </header>
                    <div class="sign-in-form-wrapper">
                        <div class="sign-in-form fade-in" id="portal-sign-in-form" name="portal-sign-in-form" action="login-processor.html" >
                            <input class="sif-username" id="username" name="username" type="text" placeholder="Username" autofocus required/>
                            <input class="sif-password" id="password" name="password" type="password" placeholder="Password" required/>
                            <div class="sif-remember">
                                <input id="remember-me" name="remember-me" type="checkbox"/>
                                <label for="remember-me">Remember Me</label>
                            </div>
                            <input class="sif-button" type="button" value="Sign In" onclick="onLogIn()"/>
                        </div>
                    </div>
                </section>
                <footer class="sign-in-footnote fade-in">
                    <p><a href="#"><i class="fa fa-lock"></i>Forgot your password?</a></p>
                </footer>
            </article>
        </div>
        <dx:ASPxCallback runat="server" ID="LogInCallBack" ClientInstanceName="LogInCallBackClinet" OnCallback="LogInCallBack_Callback">
            <ClientSideEvents CallbackComplete="function(s,e){LogInComplete(e.result);}" />
        </dx:ASPxCallback>
    </form>
    <!--END LANDING-->

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script>window.jQuery || document.write('<script src="/scripts/js/vendor/jquery-1.11.0.min.js"><\/script>')</script>
    <script src="/scripts/js/jquery.easing.1.3.js"></script>
    <script src="/scripts/js/jquery.debouncedresize.js"></script>
    <script src="/scripts/js/jquery.throttledresize.js"></script>
    <script src="/scripts/js/jquery.mousewheel.js"></script>
    <script src="/scrollbar/jquery.mCustomScrollbar.js"></script>
    <script src="/scripts/js/jquery.form.min.js"></script>
    <script src="/scripts/js/jquery.backstretch.min.js"></script>

    <script src="/scripts/js/main.js"></script>

</body>
</html>
