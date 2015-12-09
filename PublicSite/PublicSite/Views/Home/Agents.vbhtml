@Code
    ViewData("Title") = "Agents"
    Layout = "~/Views/Shared/_Layout.vbhtml"
End Code

@section Header
    <link rel="stylesheet" href="~/other/v-nav/css/style.css">
End Section

@code
    Html.RenderPartial("_TopMenuPartial")
End Code

<section class="page-intro agents-intro">
    <div class="w-container">
        <h2>Our Agents</h2>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam tempus felis turpis, dictum pellentesque sem maximus tristique. Curabitur elementum massa metus, vestibulum aliquam turpis semper aliquet.</p>
    </div>
</section>
<section class="page-content">
    <div class="w-container">
        @code
            Dim agents = PublicSiteData.PortalAgent.AgentList
        End Code

        @For i = 0 To Math.Ceiling(agents.Count / 4)
            @<div class="w-row">
                @For j = 0 To 3
                Dim index = 4 * i + j
                If index < agents.Count Then
                    Dim agent = agents(index)
                    @<div class="w-col w-col-3">
                        <a href="/home/AgentInfo/@agent.EmployeeID" class="agent-list">
                            <img src="/images/agents/sample.jpg" alt="">
                            @agent.Name
                        </a>
                    </div>
                End If
                Next
            </div>
        Next
        @*<div class="w-row">
                <div class="w-col w-col-4">
                    <a href="#" class="agent-list">
                        <img src="/images/agents/sample.jpg" alt="">
                        John Smith
                    </a>
                </div>
                <div class="w-col w-col-4">
                    <a href="#" class="agent-list">
                        <img src="/images/agents/sample-2.jpg" alt="">
                        Tim Brady
                    </a>
                </div>
                <div class="w-col w-col-4">
                    <a href="#" class="agent-list">
                        <img src="/images/agents/sample-3.jpg" alt="">
                        Angela Avalos
                    </a>
                </div>
            </div>
            <div class="w-row">
                <div class="w-col w-col-4">
                    <a href="#" class="agent-list">
                        <img src="/images/agents/sample-4.jpg" alt="">
                        Lisa Siegel
                    </a>
                </div>
                <div class="w-col w-col-4">
                    <a href="#" class="agent-list">
                        <img src="/images/agents/sample-5.jpg" alt="">
                        Daniel Pastorini
                    </a>
                </div>
                <div class="w-col w-col-4">
                    <a href="#" class="agent-list">
                        <img src="/images/agents/sample-6.jpg" alt="">
                        Jim Jackson
                    </a>
                </div>
            </div>*@
    </div>
</section>