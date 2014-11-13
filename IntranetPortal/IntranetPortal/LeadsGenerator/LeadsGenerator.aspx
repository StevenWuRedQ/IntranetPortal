<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="LeadsGenerator.aspx.vb" Inherits="IntranetPortal.LeadsGenerator" MasterPageFile="~/Content.Master" %>


<asp:Content ContentPlaceHolderID="head" runat="server">
    <link href='http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/css/bootstrap-select.css' rel='stylesheet' type='text/css' />
    <script src="http://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.6.3/js/bootstrap-select.js"></script>

</asp:Content>
<asp:Content ContentPlaceHolderID="MainContentPH" runat="server">

    <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Width="100%" Height="100%" ClientInstanceName="sampleSplitter" FullscreenMode="true">
        <Styles>
            <Pane>
                <Paddings Padding="0px" />
            </Pane>
        </Styles>
        <Panes>
            <dx:SplitterPane Size="20%" Name="listBoxContainer" ShowCollapseBackwardButton="True">
                <ContentCollection>
                    <dx:SplitterContentControl runat="server">
                        <div style="padding: 30px; color: #2e2f31;">
                            <div style="margin-bottom: 30px;">
                                <i class="fa fa-search-plus title_icon color_gray"></i>
                                <span class="title_text">Advanced Query</span>
                            </div>
                            <span class="font_18" style="color: #234b60;">Define your criteria below:</span>

                            <div class="form-group" style="margin-top: 20px;">
                                <label class="upcase_text">Location and Neighborhood </label>
                                <div class="form-inline">
                                    <select class="selectpicker form-control query_input_40percent" multiple>
                                        <option value="Borough">Borough</option>
                                        <option value="Zip">Zip</option>
                                    </select>
                                    <input class="form-control query_input_60percent" />
                                </div>

                            </div>

                            <div class="form-group">

                                <div style="display: inline-block; width: 70%">
                                    <label class="upcase_text" style="display: block">Property Class</label>

                                    <select class="selectpicker form-control " multiple>
                                        <option value="A0-CAPE CO">A0-CAPE CO</option>
                                        <option value="A1-TWO STORIES - DETACHE">A1-TWO STORIES - DETACHE</option>
                                        <option value="A2-ONE STORY - PERMANENT LIVING QUARTE">A2-ONE STORY - PERMANENT LIVING QUARTE</option>
                                        <option value="A3-LARGE SUBURBAN RESIDENC">A3-LARGE SUBURBAN RESIDENC</option>
                                        <option value="A4-CITY RESIDENCE ONE FAMIL">A4-CITY RESIDENCE ONE FAMIL</option>
                                        <option value="A5-ONE FAMILY ATTACHED OR SEMI-DETACHE">A5-ONE FAMILY ATTACHED OR SEMI-DETACHE</option>
                                        <option value="A6-SUMMER COTTAG">A6-SUMMER COTTAG</option>
                                        <option value="A7-MANSION TYPE OR TOWN HOUS">A7-MANSION TYPE OR TOWN HOUS</option>
                                        <option value="A8-BUNGALOW COLONY - COOPERATIVELY OWNED LAN">A8-BUNGALOW COLONY - COOPERATIVELY OWNED LAN</option>
                                        <option value="A9-MISCELLANEOUS ONE FAMIL">A9-MISCELLANEOUS ONE FAMIL</option>
                                        <option value="B1-TWO FAMILY BRIC">B1-TWO FAMILY BRIC</option>
                                        <option value="B2-TWO FAMILY FRAM">B2-TWO FAMILY FRAM</option>
                                        <option value="B3-TWO FAMILY CONVERTED FROM ONE FAMIL">B3-TWO FAMILY CONVERTED FROM ONE FAMIL</option>
                                        <option value="B9-MISCELLANEOUS TWO FAMIL">B9-MISCELLANEOUS TWO FAMIL</option>
                                        <option value="C0-THREE FAMILIE">C0-THREE FAMILIE</option>
                                        <option value="C1-OVER SIX FAMILIES WITHOUT STORE">C1-OVER SIX FAMILIES WITHOUT STORE</option>
                                        <option value="C2-FIVE TO SIX FAMILIE">C2-FIVE TO SIX FAMILIE</option>
                                        <option value="C3-FOUR FAMILIE">C3-FOUR FAMILIE</option>
                                        <option value="C4-OLD LAW TENEMEN">C4-OLD LAW TENEMEN</option>
                                        <option value="C5-CONVERTED DWELLINGS OR ROOMING HOUS">C5-CONVERTED DWELLINGS OR ROOMING HOUS</option>
                                        <option value="C6-WALK-UP COOPERATIV">C6-WALK-UP COOPERATIV</option>
                                        <option value="C7-WALK-UP APT. OVER SIX FAMILIES WITH STORE">C7-WALK-UP APT. OVER SIX FAMILIES WITH STORE</option>
                                        <option value="C8-WALK-UP CO-OP; CONVERSION FROM LOFT/WAREHOUS">C8-WALK-UP CO-OP; CONVERSION FROM LOFT/WAREHOUS</option>
                                        <option value="C9-GARDEN APT/MOBILE HOME/TRAILER PAR">C9-GARDEN APT/MOBILE HOME/TRAILER PAR</option>
                                        <option value="D0-ELEVATOR CO-OP; CONVERSION FROM LOFT/WAREHOUS">D0-ELEVATOR CO-OP; CONVERSION FROM LOFT/WAREHOUS</option>
                                        <option value="D1-ELEVATOR APT; SEMI-FIREPROOF WITHOUT STORE">D1-ELEVATOR APT; SEMI-FIREPROOF WITHOUT STORE</option>
                                        <option value="D2-ELEVATOR APT; ARTISTS IN RESIDENC">D2-ELEVATOR APT; ARTISTS IN RESIDENC</option>
                                        <option value="D3-ELEVATOR APT; FIREPROOF WITHOUT  STORE">D3-ELEVATOR APT; FIREPROOF WITHOUT  STORE</option>
                                        <option value="D4-ELEVATOR COOPERATIV">D4-ELEVATOR COOPERATIV</option>
                                        <option value="D5-ELEVATOR APT; CONVERTE">D5-ELEVATOR APT; CONVERTE</option>
                                        <option value="D6-ELEVATOR APT; FIREPROOF WITH STORE">D6-ELEVATOR APT; FIREPROOF WITH STORE</option>
                                        <option value="D7-ELEVATOR APT; SEMI-FIREPROOF WITH  STORE">D7-ELEVATOR APT; SEMI-FIREPROOF WITH  STORE</option>
                                        <option value="D8-ELEVATOR APT; LUXURY TYP">D8-ELEVATOR APT; LUXURY TYP</option>
                                        <option value="D9-ELEVATOR APT; MISCELLANEOU">D9-ELEVATOR APT; MISCELLANEOU</option>
                                        <option value="E1-FIREPROOF WAREHOUS">E1-FIREPROOF WAREHOUS</option>
                                        <option value="E3-SEMI-FIREPROOF WAREHOUS">E3-SEMI-FIREPROOF WAREHOUS</option>
                                        <option value="E4-METAL FRAME WAREHOUS">E4-METAL FRAME WAREHOUS</option>
                                        <option value="E6-GOVERNMENTAL WAREHOUS">E6-GOVERNMENTAL WAREHOUS</option>
                                        <option value="E7-SELF-STORAGE WAREHOUSE">E7-SELF-STORAGE WAREHOUSE</option>
                                        <option value="E9-MISCELLANEOUS WAREHOUS">E9-MISCELLANEOUS WAREHOUS</option>
                                        <option value="F1-FACTORY; HEAVY MANUFACTURING -FIREPROO">F1-FACTORY; HEAVY MANUFACTURING -FIREPROO</option>
                                        <option value="F2-FACTORY; SPECIAL CONSTRUCTION -FIREPROO">F2-FACTORY; SPECIAL CONSTRUCTION -FIREPROO</option>
                                        <option value="F4-FACTORY; INDUSTRIAL SEMI-FIREPROO">F4-FACTORY; INDUSTRIAL SEMI-FIREPROO</option>
                                        <option value="F5-FACTORY; LIGHT MANUFACTURIN">F5-FACTORY; LIGHT MANUFACTURIN</option>
                                        <option value="F8-FACTORY; TANK FAR">F8-FACTORY; TANK FAR</option>
                                        <option value="F9-FACTORY; INDUSTRIAL-MISCELLANEOU">F9-FACTORY; INDUSTRIAL-MISCELLANEOU</option>
                                        <option value="G0-GARAGE; RESIDENTIAL TAX CLASS ">G0-GARAGE; RESIDENTIAL TAX CLASS </option>
                                        <option value="G1-GARAGE; TWO OR MORE STORIE">G1-GARAGE; TWO OR MORE STORIE</option>
                                        <option value="G2-GARAGE; ONE STORY SEMI-PROOF OR FIRE-PROO">G2-GARAGE; ONE STORY SEMI-PROOF OR FIRE-PROO</option>
                                        <option value="G3-GARAGE AND GAS STATION COMBINE">G3-GARAGE AND GAS STATION COMBINE</option>
                                        <option value="G4-GAS STATION WITH ENCLOSED WORKSHO">G4-GAS STATION WITH ENCLOSED WORKSHO</option>
                                        <option value="G5-GAS STATION WITHOUT ENCLOSED WORKSHO">G5-GAS STATION WITHOUT ENCLOSED WORKSHO</option>
                                        <option value="G6-LICENSED PARKING LO">G6-LICENSED PARKING LO</option>
                                        <option value="G7-UNLICENSED PARKING LO">G7-UNLICENSED PARKING LO</option>
                                        <option value="G8-GARAGE WITH SHOWROO">G8-GARAGE WITH SHOWROO</option>
                                        <option value="G9-MISCELLANEOUS GARAGE OR GAS STATIO">G9-MISCELLANEOUS GARAGE OR GAS STATIO</option>
                                        <option value="H1-HOTEL; LUXURY TYPE BUILT PRIOR TO 196">H1-HOTEL; LUXURY TYPE BUILT PRIOR TO 196</option>
                                        <option value="H2-HOTEL; LUXURY TYPE BUILT AFTER 196">H2-HOTEL; LUXURY TYPE BUILT AFTER 196</option>
                                        <option value="H3-HOTEL; TRANSIENT OCCUPANCY-MIDTOWN MANHATTAN ARE">H3-HOTEL; TRANSIENT OCCUPANCY-MIDTOWN MANHATTAN ARE</option>
                                        <option value="H4-MOTE">H4-MOTE</option>
                                        <option value="H5-HOTEL; PRIVATE CLUB, LUXURY TYP">H5-HOTEL; PRIVATE CLUB, LUXURY TYP</option>
                                        <option value="H6-APARTMENT HOTE">H6-APARTMENT HOTE</option>
                                        <option value="H7-APARTMENT HOTEL - COOPERATIVELY OWNE">H7-APARTMENT HOTEL - COOPERATIVELY OWNE</option>
                                        <option value="H8-DORMITOR">H8-DORMITOR</option>
                                        <option value="H9-MISCELLANEOUS HOTE">H9-MISCELLANEOUS HOTE</option>
                                        <option value="I1-HOSPITAL, SANITARIUM, MENTAL INSTITUTIO">I1-HOSPITAL, SANITARIUM, MENTAL INSTITUTIO</option>
                                        <option value="I2-INFIRMAR">I2-INFIRMAR</option>
                                        <option value="I3-DISPENSAR">I3-DISPENSAR</option>
                                        <option value="I4-HOSPITAL; STAFF FACILIT">I4-HOSPITAL; STAFF FACILIT</option>
                                        <option value="I5-HEALTH CENTER, CHILD CENTER, CLINI">I5-HEALTH CENTER, CHILD CENTER, CLINI</option>
                                        <option value="I6-NURSING HOM">I6-NURSING HOM</option>
                                        <option value="I7-ADULT CARE FACILIT">I7-ADULT CARE FACILIT</option>
                                        <option value="I9-MISCELLANEOUS HOSPITAL, HEALTH CARE FACILIT">I9-MISCELLANEOUS HOSPITAL, HEALTH CARE FACILIT</option>
                                        <option value="J1-THEATRE; ART TYPE LESS THAN 400 SEAT">J1-THEATRE; ART TYPE LESS THAN 400 SEAT</option>
                                        <option value="J2-THEATRE; ART TYPE MORE THAN 400 SEAT">J2-THEATRE; ART TYPE MORE THAN 400 SEAT</option>
                                        <option value="J3-MOTION PICTURE THEATRE WITH BALCON">J3-MOTION PICTURE THEATRE WITH BALCON</option>
                                        <option value="J4-LEGITIMATE THEATRE, SOLE US">J4-LEGITIMATE THEATRE, SOLE US</option>
                                        <option value="J5-THEATRE IN MIXED-USE BUILDIN">J5-THEATRE IN MIXED-USE BUILDIN</option>
                                        <option value="J6-TELEVISION STUDI">J6-TELEVISION STUDI</option>
                                        <option value="J7-OFF BROADWAY TYPE THEATR">J7-OFF BROADWAY TYPE THEATR</option>
                                        <option value="J8-MULTIPLEX PICTURE THEATR">J8-MULTIPLEX PICTURE THEATR</option>
                                        <option value="J9-MISCELLANEOUS THEATR">J9-MISCELLANEOUS THEATR</option>
                                        <option value="K1-STORE BUILDING; ONE STOR">K1-STORE BUILDING; ONE STOR</option>
                                        <option value="K2-STORE BUILDING; TWO-STORY OR STORE/OFFIC">K2-STORE BUILDING; TWO-STORY OR STORE/OFFIC</option>
                                        <option value="K3-DEPARTMENT STORE - MULTI-STOR">K3-DEPARTMENT STORE - MULTI-STOR</option>
                                        <option value="K4-STORE WITH APARTMENTS ABOV">K4-STORE WITH APARTMENTS ABOV</option>
                                        <option value="K5-DINER - FRANCHISED TYPE STAN">K5-DINER - FRANCHISED TYPE STAN</option>
                                        <option value="K6-SHOPPING CENTER WITH PARKING FACILIT">K6-SHOPPING CENTER WITH PARKING FACILIT</option>
                                        <option value="K7-FUNERAL HOM">K7-FUNERAL HOM</option>
                                        <option value="K9-MISCELLANEOUS STORE BUILDIN">K9-MISCELLANEOUS STORE BUILDIN</option>
                                        <option value="L1-LOFT; OVER 8 STORIES (MID MANH. TYPE">L1-LOFT; OVER 8 STORIES (MID MANH. TYPE</option>
                                        <option value="L2-LOFT; FIREPROOF AND STORAGE TYPE WITHOUT STORE">L2-LOFT; FIREPROOF AND STORAGE TYPE WITHOUT STORE</option>
                                        <option value="L3-LOFT; SEMI-FIREPROO">L3-LOFT; SEMI-FIREPROO</option>
                                        <option value="L8-LOFT; WITH RETAIL STORES OTHER THAN TYPE ON">L8-LOFT; WITH RETAIL STORES OTHER THAN TYPE ON</option>
                                        <option value="L9-MISCELLANEOUS LOF">L9-MISCELLANEOUS LOF</option>
                                        <option value="M1-CHURCH, SYNAGOGUE, CHAPE">M1-CHURCH, SYNAGOGUE, CHAPE</option>
                                        <option value="M2-MISSION HOUSE (NON-RESIDENTIAL">M2-MISSION HOUSE (NON-RESIDENTIAL</option>
                                        <option value="M3-PARSONAGE, RECTOR">M3-PARSONAGE, RECTOR</option>
                                        <option value="M4-CONVEN">M4-CONVEN</option>
                                        <option value="M9-MISCELLANEOUS RELIGIOUS FACILIT">M9-MISCELLANEOUS RELIGIOUS FACILIT</option>
                                        <option value="N1-ASYLU">N1-ASYLU</option>
                                        <option value="N2-HOME FOR INDIGENT CHILDREN, AGED,HOMELES">N2-HOME FOR INDIGENT CHILDREN, AGED,HOMELES</option>
                                        <option value="N3-ORPHANAG">N3-ORPHANAG</option>
                                        <option value="N4-DETENTION HOUSE FOR WAYWARD GIRL">N4-DETENTION HOUSE FOR WAYWARD GIRL</option>
                                        <option value="N9-MISCELLANEOUS ASYLUM, HOM">N9-MISCELLANEOUS ASYLUM, HOM</option>
                                        <option value="O1-OFFICE BUILDING; FIREPROOF UP TO 9 STORIE">O1-OFFICE BUILDING; FIREPROOF UP TO 9 STORIE</option>
                                        <option value="O2-OFFICE BUILDING; 10+ STORIES - SIDE STREET TYP">O2-OFFICE BUILDING; 10+ STORIES - SIDE STREET TYP</option>
                                        <option value="O3-OFFICE BUILDING; 10+ STORIES - MAIN AVE TYP">O3-OFFICE BUILDING; 10+ STORIES - MAIN AVE TYP</option>
                                        <option value="O4-OFFICE BUILDING; TOWER TYP">O4-OFFICE BUILDING; TOWER TYP</option>
                                        <option value="O5-OFFICE BUILDING; SEMI-FIREPROO">O5-OFFICE BUILDING; SEMI-FIREPROO</option>
                                        <option value="O6-BANK BUILDING - DESIGNED EXCLUSIVELY FOR BANKIN">O6-BANK BUILDING - DESIGNED EXCLUSIVELY FOR BANKIN</option>
                                        <option value="O7-PROFESSIONAL BUILDIN">O7-PROFESSIONAL BUILDIN</option>
                                        <option value="O8-OFFICE BUILDING; WITH RESIDENTIAL APARTMENT">O8-OFFICE BUILDING; WITH RESIDENTIAL APARTMENT</option>
                                        <option value="O9-MISCELLANEOUS OFFICE BUILDIN">O9-MISCELLANEOUS OFFICE BUILDIN</option>
                                        <option value="P1-CONCERT HAL">P1-CONCERT HAL</option>
                                        <option value="P2-LODGE ROO">P2-LODGE ROO</option>
                                        <option value="P3-YWCA, YMCA, YWHA, YMHA, PA">P3-YWCA, YMCA, YWHA, YMHA, PA</option>
                                        <option value="P4-BEACH CLU">P4-BEACH CLU</option>
                                        <option value="P5-COMMUNITY CENTE">P5-COMMUNITY CENTE</option>
                                        <option value="P6-AMUSEMENT PLACE, BATH HOUSE, BOAT  HOUS">P6-AMUSEMENT PLACE, BATH HOUSE, BOAT  HOUS</option>
                                        <option value="P7-MUSEU">P7-MUSEU</option>
                                        <option value="P8-LIBRAR">P8-LIBRAR</option>
                                        <option value="P9-MISCELLANEOUS INDOOR PUBLIC ASSEMBL">P9-MISCELLANEOUS INDOOR PUBLIC ASSEMBL</option>
                                        <option value="Q1-PAR">Q1-PAR</option>
                                        <option value="Q2-PLAYGROUN">Q2-PLAYGROUN</option>
                                        <option value="Q3-OUTDOOR POO">Q3-OUTDOOR POO</option>
                                        <option value="Q4-BEAC">Q4-BEAC</option>
                                        <option value="Q5-GOLF COURS">Q5-GOLF COURS</option>
                                        <option value="Q6-STADIUM, RACE TRACK, BASEBALL FIEL">Q6-STADIUM, RACE TRACK, BASEBALL FIEL</option>
                                        <option value="Q7-TENNIS COUR">Q7-TENNIS COUR</option>
                                        <option value="Q8-MARINA, YACHT CLU">Q8-MARINA, YACHT CLU</option>
                                        <option value="Q9-MISCELLANEOUS OUTDOOR RECREATIONAL   FACILIT">Q9-MISCELLANEOUS OUTDOOR RECREATIONAL   FACILIT</option>
                                        <option value="R0-SPECIAL CONDOMINIUM BILLING LO">R0-SPECIAL CONDOMINIUM BILLING LO</option>
                                        <option value="R1-CONDO; RESIDENTIAL UNIT IN 2-10 UNIT BLDG">R1-CONDO; RESIDENTIAL UNIT IN 2-10 UNIT BLDG</option>
                                        <option value="R2-CONDO; RESIDENTIAL UNIT IN WALK-UP BLDG">R2-CONDO; RESIDENTIAL UNIT IN WALK-UP BLDG</option>
                                        <option value="R3-CONDO; RESIDENTIAL UNIT IN 1-3 STORY BLDG">R3-CONDO; RESIDENTIAL UNIT IN 1-3 STORY BLDG</option>
                                        <option value="R4-CONDO; RESIDENTIAL UNIT IN ELEVATOR BLDG">R4-CONDO; RESIDENTIAL UNIT IN ELEVATOR BLDG</option>
                                        <option value="R5-CONDO; MISCELLANEOUS COMMERCIA">R5-CONDO; MISCELLANEOUS COMMERCIA</option>
                                        <option value="R6-CONDO; RESID.UNIT OF 1-3 UNIT BLDG-ORIG  CLASS ">R6-CONDO; RESID.UNIT OF 1-3 UNIT BLDG-ORIG  CLASS </option>
                                        <option value="R7-CONDO; COMML.UNIT OF 1-3 UNIT BLDG-ORIG  CLASS ">R7-CONDO; COMML.UNIT OF 1-3 UNIT BLDG-ORIG  CLASS </option>
                                        <option value="R8-CONDO; COMML.UNIT OF 2-10 UNIT BLDG">R8-CONDO; COMML.UNIT OF 2-10 UNIT BLDG</option>
                                        <option value="R9-CO-OP WITHIN A CONDOMINIU">R9-CO-OP WITHIN A CONDOMINIU</option>
                                        <option value="RA-CULTURAL, MEDICAL, EDUCATIONAL, ETC">RA-CULTURAL, MEDICAL, EDUCATIONAL, ETC</option>
                                        <option value="RB-OFFICE SPAC">RB-OFFICE SPAC</option>
                                        <option value="RG-INDOOR PARKIN">RG-INDOOR PARKIN</option>
                                        <option value="RH-HOTEL/BOAR">RH-HOTEL/BOAR</option>
                                        <option value="RK-RETAIL SPAC">RK-RETAIL SPAC</option>
                                        <option value="RP-OUTDOOR PARKIN">RP-OUTDOOR PARKIN</option>
                                        <option value="RR-CONDO RENTAL">RR-CONDO RENTAL</option>
                                        <option value="RS-NON-BUSINESS STORAGE SPAC">RS-NON-BUSINESS STORAGE SPAC</option>
                                        <option value="RT-TERRACES/GARDENS/CABANA">RT-TERRACES/GARDENS/CABANA</option>
                                        <option value="RW-WAREHOUSE/FACTORY/INDUSTRIA">RW-WAREHOUSE/FACTORY/INDUSTRIA</option>
                                        <option value="S0-PRIMARILY 1 FAMILY WITH 2 STORES OR  OFFICE">S0-PRIMARILY 1 FAMILY WITH 2 STORES OR  OFFICE</option>
                                        <option value="S1-PRIMARILY 1 FAMILY WITH 1 STORE OR  OFFIC">S1-PRIMARILY 1 FAMILY WITH 1 STORE OR  OFFIC</option>
                                        <option value="S2-PRIMARILY 2 FAMILY WITH 1 STORE OR   OFFIC">S2-PRIMARILY 2 FAMILY WITH 1 STORE OR   OFFIC</option>
                                        <option value="S3-PRIMARILY 3 FAMILY WITH 1 STORE OR OFFIC">S3-PRIMARILY 3 FAMILY WITH 1 STORE OR OFFIC</option>
                                        <option value="S4-PRIMARILY 4 FAMILY WITH 1 STORE OR OFFIC">S4-PRIMARILY 4 FAMILY WITH 1 STORE OR OFFIC</option>
                                        <option value="S5-PRIMARILY 5-6 FAMILY WITH 1 STORE OR OFFIC">S5-PRIMARILY 5-6 FAMILY WITH 1 STORE OR OFFIC</option>
                                        <option value="S9-SINGLE OR MULTIPLE DWELLING WITH STORES OR OFFICE">S9-SINGLE OR MULTIPLE DWELLING WITH STORES OR OFFICE</option>
                                        <option value="T1-AIRPORT, AIRFIELD, TERMINA">T1-AIRPORT, AIRFIELD, TERMINA</option>
                                        <option value="T2-PIER, DOCK, BULKHEA">T2-PIER, DOCK, BULKHEA</option>
                                        <option value="T9-MISCELLANEOUS TRANSPORTATION FACILIT">T9-MISCELLANEOUS TRANSPORTATION FACILIT</option>
                                        <option value="U0-UTILITY COMPANY LAND AND BUILDIN">U0-UTILITY COMPANY LAND AND BUILDIN</option>
                                        <option value="U1-BRIDGE, TUNNEL, HIGHWA">U1-BRIDGE, TUNNEL, HIGHWA</option>
                                        <option value="U2-GAS OR ELECTRIC UTILIT">U2-GAS OR ELECTRIC UTILIT</option>
                                        <option value="U3-CEILING RAILROA">U3-CEILING RAILROA</option>
                                        <option value="U4-TELEPHONE UTILIT">U4-TELEPHONE UTILIT</option>
                                        <option value="U5-COMMUNICATION FACILITY OTHER THAN TELEPHON">U5-COMMUNICATION FACILITY OTHER THAN TELEPHON</option>
                                        <option value="U6-RAILROAD - PRIVATE OWNERSHI">U6-RAILROAD - PRIVATE OWNERSHI</option>
                                        <option value="U7-TRANSPORTATION - PUBLIC OWNERSHI">U7-TRANSPORTATION - PUBLIC OWNERSHI</option>
                                        <option value="U8-REVOCABLE CONSEN">U8-REVOCABLE CONSEN</option>
                                        <option value="U9-MISCELLANEOUS UTILITY PROPERT">U9-MISCELLANEOUS UTILITY PROPERT</option>
                                        <option value="V0-ZONED RESIDENTIAL; NOT MANHATTA">V0-ZONED RESIDENTIAL; NOT MANHATTA</option>
                                        <option value="V1-ZONED COMMERCIAL OR MANHATTAN RESIDENTIA">V1-ZONED COMMERCIAL OR MANHATTAN RESIDENTIA</option>
                                        <option value="V2-ZONED COMMERCIAL ADJACENT TO CLASS 1 DWELLING: NOT MANHATTA">V2-ZONED COMMERCIAL ADJACENT TO CLASS 1 DWELLING: NOT MANHATTA</option>
                                        <option value="V3-ZONED PRIMARILY RESIDENTIAL; NOT MANHATTA">V3-ZONED PRIMARILY RESIDENTIAL; NOT MANHATTA</option>
                                        <option value="V4-POLICE OR FIRE DEPARTMEN">V4-POLICE OR FIRE DEPARTMEN</option>
                                        <option value="V5-SCHOOL SITE OR YAR">V5-SCHOOL SITE OR YAR</option>
                                        <option value="V6-LIBRARY, HOSPITAL OR MUSEU">V6-LIBRARY, HOSPITAL OR MUSEU</option>
                                        <option value="V7-PORT AUTHORITY OF NEW YORK AND NEW  JERSE">V7-PORT AUTHORITY OF NEW YORK AND NEW  JERSE</option>
                                        <option value="V8-NEW YORK STATE OR US GOVERNMEN">V8-NEW YORK STATE OR US GOVERNMEN</option>
                                        <option value="V9-MISCELLANEOUS VACANT LAN">V9-MISCELLANEOUS VACANT LAN</option>
                                        <option value="W1-PUBLIC ELEMENTARY, JUNIOR OR SENIOR HIG">W1-PUBLIC ELEMENTARY, JUNIOR OR SENIOR HIG</option>
                                        <option value="W2-PAROCHIAL SCHOOL, YESHIV">W2-PAROCHIAL SCHOOL, YESHIV</option>
                                        <option value="W3-SCHOOL OR ACADEM">W3-SCHOOL OR ACADEM</option>
                                        <option value="W4-TRAINING SCHOO">W4-TRAINING SCHOO</option>
                                        <option value="W5-CITY UNIVERSIT">W5-CITY UNIVERSIT</option>
                                        <option value="W6-OTHER COLLEGE AND UNIVERSIT">W6-OTHER COLLEGE AND UNIVERSIT</option>
                                        <option value="W7-THEOLOGICAL SEMINAR">W7-THEOLOGICAL SEMINAR</option>
                                        <option value="W8-OTHER PRIVATE SCHOO">W8-OTHER PRIVATE SCHOO</option>
                                        <option value="W9-MISCELLANEOUS EDUCATIONAL FACILIT">W9-MISCELLANEOUS EDUCATIONAL FACILIT</option>
                                        <option value="Y1-FIRE DEPARTMEN">Y1-FIRE DEPARTMEN</option>
                                        <option value="Y2-POLICE DEPARTMEN">Y2-POLICE DEPARTMEN</option>
                                        <option value="Y3-PRISON, JAIL, HOUSE OF DETENTIO">Y3-PRISON, JAIL, HOUSE OF DETENTIO</option>
                                        <option value="Y4-MILITARY AND NAVAL INSTALLATIO">Y4-MILITARY AND NAVAL INSTALLATIO</option>
                                        <option value="Y5-DEPARTMENT OF REAL ESTAT">Y5-DEPARTMENT OF REAL ESTAT</option>
                                        <option value="Y6-DEPARTMENT OF SANITATIO">Y6-DEPARTMENT OF SANITATIO</option>
                                        <option value="Y7-DEPARTMENT OF PORTS AND TERMINAL">Y7-DEPARTMENT OF PORTS AND TERMINAL</option>
                                        <option value="Y8-DEPARTMENT OF PUBLIC WORK">Y8-DEPARTMENT OF PUBLIC WORK</option>
                                        <option value="Y9-DEPARTMENT OF ENVIRONMENTAL PROTECTIO">Y9-DEPARTMENT OF ENVIRONMENTAL PROTECTIO</option>
                                        <option value="Z0-TENNIS COURT, POOL, SHED, ETC">Z0-TENNIS COURT, POOL, SHED, ETC</option>
                                        <option value="Z1-COURT HOUS">Z1-COURT HOUS</option>
                                        <option value="Z2-PARKING PUBLIC PARKING ARE">Z2-PARKING PUBLIC PARKING ARE</option>
                                        <option value="Z3-POST OFFIC">Z3-POST OFFIC</option>
                                        <option value="Z4-FOREIGN GOVERNMEN">Z4-FOREIGN GOVERNMEN</option>
                                        <option value="Z5-UNITED NATION">Z5-UNITED NATION</option>
                                        <option value="Z6-LAND UNDER WATE">Z6-LAND UNDER WATE</option>
                                        <option value="Z7-EASEMEN">Z7-EASEMEN</option>
                                        <option value="Z8-CEMETER">Z8-CEMETER</option>
                                        <option value="Z9-OTHER MISCELLANEOU">Z9-OTHER MISCELLANEOU</option>
                                    </select>
                                </div>

                                <div style="display: inline-block; width: 25.5%" class=" query_input_margin">
                                    <label class="upcase_text" style="display: block">Zoning</label>
                                    <select class="selectpicker  form-control" multiple>
                                        <option>24d</option>
                                    </select>
                                </div>


                            </div>


                            <div class="form-group">
                                <label class="upcase_text">Unbuilt Sqft</label>
                                <div class="form-inline">
                                    <span style="font-size: 16px;">Between</span>

                                    <input class="form-control query_input_30percent query_input_margin query_input" />
                                    <span class="font_16 query_input_margin">to</span>

                                    <input type="email" class="form-control query_input_30percent query_input_margin query_input" />
                                </div>

                            </div>

                            <div class="form-group">
                                <label class="upcase_text" style="display: block">Lis Pendens</label>
                                <input id="Lis_Pendens_yes" type="radio" name="Lis_Pendens">
                                <label for="Lis_Pendens_yes">
                                    <span class="box_text">Yes </span>
                                </label>
                                <input id="Lis_Pendens_No" type="radio" name="Lis_Pendens">
                                <label for="Lis_Pendens_No" style="margin-left: 30px">
                                    <span class="box_text">No </span>
                                </label>
                            </div>
                        </div>


                    </dx:SplitterContentControl>
                </ContentCollection>
            </dx:SplitterPane>
            <dx:SplitterPane>
                <Panes>
                    <dx:SplitterPane Name="gridContainer" Size="80%">
                        <ContentCollection>
                            <dx:SplitterContentControl runat="server">
                                <div>
                                    <ul class="nav nav-tabs clearfix" role="tablist" style="height: 70px; background: #ff400d; font-size: 18px; color: white">
                                        <li class="active short_sale_head_tab">
                                            <a href="#table_view" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-file-text head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Table View</div>
                                            </a>
                                        </li>
                                        <li class="short_sale_head_tab" style="display: none"><%--map view not aviable right now--%>
                                            <a href="#map_view" role="tab" data-toggle="tab" class="tab_button_a">
                                                <i class="fa fa-map-marker head_tab_icon_padding"></i>
                                                <div class="font_size_bold">Map View</div>
                                            </a>
                                        </li>

                                    </ul>
                                    <div class="tab-content">
                                        <div role="tabpanel" class="tab-pane active" id="table_view">
                                            <div style="padding: 30px">
                                                <div style="margin: 0 10px; font-size: 36px">
                                                    <i class="fa fa-folder-open color_gray"></i>&nbsp;<span class="font_black">5 Results</span>
                                                </div>
                                                <div style="margin-top: 30px">
                                                    <dx:ASPxGridView ID="QueryResultsGrid" runat="server" Width="100%"  KeyFieldName="BBLE">
                                                        <Columns>
                                                            <dx:GridViewCommandColumn ShowSelectCheckbox="True" VisibleIndex="0" SelectAllCheckboxMode="AllPages">
                                                            </dx:GridViewCommandColumn>
                                                            <dx:GridViewDataColumn FieldName="LeadsName" VisibleIndex="1" />
                                                        </Columns>
                                                        <Styles>
                                                            <SelectedRow BackColor="#d9f1fd" ForeColor="#3993c1">

                                                            </SelectedRow>
                                                        </Styles>
                                                    </dx:ASPxGridView>
                                                </div>
                                            </div>


                                        </div>
                                        <div role="tabpanel" class="tab-pane" id="map_view">map view</div>

                                    </div>
                                </div>
                            </dx:SplitterContentControl>
                        </ContentCollection>
                    </dx:SplitterPane>

                </Panes>
            </dx:SplitterPane>
        </Panes>

    </dx:ASPxSplitter>


    <script>
        $(document).ready(
            function () {
                $('.selectpicker').selectpicker();
            }
            );

    </script>
</asp:Content>
