/*$File_version=MS4.3.0.01$*/
/******************************************************************************/
/* Procedure					: ABRmareenSpAbrrurmlbanbspO				  */
/* Description					: 											  */
/******************************************************************************/
/* Project						: MCL										  */
/* EcrNo						: ABR_ECR_00023								  */
/* Version						: 1											  */
/******************************************************************************/
/* Referenced					: 											  */
/* Tables						: 											  */
/******************************************************************************/
/* Development history			: 											  */
/******************************************************************************/
/* Author						: Ramkumar.A								  */
/* Date							: Jun  3 2010  5:07PM						  */
/******************************************************************************/
/* Modification History			: 											  */
/******************************************************************************/
/* Modified By					: Ramkumar A								  */
/* Date							: 28-06-2010								  */
/* Description					: 9I121_abr_00021							  */
/* Viji						08-sep-10			10I133_ABR_00015			  */
/* Viji						19-sep-10			10I133_ABR_00019			  */
/* Viji						04-mar-11			10I133_callid_00001			  */
/* Jakir					14/09/2011			11i130_callid_00002			  */		
/* Anand					14/09/2011			11i130_callid_00002			  */
/* Ravi						15/12/2011			10I133_abr_00048			  */
/* Sreenivasa Kumar Reddy.V	01-Nov-2012			12I205_abr_00010			  */
/* Thiyagarajan.S			30-Aug-2013			13I152ES_abr_00002			  */
/* Anitha N					13I152ES_abr_00003	06-May-2014					  */
/* Mabel Rita               07/04/2020          EBS-4247-TRCL objects migration*/
/* Tamilarasi.P				21/8/2023			EPE-71202 */
/******************************************************************************/
CREATE Procedure ABRmareenSpAbrrurmlbanbspO
	@ctxt_ouinstance        	fin_ctxt_ouinstance, --Input 
	@ctxt_user              	fin_ctxt_user, --Input 
	@ctxt_language          	fin_ctxt_language, --Input 
	@ctxt_service           	fin_ctxt_service, --Input 
	@bankaccountnumber      	fin_banknumber, --Input 
	@bankcode               	fin_bankcode, --Input 
	@banknohdr              	fin_bankname, --Input 
	@enddate                	fin_date, --Input 
	@guid                   	fin_guid, --Input 
	@hdntrantype            	fin_transactiontype, --Input 
	@hdntrantype_ml         	fin_transactiontype, --Input 
	@hidden_control1        	fin_hiddencontrol, --Input 
	@hidden_control2        	fin_hiddencontrol, --Input 
	@jvnarration            	fin_comments, --Input 
	@ouinstid               	fin_ouinstid, --Input 
	@prj_hdn_ctrl           	fin_plf_hdn_ctrl_bt, --Input 
	@raisebnkchg            	fin_checkbox, --Input 
	@startdate              	fin_date, --Input 
	@statementno1           	fin_type, --Input 
	@timestamp              	fin_timestamp, --Input 
	@m_errorid              	int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Set @m_errorid = 0

	--declaration of temporary variables

	Declare @ctxt_ouinstance_tmp    fin_ctxt_ouinstance
	Declare @ctxt_user_tmp          fin_ctxt_user
	Declare @ctxt_language_tmp      fin_ctxt_language
	Declare @ctxt_service_tmp       fin_ctxt_service
	Declare @bankaccountnumber_tmp  fin_banknumber
	Declare @bankcode_tmp           fin_bankcode
	Declare @banknohdr_tmp          fin_bankname
	Declare @enddate_tmp            fin_date
	Declare @guid_tmp               fin_guid
	Declare @hdntrantype_tmp        fin_transactiontype
	Declare @hdntrantype_ml_tmp     fin_transactiontype
	Declare @hidden_control1_tmp    fin_hiddencontrol
	Declare @hidden_control2_tmp    fin_hiddencontrol
	Declare @jvnarration_tmp        fin_comments
	Declare @ouinstid_tmp           fin_ouinstid
	Declare @prj_hdn_ctrl_tmp       fin_plf_hdn_ctrl_bt
	Declare @raisebnkchg_tmp        fin_checkbox
	Declare @startdate_tmp          fin_date
	Declare @statementno1_tmp       fin_type
	Declare @timestamp_tmp          fin_timestamp

	--temporary and formal parameters mapping

	Set @ctxt_ouinstance_tmp     = @ctxt_ouinstance
	Set @ctxt_user_tmp           = ltrim(rtrim(@ctxt_user))
	Set @ctxt_language_tmp       = @ctxt_language
	Set @ctxt_service_tmp        = ltrim(rtrim(@ctxt_service))
	Set @bankaccountnumber_tmp   = ltrim(rtrim(@bankaccountnumber))
	Set @bankcode_tmp            = ltrim(rtrim(@bankcode))
	Set @banknohdr_tmp           = ltrim(rtrim(@banknohdr))
	Set @enddate_tmp             = @enddate
	Set @guid_tmp                = ltrim(rtrim(@guid))
	Set @hdntrantype_tmp         = ltrim(rtrim(@hdntrantype))
	Set @hdntrantype_ml_tmp      = ltrim(rtrim(@hdntrantype_ml))
	Set @hidden_control1_tmp     = ltrim(rtrim(@hidden_control1))
	Set @hidden_control2_tmp     = ltrim(rtrim(@hidden_control2))
	Set @jvnarration_tmp         = ltrim(rtrim(@jvnarration))
	Set @ouinstid_tmp            = @ouinstid
	Set @prj_hdn_ctrl_tmp        = ltrim(rtrim(@prj_hdn_ctrl))
	Set @raisebnkchg_tmp         = ltrim(rtrim(@raisebnkchg))
	Set @startdate_tmp           = @startdate
	Set @statementno1_tmp        = ltrim(rtrim(@statementno1))
	Set @timestamp_tmp           = @timestamp

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance_tmp = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user_tmp = null  

	IF @ctxt_language = -915
		Select @ctxt_language_tmp = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service_tmp = null  

	IF @bankaccountnumber = '~#~' 
		Select @bankaccountnumber_tmp = null  

	IF @bankcode = '~#~' 
		Select @bankcode_tmp = null  

	IF @banknohdr = '~#~' 
		Select @banknohdr_tmp = null  

	IF @enddate = '01/01/1900' 
		Select @enddate_tmp = null  

	IF @guid = '~#~' 
		Select @guid_tmp = null  

	IF @hdntrantype = '~#~' 
		Select @hdntrantype_tmp = null  

	IF @hdntrantype_ml = '~#~' 
		Select @hdntrantype_ml_tmp = null  

	IF @hidden_control1 = '~#~' 
		Select @hidden_control1_tmp = null  

	IF @hidden_control2 = '~#~' 
		Select @hidden_control2_tmp = null  

	IF @jvnarration = '~#~' 
		Select @jvnarration_tmp = null  

	IF @ouinstid = -915
		Select @ouinstid_tmp = null  

	IF @prj_hdn_ctrl = '~#~' 
		Select @prj_hdn_ctrl_tmp = null  

	IF @raisebnkchg = '~#~' 
		Select @raisebnkchg_tmp = null  

	IF @startdate = '01/01/1900' 
		Select @startdate_tmp = null  

	IF @statementno1 = '~#~' 
		Select @statementno1_tmp = null  

	IF @timestamp = -915
		Select @timestamp_tmp = null  


	--BEGIN of Standard code for getting precision type
	declare  
		@pqty_tmp          	fin_int ,
		@pamt_tmp		fin_int ,
		@prate_tmp              fin_int ,
		@perate_tmp    		fin_int ,
		@phigh_tmp              fin_int ,
		@pmed_tmp               fin_int ,
		@plow_tmp               fin_int
		
	exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
		@prate_tmp output, @perate_tmp output, @phigh_tmp output,
		@pmed_tmp output, @plow_tmp output

	--END of Standard code for getting precision type

	declare	@compcode_tmp	fin_companycode,
		@sysdt_tmp	fin_date ,
		@csdtfmt_tmp	fin_csdtfmt,
		@stdt_tmp	fin_date,
		@enddt_tmp	fin_date,
		@ststdt_tmp	fin_date,
		@stenddt_tmp	fin_date ,
		@acccode_tmp	fin_accountcode,
		@curr_tmp	fin_currencycode,
		@fb_tmp		fin_financebookid,
		@err_tmp	fin_int ,
		@errdesc_tmp	fin_placeholder

	-- @m_errorid should be 0 to indicate success
	select @m_errorid = 0

	select	
		@bankaccountnumber	= upper(replace(isnull(ltrim(rtrim(@bankaccountnumber)), ''), '~#~', '')),
		@banknohdr		= replace(isnull(ltrim(rtrim(@banknohdr)), ''), '~#~', ''),
		@ctxt_service		= replace(isnull(ltrim(rtrim(@ctxt_service)), ''), '~#~', ''),
		@ctxt_user		= replace(isnull(ltrim(rtrim(@ctxt_user)), ''), '~#~', ''),
		@guid			= replace(isnull(ltrim(rtrim(@guid)), ''), '~#~', ''),
		@hidden_control1	= replace(isnull(ltrim(rtrim(@hidden_control1)), ''), '~#~', ''),
		@statementno1		= upper(replace(isnull(ltrim(rtrim(@statementno1)), ''), '~#~', 0)),
		@startdate		= replace(isnull(ltrim(rtrim(@startdate)), ''), '~#~', ''),
		@enddate		= replace(isnull(ltrim(rtrim(@enddate)), ''), '~#~', ''),
		@bankcode		= upper(replace(isnull(ltrim(rtrim(@bankcode)), ''), '~#~', ''))--8I200AMC_abr_00005

	--Check if the bank account number has been entered.
	if @bankaccountnumber = ''
	begin --1
		--Select a Bank Account Number.
		exec fin_sp_raise_error '', '', '', '', 'ABR', 1,@m_errorid output
		return
	end --1

	--Check if Statement Number, Start Date and End date have been given.
	if @statementno1 = '' and @startdate = '01/01/1900' and @enddate = '01/01/1900'
	begin --3
		--Enter ^StmtNo! or ^StartDate! and ^EndDate!
		exec fin_sp_raise_error 'Statement Number', 'Start Date', 'End Date', '', 'ABR', 20,@m_errorid output
		return
	end --3

	--Check if Statement Number, Start Date and End date have been given.
	if @statementno1 != '' and @startdate != '01/01/1900' and @enddate != '01/01/1900'
	begin --3
		--Enter ^StmtNo! or ^StartDate! and ^EndDate!
		exec fin_sp_raise_error 'Statement Number', 'Start Date', 'End Date', '', 'ABR', 20,@m_errorid output
		return
	end --3

	--Check if only the start date has been entered.
	if @startdate != '01/01/1900' and @enddate = '01/01/1900'
	begin --12
		--Enter the End Date.
		exec fin_sp_raise_error '', '', '', '', 'ABR', 23,@m_errorid output
		return
	end --12

	--Check if only the end date has been entered.
	if @startdate = '01/01/1900' and @enddate != '01/01/1900'
	begin --13
		--Enter the Start Date.
		exec fin_sp_raise_error '', '', '', '', 'ABR', 24,@m_errorid output
		return
	end --13

	--Get the date format.
	exec emod_sysact_spgetdatefmt @ctxt_ouinstance, @ctxt_user, @csdtfmt_tmp output

	--Get the system date.
	select	@sysdt_tmp = getdate()

	--Get the company code.
	select	@compcode_tmp = company_code
	from	emod_ou_vw (nolock)
	where	ou_id 		= @ctxt_ouinstance
	and	@sysdt_tmp	between effective_from and isnull(effective_to, dateadd(year, 100, @sysdt_tmp))

	--If the statement number is not null.
	if @statementno1 != ''
	begin --4
		--Check if it exists in Active status.
		if not exists (	select	'x'
				from	abr_bank_statement_hdr (nolock)
				where	company_code		= @compcode_tmp
				and	ou_id			= @ctxt_ouinstance
				and	bank_acc_no		= @bankaccountnumber
				and	stmt_no			= @statementno1 )
		begin --5
			--<Stmt No> does not exist.Enter a valid ^Stmt No!
			exec fin_sp_raise_error @statementno1, 'Statement Number', '', '', 'ABR', 21,@m_errorid output
			return
		end --5

		--Get the Statement Start and End dates.
		select	@ststdt_tmp	= stmt_start_date,
			@stenddt_tmp	= stmt_end_date
		from	abr_bank_statement_hdr (nolock)
		where	company_code		= @compcode_tmp
		and	bank_acc_no		= @bankaccountnumber
		and	stmt_no			= @statementno1
	end --4



	if @startdate != '01/01/1900' and @enddate != '01/01/1900'
	begin --6
		--Get the given start and end dates as datetime.
		select	@stdt_tmp	= dbo.fin_dateinuserformat(@startdate, @csdtfmt_tmp),
			@enddt_tmp	= dbo.fin_dateinuserformat(@enddate, @csdtfmt_tmp)

		--Check if the Start Date is greater than the end date.
		if @stdt_tmp > @enddt_tmp
		begin --7
			--<Start Date> must precede <End Date>.Enter a valid date.
			exec fin_sp_raise_error @startdate, @enddate, '', '', 'ABR', 19,@m_errorid output
			return
		end --7
	end --6
	/*Code added by Nagarajan G for the bug id :ABRBASEFIXES_000005 Starts here*/
	else 
	begin
			select  @startdate = @ststdt_tmp,
				@enddate  = @stenddt_tmp
	end
	/*Code added by Nagarajan G for the bug id :ABRBASEFIXES_000005 Ends here*/

	/* Code Added by Vairamani for ABRDMS412AT_000044 Starts here */
	--Clear the temp table.
	-- Jakir
	if exists ( select 'x' from	abr_fbpbankbook_tmp (nolock)
				where	guid = @guid )
	begin
		delete	abr_fbpbankbook_tmp
		where	guid = @guid
	end	
	/* Code Added by Vairamani for ABRDMS412AT_000044 Ends here */

	--Get the Bank Codes mapped to the given Bank Account Number into a cursor.
	declare	bankcode_cur	scroll cursor for
	select	bnkcash_code,fb_id	
	from	bnkdef_sysact_bnkcashfb_vw(NOLOCK)
	where	company_code	= @compcode_tmp
	and	bank_acc_no	= @bankaccountnumber
	and	flag		= 'B'
	and	@sysdt_tmp  between effective_from and isnull(effective_to, dateadd(year, 100, @sysdt_tmp))
	and 	language_id = @ctxt_language 

	open bankcode_cur

	fetch first from bankcode_cur into @bankcode_tmp, @fb_tmp

	/* Code Commented by Vairamani for ABRDMS412AT_000041 Starts here */
	/*select @pacccode_tmp = null*/
	/* Code Commented by Vairamani for ABRDMS412AT_000041 Ends here */

	--For all the Bank Codes do the following.
	while @@fetch_status = 0
	begin --while @@fetch_status = 0
		--Get the Account Code for the Bank Code.

