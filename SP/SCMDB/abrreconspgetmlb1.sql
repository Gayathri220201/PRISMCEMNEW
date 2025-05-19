/*$File_version=ms4.3.0.38*/
/*$$filename = abrreconspgetmlb1.sql*/
/********************************************************************************/
/*
Component	: 	ABR
Description	:	Get Bank Book Details 
Author		:	Vairamani C
Date		:	Nov 12 2007
Remarks		:	ABRDMS412AT_000134 - ABR Changes -- Code Revamped

Modified By		Date			Remarks
Vairamani C		Jan 11 2008		DMS412AT_ABR_00006
Vairamani C		Mar 01 2008		DMS412AT_ABR_00005
Vairamani C		Mar 17 2008		DMS412AT_abr_00044
Vairamani C		Apr 10 2008		DMS412AT_abr_00043
Vairamani C		May 07 2008		DMS412AT_abr_00136	
Angelin.R		Mar 24 2009		ES_bnkdef_00013
Esther J		Nov 11 2009		9H123-1_rp_00028 
Esther J		Nov 24 2009		9H123-1_abr_00002
P Balaji		June 03 2010	ES_abr_00027
Veangadakrishnan R	11/08/2010	ES_abr_00031(10H109_ABR_00001)
SARANYA				06/06/2011	11H103_abr_00001 
SARANYA				09/06/2011		11H103_abr_00006 
SARANYA				13/06/2011		11H103_abr_00008 
Dinesh D		Aug 10 2011		ES_abr_00107
Aditya Sitaraman  29/6/2012		ES_abr_00212	
Prakash V		24/7/2012		ES_abr_00220	
Aditya Sitaraman  21/03/2014	ES_abr_00365
C.Ramesh Kumar		22.8.2014		14H109_abr_00001		
Ayyappan M		03/08/2014		ES_abr_00403 
Aditya Sitaraman	30/03/2015	ES_abr_00453	*/
/*Kavitha			30/7/2015	14H109_abr_00014*/
/*Kavitha R			01/04/2016	14H109_rpt_00070*/
/*Aditya S			09/05/2016	ES_abr_00559	*/
/*Kavitha R			05/08/2016	14H109_ABR_00016*/
/*Aditya S			29/11/2016	ES_abr_00642	*/
/*Aditya S			20/02/2017	ES_abr_00674	*/
/*Badri				23/05/2017	CAM-420		*/
/*Anusha.p          16/11/2017  epe-3918 */
/*Aditya S			21/12/2017	AAIPSS-279	*/
/*Anusha.p                    16/11/2017              EPE-4838 */
/*Amrutha R.S		07/01/2018		EPE-5027 */ 
 /*Anusha .p            10/01/2018      EPE-5273  */ 
 /*Amrutha R.S		22/01/2018		EPE-5482 */ 
 /*Amrutha R.S		30/01/2018		EPE-5572 */ 
 /*Amani.P			29/06/2018		EPE-7274 */
 /*Amani.P			10/07/2018		EPE-7861 */
 /*Ashok V			07/08/2019		MPIE-43	 */
 /*Ashok V			15-04-2020		EBS-4247 */
 /*Aditya S			28/02/2022		LYN-765*/
 /*Ashok V			10/10/2022		TC-634	*/
 /*Sai Kumar        12/09/2024      EPE-88517 */


