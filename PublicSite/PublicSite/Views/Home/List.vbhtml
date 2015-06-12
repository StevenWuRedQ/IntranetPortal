@ModelType PublicSiteData.SearchCriteria

@Code
    ViewData("Title") = "Property List"
    Layout = "~/Views/Shared/_Layout.vbhtml"
End Code
@imports Newtonsoft.Json
@section Header
    <link rel="stylesheet" href="~/other/v-nav/css/style.css">
    <script src='https://api.tiles.mapbox.com/mapbox.js/v2.1.9/mapbox.js'></script>
    <link href='https://api.tiles.mapbox.com/mapbox.js/v2.1.9/mapbox.css' rel='stylesheet' />
    <script src="/Scripts/geojson.js"></script>
End Section

<div class="w-nav global-nav-2" data-collapse="medium" data-animation="default" data-duration="400" data-contain="1" data-ix="display-global-nav-2">
    <div class="w-container">
        <a class="w-nav-brand global-nav-logo gnlogo-subpage" href="~/">
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

<section class="hsearch-bar">
    <div class="w-container">
        @Using Html.BeginForm("List", "Home", FormMethod.Post)
            @Html.AntiForgeryToken()

            @Html.TextBoxFor(Function(model) model.Keyword, New With {.placeholder = "Search neighborhood, city, zip or address",
                .required = "required",
                .class = "w-input hsearch-bar-input"})

            @<text>
                @*<input class="w-input hsearch-bar-input" id="hsearch-criteria" type="text" placeholder="Search neighborhood, city, zip or address" name="search-criteria" data-name="hsearch-criteria" required="required">*@
                <select class="w-select hsearch-bar-input hsearch-bar-input-selection" id="price" name="price" data-name="price" required>
                    <option value="">Price</option>
                    <option value="Under $200,000">Under $200,000</option>
                    <option value="$200,000 - $300,000">$200,000 - $300,000</option>
                    <option value="$300,000 - $400,000">$300,000 - $400,000</option>
                </select>
                <select class="w-select hsearch-bar-input hsearch-bar-input-selection" id="beds" name="beds" data-name="beds">
                    <option value="">Beds</option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                </select>
                <select class="w-select hsearch-bar-input hsearch-bar-input-selection" id="baths" name="baths" data-name="baths">
                    <option value="">Baths</option>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                </select>
                <select class="w-select hsearch-bar-input hsearch-bar-input-selection" id="more" name="more" data-name="more">
                    <option value="">More</option>
                </select>
                <input class="w-button hsearch-button" type="submit" value="&#xf002;" data-wait="Please wait...">
            </text>

        End Using
    </div>
</section>
<section class="listings-map" style="background: #f5f5f5;">
    <div class="l-map-container">
        <style>
            #map {
                position: absolute;
                top: 0;
                bottom: 0;
                width: 100%;
            }
        </style>
        <div id='map' style="top:0;bottom:0;width:100%"></div>
        <script>
            L.mapbox.accessToken = 'pk.eyJ1IjoicG9ydGFsIiwiYSI6ImtCdG9ac00ifQ.p2_3nTko4JskYcg0YIgeyw';
            map = L.mapbox.map('map', 'examples.map-i87786ca').setView([40.7127, -74.0059], 11);
            var reslut = @Html.Raw(JsonConvert.SerializeObject(Model.Result))

            function map_reslut(o) {
                var image =  o.Images && o.Images[0] && o.Images[0].ImageData ? o.Images[0].ImageData : '';
                return { BBLE: o.BBLE, lat: o.Latitude, lng: o.Longitude, image: image }
            };
            var myLayer = L.mapbox.featureLayer().addTo(map);

            reslut = reslut.map(map_reslut);
            reslut.forEach(function (e, idx) { e.title = String.fromCharCode("A".charCodeAt(0) +idx ) })
            reslut = GeoJSON.parse(reslut, { Point: ['lat', 'lng'] });
            myLayer.on('layeradd', function (e) {
                var marker = e.layer,
                    feature = marker.feature;

                // Create custom popup content
                var popupContent = '<a target="_blank" class="popup" href="' + feature.properties.url + '">' +
                                        '<img src="data:image/png;base64, ' + feature.properties.image + '" />' +
                                        
                                    '</a>';

                // http://leafletjs.com/reference.html#popup
                marker.bindPopup(popupContent, {
                    closeButton: false,
                    minWidth: 320
                });
            })
            //alert(JSON.stringify(reslut));
            myLayer.setGeoJSON(reslut);
            //test
        </script>
    </div>
