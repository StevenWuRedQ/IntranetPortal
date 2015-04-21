@Code
    ViewData("Title") = "Apartment Detail"
    Layout = "~/Views/Shared/_Layout.vbhtml"
End Code

@section Header
<link rel="stylesheet" href="~/other/v-nav/css/style.css">
End Section

<a class="cd-nav-trigger cd-img-replace">Open navigation</a>
<nav id="cd-vertical-nav">
    <ul>
        <li>
            <a href="#apartment-general-info">
                <span class="cd-dot"></span>
                <span class="cd-label">General Info</span>
            </a>
        </li>
        <li>
            <a href="#apartment-about">
                <span class="cd-dot"></span>
                <span class="cd-label">About This Property</span>
            </a>
        </li>
        <li>
            <a href="#nearby-listings">
                <span class="cd-dot"></span>
                <span class="cd-label">Nearby Listings</span>
            </a>
        </li>
        <li>
            <a href="#about-the-neighborhood">
                <span class="cd-dot"></span>
                <span class="cd-label">Local Info</span>
            </a>
        </li>
    </ul>
</nav>
<div class="w-nav global-nav-2" data-collapse="medium" data-animation="default" data-duration="400" data-contain="1" data-ix="display-global-nav-2">
    <div class="w-container">
        <a class="w-nav-brand global-nav-logo gnlogo-subpage" href="#">
            <img class="global-nav-logo-img" src="~/images/logo.png" width="70" alt="54b53ed3af20c3f6386698ac_logo.png">
        </a>
        <nav class="w-nav-menu global-nav-open" role="navigation">
            <a class="w-nav-link global-nav-link gnl-subpage gnls-current" href="#">Sales</a>
            <a class="w-nav-link global-nav-link gnl-subpage" href="#">Rentals</a>
            <a class="w-nav-link global-nav-link gnl-subpage" href="#">Agents</a>
            <a class="w-nav-link global-nav-link gnl-subpage" href="#">We Buy Houses</a>
            <a class="w-nav-link global-nav-link gnl-subpage" href="#">Company</a><!--<a class="w-nav-link global-nav-link gnl-user gnl-subpage" href="#"><i class="fa fa-user"></i></a>-->
        </nav>
        <div class="w-nav-button global-nav-button">
            <div class="w-icon-nav-menu global-nav-button-icon"></div>
        </div>
    </div>
</div>

<section id="apartment-general-info" class="apartment-general-info">
    <div class="w-container">
        <h1 class="subpage-h1"><span class="font-awesome sh1fa"><i class="fa fa-map-marker"></i></span>&nbsp;2101 192th St</h1>
        <h2 class="subpage-h2">Forest Hills, NY 12345</h2>
        <a class="button agi-button agib-left agib-current" href="#">Photos</a>
        <a class="button agi-button" href="#">Floorplans</a>
        <a class="button agi-button" href="#">Map</a>
        <a class="button agi-button agib-right" href="#">Street View</a>
        <div class="agi-slider">
            <a class="agi-slider-nav agisn-left" href="#"><i class="fa fa-angle-left"></i></a><a class="agi-slider-nav agisn-right" href="#"><i class="fa fa-angle-right"></i></a>
            <div class="agi-slider-content">
                <img src="~/images/apartment_photo-1.jpg" alt="54bebe670a3e9e554cdf90fb_apartment_photo-1.jpg">
            </div>
        </div>
        <div class="w-clearfix agi-quick-info">
            <div class="agiqi-item"><span class="agiqi-item-important">3</span> bed</div>
            <div class="agiqi-item"><span class="agiqi-item-important">2</span> bath</div>
            <div class="w-clearfix agiqi-item agiqii-s2">
                <div class="agiqi-item-icon"><i class="fa fa-tag"></i></div>
                <div class="agiqi-item-text"><span class="agiqi-item-important agiqiii-2">$1,200,000</span> Annual Taxes: $3,912</div>
            </div>
            <div class="agiqi-item agiqii-s2">
                <div class="agiqi-item-textonly">
                    Added yesterday.
                    <br>Available October 29, 2014.
                </div>
            </div><a class="agiqi-item agiqi-item-iconlink" href="#" title="Add To Favorites"><i class="fa fa-heart"></i></a><a class="agiqi-item agiqi-item-iconlink" href="#" title="Enter Full Screen"><i class="fa fa-expand"></i></a>
        </div>
        <div class="w-row agi-other">
            <div class="w-col w-col-6 w-clearfix agi-transit">
                <h4 class="agi-transit-heading">Transit Lines</h4>
                <div class="agi-transit-line agitl-c1">E</div>
                <div class="agi-transit-line agitl-c2">F</div>
                <div class="agi-transit-line agitl-c2">M</div>
                <div class="agi-transit-line agitl-c3">R</div>
                <div class="agi-transit-line agitl-c4 agitl-small">LIRR</div>
            </div>
            <div class="w-col w-col-6">
                <div class="agi-share">
                    <span class="agi-share-text">Share this listing:</span>&nbsp;<a href="#" class="agi-share-link"><i class="fa fa-envelope"></i></a><a href="#" class="agi-share-link"><i class="fa fa-twitter"></i></a><a href="#" class="agi-share-link"><i class="fa fa-facebook"></i></a><a href="#" class="agi-share-link"><i class="fa fa-google-plus"></i></a><a href="#" class="agi-share-link"><i class="fa fa-linkedin"></i></a>
                </div>
            </div>
        </div>
    </div>