Create procedure abrreconspgetmlb1
(
	@bankaccountnumber	fin_banknumber,
	@banknohdr		fin_bankname,
	@ctxt_language		fin_languageid,
	@ctxt_ouinstance	fin_ouinstid,
	@ctxt_service		fin_service,
	@ctxt_user		fin_ctxt_user,
	@enddate		fin_date,
	@guid			fin_guid,
	@hidden_control1	fin_hiddencontrol,
	@startdate		fin_date,
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	@statementno1		fin_statementnumber,
	@financebook		fin_financebookid,
	@bankcode		fin_bankcode,
	@transactionou		fin_chargesou,
	@costcenter		fin_costcenter,
	@analysiscode		fin_analysiscode,
	@subanalysiscode	fin_subanalysiscode,
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */	
	@m_errorid		fin_int output
)
as
begin
	set nocount on

	--BEGIN of Standard code for getting precision type
	declare @pqty_tmp          	fin_int ,
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
		@sysdt_tmp	fin_date,
		@ststdt_tmp	fin_date,
		@stenddt_tmp	fin_date,
		@errormsgout	fin_text2500,
		@statementno	fin_statementnumber /* Code Modified for DMS412AT_ABR_00005 */
		,@int_acc_param			fin_paramcode--14H109_ABR_00016
		,@loid_tmp			fin_desc40

	-- @m_errorid should be 0 to indicate success
	select 	@m_errorid = 0

	select @bankaccountnumber = ltrim(rtrim(@bankaccountnumber))
	if @bankaccountnumber = '~#~'
		select @bankaccountnumber = null

	select @banknohdr = ltrim(rtrim(@banknohdr))
	if @banknohdr = '~#~'
		select @banknohdr = null

	select @ctxt_service = ltrim(rtrim(@ctxt_service))
	if @ctxt_service = '~#~'
		select @ctxt_service = null

	select @ctxt_user = ltrim(rtrim(@ctxt_user))
	if @ctxt_user = '~#~'
		select @ctxt_user = null

	select @guid = ltrim(rtrim(@guid))
	if @guid = '~#~'
		select @guid = null

	select @hidden_control1 = ltrim(rtrim(@hidden_control1))
	if @hidden_control1 = '~#~'
		select @hidden_control1 = null

	select @statementno1 = ltrim(rtrim(@statementno1))
	if (@statementno1 = '~#~' or @statementno1 = '')
		select @statementno1 = null

	select @startdate = ltrim(rtrim(@startdate))
	if (@startdate = '1900-01-01' or @startdate = '01/01/1900')
		select @startdate = null

	select @enddate = ltrim(rtrim(@enddate))
	if (@enddate = '1900-01-01' or @enddate = '01/01/1900')
		select @enddate = null

	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	select @financebook = ltrim(rtrim(@financebook))
	if @financebook = '~#~'
		select @financebook = null

	select @bankcode = ltrim(rtrim(@bankcode))
	if @bankcode = '~#~'
		select @bankcode = null

	select @costcenter = ltrim(rtrim(@costcenter))
	if @costcenter = '~#~'
		select @costcenter = null

	select @analysiscode = ltrim(rtrim(@analysiscode))
	if @analysiscode = '~#~'
		select @analysiscode = null

	select @subanalysiscode = ltrim(rtrim(@subanalysiscode))
	if @subanalysiscode = '~#~'
		select @subanalysiscode = null

	select @transactionou = ltrim(rtrim(@transactionou))
	if @transactionou = '~#~'
		select @transactionou = null
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */

	if @bankaccountnumber is null
	begin
		--Select a Bank Account Number.
		exec fin_sp_raise_error '', '', '', '', 'ABR', 1,@m_errorid output
		return
	end

	--Get the system date.
	select	@sysdt_tmp = convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120)

	select	@loid_tmp		=	lo_id
	from	emod_lo_bu_ou_vw (nolock)
	where	ou_id 			= 	@ctxt_ouinstance
	and		@sysdt_tmp between effective_from and isnull(effective_to, @sysdt_tmp)

	--Get the company code.
	select	@compcode_tmp = company_code
	from	emod_ou_vw (nolock)
	where	ou_id 		= @ctxt_ouinstance
	and	@sysdt_tmp between effective_from 
		and isnull(effective_to, @sysdt_tmp)
	
	/*14H109_ABR_00016*/	
	select	@int_acc_param			= cps.parameter_code
	from	cps_processparam_sys cps	
	where   cps.company_code        = @compcode_tmp 	
	and     cps.parameter_type      = 'BKSYS'  		
	--and     cps.ou_id               = @ctxt_ouinstance  		--AAIPSS-279
	and     cps.parameter_category  = 'INTACCREC'	
	and 	language_id 			= @ctxt_language		
	/*14H109_ABR_00016*/
	select @statementno = @statementno1

	if @ctxt_service not in ('ABRRECONSRAUTO')
	begin
		if (@statementno is null and @startdate is null and @enddate is null)
		begin
			--Enter statement number or the start and end dates
			exec fin_sp_raise_error '', '', '', '', 'ABR', 20,@m_errorid output
			return
		end
	
		if (@statementno is null)
		begin
			if (@startdate is null)
			begin
				--Enter the Start Date.
				exec fin_sp_raise_error '', '', '', '', 'ABR', 24,@m_errorid output
				return
			end
			
			if (@enddate is null)
			begin
				--Enter the End Date.
				exec fin_sp_raise_error '', '', '', '', 'ABR', 23,@m_errorid output
				return
			end
	
			if (@startdate > @enddate)
			begin
				--Start Date must precede End Date. Enter a valid date.
				exec fin_sp_raise_error '', '', '', '', 'ABR',19,@m_errorid output
				return
			end
	
			/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
			/*
			if 
			(
				select 	count(distinct stmt_no)
				from 	abr_bank_statement_dtl (nolock)
				where 	company_code 	= @compcode_tmp
				and 	recon_status 	= 'U'
				and 	bank_acc_no 	= @bankaccountnumber
				and 	tran_date between @startdate and @enddate
			)>1
			begin
				--More than one Statement Number falls between the Start Date and End Date - Change the Dates
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,18,'','','','','','','',@errormsgout
				return					
			end
			*/
			/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */
		end
		else
		begin -- Statement Number Entered (Not Null)
		 --epe-5273
			--if ((@statementno is not null) and (@startdate is not null or @enddate is not null))
			--begin
			--	--Enter statement number or the start and end dates
			--	exec fin_sp_raise_error '', '', '', '', 'ABR', 20,@m_errorid output
			--	return
			--end
	
			if not exists
			(
				select 	'X'
				from 	abr_bank_statement_hdr (nolock)
				where 	company_code 	= @compcode_tmp
				and 	bank_acc_no 	= @bankaccountnumber
				and	stmt_no		= @statementno
			)
			begin
				--Statement Number - %s does not exists. Enter Valid Statement Number.
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,21,@statementno,'','','','','','',@errormsgout
				return	
			end

			if exists
			(
				select 	'X'
				from 	abr_bank_statement_hdr (nolock)
				where 	company_code 	= @compcode_tmp
				and 	bank_acc_no 	= @bankaccountnumber
				and	stmt_no		= @statementno
				and	recon_status	= 'R'
			)
			begin
				--Statement Number - %s already fully Reconciled.Enter another Statement number
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,29,@statementno,'','','','','','',@errormsgout
				return	
			end
		end
	end

	if @ctxt_user = 'check1'
	begin
		select @statementno '@statementno'
	end

	if @statementno is not null
	begin
		--Get the Statement Start and End dates.
		select	@ststdt_tmp	= stmt_start_date,
			@stenddt_tmp	= stmt_end_date
		from	abr_bank_statement_hdr (nolock)
		where	company_code	= @compcode_tmp
		and	bank_acc_no	= @bankaccountnumber
		and	stmt_no		= @statementno		
	end
	else
	begin
		select @stenddt_tmp = @enddate		
	end

	--Clear the temp table.
	if exists
	(
		select	'X'
		from	abr_fbpbankbook_tmp (nolock)
		where	guid	= @guid
	)
	begin
		delete	abr_fbpbankbook_tmp
		where	guid = @guid
	end

	declare @ard_bank_acct_dtl
	table
	(
		acct_code	fin_accountcode,--nvarchar(32),--LYN-765
		fb_id		fin_financebookid--nvarchar(20)--LYN-765
	)

	insert into @ard_bank_acct_dtl
	(
		acct_code , fb_id
	)
	select	ARD.bankptt_account,ARD.fb_id
	from	bnkdef_code_mst BNK (nolock),
		ard_bnkcsh_account_mst ARD (nolock)
	where	BNK.company_code	= ARD.company_code
	and	BNK.fb_id		= ARD.fb_id
	and	BNK.bank_code		= ARD.bank_ptt_code
	and	BNK.flag		= ARD.flag
	and	BNK.bank_acc_no		= @bankaccountnumber
	and	BNK.company_code	= @compcode_tmp
	and	BNK.flag		= 'B'
	/* Code Modified by Vairamani for DMS412AT_abr_00136 Starts here */
	
	--14H109_ABR_00016
	declare @comp_table		table
	(
		component_id			fin_componentshortid
	)
	
	--LYN-765
	/*
	insert into @comp_table
	(
		component_id
	)
	select	distinct component_name
	from	fbp_posted_trn_dtl FB (NOLOCK) 
	WHERE 	FB.company_code 	= @compcode_tmp
	
	delete from @comp_table where component_id in ('FBP','FCC','CONSOL','JV')--code 'JV' added for MPIE-43
	*/
	--LYN-765
	
	if isnull(@int_acc_param,'N') = 'Y'
	begin
		insert into @ard_bank_acct_dtl
		(
			acct_code , fb_id
		)
		select	ARD.interim_account,ARD.fb_id
		from	bnkdef_code_mst BNK (nolock),
				ard_bnkcsh_account_mst ARD (nolock)
		where	BNK.company_code	= ARD.company_code
		and		BNK.fb_id			= ARD.fb_id
		and		BNK.bank_code		= ARD.bank_ptt_code
		and		BNK.flag			= ARD.flag
		and		BNK.bank_acc_no		= @bankaccountnumber
		and		BNK.company_code	= @compcode_tmp
		and		BNK.flag			= 'B'
	end

	--LYN-765	
	insert into @comp_table
	(
		component_id
	)
	select	distinct component_name
	from	fbp_posted_trn_dtl FB (NOLOCK)  , @ard_bank_acct_dtl a
	WHERE 	FB.company_code 	= @compcode_tmp 
	and		fb.fb_id  = a.fb_id
	and		fb.posting_date < = @stenddt_tmp
	and		fb.account_code  = a.acct_code
	
	delete from @comp_table where component_id in ('FBP','FCC','CONSOL','JV') 
	--LYN-765

	--14H109_ABR_00016
	--code commented for ES_abr_00559 starts
	/*
	and	@stenddt_tmp between ARD.effective_from 
		and isnull(ARD.effective_to,@stenddt_tmp)
	*/
	--code commented for ES_abr_00559 ends			
	--and	BNK.status		= '2'
	/* Code Modified by Vairamani for DMS412AT_abr_00136 Ends here */

	if @ctxt_user = 'check1'
	begin
		select @stenddt_tmp '@stenddt_tmp'
		select * from @ard_bank_acct_dtl
	end

	/*
		BR - M32ABR021 -- Get Details from FBP - Receipt transactions without pay in slip
		Fetch receipt transactions without 'Pay in slip' reference also.

		BR - M32ABR021A -- Get Details from FBP - Reversal transactions to be fetched
		Reversal Transactions for which FBP postings has happened should also be fetched in the bank book ML, 
		the transaction type as per EMOD should be displayed as 'Transaction type' in the bank book ML.
	*/

	INSERT INTO abr_fbpbankbook_tmp
	(
		guid,tran_ou,
--		tran_amount,	--ES_abr_00027
		check_no,comp_reference,
		tran_date,document_no,prefix,
		tran_remarks,tran_type,timestamp,drcr_flag,
		account_code,doc_tran_type,
		ref_doc_no,ref_tran_type,ref_tran_ou,type_flag
		,bank_code   --EPE-88517
	) 
	SELECT 	DISTINCT @guid ,FB.tran_ou , --ES_abr_00027
	--code commented by P Balaji starts here for ES_abr_00027
