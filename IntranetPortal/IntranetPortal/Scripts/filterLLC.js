function FilterLLC()
{
    var test = [{ "BBLE": 3024880015, "Owner_Name1": "98 CLAY STREET                     ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:37.143" },
{ "BBLE": 3024970005, "Owner_Name1": "DZEMIL DEMIROVIC AKA               ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:39.550" },
{ "BBLE": 3025040066, "Owner_Name1": "MOLINSKY SAMSON                    ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:43:07.247" },
{ "BBLE": 3025110030, "Owner_Name1": "2644 BEDFORD CORP                  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:43.160" },
{ "BBLE": 3025111013, "Owner_Name1": "N. KAFI HOLDINGS LLC               ", "Owner_Name2": "                                   ", "LastUpdated": "2015-10-16 17:16:44.540" },
{ "BBLE": 3025111013, "Owner_Name1": "N. KAFI HOLDINGS LLC               ", "Owner_Name2": "                                   ", "LastUpdated": "2015-10-16 17:16:44.540" },
{ "BBLE": 3025111013, "Owner_Name1": "N. KAFI HOLDINGS LLC               ", "Owner_Name2": "                                   ", "LastUpdated": "2015-10-16 17:16:44.540" },
{ "BBLE": 3025130051, "Owner_Name1": "189 GREEN STREET INC.              ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:45.537" },
{ "BBLE": 3025170027, "Owner_Name1": "KING'S LAND REALTY ASSOCIATES LLC  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:46.707" },
{ "BBLE": 3025220056, "Owner_Name1": "COPETE LUIS                        ", "Owner_Name2": "                                   ", "LastUpdated": "NULL" },
{ "BBLE": 3025230001, "Owner_Name1": "KOSAKOWSKA, ANNA                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:49.113" },
{ "BBLE": 3025230001, "Owner_Name1": "KOSAKOWSKA, ANNA                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:49.113" },
{ "BBLE": 3025231010, "Owner_Name1": "GOLDSTEIN, DAVID A                 ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:43:10.913" },
{ "BBLE": 3025980019, "Owner_Name1": "ECKFORD HOMES LLC                  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:52.723" },
{ "BBLE": 3025980020, "Owner_Name1": "NULL", "Owner_Name2": "NULL", "LastUpdated": "2015-09-12 09:13:53.910" },
{ "BBLE": 3025980021, "Owner_Name1": "261 ECKFORD STREET LLC             ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:55.130" },
{ "BBLE": 3025991108, "Owner_Name1": "CIS, MARCIN                        ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:56.333" },
{ "BBLE": 3025991108, "Owner_Name1": "CIS, MARCIN                        ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:56.333" },
{ "BBLE": 3025991108, "Owner_Name1": "CIS, MARCIN                        ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:56.333" },
{ "BBLE": 3026070094, "Owner_Name1": "FLANAGAN,LAURA,M                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:57.520" },
{ "BBLE": 3026170001, "Owner_Name1": "DOBBINS HOLDINGS,LLC               ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:13:58.707" },
{ "BBLE": 3026220002, "Owner_Name1": "RYSZEWSKI , MARK                   ", "Owner_Name2": "RYSZEWSKI , KRYSTYNA               ", "LastUpdated": "2014-11-11 16:43:15.940" },
{ "BBLE": 3026221004, "Owner_Name1": "CANAVAN, RYAN                      ", "Owner_Name2": "CANAVAN, KAREN                     ", "LastUpdated": "2015-09-12 09:13:59.940" },
{ "BBLE": 3026280001, "Owner_Name1": "VJM 796 LLC                        ", "Owner_Name2": "                                   ", "LastUpdated": "2015-10-16 22:58:32.270" },
{ "BBLE": 3026280006, "Owner_Name1": "VJM 245, LLC                       ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:02.347" },
{ "BBLE": 3026280028, "Owner_Name1": "NOT ON FILE                        ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:03.550" },
{ "BBLE": 3026280028, "Owner_Name1": "NOT ON FILE                        ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:03.550" },
{ "BBLE": 3026440016, "Owner_Name1": "961 LORIMER STREET REALTY, LLC     ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:43:18.690" },
{ "BBLE": 3026450042, "Owner_Name1": "BEDNARCZYK SOPHIE                  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:05.927" },
{ "BBLE": 3026480044, "Owner_Name1": "MORRISON, JAMES D                  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:07.160" },
{ "BBLE": 3026490003, "Owner_Name1": "SCHWALLY, FRED P                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:08.347" },
{ "BBLE": 3026550063, "Owner_Name1": "ABRAMSHE LINDA C                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:15.550" },
{ "BBLE": 3026550063, "Owner_Name1": "ABRAMSHE LINDA C                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:15.550" },
{ "BBLE": 3026590036, "Owner_Name1": "GARDOCKI, MIROSLAW                 ", "Owner_Name2": "GARDOCKA, JOLANTA                  ", "LastUpdated": "2014-11-11 16:43:24.637" },
{ "BBLE": 3026840003, "Owner_Name1": "PAUL J HUTCHINSON                  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:21.520" },
{ "BBLE": 3026880018, "Owner_Name1": "TCKA LLC                           ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:43:27.390" },
{ "BBLE": 3026891006, "Owner_Name1": "CANDIO, CRISTINA                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:23.943" },
{ "BBLE": 3026891006, "Owner_Name1": "CANDIO, CRISTINA                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:23.943" },
{ "BBLE": 3026900012, "Owner_Name1": "GIUSTO, GIUSEPPE                   ", "Owner_Name2": "GIUSTO, JOSEPHINE SPORTELLA        ", "LastUpdated": "2014-11-11 16:43:28.300" },
{ "BBLE": 3026900012, "Owner_Name1": "GIUSTO, GIUSEPPE                   ", "Owner_Name2": "GIUSTO, JOSEPHINE SPORTELLA        ", "LastUpdated": "2014-11-11 16:43:28.300" },
{ "BBLE": 3027010033, "Owner_Name1": "D'ADDARIO, RON                     ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:29.897" },
{ "BBLE": 3027060013, "Owner_Name1": "SLESZYNSKI, TOMASZ                 ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:32.317" },
{ "BBLE": 3027070007, "Owner_Name1": "DOHINICLOGUERSIO                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:34.380" },
{ "BBLE": 3027190019, "Owner_Name1": "DE'ANGELIS, FRANK                  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:35.597" },
{ "BBLE": 3027210035, "Owner_Name1": "ORNSTEIN, JUDITH                   ", "Owner_Name2": "ORNSTEIN, MICHAEL                  ", "LastUpdated": "2014-11-11 16:43:32.877" },
{ "BBLE": 3027211022, "Owner_Name1": "SZCZEPANIK, VALERIE                ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:43:33.333" },
{ "BBLE": 3027211024, "Owner_Name1": "ANGO, ABDULKADIR H                 ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:36.770" },
{ "BBLE": 3027211172, "Owner_Name1": "BARONE, JOHN                       ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:37.957" },
{ "BBLE": 3027211172, "Owner_Name1": "BARONE, JOHN                       ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:37.957" },
{ "BBLE": 3027211426, "Owner_Name1": "GREENBLATT, YUVAL                  ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:43:34.723" },
{ "BBLE": 3027221044, "Owner_Name1": "U.S.  BANK NATIONAL ASSOCIATION ET ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:39.160" },
{ "BBLE": 3027260011, "Owner_Name1": "BAYARD PROPERTIES LLC              ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:40.363" },
{ "BBLE": 3027280027, "Owner_Name1": "SYLVESTER SMOLARCZYK               ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:42.770" },
{ "BBLE": 3027320012, "Owner_Name1": "88 RICHARDSON LLC                  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-10-16 23:17:39.063" },
{ "BBLE": 3027450032, "Owner_Name1": "FORTUNATO FRANCESCO                ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:45.177" },
{ "BBLE": 3027470005, "Owner_Name1": "630-632 LORIMER ASSOCIATES, LLC    ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:46.347" },
{ "BBLE": 3027500037, "Owner_Name1": "169 MLS REALTY CORP.               ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:47.613" },
{ "BBLE": 3027521207, "Owner_Name1": "FITZSIMONS, KATE                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:48.800" },
{ "BBLE": 3027530013, "Owner_Name1": "DARIENZO JOHN                      ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:49.990" },
{ "BBLE": 3027530014, "Owner_Name1": "D'ARIENZO, JOAN P                  ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:14:51.160" },
{ "BBLE": 3027540035, "Owner_Name1": "145 CONSELYEA LLC                  ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:43:41.137" },
{ "BBLE": 3027550013, "Owner_Name1": "TAMARV 172 SKILLMAN LLC            ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:21:08.700" },
{ "BBLE": 3027581005, "Owner_Name1": "LAMME, ERIC                        ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:01.790" },
{ "BBLE": 3027590028, "Owner_Name1": "FAWZI Y ALI                        ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:03.680" },
{ "BBLE": 3028271005, "Owner_Name1": "KASIMOV, GILIOM                    ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:29.007" },
{ "BBLE": 3028290017, "Owner_Name1": "GOVAS, APHRODITE                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:30.197" },
{ "BBLE": 3028290017, "Owner_Name1": "GOVAS, APHRODITE                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:30.197" },
{ "BBLE": 3028290017, "Owner_Name1": "GOVAS, APHRODITE                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:30.197" },
{ "BBLE": 3028290017, "Owner_Name1": "GOVAS, APHRODITE                   ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:30.197" },
{ "BBLE": 3028290029, "Owner_Name1": "RLG KINGSLAND LLC                  ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-10 17:38:35.923" },
{ "BBLE": 3028330016, "Owner_Name1": "G.B. KINGSLAND GROUP LLC           ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:32.617" },
{ "BBLE": 3028350021, "Owner_Name1": "KRAMER, KERRY                      ", "Owner_Name2": "KRAMER, MARTA BOTIA                ", "LastUpdated": "2014-11-11 16:46:58.990" },
{ "BBLE": 3028570042, "Owner_Name1": "FROST CONDOMINIUM LLC              ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:36.243" },
{ "BBLE": 3028570051, "Owner_Name1": "CHAVECO, MAREA                     ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:37.430" },
{ "BBLE": 3028750026, "Owner_Name1": "WOODPOINT PLAZA LLC                ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:41.057" },
{ "BBLE": 3028750060, "Owner_Name1": "DIAMANTIS, MIHAILIS                ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:47:02.223" },
{ "BBLE": 3028751017, "Owner_Name1": "SICHEL, MATTHEW J                  ", "Owner_Name2": "CUNNINGHAM, GWENDOLYN R            ", "LastUpdated": "2014-11-11 16:47:02.683" },
{ "BBLE": 3028751017, "Owner_Name1": "SICHEL, MATTHEW J                  ", "Owner_Name2": "CUNNINGHAM, GWENDOLYN R            ", "LastUpdated": "2014-11-11 16:47:02.683" },
{ "BBLE": 3028751017, "Owner_Name1": "SICHEL, MATTHEW J                  ", "Owner_Name2": "CUNNINGHAM, GWENDOLYN R            ", "LastUpdated": "2014-11-11 16:47:02.683" },
{ "BBLE": 3028751017, "Owner_Name1": "SICHEL, MATTHEW J                  ", "Owner_Name2": "CUNNINGHAM, GWENDOLYN R            ", "LastUpdated": "2014-11-11 16:47:02.683" },
{ "BBLE": 3028840009, "Owner_Name1": "SCHER, SIMON E                     ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:47:03.627" },
{ "BBLE": 3028840015, "Owner_Name1": "MORINI, MICHAEL                    ", "Owner_Name2": "                                   ", "LastUpdated": "2014-11-11 16:47:04.083" },
{ "BBLE": 3028931011, "Owner_Name1": "SUAREZ, JEREMY                     ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:43.477" },
{ "BBLE": 3028931011, "Owner_Name1": "SUAREZ, JEREMY                     ", "Owner_Name2": "                                   ", "LastUpdated": "2015-09-12 09:32:43.477" },
{ "BBLE": 3029070068, "Owner_Name1": "11 ORIENT AVENUE, LLC              ", "Owner_Name2": "METROR REALTY, LLC                 ", "LastUpdated": "2015-09-12 09:32:44.650" },
{ "BBLE": 3029070068, "Owner_Name1": "11 ORIENT AVENUE, LLC              ", "Owner_Name2": "METROR REALTY, LLC                 ", "LastUpdated": "2015-09-12 09:32:44.650" }]

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