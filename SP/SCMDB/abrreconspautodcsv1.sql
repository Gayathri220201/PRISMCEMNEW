/*$File_version=ms4.3.0.47$*/
/*$$filename = abrreconspautodcsv1.sql*/
/*************************************************************************************************
Component	: 	ABR
Description	:	Auto Reconciliation
Author		:	Vairamani C
Date		:	Nov 12 2007
Remarks		:	ABRDMS412AT_000134 - ABR Changes -- Code Revamped
**************************************************************************************************
Modification details :
	Modified By			Date			Remarks
	Vairamani C			Nov 21 2007		ABRDMS412AT_000134
	Vairamani C			Jan 11 2008		DMS412AT_ABR_00006
	Vairamani C			Mar 01 2008		DMS412AT_ABR_00005
	Vairamani C			Mar 14 2008		DMS412AT_abr_00038
	Vairamani C			Mar 18 2008		DMS412AT_abr_00086
	Uma Maheswari		Mar 18 2008		DMS412AT_ABR_00087
	Vairamani C			Mar 19 2008		DMS412AT_ABR_00089
	Vairamani C			Mar 19 2008		DMS412AT_abr_00096/DMS412AT_abr_00102
	Vairamani C			Mar 20 2008		DMS412AT_abr_00105
	Vairamani C			Mar 24 2008		DMS412AT_abr_00106
	Uma Maheswari		Mar 25 2008		DMS412AT_ABR_00114
	Vairamani C			Apr 10 2008		DMS412AT_abr_00043
	Vairamani C			Apr 10 2008		DMS412AT_abr_00107
	Vairamani C			Apr 14 2008		DMS412AT_abr_00121/DMS412AT_abr_00125
	Vairamani C			Apr 15 2008		DMS412AT_abr_00126
	Vairamani C			Apr 17 2008		DMS412AT_abr_00073/DMS412AT_abr_00128
	Angelin.R 			Mar 24 2009		ES_bnkdef_00013
	Esther J			Nov 11 2009		9H123-1_rp_00028 
	Esther J			Nov 24 2009		9H123-1_abr_00005[9h123-1_RPT_00069]
	Anitha N 			Feb 11 2010		9H123-1_abr_00006
	P Balaji			25 June 2010	ES_abr_00024
	Veangadakrishnan R	11/08/2010		ES_abr_00031(10H109_ABR_00001)
	Veangadakrishnan R	19/08/2010		ES_abr_00031(10H109_ABR_00001:10H109_abr_00030)
	Vairamani C			26 Oct 2010		ES_abr_00062
	Satya Murty KV      03/2/03/2011    ES_ABR_00072
	T.Suresh			17/04/2011		Es_abr_00095
	Dinesh D			08/09/2011		ES_abr_00117
	Samuvel G			20/09/2011		ES_REP_00643
	Indira G			03/02/2012		ES_abr_00141
	Aditya Sitaraman	03/09/2014		ES_abr_00402
	Aditya Sitaraman	06/07/2015		ES_Rep_02297
    Divyalekaa			16/09/2015		14H109_FCC_00002
    Kavitha R			05/04/2016		14H109_rpt_00070
    Ramesh Kumar        01/12/2017      EPE-3918
	Aditya S			24/01/2018		DA-78
	Amrutha R.S			07/01/2018		EPE-5027
	Kavitha R			22/01/2018		EPE-5510
	/*Amani.P			26/06/2018		EPE-7564*/
	/*Amani.P			27/06/2018		EPE-7270 : epe-8248*/
	/*Aditya S			22/11/2018		BSF-21				*/
	Banurekha B         30/1/2019       TLET-342
	Aditya S			18/06/2020		PTP-977
	Aditya S			21/09/2020		PTP-1171
	Abhijith KP			26-09-2023		EPE-68785
	Abhijith KP			30-10-2023		EPE-68785:EPE-71762
	Saranraj C          04-09-2024      EPE-88044