--		sum
--		(
--			case drcr_flag
--				when 'DR' then FB.tran_amount 
--				else (FB.tran_amount * -1)
--			end
--		),
	--code commented by P Balaji ends here for ES_abr_00027
		'','', 
		FB.posting_date ,FB.document_no,'' , 
		--isnull(FB.narration,''),FB.tran_type,1,'DR',	--Code commented by Dinesh D for the defect id: ES_abr_00107
		--isnull(FB.hdrremarks,''),FB.tran_type,1,'DR', --Code added by Dinesh D for the defect id: ES_abr_00107
		'',FB.tran_type,1,'DR', /* code commented and added for CAM-420 */
		FB.account_code, FB.tran_type, 
		reftran_no, ref_tran_type, reftran_ou,'RT'
		,FB.bank_code   --EPE-88517
	FROM 	fbp_posted_trn_dtl FB (NOLOCK) ,@comp_table comp,@ard_bank_acct_dtl ard
	WHERE 	FB.company_code 	= @compcode_tmp 
	and		ard.fb_id			= FB.fb_id
	and 	FB.posting_date 	<= @stenddt_tmp 
	and		ard.acct_code		= FB.account_code
	and		isnull(recon_flag,'U')='U'
	and		FB.component_name	= comp.component_id--not in ('FBP','FCC') /*Added for DTS ID: ES_abr_00031(10H109_ABR_00001)*/
	--code commented by P Balaji starts here for ES_abr_00027
--	group by FB.document_no,FB.tran_type,FB.account_code,FB.posting_date,
--		FB.drcr_flag,FB.tran_ou,FB.narration,FB.reftran_no,FB.ref_tran_type,FB.reftran_ou
	--code commented by P Balaji ends here for ES_abr_00027

	/* code  added for CAM-420 starts here */
	update tmp
	set tran_remarks = fb.hdrremarks
	from abr_fbpbankbook_tmp tmp,fbp_posted_trn_dtl fb
	where fb.document_No = tmp.document_no
	and		fb.account_code = tmp.account_code
	and		fb.tran_type = tmp.tran_type
	--and		tmp.fb_id			= FB.fb_id
	and		guid = @guid
	and		isnull(FB.hdrremarks,'') <>''
	/* code  added for CAM-420 ends here */

	if @ctxt_user = 'check'
	begin
		select 'abr_fbpbankbook_tmp1'
		select 'abr_fbpbankbook_tmp',*
		from	abr_fbpbankbook_tmp
		where	guid = @guid
		and		document_no = 'CURECT\103081\2007'
	end
	--code added by P Balaji starts here for ES_abr_00027
	update TMP
	set	tran_amount	= (select sum
							(
								case drcr_flag
									when 'DR' then FB.tran_amount 
									else (FB.tran_amount * -1)
								end
							)
					FROM	fbp_posted_trn_dtl FB (NOLOCK) 
					WHERE 	FB.company_code 	=	@compcode_tmp 
					AND		TMP.tran_ou			=	fb.tran_ou
					AND		TMP.document_no			=	fb.document_no
					AND		TMP.account_code	=	fb.account_code
					and		TMP.tran_type		=	fb.tran_type --code added for ES_abr_00365
					and	exists
						(
							select	'X'
							from	@ard_bank_acct_dtl
							where	acct_code	= FB.account_code
							and	fb_id		= FB.fb_id
						)
					and 	FB.posting_date 	<= @stenddt_tmp 
					and	(recon_flag is null or recon_flag ='U')
					)	
	FROM abr_fbpbankbook_tmp TMP WITH (ROWLOCK)
	where	guid		= @guid
	--code added by P Balaji ends here for ES_abr_00027

	update	abr_fbpbankbook_tmp
	set	tran_amount	= abs(tran_amount) ,
		drcr_flag	= 'CR',
		type_flag	= 'PY'
	where	guid		= @guid
	and	tran_amount	< 0
	/* Code Modified by Vairamani for DMS412AT_ABR_00006 Starts here */
	
		if @ctxt_user = 'check'
	begin
		select 'abr_fbpbankbook_tmp1'
		select 'abr_fbpbankbook_tmp',*
		from	abr_fbpbankbook_tmp
		where	guid = @guid
		and		document_no = 'CURECT\103081\2007'
	end


	/*Code added by Aditya Sitaraman for ES_abr_00212 starts*/
	delete from abr_fbpbankbook_tmp 
	where guid = @guid
	and tran_amount = 0
	/*Code added by Aditya Sitaraman for ES_abr_00212 ends*/

	--AAIPSS-279
	if isnull(@int_acc_param,'N') = 'Y'
	begin
		delete from abr_fbpbankbook_tmp 
		where guid = @guid
		and tran_type in ('PM_IBT','RM_IBT')
	end
	--AAIPSS-279

	/*
	if @ctxt_service not in ('ABRRECONSRAUTO')
	begin
	*/
	update	abr_fbpbankbook_tmp
	set		ou_name		= ouinstname
	from	emod_ou_vw vw(nolock)--code modified for EBS-4247
	where	guid		= @guid
	and		tran_ou		= vw.ou_id
	and 	(@sysdt_tmp between vw.effective_from 
		and isnull(vw.effective_to,@sysdt_tmp))
	--end
	/* Code Modified by Vairamani for DMS412AT_ABR_00006 Ends here */
	
	/* code modified by Prakash V TTS ID : ES_abr_00220 Starts Here */
	if Exists
	(Select	'X'
	 From	rp_voucher_dtl(Nolock) B,
			abr_fbpbankbook_tmp  TMP 
	 Where	TMP.guid		= @guid
	and	B.voucher_no		= TMP.document_no
	and	B.payment_category 	= TMP.tran_type
	and	B.tran_ou			= TMP.tran_ou
	and B.pay_mode			= 'CH')
	Begin
	 
		Update	TMP
		Set	check_no			= B.check_no,
			comp_reference		= B.comp_reference
			,bank_code			= B.bank_code  -- code added by Esther for the DTS id 9H123-1_rp_00028 
		From	abr_fbpbankbook_tmp  TMP (nolock), 
			rp_voucher_dtl B (nolock)
		Where	TMP.guid		= @guid
		and	B.voucher_no		= TMP.document_no
		/*code commented and added for ES_abr_00453 starts*/
		--and	B.payment_category 	= TMP.tran_type
		and	(case when B.doc_type = 'PM_RP' then B.payment_category else B.doc_type end)	= TMP.tran_type
		/*code commented and added for ES_abr_00453 ends*/
		and	B.tran_ou		= TMP.tran_ou
		and exists( 
						Select 'X'
						From	rp_checkseries_dtl dtl(nolock)
						Where	dtl.check_no  = b.check_no
						and		dtl.checkno_status in ('VD','AT','PR')
					  )
	End
	
	
	if Exists
	(Select	'X'
	 From	rp_voucher_dtl(Nolock) B,
			abr_fbpbankbook_tmp  TMP 
	 Where	TMP.guid		= @guid
	and	B.voucher_no		= TMP.document_no
	and	B.payment_category 	= TMP.tran_type
	and	B.tran_ou			= TMP.tran_ou
	and B.pay_mode			<> 'CH')
	Begin
	 
		Update	TMP
		Set	check_no			= B.check_no,
			comp_reference		= isnull(B.comp_reference,eft_no)--14H109_abr_00001
			,bank_code			= B.bank_code  -- code added by Esther for the DTS id 9H123-1_rp_00028 
		From	abr_fbpbankbook_tmp  TMP (nolock), 
			rp_voucher_dtl B (nolock)
		Where	TMP.guid		= @guid
		and	B.voucher_no		= TMP.document_no
		and	B.payment_category 	= TMP.tran_type
		and	B.tran_ou			= TMP.tran_ou
		and B.pay_mode			<> 'CH'    --Code added by Ayyappan M for the Defect id : ES_abr_00403
		
	End
	/* code modified by Prakash V TTS ID : ES_abr_00220 Ends Here */

	/*Code Added by Esther J for the Bug id : 9H123-1_abr_00002  Starts */
	Update	TMP
	Set	check_no		= B.instr_no
	From	abr_fbpbankbook_tmp  TMP (nolock), 
		sr_receipt_MST B (nolock)
	Where	TMP.guid		= @guid
	and	B.receipt_no		= TMP.document_no
	and	B.ou_id				= TMP.tran_ou
	and B.tran_type			= TMP.tran_type		--ES_abr_00674
	/*Code Added by Esther J for the Bug id : 9H123-1_abr_00002  Ends */

	/*Code Added by Angelin.R for the Bug id : ES_bnkdef_00013 Starts here*/
	Update	TMP
	Set	comp_reference		= case when B.LC_Number = '-915' then NULL else B.LC_Number end --14H109_ABR_00016
	From	abr_fbpbankbook_tmp  TMP (nolock), 
		rpt_receipt_hdr B (nolock)
	Where	TMP.guid		= @guid
	and	B.receipt_no		= TMP.document_no
	and	B.ou_id				= TMP.tran_ou
	and B.tran_type			= TMP.tran_type		--ES_abr_00674
	/*Code Added by Angelin.R for the Bug id : ES_bnkdef_00013 Ends here*/
	--14H109_rpt_00070
	Update	TMP
	Set	comp_reference		= B.comp_reference
	From	abr_fbpbankbook_tmp  TMP (nolock), 
		rpt_receipt_hdr B (nolock)
	Where	TMP.guid		= @guid
	and	B.receipt_no		= TMP.document_no
	and	B.ou_id				= TMP.tran_ou
	and B.tran_type			= TMP.tran_type		--ES_abr_00674
	and	b.receipt_mode		in ('DB','EP') -- = 'DB'--code modified for TC-634
	--14H109_rpt_00070

	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	Update	TMP
	Set	payinslip_no		= B.payinslip_no,
		deposit_ou		= B.ou_id
	From	abr_fbpbankbook_tmp  TMP(nolock), 
		rr_payinslip_dtl B (nolock)
	Where	guid			= @guid
	and	TMP.document_no		= B.receipt_no
	and	TMP.tran_type 		= B.receipt_type
	and	TMP.tran_ou		= B.ou_id

	/* Code Modified by Vairamani for DMS412AT_abr_00043 Starts here */
	if @ctxt_user = 'check1'
	begin
		select 'check1 tresting'
		select b.* From	abr_fbpbankbook_tmp  TMP(nolock), 
			rr_acct_info_dtl B (nolock)
		Where	TMP.guid		= @guid
		and	TMP.account_code	= B.account_code
		and	TMP.document_no		= B.tran_no
		and	TMP.tran_type 		= B.tran_type
		and	TMP.tran_ou		= B.ou_id
		and	TMP.payinslip_no is null	
	end

	-- Deposit Bank Differ - Postings
	Update	TMP
	Set	payinslip_no		= B.ref_no,
		deposit_ou		= B.ou_id
	From	abr_fbpbankbook_tmp  TMP(nolock), 
		rr_acct_info_dtl B (nolock)
	Where	TMP.guid		= @guid
	and	TMP.account_code	= B.account_code
	and	TMP.document_no		= B.tran_no
	and	TMP.tran_type 		= B.tran_type
	and	TMP.tran_ou		= B.ou_id
	and	TMP.payinslip_no is null
