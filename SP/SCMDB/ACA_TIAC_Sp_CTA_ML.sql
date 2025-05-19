/*$File_version=MS4.3.0.01$*/
/******************************************************************************/
/* Procedure					: ACA_TIAC_Sp_CTA_ML			 */
/* Description					: 								 */
/******************************************************************************/
/* Project						: 								 */
/* EcrNo						: 								 */
/* Version						: MS4.3.0.00					 */
/******************************************************************************/
/* Referenced					: 								 */
/* Tables						: 								 */
/******************************************************************************/
/* Development history			: 12H124_ACAP_00001				 */
/******************************************************************************/
/* Author						: T.AnandhaMurugan				 */
/* Date							: Sep 12 2012  2:24PM			 */
/******************************************************************************/
/* Modification History			: 								 */
/******************************************************************************/
/*C.Ramesh Kumar			20.09.2012			12H124_ACAP_00001:12H124_ACAP_00084*/
/*T.AnandhaMurugan			27.09.2012			12H124_ACAP_00001:12H124_ACAP_00094*/
/*Srinivasan M              06/01/2023          TRRS-2324*/
/******************************************************************************/
Create Procedure ACA_TIAC_Sp_CTA_ML
	@ctxt_ouinstance       	fin_ctxt_ouinstance, --Input 
	@ctxt_user             	fin_ctxt_user, --Input 
	@ctxt_language         	fin_ctxt_language, --Input 
	@ctxt_service          	fin_ctxt_service, --Input 
	@docamount             	fin_amount, --Input 
	@docdate               	fin_date, --Input 
	@docno                 	fin_documentno, --Input 
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
	@fprowno               	fin_fprowno, --Input/Output
	@m_errorid             	fin_int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Select @m_errorid = 0

	--declaration of temporary variables
	declare @ou_id  fin_ouinstid

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

	IF @fprowno = -915
		Select @fprowno = null  
		
	select @ou_id 		= ou_id			
	from   emod_ou_vw(nolock)
	where  ouinstname   = @docou
	
	
	 /*TRRS-2324 code starts here*/
    if @modeflag = 'D'
	  begin
		select 	@fprowno 'fprowno'
		return
	  end
	/*TRRS-2324 code ends here*/
		
	if @modeflag in ('X','Y','Z')
	begin
	
		if @transferamount > @pendingcapitalization 
		begin 
				--Transfer Amount cannot be greater than Pending Capitalization value at row No.<%%>
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2010,@fprowno
				return
		end
		
		if isnull(@transferamount,0) < = 0--12H124_ACAP_00084
		begin 
				--Transfer Amount should be greater than Zero at row No.<%%>
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2011,@fprowno
				return
		end
	
		insert into acap_cwiptransfer_src_tmp	(guid,ou_id,doc_ou,doc_no,doc_type,line_no,doc_date,supp_name,asset_class,proposal_no,doc_amt,doc_lineamt,
												 pendcap_amt,transfer_amt,revcwip_no,revcwip_desc,revdoc_no,rowno) 
		values(@guid,@ctxt_ouinstance,@ou_id,@docno,@doctype,@lineno,@docdate,@suppliername,@sourceassetclass,@sourceproposalno,@docamount,@lineamount,
			   @pendingcapitalization,@transferamount,@revcwonoml,@revcwodescml,@revdocno,@fprowno)
	end
			 
	/*Code Commented for the DTS ID: 12H124_ACAP_00001:12H124_ACAP_00094 starts here*/
	/*if 	@fprowno = 1
	begin
	
			if not exists(	select 	'X'
   							from   	acap_cwiptransfer_src_tmp
   							where	guid 		= @guid
   							and		line_no 	= @fprowno)
			begin
				update acap_cwiptransfer_src_tmp
				set    line_no	 = @fprowno
				where  line_no	 = @lineno
				and    guid		 = @guid
			end	
	end	*/
	/*Code Commented for the DTS ID: 12H124_ACAP_00001:12H124_ACAP_00094 Ends here*/
		
	select 	@fprowno = @fprowno + 1	

	Select	@fprowno 'fprowno'

	/* 
	--OutputList
		Select
		null 'fprowno', 
	*/
	
Set nocount off

End









