function FilterLLC()
{
    var test =
        
[{ "BBLE": 3000290008, "Owner": "PLYMOUTH REALTY CORP                                                  ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-26 10:21:15.917" },
{ "BBLE": 3004060052, "Owner": "GOWANUS REALTY LLC                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-09 08:19:52.413" },
{ "BBLE": 3004070052, "Owner": "RIBELLINO, RICHARD                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-09 08:19:56.270" },
{ "BBLE": 3004130058, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-09 08:20:03.460" },
{ "BBLE": 3004200001, "Owner": "JAEZ REALTY LLC                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-09 09:56:37.017" },
{ "BBLE": 3004270021, "Owner": "A SHAMOSH REALTY LLC                                                  ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-09 09:57:39.890" },
{ "BBLE": 3004330028, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-09 09:57:49.843" },
{ "BBLE": 3004410024, "Owner": "DSSR REALTY CORP                                                      ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-09 10:06:39.510" },
{ "BBLE": 3005230013, "Owner": "HARBOR TECH LLC                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-09 16:05:46.297" },
{ "BBLE": 3006050024, "Owner": "37 VAN DYKE LLC                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-09 16:24:31.740" },
{ "BBLE": 3007450075, "Owner": "JOSEPH KWASNIK                                                        ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-09 18:21:42.057" },
{ "BBLE": 3008200012, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-13 21:58:28.130" },
{ "BBLE": 3009920001, "Owner": "WING FAT REALTY COMPANY                                               ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-13 22:32:21.440" },
{ "BBLE": 3009920005, "Owner": "RIBELLINO RICHARD                                                     ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-13 22:32:22.707" },
{ "BBLE": 3009920007, "Owner": "POLIZZOTTO, ALFRED                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-13 22:32:23.970" },
{ "BBLE": 3010530086, "Owner": "MEH SERVICES INC                                                      ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-13 22:38:58.277" },
{ "BBLE": 3017160050, "Owner": "G B W BUILDING CORP                                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-14 00:05:37.837" },
{ "BBLE": 3017340033, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-14 00:06:16.073" },
{ "BBLE": 3018730030, "Owner": "FEBRUARY 22, LLC                                                      ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-14 00:15:32.060" },
{ "BBLE": 3018750023, "Owner": "HALL STREET REAL ESTATE LLC                                           ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-14 00:15:37.200" },
{ "BBLE": 3018840013, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-16 08:13:13.290" },
{ "BBLE": 3020320022, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-16 08:39:24.287" },
{ "BBLE": 3022500014, "Owner": "HOO CORP                                                              ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 08:53:00.340" },
{ "BBLE": 3022500041, "Owner": "A. HOLDING                                                            ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 08:53:01.713" },
{ "BBLE": 3022630077, "Owner": "485 REALTY OF NY LLC                                                  ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 08:53:19.997" },
{ "BBLE": 3022920029, "Owner": "OMELAN BEREZOWSKY                                                     ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 11:10:10.277" },
{ "BBLE": 3023000026, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-16 11:16:02.497" },
{ "BBLE": 3023090005, "Owner": "RONIT REALTY LLC                                                      ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 11:16:20.590" },
{ "BBLE": 3023130013, "Owner": "223 NORTH 8TH PARTNERS LLC                                            ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 11:16:26.997" },
{ "BBLE": 3023270002, "Owner": "NORTH 6TH STREET REALTY, LLC                                          ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 12:37:42.830" },
{ "BBLE": 3023570001, "Owner": "DELTA II PROPERTIES LLC                                               ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 15:17:05.750" },
{ "BBLE": 3023690014, "Owner": "382 EIGHT, LLC.                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 15:17:14.013" },
{ "BBLE": 3023780014, "Owner": "ALIZA GUTTMAN                                                         ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 15:17:27.827" },
{ "BBLE": 3023860007, "Owner": "RHS HOPE LLC                                                          ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 15:17:32.437" },
{ "BBLE": 3024410041, "Owner": "WEISS DAVID                                                           ", "CoOwner": "WEISS GITTY                                                           ", "LastUpdated": "2015-10-16 16:51:43.277" },
{ "BBLE": 3024430006, "Owner": "HOUSING PRESERVATION & DEVELOPMENT                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 16:51:48.117" },
{ "BBLE": 3024790012, "Owner": "RML ASSOCIATES                                                        ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 17:15:47.707" },
{ "BBLE": 3024790018, "Owner": "M&D 57 BOX STREET, LLC                                                ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 17:15:48.693" },
{ "BBLE": 3025560045, "Owner": "KENTGREENPOINT LLC                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 22:56:57.707" },
{ "BBLE": 3025890001, "Owner": "79 QUAY DEVELOPMENT LLC                                               ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 22:57:29.017" },
{ "BBLE": 3025890005, "Owner": "KWOK, ANNIE                                                           ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 22:57:29.940" },
{ "BBLE": 3026130020, "Owner": "KENTO TRADING COMPANY                                                 ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 22:58:07.783" },
{ "BBLE": 3026580052, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-16 23:03:17.527" },
{ "BBLE": 3026590001, "Owner": "284 NORMAN AVENUE LLC                                                 ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:03:19.200" },
{ "BBLE": 3026600050, "Owner": "640 MORGAN AVE CORP                                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:03:24.903" },
{ "BBLE": 3026610050, "Owner": "VALEMILL REALTY CORP                                                  ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:03:29.903" },
{ "BBLE": 3026980007, "Owner": "CLARK, JAMES P JR                                                     ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:03:52.667" },
{ "BBLE": 3027230007, "Owner": "WELNER DAVID C                                                        ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:17:33.267" },
{ "BBLE": 3028430023, "Owner": "125 DIVISION PLACE,                                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:33:08.407" },
{ "BBLE": 3028590016, "Owner": "NICOLE BRITTANY LTD                                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:33:25.017" },
{ "BBLE": 3028960001, "Owner": "380 MORGAN AVENUE ASSOCIATES, LLC                                     ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:33:41.143" },
{ "BBLE": 3030190008, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-16 23:49:01.780" },
{ "BBLE": 3030190027, "Owner": "KG 3 REALTY                                                           ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:49:03.247" },
{ "BBLE": 3030210057, "Owner": "TEN EYCK REALTY  LLC                                                  ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:49:09.013" },
{ "BBLE": 3030290006, "Owner": "AURORA SPORTSWEAR GROUP LTD                                           ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:49:18.670" },
{ "BBLE": 3030290021, "Owner": "HUGO LANDAU INC                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:49:19.607" },
{ "BBLE": 3030420001, "Owner": "SUNRISE INTERNATIONAL USA TRADING C                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:49:39.750" },
{ "BBLE": 3030630026, "Owner": "HONG KEE REALTY INC                                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:54:37.987" },
{ "BBLE": 3030740001, "Owner": "BOERUM JOHNSON AVE ASSOC                                              ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:54:47.173" },
{ "BBLE": 3030740012, "Owner": "338 JOHNSON REALTY LLC                                                ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:54:48.207" },
{ "BBLE": 3031090025, "Owner": "WONTON FOOD INC                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:55:39.907" },
{ "BBLE": 3031170049, "Owner": "YORKSHIRE PROPERTIES INC                                              ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:55:53.657" },
{ "BBLE": 3031230031, "Owner": "YORKSHIRE PROPERTIES INC                                              ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-16 23:56:03.567" },
{ "BBLE": 3052950060, "Owner": "PARNES ENTERPRISES INC                                                ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:11:05.873" },
{ "BBLE": 3053450034, "Owner": "LEFKO REALTY LLC                                                      ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:12:19.770" },
{ "BBLE": 3053930027, "Owner": "HI-TECH EQUIPMENT RENTAL & SALES CO                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:16:28.193" },
{ "BBLE": 3058100006, "Owner": "HTLB DEVELOPMENT GROUP INC.                                           ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:20:45.357" },
{ "BBLE": 4000130175, "Owner": "SCOTT AVE. PROPERTIE                                                  ", "CoOwner": "QUATTRO PROPERTIES LL                                                 ", "LastUpdated": "2015-10-17 00:24:07.083" },
{ "BBLE": 4000260017, "Owner": "DESIGN CENTER REALTY SUB, LLC                                         ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:29:34.807" },
{ "BBLE": 4000480021, "Owner": "46-20 11TH STREET, LLC                                                ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:38:04.017" },
{ "BBLE": 4000480025, "Owner": "JNMY LLC                                                              ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:38:04.953" },
{ "BBLE": 4000510038, "Owner": "BINJAMA REALTY INC                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:38:14.627" },
{ "BBLE": 4000620019, "Owner": "PROPER MANUFACTURING CO INC                                           ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:38:36.047" },
{ "BBLE": 4000620034, "Owner": "SCHUMAN PROPERTIES                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:38:36.970" },
{ "BBLE": 4001190085, "Owner": "SAN-AID REALTY CORP                                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:46:40.097" },
{ "BBLE": 4001870001, "Owner": "PROPPER PROPS INC                                                     ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 00:55:58.947" },
{ "BBLE": 4002190018, "Owner": "W B WERWAISS REALTY LLC                                               ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:00:39.687" },
{ "BBLE": 4002220017, "Owner": "139 A. C. A. REALTY                                                   ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:00:48.407" },
{ "BBLE": 4002800001, "Owner": "DG VAN DAM STREET LLC                                                 ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:05:01.567" },
{ "BBLE": 4003010026, "Owner": "SDS TERMNL &WRHSE COINC                                               ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:08:02.787" },
{ "BBLE": 4003310027, "Owner": "DOUG M SMITH                                                          ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:09:07.117" },
{ "BBLE": 4003380008, "Owner": "BLUMENFELD, JONATHANA                                                 ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:09:09.087" },
{ "BBLE": 4003420002, "Owner": "GOLDEN CENTURY RLTY CORP                                              ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:09:15.850" },
{ "BBLE": 4003590008, "Owner": "JOPET REALTY CORP                                                     ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:09:44.803" },
{ "BBLE": 4003620001, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-17 01:12:16.917" },
{ "BBLE": 4003640037, "Owner": "C F DAWN CORP                                                         ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:12:21.230" },
{ "BBLE": 4003930027, "Owner": "CIAMPA ENTERPRISES                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:13:00.370" },
{ "BBLE": 4004060002, "Owner": "MAMM REALTY INC                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:13:16.857" },
{ "BBLE": 4004430001, "Owner": "NEW YORK MASONRY TRAINING CENTER                                      ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:16:53.470" },
{ "BBLE": 4004540017, "Owner": "SEBE REALTY CORP                                                      ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:17:14.627" },
{ "BBLE": 4004750003, "Owner": "CVA REALTY CORP                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:17:47.207" },
{ "BBLE": 4005020009, "Owner": "EDITH F ANTHONY                                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:18:07.237" },
{ "BBLE": 4005030048, "Owner": "ACROSS THE RIVER REALTY                                               ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 01:18:10.113" },
{ "BBLE": 4005140001, "Owner": "VISSAS, JAMES                                                         ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 12:13:58.703" },
{ "BBLE": 4005380012, "Owner": "INDUSTRIAL TRACTOR PARTS CO INC                                       ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 12:14:22.563" },
{ "BBLE": 4005990001, "Owner": "W B WERWAISS REALTY LLC                                               ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 12:20:58.977" },
{ "BBLE": 4006370014, "Owner": "VERTA INDUSTRIES                                                      ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 12:38:07.140" },
{ "BBLE": 4006390013, "Owner": "W B WERWAISS REALTY LLC                                               ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 12:38:16.657" },
{ "BBLE": 4007890004, "Owner": "19-49 42ND L.I.C. CO.                                                 ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 12:45:25.963" },
{ "BBLE": 4007890015, "Owner": "EXCELLENT LAND HOLDING INC                                            ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 12:45:27.043" },
{ "BBLE": 4008020116, "Owner": "1837 STEINWAY CORP                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-17 12:45:53.263" },
{ "BBLE": 4009100009, "Owner": "NULL", "CoOwner": "NULL", "LastUpdated": "2015-10-17 12:52:59.487" },
{ "BBLE": 4092490052, "Owner": "RASOK INCORPORATED                                                    ", "CoOwner": "                                                                      ", "LastUpdated": "2015-10-21 08:22:02.267" }]

	var BBLEs = [];
	var regex1 = /(\d+)|[ |,]((llc|corp|inc|c?o?\.?l\.p\.|church|ltd|trust)\.?$)/i;
	for(i=0;i<test.length;i++)
	{
	    var l = test[i];
	    l.Owner_Name1 = l.Owner_Name1 || l.Owner;
	    l.Owner_Name2 = l.Owner_Name2 || l.CoOwner;
		var O1 = l.Owner_Name1.trim();
		var O2 = l.Owner_Name2.trim();
		var hasLLCOwner = O1.match(regex1) || O2.match(regex1);
		if (!hasLLCOwner)
		{
			BBLEs.push(l.BBLE);
		}
	}
	//console.log("=======BBLEs================");
	console.log(BBLEs);


    //////////////////// detail/////////////////////////
	//console.log("========resluts==========");
	//console.log(test.filter(function (o) { return BBLEs.indexOf(o.BBLE) >= 0 }));

	//console.log("======== Bad Leads LLC==========");
	//console.log(test.filter(function (o) { return BBLEs.indexOf(o.BBLE) < 0 }));

	//console.log("======== Bad Leads LLC BBLE==========");
	//console.log(test.filter(function (o) { return BBLEs.indexOf(o.BBLE) < 0 }).map(function (e) { return e.BBLE }));
}
FilterLLC();