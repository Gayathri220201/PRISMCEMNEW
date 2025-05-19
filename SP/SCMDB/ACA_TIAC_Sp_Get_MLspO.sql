/*$File_version=ms4.3.0.06$													  */
/******************************************************************************/
/* Procedure					: ACA_TIAC_Sp_Get_MLspO						  */
/* Description					: 											  */
/******************************************************************************/
/* Project						: 											  */
/* EcrNo						: 											  */
/* Version						: MS4.3.0.00								  */
/******************************************************************************/
/* Referenced					: 											  */
/* Tables						: 											  */
/******************************************************************************/
/* Development history			: 12H124_ACAP_00001							  */
/******************************************************************************/
/* Author						: T.AnandhaMurugan							  */
/* Date							: Sep 11 2012  5:25PM						  */
/******************************************************************************/
/* Modification History			: 											  */
/******************************************************************************/
/* Modified By					: 								              */
/* Date							: 											  */
/* Description					: 											  */
/* T.AnandhaMurugan			14/09/2012		12H124_ACAP_00001:12H124_ACAP_00050*/
/* T.AnandhaMurugan			14/09/2012		12H124_ACAP_00001:12H124_ACAP_00072*/
/* T.AnandhaMurugan			17/09/2012		12H124_ACAP_00001:12H124_ACAP_00065*/
/* T.AnandhaMurugan			17/09/2012		12H124_ACAP_00001:12H124_ACAP_00068,12H124_ACAP_00070*/
/* T.AnandhaMurugan			18/09/2012		12H124_ACAP_00001:12H124_ACAP_00081*/
/* T.AnandhaMurugan			18/09/2012		12H124_ACAP_00001:12H124_ACAP_00083*/
/*C.Ramesh Kumar			08/11/2014		ES_ACAP_00676					   */	
/*Indira G					21/09/2018		EBS-1882						  */
/*Mabel Rita.L				20/01/2020		PTP-537						      */
/* Abimathi M				06/01/2021						EPE-25078  */
/*Abimathi.M				13/04/2020						EPE-32065:EPE-32905	*/
/*Srinivasan M              24/01/2024        TC-2440*/
/******************************************************************************/
Create Procedure ACA_TIAC_Sp_Get_MLspO
	@ctxt_ouinstance       	fin_ctxt_ouinstance, --Input 
	@ctxt_user             	fin_ctxt_user, --Input 
	@ctxt_language         	fin_ctxt_language, --Input 
	@ctxt_service           fin_ctxt_service, --Input 
	@documentdatefrom      	fin_date, --Input 
	@documentdateto        	fin_date, --Input 
	@documentnofrom        	fin_documentno, --Input 
	@documentnoto          	fin_documentno, --Input 
	@documenttype          	fin_documenttype, --Input 
	@financebook           	fin_financebookid, --Input 
	@guid                  	fin_guid, --Input 
	@proposalno            	fin_documentno, --Input 
	@suppliercode          	fin_suppliercode, --Input
	@projectcode       		fin_desc255, --EPE-32065 
	@m_errorid             	fin_int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Select @m_errorid = 0

	--declaration of temporary variables
	declare	@comp_code	  fin_companycode,
			@All_tmp1	  fin_param_text,
			@doctype_tmp  fin_documenttype,
			@loid_tmp	  fin_loid,
			@today		  fin_date,
			@exec_flag	  fin_flag,
			@error_msg    fin_desc255,
			@properr_tmp  fin_int,
			@assetclass   fin_assetclass,
			@doc_amount   fin_amount,
			@companycode  fin_companycode,
			@destou		  fin_ouinstid
	--temporary and formal parameters mapping

	Select @ctxt_user              = ltrim(rtrim(@ctxt_user))
	Select @ctxt_service           = ltrim(rtrim(@ctxt_service))
	Select @documentnofrom         = ltrim(rtrim(@documentnofrom))
	Select @documentnoto           = ltrim(rtrim(@documentnoto))
	Select @documenttype           = ltrim(rtrim(@documenttype))
	Select @financebook            = ltrim(rtrim(@financebook))
	Select @guid                   = ltrim(rtrim(@guid))
	Select @proposalno             = ltrim(rtrim(@proposalno))
	Select @suppliercode           = ltrim(rtrim(@suppliercode))
	Select @projectcode        = ltrim(rtrim(@projectcode))

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @documentdatefrom = '01/01/1900' or @documentdatefrom  = ''
		Select @documentdatefrom = null  

	IF @documentdateto = '01/01/1900' or @documentdateto = ''
		Select @documentdateto = null  

	IF @documentnofrom = '~#~' 
		Select @documentnofrom = null  

	IF @documentnoto = '~#~' or @documentnoto =''
		Select @documentnoto = null  

	IF @documenttype = '~#~' 
		Select @documenttype = null  

	IF @financebook = '~#~' 
		Select @financebook = null  

	IF @guid = '~#~' 
		Select @guid = null  

	IF @proposalno = '~#~'  or @proposalno = ''
		Select @proposalno = null  

	IF @suppliercode = '~#~' or @suppliercode = ''
		Select @suppliercode = null  
	
	--EPE-32065
	if @Projectcode = '~#~'   or isnull(@Projectcode,'') = ''
          select @Projectcode = '%'
      else
		  select @Projectcode = @Projectcode + '%' 
	--EPE-32065

	if @documentdateto is  null
		select @documentdateto = convert(datetime,convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),101),101)	
	else
		select @documentdateto = convert(datetime,convert(nvarchar(10),@documentdateto,101),101)	
	
	
	if @documentdatefrom is null
		select @documentdatefrom = convert(datetime,convert(nvarchar(10),'1900-01-01',101),101)	
	else
		select  @documentdatefrom = convert(datetime,convert(nvarchar(10),@documentdatefrom,101),101)	
	
	select	@today = dbo.RES_Getdate(@ctxt_ouinstance)
	select	@today = convert(datetime,convert(nvarchar(12),@today))
	
	select	@loid_tmp 		= lo_id,
			@companycode	= company_code 
	from	emod_lo_bu_ou_vw (nolock)
	where	ou_id 			=  @ctxt_ouinstance
	and	    @today 		between effective_from and isnull(effective_to,@today)	
	
		
	if @suppliercode is not null	
	begin
		--existence check
		exec	sup_sp_existactstat_chk 	@ctxt_language ,@ctxt_ouinstance,
				@ctxt_service ,@ctxt_user ,'ACAP', @loid_tmp , @suppliercode ,
				@exec_flag output , @error_msg output , @properr_tmp output
	
		if @properr_tmp = 2460378
		begin 
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,30
			return
		end
		else if @properr_tmp = 2460380
		begin 
			--entered supplier code does not exist
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,32
			return
		end
		else
		begin
			if @properr_tmp = 2460381
			begin 
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,33
				return
			end
		end	
	end

	SELECT	@All_tmp1			= parameter_text
	FROM	fin_quick_code_met (NOLOCK)
	WHERE	component_id		= 'ACAP'
	AND		parameter_type		= 'CBO'
	AND		parameter_category	= 'COMMON'
	AND		parameter_code		= 'A' 
	AND		language_id			= @ctxt_language	
	
	select	@doctype_tmp 			=	parameter_code
	from	fin_quick_code_met (nolock)
	where	component_id			=	'ACAP'
	and		parameter_type			=	'CBO'
	and		parameter_category		=	'DOC_TYP'
	and		parameter_text			=	@documenttype
	and		language_id				=	@ctxt_language
	
	if (@documenttype = @All_tmp1)
	begin
		select	@doctype_tmp = '%'
	end
	
	/*Code Added for the DTS ID: 12H124_ACAP_00001:12H124_ACAP_00065 Starts here*/	
	
	select @destou			= dest_ouid
	from   aplan_acq_proposal_vw(nolock)
	where  company_code		= @companycode
	and	   fb_id			= @financebook
	and    proposal_number	= @proposalno
	
	/*Code Added for the DTS ID: 12H124_ACAP_00001:12H124_ACAP_00065 Ends here*/	
	
	exec aplan_sys_fetchclass /*@ctxt_ouinstance ,*/@destou,@ctxt_language,@ctxt_user,@ctxt_service,
		 @proposalno ,@assetclass output
		

