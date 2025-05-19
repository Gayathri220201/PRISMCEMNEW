/* $File_version : MS4.3.0.36$ */
/*****************************************************************/
/* Procedure					: Acap_dim_populate_sp			 */
/* Description					: 								 */
/*****************************************************************/
/* Project						: 								 */
/* EcrNo						: 								 */
/* Version						: 								 */
/*****************************************************************/
/* Referenced					: 								 */
/* Tables						: 								 */
/*****************************************************************/
/* Development history			: 	EBS-983						 */
/*****************************************************************/
/* Author						: Padma M						 */
/* Date							: feb 09 2018					 */
/*****************************************************************/
/* Modification History			: 								 */
/*****************************************************************/
/* Modified By					: 								 */
/* Date							: 								 */
/* Description					: 								 */
/*Abinaya V             09-02-2018               EBS-982         */
/*Padma M				21-02-2018				 EBS-1051/EBS-987*/
/* Abinaya V			14-03-2018				 EBS-1159		 */
/* Abinaya V			08-05-2018				 EBS-1379		 */
/* Abinaya V			22-05-2018				 EBS-1413		 */
/*Padma M				9-07-2018				 EBS-1668		 */
/* Abinaya V			23-07-2018				 EBS-1720		 */
/*Padma M				6-08-2018				 EBS-1799 		 */
/*grant exec on Acap_dim_populate_sp to public					 */
/* Padma M			   21/08/2018				EBS-1849/EBS-1799 */
/*Abinaya V			   27-08-2018               EBS-1869         */
/*Abinaya V			   06-09-2018               EBS-1924         */
/*Abinaya V			   19-09-2018               EBS-1935         */
/*Abinaya V			   19-09-2018               EBS-1928         */
/*Abinaya V			   27-09-2018               EBS-2003         */
/*Abinaya V			   04-10-2018               EBS-2008         */
/*Abinaya V			   05-10-2018               EBS-2013         */
/*Abinaya V			   02-11-2018               EBS-2129         */
/*Abinaya V			   02-11-2018               EBS-2141         */
/*Sivapriya J		   14-05-2019               UWC-267			 */
/*Sivapriya J		   30-05-2019               ALPF-235		 */
/*Abinaya V			   21-06-2019			    EBS-3069	 	*/
/*Abinaya V			   30-10-2019			    EBS-3179	 	*/
/*Abinaya V			   07-02-2020			    EBS-3934	 	*/
/*Abinaya V			   17-03-2020				EBS-4237	    */
/*Abinaya V			   10-08-2020				EBS-4763/EBS-5180 */
/*Abinaya V			   26-11-2020				EBS-3136		*/
/*Saranraj C	       28/11/2022			    ADECCOUAT-1014	*/
/*****************************************************************/

CREATE procedure Acap_dim_populate_sp
	@ctxt_language		fin_ctxt_language,
	@ctxt_ouinstance	fin_ctxt_ouinstance,
	@ctxt_service		fin_ctxt_service,
	@ctxt_user			fin_ctxt_user,
	@tran_no	 		fin_documentnumber,
	@tran_ou			fin_ouinstid,
	@tran_type			fin_cmntrantype,
	@guid1              fin_guid = null--EBS-1869
	,@tagnumber			fin_assettagno = null --EBS-2003
	,@assetnumber		fin_assetnumber = null		--UWC-267
