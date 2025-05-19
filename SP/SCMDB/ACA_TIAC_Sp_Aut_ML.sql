/*$File_version=MS4.3.0.03$*/
/*$File Name : ACA_TIAC_Sp_Aut_ML.sql*/
/******************************************************************************/
/* Procedure					: ACA_TIAC_Sp_Aut_ML						  */
/* Description					: 								 			  */
/******************************************************************************/
/* Project						: PMC-FA-48 [ MSEnh_FIN_FN_CWIPTransfer]	  */
/* EcrNo						: 								 			  */
/* Defectid						: 12H124_ACAP_00001[ES_General_00632]		  */
/* Version						: MS4.3.0.00								  */
/******************************************************************************/
/* Referenced					: 										 	  */
/* Tables						: 											  */
/******************************************************************************/
/* Development history			: 											  */
/******************************************************************************/
/* Author						: Esther J							 		  */
/* Date							: Sept 07 2012							      */
/******************************************************************************/
/* Modification History			: 								 			  */
/******************************************************************************/
/* Modified By					: 											  */
/* Date							: 											  */
/* Description					: 								 			  */
/*Amani.P				10-03-2021				--EPE-31320					*/
/* Aditya S				19/04/2021				TCTC-376					*/
/* Abimathi M			22/04/2021				EPE-32065					*/
/* Abimathi M			30/04/2021				EPE-33075					*/
/*Srinivasan M          24/01/2024              TC-2440*/
/******************************************************************************/