/*	if  @doctype_tmp <> 'IBE' -- Code added by Uma for the bug id : ES_Amig_00001
	begin */
			exec	acap_get_doc_cap
				@ctxt_language,
				@ctxt_ouinstance,		   
				@ctxt_service,		   
				@ctxt_user, 	 	   
				@documenttype,
				@documentdatefrom,		   
				@documentdateto, 		  
				@documentnofrom,	   
				@documentnoto,		   
				@financebook, 			   
				@guid,			  
				@proposalno,		   
				@suppliercode,
				--'%',--ES_ACAP_00676
				@Projectcode, --EPE-32065 		   
				@m_errorid output	
	
			 
		if ( select count('x') 
			 from acap_doc_dtl_tmp(nolock)
			 where guid = @guid) = 0
		begin
			--No Document Found for the Given Search Criteria.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2508
			return	
		end
	/*Code Commented for the DTS ID: 12H124_ACAP_00001:12H124_ACAP_00068 Starts here*/	
/*	end

	if @doctype_tmp = 'IBE'
	begin		

		select 	@comp_code 	= company_code
		from	emod_ou_vw (nolock)
		where	ou_id 		= @ctxt_ouinstance

		if exists (select 'x' 
				   from acap_doc_dtl_tmp (nolock)
				   where guid = @guid )
		begin
				delete from acap_doc_dtl_tmp where guid = @guid
		end

		insert into acap_doc_dtl_tmp (guid, cap_flag,cap_amount , doc_amount ,tran_date , doc_number , ou_id , fb_id , 
									  line_no,doc_type ,pending_cap_amount, supplier_name_desc , account_code)
		select @GUID, 
				'CI' , 
				sum(case when drcr_flag = 'DR' then base_amount else -base_amount end ) ,
				sum(case when drcr_flag = 'DR' then base_amount else -base_amount end ),
				posting_date  ,
				fb_voucher_no, 
				@ctxt_ouinstance , 
				fbp.fb_id , 
				1,
				@doctype_tmp,
				sum(case when drcr_flag = 'DR' then base_amount else -base_amount end ) , 
				ltrim(rtrim(asset_class)) ,
				FBP.account_code
		from 	fbp_posted_trn_Dtl FBP (nolock)  , 
				ard_asset_account_mst ARD (nolock)
		where 	fbp.fb_id 			= @financebook
		and 	tran_type 			= 'BK_FBPJV'
		and		fbp.account_code 	= ard.account_code
		and		asset_usage			= 'CWIP'
		and		fbp.fb_id			= ard.fb_id
		and		ARD.company_code	= FBP.company_code
		and		FBP.company_code	= @comp_code
		group by posting_Date , fb_voucher_no, fbp.fb_id , asset_class , FBP.account_code
	
		update	TMP
		set	TMP.pending_cap_amount	= pending_cap_amount - isnull(wip_amt,0),
			TMP.cap_amount			= cap_amount - isnull(wip_amt,0)
		from	acap_doc_dtl_tmp TMP , (
						select 	sum(base_amount) 'wip_amt' , ACC.account_code  , asset_class
						from 	acap_wip_accounting_dtl ACC(nolock) , 
								acap_wip_dtl			DTL(nolock) , 
								acap_doc_dtl_tmp		TMP (nolock) ,
								acap_wip_hdr			HDR(nolock)	
						where 	guid				= @guid
						and		DTL.doc_number		= ACC.doc_number
						and		DTL.ou_id			= ACC.ou_id
						and		ACC.company_code	= @comp_code
						and		ACC.fb_id  			= @financebook
						and 	ACC.account_code 	= TMP.account_code
						and		TMP.fb_id			= ACC.fb_id
						and		drcr_flag			= 'CR'
						and 	DTL.doc_type 		= 'IBE'
						and		supplier_name_desc	= asset_class
						and		TMP.doc_type		= DTL.doc_type
						and		HDR.cap_wo_number	= DTL.cap_wo_number
						and		HDR.ou_id			= DTL.ou_id
						and		hdr.doc_number		= acc.tran_number 
						and		HDR.wip_status		NOT IN('DE','IA')
						group by ACC.account_code , asset_class
						) WIP
		where	guid			= @guid
		and	WIP.account_code 	= TMP.account_code
	
		if (select count('x') 
			from acap_doc_dtl_tmp(nolock)
			where guid = @guid) = 0
		begin
			--No Document Found for the Given Search Criteria.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2508
			return	
		end
	
	end
	
	if @doctype_tmp <> 'IBE' 
	begin*/
	/*Code Commented for the DTS ID: 12H124_ACAP_00001:12H124_ACAP_00068 Ends here*/
		update	A
		set		A.supplier_name_desc	= S.supp_spmn_supname	
		from	acap_doc_dtl_tmp A(nolock), 
				supp_spmn_suplmain S (nolock)
		Where	S.supp_spmn_supcode	= A.supplier_code	
		And		S.supp_spmn_loid	= @loid_tmp 
		