-- Code Added By Thiyagu.S For ID : 13I152ES_abr_00002 starts here

Declare	@postingstartdate	fin_date

		IF exists ( select 'T' from pps_feature_list (nolock)
					where	FEATURE_ID	=	'PPS_FID_0109'
					and		FLAG_YES_NO	=	'NO'		)
		Begin
		--Commented and added for 13I152ES_abr_00003 begins
			declare @date udd_datetime
			select @date = dateadd(yy,-1,getdate())

			select	@postingstartdate	=	min(fcc_finyr_startdt) 
			from	fcc_bfg_yr_close_status (nolock)
			where	bfg_code	= 'BK'
			and		fb_id		= @fb_tmp
			and		ou_id		= @ctxt_ouinstance
			--and		status		= 'O'
			and  @date between fcc_finyr_startdt and fcc_finyr_enddt

		--Commented and added for 13I152ES_abr_00003 ends
		End
-- Code Added By Thiyagu.S For ID : 13I152ES_abr_00002 ends here

		exec @err_tmp = ardisspgetbcpaccode @ctxt_language, @ctxt_ouinstance, @ctxt_service, @ctxt_user,
		@fb_tmp, @bankcode_tmp, @sysdt_tmp, @acccode_tmp output, @errdesc_tmp output



		if @err_tmp != 0
		begin --err
			select	@err_tmp = case when @err_tmp = 1 then 71 --Posting Account code not defined for the given Bank Code.
								 when @err_tmp = 2 then 72 --Provide OU
								 when @err_tmp = 3 then 73 --OU not mapped to any Company
								 when @err_tmp = 4 then 74 --Provide Finance Book
								 when @err_tmp = 5 then 75 --Provide Bank/Cash/PTT Code
								 when @err_tmp = 6 then 76 --Provide Transaction Date
								end
			/* Code Added by Vairamani for ABRDMS412AT_000041 Starts here */
			close bankcode_cur
			deallocate bankcode_cur
			/* Code Added by Vairamani for ABRDMS412AT_000041 Ends here */
			exec fin_sp_raise_error '', '', '', '', 'ABR', @err_tmp,@m_errorid output
			return
		end --err


	--Get the Account Currency.
	select	@curr_tmp = currency_code
	from	as_opaccountfb_vw(NOLOCK)
	where	company_code	= @compcode_tmp
	and	account_code	= @acccode_tmp


	declare @depositingpoint  fin_hiddencontrol

	select @depositingpoint =  ouinstname 
	 from emod_ou_vw
	where company_code = @compcode_tmp 
	and ou_id = @ctxt_ouinstance
	and (( @sysdt_tmp BETWEEN effective_from 
				AND ISNULL (effective_to,DATEADD (year,100,@sysdt_tmp )) )) 


	--Get all the transactions between the Statement Start and End dates, if the statement number is given.
	if @statementno1 != '' 
	begin --8
		--From Realize Receipts.

