/*$File_version=ms4.3.0.04$*/
/******************************************************************************/
/* procedure					: abr_cmn_snp_sursp      				      */
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
/*Anusha.p                   09/02/2018              epe-5031                 */
/*Aditya S					 18/06/2020				 PTP-970				  */
/*Abhijith KP				 26/09/2023				 EPE-68785				  */
/******************************************************************************/
CREATE procedure abr_cmn_snp_sursp
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
	@refno_tmp          fin_documentno,
	@m_errorid			fin_int output
)
as
begin 
	set nocount on

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


	if @fprowno = -915
		select @fprowno = null

	select @jvnarration = ltrim(rtrim(@jvnarration)) 
	if @jvnarration = '~#~'
		select @jvnarration = null

		Declare @recon_date fin_date,
		        @sysdt_tmp  fin_date,
				@compcode_tmp fin_companycode

		select @sysdt_tmp = convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120)

		--Get the company code.
	select	@compcode_tmp 	= company_code
	from	emod_ou_vw (nolock)
	where	ou_id		= @ctxt_ouinstance
	and	@sysdt_tmp between effective_from 
		and isnull(effective_to, @sysdt_tmp)

	if exists ( Select 'X'
	            from  abr_bsbb_tmp (nolock) 
				where guid  = @guid
				and  mode_flag in ('X','Y','Z')
				and  tran_type in ('ID','SC')
				and  flag     = 'S'
			 )
	begin
	 exec   abr_snp_autogen  @bankaccountnumber	, @ctxt_language	, @ctxt_ouinstance,	     @ctxt_service	,	
							 @ctxt_user			, @enddate	,   	  @guid		,		     @hidden_control1	,
							 @jvnarration	,  	  @raisebnkchg	,	  @startdate	,		 @statementno1	,	
							 @fprowno		,	  @raiserpt    ,  
							 @m_errorid output
							 
		IF @m_errorid <> 0 --EPE-68785
		RETURN
							 
	    update	abr_bsbb_tmp
		set	status  = 'R'
		where	guid	= @guid
		and	flag	= 'S'
		and  tran_type in ('ID','SC')
		and	mode_flag in ('X','Y','Z')	
	
		select @recon_date = max(tran_date) 
		from abr_bsbb_tmp (nolock)
		where guid = @guid
		and  status = 'R'
		and  tran_type in ('ID','SC')
		and	mode_flag in ('X','Y','Z')

	update     DTL
           set  DTL.ref_no      = @refno_tmp,
                DTL.recon_status     = 'R',
                DTL.recon_by         = @ctxt_user,
                DTL.recon_date      = @recon_date,
                DTL.modifiedby       = @ctxt_user,
                DTL.modifieddate     = @sysdt_tmp,
                DTL.taggroup         = TMP.taggroup
           from abr_bank_statement_dtl     DTL (nolock),
                abr_bsbb_tmp         TMP (nolock)
           where guid       = @guid    
           and  company_code    = @compcode_tmp
           and  bank_acc_no     = @bankaccountnumber
           and  DTL.stmt_no     = TMP.stmt_no
           and DTL.serial_no   = TMP.serial_no
           and  DTL.tran_type   = TMP.tran_type
           and  TMP.flag   = 'S'
           and  TMP.status = 'R'
		   and  tmp.tran_type in ('ID','SC')

    update	HDR
	set		HDR.no_of_rec_trans 	= HDR.no_of_rec_trans + DER.no_of_rec_trans,
	        hdr.recon_remarks	= @jvnarration	-- EPE-5031
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
			--and	DTL.taggroup		= TMP.taggroup				  --PTP-970		
			and	isnull(DTL.taggroup,'')		= isnull(TMP.taggroup,'') --PTP-970
			and	DTL.serial_no		= TMP.serial_no
			and	DTL.recon_status	= 'R'
			group by DTL.stmt_no
		)DER
	where	HDR.company_code	= @compcode_tmp
	and		HDR.bank_acc_no		= @bankaccountnumber
	and		HDR.stmt_no			= DER.stmt_no


	update	HDR
	set	    HDR.recon_status	= 'R',
	        hdr.recon_remarks		= @jvnarration	-- EPE-5031
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
	and	HDR.bank_acc_no			= @bankaccountnumber
	and	HDR.stmt_no				= DER.stmt_no
	and	HDR.no_of_trans			= isnull(DER.no_of_rec_trans,0)


	delete  from    abr_bsbb_tmp 
	where guid    = @guid
	and  mode_flag in ('X','Y','Z')
	and  tran_type in ('ID','SC')
	and  flag     = 'S'

	end

	if exists ( Select 'X'
	            from  abr_bsbb_tmp (nolock) 
				where guid  = @guid
				and  mode_flag in ('X','Y','Z')
				and  tran_type = 'IC'
				and  flag     = 'S'
			 )
    begin
	    exec abr_sur_autogen @bankaccountnumber	, @ctxt_language	, @ctxt_ouinstance,	     @ctxt_service	,	
							 @ctxt_user			, @enddate	,   	  @guid		,		     @hidden_control1	,
							 @jvnarration	,  	  @raisebnkchg	,	  @startdate	,		 @statementno1	,	
							 @fprowno		,	  @raiserpt    ,       
							 @m_errorid OUTPUT

		IF @m_errorid <> 0 --EPE-68785
		RETURN

		 update	abr_bsbb_tmp
		set	status  = 'R'
		where	guid	= @guid
		and	flag	= 'S'
		and  tran_type = 'IC'
		and	mode_flag in ('X','Y','Z')	
	
		select @recon_date = max(tran_date) 
		from abr_bsbb_tmp (nolock)
		where guid = @guid
		and  status = 'R'
		and  tran_type = 'IC'
		and	mode_flag in ('X','Y','Z')

	update     DTL
           set  DTL.ref_no      = @refno_tmp,
                DTL.recon_status     = 'R',
                DTL.recon_by         = @ctxt_user,
                DTL.recon_date       = @recon_date,
                DTL.modifiedby       = @ctxt_user,
                DTL.modifieddate     = @sysdt_tmp,
                DTL.taggroup         = TMP.taggroup
           from abr_bank_statement_dtl     DTL (nolock),
                abr_bsbb_tmp         TMP (nolock)
 where guid       = @guid    
           and  company_code    = @compcode_tmp
           and  bank_acc_no     = @bankaccountnumber
           and  DTL.stmt_no     = TMP.stmt_no
       and DTL.serial_no   = TMP.serial_no
           and  DTL.tran_type   = TMP.tran_type
           and  TMP.flag   = 'S'
        and  TMP.status = 'R'
		   and  tmp.tran_type = 'IC'

	update	HDR
	set		HDR.no_of_rec_trans 	= HDR.no_of_rec_trans + DER.no_of_rec_trans,
	        hdr.recon_remarks		= @jvnarration	-- EPE-5031
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
			--and	DTL.taggroup		= TMP.taggroup				  --PTP-970		
			and	isnull(DTL.taggroup,'')		= isnull(TMP.taggroup,'') --PTP-970
			and	DTL.serial_no		= TMP.serial_no
			and	DTL.recon_status	= 'R'
			group by DTL.stmt_no
		)DER
	where	HDR.company_code	= @compcode_tmp
	and		HDR.bank_acc_no		= @bankaccountnumber
	and		HDR.stmt_no			= DER.stmt_no

	update	HDR
	set	    HDR.recon_status	= 'R',
	        hdr.recon_remarks		= @jvnarration	-- EPE-5031
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
	and	HDR.bank_acc_no			= @bankaccountnumber
	and	HDR.stmt_no				= DER.stmt_no
	and	HDR.no_of_trans			= isnull(DER.no_of_rec_trans,0)

	delete from  abr_bsbb_tmp 
	where guid  = @guid
	and  mode_flag in ('X','Y','Z')
	and  tran_type = 'IC'
	and  flag     = 'S'

	end
	
	set nocount off
end




