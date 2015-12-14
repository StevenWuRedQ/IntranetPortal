<%@ Page Language="VB" AutoEventWireup="true" CodeBehind="Login.aspx.vb" Inherits="IntranetPortal.Login" %>

<!doctype html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <title>My Ideal Property Portal</title>

    <link rel="stylesheet" href="/css/normalize.min.css" />
    <link rel="stylesheet" href='http://fonts.googleapis.com/css?family=Source+Sans+Pro:200,300,400,600,700,900' />
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" />
    <link rel="stylesheet" href="/bower_components/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.css" />
    <link rel="stylesheet" href="/css/main.css" />

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
    <script src="/bower_components/modernizr/modernizr.js"></script>
    <script src="/bower_components/jquery-easing/jquery.easing.min.js"></script>
    <script src="/bower_components/jquery-smartresize/jquery.debouncedresize.js"></script>
    <script src="/bower_components/jquery-smartresize/jquery.throttledresize.js"></script>
    <script src="/bower_components/jquery-mousewheel/jquery.mousewheel.min.js"></script>
    <script src="/bower_components/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.concat.min.js"></script>
    <script src="/bower_components/jquery-form/jquery.form.js"></script>
    <script src="/bower_components/jquery-backstretch/jquery.backstretch.min.js"></script>
    <script src="/Scripts/js/main.js"></script>


    <script>
        function onLogIn() {
            if ($('#username').val().length == 0 || $('#password').val().length == 0) {
                afterloginsubmission();
                return;
            }
            var rbMe = document.getElementById('remember-me').checked ? true : false;

            LogInCallBackClinet.PerformCallback($('#username').val() + '|' + $('#password').val() + '|' + rbMe)
        }

        function LogInComplete(result) {

            //alert('mid ' + mid + 'afterloginsubmission' + afterloginsubmission);
            if (result == 1) {
                var returnUrl = getParameterByName("ReturnUrl");
                if (returnUrl == "")
                    window.location.replace("/default.aspx");
                else
                    window.location.replace(returnUrl);
            }
            else {
                if (result == 3)
                    window.location.replace("/account/changepassword.aspx")
                else
                    afterloginsubmission();
            }
        }

        function EnterInput(e) {
            if (e.keyCode == 13) {
                onLogIn();
            }
        }

        function getParameterByName(name) {
            name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
            var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
                results = regex.exec(location.search);
            return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
        }

    </script>
</head>
<body>
    <form id="form1" runat="server" style="height: 100%" method="post">

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
                        <img id="logo-landing" src="/images/img/logo_landing.png" alt="My Ideal Property Portal" class="go-retina logo-ani" width="114" />
                    </header>
                    <div class="sign-in-form-wrapper">
                        <div class="sign-in-form fade-in" id="portal-sign-in-form">
                            <input class="sif-username" id="username" name="username" type="text" placeholder="Name or Email" autofocus="autofocus" required="required" />
                            <input class="sif-password" id="password" name="password" type="password" placeholder="Password" required="required" onkeydown="return EnterInput(event)" />
                            <div class="sif-remember">
                                <input id="remember-me" name="remember-me" type="checkbox" />
                                <label for="remember-me">Remember Me</label>
                            </div>
                            <input id="sign-in-button" class="sif-button" type="button" value="Sign In" onclick="onLogIn()" />
                        </div>
                    </div>
                </section>
                <footer class="sign-in-footnote fade-in">
                    <p><a href="mailto:chrisy@myidealprop.com"><i class="fa fa-lock"></i>Forgot your password?</a></p>
                </footer>
            </article>
        </div>
        <dx:ASPxCallback runat="server" ID="LogInCallBack" ClientInstanceName="LogInCallBackClinet" OnCallback="LogInCallBack_Callback">
            <ClientSideEvents CallbackComplete="function(s,e){LogInComplete(e.result);}" />
        </dx:ASPxCallback>
        <!-- Modal -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="display: none">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                    </div>
                    <div class="modal-body">
                        ...
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Okay</button>

                    </div>
                </div>
            </div>
        </div>
        <!-- /.modal -->
        <!--END LANDING-->


        <!-- Latest compiled and minified JavaScript -->

        <script type="text/javascript">
            function inIframe() {
                try {
                    return window.self !== window.top;
                } catch (e) {
                    return true;
                }
            }

            $(function () {
                if (inIframe()) {
                    top.window.location.href = window.location.href;
                }
            });
        </script>
        <script type="text/javascript">
            window.onload = setupRefresh;

            function setupRefresh() {
                setTimeout("refreshPage();", 1000 * 60 * 60);
            }
            function refreshPage() {
                window.location = location.href;
            }
        </script>

    </form>
</body>
</html>