Create Procedure ACA_TIAC_Sp_Aut_ML
	@ctxt_ouinstance       	fin_ctxt_ouinstance, --Input 
	@ctxt_user             	fin_ctxt_user, --Input 
	@ctxt_language         	fin_ctxt_language, --Input 
	@ctxt_service           fin_ctxt_service, --Input 
	@docamount             	fin_amount, --Input 
	@docdate               	fin_date, --Input 
	@docno                  fin_documentno, --Input 
	@docou                 	fin_ouinstname, --Input 
	@doctype               	fin_documenttype, --Input 
	@guid                  	fin_guid, --Input 
	@lineamount            	fin_amount, --Input 
	@lineno                	fin_lineno, --Input 
	@modeflag              	fin_modeflag, --Input 
	@pendingcapitalization 	fin_amount, --Input 
	@revcwodescml          	fin_desc255, --Input 
	@revcwonoml            	fin_documentno, --Input 
	@revdocno              	fin_documentno, --Input 
	@sourceassetclass      	fin_assetclass, --Input 
	@sourceproposalno      	fin_documentno, --Input 
	@suppliername          	fin_name, --Input 
	@transferamount        	fin_amount, --Input 
	@transferbatchno       	fin_documentno, --Input 
	@transferdate          	fin_date, --Input 
	@targed_fprowno        	fin_fprowno, --Input/Output
	@_ml_fprowno           	fin_fprowno, --Input/Output
	@m_errorid             	fin_int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Select @m_errorid = 0

	--declaration of temporary variables

	declare @doctype_tmp    fin_paramcode,
			@docou_tmp		fin_ouinstid
		
		declare @trancurrency fin_currency
		declare @exchangerate fin_rate
	--temporary and formal parameters mapping

	Select @ctxt_user              = ltrim(rtrim(@ctxt_user))
	Select @ctxt_service           = ltrim(rtrim(@ctxt_service))
	Select @docno                  = ltrim(rtrim(@docno))
	Select @docou                  = ltrim(rtrim(@docou))
	Select @doctype                = ltrim(rtrim(@doctype))
	Select @guid                   = ltrim(rtrim(@guid))
	Select @modeflag               = ltrim(rtrim(@modeflag))
	Select @revcwodescml           = ltrim(rtrim(@revcwodescml))
	Select @revcwonoml             = ltrim(rtrim(@revcwonoml))
	Select @revdocno               = ltrim(rtrim(@revdocno))
	Select @sourceassetclass       = ltrim(rtrim(@sourceassetclass))
	Select @sourceproposalno       = ltrim(rtrim(@sourceproposalno))
	Select @suppliername           = ltrim(rtrim(@suppliername))
	Select @transferbatchno        = ltrim(rtrim(@transferbatchno))

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @docamount = -915
		Select @docamount = null  

	IF @docdate = '01/01/1900' 
		Select @docdate = null  

	IF @docno = '~#~' 
		Select @docno = null  

	IF @docou = '~#~' 
		Select @docou = null  

	IF @doctype = '~#~' 
		Select @doctype = null  

	IF @guid = '~#~' 
		Select @guid = null  

	IF @lineamount = -915
		Select @lineamount = null  

	IF @lineno = -915
		Select @lineno = null  

	IF @modeflag = '~#~' 
		Select @modeflag = null  

	IF @pendingcapitalization = -915
		Select @pendingcapitalization = null  

	IF @revcwodescml = '~#~' 
		Select @revcwodescml = null  

	IF @revcwonoml = '~#~' 
		Select @revcwonoml = null  

	IF @revdocno = '~#~' 
		Select @revdocno = null  

	IF @sourceassetclass = '~#~' 
		Select @sourceassetclass = null  

	IF @sourceproposalno = '~#~' 
		Select @sourceproposalno = null  

	IF @suppliername = '~#~' 
		Select @suppliername = null  

	IF @transferamount = -915
		Select @transferamount = null  

	IF @transferbatchno = '~#~' 
		Select @transferbatchno = null  

	IF @transferdate = '01/01/1900' 
		Select @transferdate = null  

	IF @targed_fprowno = -915
		Select @targed_fprowno = null  

	IF @_ml_fprowno = -915
		Select @_ml_fprowno = null  

	select @_ml_fprowno = @_ml_fprowno + 1
		
	--if @modeflag	in('Y','Z','X')
	if @modeflag	<> 'D'
	begin
		
		--CWIPTRF_048	Reversal Capital Work order no null check	If Reversal Capital Work Order no is null then display error message.		Enter Reversal Capital Work Order No. at row no.<%%> in Source Document Information
 		if @revcwonoml is null
		begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2007,@_ml_fprowno
			return
		end
		
		--CWIPTRF_049	Reversal Capital work order uniqueness check -1	"Within the Transfer Batch, the Reversal Capital work order No. can repeat for a source asset class / proposal no. combination. 
		--Reversal Capital work order No.  already exists in the database, then display error message."		Reversal Capital work order  at row no.<%%> in Source Document Information already exists
	   if exists(	select	'1'
    			from	acap_wip_hdr (nolock)
    			where	ou_id				= @ctxt_ouinstance
    			and		cap_wo_number		= @revcwonoml) 
		begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2009,@_ml_fprowno
			return		
		end
		
		--CWIPTRF_051	Reversal Capital Work Order Description null check	If Reversal Capital work order description is Blank then display error message.		Enter Reversal Capital Work Order Description at row no.<%%> in Source Document Information
 		if @revcwodescml is null
		begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2008,@_ml_fprowno
			return
		end
			    
		--CWIPTRF_052	Transfer Amount Check -1	For the selected row/s in the source document information multiline check if the Transfer Amount is < = the Pending Capitalization value, else display error message.		Transfer Amount cannot be greater than Pending Capitalization value at row No.<%%>
 		if @transferamount > @pendingcapitalization
		begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2010,@_ml_fprowno
			return
		end
		
		--CWIPTRF_053	Transfer Amount Check -2	For the selected row/s in the source document information multiline if the Transfer Amount is < = 0 then display error message.		Transfer Amount should be greater than Zero at row No.<%%>
 		if isnull(@transferamount,0) < = 0
		begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2011,@_ml_fprowno
			return
		end
 
		select	@doctype_tmp		= parameter_code
		from	fin_quick_code_met(nolock)
		where	component_id		= 'ACAP'
		and	parameter_type			= 'CBO'
		and	parameter_category		= 'DOC_TYP'
		and	language_id				= @ctxt_language
		and	parameter_text			= @doctype

		--TCTC-376
		select @docou_tmp = ou_id
		from emod_ou_vw (nolock)
		where ouinstname = @docou
		--TCTC-376

		-----EPE-31320
		--EPE-32065 starts
		if @doctype_tmp  = 'CO'
		begin
			select	@trancurrency	= currency,
					@exchangerate	= isnull(exchange_rate,1)--EPE-33075
			from  acap_wip_line_dtl(NOLOCK)
			where cap_wo_number	= @docno
			and   ou_id			= @docou_tmp
			and   cap_line_no   = @lineno
		end
		--EPE-32065 end
		else if @doctype_tmp  in('PM_EV'	,'PM_IV')
		begin
			select	@trancurrency	= tran_currency,
					@exchangerate	= exchange_rate
			from  sdin_invoice_hdr(NOLOCK)
			where tran_no	= @docno
			and  tran_ou	= @docou_tmp

		end
		else if @doctype_tmp ='PM_SPV'
		begin
			select	@trancurrency	= pay_currency,
					@exchangerate	= exchange_rate
			from  snp_voucher_hdr(NOLOCK)
			where voucher_no	= @docno
			--and  ou_id	= @ctxt_ouinstance 
			and  ou_id		= @docou_tmp --EPE-33075

		end
		else if @doctype_tmp in( 'PM_PI','PM_MI')
		begin
			select	@trancurrency	= tran_currency,
					@exchangerate	= exchange_rate
			from    sin_invoice_hdr(NOLOCK)
			where   tran_no	= @docno
			and		tran_ou	= @docou_tmp
		end
		else if @doctype_tmp in( 'PM_SCA','PM_SCI')
		begin
			select	@trancurrency	= tran_currency,
					@exchangerate	= exchange_rate
			from    scdn_dcnote_hdr(NOLOCK)
			where   tran_no	= @docno
			and		tran_ou	= @docou_tmp
		end
		----EPE-31320
		--code starts by TC-2440
		else if @doctype_tmp in( 'BK_JV')
		begin
			select	@trancurrency	= tran_currency,
					@exchangerate	= exchange_rate
			from    jv_voucher_trn_dtl(NOLOCK)
			where   voucher_no	= @docno
			and		ou_id	= @docou_tmp
			and     voucher_serial_no=@lineno
		end
		
		--code end by TC-2440
				
	 if @ctxt_user='proposeddebug'
		 begin
		 select 'cwip',@exchangerate,@trancurrency,@docno,@docou_tmp
			
		 end

		 --TCTC-376
		 /*
		select @docou_tmp = ou_id
		from emod_ou_vw (nolock)
		where ouinstname = @docou
		*/
		--TCTC-376
		
		insert into  acap_cwiptransfer_src_tmp
		(guid,ou_id,transfer_no,doc_ou,doc_no,doc_type,line_no,
		doc_date,supp_name,asset_class,proposal_no,doc_amt,doc_lineamt,
		pendcap_amt,transfer_amt,revcwip_no,revcwip_desc,revdoc_no,rowno,
		flag,apptrf_amt,tran_erate,tran_currency)----EPE-31320
		values 
		(@guid, @ctxt_ouinstance,null, @docou_tmp,@docno,@doctype_tmp,@lineno,
		@docdate,@suppliername,@sourceassetclass,@sourceproposalno,@docamount,@lineamount,
		@pendingcapitalization,@transferamount,@revcwonoml,@revcwodescml,null,@_ml_fprowno,
		'Y',@transferamount,@exchangerate,@trancurrency)----EPE-31320
	end
	
	--OutputList
	Select
		@targed_fprowno			 'TARGED_FPROWNO', 
		@_ml_fprowno 			 '_ML_FPROWNO'
	
	
Set nocount off

End