-- VIJI COMMENTED FOR 10I133_callid_00001 */
--	;
--		WITH
--		SQLTMP1 (document_no1) as 
--		(
--			SELECT 	abr_bank_reconcile_dtl.document_no
--			FROM 	abr_bank_reconcile_dtl (NOLOCK) 
--			WHERE  	abr_bank_reconcile_dtl.company_code 	= @compcode_tmp 
--			and  abr_bank_reconcile_dtl.bank_code = @bankcode_tmp
--			and 	abr_bank_reconcile_dtl.document_no is not NULL 
--			and (( ISNULL ( abr_bank_reconcile_dtl.ou_id , @ctxt_ouinstance) 
--			IN (
--				SELECT 	destinationouinstid
--				FROM 	fw_view_comp_intxn_model c (NOLOCK) , 
--					emod_ou_bu_map b (NOLOCK) 
--				WHERE 	c.sourceouinstid 	= @ctxt_ouinstance 
--				and 	c.sourcecomponentname 	= 'ABR' 
--				and 	B.ou_id 		= c.destinationouinstid 
--				and 	(( GETDATE () BETWEEN B.effective_from 
--						AND ISNULL (B.effective_to , GETDATE () )) ) 
--				and 	c.destinationcomponentname = 'FBP'
--				and 	B.map_status 	= 'M') )
--		    	    )
--			and 	abr_bank_reconcile_dtl.recon_status in ('R' , 'C') 
--			and 	abr_bank_reconcile_dtl.tran_type <> 'SC' 
--		)
-- VIJI COMMENTED FOR 10I133_callid_00001 */

		INSERT INTO abr_fbpbankbook_tmp
		(
			guid,tran_amount,check_no,
			comp_reference,tran_date,
			ou_name,document_no,prefix,tran_remarks,
			tran_type,timestamp,drcr_flag
			, bank_code  
			, depositslip_no 
			/* code added by viji for 10I133_ABR_00015 starts here */
			, tran_ou 
			/* code added by viji for 10I133_ABR_00015 ends here */
		) 
		SELECT 	@guid , ROUND (SUM (ISNULL (FB.tran_amount ,0)),@pamt_tmp), 
			fv.instr_no ,--'' , -- code by Ramkumar A for 6I121Live_abr_00007
			'', 
			FB.tran_date ,@depositingpoint , FB.document_no , --code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009
		case when FB.tran_type  = 'RM_BCT' then FV.micr_no
			else '' 
			end , 
			MIN (ISNULL (FB.narration ,'')),
			case when FB.tran_type in ('PM_SRC') and  FB.drcr_flag = 'CR' then 'PM_RSRC'
					else  FB.tran_type 
				end  as tran_type ,
			1,drcr_flag
			, @bankcode_tmp  , ''
			/* code added by viji for 10I133_ABR_00015 starts here */
			, tran_ou 
			/* code added by viji for 10I133_ABR_00015 ends here */

		FROM	--emod_ou_bu_map EV (NOLOCK) , -- VIJI commented for 10I133_CALLID_00001
			fbp_posted_trn_dtl_vw FB (NOLOCK) ,
			abr_receipt_ot_chk_vw FV (NOLOCK)  
		WHERE 	FB.company_code 	= @compcode_tmp 
		and 	FB.tran_type in ('PM_SRC','RM_SR','RM_RV'--,'RM_BCT' -- code commented by viji for 10I133_ABR_00015
			,'RM_RSR'  ,'RM_RRV' 

			)
		and 	FB.account_code 	= @acccode_tmp 
		and 	FB.posting_date 	<= @stenddt_tmp 
		and 	FB.posting_date		>= isnull(@postingstartdate,FB.posting_date)			-- Code Added By Thiyagu.S For ID : 13I152ES_abr_00002
		and     FB.FB_ID			= @fb_tmp
		--and 	EV.ou_id 		= FB.tran_ou   -- VIJI commented for 10I133_CALLID_00001
		and     FV.bank_cash_code    = @bankcode_tmp
	    and     isnull(FB.bank_code,FV.bank_cash_code)	= FV.bank_cash_code
		and		fv.receipt_no		=	fb.document_no
		AND     FV.FB_ID	= FB.FB_ID
		/* code added by viji for 10I133_CALLID_00001 */
		and		fb.tran_type		= fv.tran_type
		and		fv.ou_id		=	fb.tran_ou
		/* code added by viji for 10I133_CALLID_00001 */
		--and (( GETDATE () BETWEEN EV.effective_from AND ISNULL (EV.effective_to,DATEADD (year,100,GETDATE () )) ))	 ---- VIJI commented for 10I133_CALLID_00001
		GROUP BY FB.document_no,  FB.tran_date , 
			FB.drcr_flag , FB.tran_type 
		, fv.instr_no  , FV.micr_no  , fb.tran_ou -- code added by viji for 10I133_ABR_00015

	;
		
		WITH
		SQLTMP1 (document_no1) as 
		(
			SELECT 	abr_bank_reconcile_dtl.document_no
			FROM 	abr_bank_reconcile_dtl (NOLOCK) 
			WHERE  	abr_bank_reconcile_dtl.company_code 	= @compcode_tmp 
			and bank_code = @bankcode_tmp
			and 	abr_bank_reconcile_dtl.document_no is not NULL 
			and (( ISNULL ( abr_bank_reconcile_dtl.ou_id , @ctxt_ouinstance) 
			IN (
				SELECT 	destinationouinstid
				FROM 	fw_view_comp_intxn_model c (NOLOCK) , 
					emod_ou_bu_map b (NOLOCK) 
				WHERE 	c.sourceouinstid 	= @ctxt_ouinstance 
				and 	c.sourcecomponentname 	= 'ABR' 
				and 	B.ou_id 		= c.destinationouinstid 
				and 	(( GETDATE () BETWEEN B.effective_from 
						AND ISNULL (B.effective_to , GETDATE () )) ) 
				and 	c.destinationcomponentname = 'FBP'
				and 	B.map_status 	= 'M') )
		    	    )
			and 	abr_bank_reconcile_dtl.recon_status in ('R' , 'C') 
		)


			INSERT INTO abr_fbpbankbook_tmp
			(
				guid,tran_amount,
				check_no,comp_reference,
				tran_date,ou_name,document_no,prefix,
				tran_remarks,tran_type,timestamp,drcr_flag
				, bank_code 
				/* code added by viji for 10I133_ABR_00015 starts here */
				, tran_ou 
				/* code added by viji for 10I133_ABR_00015 ends here */
			) 
			SELECT 	@guid , ROUND (SUM (ISNULL (FB.tran_amount ,0)),@pamt_tmp) , 
				'','', 
			--FB.tran_date,
			FB.posting_date,
				@depositingpoint,/*EV.ouinstname,*/ FB.document_no,'' , --code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009
				MIN (ISNULL (FB.narration,'')),FB.tran_type,1,drcr_flag
				, @bankcode_tmp -- code added by Ramkumar A for 8I200AMC_rp_00005
				/* code added by viji for 10I133_ABR_00015 starts here */
				, tran_ou 
				/* code added by viji for 10I133_ABR_00015 ends here */

			FROM 	--emod_ou_bu_map EV (NOLOCK) , -- VIJI commented for 10I133_CALLID_00001
				fbp_posted_trn_dtl_vw FB (NOLOCK) 
				LEFT OUTER JOIN SQLTMP1 
				ON (FB.document_no = SQLTMP1.document_no1 )
			WHERE 	FB.company_code 	= @compcode_tmp 
			and 	FB.tran_type in ('PM_APV','PM_HPV','PM_SPV','PM_PV','PM_SPPV','RM_CPV','PM_SDV'--,'PM_BCT' -- code commented by viji for 10I133_ABR_00015
		 ,'PM_TPV', 'PM_VCK', 'PM_RSRC' ) 
			and 	FB.account_code 	= @acccode_tmp 
			and 	FB.posting_date 	<= @stenddt_tmp 
			and 	FB.posting_date		>= isnull(@postingstartdate,FB.posting_date)			-- Code Added By Thiyagu.S For ID : 13I152ES_abr_00002
			and 	SQLTMP1.document_no1 IS NULL 
			--and 	FB.tran_ou 		= EV.ou_id -- VIJI commented for 10I133_CALLID_00001 
			--and (( GETDATE () BETWEEN EV.effective_from AND ISNULL (EV.effective_to,DATEADD (year,100,GETDATE () )) ))  -- VIJI commented for 10I133_CALLID_00001
			GROUP BY FB.document_no , FB.account_code , 
			FB.posting_date,
				 FB.drcr_flag , FB.tran_type, fb.tran_ou -- code added by viji for 10I133_ABR_00015
		

	end --8
	--Get all the transactions between the given Start and End dates, if the statement number is not given.
	else
	begin --9

		--From Realize Receipts.
		/* Modified By Nitin For ABRRGGSYSTST_000084 On 29/07/03 Starts*/

