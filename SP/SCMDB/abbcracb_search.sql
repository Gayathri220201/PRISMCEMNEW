/*$File_version=ms4.3.0.06$*/
/************************************************************************************
 procedure name and id   abbcracb_search
 description             sp for search in create account budget
 name of the author      ramachandran.t
 date created            07-May-2002
 query file name         abbcracb_search.sql
 modifications history
 modified by			Sridhar Siripuram
 modified date			29-Sep-2003
 modified purpose		ABBRGGSYSTST_000019 
 Version				4.0.0.005

 Modification History							
 Modified By		Date			Remarks			
 Uma Maheswari		5th May 2006		CML Changes		
 Uma Maheswari		12th May 2006		ABBDMS412AT_000041	
 Swetha                 11/12/2006              ABBDMS412AT_000080
 Swetha                 14/12/2006              ABBDMS412AT_000093
 Prabu S		06/12/2007		ABBDMS412AT_000192
 Nithya P		04/12/2008		ES_ABB_00018
 /*Nehru D				24/03/2015			ES_General_05265 */
 /*Abimathi M			18/02/2021			EPE-29128		 */
  Nithya S				15/12/2023			EPE-74350
************************************************************************************/
CREATE procedure abbcracb_search
	@accountcodefrom                   fin_accountcode,
	@accountcodeto                     fin_accountcode,
	@accountgroup                      fin_accountgroup,
	@actiondescription                 fin_description,
	@applyseasonaladappat              fin_subtitle,
	@carryforwardbudget                fin_amount,
	@controlactionen                   fin_controlactionen,
	@ctxt_language                     fin_ctxt_language,
	@ctxt_ouinstance                   fin_ctxt_ouinstance,
	@ctxt_service                      fin_ctxt_service,
	@ctxt_user                         fin_ctxt_user,
	@currency_code                     fin_currencycode,
	@fbhdr                             fin_financebookid,
	@financialperiod                   fin_financeperiodrange,
	@financialyear                     fin_financeyearrange,
	@guid                              fin_guid,
	@hidden_control1                   fin_hiddencontrol,
	@hidden_control2                   fin_hiddencontrol,
	@m_errorid                         fin_int output --to return execution status
