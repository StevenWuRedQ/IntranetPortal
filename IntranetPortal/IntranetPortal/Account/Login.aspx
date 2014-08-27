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
        function onLogIn() {
            if ($('#username').val().length == 0 || $('#password').val().length == 0)
            {
                alert('plase input user name or password');
                return;
            }
            LogInCallBackClinet.PerformCallback($('#username').val() + '|' + $('#password').val())
        }
        function LogInComplete(result) {

            //alert('mid ' + mid + 'afterloginsubmission' + afterloginsubmission);
            if (result != 'False') {
                window.location.replace("/default.aspx");
            }
            else {

                afterloginsubmission();

            }
        }

        function EnterInput(e)
        {
            if (e.keyCode == 13) {
                onLogIn();           
            }
        }

    </script>
</head>
<body >
    <form id="form1" runat="server" style="height:100%" method="post">

       
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
                        <div class="sign-in-form fade-in" id="portal-sign-in-form">
                            <input class="sif-username" id="username" name="username" type="text" placeholder="Username" autofocus="autofocus" required="required"/>
                            <input class="sif-password" id="password" name="password" type="password" placeholder="Password" required="required" onkeydown="return EnterInput(event)" />
                            <div class="sif-remember">
                                <input id="remember-me" name="remember-me" type="checkbox"/>
                                <label for="remember-me">Remember Me</label>
                            </div>
                            <input id="sign-in-button" class="sif-button" type="button" value="Sign In" onclick="onLogIn()" />
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