-- CODE COMMENTED BY VIJI 10I133_callid_00001
--	;
--		WITH
-- 
--		SQLTMP1 (document_no1) as 
--		(
--			SELECT 	abr_bank_reconcile_dtl.document_no
--			FROM 	abr_bank_reconcile_dtl (NOLOCK) 
--			WHERE  	abr_bank_reconcile_dtl.company_code 	= @compcode_tmp 
--			and 	bank_code = @bankcode_tmp
--			and 	abr_bank_reconcile_dtl.document_no is not NULL 
--			and (( ISNULL ( abr_bank_reconcile_dtl.ou_id , @ctxt_ouinstance) 
--			IN (
--				SELECT 	destinationouinstid
--				FROM 	fw_view_comp_intxn_model c (NOLOCK) , 
--					emod_ou_bu_map b (NOLOCK) 
--				WHERE 	c.sourceouinstid 	= @ctxt_ouinstance 
--				and 	c.sourcecomponentname 	= 'ABR' 
--				and 	B.ou_id 		= c.destinationouinstid 
--				and 	(( GETDATE () BETWEEN B.effective_from 
--						AND ISNULL (B.effective_to , GETDATE () )) ) 
--				and 	c.destinationcomponentname = 'FBP'
--				and 	B.map_status 	= 'M') )
--		    	    )
--			and 	abr_bank_reconcile_dtl.recon_status in ('R' , 'C') 
--		)