--	end 
	
	insert into acap_wip_line_tmp(guid,ou_id,line_no,doc_number,timestamp,cap_wo_number,doc_type,line_desc,doc_amount,pen_cap_amount,asset_class,
								  wip_cost,cap_amount,proposal_number,doc_date,supplier_name,lineitem_amount,createdby,createddate,modifiedby,modifieddate,										  account_code,currency,exchange_rate,tran_type,cap_flag)		
	select 
				@guid,ou_id,line_no,doc_number,a.timestamp,'',doc_type,'',	isnull(total_docamt,0), isnull(pending_cap_amount,0),/*asset_class_code*/b.asset_class_code, --PTP-537
				0,isnull(cap_amount,0),a.proposal_number,tran_date,supplier_code,isnull(doc_amount,0),createdby,createddate,
				modifiedby,modifieddate,account_code,tran_currency,a.exchange_rate,null,cap_flag
	from 	acap_doc_dtl_tmp a(nolock), --left outer join
			aplan_acq_proposal_vw b (nolock)	
	where	guid				= @guid				
	and		company_code		= @companycode
	and		a.proposal_number	= b.proposal_number
	and		b.proposal_status	= 'AC'	
--	and		b.currency_code		= a.tran_currency  ----12H124_ACAP_00001:12H124_ACAP_00076
	and		dest_ouid			= ou_id
	----and		a.doc_type	not in ('PM_PV','PM_SCA','PM_SCI')--12h124_ACAP_00083
	and		a.doc_type	not in ('PM_PV','PM_SCI')--code commented and modified for EPE-25078
	and     a.fb_id				= b.fb_id --12H124_ACAP_00001:12H124_ACAP_00050	
	and		a.fb_id				= @financebook  
	and	isnull(supplier_name_desc,'')	= case 	when 	@doctype_tmp = 'IBE' then @suppliercode
										  else isnull(supplier_name_desc,'') end
	
	Select
				(isnull(doc_amount,0)) 				'docamount', 
				convert(nvarchar(10),doc_date,120)	'docdate', 
				doc_number							'docno', 
				dbo.getOuName(ou_id)				'docou', 
				f.parameter_text					'doctype', 
				lineitem_amount						'lineamount', 
				a.line_no							'lineno', 
			--	sum(isnull(pen_cap_amount,0))		'pendingcapitalization',  --12H124_ACAP_00001:12H124_ACAP_00072
				isnull(pen_cap_amount,0)			'pendingcapitalization',  
				null								'revcwodescml', 
				null								'revcwonoml', 
				null								'revdocno', 
				asset_class							'sourceassetclass', 
				proposal_number						'sourceproposalno', 
				supplier_name						'suppliername', 
				isnull(pen_cap_amount,0)			'transferamount'  --12H124_ACAP_00001:12H124_ACAP_00071
		from 	acap_wip_line_tmp  a(nolock),
				fin_quick_code_met f(nolock),
				si_line_detail_vw  c (nolock)
		where	guid					= @guid
		and 	a.pen_cap_amount		<> 0
		and  	doc_type 		in  ('SNP' ,'PM_SPV')
		and		f.component_id			= 'ACAP'
		and		f.parameter_type		= 'CBO'
		and		f.parameter_category	= 'DOC_TYP'
		and		f.parameter_code		= a.doc_type
		and		f.language_id			= @ctxt_language
		and     a.line_no				= c.line_no
		and		a.doc_number			= c.tran_no
		and		a.ou_id					= c.tran_ou	
		
