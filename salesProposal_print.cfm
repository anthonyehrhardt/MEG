<cfset spid=val(URL.id)>
<Cfset _width = 8.5>
<cfset _height = 11>
<cfset isDLO = false>

<Cfquery name="report" datasource="greenbox">
    select *, dbo.dateFormatMonthAsString( ProposalDate) as ProposalDateAsString, dbo.dateFormatMonthAsString( expirationDate) as expirationDateAsString 
    from SalesProposals 
    where spid= <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#spid#">
</cfquery>
<Cfquery name="getClientRefs" datasource="greenbox">
    select * 
    from SalesProposals_ClientReferences 
    where Type = 'CR' and  spid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#spid#">
</cfquery>
<Cfquery name="getUser" datasource="greenbox">
    select BusinessUnit from Users where UserID=<Cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#report.repID#">
</cfquery>
<cfif getUser.BusinessUnit EQ "80000">
    <Cfset isDLO = true>
</cfif>
<Cfquery name="getBullets" datasource="greenbox">
    select * 
    from salesProposals_OverviewBullets 
    where spid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#spid#"> 
    order by aid
</cfquery>
<cfquery name="getBulletsHTML" datasource="greenbox">
    SELECT *
    FROM SalesProposals_PrintParsedHTML 
    where spid=<cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#spid#"> 
    order by id
</cfquery>
<cfquery name="ourSolutionQry" datasource="greenbox">
    DECLARE @spID INT = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#spid#"> 

    select dgx_label, dgx_text txt,1 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_1=b.DGX_id
    where spID = @spID

    UNION

    select dgx_label, dgx_text txt,2 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_2=b.DGX_id
    where spID = @spID

    UNION

    select dgx_label, dgx_text txt,3 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_3=b.DGX_id
    where spID = @spID

    UNION

    select dgx_label, dgx_text txt,4 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_4=b.DGX_id
    where spID = @spID

    UNION

    select dgx_label, dgx_text txt,5 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_5=b.DGX_id
    where spID = @spID

    UNION

    select dgx_label, dgx_text txt,6 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_6=b.DGX_id
    where spID = @spID

    UNION
    select dgx_label, dgx_text txt,7 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_7=b.DGX_id
    where spID = @spID

    UNION
    select dgx_label, dgx_text txt,8 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_8=b.DGX_id
    where spID = @spID

    UNION
    select dgx_label, dgx_text txt,9 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_9=b.DGX_id
    where spID = @spID

    UNION
    select dgx_label, dgx_text txt,10 as sort 
    from salesProposals a join salesProposalsDGX  b on a.dgx_id_10=b.DGX_id
    where spID = @spID

    order by sort
</cfquery>
<cfquery name="ourSolutionSubQry" datasource="greenbox">
    SELECT DISTINCT b.dgx_text, b.dgx_label, a.sortOrder, a.dgx_order_id
	FROM salesProposalsDGX_salesProposals_subProposalXREF a
		JOIN salesProposalsDGX b ON a.salesProposalsDGX_id = b.DGX_id
		JOIN salesProposalsDGX c ON b.parentID = c.DGX_id
		JOIN SalesProposals d ON d.spID = a.spID
	WHERE a.spID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#spid#"> 
		AND (
			(d.dgx_id_1 = c.DGX_id AND a.dgx_order_id = 1)
			OR
			(d.dgx_id_2 = c.DGX_id AND a.dgx_order_id = 2)
			OR
			(d.dgx_id_3 = c.DGX_id AND a.dgx_order_id = 3)
			OR
			(d.dgx_id_4 = c.DGX_id AND a.dgx_order_id = 4)
			OR
			(d.dgx_id_5 = c.DGX_id AND a.dgx_order_id = 5)
			OR
			(d.dgx_id_6 = c.DGX_id AND a.dgx_order_id = 6)
			OR
			(d.dgx_id_7 = c.DGX_id AND a.dgx_order_id = 7)
			OR
			(d.dgx_id_8 = c.DGX_id AND a.dgx_order_id = 8)
			OR
			(d.dgx_id_9 = c.DGX_id AND a.dgx_order_id = 9)
			OR
			(d.dgx_id_10 = c.DGX_id AND a.dgx_order_id = 10)
		)
		AND a.isActive = 1
	ORDER BY a.sortorder
</cfquery>