as
Begin

	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	declare	@company_code		fin_company_code,
			@guid				fin_guid,
			@fbp_calling_mode	fin_flag,
			@opcoa_id			fin_company_code 
	
	select	@company_code	=	company_code
	from	emod_ou_vw(nolock)
	where	ou_id			=	@ctxt_ouinstance
	
	select @opcoa_id	= opcoa_id
	from   as_opaccountcomp_map (nolock)
	where  company_code = @company_code		

	declare @orgtran_no	 		fin_documentnumber,
			@orgtran_type		fin_cmntrantype , 	
			@orgtran_ou			fin_ctxt_ouinstance,
			@fb_voucher_no		fin_documentnumber
    /*Code added for Defect Id:- EBS-1051/EBS-987 starts here*/
	declare @doc_date			fin_date, 
			@fin_yr_code		fin_financeyear,
			@fin_prd_code		fin_financeperiod
    /*Code added for Defect Id:- EBS-1051/EBS-987 ends here*/

	--EBS-4237 starts
	declare @bfg_code				fin_bfgid,
			@fin_year_code			fin_financeyear,
			@fin_period_code		fin_financeperiod,
			@fin_year_stdt			datetime,
			@fin_year_enddt			datetime,
			@fin_period_stdt		datetime,
			@fin_period_enddt		datetime,
			@financeperiodrange		fin_desc255,
			@tran_fb				fin_financebookid
	--EBS-4237 ends

	Declare @asset_no fin_documentno,
				@tagcount	fin_rowno,
				@doc_number	fin_documentno,
				@refcount	fin_rowno,
				@tagno		fin_rowno
	
	if	exists	(	select	'x'	from Dim_tran_post_dtl(nolock)
				where	tran_ou		=	@tran_ou
				and		tran_no		=	@tran_no
				and		tran_type	=	@tran_type)
	begin
		delete	from Dim_tran_post_dtl
		where	tran_no		=	@tran_no
		and		tran_type	=	@tran_type
	end

	if	exists	(	select	'x'	from Dim_tran_dtl(nolock)
				where	tran_ou		=	@tran_ou
				and		tran_no		=	@tran_no
				and		tran_type	=	@tran_type)
	begin
		delete	from Dim_tran_dtl
		where	tran_no		=	@tran_no
		and		tran_type	=	@tran_type
	end

	
	/*Code added for Defect Id:- EBS-1051/EBS-987 starts here*/
	--CWIP reversal	
	if @ctxt_service in ('acapwrvmsrrev')			
	begin	
		--code commented and added for EBS-3934 starts
		/*			
		select 	@orgtran_no		=	rev_doc_number, 
				@orgtran_ou		=	ou_id
		from	acap_wip_hdr (nolock)
		where	doc_number			=	@tran_no
		and		ou_id				=	@tran_ou
		and		WIP_status		in	('IA')
		
		select top 1 @fb_voucher_no	=	fb_voucher_no , 
					@guid			=	batch_id ,
					@doc_date		=	posting_date , 
					@fin_yr_code	=	fin_year_code ,
					@fin_prd_code	=	fin_period_code
		from	fbp_posted_trn_dtl(nolock)
		where	tran_ou		=	@orgtran_ou
		and		document_no	=	@orgtran_no
		and		tran_type	=	'FA_RCAPWIP'
		*/

		select  @orgtran_no		=   doc_number,
				@orgtran_ou		=   ou_id
				,@tran_fb		=	fb_id --EBS-4237
		from 	acap_wip_hdr (nolock)
		where   rev_doc_number  =   @tran_no
		and		ou_id			=	@tran_ou 

		select top 1 
				@fb_voucher_no	=	fb_voucher_no , 
				@guid			=	batch_id ,
				@doc_date		=	posting_date  
				--@fin_yr_code	=	fin_year_code ,
				--@fin_prd_code	=	fin_period_code
		from	fbp_posted_trn_dtl(nolock)
		where	tran_ou			=	@tran_ou
		and		document_no		=	@tran_no
		and		tran_type		=	@tran_type
		--code commented and added for EBS-3934 ends


		--EBS-4237 starts		
		select	@company_code		=	company_code
		from	emod_ou_vw(nolock)
		where   ou_id				=	@tran_ou
					
		select  @bfg_code 			=	a.bfg_code  
		from 	emod_bfg_comp_vw a(nolock) ,
				emod_trantype_vw b(nolock)
		where 	b.tran_type			=   @tran_type
		and		a.component_id 		=   b.component_id 
		and  	a.language_id 		=   @ctxt_language  
		and		a.language_id		=   b.language_id

		select  @fin_year_code      =	vw.fin_year_code,     
				@fin_period_code   	=	vw.fin_period_code,
				@fin_year_stdt     	=	vw.fin_year_stdt,
				@fin_year_enddt		=	vw.fin_year_enddt,
				@fin_period_stdt   	=	vw.fin_period_stdt,
				@fin_period_enddt   =	vw.fin_period_enddt,
				@financeperiodrange	=	vw.financeperiodrange
		from    fcc_bfg_sysact_allperiod_vw VW (nolock)
		where   VW.bfg_code  		=	@bfg_code  
		and 	VW.fb_id  			=	@tran_fb  
		and		VW.ou_id			=	@tran_ou
		and 	VW.company_code		=	@company_code	
		and     @doc_date	 between	VW.fin_period_stdt	and	VW.fin_period_enddt
		--EBS-4237 ends

		insert	into	dim_postings_dtl
				(
					timestamp,			batch_id,			company_code,			component_name,			bu_id,						fb_id,
					tran_ou,			fb_voucher_no,		fb_voucher_date,		recon_flag,				con_ref_voucherno,			document_no,
					tran_type,			tran_date,			entry_date,				auth_date,				posting_date,				ou_id,
					account_code,		drcr_flag,			currency_code,			tran_amount,			base_amount,				par_base_amount,
					exchange_rate,		par_exchange_rate,	narration,				bank_code,				analysis_code,				subanalysis_code,
					cost_center,		item_code,			item_variant,			quantity,				tax_post_flag,				mac_post_flag,
					reftran_fbid,		reftran_no,			reftran_ou,				ref_tran_type,			supcust_code,				uom,
					mac_inc_flag,		createdby,			createddate,			modifiedby,				modifieddate,				
					fin_year_code,		fin_period_code,
					--code added for EBS-4237 starts	 
					fin_year_stdt,		fin_year_enddt,		
					fin_period_stdt,    fin_period_enddt,    financeperiodrange,		
					--code added for EBS-4237 ends	
					updated_flag,		recon_date,				hdrremarks,				mlremarks,					isRepupdated,
					line_no,			item_tcd_type,		consolidated,			source_comp,			project_ou,					Project_code,
					afe_number,			job_number,			Old_batch_id,			defermentamount,		expense_class,				d1,
					d2,						d3,						d4,				d5,						d6,							d7,
					d8,						d9,						d10,			d11,					d12,						d13,
					d14,					d15,				attribute1,			attribute2,				attribute3,					attribute4,
					attribute5,			attribute6,				attribute7,			attribute8,				attribute9,					attribute10,
					attribute11,		attribute12,			attribute13,		attribute14,			attribute15,				account_desc,
					ref_doc_lineno,		hdn_lineno1,			hdn_lineno2			--EBS-1668
					,Account_group --code added for EBS-5810
				)
		select		timestamp,			@guid,				company_code,			component_name,			bu_id,						fb_id,
					tran_ou,			@fb_voucher_no,		@doc_date,				recon_flag,				con_ref_voucherno,			/*@orgtran_no,*/@tran_no, --code modified for EBS-3934
					'FA_RCAPWIP',		@doc_date,			entry_date,				auth_date,				@doc_date,					ou_id,
					account_code,		case when drcr_flag = 'CR' then 'DR'
										else 'CR' end,		currency_code,			tran_amount,			base_amount,				par_base_amount,
					exchange_rate,		par_exchange_rate,	narration,				bank_code,				analysis_code,				subanalysis_code,
					cost_center,		item_code,			item_variant,			quantity,				tax_post_flag,				mac_post_flag,
					reftran_fbid,		reftran_no,			reftran_ou,				ref_tran_type,			supcust_code,				uom,
					mac_inc_flag,		
					--createdby,		createddate,								modifiedby,				modifieddate,	
					@ctxt_user,			dbo.res_getdate(@ctxt_ouinstance),			@ctxt_user,				dbo.res_getdate(@ctxt_ouinstance), --code modified for EBS-3934	
					--code commented & added for EBS-4237 starts
					/*			
					@fin_year_code,
					@fin_period_code,
					*/	
					@fin_year_code,     @fin_period_code,   @fin_year_stdt,			@fin_year_enddt, 
					@fin_period_stdt,   @fin_period_enddt,  @financeperiodrange,
					--code commented & added for EBS-4237 ends	
					updated_flag,		recon_date,			hdrremarks,				mlremarks,				isRepupdated,
					line_no,			item_tcd_type,		consolidated,			source_comp,			project_ou,					Project_code,
					afe_number,			job_number,			Old_batch_id,			defermentamount,		expense_class,				d1,
					d2,					d3,					d4,						d5,						d6,							d7,
					d8,					d9,					d10,					d11,					d12,						d13,
					d14,				d15,				attribute1,				attribute2,				attribute3,					attribute4,
					attribute5,			attribute6,			attribute7,				attribute8,				attribute9,					attribute10,
					attribute11,		attribute12,		attribute13,			attribute14,			attribute15,				account_desc,
					ref_doc_lineno,		hdn_lineno1,		hdn_lineno2		--EBS-1668
					,Account_group --code added for EBS-5810
		from	dim_postings_dtl	(nolock)
		--code commented and added for EBS-3934 starts
		/*
		where	tran_ou		=	@tran_ou
		and		document_no	=	@tran_no
		and		tran_type	=	@tran_type	
		*/
		where	tran_ou		=	@orgtran_ou
		and		document_no	=	@orgtran_no
		and		tran_type	=	'FA_ACAPWIP'
		--code commented and added for EBS-3934 ends 								
		return	
		
	end
	/*Code added for Defect Id:- EBS-1051/EBS-987 ends here*/

	/*Code added for Defect ID:- UWC-267 Starts here*/
	if @ctxt_service in ('acaprvasmsrrvas')
	begin			 
		--code commented for EBS-3179
		/*
		select	@orgtran_no		=	cap_number, 
				@orgtran_ou		=	ou_id,
				@orgtran_type	=   'FA_ACAP'
		from	acap_asset_hdr (nolock)
		where	asset_number	=	@assetnumber
		and		ou_id			=	@tran_ou
		*/
		--code commented for EBS-3179
		select top 1 @fb_voucher_no	=	fb_voucher_no , 
					@guid			=	batch_id ,
					@doc_date		=	posting_date	
					,@tran_fb		=	fb_id --EBS-4237		
		from	fbp_posted_trn_dtl(nolock)
		where	tran_ou				=	@tran_ou--@orgtran_ou				--commented and added for Defect ID:-ALPF-235
		and		document_no			=	@tran_no--@orgtran_no				--ALPF-235
		and		tran_type			=  'FA_RACAP'

		--EBS-4237 starts		
		select	@company_code		=	company_code
		from	emod_ou_vw(nolock)
		where   ou_id				=	@tran_ou
					
		select  @bfg_code 			=	a.bfg_code  
		from 	emod_bfg_comp_vw a(nolock) ,
				emod_trantype_vw b(nolock)
		where 	b.tran_type			=   @tran_type
		and		a.component_id 		=   b.component_id 
		and  	a.language_id 		=   @ctxt_language  
		and		a.language_id		=   b.language_id

		select  @fin_year_code      =	vw.fin_year_code,     
				@fin_period_code   	=	vw.fin_period_code,
				@fin_year_stdt     	=	vw.fin_year_stdt,
				@fin_year_enddt		=	vw.fin_year_enddt,
				@fin_period_stdt   	=	vw.fin_period_stdt,
				@fin_period_enddt   =	vw.fin_period_enddt,
				@financeperiodrange	=	vw.financeperiodrange
		from    fcc_bfg_sysact_allperiod_vw VW (nolock)
		where   VW.bfg_code  		=	@bfg_code  
		and 	VW.fb_id  			=	@tran_fb  
		and		VW.ou_id			=	@tran_ou
		and 	VW.company_code		=	@company_code	
		and     @doc_date	 between	VW.fin_period_stdt	and	VW.fin_period_enddt
		--EBS-4237 ends

		--insertion for reversal document
			insert	into	dim_postings_dtl
					(
						timestamp,			batch_id,			company_code,			component_name,			bu_id,						fb_id,
						tran_ou,			fb_voucher_no,		fb_voucher_date,		recon_flag,				con_ref_voucherno,			
						document_no,		tran_type,			
						tran_date,			entry_date,			auth_date,				posting_date,			ou_id,
						account_code,		drcr_flag,			currency_code,			tran_amount,			base_amount,				par_base_amount,
						exchange_rate,		par_exchange_rate,	narration,				bank_code,				analysis_code,				subanalysis_code,
						cost_center,		item_code,			item_variant,			quantity,				tax_post_flag,				mac_post_flag,
						reftran_fbid,		reftran_no,			reftran_ou,				ref_tran_type,			supcust_code,				uom,
						mac_inc_flag,		createdby,			createddate,			modifiedby,				modifieddate,				
						fin_year_code,
						fin_period_code,	
						--code added for EBS-4237 starts	 
						fin_year_stdt,		fin_year_enddt, 
						fin_period_stdt,    fin_period_enddt,    financeperiodrange,		
						--code added for EBS-4237 ends
						updated_flag,		recon_date,				hdrremarks,				mlremarks,					isRepupdated,
						line_no,			item_tcd_type,		consolidated,			source_comp,			project_ou,					Project_code,
						afe_number,			job_number,			Old_batch_id,			defermentamount,		expense_class,				d1,
						d2,						d3,						d4,				d5,						d6,							d7,
						d8,						d9,						d10,			d11,					d12,						d13,
						d14,					d15,				attribute1,			attribute2,				attribute3,					attribute4,
						attribute5,			attribute6,				attribute7,			attribute8,				attribute9,					attribute10,
						attribute11,		attribute12,			attribute13,		attribute14,			attribute15,				account_desc
						,ref_doc_lineno,	hdn_lineno1,			hdn_lineno2
						,Account_group --code added for EBS-5810			
					)
			select		dim.timestamp,		@guid,				company_code,			component_name,			bu_id,						dim.fb_id,
						@tran_ou,			@fb_voucher_no,		@doc_date,				recon_flag,				con_ref_voucherno,			
						@tran_no,			/*@tran_type*/ 'FA_RACAP',--ALPF-235
						@doc_date,			entry_date,			auth_date,				@doc_date,				dim.ou_id,
						dim.account_code,		case when drcr_flag = 'CR' then 'DR'
											else 'CR' end,		currency_code,			tran_amount,			base_amount,				par_base_amount,
						exchange_rate,		par_exchange_rate,	narration,				bank_code,				analysis_code,				subanalysis_code,
						dim.cost_center,	item_code,			item_variant,			quantity,				tax_post_flag,				mac_post_flag,
						reftran_fbid,		reftran_no,			reftran_ou,				ref_tran_type,			supcust_code,				uom,
						mac_inc_flag,		
						--dim.createdby,	dim.createddate,							dim.modifiedby,			dim.modifieddate,	
						@ctxt_user,			dbo.res_getdate(@ctxt_ouinstance),			@ctxt_user,				dbo.res_getdate(@ctxt_ouinstance), --code modified for EBS-3934				
						--code commented & added for EBS-4237 starts
						/*			
						fin_year_code,
						fin_period_code,
						*/	
						@fin_year_code,    @fin_period_code,   @fin_year_stdt,			@fin_year_enddt, 
						@fin_period_stdt,   @fin_period_enddt,  @financeperiodrange,
						--code commented & added for EBS-4237 ends				
						updated_flag,		recon_date,			hdrremarks,				mlremarks,				isRepupdated,
						line_no,			item_tcd_type,		consolidated,			source_comp,			project_ou,					Project_code,
						afe_number,			job_number,			Old_batch_id,			defermentamount,		expense_class,				d1,
						d2,					d3,					d4,						d5,						d6,							d7,
						d8,					d9,					d10,					d11,					d12,						d13,
						d14,				d15,				attribute1,				attribute2,				attribute3,					attribute4,
						attribute5,			attribute6,			attribute7,				attribute8,				attribute9,					attribute10,
						attribute11,		attribute12,		attribute13,			attribute14,			attribute15,				account_desc
						,ref_doc_lineno,	hdn_lineno1,		hdn_lineno2	
						,Account_group --code added for EBS-5810
			--Code commented and modified for EBS-3179
			/*	
			from	dim_postings_dtl(nolock)			
			where	tran_ou		=	@orgtran_ou
			and		document_no	=	@orgtran_no
			and		tran_type	=	@orgtran_type
			*/
			from	dim_postings_dtl dim(nolock)
				   ,acap_asset_hdr acap(nolock)
			where	asset_number	=	@assetnumber
			and		acap.ou_id		=	@tran_ou
			and		tran_ou			=	acap.ou_id
			and		document_no		=	acap.cap_number
			and		tran_type		=	'FA_ACAP'
			--Code commented and modified for EBS-3179
		return
	end
	/*Code added for Defect ID:- UWC-267 Ends here*/

	if @tran_type = 'FA_ACAPWIP' 
	begin	
	
			insert	into Dim_tran_post_dtl
			(
			 
				tran_no,			tran_ou,			tran_type,			tran_fb,			line_no,
				account_code,		drcr_flag,			tran_amount,		tran_currency,		cost_center,		
				analysis_code,		sub_analysiscode,	base_amount,		base_exchange_rate,	pbase_amount,		
				pbase_exchange_rate,comp_id,			posting_line_no,	Posting_date,		tran_date		--EBS-933	
				,ref_doc_lineno,		hdn_lineno1,		hdn_lineno2			--EBS-1668
				,posting_acctcode,	 posting_fb --code added for EBS-3136		
			)
			select	
				tran_no,			 tran_ou,				act.tran_type,		act.fb_id,			act.line_no,	
				act.account_code,	 drcr_flag,				tran_amount,		currency,			cost_center,	
				act.analysis_code,	 act.sub_analysis_code,	base_amount,		bc_erate,			pbase_amount,
				pbc_erate,			'ACAP',					act.line_no,		posting_date,		posting_date--EBS-933
				,0,					0,						0				--EBS-1668	
				,account_code,		fb_id --code added for EBS-3136				
			from	dim_acap_dtl_vw act(nolock)
			where	act.tran_ou			=	@tran_ou
			and		act.tran_no			=	@tran_no			
			and		act.tran_type		=   @tran_type
	end	

	--EBS-982 starts
	if @tran_type = 'FA_ACAPJV'
	begin		
			insert	into Dim_tran_post_dtl
			(
			 
				tran_no,			 tran_ou,			tran_type,			tran_fb,			line_no,
				account_code,		 drcr_flag,			tran_amount,		tran_currency,		cost_center,--EBS-1720 -uncommented tran_currency	
				analysis_code,		 sub_analysiscode,	base_amount,		base_exchange_rate,	pbase_amount,		
				/*pbase_exchange_rate,*/ comp_id,		posting_line_no,	Posting_date,		tran_date
				, ref_doc_lineno,	 hdn_lineno1,		hdn_lineno2			--EBS-1668		
				,posting_acctcode,	 posting_fb --code added for EBS-3136
			)
			select	
				tran_no,			 tran_ou,			tran_type,			fb_id,			line_no,	
				account_code,		 drcr_flag,			tran_amount,		currency,		cost_center, --EBS-1720 -uncommented currency		
				analysis_code,		 sub_analysis_code,	base_amount,		1,				pbase_amount,
				/*pbc_erate,*/		 'ACAP',			isnull(line_no,0),	posting_date,	posting_date	
				,0,						0,				0				--EBS-1668
				,account_code,		fb_id --code added for EBS-3136		
			from	dim_acap_jv_dtl_vw vw(nolock)
			where	tran_ou			=	@tran_ou
			and		tran_no			=	@tran_no			
			and		tran_type		=   @tran_type

		--EBS-1159 starts
		update a
		set		a.remarks    =  b.remarks
		from	Dim_tran_post_dtl a(nolock),
				acap_journal_dtl  b(nolock)
		where   a.tran_no	   =  @tran_no
		and		a.tran_ou	   =  @tran_ou
		and		b.account_code =  a.account_code
		and     a.tran_no      =  b.voucher_number
		and		b.ou_id		  =  @ctxt_ouinstance     
		--EBS-1159 ends
	end	
	--EBS-982 ends
	declare @dimassettag  fin_flag 

	select @dimassettag			= parameter_code 
	from   ips_processparam_sys
	where  parameter_type		= 'CPSYS'
	and    company_code     = @company_code
	and    parameter_Category   = 'DIMONASSETTAG'		
	and	   language_id		    =  @ctxt_language
	--EBS-1379 starts
	if @tran_type = 'FA_ACAP' 
	begin	
		/* code added for EBS- EBS-1799  starts here*/
		if @dimassettag = 'Y'
		begin	
				insert	into Dim_tran_post_dtl
				(		 
					tran_no,			 tran_ou,			tran_type,			tran_fb,			line_no,
					account_code,		 drcr_flag,			tran_amount,		cost_center,		
					analysis_code,		 sub_analysiscode,	base_amount,		base_exchange_rate,	pbase_amount,		
					comp_id,		     posting_line_no,	Posting_date,		tran_date,	    
					remarks	,			 tran_currency	--EBS-1413	
					, ref_doc_lineno,	 hdn_lineno1,		hdn_lineno2		--EBS-1668
					,item_usage_code,	 item_variant,      account_type --EBS-2129
					,posting_fb,		 posting_acctcode  --EBS-3136
				)
				select	
					tran_no,			 tran_ou,			tran_type,			fb_id,			line_no,	
					account_code,		 drcr_flag,			tran_amount,		cost_center,	
					analysis_code,		 sub_analysis_code,	base_amount,		1,				pbase_amount,
					'ACAP',				 line_no,	        posting_date,	    posting_date,  
					 remarks,			 currency --EBS-1413	
					 ,0,					0,					0				--EBS-1668	
					 ,item_usage_code,	 item_variant,       account_type --EBS-2129	
					 ,fb_id,			 account_code --EBS-3136
				from	dim_acap_asset_vw vw(nolock) 
				where	tran_ou			=	@tran_ou
				and		tran_no			=	@tran_no			
				and		tran_type		=   @tran_type


				insert	into Dim_tran_dtl
				(
					tran_no,			 tran_ou,			tran_type,			tran_fb,			line_no,
					item_usage_code,	 item_variant,	 	tran_amount,		drcr_flag,			cost_center,		
					analysis_code,		 sub_analysiscode,	base_amount,		account_code,					
					tran_currency,		 tran_date	,		ref_doc_lineno,		hdn_lineno1,		hdn_lineno2   				
					--,Posting_date		
				)
				select	
					tran_number,		 ou_id,				tran_type,			fb_id,				tag_number,	
					asset_number	,	 tag_number,		/*tran_amount*/ sum(tran_amount),	    drcr_flag,			cost_center,		--EBS-1849
					analysis_code,		 sub_analysis_code,	/*base_amount */sum(base_amount),		account_code,						--EBS-1849
					currency,			 tran_date,			0,					0,					0	
					--,Posting_date	
				from	acap_accounting_info_dtl act(nolock)				
				where	ou_id			=	@tran_ou
				and		act.tran_number	=	@tran_no			
				and		act.tran_type	=   @tran_type							
				and		account_type	=	'ASSETACCOUNT'
				--EBS-1849
				group by tran_number ,	act.ou_id ,		 act.tran_type  ,    act.fb_id,             act.account_code, 
				drcr_flag,			    act.cost_center, act.analysis_code , act.sub_analysis_code, currency,
				act.asset_number,		tag_number,		tran_date 
			--EBS-1849
		
		
		select  @doc_number	=  	doc_number,
				@asset_no	=	asset_number,
				@tagno		=	tag_number
		from   acap_tag_doc_dtl (nolock) 
		where  cap_number		=   @tran_no
		and	   ou_id			=   @tran_ou

		if  exists (select 'X' 
					from  Dim_user_entry_dtl(nolock)
					where tran_ou		=	@tran_ou
					and	  tran_no		=	@tran_no			
					and	  tran_type		=   @tran_type)			
		begin

			update	dp
			set	dp.d1	=	dim.d1,
				dp.d2	=	dim.d2,
				dp.d3	=	dim.d3,
				dp.d4	=	dim.d4,
				dp.d5	=	dim.d5,
				dp.d6	=	dim.d6,
				dp.d7	=	dim.d7,
				dp.d8	=	dim.d8,
				dp.d9	=	dim.d9,
				dp.d10	=	dim.d10,
				dp.d11	=	dim.d11,
				dp.d12	=	dim.d12,
				dp.d13	=	dim.d13,
				dp.d14	=	dim.d14,
				dp.d15	=	dim.d15
			from	dim_tran_dtl dp(nolock),					
					dim_user_entry_dtl dim(nolock)
			where	dp.tran_ou			=	@tran_ou	
			and		dp.tran_no			=	@tran_no
			and		dp.tran_type		=	@tran_type						
			and		dp.tran_no			=	dim.tran_no
			and		dp.tran_type		=	dim.tran_type
			and		dp.item_usage_code	=	dim.item_usage_code
			and		dp.item_variant		=   dim.item_variant
			and		dp.line_no			=   dim.line_no		--EBS-1849				

			update	dp
			set	dp.d1	=	dim.d1,
				dp.d2	=	dim.d2,
				dp.d3	=	dim.d3,
				dp.d4	=	dim.d4,
				dp.d5	=	dim.d5,
				dp.d6	=	dim.d6,
				dp.d7	=	dim.d7,
				dp.d8	=	dim.d8,
				dp.d9	=	dim.d9,
				dp.d10	=	dim.d10,
				dp.d11	=	dim.d11,
				dp.d12	=	dim.d12,
				dp.d13	=	dim.d13,
				dp.d14	=	dim.d14,
				dp.d15	=	dim.d15
			from	dim_tran_post_dtl dp(nolock),					
					dim_userentry_acc_dtl dim(nolock)
			where	dp.tran_ou			=	@tran_ou	
			and		dp.tran_no			=	@tran_no
			and		dp.tran_type		=	@tran_type
			and		dp.tran_no			=   dim.tran_no			
			and		dp.item_usage_code	=	dim.item_usage_code
			and		dp.item_variant		=   dim.item_variant
			and		dp.account_code		=   dim.account_code
		end	
		else
		begin
			if ((select count('x') from acap_tag_doc_dtl (nolock) where asset_number = @asset_no ) = (select count('X') from acap_asset_tag_dtl where asset_number = @asset_no))	
			begin	
				update	dp
				set	dp.d1	=	dim.d1,
					dp.d2	=	dim.d2,
					dp.d3	=	dim.d3,
					dp.d4	=	dim.d4,
					dp.d5	=	dim.d5,
					dp.d6	=	dim.d6,
					dp.d7	=	dim.d7,
					dp.d8	=	dim.d8,
					dp.d9	=	dim.d9,
					dp.d10	=	dim.d10,
					dp.d11	=	dim.d11,
					dp.d12	=	dim.d12,
					dp.d13	=	dim.d13,
					dp.d14	=	dim.d14,
					dp.d15	=	dim.d15
				from	dim_tran_dtl dp(nolock),
						acap_tag_doc_dtl doc (nolock),
						--dim_tran_dtl dim(nolock),		--EBS-1849
						dim_tran_Post_dtl dim(nolock)--sdin
				where	dp.tran_ou			=	@tran_ou	
				and		dp.tran_no			=	@tran_no
				and		dp.tran_type		=	@tran_type						
				and		dp.tran_no			=	cap_number
				and		dp.item_usage_code	=	doc.asset_number
				and		dp.item_variant		=   doc.tag_number
				--and	dp.line_no			=   dim.line_no		--EBS-1849			
				and		dim.tran_no			=   doc.doc_number
				and		dim.line_no			=   doc.line_no
				and		doc.account_code	=   dim.account_code	 --EBS-1849

				

				update	dp
				set	dp.d1	=	dim.d1,
					dp.d2	=	dim.d2,
					dp.d3	=	dim.d3,
					dp.d4	=	dim.d4,
					dp.d5	=	dim.d5,
					dp.d6	=	dim.d6,
					dp.d7	=	dim.d7,
					dp.d8	=	dim.d8,
					dp.d9	=	dim.d9,
					dp.d10	=	dim.d10,
					dp.d11	=	dim.d11,
					dp.d12	=	dim.d12,
					dp.d13	=	dim.d13,
					dp.d14	=	dim.d14,
					dp.d15	=	dim.d15
				from	dim_tran_post_dtl dp(nolock),					
						dim_tran_dtl dim(nolock)
				where	dp.tran_ou			=	@tran_ou	
				and		dp.tran_no			=	@tran_no
				and		dp.tran_type		=	@tran_type
				and		dp.tran_no			=   dim.tran_no			
				and		dp.item_usage_code	=	dim.item_usage_code
				and		dp.item_variant		=   dim.item_variant	
			

				update	dp
				set	    dp.d1	=	dim.d1,
						dp.d2	=	dim.d2,
						dp.d3	=	dim.d3,
						dp.d4	=	dim.d4,
						dp.d5	=	dim.d5,
						dp.d6	=	dim.d6,
						dp.d7	=	dim.d7,
						dp.d8	=	dim.d8,
						dp.d9	=	dim.d9,
						dp.d10	=	dim.d10,
						dp.d11	=	dim.d11,
						dp.d12	=	dim.d12,
						dp.d13	=	dim.d13,
						dp.d14	=	dim.d14,
						dp.d15	=	dim.d15
				from	dim_user_entry_dtl dp(nolock),
						dim_tran_dtl dim(nolock)
				where	dp.tran_ou			=	@tran_ou	
				and		dp.tran_no			=	@tran_no
				and		dp.tran_type		=	@tran_type
				and		dp.tran_no			=   dim.tran_no			
				and		dp.item_usage_code	=	dim.item_usage_code
				and		dp.item_variant		=   dim.item_variant	

				update	dp
				set	dp.d1	=	dim.d1,
					dp.d2	=	dim.d2,
					dp.d3	=	dim.d3,
					dp.d4	=	dim.d4,
					dp.d5	=	dim.d5,
					dp.d6	=	dim.d6,
					dp.d7	=	dim.d7,
					dp.d8	=	dim.d8,
					dp.d9	=	dim.d9,
					dp.d10	=	dim.d10,
					dp.d11	=	dim.d11,
					dp.d12	=	dim.d12,
					dp.d13	=	dim.d13,
					dp.d14	=	dim.d14,
					dp.d15	=	dim.d15
				from	Dim_userentry_acc_dtl dp(nolock),
						dim_tran_dtl dim(nolock)
				where	dp.tran_ou			=	@tran_ou	
				and		dp.tran_no			=	@tran_no
				and		dp.tran_type		=	@tran_type
				and		dp.tran_no			=   dim.tran_no			
				and		dp.item_usage_code	=	dim.item_usage_code
				and		dp.item_variant		=   dim.item_variant
			end
		 end
	  end 	
	   else
		/* code added for EBS- EBS-1799  ends here*/
		begin
			insert	into Dim_tran_post_dtl
			(
			 
				tran_no,			 tran_ou,			tran_type,			tran_fb,			line_no,
				account_code,		 drcr_flag,			tran_amount,		cost_center,		
				analysis_code,		 sub_analysiscode,	base_amount,		base_exchange_rate,	pbase_amount,		
				comp_id,		     posting_line_no,	Posting_date,		tran_date	,	    
				remarks	,			 tran_currency	--EBS-1413	
				, ref_doc_lineno,		hdn_lineno1,		hdn_lineno2		--EBS-1668
				,account_type--EBS-2129
				,posting_fb,		 posting_acctcode  --EBS-3136
			)
			select	
				tran_no,			 tran_ou,			tran_type,			fb_id,			line_no,	
				account_code,		 drcr_flag,			sum(tran_amount),	cost_center,	
				analysis_code,		 sub_analysis_code,	sum(base_amount),		1,			sum(pbase_amount),
				'ACAP',				 line_no,	        posting_date,	    posting_date,  
				 remarks,			 currency --EBS-1413	
				 ,0,					0,					0				--EBS-1668
				 ,account_type--EBS-2129
				  ,fb_id,			 account_code --EBS-3136
			from	dim_acap_asset_vw vw(nolock) 
			where	tran_ou			=	@tran_ou
			and		tran_no			=	@tran_no			
			and		tran_type		=   @tran_type
			group by tran_no ,	vw.tran_ou ,		 vw.tran_type  , vw.fb_id,vw.account_code,line_no, 
			 drcr_flag,     vw.cost_center, vw.analysis_code , vw.sub_analysis_code, posting_date,currency,vw.remarks,
			 account_type --EBS-2129					 
		end
	end	
	