</section>
<section class="listings">
    <div class="listings-container">
        <div class="listings-order">
            Sort by:
            <select class="w-select listings-order-selection" id="listings-order-selection" name="listings-order-selection" data-name="listings-order-selection">
                <option value="">Time Posted</option>
                <option value="">Popularity</option>
            </select>
        </div>
        <div class="l-entries">
            <h2>Showing @Model.Result.Count properties</h2>

            @code
                Dim i = 0
                'Dim c As Char = "A"
                'c = c & 1
                Dim C As Byte = System.Text.Encoding.Unicode.GetBytes("A")(0)
            End Code

            @For Each item In Model.Result

                @<div class="l-entry">
                    <a class="l-entry-link" href="/home/detail/@item.BBLE" target="_blank">
                        <img src="~/images/sample-image-70-54.jpg" alt="" width="70" height="54">
                        <div class="l-entry-headers">
                            <h3>@item.Number&nbsp;@item.StreetName &nbsp;@(If(String.IsNullOrEmpty(item.AptNo), "", "Unit " & item.AptNo))</h3>
                            <h4><i class="fa fa-map-marker"></i> @item.NeighName</h4>
                        </div>
                        <div class="w-clearfix">
                            <div class="lei-item"><span class="lei-item-important">@item.BedRoomNum</span> bed</div>
                            <div class="lei-item"><span class="lei-item-important">@item.BathRoomNum</span> bath</div>
                            <div class="lei-item leii-s2 w-clearfix">
                                <div class="lei-item-icon"><i class="fa fa-tag"></i></div>
                                <div class="lei-item-text"><span class="lei-item-important leiii-2">@String.Format("{0:C0}", item.SalePrice)</span> Annual Taxes: @String.Format("{0:C0}", item.Taxes)</div>
                            </div>
                        </div>
                        <p class="l-entry-time-added">Added 2 hours ago</p>
                        <div class="l-entry-num">@Convert.ToChar(C + i)</div>
                        @code
                        i = i + 1
                        End Code
                    </a>
                </div>
            Next
            @*<div class="l-entry">
                    <a class="l-entry-link" href="#">
                        <img src="~/images/sample-image-70-54.jpg" alt="" width="70" height="54">
                        <div class="l-entry-headers">
                            <h3>740 Park Avenue, Unit 4/5D</h3>
                            <h4><i class="fa fa-map-marker"></i> Forest Hills</h4>
                        </div>
                        <div class="w-clearfix">
                            <div class="lei-item"><span class="lei-item-important">3</span> bed</div>
                            <div class="lei-item"><span class="lei-item-important">2</span> bath</div>
                            <div class="lei-item leii-s2 w-clearfix">
                                <div class="lei-item-icon"><i class="fa fa-tag"></i></div>
                                <div class="lei-item-text"><span class="lei-item-important leiii-2">$1,200,000</span> Annual Taxes: $3,912</div>
                            </div>
                        </div>
                        <p class="l-entry-time-added">Added 2 hours ago</p>
                        <div class="l-entry-num">A</div>
                    </a>
                </div>
                <div class="l-entry">
                    <a class="l-entry-link" href="#">
                        <img src="~/images/sample-image-70-54.jpg" alt="" width="70" height="54">
                        <div class="l-entry-headers">
                            <h3>740 Park Avenue, Unit 4/5D</h3>
                            <h4><i class="fa fa-map-marker"></i> Forest Hills</h4>
                        </div>
                        <div class="w-clearfix">
                            <div class="lei-item"><span class="lei-item-important">3</span> bed</div>
                            <div class="lei-item"><span class="lei-item-important">2</span> bath</div>
                            <div class="lei-item leii-s2 w-clearfix">
                                <div class="lei-item-icon"><i class="fa fa-tag"></i></div>
                                <div class="lei-item-text"><span class="lei-item-important leiii-2">$1,200,000</span> Annual Taxes: $3,912</div>
                            </div>
                        </div>
                        <p class="l-entry-time-added">Added 2 hours ago</p>
                        <div class="l-entry-num">B</div>
                    </a>
                </div>
                <div class="l-entry">
                    <a class="l-entry-link" href="#">
                        <img src="~/images/sample-image-70-54.jpg" alt="" width="70" height="54">
                        <div class="l-entry-headers">
                            <h3>740 Park Avenue, Unit 4/5D</h3>
                            <h4><i class="fa fa-map-marker"></i> Forest Hills</h4>
                        </div>
                        <div class="w-clearfix">
                            <div class="lei-item"><span class="lei-item-important">3</span> bed</div>
                            <div class="lei-item"><span class="lei-item-important">2</span> bath</div>
                            <div class="lei-item leii-s2 w-clearfix">
                                <div class="lei-item-icon"><i class="fa fa-tag"></i></div>
                                <div class="lei-item-text"><span class="lei-item-important leiii-2">$1,200,000</span> Annual Taxes: $3,912</div>
                            </div>
                        </div>
                        <p class="l-entry-time-added">Added 2 hours ago</p>
                        <div class="l-entry-num">C</div>
                    </a>
                </div>
                <div class="l-entry">
                    <a class="l-entry-link" href="#">
                        <img src="~/images/sample-image-70-54.jpg" alt="" width="70" height="54">
                        <div class="l-entry-headers">
                            <h3>740 Park Avenue, Unit 4/5D</h3>
                            <h4><i class="fa fa-map-marker"></i> Forest Hills</h4>
                        </div>
                        <div class="w-clearfix">
                            <div class="lei-item"><span class="lei-item-important">3</span> bed</div>
                            <div class="lei-item"><span class="lei-item-important">2</span> bath</div>
                            <div class="lei-item leii-s2 w-clearfix">
                                <div class="lei-item-icon"><i class="fa fa-tag"></i></div>
                                <div class="lei-item-text"><span class="lei-item-important leiii-2">$1,200,000</span> Annual Taxes: $3,912</div>
                            </div>
                        </div>
                        <p class="l-entry-time-added">Added 2 hours ago</p>
                        <div class="l-entry-num">D</div>
                    </a>
                </div>*@
        </div>
    </div>
</section>

@section  FootScript
    <script type="text/javascript" src="~/other/v-nav/js/modernizr.js"></script>
    <script type="text/javascript" src="~/other/v-nav/js/main.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $(".global-footer,.global-footer-2").each(function () {
                this.style.display = "none";
            });
        });
    </script>
End Section


