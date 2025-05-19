/*$File_version=MS4.3.0.05$*/
/************************************************************************************
 procedure name and id   abbhasansphsrchml
 description             SP for Listing the Multiline for Search task
 name of the author      Sridhar Siripuram
 date created            11-Apr-2002
 query file name         abbhasansphsrchml.sql
 modifications history
 modified by
 modified date
 modified purpose
 Divyalekaa					05/06/2014						14H109_SNP_00001
 Amani.P					11 FEB 2016						14H109_REP_00126
 Sweety Ninave				25/07/2017						MHW-151
 Balaji C					21/08/2017						EA-70
 Nithya S					15/12/2023						EPE-74350
************************************************************************************/
Create procedure abbhasansphsrchml
     @accountcodefrom                   fin_accountcode,
     @accountcodeto                     fin_accountcode,
     @analysiscodefrom                  fin_analysiscode,
     @analysiscodeto                    fin_analysiscode,
     @analysisdetails                   fin_subtitle,
     @ctxt_language                     fin_ctxt_language,
     @ctxt_ouinstance                   fin_ctxt_ouinstance,
     @ctxt_service                      fin_ctxt_service,
     @ctxt_user                         fin_ctxt_user,
     @guid                              fin_guid,
     @hidden_control1                   fin_hiddencontrol,
     @hidden_control2                   fin_hiddencontrol,
     @hdncomp							fin_desc255,--14H109_SNP_00001
	 @analysisdesc      				fin_description, --Input   --MHW-151
     @m_errorid                         fin_int output --to return execution status
as
begin

    set nocount on

--BEGIN of Standard code for getting precision type
    declare  @pqty_tmp                  fin_int ,
             @pamt_tmp                  fin_int ,
             @prate_tmp                 fin_int ,
             @perate_tmp                fin_int ,
             @phigh_tmp                 fin_int ,
             @pmed_tmp                  fin_int ,
             @plow_tmp                  fin_int

    exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
             @prate_tmp output, @perate_tmp output, @phigh_tmp output,
             @pmed_tmp output, @plow_tmp output