--EBS-1924
    declare @source_asset   fin_assetnumber,
			@old_capnumber  fin_documentnumber,
			@source_tagno   fin_tagno --EBS-1935
    --@old_capnumber--> Creation of capitalization number without reference document
	if @ctxt_service = 'acapamasmsramas' 
	begin
		if exists ( select 'x' 
					from  acap_tag_doc_dtl(nolock) 
					where cap_number =  @tran_no
					and   ou_id      =  @tran_ou
				  )
		begin
			select  @tran_no = @tran_no
		end
		else
		begin
			select	@source_asset    =  asset_number,
					@source_tagno	 =  tag_number --EBS-1935
			from	acap_asset_Tag_dtl(nolock)
			where   cap_number		 =  @tran_no
			
			select  @old_capnumber   =  cap_number
			from    acap_asset_Tag_dtl(nolock)
			where   asset_number     = @source_asset
			and     cap_number      <> @tran_no			

			--update dim_tran_dtl 
				update	amend
				set		amend.d1	=	old.d1,
						amend.d2	=	old.d2,
						amend.d3	=	old.d3,
						amend.d4	=	old.d4,
						amend.d5	=	old.d5,
						amend.d6	=	old.d6,
						amend.d7	=	old.d7,
						amend.d8	=	old.d8,
						amend.d9	=	old.d9,
						amend.d10	=	old.d10,
						amend.d11	=	old.d11,
						amend.d12	=	old.d12,
						amend.d13	=	old.d13,
						amend.d14	=	old.d14,
						amend.d15	=	old.d15
				from	dim_tran_dtl old(nolock), 						
						dim_tran_dtl amend(nolock)
				where	amend.tran_ou			=	@tran_ou	
				and		amend.tran_no			=	@tran_no
				and		amend.tran_type			=	@tran_type						
				and		old.tran_no				=	@old_capnumber
				and		amend.item_usage_code	=	old.item_usage_code
				and		amend.item_variant		=   old.item_variant

		
			--update dim_tran_post_dtl		
				update	amend
				set		amend.d1	=	old.d1,
						amend.d2	=	old.d2,
						amend.d3	=	old.d3,
						amend.d4	=	old.d4,
						amend.d5	=	old.d5,
						amend.d6	=	old.d6,
						amend.d7	=	old.d7,
						amend.d8	=	old.d8,
						amend.d9	=	old.d9,
						amend.d10	=	old.d10,
						amend.d11	=	old.d11,
						amend.d12	=	old.d12,
						amend.d13	=	old.d13,
						amend.d14	=	old.d14,
						amend.d15	=	old.d15
				from	dim_tran_post_dtl old(nolock),
						dim_tran_post_dtl amend(nolock)
				where	amend.tran_ou			=	@tran_ou	
				and		amend.tran_no			=	@tran_no
				and		amend.tran_type			=	@tran_type						
				and		old.tran_no				=	@old_capnumber
				and		amend.item_usage_code	=	old.item_usage_code
				and		amend.item_variant		=   old.item_variant
				and     amend.account_code		=   old.account_code 

				--EBS-1935
				insert	into Dim_userentry_acc_dtl
					(
						tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
						account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
						analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
						ref_doc_lineno, hdn_lineno1,		hdn_lineno2,		remarks,            base_amount        
						
					)
			   select	
						tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
						account_code,	item_usage_code,    item_variant,		tran_amount,		tran_currency,		cost_center,
						analysis_code,	sub_analysiscode,	account_desc,		comp_id,			drcr_flag,			posting_date,
						0 ,             0,					0,					remarks,			tran_amount       		
			   from  dim_tran_post_dtl a(nolock)
			   where tran_no	     = @tran_no
			   and   tran_ou		 = @tran_ou
			   and   item_usage_code = @source_asset
			   and   item_variant    = @source_tagno


			   insert	into Dim_user_entry_dtl
				  (
					tran_no,				tran_ou,			tran_type,			tran_fb,			line_no,			
					item_usage_code,		item_variant,		drcr_flag,			tran_amount,		tran_currency,
					cost_center,			analysis_code,		sub_analysiscode,	company_code,       base_amount,
					ref_doc_lineno ,		hdn_lineno1 ,		hdn_lineno2
				   )
				select
					tran_no,				tran_ou,			tran_type,			tran_fb,			line_no,			
					item_usage_code,		item_variant,		drcr_flag,			tran_amount,		tran_currency,
					cost_center,			analysis_code,		sub_analysiscode,	company_code,       base_amount,
					0 ,						0,		            0
			   from  dim_tran_dtl b(nolock)
			   where tran_no	     = @tran_no
			   and tran_ou		 = @tran_ou
			   and   item_usage_code = @source_asset
			   and   item_variant    = @source_tagno

			   
			   --Updation of Dim_userentry_acc_dtl
			    update	amend
				set		amend.d1	=	old.d1,
						amend.d2	=	old.d2,
						amend.d3	=	old.d3,
						amend.d4	=	old.d4,
						amend.d5	=	old.d5,
						amend.d6	=	old.d6,
						amend.d7	=	old.d7,
						amend.d8	=	old.d8,
						amend.d9	=	old.d9,
						amend.d10	=	old.d10,
						amend.d11	=	old.d11,
						amend.d12	=	old.d12,
						amend.d13	=	old.d13,
						amend.d14	=	old.d14,
						amend.d15	=	old.d15
				from	Dim_userentry_acc_dtl old(nolock),
						Dim_userentry_acc_dtl amend(nolock)
				where	amend.tran_ou			=	@tran_ou	
				and		amend.tran_no			=	@tran_no
				and		amend.tran_type			=	@tran_type						
				and		old.tran_no				=	@old_capnumber
				and		amend.item_usage_code	=	old.item_usage_code
				and		amend.item_variant		=   old.item_variant
				and     amend.account_code		=   old.account_code


				--Updation of Dim_user_entry_dtl
			    update	amend
				set		amend.d1	=	old.d1,
						amend.d2	=	old.d2,
						amend.d3	=	old.d3,
						amend.d4	=	old.d4,
						amend.d5	=	old.d5,
						amend.d6	=	old.d6,
						amend.d7	=	old.d7,
						amend.d8	=	old.d8,
						amend.d9	=	old.d9,
						amend.d10	=	old.d10,
						amend.d11	=	old.d11,
						amend.d12	=	old.d12,
						amend.d13	=	old.d13,
						amend.d14	=	old.d14,
						amend.d15	=	old.d15
				from	Dim_user_entry_dtl old(nolock),
						Dim_user_entry_dtl amend(nolock)
				where	amend.tran_ou			=	@tran_ou	
				and		amend.tran_no			=	@tran_no
				and		amend.tran_type			=	@tran_type						
				and		old.tran_no				=	@old_capnumber
				and		amend.item_usage_code	=	old.item_usage_code
				and		amend.item_variant		=   old.item_variant
				--EBS-1935

	--select 'test11',@tran_no
	--select d12,d13,d14,* from   Dim_tran_dtl(nolock) where tran_no = @tran_no				
	--select d12,d13,d14,* from   Dim_tran_post_dtl where tran_no = @tran_no


		end
	end