--14H109_abr_00014	
	Update	TMP
	Set	payinslip_no		= B.payinslip_no,
		deposit_ou		= B.ou_id
	From	abr_fbpbankbook_tmp  TMP(nolock), 
		rr_payinslip_hdr B (nolock)
	Where	TMP.guid		= @guid
	--and	TMP.account_code	= B.account_code
	and	TMP.document_no		= B.receipt_no
	--and	TMP.tran_type 		= B.tran_type
	and	TMP.tran_ou		= B.ou_id
	and	TMP.payinslip_no is null
	and	b.deposittype	= 'CAD'	
	/* Code Modified by Vairamani for DMS412AT_abr_00043 Ends here */
--14H109_abr_00014
	update	abr_fbpbankbook_tmp
	set	deposit_ou	= ouinstname
	from	emod_ou_vw vw(nolock)--code modified for EBS-4247
	where	guid		= @guid
	and	deposit_ou	= vw.ou_id
	and 	(@sysdt_tmp between vw.effective_from 
		and isnull(vw.effective_to,@sysdt_tmp))
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */

	Update	TMP
	Set	check_no		= B.instr_no
	From	abr_fbpbankbook_tmp  TMP(nolock), 
		ci_doc_hdr B (nolock)
	Where	guid			= @guid
	and	TMP.document_no		= B.tran_no
	and	TMP.tran_type 		= B.tran_type
	and	TMP.tran_ou		= B.tran_ou
	and	TMP.tran_type not in ('RM_CPV') -- Code Modified by Vairamani for DMS412AT_abr_00043
	
	/*code for EPE-5482 begins here */
	Update	TMP
	Set		Paybatch_no		= B.Paybatch_no,
			bank_code		= B.bank_cash_code	
	From	abr_fbpbankbook_tmp  TMP(nolock), 
			spy_voucher_hdr		B (nolock)
	Where	guid			= @guid
	and	TMP.document_no		= B.voucher_no
	and	TMP.tran_ou			= B.ou_id
	and	TMP.tran_type		= 'PM_PV'
	
	Update	TMP
	Set		bank_code		= B.bank_cash_code	
	From	abr_fbpbankbook_tmp  TMP(nolock), 
			spy_prepay_vch_hdr B(nolock)
	where guid				= @guid
	and	TMP.document_no		= B.voucher_no
	and	TMP.tran_ou			= B.ou_id
	and TMP.tran_type		= 'PM_SPPV'
	and	B.tran_type			= 'PM_SPPV'
	
	-- EPE-5572
	Update	TMP
	Set		bank_code		= B.bank_cash_code	
	From	abr_fbpbankbook_tmp  TMP(nolock), 
			snp_voucher_hdr		B(nolock)
	where guid				= @guid
	and	TMP.document_no		= B.voucher_no
	and	TMP.tran_ou			= B.ou_id
	and TMP.tran_type		= 'PM_SPV'
	and	B.tran_type			= 'PM_SPV'
	
	-- EPE-5572
	/*code for EPE-5482 ends here */
	
	

	/* code added for the bugid:11H103_abr_00001 starts here */
	update	abr_fbpbankbook_tmp
	set	natureoftran =
		case	
			when tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV', 'PM_TPV','PM_BCT',
						'PM_PV','PM_SPPV','PM_SDV','RM_CPV') and (isnull(check_no,'') <> '' ) ----11H103_abr_00004
				then 'CP' 	
			when tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV', 'PM_TPV','PM_BCT',
						'PM_PV','PM_SPPV','PM_SDV','RM_CPV') and (isnull(check_no,'')= '' )
				then 'PY'
			when tran_type in ('PM_SRC','RM_SR','RM_IBT','RM_BCT','RM_RV','RM_PS')and ( (isnull(check_no,'') <> ''  ) )	----11H103_abr_00006
				then 'CR' 
			when tran_type in ('PM_SRC','RM_SR','RM_IBT','RM_BCT','RM_RV','RM_PS')and (isnull(check_no,'') = ''   )----11H103_abr_00006
				then 'RT' 
		--Added for 11H103_abr_00008 begins
			when tran_type in ('PM_RSRC','RM_RRV','RM_RSR') and (isnull(check_no,'') = '' )
				then 'RR' 
			when tran_type in ('PM_RSRC','RM_RRV','RM_RSR') and (isnull(check_no,'') <> '' )
				then 'CRP' 
			when tran_type in ('PM_VCK')and (isnull(check_no,'') = ''   )
				then 'PR' 
			when tran_type in ('PM_VCK') and (isnull(check_no,'') <> ''   )
				then 'CPR' 
		--Added for 11H103_abr_00008 ends

		end
	where	guid 	= @guid
	/* code added for the bugid:11H103_abr_00001 ends here */

	/*
	update	TMP
	set	tran_type = 
		(
			select	case SI.doc_status
					when 'RVD' then 'VODP'
					else SI.tran_type
				end
			from	si_doc_hdr SI(nolock)
			WHERE	TMP.document_no		= SI.tran_no
			and	TMP.tran_ou		= SI.tran_ou
			and	TMP.doc_tran_type	= SI.tran_type
		)
	from	abr_fbpbankbook_tmp TMP(rowlock)
	where	TMP.guid 	= @guid
	and	TMP.type_flag	= 'PY'

	update	abr_fbpbankbook_tmp
	set	tran_type	= 'VODPP'
	where	guid		= @guid
	and	type_flag	= 'PY'
	and	tran_type	= 'VODP'
	and	document_no not in
	(
		select	ref_doc_no
		from	abr_fbpbankbook_tmp (nolock)
		where	guid		= @guid
		and	type_flag	= 'PY'
		and	ref_doc_no is not null
	)

	Update	abr_fbpbankbook_tmp
	set	tran_type	= 'RVLP'
	where	guid		= @guid
	and	type_flag	= 'PY'
	and	doc_tran_type	= 'PM_VCK'

	Update	TMP
	set	TMP.tran_type = 
		case CI.doc_status
			when 'RV' then 'BOUR'
			else 'RVLR'
		end ,
		TMP.ref_doc_no	= CI.reversed_docno
	from	ci_doc_hdr CI(nolock) ,
		abr_fbpbankbook_tmp TMP (nolock)
	where	TMP.guid		= @guid
	and	TMP.type_flag		= 'RT'
	and	TMP.document_no		= CI.tran_no
	and	TMP.tran_ou		= CI.tran_ou
	and	TMP.doc_tran_type	= CI.tran_type
	and	CI.reversed_docno is not null

	update	abr_fbpbankbook_tmp
	set	tran_type	= 'BOURP'
	where	guid		= @guid
	and	type_flag	= 'RT'
	and	tran_type	= 'BOUR'
	and	document_no not in
	(
		select	ref_doc_no
		from	abr_fbpbankbook_tmp (nolock)
		where	guid		= @guid
		and	type_flag	= 'RT'
		and	ref_doc_no is not null
	)
	*/

	/* Code Modified by Vairamani for DMS412AT_abr_00044 Starts here */
	/*
	update	TMP
	set	tran_type =
		isnull
		(
		(
			select	case DTL.voucher_status
					when 'VD' then 'VODP'
					else DTL.payment_category
				end
			from	rp_voucher_dtl DTL(nolock)
			where	DTL.voucher_no		= TMP.document_no
			and	DTL.ou_id		= TMP.tran_ou
			and	DTL.payment_category	= TMP.doc_tran_type
			and	DTL.doc_type not in ('PM_VCK')
		),tran_type
		)
	from	abr_fbpbankbook_tmp TMP(rowlock)
	where	TMP.guid 	= @guid
	and	TMP.type_flag	= 'PY'

	*/	
	
	update	TMP
	set	tran_type 	= RPT.tran_type
	from	abr_fbpbankbook_tmp TMP(rowlock),
		(
			select	case DTL.voucher_status
					when 'VD' then 'VODP'
					else DTL.payment_category
				end 'tran_type', 
				voucher_no 'voucher_no'
			from	rp_voucher_dtl DTL(nolock) , 
					abr_fbpbankbook_tmp  TMP1 (nolock)
			where	DTL.voucher_no		= TMP1.document_no
			and		TMP1.guid 		= @guid
			and		DTL.ou_id		= TMP1.tran_ou
			and		DTL.payment_category	= TMP1.doc_tran_type
			--and		dtl.check_no		=	tmp1.check_no  --sam			--ES_abr_00642
			and		((dtl.check_no		=	tmp1.check_no)  or ( dtl.eft_no =	tmp1.comp_reference)) --ES_abr_00642
			and		DTL.doc_type not in ('PM_VCK','PM_VEFT')					--ES_abr_00642
		 )	RPT 
	where	TMP.guid 		= @guid
	and	TMP.type_flag		= 'PY'
	and	TMP.document_no		= RPT.voucher_no
	/* Code Modified by Vairamani for DMS412AT_abr_00044 Ends here */
		
	if @ctxt_user = 'check1'
	begin
		
		select	* from	abr_fbpbankbook_tmp (nolock)
		where	guid		= @guid

		select	ref_doc_no from	abr_fbpbankbook_tmp (nolock)
		where	guid		= @guid
		and	tran_type	= 'PM_VCK'
		and	ref_doc_no is not null		
	end	
	
 	update	abr_fbpbankbook_tmp
	set	tran_type	= 'VODPP'
	where	guid		= @guid
	and	type_flag	= 'PY'
	and	tran_type	= 'VODP'
	and	document_no not in
	(
		select	ref_doc_no
		from	abr_fbpbankbook_tmp (nolock)
		where	guid		= @guid
		--and	tran_type	= 'PM_VCK'			--ES_abr_00642
		and	tran_type	in ('PM_VCK','PM_VEFT') --ES_abr_00642 
		and	ref_doc_no is not null
	)

	Update	abr_fbpbankbook_tmp
	set	tran_type	= 'RVLP'
	where	guid		= @guid
	and	type_flag	= 'RT'
	--and	doc_tran_type	= 'PM_VCK'		--ES_abr_00642
	and	tran_type	in ('PM_VCK','PM_VEFT') --ES_abr_00642 

	Update	TMP
	set	TMP.tran_type = 
		case CI.doc_status
			when 'RV' then 'BOUR'
			else 'RVLR'
		end ,
		TMP.ref_doc_no	= CI.reversed_docno
	from	ci_doc_hdr CI(nolock) ,
		abr_fbpbankbook_tmp TMP (nolock)
	where	TMP.guid		= @guid
	and	TMP.type_flag		= 'RT'
	and	TMP.document_no		= CI.tran_no
	and	TMP.tran_ou		= CI.tran_ou
	and	TMP.doc_tran_type	= CI.tran_type
	and	CI.reversed_docno is not null
	
	
	/* Code Modified by Vairamani for DMS412AT_abr_00043 Starts here */
	Update	TMP
	set	TMP.tran_type = 
		case SI.doc_status
			when 'RVD' then 'BOUR'
			else 'RVLR'
		end ,
		TMP.ref_doc_no	= SI.reversed_docno
	from	si_doc_hdr SI(nolock) ,
		abr_fbpbankbook_tmp TMP (nolock)
	where	TMP.guid		= @guid
	and	TMP.type_flag		= 'RT'
	and	TMP.document_no		= SI.tran_no
	and	TMP.tran_ou		= SI.tran_ou
	and	TMP.doc_tran_type	= SI.tran_type
	and	SI.reversed_docno is not null
	/* Code Modified by Vairamani for DMS412AT_abr_00043 Ends here */
		

	update	abr_fbpbankbook_tmp
	set	tran_type	= 'BOURP'
	where	guid		= @guid
	and	type_flag	= 'RT'
	and	tran_type	= 'BOUR'
	and	ref_doc_no is not null
	and	ref_doc_no not in
	(
		select	document_no
		from	abr_fbpbankbook_tmp (nolock)
		where	guid		= @guid
		and	type_flag	= 'PY'
	)	

	/* Code Modified by Vairamani for DMS412AT_abr_00043 Starts here */
	if @ctxt_service in ('ABRRECONSRAUTO')
	begin
		/*
		update	abr_fbpbankbook_tmp
		set	tran_type_code	=
			case
				when tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV', 'PM_TPV','PM_BCT') 
					then 'SNP'
				when tran_type in ('PM_PV','PM_SPPV','PM_SDV') 
					then 'SUP'
				when tran_type in ('RM_CPV') 
					then 'CUP'
				when tran_type in ('PM_SRC') 
					then 'SUR'
				when tran_type in ('RM_SR','RM_IBT','RM_BCT') 
					then 'SNR'
				when tran_type in ('RM_RV') 
					then 'CUR'
				when tran_type in ('PM_VCK')
					then 'RVLP'
				when tran_type in ('PM_RSRC','RM_RSR','RM_RRV')
					then 'RVLR'
				else tran_type
			end
		where	guid	= @guid	

		--Code Modified by Vairamani for DMS412AT_ABR_00006 Starts here
		insert into abr_bsbb_tmp 
		(
			guid, tran_type, tran_date, ou_name, 
			payinslip_no ,document_no ,prefix ,check_no ,
			tran_amount ,taggroup ,stmt_no,
			tran_remarks ,status ,
			comp_reference ,flag ,timestamp ,
			type_flag ,
			type_remarks ,mode_flag ,
			ref_doc_tran_type ,ref_doc_acct_code ,
			ref_tran_amount ,ref_tran_ou ,void_org_no ,deposit_ou --Code Modified for DMS412AT_ABR_00005
		)
		select	@guid, tran_type_code, tran_date, ou_name,--tran_ou,
			payinslip_no, document_no, prefix, check_no ,
			tran_amount , '' ,@statementno,
			'' ,'U' ,
			comp_reference ,'B' ,1 ,
			case 
				when tran_type_code in ('SUP','SNP','CUP') then 'PY'
				when tran_type_code in ('SUR','SNR','CUR') then 'RT'
				else tran_type_code
			end,
			parameter_text ,'X' ,
			doc_tran_type ,account_code ,
			tran_amount ,tran_ou ,ref_doc_no ,deposit_ou --Code Modified for DMS412AT_ABR_00005
		from	abr_fbpbankbook_tmp (nolock),
			fin_quick_code_met (nolock)
		where	guid			= @guid
		AND 	tran_date 		<= @stenddt_tmp	
		and	component_id		= 'ABR'
		and	parameter_type		= 'COMBO'
		and	parameter_category	= 'DOCTYPE'
		and	parameter_code		= 
			case	
				when tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV', 'PM_TPV','PM_BCT') 
					then 'SNP'
				when tran_type in ('PM_PV','PM_SPPV','PM_SDV') 
					then 'SUP'
				when tran_type in ('RM_CPV') 
					then 'CUP'
				when tran_type in ('PM_SRC') 
					then 'SUR'
				when tran_type in ('RM_SR','RM_IBT','RM_BCT') 
					then 'SNR'
				when tran_type in ('RM_RV') 
					then 'CUR'
				when tran_type in ('PM_VCK')
					then 'RVLP'
				when tran_type in ('PM_RSRC','RM_RSR','RM_RRV')
					then 'RVLR'
				else tran_type
			end
		and	language_id		= @ctxt_language
		-- Code Modified by Vairamani for DMS412AT_ABR_00006 Ends here 
		*/

		update	abr_fbpbankbook_tmp
		set	tran_type_code	=
			case
				when tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV', 'PM_TPV','PM_BCT','PM_PV','PM_SPPV','PM_SDV','RM_CPV','PM_VCK')
					then 'PY'
				when tran_type in ('PM_SRC','RM_SR','RM_IBT','RM_BCT','RM_RV','PM_RSRC','RM_RSR','RM_RRV')
					then 'RT'
				else tran_type
			end
		where	guid	= @guid	

		update	abr_fbpbankbook_tmp
		set	tran_type_code	= 'BOUR',
			type_flag	= 'PS'
		where	guid		= @guid
		and	tran_type_code	= 'RT'
		and	document_no in
		(
			select	document_no
			from	abr_fbpbankbook_tmp (nolock)
			where	guid		= @guid
			and	type_flag	= 'PY'
			and	tran_type	= 'RM_PS'
		)

		update	abr_fbpbankbook_tmp
		set	tran_type_code	= 'RVLR',
			type_flag	= 'PS'
		where	guid		= @guid
		and	tran_type	= 'RM_PS'
		and	type_flag	= 'PY'
		and	document_no in
		(
			select	document_no
			from	abr_fbpbankbook_tmp (nolock)
			where	guid		= @guid
			and	type_flag	= 'PS'
			and	tran_type_code	= 'BOUR'
		)

		update	abr_fbpbankbook_tmp
		set	tran_type_code	= 'BOUR',
			type_flag	= 'PS'
		where	guid		= @guid
		and	tran_type_code	= 'RM_PS'
		and	type_flag	= 'RT'
		and	document_no in
		(
			select	document_no
			from	abr_fbpbankbook_tmp (nolock)
			where	guid		= @guid
			and	type_flag	= 'PY'
			and	tran_type	= 'RM_PS'
		)

		update	abr_fbpbankbook_tmp
		set	tran_type_code	= 'RVLR',
			type_flag	= 'PS'
		where	guid		= @guid
		and	tran_type	= 'RM_PS'
		and	type_flag	= 'PY'
		and	document_no in
		(
			select	document_no
			from	abr_fbpbankbook_tmp (nolock)
			where	guid		= @guid
			and	type_flag	= 'PS'
			and	tran_type_code	= 'BOUR'
			and	tran_type	= 'RM_PS'
		)		

		insert into abr_bsbb_tmp 
		(
			guid, tran_type, tran_date, ou_name, 
			payinslip_no ,document_no ,prefix ,check_no ,
			tran_amount ,taggroup ,stmt_no,
			tran_remarks ,status ,
			comp_reference ,flag ,timestamp ,
			type_flag ,
			type_remarks ,mode_flag ,
			ref_doc_tran_type ,ref_doc_acct_code ,
			ref_tran_amount ,ref_tran_ou ,void_org_no ,deposit_ou --Code Modified for DMS412AT_ABR_00005
			,bank_Code-- code added by Esther for the DTS id 9H123-1_rp_00028 
		)
		select	@guid, TMP.tran_type_code, tran_date, ou_name,
			payinslip_no, document_no, prefix, check_no ,
			tran_amount , '' ,@statementno,
			'' ,'U' ,
			comp_reference ,'B' ,1 ,
			case 
				when TMP.tran_type in ('PM_RSRC','RM_RSR','RM_RRV') 
					then 'RVLR'
				when (TMP.tran_type in ('RM_PS') and TMP.tran_type_code in ('RM_PS'))
					then 'RT'
				else tran_type_code
			end,
			EMOD.tran_desc ,'X' ,
			doc_tran_type ,account_code ,
			tran_amount ,tran_ou ,ref_doc_no ,deposit_ou
			,TMP.bank_Code-- code added by Esther for the DTS id 9H123-1_rp_00028 
		from	abr_fbpbankbook_tmp TMP(nolock),
			emod_post_trantype_sys EMOD(nolock)
		where	guid			= @guid
		AND 	tran_date 		<= @stenddt_tmp	
		and	doc_tran_type		= EMOD.tran_type
		and	EMOD.language_id	= @ctxt_language

		/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) starts here*/
		if exists (	select 'X'
					from	abr_opunrecon_rptpy_hdr(nolock)
					where	bank_acc_no  = @bankaccountnumber
					and		company_code = @compcode_tmp
					and		status		 = 'AUT')
		begin
			insert into abr_bsbb_tmp 
			(
				guid,				tran_type,			tran_date,		ou_name, 
				payinslip_no,		document_no,		prefix,			check_no,
				tran_amount,		taggroup,			stmt_no,		tran_remarks,
				status,				comp_reference,		flag,			timestamp,
				type_flag,			type_remarks,		mode_flag,		ref_doc_tran_type,
				ref_doc_acct_code,	ref_tran_amount,	ref_tran_ou,	void_org_no,
				deposit_ou,			bank_Code
			)
			select 
				@guid,				a.tran_type,		a.tran_date,	dbo.fin_ouname_desc(a.tran_ou),
				null,				a.tran_no,			null,			a.check_no,
				a.tran_amount,		null,				null,			a.remarks,
				'U',				company_ref_no,		'B',			1,
				case 
				when a.tran_type in ('CP','PY')
					then 'PY'
					else 'RT'
				end,		dbo.fin_quickcode_desc(
										'ABR',
										'COMBO',
										'TRANTYPE',
										a.tran_type,
										@ctxt_language),'X',			a.tran_type,
				null,				null,				a.tran_ou,		null,
				a.depositing_ou,	null	
			from	abr_opunrecon_rptpy_dtl a(nolock)
			where	a.bank_acc_no	=	@bankaccountnumber
			and		a.company_code	=	@compcode_tmp
			and		a.status		=	'U'
			and		a.tran_date		<=	@stenddt_tmp
		end
		/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) ends here*/
	end

	if @ctxt_user = 'check1'
	begin
		select 'abr_bsbb_tmp', * from abr_bsbb_tmp
		where guid = @guid
	end

	/*Code added for EPE-7274 begins here*/

	update	tmp
	set		tmp.party_code			= 	si.supplier_code,
			tmp.party_name			=	supp.supp_spmn_supname
	from	abr_fbpbankbook_tmp  tmp(nolock),
			si_doc_hdr_vw si(nolock),
			supp_spmn_suplmain supp(nolock)
	where	tmp.guid				=	@guid
	and		tmp.document_no 		= 	si.tran_no
	and		tmp.tran_ou				=	si.tran_ou
	and		tmp.doc_tran_type		=	si.tran_type	
	and		supp.supp_spmn_loid  	=	@loid_tmp
	and		supp.supp_spmn_supcode	=	si.supplier_code

	update	tmp
	set		tmp.party_code		= 	ci.cust_code,
			tmp.party_name		=	cu.clo_cust_name
	from	abr_fbpbankbook_tmp  tmp(nolock),
			ci_doc_hdr_vw ci(nolock),
			cust_lo_info cu(nolock)
	where	tmp.guid			=	@guid
	and		tmp.document_no 	= 	ci.tran_no
	and		tmp.tran_ou			=	ci.tran_ou
	and		tmp.doc_tran_type	=	ci.tran_type		
	and		cu.clo_lo  			=	@loid_tmp
	and		cu.clo_cust_code	=	ci.cust_code

	if Exists(Select	'X'
				 From	rp_voucher_dtl(Nolock) B,
						abr_fbpbankbook_tmp  TMP 
				Where	TMP.guid			= @guid
				and		B.voucher_no		= TMP.document_no
				and		B.payment_category 	= TMP.tran_type
				and		B.tran_ou			= TMP.tran_ou
				and		B.pay_mode			= 'CH')
	Begin	 
		Update	TMP
		Set		party_name			= case when party_name is null then b.payee_name  else party_name end
		From	abr_fbpbankbook_tmp  TMP (nolock), 
				rp_voucher_dtl B (nolock)
		Where	TMP.guid		= @guid
		and		B.voucher_no		= TMP.document_no
		and		(case when B.doc_type = 'PM_RP' then B.payment_category else B.doc_type end)	= TMP.tran_type
		and		B.tran_ou		= TMP.tran_ou
		and exists( 
						Select 'X'
						From	rp_checkseries_dtl dtl(nolock)
						Where	dtl.check_no  = b.check_no
						and		dtl.checkno_status in ('VD','AT','PR')
					  )
	End
	
	if Exists(Select	'X'
		From	rp_voucher_dtl(Nolock) B,
				abr_fbpbankbook_tmp  TMP 
		Where	TMP.guid			= @guid
		and		B.voucher_no		= TMP.document_no
		and		B.payment_category 	= TMP.tran_type
		and		B.tran_ou			= TMP.tran_ou
		and		B.pay_mode			<> 'CH')
	Begin
		Update	TMP
		Set		party_name			= case when party_name is null then b.payee_name  else party_name end  
		From	abr_fbpbankbook_tmp  TMP (nolock), 
				rp_voucher_dtl B (nolock)
		Where	TMP.guid			= @guid
		and		B.voucher_no		= TMP.document_no
		and		B.payment_category 	= TMP.tran_type
		and		B.tran_ou			= TMP.tran_ou
		and		B.pay_mode			<> 'CH'    		
	End

	Update	TMP
	Set		party_code				= case when party_code is null then supplier_code  else party_code end ,
			party_name				=  case when party_name is null then supp_spmn_supname  else party_name end 
	From	abr_fbpbankbook_tmp  TMP (nolock), 
			sr_receipt_MST B (nolock),
			supp_spmn_suplmain supp(nolock)
	Where	TMP.guid				= @guid
	and		B.receipt_no			= TMP.document_no
	and		B.ou_id					= TMP.tran_ou
	and		B.tran_type				= TMP.tran_type	
	and		supp.supp_spmn_loid  	= @loid_tmp
	and		supp.supp_spmn_supcode	= supplier_code
	
	Update	TMP
	Set		party_code				= case when party_code is null then B.cust_code  else party_code end , --code modified for EBS-4247
			party_name				=	case when party_name is null then clo_cust_name  else party_name end 
	From	abr_fbpbankbook_tmp  TMP (nolock), 
			rpt_receipt_hdr B (nolock),
			cust_lo_info cu(nolock)
	Where	TMP.guid				= @guid
	and		B.receipt_no			= TMP.document_no
	and		B.ou_id					= TMP.tran_ou
	and		B.tran_type				= TMP.tran_type	
	and		cu.clo_lo  				= @loid_tmp
	and		cu.clo_cust_code		= B.cust_code	--code modified for EBS-4247
				

	Update	TMP
	Set		party_name				= case when party_name is null then remitter  else party_name end  
	From	abr_fbpbankbook_tmp  TMP(nolock), 
			rr_payinslip_dtl B (nolock)
	Where	guid					= @guid
	and		TMP.document_no			= B.receipt_no
	and		TMP.tran_type 			= B.receipt_type
	and		TMP.tran_ou				= B.ou_id
	
	--EPE-7861
	update	tmp
	set		tmp.party_code			= 	si.supplier_code,
			tmp.party_name			=	supp.supp_spmn_supname
	from	abr_opunrecon_rptpy_dtl  tmp(nolock),
			si_doc_hdr_vw si(nolock),
			supp_spmn_suplmain supp(nolock)
	where	tmp.company_code		=	@compcode_tmp
	and		tmp.tran_no	 			= 	si.tran_no
	and		tmp.tran_ou				=	si.tran_ou
	--and		tmp.doc_tran_type		=	si.tran_type	
	and		supp.supp_spmn_loid  	=	@loid_tmp
	and		supp.supp_spmn_supcode	=	si.supplier_code

	update	tmp
	set		tmp.party_code		= 	ci.cust_code,
			tmp.party_name		=	cu.clo_cust_name
	from	abr_opunrecon_rptpy_dtl  tmp(nolock),
			ci_doc_hdr_vw ci(nolock),
			cust_lo_info cu(nolock)
	where	tmp.company_code		=	@compcode_tmp
	and		tmp.tran_no 		= 	ci.tran_no
	--and		tmp.tran_ou			=	ci.tran_ou
	--and		tmp.doc_tran_type	=	ci.tran_type		
	and		cu.clo_lo  			=	@loid_tmp
	and		cu.clo_cust_code	=	ci.cust_code

	if Exists(Select	'X'
				 From	rp_voucher_dtl(Nolock) B,
						abr_opunrecon_rptpy_dtl  TMP 
				Where	tmp.company_code		=	@compcode_tmp
				and		B.voucher_no		= tmp.tran_no
				and		B.payment_category 	= TMP.tran_type
				and		B.tran_ou			= TMP.tran_ou
				and		B.pay_mode			= 'CH')
	Begin	 
		Update	TMP
		Set		party_name			= case when party_name is null then b.payee_name  else party_name end
		From	abr_opunrecon_rptpy_dtl  TMP (nolock), 
				rp_voucher_dtl B (nolock)
		Where	tmp.company_code		=	@compcode_tmp
		and		B.voucher_no		= tmp.tran_no
		and		(case when B.doc_type = 'PM_RP' then B.payment_category else B.doc_type end)	= TMP.tran_type
		and		B.tran_ou		= TMP.tran_ou
		and exists( 
						Select 'X'
						From	rp_checkseries_dtl dtl(nolock)
						Where	dtl.check_no  = b.check_no
						and		dtl.checkno_status in ('VD','AT','PR')
					  )
	End
	
	if Exists(Select	'X'
		From	rp_voucher_dtl(Nolock) B,
				abr_opunrecon_rptpy_dtl  TMP 
		Where	tmp.company_code		=	@compcode_tmp
		and		B.voucher_no		= tmp.tran_no
		and		B.payment_category 	= TMP.tran_type
		and		B.tran_ou			= TMP.tran_ou
		and		B.pay_mode			<> 'CH')
	Begin
		Update	TMP
		Set		party_name			= case when party_name is null then b.payee_name  else party_name end  
		From	abr_opunrecon_rptpy_dtl  TMP (nolock), 
				rp_voucher_dtl B (nolock)
		Where	tmp.company_code		=	@compcode_tmp
		and		B.voucher_no		= tmp.tran_no
		and		B.payment_category 	= TMP.tran_type
		and		B.tran_ou			= TMP.tran_ou
		and		B.pay_mode			<> 'CH'    		
	End

	Update	TMP
	Set		party_code				= case when party_code is null then supplier_code  else party_code end ,
			party_name				=  case when party_name is null then supp_spmn_supname  else party_name end 
	From	abr_opunrecon_rptpy_dtl  TMP (nolock), 
			sr_receipt_MST B (nolock),
			supp_spmn_suplmain supp(nolock)
	Where	tmp.company_code		=	@compcode_tmp
	and		B.receipt_no			= tmp.tran_no
	and		B.ou_id					= TMP.tran_ou
	and		B.tran_type				= TMP.tran_type	
	and		supp.supp_spmn_loid  	= @loid_tmp
	and		supp.supp_spmn_supcode	= supplier_code
	
	Update	TMP
	Set		party_code				= case when party_code is null then cust_code  else party_code end , 
			party_name				=	case when party_name is null then clo_cust_name  else party_name end 
	From	abr_opunrecon_rptpy_dtl  TMP (nolock), 
			rpt_receipt_hdr B (nolock),
			cust_lo_info cu(nolock)
	Where	tmp.company_code		=	@compcode_tmp
	and		B.receipt_no			= tmp.tran_no
	and		B.ou_id					= TMP.tran_ou
	and		B.tran_type				= TMP.tran_type	
	and		cu.clo_lo  				= @loid_tmp
	and		cu.clo_cust_code		= cust_code	
				

	Update	TMP
	Set		party_name				= case when party_name is null then remitter  else party_name end  
	From	abr_opunrecon_rptpy_dtl  TMP(nolock), 
			rr_payinslip_dtl B (nolock)
	Where	tmp.company_code		=	@compcode_tmp
	and		tmp.tran_no			= B.receipt_no
	and		TMP.tran_type 			= B.receipt_type
	and		TMP.tran_ou				= B.ou_id
	--EPE-7861
	/*Code added for EPE-7274 ends here*/

	if @ctxt_service not in ('ABRRECONSRAUTO')
	begin
		

		
		/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
		select	tran_amount											'amount',
			ltrim(rtrim(check_no))									'checknumber',
			ltrim(rtrim(comp_reference))							'companyref',
			tran_date												'date',
			ltrim(rtrim(deposit_ou))								'depositingpoint',
			ltrim(rtrim(document_no))								'documentno',
			ltrim(rtrim(prefix))									'prefix',
			ltrim(rtrim(tran_remarks))								'remarks',
			''														'taggroup',
			ltrim(rtrim(EMOD.tran_desc))							'transactiontypeml',
			ltrim(rtrim(ou_name))									'transactionoumlb',
			dbo.fin_quickcode_desc(	'ABR',
										'COMBO',
										'NATTRAN',				-------11H103_abr_00008
										TMP.natureoftran,
										@ctxt_language
									)							'natureoftransaction', ---11H103_abr_00001
									r.bank_ref_no                            'BankReference_Tran'  --epe-3918
		,Paybatch_no				'paybatchno',		-- EPE-5027	--EPE-5482
		bank_code					'bankcodeml1'	    -- EPE-5027 --EPE-5482
		,party_code					'partycode', --EPE-7274
		party_name					'partyname'  --EPE-7274
		from	abr_fbpbankbook_tmp 	TMP(nolock)
		 left outer join rp_bnkref_inf r(nolock)  --EPE-4838
		 on (document_no            = tran_no   
		     and tmp.doc_tran_type  = r.tran_type 
		     and tmp.tran_ou        = r.tran_ou),    --EPE-4838
			emod_post_trantype_sys 	EMOD(nolock)		
		where	TMP.guid		= @guid
		--and document_no             = tran_no   --epe-3918
		--and tmp.doc_tran_type       = r.tran_type --epe-3918
		--and tmp.tran_ou             = r.tran_ou --epe-3918
		and 	TMP.tran_date 		<= @stenddt_tmp	
		and	TMP.doc_tran_type	= EMOD.tran_type
		and	EMOD.language_id	= @ctxt_language
