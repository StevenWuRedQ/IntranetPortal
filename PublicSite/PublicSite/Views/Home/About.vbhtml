@Code
    ViewData("Title") = "Company"
End Code

@code
    Html.RenderPartial("_TopMenuPartial")
End Code

<section class="page-intro company-intro">
    <div class="w-container">
        <h2>My Ideal Property</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tempus felis turpis, dictum pellentesque sem maximus tristique. Curabitur elementum massa metus, vestibulum aliquam turpis semper aliquet. Curabitur nec felis erat. Aliquam risus ipsum, feugiat vitae mattis ut, elementum sit amet felis. Proin molestie dapibus pretium. Donec tincidunt, felis vitae efficitur aliquam, purus enim porttitor ligula, at commodo elit est ac tellus.</p>
    </div>
</section>
<section class="page-content">
    <div class="w-container">
        <div class="w-row">
            <div class="w-col w-col-7 page-content-intro">
                <h2 class="global-heading-2">About Us</h2>
                <div class="company-photo"><img src="~/images/team.jpg" alt=""></div>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum sed diam ut est iaculis egestas sed eget nisl. Nunc sed purus at mauris malesuada egestas a vitae dui.</p>
                <p>Nulla tincidunt semper tortor vel ultricies. Fusce semper turpis in ex porttitor dictum. Maecenas sed lacus et leo luctus fringilla eu sit amet ipsum. Sed ex est, porta ac sodales quis, porttitor ac velit. Nullam velit ligula, mollis ut dolor quis, facilisis rutrum odio. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Cras nulla sapien, pharetra vitae nisi ut, elementum facilisis nisl.</p>
                <p>Maecenas eu fringilla massa. Curabitur placerat, odio nec luctus finibus, odio justo rhoncus magna, quis accumsan quam dui maximus tellus. Vivamus eget ante sed odio consequat rhoncus. Aenean elementum dignissim semper. In mollis est ultricies, tempor mi at, consequat dolor. Fusce luctus, nisl vitae feugiat suscipit, justo lacus semper orci, a commodo nunc tellus id lorem. Sed sit amet massa auctor, tincidunt magna id, pulvinar nisl. Sed maximus ac arcu ut tincidunt. Donec in finibus quam.</p>
            </div>
            <div class="w-col w-col-5">
                <h2 class="global-heading-2">Our Milestones</h2>
                <dl class="w-clearfix page-dl">
                    <dt><i class="fa fa-star"></i> June 2011</dt>
                    <dd>Company founded.</dd>
                    <dt>December 2011</dt>
                    <dd>Mauris convallis sagittis elit.</dd>
                    <dt>March 2012</dt>
                    <dd>Phasellus ac sodales ante.</dd>
                    <dt>September 2013</dt>
                    <dd>Vestibulum faucibus lacinia sapien vitae tincidunt.</dd>
                    <dt>January 2014</dt>
                    <dd>Donec pellentesque leo sed mi pulvinar.</dd>
                    <dt>July 2014</dt>
                    <dd>Etiam mollis, massa eu dignissim feugiat.</dd>
                    <dt><i class="fa fa-trophy"></i> October 2014</dt>
                    <dd>Donec et sollicitudin ex. Suspendisse potenti.</dd>
                    <dt>May 2015</dt>
                    <dd>Nunc tincidunt metus vel.</dd>
                </dl>
            </div>
        </div>
    </div>