</section>
<section class="apartment-details">
    <div class="w-container">
        <div class="w-row">
            <div id="apartment-about" class="w-col w-col-7 ad-intro">
                <h2 class="global-heading-2">About This Property</h2>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse varius enim in eros elementum tristique. Duis cursus, mi quis viverra ornare, eros dolor interdum nulla, ut commodo diam libero vitae erat. Aenean faucibus nibh et justo cursus id rutrum lorem imperdiet. Nunc ut sem vitae risus tristique posuere.</p>
            </div>
            <div class="w-col w-col-5 ad-agent-container">
                <h2 class="global-heading-2">Exclusive Agents</h2>
                <ul class="w-list-unstyled">
                    <li>
                        <a class="w-inline-block ad-agent" href="#" data-ix="ad-agent-contact-show">
                            <img class="ad-agent-photo" src="~/images/agent-2.jpg" width="80" alt="54b551de50d87cf623f7e37d_agent-2.jpg">
                            <div class="ad-agent-name">Serah Zach</div>
                            <div class="ad-agent-contact">Contact Agent</div>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="apartment-features">
            <h2 class="global-heading-2">Features</h2>
            <ul class="w-list-unstyled w-clearfix apartment-features-list">
                <li class="afl-item">
                    <strong class="text-important">Northern Exposure</strong>
                </li>
                <li class="afl-item">Estern Exposure</li>
                <li class="afl-item">Southern Exposure</li>
                <li class="afl-item">
                    <strong class="text-important">Total Renovation</strong>
                </li>
                <li class="afl-item">Open Views</li>
                <li class="afl-item">Bay Windows</li>
                <li class="afl-item">
                    <strong class="text-important">Floor Thru</strong>
                </li>
                <li class="afl-item">Street Scape</li>
                <li class="afl-item">Exposed Brick</li>
            </ul>
        </div>
    </div>
    <div class="apartment-key-details">
        <div class="w-container">
            <h2 class="global-heading-2">Key Details</h2>
            <ul class="w-list-unstyled w-clearfix apartment-key-details-list">
                <li class="akdl-item"><strong class="text-important">Common Charges:</strong> $7,080</li>
                <li class="akdl-item"><strong class="text-important">Taxes:</strong> $6,062</li>
                <li class="akdl-item"><strong class="text-important">Price per Sq Foot:</strong> $5,032</li>
                <li class="akdl-item"><strong class="text-important">Min. Down Payment:</strong> 10%</li>
                <li class="akdl-item"><strong class="text-important">Dog:</strong> Allowed</li>
                <li class="akdl-item"><strong class="text-important">Cat:</strong> Allowed</li>
                <li class="akdl-item"><strong class="text-important">Square Feet:</strong> 7452 ft</li>
                <li class="akdl-item"><strong class="text-important">Units in Building:</strong> 19</li>
                <li class="akdl-item"><strong class="text-important">Building Floors:</strong> 12</li>
                <li class="akdl-item"><strong class="text-important">School District:</strong> 2</li>
            </ul>
        </div>
    </div>
