/*$File_version=ms4.3.0.09$*/
/************************************************************************************
 procedure name and id   abredbstspfetml
 description
 name of the author      Shamim Basheer
 date created            03-Sep-2002
 query file name         abredbstspfetml.sql
 modifications history
 modified by		 Nitin
 modified date		 18-07-2003
 modified purpose	 ABRRGGSYSTST_000051
 Version		: 4.1.2.001

/* Added by Malika P for the bug_id: HBDRGGSYSTST_000038 */
/* Addition starts */
/* Addition ends */
/* Modified By		Date		Remarks
Vairamani C		Sep 18 2006	ABRDMS412AT_000060
Vairamani C		Nov 12 2007	ABRDMS412AT_000134 -- ABR Changes (Code Revamped)
Selvan.G		Nov 29 2007	ABRDMS412AT_000136
Vairamani C		Mar 01 2008	DMS412AT_ABR_00005
Vairamani C		Mar 24 2008	DMS412AT_ABR_00075/108/109/110/112/113
Anusha.p        10/11/2017           epe-3918
Kiran Kumar Minuku 17-03-2022        EPE-43205
Banurekha B     25/10/2023           MCHS-866   
*/
************************************************************************************/
create procedure abredbstspfetml
	@bankaccountnumber                 fin_banknumber,
	@banknohdr                         fin_bankname,
	@closbal                           fin_amount,
	@createddate                       fin_date,
	@creationby                        fin_ctxt_user,
	@ctxt_language                     fin_ctxt_language,
	@ctxt_ouinstance                   fin_ctxt_ouinstance,
	@ctxt_service                      fin_ctxt_service,
	@ctxt_user                         fin_ctxt_user,
	@debitcredit                       fin_drcridentifier,
	@debitcredit1                      fin_drcridentifier,
	@guid                              fin_guid,
	@hidden_control1                   fin_hiddencontrol,
	@lastmodificationby                fin_ctxt_user,
	@lastmodifieddate                  fin_date,
	@opbal                             fin_amount,
	@statementno1                      fin_statementnumber, /* Code Modified for DMS412AT_ABR_00005 */
	@statenddt                         fin_date,
	@statstdt                          fin_date,
	@timestamp1                        fin_timestamp,
	@m_errorid                         fin_int output --to return execution status
