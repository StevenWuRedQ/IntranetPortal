@Code
    ViewData("Title") = "Home Page"
End Code

@section Header
    <link rel="stylesheet" href="~/other/navigation/css/style.css">
    <link rel="stylesheet" href="~/other/animated-headline/css/style.css">
End Section

<nav>
    <ul class="cd-primary-nav">
        <li><a href="#0">Sales</a></li>
        <li><a href="#0">Rentals</a></li>
        <li><a href="#0">Agents</a></li>
        <li><a href="#0">We Buy Houses</a></li>
        <li><a href="#0">Company</a></li>
        <!--<li class="cd-primary-nav-divider"></li>
        <li><a href="#0">Sign Up</a></li>-->
    </ul>
</nav>

<section class="hero" data-ix="display-global-nav">
    <header class="hero-brand">
        <div class="w-container">
            <a class="w-inline-block home-logo" href="http://myidealprop.com">
                <img src="~/images/home_logo.png" width="84" alt="54b43376af20c3f6386688a4_home_logo.png">
            </a>
        </div>
    </header>
    <div class="hero-callout">
        <h1 class="callout-h1 cd-headline clip">
            <span class="cd-words-wrapper">
                <b class="is-visible">Hundreds of listings!</b>
                <b>Add a second line!</b>
                <b>One more!</b>
            </span>
        </h1>
        <p class="callout-p">Search for your apartment today...</p>
    </div>
    <div class="hero-search">
        <div class="hero-search-box">
            <!--<div class="hero-search-selection"><a class="hero-search-link hsl-left hsl-current" href="#">Quick Search</a><a class="hero-search-link" href="#">Advanced Search</a></div>-->
            <div>
                <form id="search-form" name="search-form">
                    <select class="w-select hero-search-input hero-search-input-selection" id="Category" name="Category" data-name="Category" required>
                        <option value="Buy">Buy</option>
                        <option value="Rent">Rent</option>
                        <option value="Sell">Sell</option>
                    </select>
                    <input class="w-input hero-search-input" id="search-criteria" type="text" placeholder="Search neighborhood, city, zip or address" name="search-criteria" data-name="search-criteria" required="required">
                    <input class="w-button hero-search-button" type="submit" value="&#xf002;" data-wait="Please wait...">
                </form>
            </div>
        </div>
    </div>
    <div class="hero-go">
        <p>...Or meet one of our experienced agents</p><a class="hero-go-button pulse" href="#featured-agents"><i class="fa fa-angle-down"></i></a>
    </div>
</section>
<div class="cd-overlay-nav">
    <span></span>
</div> <!-- cd-overlay-nav -->

<div class="cd-overlay-content">
    <span></span>
