/*$File_version=MS4.3.0.01$*/
/***********************************************************************************
 procedure name and id   abbeanspasrchaml
 description             SP for Listing Multiline in Search task of
						Edit Analysis Code
 name of the author      Sridhar Siripuram
 date created            16-Mar-2002
 query file name         abbeanspasrchaml.sql
 modifications history
 modified by
 modified date
 modified purpose
 /*Nithya S		15-12-2023			EPE-74350				 */
***********************************************************************************/
create procedure  abbeanspasrchaml
     @analysiscodefrom                  fin_analysiscode,
     @analysiscodeto                    fin_analysiscode,
     @ctxt_language                     fin_ctxt_language,
     @ctxt_ouinstance                   fin_ctxt_ouinstance,
     @ctxt_service                      fin_ctxt_service,
     @ctxt_user                         fin_ctxt_user,
     @description                       fin_itemdesc,
     @effectivedatefrom                 datetime,
     @effectivedateto                   datetime,
     @guid                              fin_guid,
     @hidden_control1                   fin_hiddencontrol,
     @hidden_control2                   fin_hiddencontrol,
     @m_errorid                         int output --to return execution status
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

	declare 	@companycode_tmp 			fin_companycode,
			@qry1_tmp 				fin_querybuffer,
			@execqry_tmp				nvarchar(3000),
			@guid_tmp					fin_guid,
			@analysiscodefrom_tmp		fin_analysiscode,
			@analysiscodeto_tmp			fin_analysiscode,
			@csdtfmt_tmp				fin_csdtfmt 
			--@chrind_tmp				fin_int   --code commented for SCA Rule while deploying SQL Injectin fixes

     -- @m_errorid should be 0 to indicate success
     select @m_errorid = 0, @qry1_tmp = ' ', @execqry_tmp = ' '

     select @analysiscodefrom   = upper(ltrim(rtrim(@analysiscodefrom)))
     select @analysiscodeto     = upper(ltrim(rtrim(@analysiscodeto)))
     select @ctxt_service       = upper(ltrim(rtrim(@ctxt_service)))
     select @ctxt_user          = upper(ltrim(rtrim(@ctxt_user)))
     select @description        = ltrim(rtrim(@description))
     select @guid               = ltrim(rtrim(@guid))
     select @hidden_control1    = ltrim(rtrim(@hidden_control1))
     select @hidden_control2    = ltrim(rtrim(@hidden_control2))

     if @analysiscodefrom   = '~#~'             select @analysiscodefrom   = null
     if @analysiscodeto     = '~#~'             select @analysiscodeto     = null
     if @ctxt_language      = -915              select @ctxt_language      = null
     if @ctxt_ouinstance    = -915              select @ctxt_ouinstance    = null
     if @ctxt_service       = '~#~'             select @ctxt_service       = null
     if @ctxt_user          = '~#~'             select @ctxt_user          = null
     if @description        = '~#~'             select @description        = null
     if @effectivedatefrom  = '01/01/1900'      select @effectivedatefrom  = null
     if @effectivedateto    = '01/01/1900'      select @effectivedateto    = null
     if @guid               = '~#~'             select @guid          = null
     if @hidden_control1    = '~#~'             select @hidden_control1    = null
     if @hidden_control2    = '~#~'             select @hidden_control2    = null
	
	--EPE-74350 starts
	--SQL Injection correction
	declare  @inputval	fin_int

	select   @inputval = dbo.ES_inputval(@analysiscodefrom)
	if @inputval > 0
	begin
		--raiserror('Please provide valid input',16,1)
		exec fin_german_raiserror_sp 'Common',@ctxt_language,44
		return
	end

	select   @inputval = 0
	select   @inputval  = dbo.ES_inputval(@analysiscodeto)	
	if @inputval > 0
	begin
		--raiserror('Please provide valid input',16,1)
		exec fin_german_raiserror_sp 'Common',@ctxt_language,44
		return
	end
	
	select   @inputval = 0
	select   @inputval  = dbo.ES_inputval(@description)	
	if @inputval > 0
	begin
		--raiserror('Please provide valid input',16,1)
		exec fin_german_raiserror_sp 'Common',@ctxt_language,44
		return
	end
	--EPE-74350 ends
	
	if charindex('*',@analysiscodefrom) <> 0
	begin
		exec fin_sp_raise_error	'','','','','ABB', 152, @m_errorid output
		return
	end

	if charindex('*',@analysiscodeto) <> 0
	begin
		exec fin_sp_raise_error	'','','','','ABB', 152, @m_errorid output
		return
	end

	-- FromAnalysisCode is greaterthan the ToAnalysisCode
	if datalength(isnull(@analysiscodefrom,'')) > 0 and
	   datalength(isnull(@analysiscodeto,'')) > 0
	begin
		if @analysiscodefrom > @analysiscodeto
		begin
			exec fin_sp_raise_error @analysiscodefrom, @analysiscodeto, '','','ABB', 10,@m_errorid output
			return
		end
	end

	-- @effectivedatefrom is greaterthan the @effectivedateto
	if @effectivedatefrom >  @effectivedateto
	begin
		exec fin_sp_raise_error @effectivedatefrom, @effectivedateto, '','','ABB', 93,@m_errorid output
		return
	end

	-- Getting company code
	select @companycode_tmp = company_code
	from   emod_ou_vw
	where  ou_id 		    = @ctxt_ouinstance

	-- getting the from Analysis code
	if datalength(isnull(@analysiscodefrom,'')) = 0
		select @analysiscodefrom = null
	else
	begin
		select 	@analysiscodefrom_tmp = min(analysis_code)
		from		abb_analysis_mst  (nolock)
		where	company_code		=  @companycode_tmp
		and		(analysis_code 	>= @analysiscodefrom + '%'
				or analysis_code  like @analysiscodefrom + '%')

		if datalength(isnull(@analysiscodefrom_tmp,'')) <> 0
			select @analysiscodefrom = @analysiscodefrom_tmp

	end

	-- getting the To Analysis code
	if datalength(isnull(@analysiscodeto,'')) = 0
		select @analysiscodeto = null
	else
	begin
		select 	@analysiscodeto_tmp  = max(analysis_code)
		from		abb_analysis_mst  (nolock)
		where	company_code		 = @companycode_tmp
		and		(analysis_code 	<= @analysiscodeto + '%'
				or analysis_code  like @analysiscodeto + '%')

		if datalength(isnull(@analysiscodeto_tmp,'')) <> 0
			select @analysiscodeto = @analysiscodeto_tmp

	end

	-- if @analysiscodefrom is having value
	if datalength(isnull(@analysiscodefrom,'')) > 0
	begin
		select @qry1_tmp = @qry1_tmp + ' and (analysis_code >= ''' + @analysiscodefrom + '''' +
						' or analysis_code like ''' + @analysiscodefrom + '%'')'
	end

	-- if @analysiscodeto is having value
	if  datalength(isnull(@analysiscodeto,'')) > 0
	begin
		select @qry1_tmp = @qry1_tmp + ' and (analysis_code <= ''' + @analysiscodeto + '''' +
						' or analysis_code like ''' + @analysiscodeto + '%'')'
	end

	-- if Description is not null
	if datalength(isnull(@description,'')) > 0
	begin
		select @description = REPLACE(@description,'*','%')
	end
	else
		select @description = '%'

	select @qry1_tmp = @qry1_tmp + ' and analysis_desc like ''' + @description + '''' 		

	-- Getting dateformat
	exec emod_sysact_spgetdatefmt @ctxt_ouinstance, @ctxt_user, @csdtfmt_tmp output

	-- if effectivedate from is not null
	if @effectivedatefrom is not null
		select @qry1_tmp = @qry1_tmp + ' and effective_date_from >= ''' + dbo.fin_dateinuserformat(@effectivedatefrom,@csdtfmt_tmp) + ''''

	-- if effectivedate to is not null
	if @effectivedateto is not null
		select @qry1_tmp = @qry1_tmp + ' and effective_date_to >= ''' + dbo.fin_dateinuserformat(@effectivedateto,@csdtfmt_tmp) + '''' 		

	select @guid_tmp = newid()

	select @execqry_tmp = '	insert into abb_account_budget_tmp
								(guid, analysis_code, analysis_desc,	
								effective_date_from, effective_date_to,
								timestamp)
						select ''' + @guid_tmp + ''',	analysis_code, analysis_desc,
								effective_date_from, effective_date_to,
								timestamp
						from	 	abb_analysis_mst (nolock)
						where 	company_code = ''' + @companycode_tmp + '''
						and		status	   = ''A''' +	@qry1_tmp

	-- executing the dynamic query	
	--SQL injection correction
	--code modified for EPE-74350 starts	
	--exec sp_executesql @execqry_tmp
	exec ES_executesql	@execqry_tmp
	--code modified for EPE-74350 ends

	select  	'ANALYSISCODE' 		= analysis_code,
			'DESC40' 				= analysis_desc,
			'EFFECTIVEDATEFROMML' 	= dbo.fin_dateinuserformat(effective_date_from,@csdtfmt_tmp),
			'EFFECTIVEDATETOML' 	= dbo.fin_dateinuserformat(effective_date_to,@csdtfmt_tmp),
			'TIMESTAMP1' 			= timestamp 		 	
	from 	abb_account_budget_tmp (nolock)
	where	guid	= @guid_tmp
	order 	by analysis_code

	-- Deleting the rows for the guid
	delete from abb_account_budget_tmp
	where	guid	= @guid_tmp

	if @ctxt_service = 'ABBEANSREDAN'
	begin
		exec fin_sp_raise_error '','','','','ABB',99990,@m_errorid output
	end
	
     set nocount off

end


