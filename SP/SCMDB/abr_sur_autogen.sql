/*$File_version=ms4.3.0.02$*/
/******************************************************************************/
/* procedure					: abr_sur_autogen      					      */
/* description					: 											  */
/******************************************************************************/
/* project						: 								 			  */
/* ecrno						: 								 			  */
/* version						: 								 			  */
/******************************************************************************/
/* referenced					: 								 			  */
/* tables						: 								 			  */
/******************************************************************************/
/* Development history			:											  */
/******************************************************************************/
/* Author						: Anusha.p  								  */
/* Date							: 29 jan 2018            					  */
/******************************************************************************/
/* modification history			: 											  */
/*Amrutha R.S				30/01/2018				EPE-5584				  */
/*Aditya S					13/12/2019				MPIE-139				  */  
/*Abhijith KP				26/09/2023				EPE-68785				  */
/******************************************************************************/
Create procedure abr_sur_autogen
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

	--declare	@bs_sc_amount		fin_amount,
	--		@bs_tran_type		fin_trantype,
	--		@bs_sc_date			fin_date,
	--		@bs_sc_remarks		fin_text255,
	--		@bs_sc_docno 		fin_documentno,
	--		@bs_sc_prefix		fin_prefix,
	--		@bs_sc_stmtno		fin_documentno,
	--		@bs_sc_check_no		fin_checknumber,
	--		@bs_sc_comp_ref		fin_checknumber,
	--		@bs_sc_slipno		fin_documentnumber,
	--		@bs_sc_sno			fin_number,
	--		@bs_py_amount		fin_amount,
	--		@bs_rt_amount		fin_amount,
	--		@bb_py_amount		fin_amount,
	--		@bb_rt_amount		fin_amount,
	declare	@compcode_tmp		fin_companycode,
		--	@count_bs			fin_int,
		--	@count_bb			fin_int,
		--	@errormsgout		fin_text2500,
			@sysdt_tmp			fin_date,
			@statementno		fin_statementnumber, 
		--	@bank_code			fin_bankcode,
		--	@tag_group			fin_code,
		--	@bb_sno_tmp			fin_number,
			@refno_tmp			fin_documentno,
		--	@bs_seqno_tmp		fin_int,
		--	@bb_seqno_tmp		fin_int,
		--	@snp_raise_amt		fin_amount,
		--	@err_tmp			fin_int,
		--	@bs_tag_count		fin_int,
		--	@bb_tag_count		fin_int,
		--	@tag_count			fin_int,
			@taggroup			fin_code,
		--	@err_taggroup		fin_code,
		--	@auto_taggen_flag	fin_flag,
		--	@seq_no				fin_int,
		--	@bank_charge_amt	fin_amount,
		--	@chg_coll_amt		fin_amount,
			@line_no			fin_int,
			@buid_tmp			fin_buid,
		--	@paymentpoint		fin_ouinstname,
			@currency_code		fin_currency,
		--	@bank_charges_account	fin_accountcode,
		--	@chg_coll_account	fin_accountcode,
		--	@default_fb_id		fin_financebookid,
		--	@voucher_no			fin_documentno,
		--	@snp_guid			fin_guid,
		--	@pay_amount			fin_amount,
		--	@sc_amount			fin_amount,
		--	@tag_group_st		fin_code,
		--	@tag_group_recon	fin_code,
			@error_tmp			fin_int,
		--	@raise_bank_charges	fin_status,
		--	@state_flag 		fin_flag,
		--	@pay_voucherno		fin_documentno,
		--	@curr_st_seqno		fin_int,		
		--	@rev_entry_flag		fin_flag,
		--	@refno_recon		fin_code,
		--	@refno_st			fin_code
			 @int_acc_param		fin_paramcode,
				@financebook		fin_financebookid,
	@bankcode			fin_bankcode,
	@transactionou		fin_chargesou,
	@costcenter			fin_costcenter,
	@analysiscode		fin_analysiscode,
	@subanalysiscode	fin_subanalysiscode

	--declare @ppsflag fin_flag
	--declare @snpdate fin_date  
	declare	@base_cur_tmp 			fin_currencycode ,
			@exch_ratetype_tmp		fin_paramcode	 ,
			@maxlimit_tmp 			fin_amount ,
			@minlimit_tmp 			fin_amount ,
			@eratecat_tmp  			fin_param_text ,
			@currunits_tmp 			fin_currencycode ,
			@errorid_tmp			fin_int	,
			@exchangerate           fin_exchangerate
	--@bank_charges_currency	fin_currency	
			
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
	declare @sur_guid					fin_guid,
			--@ardguid1					fin_guid,
			--@ardguid2					fin_guid,
			--@return_val					fin_int,
			@surdate					fin_date,
			--@snp_intpaid_accode			fin_accountcode,
			@sur_intrecd_accode			fin_accountcode,
			@receiptcategory			fin_receiptcategory,
			@sundryreceiptvoucher		fin_desc255,
			@receiptmethod				fin_method,
			@receiptmode				fin_receiptmode,
			@receiptroute				fin_route,
			@bankdescription  			fin_bankdescription,			
			---@errormsg_tmp				fin_desc255,
			---@snp_intpaid_amt			fin_amount,
			@sur_intrecd_amt			fin_amount,
			--@id_amt						fin_amount,	
			--@ic_amt						fin_amount,
			--@sc_amt						fin_amount,
			--@diff_intpaid_amt			fin_amount,
			--@diff_intrecd_amt			fin_amount,
			--@max_interest_paid			fin_amount,
			--@max_interest_received		fin_amount,
			--@usage_interest_paid		fin_usageid,
			@usage_interest_received	fin_usageid
	/*Code added for 14H109_abr_00006 ends here*/	
	
	select @sysdt_tmp = convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120) -- EPE-5584	

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
	
	--MPIE-139
	/*
	select  @exch_ratetype_tmp = parameter_value
	from	ops_processparam_vw ( nolock )
	where	ou_id			= @ctxt_ouinstance 
	and		parameter_type  = 'PMSYS' 
	and		parameter_code  = 'SETTLEMENTERTYPE'
	*/
	SELECT 	@exch_ratetype_tmp  	= parameter_value
	FROM 	cps_processparam_vw (NOLOCK) 
	WHERE  	company_code 		= @compcode_tmp 
	and 	parameter_type 		= 'SYS' 
	and 	parameter_code 		= 'BANKRPTERTYPE'
	--MPIE-139
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

	if
	(
		select 	count(distinct stmt_no)
		from	abr_bsbb_tmp (nolock)
		where	guid		= @guid
		and		flag		= 'S'
		and		mode_flag in ('X','Y','Z')
	)=1
	begin
		select 	@statementno	= stmt_no
		from	abr_bsbb_tmp (nolock)
		where	guid		= @guid
		and	flag		= 'S'
		and	mode_flag in ('X','Y','Z')
	end
	else
	begin
		select @statementno = null
	end

	declare @ard_bank_acct_dtl
	table
	(
		acct_code	fin_accountcode,
		fb_id		fin_financebookid 
	)

	
		--select  @max_interest_paid		=	max_interest_paid,
		--		@max_interest_received	=	max_interest_received,
		--		--@usage_interest_paid	=	usage_interest_paid,
		--		--@usage_interest_received=	usage_interest_received,
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
		
	declare	Sur_cursor1 cursor for

		select distinct   taggroup
		from  abr_bsbb_tmp(nolock)
		where guid   =  @guid
		and   mode_flag in ('X','y','Z')
		and   tran_type in ('IC')
		and   taggroup is not null
		and   isnull(taggroup,'') <> ''--EPE-68785
		 and  flag     = 'S'
		
		open  Sur_cursor1

		fetch next from  Sur_cursor1 into @taggroup
		while (@@fetch_status = 0)
		 begin
		   select @financebook  = fbid,
		          @bankcode     = bankcode,
				  @transactionou =rpt_tran_ou 
			from   abr_bsbb_tmp(nolock)
		    where guid     =  @guid
		    and   taggroup =  @taggroup
			and		mode_flag in ('X','Y','Z')
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
			  and   flag      = 'S'
			  and		mode_flag in ('X','Y','Z')
			  and   tran_type = 'IC'	

			   open validate_cursor

			 fetch next from  validate_cursor into   @costcenter, @analysiscode,@subanalysiscode,@sur_intrecd_accode,@sur_intrecd_amt

			  while (@@fetch_status = 0)
			   begin
					
						exec @error_tmp = abr_autogensnp_validate_sp 
							@ctxt_language, @ctxt_ouinstance, @ctxt_service, @ctxt_user,
							@enddate, @guid, @startdate, @raisebnkchg, @financebook,
							@bankcode, @bankaccountnumber, @costcenter, @analysiscode,
							@subanalysiscode, @transactionou, @sur_intrecd_amt, @sysdt_tmp,
							@compcode_tmp, @buid_tmp, @sur_intrecd_accode

					if @error_tmp <> 0
					begin
					   close    validate_cursor
			           deallocate validate_cursor
					   close Sur_cursor1
			           deallocate Sur_cursor1
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

						if (@error_tmp = 9999) 
						begin
							return
						end
					end

				 fetch next from  validate_cursor into   @costcenter, @analysiscode,@subanalysiscode,@sur_intrecd_accode,@sur_intrecd_amt
         end
			close    validate_cursor
			deallocate validate_cursor
					
					select 	@receiptcategory  		=  parameter_text
					from 	fin_quick_code_met ( nolock )
					where 	component_id 		= 'SUR'
					and 	parameter_type 		= 'CBO'
					and 	parameter_category	= 'RPTCAT'
					and		parameter_code		= 'R'
					and		language_id			= @ctxt_language
					
					select	@receiptmethod 	= rcpt_pymt_method 
					from	bnkdef_rcpt_pay_method_vw (nolock)
					where 	 rcpt_pymt_method_code	= 'RGLR'
					and 	language_id  			= @ctxt_language	

					select	@receiptmode 	= rcpt_pymt_mode 
					from	bnkdef_rcpt_pay_mode_vw (nolock)
					where 	 rcpt_pymt_mode_code	= 'OT'
					and 	language_id  			= @ctxt_language	
					
					select	@receiptroute		=  rcpt_pymt_route
					from	bnkdef_rcpt_pay_route_vw (nolock)
					where 	rcpt_pymt_route_code 	= 'B'
					and 	language_id  			= @ctxt_language

					select	@bankdescription 	=	bank_desc
					from	bnkdef_code_mst(nolock)
					where	bank_code			= @bankcode
					and		company_code		= @compcode_tmp

					if @statementno is not null
					begin	
							select	@surdate 			= stmt_end_date
							from	abr_bank_statement_hdr(nolock)
							WHERE 	company_code 		=  @compcode_tmp 
							and		bank_acc_no			=  @bankaccountnumber
							and		stmt_no				=  @statementno
					end
					else
					begin
							select	@surdate  = @enddate
					end					
					
					--MPIE-139
					if 	(@currency_code	=	@base_cur_tmp)
					begin
							SELECT @exchangerate	= 1
					end 
					else
					begin	

						exec @errorid_tmp	=	erate_sysact_spgetexcgrate @ctxt_ouinstance , @ctxt_user ,
										@ctxt_language , @currency_code ,@base_cur_tmp , @surdate, @exch_ratetype_tmp ,
										@exchangerate out ,@maxlimit_tmp out ,@minlimit_tmp out , @eratecat_tmp out ,
										@currunits_tmp out , 'SUR'
		
						if	@errorid_tmp	<>	0
						begin
								--Exchange Rate is not defined
								exec fin_german_raiserror_sp 'SIN',@ctxt_language,75
								return		
						end
					end
					--MPIE-139	

					select @sur_guid = newid()					

					insert into sur_is_voucher_dtl_tmp
					(
						guid,				account_code,				analysis_code,			Account_Amount, 
						cost_center,		currency_code,				drcr_flag,				exchangerate, 
						fb,					usage,						instrdate,				modeflag, 
						netcramount,		remarksml,					
						subanalysis_code,	fprowno 
						--successflag,		item_code,					item_desc,			
					)
					select	
						@sur_guid,			NULL,						analysiscode,			sum(tran_amount),
						costcenter,			@currency_code,				'CR',					/*1,*/@exchangerate,--MPIE-139
						@financebook,		acusage,	NULL,					NULL,
						sum(tran_amount),	'From ABR - SUR Autogeneration - Interest Paid Account',
						subanalysiscode,	1
					from  abr_bsbb_tmp(nolock)
					where guid     = @guid
					and   taggroup =  @taggroup
					and   tran_type = 'IC'		
					and	  mode_flag in ('X','Y','Z')
					group by acusage,costcenter, analysiscode, subanalysiscode	

					select @sur_intrecd_amt = 	sum(tran_amount)
					from  abr_bsbb_tmp(nolock)
					where guid  = @guid
					and   taggroup =  @taggroup	
					and   tran_type = 'IC'		
					and	  mode_flag in ('X','Y','Z')	
					

					if Exists(	Select	'X'
								From	sur_is_voucher_dtl_tmp(nolock)
								where	guid	=	@sur_guid
							 )
					Begin								
						exec	sur_is_autogensp
								'~#~',--@authorizationnumber,
								@bankcode,
								@bankcode,
								@bankdescription,
								-915,--@calendaryear
								'~#~',--@cardnumber
								@sysdt_tmp,--@createddate
								@ctxt_user,--@creationby
								@ctxt_language,
								@transactionou,--@ctxt_ouinstance,
								@ctxt_service,
								@ctxt_user,
								@currency_code,
								--1,--@exchangerate,	--MPIE-139
								@exchangerate,			--MPIE-139
								@financebook,
								'~#~',--@finmonth
								@sur_guid,
								-915,--@instramt
								'01/01/1900',--@instrdate
								'~#~',--@instrumentnumber
								'~#~',--@issuer
								'~#~',--@micrnumber
								@sur_intrecd_amt,--@netcramount
								NULL,--@notypeno,
								@sur_intrecd_amt,--@receiptamt
								@receiptcategory,
								@surdate,
								@receiptmethod,
								@receiptmode,
								'~#~',--@receiptnumber,
								@receiptroute,
								'Generated from ABR',--@referencedocumentnumber
								'Generated from ABR',--@remarks
								'ABR Remitter',--@remittername
								'~#~',--@rptstatus
								-915,--@timestamp
								'Y',--@fbp_calling_mode
								'~#~',--@instrumenttype
								@m_errorid	 OUTPUT			
								
								if @m_errorid <> 0
								begin
								   close Sur_cursor1
			                       deallocate Sur_cursor1
									--Error in Sundry Receipt Autogeneration for Interest Received.
									exec fin_german_raiserror_sp  'BNKDEF',@ctxt_language,1215
									return
								end
							
								select 	@sundryreceiptvoucher = ReceiptNumber
								from sur_is_voucher_dtl_tmp (nolock)
								where guid = @sur_guid
								
								
								update	sur_receipt_hdr 
								set		auto_gen_flag	=	'N'
								Where	receipt_no		=	@sundryreceiptvoucher
								and		Ou_id			=	@transactionou								

								
							update	DTL
							set		DTL.recon_flag		= 'R',
									DTL.modifiedby		= @ctxt_user,
									DTL.modifieddate	= @sysdt_tmp,
									DTL.recon_date		= @surdate    
							from	fbp_posted_trn_dtl	DTL (nolock)
							where	DTL.company_code	= @compcode_tmp
							and		DTL.document_no		= @sundryreceiptvoucher
							and		DTL.account_code in
									(
										select	acct_code
										from	@ard_bank_acct_dtl
									)
							and		DTL.tran_type		= 'RM_SR'
							and		DTL.tran_ou			= @transactionou 
							and		DTL.fb_id			= @financebook	
							
							if isnull(@taggroup,'')	 = ''
							begin
								select	distinct @taggroup	=  taggroup
								from	abr_bsbb_tmp (nolock)
								where	guid			= @guid
								and		type_flag 		in ('RT')
								and		mode_flag		in ('X','Y','Z')						
							end															

							insert into abr_snp_gen_dtl
							(
								batch_id, document_no, stmt_no, taggroup, ou_id,
								tran_type, fb_id, pay_date, pay_currency, pay_amount,
								bank_acc_no, bank_code, stmt_st_date, stmt_end_date,
								company_code, remarks, ref_no,
								cost_center, analysis_code, subanalysis_code, org_ou_id
							)
							select	@sur_guid, @sundryreceiptvoucher, @statementno, @taggroup,@transactionou,
									'RM_SR', @financebook, @surdate, @currency_code, @sur_intrecd_amt,
									@bankaccountnumber, @bankcode, @startdate, @enddate,
									@compcode_tmp, 'SUR Auto Generated from ABR', @refno_tmp,
									@costcenter, @analysiscode, @subanalysiscode, @ctxt_ouinstance										
					end	
			insert into abr_reconcile_tmp  (guid	,	Tran_NO	,	Tran_Type	,Tran_OU,		
											Tran_Date,	Finance_Book
										)
					  values ( @guid,    @sundryreceiptvoucher,   'RM_SR',  @transactionou,
					           @surdate,     @financebook
							   )

			if exists( select 'X'
			           from  sur_is_voucher_dtl_tmp(nolock)
					   where guid = @sur_guid
					   )
				begin 
				  Delete from sur_is_voucher_dtl_tmp
					   where guid = @sur_guid
				end
				select @line_no = 0 

				if exists ( select 'X'
			            from @ard_bank_acct_dtl
						)
 begin
			   Delete from @ard_bank_acct_dtl
			 end
			fetch next from  Sur_cursor1 into @taggroup
			end
			close Sur_cursor1
			deallocate Sur_cursor1


			declare	Sur_cursor2 cursor for

		select distinct   taggroup,fbid,bankcode,rpt_tran_ou,costcenter, analysiscode, subanalysiscode,acc_code,tran_amount,acusage
		from  abr_bsbb_tmp(nolock)
		where guid   =  @guid
		and   mode_flag in ('X','y','Z')
		and   tran_type in ('IC')
		and   (taggroup is  null or taggroup = '')
		 and  flag     = 'S'
		
		open  Sur_cursor2

		fetch next from  Sur_cursor2 into @taggroup,@financebook,@bankcode,@transactionou,@costcenter, @analysiscode,@subanalysiscode,@sur_intrecd_accode,@sur_intrecd_amt,@usage_interest_received
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
		   	
						exec @error_tmp = abr_autogensnp_validate_sp 
							@ctxt_language, @ctxt_ouinstance, @ctxt_service, @ctxt_user,
							@enddate, @guid, @startdate, @raisebnkchg, @financebook,
							@bankcode, @bankaccountnumber, @costcenter, @analysiscode,
							@subanalysiscode, @transactionou, @sur_intrecd_amt, @sysdt_tmp,
							@compcode_tmp, @buid_tmp, @sur_intrecd_accode

					if @error_tmp <> 0
					begin
					   close Sur_cursor2
		           	deallocate Sur_cursor2
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

						if (@error_tmp = 9999) 
						begin
							return
						end
					end

					
					select 	@receiptcategory  		=  parameter_text
					from 	fin_quick_code_met ( nolock )
					where 	component_id 		= 'SUR'
					and 	parameter_type 		= 'CBO'
					and 	parameter_category	= 'RPTCAT'
					and		parameter_code		= 'R'
					and		language_id			= @ctxt_language
					
					select	@receiptmethod 	= rcpt_pymt_method 
					from	bnkdef_rcpt_pay_method_vw (nolock)
					where 	 rcpt_pymt_method_code	= 'RGLR'
					and 	language_id  			= @ctxt_language	

					select	@receiptmode 	= rcpt_pymt_mode 
					from	bnkdef_rcpt_pay_mode_vw (nolock)
					where 	 rcpt_pymt_mode_code	= 'OT'
					and 	language_id  			= @ctxt_language	
					
					select	@receiptroute		=  rcpt_pymt_route
					from	bnkdef_rcpt_pay_route_vw (nolock)
					where 	rcpt_pymt_route_code 	= 'B'
					and 	language_id  			= @ctxt_language

					select	@bankdescription 	=	bank_desc
					from	bnkdef_code_mst(nolock)
					where	bank_code			= @bankcode
					and		company_code		= @compcode_tmp

					if @statementno is not null
					begin	
							select	@surdate 			= stmt_end_date
							from	abr_bank_statement_hdr(nolock)
							WHERE 	company_code 		=  @compcode_tmp 
							and		bank_acc_no			=  @bankaccountnumber
							and		stmt_no				=  @statementno
					end
					else
					begin
							select	@surdate  = @enddate
					end						

					--MPIE-139
					if 	(@currency_code	=	@base_cur_tmp)
					begin
							SELECT @exchangerate	= 1
					end 
					else
					begin	

						exec @errorid_tmp	=	erate_sysact_spgetexcgrate @ctxt_ouinstance , @ctxt_user ,
										@ctxt_language , @currency_code ,@base_cur_tmp , @surdate, @exch_ratetype_tmp ,
										@exchangerate out ,@maxlimit_tmp out ,@minlimit_tmp out , @eratecat_tmp out ,
										@currunits_tmp out , 'SUR'
		
						if	@errorid_tmp	<>	0
						begin
								--Exchange Rate is not defined
								exec fin_german_raiserror_sp 'SIN',@ctxt_language,75
								return		
						end
					end
					--MPIE-139

					select @sur_guid = newid()					

					insert into sur_is_voucher_dtl_tmp
					(
						guid,				account_code,				analysis_code,			Account_Amount, 
						cost_center,		currency_code,				drcr_flag,				exchangerate, 
						fb,					usage,						instrdate,				modeflag, 
						netcramount,		remarksml,					
						subanalysis_code,	fprowno 
						--successflag,		item_code,					item_desc,			
					)
					select	
						@sur_guid,			NULL,						@analysiscode,			@sur_intrecd_amt,
						@costcenter,		@currency_code,				'CR',					/*1,*/@exchangerate,--MPIE-139
						@financebook,		@usage_interest_received,	NULL,					NULL,
						@sur_intrecd_amt,	'From ABR - SUR Autogeneration - Interest Paid Account',
						@subanalysiscode,	1
					
					--select @sur_intrecd_amt = 	sum(tran_amount)
					--from  abr_bsbb_tmp(nolock)
					--where guid  = @guid
					--and   taggroup =  @taggroup	

					if @ctxt_user = 'sur_user'
					 begin
					   select * from  sur_is_voucher_dtl_tmp where guid = @sur_guid
					 end
					

					if Exists(	Select	'X'
								From	sur_is_voucher_dtl_tmp(nolock)
								where	guid	=	@sur_guid
							 )
					Begin								
						exec	sur_is_autogensp
								'~#~',--@authorizationnumber,
								@bankcode,
								@bankcode,
								@bankdescription,
								-915,--@calendaryear
								'~#~',--@cardnumber
								@sysdt_tmp,--@createddate
								@ctxt_user,--@creationby
								@ctxt_language,
								@transactionou,--@ctxt_ouinstance,
								@ctxt_service,
								@ctxt_user,
								@currency_code,
								--1,--@exchangerate,	--MPIE-139
								@exchangerate ,			--MPIE-139
								@financebook,
								'~#~',--@finmonth
								@sur_guid,
								-915,--@instramt
								'01/01/1900',--@instrdate
								'~#~',--@instrumentnumber
								'~#~',--@issuer
								'~#~',--@micrnumber
								@sur_intrecd_amt,--@netcramount
								NULL,--@notypeno,
								@sur_intrecd_amt,--@receiptamt
								@receiptcategory,
								@surdate,
								@receiptmethod,
								@receiptmode,
								'~#~',--@receiptnumber,
								@receiptroute,
								'Generated from ABR',--@referencedocumentnumber
								'Generated from ABR',--@remarks
								'ABR Remitter',--@remittername
								'~#~',--@rptstatus
								-915,--@timestamp
								'Y',--@fbp_calling_mode
								'~#~',--@instrumenttype
								@m_errorid	 OUTPUT			
								
								if @m_errorid <> 0
								begin
								   close Sur_cursor2
			                      deallocate Sur_cursor2
									--Error in Sundry Receipt Autogeneration for Interest Received.
									exec fin_german_raiserror_sp  'BNKDEF',@ctxt_language,1215
									return
								end
							
								select 	@sundryreceiptvoucher = ReceiptNumber
								from sur_is_voucher_dtl_tmp (nolock)
								where guid = @sur_guid
								
								update	sur_receipt_hdr 
								set		auto_gen_flag	=	'N'
								Where	receipt_no		=	@sundryreceiptvoucher
								and		Ou_id			=	@transactionou								

								delete sur_is_voucher_dtl_tmp 
								where guid = @sur_guid
								
							update	DTL
							set		DTL.recon_flag		= 'R',
									DTL.modifiedby		= @ctxt_user,
									DTL.modifieddate	= @sysdt_tmp,
									DTL.recon_date		= @surdate    
							from	fbp_posted_trn_dtl	DTL (nolock)
							where	DTL.company_code	= @compcode_tmp
							and		DTL.document_no		= @sundryreceiptvoucher
							and		DTL.account_code in
									(
										select	acct_code
										from	@ard_bank_acct_dtl
									)
							and		DTL.tran_type		= 'RM_SR'
							and		DTL.tran_ou			= @transactionou 
							and		DTL.fb_id			= @financebook	
							
							if isnull(@taggroup,'')	 = ''
							begin
								select	distinct @taggroup	=  taggroup
								from	abr_bsbb_tmp (nolock)
								where	guid			= @guid
								and		type_flag 		in ('RT')
								and		mode_flag		in ('X','Y','Z')						
							end															

							insert into abr_snp_gen_dtl
							(
								batch_id, document_no, stmt_no, taggroup, ou_id,
								tran_type, fb_id, pay_date, pay_currency, pay_amount,
								bank_acc_no, bank_code, stmt_st_date, stmt_end_date,
								company_code, remarks, ref_no,
								cost_center, analysis_code, subanalysis_code, org_ou_id
							)
							select	@sur_guid, @sundryreceiptvoucher, @statementno, @taggroup,@transactionou,
									'RM_SR', @financebook, @surdate, @currency_code, @sur_intrecd_amt,
									@bankaccountnumber, @bankcode, @startdate, @enddate,
									@compcode_tmp, 'SUR Auto Generated from ABR', @refno_tmp,
									@costcenter, @analysiscode, @subanalysiscode, @ctxt_ouinstance										
					end	
			insert into abr_reconcile_tmp  (guid	,	Tran_NO	,	Tran_Type	,Tran_OU,		
											Tran_Date,	Finance_Book
										)
					  values ( @guid,    @sundryreceiptvoucher,   'RM_SR',  @transactionou,
					           @surdate,     @financebook
							   )

			if exists( select 'X'
			           from  sur_is_voucher_dtl_tmp(nolock)
					   where guid = @sur_guid
					   )
				begin 
				  Delete from sur_is_voucher_dtl_tmp
					   where guid = @sur_guid
				end

			if exists ( select 'X'
			            from @ard_bank_acct_dtl
						)
             begin
			   Delete from @ard_bank_acct_dtl
			 end

				select @line_no = 0 
			fetch next from  Sur_cursor2 into @taggroup,@financebook,@bankcode,@transactionou,@costcenter, @analysiscode,@subanalysiscode,@sur_intrecd_accode,@sur_intrecd_amt,@usage_interest_received
			end
			close Sur_cursor2
			deallocate Sur_cursor2
									
			
	set nocount off
end




