@modelType PublicSiteData.PortalAgent

@Code
    ViewData("Title") = Model.Name
    Layout = "~/Views/Shared/_Layout.vbhtml"
End Code

@code
    Html.RenderPartial("_TopMenuPartial")
End Code

<section class="page-intro agent-intro">
    <div class="w-container">
        <div class="page-agent-photo"><img src="~/images/agents/sample.jpg" alt=""></div>
        <h2>@Model.Name</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tempus felis turpis, dictum pellentesque sem maximus tristique. Curabitur elementum massa metus, vestibulum aliquam turpis semper aliquet.</p>
    </div>
</section>
<section class="page-content">
    <div class="w-container">
        <div class="w-row">
            <div class="w-col w-col-7 page-content-intro">
                <h2 class="global-heading-2">About Me</h2>                
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum sed diam ut est iaculis egestas sed eget nisl. Nunc sed purus at mauris malesuada egestas a vitae dui.</p>
                <p>Nulla tincidunt semper tortor vel ultricies. Fusce semper turpis in ex porttitor dictum. Maecenas sed lacus et leo luctus fringilla eu sit amet ipsum. Sed ex est, porta ac sodales quis, porttitor ac velit. Nullam velit ligula, mollis ut dolor quis, facilisis rutrum odio. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Cras nulla sapien, pharetra vitae nisi ut, elementum facilisis nisl.</p>
                <p>Maecenas eu fringilla massa. Curabitur placerat, odio nec luctus finibus, odio justo rhoncus magna, quis accumsan quam dui maximus tellus. Vivamus eget ante sed odio consequat rhoncus. Aenean elementum dignissim semper. In mollis est ultricies, tempor mi at, consequat dolor. Fusce luctus, nisl vitae feugiat suscipit, justo lacus semper orci, a commodo nunc tellus id lorem. Sed sit amet massa auctor, tincidunt magna id, pulvinar nisl. Sed maximus ac arcu ut tincidunt. Donec in finibus quam.</p>
            </div>
            <div class="w-col w-col-5">
                <h2 class="global-heading-2">Work With Me</h2>
                <dl class="w-clearfix agent-contact">
                    <dt><i class="fa fa-crosshairs"></i></dt>
                    <dd>Brooklyn, Downtown Manhattan</dd>
                </dl>
                <dl class="w-clearfix agent-contact">
                    <dt><i class="fa fa-phone"></i></dt>
                    <dd>@Model.CellPhone</dd>
                    <dt><i class="fa fa-envelope"></i></dt>
                    <dd><a href="#">@Model.Email</a></dd>
                </dl>
            </div>
        </div>
    </div>
</section>