</div> <!-- cd-overlay-content -->
<a href="#0" class="cd-nav-trigger">Menu<span class="cd-icon"></span></a>
<div class="featured-agents" id="featured-agents">
    <section class="featured-agents-content">
        <div class="w-container featured-agents-container">
            <a class="featured-agents-nav fan-left" href="#"><i class="fa fa-angle-left"></i></a><a class="featured-agents-nav fan-right" href="#"><i class="fa fa-angle-right"></i></a>
            <div class="featured-agents-list-wrapper">
                <ul class="w-list-unstyled w-clearfix featured-agents-list">
                    @code
                        Dim agents = PublicSiteData.PortalAgent.AgentList
                    End Code

                    @For Each agent In agents

                        @<li class="featured-agents-list-item">
                             <a class="w-inline-block featured-agents-list-item-link" href="#fa-@agent.EmployeeID">
                                 <img class="featured-agents-list-item-pic" src="~/getAgentImage/@agent.EmployeeID" width="80" alt="/images/agent-1.jpg">
                                 <div>@agent.Name</div>
                             </a>
                                      
                      


                        </li>

                    Next

                    @*<li class="featured-agents-list-item">
                            <a class="w-inline-block featured-agents-list-item-link" href="#fa-serah-zach">
                                <img class="featured-agents-list-item-pic" src="images/agent-2.jpg" width="80" alt="54b551de50d87cf623f7e37d_agent-2.jpg">
                                <div>Serah Z.</div>
                            </a>
                        </li>
                        <li class="featured-agents-list-item">
                            <a class="w-inline-block featured-agents-list-item-link" href="#fa-jack-akin">
                                <img class="featured-agents-list-item-pic" src="images/agent-3.jpg" width="80" alt="54b551e4af20c3f638669a3f_agent-3.jpg">
                                <div>Jack A.</div>
                            </a>
                        </li>
                        <li class="featured-agents-list-item">
                            <a class="w-inline-block featured-agents-list-item-link" href="#">
                                <img class="featured-agents-list-item-pic" src="images/agent-4.jpg" width="80" alt="54b551ea50d87cf623f7e380_agent-4.jpg">
                                <div>Mark V.</div>
                            </a>
                        </li>
                        <li class="featured-agents-list-item">
                            <a class="w-inline-block featured-agents-list-item-link" href="#">
                                <img class="featured-agents-list-item-pic" src="images/agent-5.jpg" width="80" alt="54b551efaf20c3f638669a42_agent-5.jpg">
                                <div>Juliet S.</div>
                            </a>
                        </li>
                        <li class="featured-agents-list-item">
                            <a class="w-inline-block featured-agents-list-item-link" href="#">
                                <img class="featured-agents-list-item-pic" src="images/agent-5.jpg" width="80" alt="54b551efaf20c3f638669a42_agent-5.jpg">
                                <div>Juliet S.</div>
                            </a>
                        </li>
                        <li class="featured-agents-list-item">
                            <a class="w-inline-block featured-agents-list-item-link" href="#">
                                <img class="featured-agents-list-item-pic" src="images/agent-5.jpg" width="80" alt="54b551efaf20c3f638669a42_agent-5.jpg">
                                <div>Juliet S.</div>
                            </a>
                        </li>
                        <li class="featured-agents-list-item">
                            <a class="w-inline-block featured-agents-list-item-link" href="#">
                                <img class="featured-agents-list-item-pic" src="images/agent-5.jpg" width="80" alt="54b551efaf20c3f638669a42_agent-5.jpg">
                                <div>Juliet S.</div>
                            </a>
                        </li>*@
                    <!--<li class="featured-agents-list-item-blind falib-right"></li>
                    <li class="featured-agents-list-item-blind"></li>-->
                </ul>
            </div>
        </div>

        @For Each agent In agents

            @<div id="fa-@agent.EmployeeID" class="featured-agents-desc">
                <div class="w-container">
                    <div class="featured-agents-desc-content">
                        <h2 class="featured-agents-desc-h">@agent.Name</h2>
                        <p class="featured-agents-desc-p">
                            @agent.Description
                        </p><a class="button featured-agents-desc-button" href="#">More About @agent.Name.Split(" ")(0)</a>
                    </div>
                </div>
            </div>

        Next

        @*<div id="fa-jack-akin" class="featured-agents-desc">
                <div class="w-container">
                    <div class="featured-agents-desc-content">
                        <h2 class="featured-agents-desc-h">Jack Akin</h2>
                        <p class="featured-agents-desc-p">Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed velit urna, pulvinar id porttitor eget, fermentum nec libero. In pellentesque velit ut dui porttitor egestas. Nunc vel turpis finibus, venenatis neque sit amet, facilisis nulla. Curabitur a neque lobortis, fringilla purus id, pulvinar erat.</p><a class="button featured-agents-desc-button" href="#">More About Jack</a>
                    </div>
                </div>
            </div>*@
    </section>
</div>