as
begin
	set nocount on

	declare @pqty_tmp                  fin_int ,
		@pamt_tmp                  fin_int ,
		@prate_tmp                 fin_int ,
		@perate_tmp                fin_int ,
		@phigh_tmp                 fin_int ,
		@pmed_tmp                  fin_int ,
		@plow_tmp                  fin_int

	/* Added by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on starts*/
	Declare @compref_tmp	fin_checknumber
	/* Added by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on Ends*/
	
	exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
		@prate_tmp output, @perate_tmp output, @phigh_tmp output,
		@pmed_tmp output, @plow_tmp output
	
	/* Code Modified by Vairamani for ABRDMS412AT_000134 Starts here */
	declare --@guid_tmp			fin_guid, -- commented for SCRA Validations exceptions in id MCHS-866
		@amount_tmp			fin_amount,
		@drcr_tmp			fin_drcridentifier,
		@serialno_tmp			fin_number,
		@date				fin_date,
		@payinslipnumberml         	fin_documentnumber,
		@prefix_mul                	fin_prefix,
		@transactiontypeml         	fin_transactiontype,
		@depositingpoint           	fin_ouinstname,
		--@companyreference          	fin_checknumber, -- commented for SCRA Validations exceptions in id MCHS-866
	  /*  
 /* code commented by Muniraj for the DTS : ES_ABR_00092 starts */  
 @brsremarkml1                      fin_desc40,  
 /* code commented by Muniraj for the DTS : ES_ABR_00092 ends */  
 */  
 /* code Added by Muniraj for the DTS : ES_ABR_00092 starts */  
 @brsremarkml1                      fin_desc1000,--fin_text255,--EPE-43205  
 /* code Added by Muniraj for the DTS : ES_ABR_00092 ends */  
		@checknumber               	fin_checknumber,
		@runningbalance		  	fin_amount,
		--@csdateformat_tmp		fin_csdtfmt,-- commented for SCRA Validations exceptions in id MCHS-866
		@bankno_tmp			fin_documentno,
		@companycode_tmp		fin_companycode,
		/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
		@sysdt_tmp			fin_date,
		@recon_status			fin_status,
		@recon_status_desc		fin_param_text,
		@transactiontypeml_tmp         	fin_transactiontype,
		@depositingpoint_tmp		fin_bankcode,
		/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */
		@bankreference      	fin_desc40   --epe-3918

	select @m_errorid =0
	
	select @bankaccountnumber   = ltrim(rtrim(@bankaccountnumber))
	select @banknohdr           = ltrim(rtrim(@banknohdr))
	select @createddate         = ltrim(rtrim(@createddate))
	select @creationby          = ltrim(rtrim(@creationby))
	select @ctxt_service        = ltrim(rtrim(@ctxt_service))
	select @ctxt_user           = ltrim(rtrim(@ctxt_user))
	select @debitcredit         = ltrim(rtrim(@debitcredit))
	select @debitcredit1        = ltrim(rtrim(@debitcredit1))
	select @guid                = ltrim(rtrim(@guid))
	select @hidden_control1     = ltrim(rtrim(@hidden_control1))
	select @lastmodificationby  = ltrim(rtrim(@lastmodificationby))
	select @lastmodifieddate    = ltrim(rtrim(@lastmodifieddate))
	select @statementno1        = ltrim(rtrim(@statementno1))
	select @statenddt    	    = ltrim(rtrim(@statenddt))
	select @statstdt            = ltrim(rtrim(@statstdt))
	
	if @bankaccountnumber   = '~#~'             select @bankaccountnumber   = null
	if @banknohdr           = '~#~'             select @banknohdr           = null
	if @closbal             = -915              select @closbal             = null
	if @createddate         = '01/01/1900'      select @createddate         = null
	if @creationby          = '~#~'             select @creationby          = null
	if @ctxt_language       = -915              select @ctxt_language       = null
	if @ctxt_ouinstance     = -915              select @ctxt_ouinstance     = null
	if @ctxt_service        = '~#~'             select @ctxt_service        = null
	if @ctxt_user           = '~#~'             select @ctxt_user           = null
	if @debitcredit         = '~#~'             select @debitcredit         = null
	if @debitcredit1        = '~#~'             select @debitcredit1        = null
	if @guid                = '~#~'             select @guid                = null
	if @hidden_control1     = '~#~'             select @hidden_control1     = null
	if @lastmodificationby  = '~#~'             select @lastmodificationby  = null
	if @lastmodifieddate    = '01/01/1900'      select @lastmodifieddate    = null
	if @opbal               = -915              select @opbal               = null
	if @statementno1        = '~#~'             select @statementno1        = null
	if @statenddt           = '01/01/1900'      select @statenddt           = null
	if @statstdt            = '01/01/1900'      select @statstdt            = null
	if @timestamp1          = -915              select @timestamp1          = null
	
	--Clear temp table.
	/* Code Modified by Vairamani for DMS412AT_ABR_00075/108/109/110/112/113 Starts here */
	if exists
	(
		select	'X'
		from	abr_stmt_book_tmp (nolock)
		where	guid	= @guid
	)
	begin
		delete 	from	abr_stmt_book_tmp
		where	guid	= @guid
	end
	/* Code Modified by Vairamani for DMS412AT_ABR_00075/108/109/110/112/113 Ends here */
	
	--exec  emod_sysact_spgetdatefmt @ctxt_ouinstance,@ctxt_user,@csdateformat_tmp output

	select @sysdt_tmp = convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120)

	-- Get the company code.
	select	@companycode_tmp	= company_code
	from	emod_ou_vw (nolock)
	where	ou_id			= @ctxt_ouinstance
	and	@sysdt_tmp between effective_from 
		and isnull(effective_to, @sysdt_tmp)

	-- Get Bank Code for the Bank Account Number.
	select	top 1
		@bankno_tmp		= bank_code
	from	bnkdef_code_mst BNK (nolock)
	where	BNK.bank_acc_no		= @bankaccountnumber
	and	BNK.company_code	= @companycode_tmp
	and	BNK.flag		= 'B'
	and 	BNK.status		= '2'
	
	--Getting the code for debit credit identifier
	select	@drcr_tmp		= parameter_code
	from	fin_quick_code_met(nolock)
	where	component_id		= 'ABR'
	and	parameter_type		= 'COMBO'
	and	parameter_category	= 'DRCR'
	and	parameter_text		= @debitcredit
	and	language_id		= @ctxt_language
	
	if	@drcr_tmp = 'CR'
		select	@opbal	=	@opbal
	else
		select	@opbal	=	@opbal * -1

	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	/*
		BR - M32ABR004 -- Fetch details
		For the Statement Number fetch both reconciled and unreconciled transaction in the ML
		BR - M32ABR005 -- Status Default
		Default the status of the transaction in each Multiline as Reconcilled or Unreconcilled. 
	*/

	declare abr_cursor cursor for
	select	A.serial_no, A.tran_amount, A.tran_remarks, A.check_no, A.tran_date,
		A.ou_id, A.payinslip_no, A.prefix, A.tran_type
		/* Added by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on starts*/
		,A.comp_reference, A.recon_status ,A.bank_ref_no  --epe-3918
		/* Added by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on Ends*/
	from  	abr_bank_statement_dtl A (nolock),
		abr_bank_statement_hdr B (nolock)
	where 	A.stmt_no 		=  B.stmt_no
	--and	A.bank_code 		=  B.bank_code
	--and	A.bank_code 		=  @bankno_tmp
	and	B.stmt_start_date	=  @statstdt
	and	B.stmt_end_date		=  @statenddt
	and	A.stmt_no 		=  @statementno1
	and	A.company_code		=  B.company_code
	and	A.company_code		=  @companycode_tmp
	and	A.bank_acc_no		=  B.bank_acc_no
	and	isnull(A.tran_amount,0) > 0 /* Code Added for ABRDMS412AT_000060 */
	order by A.serial_no --MCHS-866

	open abr_cursor

	while 1=1
	begin
		fetch next from abr_cursor into 
		@serialno_tmp,@amount_tmp,@brsremarkml1,@checknumber,@date	,
		@depositingpoint,@payinslipnumberml,@prefix_mul,@transactiontypeml
		/* Added by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on starts*/
		,@compref_tmp, @recon_status , @bankreference  --epe-3918
		/* Added by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on Ends*/
		
		if @@fetch_status	<>	0
			break

		--select @transactiontypeml_tmp = @transactiontypeml

		--get the transaction type
		select	@transactiontypeml_tmp	= parameter_text
		from	fin_quick_code_met(nolock)
		where	component_id		= 'ABR'
		and	parameter_type		= 'COMBO'
		and	parameter_category	= 'TRANTYPE'
		and	parameter_code		= @transactiontypeml
		and	language_id		= @ctxt_language

		select	@recon_status_desc	= parameter_text
		from	fin_quick_code_met(nolock)
		where	component_id		= 'ABR'
		and	parameter_type		= 'STATUS'
		and	parameter_category	= 'DOCSTATUS'
		and	parameter_code		= @recon_status
		and	language_id		= @ctxt_language
		
		if @transactiontypeml  in ('PY','ID','SC','CP')
			select	@amount_tmp	= @amount_tmp * -1
		else
			select	@amount_tmp	= @amount_tmp 

		-- get the running balance
		if not exists	(	
					select	'1'
					from	abr_stmt_book_tmp(nolock)
					where	guid		= @guid
					--and	bank_code	= @bankno_tmp  
				)
		begin
			select @runningbalance = @opbal + @amount_tmp
			select @serialno_tmp   = 1		
		end
		else
		begin
			-- get the serial no
			select	@serialno_tmp 	= max(serial_no)
			from	abr_stmt_book_tmp(nolock)
			where	guid		= @guid
			--and	bank_code	= @bankno_tmp
			
			-- get the latest running balance
			select	@runningbalance	= run_bal
			from	abr_stmt_book_tmp(nolock)
			where	guid		= @guid
			--and	bank_code	= @bankno_tmp
			and	serial_no	= @serialno_tmp
		
			select 	@runningbalance = @runningbalance + @amount_tmp
			select	@serialno_tmp	= @serialno_tmp	+ 1
		end

		if @amount_tmp < 0
			select @amount_tmp = @amount_tmp * -1

		select @depositingpoint_tmp = @depositingpoint

		if @depositingpoint <> 0
		begin
			select  @depositingpoint_tmp 	= ouinstname  
			from    fw_admin_view_ouinstance  (nolock)
			where 	ouinstid 		= @depositingpoint  
		end
		else
		begin
			select @depositingpoint_tmp = null
		end

		-- insert into tmp table if the record is unreconciled.
		/* Modified by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on starts*/
		insert into abr_stmt_book_tmp
		(
			guid,bank_code,stmt_no,serial_no,
			tran_amount,
			tran_remarks,check_no,tran_date,
			ou_id,payinslip_no,prefix,
			run_bal,
			tran_type,flag,timestamp,comp_reference,
			recon_status,ou_name,tran_type_desc,recon_status_desc,bank_ref_no  --epe-3918
		)
		values
		(
			@guid,@bankno_tmp,@statementno1,@serialno_tmp,
			round(@amount_tmp,@pamt_tmp),
			@brsremarkml1,@checknumber,@date,
			@depositingpoint,@payinslipnumberml,@prefix_mul,
			round(@runningbalance,@pamt_tmp),
			@transactiontypeml,'S',1,@compref_tmp,
			@recon_status, @depositingpoint_tmp,@transactiontypeml_tmp,@recon_status_desc, @bankreference --epe-3918
		)
		/* Modified by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on Ends*/
	end
	close abr_cursor
	deallocate abr_cursor

	--Output.
	select
		'amount'		= TMP.tran_amount,
		'brsremarkml1'		= TMP.tran_remarks,
		'checknumber'		= TMP.check_no,
		'companyreference'	= TMP.comp_reference,--'',
		'date'			= TMP.tran_date,
		'depositingpoint'	= TMP.ou_name,
		'linenumber'		= TMP.serial_no,
		'payinslipnumberml'	= TMP.payinslip_no,
		'prefix_mul'		= TMP.prefix,
		'runningbalance'	= TMP.run_bal,
		'transactiontypeml'	= TMP.tran_type_desc,
		'status'		= TMP.recon_status_desc,
		TMP.serial_no,
		'bankreference'  =  bank_ref_no    --epe-3918
	from	abr_stmt_book_tmp	TMP(nolock)
	where	TMP.guid		=  @guid
	order by TMP.serial_no

	/* Code Modified by vairamani for DMS412AT_ABR_00075/108/109/110/112/113 Starts here */
	if exists
	(
		select	'X'
		from	abr_stmt_book_tmp (nolock)
		where	guid	= @guid
	)
	begin
		delete from abr_stmt_book_tmp
		where guid = @guid
	end
	/* Code Modified by vairamani for DMS412AT_ABR_00075/108/109/110/112/113 Ends here */

	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */
