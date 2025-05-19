/*$File_version=MS4.3.0.06$*/
/************************************************************************************
 procedure name and id   abbeacbspdlbudgmlout
 description             multilne refresh method of delete budget in edit account budget
 name of the author      ramachandran.t
 date created            23-Mar-2002
 query file name         abbeacbspdlbudgmlout.sql
 modifications history
 modified by			Sridhar Siripuram
 modified date			29-Sep-2003, 01-Oct-2003
 modified purpose		ABBRGGSYSTST_000019, ABBRGGSYSTST_000025
 Version			4.0.0.005
 Modification History							
 Modified By		Date			Remarks			
 Uma Maheswari		5th May 2006		CML Changes		
 Esther J		17th Jul 2006 		1_412_RCN_0468 / ABBDMS412AT_000065
 Sharmila M		2/3/2012			ES_ABB_00059:11H103_ABB_00001
 Sharmila M		20/3/2012			ES_ABB_00059[11H103_ABB_00001:11H103_ABB_00030]
 /*Nehru D				24/03/2015			ES_General_05265 */
 /*Abimathi.M	18-2-2021			EPE-29128				 */
 /*Mabel Rita L 09-3-2021			EPE-31268				 */
 /*Abimathi.M	11-3-2021			EPE-31361				 */
 /*Nithya S		15-12-2023			EPE-74350				 */
************************************************************************************/
Create procedure abbeacbspdlbudgmlout
     @accountcodefrom                   fin_accountcode,
     @accountcodeto                     fin_accountcode,
     @accountgroup                      fin_accountgroup,
     @actiondescription                 fin_description,
     @ctxt_language                     fin_ctxt_language,
     @ctxt_ouinstance                   fin_ctxt_ouinstance,
     @ctxt_service                      fin_ctxt_service,
     @ctxt_user                         fin_ctxt_user,
     @currency_code                     fin_currencycode,
     @fbhdr                             fin_financebookid,
     @financeperiodrange                fin_financeperiodrange,
     @financialyearrange                fin_financeyearrange,
     @guid                              fin_guid,
     @hidden_control1                   fin_hiddencontrol,
     @hidden_control2                   fin_hiddencontrol,
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
             @plow_tmp                  fin_int,
	     @utilized_amount_tmp	fin_amount,
	     @accountcode_tmp		fin_accountcode	

    exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
             @prate_tmp output, @perate_tmp output, @phigh_tmp output,
             @pmed_tmp output, @plow_tmp output

