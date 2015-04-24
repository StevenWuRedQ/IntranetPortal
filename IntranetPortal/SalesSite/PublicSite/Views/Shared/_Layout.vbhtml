<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@ViewBag.Title - My Ideal Property</title>
    <link rel="stylesheet" type="text/css" href="~/Content/normalize.css">
    <link rel="stylesheet" type="text/css" href="~/Content/wf.css">
    <link rel="stylesheet" href="~/fonts/font-awesome-4.3.0/css/font-awesome.min.css">
    @RenderSection("Header", False)
    <link rel="stylesheet" type="text/css" href="~/Content/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/webfont/1.4.7/webfont.js"></script>
    <script type="text/javascript"> 
    WebFont.load({
        google: {
            families: ["Source Sans Pro:200,200italic,300,300italic,regular,italic,600,600italic,700,700italic,900,900italic"]
        }
    });
    </script>
    @Html.DevExpress().GetScripts(
        New Script With {.ExtensionSuite = ExtensionSuite.NavigationAndLayout},
        New Script With {.ExtensionSuite = ExtensionSuite.HtmlEditor},
        New Script With {.ExtensionSuite = ExtensionSuite.GridView},
        New Script With {.ExtensionSuite = ExtensionSuite.Editors},
        New Script With {.ExtensionSuite = ExtensionSuite.Scheduler},
        New Script With {.ExtensionSuite = ExtensionSuite.TreeList}
    )

    @Html.DevExpress().GetStyleSheets(
        New StyleSheet With {.ExtensionSuite = ExtensionSuite.NavigationAndLayout},
        New StyleSheet With {.ExtensionSuite = ExtensionSuite.Editors},
        New StyleSheet With {.ExtensionSuite = ExtensionSuite.HtmlEditor},
        New StyleSheet With {.ExtensionSuite = ExtensionSuite.GridView},
        New StyleSheet With {.ExtensionSuite = ExtensionSuite.Scheduler},
        New StyleSheet With {.ExtensionSuite = ExtensionSuite.TreeList}
    )

    <script type="text/javascript" src="~/Scripts/modernizr.js"></script>
     <style type="text/css">
         
html {
        -webkit-font-smoothing: antialiased;
        font-smoothing: antialiased;
    }
    a, input, select {
        -moz-transition: color .5s ease, background-color .5s ease, border-color .5s ease, opacity .5s ease, -moz-transform .5s ease, box-shadow .5s ease;
        -ms-transition: color .5s ease, background-color .5s ease, border-color .5s ease, opacity .5s ease, -ms-transform .5s ease, box-shadow .5s ease;
        -o-transition: color .5s ease, background-color .5s ease, border-color .5s ease, opacity .5s ease, -o-transform .5s ease, box-shadow .5s ease;
        -webkit-transition: color .5s ease, background-color .5s ease, border-color .5s ease, opacity .5s ease, -webkit-transform .5s ease, box-shadow .5s ease;
        transition: color .5s ease, background-color .5s ease, border-color .5s ease, opacity .5s ease, transform .5s ease, box-shadow .5s ease;
    }
          @@media screen and (min-width: 1200px) {
            .w-container {
              max-width: 1170px;
            }
          }
    /*
    ==============================================
    pulse
    ==============================================
    */
    .pulse{
    	animation-name: pulse;
    	-webkit-animation-name: pulse;	
    	animation-duration: 1.5s;	
    	-webkit-animation-duration: 1.5s;
    	animation-iteration-count: infinite;
    	-webkit-animation-iteration-count: infinite;
    }
    @@keyframes pulse {
    	0% {
    		transform: scale(0.7);
    		opacity: 0.5;		
    	}
    	50% {
    		transform: scale(1);
    		opacity: 1;	
    	}	
    	100% {
    		transform: scale(0.7);
    		opacity: 0.5;	
    	}			
    }
    @@-webkit-keyframes pulse {
    	0% {
    		-webkit-transform: scale(0.75);
    		opacity: 0.5;		
    	}
    	50% {
    		-webkit-transform: scale(1);
    		opacity: 1;	
    	}	
    	100% {
    		-webkit-transform: scale(0.75);
    		opacity: 0.5;	
    	}			
    }

     </style>