-- 	--Output.
-- 	select
-- 		'amount'		= TMP.tran_amount,
-- 		'brsremarkml1'		= TMP.tran_remarks,
-- 		'checknumber'		= TMP.check_no,
-- 		/* Modified by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on starts*/
-- 		'companyreference'	= TMP.comp_reference,--'',
-- 		/* Modified by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on Ends*/
-- 		/* Code Modified By Selvan.G For the Bug Id : ABRDMS412AT_000136 Starts Here */	
-- 		--'date'			= dbo.fin_dateinuserformat(TMP.tran_date,@csdateformat_tmp),
-- 		'date'			= TMP.tran_date,
-- 		/* Code Modified By Selvan.G For the Bug Id : ABRDMS412AT_000136 Ends Here */	
-- 		'depositingpoint'	= FW.ouinstname,
-- 		'linenumber'		= TMP.serial_no,
-- 		'payinslipnumberml'	= TMP.payinslip_no,
-- 		'prefix_mul'		= TMP.prefix,
-- 		'runningbalance'	= TMP.run_bal,
-- 		'transactiontypeml'	= MET.parameter_text,
-- 		'status'		= '',
-- 		TMP.serial_no
-- 	from	abr_stmt_book_tmp	TMP(nolock),
-- 		fin_quick_code_met	MET(nolock),
-- 		fw_admin_view_ouinstance FW(nolock)
-- 	where	TMP.guid		=  @guid
-- 	--and	TMP.bank_code		=  @bankno_tmp
-- 	and	TMP.ou_id		=  FW.ouinstid	
-- 	and	TMP.tran_type		=  MET.parameter_code
-- 	and	MET.component_id	=  'ABR'
-- 	and	MET.parameter_type	=  'COMBO'
-- 	and	MET.parameter_category	=  'TRANTYPE'
-- 	and	MET.language_id		=  @ctxt_language
-- 	and	TMP.ou_id		<> 0
-- 	union
-- 	select
-- 		'amount'		= TMP.tran_amount,
-- 		'brsremarkml1'		= TMP.tran_remarks,
-- 		'checknumber'		= TMP.check_no,
-- 		/* Modified by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on starts*/
-- 		'companyreference'	= TMP.comp_reference,--'',
-- 		/* Modified by Nitin For Bug Id ABRRGGSYSTST_000051 on 18/07/03 on Ends*/	
-- 		/* Code Modified By Selvan.G For the Bug Id : ABRDMS412AT_000136 Starts Here */	
-- 		--'date'			= dbo.fin_dateinuserformat(TMP.tran_date,@csdateformat_tmp),
-- 		'date'			= TMP.tran_date,
-- 		/* Code Modified By Selvan.G For the Bug Id : ABRDMS412AT_000136 Ends Here */	
-- 		'depositingpoint'	= null,
-- 		'linenumber'		= serial_no,
-- 		'payinslipnumberml'	= TMP.payinslip_no,
-- 		'prefix_mul'		= TMP.prefix,
-- 		'runningbalance'	= TMP.run_bal,
-- 		'transactiontypeml'	= MET.parameter_text,
-- 		'status'		= '',
-- 		TMP.serial_no
-- 	from	abr_stmt_book_tmp	TMP(nolock),
-- 		fin_quick_code_met	MET(nolock)
-- 	where	TMP.guid		= @guid
-- 	--and	TMP.bank_code		= @bankno_tmp
-- 	and	TMP.tran_type		= MET.parameter_code
-- 	and	MET.component_id	= 'ABR'
-- 	and	MET.parameter_type	= 'COMBO'
-- 	and	MET.parameter_category	= 'TRANTYPE'
-- 	and	MET.language_id		= @ctxt_language
-- 	and	TMP.ou_id		= 0
-- 	order by TMP.serial_no
-- 
-- 	/* Code Modified by Vairamani for ABRDMS412AT_000134 Ends here */

	set nocount off
end