</section>
<section id="nearby-listings" class="featured-listings featured-listings-nearby">
    <div class="w-container">
        <h2 class="global-heading-2">Nearby Listings You Might Like</h2>
        <div class="w-row">
            <div class="w-col w-col-4 w-col-stack">
                <a class="w-inline-block featured-listings-item fli-nearby" href="#">
                    <div class="fli-nearby-left">
                        <img class="featured-listings-item-pic flip-nearby" src="~/images/listing-1.jpg" width="190" alt="54b564547f72257c2dde4278_listing-1.jpg">
                    </div>
                    <div class="fli-nearby-right">
                        <div class="featured-listings-item-price flipr-nearby"><span class="font-awesome"><i class="fa fa-tag"></i></span>&nbsp;$5,795,000</div>
                        <div class="featured-listings-item-desc flid-nearby">
                            7 Bed at East 10 St
                            <br><span class="font-awesome"><i class="fa fa-map-marker"></i></span> Brooklyn
                        </div>
                    </div>
                </a>
            </div>
            <div class="w-col w-col-4 w-col-stack">
                <a class="w-inline-block featured-listings-item fli-nearby" href="#">
                    <div class="fli-nearby-left">
                        <img class="featured-listings-item-pic flip-nearby" src="~/images/listing-2.jpg" width="190" alt="54b5667fa1dc10190edcda39_listing-2.jpg">
                    </div>
                    <div class="fli-nearby-right">
                        <div class="featured-listings-item-price flipr-nearby"><span class="font-awesome"><i class="fa fa-tag"></i></span>&nbsp;$7,413,000</div>
                        <div class="featured-listings-item-desc flid-nearby">
                            5 Bed at 48 Ave
                            <br><span class="font-awesome"><i class="fa fa-map-marker"></i></span> Bayside
                        </div>
                    </div>
                </a>
            </div>
            <div class="w-col w-col-4 w-col-stack">
                <a class="w-inline-block featured-listings-item fli-nearby" href="#">
                    <div class="fli-nearby-left">
                        <img class="featured-listings-item-pic flip-nearby" src="~/images/listing-3.jpg" width="190" alt="54b566877f72257c2dde42d0_listing-3.jpg">
                    </div>
                    <div class="fli-nearby-right">
                        <div class="featured-listings-item-price flipr-nearby"><span class="font-awesome"><i class="fa fa-tag"></i></span>&nbsp;$5,295/mo</div>
                        <div class="featured-listings-item-desc flid-nearby">
                            2 Bed at 132 St
                            <br><span class="font-awesome"><i class="fa fa-map-marker"></i></span> Chelsea
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</section>
<section id="about-the-neighborhood" class="local-info li-forest-hills">
    <div class="w-container">
        <h2 class="global-heading-2 text-white">About The Neighborhood</h2>
        <h3 class="local-info-neighborhood-name">Forest Hills</h3>
        <div class="local-info-intro">
            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tempus felis turpis, dictum pellentesque sem maximus tristique. Curabitur elementum massa metus, vestibulum aliquam turpis semper aliquet. Curabitur nec felis erat. Aliquam risus ipsum, feugiat vitae mattis ut, elementum sit amet felis. Proin molestie dapibus pretium. Donec tincidunt, felis vitae efficitur aliquam, purus enim porttitor ligula, at commodo elit est ac tellus.
            <br>
            <br><a href="#" class="local-info-intro-link">Discover More</a>
        </div>
    </div>
</section>
<section class="apartment-footer-cta">
    <div class="w-container">
        <h2 class="afcta-heading">Interested in this home?</h2><a class="button mip-button-1" href="#">Meet Agent</a>
    </div>
</section>

@section  FootScript
<script type="text/javascript" src="~/other/v-nav/js/modernizr.js"></script>
<script type="text/javascript" src="~/other/v-nav/js/main.js"></script>
End Section