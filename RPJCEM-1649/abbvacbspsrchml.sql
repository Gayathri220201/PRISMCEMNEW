/*$File_version=MS4.3.0.04$*/
/************************************************************************************
 procedure name and id   abbvacbspsrchml
 description             sp for fetching the multiline based on the search criteria
					in view account budget
 name of the author      ramachandran.t
 date created            23-Mar-2002
 query file name         abbvacbspsrchml.sql
 Version		 4.0.0.002
 modifications history
 modified by		Sridhar Siripuram
 modified date		24-Sep-2003, 29-Sep-2003
 modified purpose	ABBRGGSYSTST_000021, ABBRGGSYSTST_000023, 19
 version		4.0.0.003

 modified by		Muthu V
 modified date		12-APR-2004
 modified purpose	SP Modification for German Language Support

 Modification History							
 Modified By		Date			Remarks			
 Uma Maheswari		5th May 2006		CML Changes		
 Esther J		    17th Jul 2006 		1_412_RCN_0468 / ABBDMS412AT_000065
 Swetha             27 sep 2006         ABBDMS412at_000070
 Poorna R			28 Jan 2010			ES_ABB_00033
 Sharmila			2/3/2012			ES_ABB_00059:11H103_ABB_00001
 Sharmila M		20/3/2012			ES_ABB_00059[11H103_ABB_00001:11H103_ABB_00031]
 Version            4.0.0.007
 /*Nehru D				24/03/2015			ES_General_05265 */
 /*Vinothini N			11/2/2021			EPE-29128							   */
 /*Nithya S				15-12-2023			EPE-74350							   */