--EBs-1924
    
    --EBS-1928
	if  @tran_type = 'FA_ABITAG'  and @dimassettag = 'Y'
	begin
			declare @src_asset			fin_assetnumber,
					@src_tagno			fin_tagno,
					@acap_capnumber		fin_documentnumber
			select  @src_asset       =  asset_number,
					@src_tagno       =  tag_number
			from    acap_split_asset_hdr (nolock)
			where   document_number  =  @tran_no

			select  @acap_capnumber  =  cap_number
			from    acap_asset_tag_dtl(nolock)
			where   asset_number	 = @src_asset
			and     tag_number       = @src_tagno --EBS-3069
	

			
	        insert	into Dim_tran_dtl
			(
				tran_no,			  tran_ou,				tran_type,			tran_fb,			line_no,
				item_usage_code,	  item_variant,	 		tran_amount,		drcr_flag,			cost_center,		
				analysis_code,		  sub_analysiscode,		base_amount,		account_code,					
				tran_currency,		  tran_date	,			ref_doc_lineno,		hdn_lineno1,		hdn_lineno2   				
			)
			select	
				dtl.document_number,  dtl.ou_id,			'FA_ABITAG',		hdr.fb_id,			 dtl.tag_number,	
				hdr.asset_number,	  dtl.tag_number,	    dtl.tag_cost,	    drcr_flag,		     cost_center,		
				analysis_code,		  sub_analysis_code,	dtl.tag_cost,		account_code,						
				currency,			  hdr.tran_date,		0,					0,				 0	
			from	acap_split_asset_hdr hdr(nolock),
					acap_split_asset_dtl dtl(nolock),
					acap_accounting_info_dtl acc(nolock)			
			where dtl.document_number  = @tran_no
			and   dtl.ou_id            = @tran_ou
			and   hdr.asset_number	   = @src_asset
			and   dtl.depr_book		   = 'CORP'
			and   hdr.document_number  = dtl.document_number
			and   dtl.depr_book        = hdr.depr_book 
			and   acc.tran_number      = dtl.document_number
			and   acc.asset_number     = hdr.asset_number
			and   dtl.tag_number       = acc.tag_number	
			and   acc.account_type     = 'ASSETACCOUNT'	
			and   dtl.tag_number       <> @src_tagno --EBS-2008	


			insert	into Dim_tran_post_dtl
			(
			 
				tran_no,			 tran_ou,				tran_type,			tran_fb,			line_no,
				account_code,		 drcr_flag,				tran_amount,		cost_center,		tran_date	,
				analysis_code,		 sub_analysiscode,		base_amount,        posting_line_no,	Posting_date,			    
				tran_currency,		 item_usage_code,		item_variant,		ref_doc_lineno,	    hdn_lineno1,		hdn_lineno2		
			)
			select	
				dtl.document_number,  dtl.ou_id,			'FA_ABITAG',		hdr.fb_id,			dtl.tag_number,
				account_code,		  drcr_flag,			dtl.tag_cost,		cost_center,		posting_date,
				analysis_code,		  sub_analysis_code,	dtl.tag_cost,	    dtl.tag_number,		posting_date,
				currency,			  hdr.asset_number,	    dtl.tag_number,	    0,					0,				    0	
				from	acap_split_asset_hdr hdr(nolock),
						acap_split_asset_dtl dtl(nolock),
						acap_accounting_info_dtl acc(nolock)			
				where dtl.document_number =  @tran_no
				and   dtl.ou_id           =  @tran_ou
				and   hdr.asset_number	  =  @src_asset
				and   dtl.depr_book		  =  'CORP'
				and   hdr.document_number =  dtl.document_number
				and   dtl.depr_book       =  hdr.depr_book 
				and   acc.tran_number     =  dtl.document_number
				and   acc.asset_number    =  hdr.asset_number
				and   dtl.tag_number      =  acc.tag_number
				and   dtl.tag_number      <> @src_tagno --EBS-2008
	

			update	splittag
			set		splittag.d1		=	acap.d1,
					splittag.d2		=	acap.d2,
					splittag.d3		=	acap.d3,
					splittag.d4		=	acap.d4,
					splittag.d5		=	acap.d5,
					splittag.d6		=	acap.d6,
					splittag.d7		=	acap.d7,
					splittag.d8		=	acap.d8,
					splittag.d9		=	acap.d9,
					splittag.d10	=	acap.d10,
					splittag.d11	=	acap.d11,
					splittag.d12	=	acap.d12,
					splittag.d13	=	acap.d13,
					splittag.d14	=	acap.d14,
					splittag.d15	=	acap.d15
			--from	dim_tran_dtl acap(nolock), --EBS-2141	
			from	dim_tran_dtl splittag(nolock),
					dim_tran_post_dtl acap(nolock) --EBS-2141
			where	splittag.tran_ou			=	@tran_ou	
			and		splittag.tran_no			=	@tran_no
			and		splittag.tran_type			=	@tran_type						
			and		acap.item_usage_code		=	@src_asset
			and     acap.item_variant           =   @src_tagno
			and     acap.item_usage_code		=   splittag.item_usage_code
			and     acap.tran_no                =   @acap_capnumber
			and     acap.account_type			=   'ASSETACCOUNT' --EBS-2141

			
			update	splittag
			set		splittag.d1		=	acap.d1,
					splittag.d2		=	acap.d2,
					splittag.d3		=	acap.d3,
					splittag.d4		=	acap.d4,
					splittag.d5		=	acap.d5,
					splittag.d6		=	acap.d6,
					splittag.d7		=	acap.d7,
					splittag.d8		=	acap.d8,
					splittag.d9		=	acap.d9,
					splittag.d10	=	acap.d10,
					splittag.d11	=	acap.d11,
					splittag.d12	=	acap.d12,
					splittag.d13	=	acap.d13,
					splittag.d14	=	acap.d14,
					splittag.d15	=	acap.d15
			from	dim_tran_post_dtl acap(nolock), 						
					dim_tran_post_dtl splittag(nolock)
			where	splittag.tran_ou			=	@tran_ou	
			and		splittag.tran_no			=	@tran_no
			and		splittag.tran_type			=	@tran_type						
			and		acap.item_usage_code		=	@src_asset
			and     acap.account_code			=   splittag.account_code
			and		splittag.item_usage_code	=	acap.item_usage_code --EBS-2008
			and     acap.item_variant			=   @src_tagno --EBS-2008

				
			insert	into Dim_userentry_acc_dtl
				(
					tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
					account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
					ref_doc_lineno, hdn_lineno1,		hdn_lineno2,		remarks,            base_amount				
				)
			select	
					tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
					account_code,	item_usage_code,    item_variant,		tran_amount,		tran_currency,		cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,			drcr_flag,			posting_date,
					0 ,             0,					0,					remarks,			tran_amount					
			from  dim_tran_post_dtl a(nolock)
			where tran_no	      = @tran_no
			and   tran_ou		  = @tran_ou
			and   item_usage_code = @src_asset


			insert	into Dim_user_entry_dtl
				(
				tran_no,				tran_ou,			tran_type,			tran_fb,			line_no,			
				item_usage_code,		item_variant,		drcr_flag,			tran_amount,		tran_currency,
				cost_center,			analysis_code,		sub_analysiscode,	company_code,       base_amount,
				ref_doc_lineno ,		hdn_lineno1 ,		hdn_lineno2 
				)
			select
				tran_no,				tran_ou,			tran_type,			tran_fb,			line_no,			
				item_usage_code,		item_variant,		drcr_flag,			tran_amount,		tran_currency,
				cost_center,			analysis_code,		sub_analysiscode,	company_code,       base_amount,
				0 ,						0,		            0
			from  dim_tran_dtl (nolock)
			where tran_no	      = @tran_no
			and   tran_ou		  = @tran_ou
			and   item_usage_code = @src_asset
			
			   		   
			--Updation of Dim_userentry_acc_dtl
			update	splittag
			set		splittag.d1		=	acap.d1,
					splittag.d2		=	acap.d2,
					splittag.d3		=	acap.d3,
					splittag.d4		=	acap.d4,
					splittag.d5		=	acap.d5,
					splittag.d6		=	acap.d6,
					splittag.d7		=	acap.d7,
					splittag.d8		=	acap.d8,
					splittag.d9		=	acap.d9,
					splittag.d10	=	acap.d10,
					splittag.d11	=	acap.d11,
					splittag.d12	=	acap.d12,
					splittag.d13	=	acap.d13,
					splittag.d14	=	acap.d14,
					splittag.d15	=	acap.d15
			from	Dim_userentry_acc_dtl acap(nolock),
					Dim_userentry_acc_dtl splittag(nolock)
			where	splittag.tran_ou			=	@tran_ou	
			and		splittag.tran_no			=	@tran_no
			and		splittag.tran_type			=	@tran_type
			and     acap.item_usage_code      	=   @src_asset				
			and		splittag.item_usage_code	=	acap.item_usage_code
			and     splittag.account_code		=   acap.account_code
			and     acap.item_variant			=   @src_tagno --EBS-2008

							
			--Updation of Dim_user_entry_dtl
			update	splittag
			set		splittag.d1		=	acap.d1,
					splittag.d2		=	acap.d2,
					splittag.d3		=	acap.d3,
					splittag.d4		=	acap.d4,
					splittag.d5		=	acap.d5,
					splittag.d6		=	acap.d6,
					splittag.d7		=	acap.d7,
					splittag.d8		=	acap.d8,
					splittag.d9		=	acap.d9,
					splittag.d10	=	acap.d10,
					splittag.d11	=	acap.d11,
					splittag.d12	=	acap.d12,
					splittag.d13	=	acap.d13,
					splittag.d14	=	acap.d14,
					splittag.d15	=	acap.d15
			--from	Dim_user_entry_dtl acap(nolock), --EBS-2141
			from	dim_tran_post_dtl acap(nolock), --EBS-2141
					Dim_user_entry_dtl splittag(nolock)
			where	splittag.tran_ou			=	@tran_ou	
			and		splittag.tran_no			=	@tran_no
			and		splittag.tran_type			=	@tran_type
			and     acap.item_usage_code      	=   @src_asset
			and     acap.item_variant			=   @src_tagno	
			and		splittag.item_usage_code	=	acap.item_usage_code
			and     acap.tran_no                =   @acap_capnumber	
			and     acap.account_type			=   'ASSETACCOUNT' --EBS-2141
	end
	--EBS-1928
     

	--EBS-1869
	--For the SourceAsset assetflag is updating 
	if @ctxt_service = 'acapapaddbsrblkast' 
	begin
		update acap_asset_bulk_tmp
		set   source_assetflag = 'S'
		where ref_assetno      = @tran_no
		and   ou_id            = @tran_ou
		and	  guid             = @guid1
	
		declare @source_assetflag	fin_flag

		select	@source_assetflag = source_assetflag
		from	acap_asset_bulk_tmp (nolock)
		where	ref_assetno		  = @tran_no
		and		ou_id			  = @tran_ou
		and		guid			  = @guid1	
	end
   

	--splited tag amount is updated for the source asset  
	if @source_assetflag = 'S' 
	begin
		if @ctxt_service = 'acapapaddbsrblkast' and @dimassettag = 'Y'
		begin 
		  --EBS-2003 
		  --Updation of tag amount for the existing source asset and tag number
		   if exists (     select 'X'
						   from  dim_tran_dtl(nolock)
						   where item_usage_code = @tran_no
						   and   item_variant    = @tagnumber
						   and   tran_ou         = @tran_ou
					  )
		   --EBS-2003
		   begin
			   update dim
			   set   tran_amount      = asset_cost,
					 base_amount      = asset_cost
			   from  dim_tran_dtl dim(nolock),
					 acap_asset_hdr hdr(nolock) 
			   where asset_number     = @tran_no
			   and   hdr.ou_id        = @tran_ou
			   and   hdr.asset_number = dim.item_usage_code
			   and   hdr.ou_id		  = dim.tran_ou

			   update dp
			   set   tran_amount      = asset_cost,
					 base_amount      = asset_cost
			   from  dim_tran_post_dtl dp(nolock),
					 acap_asset_hdr hdr(nolock)
			   where asset_number     = @tran_no
			   and   hdr.ou_id        = @tran_ou
			   and   hdr.asset_number = dp.item_usage_code
			   and   hdr.ou_id		  = dp.tran_ou

			   update dtl
			   set   tran_amount      = asset_cost,
					 base_amount      = asset_cost
			   from  Dim_user_entry_dtl dtl(nolock),
					 acap_asset_hdr hdr(nolock)
			   where asset_number     = @tran_no
			   and   hdr.ou_id        = @tran_ou
			   and   hdr.asset_number = dtl.item_usage_code
			   and   hdr.ou_id		  = dtl.tran_ou

			   update acc
			   set   tran_amount      = asset_cost,
					 base_amount      = asset_cost
			   from  Dim_userentry_acc_dtl acc(nolock),
					 acap_asset_hdr hdr(nolock)
			   where asset_number     = @tran_no
			   and   hdr.ou_id        = @tran_ou
			   and   hdr.asset_number = acc.item_usage_code
			   and   hdr.ou_id		  = acc.tran_ou
		   end
		   else		   
		   --EBS-2003 
		   --insertion for the splitted asset number and tag number
		   begin
				insert into dim_tran_dtl
				(
					tran_no,				tran_ou,			tran_type,			tran_fb,			line_no,		
					item_usage_code,		item_variant,		drcr_flag,			tran_amount,		tran_currency,
					cost_center,			analysis_code,		sub_analysiscode,	company_code,		account_code,
					account_desc,			createdby,			createddate,		modifiedby,			modifieddate,
					d1,						d2,					d3,					d4,					d5,
					d6,						d7,					d8,					d9,					d10,
					d11,					d12,				d13,				d14,				d15
					, ref_doc_lineno ,		hdn_lineno1 ,		hdn_lineno2,        tran_date,			base_amount   
				   )
				select
					a.cap_number,			tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber ,--EBS-2013			
					a.asset_number,			@tagnumber,			drcr_flag,			tag_cost,			tran_currency,
					b.cost_center,			analysis_code,		sub_analysiscode,	company_code,       account_code,
					account_desc,           b.createdby,		b.createddate,		b.modifiedby,		b.modifieddate,
					d1,						d2,					d3,					d4,					d5,
					d6,						d7,					d8,					d9,					d10,
					d11,					d12,				d13,				d14,				d15,
					0 ,						0,		            0,                  tran_date,          tag_cost
			   from  dim_tran_dtl b(nolock),
					 acap_asset_bulk_tmp a(nolock)					 
			   where a.asset_number	= @tran_no
			   and   a.ou_id		= @tran_ou
			   and   guid			= @guid1		   
			   and   a.ref_assetno	= b.item_usage_code
			   and   a.ou_id		= b.tran_ou
			   and   a.tag_number	= @tagnumber
			   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number

			   
			   insert	into Dim_tran_post_dtl
					(
						tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
						account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
						analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
						remarks,        createdby,			createddate,        modifiedby,         modifieddate,       base_amount,
						d1,				d2,					d3,					d4,					d5,					d6,
						d7,				d8,					d9,					d10,				d11,			    d12,
						d13,			d14,				d15,                ref_doc_lineno,     hdn_lineno1,		hdn_lineno2						
					)
			   select	
						a.cap_number,	tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, posting_line_no,--EBS-2013
						account_code,	a.asset_number,     a.tag_number,		tag_cost,		    tran_currency,		b.cost_center,
						analysis_code,	sub_analysiscode,	account_desc,		comp_id,		    drcr_flag,			posting_date,
						b.remarks,		b.createdby,		b.createddate,      b.modifiedby,		b.modifieddate,	    tag_cost,     -- "b.remarks" Modified by ADECCOUAT-1014
						d1,				d2,					d3,					d4,					d5,				    d6,					
						d7,				d8,					d9,					d10,				d11,			    d12,
						d13,			d14,				d15,                0 ,                 0,		            0 
			   from  Dim_tran_post_dtl b(nolock),
					 acap_asset_bulk_tmp a(nolock)
			   where a.asset_number	= @tran_no
			   and   a.ou_id		= @tran_ou
			   and   guid			= @guid1
			   and   a.ref_assetno	= b.item_usage_code
			   and   a.ou_id		= b.tran_ou
			   and   a.tag_number	= @tagnumber	
			   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number

			   insert	into Dim_user_entry_dtl
				  (
					tran_no,				tran_ou,			tran_type,			tran_fb,			line_no,			
					item_usage_code,		item_variant,		drcr_flag,			tran_amount,		tran_currency,
					cost_center,			analysis_code,		sub_analysiscode,	company_code,       base_amount,
					d1,						d2,					d3,					d4,					d5,
					d6,						d7,					d8,					d9,					d10,
					d11,					d12,				d13,				d14,				d15,
					ref_doc_lineno ,		hdn_lineno1 ,		hdn_lineno2 
				   )
				select
					a.cap_number,			tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber ,--EBS-2013		
					a.asset_number,			a.tag_number,		drcr_flag,			tag_cost,			tran_currency,
					b.cost_center,			analysis_code,		sub_analysiscode,	company_code,		tag_cost,
					d1,						d2,					d3,					d4,					d5,
					d6,						d7,					d8,					d9,					d10,
					d11,					d12,				d13,				d14,				d15,
					0 ,						0,		            0

			   from  Dim_user_entry_dtl b(nolock),
					 acap_asset_bulk_tmp a(nolock)
			   where a.asset_number	= @tran_no
			   and   a.ou_id		= @tran_ou
			   and   guid			= @guid1
			   and   a.ref_assetno	= b.item_usage_code
			   and   a.ou_id		= b.tran_ou
			   and   a.tag_number	= @tagnumber
			 and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number


			   insert	into Dim_userentry_acc_dtl
					(
						tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
						account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
						analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
						ref_doc_lineno, hdn_lineno1,		hdn_lineno2,		remarks,            base_amount,
						d1,				d2,					d3,					d4,					d5,					d6,
						d7,				d8,					d9,					d10,				d11,			    d12,
						d13,			d14,				d15					
					)
			   select	
						a.cap_number,	tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, posting_line_no, --EBS-2013
						account_code,	a.asset_number,     a.tag_number,		tag_cost,			tran_currency,		b.cost_center,
						analysis_code,	sub_analysiscode,	account_desc,		comp_id,			drcr_flag,			posting_date,
						0 ,   0,					0,					b.remarks,			tag_cost,                  -- "b.remarks" Modified by ADECCOUAT-1014
						d1,				d2,					d3,					d4,					d5,				    d6,					
						d7,				d8,					d9,					d10,				d11,			    d12,
						d13,			d14,				d15   
			   from  Dim_userentry_acc_dtl b(nolock),
					 acap_asset_bulk_tmp a(nolock)
			   where a.asset_number	= @tran_no
			   and   a.ou_id		= @tran_ou
			   and   guid			= @guid1
			   and   a.ref_assetno	= b.item_usage_code
			   and   a.ou_id		= b.tran_ou
			   and   a.tag_number	= @tagnumber
			   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number	
		   end	
		   --EBS-2003
	   end
	   else
	   if @ctxt_service = 'acapapaddbsrblkast' and @dimassettag = 'N'
	   begin
	      --EBS-2003 
		  --Updation of tag amount for the existing source asset and tag number
		   if exists (Select 'X'
		              from  dim_tran_post_dtl(nolock)
					  where item_usage_code = @tran_no
					  and   item_variant    = @tagnumber
					  and   tran_ou         = @tran_ou
					  )
		   --EBS-2003
		   begin
			   update dp
			   set   tran_amount      = asset_cost,
					 base_amount      = asset_cost
			   from  dim_tran_post_dtl dp(nolock),
					 acap_asset_hdr hdr(nolock)
			   where asset_number     = @tran_no
			   and   hdr.ou_id		  = @tran_ou
			   and   hdr.asset_number = dp.item_usage_code
			   and   hdr.ou_id		  = dp.tran_ou

			   update acc
			   set   tran_amount      = asset_cost,
					 base_amount      = asset_cost
			   from  Dim_userentry_acc_dtl acc(nolock),
					 acap_asset_hdr hdr(nolock)
			   where asset_number     = @tran_no
			   and   hdr.ou_id        = @tran_ou
			   and   hdr.asset_number = acc.item_usage_code
			   and   hdr.ou_id		  = acc.tran_ou
		   end
		   else
		   --EBS-2003
		   --insertion for the splitted tag number from the source asset
		   if not exists ( Select 'X'
						   from  dim_tran_post_dtl(nolock)
						   where item_usage_code = @tran_no
						   and   item_variant    = @tagnumber
						   and  tran_ou         = @tran_ou
						  )
		   begin
				 insert	into Dim_tran_post_dtl
						(
							tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
							account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
							analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
							remarks,        createdby,			createddate,		modifiedby,         modifieddate,       base_amount,
							d1,				d2,					d3,					d4,					d5,					d6,
							d7,				d8,					d9,					d10,				d11,			    d12,
							d13,			d14,				d15,				ref_doc_lineno,     hdn_lineno1,		hdn_lineno2
							
						)
				   select	
							a.cap_number,	tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, posting_line_no, --EBS-2013
							account_code,	a.asset_number,     a.tag_number,		tag_cost,		    tran_currency,		b.cost_center,
							analysis_code,	sub_analysiscode,	account_desc,		comp_id,		    drcr_flag,			posting_date,
							b.remarks,		b.createdby,		b.createddate,      b.modifiedby,       b.modifieddate,	    tag_cost,     -- "b.remarks" Modified by ADECCOUAT-1014
							d1,				d2,					d3,					d4,					d5,				    d6,					
							d7,				d8,					d9,					d10,				d11,			    d12,
							d13,			d14,				d15,                0 ,					0,		            0 
				   from  Dim_tran_post_dtl b(nolock),
						 acap_asset_bulk_tmp a(nolock)
				   where a.asset_number	= @tran_no
				   and   a.ou_id		= @tran_ou
				   and   guid			= @guid1
				   and   a.ref_assetno	= b.item_usage_code
				   and   a.ou_id		= b.tran_ou
				   and   a.tag_number	= @tagnumber
				   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number	


				   insert	into Dim_userentry_acc_dtl
						(
							tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
							account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
							analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
							ref_doc_lineno, hdn_lineno1,		hdn_lineno2,		remarks,            base_amount,
							d1,				d2,					d3,					d4,					d5,					d6,
							d7,				d8,					d9,					d10,				d11,			    d12,
							d13,			d14,				d15
							
						)
				   select	
							a.cap_number,	tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, posting_line_no, --EBS-2013
							account_code,	a.asset_number,     a.tag_number,		tag_cost,			tran_currency,		b.cost_center,
							analysis_code,	sub_analysiscode,	account_desc,		comp_id,			drcr_flag,			posting_date,
							0 ,             0,					0,					b.remarks,			tag_cost,            -- "b.remarks" Modified by ADECCOUAT-1014
							d1,				d2,					d3,					d4,					d5,				    d6,					
							d7,				d8,					d9,					d10,				d11,			    d12,
							d13,			d14,				d15   
				   from  Dim_userentry_acc_dtl b(nolock),
						 acap_asset_bulk_tmp a(nolock)
				   where a.asset_number = @tran_no
				   and   a.ou_id        = @tran_ou
				   and   guid           = @guid1
				   and   a.ref_assetno  = b.item_usage_code
				   and   a.ou_id        = b.tran_ou
				   and   a.tag_number   = @tagnumber
				   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number
		   end
		   --EBS-2003
	   end
    end
	else
	if isnull(@source_assetflag,'') = ''
	begin
		if @ctxt_service = 'acapapaddbsrblkast' and @dimassettag = 'Y'
		begin
		    insert into dim_tran_dtl
			(
				tran_no,				tran_ou,			tran_type,			tran_fb,			line_no,			
				item_usage_code,		item_variant,		drcr_flag,			tran_amount,		tran_currency,
				cost_center,			analysis_code,		sub_analysiscode,	company_code,		account_code,
				account_desc,			createdby,			createddate,		modifiedby,			modifieddate,
				d1,						d2,					d3,					d4,					d5,
				d6,						d7,					d8,					d9,					d10,
				d11,					d12,				d13,				d14,				d15
				, ref_doc_lineno ,		hdn_lineno1 ,		hdn_lineno2,        tran_date,			base_amount   
			   )
			select
				a.cap_number,			tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, --EBS-2013			
				a.asset_number,			a.tag_number,		drcr_flag,			tag_cost,			tran_currency,
				b.cost_center,			analysis_code,		sub_analysiscode,	company_code,       account_code,
				account_desc,			b.createdby,		b.createddate,		b.modifiedby,		b.modifieddate,
				d1,						d2,					d3,					d4,					d5,
				d6,						d7,					d8,					d9,					d10,
				d11,					d12,				d13,				d14,				d15,
				0 ,						0,		            0,                  tran_date,          tag_cost
		   from  dim_tran_dtl b(nolock),		  
				 acap_asset_bulk_tmp a(nolock)
		   where a.asset_number	= @tran_no
		   and   a.ou_id		= @tran_ou
		   and   guid			= @guid1
		   and   a.ref_assetno	= b.item_usage_code
		   and   a.ou_id		= b.tran_ou
		   and   a.tag_number	= @tagnumber	--EBS-2003
		   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number
	 
		   insert	into Dim_tran_post_dtl
				(
					tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
					account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
					remarks,        createdby,			createddate,        modifiedby,         modifieddate,       base_amount,
					d1,				d2,					d3,					d4,					d5,					d6,
					d7,				d8,					d9,					d10,				d11,			    d12,
					d13,			d14,				d15,                ref_doc_lineno,     hdn_lineno1,		hdn_lineno2						
				)
			select	
					a.cap_number,	tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, posting_line_no, --EBS-2013
					account_code,	a.asset_number,     a.tag_number,		tag_cost,		    tran_currency,		b.cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,		    drcr_flag,			posting_date,
					b.remarks,		b.createdby,		b.createddate,      b.modifiedby,       b.modifieddate,	  tag_cost,    -- "b.remarks" Modified by ADECCOUAT-1014
					d1,				d2,					d3,					d4,					d5,				    d6,					
					d7,				d8,					d9,					d10,				d11,			    d12,
					d13,			d14,				d15,                0 ,                 0,		            0 
		   from  Dim_tran_post_dtl b(nolock),
				 acap_asset_bulk_tmp a(nolock)
		   where a.asset_number	= @tran_no
		   and   a.ou_id		= @tran_ou
		   and   guid			= @guid1
		   and   a.ref_assetno	= b.item_usage_code
		   and   a.ou_id		= b.tran_ou
		   and   a.tag_number	= @tagnumber	--EBS-2003
		   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number


		   insert	into Dim_user_entry_dtl
			  (
				tran_no,				tran_ou,			tran_type,			tran_fb,			line_no,			
				item_usage_code,		item_variant,		drcr_flag,			tran_amount,		tran_currency,
				cost_center,			analysis_code,		sub_analysiscode,	company_code,       base_amount,
				d1,						d2,					d3,					d4,					d5,
				d6,						d7,					d8,					d9,					d10,
				d11,					d12,				d13,				d14,				d15,
				ref_doc_lineno ,		hdn_lineno1 ,		hdn_lineno2 
			   )
			select
				a.cap_number,			tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, --EBS-2013			
				a.asset_number,			a.tag_number,		drcr_flag,			tag_cost,			tran_currency,
				b.cost_center,			analysis_code,		sub_analysiscode,	company_code,       tag_cost,
				d1,						d2,					d3,					d4,					d5,
				d6,						d7,					d8,					d9,					d10,
				d11,					d12,				d13,				d14,				d15,
				0 ,						0,		            0

		   from  Dim_user_entry_dtl b(nolock),
				 acap_asset_bulk_tmp a(nolock)
		   where a.asset_number	= @tran_no
		   and   a.ou_id		= @tran_ou
		   and   guid			= @guid1
		   and   a.ref_assetno	= b.item_usage_code
		   and   a.ou_id		= b.tran_ou
		   and   a.tag_number	= @tagnumber	--EBS-2003
		   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number


		   insert	into Dim_userentry_acc_dtl
				(
					tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
					account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
					ref_doc_lineno, hdn_lineno1,		hdn_lineno2,		remarks,            base_amount,
					d1,				d2,					d3,					d4,					d5,					d6,
					d7,				d8,					d9,					d10,				d11,			    d12,
					d13,			d14,				d15
							
				)
		   select	
					a.cap_number,	tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, posting_line_no, --EBS-2013
					account_code,	a.asset_number,     a.tag_number,		tag_cost,			tran_currency,		b.cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,			drcr_flag,			posting_date,
					0 ,             0,					0,					b.remarks,			tag_cost,                             -- "b.remarks" Modified by ADECCOUAT-1014
					d1,				d2,					d3,					d4,					d5,				    d6,					
					d7,				d8,					d9,					d10,				d11,			    d12,
					d13,			d14,				d15   
		   from  Dim_userentry_acc_dtl b(nolock),
				 acap_asset_bulk_tmp a(nolock)
		   where a.asset_number	= @tran_no
		   and   a.ou_id		= @tran_ou
		   and   guid			= @guid1
		   and   a.ref_assetno	= b.item_usage_code
		   and   a.ou_id		= b.tran_ou
		   and   a.tag_number	= @tagnumber	--EBS-2003	
		   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number
		end
		else
		begin
		   insert	into Dim_tran_post_dtl
				(
					tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
					account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
					remarks,        createdby,			createddate,        modifiedby,         modifieddate,       base_amount,
					d1,				d2,					d3,					d4,					d5,					d6,
					d7,				d8,					d9,					d10,				d11,			    d12,
					d13,			d14,				d15,                ref_doc_lineno,     hdn_lineno1,		hdn_lineno2							
				)
		   select	
					a.cap_number,	tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, posting_line_no, --EBS-2013
					account_code,	a.asset_number,     a.tag_number,		tag_cost,			tran_currency,		b.cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,		    drcr_flag,			posting_date,
					b.remarks,		b.createdby,		b.createddate,      b.modifiedby,       b.modifieddate,	    tag_cost,    -- "b.remarks" Modified by ADECCOUAT-1014
					d1,				d2,					d3,					d4,				    d5,				    d6,					
					d7,				d8,					d9,					d10,				d11,			    d12,
					d13,			d14,				d15,                0 ,      0,		   0 
		   from  Dim_tran_post_dtl b(nolock),
				 acap_asset_bulk_tmp a(nolock)
		   where a.asset_number	= @tran_no
		   and   a.ou_id		= @tran_ou
		   and   guid			= @guid1
		   and   a.ref_assetno	= b.item_usage_code
		   and   a.ou_id		= b.tran_ou
		   and   a.tag_number	= @tagnumber	--EBS-2003
		   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number 

		   insert	into Dim_userentry_acc_dtl
				(
					tran_no,		tran_ou,			tran_type,			tran_fb,			line_no,			posting_line_no,
					account_code,	item_usage_code,	item_variant,		tran_amount,		tran_currency,		cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,	        drcr_flag,			posting_date,		
					ref_doc_lineno, hdn_lineno1,		hdn_lineno2,		remarks,            base_amount,
					d1,				d2,					d3,					d4,					d5,					d6,
					d7,				d8,					d9,					d10,				d11,			    d12,
					d13,			d14,				d15			
				)
		   select	
					a.cap_number,	tran_ou,			tran_type,			tran_fb,			/*line_no,*/@tagnumber, posting_line_no, --EBS-2013
					account_code,	a.asset_number,     a.tag_number,		tag_cost,			tran_currency,		b.cost_center,
					analysis_code,	sub_analysiscode,	account_desc,		comp_id,		    drcr_flag,			posting_date,
					0 ,             0,					0,					b.remarks,			tag_cost,                                -- "b.remarks" Modified by ADECCOUAT-1014
					d1,				d2,					d3,					d4,					d5,				    d6,					
					d7,				d8,					d9,					d10,				d11,			    d12,
					d13,			d14,				d15   
		   from  Dim_userentry_acc_dtl b(nolock),
				 acap_asset_bulk_tmp a(nolock)
		   where a.asset_number	= @tran_no
		   and   a.ou_id		= @tran_ou
		   and   guid			= @guid1
		   and   a.ref_assetno	= b.item_usage_code
		   and   a.ou_id		= b.tran_ou
		   and   a.tag_number	= @tagnumber --EBS-2003
		   and   b.item_variant	= '1' --EBS-2013 --inserting from the source asset and source tag number
		end
	end
	--EBS-1869	 

	--EBS-1379 ends
	update a
	set		a.account_desc	=	ml_account_desc
	from	Dim_tran_post_dtl a(nolock),  
			as_ml_opaccount_dtl b(nolock)  
	where	a.tran_no		=	@tran_no
	and		a.tran_ou		=	@tran_ou
	and		b.account_code	=	a.account_code
	and		b.language_id	=	@ctxt_language
	and		opcoa_id		=   @opcoa_id  