<section class="featured-listings">
    <div class="w-container">
        <h2 class="mip-h2">Recent Listings</h2>
        <h3 class="mip-h3 close-top">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</h3>
        <div class="w-row">
            @code
                Dim recentListing = PublicSiteData.ListProperty.GetRecentListing
            End Code

            @For Each item In recentListing

                @<div class="w-col w-col-3">
                    <a class="w-inline-block featured-listings-item" href="/home/detail/@item.BBLE">
                        <img class="featured-listings-item-pic" src="~/getImage/@item.DefaultImage" width="190" height="190" style="border-radius:50%" alt="54b5667fa1dc10190edcda39_listing-2.jpg">
                        <div class="featured-listings-item-price"><span class="font-awesome"><i class="fa fa-tag"></i></span>&nbsp;@String.Format("{0:C0}", item.SalePrice) </div>
                        <div class="featured-listings-item-desc">
                            @item.BedRoomNum Bed at @item.StreetName
                            <br><span class="font-awesome"><i class="fa fa-map-marker"></i></span> @item.NeighName
                        </div>
                    </a>
                </div>
            Next


            @*<div class="w-col w-col-3">
                    <a class="w-inline-block featured-listings-item" href="#">
                        <img class="featured-listings-item-pic" src="images/listing-2.jpg" width="190" alt="54b5667fa1dc10190edcda39_listing-2.jpg">
                        <div class="featured-listings-item-price"><span class="font-awesome"><i class="fa fa-tag"></i></span>&nbsp;$7,413,000</div>
                        <div class="featured-listings-item-desc">
                            5 Bed at 48 Ave
                            <br><span class="font-awesome"><i class="fa fa-map-marker"></i></span> Bayside
                        </div>
                    </a>
                </div>
                <div class="w-col w-col-3">
                    <a class="w-inline-block featured-listings-item" href="#">
                        <img class="featured-listings-item-pic" src="images/listing-3.jpg" width="190" alt="54b566877f72257c2dde42d0_listing-3.jpg">
                        <div class="featured-listings-item-price"><span class="font-awesome"><i class="fa fa-clock-o"></i></span>&nbsp;$5,295/mo</div>
                        <div class="featured-listings-item-desc">
                            2 Bed at 132 St
                            <br><span class="font-awesome"><i class="fa fa-map-marker"></i></span> Chelsea
                        </div>
                    </a>
                </div>
                <div class="w-col w-col-3">
                    <a class="w-inline-block featured-listings-item" href="#">
                        <img class="featured-listings-item-pic" src="images/listing-4.jpg" width="190" alt="54b56690a1dc10190edcda3a_listing-4.jpg">
                        <div class="featured-listings-item-price"><span class="font-awesome"><i class="fa fa-tag"></i></span>&nbsp;$1,300,000</div>
                        <div class="featured-listings-item-desc">
                            4 Bed at ABC Blvd
                            <br><span class="font-awesome"><i class="fa fa-map-marker"></i></span> Brooklyn
                        </div>
                    </a>
                </div>*@
        </div>
    </div>
</section>
<section class="home-highlight">
    <div class="w-container">
        <h2 class="mip-h2">Find apartments in 3 steps.</h2>
        <div class="w-row">
            <div class="w-col w-col-4 home-highlight-item">
                <img src="~/images/find-apartment-icon-1.png" width="140" alt="54b56d917f72257c2dde43f3_find-apartment-icon-1.png">
                <h3>Search through listings.</h3>
                <div class="home-highlight-desc">Consectetur adipiscing elit.</div>
            </div>
            <div class="w-col w-col-4 home-highlight-item">
                <img src="~/images/find-apartment-icon-2.png" width="140" alt="54b570357f72257c2dde4430_find-apartment-icon-2.png">
                <h3>Get expert advice.</h3>
                <div class="home-highlight-desc">Magna est consectetur.</div>
            </div>
            <div class="w-col w-col-4 home-highlight-item">
                <img src="~/images/find-apartment-icon-3.png" width="140" alt="54b5703f7f72257c2dde4431_find-apartment-icon-3.png">
                <h3>Get your apartment.</h3>
                <div class="home-highlight-desc">Suspendisse erat ex.</div>
            </div>
        </div><a class="button home-highlight-button" href="#">Get Started</a>
    </div>
</section>
<section class="testimonial">
    <div class="testimonial-bg-1">
        <div class="w-container">
            <blockquote class="testimonial-quote">Just want to say that the humans who work for My Ideal Property are awesome. That is all.</blockquote>
            <div class="testimonial-cite">&#64;someone</div>
        </div>
    </div>
</section>
<section class="social-media">
    <div class="w-container social-media-container">
        <p>
            Let’s stay connected:&nbsp;<a href="#" class="font-awesome for-social-media fsm-left"><i class="fa fa-twitter"></i></a><a href="#" class="font-awesome for-social-media"><i class="fa fa-facebook"></i></a><a href="#" class="font-awesome for-social-media"><i class="fa fa-google-plus"></i></a><a href="#" class="font-awesome for-social-media"><i class="fa fa-linkedin"></i></a>
        </p>
    </div>
</section>

@section FootScript
    <script type="text/javascript" src="~/other/navigation/js/velocity.min.js"></script>
    <script type="text/javascript" src="~/other/navigation/js/main.js"></script>
    <script type="text/javascript" src="~/other/animated-headline/js/main.js"></script>
    <script type="text/javascript" src="~/Scripts/main.js"></script>
End Section