************************************************************************************/
CREATE PROCEDURE abbvacbspsrchml
     @accountcodefrom                   fin_accountcode,
     @accountcodeto                     fin_accountcode,
     @accountgroup                      fin_accountgroup,
     @actiondescription                 fin_description,
     @controlactionenn                  fin_desc40,
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
AS
BEGIN
	SET NOCOUNT ON
	
	--BEGIN of Standard code for getting precision type
	DECLARE @pqty_tmp             fin_int,
	        @pamt_tmp             fin_int,
	        @prate_tmp            fin_int,
	        @perate_tmp           fin_int,
	        @phigh_tmp            fin_int,
	        @pmed_tmp             fin_int,
	        @plow_tmp             fin_int,
	        @utilized_amount_tmp  fin_amount,
	        @accountcode_tmp      fin_accountcode	
	
	
	EXEC fin_sp_precisiontype_rtr @pqty_tmp OUTPUT,
	     @pamt_tmp OUTPUT,
	     @prate_tmp OUTPUT,
	     @perate_tmp OUTPUT,
	     @phigh_tmp OUTPUT,
	     @pmed_tmp OUTPUT,
	     @plow_tmp OUTPUT
	
	--END of Standard code for getting precision type
	
	-- nocount should be switched on to prevent phantom rows
	SET NOCOUNT ON
	
	DECLARE @qstr_tmp             fin_querybuffer,
	        @qstr1_tmp            nvarchar(4000),
	        @acgrpcode_tmp        fin_param_code,
	        @companycode_tmp      fin_companycode,
	        @finyearcode_tmp      fin_calendarcode,
	        @finprdcode_tmp       fin_calendarcode,
	        --@finprd_tmp           fin_calendarcode,
	        @acc_desc_tmp         fin_accountdesc,
	        @csdateformat_tmp     fin_csdtfmt,
	        @finyrprd_tmp         fin_financeyearrange,
	        @ctrlact_tmp          fin_paramcode,
	        @accountcodefrom_tmp  fin_accountcode,
	        @accountcodeto_tmp    fin_accountcode,
	        @finyrstdt_tmp        fin_date,	--datetime,
	        @finyrenddt_tmp       fin_date,	--datetime,
	        @finprdstdt_tmp       fin_date,	--datetime,
	        @finprdenddt_tmp      fin_date,	--datetime,
	        @status_tmp    fin_status,
	        @errid_tmp            fin_int,
	        @yrprdchk_tmp         fin_int,
			@curr_code_tmp		  fin_currencycode, --Code added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010
			@controlaction_tmp	  fin_paramcode --Code added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010
	
	
	-- @m_errorid should be 0 to indicate success
	SELECT @m_errorid = 0
	
	SELECT @qstr_tmp = '',
	       @qstr1_tmp = '',
	       @finyearcode_tmp = '',
	       @status_tmp = 'A'
	
	
	SELECT @accountcodefrom = UPPER(LTRIM(RTRIM(@accountcodefrom)))
	SELECT @accountcodeto = UPPER(LTRIM(RTRIM(@accountcodeto)))
	SELECT @accountgroup = LTRIM(RTRIM(@accountgroup))
	SELECT @actiondescription = UPPER(LTRIM(RTRIM(@actiondescription)))
	SELECT @controlactionenn = LTRIM(RTRIM(@controlactionenn))
	SELECT @ctxt_service = LTRIM(RTRIM(@ctxt_service))
	SELECT @ctxt_user = LTRIM(RTRIM(@ctxt_user))
	SELECT @currency_code = LTRIM(RTRIM(@currency_code))
	SELECT @fbhdr = LTRIM(RTRIM(@fbhdr))
	SELECT @financeperiodrange = LTRIM(RTRIM(@financeperiodrange))
	SELECT @financialyearrange = LTRIM(RTRIM(@financialyearrange))
	SELECT @guid = LTRIM(RTRIM(@guid))
	SELECT @hidden_control1 = LTRIM(RTRIM(@hidden_control1))
	SELECT @hidden_control2 = LTRIM(RTRIM(@hidden_control2))
	
	IF @accountcodefrom = '~#~'
	    SELECT @accountcodefrom = NULL
	
	IF @accountcodeto = '~#~'
	    SELECT @accountcodeto = NULL
	
	IF @accountgroup = '~#~'
	    SELECT @accountgroup = NULL
	
	IF @actiondescription = '~#~'
	    SELECT @actiondescription = NULL
	
	IF @controlactionenn = '~#~'
	    SELECT @controlactionenn = NULL
	
	IF @ctxt_language = -915
	    SELECT @ctxt_language = NULL
	
	IF @ctxt_ouinstance = -915
	    SELECT @ctxt_ouinstance = NULL
	
	IF @ctxt_service = '~#~'
	    SELECT @ctxt_service = NULL
	
	IF @ctxt_user = '~#~'
	    SELECT @ctxt_user = NULL
	
	IF @currency_code = '~#~'
	    SELECT @currency_code = NULL
	
	IF @fbhdr = '~#~'
	    SELECT @fbhdr = NULL
	
	IF @financeperiodrange = '~#~'
	    SELECT @financeperiodrange = NULL
	
	IF @financialyearrange = '~#~'
	    SELECT @financialyearrange = NULL
	
	IF @guid = '~#~'
	    SELECT @guid = NULL
	
	IF @hidden_control1 = '~#~'
	    SELECT @hidden_control1 = NULL
	
	IF @hidden_control2 = '~#~'
	    SELECT @hidden_control2 = NULL
	
	/* Code added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */

	SELECT @curr_code_tmp		= LTRIM(RTRIM(parameter_text))
	FROM   fin_quick_code_met(NOLOCK)
	WHERE  component_id			= 'ABB'
	AND    parameter_type		= 'COMBO'
	AND    parameter_category	= 'COMMON'
	AND    parameter_code		= 'ALL'
	AND    language_id			= @ctxt_language

	IF @currency_code = @curr_code_tmp
	    SELECT @currency_code = '%'
	/* Code added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	
	IF CHARINDEX('*', @accountcodefrom) <> 0
	BEGIN
	    EXEC fin_sp_raise_error '',
	         '',
	         '',
	         '',
	         'ABB',
	         154,
	         @m_errorid OUTPUT
	    
	    RETURN
	END
	
	IF CHARINDEX('*', @accountcodeto) <> 0
	BEGIN
	    EXEC fin_sp_raise_error '',
	         '',
	         '',
	         '',
	         'ABB',
	         154,
	         @m_errorid OUTPUT
	    
	    RETURN
	END
	
	-- accountcodefrom code is greater than the accountcodeto
	IF len(ISNULL(@accountcodefrom, '')) > 0 -- code Modified by Nehru D for ES_General_05265
	AND len(ISNULL(@accountcodeto, '')) > 0  -- code Modified by Nehru D for ES_General_05265
	BEGIN
	    IF @accountcodefrom > @accountcodeto
	    BEGIN
	        EXEC fin_sp_raise_error @accountcodefrom,
	             @accountcodeto,
	             '',
	             '',
	             'ABB',
	             53,
	             @m_errorid OUTPUT
	        
	        RETURN
	   END
	END
	
	-- getting year / period
	SELECT @finyrprd_tmp = @financeperiodrange
	
	-- check for whether period or year selectd in the combo
	SELECT @yrprdchk_tmp = len(ISNULL(@financeperiodrange, '')) -- code Modified by Nehru D for ES_General_05265
	IF @yrprdchk_tmp = 0
	BEGIN
	    SELECT @financeperiodrange = '##',
	 @finyrprd_tmp = @financialyearrange
	END 
	
	-- Getting the Company Code from Emod
	SELECT @companycode_tmp = company_code
	FROM   emod_ou_vw(NOLOCK)
	WHERE  ou_id = @ctxt_ouinstance
	
	-- Get the default Date Formaat
	EXEC emod_sysact_spgetdatefmt @ctxt_ouinstance,
	     @ctxt_user,
	     @csdateformat_tmp OUTPUT,
	     'CMB'
	
	-- getting account group code from fin_quick_code
	SELECT @acgrpcode_tmp = parameter_code
	FROM   fin_quick_code_met(NOLOCK)
	WHERE  component_id = 'ABB'
	AND    parameter_type = 'COMBO'
	AND    parameter_category = 'ACCGRP'
	AND    parameter_text = @accountgroup
	AND    language_id = @ctxt_language
	
	--Template Select Statement for Selecting data to App Layer
	/* Code added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	SELECT @controlaction_tmp	= LTRIM(RTRIM(parameter_text))
	FROM   fin_quick_code_met(NOLOCK)
	WHERE  component_id			= 'ABB'
	AND    parameter_type		= 'COMBO'
	AND    parameter_category	= 'COMMON'
	AND    parameter_code		= 'ALL'
	AND    language_id			= @ctxt_language
	
	IF @controlactionenn = @controlaction_tmp
	BEGIN
	    SELECT @ctrlact_tmp = '%'
	END
	ELSE
	BEGIN
	    /* Code added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	    SELECT @ctrlact_tmp = parameter_code
	    FROM   fin_quick_code_met(NOLOCK)
	    WHERE  component_id = 'ABB'
	    AND    parameter_type = 'COMBO'
	    AND    parameter_category = 'CTRLACT'
	    AND    parameter_text = @controlactionenn
	    AND    language_id = @ctxt_language
	    ORDER BY
	           parameter_text
	END --Code added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 
	
	-- getting the year code
	EXEC abb_getyearcode @ctxt_ouinstance,
	     @ctxt_user,
	     @ctxt_language,
	     @companycode_tmp,
	     @financialyearrange,
	     @csdateformat_tmp,
	     @fbhdr,
	     @finyearcode_tmp OUTPUT,
	     @finyrstdt_tmp OUTPUT,
	     @finyrenddt_tmp OUTPUT,
	     @errid_tmp OUTPUT
	
	IF @yrprdchk_tmp <> 0
	    EXEC abb_getprdcode @ctxt_ouinstance,
	         @ctxt_user,
	         @ctxt_language,
	         @companycode_tmp,
	         @finyearcode_tmp,
	         @financeperiodrange,
	         @csdateformat_tmp,
	         @fbhdr,
	         @finprdcode_tmp OUTPUT,
	         @finprdstdt_tmp OUTPUT,
	         @finprdenddt_tmp OUTPUT,
	         @errid_tmp OUTPUT
	
	IF @finprdcode_tmp IS NULL
	    SELECT @finprdcode_tmp = '##'
	
	-- getting the from account code
	IF len(ISNULL(@accountcodefrom, '')) = 0 -- code Modified by Nehru D for ES_General_05265 
	    SELECT @accountcodefrom = 'null'
	ELSE
	BEGIN
	    SELECT @accountcodefrom_tmp = MIN(account_code)
	    FROM   fbp_accounts_vw(NOLOCK)
	    WHERE  company_code = @companycode_tmp
	    AND    fb_id = @fbhdr
	           /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	           /*and		account_currency	= @currency_code*/
	    AND    account_currency LIKE @currency_code
	           /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	    AND    (
	               account_code >= @accountcodefrom + '%'
	           OR  account_code LIKE @accountcodefrom + '%'
	           )
	    
	    -- Modified by Sridhar Siripuram for ABBRGGSYSTST_000021 begin
	    IF len(ISNULL(@accountcodefrom_tmp, '')) <> 0 -- code Modified by Nehru D for ES_General_05265 
	        SELECT @accountcodefrom = '''' + @accountcodefrom_tmp + ''''
	               -- Modified by Sridhar Siripuram for ABBRGGSYSTST_000021 end
	END 
	
	-- getting the to account code
	IF len(ISNULL(@accountcodeto, '')) = 0 -- code Modified by Nehru D for ES_General_05265
	    SELECT @accountcodeto = 'null' 
	ELSE
	BEGIN
	    SELECT @accountcodeto_tmp = MAX(account_code)
	    FROM   fbp_accounts_vw(NOLOCK)
	    WHERE  company_code = @companycode_tmp
	    AND    fb_id = @fbhdr
	           /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	           /*and		account_currency	= @currency_code*/
	    AND    account_currency LIKE @currency_code
	           /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	    AND    (
	               account_code <= @accountcodeto + '%'
	           OR  account_code LIKE @accountcodeto + '%'
	           )
	    
	    -- Modified by Sridhar Siripuram for ABBRGGSYSTST_000021 begin
	    IF len(ISNULL(@accountcodeto_tmp, '')) <> 0 -- code Modified by Nehru D for ES_General_05265
	        SELECT @accountcodeto = '''' + @accountcodeto_tmp + ''''
	               -- Modified by Sridhar Siripuram for ABBRGGSYSTST_000021 end
	END	
	
	IF CHARINDEX('*', @actiondescription) <> 0
	    SELECT @acc_desc_tmp = REPLACE(@actiondescription, '*', '%')
	ELSE
	    SELECT @acc_desc_tmp = @actiondescription
	
	IF @finprdcode_tmp IS NULL
	OR @finprdcode_tmp = '##'
	BEGIN
	    SELECT @qstr_tmp = 'select  distinct ''' + @guid + '''' + 
	           ', a.account_code, '
	    
	    SELECT @qstr_tmp = @qstr_tmp + 
	           ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase , a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase' --ES_ABB_00059:11H103_ABB_00001 -- 1_412_RCN_0468 / ABBDMS412AT_000065
	    SELECT @qstr_tmp = @qstr_tmp + 
	           ' from abb_account_budget_dtl a (nolock), fbp_accounts_vw c '
	    
	    SELECT @qstr_tmp = @qstr_tmp + 
	           ' where 	a.company_code 	= c.company_code'
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.fb_id 			= c.fb_id'
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.account_code 	= c.account_code'
	    SELECT @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
	    SELECT @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
	    SELECT @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''
	    SELECT @qstr_tmp = @qstr_tmp + ' and	a.company_code 	= ''' + @companycode_tmp 
	           + ''''
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr 
	           + ''''
	    /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	    /*select @qstr_tmp = @qstr_tmp + ' and   	a.control_action	= ''' + @ctrlact_tmp + ''''*/
	    SELECT @qstr_tmp = @qstr_tmp + ' and   	a.control_action	like ''' + @ctrlact_tmp 
	           + ''''
	    /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	    
	    IF len(ISNULL(@accountcodefrom, '')) > 0 -- code Modified by Nehru D for ES_General_05265 
	        SELECT @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' 
	               + @accountcodefrom + 
	               ',a.account_code) or a.account_code is null)'
	    
	    IF len(ISNULL(@accountcodeto, '')) > 0 -- code Modified by Nehru D for ES_General_05265
	        SELECT @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' 
	               + @accountcodeto + 
	               ',a.account_code) or a.account_code is null)'
	    
	    -- Code added by Sridhar siripuram for ABBRGGSYSTST_000019 begin
	    -- Code added by Sridhar siripuram for ABBRGGSYSTST_000023 begin 
	    IF @acgrpcode_tmp <> 'AL'
	    BEGIN
	        /*SP Modifcation For German Language Support Starts Here */
	        SELECT @acgrpcode_tmp = parameter_code 
	               -- 							WHEN 'A' THEN parameter_code
	               -- 							WHEN 'E' THEN parameter_code
	               -- 							WHEN 'R' THEN parameter_code
	               -- 							WHEN 'L' THEN parameter_code
	               -- 						   END
	        FROM   fin_quick_code_met(NOLOCK)
	        WHERE  component_id = 'ABB'
	        AND    parameter_type = 'COMBO'
	        AND    parameter_category = 'ACCGRP'
	        AND    parameter_text = @accountgroup
	        AND    language_id = @ctxt_language
	        GROUP BY
	               parameter_code
	        HAVING parameter_code IN ('A', 'E', 'R', 'L') 
	        
	        
	        -- 			select @acgrpcode_tmp = case @accountgroup
	        -- 								when 'ASSET' 		then 'A'
	        -- 								when 'EXPENSES' 	then 'E'
	        -- 								when 'REVENUE' 		then 'R'
	        -- 								when 'LIABILITIES' 	then 'L'
	        -- 							    end
	        /*SP Modifcation For German Language Support ends Here */
	        
	        SELECT @qstr_tmp = @qstr_tmp + ' and	c.account_group 	= ''' + 
	               @acgrpcode_tmp + ''''
	    END
	    -- Code added by Sridhar siripuram for ABBRGGSYSTST_000023 end
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp 
	           + ''''
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code	= ''##''' 
	    /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	    /*select @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	= ''' + @currency_code + ''''*/
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	like ''' + @currency_code 
	           + ''''
	    /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''' + @status_tmp 
	           + ''''
	    /* code added by Swetha for ABBDMS412AT_000070 on 27/9/2006 */
	    SELECT @qstr_tmp = @qstr_tmp + ' and   	c.language_id   	= ''' + 
	           CONVERT(nVARCHAR(100), @ctxt_language) + ''''
	    /* code added by Swetha for ABBDMS412AT_000070 on 27/9/2006 */
	    
	    SELECT @qstr1_tmp = 'insert into abb_account_budget_tmp '
	    SELECT @qstr1_tmp = @qstr1_tmp + 
	           ' (guid, account_code, currency_code , '
	    
	    SELECT @qstr1_tmp = @qstr1_tmp + 
	           ' budget_amount, control_action, timestamp, basecur_erate , parbasecur_erate , budamt_base , budamt_parbase, ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase)'--ES_ABB_00059:11H103_ABB_00001 -- 1_412_RCN_0468 / ABBDMS412AT_000065--modified for ES_ABB_00059[11H103_ABB_00001:11H103_ABB_00030] 
	    SELECT @qstr1_tmp = @qstr1_tmp + @qstr_tmp
	    
	    -- executing the dynamic query	
		--SQL injection correction
		--code modified for EPE-74350 starts	
		----EXEC sp_executesql @qstr1_tmp
		EXEC ES_executesql	@qstr1_tmp
		--code modified for EPE-74350 ends
	END
	ELSE
	BEGIN
	    SELECT @qstr_tmp = 'select ''' + @guid + '''' + ', a.account_code, '
	    SELECT @qstr_tmp = @qstr_tmp + 
	           ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase, a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase' --ES_ABB_00059:11H103_ABB_00001 -- 1_412_RCN_0468 / ABBDMS412AT_000065
	    SELECT @qstr_tmp = @qstr_tmp + 
	           ' from abb_account_budget_dtl a(nolock), fbp_accounts_vw c'
	    
	    SELECT @qstr_tmp = @qstr_tmp + 
	           ' where 	a.company_code 	= c.company_code'
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.fb_id 			= c.fb_id'
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.account_code 	= c.account_code'
	    SELECT @qstr_tmp = @qstr_tmp + ' and	c.account_status	= ''A'''
	    SELECT @qstr_tmp = @qstr_tmp + ' and	c.autopost_type 	is null ' 
	    SELECT @qstr_tmp = @qstr_tmp + ' and	c.account_class 	<> ''RETEARNINGS'''
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and	c.account_group 	<> ''C'''
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.company_code 	= ''' + @companycode_tmp 
	           + ''''
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and   	a.fb_id 			= ''' + @fbhdr 
	           + ''''
	    
	    -- Code added by Sridhar siripuram for ABBRGGSYSTST_000023 begin 		
	    IF @acgrpcode_tmp <> 'AL'
	  BEGIN
	        /*SP Modifcation For German Language Support Starts Here */
	        SELECT @acgrpcode_tmp = CASE parameter_code
	                                     WHEN 'A' THEN parameter_code
	                                     WHEN 'E' THEN parameter_code
	                                     WHEN 'R' THEN parameter_code
	                                     WHEN 'L' THEN parameter_code
	              END
	        FROM   fin_quick_code_met(NOLOCK)
	        WHERE  component_id = 'ABB'
	        AND    parameter_type = 'COMBO'
	        AND    parameter_category = 'ACCGRP'
	        AND    parameter_text = @accountgroup
	        AND    language_id = @ctxt_language
	        
	        
	        
	        
	        -- 			select @acgrpcode_tmp = case @accountgroup
	        -- 								when 'ASSET' 		then 'A'
	        -- 								when 'EXPENSES' 	then 'E'
	        -- 								when 'REVENUE' 		then 'R'
	        -- 								when 'LIABILITIES' 	then 'L'
	        -- 							    end
	        /*SP Modifcation For German Language Support ends Here */								
	        SELECT @qstr_tmp = @qstr_tmp + ' and	c.account_group 	= ''' + 
	               @acgrpcode_tmp + ''''
	    END
	    -- Code added by Sridhar siripuram for ABBRGGSYSTST_000023 end
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and	(a.account_code	>= isnull(' + @accountcodefrom 
	           + ', a.account_code) or a.account_code is null)'
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and	(a.account_code	<= isnull(' + @accountcodeto 
	           + ', a.account_code) or a.account_code is null)'
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and	a.fin_year_code	= ''' + @finyearcode_tmp 
	           + ''''
	    
	    SELECT @qstr_tmp = @qstr_tmp + ' and	a.fin_period_code	= ''' + @finprdcode_tmp 
	           + ''''
	    /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	    /*select @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	= ''' + @currency_code + ''''*/
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.account_currency 	like ''' + @currency_code 
	           + ''''
	    /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	    SELECT @qstr_tmp = @qstr_tmp + ' and 	a.status			= ''' + @status_tmp 
	           + ''''
	    /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	    /*select @qstr_tmp = @qstr_tmp + ' and   	a.control_action	= ''' + @ctrlact_tmp + ''''*/
	    SELECT @qstr_tmp = @qstr_tmp + ' and   	a.control_action	like ''' + @ctrlact_tmp 
	           + ''''
	    /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	    /* code added by Swetha for ABBDMS412AT_000070 on 27/9/2006 */
	    SELECT @qstr_tmp = @qstr_tmp + ' and   	c.language_id   	= ''' + 
	           CONVERT(nVARCHAR(100), @ctxt_language) + ''''
	    /* code added by Swetha for ABBDMS412AT_000070 on 27/9/2006 */
	    
	    SELECT @qstr1_tmp = 'insert into abb_account_budget_tmp '
	    SELECT @qstr1_tmp = @qstr1_tmp + 
	           ' (guid, account_code, currency_code , '
	    
	    SELECT @qstr1_tmp = @qstr1_tmp + 
	           ' budget_amount, control_action, timestamp,basecur_erate , parbasecur_erate , budamt_base , budamt_parbase , ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase)'--ES_ABB_00059:11H103_ABB_00001 -- 1_412_RCN_0468 / ABBDMS412AT_000065--modifiedfor ES_ABB_00059[11H103_ABB_00001:11H103_ABB_00030] 
	    SELECT @qstr1_tmp = @qstr1_tmp + @qstr_tmp
	    
	    -- executing the dynamic query	
		--SQL injection correction
		--code modified for EPE-74350 starts	
		----EXEC sp_executesql @qstr1_tmp
		EXEC ES_executesql	@qstr1_tmp
		--code modified for EPE-74350 ends
	END 
	

	--EPE-29128 starts
       if exists(select '*' from cps_workflowparam_sys 
                           where component_id = 'ABB' 
                           and  workflow_tran = 'CAAB' 
                           and  workflow_app  = 'Y'
                           and company_code   =  @companycode_tmp
						   and language_id    =  @ctxt_language
                     )
       begin  
              -- getting the from account code
              IF len(ISNULL(@accountcodefrom, '')) = 0 
                  SELECT @accountcodefrom = 'null'
              ELSE
              BEGIN
                  
                  IF len(ISNULL(@accountcodefrom_tmp, '')) <> 0 
                      SELECT @accountcodefrom = '''' + @accountcodefrom_tmp + ''''
              END 
              
              -- getting the to account code
              IF len(ISNULL(@accountcodeto, '')) = 0 
                  SELECT @accountcodeto = 'null' 
              ELSE
              BEGIN
                  
                  IF len(ISNULL(@accountcodeto_tmp, '')) <> 0 
                      SELECT @accountcodeto = '''' + @accountcodeto_tmp + ''''
              END    

              IF @finprdcode_tmp IS NULL OR @finprdcode_tmp = '##'
              BEGIN
                  SELECT @qstr_tmp = 'select  distinct ''' + @guid + '''' + 
                         ', a.account_code, '
                  
                  SELECT @qstr_tmp = @qstr_tmp + 
                         ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase , a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase,a.workflow_status'
                  SELECT @qstr_tmp = @qstr_tmp + 
                         ' from abb_account_budget_dtl_wf a (nolock), fbp_accounts_vw c '
                  
                  SELECT @qstr_tmp = @qstr_tmp + 
                         ' where   a.company_code       = c.company_code'
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.fb_id                    = c.fb_id'
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.account_code       = c.account_code'
                  SELECT @qstr_tmp = @qstr_tmp + ' and c.account_status				 = ''A'''
                  SELECT @qstr_tmp = @qstr_tmp + ' and c.autopost_type      is null ' 
                  SELECT @qstr_tmp = @qstr_tmp + ' and c.account_class      <> ''RETEARNINGS'''
                  
				  SELECT @qstr_tmp = @qstr_tmp + ' and c.account_group      <> ''C'''
                  SELECT @qstr_tmp = @qstr_tmp + ' and a.company_code       = ''' + @companycode_tmp 
                         + ''''
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.fb_id                    = ''' + @fbhdr 
                         + ''''
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.control_action     like ''' + @ctrlact_tmp 
                         + ''''
                  
                  IF len(ISNULL(@accountcodefrom, '')) > 0  
                      SELECT @qstr_tmp = @qstr_tmp + ' and    (a.account_code      >= isnull(' 
                             + @accountcodefrom + 
                             ',a.account_code) or a.account_code is null)'
                  
                  IF len(ISNULL(@accountcodeto, '')) > 0 
                      SELECT @qstr_tmp = @qstr_tmp + ' and    (a.account_code      <= isnull(' 
                             + @accountcodeto + 
                             ',a.account_code) or a.account_code is null)'
                  
                 
                  IF @acgrpcode_tmp <> 'AL'
                  BEGIN
                      SELECT @acgrpcode_tmp = parameter_code 
                      FROM   fin_quick_code_met(NOLOCK)
                      WHERE  component_id = 'ABB'
                      AND    parameter_type = 'COMBO'
                      AND    parameter_category = 'ACCGRP'
                      AND    parameter_text = @accountgroup
                      AND    language_id = @ctxt_language
                      GROUP BY
                             parameter_code
                      HAVING parameter_code IN ('A', 'E', 'R', 'L') 
      
                      
                      SELECT @qstr_tmp = @qstr_tmp + ' and    c.account_group      = ''' + 
                             @acgrpcode_tmp + ''''
                  END
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and a.fin_year_code      = ''' + @finyearcode_tmp 
                         + ''''
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and a.fin_period_code    = ''##''' 
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.account_currency   like ''' + @currency_code 
                         + ''''
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.status                   = ''IA'''                
                  SELECT @qstr_tmp = @qstr_tmp + ' and        c.language_id        = ''' + 
                         CONVERT(nVARCHAR(100), @ctxt_language) + ''''
                  
                  SELECT @qstr1_tmp = 'insert into abb_account_budget_tmp '
                  SELECT @qstr1_tmp = @qstr1_tmp + 
                         ' (guid, account_code, currency_code , '
                  
                  SELECT @qstr1_tmp = @qstr1_tmp + 
                         ' budget_amount, control_action, timestamp, basecur_erate , parbasecur_erate , budamt_base , budamt_parbase, ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase,workflow_status)'
                  SELECT @qstr1_tmp = @qstr1_tmp + @qstr_tmp
                  
                  -- executing the dynamic query	
				--SQL injection correction
				--code modified for EPE-74350 starts	
				----EXEC sp_executesql @qstr1_tmp
				EXEC ES_executesql	@qstr1_tmp
				--code modified for EPE-74350 ends
              END
              ELSE
              BEGIN
                  SELECT @qstr_tmp = 'select ''' + @guid + '''' + ', a.account_code, '
                  SELECT @qstr_tmp = @qstr_tmp + 
                         ' a.account_currency, a.budget_amount, a.control_action, a.timestamp,a.basecur_erate , a.parbasecur_erate , a.budamt_base , a.budamt_parbase, a.ForecastAmt , a.ForecastAmt_base , a.ForecastAmt_parbase,a.workflow_status' 
                  SELECT @qstr_tmp = @qstr_tmp + 
                         ' from abb_account_budget_dtl_wf a(nolock), fbp_accounts_vw c'
                  
                  SELECT @qstr_tmp = @qstr_tmp + 
                         ' where   a.company_code       = c.company_code'
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.fb_id                    = c.fb_id'
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.account_code       = c.account_code'
                  SELECT @qstr_tmp = @qstr_tmp + ' and c.account_status     = ''A'''
                  SELECT @qstr_tmp = @qstr_tmp + ' and c.autopost_type      is null ' 
                  SELECT @qstr_tmp = @qstr_tmp + ' and c.account_class      <> ''RETEARNINGS'''
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and c.account_group      <> ''C'''
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.company_code       = ''' + @companycode_tmp 
                         + ''''
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.fb_id                    = ''' + @fbhdr 
                         + ''''
                  
                  IF @acgrpcode_tmp <> 'AL'
                BEGIN
                      SELECT @acgrpcode_tmp = CASE parameter_code
                                                   WHEN 'A' THEN parameter_code
                                            WHEN 'E' THEN parameter_code
                                                   WHEN 'R' THEN parameter_code
                                                   WHEN 'L' THEN parameter_code
                            END
                      FROM   fin_quick_code_met(NOLOCK)
                      WHERE  component_id = 'ABB'
                      AND    parameter_type = 'COMBO'
                      AND    parameter_category = 'ACCGRP'
                      AND    parameter_text = @accountgroup
                      AND    language_id = @ctxt_language
                      
                      
                                                                                          
                  SELECT @qstr_tmp = @qstr_tmp + ' and    c.account_group      = ''' + 
                             @acgrpcode_tmp + ''''
                  END
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and (a.account_code      >= isnull(' + @accountcodefrom 
                         + ', a.account_code) or a.account_code is null)'
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and (a.account_code      <= isnull(' + @accountcodeto 
                         + ', a.account_code) or a.account_code is null)'
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and a.fin_year_code      = ''' + @finyearcode_tmp 
                         + ''''
                  
                  SELECT @qstr_tmp = @qstr_tmp + ' and a.fin_period_code    = ''' + @finprdcode_tmp 
                         + ''''
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.account_currency   like ''' + @currency_code 
                         + ''''
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.status                   = ''IA'''
                  SELECT @qstr_tmp = @qstr_tmp + ' and        a.control_action     like ''' + @ctrlact_tmp 
                         + ''''
                  SELECT @qstr_tmp = @qstr_tmp + ' and        c.language_id        = ''' + 
                         CONVERT(nVARCHAR(100), @ctxt_language) + ''''
                  
                  SELECT @qstr1_tmp = 'insert into abb_account_budget_tmp '
                  SELECT @qstr1_tmp = @qstr1_tmp + ' (guid, account_code, currency_code , '
                  SELECT @qstr1_tmp = @qstr1_tmp + 
                         ' budget_amount, control_action, timestamp,basecur_erate , parbasecur_erate , budamt_base , budamt_parbase , ForecastAmt ,ForecastAmt_base , ForecastAmt_parbase,workflow_status)'
                  SELECT @qstr1_tmp = @qstr1_tmp + @qstr_tmp
                  
                  -- executing the dynamic query	
				--SQL injection correction
				--code modified for EPE-74350 starts	
				----EXEC sp_executesql @qstr1_tmp
				EXEC ES_executesql	@qstr1_tmp
				--code modified for EPE-74350 ends
      END
	END
	--EPE-29128 ends

	--updating account desc and account group from fbp_accounts_vw
	UPDATE abb_account_budget_tmp
	SET    abb_account_budget_tmp.account_group = b.account_group,
	       abb_account_budget_tmp.account_desc = mlt1.account_desc
	FROM   fbp_accounts_vw b,
	       fbp_accounts_Ml_vw mlt1(NOLOCK)
	WHERE  abb_account_budget_tmp.guid = @guid
	AND    b.fb_id = @fbhdr
	AND    b.company_code = @companycode_tmp
	AND    abb_account_budget_tmp.account_code = b.account_code
	AND    mlt1.fb_id = @fbhdr
	AND    mlt1.company_code = @companycode_tmp
	AND    abb_account_budget_tmp.account_code = mlt1.account_code
	AND    mlt1.language_id = @ctxt_language 
	
	
	IF @finprdcode_tmp = '##'
	BEGIN
	    DECLARE account_cursor CURSOR  
	    FOR
	        SELECT DISTINCT account_code
	        FROM   abb_account_budget_tmp(NOLOCK)
	        WHERE  guid = @guid
	    
	    OPEN account_cursor
	    
	    WHILE 1 = 1
	    BEGIN
	        FETCH NEXT FROM account_cursor INTO @accountcode_tmp
	        
	        IF @@fetch_status <> 0
	            BREAK
	        
	        SELECT @utilized_amount_tmp = 0
	        
	        SELECT @utilized_amount_tmp = CASE 
	                                           WHEN a.account_group IN ('R', 'C', 'L') THEN 
	                                                ISNULL(SUM(period_credit), 0) 
	                                                - ISNULL(SUM(period_debit), 0)
	                                           ELSE ISNULL(SUM(period_debit), 0) 
	                                                - ISNULL(SUM(period_credit), 0)
	                                      END
	        FROM   fbp_account_balance_vw b,
	               abb_account_budget_tmp a(NOLOCK)
	        WHERE  a.account_code = b.account_code
	        AND  b.company_code = @companycode_tmp
	        AND    b.fb_id = @fbhdr
	               /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	               /*and		b.currency_code					= @currency_code*/
	        AND    b.currency_code LIKE @currency_code
	               /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	        AND    b.fin_year_code = @finyearcode_tmp
	        AND    a.account_code = @accountcode_tmp
	        AND    a.guid = @guid
	        GROUP BY
	               account_group
	        
	        UPDATE abb_account_budget_tmp
	        SET    utilized_amount = @utilized_amount_tmp
	        WHERE  guid = @guid
	        AND    account_code = @accountcode_tmp
	    END 
	    
	    CLOSE account_cursor
	    DEALLOCATE account_cursor
	END
	ELSE
	BEGIN
	    --updating the utilized amount
	    UPDATE abb_account_budget_tmp
	    SET    abb_account_budget_tmp.utilized_amount = CASE 
	                                                         WHEN account_group IN ('R', 'C', 'L') THEN 
	                                                              ISNULL(period_credit, 0) 
	                                                              - ISNULL(period_debit, 0)
	                                                         ELSE ISNULL(period_debit, 0) 
	                                                              - ISNULL(period_credit, 0)
	                                                    END
	    FROM   fbp_account_balance_vw b
	    WHERE  b.fb_id = @fbhdr
	    AND    b.company_code = @companycode_tmp
	    AND    abb_account_budget_tmp.account_code = b.account_code
	    AND    b.fin_year_code = @finyearcode_tmp
	    AND    b.fin_period_code = @finprdcode_tmp
	           /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 starts here */
	           /*and		b.currency_code					= @currency_code*/
	    AND    b.currency_code LIKE @currency_code
	           /* Code Commented and added by Poorna R for the Case id ES_ABB_00033 on 28/01/2010 ends here */
	    AND    abb_account_budget_tmp.guid = @guid
	END
	
	--Template Select Statement for Selecting data to App Layer
	IF @acgrpcode_tmp = 'AL'
	    SELECT 'ACCOUNTCODEML' = account_code,
	           'ACCOUNTGROUPML' = b.parameter_text,
	           'BUDGETAMOUNT' = budget_amount,
	           'CURRENCY' = currency_code,
	           'DESC40' = account_desc,
	           'FINANCEYRPERIOD' = @finyrprd_tmp,
	           'UTILIZEDAMOUNT' = utilized_amount,
	           /* Code Added by Esther J on 17-07-2006 for 1_412_RCN_0468 / ABBDMS412AT_000065 starts */
	           'BASECURRERATE' = basecur_erate,
	           'PBASECURRERATE' = parbasecur_erate,
	           'BASECURRBUDAMT' = budamt_base,
	           'PBASECURRBUDAMT' = budamt_parbase 
	           /* Code Added by Esther J on 17-07-2006 for 1_412_RCN_0468 / ABBDMS412AT_000065 ends */
				,'ForecastAmt'			= ForecastAmt--ES_ABB_00059:11H103_ABB_00001
				,'WorkflowStatusml'  = workflow_status
	    FROM   abb_account_budget_tmp a(NOLOCK)
	           LEFT	JOIN fin_quick_code_met b(NOLOCK)
	   ON  a.account_group = b.parameter_code
	    AND             b.component_id = 'ABB'
	    AND             b.parameter_type = 'COMBO'
	    AND             b.parameter_category = 'ACCGRP'
	    AND             b.language_id = @ctxt_language
	    WHERE  guid = @guid
	    AND    UPPER(a.account_desc) LIKE @acc_desc_tmp + '%'
	    ORDER BY
	           b.parameter_text,
	           account_code
	ELSE
	    SELECT 'ACCOUNTCODEML' = account_code,
	           'ACCOUNTGROUPML' = b.parameter_text,
	           'BUDGETAMOUNT' = ISNULL(budget_amount, 0),
	           'CURRENCY' = currency_code,
	           'DESC40' = account_desc,
	           'FINANCEYRPERIOD' = @finyrprd_tmp,
	           'UTILIZEDAMOUNT' = ISNULL(utilized_amount, 0),
	           /* Code Added by Esther J on 17-07-2006 for 1_412_RCN_0468 / ABBDMS412AT_000065 starts */
	           'BASECURRERATE' = basecur_erate,
	           'PBASECURRERATE' = parbasecur_erate,
	           'BASECURRBUDAMT' = budamt_base,
	           'PBASECURRBUDAMT' = budamt_parbase 
	           /* Code Added by Esther J on 17-07-2006 for 1_412_RCN_0468 / ABBDMS412AT_000065 ends */
			,'ForecastAmt'			= ForecastAmt--ES_ABB_00059:11H103_ABB_00001
			,'WorkflowStatusml'  = workflow_status
	    FROM   abb_account_budget_tmp a(NOLOCK)
	           LEFT	JOIN fin_quick_code_met b(NOLOCK)
	                ON  a.account_group = b.parameter_code
	    AND             b.component_id = 'ABB'
	    AND             b.parameter_type = 'COMBO'
	    AND             b.parameter_category = 'ACCGRP'
	    AND             b.language_id = @ctxt_language
	    WHERE  guid = @guid
	    AND    UPPER(a.account_desc) LIKE @acc_desc_tmp + '%'
	    AND    account_group = @acgrpcode_tmp
	    ORDER BY
	           b.parameter_text,
	           account_code
	-- Code added by Sridhar siripuram for ABBRGGSYSTST_000019 end
	
	-- deleting the records in the temp table
	DELETE abb_account_budget_tmp
	WHERE  guid = @guid
	
	SET NOCOUNT OFF
END