--END of Standard code for getting precision type

     -- nocount should be switched on to prevent phantom rows
     set nocount on

	declare 	@qstr_tmp 		fin_querybuffer,
			@qstr1_tmp 		nvarchar(4000),
			@acgrpcode_tmp		fin_param_code,
			@companycode_tmp	fin_companycode,
			@finyearcode_tmp	fin_calendarcode,
			@finprdcode_tmp	fin_calendarcode,
			--@finprd_tmp		fin_calendarcode,   --code commented for SCA Rule while deploying SQL Injectin fixes
			@acc_desc_tmp		fin_accountdesc,
			@csdateformat_tmp 	fin_csdtfmt,
			@finyrprd_tmp		fin_financeyearrange,
			@finyrstdt_tmp		fin_date, --datetime,
			@finyrenddt_tmp		fin_date, --datetime,
			@finprdstdt_tmp		fin_date, --datetime,
			@finprdenddt_tmp	fin_date, --datetime,
			@status_tmp		fin_status,
			@errid_tmp		fin_int,
			@yrprdchk_tmp 		fin_int

     -- @m_errorid should be 0 to indicate success
     select @m_errorid = 0

	select 	@qstr_tmp 		= '',
			@qstr1_tmp 		= '',
			@finyearcode_tmp	= '',
			@status_tmp     = 'A'
			

     select @accountcodefrom     = upper(ltrim(rtrim(@accountcodefrom)))
     select @accountcodeto       = upper(ltrim(rtrim(@accountcodeto)))
     select @accountgroup        = ltrim(rtrim(@accountgroup))
 select @actiondescription   = upper(ltrim(rtrim(@actiondescription)))
     select @ctxt_service        = upper(ltrim(rtrim(@ctxt_service)))
     select @ctxt_user           = ltrim(rtrim(@ctxt_user))
     select @currency_code       = ltrim(rtrim(@currency_code))
     select @fbhdr               = ltrim(rtrim(@fbhdr))
     select @financeperiodrange  = ltrim(rtrim(@financeperiodrange))
     select @financialyearrange  = ltrim(rtrim(@financialyearrange))
     select @guid                = ltrim(rtrim(@guid))
     select @hidden_control1     = ltrim(rtrim(@hidden_control1))
     select @hidden_control2     = ltrim(rtrim(@hidden_control2))

     if @accountcodefrom     = '~#~'             select @accountcodefrom     = null
     if @accountcodeto       = '~#~'             select @accountcodeto       = null
     if @accountgroup        = '~#~'             select @accountgroup        = null
     if @actiondescription   = '~#~'             select @actiondescription   = null
     if @ctxt_language       = -915              select @ctxt_language       = null
     if @ctxt_ouinstance     = -915              select @ctxt_ouinstance     = null
     if @ctxt_service        = '~#~'             select @ctxt_service        = null
     if @ctxt_user           = '~#~'             select @ctxt_user           = null
     if @currency_code       = '~#~'             select @currency_code       = null
     if @fbhdr               = '~#~'             select @fbhdr               = null
     if @financeperiodrange  = '~#~'             select @financeperiodrange  = null
     if @financialyearrange  = '~#~'             select @financialyearrange  = null
     if @guid                = '~#~'             select @guid                = null
     if @hidden_control1     = '~#~'             select @hidden_control1     = null
     if @hidden_control2     = '~#~'             select @hidden_control2     = null

	--EPE-74350 starts
	--SQL Injection correction
	declare  @inputval	fin_int

	select   @inputval = dbo.ES_inputval(@accountcodefrom)
	if @inputval > 0
	begin
		--raiserror('Please provide valid input',16,1)
		exec fin_german_raiserror_sp 'Common',@ctxt_language,44
		return
	end

	select   @inputval = 0
	select   @inputval  = dbo.ES_inputval(@accountcodeto)	
	if @inputval > 0
	begin
		--raiserror('Please provide valid input',16,1)
		exec fin_german_raiserror_sp 'Common',@ctxt_language,44
		return
	end
	
	select   @inputval = 0
	select   @inputval  = dbo.ES_inputval(@actiondescription)	
	if @inputval > 0
	begin
		--raiserror('Please provide valid input',16,1)
		exec fin_german_raiserror_sp 'Common',@ctxt_language,44
		return
	end
	--EPE-74350 ends

	if @ctxt_service = 'ABBEACBSRSRCH'
	begin

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

		if  len(isnull(@accountcodefrom,'')) <> 0 and len(isnull(@accountcodeto,'')) <> 0  -- code Modified by Nehru D for ES_General_05265 
		begin
			if @accountcodefrom > @accountcodeto
			begin				
				select @m_errorid = 53
				return
			end	
		end
	end


	-- getting year / period
	select @finyrprd_tmp = @financeperiodrange

	-- check for whether period or year selectd in the combo
	select @yrprdchk_tmp = len(isnull(@financeperiodrange,'')) -- code Modified by Nehru D for ES_General_05265 
	if @yrprdchk_tmp = 0
	begin
		select 	@financeperiodrange = '##',
				@finyrprd_tmp 		= @financialyearrange
	end	

	-- Getting the Company Code from Emod
	select 	@companycode_tmp = company_code
	from   	emod_ou_vw (nolock)
	where  	ou_id = @ctxt_ouinstance

	-- Get the default Date Formaat
	exec  emod_sysact_spgetdatefmt	@ctxt_ouinstance, @ctxt_user,
								@csdateformat_tmp output, 'CMB'


	-- getting account group code from fin_quick_code
	select 	@acgrpcode_tmp 	= parameter_code
	from		fin_quick_code_met (nolock)
	where	component_id 		= 'ABB'
	and		parameter_type		= 'COMBO'
	and		parameter_category	= 'ACCGRP'
	and		parameter_text		= @accountgroup
	and		language_id		= @ctxt_language

	-- getting the year code
	exec	abb_getyearcode	@ctxt_ouinstance,
						@ctxt_user,
						@ctxt_language,
						@companycode_tmp,
						@financialyearrange,
						@csdateformat_tmp,
						@fbhdr,
						@finyearcode_tmp output,
						@finyrstdt_tmp output,
						@finyrenddt_tmp output,
						@errid_tmp output

	-- getting the period code
	if @yrprdchk_tmp <> 0
		exec	abb_getprdcode		@ctxt_ouinstance,
							@ctxt_user,
							@ctxt_language,
							@companycode_tmp,
							@finyearcode_tmp,
							@financeperiodrange,
							@csdateformat_tmp,
							@fbhdr,
							@finprdcode_tmp output,
							@finprdstdt_tmp output,
							@finprdenddt_tmp output,
							@errid_tmp output

	if @finprdcode_tmp is null select @finprdcode_tmp = '##'
	
	--EPE-29128
	if exists(select '*' from cps_workflowparam_sys 
				where component_id = 'ABB' 
				and  workflow_tran = 'CAAB' 
				and  workflow_app  = 'Y'
				and  company_code  =  @companycode_tmp
				and  language_id   =  @ctxt_language
			 )
	begin
	--commented and added for EPE-31268
	declare  @accountcodefrom_tmp  fin_accountcode,
	         @accountcodeto_tmp    fin_accountcode

			 select  @accountcodefrom_tmp =  @accountcodefrom
			 select  @accountcodeto_tmp   =  @accountcodeto

	   if @accountcodefrom_tmp is null or @accountcodefrom_tmp = ''
	   begin
	        select @accountcodefrom_tmp = 'null'
	   end	
		    
		else--EPE-31268
		begin
		    select @accountcodefrom_tmp = '''' + @accountcodefrom_tmp + '''' 
		end

	   if @accountcodeto_tmp is null or @accountcodeto_tmp = ''
	   begin
	   select @accountcodeto_tmp = 'null'
	   end
		
	   
	   else--EPE-31268
	   begin
		    select @accountcodeto_tmp = '''' + @accountcodeto_tmp + '''' 
       end
		--if @accountcodefrom is null or @accountcodefrom = ''
		--	select @accountcodefrom = 'null'
		
		----select @accountcodefrom = '''' + @accountcodefrom + ''''
		
		--if @accountcodeto is null or @accountcodeto = ''
		--select @accountcodeto = 'null'
		
		--select @accountcodeto = '''' + @accountcodeto + ''''

		--commented and added for EPE-31268

		if charindex('*',@actiondescription) <> 0
			select @acc_desc_tmp = REPLACE(@actiondescription,'*','%')
		else
			select @acc_desc_tmp = @actiondescription
			
		if	@finprdcode_tmp is null or @finprdcode_tmp = '##'
		begin
		
			select @qstr_tmp = 'select  distinct ''' + @guid + '''' + ', a.account_code, '
			select @qstr_tmp = @qstr_tmp + ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase , a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase,workflow_status' 
			select @qstr_tmp = @qstr_tmp + ' from abb_account_budget_dtl_wf a (nolock), fbp_accounts_vw c '
			select @qstr_tmp = @qstr_tmp + ' where 	a.company_code 		= c.company_code'
			select @qstr_tmp = @qstr_tmp + ' and 	a.fb_id 			= c.fb_id'
			select @qstr_tmp = @qstr_tmp + ' and 	a.account_code 		= c.account_code'
			select @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
			select @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
			select @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
			select @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''
			
			select @qstr_tmp = @qstr_tmp + ' and 	a.company_code 	 = ''' + @companycode_tmp + ''''
			select @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr + ''''
			select @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''IA'''
			--select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + '''' + @accountcodefrom + '''' + ',a.account_code) or a.account_code is null)'--EPE-31268
			--select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + '''' + @accountcodeto + '''' + ',a.account_code) or a.account_code is null)' --EPE-31268
			select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + @accountcodefrom_tmp + ',a.account_code) or a.account_code is null)'--EPE-31268
		    select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + @accountcodeto_tmp + ',a.account_code) or a.account_code is null)'--EPE-31268
			select @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp + ''''
			select @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code	= ''##''' 
			select @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	= ''' + @currency_code + ''''
			select @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''IA'''
			select @qstr_tmp = @qstr_tmp + ' and	a.workflow_status 	= ''FRESH''' --EPE-31361
			
		
			select @qstr1_tmp = 'insert into abb_account_budget_tmp '
			select @qstr1_tmp = @qstr1_tmp + ' (guid, account_code, currency_code , '
			select @qstr1_tmp = @qstr1_tmp + ' budget_amount, control_action, timestamp, basecur_erate , parbasecur_erate , budamt_base , budamt_parbase , ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase,workflow_status)'
			select @qstr1_tmp = @qstr1_tmp + @qstr_tmp
			
			--SQL injection correction
			--code modified for EPE-74350 starts	
			--exec sp_executesql @qstr1_tmp
			exec ES_executesql	@qstr1_tmp
			--code modified for EPE-74350 ends

			--EPE-31057 
			--select @qstr_tmp = 'select  distinct ''' + @guid + '''' + ', a.account_code, '
			--select @qstr_tmp = @qstr_tmp + ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase , a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase' 
			--select @qstr_tmp = @qstr_tmp + ' from abb_account_budget_dtl a (nolock), fbp_accounts_vw c '
			--select @qstr_tmp = @qstr_tmp + ' where 	a.company_code 	= c.company_code'
			--select @qstr_tmp = @qstr_tmp + ' and 	a.fb_id 			= c.fb_id'
			--select @qstr_tmp = @qstr_tmp + ' and 	a.account_code 	= c.account_code'
			--select @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
			--select @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
			--select @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
			--select @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''
			--select @qstr_tmp = @qstr_tmp + ' and 	a.company_code 	= ''' + @companycode_tmp + ''''
			--select @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr + ''''
			--select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + @accountcodefrom + ',a.account_code) or a.account_code is null)'
			--select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + @accountcodeto + ',a.account_code) or a.account_code is null)'
			--select @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp + ''''
			--select @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code	= ''##''' 
			--select @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	= ''' + @currency_code + ''''
			--select @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''' + @status_tmp + ''''

			--exec sp_executesql @qstr1_tmp
			--EPE-31057 
		end
		else
		begin
			select @qstr_tmp = 'select ''' + @guid + '''' + ', a.account_code, '
			select @qstr_tmp = @qstr_tmp + ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase, a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase,workflow_status' 
			select @qstr_tmp = @qstr_tmp + ' from abb_account_budget_dtl_wf a (nolock), fbp_accounts_vw c'
			select @qstr_tmp = @qstr_tmp + ' where 	a.company_code 		= c.company_code'
			select @qstr_tmp = @qstr_tmp + ' and 	a.fb_id 			= c.fb_id'
			select @qstr_tmp = @qstr_tmp + ' and 	a.account_code 		= c.account_code'
			select @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
			select @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
			select @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
			select @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''
			
			select @qstr_tmp = @qstr_tmp + ' and 	a.company_code 		= ''' + @companycode_tmp + ''''
			select @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr + ''''
			--select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + '''' + @accountcodefrom + '''' + ',a.account_code) or a.account_code is null)'----EPE-31268
			--select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + '''' + @accountcodeto + '''' + ',a.account_code) or a.account_code is null)'----EPE-31268
			select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + @accountcodefrom_tmp + ',a.account_code) or a.account_code is null)'--EPE-31268
		    select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + @accountcodeto_tmp + ',a.account_code) or a.account_code is null)'--EPE-31268
			select @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp + ''''
			select @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code	= ''' + @finprdcode_tmp + ''''
			select @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	= ''' + @currency_code + ''''
			select @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''IA'''
			select @qstr_tmp = @qstr_tmp + ' and	a.workflow_status 	= ''FRESH''' --EPE-31361
		
			select @qstr1_tmp = 'insert into abb_account_budget_tmp '
			select @qstr1_tmp = @qstr1_tmp + ' (guid, account_code, currency_code , '
			select @qstr1_tmp = @qstr1_tmp + ' budget_amount, control_action, timestamp, basecur_erate , parbasecur_erate , budamt_base , budamt_parbase, ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase,workflow_status)'
			select @qstr1_tmp = @qstr1_tmp + @qstr_tmp
		
			--SQL injection correction
			--code modified for EPE-74350 starts	
			--exec sp_executesql @qstr1_tmp
			exec ES_executesql	@qstr1_tmp
			--code modified for EPE-74350 ends

			--EPE-31057 
		--	select @qstr_tmp = 'select ''' + @guid + '''' + ', a.account_code, '
		--select @qstr_tmp = @qstr_tmp + ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase, a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase' --ES_ABB_00059:11H103_ABB_00001--1_412_RCN_0468 / ABBDMS412AT_000065
		--select @qstr_tmp = @qstr_tmp + ' from abb_account_budget_dtl a (nolock), fbp_accounts_vw c'
		--select @qstr_tmp = @qstr_tmp + ' where 	a.company_code 	= c.company_code'
		--select @qstr_tmp = @qstr_tmp + ' and 	a.fb_id 			= c.fb_id'
		--select @qstr_tmp = @qstr_tmp + ' and 	a.account_code 	= c.account_code'
		--select @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
		--select @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
		--select @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
		--select @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''
		
		--select @qstr_tmp = @qstr_tmp + ' and 	a.company_code 	= ''' + @companycode_tmp + ''''
		--select @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr + ''''
		--select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + @accountcodefrom + ',a.account_code) or a.account_code is null)'
		--select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + @accountcodeto + ',a.account_code) or a.account_code is null)'
		--select @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp + ''''
		--select @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code	= ''' + @finprdcode_tmp + ''''
		--select @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	= ''' + @currency_code + ''''
		--select @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''' + @status_tmp + ''''
	
		--select @qstr1_tmp = 'insert into abb_account_budget_tmp '
		--select @qstr1_tmp = @qstr1_tmp + ' (guid, account_code, currency_code , '
		--select @qstr1_tmp = @qstr1_tmp + ' budget_amount, control_action, timestamp, basecur_erate , parbasecur_erate , budamt_base , budamt_parbase, ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase)'--ES_ABB_00059:11H103_ABB_00001  --1_412_RCN_0468 /ABBDMS412AT_000065--modified for ES_ABB_00059[11H103_ABB_00001:11H103_ABB_00030] 
		--select @qstr1_tmp = @qstr1_tmp + @qstr_tmp
	
		--exec sp_executesql @qstr1_tmp
		--EPE-31057 
		end
	end	
	--EPE-29128


	-- getting the from account code
	if @accountcodefrom is null or @accountcodefrom = ''
		select @accountcodefrom = 'null'
	else
	begin
		if not exists (select 'x'
					from		abb_account_budget_dtl (nolock)
					where	company_code	= @companycode_tmp
					and		fb_id		= @fbhdr
					and		fin_year_code	= @finyearcode_tmp
					and		fin_period_code= @finprdcode_tmp
					and		account_code like @accountcodefrom+'%')

		select 	@accountcodefrom = min(account_code)
		from		abb_account_budget_dtl (nolock)
		where	company_code	= @companycode_tmp
		and		fb_id		= @fbhdr
		and		fin_year_code	= @finyearcode_tmp
		and		fin_period_code= @finprdcode_tmp
		and		account_code 	>= @accountcodefrom+'%'

		
		select @accountcodefrom = '''' + @accountcodefrom + ''''
	end

	-- getting the to account code
	if @accountcodeto is null or @accountcodeto = ''
		select @accountcodeto = 'null'
	else
	begin
		if not exists (select 'x'
					from		abb_account_budget_dtl (nolock)
					where	company_code	= @companycode_tmp
					and		fb_id		= @fbhdr
					and		fin_year_code	= @finyearcode_tmp
					and		fin_period_code= @finprdcode_tmp
					and		account_code like @accountcodeto+'%')

		select 	@accountcodeto = max(account_code)
		from		abb_account_budget_dtl (nolock)
		where	company_code	= @companycode_tmp
		and		fb_id		= @fbhdr
		and		fin_year_code	= @finyearcode_tmp
		and		fin_period_code= @finprdcode_tmp
		and		account_code 	<= @accountcodeto+'%'
				
		select @accountcodeto = '''' + @accountcodeto + ''''
	end
	
	if charindex('*',@actiondescription) <> 0
		select @acc_desc_tmp = REPLACE(@actiondescription,'*','%')
	else
		select @acc_desc_tmp = @actiondescription
	
	if	@finprdcode_tmp is null or @finprdcode_tmp = '##'
	begin
		select @qstr_tmp = 'select  distinct ''' + @guid + '''' + ', a.account_code, '
		select @qstr_tmp = @qstr_tmp + ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase , a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase'--ES_ABB_00059:11H103_ABB_00001 --1_412_RCN_0468 / ABBDMS412AT_000065
		select @qstr_tmp = @qstr_tmp + ' from abb_account_budget_dtl a (nolock), fbp_accounts_vw c '
		select @qstr_tmp = @qstr_tmp + ' where 	a.company_code 	= c.company_code'
		select @qstr_tmp = @qstr_tmp + ' and 	a.fb_id 			= c.fb_id'
		select @qstr_tmp = @qstr_tmp + ' and 	a.account_code 	= c.account_code'
		select @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
		select @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
		select @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
		select @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''		
		select @qstr_tmp = @qstr_tmp + ' and 	a.company_code 	= ''' + @companycode_tmp + ''''
		select @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr + ''''
		select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + @accountcodefrom + ',a.account_code) or a.account_code is null)'
		select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + @accountcodeto + ',a.account_code) or a.account_code is null)'
		select @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp + ''''
		select @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code	= ''##''' 
		select @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	= ''' + @currency_code + ''''
		select @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''' + @status_tmp + ''''
		select @qstr_tmp = @qstr_tmp + ' and 	a.account_code not in  (select  account_code from abb_account_budget_tmp tmp (nolock) where tmp.guid = ''' + @guid+''')' --epe-29128

		select @qstr1_tmp = 'insert into abb_account_budget_tmp '
		select @qstr1_tmp = @qstr1_tmp + ' (guid, account_code, currency_code , '
		select @qstr1_tmp = @qstr1_tmp + ' budget_amount, control_action, timestamp, basecur_erate , parbasecur_erate , budamt_base , budamt_parbase , ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase)'--ES_ABB_00059:11H103_ABB_00001 --1_412_RCN_0468 /ABBDMS412AT_000065--modified for ES_ABB_00059[11H103_ABB_00001:11H103_ABB_00030] 
		select @qstr1_tmp = @qstr1_tmp + @qstr_tmp
		
		--SQL injection correction
		--code modified for EPE-74350 starts	
		--exec sp_executesql @qstr1_tmp
		exec ES_executesql	@qstr1_tmp
		--code modified for EPE-74350 ends
	end
	else
	begin
		select @qstr_tmp = 'select ''' + @guid + '''' + ', a.account_code, '
		select @qstr_tmp = @qstr_tmp + ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase, a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase'--ES_ABB_00059:11H103_ABB_00001  --1_412_RCN_0468 / ABBDMS412AT_000065
		select @qstr_tmp = @qstr_tmp + ' from abb_account_budget_dtl a (nolock), fbp_accounts_vw c'
		select @qstr_tmp = @qstr_tmp + ' where 	a.company_code 	= c.company_code'
		select @qstr_tmp = @qstr_tmp + ' and 	a.fb_id 			= c.fb_id'
		select @qstr_tmp = @qstr_tmp + ' and 	a.account_code 	= c.account_code'
		select @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
		select @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
		select @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
		select @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''		
		select @qstr_tmp = @qstr_tmp + ' and 	a.company_code 	= ''' + @companycode_tmp + ''''
		select @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr + ''''
		select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + @accountcodefrom + ',a.account_code) or a.account_code is null)'
		select @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + @accountcodeto + ',a.account_code) or a.account_code is null)'
		select @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp + ''''
		select @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code	= ''' + @finprdcode_tmp + ''''
		select @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	= ''' + @currency_code + ''''
		select @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''' + @status_tmp + ''''
		select @qstr_tmp = @qstr_tmp + ' and 	a.account_code not in  (select  account_code from abb_account_budget_tmp tmp (nolock) where tmp.guid = ''' + @guid+''')' --epe-29128
		
		select @qstr1_tmp = 'insert into abb_account_budget_tmp '
		select @qstr1_tmp = @qstr1_tmp + ' (guid, account_code, currency_code , '
		select @qstr1_tmp = @qstr1_tmp + ' budget_amount, control_action, timestamp, basecur_erate , parbasecur_erate , budamt_base , budamt_parbase, ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase)'--ES_ABB_00059:11H103_ABB_00001 --1_412_RCN_0468 / ABBDMS412AT_000065--modified for ES_ABB_00059[11H103_ABB_00001:11H103_ABB_00030] 
		select @qstr1_tmp = @qstr1_tmp + @qstr_tmp
	
		--SQL injection correction
		--code modified for EPE-74350 starts	
		--exec sp_executesql @qstr1_tmp
		exec ES_executesql	@qstr1_tmp
		--code modified for EPE-74350 ends
	end	
	
		-- updating account desc and account group from fbp_accounts_vw
	update 	abb_account_budget_tmp
	set	abb_account_budget_tmp.account_group	= b.account_group,
		abb_account_budget_tmp.account_desc	=  mlt1.account_desc
	from	fbp_accounts_vw b ,
		fbp_accounts_Ml_vw mlt1 (nolock) 
	where	abb_account_budget_tmp.guid			= @guid
	and	b.fb_id					= @fbhdr
	and	b.company_code						= @companycode_tmp
	and	abb_account_budget_tmp.account_code	= b.account_code
	and 	mlt1.fb_id = @fbhdr 
	and 	mlt1.company_code = @companycode_tmp 
	and 	abb_account_budget_tmp.account_code = mlt1.account_code 
	and 	mlt1.language_id = @ctxt_language 


	if @finprdcode_tmp = '##'
	begin	
		declare 	account_cursor cursor for
		select 	distinct account_code
		from		abb_account_budget_tmp (nolock)
		where	guid	= @guid		
		
		open account_cursor
				
		while 1=1
		begin 
			fetch next from account_cursor into @accountcode_tmp
			
			if @@fetch_status != 0
				break
			
			select @utilized_amount_tmp = 0
				
			select 	@utilized_amount_tmp =	case
										when a.account_group in ('R','C','L') then isnull(sum(period_credit),0) - isnull(sum(period_debit),0)
									   	else isnull(sum(period_debit),0) - isnull(sum(period_credit),0)
										end
			from		fbp_account_balance_vw b, abb_account_budget_tmp a (nolock)
			where	a.account_code						= b.account_code
			and		b.company_code						= @companycode_tmp
			and		b.fb_id							= @fbhdr
			and		b.currency_code					= @currency_code
			and		b.fin_year_code					= @finyearcode_tmp
			and		a.account_code						= @accountcode_tmp
			and		a.guid							= @guid
			group by	 account_group
			
			update 	abb_account_budget_tmp 
			set		utilized_amount	= @utilized_amount_tmp
			where	guid				= @guid
			and		account_code		= @accountcode_tmp						
		end			
		
		close account_cursor
		deallocate account_cursor
	end
	else
	begin
		-- updating the account balance
		update 	abb_account_budget_tmp
		set		abb_account_budget_tmp.utilized_amount	= case
									when account_group in ('R','C','L') then isnull(period_credit,0) - isnull(period_debit,0)
								   	else isnull(period_debit,0) - isnull(period_credit,0)
									end
		from		fbp_account_balance_vw b
		where	abb_account_budget_tmp.account_code	= b.account_code
		and		b.company_code						= @companycode_tmp
		and		b.fb_id							= @fbhdr
		and		b.currency_code					= @currency_code
		and		b.fin_year_code					= @finyearcode_tmp
		and		b.fin_period_code					= @finprdcode_tmp	
	end
	                                    
	if @ctxt_service = 'ABBEACBSRSRCH'
	begin
		-- inserting into header temp table
		if not exists 	(select 	'x'
					from		abb_budget_hdr_tmp (nolock)
					where	guid		= @guid)
			insert into abb_budget_hdr_tmp
				(guid, company_code, fb_id, fin_year_range, fin_period_range)
			values
				(@guid, @companycode_tmp, @fbhdr, @financialyearrange, @financeperiodrange)
		else
			update	abb_budget_hdr_tmp
			set		company_code		= @companycode_tmp,
					fin_year_range		= @financialyearrange,
					fb_id			= @fbhdr,
					fin_period_range	= @financeperiodrange			
			where	guid				= @guid
	end

	--Template Select Statement for Selecting data to App Layer
	SELECT 	distinct 'ACCCURRENCYCODEML'	= currency_code,
			'ACCOUNTCODEML'		= account_code,
     		'ACCOUNTGROUPML'	= b.parameter_text,
			'BUDGETAMOUNT'		= budget_amount,
			'CONTROLACTION'		= c.parameter_text,
     		'DESC40'			= account_desc,
			'FINANCEYRPERIOD'	= @finyrprd_tmp,
			'TIMESTAMP1'		= a.timestamp,
			'UTILIZEDAMOUNT'	= utilized_amount,
/* Code Added by Esther J on 17-07-2006 for 1_412_RCN_0468 / ABBDMS412AT_000065 starts */
	 		'BASECURRERATE'    	= basecur_erate , 
	 		'PBASECURRERATE'        = parbasecur_erate  
/* Code Added by Esther J on 17-07-2006 for 1_412_RCN_0468 / ABBDMS412AT_000065 ends */
			,'ForecastAmt'			= ForecastAmt--ES_ABB_00059:11H103_ABB_00001
			--,'workflowml'			= dbo.wf_metadesc_fet_fn('ABBACTBUD',workflow_status)
			,'workflowml'			= workflow_status --EPE-31361

	from		abb_account_budget_tmp a(nolock)
	left	join	fin_quick_code_met b (nolock)
	on		a.account_group		= b.parameter_code
	and		b.component_id			= 'ABB'
	and		b.parameter_type		= 'COMBO'
	and		b.parameter_category	= 'ACCGRP'
	and 	b.language_id = @ctxt_language	
	left	join	fin_quick_code_met c (nolock)
	on		a.control_action		= c.parameter_code
	and		c.component_id			= 'ABB'
	and		c.parameter_type		= 'COMBO'
	and		c.parameter_category	= 'CTRLACT'
	and 	c.language_id			= @ctxt_language
	where	guid					= @guid
	and	upper(a.account_desc)	like  @acc_desc_tmp + '%'
	and	account_group	= case @acgrpcode_tmp  -- modified by Sridhar Siripuram for ABBRGGSYSTST_000019 , 25
					when 'AL' then account_group
					else @acgrpcode_tmp
				  end
	order by b.parameter_text, account_code
	
	-- deleting the records from the temporary table
 	delete	abb_account_budget_tmp	
 	where	guid		= @guid
	
	if @ctxt_service = 'ABBEACBSREDBUDG'
	begin
		exec fin_sp_raise_error '','','','','ABB',99997,@m_errorid output		
	end
	else if @ctxt_service = 'ABBEACBSRDLBUDG'
	begin
		exec fin_sp_raise_error '','','','','ABB',99996,@m_errorid output		
	end
	
     set nocount off
end