*************************************************************************************************/
Create procedure abrreconspautodcsv1
(
	@bankaccountnumber	fin_banknumber,
	@banknohdr			fin_bankname,
	@ctxt_language		fin_languageid,
	@ctxt_ouinstance	fin_ouinstid,
	@ctxt_service		fin_service, 
	@ctxt_user			fin_userid,
	@enddate			fin_date,
	@guid				fin_guid,
	@hidden_control1	fin_hiddencontrol,
	@startdate			fin_date,
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	@statementno1		fin_statementnumber,
	@raisebnkchg		fin_checkbox,
	@financebook		fin_financebookid,
	@bankcode			fin_bankcode,
	@costcenter			fin_costcenter,
	@analysiscode		fin_analysiscode,
	@subanalysiscode	fin_subanalysiscode,
	@transactionou		fin_chargesou,
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */
	@jvnarration		fin_comments, -- Code Added for DMS412AT_ABR_00089
	@raiserpt           fin_checkbox, --EPE-5027
	@m_errorid			fin_int output
)
as
begin
	set nocount on

	--BEGIN of Standard code for getting precision type
	declare @pqty_tmp                  fin_int ,
			@pamt_tmp                  fin_int ,
			@prate_tmp                 fin_int ,
			@perate_tmp                fin_int ,
			@phigh_tmp                 fin_int ,
			@pmed_tmp                  fin_int ,
			@plow_tmp         fin_int
	
	exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
	     @prate_tmp output, @perate_tmp output, @phigh_tmp output,
	     @pmed_tmp output, @plow_tmp output
	--END of Standard code for getting precision type

	declare	@sysdt_tmp			fin_date,
		@compcode_tmp			fin_companycode,
		--@bank_code				fin_bankcode, 
		@refno_tmp				fin_documentno,
		@statementno			fin_statementnumber, /* Code Modified for DMS412AT_ABR_00005 */
		@tag_group				fin_code,
		@seq_no					fin_int,
		@errormsgout			fin_text2500,
		@paymentpoint			fin_ouinstname,
		@snp_raise_amount		fin_amount,
		@buid_tmp				fin_buid,
		@line_no				fin_int,
		@currency_code			fin_currency,
		@bank_charges_account	fin_accountcode,
		@chg_coll_account		fin_accountcode,
		--@default_fb_id			fin_financebookid,
		--@default_bankcode		fin_bankcode,
		@bank_charge_amt 		fin_amount,
		@chg_coll_amt			fin_amount,
		@voucher_no				fin_documentno,
		@tag_group_st			fin_code,
		/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
		@tag_group_recon		fin_code,
		@error_tmp				fin_int,
		@raise_bank_charges		fin_flag,
		/* Code Added by Vairamani for DMS412AT_abr_00105 Starts here */
		@state_flag 			fin_flag,
		@pay_voucherno			fin_documentno,
		/* Code Modified by Vairamani for DMS412AT_abr_00106 Starts here */
		@bacc_fbp_ibe_amt		fin_amount,
		@opbal_ibe				fin_amount,
		@ibe_drcr_flag			fin_flag
		/* Code Modified by Vairamani for DMS412AT_abr_00106 Ends here */
		/* Code Added by Vairamani for DMS412AT_abr_00105 Ends here */
		/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */

	/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) starts here*/
	declare @opunrecon_pybal	fin_amount
	declare @opunrecon_rtbal	fin_amount
	declare @opunrecon_bal		fin_amount
	declare @opunrecon_exist	fin_flag

	--BSF-21	
	declare	@financial_period	fin_financeperiod,
			@financial_year		fin_financeyear,
			@curcode			fin_currencycode
	--BSF-21	
	/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) ends here*/
	
	select @bankaccountnumber = ltrim(rtrim(@bankaccountnumber))
	if @bankaccountnumber = '~#~'
		select @bankaccountnumber = null

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
	if @statementno1 = '~#~'
		select @statementno1 = null

	select @raisebnkchg = ltrim(rtrim(@raisebnkchg))
	if @raisebnkchg = '~#~'
		select @raisebnkchg = null

	select @startdate = ltrim(rtrim(@startdate))
	if (@startdate = '1900-01-01' or @startdate = '01/01/1900')
		select @startdate = null

	select @enddate = ltrim(rtrim(@enddate))
	if (@enddate = '1900-01-01' or @enddate = '01/01/1900')
		select @enddate = null

	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	select @financeBook = ltrim(rtrim(@financeBook))
	if @financeBook = '~#~'
		select @financeBook = null

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

	/* Code Modified by Vairamani for DMS412AT_ABR_00089 Starts here */
	select @jvnarration = ltrim(rtrim(@jvnarration))
	if @jvnarration = '~#~'
		select @jvnarration = null
	/* Code Modified by Vairamani for DMS412AT_ABR_00089 Ends here */

	/*code for 	EPE-5027 begins here */
	Set @raiserpt				= ltrim(rtrim(@raiserpt)) 
	IF @raiserpt				= '~#~'		Select @raiserpt = null  	
	/*code for 	EPE-5027 ends here */

	
	/*Code added for 14H109_FCC_00002 begins here*/
	DECLARE	@called_from			fin_desc40
	
	select	@called_from	=	'NONE'
	
	if exists	(	select	'*'
					from	fcc_hub_bkclosure_tmp (nolock)
					where	guid	=	@guid
				)
	begin				
		select	@called_from	=	'FCC_HUB'
	end	
	/*Code added for 14H109_FCC_00002 ends here*/	
	--EPE-5510
	if exists(select 1 from abr_bankstmt_tmp(nolock)
					where	guid	 = @guid)
	begin
		select	@called_from	=	'BRS_HUB'
	end					
	--EPE-5510

	--Clear the Temp table.
	if exists
	(
		select	'X'
		from	abr_bank_reconcile_tmp (nolock)
		where	guid		= @guid
	)
	begin		
		delete	abr_bank_reconcile_tmp
		where	guid = @guid
	end
	
	if exists
	(
		select	'X'
		from	abr_bsbb_tmp (nolock)
		where	guid	= @guid
	)
	begin
		delete	abr_bsbb_tmp
		where	guid = @guid
	end

	--@m_errorid should be 0 to indicate success
	select @m_errorid = 0
	
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	select @seq_no = 0

	--Get the system date.
	select @sysdt_tmp = convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120)

	/*
	--Get the company code.
	select	@compcode_tmp 	= company_code,
		@paymentpoint	= ouinstname,
		@buid_tmp	= bu_id
	from	emod_ou_vw (nolock)
	where	ou_id		= @ctxt_ouinstance
	and	@sysdt_tmp between effective_from 
		and isnull(effective_to, @sysdt_tmp)
	*/

	/*
	-- Get Bank Code for the Bank Account Number.
	select	top 1 @bank_code	= bank_code
	from	bnkdef_code_mst BNK (nolock)
	where	BNK.bank_acc_no		= @bankaccountnumber
	and	BNK.company_code	= @compcode_tmp
	and	BNK.flag		= 'B'
	and 	BNK.status		= '2'
	*/

	select @state_flag = lower('snpstate2') /* Code Added by Vairamani for DMS412AT_abr_00105 */

	--Get the company code.
	select	@compcode_tmp 	= company_code
	from	emod_ou_vw (nolock)
	where	ou_id		= @ctxt_ouinstance
	and	@sysdt_tmp between effective_from 
		and isnull(effective_to, @sysdt_tmp)

	select	@currency_code 	= currency_code
	from	bnkdef_acc_mst(nolock)
	where	company_code	= @compcode_tmp
	and	bank_acc_no	= @bankaccountnumber

	select @statementno = @statementno1

	--Check if Statement Number, Start Date and End date have been given.
	if (@statementno is null and @startdate is null and @enddate is null)
	begin
		--Enter statement number or the start and end dates
		select	@m_errorid = 20
		return
	end

	/* Code Commented by Vairamani for DMS412AT_abr_00102 Starts here */
	/*
	if ((@raisebnkchg = '0') and (@bankcode is null))
	begin
		-- Get Bank Code for the Bank Account Number.
		select	top 1 @bankcode		= bank_code
		from	bnkdef_code_mst BNK (nolock)
		where	BNK.bank_acc_no		= @bankaccountnumber
		and	BNK.company_code	= @compcode_tmp
		and	BNK.flag		= 'B'
		and 	BNK.status		= '2'		
	end
	*/
	/* Code Commented by Vairamani for DMS412AT_abr_00102 Ends here */
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */

	if (@statementno is null)
	begin
		if (@startdate is null)
		begin
			--Enter the Start Date
			select	@m_errorid = 24
			return
		end
		
		if (@enddate is null)
		begin
			--Enter End Date
			select	@m_errorid = 23
			return
		end

		if (@startdate > @enddate)
		begin
			--Start Date must precede End Date. Enter a valid date.
			select	@m_errorid = 19
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

		select 	@statementno	= stmt_no
		from 	abr_bank_statement_dtl (nolock)
		where 	company_code 	= @compcode_tmp
		and 	bank_acc_no 	= @bankaccountnumber
		and 	tran_date between @startdate and @enddate
		*/
		/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */
	end
	else
	begin
		if ((@startdate is not null) or (@enddate is not null))
		begin
			--Enter statement number or the start and end dates
			select	@m_errorid = 20
			return
		end

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

		select 	@startdate	= stmt_start_date,
			@enddate	= stmt_end_date
 		from 	abr_bank_statement_hdr (nolock)
		where 	company_code 	= @compcode_tmp
		and 	bank_acc_no 	= @bankaccountnumber
		and	stmt_no		= @statementno
	end

	--Frame the Reference Number.
	select	@refno_tmp 		= convert(nvarchar(10),isnull(max(convert(int,ref_no)),0)+ 1)
	from	abr_bank_statement_dtl(nolock)
	where	company_code 		= @compcode_tmp
	--and	stmt_no 		= @statementno /* Code Modified for DMS412AT_ABR_00005 */
	and	bank_acc_no		= @bankaccountnumber 
	and	isnumeric(ref_no) 	= 1

	/* Code Modified by Vairamani for DMS412AT_ABR_00006 Starts here */
	--Insert the Bank Statement details into temp table for reconciliation.
	insert into abr_bsbb_tmp 
	(
		guid, tran_type, tran_date, ou_name, 
		payinslip_no, prefix, stmt_no, check_no, 
		tran_amount,
		tran_remarks, status, taggroup, 
		comp_reference, flag, 
		serial_no, timestamp, mode_flag,
		type_flag, 
		type_remarks, bank_ref_no		-- EPE-3918
	)
	select	@guid, tran_type, tran_date, 
		--ou_id, 
		case 
			when DTL.ou_id = 0 then ''
			else 
			(	
				select 	ouinstname 
				from 	emod_ou_vw (nolock)
				where 	ou_id 	= DTL.ou_id 
			)
		end,
		payinslip_no, prefix, stmt_no, check_no, 
		tran_amount,
		tran_remarks, recon_status, '', 
		comp_reference, 'S', 
		serial_no, 1, 'X',
		case 
			when tran_type in ('CP','PY','ID') then 'PY'
			when tran_type in ('CR','RT','IC') then 'RT'
			else tran_type
		end,
		QC.parameter_text, bank_ref_no		-- EPE-3918
	from	abr_bank_statement_dtl DTL(nolock),
		fin_quick_code_met QC (nolock)
	where	company_code		= @compcode_tmp
	and	bank_acc_no		= @bankaccountnumber
	--and	stmt_no			= @statementno
	and	DTL.tran_date between @startdate and @enddate /* Code Modified for DMS412AT_ABR_00005 */
	and	recon_status		= 'U'
	and	QC.component_id		= 'ABR'
	and	QC.parameter_type	= 'COMBO'
	and	QC.parameter_category	= 'TRANTYPE'
	and	QC.parameter_code	= tran_type
	and	QC.language_id		= @ctxt_language	
	/* Code Modified by Vairamani for DMS412AT_ABR_00006 Ends here */
	/*Code Added by Angelin.R for the Bug id : ES_bnkdef_00013 Starts here*/

	--EPE-68785
	declare @trantype_code fin_trantype,
			@transactiontype fin_desc255

	select @trantype_code = tran_type,
		   @transactiontype = type_remarks	
	from abr_bsbb_tmp(nolock)
	where guid = @guid
	

	
	if  @trantype_code in ( 'ID','IC','SC')  and  @raisebnkchg = 0
	begin
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,132,@transactiontype
			return
	end
	--EPE-68785

	if exists
	(
		select	'X'
		from	abr_bsbb_tmp (nolock)
		where	guid	= @guid
		and	flag	= 'S'
		and	comp_reference is not null
	)
	begin
		if exists
		(
			select	'X'
			from	abr_bsbb_tmp TMP (nolock),
				rp_voucher_dtl RP (nolock)
			where	TMP.guid		= @guid
			and	TMP.flag		= 'S'
			and	TMP.comp_reference is not null
			and	TMP.comp_reference	= RP.comp_reference
			and	RP.flag			= 'LC'
		)
		begin
			if exists 
			(
				select 	'X'
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	comp_reference is not null
				group by comp_reference
				having count('X') > 1
			)
			begin
				update	TMP
				set	TMP.flag			= 'N'
				from	abr_bsbb_tmp TMP (nolock),
				(
					select	distinct comp_reference, guid, flag
					from	abr_bsbb_tmp (nolock)
					where	guid		= @guid
					and	flag		= 'S'
					and	comp_reference is not null
					group by comp_reference,guid, flag
					having count('X') > 1
				)DRTB 
				where	TMP.guid		= @guid
				and	TMP.flag		= 'S'
				and	TMP.comp_reference is not null
				and	TMP.guid		= DRTB.guid
				and	TMP.flag		= DRTB.flag
				and	TMP.comp_reference	= DRTB.comp_reference
			end
		end
	end

	if exists
	(
		select	'X'
		from	abr_bsbb_tmp (nolock)
		where	guid	= @guid
		and	flag	= 'S'
		and	comp_reference is not null
	)
	begin
		if exists
		(
			select	'X'
			from	abr_bsbb_tmp TMP (nolock),
				rpt_receipt_hdr RPT (nolock)
			where	TMP.guid		= @guid
			and	TMP.flag		= 'S'
			and	TMP.comp_reference is not null
			and	TMP.comp_reference	= RPT.LC_Number
			and	RPT.receipt_mode	= 'LC'
		)
		begin
			if exists 
			(
				select 	'X'
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	comp_reference is not null
				group by comp_reference
				having count('X') > 1
			)
			begin
				update	TMP
				set	TMP.flag			= 'N'
				from	abr_bsbb_tmp TMP (nolock),
				(
					select	distinct comp_reference, guid, flag
					from	abr_bsbb_tmp (nolock)
					where	guid		= @guid
					and	flag		= 'S'
					and	comp_reference is not null
					group by comp_reference,guid, flag
					having count('X') > 1
				)DRTB 
				where	TMP.guid		= @guid
				and	TMP.flag		= 'S'
				and	TMP.comp_reference is not null
				and	TMP.guid		= DRTB.guid
				and	TMP.flag		= DRTB.flag
				and	TMP.comp_reference	= DRTB.comp_reference
			end
		end
		--14H109_rpt_00070
		if exists
		(
			select	'X'
			from	abr_bsbb_tmp TMP (nolock),
				rpt_receipt_hdr RPT (nolock)
			where	TMP.guid		= @guid
			and	TMP.flag		= 'S'
			and	TMP.comp_reference is not null
			and	TMP.comp_reference	= RPT.comp_reference
			and	RPT.receipt_mode	= 'DB'
		)
		begin
			if exists 
			(
				select 	'X'
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	comp_reference is not null
				group by comp_reference
				having count('X') > 1
			)
			begin
				update	TMP
				set	TMP.flag			= 'N'
				from	abr_bsbb_tmp TMP (nolock),
				(
					select	distinct comp_reference, guid, flag
					from	abr_bsbb_tmp (nolock)
					where	guid		= @guid
					and	flag		= 'S'
					and	comp_reference is not null
					group by comp_reference,guid, flag
					having count('X') > 1
				)DRTB 
				where	TMP.guid		= @guid
				and	TMP.flag		= 'S'
				and	TMP.comp_reference is not null
				and	TMP.guid		= DRTB.guid
				and	TMP.flag		= DRTB.flag
				and	TMP.comp_reference	= DRTB.comp_reference
			end
		end
		--14H109_rpt_00070		
	end
	/*Code Added by Angelin.R for the Bug id : ES_bnkdef_00013 Ends here*/

	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	/* Code added by Vairamani for DMS412AT_abr_00086 Starts here */
	/* Code Commented by Vairamani for DMS412AT_abr_00126 Starts here */
	/*
	if not exists 
	(	
		select	'x'
		from	abr_bsbb_tmp (nolock)
		where	guid 	= @guid 
		and	flag	= 'S'
	)
	begin
		--No records are available for Auto-Reconciliation.
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,120
		return	
	end
	*/
	/* Code Commented by Vairamani for DMS412AT_abr_00126 Ends here */
	if @ctxt_user = 'check'
	begin
		select 'abr_bsbb_tmp'
		select * from abr_bsbb_tmp where guid = @guid
	end


	--Call the Child SP to populate the Temp Tables for Bank Book Entries
	exec abrreconspgetmlb1 	@bankaccountnumber, @banknohdr, @ctxt_language, @ctxt_ouinstance,
				@ctxt_service, @ctxt_user, @enddate, @guid, @hidden_control1,
				@startdate, @statementno, @financebook,	@bankcode, @transactionou,
				@costcenter, @analysiscode, @subanalysiscode, @m_errorid output

	-- EPE-3918
	update	t
	set		t.bank_ref_no	=	r.bank_ref_no
	from	abr_bsbb_tmp  t,
			rp_bnkref_inf r(nolock)
	where	guid 		 = @guid 
	and		flag		 = 'B'
	and 	t.document_no    = r.tran_no   
	and		t.ref_doc_tran_type	= r.tran_type
	and		t.ref_tran_ou	= r.tran_ou
	-- EPE-3918
				
	if not exists 
	(	
		select	'x'
		from	abr_bsbb_tmp (nolock)
		where	guid 	= @guid 
		and	flag	= 'B'
	)
	begin

 ----Code added by Abhijith KP for EPE-68785 starts here
	if	 exists 
	(	
			select	'x'
			from	abr_bsbb_tmp (nolock)
			where	guid 	= @guid 
			and		flag	= 'S'
			and		tran_type in ('ID','SC','IC')
			and		mode_flag in ('X','Y','Z')
	)
	begin

			update	abr_bsbb_tmp
			set		mode_flag	= 'S'
			where	guid 	= @guid 
			and		flag	= 'S'
			and		tran_type not in ('ID','SC','IC')
			and		mode_flag in ('X','Y','Z')
	end
	----Code added by Abhijith KP for EPE-68785 ends here

	else
	begin
	/*code added for the defect id TLET-342	starts here*/
	if @statementno is not null
		begin
			--No records are available for the bank statement no - %d.
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,1900030015,@statementno
			return
		end
	else
	/*code added for the defect id TLET-342	ends here*/
		--No records are available for Auto-Reconciliation.
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,120
		return	
	end
	end

	if @ctxt_user = 'snpuser'
	begin
		select 'bbb'
		select tran_type,type_flag,type_remarks,ref_doc_tran_type,document_no,payinslip_no,check_no,tran_amount,void_org_no,
		* from abr_bsbb_tmp (nolock) where guid = @guid
	end

	if (@raisebnkchg = '0')
	begin
		if ((@costcenter is not null) or (@analysiscode is not null) or (@subanalysiscode is not null))
		begin
			--'Raise bank charges not checked.Cost center/analysis/subanalysis  codes cannot be given'
			exec fin_sp_raise_error '', '', '', '', 'ABR', 38848,@m_errorid output
			return
		end
	end
	/* Code added by Vairamani for DMS412AT_abr_00086 Ends here */

	/* Sequences for Auto Reconcile
	   1. Try to rencoile the Voided Payment Vs Reversal Payment and Bounce Receipt Vs Reversal Receipt
		[Within Bank Book Reconciliation]
	   2. Try to reconcile the Bank Statement and Bank Book with Payment Entries - Ref as Check No.
	   3. Try to reconcile the Bank Statement and Bank Book with Payment Entries - Ref as Company Ref.
	   4. Try to reconcile the Bank Statement and Bank Book with Receipt Entries - Ref as Pay-In-Slip or Direct Receipts.
	   5. Try to reconcile the Bank Statement and Bank Book with Receipt Entries - Ref as Instrument No
	   6. Raise Bank Charges for Diff in Receipt Amount Calculation
	   7. Charges Posting Reconcile
	*/

	declare	@prev_stmt_no		fin_statementnumber,
		@stmtno_tmp		fin_statementnumber,
		@curr_stmt_st_date	fin_date,
		@prev_stmt_end_date	fin_date,
		@prev_stmt_cb_bal	fin_amount,
		@curr_stmt_op_bal	fin_amount,
		@curr_stmt_drcr		fin_drcridentifier,
		@prev_stmt_drcr		fin_drcridentifier
        ,@curr_seq_no		fin_int		-- Code Added by satya Murty KV For the Defect Id: ES_ABR_00072
	/* Code Modified by Vairamani for DMS412AT_abr_00106 Starts here */
	if 
	(
		select	count(distinct stmt_no)
		from	abr_bsbb_tmp (nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	mode_flag in ('X','Y','Z')
	)=1
	begin -- Count = 1

		select	@stmtno_tmp	= stmt_no
		from	abr_bsbb_tmp (nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	mode_flag in ('X','Y','Z')

		select 	@curr_stmt_st_date	= stmt_start_date,
			@curr_stmt_op_bal	= open_bal,
			@curr_stmt_drcr		= openbal_drcr
		from 	abr_bank_statement_hdr (nolock)
		where 	company_code 		= @compcode_tmp 
		and 	bank_acc_no 		= @bankaccountnumber
		and 	stmt_no 		= @stmtno_tmp

		select	@prev_stmt_end_date	= max(stmt_end_date)
				--@prev_stmt_no		= stmt_no -- code modified by Dinesh D for the defect id: ES_abr_00117
		from 	abr_bank_statement_hdr (nolock)
		where 	company_code 		= @compcode_tmp 
		and 	bank_acc_no 		= @bankaccountnumber
		and	stmt_start_date		< @curr_stmt_st_date
		--group by stmt_no -- code modified by Dinesh D for the defect id: ES_abr_00117
		
		-- code modified by Dinesh D for the defect id: ES_abr_00117
		select	@prev_stmt_no		= stmt_no 
		from 	abr_bank_statement_hdr (nolock)
		where 	company_code 		= @compcode_tmp 
		and 	bank_acc_no 		= @bankaccountnumber
		and		stmt_end_date		= @prev_stmt_end_date
		-- code modified by Dinesh D for the defect id: ES_abr_00117

		select	@prev_stmt_cb_bal	= close_bal,
			@prev_stmt_drcr		= closebal_drcr
		from 	abr_bank_statement_hdr (nolock)
		where 	company_code 		= @compcode_tmp 
		and 	bank_acc_no 		= @bankaccountnumber
		and	stmt_no			= @prev_stmt_no

		--BSF-21	
		select	@financial_period	=	financial_period,
				@financial_year		=	financial_year
		from	abr_bank_recon_start(nolock)
		where	company_code		=	@compcode_tmp
		and		bank_accountno		=	@bankaccountnumber
		--BSF-21	

		if ((isnull(@curr_stmt_op_bal,0) <> isnull(@prev_stmt_cb_bal,0)) or (@curr_stmt_drcr <> @prev_stmt_drcr))
		begin
			if @prev_stmt_no is null
			begin
			--BSF-21	
			 if isnull(@financial_period ,'') = ''
			 begin
			 --BSF-21	 
				select 	@bacc_fbp_ibe_amt	=
					sum
					(
						case drcr_flag
							when 'DR' then tran_amount 
							else (tran_amount * -1)
						end
					)
				from 	fbp_ibe_trn_dtl IBE(nolock),
				(
					select 	BNK.bank_Code,ARD.bankptt_account,BNK.fb_id,ARD.company_code
					from 	bnkdef_code_mst BNK(nolock),
						ard_bnkcsh_account_mst ARD (nolock)
					where 	BNK.company_code 	= @compcode_tmp
					and 	BNK.flag 		= 'B' 
					and 	BNK.status 		= '2'
					and 	BNK.bank_acc_no 	= @bankaccountnumber
					and	BNK.bank_code		= ARD.bank_ptt_code
					and	BNK.company_code	= ARD.company_code
					and	BNK.fb_id		= ARD.fb_id
					and	BNK.flag		= ARD.flag
					and	dbo.RES_Getdate(@ctxt_ouinstance) between ARD.effective_from 
						and isnull(ARD.effective_to,dbo.RES_Getdate(@ctxt_ouinstance))
				)DER
				where	DER.company_code	= IBE.company_code
				and	DER.fb_id		= IBE.fb_id
				and	DER.bankptt_account	= IBE.account_code
				and	IBE.company_code	= @compcode_tmp
			--BSF-21
			 end  
			 else  
			 begin  
				select	@curcode		=	currency_code 
				from	bnkdef_acc_mst   (nolock)
				where	bank_acc_no		=	@bankaccountnumber  
				and		company_code	=	@compcode_tmp  

				select  @bacc_fbp_ibe_amt = sum(ob_debit)-sum(ob_credit) 
				from	fbp_account_balance fbp(nolock),    
				(    
					select  bnk.bank_code,ard.bankptt_account,bnk.fb_id,ard.company_code    
					from	bnkdef_code_mst bnk(nolock),    
							ard_bnkcsh_account_mst ard (nolock)    
					where	bnk.company_code	= @compcode_tmp    
					and		bnk.flag			= 'B'     
					and		bnk.status			= '2'    
					and		bnk.bank_acc_no		= @bankaccountnumber    
					and		bnk.bank_code		= ard.bank_ptt_code    
					and		bnk.company_code	= ard.company_code    
					and		bnk.fb_id			= ard.fb_id    
					and		bnk.flag			= ard.flag    
					and		@sysdt_tmp between ard.effective_from and isnull(ard.effective_to,@sysdt_tmp)    
				)	der    
				where	fbp.company_code	=	der.company_code    
				and		fbp.fb_id			=	der.fb_id    
				and		fbp.account_code	=	der.bankptt_account   
				and		fbp.company_code	=	@compcode_tmp    
				and		fbp.currency_code	=	@curcode  
				and		fbp.fin_year		=	@financial_year  
				and		fbp.fin_period		=	@financial_period 			
			
				select  @bacc_fbp_ibe_amt = isnull(@bacc_fbp_ibe_amt,0) + isnull((sum(ob_debit)-sum(ob_credit) ),0)
				from	fbp_account_balance fbp(nolock),    
				(    
					select  bnk.bank_code,ard.interim_account,bnk.fb_id,ard.company_code    
					from	bnkdef_code_mst bnk(nolock),    
							ard_bnkcsh_account_mst ard (nolock)    
					where	bnk.company_code	= @compcode_tmp    
					and		bnk.flag			= 'B'     
					and		bnk.status			= '2'    
					and		bnk.bank_acc_no		= @bankaccountnumber    
					and		bnk.bank_code		= ard.interim_account    
					and		bnk.company_code	= ard.company_code    
					and		bnk.fb_id			= ard.fb_id    
					and		bnk.flag			= ard.flag    
					and		@sysdt_tmp between ard.effective_from and isnull(ard.effective_to,@sysdt_tmp)    
				)	der  
				where	fbp.company_code	=	der.company_code    
				and		fbp.fb_id			=	der.fb_id    
				and		fbp.account_code	=	der.interim_account   
				and		fbp.company_code	=	@compcode_tmp    
				and		fbp.currency_code	=	@curcode  
				and		fbp.fin_year		=	@financial_year  
				and		fbp.fin_period		=	@financial_period   					
			end  
			--BSF-21

				/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) starts here*/
				select  @opunrecon_pybal	= 0
				select	@opunrecon_rtbal	= 0
				select	@opunrecon_bal		= 0
				select	@opunrecon_exist    = 'N'

				if exists (	select	'X'
							from	abr_opunrecon_rptpy_hdr(nolock)
							where	bank_acc_no		=	@bankaccountnumber
							and		company_code	=	@compcode_tmp
							and		status			=	'AUT')/*Added for DTS ID: ES_abr_00031(10H109_ABR_00001:10H109_abr_00030)*/
				begin
					select	@opunrecon_exist = 'Y'

					select	@opunrecon_pybal= sum(tran_amount)
					from	abr_opunrecon_rptpy_dtl(nolock)
					where	bank_acc_no		=	@bankaccountnumber
					and		company_code	=	@compcode_tmp	
					and		tran_type		in	('CP','PY')

					select	@opunrecon_rtbal= sum(tran_amount)
					from	abr_opunrecon_rptpy_dtl(nolock)
					where	bank_acc_no		=	@bankaccountnumber
					and		company_code	=	@compcode_tmp	
					and		tran_type		in	('CR','RT')

					select @opunrecon_pybal = isnull(@opunrecon_pybal,0)
					select @opunrecon_rtbal = isnull(@opunrecon_rtbal,0)
			
					select @opunrecon_bal = @opunrecon_pybal - @opunrecon_rtbal

					select @bacc_fbp_ibe_amt = @opunrecon_bal+isnull(@bacc_fbp_ibe_amt,0)
				end
				/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) ends here*/
		
				if @bacc_fbp_ibe_amt is null
				begin
					if (@curr_stmt_op_bal <> 0)
					begin
						-- Opening Balance should be 0.00 for the first statement of the Bank Account No.as initial Balance 
						-- entry is not available for the account codes  
						exec fin_german_raiserror_sp 'ABR',@ctxt_language,118
						return	
					end
				end
				else
				begin
					select @opbal_ibe = abs(@bacc_fbp_ibe_amt)
		
					select @ibe_drcr_flag	= 
							case 
								when @bacc_fbp_ibe_amt < 0 then 'DR'
								else 'CR'
							end
									
					if ((@opbal_ibe <> @curr_stmt_op_bal) or (@curr_stmt_drcr <> @ibe_drcr_flag))
					begin
						/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) starts here*/
						if @opunrecon_exist = 'Y'
						begin
							/*Opening Balance of the First Statement of the Bank Account no should be the Initial Balance Entry in FBP for the Bank's Account Codes 
							+/- Authorized Unreconciled Payments / receipts for the Bank Account No. Modify the Opening Balance*/
							exec fin_german_raiserror_sp 'ABR',@ctxt_language,1018
							return
						end
						else
						begin
						/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001) ends here*/
							-- Opening Balance of the First Statement of the Bank Account no should be the 
							-- Initial Balance Entry in FBP for the account codes of the Bank Account No.Modify the Opening Balance.
							exec fin_german_raiserror_sp 'ABR',@ctxt_language,119
							return
						end/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001)*/
					end
				end				
			end
			else
			begin
				-- Opening balance of Current Statement No - %s does not tally with the closing balance of the previous statement no - %s
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,98,@stmtno_tmp,@prev_stmt_no
				return
			end
		end
		/* Code Modified by Vairamani for DMS412AT_abr_00107 Starts here */
		else
		begin
			if (datediff(day,@prev_stmt_end_date,@curr_stmt_st_date) <> 1)
			begin
				-- Start Date of the Statement - %s is not 1 day after the End Date of the Previous Statement - %s.
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,127,@stmtno_tmp,@prev_stmt_no
				return
			end
		end
		/* Code Modified by Vairamani for DMS412AT_abr_00107 Ends here */

		/* Code Modified by Vairamani for DMS412AT_abr_00128 Starts here */
		/* Code commented by T.Suresh for bugid es_abr_00095 starts here */
		/*
		if exists
		(
			select	'X'
			from 	abr_bank_statement_hdr (nolock)
			where 	company_code 		= @compcode_tmp 
			and 	bank_acc_no 		= @bankaccountnumber
			and	stmt_start_date		< @curr_stmt_st_date
			and	recon_status		= 'U'
		)
		begin
			select	@prev_stmt_no		= stmt_no
			from 	abr_bank_statement_hdr (nolock)
			where 	company_code 		= @compcode_tmp 
			and 	bank_acc_no 		= @bankaccountnumber
			and	stmt_start_date		< @curr_stmt_st_date
			and	recon_status		= 'U'
			order by stmt_end_date desc

			--Previous Statement No - %s is not in Reconciled Status.
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,97,@prev_stmt_no
			return
		end
		*/
		/* Code commented by T.Suresh for bugid es_abr_00095 ends here */
		/* Code Modified by Vairamani for DMS412AT_abr_00128 Ends here */
	end -- Count = 1
	else
	begin
	/* Code Modified by Vairamani for DMS412AT_abr_00106 Ends here */
		declare Valid_St_recon_status cursor for
		select 	distinct stmt_no
		from	abr_bsbb_tmp (nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	mode_flag in ('X','Y','Z')
	
		open Valid_St_recon_status
	
		fetch next from Valid_St_recon_status into @stmtno_tmp
	
		while @@fetch_status = 0
		begin	
			select 	@curr_stmt_st_date	= stmt_start_date,
				@curr_stmt_op_bal	= open_bal,
				@curr_stmt_drcr		= openbal_drcr
				,@curr_seq_no		= seq_no	-- Code Added by satya Murty KV For the Defect Id: ES_ABR_00072
			from 	abr_bank_statement_hdr (nolock)
			where 	company_code 		= @compcode_tmp 
			and 	bank_acc_no 		= @bankaccountnumber
			and 	stmt_no 		= @stmtno_tmp
	
			select	@prev_stmt_end_date	= max(stmt_end_date),
				@prev_stmt_no		= stmt_no
			from 	abr_bank_statement_hdr (nolock)
			where 	company_code 		= @compcode_tmp 
			and 	bank_acc_no 		= @bankaccountnumber
			and	    stmt_start_date		< @curr_stmt_st_date
			and	    seq_no		    = @curr_seq_no-1		-- Code Added by satya Murty KV For the Defect Id: ES_ABR_00072
			group by stmt_no
	
			select	@prev_stmt_cb_bal	= close_bal,
				@prev_stmt_drcr		= closebal_drcr
			from 	abr_bank_statement_hdr (nolock)
			where 	company_code 		= @compcode_tmp 
			and 	bank_acc_no 		= @bankaccountnumber
			and	stmt_no			= @prev_stmt_no
	
			if ((@curr_stmt_op_bal <> @prev_stmt_cb_bal) or (@curr_stmt_drcr <> @prev_stmt_drcr))
			begin
				update	abr_bsbb_tmp
				set	mode_flag	= 'S'
				where	guid		= @guid
				and	flag		= 'S'
				and	mode_flag in ('X','Y','Z')
				and	stmt_no		= @stmtno_tmp
			end
	
			fetch next from Valid_St_recon_status into @stmtno_tmp
		end
		close Valid_St_recon_status
		deallocate Valid_St_recon_status
	end -- Code Modified by Vairamani for DMS412AT_abr_00106
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */

	/*
	   1. Try to rencoile the Voided Payment Vs Reversal Payment and Bounce Receipt Vs Reversal Receipt
		[Within Bank Book Reconciliation]
	*/

	/*
	-- Tag Group Generation
	select	@tag_group 		= max(convert(int,taggroup))
	from	abr_bank_statement_dtl(nolock)
	where	company_code 		= @compcode_tmp
	and	stmt_no 		= @statementno
	and	bank_acc_no		= @bankaccountnumber
	and	isnumeric(taggroup) 	= 1
	*/

	-- Tag Group Generation
	select	@tag_group_st 		= max(convert(int,taggroup))
	from	abr_bank_statement_dtl(nolock)
	where	company_code 		= @compcode_tmp 
	--and	stmt_no 		= @statementno /* Code Modified for DMS412AT_ABR_00005 */
	and	bank_acc_no		= @bankaccountnumber
	and	isnumeric(taggroup) 	= 1

	select	@tag_group_recon 	= max(convert(int,taggroup))
	from	abr_bank_reconcile_dtl(nolock)
	where	company_code 		= @compcode_tmp
	--and	stmt_no 		= @statementno /* Code Modified for DMS412AT_ABR_00005 */
	and	bank_acc_no		= @bankaccountnumber
	and	isnumeric(taggroup) 	= 1
	
	if (isnull(@tag_group_st,0) > isnull(@tag_group_recon,0))
		select @tag_group = isnull(@tag_group_st,0)
	else
		select @tag_group = isnull(@tag_group_recon,0)

	select	@tag_group = isnull(@tag_group,0)

	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */	
	--Get the latest serial number updated for the Bank Account Number in Bank Book.
	if exists
	(
		select	'X'
		from	abr_bank_reconcile_dtl (nolock)
		where	company_code	= @compcode_tmp
		and	bank_acc_no	= @bankaccountnumber
	)
	begin	
		select	@seq_no 	= isnull(max(serial_no),0)
	 	from	abr_bank_reconcile_dtl (nolock)
		where	bank_acc_no	= @bankaccountnumber
		and	company_code	= @compcode_tmp
		--and	stmt_no		= @statementno /* Code Commented for ABRDMS412AT_000134 */
	end
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */

	if exists
	(
		select	'X'
		from	abr_bsbb_tmp (nolock)
		where	guid		= @guid
		and	flag		= 'B'
		and	type_flag in ('VODP','RVLP','BOUR','RVLR')
		and	mode_flag in ('X','Y','Z')
	)
	begin
		if exists
		(
			select	'X'
			from	
			(
				select	sum(isnull(tran_amount,0)) tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid	= @guid
				and	flag	= 'B'
				and	type_flag in ('VODP','BOUR')
				and	mode_flag in ('X','Y','Z')
				and	status	= 'U'
			) VOID,
			(
				select	sum(isnull(tran_amount,0)) tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid	= @guid
				and	flag	= 'B'
				and	type_flag in ('RVLP','RVLR')
				and	mode_flag in ('X','Y','Z')
				and	status	= 'U'
			) REV
			where	isnull(VOID.tran_amount,0) <> isnull(REV.tran_amount,0)
		)
		begin
			-- Voided Amount mismatch between Voided/Reversal Payments and Bounce/Reversal Receipts Transaction.
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,34,'','','','','','','',@errormsgout
			return			
		end

		select	@tag_group = isnull(@tag_group,0)+1

		update	abr_bsbb_tmp
		set	serial_no	= @seq_no,
					  @seq_no = @seq_no + 1,
			status		= 'R',
			taggroup	= @tag_group
		where	guid		= @guid
		and	flag		= 'B'
		and	type_flag in ('VODP','RVLP','BOUR','RVLR')
		and	mode_flag in ('X','Y','Z')
	end

	/*
	   2. Try to reconcile the Bank Statement and Bank Book with Payment Entries - Ref as Check No.
	*/
	if exists
	(
		select 	'X'
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid		= @guid
			and	flag		= 'B'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	isnull(STMT.check_no,'') 	= isnull(BANK.check_no,'') --9H123-1_abr_00006
			and	status		= 'U'
			)
	)
	begin
		select	@tag_group = isnull(@tag_group,0)+1

		update	STMT
		set	status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid		= @guid
			and	flag		= 'B'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	isnull(STMT.check_no,'') 	= isnull(BANK.check_no,'') --9H123-1_abr_00006
			and	status		= 'U'
			)
	
		update	BANK 
		set	serial_no	= @seq_no,
					  @seq_no = @seq_no + 1,
			status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp BANK(nolock)
		where	guid		= @guid
		and	flag		= 'B'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	exists
			(
			select	'x'
			from	abr_bsbb_tmp STMT(nolock)
			where	guid		= @guid
			and	flag		= 'S'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	isnull(STMT.check_no,'') 	= isnull(BANK.check_no,'') --9H123-1_abr_00006
			and	status		= 'R'
			)
	end

	/*
	   3. Try to reconcile the Bank Statement and Bank Book with Payment Entries - Ref as Company Ref.
	*/
	
	--14H109_rpt_00070
	if exists
	(
		select 	'X'
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('RT')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('RT')
			and	mode_flag in ('X','Y','Z')
			and	STMT.comp_reference 	= BANK.comp_reference
			and	status			= 'U'
			)
	)
	begin

		select	@tag_group = isnull(@tag_group,0)+1

		update	STMT
		set	status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('RT')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('RT')
			and	mode_flag in ('X','Y','Z')
			and	STMT.comp_reference 	= BANK.comp_reference
			and	status			= 'U'
			)
	
	
		update	BANK 
		set	serial_no	= @seq_no,
					  @seq_no = @seq_no + 1,
			status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp BANK(nolock)
		where	guid		= @guid
		and	flag		= 'B'
		and	type_flag in ('RT')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	exists
			(
			select	'x'
			from	abr_bsbb_tmp STMT(nolock)
			where	guid			= @guid
			and	flag			= 'S'
			and	type_flag in ('RT')
			and	mode_flag in ('X','Y','Z')
			and	STMT.comp_reference 	= BANK.comp_reference
			and	status			= 'R'
			)
	end
	-- EPE-3918
		
	if exists
	(	
		--DA-78
		/*
		select 	'X'
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('RT')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	STMT.comp_reference is null
		and	STMT.payinslip_no is null
		and	STMT.check_no is null
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('RT')
			and	mode_flag in ('X','Y','Z')
			and	STMT.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'U'
			)
		*/
		select 	'X'
		from	
		(select STMT.bank_ref_no , sum(tran_amount) 'tran_amount'
		from abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('RT')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	STMT.comp_reference is null
		and	STMT.payinslip_no is null
		and	STMT.check_no is null
		group by STMT.bank_ref_no
		) A
		where A.tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('RT')
			and	mode_flag in ('X','Y','Z')
			and	A.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'U'
			)
		--DA-78
	)
	begin

		select	@tag_group = isnull(@tag_group,0)+1

		update	STMT
		set	status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('RT')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	STMT.comp_reference is null
		and	STMT.payinslip_no is null
		and	STMT.check_no is null
		--DA-78
		/*
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('RT')
			and	mode_flag in ('X','Y','Z')
			and	STMT.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'U'
			)
		*/
		and stmt.bank_ref_no in 
		(
		select 	A.bank_ref_no
		from	
		(select STMT.bank_ref_no , sum(tran_amount) 'tran_amount'
		from abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('RT')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	STMT.comp_reference is null
		and	STMT.payinslip_no is null
		and	STMT.check_no is null
		group by STMT.bank_ref_no
		) A
		where A.tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('RT')
			and	mode_flag in ('X','Y','Z')
			and	A.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'U'
			)
		)
		--DA-78
	
	
		update	BANK 
		set	serial_no	= @seq_no,
					  @seq_no = @seq_no + 1,
			status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp BANK(nolock)
		where	guid		= @guid
		and	flag		= 'B'
		and	type_flag in ('RT')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	exists
			(
			select	'x'
			from	abr_bsbb_tmp STMT(nolock)
			where	guid			= @guid
			and	flag			= 'S'
			and	type_flag in ('RT')
			and	mode_flag in ('X','Y','Z')
			and	STMT.bank_ref_no 	= BANK.bank_ref_no
			and	STMT.comp_reference is null
			and	STMT.payinslip_no is null
			and	STMT.check_no is null			
			and	status			= 'R'
			)
	end	
	
	if exists
	(	--DA-78
		/*
		select 	'X'
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	STMT.comp_reference is null
		and	STMT.payinslip_no is null
		and	STMT.check_no is null			
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	STMT.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'U'
			)
		*/
		select 	'X'
		from	
		(select  STMT.bank_ref_no , sum(tran_amount) 'tran_amount'
		from abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	STMT.comp_reference is null
		and	STMT.payinslip_no is null
		and	STMT.check_no is null		
		group by STMT.bank_ref_no
		)	A
		where A.tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	A.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'U'
			)
		--DA-78
	)
	begin

		select	@tag_group = isnull(@tag_group,0)+1

		update	STMT
		set	status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	STMT.comp_reference is null
		and	STMT.payinslip_no is null
		and	STMT.check_no is null	
		--DA-78
		/*		
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	STMT.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'U'
			)
		*/
		and STMT.bank_ref_no 	in 
		(
		select A.bank_ref_no
		from	
		(select  STMT.bank_ref_no , sum(tran_amount) 'tran_amount'
		from abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	STMT.comp_reference is null
		and	STMT.payinslip_no is null
		and	STMT.check_no is null		
		group by STMT.bank_ref_no
		)	A
		where A.tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	A.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'U'
			)
		)
		--DA-78
	
		update	BANK 
		set	serial_no	= @seq_no,
					  @seq_no = @seq_no + 1,
			status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp BANK(nolock)
		where	guid		= @guid
		and	flag		= 'B'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	exists
			(
			select	'x'
			from	abr_bsbb_tmp STMT(nolock)
			where	guid			= @guid
			and	flag			= 'S'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	STMT.bank_ref_no 	= BANK.bank_ref_no
			and	status			= 'R'
			and	STMT.comp_reference is null
			and	STMT.payinslip_no is null
			and	STMT.check_no is null				
			)
	end		
	-- EPE-3918
	--14H109_rpt_00070
	
	if exists
	(
		select 	'X'
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	STMT.comp_reference 	= BANK.comp_reference
			and	status			= 'U'
			)
	)
	begin

		select	@tag_group = isnull(@tag_group,0)+1

		update	STMT
		set	status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp STMT(nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	tran_amount
			=
			(
			select	sum(bank.tran_amount)
			from	abr_bsbb_tmp BANK(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	STMT.comp_reference 	= BANK.comp_reference
			and	status			= 'U'
			)
	
	
		update	BANK 
		set	serial_no	= @seq_no,
					  @seq_no = @seq_no + 1,
			status		= 'R',
			taggroup	= @tag_group
		from	abr_bsbb_tmp BANK(nolock)
		where	guid		= @guid
		and	flag		= 'B'
		and	type_flag in ('PY')
		and	status		= 'U'
		and	mode_flag in ('X','Y','Z')
		and	exists
			(
			select	'x'
			from	abr_bsbb_tmp STMT(nolock)
			where	guid			= @guid
			and	flag			= 'S'
			and	type_flag in ('PY')
			and	mode_flag in ('X','Y','Z')
			and	STMT.comp_reference 	= BANK.comp_reference
			and	status			= 'R'
			)
	end	
	
	
	/* Code Modified and Commented by Vairamani for DMS412AT_abr_00121 Starts here */
	if (@raisebnkchg = '0') -- Check box not checked
	begin -- raisebnk chg = 0
		if exists
		(
			select	'X'
			from 
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount) tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'U'
				group by payinslip_no,guid,type_flag,Status
			)ST,
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount)tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'U'
				group by payinslip_no,guid,type_flag,Status
			)BNK
			where	ST.guid		= BNK.guid
			and	isnull(ST.payinslip_no,'')= isnull(BNK.payinslip_no,'') --9H123-1_abr_00006
			and	ST.type_flag	= BNK.type_flag
			and	ST.status	= BNK.status
			and	ST.guid		= @guid
			and	ST.tran_amount	= BNK.tran_amount
		)
		begin
			select	@tag_group = isnull(@tag_group,0)+1
	
			update	TMP
			set	TMP.status	= 'R',
				TMP.taggroup	= @tag_group
			from 	abr_bsbb_tmp	TMP (nolock),
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount) tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'U'
				group by payinslip_no,guid,type_flag,Status
			)ST,
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount)tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'U'
				group by payinslip_no,guid,type_flag,Status
			)BNK
			where	ST.guid		= BNK.guid
			--and	ST.payinslip_no	= BNK.payinslip_no --PTP-977
			and	isnull(ST.payinslip_no,'')	= isnull(BNK.payinslip_no,'') --PTP-977
			and	ST.type_flag	= BNK.type_flag
			and	ST.status	= BNK.status
			and	ST.guid		= @guid
			and	ST.tran_amount	= BNK.tran_amount
			and	TMP.guid	= BNK.guid
			and	isnull(TMP.payinslip_no,'')= isnull(BNK.payinslip_no,'') --9H123-1_abr_00006
			and	TMP.type_flag	= BNK.type_flag 
			and	TMP.status	= BNk.status
			and	TMP.flag	= 'S'
			and	TMP.type_flag in ('RT')
			and	TMP.status	= 'U'
			and	TMP.mode_flag in ('X','Y','Z')
	
			update	BANK
			set	serial_no	= @seq_no,
						  @seq_no = @seq_no + 1,
				status		= 'R',
				taggroup	= @tag_group
			from	abr_bsbb_tmp BANK(nolock)
			where	guid		= @guid
			and	flag		= 'B'
			and	type_flag in ('RT')
			and	status		= 'U'
			and	mode_flag in ('X','Y','Z')
			and	exists
				(
				select	'x'
				from	abr_bsbb_tmp STMT(nolock)
				where	guid			= @guid
				and	flag			= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	isnull(STMT.payinslip_no,'')= isnull(BANK.payinslip_no,'') ----9H123-1_abr_00006
				and	status			= 'R'
				and	STMT.taggroup	= @tag_group --PTP-977
				)
		end

	end -- raisebnk chg = 0
	else
	begin -- raisebnk chg = 1

		if exists
		(
			select	'X'
			from 
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount) tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'U'
				group by payinslip_no,guid,type_flag,Status
			)ST,
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount)tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'U'
				group by payinslip_no,guid,type_flag,Status
			)BNK
			where	ST.guid		= BNK.guid
			and	isnull(ST.payinslip_no,'')= isnull(BNK.payinslip_no,'')--9H123-1_abr_00006
			and	ST.type_flag	= BNK.type_flag
			and	ST.status	= BNK.status
			and	ST.guid		= @guid
			and	ST.tran_amount	<= BNK.tran_amount
		)
		begin
			select	@tag_group = isnull(@tag_group,0)+1
	
			update	TMP
			set	TMP.status	= 'R',
				TMP.taggroup	= @tag_group
			from 	abr_bsbb_tmp	TMP (nolock),
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount) tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'U'
				group by payinslip_no,guid,type_flag,Status
			)ST,
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount)tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'U'
				group by payinslip_no,guid,type_flag,Status
			)BNK
			where	ST.guid		= BNK.guid
			and	isnull(ST.payinslip_no,'')= isnull(BNK.payinslip_no,'')--9H123-1_abr_00006
			and	ST.type_flag	= BNK.type_flag
			and	ST.status	= BNK.status
			and	ST.guid		= @guid
			and	ST.tran_amount	<= BNK.tran_amount
			and	TMP.guid	= BNK.guid
			and	isnull(TMP.payinslip_no,'')= isnull(BNK.payinslip_no,'')--9H123-1_abr_00006
			and	TMP.type_flag	= BNK.type_flag
			and	TMP.status	= BNk.status
			and	TMP.flag	= 'S'
			and	TMP.type_flag in ('RT')
			and	TMP.status	= 'U'
			and	TMP.mode_flag in ('X','Y','Z')


			/* Code added by Esther  J for the DTS id 9H123-1_abr_00005[9h123-1_RPT_00069] starts */
			update tmp
			set  instr_type = hdr.instr_type
			from	abr_bsbb_tmp tmp(nolock),rpt_receipt_hdr hdr (nolock)
			where	tmp.guid			= @guid
			and	tmp.flag			= 'B'
			and	tmp.type_flag 			in ('RT')
			and	tmp.mode_flag		 	in ('X','Y','Z')
			and tmp.ref_tran_ou			= hdr.ou_id
			and tmp.ref_doc_tran_type   		= hdr.tran_type
			and tmp.document_no			= hdr.receipt_no


			update tmp
			set  instr_type = hdr.instr_type
			from	abr_bsbb_tmp tmp(nolock),sur_receipt_hdr hdr (nolock)
			where	tmp.guid			= @guid
			and	tmp.flag			= 'B'
			and	tmp.type_flag 			in ('RT')
			and	tmp.mode_flag		 	in ('X','Y','Z')
			and tmp.ref_tran_ou			= hdr.ou_id
			and tmp.ref_doc_tran_type   		= hdr.tran_type
			and tmp.document_no			= hdr.receipt_no

			update tmp
			set  instr_type = hdr.instr_type
			from	abr_bsbb_tmp tmp(nolock),sr_receipt_mst hdr (nolock)
			where	tmp.guid			= @guid
			and	tmp.flag			= 'B'
			and	tmp.type_flag 			in ('RT')
			and	tmp.mode_flag		 	in ('X','Y','Z')
			and tmp.ref_tran_ou			= hdr.ou_id
			and tmp.ref_doc_tran_type   		= hdr.tran_type
			and tmp.document_no			= hdr.receipt_no

			update	TMP
			set	TMP.status	= 'U',
				TMP.taggroup	= NULL
			from 	abr_bsbb_tmp	TMP (nolock),
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount) tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag 	in ('RT')
				and	mode_flag 	in ('X','Y','Z')
				and	Status		= 'R'
				group by payinslip_no,guid,type_flag,Status
			)ST,
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount)tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid			= @guid
				and	flag			= 'B'
				and	type_flag 		in ('RT')
				and	mode_flag		in ('X','Y','Z')
				and	Status			= 'U'
				and isnull(instr_type,'') 	= 'AP'
				group by payinslip_no,guid,type_flag,Status
			)BNK
			where	ST.guid		= BNK.guid
			and	ST.payinslip_no	= BNK.payinslip_no
			and	ST.type_flag	= BNK.type_flag
			and	ST.guid		= @guid
			and	ST.tran_amount	< BNK.tran_amount
			and	TMP.guid	= BNK.guid
			and	isnull(TMP.payinslip_no,'')= isnull(BNK.payinslip_no,'')--9H123-1_abr_00006
			and	TMP.type_flag	= BNK.type_flag
			and	TMP.flag	= 'S'
			and	TMP.type_flag 	in ('RT')
			and	TMP.status	= 'R'
			and	TMP.mode_flag 	in ('X','Y','Z')
			/* Code added by Esther  J for the DTS id 9H123-1_abr_00005[9h123-1_RPT_00069] ends*/

			update	BANK
			set	serial_no	= @seq_no,
						  @seq_no = @seq_no + 1,
				status		= 'R',
				taggroup	= @tag_group
			from	abr_bsbb_tmp BANK(nolock)
			where	guid		= @guid
			and	flag		= 'B'
			and	type_flag in ('RT')
			and	status		= 'U'
			and	mode_flag in ('X','Y','Z')
			and	exists
				(
				select	'x'
				from	abr_bsbb_tmp STMT(nolock)
				where	guid			= @guid
				and	flag			= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	isnull(STMT.payinslip_no,'')= isnull(BANK.payinslip_no,'')--9H123-1_abr_00006
				and	status			= 'R'
				)
		end
	end -- raisebnk chg = 1 

	/*
	   4. Try to reconcile the Bank Statement and Bank Book with Receipt Entries - Ref as Pay-In-Slip or Direct Receipts.
	*/

	/*
	if (@raisebnkchg = '0') -- Check box not checked
	begin -- raisebnk chg = 0
		if exists
		(
			select	'X'
			from	abr_bsbb_tmp STMT(nolock)
			where	guid		= @guid
			and	flag		= 'S'
			and	type_flag in ('RT')
			and	status		= 'U'
			and	mode_flag in ('X','Y','Z')
			and	tran_amount = 
				(
				select	sum(tran_amount)
				from	abr_bsbb_tmp BANK(nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	STMT.payinslip_no = BANK.payinslip_no
				and	status		= 'U'
				)
		)
		begin

			select	@tag_group = isnull(@tag_group,0)+1
	
			update	STMT
			set	status		= 'R',
				taggroup	= @tag_group
			from	abr_bsbb_tmp STMT(nolock)
			where	guid		= @guid
			and	flag		= 'S'
			and	type_flag in ('RT')
			and	status		= 'U'
			and	mode_flag in ('X','Y','Z')
			and	tran_amount = 
				(
				select	sum(tran_amount)
				from	abr_bsbb_tmp BANK(nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	STMT.payinslip_no = BANK.payinslip_no
				and	status		= 'U'
				)
		
			update	BANK
			set	serial_no	= @seq_no,
						  @seq_no = @seq_no + 1,
				status		= 'R',
				taggroup	= @tag_group
			from	abr_bsbb_tmp BANK(nolock)
			where	guid		= @guid
			and	flag		= 'B'
			and	type_flag in ('RT')
			and	status		= 'U'
			and	mode_flag in ('X','Y','Z')
			and	exists
				(
				select	'x'
				from	abr_bsbb_tmp STMT(nolock)
				where	guid			= @guid
				and	flag			= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	STMT.payinslip_no 	= BANK.payinslip_no
				and	status			= 'R'
				)
		end
	end -- raisebnk chg = 0
	else
	begin -- raisebnk chg = 1
		if exists
		(
			select	'X'
			from	abr_bsbb_tmp STMT(nolock)
			where	guid		= @guid
			and	flag		= 'S'
			and	type_flag in ('RT')
			and	status		= 'U'
			and	mode_flag in ('X','Y','Z')
			and	tran_amount <= 
				(
				select	sum(tran_amount)
				from	abr_bsbb_tmp BANK(nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	STMT.payinslip_no = BANK.payinslip_no
				and	status		= 'U'
				)
		)
		begin
	
			select	@tag_group = isnull(@tag_group,0)+1
	
			update	STMT
			set	status		= 'R',
				taggroup	= @tag_group
			from	abr_bsbb_tmp STMT(nolock)
			where	guid		= @guid
			and	flag		= 'S'
			and	type_flag in ('RT')
			and	status		= 'U'
			and	mode_flag in ('X','Y','Z')
			and	tran_amount <= 
				(
				select	sum(tran_amount)
				from	abr_bsbb_tmp BANK(nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	STMT.payinslip_no = BANK.payinslip_no
				and	status		= 'U'
				)
		
			update	BANK
			set	serial_no	= @seq_no,
						  @seq_no = @seq_no + 1,
				status		= 'R',
				taggroup	= @tag_group
			from	abr_bsbb_tmp BANK(nolock)
			where	guid		= @guid
			and	flag		= 'B'
			and	type_flag in ('RT')
			and	status		= 'U'
			and	mode_flag in ('X','Y','Z')
			and	exists
				(
				select	'x'
				from	abr_bsbb_tmp STMT(nolock)
				where	guid			= @guid
				and	flag			= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	STMT.payinslip_no 	= BANK.payinslip_no
				and	status			= 'R'
				)
		end
	end -- raisebnk chg = 1
	*/
	/* Code Modified and Commented by Vairamani for DMS412AT_abr_00121 Ends here */

	/*
	   5. Try to reconcile the Bank Statement and Bank Book with Receipt Entries - Ref as Instrument No
	*/
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	/* Code Uncommented and Modified by Vairamani C for ES_abr_00062 Starts here */
	--14H109_rpt_00070
	/*if exists
	(
		select	'X'
		from	PPS_FEATURE_LIST (nolock)
		where	component_name	= 'ABR'
		and		feature_id		= 'PPS_FID_0116'		
		and		FLAG_YES_NO		= 'YES'
	)*/
	--14H109_rpt_00070
	begin
		if (@raisebnkchg = '0') -- Check box not checked
		begin -- raisebnk chg = 0 
			if exists
			(
				select	'X'
				from	abr_bsbb_tmp STMT(nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	status		= 'U'
				and	mode_flag in ('X','Y','Z')
				and	tran_amount = 
					(
					select	sum(tran_amount)
					from	abr_bsbb_tmp BANK(nolock)
					where	guid		= @guid
					and	flag		= 'B'
					and	type_flag in ('RT')
					and	mode_flag in ('X','Y','Z')
					and	STMT.check_no 	= BANK.check_no
					and	status		= 'U'
					)
			)
			begin
		
				select	@tag_group = isnull(@tag_group,0)+1
		
				update	STMT
				set	status		= 'R',
					taggroup	= @tag_group
				from	abr_bsbb_tmp STMT(nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	status		= 'U'
				and	mode_flag in ('X','Y','Z')
				and	tran_amount = 
					(
					select	sum(tran_amount)
					from	abr_bsbb_tmp BANK(nolock)
					where	guid		= @guid
					and	flag		= 'B'
					and	type_flag in ('RT')
					and	mode_flag in ('X','Y','Z')
					and	STMT.check_no = BANK.check_no
					and	status		= 'U'
					)
				--code added for ES_abr_00402 starts	
			    and serial_no = (
									select min(STMT1.serial_no)
									from   abr_bsbb_tmp STMT1(nolock)
									where	guid		= @guid
									and	STMT1.flag		= 'S'
									and	STMT1.type_flag in ('RT')
									and	STMT1.status		= 'U'
									and	STMT1.mode_flag in ('X','Y','Z')
									and	STMT1.check_no  = 	STMT.check_no
									and stmt1.tran_amount = stmt.tran_amount 
								)
				--code added for ES_abr_00402 ends
			
				update	BANK
				set	serial_no	= @seq_no,
							  @seq_no = @seq_no + 1,
					status		= 'R',
					taggroup	= @tag_group
				from	abr_bsbb_tmp BANK(nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	status		= 'U'
				and	mode_flag in ('X','Y','Z')
				and	exists
					(
					select	'x'
					from	abr_bsbb_tmp STMT(nolock)
					where	guid		= @guid
					and	flag		= 'S'
					and	type_flag in ('RT')
					and	mode_flag in ('X','Y','Z')
					and	STMT.check_no 	= BANK.check_no
					and	status		= 'R'
					)
			end
		end -- raisebnk chg = 0
		else
		begin -- raisebnk chg = 1
			if exists
			(
				select	'X'
				from	abr_bsbb_tmp STMT(nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	status		= 'U'
				and	mode_flag in ('X','Y','Z')
				and	tran_amount <= 
					(
					select	sum(tran_amount)
					from	abr_bsbb_tmp BANK(nolock)
					where	guid		= @guid
					and	flag		= 'B'
					and	type_flag in ('RT')
					and	mode_flag in ('X','Y','Z')
					and	STMT.check_no 	= BANK.check_no
					and	status		= 'U'
					)
			)
			begin
		
				select	@tag_group = isnull(@tag_group,0)+1
		
				update	STMT
				set	status		= 'R',
					taggroup	= @tag_group
				from	abr_bsbb_tmp STMT(nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	status		= 'U'
				and	mode_flag in ('X','Y','Z')
				and	tran_amount <= 
					(
					select	sum(tran_amount)
					from	abr_bsbb_tmp BANK(nolock)
					where	guid		= @guid
					and	flag		= 'B'
					and	type_flag in ('RT')
					and	mode_flag in ('X','Y','Z')
					and	STMT.check_no = BANK.check_no
					and	status		= 'U'
					)
			
				update	BANK
				set	serial_no	= @seq_no,
							  @seq_no = @seq_no + 1,
					status		= 'R',
					taggroup	= @tag_group
				from	abr_bsbb_tmp BANK(nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	status		= 'U'
				and	mode_flag in ('X','Y','Z')
				and	exists
					(
					select	'x'
					from	abr_bsbb_tmp STMT(nolock)
					where	guid		= @guid
					and	flag		= 'S'
					and	type_flag in ('RT')
					and	mode_flag in ('X','Y','Z')
					and	STMT.check_no 	= BANK.check_no
					and	status		= 'R'
					)
			end
		end -- raisebnk chg = 1
	end
	/* Code Uncommented and Modified by Vairamani C for ES_abr_00062 Ends here */
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */

	--Bank Charges Computation
	select	@bank_charge_amt = 
		(
		select	sum(tran_amount)
		from	abr_bsbb_tmp bank(nolock)
		where	guid			= @guid
		and	flag			= 'B'
		and	type_flag in ('RT')
		and	mode_flag in ('X','Y','Z')
		and	status			= 'R'
		)
		-
		(
		select	sum(tran_amount)
		from	abr_bsbb_tmp STMT(nolock)
		where	guid			= @guid
		and	flag			= 'S'
		and	type_flag in ('RT')
		and	mode_flag in ('X','Y','Z')
		and	status			= 'R'
		)
		
	select	@bank_charge_amt = isnull(@bank_charge_amt,0)

	select	@snp_raise_amount = @bank_charge_amt

	if @ctxt_user = 'snpuser'
	begin
		select * from abr_bsbb_tmp (nolock) where guid = @guid
		and mode_flag in ('X','Y','Z')
		select @snp_raise_amount '@snp_raise_amount',@bank_charge_amt '@bank_charge_amt'
	end

	/*
	if ((@raisebnkchg = '0') and (@bank_charge_amt > 0))
	begin
		--Cannot Raise Bank Charges for the difference Since the option has not been ticked
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,15,'','','','','','','',@errormsgout
		return
	end
	*/

	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Starts here */
	if ((@bank_charge_amt > 0) and (@raisebnkchg = '1'))
	begin
		select	@chg_coll_amt = sum
			(
			case
			when	drcr_flag = 'cr' then tran_amount
			else	-tran_amount
			end
			)
		from	fbp_posted_trn_Dtl fbp(nolock)
		where	exists
			(
			select	'x'
			from	abr_bsbb_tmp bank(nolock)
			where	guid			= @guid
			and	flag			= 'B'
			and	type_flag in ('RT')
			and	status			= 'R'
			and	bank.document_no	= fbp.document_no
			and	bank.ref_doc_tran_type	= fbp.tran_type
			and	bank.ref_tran_ou	= fbp.tran_ou
			)
		and	account_code in
			(
				select 	account_code
				from 	ard_addn_Account_mst 
				where 	company_code	= @compcode_tmp
				and	usage_id 	= 'CHGSCOLL'
				and	currency_code	= @currency_code
				and	fb_id		= @financeBook
				/*in
						(
						select	fb_id
						from	bnkdef_code_mst
						where	company_code = @compcode_tmp
						and	bank_acc_no  = @bankaccountnumber
						and	status	= 2
						and	flag	= 'B'
						)
				*/
			)

		select	@chg_coll_amt = isnull(@chg_coll_amt,0)
		select	@bank_charge_amt = @bank_charge_amt - @chg_coll_amt

		if exists
		(	
			select 	'X' 
			from 	bnkdef_charges_mst (nolock)
			where 	company_code 		= @compcode_tmp
			and 	bank_acc_no 		= @bankaccountnumber
			--and 	pay_mode 		= 'C' -- Code Modified for DMS412AT_abr_00125
			--and 	bank_charge_type 	= 'LOCALCHECK' /* Code Modified for DMS412AT_abr_00038 */
			and 	max_charge 		>= @bank_charge_amt
		)
		begin
			select @raise_bank_charges = 'Y'
		end
		else
		begin
			select @raise_bank_charges = 'N'
		/*Code added by Uma for the bug id : DMS412AT_ABR_00114 starts here*/
		end

		/*Code Commented by Vairamani for DMS412AT_abr_00043 Starts here */
		/*	
		select	@bank_charges_account	= bankcharge_account 
		from 	ard_bnkcsh_account_mst(nolock)
		where	company_code 	= @compcode_tmp
		and	fb_id		= @financeBook 
		and	bank_ptt_code	= @bankcode 
		and	@sysdt_tmp between effective_from and	isnull(effective_to,@sysdt_tmp)

		declare	@opcoid	fin_coaid
	
		select 	@opcoid 	= opcoa_id 
		from	as_opcoaid_map	(nolock)
		where	company_code	= @compcode_tmp
		and	map_status 	= 'A'

		if @raise_bank_charges = 'Y'
		begin	
			if exists (	select 	'X' 
					from 	as_opaccount_dtl (nolock)
					where	opcoa_id	= @opcoid	
					and	account_code	= @bank_charges_account
					and	(@sysdt_tmp 	between effective_from 
								and isnull(effective_to, @sysdt_tmp))
				   )
			begin	
				select @ctxt_user = @ctxt_user 
			end
			else
			begin
				select @raise_bank_charges = 'N'			
			end
		end
		*/
		/*Code Commented by Vairamani for DMS412AT_abr_00043 Ends here */
	
		if @raise_bank_charges = 'N'
		begin
		/*Code added by Uma for the bug id : DMS412AT_ABR_00114 ends here*/
			/* Code Modified by Vairamani for DMS412AT_abr_00096 Starts here */
		/* Code Modified by Vairamani for DMS412AT_abr_00126 Starts here */
			/*
			update	STMT
			set	status		= 'U',
				taggroup	= null
			from	abr_bsbb_tmp STMT(nolock)
			where	guid		= @guid
			and	flag		= 'S'
			and	type_flag in ('RT')
			and	status		= 'R'
			and	mode_flag in ('X','Y','Z')
			and	tran_amount <= 
				(
				select	sum(tran_amount)
				from	abr_bsbb_tmp BANK(nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	STMT.payinslip_no = BANK.payinslip_no
				and	status		= 'R'
				)
			*/

			update	TMP
			set	TMP.status	= 'U',
				TMP.taggroup	= null
			from 	abr_bsbb_tmp	TMP (nolock),
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount) tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'R'
				group by payinslip_no,guid,type_flag,Status
			)ST,
			(
				select 	payinslip_no,guid,type_flag,Status,sum(tran_amount)tran_amount
				from	abr_bsbb_tmp (nolock)
				where	guid		= @guid
				and	flag		= 'B'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	Status		= 'R'
				group by payinslip_no,guid,type_flag,Status
			)BNK
			where	ST.guid		= BNK.guid
			and	ST.payinslip_no	= BNK.payinslip_no
			and	ST.type_flag	= BNK.type_flag
			and	ST.status	= BNK.status
			and	ST.guid		= @guid
			and	ST.tran_amount	< BNK.tran_amount
			and	TMP.guid	= BNK.guid
			and	TMP.payinslip_no= BNK.payinslip_no
			and	TMP.type_flag	= BNK.type_flag
			and	TMP.status	= BNk.status
			and	TMP.flag	= 'S'
			and	TMP.type_flag in ('RT')
			and	TMP.status	= 'R'
			and	TMP.mode_flag in ('X','Y','Z')
		/* Code Modified by Vairamani for DMS412AT_abr_00126 Ends here */
		
			update	BANK
			set	serial_no	= null,
				status		= 'U',
				taggroup	= null
			from	abr_bsbb_tmp BANK(nolock)
			where	guid		= @guid
			and	flag		= 'B'
			and	type_flag in ('RT')
			and	status		= 'R'
			and	mode_flag in ('X','Y','Z')
			and	exists
				(
				select	'x'
				from	abr_bsbb_tmp STMT(nolock)
				where	guid			= @guid
				and	flag			= 'S'
				and	type_flag in ('RT')
				and	mode_flag in ('X','Y','Z')
				and	STMT.payinslip_no 	= BANK.payinslip_no
				and	status			= 'U'
				)
			/* Code Modified by Vairamani for DMS412AT_abr_00096 Ends here */
		end	

		if @ctxt_user = 'snpuser'
		begin
			select @bank_charge_amt '@bank_charge_amt',@raise_bank_charges '@raise_bank_charges'
		end
	
			
		if ((@bank_charge_amt > 0) and (@raise_bank_charges = 'Y'))
		begin
			--SNP will be raised for the first bank code available.
			--Fetch the first bank code, fb id
			/*
			select	top 1 
				@default_fb_id	= fb_id,
				@default_bankcode = bank_code
			from	bnkdef_code_mst(nolock)
			where	company_code 	= @compcode_tmp
			and	bank_acc_no  	= @bankaccountnumber
			and	status		= 2
			and	flag		= 'B'
			*/

			select	@bank_charges_account	= bankcharge_account 
			from 	ard_bnkcsh_account_mst(nolock)
			where	company_code 	= @compcode_tmp
			and	fb_id		= @financeBook /*@default_fb_id*/
			and	bank_ptt_code	= @bankcode /*@default_bankcode*/
			and	@sysdt_tmp between effective_from and	isnull(effective_to,@sysdt_tmp)

			select 	@chg_coll_account	= account_code
			from 	ard_addn_Account_mst (nolock)
			where 	company_code	= @compcode_tmp
 			and	usage_id 	= 'CHGSCOLL'
			and	currency_code	= @currency_code
			and	fb_id		= @financeBook /*@default_fb_id*/
			and	@sysdt_tmp between effective_from and	isnull(effective_to,@sysdt_tmp)

			select	@paymentpoint	= ouinstname,
				@buid_tmp	= bu_id,
				@transactionou	= ou_id
			from	emod_ou_vw (nolock)
			where	ouinstname	= @transactionou
			and	@sysdt_tmp between effective_from 
				and isnull(effective_to, @sysdt_tmp)

			exec @error_tmp = abr_autogensnp_validate_sp 
					@ctxt_language, @ctxt_ouinstance, @ctxt_service, @ctxt_user,
					@enddate, @guid, @startdate, @raisebnkchg, @financebook,
					@bankcode, @bankaccountnumber, @costcenter, @analysiscode,
					@subanalysiscode, @transactionou, @bank_charge_amt, @sysdt_tmp,
					@compcode_tmp, @buid_tmp, @bank_charges_account

			if @error_tmp <> 0
			begin
				if (@error_tmp = 1)
				begin
					-- Finance Book cannot be Null - when Raise Bank Charges is selected
					exec fin_sp_raise_error '', '', '', '', 'ABR', 38849,@m_errorid output
					return
				end
			
				if (@error_tmp = 2)
				begin
					-- Bank Code cannot be Null - when Raise Bank Charges is selected
					exec fin_sp_raise_error '', '', '', '', 'ABR', 38850,@m_errorid output
					return
				end
			
				if (@error_tmp = 3)
				begin
					-- Transaction OU cannot be Null - when Raise Bank Charges is selected
					exec fin_sp_raise_error '', '', '', '', 'ABR', 38851,@m_errorid output
					return
				end

				if (@error_tmp = 4)
				begin
					-- Bank Charges account not available for the Bank Code/Finance Book Combination
					exec fin_sp_raise_error '', '', '', '', 'ABR', 38853,@m_errorid output
					return
				end

				if (@error_tmp = 5)
				begin
					-- Analysis / Sub Analysis Code not mapped to Bank Charges Account Code.
					exec fin_sp_raise_error '', '', '', '', 'ABR', 38857,@m_errorid output
					return
				end

				/*Code added by Uma for the bug id : DMS412AT_ABR_00087 starts here*/
				if (@error_tmp = 9999) -- fin_germantrn_errors
				begin
					return
				end
				/*Code added by Uma for the bug id : DMS412AT_ABR_00087 ends here*/
			end

			if @ctxt_user = 'snpuser'
			begin
				select	@bank_charges_account '@bank_charges_account', @chg_coll_account '@chg_coll_account',
					@bank_charge_amt  '@bank_charge_amt', @chg_coll_amt '@chg_coll_amt'
			end

			--Payment Route - "BANK" ,Payment Method - "REGULAR" ,Electronic Payment - "NO"
			--Insert into Temp Table for Sundry Payment Service - Bank Charges Account.
			select @line_no = isnull(@line_no,0) + 1

			insert into snp_is_voucher_dtl_tmp
			(
				guid, usageid, currencycodeml,
				accountcodeml, accountamountml,
				debitcredit, remarks, costcenter,
				acct_line_no, fbp_flag, tcal_flag,
				analysis_code, subanalysis_code
			)
			values
			(
				@guid, null, @currency_code,
				@bank_charges_account, @bank_charge_amt,
				'DR', 'From ABR - SNP Autogeneration - Bank Charges Account', @costcenter,
				@line_no, 'Y', 'N',
				@analysiscode, @subanalysiscode
			)
			
			if @chg_coll_amt > 0
			begin
				select @line_no = @line_no + 1
				--Insert into Temp Table for Sundry Payment Service - Charges Collected Account.
				insert into snp_is_voucher_dtl_tmp
				(
					guid, usageid, currencycodeml,
					accountcodeml, accountamountml,
					debitcredit, remarks, costcenter,
					acct_line_no, fbp_flag, tcal_flag,
					analysis_code, subanalysis_code
				)
				values
				(
					@guid, null, @currency_code,
					@chg_coll_account, @chg_coll_amt,
					'DR', 'From ABR - SNP Autogeneration - Charges Collected Account', null,
					@line_no, 'Y', 'N',
					null, null
				)
			end

			exec snp_is_autogensp	@ctxt_language, /*@ctxt_ouinstance,*/@transactionou, @ctxt_service, @ctxt_user, @guid,
						'Sundry Payment', 'Y', 'N', 'SNP', @sysdt_tmp, /*@default_fb_id,*/
						@financebook,'ABRPAYEE',
						@sysdt_tmp, 'NO', @currency_code, 1, @snp_raise_amount, 'REGULAR',
						'BANK', 'OTHERS', /*@default_bankcode,*/@bankcode, @paymentpoint, 
						'', 'HIGH', 
						/*'From ABR - SNP Autogeneration'*/@jvnarration,@m_errorid output -- Code Modified for DMS412AT_ABR_00089

			if @m_errorid <>0
			begin
				--Error in SNP Auto Genaration.
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,24,'','','','','','','',@errormsgout
				return					
			end

			select	@voucher_no	= voucher_no
			from	snp_is_voucher_dtl_tmp (nolock)
			where	guid		= @guid

			insert into abr_snp_gen_dtl
			(
				batch_id, document_no, stmt_no, taggroup, ou_id,
				tran_type, fb_id, pay_date, pay_currency, pay_amount,
				bank_acc_no, bank_code, stmt_st_date, stmt_end_date,
				company_code, remarks, ref_no,
				cost_center, analysis_code, subanalysis_code, org_ou_id
			)
			select	@guid, @voucher_no, @statementno, @tag_group, /*@ctxt_ouinstance*/@transactionou,
				'PM_SPV', /*@default_fb_id*/@financebook, @sysdt_tmp, @currency_code, @snp_raise_amount,
				@bankaccountnumber, /*@default_bankcode*/@bankcode, @startdate, @enddate,
				@compcode_tmp, 'SNP Auto Generated from ABR', @refno_tmp,
				@costcenter, @analysiscode, @subanalysiscode, @ctxt_ouinstance

			declare @ard_bank_acct_dtl
			table
			(
				acct_code	fin_accountcode,
				fb_id		fin_financebookid 
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
			and	BNK.status		= '2'

			-- Fbp Updation for SNP Auto Generated
			update	DTL
			set	DTL.recon_flag		= 'R',
				DTL.modifiedby		= @ctxt_user,
				DTL.modifieddate	= @sysdt_tmp,
				/*Code Modified By Indira G For defect id:ES_abr_00141 Starts */
				--DTL.recon_date	= @enddate
				DTL.recon_date		= @sysdt_tmp
				/*Code Modified By Indira G For defect id:ES_abr_00141 Ends */
			from	fbp_posted_trn_dtl	DTL (nolock)
			where	DTL.company_code	= @compcode_tmp
			and	DTL.document_no		= @voucher_no
			and	DTL.account_code in
					(
						select	acct_code
						from	@ard_bank_acct_dtl
					)
			and	DTL.tran_type		= 'PM_SPV'
			and	DTL.tran_ou		= @transactionou /*@ctxt_ouinstance*/
			and	DTL.fb_id		= @financebook

			/* Code Added by Vairamani for DMS412AT_abr_00105 Starts here */
			select 	@state_flag 	= 'snpstate',
				@pay_voucherno	= @voucher_no
			/* Code Added by Vairamani for DMS412AT_abr_00105 Ends here */
		end
	end	

	/* Code added by Vairamani for DMS412AT_abr_00086 Starts here */
	if @ctxt_user = 'check'
	begin	
		select 'abr_bsbb_tmp'
		select	*
		from	abr_bsbb_tmp (nolock)
		where	guid	= @guid
	end

	if not exists
	(
		select	'X'
		from	abr_bsbb_tmp (nolock)
		where	guid	= @guid
		and	status	= 'R'
		and	flag in ('B','S')
		and	mode_flag in ('X','Y','Z')
	)
	begin

----Code added by Abhijith KP for EPE-68785 starts here
		if	 exists 
	(	
			select	'x'
			from	abr_bsbb_tmp (nolock)
			where	guid 	= @guid 
			and		flag	= 'S'
			and		tran_type in ('ID','SC','IC')
			and		mode_flag in ('X','Y','Z')
	)
	begin 
			select @guid = @guid
	end
----Code added by Abhijith KP for EPE-68785 ends here
	else
	begin
	/*code added for the defect id TLET-342	starts here*/
	if @statementno is not null
		begin
			--No records are available for the bank statement no - %d.
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,1900030015,@statementno
			return
		end
	else
	/*code added for the defect id TLET-342	ends here*/
		--No records are available for Auto-Reconciliation.
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,120
		return	
	end
	end
	/* Code added by Vairamani for DMS412AT_abr_00086 Ends here */

	/* Code Modified by Vairamani for DMS412AT_abr_00102 Starts here */
	if (@bankcode is null)
	begin
		-- Get Bank Code for the Bank Account Number.
		select	top 1 @bankcode		= bank_code
		from	bnkdef_code_mst BNK (nolock)
		where	BNK.bank_acc_no		= @bankaccountnumber
		and	BNK.company_code	= @compcode_tmp
		and	BNK.flag		= 'B'
		and 	BNK.status		= '2'		
	end
	/* Code Modified by Vairamani for DMS412AT_abr_00102 Ends here */
	insert into abr_bank_reconcile_dtl
	(
		company_code, bank_acc_no, bank_code, ref_no,
		serial_no, timestamp, tran_type, tran_date, 
		tran_amount, taggroup, stmt_no,
		tran_remarks, document_no, prefix,check_no, 
		comp_reference, ou_id, recon_status, 
		recon_remarks, 
		recon_by,recon_date, createdby, 
		createddate, modifiedby, modifieddate,
		ref_doc_tran_type, ref_doc_acct_code,
		ou_name, deposit_ou
	)
	select	@compcode_tmp, @bankaccountnumber, isnull(bank_code,@bankcode)/*@bankcode*/, @refno_tmp,  -- code changed by Esther for the DTS id 9H123-1_rp_00028 
		serial_no, 1 , /*tran_type*/type_flag, tran_date, --Code Modified by Vairamani for DMS412AT_abr_00043
		tran_amount, taggroup, @statementno,
		tran_remarks, document_no, prefix,check_no, 
		comp_reference, /*ou_name*/ref_tran_ou, 'R', /* Code Modified by Vairamani for DMS412AT_ABR_00006 */
		'Auto Renconcile Transactions', 
		@ctxt_user, @sysdt_tmp, @ctxt_user,
		@sysdt_tmp, @ctxt_user, @sysdt_tmp,
		ref_doc_tran_type, ref_doc_acct_code,
		ou_name, deposit_ou
	from	abr_bsbb_tmp (nolock)
	where	guid		= @guid
	and	flag		= 'B'
	and	status		= 'R'
	and	mode_flag in ('X','Y','Z')

	insert into fbp_bank_reconcile_dtl 
	(
		company_code, bank_account_no, bank_code, 
		ref_no, serial_no, timestamp, tran_type, tran_date, 
		tran_amount, taggroup, stmt_no,
		doc_no, prefix ,check_no ,comp_reference ,
		ou_id ,recon_status, 
		recon_remarks, 
		recon_by, recon_date,
		createdby, createddate, modifiedby, modifieddate,
		ref_doc_tran_type, ref_doc_acct_code,
		ou_name, deposit_ou
	)
	select	@compcode_tmp, @bankaccountnumber, @bankcode,
		@refno_tmp, serial_no, 1 , /*tran_type*/type_flag, tran_date, --Code Modified by Vairamani for DMS412AT_abr_00043
		tran_amount, taggroup, @statementno ,
		document_no, prefix, check_no, comp_reference,
		/*ou_name*/ref_tran_ou, 'R', /* Code Modified by Vairamani for DMS412AT_ABR_00006 */
		'Auto Renconcile Transactions', 
		@ctxt_user,@sysdt_tmp, 
		@ctxt_user, @sysdt_tmp,@ctxt_user, @sysdt_tmp,
		ref_doc_tran_type, ref_doc_acct_code,
		ou_name, deposit_ou
	from	abr_bsbb_tmp (nolock)
	where	guid		= @guid
	and	flag		= 'B'
	and	status		= 'R'
	and	mode_flag in ('X','Y','Z')

	update	DTL
	set	DTL.ref_no		= @refno_tmp,
		DTL.recon_status	= 'R',
		DTL.recon_by		= @ctxt_user,
		DTL.recon_date		= @sysdt_tmp,
		DTL.modifiedby		= @ctxt_user,
		DTL.modifieddate	= @sysdt_tmp,
		DTL.taggroup		= tmp.taggroup
	from	abr_bank_statement_dtl	DTL (nolock),
		abr_bsbb_tmp		TMP (nolock)
	where	guid		= @guid	
	and	company_code	= @compcode_tmp
	and	bank_acc_no	= @bankaccountnumber
	--and	bank_code	= @bank_code
	and	DTL.stmt_no	= TMP.stmt_no
	and 	DTL.serial_no 	= TMP.serial_no
	and	DTL.tran_type	= TMP.tran_type
	and	tmp.status	= 'R'
	and	TMP.flag	= 'S'
	and	mode_flag in ('X','Y','Z')
	
	/*Code Modified By Indira G For defect id:ES_abr_00141 Starts */
	update	DTL
	set	DTL.recon_date = tmp.tran_date
	from abr_bank_statement_dtl	DTL (nolock),
		(
		select taggroup, tran_date = max(tran_date)
		from abr_bsbb_tmp (nolock)
		where guid = @guid
		and	status	= 'R'
		and	mode_flag in ('X','Y','Z')
		group by taggroup
		) tmp
	where dtl.company_code	= @compcode_tmp
	and	dtl.bank_acc_no	= @bankaccountnumber
	and	DTL.taggroup = tmp.taggroup
	and	DTL.recon_date = @sysdt_tmp
	/*Code Modified By Indira G For defect id:ES_abr_00141 Ends */	

	/* Code Modified by Vairamani for DMS412AT_abr_00073 Starts here */
	-- Fbp Updation for Reconciled Transactions.
	update	DTL
	set	DTL.recon_flag		= 'R',
		DTL.modifiedby		= @ctxt_user,
		DTL.modifieddate	= @sysdt_tmp
	from	fbp_posted_trn_dtl	DTL (nolock),
		abr_bsbb_tmp		TMP (nolock)
	where	TMP.guid		= @guid	
	and	DTL.company_code	= @compcode_tmp
	and	DTL.document_no		= TMP.document_no
	and	DTL.account_code	= TMP.ref_doc_acct_code
	and	DTL.tran_type		= TMP.ref_doc_tran_type
	and	DTL.tran_ou		= TMP.ref_tran_ou
	and	TMP.flag		= 'B'
	and	tmp.status		= 'R'
	and	mode_flag in ('X','Y','Z')

	update	FBP
	set	FBP.recon_date		= HDR.stmt_end_date
	from	fbp_posted_trn_dtl	FBP (nolock),
		abr_bsbb_tmp		TMP (nolock),
		abr_bank_statement_dtl	DTL (nolock),
		abr_bank_statement_hdr	HDR (nolock)
	where	TMP.guid		= @guid
	and	FBP.company_code	= @compcode_tmp
	and	FBP.document_no		= TMP.document_no
	and	FBP.account_code	= TMP.ref_doc_acct_code
	and	FBP.tran_type		= TMP.ref_doc_tran_type
	and	FBP.tran_ou		= TMP.ref_tran_ou
	and	TMP.flag		= 'B'
	and	TMP.status		= 'R'
	and	mode_flag in ('X','Y','Z')		
	and	FBP.recon_flag		= 'R'
	and	DTL.taggroup		= TMP.taggroup
	and	DTL.bank_acc_no		= @bankaccountnumber
	and	DTL.company_code	= @compcode_tmp
	and	DTL.recon_status	= 'R'
	and	DTL.bank_acc_no		= HDR.bank_acc_no
	and	DTL.company_code	= HDR.company_code
	and	DTL.stmt_no		= HDR.stmt_no
	
	
	/*Code Modified By Indira G For defect id:ES_abr_00141 Starts */
	update	DTL
	set	DTL.recon_date = tmp.tran_date
	from fbp_posted_trn_dtl	DTL (nolock),
		(
		select taggroup, tran_date = max(tran_date)
		from abr_bsbb_tmp (nolock)
		where guid = @guid
		and	status	= 'R'
		and	mode_flag in ('X','Y','Z')
		group by taggroup
		) tmp,
		abr_bsbb_tmp		TMP1 (nolock)
	where TMP1.guid		= @guid	
	and	DTL.company_code	= @compcode_tmp
	and	DTL.document_no		= TMP1.document_no
	and	DTL.account_code	= TMP1.ref_doc_acct_code
	and	DTL.tran_type		= TMP1.ref_doc_tran_type
	and	DTL.tran_ou		= TMP1.ref_tran_ou
	and	TMP1.flag		= 'B'
	and	TMP1.status		= 'R'
	and	TMP1.mode_flag in ('X','Y','Z')
	and	tmp.taggroup = tmp1.taggroup
	/*Code Modified By Indira G For defect id:ES_abr_00141 Ends */	

	--PTP-1171
	update	DTL
	set	DTL.modifieddate = tmp.tran_date
	from abr_bank_reconcile_dtl	DTL (nolock),
		(
		select taggroup, tran_date = max(tran_date)
		from abr_bsbb_tmp (nolock)
		where guid = @guid
		and	status	= 'R'
		and	mode_flag in ('X','Y','Z')
		group by taggroup
		) tmp,
		abr_bsbb_tmp		TMP1 (nolock)
	where TMP1.guid			= @guid	
	and	DTL.company_code	= @compcode_tmp
	and	DTL.bank_acc_no		= @bankaccountnumber
	and	DTL.document_no		= TMP1.document_no
	and	DTL.ref_doc_tran_type = TMP1.ref_doc_tran_type
	and	DTL.ou_id			= TMP1.ref_tran_ou
	and	TMP1.flag		= 'B'
	and	TMP1.status		= 'R'
	and	TMP1.mode_flag in ('X','Y','Z')
	and	tmp.taggroup = tmp1.taggroup
	--PTP-1171

	 
	/*code added for DTS ID: ES_abr_00031(10H109_ABR_00001) starts here*/
	if exists (	select 'X'
				from	abr_opunrecon_rptpy_hdr(nolock)
				where	bank_acc_no  = @bankaccountnumber
				and		company_code = @compcode_tmp
				and		status		 = 'AUT')
	begin
		update	dtl
		set		dtl.status			= 'R',
				dtl.modified_by		= @ctxt_user,
				dtl.modified_date	= @sysdt_tmp
		from	abr_opunrecon_rptpy_dtl	dtl (nolock),
				abr_bsbb_tmp		tmp (nolock)
		where	tmp.guid			= @guid	
		and		dtl.company_code	= @compcode_tmp
		and		dtl.tran_no			= tmp.document_no
		and		dtl.tran_type		= tmp.ref_doc_tran_type
		and		dtl.tran_ou			= tmp.ref_tran_ou
		and		tmp.flag			= 'B'
		and		tmp.status			= 'R'
		and		mode_flag			in ('X','Y','Z')

		update	op
		set		op.recon_date		= hdr.stmt_end_date
		from	abr_opunrecon_rptpy_dtl	op (nolock),
				abr_bsbb_tmp			tmp (nolock),
				abr_bank_statement_dtl	dtl (nolock),
				abr_bank_statement_hdr	hdr (nolock)
		where	tmp.guid			= @guid
		and		op.company_code		= @compcode_tmp
		and		op.tran_no			= tmp.document_no
		and		op.tran_type		= tmp.ref_doc_tran_type
		and		op.tran_ou			= tmp.ref_tran_ou
		and		tmp.flag			= 'B'
		and		tmp.status			= 'R'
		and		mode_flag			in ('X','Y','Z')		
		and		op.status			= 'R'
		and		dtl.bank_acc_no		= @bankaccountnumber
		and		dtl.company_code	= @compcode_tmp
		and		dtl.recon_status	= 'R'
		and		dtl.bank_acc_no		= hdr.bank_acc_no
		and		dtl.company_code	= hdr.company_code
		and		dtl.stmt_no			= hdr.stmt_no
		and		dtl.check_no		= tmp.check_no --ES_Rep_02297
	end
	/*code added for DTS ID: ES_abr_00031(10H109_ABR_00001) ends here*/
	
	/*
	Code Commented by samuel for the defect id : ES_REP_00643 starts here
	--code added by Balaji ES_abr_00024 starts here  
	if exists
	(
		select	'X'
		from	abr_bsbb_tmp (nolock)
		where	guid		= @guid
		and	flag		= 'B'
		and	status		= 'R'
		and	mode_flag in ('X','Y','Z')
		and	type_flag in ('VODP','RVLP','BOUR','RVLR')
	)
	begin
		Update	FBP
		set	FBP.recon_date		= REC.tran_date
		from	fbp_posted_trn_dtl FBP,
			abr_bank_reconcile_dtl REC (nolock),	
			abr_bsbb_tmp TMP (nolock)
		where	TMP.guid		= @guid
		and	TMP.flag		= 'B'
		and	TMP.status		= 'R'
		and	mode_flag in ('X','Y','Z')
		and	type_flag in ('VODP','RVLP','BOUR','RVLR')
		and	REC.company_code	= @compcode_tmp
		and	REC.document_no		= TMP.document_no
		and	REC.ref_doc_acct_code	= TMP.ref_doc_acct_code
		and	REC.ref_doc_tran_type	= TMP.ref_doc_tran_type
		and	REC.ou_id		= TMP.ref_tran_ou
		and	FBP.company_code	= REC.company_code
		and	FBP.document_no		= TMP.document_no
		and	FBP.account_code	= TMP.ref_doc_acct_code
		and	FBP.tran_type		= TMP.ref_doc_tran_type
		and	FBP.tran_ou		= TMP.ref_tran_ou
		and	FBP.recon_flag		= 'R'
		and	FBP.recon_date is null
	end
	--code added by Balaji ES_abr_00024 ends here
	Code Commented by samuel for the defect id : ES_REP_00643 ends here
	*/

	/*
	update	DTL
	set	DTL.recon_flag		= 'R',
		DTL.modifiedby		= @ctxt_user,
		DTL.modifieddate	= @sysdt_tmp,
		DTL.recon_date		= @enddate
	from	fbp_posted_trn_dtl	DTL (nolock),
		abr_bsbb_tmp		TMP (nolock)
	where	TMP.guid		= @guid	
	and	DTL.company_code	= @compcode_tmp
	and	DTL.document_no		= TMP.document_no
	and	DTL.account_code	= TMP.ref_doc_acct_code
	and	DTL.tran_type		= TMP.ref_doc_tran_type
	and	DTL.tran_ou		= TMP.ref_tran_ou
	and	TMP.flag		= 'B'
	and	tmp.status		= 'R'
	and	mode_flag in ('X','Y','Z')
	*/
	/* Code Modified by Vairamani for DMS412AT_abr_00073 Ends here */

	/*
	update	abr_bank_statement_hdr
	set	no_of_rec_trans =
	(
		select	count('X')
		from	abr_bank_statement_dtl (nolock)
		where	company_code	= @compcode_tmp
		and	bank_acc_no	= @bankaccountnumber
		and	stmt_no		= @statementno
		and	recon_status	= 'R'
	)
	where	company_code	= @compcode_tmp
	and	bank_acc_no	= @bankaccountnumber
	and	stmt_no		= @statementno

	update	abr_bank_statement_hdr
	set	recon_status	= 'R'
	where	company_code	= @compcode_tmp
	and	bank_acc_no	= @bankaccountnumber
	and	stmt_no		= @statementno
	and	no_of_trans	= isnull(no_of_rec_trans,0)
	*/

	--EPE-7270
	 Declare    @pps_flag1           fin_flag
	 Declare    @pps_flag2           fin_flag,
				 @lo_id           fin_loid,
				@bu_id           fin_buid,
				@fb_id              fin_financebookid,
				--@custcode        fin_desc40,
				@base_curr          fin_currencycode,      
				@pab_curr           fin_currencycode,
				--@deposit_amount     fin_amount,
				@realized_amount    fin_amount,
				--@par_deposit_amount fin_amount,
				@receipt_no			fin_documentno,
				@tran_type			fin_trantype,
				@instr_type			fin_desc255,
				@instr_type_cd			fin_desc40,
				@receiptamount2		fin_amount,
				@cust_code			fin_desc40,
				--@erate_tmp          fin_exchangerate,
				@instr_status		fin_desc40
	
select 	@lo_id = lo_id,    
		@bu_id = bu_id
from  	emod_lo_bu_ou_vw (nolock)
where  	ou_id =  @ctxt_ouinstance
and	    @sysdt_tmp between effective_from and isnull(effective_to, @sysdt_tmp)

select  @pps_flag1   = FLAG_YES_NO
from  pps_feature_list(nolock)
where FEATURE_ID = 'pps_realization_status'

select  @pps_flag2   = FLAG_YES_NO
from    pps_feature_list(nolock)
where   FEATURE_ID   = 'pps_autoupdation_reconcile'

IF @pps_flag1 = 'NO' AND @pps_flag2 = 'YES'
begin
	declare pps_amount_upd cursor for
	select distinct h.tran_no,h.tran_type,h.instr_status
	from	ci_doc_hdr	h	 (nolock),
			abr_bsbb_tmp		tmp (nolock)
	where	tmp.guid			= @guid	
	and		h.tran_no			= tmp.document_no
	and		h.tran_type			= tmp.ref_doc_tran_type
	and		h.tran_ou			= tmp.ref_tran_ou
	and		tmp.flag			= 'B'
	and		tmp.status			= 'R'
	and		mode_flag			in ('X','Y','Z')

	open pps_amount_upd

	fetch next from pps_amount_upd into @receipt_no,  @tran_type,@instr_status

	while @@fetch_status = 0
	begin
	
		select @fb_id			= fb_id,
			   @cust_code		= cust_code,
			   @instr_type_cd  = instr_type,
			   @receiptamount2 = receipt_amount
		from  rpt_receipt_hdr (nolock)
		where receipt_no  = @receipt_no
		and	  tran_type	  = @tran_type

		 select @base_curr = currency_code      
		 from emod_basecurr_vw      
		 where company_code = @compcode_tmp      
		 and flag  = 'B'      
		 and @sysdt_tmp between effective_from and isnull(effective_to,@sysdt_tmp)      
      
		 select @pab_curr = currency_code      
		 from emod_basecurr_vw      
		 where company_code = @compcode_tmp      
		 and flag  = 'P'      
		 and @sysdt_tmp between effective_from and isnull(effective_to,@sysdt_tmp) 

		select @instr_type			=	parameter_text
		from  fin_quick_code_met  (nolock)
		where component_id			= 'RPT'
		and	  parameter_type		= 'COMBO'
		and	  parameter_category	= 'INSTYPE'
		and	  parameter_code		= @instr_type_cd
		and	  language_id			= @ctxt_language

		
		if exists (select  'x'
					from  realization_status_upd_met (nolock)
					where Instrument_type   = @instr_type
					and	  Transaction_Type  = @tran_type
					) and @instr_status in( 'UC','DUC')
		begin
			Select  @realized_amount = round (@receiptamount2,@pamt_tmp)
				
		end
		else
		begin
			Select  @realized_amount    = 0

		end
	if @ctxt_user = 'debug$$'
	begin
		select @lo_id,@bu_id,@ctxt_ouinstance,@fb_id,@compcode_tmp,@cust_code,@base_curr
		select  'before',* from ci_cust_undercoll_bal(nolock)      
		where lo_id                =   @lo_id      
		and   bu_id                =   @bu_id      
		and   ou_id                =   @ctxt_ouinstance      
		and   fb_id                =   @fb_id      
		and   company_code         =   @compcode_tmp       
		and   cust_code            =   @cust_code      
		and   base_currency_code   =   @base_curr  
	end	  
		 if exists( select 'x' from ci_cust_undercoll_bal(nolock)      
					 where lo_id                =   @lo_id      
					 and   bu_id                =   @bu_id      
					 and   ou_id                =   @ctxt_ouinstance      
					 and   fb_id                =   @fb_id  
					 and   company_code         =   @compcode_tmp       
					 and   cust_code            =   @cust_code       --epe-8248
					 and   base_currency_code   =   @base_curr  
				 )
			 begin
			   update ci_cust_undercoll_bal      
			  set  realized_amount         =   isnull(realized_amount,0)       + @realized_amount,            
				   --undercoll_amount         =   isnull(undercoll_amount,0)     - @realized_amount ,  
				   modifiedby               =   @ctxt_user,      
				   modifieddate             =   @sysdt_tmp ,       
				   timestamp                =   timestamp  +  1       
				where lo_id                =   @lo_id      
				and   bu_id                =   @bu_id      
				and   ou_id                =   @ctxt_ouinstance      
				and   fb_id                =   @fb_id      
				and   company_code         =   @compcode_tmp       
				and   cust_code            =   @cust_code      --epe-8248
				and   base_currency_code   =   @base_curr  

				update ci_cust_undercoll_bal      
				set   undercoll_amount         =   isnull(deposit_amount,0)       -  isnull(realized_amount,0) ,   
					 modifiedby               =   @ctxt_user,      
				     modifieddate             =   @sysdt_tmp ,       
				     timestamp                =   timestamp  +  1       
				where lo_id                =   @lo_id      
				and   bu_id                =   @bu_id      
				and   ou_id                =   @ctxt_ouinstance      
				and   fb_id                =   @fb_id      
				and   company_code         =   @compcode_tmp       
				and   cust_code            =   @cust_code      --epe-8248
				and   base_currency_code   =   @base_curr  

			 end

	  if @ctxt_user = 'debug$$'
	begin
		select @realized_amount '@realized_amount' ,@receiptamount2 '@receiptamount2',@fb_id '@fb_id',@cust_code '@cust_code',@instr_type_cd '@@instr_type_cd'
		,@instr_status '@instr_status',@receipt_no '@receipt_no' ,@tran_type '@tran_type',@instr_status '@instr_status',
		@lo_id,@bu_id,@compcode_tmp,@base_curr
		select * from ci_cust_undercoll_bal
	end
		fetch next from pps_amount_upd into @receipt_no,@tran_type,@instr_status
	end
	close pps_amount_upd
	deallocate pps_amount_upd
end

	--EPE-7270
	--EPE-7564
	if exists(   select 'x'
				 from	pps_feature_list (nolock)
				 where	feature_id		= 'pps_autoupdation_reconcile'
				 and	flag_yes_no		= 'yes'
				 and	component_name 	= 'rr'
				)
	BEGIN
		update	h
		set		h.instr_status  =  case when instr_status  = 'UC' then 'R' 
										when instr_status  = 'DUC' then 'D' 
								else instr_status end
		from	ci_doc_hdr	h	 (nolock),
				abr_bsbb_tmp		tmp (nolock)
		where	tmp.guid			= @guid	
		--and		dtl.company_code	= @compcode_tmp
		and		h.tran_no			= tmp.document_no
		and		h.tran_type			= tmp.ref_doc_tran_type
		and		h.tran_ou			= tmp.ref_tran_ou
		and		tmp.flag			= 'B'
		and		tmp.status			= 'R'
		and		mode_flag			in ('X','Y','Z')

		update	h
		set		h.instr_status  =  case when instr_status  = 'UC' then 'R' 
										when instr_status  = 'DUC' then 'D' 
								else instr_status end
		from	ci_doc_hdr	h	 (nolock),
				abr_bsbb_tmp		tmp (nolock)
		where	tmp.guid			= @guid	
		--and		dtl.company_code	= @compcode_tmp
		and		h.tran_no			= tmp.document_no
		and		h.tran_type			=  'RM_PS'
		and	    tmp.ref_doc_tran_type = 'RM_RV'
		and		h.tran_ou			= tmp.ref_tran_ou
		and		tmp.flag			= 'B'
		and		tmp.status			= 'R'
		and		mode_flag			in ('X','Y','Z')
	END
	--EPE-7564

	update	HDR
	set	HDR.no_of_rec_trans 	= HDR.no_of_rec_trans + DER.no_of_rec_trans
	from	abr_bank_statement_hdr HDR (nolock),
		(
			select	DTL.stmt_no,count('X') 'no_of_rec_trans'
			from	abr_bank_statement_dtl DTL (nolock),
				abr_bsbb_tmp TMP (nolock)
			where	TMP.guid		= @guid	
			and	TMP.flag		= 'S'
			and	TMP.mode_flag in ('X','Y','Z')
			and	DTL.company_code	= @compcode_tmp
			and	DTL.bank_acc_no		= @bankaccountnumber
			and	DTL.stmt_no		= TMP.stmt_no
			and	DTL.recon_status	= TMP.status
			and	DTL.tran_type		= TMP.tran_type
			and	DTL.taggroup		= TMP.taggroup
			and	DTL.serial_no		= TMP.serial_no
			and	DTL.recon_status	= 'R'
			group by DTL.stmt_no
		)DER
	where	HDR.company_code	= @compcode_tmp
	and	HDR.bank_acc_no		= @bankaccountnumber
	and	HDR.stmt_no		= DER.stmt_no

	update	HDR
	set	HDR.recon_status	= 'R'
	from	abr_bank_statement_hdr HDR (nolock),
		(
			select	HDR.stmt_no,HDR.no_of_rec_trans
			from	abr_bank_statement_hdr HDR (nolock),
				abr_bsbb_tmp TMP (nolock)
			where	TMP.guid		= @guid	
			and	TMP.flag		= 'S'
			and	TMP.mode_flag in ('X','Y','Z')
			and	HDR.company_code	= @compcode_tmp
			and	HDR.bank_acc_no		= @bankaccountnumber
			and	HDR.stmt_no		= TMP.stmt_no
		)DER
	where	HDR.company_code	= @compcode_tmp
	and	HDR.bank_acc_no		= @bankaccountnumber
	and	HDR.stmt_no		= DER.stmt_no
	and	HDR.no_of_trans		= isnull(DER.no_of_rec_trans,0)	
	/* Code Modified by Vairamani for DMS412AT_ABR_00005 Ends here */

----Code added by Abhijith KP for EPE-68785 starts here


 declare @pps_abr_001 fin_flag,
         @companycode fin_companycode ,
		 @ardguid2    fin_guid,
		 @sur_intrecd_accode fin_accountcode,
		 @ardguid1	  fin_guid,
		 @ardguid3	  fin_guid,
		 @snp_SerChrg_accode	fin_accountcode,
		 @snp_intpaid_accode	fin_accountcode,
		 @return_val             fin_guid,
		 @usage_interest_paid	fin_usageid,
		 @usage_interest_recieved fin_usageid,
		 @usage_chkbnchg_SC      fin_usageid,
		 @errormsg_tmp			fin_errormsg,
		 @hdn_vouchdtl			fin_int
		 


 select  @companycode	= COMPANY_CODE
 from 	emod_lo_bu_ou_vw(nolock)
 where	ou_id	= @ctxt_ouinstance

 select @pps_abr_001 = FLAG_YES_NO
 from pps_finance_feature_list with (nolock)
 where FEATURE_ID = 'PPS_ABR_0002'
 and company_code = @companycode

 select @usage_interest_paid = usage_interest_paid
 FROM bnkdef_charges_mst(nolock)
 where company_code = @companycode
 and bank_acc_no = @bankaccountnumber

 select @usage_interest_recieved = usage_interest_received
 FROM bnkdef_charges_mst(nolock)
 where company_code = @companycode
 and bank_acc_no = @bankaccountnumber

 select @usage_chkbnchg_SC = usageforchkbnchg
 FROM bnkdef_charges_mst(nolock)
 where company_code = @companycode
 and bank_acc_no = @bankaccountnumber

 if @pps_abr_001 is null
 BEGIN
     select @pps_abr_001 = FLAG_YES_NO
     from pps_finance_feature_list with (nolock)
     where FEATURE_ID = 'PPS_ABR_0002'
     and company_code IS NULL
 END

 IF @pps_abr_001 = 'YES' AND @raisebnkchg = 1 --IF condition added for EPE-88044
 begin 

  if (@financeBook is null)
	begin
					exec fin_sp_raise_error '', '', '', '', 'ABR', 38849,@m_errorid output
					return
	end

	if (@transactionou is null)
	begin
					exec fin_sp_raise_error '', '', '', '', 'ABR', 38851,@m_errorid output
					return
	end


if exists (select 'x' from abr_bsbb_tmp(nolock)
		   where tran_type = 'IC'
		   and guid = @guid)
begin


	 EXEC @return_val = ARDISSpGetUsageAcc	@ctxt_language,
														@ctxt_ouinstance,
														@ctxt_service,
														@ctxt_user,
														'',
														@usage_interest_recieved,
														@financebook,
														@currency_code,
														@sysdt_tmp,
														@ardguid2 OUTPUT,
														@errormsg_tmp OUTPUT
																										
														
				if (@return_val <> 0)
				begin

					exec fin_german_raiserror_sp 'ABR',1,289
					return
				end
				
				select	@sur_intrecd_accode = account_code
				from	ard_is_account_vw (nolock)
				where	guid = @ardguid2	

		if @costcenter is not null
		begin
				 if @costcenter not in (select 	center_no
				     from 	mac_acc_ce_cc_mapping (nolock)
				     where 	account_no 	= @sur_intrecd_accode
				     and 	company_code 	= @compcode_tmp
				     and 	bu_id 		= @bu_id
				     and 	@sysdt_tmp between effective_date and isnull(expiry_date,@sysdt_tmp))
				  begin
					exec fin_german_raiserror_sp 'ABR',@ctxt_language,286,'Interest Recieved'
					return	
				  end
		end	

				
	IF @analysiscode IS not NULL
	BEGIN
        if @analysiscode not in(select analysis_code
			from 	abb_account_analysis_map (nolock)
			where 	company_code 	= @compcode_tmp
			and 	account_code 	= @sur_intrecd_accode----EPE-68785:EPE-71762
			and     map_status		= 'A')
			begin 
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,287,'Interest Recieved'
				return	
			end

	END

	 IF @subanalysiscode IS not NULL
     BEGIN
        if @subanalysiscode not in(select sub_analysis_code
			from 	abb_account_analysis_map (nolock)
			where 	company_code 	= @compcode_tmp
			and 	account_code 	= @sur_intrecd_accode--EPE-68785:EPE-71762
			and     map_status		= 'A')
			begin 
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,288,'Interest Recieved'
				return	
			end

	 end
end


 if exists (select 'x' from abr_bsbb_tmp(nolock)
				where tran_type = 'SC'
				and guid = @guid)
 begin

	EXEC @return_val = ARDISSpGetUsageAcc	@ctxt_language,
											@ctxt_ouinstance,
											@ctxt_service,
											@ctxt_user,
											'',
											@usage_chkbnchg_SC,
											@financebook,
											@currency_code,
											@sysdt_tmp,
											@ardguid3 OUTPUT,
											@errormsg_tmp OUTPUT

				if (@return_val <> 0)
				begin

					exec fin_german_raiserror_sp 'ABR',1,289
					return
				end

								select	@snp_SerChrg_accode = account_code
				                from	ard_is_account_vw (nolock)
				                where	guid = @ardguid3	

		if @costcenter is not null
		begin
				 if @costcenter not in (select 	center_no
				     from 	mac_acc_ce_cc_mapping (nolock)
				     where 	account_no 	= @snp_SerChrg_accode
				     and 	company_code 	= @compcode_tmp
				     and 	bu_id 		= @bu_id
				     and 	@sysdt_tmp between effective_date and isnull(expiry_date,@sysdt_tmp))
				  begin
					exec fin_german_raiserror_sp 'ABR',@ctxt_language,286,'Service Charges'
					return	
				  end
		end	

	IF @analysiscode IS not NULL
	BEGIN
        if @analysiscode not in(select analysis_code
			from 	abb_account_analysis_map (nolock)
			where 	company_code 	= @compcode_tmp
			and 	account_code 	= @snp_SerChrg_accode
			and     map_status		= 'A')
			begin 
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,287,'Service Charges'
				return	
			end

	END

	 IF @subanalysiscode IS not NULL
     BEGIN
        if @subanalysiscode not in(select sub_analysis_code
			from 	abb_account_analysis_map (nolock)
			where 	company_code 	= @compcode_tmp
			and 	account_code 	= @snp_SerChrg_accode
			and     map_status		= 'A')
			begin 
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,288,'Service Charges'
				return	
			end
	 end
 end

 if exists (select 'x' from abr_bsbb_tmp(nolock) 
				where tran_type = 'ID'
				and guid = @guid)
   begin 
	EXEC @return_val = ARDISSpGetUsageAcc	@ctxt_language,
											@ctxt_ouinstance,
											@ctxt_service,
											@ctxt_user,
											'',
											@usage_interest_paid,
											@financebook,
											@currency_code,
											@sysdt_tmp,
											@ardguid1 OUTPUT,
											@errormsg_tmp OUTPUT

				if (@return_val <> 0)
				begin

					exec fin_german_raiserror_sp 'ABR',1,289
					return
				end

		select	@snp_intpaid_accode = account_code
		from	ard_is_account_vw (nolock)
		where	guid = @ardguid1	

		if @costcenter is not null
		begin
				 if @costcenter not in (select 	center_no
				     from 	mac_acc_ce_cc_mapping (nolock)
				     where 	account_no 	= @snp_intpaid_accode
				     and 	company_code 	= @compcode_tmp
				     and 	bu_id 		= @bu_id
				     and 	@sysdt_tmp between effective_date and isnull(expiry_date,@sysdt_tmp))
				  begin
					exec fin_german_raiserror_sp 'ABR',@ctxt_language,286,'Interest Paid'
					return	
				  end

		end		

	IF @analysiscode IS not NULL
	BEGIN
        if @analysiscode not in(select analysis_code
			from 	abb_account_analysis_map (nolock)
			where 	company_code 	= @compcode_tmp
			and 	account_code 	= @snp_intpaid_accode
			and     map_status		= 'A')
			begin 
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,287,'Interest Paid'
				return	
			end


	END

	 IF @subanalysiscode IS not NULL
     BEGIN
        if @subanalysiscode not in(select sub_analysis_code
			from 	abb_account_analysis_map (nolock)
			where 	company_code 	= @compcode_tmp
			and 	account_code 	= @snp_intpaid_accode
			and     map_status		= 'A')
			begin 
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,288,'Interest Paid'
				return	
			end

	 end

end


end   --Code added for EPE-88044	

		
 IF @pps_abr_001 = 'YES' AND @raisebnkchg = 1 
 begin 	
	 


	 
				update	abr_bsbb_tmp
        		set	acc_code	=  case	when	tran_type =  'ID'then @snp_intpaid_accode
										when	tran_type =  'SC' then @snp_SerChrg_accode
										when	tran_type =  'IC' then @sur_intrecd_accode 
										else	acc_code	end,
					acusage		=  case	when	tran_type =  'IC' then @usage_interest_recieved
										when	tran_type =  'ID' then @usage_interest_paid
										else	acusage	end,
					fbid		=	@financebook,
        			bankcode	=	@bankcode,
        			rpt_tran_ou =	@ctxt_ouinstance
        		where	guid = @guid
        		and		flag = 'S'
        		and		mode_flag in ('X','Y','Z')

		if @analysiscode is null
		begin
					    exec abb_sysact_acansub_def
						@ctxt_language,
						@ctxt_ouinstance,
						@ctxt_service,
						@ctxt_user,
						@snp_intpaid_accode,
						@analysiscode  output,
						@subanalysiscode output,
						@sysdt_tmp	

						update abr_bsbb_tmp
						set analysiscode = @analysiscode
						where guid = @guid
			
	     end
		 else
		  begin 
						update abr_bsbb_tmp
						set analysiscode = @analysiscode
						where guid = @guid
		  end

		if @subanalysiscode is null
		begin
					    exec abb_sysact_acansub_def
						@ctxt_language,
						@ctxt_ouinstance,
						@ctxt_service,
						@ctxt_user,
						@snp_intpaid_accode,
						@analysiscode  output,
						@subanalysiscode output,
						@sysdt_tmp	

						update abr_bsbb_tmp
						set subanalysiscode = @subanalysiscode
						where guid = @guid
			
	     end
		 else
		  begin 
						update abr_bsbb_tmp
						set subanalysiscode = @subanalysiscode
						where guid = @guid
		  end



			if @costcenter is null
			begin
	            UPDATE	dtl
	            set		dtl.costcenter		= map.center_no
	            from	abr_bsbb_tmp dtl,
	            		mac_acc_ce_cc_mapping map(nolock)
	            where	dtl.guid = @guid
                and		dtl.flag = 'S'
                and		dtl.mode_flag in ('X','Y','Z')
	            and		dtl.acc_code	= map.account_no
	            and     dtl.tran_date between effective_date	and isnull(expiry_date,DTL.tran_date)
				and     tran_type  in  ('IC','SC','ID')
				and		bu_id   = @bu_id
			end
			else
			begin
				     update abr_bsbb_tmp
				     set  costcenter = @costcenter
				     where guid = @guid
			end
				


		   exec  abr_cmn_snp_sursp   @bankaccountnumber	, @ctxt_language	, @ctxt_ouinstance,	     @ctxt_service	,	
								 @ctxt_user			, @enddate	,   	  @guid		,		     @hidden_control1	,
								 @jvnarration	,  	  @raisebnkchg	,	  @startdate	,		 @statementno1	,	
								 NULL		,	  @raiserpt    ,     @refno_tmp,  
								 @m_errorid	output

			

			IF @m_errorid <> 0
				return

END	

if exists (select * from abr_reconcile_tmp(NOLOCK)
				where guid = @guid)
begin 
	select @hdn_vouchdtl = 1
end
else
begin
	select @hdn_vouchdtl = 0
end
----Code added by Abhijith KP for EPE-68785 ends here
	
	--EPE-5510
	if isnull(@called_from,'')	not in	('FCC_HUB','BRS_HUB')--14H109_FCC_00002--EPE-5510
	/* Code Added by Vairamani for DMS412AT_abr_00105 Starts here */
	select	@pay_voucherno	'SundryPaymentVoucher',
			@state_flag		'HDNhdnrt_stcontrol'
	/* Code Added by Vairamani for DMS412AT_abr_00105 Ends here */
			,1				'stsnp',	-- EPE-5027 
			 1				'stsur'		-- EPE-5027
			,@hdn_vouchdtl	'hdn_vouchdtl'	-- EPE-5027 

	set nocount off
end