-- CODE COMMENTED BY VIJI FOR 10I133_callid_00001 


		INSERT INTO abr_fbpbankbook_tmp
		(
			guid,tran_amount,
			check_no,comp_reference,
			tran_date,ou_name,document_no,prefix,
			tran_remarks,tran_type,timestamp,drcr_flag
			, bank_code  
			, depositslip_no  
			/* code added by viji for 10I133_ABR_00015 starts here */
			, tran_ou 
			/* code added by viji for 10I133_ABR_00015 ends here */
		) 
		SELECT 	@guid , ROUND (SUM (ISNULL (FB.tran_amount ,0)),@pamt_tmp), 
			fv.instr_no ,--'' , -- code by Ramkumar A for 6I121Live_abr_00007
			'', 
			FB.tran_date , @depositingpoint, /*EV.ouinstname ,*/ FB.document_no ,  --code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009
			case when FB.tran_type  = 'RM_BCT' then FV.micr_no
				else '' 
				end , 
			MIN (ISNULL (FB.narration ,'')),
			case when FB.tran_type in ('PM_SRC') and  FB.drcr_flag = 'CR' then 'PM_RSRC'
					else  FB.tran_type 
				end  as tran_type ,
		1,drcr_flag
		, @bankcode_tmp  ,''
			/* code added by viji for 10I133_ABR_00015 starts here */
			, tran_ou 
			/* code added by viji for 10I133_ABR_00015 ends here */
		FROM 	--emod_ou_bu_map EV (NOLOCK) ,  -- VIJI commented for 10I133_CALLID_00001
			fbp_posted_trn_dtl_vw FB (NOLOCK) ,
			abr_receipt_ot_chk_vw FV (NOLOCK)  
		WHERE 	FB.company_code 	= @compcode_tmp 
		and 	FB.tran_type in ('PM_SRC','RM_SR','RM_RV'--,'RM_BCT' -- code commented by viji for 10I133_ABR_00015
		,'RM_RSR'   	,'RM_RRV' 
		)
		and 	FB.account_code 	= @acccode_tmp 
		and 	FB.posting_date 	<= @enddt_tmp 
		and 	FB.posting_date		>= isnull(@postingstartdate,FB.posting_date)			-- Code Added By Thiyagu.S For ID : 13I152ES_abr_00002
		and     FB.FB_ID			= @fb_tmp
		--and 	EV.ou_id 		= FB.tran_ou  -- VIJI commented for 10I133_CALLID_00001
		and     FV.bank_cash_code = @bankcode_tmp
	    and     isnull(FB.bank_code,FV.bank_cash_code)	= FV.bank_cash_code
		/* code added by viji for 10I133_CALLID_00001 */
		and		fb.tran_type		= fv.tran_type
		and		fv.ou_id		=	fb.tran_ou
		/* code added by viji for 10I133_CALLID_00001 */
		and		fv.receipt_no		=	fb.document_no
		AND     FV.FB_ID	= FB.FB_ID
		--and (( GETDATE () BETWEEN EV.effective_from AND ISNULL (EV.effective_to,DATEADD (year,100,GETDATE () )) ))  -- VIJI commented for 10I133_CALLID_00001
		GROUP BY FB.document_no,  FB.tran_date , 
			FB.drcr_flag , FB.tran_type /*, EV.ouinstname */ --code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009
		,fv.instr_no  -- code by Ramkumar A for 6I121Live_abr_00007
		, FV.micr_no  -- code by Ramkumar A for 6I121Live_abr_00013
		, fb.tran_ou -- code added by viji for 10I133_ABR_00015


	/*code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009 starts*/

	;
		WITH 		
		SQLTMP1 (document_no1) as 
		(
			SELECT 	abr_bank_reconcile_dtl.document_no
			FROM 	abr_bank_reconcile_dtl (NOLOCK) 
			WHERE  	abr_bank_reconcile_dtl.company_code 	= @compcode_tmp 
			and bank_code = @bankcode_tmp
			and 	abr_bank_reconcile_dtl.document_no is not NULL 
			and (( ISNULL ( abr_bank_reconcile_dtl.ou_id , @ctxt_ouinstance) 
			IN (
				SELECT 	destinationouinstid
				FROM 	fw_view_comp_intxn_model c (NOLOCK) , 
					emod_ou_bu_map b (NOLOCK) 
				WHERE 	c.sourceouinstid 	= @ctxt_ouinstance 
				and 	c.sourcecomponentname 	= 'ABR' 
				and 	B.ou_id 		= c.destinationouinstid 
				and 	(( GETDATE () BETWEEN B.effective_from 
						AND ISNULL (B.effective_to , GETDATE () )) ) 
				and 	c.destinationcomponentname = 'FBP'
				and 	B.map_status 	= 'M') )
		    	    )
			and 	abr_bank_reconcile_dtl.recon_status in ('R' , 'C') 
			and 	abr_bank_reconcile_dtl.tran_type <> 'SC' 
		)

	INSERT INTO abr_fbpbankbook_tmp
	(
		guid,tran_amount,
		check_no,comp_reference,
		tran_date,ou_name,document_no,prefix,
		tran_remarks,tran_type,timestamp,drcr_flag
		, bank_code -- code added by Ramkumar A for 8I200AMC_rp_00005
		/* code added by viji for 10I133_ABR_00015 starts here */
		, tran_ou 
		/* code added by viji for 10I133_ABR_00015 ends here */
	)
	SELECT 	@guid , ROUND (SUM (ISNULL (FB.tran_amount , 0) ) , @pamt_tmp) , 
		'' , '' , 
FB.posting_date,
 @depositingpoint , /*EV.ouinstname ,*/ FB.document_no , --code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009 