<cfdocument fontDirectory="#ExpandPath('/pdf_fonts')#" orientation="portrait" pagetype="custom" pageheight="#_height#" pagewidth="#_width#" overwrite="yes" marginbottom="0.0" marginleft="0.0" marginright="0.0" margintop="0.0" unit="in" format="PDF" fontembed="true" localurl="false" name="tempPDF">
    <cfdocumentsection><!DOCTYPE html>
        <html>
        <head>
            <style>
                body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:.25in 0 0 0; box-sizing: border-box; color:#63666A; font-family: Arial, Helvetica, sans-serif;}
                img.background {width:<cfoutput>#_width-0.5#</cfoutput>in;display:block; margin-bottom: .5in}
                img.quest-logo {position: absolute; bottom: 0.75in; right: .5in;}
                .header { font-family:Arial, Helvetica, sans-serif; font-size: 14.5pt; color:#C6D52F; margin-top:5px;margin-bottom:.25in;}
                .dateText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt; padding-bottom: .25in;}
                .submittedText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt;}
                .dateText > div {}
                .submittedText > div {}
                .dateText span,
                .submittedText span {font-family: Arial, Helvetica, sans-serif; font-weight:400; color:#C6D52F;}
            </style>
        </head>
        <body>
            <cfif isDLO>
                <img src="/SalesProposals/images/dlo-businessproposal_header.jpg" width="8.5in" class="background" />
            <cfelse>
                <img src="/SalesProposals/images/salesProposal_cov_header.jpg" width="8.5in" class="background" />
            </cfif>
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td width="50">&nbsp;</td>
                    <td width="308">
                        <cfif report.Logo NEQ "" AND (report.LogoOption EQ "LogoOnly" OR report.LogoOption EQ "LCompany")>
                        <div style="height:200px;width:308px;background:red;"><img src="<cfoutput>#ExpandPath('/SalesProposals/logos/')##trim(report.Logo)#</cfoutput>" alt="Company Logo" width="308" height="75" style="max-width: 308px; max-height:75px; width:auto; height: auto; /></div>
                        <cfelseif report.Logo NEQ "" AND (report.LogoOption EQ "LCompany")>
                        <div class="companyName"><cfoutput>#report.Company#</cfoutput></div>
                        </cfif>
                    </td>
                    <td width="70">&nbsp;</td>
                    <td valign="top"> 
                    <!---  12/13/23 ACE Quick edit --->
                      line 161
                        <div class="header">Delivering Value<br/>for your Stuff</div>
                        <cfif report.ProposalDateAsString NEQ ""><div class="dateText"><span>Date:</span> <div><Cfoutput>#report.ProposalDateAsString#</cfoutput></div></div></cfif>
                        <div class="dateText"><span>Submitted to:</span> <div><Cfoutput>#report.ClientContact#<br/>#report.PractiseName#<br/>#report.PractiseAddress#<br/>#report.PractiseCity#, #report.PractiseState# #report.PractiseZip#</cfoutput></div></div>
                        <div class="submittedText"><span>Submitted by:</span> <div>Quest Diagnostics<br/><Cfoutput>#report.repName#<br/>#report.repAddress#<br/>#report.repCity#, #report.repState# #report.repZip#<br/>#report.repPhone#<br/>#report.repEmail#</cfoutput></div></div>
                    </td>
                    <td width="20">&nbsp;</td>
                </tr>
            </table>
        </body>
        </html>
    </cfdocumentsection>
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="padding:0in; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-1.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                </style>
            </head>
            <body>
                <h1>Table of Contents</h1>
                <table cellpadding="0" cellspacing="0" border="0" width="90%">
                    <tbody>
                        <tr>
                            <td width="30">3</td>
                            <td class="bluetext">Your Current Position</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bluetext">Desired Outcome</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bluetext">Our Solution</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bluetext">Implementation Overview</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bluetext">Your Quest Diagnostics Team</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bluetext">Patient Service Center Locations</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bluetext">Experience You Can Count On</td>
                        </tr>
                        <tr>
                            <td></td>
                            <td class="bluetext">Caring For Your Specimen</td>
                        </tr>
                        <cfif report.showNicols EQ True OR report.showNicols EQ 1>
                        <tr>
                            <td></td>
                            <td class="bluetext">Access to Advanced Testing</td>
                        </tr>
                        </cfif>
                        <cfif report.displayQualityYouDeserve EQ True OR report.displayQualityYouDeserve EQ 1>
                        <tr>
                            <td></td>
                            <td class="bluetext">Quality You Deserve</td>
                        </tr>
                        </cfif>
                        <cfif report.displayCertSection EQ True OR report.displayCertSection EQ 1>
                        <tr>
                            <td></td>
                            <td class="bluetext">Certifications and Accreditations line 252</td>
                        </tr>
                        </cfif>
                        <cfif getClientRefs.recordcount GT 0>
                        <tr>
                            <td></td>
                            <td class="bluetext">Local Client References</td>
                        </tr>
                        </cfif>
                        <cfif report.coverSheet_1 EQ True OR report.coverSheet_1 EQ 1 OR report.coverSheet_2 EQ True OR report.coverSheet_2 EQ 1 OR report.coverSheet_3 EQ True OR report.coverSheet_3 EQ 1 OR
                              report.coverSheet_4 EQ True OR report.coverSheet_1 EQ 4 OR report.coverSheet_5 EQ True OR report.coverSheet_5 EQ 1 OR report.coverSheet_6 EQ True OR report.coverSheet_6 EQ 1 OR
                              report.coverSheet_7 EQ True OR report.coverSheet_1 EQ 7>
                        <tr>
                            <td></td>
                            <td class="bluetext">
                                Confidential Pricing Schedules
                                <cfif report.coverSheet_1 EQ True OR report.coverSheet_1 EQ 1><div>LOA Pricing Agreement</div></cfif>
                                <cfif report.coverSheet_2 EQ True OR report.coverSheet_2 EQ 1><div>Care360&reg; Physician Portal Agreement</div></cfif>
                                <cfif report.coverSheet_3 EQ True OR report.coverSheet_3 EQ 1><div>CPU/CPU Interface Agreement</div></cfif>
                                <cfif report.coverSheet_4 EQ True OR report.coverSheet_4 EQ 1><div>TSA Agreements</div></cfif>
                                <cfif report.coverSheet_5 EQ True OR report.coverSheet_5 EQ 1><div>Laboratory Services Agreement</div></cfif>
                                <cfif report.coverSheet_6 EQ True OR report.coverSheet_6 EQ 1><div>Equipment/Line Use Agreement</div></cfif>
                                <cfif report.coverSheet_7 EQ True OR report.coverSheet_7 EQ 1><div>Database Mapping Agreement</div></cfif>
                            </td>
                        </tr>
                        </cfif>
                    </tbody>
                </table>
            </body>
        </html>
    </cfdocumentsection>
    <cfset section="YCP">
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-2.1#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#63666a; font-family: Arial, Helvetica, sans-serif;}
                    * {box-sizing: border-box;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    .grouping {break-inside: avoid;page-break-inside: avoid; width: 85%; position:relative; margin-bottom: .33in;}
                    .grouping div {color: #777777; font-size: 10.5pt; line-height: 13pt; font-family: Arial, Helvetica, sans-serif; font-weight: 100;}
                    .grouping div.hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:-2em;left:0;}
                    .separator {height: 1pt; width: 100%; background-color:#34B233;margin-top:.15in; margin-bottom: .15in;}
                </style>
            </head>
            <body>
                <div class="grouping">
                <div class="hidden">__YCP_SECTION_00001__</div>
                <h1>Your Current Position</h1>
                <cfquery name="ycp_bullets1" dbtype="query">
                    SELECT * FROM getBullets where Type = 'Position1'
                </cfquery>
                <cfloop query="ycp_bullets1">
                    <Cfquery name="getYCPBulletHTML" dbtype="query">
                        SELECT * FROM getBulletsHTML WHERE aid = #ycp_bullets1.aid#
                    </cfquery>
                    <div><cfloop query="getYCPBulletHTML">
                    <cfoutput><span style='<cfif isBold>font-weight:bold; </cfif><cfif isItalic>font-style: italic; </cfif><cfif color NEQ "">color:###color#; </cfif>'>#replacenocase(getYCPBulletHTML.text,"replacemewithalinebreak","<br/><br/>","all")#</span></cfoutput>
                    </cfloop></div>
                </cfloop>
                <div class="separator"></div>
                <cfquery name="ycp_bullets2" dbtype="query">
                    SELECT * FROM getBullets where Type = 'Position2'
                </cfquery>
                <cfloop query="ycp_bullets2">
                    <Cfquery name="getYCPBulletHTML" dbtype="query">
                        SELECT * FROM getBulletsHTML WHERE aid = #ycp_bullets2.aid#
                    </cfquery>
                    <div><cfloop query="getYCPBulletHTML">
                    <cfoutput><span style='<cfif isBold>font-weight:bold; </cfif><cfif isItalic>font-style: italic; </cfif><cfif color NEQ "">color:###color#; </cfif>'>#replacenocase(getYCPBulletHTML.text,"replacemewithalinebreak","<br/><br/>","all")#</span></cfoutput>
                    </cfloop></div>
                </cfloop>
                </div>
                <div class="grouping">
                <cfset section="Desired Outcome">
                <div class="hidden">__DO_SECTION_00002__</div>
                <h1>Desired Outcome</h1>
                <cfquery name="do_bullets" dbtype="query">
                    SELECT * FROM getBullets where Type = 'OPP'
                </cfquery>
                <cfloop query="do_bullets">
                    <Cfquery name="getDOBulletHTML" dbtype="query">
                        SELECT * FROM getBulletsHTML WHERE aid = #do_bullets.aid#
                    </cfquery>
                    <div><cfloop query="getDOBulletHTML">
                    <cfoutput><span style='<cfif isBold>font-weight:bold; </cfif><cfif isItalic>font-style: italic; </cfif><cfif color NEQ "">color:###color#; </cfif>'>#replacenocase(getDOBulletHTML.text,"replacemewithalinebreak","<br/><br/>","all")#</span></cfoutput>
                    </cfloop></div>
                </cfloop>
                </div>
            </body>
        </html>
    </cfdocumentsection>
    <Cfset showCont = false>
    <cfdocumentsection margintop="1.2" marginbottom="1.0" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
            <cfif !showCont><Cfset showCont = true><cfelse><h1 style="position:absolute; top:.9in; left:0; margin: 0; padding: 0in .66in 0 .66in; font-size: 14pt;">Our Solution (cont.)</h1></cfif>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0.5in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-2.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#63666a; font-family: Arial, Helvetica, sans-serif;}
                    * {box-sizing: border-box;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    h2 {margin:0;padding:.25in 0 .05in 0;font-size: 13pt; color:#35792a; font-weight:bold;}
                    div {color: #777777; font-size: 10pt; line-height: 12pt; font-family: Arial, Helvetica, sans-serif; font-weight: 100; margin-bottom: .1in;}
                    div.hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                    div span.sub {display: block; padding-left: .25in; padding-right: 1.25in; break-inside: avoid;page-break-inside: avoid;}
                    div span.sub span.h3 {display: block; margin:0;padding:.25in 0 .05in 0;font-size: 13pt; color:#35792a; font-weight:normal;}
                    div span.sub span {color: #777777; font-size: 10pt; line-height: 12pt; font-family: Arial, Helvetica, sans-serif; font-weight: 100; margin-bottom: .1in;}
                </style>
            </head>
            <body>
                <div class="hidden">__OS_SECTION_00003__</div>
                <h1>Our Solution</h1>
                <div>Since 1967, Quest Diagnostics has committed to assisting physician practices in caring for their patients. Our goal is to help you enhance patient care and streamline operations. In the following proposal, we'll discuss how we can help your practice deliver outstanding patient outcomes, while achieving higher productivity, and identifying the benefits associated with these higher efficiencies.</div>
                <div>To meet your current needs and help you achieve your future objectives, Quest Diagnostics proudly offers the following solution for <cfoutput>#report.PractiseName#</cfoutput>.</div>
                <cfloop query="ourSolutionQry">
                    <cfset section = ourSolutionQry.dgx_label>
                    <h2><cfoutput>#ourSolutionQry.dgx_label#</cfoutput></h2>
                    <div style="padding-right:0.25in;"><cfoutput>#ourSolutionQry.txt#</cfoutput>
                        <cfif ourSolutionSubQry.recordcount GT 0>
                            <Cfquery name="checkSubQry" dbtype="query">
                                SELECT * FROM ourSolutionSubQry WHERE dgx_order_id = #ourSolutionQry.sort# ORDER BY sortOrder
                            </cfquery>
                            <cfloop query="checkSubQry">
                            <cfoutput><span class="sub"><span class="h3">#checkSubQry.dgx_label#</span><span>#checkSubQry.dgx_text#</span></span></cfoutput>
                            </cfloop>
                        </cfif>
                    </div>
                </cfloop>
            </body>
        </html>
    </cfdocumentsection>
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-1.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                    .grouping {break-inside: avoid;page-break-inside: avoid;position:relative;}
                    .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                </style>
            </head>
            <body>
                <div class="hidden">__IO_SECTION_00004__</div>
                <h1>Implementation Overview 12/13/23</h1>
            <!---
            ACE 12-14
            --->
            <!---
            <img src="/SalesProposals/images/salesProposal_step1box.jpg">
            <img src="/SalesProposals/images/salesProposal_step2box.jpg">
            <img src="/SalesProposals/images/salesProposal_step3box.jpg">
            <img src="/SalesProposals/images/salesProposal_step4box.jpg">
            --->
<!--- ACE --->

            </body>
        </html>
        12/14
        <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            height: 100vh;
        }

        img {
            max-width: 100%;
            height: auto;
            margin-bottom: 20px;
        }
    </style>
    <title>Sales Proposal Steps</title>
</head>
<!---<body>
    <img src="/SalesProposals/images/salesProposal_step1box.jpg" alt="Step 1">
    <img src="/SalesProposals/images/salesProposal_step2box.jpg" alt="Step 2">
    <img src="/SalesProposals/images/salesProposal_step3box.jpg" alt="Step 3">
    <img src="/SalesProposals/images/salesProposal_step4box.jpg" alt="Step 4">
</body>--->
</html>
<!-- end -->
    </cfdocumentsection>
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-1.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                    .grouping {break-inside: avoid;page-break-inside: avoid;position:relative;}
                    .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                </style>
            </head>
            <body>
                <div class="hidden">__YQDT_SECTION_00005__</div>
                <h1>Your Quest Diagnostics Team</h1>
            </body>
        </html>
    </cfdocumentsection>
    <!---ACE 12/14 --->
  <cfset text = "Your Quest Diagnostics Team">

<cfdocumentitem type="header">
<cfdocumentsection>
For General Information please contact: 210-435-6198<br>
<u>Your Representative</u><br>
Ted Test<br>
<i>210-435-6199</i><br>
<b>Local Medical Director</b><br>
Mike Ctor<br>
<i>210-435-6200</i> <br>
Client Services<br>
210-435-6203<br>
Information Technology<br>
Ivan Tectap<br>
210-435-6204 <br>
</cfdocumentsection>
</cfdocumentitem>

<!-- Continue with the conversion for the rest of the code -->
  

<!--- ACE--->
<!-- Continue with the conversion for the rest of the code -->

    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-1.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                    .grouping {break-inside: avoid;page-break-inside: avoid;position:relative;}
                    .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                </style>
            </head>
            <body>
                <div class="hidden">__LPSC_SECTION_00006__</div>
                <h1>Local Patient Service Centers</h1>
            </body>
        </html>
    </cfdocumentsection>
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-1.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                    .grouping {break-inside: avoid;page-break-inside: avoid;position:relative;}
                    .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                </style>
            </head>
            <body>
                <div class="hidden">__EYCCO_SECTION_00007__</div>
                <h1>Experience You Can Count On</h1>
            </body>
        </html>
    </cfdocumentsection>
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-1.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                    .grouping {break-inside: avoid;page-break-inside: avoid;position:relative;}
                    .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                </style>
            </head>
            <body>
                <div class="grouping">
                <div class="hidden">__CFYS_SECTION_00008__</div>
                <h1>Caring for your Specimen</h1>
                </div>
                <cfif report.showNicols EQ True OR report.showNicols EQ 1>
                <div class="grouping">
                <div class="hidden">__AAT_SECTION_00009__</div>
                <h1>Access to Advanced Testing</h1>
                </div>
                </cfif>
                <cfif report.displayQualityYouDeserve EQ True OR report.displayQualityYouDeserve EQ 1>
                <div class="grouping">
                <div class="hidden">__QYD_SECTION_000010__</div>
                <h1>Quality You Deserve</h1>
                </div>
                </cfif>
            </body>
        </html>
    </cfdocumentsection>
    <cfif report.displayCertSection EQ True OR report.displayCertSection EQ 1>
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-1.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                    .grouping {break-inside: avoid;page-break-inside: avoid;position:relative;}
                    .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                </style>
            </head>
            <body>
                <div class="hidden">__CAA_SECTION_000011__</div>
                <h1>Certifications and Accreditations</h1>
            </body>
        </html>
    </cfdocumentsection>
    </cfif>
    <cfif getClientRefs.recordcount GT 0>
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="position: absolute; top:0; left:0; padding:.33in 0 0 0; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span><cfoutput>#cfdocument.currentpagenumber#</cfoutput></div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                    .grouping {break-inside: avoid;page-break-inside: avoid;position:relative;}
                    .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                </style>
            </head>
            <body>
                <div class="hidden">__LCR_SECTION_000012__</div>
                <h1>Local Client References</h1>
            </body>
        </html>
    </cfdocumentsection>
    </cfif>
    <cfif report.coverSheet_1 EQ True OR report.coverSheet_1 EQ 1 OR report.coverSheet_2 EQ True OR report.coverSheet_2 EQ 1 OR report.coverSheet_3 EQ True OR report.coverSheet_3 EQ 1 OR
            report.coverSheet_4 EQ True OR report.coverSheet_1 EQ 4 OR report.coverSheet_5 EQ True OR report.coverSheet_5 EQ 1 OR report.coverSheet_6 EQ True OR report.coverSheet_6 EQ 1 OR
            report.coverSheet_7 EQ True OR report.coverSheet_1 EQ 7>
        <cfif report.coverSheet_1 EQ True OR report.coverSheet_1 EQ 1>
            <cfdocumentsection><!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:.25in 0 0 0; box-sizing: border-box; color:#63666A; font-family: Arial, Helvetica, sans-serif;}
                        img.background {width:<cfoutput>#_width-0.5#</cfoutput>in;display:block; margin-bottom: .5in}
                        img.quest-logo {position: absolute; bottom: 0.75in; right: .5in;}
                        .header { font-family:Arial, Helvetica, sans-serif; font-size: 14.5pt; color:#C6D52F; margin-top:5px;margin-bottom:.25in;}
                        .dateText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt; padding-bottom: .25in;}
                        .submittedText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt;}
                        .dateText > div {}
                        .submittedText > div {}
                        .dateText span,
                        .submittedText span {font-family: Arial, Helvetica, sans-serif; font-weight:400; color:#C6D52F;}
                        .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                    </style>
                </head>
                <body>
                    <div class="hidden">__CS1_SECTION_000013__</div>
                    <cfif isDLO>
                        <img src="/SalesProposals/images/dlo-businessproposal_header.jpg" width="8.5in" class="background" />
                    <cfelse>
                        <img src="/SalesProposals/images/salesProposal_cov_header.jpg" width="8.5in" class="background" />
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="50">&nbsp;</td>
                            <td width="308">
                                <cfif report.Logo NEQ "" AND (report.LogoOption EQ "LogoOnly" OR report.LogoOption EQ "LCompany")>
                                <div style="height:200px;width:308px;background:red;"><img src="<cfoutput>#ExpandPath('/SalesProposals/logos/')##trim(report.Logo)#</cfoutput>" alt="Company Logo" width="308" height="75" style="max-width: 308px; max-height:75px; width:auto; height: auto; /></div>
                                <cfelseif report.Logo NEQ "" AND (report.LogoOption EQ "LCompany")>
                                <div class="companyName"><cfoutput>#report.Company#</cfoutput></div>
                                </cfif>
                            </td>
                            <td width="70">&nbsp;</td>
                            <td valign="top">
                                <div class="header">Delivering Value<br/>for your Practice</div>
                                <cfif report.ProposalDateAsString NEQ ""><div class="dateText"><span>Date:</span> <div><Cfoutput>#report.ProposalDateAsString#</cfoutput></div></div></cfif>
                                <div class="dateText"><span>Submitted to:</span> <div><Cfoutput>#report.ClientContact#<br/>#report.PractiseName#<br/>#report.PractiseAddress#<br/>#report.PractiseCity#, #report.PractiseState# #report.PractiseZip#</cfoutput></div></div>
                                <div class="submittedText"><span>Submitted by:</span> <div>Quest Diagnostics<br/><Cfoutput>#report.repName#<br/>#report.repAddress#<br/>#report.repCity#, #report.repState# #report.repZip#<br/>#report.repPhone#<br/>#report.repEmail#</cfoutput></div></div>
                            </td>
                            <td width="20">&nbsp;</td>
                        </tr>
                    </table>
                </body>
                </html>
            </cfdocumentsection>
        </cfif>
        <cfif report.coverSheet_2 EQ True OR report.coverSheet_2 EQ 1>
            <cfdocumentsection><!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:.25in 0 0 0; box-sizing: border-box; color:#63666A; font-family: Arial, Helvetica, sans-serif;}
                        img.background {width:<cfoutput>#_width-0.5#</cfoutput>in;display:block; margin-bottom: .5in}
                        img.quest-logo {position: absolute; bottom: 0.75in; right: .5in;}
                        .header { font-family:Arial, Helvetica, sans-serif; font-size: 14.5pt; color:#C6D52F; margin-top:5px;margin-bottom:.25in;}
                        .dateText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt; padding-bottom: .25in;}
                        .submittedText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt;}
                        .dateText > div {}
                        .submittedText > div {}
                        .dateText span,
                        .submittedText span {font-family: Arial, Helvetica, sans-serif; font-weight:400; color:#C6D52F;}
                        .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                    </style>
                </head>
                <body>
                    <div class="hidden">__CS2_SECTION_000014__</div>
                    <cfif isDLO>
                        <img src="/SalesProposals/images/dlo-businessproposal_header.jpg" width="8.5in" class="background" />
                    <cfelse>
                        <img src="/SalesProposals/images/salesProposal_cov_header.jpg" width="8.5in" class="background" />
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="50">&nbsp;</td>
                            <td width="308">
                                <cfif report.Logo NEQ "" AND (report.LogoOption EQ "LogoOnly" OR report.LogoOption EQ "LCompany")>
                                <div style="height:200px;width:308px;background:red;"><img src="<cfoutput>#ExpandPath('/SalesProposals/logos/')##trim(report.Logo)#</cfoutput>" alt="Company Logo" width="308" height="75" style="max-width: 308px; max-height:75px; width:auto; height: auto; /></div>
                                <cfelseif report.Logo NEQ "" AND (report.LogoOption EQ "LCompany")>
                                <div class="companyName"><cfoutput>#report.Company#</cfoutput></div>
                                </cfif>
                            </td>
                            <td width="70">&nbsp;</td>
                            <td valign="top">
                                <div class="header">Delivering Value<br/>for your Practice</div>
                                <cfif report.ProposalDateAsString NEQ ""><div class="dateText"><span>Date:</span> <div><Cfoutput>#report.ProposalDateAsString#</cfoutput></div></div></cfif>
                                <div class="dateText"><span>Submitted to:</span> <div><Cfoutput>#report.ClientContact#<br/>#report.PractiseName#<br/>#report.PractiseAddress#<br/>#report.PractiseCity#, #report.PractiseState# #report.PractiseZip#</cfoutput></div></div>
                                <div class="submittedText"><span>Submitted by:</span> <div>Quest Diagnostics<br/><Cfoutput>#report.repName#<br/>#report.repAddress#<br/>#report.repCity#, #report.repState# #report.repZip#<br/>#report.repPhone#<br/>#report.repEmail#</cfoutput></div></div>
                            </td>
                            <td width="20">&nbsp;</td>
                        </tr>
                    </table>
                </body>
                </html>
            </cfdocumentsection>
        </cfif>
        <cfif report.coverSheet_3 EQ True OR report.coverSheet_3 EQ 1>
            <cfdocumentsection><!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:.25in 0 0 0; box-sizing: border-box; color:#63666A; font-family: Arial, Helvetica, sans-serif;}
                        img.background {width:<cfoutput>#_width-0.5#</cfoutput>in;display:block; margin-bottom: .5in}
                        img.quest-logo {position: absolute; bottom: 0.75in; right: .5in;}
                        .header { font-family:Arial, Helvetica, sans-serif; font-size: 14.5pt; color:#C6D52F; margin-top:5px;margin-bottom:.25in;}
                        .dateText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt; padding-bottom: .25in;}
                        .submittedText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt;}
                        .dateText > div {}
                        .submittedText > div {}
                        .dateText span,
                        .submittedText span {font-family: Arial, Helvetica, sans-serif; font-weight:400; color:#C6D52F;}
                        .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                    </style>
                </head>
                <body>
                    <div class="hidden">__CS3_SECTION_000015__</div>
                    <cfif isDLO>
                        <img src="/SalesProposals/images/dlo-businessproposal_header.jpg" width="8.5in" class="background" />
                    <cfelse>
                        <img src="/SalesProposals/images/salesProposal_cov_header.jpg" width="8.5in" class="background" />
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="50">&nbsp;</td>
                            <td width="308">
                                <cfif report.Logo NEQ "" AND (report.LogoOption EQ "LogoOnly" OR report.LogoOption EQ "LCompany")>
                                <div style="height:200px;width:308px;background:red;"><img src="<cfoutput>#ExpandPath('/SalesProposals/logos/')##trim(report.Logo)#</cfoutput>" alt="Company Logo" width="308" height="75" style="max-width: 308px; max-height:75px; width:auto; height: auto; /></div>
                                <cfelseif report.Logo NEQ "" AND (report.LogoOption EQ "LCompany")>
                                <div class="companyName"><cfoutput>#report.Company#</cfoutput></div>
                                </cfif>
                            </td>
                            <td width="70">&nbsp;</td>
                            <td valign="top">
                                <div class="header">Delivering Value<br/>for your Practice</div>
                                <cfif report.ProposalDateAsString NEQ ""><div class="dateText"><span>Date:</span> <div><Cfoutput>#report.ProposalDateAsString#</cfoutput></div></div></cfif>
                                <div class="dateText"><span>Submitted to:</span> <div><Cfoutput>#report.ClientContact#<br/>#report.PractiseName#<br/>#report.PractiseAddress#<br/>#report.PractiseCity#, #report.PractiseState# #report.PractiseZip#</cfoutput></div></div>
                                <div class="submittedText"><span>Submitted by:</span> <div>Quest Diagnostics<br/><Cfoutput>#report.repName#<br/>#report.repAddress#<br/>#report.repCity#, #report.repState# #report.repZip#<br/>#report.repPhone#<br/>#report.repEmail#</cfoutput></div></div>
                            </td>
                            <td width="20">&nbsp;</td>
                        </tr>
                    </table>
                </body>
                </html>
            </cfdocumentsection>
        </cfif>
        <cfif report.coverSheet_4 EQ True OR report.coverSheet_4 EQ 1>
            <cfdocumentsection><!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:.25in 0 0 0; box-sizing: border-box; color:#63666A; font-family: Arial, Helvetica, sans-serif;}
                        img.background {width:<cfoutput>#_width-0.5#</cfoutput>in;display:block; margin-bottom: .5in}
                        img.quest-logo {position: absolute; bottom: 0.75in; right: .5in;}
                        .header { font-family:Arial, Helvetica, sans-serif; font-size: 14.5pt; color:#C6D52F; margin-top:5px;margin-bottom:.25in;}
                        .dateText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt; padding-bottom: .25in;}
                        .submittedText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt;}
                        .dateText > div {}
                        .submittedText > div {}
                        .dateText span,
                        .submittedText span {font-family: Arial, Helvetica, sans-serif; font-weight:400; color:#C6D52F;}
                        .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                    </style>
                </head>
                <body>
                    <div class="hidden">__CS4_SECTION_000016__</div>
                    <cfif isDLO>
                        <img src="/SalesProposals/images/dlo-businessproposal_header.jpg" width="8.5in" class="background" />
                    <cfelse>
                        <img src="/SalesProposals/images/salesProposal_cov_header.jpg" width="8.5in" class="background" />
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="50">&nbsp;</td>
                            <td width="308">
                                <cfif report.Logo NEQ "" AND (report.LogoOption EQ "LogoOnly" OR report.LogoOption EQ "LCompany")>
                                <div style="height:200px;width:308px;background:red;"><img src="<cfoutput>#ExpandPath('/SalesProposals/logos/')##trim(report.Logo)#</cfoutput>" alt="Company Logo" width="308" height="75" style="max-width: 308px; max-height:75px; width:auto; height: auto; /></div>
                                <cfelseif report.Logo NEQ "" AND (report.LogoOption EQ "LCompany")>
                                <div class="companyName"><cfoutput>#report.Company#</cfoutput></div>
                                </cfif>
                            </td>
                            <td width="70">&nbsp;</td>
                            <td valign="top">
                                <div class="header">Delivering Value<br/>for your Practice</div>
                                <cfif report.ProposalDateAsString NEQ ""><div class="dateText"><span>Date:</span> <div><Cfoutput>#report.ProposalDateAsString#</cfoutput></div></div></cfif>
                                <div class="dateText"><span>Submitted to:</span> <div><Cfoutput>#report.ClientContact#<br/>#report.PractiseName#<br/>#report.PractiseAddress#<br/>#report.PractiseCity#, #report.PractiseState# #report.PractiseZip#</cfoutput></div></div>
                                <div class="submittedText"><span>Submitted by:</span> <div>Quest Diagnostics<br/><Cfoutput>#report.repName#<br/>#report.repAddress#<br/>#report.repCity#, #report.repState# #report.repZip#<br/>#report.repPhone#<br/>#report.repEmail#</cfoutput></div></div>
                            </td>
                            <td width="20">&nbsp;</td>
                        </tr>
                    </table>
                </body>
                </html>
            </cfdocumentsection>
        </cfif>
        <cfif report.coverSheet_5 EQ True OR report.coverSheet_5 EQ 1>
            <cfdocumentsection><!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:.25in 0 0 0; box-sizing: border-box; color:#63666A; font-family: Arial, Helvetica, sans-serif;}
                        img.background {width:<cfoutput>#_width-0.5#</cfoutput>in;display:block; margin-bottom: .5in}
                        img.quest-logo {position: absolute; bottom: 0.75in; right: .5in;}
                        .header { font-family:Arial, Helvetica, sans-serif; font-size: 14.5pt; color:#C6D52F; margin-top:5px;margin-bottom:.25in;}
                        .dateText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt; padding-bottom: .25in;}
                        .submittedText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt;}
                        .dateText > div {}
                        .submittedText > div {}
                        .dateText span,
                        .submittedText span {font-family: Arial, Helvetica, sans-serif; font-weight:400; color:#C6D52F;}
                        .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                    </style>
                </head>
                <body>
                    <div class="hidden">__CS5_SECTION_000017__</div>
                    <cfif isDLO>
                        <img src="/SalesProposals/images/dlo-businessproposal_header.jpg" width="8.5in" class="background" />
                    <cfelse>
                        <img src="/SalesProposals/images/salesProposal_cov_header.jpg" width="8.5in" class="background" />
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="50">&nbsp;</td>
                            <td width="308">
                                <cfif report.Logo NEQ "" AND (report.LogoOption EQ "LogoOnly" OR report.LogoOption EQ "LCompany")>
                                <div style="height:200px;width:308px;background:red;"><img src="<cfoutput>#ExpandPath('/SalesProposals/logos/')##trim(report.Logo)#</cfoutput>" alt="Company Logo" width="308" height="75" style="max-width: 308px; max-height:75px; width:auto; height: auto; /></div>
                                <cfelseif report.Logo NEQ "" AND (report.LogoOption EQ "LCompany")>
                                <div class="companyName"><cfoutput>#report.Company#</cfoutput></div>
                                </cfif>
                            </td>
                            <td width="70">&nbsp;</td>
                            <td valign="top">
                                <div class="header">Delivering Value<br/>for your Practice</div>
                                <cfif report.ProposalDateAsString NEQ ""><div class="dateText"><span>Date:</span> <div><Cfoutput>#report.ProposalDateAsString#</cfoutput></div></div></cfif>
                                <div class="dateText"><span>Submitted to:</span> <div><Cfoutput>#report.ClientContact#<br/>#report.PractiseName#<br/>#report.PractiseAddress#<br/>#report.PractiseCity#, #report.PractiseState# #report.PractiseZip#</cfoutput></div></div>
                                <div class="submittedText"><span>Submitted by:</span> <div>Quest Diagnostics<br/><Cfoutput>#report.repName#<br/>#report.repAddress#<br/>#report.repCity#, #report.repState# #report.repZip#<br/>#report.repPhone#<br/>#report.repEmail#</cfoutput></div></div>
                            </td>
                            <td width="20">&nbsp;</td>
                        </tr>
                    </table>
                </body>
                </html>
            </cfdocumentsection>
        </cfif>
        <cfif report.coverSheet_6 EQ True OR report.coverSheet_6 EQ 1>
            <cfdocumentsection><!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:.25in 0 0 0; box-sizing: border-box; color:#63666A; font-family: Arial, Helvetica, sans-serif;}
                        img.background {width:<cfoutput>#_width-0.5#</cfoutput>in;display:block; margin-bottom: .5in}
                        img.quest-logo {position: absolute; bottom: 0.75in; right: .5in;}
                        .header { font-family:Arial, Helvetica, sans-serif; font-size: 14.5pt; color:#C6D52F; margin-top:5px;margin-bottom:.25in;}
                        .dateText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt; padding-bottom: .25in;}
                        .submittedText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt;}
                        .dateText > div {}
                        .submittedText > div {}
                        .dateText span,
                        .submittedText span {font-family: Arial, Helvetica, sans-serif; font-weight:400; color:#C6D52F;}
                        .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                    </style>
                </head>
                <body>
                    <div class="hidden">__CS6_SECTION_000018__</div>
                    <cfif isDLO>
                        <img src="/SalesProposals/images/dlo-businessproposal_header.jpg" width="8.5in" class="background" />
                    <cfelse>
                        <img src="/SalesProposals/images/salesProposal_cov_header.jpg" width="8.5in" class="background" />
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="50">&nbsp;</td>
                            <td width="308">
                                <cfif report.Logo NEQ "" AND (report.LogoOption EQ "LogoOnly" OR report.LogoOption EQ "LCompany")>
                                <div style="height:200px;width:308px;background:red;"><img src="<cfoutput>#ExpandPath('/SalesProposals/logos/')##trim(report.Logo)#</cfoutput>" alt="Company Logo" width="308" height="75" style="max-width: 308px; max-height:75px; width:auto; height: auto; /></div>
                                <cfelseif report.Logo NEQ "" AND (report.LogoOption EQ "LCompany")>
                                <div class="companyName"><cfoutput>#report.Company#</cfoutput></div>
                                </cfif>
                            </td>
                            <td width="70">&nbsp;</td>
                            <td valign="top">
                                <div class="header">Delivering Value<br/>for your Practice</div>
                                <cfif report.ProposalDateAsString NEQ ""><div class="dateText"><span>Date:</span> <div><Cfoutput>#report.ProposalDateAsString#</cfoutput></div></div></cfif>
                                <div class="dateText"><span>Submitted to:</span> <div><Cfoutput>#report.ClientContact#<br/>#report.PractiseName#<br/>#report.PractiseAddress#<br/>#report.PractiseCity#, #report.PractiseState# #report.PractiseZip#</cfoutput></div></div>
                                <div class="submittedText"><span>Submitted by:</span> <div>Quest Diagnostics<br/><Cfoutput>#report.repName#<br/>#report.repAddress#<br/>#report.repCity#, #report.repState# #report.repZip#<br/>#report.repPhone#<br/>#report.repEmail#</cfoutput></div></div>
                            </td>
                            <td width="20">&nbsp;</td>
                        </tr>
                    </table>
                </body>
                </html>
            </cfdocumentsection>
        </cfif>
        <cfif report.coverSheet_7 EQ True OR report.coverSheet_7 EQ 1>
            <cfdocumentsection><!DOCTYPE html>
                <html>
                <head>
                    <style>
                        body {height:<cfoutput>#_height#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:.25in 0 0 0; box-sizing: border-box; color:#63666A; font-family: Arial, Helvetica, sans-serif;}
                        img.background {width:<cfoutput>#_width-0.5#</cfoutput>in;display:block; margin-bottom: .5in}
                        img.quest-logo {position: absolute; bottom: 0.75in; right: .5in;}
                        .header { font-family:Arial, Helvetica, sans-serif; font-size: 14.5pt; color:#C6D52F; margin-top:5px;margin-bottom:.25in;}
                        .dateText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt; padding-bottom: .25in;}
                        .submittedText {font-family:Arial, Helvetica, sans-serif; font-size: 10pt;}
                        .dateText > div {}
                        .submittedText > div {}
                        .dateText span,
                        .submittedText span {font-family: Arial, Helvetica, sans-serif; font-weight:400; color:#C6D52F;}
                        .hidden {overflow:hidden;width:20%;display:block;position:absolute; font-size:1pt; color:white;top:0;left:0;}
                    </style>
                </head>
                <body>
                    <div class="hidden">__CS7_SECTION_000019__</div>
                    <cfif isDLO>
                        <img src="/SalesProposals/images/dlo-businessproposal_header.jpg" width="8.5in" class="background" />
                    <cfelse>
                        <img src="/SalesProposals/images/salesProposal_cov_header.jpg" width="8.5in" class="background" />
                    </cfif>
                    <table width="100%" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td width="50">&nbsp;</td>
                            <td width="308">
                                <cfif report.Logo NEQ "" AND (report.LogoOption EQ "LogoOnly" OR report.LogoOption EQ "LCompany")>
                                <div style="height:200px;width:308px;background:red;"><img src="<cfoutput>#ExpandPath('/SalesProposals/logos/')##trim(report.Logo)#</cfoutput>" alt="Company Logo" width="308" height="75" style="max-width: 308px; max-height:75px; width:auto; height: auto; /></div>
                                <cfelseif report.Logo NEQ "" AND (report.LogoOption EQ "LCompany")>
                                <div class="companyName"><cfoutput>#report.Company#</cfoutput></div>
                                </cfif>
                            </td>
                            <td width="70">&nbsp;</td>
                            <td valign="top">
                                <div class="header">Delivering Value<br/>for your Practice</div>
                                <cfif report.ProposalDateAsString NEQ ""><div class="dateText"><span>Date:</span> <div><Cfoutput>#report.ProposalDateAsString#</cfoutput></div></div></cfif>
                                <div class="dateText"><span>Submitted to:</span> <div><Cfoutput>#report.ClientContact#<br/>#report.PractiseName#<br/>#report.PractiseAddress#<br/>#report.PractiseCity#, #report.PractiseState# #report.PractiseZip#</cfoutput></div></div>
                                <div class="submittedText"><span>Submitted by:</span> <div>Quest Diagnostics<br/><Cfoutput>#report.repName#<br/>#report.repAddress#<br/>#report.repCity#, #report.repState# #report.repZip#<br/>#report.repPhone#<br/>#report.repEmail#</cfoutput></div></div>
                            </td>
                            <td width="20">&nbsp;</td>
                        </tr>
                    </table>
                </body>
                </html>
            </cfdocumentsection>
        </cfif>
    </cfif>
</cfdocument>

<CFSET _desiredOutcome = -1>
<CFSET _ourSolution = -1>
<CFSET _implementationOverview = -1>
<CFSET _yourQDTeam = -1>
<CFSET _PSCLocations = -1>
<CFSET _experience = -1>
<CFSET _specimen = -1>
<CFSET _advancedTesting = -1>
<CFSET _quality = -1>
<CFSET _certifications = -1>
<CFSET _localreferences= -1>
<CFSET _confidential = -1>

<Cfpdf action="getInfo" source="tempPDF" name="tempPDFInfo">

<cfloop from="3" to="#tempPDFInfo.TotalPages#" index="p">
    <Cfpdf action="extractText" source="tempPDF" name="pageText" type="xml" pages="#p#">
    <Cfif findnocase("__DO_SECTION_00002__",pageText) NEQ 0 AND _desiredOutcome LT 0>
        <cfset _desiredOutcome = p>
    </cfif>
    <Cfif findnocase("__OS_SECTION_00003__",pageText) NEQ 0 AND _ourSolution LT 0>
        <cfset _ourSolution = p>
    </cfif>
    <Cfif findnocase("__IO_SECTION_00004__",pageText) NEQ 0 AND _implementationOverview LT 0>
        <cfset _implementationOverview = p>
    </cfif>
    <Cfif findnocase("__YQDT_SECTION_00005__",pageText) NEQ 0 AND _yourQDTeam LT 0>
        <cfset _yourQDTeam = p>
    </cfif>
    <Cfif findnocase("__LPSC_SECTION_00006__",pageText) NEQ 0 AND _PSCLocations LT 0>
        <cfset _PSCLocations = p>
    </cfif>
    <Cfif findnocase("__EYCCO_SECTION_00007__",pageText) NEQ 0 AND _experience LT 0>
        <cfset _experience = p>
    </cfif>
    <Cfif findnocase("__CFYS_SECTION_00008__",pageText) NEQ 0 AND _specimen LT 0>
        <cfset _specimen = p>
    </cfif>
    <Cfif findnocase("__AAT_SECTION_00009__",pageText) NEQ 0 AND _advancedTesting LT 0>
        <cfset _advancedTesting = p>
    </cfif>
    <Cfif findnocase("__QYD_SECTION_000010__",pageText) NEQ 0 AND _quality LT 0>
        <cfset _quality = p>
    </cfif>
    <Cfif findnocase("__CAA_SECTION_000011__",pageText) NEQ 0 AND _certifications LT 0>
        <cfset _certifications = p>
    </cfif>
    <Cfif findnocase("__LCR_SECTION_000012__",pageText) NEQ 0 AND _localreferences LT 0>
        <cfset _localreferences = p>
    </cfif>
    <Cfif findnocase("__CS1_SECTION_000013__",pageText) NEQ 0 AND _confidential LT 0>
        <cfset _confidential = p>
    </cfif>
    <Cfif findnocase("__CS2_SECTION_000014__",pageText) NEQ 0 AND _confidential LT 0>
        <cfset _confidential = p>
    </cfif>
    <Cfif findnocase("__CS3_SECTION_000015__",pageText) NEQ 0 AND _confidential LT 0>
        <cfset _confidential = p>
    </cfif>
    <Cfif findnocase("__CS4_SECTION_000016__",pageText) NEQ 0 AND _confidential LT 0>
        <cfset _confidential = p>
    </cfif>
    <Cfif findnocase("__CS5_SECTION_000017__",pageText) NEQ 0 AND _confidential LT 0>
        <cfset _confidential = p>
    </cfif>
    <Cfif findnocase("__CS6_SECTION_000018__",pageText) NEQ 0 AND _confidential LT 0>
        <cfset _confidential = p>
    </cfif>
    <Cfif findnocase("__CS7_SECTION_000019__",pageText) NEQ 0 AND _confidential LT 0>
        <cfset _confidential = p>
    </cfif>
</cfloop>

<cfdocument fontDirectory="#ExpandPath('/pdf_fonts')#" orientation="portrait" pagetype="custom" pageheight="#_height#" pagewidth="#_width#" overwrite="yes" marginbottom="0.0" marginleft="0.0" marginright="0.0" margintop="0.0" unit="in" format="PDF" fontembed="true" localurl="false" name="tempTOC">
    <cfdocumentsection margintop="1.2" marginbottom="0.50" marginleft="0" marginright="0">
        <cfdocumentitem type="header" evalAtPrint="true">
            <div style="padding:0in; width:<cfoutput>#_width#</cfoutput>in; overflow:hidden;">
                <cfif isDLO>
                    <img src="/SalesProposals/images/dlo-busproposal-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                <cfelse>
                    <img src="/SalesProposals/images/Business-Proposal-Rebranding-Dot-Border.png" width="100%" height="auto" style="display:block; width:100%; height: auto" />
                </cfif>
            </div>
        </cfdocumentitem>
        <cfdocumentitem type="footer" evalAtPrint="true">
            <div style="padding:0in 0.5in 0 .66in; width:<cfoutput>#_width-0#</cfoutput>in; font-size: 8pt; color:#4D4F53; box-sizing: border-box;">
                <div style="float:left; font-size: 10pt;">CONFIDENTIAL</div>
                <div style="float:right;"><span style="color:#35792A; padding-right: 0.15in;"><cfoutput>#report.PractiseName#</cfoutput> Business Proposal</span>2</div>
            </div>
        </cfdocumentitem>
        <!DOCTYPE html>
        <html>
            <head>
                <style>
                    body {height:<cfoutput>#_height-1.7#</cfoutput>in; width: <cfoutput>#_width#</cfoutput>in; margin:0;padding:0 .66in; box-sizing: border-box; color:#4D4F53; font-family: Arial, Helvetica, sans-serif;}
                    h1 {margin:0;padding:0 0 .25in 0;font-size: 18pt; color:#00587c; font-weight:normal;}
                    table {padding-left:5px;}
                    table tr td {padding-bottom: .22in; font-size: 11pt; vertical-align: top;}
                    table tr td.bluetext {color: #8DA4BB; font-weight: 600;}
                    table tr td.bluetext div {color:#4D4F53; font-weight: normal; padding-top: .1in;}
                    sup {line-height:0;font-size: .66em; top:0;margin-left:-4px;}
                </style>
            </head>
            <body>
                <h1>Table of Contents</h1>
                <table cellpadding="0" cellspacing="0" border="0" width="90%">
                    <tbody>
                        <tr>
                            <td width="30">3</td>
                            <td class="bluetext">Your Current Position</td>
                        </tr>
                        <tr>
                            <td><cfoutput>#_desiredOutcome#</cfoutput></td>
                            <td class="bluetext">Desired Outcome</td>
                        </tr>
                        <tr>
                            <td><cfoutput>#_ourSolution#</cfoutput></td>
                            <td class="bluetext">Our Solution</td>
                        </tr>
                        <tr>
                            <td><cfoutput>#_implementationOverview#</cfoutput></td>
                            <td class="bluetext">Implementation Overview</td>
                        </tr>
                        <tr>
                            <td><cfoutput>#_yourQDTeam#</cfoutput></td>
                            <td class="bluetext">Your Quest Diagnostics Team</td>
                        </tr>
                        <tr>
                            <td><cfoutput>#_PSCLocations#</cfoutput></td>
                            <td class="bluetext">Patient Service Center Locations</td>
                        </tr>
                        <tr>
                            <td><cfoutput>#_experience#</cfoutput></td>
                            <td class="bluetext">Experience You Can Count On</td>
                        </tr>
                        <tr>
                            <td><cfoutput>#_specimen#</cfoutput></td>
                            <td class="bluetext">Caring For Your Specimen</td>
                        </tr>
                        <cfif report.showNicols EQ True OR report.showNicols EQ 1>
                        <tr>
                            <td><cfoutput>#_advancedTesting#</cfoutput></td>
                            <td class="bluetext">Access to Advanced Testing</td>
                        </tr>
                        </cfif>
                        <cfif report.displayQualityYouDeserve EQ True OR report.displayQualityYouDeserve EQ 1>
                        <tr>
                            <td><cfoutput>#_quality#</cfoutput></td>
                            <td class="bluetext">Quality You Deserve</td>
                        </tr>
                        </cfif>
                        <cfif report.displayCertSection EQ True OR report.displayCertSection EQ 1>
                        <tr>
                            <td><cfoutput>#_certifications#</cfoutput></td>
                            <td class="bluetext">Certifications and Accreditations</td>
                        </tr>
                        </cfif>
                        <cfif getClientRefs.recordcount GT 0>
                        <tr>
                            <td><cfoutput>#_localreferences#</cfoutput></td>
                            <td class="bluetext">Local Client References</td>
                        </tr>
                        </cfif>
                        <cfif report.coverSheet_1 EQ True OR report.coverSheet_1 EQ 1 OR report.coverSheet_2 EQ True OR report.coverSheet_2 EQ 1 OR report.coverSheet_3 EQ True OR report.coverSheet_3 EQ 1 OR
                              report.coverSheet_4 EQ True OR report.coverSheet_1 EQ 4 OR report.coverSheet_5 EQ True OR report.coverSheet_5 EQ 1 OR report.coverSheet_6 EQ True OR report.coverSheet_6 EQ 1 OR
                              report.coverSheet_7 EQ True OR report.coverSheet_1 EQ 7>
                        <tr>
                            <td><cfoutput>#_confidential#</cfoutput></td>
                            <td class="bluetext">
                                Confidential Pricing Schedules
                                <cfif report.coverSheet_1 EQ True OR report.coverSheet_1 EQ 1><div>LOA Pricing Agreement</div></cfif>
                                <cfif report.coverSheet_2 EQ True OR report.coverSheet_2 EQ 1><div>Care360<sup>&reg;</sup> Physician Portal Agreement</div></cfif>
                                <cfif report.coverSheet_3 EQ True OR report.coverSheet_3 EQ 1><div>CPU/CPU Interface Agreement</div></cfif>
                                <cfif report.coverSheet_4 EQ True OR report.coverSheet_4 EQ 1><div>TSA Agreements</div></cfif>
                                <cfif report.coverSheet_5 EQ True OR report.coverSheet_5 EQ 1><div>Laboratory Services Agreement</div></cfif>
                                <cfif report.coverSheet_6 EQ True OR report.coverSheet_6 EQ 1><div>Equipment/Line Use Agreement</div></cfif>
                                <cfif report.coverSheet_7 EQ True OR report.coverSheet_7 EQ 1><div>Database Mapping Agreement</div></cfif>
                            </td>
                        </tr>
                        </cfif>
                    </tbody>
                </table>
            </body>
        </html>
    </cfdocumentsection>
</cfdocument>

<Cfpdf action="merge" name="resultPDF">
    <cfpdfparam source="tempPDF" pages="1">
    <cfpdfparam source="tempTOC" pages="1">
    <cfpdfparam source="tempPDF" pages="3-99">
</cfpdf>

<cfcontent type="application/pdf" variable="#toBinary(resultPDF)#" />