as
begin
	-- nocount should be switched on to prevent phantom rows
	set nocount on

	/*code added by Nithya P for bugid:ES_ABB_00018 starts here*/
	--BEGIN of Standard code for getting precision type
	declare  @pqty_tmp                  fin_int ,
	     @pamt_tmp                  fin_int ,
	     @prate_tmp                 fin_int ,
	     @perate_tmp     fin_int ,
	     @phigh_tmp                 fin_int ,
	     @pmed_tmp                 fin_int ,
	     @plow_tmp                  fin_int

	exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
	     @prate_tmp output, @perate_tmp output, @phigh_tmp output,
	     @pmed_tmp output, @plow_tmp output

	--END of Standard code for getting precision type
	/*code added by Nithya P for bugid:ES_ABB_00018 ends here*/

	declare @qstr_tmp 			fin_querybuffer,
		@qstr1_tmp 			nvarchar(4000),
		@acgrpcode_tmp			fin_param_code,
		@companycode_tmp		fin_companycode,
		@finyearcode_tmp		fin_calendarcode,
		@finprdcode_tmp		        fin_calendarcode,
		--@finprd_tmp			fin_calendarcode,    --code commented for SCA Rule while deploying SQL Injectin fixes
		@acc_desc_tmp			fin_accountdesc,
		@csdateformat_tmp 		fin_csdtfmt,
		@finyrprd_tmp			fin_financeyearrange,
		@accountcodefrom_tmp	        fin_accountcode,
		@accountcodeto_tmp		fin_accountcode,
		@finyrstdt_tmp			fin_date,
		@finyrenddt_tmp		        fin_date,
		@finprdstdt_tmp		        fin_date,
		@finprdenddt_tmp		fin_date,
		@errid_tmp			fin_int,
		@yrprdchk_tmp 			fin_int,
                @basecurrerate 		        fin_amount ,
		@pbasecurrerate 		fin_amount ,
		@maxlimit_tmp 		        fin_amount ,
		@minlimit_tmp 		        fin_amount ,                       
		@eratecat_tmp 		        fin_param_text ,
		@currunits_tmp 		        fin_units,
		@base_tmp			fin_currencycode,
		@pbase_tmp			fin_currencycode,
		@exch_ratetype_tmp	        fin_paramcode,
		@errorid_tmp		        fin_int   ,
		@firstday_tmp		        fin_date ,
		@getdate_tmp		        fin_date 
               -- @fintoyrstdt_tmp		fin_date ,  --code commented for SCA Rule while deploying SQL Injectin fixes
                --@fintoprdstdt_tmp		fin_date   --code commented for SCA Rule while deploying SQL Injectin fixes

	-- @m_errorid should be 0 to indicate success
	select @m_errorid =0

	select 	@qstr_tmp 		= '',
		@qstr1_tmp 		= '',
		@finyearcode_tmp	= ''

	select @accountcodefrom       = upper(ltrim(rtrim(@accountcodefrom)))
	select @accountcodeto         = upper(ltrim(rtrim(@accountcodeto)))
	select @accountgroup          = ltrim(rtrim(@accountgroup))
	select @actiondescription     = upper(ltrim(rtrim(@actiondescription)))
	select @applyseasonaladappat  = ltrim(rtrim(@applyseasonaladappat))
	select @controlactionen       = ltrim(rtrim(@controlactionen))
	select @ctxt_service          = ltrim(rtrim(@ctxt_service))
	select @ctxt_user             = ltrim(rtrim(@ctxt_user))
	select @currency_code         = ltrim(rtrim(@currency_code))
	select @fbhdr                 = ltrim(rtrim(@fbhdr))
	select @financialperiod       = ltrim(rtrim(@financialperiod))
	select @financialyear         = ltrim(rtrim(@financialyear))
	select @guid                  = ltrim(rtrim(@guid))
	select @hidden_control1       = ltrim(rtrim(@hidden_control1))
	select @hidden_control2       = ltrim(rtrim(@hidden_control2))

	if @accountcodefrom       = '~#~'           select @accountcodefrom       = null
	if @accountcodeto         = '~#~'             select @accountcodeto         = null
	if @accountgroup          = '~#~'             select @accountgroup          = null
	if @actiondescription     = '~#~'             select @actiondescription     = null
	if @applyseasonaladappat  = '~#~'             select @applyseasonaladappat  = null
	if @carryforwardbudget    = -915              select @carryforwardbudget    = null
	if @controlactionen       = '~#~'             select @controlactionen       = null
	if @ctxt_language         = -915              select @ctxt_language         = null
	if @ctxt_ouinstance       = -915              select @ctxt_ouinstance       = null
	if @ctxt_service          = '~#~'             select @ctxt_service          = null
	if @ctxt_user             = '~#~'             select @ctxt_user             = null
	if @currency_code         = '~#~'             select @currency_code         = null
	if @fbhdr                 = '~#~'             select @fbhdr                 = null
	if @financialperiod       = '~#~'             select @financialperiod       = null
	if @financialyear         = '~#~'             select @financialyear         = null
	if @guid                  = '~#~'             select @guid                  = null
	if @hidden_control1       = '~#~'             select @hidden_control1       = null
	if @hidden_control2       = '~#~'             select @hidden_control2       = null

	select 	@finyrprd_tmp 	= @financialperiod,
		@m_errorid	    = 0


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
	--SQL Injection correction
    --EPE-74350 ends
	

	-- check for whether period or year selectd in the combo
	select @yrprdchk_tmp = len(isnull(@financialperiod,'')) -- code Modified by Nehru D for ES_General_05265

	if @yrprdchk_tmp = 0
	begin
		select 	@financialperiod 	= '##',
			@finyrprd_tmp 	= @financialyear
	end	

	-- Getting the Company Code from Emod
	select 	@companycode_tmp = company_code
	from   	emod_ou_vw (nolock)
	where  	ou_id = @ctxt_ouinstance

	-- Get the default Date Formaat
	exec  emod_sysact_spgetdatefmt	@ctxt_ouinstance, @ctxt_user,
								@csdateformat_tmp output, 'CMB'

	if  len(isnull(@accountcodefrom,'')) <> 0 and len(isnull(@accountcodeto,'')) <> 0 -- code Modified by Nehru D for ES_General_05265
	begin
		if @accountcodefrom > @accountcodeto
		begin				
			select @m_errorid = 53
			return
		end
	end
	
	-- getting account group code from fin_quick_code
	select 	@acgrpcode_tmp 	= parameter_code
	from	fin_quick_code_met (nolock)
	where	component_id 		= 'ABB'
	and	parameter_type		= 'COMBO'
	and	parameter_category	= 'ACCGRP'
	and	parameter_text		= @accountgroup
	and	language_id		= @ctxt_language
	
	-- getting the year code
	exec	abb_getyearcode	@ctxt_ouinstance,
				@ctxt_user,
				@ctxt_language,
				@companycode_tmp,
				@financialyear,
				@csdateformat_tmp,
				@fbhdr,
				@finyearcode_tmp output,
				@finyrstdt_tmp output,
				@finyrenddt_tmp output,
				@errid_tmp output
	
	-- getting the period code
	if @yrprdchk_tmp <> 0
		exec	abb_getprdcode	@ctxt_ouinstance,
					@ctxt_user,
					@ctxt_language,
					@companycode_tmp,
					@finyearcode_tmp,
					@financialperiod,
					@csdateformat_tmp,
					@fbhdr,
					@finprdcode_tmp output,
					@finprdstdt_tmp output,
					@finprdenddt_tmp output,
					@errid_tmp output
	
	if @finprdcode_tmp is null select @finprdcode_tmp = '##'
	
	-- getting the from account code
	if len(isnull(@accountcodefrom,'')) = 0 -- code Modified by Nehru D for ES_General_05265
		select @accountcodefrom = null
	else
	begin
		select 	@accountcodefrom_tmp = min(account_code)
		from	fbp_accounts_vw  (nolock)
		where	company_code		= @companycode_tmp
		and	fb_id			= @fbhdr
		and	account_currency	= @currency_code
		and	(account_code 		>= @accountcodefrom+'%'
		or	account_code		like @accountcodefrom+'%')
		
		if len(isnull(@accountcodefrom_tmp,'')) <> 0  -- code Modified by Nehru D for ES_General_05265
			select @accountcodefrom = @accountcodefrom_tmp
	end	
	

	-- getting the from account code
	if len(isnull(@accountcodeto,'')) = 0  -- code Modified by Nehru D for ES_General_05265
		select @accountcodeto = null
	else
	begin
		select 	@accountcodeto_tmp 	= max(account_code)
		from	fbp_accounts_vw  (nolock)
		where	company_code		= @companycode_tmp
		and	fb_id			= @fbhdr
		and	account_currency	= @currency_code
		and	(account_code 		<= @accountcodeto+'%'
		or	account_code		like @accountcodeto+'%')

		if len(isnull(@accountcodeto_tmp,'')) <> 0 -- code Modified by Nehru D for ES_General_05265
			select @accountcodeto = @accountcodeto_tmp
	end	

	if charindex('*',@actiondescription) <> 0
		select @acc_desc_tmp = REPLACE(@actiondescription,'*','%')
	else
		select @acc_desc_tmp = @actiondescription

	/*Code modified by Prabu for the bug id : ABBDMS412AT_000192 starts here*/	
	-- dynamic query formation based on the search criteria
	select @qstr_tmp = 'select ''' + @guid + ''',''' + @finyrprd_tmp + ''', account_code, account_desc, account_group, ' 
			   
				
	/*Code modified by Uma for the bug id : ABBDMS412AT_000041 starts here*/
--	select @qstr_tmp = @qstr_tmp + ' account_currency from fbp_accounts_vw a '
	select @qstr_tmp = @qstr_tmp + ' account_currency,language_id from fbp_accounts_vw a (nolock)'
	/*Code modified by Uma for the bug id : ABBDMS412AT_000041 ends here*/
	/*Code modified by Prabu for the bug id : ABBDMS412AT_000192 ends here*/
	select @qstr_tmp = @qstr_tmp + ' where 	company_code 	= ''' + @companycode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and   	fb_id 		= ''' + @fbhdr + ''''
	select @qstr_tmp = @qstr_tmp + ' and	account_status	= ''' + 'A' + ''''
	select @qstr_tmp = @qstr_tmp + ' and	autopost_type is null ' 
	select @qstr_tmp = @qstr_tmp + ' and	account_class <> ''RETEARNINGS'''
	select @qstr_tmp = @qstr_tmp + ' and	account_group <> ''C'''
	select @qstr_tmp = @qstr_tmp + ' and	upper(account_desc)	like ''' + @acc_desc_tmp + '%'''

	if len(isnull(@accountcodefrom,'')) > 0 -- code Modified by Nehru D for ES_General_05265
		select @qstr_tmp = @qstr_tmp + ' and (account_code >= ''' + @accountcodefrom + '''' +
						' or account_code like ''' + @accountcodefrom + '%'')'

	if  len(isnull(@accountcodeto,'')) > 0   -- code Modified by Nehru D for ES_General_05265
		select @qstr_tmp = @qstr_tmp + ' and (account_code <= ''' + @accountcodeto + '''' +
						' or account_code like ''' + @accountcodeto + '%'')'

	select @qstr_tmp = @qstr_tmp + ' and 	account_currency = ''' + @currency_code + ''''
	
	-- Added by Sridhar siripuram for ABBRGGSYSTST_000019 begin
	if @acgrpcode_tmp <> 'AL'
		select @qstr_tmp = @qstr_tmp + ' and	account_group	= ''' + @acgrpcode_tmp + ''''
	-- Added by Sridhar siripuram for ABBRGGSYSTST_000019 end
		
	select @qstr_tmp = @qstr_tmp + ' and	account_code	not in (select account_code '
	select @qstr_tmp = @qstr_tmp + ' from  	abb_account_budget_dtl  b(nolock) '
	select @qstr_tmp = @qstr_tmp + ' where 	b.company_code 	= ''' + @companycode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and	b.account_code 	= a.account_code '
	select @qstr_tmp = @qstr_tmp + ' and	b.fin_year_code 	= ''' + @finyearcode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and	b.fin_period_code 	= ''' + @finprdcode_tmp + ''''
	select @qstr_tmp = @qstr_tmp + ' and	b.fb_id 			= ''' + @fbhdr + '''' + ')'	
	select @qstr_tmp = @qstr_tmp + ' order by account_code '

	select @qstr1_tmp = 'insert into abb_account_budget_tmp '
	/*Code modified by Uma for the bug id : ABBDMS412AT_000041 starts here*/
--	select @qstr1_tmp = @qstr1_tmp + ' (guid, fin_yearperiod_range, account_code, account_desc, account_group, currency_code)'
	select @qstr1_tmp = @qstr1_tmp + ' (guid, fin_yearperiod_range, account_code, account_desc, account_group, currency_code,language_id)'
	/*Code modified by Uma for the bug id : ABBDMS412AT_000041 ends here*/
	select @qstr1_tmp = @qstr1_tmp + @qstr_tmp	

	-- executing the dynamic query	
	--SQL injection correction
	--code modified for EPE-74350 starts	
	----exec sp_executesql @qstr1_tmp
	exec ES_executesql	@qstr1_tmp
	--code modified for EPE-74350 ends

	/* Code added by Swetha for ABBDMS412AT_000080 on 11/12/2006 */
	select @getdate_tmp = dbo.RES_Getdate(@ctxt_ouinstance)

        /* Code modified by Swetha for ABBDMS412AT_000093 on 14/12/2006 */
    	-- Get the default Date Formaat
	exec  emod_sysact_spgetdatefmt	@ctxt_ouinstance, @ctxt_user,
					@csdateformat_tmp output, 'CMB'
	
   	--Get the Base Currency
	select	@base_tmp	=	currency_code
	from	emod_basecurr_vw(NOLOCK)
	where	company_code	=	@companycode_tmp
	and	flag		    =	'B'
	and	@getdate_tmp between effective_from and isnull(effective_to,@getdate_tmp)
	
	-- Get the Parallel Base Currency
	select	@pbase_tmp	=	currency_code
	from	emod_basecurr_vw(NOLOCK)
	where	company_code	=	@companycode_tmp
	and	flag		    =	'P'
	and	@getdate_tmp 	between effective_from and isnull(effective_to,@getdate_tmp)

	select	@exch_ratetype_tmp 	= ltrim(rtrim(parameter_code))
	from	fin_processparam_sys (nolock)
	where	company_code		= @companycode_tmp
	and	ou_id			    = @ctxt_ouinstance
	and	component_id		= 'ABB'
	and	parameter_type		= 'FNDEF'
	and	parameter_category	= 'ERATETYP'

	if @yrprdchk_tmp = 0 
			select @firstday_tmp  = @finyrstdt_tmp
	else
			select @firstday_tmp  = @finprdstdt_tmp
        
        /* Code modified by Swetha for ABBDMS412AT_000093 on 14/12/2006 */

	if @currency_code = @base_tmp
	begin
    		select @basecurrerate = 1
	end
	else
	begin 
		   exec @errorid_tmp = erate_sysact_spgetexcgrate                       
		   @ctxt_ouinstance ,@ctxt_user , @ctxt_language ,                      
		   @currency_code ,@base_tmp , @firstday_tmp ,@exch_ratetype_tmp ,
		   @basecurrerate out ,@maxlimit_tmp out ,@minlimit_tmp out ,                       
		   @eratecat_tmp out ,@currunits_tmp out,'ABB'    
	end

	if @currency_code = @pbase_tmp
	begin
		select @pbasecurrerate = 1
	end
	else
	begin 
		   exec @errorid_tmp = erate_sysact_spgetexcgrate                       
		   @ctxt_ouinstance ,@ctxt_user , @ctxt_language ,                      
		   @currency_code ,@pbase_tmp , @firstday_tmp ,@exch_ratetype_tmp ,
		   @pbasecurrerate out ,@maxlimit_tmp out ,@minlimit_tmp out ,                       
		   @eratecat_tmp out ,@currunits_tmp out,'ABB'    
	end

	update  A
	set 	basecur_erate		= round(@basecurrerate,@pamt_tmp) , --ES_ABB_00018
		parbasecur_erate	= round(@pbasecurrerate ,@pamt_tmp)--ES_ABB_00018
	from	abb_account_budget_tmp A (nolock)
	where	guid		 	= @guid

		--EPE-29128 starts
		if exists(select '*' from cps_workflowparam_sys 
					where component_id = 'ABB' 
					and  workflow_tran = 'CAAB' 
					and  workflow_app  = 'Y'
					and company_code   =  @companycode_tmp
					and language_id	   =  @ctxt_language
				 )
		begin
		
			delete tmp 
			from abb_account_budget_tmp tmp,
			     abb_account_budget_dtl_wf wf 
			where guid				 = @guid
			and  wf.account_code     = tmp.account_code --EPE-31198   
			and  wf.company_code	 = @companycode_tmp
			and  wf.fb_id			 = @fbhdr
			and  wf.fin_year_code	 = @finyearcode_tmp	
			and  wf.fin_period_code  = @finprdcode_tmp
			and  wf.status			 = 'IA'	
			
		end
		--EPE-29128 starts

        /* Code added by Swetha for ABBDMS412AT_000080 on 11/12/2006 */
	
     set nocount off
end