'' , 		MIN (ISNULL (FB.narration ,'')),FB.tran_type ,1,drcr_flag
	, @bankcode_tmp -- code added by Ramkumar A for 8I200AMC_rp_00005
		/* code added by viji for 10I133_ABR_00015 starts here */
		, tran_ou 
		/* code added by viji for 10I133_ABR_00015 ends here */
		FROM 	--emod_ou_bu_map EV (NOLOCK) , -- VIJI commented for 10I133_CALLID_00001
		fbp_posted_trn_dtl_vw fb (NOLOCK) 
		LEFT OUTER JOIN SQLTMP1 
		ON (FB.document_no = SQLTMP1.document_no1 )
	WHERE 	FB.company_code 	= @compcode_tmp 
	and 	FB.tran_type in ('PM_APV','PM_HPV','PM_SPV','PM_PV','PM_SPPV','RM_CPV','PM_SDV'--,'PM_BCT' -- code commented by viji for 10I133_ABR_00015
,'PM_TPV', 'PM_VCK'  ,'PM_RSRC'   -- code added By Ramkumar A for 6I121Live_abr_00013 
) 
	and 	FB.account_code 	= @acccode_tmp 
	and 	FB.posting_date 	<= @enddt_tmp 
	and 	FB.posting_date		>= isnull(@postingstartdate,FB.posting_date)			-- Code Added By Thiyagu.S For ID : 13I152ES_abr_00002
	and 	SQLTMP1.document_no1 IS NULL 
	--and 	FB.tran_ou 		= EV.ou_id  -- VIJI commented for 10I133_CALLID_00001
	--and (( GETDATE () BETWEEN EV.effective_from AND ISNULL (EV.effective_to,DATEADD (year,100,GETDATE () )) ))  ---- VIJI commented for 10I133_CALLID_00001
	GROUP BY FB.document_no , FB.account_code , FB.posting_date,
		 FB.drcr_flag , FB.tran_type /*, EV.ouinstname */ --code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009
, fb.tran_ou -- code added by viji for 10I133_ABR_00015


	end  -- Statement No Blank - Start and End Date Given End
	



	fetch next from bankcode_cur into @bankcode_tmp, @fb_tmp

	end -- While Loop end



	close bankcode_cur
	deallocate bankcode_cur

		INSERT INTO abr_fbpbankbook_tmp
		(
			guid,tran_amount,check_no,comp_reference,
			tran_date,ou_name,document_no,prefix,
			tran_remarks,tran_type,timestamp,drcr_flag
			, bank_code -- code added by Ramkumar A for 8I200AMC_rp_00005
			/* code added by viji for 10I133_ABR_00015 starts here */
			, tran_ou 
			/* code added by viji for 10I133_ABR_00015 ends here */
		) 
		SELECT DISTINCT 
			@guid,FB.tran_amount,instr_no,'' , 
			FV.VoucherDate, @depositingpoint ,/*EV.ouinstname,*/FV.VoucherNo,'' , --code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009
			FB.narration,FB.tran_type,1,FV.drcr_flag
			, @bankcode_tmp -- code added by Ramkumar A for 8I200AMC_rp_00005
			/* code added by viji for 10I133_ABR_00015 starts here */
			, fb.tran_ou 
			/* code added by viji for 10I133_ABR_00015 ends here */
		FROM 	fbp_posted_trn_dtl_vw FB (NOLOCK) , 
		 	emod_ou_bu_map EV (NOLOCK) , 
			abr_genvoucher_dtl_vw FV (NOLOCK) 
		WHERE 	FB.company_code 	= @compcode_tmp 
		and FV.bankpttnum = @bankcode_tmp -- code added by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009
		and 	FB.account_code 	= FV.account_code 
		and 	FB.document_no 		= FV.tran_no 
		and 	FB.tran_ou 		= FV.tran_ou 
		and 	EV.ou_id 		= FV.tran_ou




	Update	abr_fbpbankbook_tmp
		Set	
		/*code modified by Ramkumar A for 9I121_abr_00008 on 14-7-2009 starts*/
			--check_no	= substring(B.check_no,len(B.check_prefix)+1,len(B.check_no) - len(B.check_prefix)),
			check_no	= substring(B.check_no,isnull(len(B.check_prefix),0)+1,isnull(len(B.check_no),0) - isnull(len(B.check_prefix),0)),
		/*code modified by Ramkumar A for 9I121_abr_00008 on 14-7-2009 ends*/
			comp_reference	= B.comp_reference,
			prefix		=    isnull(B.check_prefix,'')
		From	rp_sivoucher_vw B (NOLOCK), fin_quick_code_met (nolock) met
/*Code modified by anand for the bugid:11i130_callid_00002 as on 14/09/2011 Starts*/
		--Where	B.voucher_no	= document_no 
		Where guid				= @guid
		and B.voucher_no	= document_no 
/*Code modified by anand for the bugid:11i130_callid_00002 as on 14/09/2011 ends*/
		and	B.payment_category = tran_type
		and met.component_id = 'RP'
		and met.parameter_category = 'CHKNOSTAT'
		and met.parameter_text ='Damaged'
		and met.language_id = @ctxt_language 
		and B.checkno_status <> met.parameter_code


	Update	A 
		Set	
			 A.depositslip_no = B.depositslip_no
		From	abr_fbpbankbook_tmp A , rr_payinslip_dtl B (NOLOCK) 
		Where	B.receipt_no	= A.document_no 
		 and	 B.receipt_type  = A.tran_type
		and A.guid = @guid
		and B.instr_status <>  'BU'

	



	;
	WITH SQLTMP (tmpCol) as 
	(
		SELECT	'X'
		FROM 	sur_receipt_hdr(nolock) SUR , --FROM 	sur_receipt_hdr SUR , -- code modified by Ramkumar A for 9I121_CALLID_00006 on 25-6-2009 
			rr_payinslip_dtl rr (NOLOCK) 
		WHERE 	RR.receipt_no 	= SUR.origin_no 
		and 	SUR.tran_type 	= 'RM_SR' 
	)
	
	DELETE 	FROM abr_fbpbankbook_tmp
	WHERE 	(EXISTS 
			(
				SELECT 'X'
				FROM 	sur_receipt_hdr SUR (NOLOCK) 
					LEFT OUTER JOIN SQLTMP 
					ON ( origin_no = SQLTMP.tmpCol )
				WHERE  	receipt_no 	= abr_fbpbankbook_tmp.document_no 
				and 	receipt_type 	= abr_fbpbankbook_tmp.tran_type 
				and 	SQLTMP.tmpCol IS NULL 
			  )
		  ) 
	and 	guid 	= @guid





	delete from abr_fbpbankbook_tmp  
	where exists(	
		select 'x' from abr_bank_reconcile_dtl (nolock)
		where document_no = abr_fbpbankbook_tmp.document_no 
		and   recon_status in ('R','C')
	     )
	and guid 	=	@guid

	Update	FBP 
		Set	FBP.prefix		= substring(B.account_code,1,6),
			FBP.check_no = convert(varchar(10),datepart(dd,tran_date))+convert(varchar(10),datepart(mm,tran_date))+convert(varchar(10),datepart(yy,tran_date)) 
		From	abr_fbpbankbook_tmp (nolock) FBP, snp_voucher_dtl B (NOLOCK)
		Where	FBP.guid			=	@guid
		and		B.voucher_no	= FBP.document_no
		and	B.tran_type = FBP.tran_type AND B.tran_type = 'PM_BCT'
		and B.drcr_flag = 'DR'


		Update	FBP 
		Set	FBP.prefix		= ''	,
			FBP.check_no	= epay.utrno
		From	abr_fbpbankbook_tmp (nolock) FBP, bubct_epay_tran_dtl /*mcl_epay_tran_dtl--code commented and added by EPE-71202*/ epay (NOLOCK)
		Where	FBP.guid			=	@guid
		and		epay.voucher_no	= FBP.document_no 
		and	epay.bank_code = FBP.bank_code and FBP.bank_code =@bankcode_tmp 
		and epay.voucher_type   =  FBP.tran_type 
		and epay.Paymode  in ( 'OT' , 'Others')
		and epay.utrstatus  = 'AUT'

