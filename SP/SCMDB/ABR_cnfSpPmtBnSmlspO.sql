/*$File_version=MS4.3.0.02$*/
/******************************************************************************/
/* Procedure					: ABR_cnfSpPmtBnSmlspO      				  */
/* Description					: 								              */
/******************************************************************************/
/* Project						: 								              */
/* EcrNo						: 								              */
/* Version						: 								              */
/******************************************************************************/
/* Referenced					: 								              */
/* Tables						: 								              */
/******************************************************************************/
/* Development history			: 								              */
/******************************************************************************/
/* Author						: Anusha.p   								  */
/* Date							: Feb  6 2018  6:49PM						  */
/******************************************************************************/
/* Modification History			: 								              */
/******************************************************************************/
/* Modified By					: 								              */
/* Date							: 								               */
/* Description					: 								               */
/*Amani.P						28/06/2018							EPE-7274  */
/* Ashok V						23/09/2022							TVIE-496  */
/******************************************************************************/

Create Procedure ABR_cnfSpPmtBnSmlspO
	@ctxt_ouinstance   	fin_ctxt_ouinstance, --Input 
	@ctxt_user         	fin_ctxt_user, --Input 
	@ctxt_language     	fin_ctxt_language, --Input 
	@ctxt_service      	fin_ctxt_service, --Input 
	@bankaccountnumber 	fin_banknumber, --Input 
	@guid              	fin_guid, --Input 
	@statementperiod   	fin_text255, --Input 
	@m_errorid         	int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	select @m_errorid = 0

	--declaration of temporary variables
	declare @gu_id    		fin_guid    
    declare @bnkcurr   		fin_currencycode      
    declare @flag    		fin_flag    
    declare @err_id 		fin_int    
    declare @err_msg 		fin_errordesc
    declare @companycode	fin_companycode
	declare @companydesc	    fin_companydesc    
	declare @ouinstdesc  	    fin_desc40     
	declare @sysdt_tmp	    	fin_date
	declare @bankname	    	fin_description  
	declare @bal_book_register  fin_amount  
	declare @diff_amount	    fin_amount
	declare @additions_amount   fin_amount
	declare @deductions_amount  fin_amount
	declare @bank_bal_add	    fin_amount
	declare	@book_bal_ded	    fin_amount
	declare	@net_balance	    fin_amount
	declare @asondate           fin_date,
	@bankbal           	fin_amount, 
	@bookbal           	fin_amount, 
	@deductions        	fin_amount, 
	@difference        	fin_amount,
	@totaladdition     	fin_amount, --Input/Output
	@totaldeduction    	fin_amount

	--temporary and formal parameters mapping

	select @ctxt_user          = ltrim(rtrim(@ctxt_user))
	select @ctxt_service       = ltrim(rtrim(@ctxt_service))
	select @bankaccountnumber  = ltrim(rtrim(@bankaccountnumber))
	select @guid               = ltrim(rtrim(@guid))
	select @statementperiod    = ltrim(rtrim(@statementperiod))

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @bankaccountnumber = '~#~' 
		Select @bankaccountnumber = null  

	IF @guid = '~#~' 
		Select @guid = null  

	IF @statementperiod = '~#~' 
		Select @statementperiod = null  

	 select @sysdt_tmp = convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120)

    -- Get the company code.
    select  @ouinstdesc 	= ouinstname,
	    	@companycode	= company_code
    from    emod_ou_vw (nolock)
    where  ou_id			= @ctxt_ouinstance
    and	    @sysdt_tmp between effective_from 
    and	    isnull(effective_to, @sysdt_tmp)

    select  @companydesc 	= company_name
    from    emod_company_mst_vw (nolock)
    where   company_code 	= @companycode

    
   
    select  @bankname	    = ltrim(rtrim(bank_name))
    from    bnkdef_sysact_bank_vw (nolock)
    where   company_code    = @companycode
    and	    bank_acc_no	    = @bankaccountnumber

    select 	@asondate =  convert(date ,substring(@statementperiod,13,23))

	 exec @err_id  = abr_is_brs1 
			@ctxt_language,@ctxt_ouinstance ,@ctxt_service,@ctxt_user,  
			@bankaccountnumber ,@asondate,    
			@gu_id  out,    
			@bankname out,    
			@bnkcurr out,    
			@bankbal out,    
			@bookbal out,    
			@totaladdition out,    
			@totaldeduction out,    
			@difference out,    
			@flag  out    

    if @err_id =1        
    begin        
		--'Provide OUInstance'        
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,45
		return
    end        

    if @err_id =2        
    begin        
		--'Provide Bank Account Number'        
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,46
		return
    end        

    if @err_id =3        
    begin        
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,47
		return
		--'Provide Date'        
    end
	if @ctxt_user = '$debug_user'
	 begin
	   select * from  abr_fbpbankbook_tmp (nolock)
		where	guid	          =	@gu_id  
		and     display_option    = 'Additions' 
		and     display_remarks   = 'Payments in Bank Statement but not in Bank Book' 
	 end

	
	Select
		isnull(tran_amount,0)    'amount', 
		check_no                 'checknumber', 
		tran_type_desc           'companyreference', 
		/*@asondate*/tran_date   'date', --code modified for TVIE-496 
		deposit_ou               'depositingpoint', 
		isnull(document_no ,'')  'documentno', 
		payinslip_no             'payinslipnumberml', 
		tran_remarks             'remarksml', 
		ou_name                  'transactionou', 
		tran_type_desc           'transactiontypeml' 
		--EPE-7274
		,bank_ref_no			 'bank_reference_no', 
		payee_name				'payee', 
		createdby				'created_by', 
		modifiedby				'lastmodi_by', 
		 datediff(dd,@sysdt_tmp,recon_date)			'pending_days'
		--EPE-7274
		from    abr_fbpbankbook_tmp (nolock)
		where	guid	          =	@gu_id  
		and     display_option    = 'Additions' 
		and     display_remarks   = 'Payments in Bank Statement but not in Bank Book' 


	/* 
	--OutputList
		Select
		null 'amount', 
		null 'checknumber', 
		null 'companyreference', 
		null 'date', 
		null 'depositingpoint', 
		null 'documentno', 
		null 'payinslipnumberml', 
		null 'remarksml', 
		null 'transactionou', 
		null 'transactiontypeml', 
	*/
	
Set nocount off

End