</section>
<section class="company-offices">
    <div class="w-container">
        <h2 class="global-heading-2">Our Offices</h2>
        <div class="w-row">
            <div class="w-col w-col-4">
                <div class="company-office">
                    <h3>Queens Office</h3>
                    <p>You may write a short introduction about this office at this location.</p>
                    <dl class="company-office-contact w-clearfix">
                        <dt><i class="fa fa-phone"></i></dt>
                        <dd>718.205.2000</dd>
                        <dt><i class="fa fa-fax"></i></dt>
                        <dd>718.205.0222</dd>
                        <dt><i class="fa fa-envelope"></i></dt>
                        <dd><a href="#">info@myidealprop.com</a></dd>
                        <dt><i class="fa fa-map-marker"></i></dt>
                        <dd>
                            116-55 Queens Blvd, #206<br>
                            Forest Hills, NY 11375
                        </dd>
                    </dl>
                </div>
            </div>
            <div class="w-col w-col-4">
                <div class="company-office">
                    <h3>Brooklyn Office</h3>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                    <dl class="company-office-contact w-clearfix">
                        <dt><i class="fa fa-phone"></i></dt>
                        <dd>718.205.2000</dd>
                        <dt><i class="fa fa-fax"></i></dt>
                        <dd>718.205.0222</dd>
                        <dt><i class="fa fa-envelope"></i></dt>
                        <dd>info@myidealprop.com</dd>
                        <dt><i class="fa fa-map-marker"></i></dt>
                        <dd>
                            116-55 Queens Blvd, #206<br>
                            Forest Hills, NY 11375
                        </dd>
                    </dl>
                </div>
            </div>
            <div class="w-col w-col-4">
                <div class="company-office company-office-no-border-right">
                    <h3>Rockaway Office</h3>
                    <p>Nunc ultricies euismod tortor, sed posuere lectus sodales in.</p>
                    <dl class="company-office-contact w-clearfix">
                        <dt><i class="fa fa-phone"></i></dt>
                        <dd>718.205.2000</dd>
                        <dt><i class="fa fa-fax"></i></dt>
                        <dd>718.205.0222</dd>
                        <dt><i class="fa fa-envelope"></i></dt>
                        <dd>info@myidealprop.com</dd>
                        <dt><i class="fa fa-map-marker"></i></dt>
                        <dd>
                            116-55 Queens Blvd, #206<br>
                            Forest Hills, NY 11375
                        </dd>
                    </dl>
                </div>
            </div>
        </div>
        <div class="w-row">
            <div class="w-col w-col-4">
                <div class="company-office">
                    <h3>Queens Office</h3>
                    <p>You may write a short introduction about this office at this location.</p>
                    <dl class="company-office-contact w-clearfix">
                        <dt><i class="fa fa-phone"></i></dt>
                        <dd>718.205.2000</dd>
                        <dt><i class="fa fa-fax"></i></dt>
                        <dd>718.205.0222</dd>
                        <dt><i class="fa fa-envelope"></i></dt>
                        <dd>info@myidealprop.com</dd>
                        <dt><i class="fa fa-map-marker"></i></dt>
                        <dd>
                            116-55 Queens Blvd, #206<br>
                            Forest Hills, NY 11375
                        </dd>
                    </dl>
                </div>
            </div>
            <div class="w-col w-col-4">
                <div class="company-office">
                    <h3>Brooklyn Office</h3>
                    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit.</p>
                    <dl class="company-office-contact w-clearfix">
                        <dt><i class="fa fa-phone"></i></dt>
                        <dd>718.205.2000</dd>
                        <dt><i class="fa fa-fax"></i></dt>
                        <dd>718.205.0222</dd>
                        <dt><i class="fa fa-envelope"></i></dt>
                        <dd>info@myidealprop.com</dd>
                        <dt><i class="fa fa-map-marker"></i></dt>
                        <dd>
                            116-55 Queens Blvd, #206<br>
                            Forest Hills, NY 11375
                        </dd>
                    </dl>
                </div>
            </div>
            <div class="w-col w-col-4">
                <div class="company-office company-office-no-border-right">
                    <h3>Rockaway Office</h3>
                    <p>Nunc ultricies euismod tortor, sed posuere lectus sodales in.</p>
                    <dl class="company-office-contact w-clearfix">
                        <dt><i class="fa fa-phone"></i></dt>
                        <dd>718.205.2000</dd>
                        <dt><i class="fa fa-fax"></i></dt>
                        <dd>718.205.0222</dd>
                        <dt><i class="fa fa-envelope"></i></dt>
                        <dd>info@myidealprop.com</dd>
                        <dt><i class="fa fa-map-marker"></i></dt>
                        <dd>
                            116-55 Queens Blvd, #206<br>
                            Forest Hills, NY 11375
                        </dd>
                    </dl>
                </div>
            </div>
        </div>
    </div>
</section>
<section class="p-highlights">
    <div class="w-container">
        <div class="p-features">
            <h2 class="global-heading-2">Why Choose My Ideal Property?</h2>
            <ul class="w-list-unstyled w-clearfix apartment-features-list">
                <li class="pfl-item">
                    <strong class="text-important">We're the best!</strong>
                </li>
                <li class="pfl-item">Lorem ipsum dolor sit amet, consectetur adipiscing elit.</li>
                <li class="pfl-item">Maecenas iaculis nisi ac molestie elementum.</li>
                <li class="pfl-item"><strong class="text-important">Sed risus turpis</strong>, hendrerit ut leo in, iaculis pulvinar sem.</li>
                <li class="pfl-item">Suspendisse ac purus id ante congue venenatis.</li>
                <li class="pfl-item">Aliquam risus mi, aliquam ut ligula dictum, pellentesque.</li>
                <li class="pfl-item"><strong class="text-important">Nam leo libero</strong>, rhoncus a aliquet id, rhoncus sit amet elit.</li>
                <li class="pfl-item">Nulla quis accumsan metus, in ullamcorper nisi.</li>
                <li class="pfl-item">Integer purus sapien, sagittis in suscipit sit amet.</li>
            </ul>
        </div>
    </div>
</section>