union
		select 	distinct		
			(isnull(doc_amount,0)) 				'docamount', 
			convert(nvarchar(10),doc_date,120)	'docdate', 
			doc_number							'docno', 
			dbo.getOuName(ou_id)				'docou', 
			f.parameter_text					'doctype', 
			lineitem_amount						'lineamount', 
			w.line_no							'lineno', 
		--	sum(isnull(pen_cap_amount,0))		'pendingcapitalization',  --12H124_ACAP_00001:12H124_ACAP_00072
			isnull(pen_cap_amount,0)			'pendingcapitalization', 
			null								'revcwodescml', 
			null								'revcwonoml', 
			null								'revdocno', 
			asset_class							'sourceassetclass', 
			proposal_number						'sourceproposalno', 
			w.supplier_name						'suppliername', 
			isnull(pen_cap_amount,0)			'transferamount' 	 --12H124_ACAP_00001:12H124_ACAP_00071
		from 	acap_wip_line_tmp w (nolock) ,
				supp_address_vw s (nolock),
				fin_quick_code_met f(nolock),
				si_line_detail_vw c(nolock)
		where	guid				= @guid
		and 	f.component_id 		= 'ACAP'
		and		f.parameter_type	= 'CBO'
		and		f.parameter_category	= 'DOC_TYP'
		and  	doc_type not 		in  ('SNP' ,'PM_SPV','CO')--EPE-32065:EPE-32905
		and		f.parameter_code	= doc_type
		and		f.language_id		= @ctxt_language
		and 	s.supplier_code		= w.supplier_name
		and		w.ou_id				= c.tran_ou
		and		w.doc_number		= c.tran_no
		and		w.line_no			= c.line_no
		and 	w.pen_cap_amount		<> 0 --12H124_ACAP_00001:12H124_ACAP_00070
		
 union
		select 	distinct		
			(isnull(doc_amount,0)) 				'docamount', 
			convert(nvarchar(10),doc_date,120)	'docdate', 
			doc_number							'docno', 
			dbo.getOuName(ou_id)				'docou', 
			f.parameter_text					'doctype', 
			lineitem_amount						'lineamount', 
			w.line_no							'lineno', 
		--	sum(isnull(pen_cap_amount,0))		'pendingcapitalization',  --12H124_ACAP_00001:12H124_ACAP_00072
			isnull(pen_cap_amount,0)			'pendingcapitalization', 
			null								'revcwodescml', 
			null								'revcwonoml', 
			null								'revdocno', 
			asset_class							'sourceassetclass', 
			proposal_number						'sourceproposalno', 
			w.supplier_name						'suppliername', 
			isnull(pen_cap_amount,0)			'transferamount' 			--12H124_ACAP_00001:12H124_ACAP_00071
		from 	acap_wip_line_tmp w (nolock) ,
				fin_quick_code_met f(nolock)
		where	guid 					= @guid
		--and 	doc_type				= 'INV_IMIS' 
		and 	doc_type				in('INV_IMIS' ,'PUR_GR','CO','BK_JV') --EBS-1882--EPE-32065:EPE-32905--'BK_JV' tran_type added by TC-2440
		and 	f.component_id 			= 'ACAP'
		and		f.parameter_type		= 'CBO'
		and		f.parameter_category	= 'DOC_TYP'
		and		f.parameter_code		= doc_type
		and		f.language_id			= @ctxt_language
		and 	w.pen_cap_amount		<> 0 --12H124_ACAP_00001:12H124_ACAP_00070			
	--	order by 6
		order by 2,5,3,7 --12H124_ACAP_00001:12H124_ACAP_00081
		

	if exists ( select 'x'
				from  acap_wip_line_tmp (nolock)
				where guid   = @guid
			  )
	begin
			delete from acap_wip_line_tmp
			where guid = @guid
	end		  	

	/* 
	--OutputList
		Select
		null 'docamount', 
		null 'docdate', 
		null 'docno', 
		null 'docou', 
		null 'doctype', 
		null 'lineamount', 
		null 'lineno', 
		null 'pendingcapitalization', 
		null 'revcwodescml', 
		null 'revcwonoml', 
		null 'revdocno', 
		null 'sourceassetclass', 
		null 'sourceproposalno', 
		null 'suppliername', 
		null 'transferamount', 
	*/
	
Set nocount off

End