--END of Standard code for getting precision type


     -- nocount should be switched on to prevent phantom rows
     set nocount on

	declare 	@companycode_tmp		fin_companycode,
			@qry1_tmp				fin_querybuffer,
			@qry2_tmp				fin_querybuffer,
			@execsql_tmp			nvarchar(4000),
			@guid_tmp				fin_guid,
			@analfrom_tmp			fin_analysiscode,
			@analto_tmp			fin_analysiscode,
			@acfrom_tmp			fin_accountcode,
			@acto_tmp				fin_accountcode,
			@csdtfmt_tmp			fin_csdtfmt

     -- @m_errorid should be 0 to indicate success
     select 	@m_errorid 	= 0,
			@qry1_tmp 	= '',
			@qry2_tmp 	= '',
			@execsql_tmp 	= '',
			@guid_tmp 	= newid()

     select @ctxt_service      = ltrim(rtrim(@ctxt_service))
     select @ctxt_user         = ltrim(rtrim(@ctxt_user))
     select @accountcodefrom   = upper(ltrim(rtrim(@accountcodefrom)))
     select @accountcodeto     = upper(ltrim(rtrim(@accountcodeto)))
     select @analysiscodefrom  = upper(ltrim(rtrim(@analysiscodefrom)))
     select @analysiscodeto    = upper(ltrim(rtrim(@analysiscodeto)))
     select @analysisdetails   = ltrim(rtrim(@analysisdetails))
     select @guid              = ltrim(rtrim(@guid))
     select @hidden_control1   = ltrim(rtrim(@hidden_control1))
     select @hidden_control2   = ltrim(rtrim(@hidden_control2))
     select @hdncomp		   = ltrim(rtrim(@hdncomp))	--14H109_SNP_00001
	 Select @analysisdesc      = ltrim(rtrim(@analysisdesc))   --MHW-151

     if @accountcodefrom   = '~#~'             select @accountcodefrom   = null
     if @accountcodeto     = '~#~'             select @accountcodeto     = null
     if @analysiscodefrom  = '~#~'             select @analysiscodefrom  = null
     if @analysiscodeto    = '~#~'             select @analysiscodeto    = null
     if @analysisdetails   = '~#~'             select @analysisdetails   = null
     if @ctxt_language     = -915              select @ctxt_language     = null
     if @ctxt_ouinstance   = -915              select @ctxt_ouinstance   = null
     if @ctxt_service      = '~#~'             select @ctxt_service      = null
     if @ctxt_user         = '~#~'             select @ctxt_user         = null
     if @guid              = '~#~'             select @guid              = null
     if @hidden_control1   = '~#~'             select @hidden_control1   = null
     if @hidden_control2   = '~#~'             select @hidden_control2   = null
     if @hdncomp		   = '~#~'             select @hdncomp		     = null --14H109_SNP_00001
	 IF @analysisdesc	   = '~#~'			   Select @analysisdesc	     = '%'    --MHW-151


	select @analysisdesc = upper(replace(@analysisdesc,'*','%'))+'%'  --MHW-151

	if charindex('*',@accountcodefrom) <> 0
	begin
		exec fin_sp_raise_error	'','','','','ABB', 154, @m_errorid output
		return
	end

	if charindex('*',@accountcodeto) <> 0
	begin
		exec fin_sp_raise_error	'','','','','ABB', 154, @m_errorid output
		return
	end

	if charindex('*',@analysiscodefrom) <> 0
	begin
		exec fin_sp_raise_error	'','','','','ABB', 153, @m_errorid output
		return
	end

	if charindex('*',@analysiscodeto) <> 0
	begin
		exec fin_sp_raise_error	'','','','','ABB', 153, @m_errorid output
		return
	end

	-- Analysiscodefrom code is greater than the Analysiscodeto
	if datalength(isnull(@analysiscodefrom,'')) > 0 and
	   datalength(isnull(@analysiscodeto,'')) > 0
	begin
		if @analysiscodefrom > @analysiscodeto
		begin
			exec fin_sp_raise_error @analysiscodefrom, @analysiscodeto, '','','ABB', 10,@m_errorid output
			return
		end
	end

	-- Accountcodefrom code is greater than the Accountcodeto
	if datalength(isnull(@accountcodefrom,'')) > 0 and
	   datalength(isnull(@accountcodeto,''))   > 0
	begin
		if @accountcodefrom > @accountcodeto
		begin
			exec fin_sp_raise_error @accountcodefrom, @accountcodeto, '','','ABB', 53,@m_errorid output
			return
		end
	end

	-- Getting company code
	select @companycode_tmp = company_code
	from   emod_ou_vw
	where  ou_id 		    = @ctxt_ouinstance
	
	
	---14H109_REP_00126
	
	if @ctxt_service  = 'abbhasansrhsrch'
	begin
	
	if isnull(@hidden_control1,'') <> ''	 
	begin
		select	@companycode_tmp	=	@hidden_control1
	end
	end
	---14H109_REP_00126

	
	/*Code added for 14H109_SNP_00001 begins here*/
	if isnull(@hdncomp,'') <> ''	 
	begin
		select	@companycode_tmp	=	@hdncomp
	end
	/*Code added for 14H109_SNP_00001 ends here*/

	/*Code added for rtrack id : EA-70 starts*/
	if exists	(	select	'x'	from	emod_ou_vw(nolock)
					where	company_code	=	@companycode_tmp
				)	
	begin
		select	@companycode_tmp	=	@companycode_tmp
	end
	else
	begin
		select @companycode_tmp = company_code
		from   emod_ou_vw
		where  ou_id 		    = @ctxt_ouinstance
	end
	/*Code added for rtrack id : EA-70 ends*/
	
	-- getting the from analysis code
	if datalength(isnull(@analysiscodefrom,'')) = 0
		select @analysiscodefrom = null
	else
	begin
		select 	@analfrom_tmp 	= min(analysis_code)
		from		abb_analysis_mst  (nolock)
		where	company_code	= @companycode_tmp
		and		(analysis_code >= @analysiscodefrom + '%'
				 or analysis_code like @analysiscodefrom + '%')

		if datalength(isnull(@analfrom_tmp,'')) <> 0
 			select @analysiscodefrom = @analfrom_tmp
	end


	-- getting the To Analysis code
	if datalength(isnull(@analysiscodeto,'')) = 0
		select @analysiscodeto = null
	else
	begin
		select 	@analto_tmp 	= max(analysis_code)
		from		abb_analysis_mst  (nolock)
		where	company_code	= @companycode_tmp
		and		(analysis_code <= @analysiscodeto + '%'
				 or analysis_code like @analysiscodeto + '%')

		if datalength(isnull(@analto_tmp,'')) <> 0
			select @analysiscodeto = @analto_tmp
	end

	-- getting the from account code
	if datalength(isnull(@accountcodefrom,'')) = 0
		select @accountcodefrom = null
	else
	begin
		select 	@acfrom_tmp 	= min(account_code)
		from		abb_account_analysis_map  (nolock)
		where	company_code	= @companycode_tmp
		and		(account_code >= @accountcodefrom + '%'
				 or account_code like @accountcodefrom + '%')

		if datalength(isnull(@acfrom_tmp,'')) <> 0
 			select @accountcodefrom = @acfrom_tmp
	end

	-- getting the To account code
	if datalength(isnull(@accountcodeto,'')) = 0
		select @accountcodeto = null
	else
	begin
		select 	@acto_tmp 	= max(account_code)
		from		abb_account_analysis_map  (nolock)
		where	company_code	= @companycode_tmp
		and		(account_code <= @accountcodeto + '%'
				 or account_code like @accountcodeto + '%')

		if datalength(isnull(@acto_tmp,'')) <> 0
			select @accountcodeto = @acto_tmp
	end

	-- if Analysiscodefrom is having value and Analysiscodeto is null
	if datalength(isnull(@analysiscodefrom,'')) > 0
	begin
		select @qry1_tmp = @qry1_tmp + ' and (analysis_code >= ''' + @analysiscodefrom + '''' +
						' or analysis_code like ''' + @analysiscodefrom + '%'')'

		select @qry2_tmp = @qry1_tmp
	end

	-- if Analysiscodefrom is null and Analysiscodeto is having value
	if datalength(isnull(@analysiscodeto,'')) > 0
	begin	
		select @qry1_tmp = @qry1_tmp + ' and (analysis_code <= ''' + @analysiscodeto + '''' +
						' or analysis_code like ''' + @analysiscodeto + '%'')'

		select @qry2_tmp = @qry1_tmp
	end

	-- if Accountcodefrom is having value
	if datalength(isnull(@accountcodefrom,'')) > 0
		select @qry1_tmp = @qry1_tmp + ' and (account_code >= ''' + @accountcodefrom + '''' +
						' or account_code like ''' + @accountcodefrom + '%'')'

	-- if Accountcodeto is having value
	if datalength(isnull(@accountcodeto,'')) > 0
		select @qry1_tmp = @qry1_tmp + ' and (account_code <= ''' + @accountcodeto + '''' +
						' or account_code like ''' + @accountcodeto + '%'')'

	select @execsql_tmp = 'insert into abb_account_budget_tmp
					(guid, company_code, account_code, analysis_code, sub_analysis_code)
					select 	''' + @guid_tmp + ''',
					company_code, account_code, analysis_code, sub_analysis_code
				 	from 	abb_account_analysis_map (nolock)
				  	where	company_code	    = ''' + @companycode_tmp + '''
					and		map_status	    = ''A''' + @qry1_tmp
	
	-- executing the dynamic query	
	--SQL injection correction
	--code modified for EPE-74350 starts	
	--exec sp_executesql @execsql_tmp
	exec ES_executesql	@execsql_tmp
	--code modified for EPE-74350 ends
	

	if datalength(isnull(@accountcodefrom,'')) = 0 and
	   datalength(isnull(@accountcodeto,''))   = 0
	begin
		select @execsql_tmp = 'insert into abb_account_budget_tmp
					(guid, company_code, analysis_code, sub_analysis_code)
					select 	''' + @guid_tmp + ''',
					company_code, analysis_code, sub_analysis_code
				 	from 	abb_analysis_subanal_map (nolock)
				  	where	company_code	    = ''' + @companycode_tmp + '''
					and		map_status	    = ''A''' + @qry2_tmp + '
					and		analysis_code not in (select distinct analysis_code
											  from abb_account_budget_tmp (nolock)
											  where guid = ''' + @guid_tmp + ''')'

		-- executing the dynamic query	
		--SQL injection correction
		--code modified for EPE-74350 starts	
		--exec sp_executesql @execsql_tmp
		exec ES_executesql	@execsql_tmp
		--code modified for EPE-74350 ends

		select @execsql_tmp = 'insert into abb_account_budget_tmp
					(guid, company_code, analysis_code)
					select 	''' + @guid_tmp + ''', company_code, analysis_code
				 	from 	abb_analysis_mst (nolock)
				  	where	company_code	    = ''' + @companycode_tmp + '''
					and		status	    	    = ''A''' + @qry2_tmp + '
					and		analysis_code not in (select distinct analysis_code
											  from abb_account_budget_tmp (nolock)
											  where guid = ''' + @guid_tmp + ''')'

		-- executing the dynamic query	
		--SQL injection correction
		--code modified for EPE-74350 starts	
		--exec sp_executesql @execsql_tmp
		exec ES_executesql	@execsql_tmp
		--code modified for EPE-74350 ends
	end

	--Updating the Analysiscode Description
	update	abb_account_budget_tmp
	set		analysis_desc 		= b.analysis_desc,
			effective_date_from = b.effective_date_from,
			effective_date_to	= b.effective_date_to
	from		abb_account_budget_tmp 	a (nolock),
			abb_analysis_mst	 	b (nolock)
	where	a.company_code		= b.company_code
	and 		a.analysis_code	= b.analysis_code
	and 		a.guid 			= @guid_tmp

	--Updating the SubAnalysiscode Description
	update	abb_account_budget_tmp
	set		sub_analysis_desc 	= b.sub_analysis_desc
	from		abb_account_budget_tmp 	a (nolock),
			abb_sub_analysis_mst	b (nolock)
	where	a.company_code 	= b.company_code
	and 		a.sub_analysis_code = b.sub_analysis_code
	and 		a.guid 			= @guid_tmp
	
	-- Get the default Date Formaat
	exec  emod_sysact_spgetdatefmt	@ctxt_ouinstance, @ctxt_user,
								@csdtfmt_tmp output
	
	--Template Select Statement for Selecting data to App Layer
	select 	'ACCOUNTCODEML' 	= account_code,
			'ANALYSISCODE'		= analysis_code,
			'DESCRIPTION'		= analysis_desc,
     		'DESCRIPTION1'		= sub_analysis_desc,	
			'EFFECTIVEDATEFROM'	= dbo.fin_dateinuserformat(effective_date_from, @csdtfmt_tmp),
     		'EFFECTIVEDATETO'	= dbo.fin_dateinuserformat(effective_date_to, @csdtfmt_tmp),
			'SUBANALYSISCODE'	= sub_analysis_code
	from 	abb_account_budget_tmp (nolock)
	where	guid = @guid_tmp
	and     analysis_desc like  @analysisdesc  --MHW-151
	 
	-- Deleting rows from tmp table
	delete from abb_account_budget_tmp
	where  guid = @guid_tmp

     set nocount off

end


