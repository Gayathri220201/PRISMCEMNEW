/*$File_version=MS4.3.0.02$*/
/************************************************************************************
 procedure name and id   abbtrbd_search
 description             sp for fetching the multiline based on the search criteria
					in transfer account budget
 name of the author      ramachandran.t
 Version		 4.0.0.01
 date created            24-Mar-2002
 query file name         abbtrbd_search.sql
 Modification History							
 Modified By		Date			Remarks			
 Uma Maheswari		5th May 2006		CML Changes	
 /*Nehru D				24/03/2015			ES_General_05265 */
  Nithya S				15/12/2023			EPE-74350
  Abinaya V				28/12/2023			EPE-74350
************************************************************************************/
create	procedure abbtrbd_search
     @accountcodefrom                   fin_accountcode,
     @accountcodeto                     fin_accountcode,
     @accountgroup                      fin_accountgroup,
     @ctxt_language                     fin_ctxt_language,
     @ctxt_ouinstance                   fin_ctxt_ouinstance,
     @ctxt_service                      fin_ctxt_service,
     @ctxt_user                         fin_ctxt_user,
     @description1                      fin_storagespacedesc,
     @fbhdr                             fin_financebookid,
     @financeperiodrange                fin_financeperiodrange,
     @financialyearrange                fin_financeyearrange,
     @guid                              fin_guid,
     @hidden_control1                   fin_hiddencontrol,
     @hidden_control2                   fin_hiddencontrol,
     @transferfinyrperiodfrom           fin_financeyearrange,
     @transferfinyrperiodto             fin_financeyearrange,
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

	declare 	@qstr_tmp 			fin_querybuffer,
			@qstr1_tmp 			nvarchar(4000),
			@acgrpcode_tmp			fin_param_code,
			@companycode_tmp		fin_companycode,
			@finyearcode_tmp		fin_calendarcode,
			@finprdcode_tmp		fin_calendarcode,
			@fintoyearcode_tmp		fin_calendarcode,
			@fintoprdcode_tmp		fin_calendarcode,
			--@finprd_tmp			fin_calendarcode,  --code commented for SCA Rule while deploying SQL Injectin fixes
			@acc_desc_tmp			fin_accountdesc,
			@csdateformat_tmp 		fin_csdtfmt,
			@finyrprd_tmp			fin_financeyearrange,
			@finyrstdt_tmp			datetime,
			@finyrenddt_tmp		datetime,
			@fintoyrstdt_tmp		datetime,
			@fintoyrenddt_tmp		datetime,		
			@finprdstdt_tmp		datetime,
			@finprdenddt_tmp		datetime,
			@fintoprdstdt_tmp		datetime,
			@fintoprdenddt_tmp		datetime,
			@accountcodefrom_tmp	fin_accountcode,
			@accountcodeto_tmp		fin_accountcode,
			@errid_tmp			int,
			@accountcode_tmp		fin_accountcode,
			@utilized_amount_tmp	fin_amount, 
			@yrprdchk_tmp 			int


     -- @m_errorid should be 0 to indicate success
     select @m_errorid =0

     select @accountcodefrom          = upper(ltrim(rtrim(@accountcodefrom)))
     select @accountcodeto            = upper(ltrim(rtrim(@accountcodeto)))
     select @accountgroup             = ltrim(rtrim(@accountgroup))
     select @ctxt_service             = ltrim(rtrim(@ctxt_service))
     select @ctxt_user                = ltrim(rtrim(@ctxt_user))
     select @description1             = upper(ltrim(rtrim(@description1)))
     select @fbhdr                    = ltrim(rtrim(@fbhdr))
     select @financeperiodrange       = ltrim(rtrim(@financeperiodrange))
     select @financialyearrange       = ltrim(rtrim(@financialyearrange))
     select @guid                     = ltrim(rtrim(@guid))
     select @hidden_control1          = ltrim(rtrim(@hidden_control1))
     select @hidden_control2          = ltrim(rtrim(@hidden_control2))
     select @transferfinyrperiodfrom  = ltrim(rtrim(@transferfinyrperiodfrom))
     select @transferfinyrperiodto    = ltrim(rtrim(@transferfinyrperiodto))

     if @accountcodefrom          = '~#~'             select @accountcodefrom          = null
     if @accountcodeto            = '~#~'             select @accountcodeto            = null
     if @accountgroup             = '~#~'             select @accountgroup             = null
     if @ctxt_language            = -915              select @ctxt_language            = null
     if @ctxt_ouinstance          = -915              select @ctxt_ouinstance          = null
     if @ctxt_service             = '~#~'             select @ctxt_service             = null
     if @ctxt_user                = '~#~'             select @ctxt_user                = null
     --if @description1             = '~#~'             select @description1             = null --code commented for EPE-74350
     if @fbhdr                    = '~#~'             select @fbhdr                    = null
     if @financeperiodrange       = '~#~'             select @financeperiodrange       = null
     if @financialyearrange       = '~#~'             select @financialyearrange       = null
     if @guid                     = '~#~'             select @guid                     = null
     if @hidden_control1          = '~#~'             select @hidden_control1          = null
     if @hidden_control2          = '~#~'             select @hidden_control2          = null
     if @transferfinyrperiodfrom  = '~#~'             select @transferfinyrperiodfrom  = null
     if @transferfinyrperiodto    = '~#~'             select @transferfinyrperiodto    = null

	 --Code added by Abinaya for EPE-74350 starts
	 if @description1     = '~#~' or @description1 = ''            
		select @description1  = '*'
	 --Code added by Abinaya for EPE-74350 ends

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

	exec	abb_getyearcode	@ctxt_ouinstance,
						@ctxt_user,
						@ctxt_language,
						@companycode_tmp,
						@transferfinyrperiodto,
						@csdateformat_tmp,
						@fbhdr,
						@fintoyearcode_tmp output,
						@fintoyrstdt_tmp output,
						@fintoyrenddt_tmp output,
						@errid_tmp output


	if @yrprdchk_tmp <> 0
	begin
		-- getting from period code
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

		-- getting copy to period code
		exec	abb_getprdcode		@ctxt_ouinstance,
							@ctxt_user,
							@ctxt_language,
							@companycode_tmp,
							@fintoyearcode_tmp,
							@transferfinyrperiodto,
							@csdateformat_tmp,
							@fbhdr,
							@fintoprdcode_tmp output,
							@fintoprdstdt_tmp output,
							@fintoprdenddt_tmp output,
							@errid_tmp output

	end
	
	if @finprdcode_tmp is null select @finprdcode_tmp = '##'
	if @fintoprdcode_tmp is null select @fintoprdcode_tmp = '##'
	
	-- fcc status check
	if @finprdcode_tmp = '##'
	begin
		-- check for from year is closedd or not
		if not exists (select 	'x'	
					from		fcc_sysact_allyears_vw
					where	company_code	= @companycode_tmp
					and		fb_id		= @fbhdr
					and		fin_year_code	= @finyearcode_tmp
					and		close_status	= 'C')
		begin
			select @m_errorid = 63
			return
		end
			
		-- check for copy to year is open or not
		if not exists (select 	'x'	
					from		fcc_sysact_allyears_vw
					where	company_code	= @companycode_tmp
					and		fb_id		= @fbhdr
					and		fin_year_code	= @fintoyearcode_tmp
					and		close_status	= 'O')
		begin
			select @m_errorid = 65	
			return
		end	
	end
	else
	begin
		--check for from period is closed or not
		if not exists (select 	'x'	
					from		fcc_sysact_allperiod_vw
					where	company_code	= @companycode_tmp
					and		fb_id		= @fbhdr
					and		fin_year_code	= @finyearcode_tmp
					and		fin_period_code= @finprdcode_tmp
					and		close_status	= 'C')
		begin
			select @m_errorid = 64
			return
		end
			
		-- check for copy to period is open or not
		if not exists (select 	'x'	
					from		fcc_sysact_allperiod_vw
					where	company_code	= @companycode_tmp
					and		fb_id		= @fbhdr
					and		fin_year_code	= @fintoyearcode_tmp
					and		fin_period_code= @fintoprdcode_tmp
					and		close_status	= 'O')
		begin
			select @m_errorid = 66
			return
		end
	end
	
	-- getting the from account code
	if len(isnull(@accountcodefrom,'')) = 0 -- code Modified by Nehru D for ES_General_05265 
		select @accountcodefrom = null
	else
	begin
		select 	@accountcodefrom_tmp = min(account_code)
		from		fbp_accounts_vw  (nolock)
		where	company_code		= @companycode_tmp
		and		fb_id			= @fbhdr
		and		(account_code 		>= @accountcodefrom+'%'
		or		account_code		like @accountcodefrom+'%')
			
		if len(isnull(@accountcodefrom_tmp,'')) <> 0 -- code Modified by Nehru D for ES_General_05265 
			select @accountcodefrom = @accountcodefrom_tmp
	end	
	
	-- getting the to account code
	if len(isnull(@accountcodeto,'')) = 0 -- code Modified by Nehru D for ES_General_05265 
		select @accountcodeto = null
	else
	begin
		select 	@accountcodeto_tmp 	= max(account_code)
		from		fbp_accounts_vw  (nolock)
		where	company_code		= @companycode_tmp
		and		fb_id			= @fbhdr
		and		(account_code 		<= @accountcodeto+'%'
		or		account_code		like @accountcodeto+'%')
		
		if len(isnull(@accountcodeto_tmp,'')) <> 0 -- code Modified by Nehru D for ES_General_05265 
			select @accountcodeto = @accountcodeto_tmp
	end		
	

	if charindex('*',@description1) <> 0
		select @acc_desc_tmp = REPLACE(@description1,'*','%')
	else
		select @acc_desc_tmp = @description1
		
	-- search  dynamic query
	select @qstr_tmp = 'select ''' + @guid + '''' + ', a.account_code, '
	select @qstr_tmp = @qstr_tmp + ' a.account_currency, a.budget_amount, a.control_action, a.timestamp'
	select @qstr_tmp = @qstr_tmp + ' from abb_account_budget_dtl a (nolock), fbp_accounts_vw c'
	select @qstr_tmp = @qstr_tmp + ' where 	a.company_code 	= c.company_code'
	select @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= c.fb_id'
	select @qstr_tmp = @qstr_tmp + ' and   	a.account_code 	= c.account_code'
	select @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
	select @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
	select @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
	select @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''
	select @qstr_tmp = @qstr_tmp + ' and	a.company_code 	= ''' + @companycode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr + ''''
	
	if len(isnull(@accountcodefrom,'')) > 0 -- code Modified by Nehru D for ES_General_05265 
		select @qstr_tmp = @qstr_tmp + ' and (a.account_code >= ''' + @accountcodefrom + '''' +
						' or a.account_code like ''' + @accountcodefrom + '%'')' 
						
	if  len(isnull(@accountcodeto,'')) > 0 -- code Modified by Nehru D for ES_General_05265 
		select @qstr_tmp = @qstr_tmp + ' and (a.account_code <= ''' + @accountcodeto + '''' +
						' or a.account_code like ''' + @accountcodeto + '%'')'
						
	select @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code= ''' + @finprdcode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and	upper(c.account_desc) like  ''' + upper(@acc_desc_tmp) + ''''
	
	select @qstr_tmp = @qstr_tmp + ' and	a.account_code	not in (select account_code '
	select @qstr_tmp = @qstr_tmp + ' from  	abb_account_budget_dtl  b(nolock) '
	select @qstr_tmp = @qstr_tmp + ' where 	b.company_code 	= ''' + @companycode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and	b.account_code 	= a.account_code '
	select @qstr_tmp = @qstr_tmp + ' and	b.fin_year_code 	= ''' + @fintoyearcode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and	b.fin_period_code 	= ''' + @fintoprdcode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and	b.fb_id 			= ''' + @fbhdr + '''' + ')'	
	
	select @qstr1_tmp = 'insert into abb_account_budget_tmp '
	select @qstr1_tmp = @qstr1_tmp + ' (guid, account_code, currency_code , '
	select @qstr1_tmp = @qstr1_tmp + ' budget_amount, control_action, timestamp)'
	select @qstr1_tmp = @qstr1_tmp + @qstr_tmp
			
	-- executing the dynamic query	
	--SQL injection correction
	--code modified for EPE-74350 starts	
	----exec sp_executesql @qstr1_tmp
	exec ES_executesql	@qstr1_tmp
	--code modified for EPE-74350 ends
		
	--- inserting the records into header temp table
	if not exists 	(select 	'x'
				from		abb_budget_hdr_tmp (nolock)
				where 	guid	= @guid)
		insert into abb_budget_hdr_tmp
			(guid, company_code, fb_id, fin_year_range, fin_period_range)
		values
			(@guid, @companycode_tmp, @fbhdr, @financialyearrange, @financeperiodrange)
	else
		update	abb_budget_hdr_tmp
		set		company_code		= @companycode_tmp ,
				fb_id			= @fbhdr,
				fin_year_range		= @financialyearrange,
				fin_period_range	= @financeperiodrange
		where	guid				= @guid
	-- updating account desc and account group from fbp_accounts_vw
	update 	abb_account_budget_tmp
	set	abb_account_budget_tmp.account_group	= b.account_group,
			abb_account_budget_tmp.account_desc		= mlt1.account_desc 
	from	fbp_accounts_vw b (nolock) ,
			fbp_accounts_Ml_vw mlt1 (nolock) 
	where	abb_account_budget_tmp.guid				= @guid
	and	b.fb_id									= @fbhdr
	and	b.company_code							= @companycode_tmp
	and	abb_account_budget_tmp.account_code		= b.account_code
	and 	mlt1.fb_id 								= @fbhdr 
	and 	mlt1.company_code 						= @companycode_tmp 
	and 	abb_account_budget_tmp.account_code 	= mlt1.account_code 
	and 	mlt1.language_id 						= @ctxt_language 

	
	if @finprdcode_tmp <> '##'
	begin
		--updating the utilized amount
		update	abb_account_budget_tmp
		set		abb_account_budget_tmp.utilized_amount	= case
								when account_group in ('R','C','L') then isnull(period_credit,0) - isnull(period_debit,0)
							   	else isnull(period_debit,0) - isnull(period_credit,0)
								end
		from		fbp_account_balance_vw b
		where	b.fb_id							= @fbhdr
		and		b.company_code						= @companycode_tmp
		and		abb_account_budget_tmp.account_code	= b.account_code
		and		b.fin_year_code					= @finyearcode_tmp
		and		b.fin_period_code					= @finprdcode_tmp
		and		abb_account_budget_tmp.guid			= @guid
	end
	else
	begin
		declare 	account_cursor cursor for
		select 	distinct account_code
		from		abb_account_budget_tmp (nolock)
		where	guid		 	= @guid
					
		open account_cursor		
				
		while  1=1
		begin 
			fetch next from account_cursor into @accountcode_tmp
			
			if @@fetch_status != 0
				break						

			select 	@utilized_amount_tmp =	0
						
			select 	@utilized_amount_tmp =	case
										when a.account_group in ('R','C','L') then isnull(sum(period_credit),0) - isnull(sum(period_debit),0)
									   	else isnull(sum(period_debit),0) - isnull(sum(period_credit),0)
										end
			from		fbp_account_balance_vw b, abb_account_budget_tmp a (nolock)
			where	a.account_code						= b.account_code
			and		b.company_code						= @companycode_tmp
			and		b.fb_id							= @fbhdr
			and		b.currency_code					= a.currency_code
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
			
     set nocount off
end