/* Code added for Padma Starts here */
	update a
	set		a.account_desc	=	ml_account_desc
	from	Dim_tran_dtl a(nolock),  
			as_ml_opaccount_dtl b(nolock)  
	where	a.tran_no		=	@tran_no
	and		a.tran_ou		=	@tran_ou
	and		b.account_code	=	a.account_code
	and		b.language_id	=	@ctxt_language
	and		opcoa_id		= @opcoa_id 
/* Code added for Padma ends here */

	if exists	(select	'x' from	dim_maintain_dtls ap(nolock)
				where	company_code	in	(@company_code,'##')					
				) 
	begin 
		if exists	(select	'x' from	fbp_posted_trn_dtl ap(nolock)
					where	document_no		=	@tran_no
					and		tran_ou			=	@tran_ou
					and		tran_type		=	@tran_type		
					)
		begin
				select	@fbp_calling_mode	=	'Y'
			
				select	top 1 @guid	=	batch_id
				from	fbp_posted_trn_dtl ap(nolock)
				where	document_no		=	@tran_no
				and		tran_ou			=	@tran_ou
				and		tran_type		=	@tran_type	
		end

		exec	dim_dynamic_query_sp
				@tran_no,
				@tran_ou,
				@tran_type,
				null,
				@ctxt_user,
				@guid,
				@company_code,
				@fbp_calling_mode,
				@ctxt_language	

				
		

		--EBS-3069		
		if exists( select 'X'
				   from  ainq_accounting_info_dtl(nolock)
				   where tran_number   = @tran_no
				   and   depr_book     = 'TAX'
				  )	
		begin
		
			exec	dim_tax_dynamic_query_sp
				@tran_no,
				@tran_ou,
				@tran_type,
				null,
				@ctxt_user,
				@guid,
				@company_code,
				@fbp_calling_mode,
				@ctxt_language
		end
		--EBS-3069	
	end

		
	Set nocount off
end