</head>
<body>
    <nav class="w-hidden-medium w-hidden-small w-hidden-tiny global-nav">
        <div class="w-container global-nav-container">
            <div class="w-row">
                <div class="w-col w-col-2">
                    <a class="w-inline-block global-nav-logo" href="#">
                        <img src="~/images/logo.png" width="44" alt="54b53ed3af20c3f6386698ac_logo.png">
                    </a>
                </div>
                <div class="w-col w-col-10 global-nav-links">
                    <a class="global-nav-link gnl-current" href="#">Sales</a>
                    <a class="global-nav-link" href="#">Rentals</a>
                    <a class="global-nav-link" href="#">Agents</a>
                    <a class="global-nav-link" href="#">We Buy Houses</a>
                    <a class="global-nav-link" href="#">Company</a><!--<a class="global-nav-link gnl-user" href="#"><i class="fa fa-user"></i></a>-->
                </div>
            </div>
        </div>
    </nav>   

@RenderBody()

    <footer class="global-footer">
        <div class="w-container">
            <div class="w-row">
                <div class="w-col w-col-1">
                    <a class="font-awesome for-footer" href="#"><i class="fa fa-heart"></i></a><a class="font-awesome for-footer" href="#"><i class="fa fa-search"></i></a>
                </div>
                <div class="w-col w-col-11">
                    <div class="w-row">
                        <div class="w-col w-col-3 footer-links-block">
                            <h3 class="footer-links-heading">Buy a Home</h3>
                            <ul class="w-list-unstyled footer-links">
                                <li>
                                    <a href="#" class="footer-links-link">Homes for sale</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Commercial</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">New to the Market</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Reduced in Price</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Featured Listings</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Great Values</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Healthcare</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Townhouses</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Sell Your Home</a>
                                </li>
                            </ul>
                        </div>
                        <div class="w-col w-col-3 footer-links-block">
                            <h3 class="footer-links-heading">Rent an Apartment</h3>
                            <ul class="w-list-unstyled footer-links">
                                <li>
                                    <a href="#" class="footer-links-link">New York Apartments</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Commercial</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">New to the Market</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Reduced in Price</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Featured Listings</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Great Values</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Healthcare</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Townhouses</a>
                                </li>
                            </ul>
                        </div>
                        <div class="w-col w-col-3 footer-links-block">
                            <h3 class="footer-links-heading">Popular Neighborhoods</h3>
                            <ul class="w-list-unstyled footer-links">
                                <li>
                                    <a href="#" class="footer-links-link">Battery Park City</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Brooklyn Heights</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Chelsea</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Chinatown</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Long Island City</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Park Slope</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">SOHO</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">West Village</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Williamsburg</a>
                                </li>
                            </ul>
                        </div>
                        <div class="w-col w-col-3 footer-links-block">
                            <h3 class="footer-links-heading">Get Started</h3>
                            <ul class="w-list-unstyled footer-links">
                                <li>
                                    <a href="#" class="footer-links-link">Search through Listings</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Get Expert Advice</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">New Developments</a>
                                </li>
                                <li>
                                    <a href="#" class="footer-links-link">Open Houses</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </footer>
    <footer class="global-footer-2">
        <div class="w-container global-footer-seo">
            <h3 class="global-footer-seo-heading">Place SEO Text Here</h3>
            <p class="global-footer-seo-p">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum porttitor commodo libero. Donec malesuada, eros id vestibulum malesuada, magna est consectetur ipsum, vitae varius quam dolor et dolor. Interdum et malesuada fames ac ante ipsum primis in faucibus. Aenean in ipsum tristique turpis imperdiet vestibulum ut in nulla. Nullam sagittis sed libero ut gravida.</p>
            <div class="global-seo-divider"></div>
        </div>
        <div class="w-container global-footer-copyright">
            <a class="w-inline-block global-footer-copyright-link gfcl-left" href="#">
                <img src="~/images/logo_footer.png" width="49" alt="54b6c4c5f7e59176037ac85e_logo_footer.png">
            </a><a class="global-footer-copyright-link" href="#">Who We Are</a><a class="global-footer-copyright-link" href="#">Our Offices</a><a class="global-footer-copyright-link" href="#">Careers</a><a class="global-footer-copyright-link" href="#">FAQ</a><a class="global-footer-copyright-link" href="#">Terms &amp; Privacy</a><a class="global-footer-copyright-link" href="#">Contact</a>
            <div class="footer-copyright-text">
                ©2014 My Ideal Property Inc.
                <br><strong class="mip-important">Made in NYC</strong>
            </div>
        </div>
    </footer>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
    @RenderSection("FootScript", False)
    <script type="text/javascript" src="~/Scripts/wf.js"></script>       
    @RenderSection("scripts", required:=False)
</body>
</html>