--		and	QC.component_id		= 'ABR'
--		and	QC.parameter_type	= 'COMBO'
--		and	QC.parameter_category	= 'TRANTYPE'
--		and	QC.parameter_code	= TMP.natureoftran
--		and	QC.language_id		= @ctxt_language

		/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) starts here*/
		--order by tran_date
		union
		select	tran_amount							'amount',
				ltrim(rtrim(check_no))							'checknumber',
				ltrim(rtrim(company_ref_no))						'companyref',
				tran_date							'date',
				ltrim(rtrim(depositing_ou))						'depositingpoint',
				ltrim(rtrim(tran_no))							'documentno',
				null								'prefix',
				ltrim(rtrim(remarks))								'remarks',
				''									'taggroup',
				dbo.fin_quickcode_desc(
						'ABR',
						'COMBO',
						'TRANTYPE',
						tran_type,
						@ctxt_language)				'transactiontypeml',
				dbo.fin_ouname_desc(tran_ou)		'transactionoumlb',
				dbo.fin_quickcode_desc(	'ABR',
										'COMBO',
										'NATTRAN',						----11H103_abr_00008
										tran_type,
										@ctxt_language
									)				 'natureoftransaction', ---- ---11H103_abr_00001
									null                           'BankReference_Tran'  --epe-3918
			,null 						'paybatchno',		-- EPE-5027
			null 						'bankcodeml1'	    -- EPE-5027
			,party_code					'partycode', ----EPE-7861
			party_name					'partyname'  ----EPE-7861
		from	abr_opunrecon_rptpy_dtl a(nolock)
		where	a.bank_acc_no	=	@bankaccountnumber
		and		a.company_code	=	@compcode_tmp
		and		a.status		=	'U'
		order by 4
		/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) ends here*/
		
		/*
		select	tran_amount				'amount',
			check_no				'checknumber',
			comp_reference				'companyref',
			tran_date				'date',
			--ou_name				'depositingpoint',
			deposit_ou				'depositingpoint',
			document_no				'documentno',
			prefix					'prefix',
			tran_remarks				'remarks',
			''					'taggroup',
			parameter_text				'transactiontypeml',
			ou_name					'transactionoumlb'
		from	abr_fbpbankbook_tmp (nolock),
			fin_quick_code_met (nolock)
		where	guid			= @guid
		AND 	tran_date 		<= @stenddt_tmp	
		and	component_id		= 'ABR'
		and	parameter_type		= 'COMBO'
		and	parameter_category	= 'DOCTYPE'
		and	parameter_code		= 
			case	
				when tran_type in ('PM_IBT','PM_APV', 'PM_HPV', 'PM_SPV', 'PM_TPV','PM_BCT') 
					then 'SNP'
				when tran_type in ('PM_PV','PM_SPPV','PM_SDV') 
					then 'SUP'
				when tran_type in ('RM_CPV') 
					then 'CUP'
				when tran_type in ('PM_SRC') 
					then 'SUR'
				when tran_type in ('RM_SR','RM_IBT','RM_BCT') 
					then 'SNR'
				when tran_type in ('RM_RV') 
					then 'CUR'
				when tran_type in ('PM_VCK')
					then 'RVLP'
				when tran_type in ('PM_RSRC','RM_RSR','RM_RRV')
					then 'RVLR'
				else tran_type
			end
		and	language_id		= @ctxt_language
		order by tran_date
		*/
		/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */
	end
	/* Code Modified by Vairamani for DMS412AT_abr_00043 Ends here */
--EPE-5027
	--if exists
	--(
	--	select	'X'
	--	from	abr_fbpbankbook_tmp (nolock)
	--	where 	guid 	= @guid
	--)
	--begin
	--	delete 	from abr_fbpbankbook_tmp 
	--	where 	guid = @guid
	--end
--EPE-5027
	set nocount off
end