/*code modified by Ramkumar A for 9I121_abr_00019 ends*/


	/* code added by viji for 10I133_ABR_00015S starts here */
	delete from a
	From	abr_fbpbankbook_tmp A ,  rpt_receipt_hdr b(nolock)
	Where	A.guid = @guid
	and b.receipt_no = A.document_no 
	and a.tran_ou  = b.ou_id
	and A.tran_type = 'RM_RRV'
	and	 B.tran_type  = A.tran_type
	AND	b.ref_doc_no not in (select receipt_no from rr_payinslip_dtl   (NOLOCK)  where instr_status ='BU')

	/* code added by viji for 10I133_ABR_00015S ends here */

	/* code added by viji for 10I133_ABR_00019 starts here */
	delete from a
	From	abr_fbpbankbook_tmp A ,  rpt_receipt_hdr b(nolock)
	Where	A.guid = @guid
	and b.receipt_no = A.document_no 
	and a.tran_ou  = b.ou_id
	and A.tran_type = 'RM_RV'
	and  b.receipt_status = 'F'
	and	 B.tran_type  = A.tran_type
	AND	b.receipt_no not in (select receipt_no from rr_payinslip_dtl   (NOLOCK)  where instr_status ='BU')
	/* code added by viji for 10I133_ABR_00019 ends here */

/*code added by Ravi on 15/12/2011 for 10I133_abr_00048 begins */
	update a
	set a.inst_date = b.instr_date ,
		a.cust_code = b.cust_code
	From	abr_fbpbankbook_tmp A ,  rpt_receipt_hdr b(nolock)
	Where	A.guid = @guid
	and b.receipt_no = A.document_no 
	and a.tran_ou  = b.ou_id
	and A.tran_type = 'RM_RV'
	and	 B.tran_type  = A.tran_type

	update a
	set a.cust_name = b.clo_cust_name
	From	abr_fbpbankbook_tmp A ,  cust_lo_info b(nolock)
	Where	A.guid = @guid
	and a.cust_code = b.clo_cust_code 
	and a.tran_type = 'RM_RV'
/*code added by Ravi on 15/12/2011 for 10I133_abr_00048 ends */

	--Code Added By Reddy For The TTS ID - 12I205_abr_00010 Starts
	update	tmp
	set		tmp.inst_date		=	sr.instr_date,
			tmp.cust_code		=	sr.supplier_code
	from	abr_fbpbankbook_tmp	tmp,
			sr_receipt_mst		sr(nolock)
	where	tmp.guid		=	@guid
	and		tmp.tran_type	=	'PM_SRC'
	and		sr.ou_id		=	tmp.tran_ou
	and		sr.receipt_no	=	tmp.document_no
	and		sr.receipt_type	=	'RE'
	and		sr.tran_type	=	tmp.tran_type
	and		tmp.cust_code	is	null
	
	update	tmp
	set		tmp.cust_name	=	sup.sup_name
	from	abr_fbpbankbook_tmp	tmp,
			sup_master_vw		sup(nolock)
	where	tmp.guid		=	@guid
	and		tmp.tran_type	=	'PM_SRC'
	and		sup.sup_code	=	tmp.cust_code
	--Code Added By Reddy For The TTS ID - 12I205_abr_00010 Ends

	-- Added by Vineesh on 11/05/018 starts
	if @ctxt_service = 'abrmareensrabrrur'
	Begin
		delete tmp
		from	abr_fbpbankbook_tmp tmp ,   mcl_bounce_rect_dtl d (nolock)
		where	receipt_no	= document_no
		and		check_no	= inst_tno
		and		tmp.guid		= @guid 
		and		bounceddate	<=   @enddate	
	End
	-- Added by Vineesh on 11/05/018 ends

	--Output.
if(@ctxt_service <> 'abrbrecstsrsave')
	select 
		 
	tran_amount				'amount',
	check_no						'checknumber',
	comp_reference						'companyref',
/*code added by Ravi on 15/12/2011 for 10I133_abr_00048 begins */
		cust_code				'customercode', 
		cust_name				'customername', 
/*code added by Ravi on 15/12/2011 for 10I133_abr_00048 ends */
	dbo.fin_dateinuserformat(tran_date, @csdtfmt_tmp)	'dateml1',
	ou_name							'depositingpoint',
	document_no						'documentno',
/*code added by Ravi on 15/12/2011 for 10I133_abr_00048 begins */
		inst_date					'instrumentdate', 
/*code added by Ravi on 15/12/2011 for 10I133_abr_00048 ends */
	depositslip_no					 'payinslipnumberml1', 
	prefix							'prefix',
	tran_remarks						'remarks',
	''							'taggroup',
	parameter_text						'transactiontypeml'
	from	abr_fbpbankbook_tmp (nolock),
		fin_quick_code_met (nolock)
	where	guid			= @guid
	AND 	tran_date <= @enddate	
	and	component_id		= 'ABR'
	and	parameter_type		= 'COMBO'
	and	parameter_category	= 'DOCTYPE'
	and	parameter_code		= case	when 
						tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV','PM_BCT','RM_RSR') then 'SNP' --Code Added By Reddy For The Bug ID: 6I121Live_ABR_00001 As On 27052008
						when tran_type in ('PM_PV', 'PM_SPPV'
						,'PM_SDV'
					,'PM_TPV' , 'PM_RSRC' -- code added by Ramkumar A for 6I121Live_abr_00013
						) then 'SUP'
						when tran_type in ('RM_CPV'
						,'RM_RRV' -- code added by Ramkumar A for 9I121_abr_00016 
						) then 'CUP'
						when tran_type in ('RM_IBT','PM_SRC'/*, 'PM_RSRC'*/) then 'SUR'
						when tran_type in (
						'RM_SR','RM_BCT'
						, 'PM_VCK'  -- code commented by Ramkumar A for  6I121Live_abr_00013	
						) then 'SNR'--Code Added By Reddy For The Bug ID: 6I121Live_ABR_00001 As On 27052008
						when tran_type in ('RM_RV'/*, 'RM_RRV'*/) then 'CUR'
					  end
	and	language_id		= @ctxt_language
	order by tran_date

