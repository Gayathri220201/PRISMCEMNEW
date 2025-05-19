/*$File_version=ms4.3.0.04$*/
/******************************************************************************/
/* procedure					: abr_snp_autogen      					      */
/* description					: 											  */
/******************************************************************************/
/* project						: 								 			  */
/* ecrno						: 								 			  */
/* version						: 								 			  */
/******************************************************************************/
/* referenced					: 								 			  */
/* tables						: 								 			  */
/***************************************************************** *************/
/* Development history			:											  */
/******************************************************************************/
/* Author						: Anusha.p  								  */
/* Date							: 29 jan 2018            					  */
/******************************************************************************/
/* modification history			: 											  */
/* Aditya S				18/06/2020			PTP-970							  */
/* Andavar C			17/09/2020			PTP-1174						  */
/* Abhijith KP			26/09/2023			EPE-68785						  */
/* Preethi Venkatraman		17-09-2024			EPE-87691:EPE-88067 */
/******************************************************************************/
Create procedure abr_snp_autogen
(
	@bankaccountnumber	fin_banknumber,
	@ctxt_language		fin_languageid,
	@ctxt_ouinstance	fin_ouinstid,
	@ctxt_service		fin_service,
	@ctxt_user			fin_userid,
	@enddate			fin_date,
	@guid				fin_guid,
	@hidden_control1	fin_hiddencontrol,
	@jvnarration		fin_comments,
	@raisebnkchg		fin_checkbox,
	@startdate			fin_date,
	@statementno1		fin_statementnumber,
	@fprowno			fin_rowno,
	@raiserpt           fin_checkbox, 
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
			@plow_tmp                  fin_int
	
	exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
		@prate_tmp output, @perate_tmp output, @phigh_tmp output,
		@pmed_tmp output, @plow_tmp output
	--END of Standard code for getting precision type

	declare--	@bs_sc_amount		fin_amount,
			--@bs_tran_type		fin_trantype,
			--@bs_sc_date			fin_date,
			--@bs_sc_remarks		fin_text255,
			--@bs_sc_docno 		fin_documentno,
			--@bs_sc_prefix		fin_prefix,
			--@bs_sc_stmtno		fin_documentno,
			--@bs_sc_check_no		fin_checknumber,
			--@bs_sc_comp_ref		fin_checknumber,
			--@bs_sc_slipno		fin_documentnumber,
			--@bs_sc_sno			fin_number,
			--@bs_py_amount		fin_amount,
			--@bs_rt_amount		fin_amount,
			--@bb_py_amount		fin_amount,
			--@bb_rt_amount		fin_amount,
			@compcode_tmp		fin_companycode,
			--@count_bs			fin_int,
			--@count_bb			fin_int,
			@errormsgout		fin_text2500,
			@sysdt_tmp			fin_date,
			@statementno		fin_statementnumber, 
			--@bank_code			fin_bankcode,
			--@tag_group			fin_code,
			--@bb_sno_tmp			fin_number,
			@refno_tmp			fin_documentno,
			--@bs_seqno_tmp		fin_int,
			--@bb_seqno_tmp		fin_int,
			@snp_raise_amt		fin_amount,
			--@err_tmp			fin_int,
			--@bs_tag_count		fin_int,
			--@bb_tag_count		fin_int,
			--@tag_count			fin_int,
			@taggroup			fin_code,
			--@err_taggroup		fin_code,
			--@auto_taggen_flag	fin_flag,
			--@seq_no				fin_int,
			@bank_charge_amt	fin_amount,
			--@chg_coll_amt		fin_amount,
			@line_no			fin_int,
			@buid_tmp			fin_buid,
			@paymentpoint		fin_ouinstname,
			@currency_code		fin_currency,
			@bank_charges_account	fin_accountcode,
			--@chg_coll_account	fin_accountcode,
			--@default_fb_id		fin_financebookid,
			@voucher_no			fin_documentno,
			@snp_guid			fin_guid,
			--@pay_amount			fin_amount,
			--@sc_amount			fin_amount,
			--@tag_group_st		fin_code,
			--@tag_group_recon	fin_code,
			@error_tmp			fin_int,
			--@raise_bank_charges	fin_status,
			@state_flag 		fin_flag,
			@pay_voucherno		fin_documentno,
			--@curr_st_seqno		fin_int,		
			--@rev_entry_flag		fin_flag,
			--@refno_recon		fin_code,
			--@refno_st			fin_code
			@int_acc_param		fin_paramcode,
			@tran_type          fin_trantype,
				@financebook		fin_financebookid,
	@bankcode			fin_bankcode,
	@transactionou		fin_chargesou,
	@costcenter			fin_costcenter,
	@analysiscode		fin_analysiscode,
	@subanalysiscode	fin_subanalysiscode

	--declare @ppsflag fin_flag
	declare @snpdate fin_date  
	declare	@base_cur_tmp 			fin_currencycode ,
			@exch_ratetype_tmp		fin_paramcode	 ,
			@maxlimit_tmp 			fin_amount ,
			@minlimit_tmp 			fin_amount ,
			@eratecat_tmp  			fin_param_text ,
			@currunits_tmp 			fin_currencycode ,
			@errorid_tmp			fin_int	,
			@exchangerate           fin_exchangerate,
			@bank_charges_currency	fin_currency

	-- @m_errorid should be 0 to indicate success
	select 	@m_errorid = 0	

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

	select @raisebnkchg = ltrim(rtrim(@raisebnkchg))
	if @raisebnkchg = '~#~'
		select @raisebnkchg = null

	select @statementno1 = ltrim(rtrim(@statementno1))
	if @statementno1 = '~#~'
		select @statementno1 = null
		select @statementno  = @statementno1

	if @fprowno = -915
		select @fprowno = null

	select @jvnarration = ltrim(rtrim(@jvnarration)) -- Code Modified for DMS412AT_ABR_00089
	if @jvnarration = '~#~'
		select @jvnarration = null
	
	/*Code added for 14H109_abr_00006 begins here*/
--	declare @sur_guid					fin_guid,
--			@ardguid1					fin_guid,
--			@ardguid2					fin_guid,
--			@return_val					fin_int,
--			@surdate					fin_date,
--			@snp_intpaid_accode			fin_accountcode,
--			@sur_intrecd_accode			fin_accountcode,
--			@receiptcategory			fin_receiptcategory,
--			@sundryreceiptvoucher		fin_desc255,
--			@receiptmethod				fin_method,
--			@receiptmode				fin_receiptmode,
--			@receiptroute				fin_route,
--			@bankdescription  			fin_bankdescription,			
--			@errormsg_tmp				fin_desc255,
--			@snp_intpaid_amt			fin_amount,
--			@sur_intrecd_amt			fin_amount,
--			@id_amt						fin_amount,	
--			@ic_amt						fin_amount,
--			@sc_amt						fin_amount,
--			@diff_intpaid_amt			fin_amount,
--			@diff_intrecd_amt			fin_amount,
--			@max_interest_paid			fin_amount,
--			@max_interest_received		fin_amount,
   declare  @usage_interest_paid		fin_usageid
--			@usage_interest_received	fin_usageid	

	

	
	select @sysdt_tmp = convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120)


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
		
	--VE-3059	
	select 	@base_cur_tmp	=	currency_code
	from 	emod_basecurr_vw ( nolock )
	where	company_code	=	@compcode_tmp
	and		flag			=	'B'
	
	select  @exch_ratetype_tmp = parameter_value
	from	ops_processparam_vw ( nolock )
	where	ou_id			= @ctxt_ouinstance 
	and		parameter_type  = 'PMSYS' 
	and		parameter_code  = 'SETTLEMENTERTYPE'
	--VE-3059	
		
	/*14H109_ABR_00016*/	
	select	@int_acc_param			= cps.parameter_code
	from	cps_processparam_sys cps	
	where   cps.company_code        = @compcode_tmp 	
	and     cps.parameter_type  = 'BKSYS'  		
	--and     cps.ou_id               = @ctxt_ouinstance  EPE-5027 		
	and     cps.parameter_category  = 'INTACCREC'	
	and 	language_id 			= @ctxt_language		
	/*14H109_ABR_00016*/		

	--EPE-87691 starts
	declare @tcal_flag		udd_flag
	if exists (	Select '*'
					from cps_taxparam_vw(nolock)
					where tax_type in ('SALT', 'SERT')
					and tax_community = 'MALAYSIA'
					and company_code = @compcode_tmp --EPE-88067
				)
	begin
		Select @tcal_flag = 'Y'
	end
	else
		Select @tcal_flag = 'N'
	--EPE-87691 ends

	--if
	--(
	--	select 	count(distinct stmt_no)
	--	from	abr_bsbb_tmp (nolock)
	--	where	guid		= @guid
	--	and		flag		= 'S'
	--	and		mode_flag in ('X','Y','Z')
	--)=1
	--begin
	--	select 	@statementno	= stmt_no
	--	from	abr_bsbb_tmp (nolock)
	--	where	guid		= @guid
	--	and	flag		= 'S'
	--	and	mode_flag in ('X','Y','Z')
	--end
	--else
	--begin
	--	select @statementno = null
	--end

		declare @ard_bank_acct_dtl
	table
	(
		acct_code	fin_accountcode,
		fb_id		fin_financebookid 
	)

	
	--14H109_ABR_00016
	if @ctxt_user = 'snpuser'
	begin
		select 'abr_bsbb_tmp'
		select * from abr_bsbb_tmp (nolock) where guid = @guid
		and mode_flag in ('X','y','Z')
	end
  -- 	select      @max_interest_paid		=	max_interest_paid,
		--		@max_interest_received	=	max_interest_received,
		--	--	@usage_interest_paid	=	usage_interest_paid,
		--	--	@usage_interest_received=	usage_interest_received,
		--		@bankaccountnumber		=	bank_acc_no
		--from 	bnkdef_charges_mst (nolock)
		--where 	company_code 			=	@compcode_tmp
		--and 	bank_acc_no 			=	@bankaccountnumber
							
		--if isnull(@bankaccountnumber,'') = ''
		--begin
		--	--Bank charges is not set for the Bank Account No.
		--	exec fin_german_raiserror_sp 'ABR',@ctxt_language,105
		--	return
		--end								
							

		declare	Snp_cursor1 cursor for

		select distinct   taggroup
		from  abr_bsbb_tmp(nolock)
		where guid   =  @guid
		and   mode_flag in ('X','y','Z')
		and   tran_type in ('ID','SC')
		and   taggroup is not null
		and   isnull(taggroup,'') <> ''--EPE-68785
		 and  flag     = 'S'
		
		open  Snp_cursor1

		fetch next from  Snp_cursor1 into @taggroup
		while (@@fetch_status = 0)
		 begin
		   select @financebook  = fbid,
		          @bankcode     = bankcode,
				  @transactionou =rpt_tran_ou 
			from   abr_bsbb_tmp(nolock)
		    where guid     =  @guid
		    and   taggroup =  @taggroup
			and		mode_flag in ('X','Y','Z')
			and   tran_type in ('ID','SC')
			 and  flag     = 'S'

	insert into @ard_bank_acct_dtl
	(
		acct_code , fb_id
	)
	select	ARD.bankptt_account,ARD.fb_id
	from	bnkdef_code_mst BNK (nolock),
		ard_bnkcsh_account_mst ARD (nolock)
	where	BNK.company_code	= ARD.company_code
	and	BNK.fb_id			= ARD.fb_id
	and	BNK.bank_code		= ARD.bank_ptt_code
	and	BNK.flag			= ARD.flag
	and	BNK.bank_acc_no		= @bankaccountnumber
	and	BNK.company_code	= @compcode_tmp
	and	BNK.fb_id			= @financebook 
	and	BNK.flag			= 'B'
	and	BNK.status			= '2'

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
		and		BNK.fb_id			= @financebook 
		and		BNK.flag			= 'B'	
		and		BNK.status			= '2'
	
	end

		  declare validate_cursor cursor for

		  select costcenter, analysiscode, subanalysiscode,acc_code,tran_amount
		  from  abr_bsbb_tmp(nolock)
		  where guid     =  @guid
		  and   taggroup =  @taggroup
		  and	mode_flag in ('X','Y','Z')
		  and   tran_type in ('ID','SC')
		  and   flag      = 'S'

		  open validate_cursor

		  fetch next from  validate_cursor into   @costcenter, @analysiscode,@subanalysiscode,@bank_charges_account,@bank_charge_amt

		  while (@@fetch_status = 0)
		   begin

				exec   @error_tmp = abr_autogensnp_validate_sp 
						@ctxt_language, @ctxt_ouinstance, @ctxt_service, @ctxt_user,
						@enddate, @guid, @startdate, @raisebnkchg, @financebook,
						@bankcode, @bankaccountnumber, @costcenter, @analysiscode,
						@subanalysiscode, @transactionou, @bank_charge_amt, @sysdt_tmp,
						@compcode_tmp,   @buid_tmp, @bank_charges_account

				if @error_tmp <> 0
				begin
				   close    validate_cursor
			       deallocate validate_cursor
				   close Snp_cursor1
				   deallocate Snp_cursor1
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
				
			 fetch next from  validate_cursor into   @costcenter, @analysiscode,@subanalysiscode,@bank_charges_account,@bank_charge_amt
         end
			close    validate_cursor
			deallocate validate_cursor

				--Payment Route - "BANK" ,Payment Method - "REGULAR" ,Electronic Payment - "NO"
				--Insert into Temp Table for Sundry Payment Service - Bank Charges Account.
				select @line_no = isnull(@line_no,0) + 1

				if @ctxt_user = 'snpuser'
				begin
					select	@bank_charges_account '@bank_charges_account',@bank_charge_amt  '@bank_charge_amt'
				end

				select @snp_guid = newid()
				
				/*Code Added by Aditya Sitaraman for ES_Abr_00257 starts*/
				if @statementno is not null
				begin	
									
						select	@snpdate 	= stmt_end_date
						from	abr_bank_statement_hdr(nolock)
						WHERE 	company_code 		=  @compcode_tmp 
						and		bank_acc_no			=  @bankaccountnumber
						and		stmt_no				=  @statementno
				end
				else
				begin
						select	@snpdate  = @enddate
				end
				
				select @snpdate = isnull(@snpdate, @sysdt_tmp)
				/*Code Added by Aditya Sitaraman for ES_Abr_00257 ends*/
				
				/*Code added for 14H109_abr_00006 begins here*/
					
				select @bank_charges_currency = ltrim(rtrim(currency_code))
				from   as_opacctall_vw (nolock)
				where  company_code = @compcode_tmp
				and    account_code = @bank_charges_account 	
				
				
					insert into snp_is_voucher_dtl_tmp
					(
						guid, usageid, currencycodeml,
						accountcodeml, accountamountml,
						debitcredit, remarks, costcenter,
						acct_line_no, fbp_flag, tcal_flag,
						analysis_code, subanalysis_code,analysiscode,subanalysiscode
					)
					select 
						@snp_guid, acusage, @currency_code,
						null/*NULL@bank_charges_account*/, sum(tran_amount),
						'DR', 'From ABR - SNP Autogeneration - Interest Paid Account', costcenter,
						@line_no, 'Y', /*'N'*/ @tcal_flag /* Code commented and added for EPE-87691 */,
						analysiscode, subanalysiscode,analysiscode,subanalysiscode
					from  abr_bsbb_tmp(nolock)
					where guid     = @guid
					and   taggroup =  @taggroup
					and   tran_type = 'ID'
					and	  mode_flag in ('X','Y','Z')
					group by acusage,costcenter,analysiscode,subanalysiscode

				insert into snp_is_voucher_dtl_tmp
				(
					guid, usageid, currencycodeml,
					accountcodeml, accountamountml,
					debitcredit, remarks, costcenter,
					acct_line_no, fbp_flag, tcal_flag,
					analysis_code, subanalysis_code,analysiscode,subanalysiscode
				)
				select
					@snp_guid, null, /*@currency_code*/@bank_charges_currency, 
					acc_code, sum(tran_amount),
					'DR', 'From ABR - SNP Autogeneration - Bank Charges Account', costcenter,
					@line_no, 'Y', /*'N'*/ @tcal_flag /* Code commented and added for EPE-87691 */,
					analysiscode, subanalysiscode,analysiscode,subanalysiscode
					from abr_bsbb_tmp(nolock)
					where guid     = @guid
					and   taggroup =  @taggroup
					and   tran_type = 'SC'
					and	  mode_flag in ('X','Y','Z')
					group by acc_code,costcenter,analysiscode,subanalysiscode
				
				select @snp_raise_amt = 	sum(tran_amount)
				from  abr_bsbb_tmp(nolock)
				where guid  = @guid
				and   taggroup =  @taggroup	
					and   tran_type IN ('ID','SC')
					and	  mode_flag in ('X','Y','Z')		

			if @snp_raise_amt > 0
			begin
			
				--VE-3059
				if 	(@currency_code	=	@base_cur_tmp)
				begin
					SELECT @exchangerate	= 1
				end 
				else
				begin	
					exec @errorid_tmp	=	erate_sysact_spgetexcgrate @ctxt_ouinstance , @ctxt_user ,
					@ctxt_language ,@currency_code ,@base_cur_tmp , @snpdate ,@exch_ratetype_tmp ,
					@exchangerate	out ,@maxlimit_tmp out ,@minlimit_tmp out , @eratecat_tmp out ,
					@currunits_tmp out , 'SNP'

					if	@errorid_tmp	<>	0
					begin
					  close Snp_cursor1
			          deallocate Snp_cursor1
						--Exchange Rate is not defined
						exec fin_german_raiserror_sp 'SIN',@ctxt_language,75
						return		
					end
				end
				--VE-3059

				select	@paymentpoint	= ouinstname,
					    @buid_tmp	= bu_id
				from	emod_ou_vw (nolock)
				where	ou_id 	= @transactionou
				and	@sysdt_tmp between effective_from 
					and isnull(effective_to, @sysdt_tmp)

					if @ctxt_user ='debuguser_snp'
					begin
							select 'snp_is_voucher_dtl_tmp',@snp_raise_amt,* from snp_is_voucher_dtl_tmp where guid = @snp_guid
					end
				
				exec snp_is_autogensp	@ctxt_language, /*@ctxt_ouinstance,*/@transactionou, @ctxt_service, @ctxt_user, @snp_guid,
							'Sundry Payment', 'Y', 'N', 'SNP',/* @sysdt_tmp*/@snpdate, /*@default_fb_id,*/         /*Code modified by Aditya Sitaraman for ES_Abr_00257 */
							@financebook, 'ABRPAYEE',
							/*@sysdt_tmp*/@snpdate, 'NO', @currency_code, /*1*/@exchangerate --VE-3059
							, @snp_raise_amt, 'REGULAR',             /*Code modified by Aditya Sitaraman for ES_Abr_00257 */     
							'BANK', 'OTHERS', /*@bank_code,*/@bankcode, @paymentpoint, '', 'HIGH', 
							/*'From ABR - SNP Autogeneration'*/@jvnarration,@m_errorid output -- Code Modified for DMS412AT_ABR_00089

				if @ctxt_user = 'snpuser'
				begin
					select @m_errorid '@m_errorid'
				end
	
				if @m_errorid <>0
				begin
				   close Snp_cursor1
			       deallocate Snp_cursor1
			 		--Error in SNP Auto Genaration.
					exec fin_german_raiserror_sp 'ABR',@ctxt_language,24,'','','','','','','',@errormsgout
					return					
				end

			
				
				select	@voucher_no	= voucher_no
				from	snp_is_voucher_dtl_tmp (nolock)
				where	guid		= @snp_guid

				insert into abr_snp_gen_dtl
				(
					batch_id, document_no, stmt_no, taggroup, ou_id,
					tran_type, fb_id, pay_date, pay_currency, pay_amount,
					bank_acc_no, bank_code, stmt_st_date, stmt_end_date,
					company_code, remarks, ref_no,
					cost_center, analysis_code, subanalysis_code, org_ou_id					
				)
				select	@snp_guid, @voucher_no, @statementno, @taggroup, /*@ctxt_ouinstance,*/@transactionou,
					'PM_SPV', /*@default_fb_id,*/@financebook, /*@sysdt_tmp*/@snpdate, @currency_code, @snp_raise_amt, /*Code modified by Aditya Sitaraman for ES_Abr_00257 */     
					@bankaccountnumber, /*@bank_code,*/@bankcode, @startdate, @enddate,
					@compcode_tmp, 'SNP Auto Generated from ABR', @refno_tmp,
					@costcenter, @analysiscode, @subanalysiscode, @ctxt_ouinstance

				-- Fbp Updation for SNP Auto Generated
				update	DTL
				set	DTL.recon_flag		= 'R',
					DTL.modifiedby		= @ctxt_user,
					DTL.modifieddate	= @sysdt_tmp,
					DTL.recon_date		= @snpdate  /*Code modified by Aditya Sitaraman for ES_Abr_00257 */     
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

				select 	@state_flag 	= 'snpstate',
					@pay_voucherno	= @voucher_no

				if @ctxt_user = 'snpuser'
				begin
					select @voucher_no '@voucher_no'
					select * from abr_snp_gen_dtl (nolock) where batch_id = @guid

					select 'SI Entries'
					select * from si_doc_hdr (nolock) where tran_no = @voucher_no

					select * from si_doc_balance (nolock) where tran_no = @voucher_no

					select * from si_acct_info_dtl (nolock) where tran_no = @voucher_no						
				 end
			end
			insert into abr_reconcile_tmp  (guid	,	Tran_NO	,	Tran_Type	,Tran_OU,		
											Tran_Date,	Finance_Book
										)
					  values ( @guid,    @voucher_no,   'PM_SPV',  @transactionou,
					           @snpdate,     @financebook
							   )
           if exists ( select 'X'
		               from snp_is_voucher_dtl_tmp(nolock)
					   where guid =@snp_guid)
			begin 
			delete from snp_is_voucher_dtl_tmp
					   where guid =@snp_guid
			end
			select @line_no = 0 

			if exists ( select 'X'
			            from @ard_bank_acct_dtl
						)
             begin
			   Delete from @ard_bank_acct_dtl
			 end
			
			fetch next from  Snp_cursor1 into @taggroup
			end
			close Snp_cursor1
			deallocate Snp_cursor1


		declare	Snp_cursor2 cursor for

		select /*distinct*/   taggroup,fbid,bankcode,rpt_tran_ou,costcenter, analysiscode, subanalysiscode,acc_code,tran_amount,tran_type,acusage, stmt_no--PTP-970--PTP-1174
		from  abr_bsbb_tmp(nolock)
		where guid   =  @guid
		and   mode_flag in ('X','y','Z')
		and   tran_type in ('ID','SC')
		and   (taggroup  is  null or taggroup = '')
		 and  flag     = 'S'
		
		open  Snp_cursor2

		fetch next from  Snp_cursor2 into @taggroup,@financebook,@bankcode,@transactionou,@costcenter, @analysiscode,@subanalysiscode,@bank_charges_account,@bank_charge_amt,@tran_type,@usage_interest_paid
			,@statementno -- PTP-1174
		while (@@fetch_status = 0)
		 begin

		     insert into @ard_bank_acct_dtl
			(
				acct_code , fb_id
			)
			select	ARD.bankptt_account,ARD.fb_id
			from	bnkdef_code_mst BNK (nolock),
				ard_bnkcsh_account_mst ARD (nolock)
			where	BNK.company_code	= ARD.company_code
			and	BNK.fb_id			= ARD.fb_id
			and	BNK.bank_code		= ARD.bank_ptt_code
			and	BNK.flag			= ARD.flag
			and	BNK.bank_acc_no		= @bankaccountnumber
			and	BNK.company_code	= @compcode_tmp
			and	BNK.fb_id			= @financebook 
			and	BNK.flag			= 'B'
			and	BNK.status			= '2'

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
				and		BNK.fb_id			= @financebook 
				and		BNK.flag			= 'B'	
				and		BNK.status			= '2'
	
			end


				exec   @error_tmp = abr_autogensnp_validate_sp 
						@ctxt_language, @ctxt_ouinstance, @ctxt_service, @ctxt_user,
						@enddate, @guid, @startdate, @raisebnkchg, @financebook,
						@bankcode, @bankaccountnumber, @costcenter, @analysiscode,
						@subanalysiscode, @transactionou, @bank_charge_amt, @sysdt_tmp,
						@compcode_tmp,   @buid_tmp, @bank_charges_account

				if @error_tmp <> 0
				begin
				  close Snp_cursor2
			      deallocate Snp_cursor2
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
				

				--Payment Route - "BANK" ,Payment Method - "REGULAR" ,Electronic Payment - "NO"
				--Insert into Temp Table for Sundry Payment Service - Bank Charges Account.
				select @line_no = isnull(@line_no,0) + 1

				if @ctxt_user = 'snpuser'
				begin
					select	@bank_charges_account '@bank_charges_account',@bank_charge_amt  '@bank_charge_amt'
				end

				select @snp_guid = newid()
				
				/*Code Added by Aditya Sitaraman for ES_Abr_00257 starts*/
				if @statementno is not null
				begin	
									
						select	@snpdate 	= stmt_end_date
						from	abr_bank_statement_hdr(nolock)
						WHERE 	company_code 		=  @compcode_tmp 
						and		bank_acc_no			=  @bankaccountnumber
						and		stmt_no				=  @statementno
				end
				else
				begin
						select	@snpdate  = @enddate
				end
				
				select @snpdate = isnull(@snpdate, @sysdt_tmp)
				/*Code Added by Aditya Sitaraman for ES_Abr_00257 ends*/
				
				/*Code added for 14H109_abr_00006 begins here*/
					
				select @bank_charges_currency = ltrim(rtrim(currency_code))
				from   as_opacctall_vw (nolock)
				where  company_code = @compcode_tmp
				and    account_code = @bank_charges_account 	

			
				
				if @tran_type = 'ID'
				  begin
					insert into snp_is_voucher_dtl_tmp
					(
						guid, usageid, currencycodeml,
						accountcodeml, accountamountml,
						debitcredit, remarks, costcenter,
						acct_line_no, fbp_flag, tcal_flag,
						analysis_code, subanalysis_code,analysiscode,subanalysiscode
					)
				values (		@snp_guid, @usage_interest_paid, @currency_code,
						     null/*@bank_charges_account*/, @bank_charge_amt,
						'DR', 'From ABR - SNP Autogeneration - Interest Paid Account', @costcenter,
						@line_no, 'Y', /*'N'*/ @tcal_flag /* Code commented and added for EPE-87691 */,
						@analysiscode, @subanalysiscode,@analysiscode,@subanalysiscode
				   )
				   end

				 
           if @tran_type = 'SC'
		    begin
				insert into snp_is_voucher_dtl_tmp
				(
					guid, usageid, currencycodeml,
					accountcodeml, accountamountml,
					debitcredit, remarks, costcenter,
					acct_line_no, fbp_flag, tcal_flag,
					analysis_code, subanalysis_code,analysiscode,subanalysiscode--code modified Aditya Sitaraman for ES_abr_00269
				)
			values(
					@snp_guid, null, /*@currency_code*/@bank_charges_currency, --VE-3059
					@bank_charges_account, @bank_charge_amt,
					'DR', 'From ABR - SNP Autogeneration - Bank Charges Account', @costcenter,/*@cost_center_tmp,*/
					@line_no, 'Y', /*'N'*/ @tcal_flag /* Code commented and added for EPE-87691 */,
					@analysiscode, @subanalysiscode,@analysiscode,@subanalysiscode--code modified Aditya Sitaraman for ES_abr_00269
				  ) 
			end	
				select @snp_raise_amt = 	@bank_charge_amt		

			if @snp_raise_amt > 0--14H109_abr_00006
			begin
			
				--VE-3059
				if 	(@currency_code	=	@base_cur_tmp)
				begin
					SELECT @exchangerate	= 1
				end 
				else
				begin	
					exec @errorid_tmp	=	erate_sysact_spgetexcgrate @ctxt_ouinstance , @ctxt_user ,
					@ctxt_language ,@currency_code ,@base_cur_tmp , @snpdate ,@exch_ratetype_tmp ,
					@exchangerate	out ,@maxlimit_tmp out ,@minlimit_tmp out , @eratecat_tmp out ,
					@currunits_tmp out , 'SNP'

					if	@errorid_tmp	<>	0
					begin
					 close Snp_cursor2
			            deallocate Snp_cursor2
						--Exchange Rate is not defined
						exec fin_german_raiserror_sp 'SIN',@ctxt_language,75
						return		
					end
				end
				--VE-3059

				select	@paymentpoint	= ouinstname,
					    @buid_tmp	= bu_id
				from	emod_ou_vw (nolock)
				where	ou_id 	= @transactionou
				and	@sysdt_tmp between effective_from 
					and isnull(effective_to, @sysdt_tmp)

					if @ctxt_user ='debuguser_snp'
					begin
							select 'snp_is_voucher_dtl_tmp',* from snp_is_voucher_dtl_tmp where guid = @snp_guid
					end
				
				exec snp_is_autogensp	@ctxt_language, /*@ctxt_ouinstance,*/@transactionou, @ctxt_service, @ctxt_user, @snp_guid,
							'Sundry Payment', 'Y', 'N', 'SNP',/* @sysdt_tmp*/@snpdate, /*@default_fb_id,*/         /*Code modified by Aditya Sitaraman for ES_Abr_00257 */
							@financebook, 'ABRPAYEE',
							/*@sysdt_tmp*/@snpdate, 'NO', @currency_code, /*1*/@exchangerate --VE-3059
							, @snp_raise_amt, 'REGULAR',             /*Code modified by Aditya Sitaraman for ES_Abr_00257 */     
							'BANK', 'OTHERS', /*@bank_code,*/@bankcode, @paymentpoint, '', 'HIGH', 
							/*'From ABR - SNP Autogeneration'*/@jvnarration,@m_errorid output -- Code Modified for DMS412AT_ABR_00089

				if @ctxt_user = 'snpuser'
				begin
					select @m_errorid '@m_errorid'
				end
	
				if @m_errorid <>0
				begin
				   close Snp_cursor2
			      deallocate Snp_cursor2
					--Error in SNP Auto Genaration.
					exec fin_german_raiserror_sp 'ABR',@ctxt_language,24,'','','','','','','',@errormsgout
					return					
				end

				select	@voucher_no	= voucher_no
				from	snp_is_voucher_dtl_tmp (nolock)
				where	guid		= @snp_guid

				insert into abr_snp_gen_dtl
				(
					batch_id, document_no, stmt_no, taggroup, ou_id,
					tran_type, fb_id, pay_date, pay_currency, pay_amount,
					bank_acc_no, bank_code, stmt_st_date, stmt_end_date,
					company_code, remarks, ref_no,
					cost_center, analysis_code, subanalysis_code, org_ou_id					
				)
				select	@snp_guid, @voucher_no, @statementno, @taggroup, /*@ctxt_ouinstance,*/@transactionou,
					'PM_SPV', /*@default_fb_id,*/@financebook, /*@sysdt_tmp*/@snpdate, @currency_code, @snp_raise_amt, /*Code modified by Aditya Sitaraman for ES_Abr_00257 */     
					@bankaccountnumber, /*@bank_code,*/@bankcode, @startdate, @enddate,
					@compcode_tmp, 'SNP Auto Generated from ABR', @refno_tmp,
					@costcenter, @analysiscode, @subanalysiscode, @ctxt_ouinstance

				-- Fbp Updation for SNP Auto Generated
				update	DTL
				set	DTL.recon_flag		= 'R',
					DTL.modifiedby		= @ctxt_user,
					DTL.modifieddate	= @sysdt_tmp,
					DTL.recon_date		= @snpdate  /*Code modified by Aditya Sitaraman for ES_Abr_00257 */     
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

				select 	@state_flag 	= 'snpstate',
					@pay_voucherno	= @voucher_no

				if @ctxt_user = 'snpuser'
				begin
					select @voucher_no '@voucher_no'
					select * from abr_snp_gen_dtl (nolock) where batch_id = @guid

					select 'SI Entries'
					select * from si_doc_hdr (nolock) where tran_no = @voucher_no

					select * from si_doc_balance (nolock) where tran_no = @voucher_no

					select * from si_acct_info_dtl (nolock) where tran_no = @voucher_no						
				 end
			end
			insert into abr_reconcile_tmp  (guid	,	Tran_NO	,	Tran_Type	,Tran_OU,		
											Tran_Date,	Finance_Book
										)
					  values ( @guid,    @voucher_no,   'PM_SPV',  @transactionou,
					           @snpdate,     @financebook
							   )
           if exists ( select 'X'
		               from snp_is_voucher_dtl_tmp(nolock)
					   where guid =@snp_guid)
			begin 
			delete from snp_is_voucher_dtl_tmp
					   where guid =@snp_guid
			end
			if exists ( select 'X'
			            from @ard_bank_acct_dtl
						)
             begin
			   Delete from @ard_bank_acct_dtl
			 end

			select @line_no = 0 

			fetch next from  Snp_cursor2 into @taggroup,@financebook,@bankcode,@transactionou,@costcenter, @analysiscode,@subanalysiscode,@bank_charges_account,@bank_charge_amt,@tran_type,@usage_interest_paid
				,@statementno --PTP-1174
			end
			close Snp_cursor2
			deallocate Snp_cursor2



	set nocount off
end