--	RSL

--	if exists ( select * from mcl_abr_fbpbankbook (nolock) where bank_code =  @bankcode_tmp )
--	begin
	--	delete from mcl_abr_fbpbankbook where bank_code =  @bankcode_tmp
--	end

--	RSL

	if(@ctxt_service = 'abrbrecstsrsave')
			begin 
				declare @period_code fin_financeperiod

				select @period_code = finprd_code
				from as_finperiod_dtl (nolock)
				where @enddate between finprd_startdt and finprd_enddt 

					/*insert into mcl_abr_fbpbankbook_conf
					select tmp.*, met.parameter_text,@period_code from abr_fbpbankbook_tmp tmp (nolock),
								  fin_quick_code_met  met(nolock)
					where guid = @guid
					and	component_id		= 'ABR'
					and	parameter_type		= 'COMBO'
					and	parameter_category	= 'DOCTYPE'
					and	parameter_code		= case
												 when tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV','PM_BCT','RM_RSR')	then 'SNP'
												 when tran_type in ('PM_PV', 'PM_SPPV', 'PM_SDV','PM_TPV', 'PM_RSRC')			then 'SUP'
												 when tran_type in ('RM_CPV','RM_RRV')											then 'CUP'
												 when tran_type in ('RM_IBT','PM_SRC')											then 'SUR'
												 when tran_type in ('RM_SR','RM_BCT','PM_VCK')									then 'SNR'
												 when tran_type in ('RM_RV')													then 'CUR'
											end
					and	language_id		= @ctxt_language*/

					insert into mcl_abr_fbpbankbook_conf
					select tmp.*, @period_code from mcl_abr_fbpbankbook tmp (nolock)
					where bank_code =  @bankcode_tmp
					and tran_date <= @enddate --need to be add

					--added for new requirement amc_cid_11421 begins
					insert	into mcl_abr_fbpbankstatement_hdr_conf   -- new table as like abr_bank_statement_hdr
					(company_code,bank_acc_no,bank_code,stmt_no,timestamp,ou_id,stmt_start_date,stmt_end_date,open_bal,
					openbal_drcr,close_bal,closebal_drcr,createdby,createddate,modifiedby,modifieddate,fb_id,fin_period)

					select	company_code,bank_acc_no,bank_code,stmt_no,timestamp,ou_id,stmt_start_date,stmt_end_date,open_bal,
					openbal_drcr,close_bal,closebal_drcr,createdby,createddate,modifiedby,modifieddate,fb_id,@period_code  
					from  Scmdb..abr_bank_statement_hdr tmp (nolock)
					where	tmp.bank_code =  @bankcode 
					and		tmp.stmt_start_date between  @ststdt_tmp and @stenddt_tmp

					insert	into mcl_abr_fbpbankstatement_dtl_conf  -- new table as like abr_bank_statement_dtl
					Select	
						company_code,	bank_acc_no,	bank_code,			stmt_no,		serial_no,			timestamp,
						ou_id,			ref_no,			tran_type,			tran_date,		check_no,			tran_amount,
						tran_remarks,	prefix,			comp_reference,		payinslip_no,	recon_status,		recon_by,
						recon_date,		createdby,		createddate,		modifiedby,		modifieddate,		deposlip_no,
						deposlip_amt,	inst_no,		inst_bank,			inst_date,		doc_no,				doc_type,
						check_Status,	bnkrel_date,	inst_amt,			doc_ou,			transactiondate,	patch_user,
						patch_remarks,	patch_date,		@period_code  
					from Scmdb..abr_bank_statement_dtl tmp (NoLock)
					where	tmp.bank_code = @bankcode --anitha
					and		tmp.stmt_no in (Select	hdr.stmt_no from Scmdb..abr_bank_statement_hdr hdr(NoLock)
											where	hdr.bank_code = @bankcode 
											and		hdr.stmt_start_date between  @ststdt_tmp and @stenddt_tmp)
					--added for new requirement amc_cid_11421 ends
					

			end
			else
			begin
					delete from mcl_abr_fbpbankbook where bank_code =  @bankcode_tmp

					-- Jakir
					if exists ( select 'x' from abr_fbpbankbook_tmp  (nolock)
								WHERE GUID = @GUID )
					begin
				--	RSL
								insert into mcl_abr_fbpbankbook
								select 
									tmp.timestamp,		tmp.guid,			tran_amount,		check_no,		comp_reference,		tran_date,
									ou_name,		document_no,	prefix,				tran_remarks,	tran_type,			tmp.createdby,
									tmp.createddate,	tmp.modifiedby,		tmp.modifieddate,		drcr_flag,		bank_code,			type,
									tran_ou,		checkdate,		bank_real_date,		ou_id,			bnkrel_date,		actrel_date,
									inst_amount,	inst_date,		trantype_desc,		doc_type,		actrel_amount,		transactiondate,
									depositslip_no,	cust_code,		cust_name,			met.parameter_text 
								from abr_fbpbankbook_tmp tmp,
									fin_quick_code_met  met(nolock)
								where guid = @guid
								and	component_id		= 'ABR'
								and	parameter_type		= 'COMBO'
								and	parameter_category	= 'DOCTYPE'
								and	parameter_code		= case	when tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV','PM_BCT','RM_RSR') then 'SNP'
																when tran_type in ('PM_PV','PM_SPPV','PM_SDV','PM_TPV' , 'PM_RSRC') then 'SUP'
																when tran_type in ('RM_CPV','RM_RRV') then 'CUP'
																when tran_type in ('RM_IBT','PM_SRC') then 'SUR'
																when tran_type in ('RM_SR','RM_BCT','PM_VCK') then 'SNR'--Code Added By Reddy For The Bug ID: 6I121Live_ABR_00001 As On 27052008
																when tran_type in ('RM_RV'/*, 'RM_RRV'*/) then 'CUR'
														end
								and	language_id		= @ctxt_language
				--	RSL
					end
		
			end

	if(@ctxt_service != 'abrbrecstsrsave')
			DELETE FROM abr_fbpbankbook_tmp WHERE GUID = @GUID

		/* 
	--OutputList
		Select
		null 'amount', 
		null 'checknumber', 
		null 'companyref', 
		null 'dateml1', 
		null 'depositingpoint', 
		null 'documentno', 
		null 'payinslipnumberml1', 
		null 'prefix', 
		null 'remarks', 
		null 'taggroup', 
		null 'transactiontypeml', 
	*/

	
Set nocount off

End









