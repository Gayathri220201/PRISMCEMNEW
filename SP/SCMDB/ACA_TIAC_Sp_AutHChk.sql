/*$File_version=MS4.3.0.07$	*/
/*$File Name : ACA_TIAC_Sp_AutHChk.sql*/        
/******************************************************************************/
/* Procedure					: ACA_TIAC_Sp_AutHChk						  */
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
/*Esther J				17/09/2012			12H124_ACAP_00001:12H124_ACAP_00042[ES_General_00632]				*/
/*Esther J				18/09/2012			12H124_ACAP_00001:12H124_ACAP_00052 */
/*Esther J				18/09/2012			12H124_ACAP_00001:12H124_ACAP_00085 */
/*Esther J				20/09/2012			12H124_ACAP_00001:12H124_ACAP_00086 */
/*Esther J				24/09/2012			12H124_ACAP_00001:12H124_ACAP_00087 */
/*Esther J				24/09/2012			12H124_ACAP_00001:12H124_ACAP_00092 */
/*Esther J				27/09/2012			12H124_ACAP_00001:12H124_ACAP_00092 */
/*Divyalekaa			20/07/2020			EPE-19372							*/
/*Amani.P				07/08/2020			EPE-20269:23229:EPE-23279:--epe-23265	*/
/*Sai Kumar             17/01/2023          MSIE-656                          */
/*Srinivasan M          04/10/2023          MCHS-749*/
/*Srinivasan M          30/01/2024          TC-2440*/
/******************************************************************************/

Create Procedure ACA_TIAC_Sp_AutHChk
	@ctxt_ouinstance    	fin_ctxt_ouinstance, --Input 
	@ctxt_user          	fin_ctxt_user, --Input 
	@ctxt_language      	fin_ctxt_language, --Input 
	@ctxt_service       	fin_ctxt_service, --Input 
	@batchnumtype       	fin_notypeno, --Input 
	@createdby          	fin_ctxt_user, --Input 
	@createddate        	fin_date, --Input 
	@docnonumtype       	fin_notypeno, --Input 
	@financebook        	fin_financebookid, --Input 
	@guid               	fin_guid, --Input 
	@hdntranno          	fin_documentno, --Input 
	@Hidden_control1       	fin_hiddencontrol, --Input 
	@Hidden_control2       	fin_hiddencontrol, --Input 
	@Hidden_control3 		fin_hiddencontrol, --Input 
	@lastmodifiedby     	fin_ctxt_user, --Input 
	@lastmodifieddate   	fin_date, --Input 
	@revdocnonumtype    	fin_notypeno, --Input 
	@status             	fin_status, --Input 
	@timestamp          	fin_timestamp, --Input 
	@totalwipamount     	fin_amount, --Input 
	@transferbatchno    	fin_documentno, --Input 
	@transfercwipamount 	fin_amount, --Input 
	@transferdate       	fin_date, --Input 
	@targed_fprowno     	fin_fprowno, --Input/Output
	@_ml_fprowno        	fin_fprowno, --Input/Output
	@updateprop				fin_rowno,--EPE-19372
	@autogentargetprop		fin_rowno,--EPE-20269
	@m_errorid          	fin_int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Set @m_errorid = 0

	--declaration of temporary variables
	declare @errorid			fin_number,
			@timestamp_tmp		fin_int,
			@rowno				fin_int,
			@execflag			fin_execflag,
			@placeholder		fin_placeholder,
			@target_assetcls	fin_assetclass,
			@financialyear_sr	fin_desc255,
			@financialyearrange	fin_desc255,
			@source_proposalno	fin_desc255,
			@prop_notype		fin_desc255,
			@prop_cwipamt		fin_amount,
			@tgt_asset_desc		fin_desc255,
			@budgetnum_dup		udd_desc255,
			@tgt_assetcls		udd_desc255,
			@srs_assetcls		udd_desc255
	--temporary and formal parameters mapping

	Set @ctxt_user = ltrim(rtrim(@ctxt_user))
	Set @ctxt_service        = ltrim(rtrim(@ctxt_service))
	Set @batchnumtype        = ltrim(rtrim(@batchnumtype))
	Set @createdby           = ltrim(rtrim(@createdby))
	Set @docnonumtype        = ltrim(rtrim(@docnonumtype))
	Set @financebook         = ltrim(rtrim(@financebook))
	Set @guid                = ltrim(rtrim(@guid))
	Set @hdntranno           = ltrim(rtrim(@hdntranno))
	Set @lastmodifiedby      = ltrim(rtrim(@lastmodifiedby))
	Set @revdocnonumtype     = ltrim(rtrim(@revdocnonumtype))
	Set @status              = ltrim(rtrim(@status))
	Set @transferbatchno     = ltrim(rtrim(@transferbatchno))

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @batchnumtype = '~#~' 
		Select @batchnumtype = null  

	IF @createdby = '~#~' 
		Select @createdby = null  

	IF @createddate = '01/01/1900' 
		Select @createddate = null  

	IF @docnonumtype = '~#~' 
		Select @docnonumtype = null  

	IF @financebook = '~#~' 
		Select @financebook = null  

	IF @guid = '~#~' 
		Select @guid = null  

	IF @hdntranno = '~#~' 
		Select @hdntranno = null  

	IF @lastmodifiedby = '~#~' 
		Select @lastmodifiedby = null  

	IF @lastmodifieddate = '01/01/1900' 
		Select @lastmodifieddate = null  

	IF @revdocnonumtype = '~#~' 
		Select @revdocnonumtype = null  

	IF @status = '~#~' 
		Select @status = null  

	IF @timestamp = -915
		Select @timestamp = null  

	IF @totalwipamount = -915
		Select @totalwipamount = null  

	IF @transferbatchno = '~#~' 
		Select @transferbatchno = null  

	IF @transfercwipamount = -915
		Select @transfercwipamount = null  

	IF @transferdate = '01/01/1900' 
		Select @transferdate = null  

	IF @targed_fprowno = -915
		Select @targed_fprowno = null  

	IF @_ml_fprowno = -915
		Select @_ml_fprowno = null  
		
	select @Hidden_control1     = ltrim(rtrim(@Hidden_control1))
	IF @Hidden_control1 = '~#~' 
		Select @Hidden_control1 = null  
	select @Hidden_control2     = ltrim(rtrim(@Hidden_control2))
	IF @Hidden_control2 = '~#~' 
		Select @Hidden_control2 = null  
	select @Hidden_control3     = ltrim(rtrim(@Hidden_control3))
	IF @Hidden_control3 = '~#~' 
		Select @Hidden_control3 = null  

	IF @updateprop = -915
		Select @updateprop = null --EPE-19372 

	IF @autogentargetprop = -915
		Select @autogentargetprop = null --EPE-20269 

	--BEGIN of Standard code for getting precision type--EPE-19372
    declare  @pqty_tmp                  fin_int ,
             @pamt_tmp                  fin_int ,
             @prate_tmp                 fin_int ,
             @perate_tmp                fin_int ,
             @phigh_tmp					fin_int ,
             @pmed_tmp                  fin_int ,
             @plow_tmp                  fin_int

    exec	fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
            @prate_tmp output, @perate_tmp output, @phigh_tmp output,
			@pmed_tmp output, @plow_tmp output
	--END of Standard code for getting precision type
	
	if /*@targed_fprowno = 0 or */ @_ml_fprowno = 0  --code changed for dts id 12H124_ACAP_00001:12H124_ACAP_00086  
	begin
		--Execute Get Details.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2022
		return
	end
	
	if not exists (select 'x' from acap_cwiptransfer_src_tmp(nolock)
						where guid		=		@guid)
	begin
		/*--Select at least one row in Source Document Information Multiline.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2023
		return*/
		--Execute Get Details.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2022
		return
	end
	
	--code added for dts id 12H124_ACAP_00001:12H124_ACAP_00086  starts 
	if @targed_fprowno = 0 
	begin
		--Provide Target Document Information.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,1999
		return
	end
	--code added for dts id 12H124_ACAP_00001:12H124_ACAP_00086  ends
	
	if not exists (select 'x' from acap_cwiptransfer_tgt_tmp(nolock)
					where guid		=		@guid)
	begin
		/*--Select at least one row in Target Document Information Multiline.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2024
		return*/
		--Provide Target Document Information.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,1999 --2022 ----code changed for dts id 12H124_ACAP_00001:12H124_ACAP_00086  
		return
	end
	

	if @Hidden_control1 <> @financebook
	begin
		--Search criteria modified since last fetch. Re-execute Get Details task.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2033
		return
	end
	
	-- code changed for the dts id 12H124_ACAP_00042 starts
	select @rowno = 0
	select @placeholder = null
	
	select @rowno = a.rowno,
			@placeholder = a.proposal_no
	from acap_cwiptransfer_src_tmp A (nolock) 
	where A.guid			=		@guid 
	and not exists (	select	'x' 
								from	aplan_acq_proposal_vw(nolock)
								where	proposal_number = A.proposal_no
								and	fb_id				= @financebook 
								and	proposal_status		= 'AC'
								and	dest_ouid			= @ctxt_ouinstance)
	order by a.rowno desc -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085
								
	if @placeholder is not null							
	begin
		--2048	Source Proposal Number %a  does not exist in Active Status at line no. %b.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2048,@placeholder,@rowno
		return
	end
	
	--CWIPTRF_050	Reversal Capital work order uniqueness check -2	"If the reversal Capital work order No. is repeated in the multiline, then check whether the Reversal Capital work order no is unique for combination of 
	--Source Asset Class, Source Proposal No. Else Display error."		Reversal Capital Work Order No. should be unique for Source Asset Class  Source Proposal No. combination. Modify Reversal Capital work order no at row no.<%%>
	select @rowno = 0
	select @placeholder = null
	
	select @rowno = b.rowno
	from acap_cwiptransfer_src_tmp A (nolock),acap_cwiptransfer_src_tmp B (nolock)
	where A.guid			=		@guid
	and   B.guid			=		@guid
	and   A.revcwip_no		=		B.revcwip_no
	and   A.asset_class + A.proposal_no		<>		B.asset_class + B.proposal_no
	order by a.rowno desc, b.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085:12H124_ACAP_00087
 

	if @rowno <> 0 
	begin
		--Reversal Capital Work Order Description should be same for Source Asset Class, Proposal No., Capital work order No. combination.Modify Reversal Capital work order description at row no.<%%>
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2027,@rowno
		return
	end
	
	--CWIPTRF_051a	Reversal Capital Work Order Description check -1	If Reversal Capital work order description is not and different for same Reversal capital work order no. then display error message.		Reversal Capital Work Order Description should be same 





































--or Source Asset Class, Proposal No., Capital work order No. combination.Modify Reversal Capital work order description at row no.<%%>

	select @rowno = 0
	select @rowno = b.rowno
	from acap_cwiptransfer_src_tmp A (nolock),acap_cwiptransfer_src_tmp B (nolock)
	where A.guid			=		@guid
	and   B.guid			=		@guid
	and   A.revcwip_no		=		B.revcwip_no
	and   A.revcwip_desc		<>		B.revcwip_desc
	order by a.rowno desc,b.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085:12H124_ACAP_00087

	if @rowno <> 0 
	begin
		--Reversal Capital Work Order Description should be same for Source Asset Class, Proposal No., Capital work order No. combination.Modify Reversal Capital work order description at row no.<%%>
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2028,@rowno
		return
	end
	
	if @autogentargetprop <> 1 
	begin

	select @rowno = 0
	select @placeholder = null
	
	select @rowno = a.rowno,
			@placeholder = a.proposal_no
	from acap_cwiptransfer_tgt_tmp A (nolock) 
	where A.guid			=		@guid 
	and not exists (	select	'x' 
								from	aplan_acq_proposal_vw(nolock)
								where	proposal_number = A.proposal_no
								and	fb_id				= @financebook 
								and	dest_ouid			= @ctxt_ouinstance)
	order by a.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085
								
	if @placeholder is not null							
	begin							
		--2044	Target Proposal No. %a does not belong to the Finance Book at line no. %b.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2044,@placeholder,@rowno
		return
	end

	select @rowno = 0
	select @placeholder = null
	
	select @rowno = a.rowno,
			@placeholder = a.proposal_no
	from acap_cwiptransfer_tgt_tmp A (nolock) 
	where A.guid			=		@guid 
	and not exists (	select	'x' 
								from	aplan_acq_proposal_vw(nolock)
								where	proposal_number = A.proposal_no
								and	fb_id				= @financebook 
								and	proposal_status		= 'AC'
								and	dest_ouid			= @ctxt_ouinstance)
	order by a.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085
							
	if @placeholder is not null							
	begin	
		--2045	Target Proposal No. %a does not exist in Active Status at line no. %b.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2045,@placeholder,@rowno
		return
	end
	
	select @rowno = 0
	select @placeholder = null
	
	select @rowno = a.rowno,
			@placeholder = a.proposal_no
	from acap_cwiptransfer_tgt_tmp A (nolock) 
	where A.guid			=		@guid 
	and not exists (	select	'x' 
								from	aplan_acq_proposal_vw(nolock)
								where	proposal_number = A.proposal_no
								and	fb_id				= @financebook 
								and	proposal_status		= 'AC'
								and	datediff(dd, @transferdate, expiry_date) > = 0
								and	dest_ouid			= @ctxt_ouinstance)
	order by a.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085
								
	if @placeholder is not null							
	begin									
		--2046	Target Proposal No. %a is not valid for the transfer date at line no.%b.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2046,@placeholder,@rowno
		return
	end
	

	select @rowno = 0
	select @placeholder = null
	
	select @rowno		 = a.rowno,
			@placeholder = a.proposal_no
	from acap_cwiptransfer_tgt_tmp A (nolock) 
	where A.guid			=		@guid 
	and not exists (	select	'x' 
								from	aplan_acq_proposal_vw(nolock)
								where	proposal_number = A.proposal_no
								and    asset_class_code = A.asset_class
								and	fb_id				= @financebook  
								and	dest_ouid			= @ctxt_ouinstance)
	order by a.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085
								
	if @placeholder is not null							
	begin														
		--2047	Target Proposal No. %a given does not correspond to the Target Asset Class selected at line no. %b. 
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2047,@placeholder,@rowno
		return
	end
	
	end
	--CWIPTRF_058	Capital work order uniqueness check -2	"If the Capital work order No. is repeated in the multiline, then check whether the Capital work order no is unique for combination of 
	--Target Asset Class, Target Proposal No. Else Display error."		Capital Work Order No. should be unique for Target Asset Class  Proposal No. combination. Modify work order no. at row no.<%%>
	select @rowno = 0
	select @rowno = b.rowno
	from acap_cwiptransfer_tgt_tmp A (nolock),acap_cwiptransfer_tgt_tmp B (nolock)
	where A.guid							=		@guid
	and   B.guid							=		@guid
	and   A.cwip_no							=		B.cwip_no
	and   A.asset_class + A.proposal_no		<>		B.asset_class + B.proposal_no
	order by a.rowno desc , b.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085:12H124_ACAP_00087
		
	if @rowno <> 0
	begin	
		-- Capital Work Order No. should be unique for Target Asset Class  Proposal No. combination. Modify work order no. at row no. %a.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2029,@rowno
		return
	end
	
	--12H124_ACAP_00032 Target Asset Class, Target Proposal No. and Capital Work Order No. repeated in the Multiline.
	select @rowno = 0
	select @rowno = b.rowno
	from acap_cwiptransfer_tgt_tmp A (nolock),acap_cwiptransfer_tgt_tmp B (nolock)
	where A.guid							=		@guid
	and   B.guid							=		@guid
	and   A.rowno							<>		B.rowno
	and    A.cwip_no + A.asset_class + A.proposal_no		=		 B.cwip_no + B.asset_class + B.proposal_no
	order by a.rowno desc , b.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085:12H124_ACAP_00087
	
	if @rowno <> 0
	begin			
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2043
		return
	end
	
	--CWIPTRF_058a	Capital work order uniqueness check -3	If the Capital work order No. exist as reversal capital work order then Display error.		Capital Work Order No. at row no.<%%> exist as a reversal capital work order no. Modify work order no.
	select @rowno = 0
	select @rowno = b.rowno
	from acap_cwiptransfer_src_tmp A (nolock),acap_cwiptransfer_tgt_tmp B (nolock)
	where A.guid			=		@guid
	and   B.guid			=		@guid
	and   A.revcwip_no		=		B.cwip_no 
	order by a.rowno desc , b.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085:12H124_ACAP_00087
	
	if @rowno <> 0
	begin	
		--Capital Work Order No. at row no. %a  exist as a reversal capital work order no. Modify work order no.
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2030,@rowno
		return
	end


	--CWIPTRF_059a	Capital Work Order Description check -1	If Capital work order description is not and different for same capital work order no. then display error message.		 Capital Work Order Description should be same for Target Asset Class, Proposal --, Capital work order No. combination.Modify  Capital work order description at row no.<%%> in the Target Document Information Multiline
	select @rowno = 0
	select @rowno = b.rowno
	from acap_cwiptransfer_tgt_tmp A (nolock),acap_cwiptransfer_tgt_tmp B (nolock)
	where A.guid			=		@guid
	and   B.guid			=		@guid
	and   A.cwip_no			=		B.cwip_no
	and   A.cwip_desc		<>		B.cwip_desc
	order by a.rowno desc , b.rowno desc  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00085:12H124_ACAP_00087
	
	if @rowno <> 0
	begin	
		-- Capital Work Order Description should be same for Target Asset Class, Proposal No., Capital work order No. combination.Modify  Capital work order description at row no.  %a in the Target Document Information Multiline
		exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2031,@rowno
		return
	end
	-- code changed for the dts id 12H124_ACAP_00042 ends
	/*Code added for EPE-19372 begins here*/
	if	@UpdateProp	= 1
	begin
		select	@rowno			= a.rowno,
				@placeholder	= a.proposal_no
		from	acap_cwiptransfer_tgt_tmp A (nolock) ,
				aplan_acq_proposal_vw p(nolock)
		where	A.guid				= @guid 
		and		p.proposal_number	= a.proposal_no
		and		p.fb_id				= @financebook 
		and		p.proposal_status	= 'AC'
		and		p.dest_ouid			= @ctxt_ouinstance
		and		NOT exists (	select	'x' 
								from	aplan_acq_proposal_vw V(nolock),
										acap_cwiptransfer_src_tmp B (nolock) 
								where	v.proposal_number	= B.proposal_no
								and		v.fb_id				= @financebook 
								and		v.proposal_status	= 'AC'
								and		v.dest_ouid			= @ctxt_ouinstance
								and		p.budget_number		= v.budget_number
								and		A.guid				= @guid
							)
		order by a.rowno desc

		
		if @placeholder is not null							
		begin	
			--For transferring Proposal Balance, Source and Destination Proposal should belongs to the same budget..
			exec fin_german_raiserror_sp   'ACAP',@ctxt_language,2233,@placeholder,@rowno
			return
		end
	end
	/*Code added for EPE-19372 ends here*/
	----epe-20269
	if @autogentargetprop = 1 
	begin
		declare	@proposalnumber_src	fin_desc40

		select	@proposalnumber_src	=	proposal_no
		from	acap_cwiptransfer_src_tmp(nolock)
		where	guid = @guid

		select  @financialyear_sr			= financial_year
		from	aplan_acq_proposal_hdr A(nolock)
		where	A.ou_id						= @ctxt_ouinstance
		and		A.proposal_number			= @proposalnumber_src

		if @ctxt_user='debug##'
		begin
	
			select @financialyear_sr,@proposalnumber_src
			Select d.asset_class_code	, asset_class,*  
			from	acap_cwiptransfer_tgt_tmp t(nolock)
					left outer join
					aplan_budget_dtl d(nolock)
					on	
					(
						d.ou_id				= @ctxt_ouinstance
						and		d.financial_year	= @financialyear_sr
						and		t.guid				= @guid
						--and		d.asset_class_code	= asset_class
						and		d.fb_id				= @financebook
					)
			where	d.asset_class_code	is not null 
			and		t.guid				= @guid
		end

		if  exists (	Select 'x'   
						from	acap_cwiptransfer_tgt_tmp t(nolock)
								left outer join
								aplan_budget_dtl d(nolock)
								on	
								(
									d.ou_id				= @ctxt_ouinstance
									and		d.financial_year	= @financialyear_sr
									and		t.guid				= @guid
									and		d.asset_class_code	= asset_class
									and		d.fb_id				= @financebook
								)
						where	d.asset_class_code	is  null 
						and		t.guid				= @guid
						)
		begin
			select	@placeholder	=	null

			Select  top 1 
					@placeholder	=	asset_class  
			from	acap_cwiptransfer_tgt_tmp t(nolock)
					left outer join
					aplan_budget_dtl d(nolock)
					on	
					(
						d.ou_id				= @ctxt_ouinstance
				and		d.financial_year	= @financialyear_sr
				and		t.guid				= @guid
				and		d.asset_class_code	= asset_class
				and		d.fb_id				= @financebook
					)
			where	d.asset_class_code	is   null ---EPE-23229 :23229
			and		t.guid				= @guid

			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,20002,@placeholder,@financialyear_sr
			return
		end
		---EPE-23279
		if @ctxt_user='debug##'
		begin
	
			Select  count(distinct budget_number)
			from	acap_cwiptransfer_src_tmp t(nolock),
					aplan_acq_proposal_hdr A(nolock)
			where	a.asset_class_code	= asset_class
			and		a.ou_id				= @ctxt_ouinstance
			and		t.guid				= @guid
			and		a.fb_id				= @financebook
			and		A.ou_id				= @ctxt_ouinstance
			and		A.proposal_number	= proposal_no
		end

		select	@budgetnum_dup		=	null

		select	 @budgetnum_dup		=	count(distinct budget_number)
		from	acap_cwiptransfer_src_tmp t(nolock),
				aplan_acq_proposal_hdr A(nolock)
		where	a.asset_class_code	= asset_class
		and		a.ou_id				= @ctxt_ouinstance
		and		t.guid				= @guid
		and		a.fb_id				= @financebook
		and		A.ou_id				= @ctxt_ouinstance
		and		A.proposal_number	= proposal_no

		if @budgetnum_dup > 1  --new req
		begin
			--For auto generation of target proposal id, all the source proposals should belong to the same budget
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,20005
			return
		end
	end
	--epe-20269 :---EPE-23279
	if exists (select 'x' from acap_cwiptransfer_src_dtl (nolock)
				where ou_id		= @ctxt_ouinstance
				and transfer_no  = @transferbatchno)
	begin
		delete  acap_cwiptransfer_src_dtl
		where ou_id		= @ctxt_ouinstance
		and transfer_no  = @transferbatchno
	end

	if exists (select 'x' from acap_cwiptransfer_tgt_dtl (nolock)
				where ou_id		= @ctxt_ouinstance
				and transfer_no  = @transferbatchno)
	begin
		delete  acap_cwiptransfer_tgt_dtl
		where ou_id		= @ctxt_ouinstance
		and transfer_no  = @transferbatchno
	end

	
	
	--CWIPTRF_054	Computation of Total Transfer CWIP Amount 	Sum up the Transfer Amount column in the Source document information multiline and save the same for Total Transfer CWIP Amount
	select @transfercwipamount = sum(isnull(transfer_amt,0))
	from acap_cwiptransfer_src_tmp  (nolock)
	where guid = @guid
	
	select @totalwipamount = sum(isnull(cwip_amt,0))
	from acap_cwiptransfer_tgt_tmp  (nolock)
	where guid = @guid
	
	--CWIPTRF_062	Transfer Amount = CWIP Amount	For the selected row/s in the multiline if the Sum of CWIP Amount is not  = Sum of Transfer Amount in the Source document information display error message.		Sum of CWIP Amount in Target Document Information i

















































--snot equal to Sum of Transfer Amount in the Source document information. Modify Amounts.
	if @transfercwipamount <> @totalwipamount
	begin
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2016
		return
	end
	
	/*
	--CWIPTRF_098	Transfer Batch No. Blank check.	If Transfer Batch No. is Blank then display error.		Execute Maintain Transfer before authorizing Transfer.
	if @transferbatchno is null
	begin
		--Execute Maintain Transfer before authorizing Transfer.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2032
		return
	end
	*/
	
	declare @status_tmp    fin_status
	
	if @ctxt_service = 'ACA_TIAC_SR_MNT'
		select @status_tmp = 'F'
	
	if @ctxt_service = 'ACA_TIAC_SR_AUT'
		select  @status_tmp = 'A'
	
	if exists (select 'X'	from acap_cwiptransfer_hdr (nolock)
					 where		ou_id 		= @ctxt_ouinstance
					 and		transfer_no = @transferbatchno	  )
	begin
	
		if @transferbatchno <> @hdntranno
		begin
			--Header Details Modified. Please refresh before proceeding.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2026
			return
		end
		
		
		if exists (select 'X'	from acap_cwiptransfer_hdr (nolock)
				 where		ou_id 		= @ctxt_ouinstance
				 and		transfer_no = @transferbatchno
				 and        transfer_status <> 'F'	  )
		begin
			--Transfer Batch No.  %a Not in Fresh Status. 
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2042,@transferbatchno
			return
		end

		select @timestamp_tmp = timestamp
		from acap_cwiptransfer_hdr (nolock)
		where		ou_id 		= @ctxt_ouinstance
		and		transfer_no	    = @transferbatchno

		if @timestamp <> @timestamp_tmp
		begin
			--Details have been modified by another User. Please refresh before proceeding.
			exec fin_german_raiserror_sp  'ACAP',@ctxt_language,2025
			return
		end
		
		update acap_cwiptransfer_hdr 
		set  transfer_status	= @status_tmp,
			 transfer_date		= @transferdate,
			 docno_numtype		= @docnonumtype,
			 revdocno_numtype	= @revdocnonumtype,
			 fb					= @financebook,
			 timestamp			= timestamp + 1,
			 guid				= @guid,
			 tot_trncwip_amt	= @transfercwipamount,
			 tot_cwip_amt		= @totalwipamount,
			 updateprop_chk		= @updateprop,--EPE-19372
			 autogenprop_chk	= @autogentargetprop,--EPE-19372
			 modifiedby			= @ctxt_user,
			 modifieddate		= dbo.RES_Getdate(@ctxt_ouinstance)
		where	ou_id 		= @ctxt_ouinstance
		and	   transfer_no = @transferbatchno
	end
	else
	begin
		if @batchnumtype  LIKE ('%~MANUAL~%')
		begin  --'%~MANUAL~%'
			--CWIPTRF_075	Transfer Batch No. Blank check.	If Numbering Type is manual and Transfer Batch No. is Blank then display error.		For manual numbering type,  Transfer Batch No. has to be specified. Provide Transfer Batch No.
			if isnull(@transferbatchno,'~#~') = '~#~' or @transferbatchno = ''
			begin
				 exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2017
				 return
			end	

			--CWIPTRF_076	Space between numbers check.	If Numbering Type is manual and there is space between numbers in Transfer Batch No. display error.		Transfer Batch No. should not contain spaces in between.
			if ltrim(rtrim(@transferbatchno)) like '% %'
			begin
				 exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2018
				 return
			end	
			
			----CWIPTRF_078	Unique Transfer Batch No. generation.	Check if the Transfer Batch No. already exists in the ACAP component mapped to the OU. If yes and the numbering type is manual then display error. If yes and the numbering type is not manual then ta



























			--ke the service NcSerNcComTrn2 again from numbering type component go generate another number. Repeat this request till you get a unique number for that OU.
			if exists (select 'X'	from acap_cwiptransfer_hdr (nolock)
								 where		ou_id 		= @ctxt_ouinstance
								 and		transfer_no = @transferbatchno	  )
			begin
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2020
				return      
			end  
		end -- '%~MANUAL~%'
		else
		begin -- not manual
			--For Automatic numbering type, Transfer Batch No. can not be specified. Remove Transfer Batch No.
			if @transferbatchno is not null     
			begin      
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2019
				return      
			end  
			
			while 1 = 1
			begin --while 1 = 1
				--CWIPTRF_077	Transfer Batch No. generation rule -2	If Numbering type is not manual Invoke the service NcSerNcComTrn2 from the Numbering Class Component mapped to the login Org Unit.  Give inputs as (1) Transaction Type: FA_CWIPTRF (2) Org Unit : Log



































				--n Org Unit, (3) Date: Transfer Date  (4) Numbering Type.  Get output and load it to Transfer Batch No. field.
				exec  dnm_gen_tranno_sp @ctxt_language, @ctxt_ouinstance, @ctxt_service, @ctxt_user,
				'ACAP', 'FA_CWIPTRF', @batchnumtype, @transferdate, @transferbatchno output ,
				@errorid output, @execflag output
				
				if isnull(@transferbatchno,'') = ''
				begin
					--Automatic Generation of Transfer Batch No. failed.
					exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2021
					return
				end


				--CWIPTRF_078	Unique Transfer Batch No. generation.	Check if the Transfer Batch No. already exists in the ACAP component mapped to the OU. If yes and the numbering type is manual then display error. If yes and the numbering type is not manual then tak




























--e the service NcSerNcComTrn2 again from numbering type component go generate another number. Repeat this request till you get a unique number for that OU.
				if exists (	select 'x' from acap_cwiptransfer_hdr (nolock)
						 where		transfer_no 		= @transferbatchno
						 and		ou_id 				= @ctxt_ouinstance	  )
				begin
					continue
				end
				else
				begin
					break
				end
			end --while 1 = 1
		end  -- not manual
		
		insert into acap_cwiptransfer_hdr
		(ou_id , transfer_no, transfer_date, transfer_status, transfer_numtype,docno_numtype, revdocno_numtype, 
		updateprop_chk,--EPE-19372
		 autogenprop_chk,--EPE-19372
		guid,fb, timestamp,tot_trncwip_amt, tot_cwip_amt,createdby,createddate,modifiedby,modifieddate)
		values
		(@ctxt_ouinstance,@transferbatchno,@transferdate,@status_tmp,@batchnumtype,@docnonumtype,@revdocnonumtype,
		@updateprop,--EPE-19372
		@autogentargetprop,--EPE-19372
		@guid,@financebook,1,@transfercwipamount,@totalwipamount,@ctxt_user,dbo.RES_Getdate(@ctxt_ouinstance),null,null	)
	end
		

	-- insert the source ml table information
	insert into acap_cwiptransfer_src_dtl
	(ou_id,transfer_no,doc_ou,doc_no,doc_type,line_no,doc_date,
	supp_name,asset_class,proposal_no,doc_amt,doc_lineamt,pendcap_amt,
	transfer_amt,revcwip_no,revcwip_desc,revdoc_no,rowno
	,tran_currency,tran_erate--Amani
	)
	select @ctxt_ouinstance,@transferbatchno,doc_ou,doc_no,doc_type,line_no,doc_date,
		supp_name,asset_class,proposal_no,doc_amt,doc_lineamt,pendcap_amt,
		transfer_amt,revcwip_no,revcwip_desc,revdoc_no,rowno -- code changed for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 
		,tran_currency,tran_erate--Amani
	from acap_cwiptransfer_src_tmp (nolock)
	where guid = @guid
	order by rowno  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 
	
	

	-- insert the target ml table information
	insert into acap_cwiptransfer_tgt_dtl
	(ou_id,transfer_no,asset_class,proposal_no,
	 cwip_amt,cwip_no,cwip_desc,doc_no,rowno)
	select  @ctxt_ouinstance,@transferbatchno,asset_class,proposal_no,
			cwip_amt,cwip_no,cwip_desc,doc_no,rowno  -- code changed for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 
	from acap_cwiptransfer_tgt_tmp (nolock)
	where guid = @guid
	order by rowno  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 
	
	--EPE-20269
	
	if @autogentargetprop = 1 
	begin
		
		if exists (	select 'x'
					from 	dnm_trans_notype_vw(nolock)
					where   ouinstance 	= @ctxt_ouinstance
					and		trantype_code 	= 'FA_APRO'
					and		no_type			<> '~MANUAL~'
				)
		begin	
			select 	TOP 1
					@prop_notype	= ltrim(rtrim(no_type))
			from 	dnm_trans_notype_vw(nolock)
			where   ouinstance 		= @ctxt_ouinstance
			and		trantype_code 	= 'FA_APRO'
			and		no_type			<> '~MANUAL~'
			ORDER BY DEFAULT_TYPE DESC
		end
		else
		begin
			--Numbering type not mapped for the Asset Proposal for the login OU. Map Numbering type and proceed.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,20003
			return
		END

		
	end
	--EPE-20269


	-- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00052 starts
	if @ctxt_service = 'ACA_TIAC_SR_AUT'
	begin	
	-- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00052 ends
		/*Code added for EPE-19372 begins here*/
		declare @AplProjectCode					fin_projectcode,
				@AplProjectDescription			fin_projectdescription,
				@ValidateAddtionalEntiry		fin_flag,
				@projectou_hdn					fin_ctxt_ouinstance,
				@costcenter						fin_costcentercode,
				@assetclass						fin_desc255,
				@asset_class					fin_desc255,			
				@boardrefdate					fin_date,		
				@boardreference					fin_desc255,
				@budgetnum						fin_desc255,	
				@costvariance					fin_amount,
				@createdby1						fin_desc255,
				@createddate1					fin_date,
				@currencycode					fin_desc255,
				@currencycodeml					fin_desc255,
				@exchangerate					fin_exchangerate,
				@costinbasecurrml				fin_amount,
				@assetdescriptionml				fin_desc255,
				@new_proposal_amt_ml			fin_amount,
				@exist_proposal_amt_ml			fin_amount,
				@transfer_amt_ml				fin_amount,
				@as_fprowno						fin_int,
				@budamdnum						fin_int,
				@budgetdate						fin_date,			
				@budgetstatus					fin_desc255,
				@allowvarenn					fin_desc255,
				@amountreqd						fin_amount,
				@allocatedamtml					fin_amount,
				@total_utilized_amount			fin_amount,
				@totalallocatedamount			fin_amount,
				@totalbasereqamount				fin_amount,
				@totbasebalamt					fin_amount,
				@totbaseutiamount				fin_amount,
				@totallocamount_tmp				fin_amount,
				@totbasevaramt					fin_amount,
				@exchangevariance				fin_amount,
				@new_allocated_amt				fin_amount,
				@allocated_amt					fin_amount,
				@new_utilized_amt				fin_amount,
				@new_proposal_amt				fin_amount,
				@exist_proposal_amt				fin_amount,
				@transfer_amt					fin_amount,
				@cwip_amt						fin_amount,
				@committed_amt					fin_amount,
				@liability_amt					fin_amount,
				@exist_liability_amt			fin_amount,
				@utilized_amt					fin_amount,
				@Balance_amt					fin_amount,
				@expiry_date1					fin_date,
				@amendment_no					fin_int,
				@balanceamount					fin_amount,
				@baseallocamount				fin_amount,	
				@baseamount						fin_amount,
				@basebalamt						fin_amount,
				@baseutilizedamount				fin_amount,
				@basevaramount					fin_amount,
				@currencyml						fin_desc255,
				@fb_budget						fin_desc255,
				--@exchangerate		
				@budvarianceamount				fin_amount,
				@variancepercent				fin_amount,
				@placeholder1					fin_desc255,
				@placeholder2					fin_desc255,
				@placeholder3					fin_desc255,
				@placeholder4					fin_desc255,
				@fb   							fin_desc255,
				@financialyear					fin_desc255,
				@proposaldate					fin_date,
				@proposaldesc					fin_desc255,
				@proposalnumber					fin_desc255,
				@proposalstatus					fin_desc255,
				@proposedcostinclvar			fin_amount,
				@timestamp1						fin_int,
				@merrorid						fin_int,
				@errorno						fin_int,
				@noofunits						fin_int,
				@successflag					fin_int,
				@seq							fin_int,
				@type							fin_desc255,
				@totalprocostinbascurr			fin_amount,
				@guid_new						fin_guid,
				@trgassetclass					fin_desc255,
				@tran_date						datetime,
				@companycode					fin_companycode,
				@documentnumber					fin_desc255
		



		if	@UpdateProp	= 1 or (@UpdateProp	= 1 and  @autogentargetprop = 1 )--EPE-20269
		begin
			declare acqprop_cursor    cursor  
			for
			select	proposal_no,asset_class,'SRC',1 as 'seq'
			from	acap_cwiptransfer_src_tmp(nolock)
			where	guid = @guid
			union
			select	proposal_no,asset_class,'TGT',2 as 'seq'
			from	acap_cwiptransfer_tgt_tmp(nolock)
			where	guid = @guid
			order by seq

			open acqprop_cursor
	
			fetch from acqprop_cursor  into @proposalnumber,@assetclass,@type ,@seq                               
	
			while (@@fetch_status = 0)
			begin	
				select	@guid_new	=	newid()

				

				--EPE-20269
				if @ctxt_user = 'debug'
				begin
					select @proposalnumber

				end
				
				

				if	@type	=	'TGT' and @proposalnumber = ''
				begin
					select	@prop_cwipamt	= cwip_amt
					from	acap_cwiptransfer_tgt_tmp(nolock)
					where	guid			= @guid
					AND		asset_class		=	@assetclass

					select @tran_date = dbo.RES_Getdate(@ctxt_ouinstance)

					select	@companycode	 = company_code 
					from	emod_ou_vw (nolock)
					where	ou_id 			 = @ctxt_ouinstance
					and	    @tran_date between effective_from and isnull(effective_to,@tran_date)

					select  @currencycode   = currency_code      
					from	emod_basecurr_vw      
					where	company_code	= @companycode      
					and		flag			= 'B'      
					and		@tran_date between effective_from and isnull(effective_to,@tran_date)      
					
					select	@tgt_asset_desc	 =	asset_class_desc
					from	ainf_asset_class_mst(nolock)
					where	asset_class_code =  @assetclass
					and		ou_id		=	@ctxt_ouinstance
					
					select @source_proposalno	= proposal_no
					from   acap_cwiptransfer_src_tmp (nolock)
					where  guid					= @guid


					select  @financialyear				= financial_year,
							@budgetnum					= budget_number,
							@proposaldate				= proposal_date,
							@boardrefdate				=  board_ref_date
					from	aplan_acq_proposal_hdr A(nolock)
					where	A.ou_id						= @ctxt_ouinstance
					and		A.proposal_number			= @source_proposalno

					select	@financialyearrange	= financialyearrange
					from	fcc_sysact_allyears_vw (nolock)
					where	company_code		= @companycode
					and		fb_id				= @financebook
					and		fin_year_code		= @financialyear

					if @ctxt_user = 'testdebug'
					begin
						select @prop_notype,@proposaldate,@financebook,@tgt_asset_desc,@financialyearrange,@budgetnum,
						@batchnumtype,@transferdate,@assetclass,@boardrefdate,@expiry_date1,@currencycode,@assetclass
					end
				
					--select @financialyearrange,'@financialyear before calling autogen sp'

					exec	acap_sp_autogen_acqproposal
							@ctxt_language,
							@ctxt_ouinstance,
							@ctxt_service,
							@ctxt_user,
							@guid_new,
							@batchnumtype,
							@transferdate,
							@prop_notype,--@numbering_type_no, --dought
							'~#~',--@proposalnumber,--. (Running No. from numbering type) --dought
							@proposaldate,
							@financebook,
							@tgt_asset_desc,--  - Destination Asset Class Description --dought
							@financialyearrange,
							@budgetnum,
							@assetclass,--Target Asset Class
							'Auto-generation of Target Proposal during Transfer of CWIP',--Auto-generation of Target Proposal during Transfer of CWIP--dought
							@boardrefdate,
							@expiry_date1,
							@currencycode,
							'1',---@exchangerate,
							'',--@exchangevariance,
							'',--@costvariance,
							'',--@costcenter,
							'',--@projectou,
							'',--@ProjectCode,
							'',--@ProjectDescription,
							'0',--'',--@ValidateAddtionalEntiry,--code added and commneted by MCHS-749
							@assetclass,--@assetdescriptionml, --- Target Asset class code --dought
							'1',--@noofunits,
							@currencycode, --: Base Currency
							@prop_cwipamt, /*@proposedcost*/--CWIP Amount of the line  --dought
							@prop_cwipamt,  --dought
							@createddate1,
							@createdby1,
							@placeholder1,
							@placeholder2,
							@placeholder3,
							@placeholder4,
							@successflag,
							@errorno,
							@documentnumber out,
							@m_errorid out


					if isnull(@documentnumber,'') = '' or isnull(@m_errorid,0) <> 0 
					begin
						close acqprop_cursor   
						deallocate acqprop_cursor 
						--Automatic Generation of Target proposal failed.
						exec fin_german_raiserror_sp 'ACAP',@ctxt_language,20004
						 
						return
					end

					
			
					
					update tmp
					set	 proposal_no     = @documentnumber
					from acap_cwiptransfer_tgt_tmp tmp(nolock)
					where guid			  = @guid
					and	 asset_class	  = @assetclass

					update tmp
					set	 proposal_no     = @documentnumber
					from acap_cwiptransfer_tgt_dtl tmp(nolock)
					where ou_id		= @ctxt_ouinstance
					and transfer_no  = @transferbatchno
					and		asset_class	  = @assetclass
				
					
			end
			else
			begin
			----EPE-20269
				insert into fb_tmp
				(		rsih_guid_tmp,		remarks	)
				select	@guid_new,			'ACAP'

				select	@transfer_amt	= sum(isnull(transfer_amt,0))
				from	acap_cwiptransfer_src_tmp  (nolock)
				where	guid			= @guid
				and		proposal_no		= @proposalnumber
	
				select	@cwip_amt		= sum(isnull(cwip_amt,0))
				from	acap_cwiptransfer_tgt_tmp  (nolock)
				where	guid			= @guid			
				and		proposal_no		= @proposalnumber
				
		
				Select	@AplProjectCode				= a.project_code,		
						@AplProjectDescription		= dbo.fin_get_prjdesc(@ctxt_ouinstance, @ctxt_language, a.project_ou, a.project_code),		
						@ValidateAddtionalEntiry	= a.addnl_entity,	
						@projectou_hdn				= a.project_ou,		
						@costcenter					= a.cost_center,
						@assetclass					= asset_class_code,
						@boardrefdate				= board_ref_date,
						@boardreference				= board_ref,
						@budgetnum					= budget_number,
						@costvariance				= cost_var_per,
						@createdby1					= createdby,
						@createddate1				= createddate,
						@currencycode				= currency_code,
						@exchangerate				= exchange_rate,
						@exchangevariance			= exchange_rate_var_per,
						@expiry_date1				= expiry_date,
						@fb   						= fb_id,
						@financialyear				= financial_year,
						@proposaldate				= proposal_date,
						@proposaldesc				= proposal_desc,
						@proposalnumber				= proposal_number,
						@proposalstatus				= proposal_status,
						@proposedcostinclvar		= proposed_cost_variance,
						@timestamp1					= timestamp,
						@totalprocostinbascurr		= total_proposed_cost_bc,
						@exist_proposal_amt			= round(isnull(proposed_cost,0) * isnull(exchange_rate,0) ,@pamt_tmp),	
						@committed_amt				= round(isnull(commited_amount,0) * isnull(exchange_rate,0) ,@pamt_tmp),
						@exist_liability_amt		= round(isnull(liability_amount,0) * isnull(exchange_rate,0) ,@pamt_tmp),
						@utilized_amt				= round(isnull(proposed_cost,0) * isnull(exchange_rate,0) ,@pamt_tmp) 
				from	aplan_acq_proposal_hdr A(nolock)
				where	A.ou_id						= @ctxt_ouinstance
				and		A.proposal_number			= @proposalnumber
				
				select	@exist_proposal_amt			= isnull(proposal_amount,0),--round(isnull(proposed_cost,0) * isnull(exchange_rate,0) ,@pamt_tmp),	
						@exist_liability_amt		= isnull(liability_amount,0),--round(isnull(liability_amount,0) * isnull(exchange_rate,0) ,@pamt_tmp),
						@utilized_amt				= isnull(utilized_amount,0)--round(isnull(proposed_cost,0) * isnull(exchange_rate,0) ,@pamt_tmp) 
				from	aplan_proposal_bal_dtl A(nolock)
				where	A.ou_id						= @ctxt_ouinstance
				and		A.proposal_number			= @proposalnumber

				if	@type	=	'SRC'
				begin
					select	@new_proposal_amt = @exist_proposal_amt - @transfer_amt,
							@liability_amt = @exist_liability_amt - @transfer_amt
				end
				else
				begin
					select	@new_proposal_amt = @exist_proposal_amt + @cwip_amt,
							@liability_amt = @exist_liability_amt + @cwip_amt
				end
			
				select	@Balance_amt = isnull(@new_proposal_amt,0) - isnull(@committed_amt,0) - isnull(@liability_amt,0) - isnull(@utilized_amt,0)

				select	@transfer_amt_ml = @transfer_amt

				select @as_fprowno = 1

				delete from aplan_acq_proposal_tmp
				where guid	=	@guid
				
				INSERT INTO aplan_acq_proposal_tmp
				(	
						asset_desc,						currency_code,						no_of_units,						proposal_cost,
						guid,							ou_id,								proposal_number
				)
				select	asset_desc,
						currency_code,
						no_of_units,
						proposal_cost,
						@guid,
						@ctxt_ouinstance,
						proposal_number
				from	aplan_acq_proposal_dtl(nolock)
				where	proposal_number		=	@proposalnumber
				and		ou_id				=	@ctxt_ouinstance
				and		fb_id				=	@fb
				and		financial_year		=	@financialyear
				and		asset_class_code	=	@assetclass

				declare assetdesc_cursor    cursor  
				for
				select	asset_desc,
						currency_code,
						no_of_units,
						proposal_cost
				from	aplan_acq_proposal_tmp(nolock)
				where	guid	=	@guid

				open assetdesc_cursor
	
				fetch from assetdesc_cursor  into @assetdescriptionml,@currencycodeml,@noofunits ,@exist_proposal_amt_ml                      
	
				while (@@fetch_status = 0)
				begin
					if	@type	=	'SRC'
					begin
						if @exist_proposal_amt_ml < @transfer_amt_ml
						begin
							select	@new_proposal_amt_ml = 0

							select	@transfer_amt_ml = @transfer_amt_ml-@exist_proposal_amt_ml
						end
						else
						begin
							select	@new_proposal_amt_ml = @exist_proposal_amt_ml - @transfer_amt_ml

							select	@transfer_amt_ml = 0
						end
					end
					else
					begin
						if @as_fprowno = 1
						select	@new_proposal_amt_ml = @exist_proposal_amt_ml + @cwip_amt
						else
						select	@new_proposal_amt_ml = @exist_proposal_amt_ml
					end
					
					select	@costinbasecurrml	=	@new_proposal_amt_ml*@exchangerate
				
					if @as_fprowno = 1
					exec	aplanacpmsphdsav_common
							@assetclass,
							'~#~',
							@boardrefdate ,
							@boardreference,
							@budgetnum   ,
							@costvariance,
							@createdby1  ,
							@createddate1,
							@ctxt_language,
							@ctxt_ouinstance,
							'APLANAMACPMSRAMD',--@ctxt_service  ,
							@ctxt_user   ,
							@currencycode ,
							@exchangerate ,
							@exchangevariance,
							@expiry_date1   ,
							@fb   	,
							@financialyear,
							@guid_new   ,
							'~#~',
							@proposaldate  ,
							@proposaldesc ,
							@proposalnumber,
							@proposalstatus,
							@proposedcostinclvar,
							@timestamp1,
							@totalprocostinbascurr,
							'E',
							@AplProjectCode,			
							@AplProjectDescription	,
							@ValidateAddtionalEntiry,
							@projectou_hdn,			
							@costcenter	,		
							@merrorid	output

					if @merrorid <> 0 
					begin
						if 	@ctxt_user	=	'debugaplan$'		
						begin
							select @merrorid '@merrorid'
							select 'Error from aplanacpmsphdsav_common'
						end
						close assetdesc_cursor     
						deallocate assetdesc_cursor 

									close acqprop_cursor     
							deallocate acqprop_cursor 

						raiserror('Error in Amend Proposal.',16,1)
						
						return
					end

					if 	@ctxt_user	=	'debugaplan$'		
					begin	
						select @assetclass,@proposalnumber 'before ,ml'
						select @assetdescriptionml,@currencycodeml,@noofunits,@exist_proposal_amt_ml
						select * from aplan_acq_proposal_dtl(nolock)where proposal_number in ('AMDTEST1','AMDTEST2') 
					end

					exec	aplanacpmspminf_common
							@assetclass     ,
							@assetdescriptionml,	
							@costinbasecurrml,
							@costvariance   ,
							@ctxt_language  ,
							@ctxt_ouinstance ,
							'APLANAMACPMSRAMD',--@ctxt_service    ,
							@ctxt_user    ,
							@currencycode  ,
							@currencycodeml,--@currencycodeml ,
							@exchangerate    ,
							@exchangevariance ,
							@fb              ,
							@financialyear    ,
							@guid_new             ,
							'Z',--@modeflag         ,
							@noofunits         ,
							@proposalnumber    ,
							@new_proposal_amt_ml,--@proposedcostml    ,
							@errorno          ,
							@as_fprowno,--@fprowno           ,
							@placeholder1      ,
							@placeholder2 ,
							@placeholder3      ,
							@placeholder4      ,
							@successflag       ,
							'E',		
							@merrorid                  output

							if @merrorid <> 0 
							begin
								if 	@ctxt_user	=	'debugaplan$'		
								begin
									select @merrorid '@merrorid'
									select 'Error from aplanacpmspminf_common'
								end
								close assetdesc_cursor     
								deallocate assetdesc_cursor 
								raiserror('Error in Amend Proposal.',16,1)
								
								return
								
							end

							select @as_fprowno = @as_fprowno+1

						fetch next from assetdesc_cursor into @assetdescriptionml,@currencycodeml,@noofunits,@exist_proposal_amt_ml 
				end
				
				close assetdesc_cursor     
				deallocate assetdesc_cursor 

				--update  aplan_proposal_bal_dtl
    --    		set 	proposal_amount	 = round(@new_proposal_amt,@pamt_tmp),
    --    				liability_amount = round(@liability_amt,@pamt_tmp)
    --    		where	ou_id			= @ctxt_ouinstance
    --    		and		proposal_number	= @proposalnumber

				--update  aplan_acq_proposal_dtl
    --    		set 	proposal_cost	 = round(@new_proposal_amt,@pamt_tmp)
    --    		where	ou_id			= @ctxt_ouinstance
    --    		and		proposal_number	= @proposalnumber

				--update  aplan_acq_proposal_hdr
    --    		set 	liability_amount = round(@liability_amt,@pamt_tmp)
    --    		where	ou_id			= @ctxt_ouinstance
    --    		and		proposal_number	= @proposalnumber

				exec	aplanacpmsphdchk_common
						@assetclass  ,
						'~#~',
						@boardrefdate  ,
						@boardreference,
						@budgetnum   ,
						@costvariance,
						@createdby   ,
						@createddate ,
						@ctxt_language,
						@ctxt_ouinstance,
						@ctxt_service  ,
						@ctxt_user   	,
						@currencycode  ,
						@exchangerate  ,
						@exchangevariance,
						@expiry_date1   	,
						@fb   		,
						@financialyear  ,
						@guid_new   	,
						'~#~',
						@proposaldate   	,
						@proposaldesc   ,
						@proposalnumber ,
						@proposalstatus ,
						@proposedcostinclvar,
						@totalprocostinbascurr,
						@errorno  ,
						1,--@fprowno   ,
						@placeholder1,
						@placeholder2 ,
						@placeholder3 ,
						@placeholder4 ,
						@successflag  ,
						'E',
						@merrorid output

						if @merrorid <> 0 
						begin
							if 	@ctxt_user	=	'debugaplan$'		
							begin
								select @merrorid '@merrorid'
								select 'Error from aplanacpmsphdchk_common'
							end
							close acqprop_cursor     
							deallocate acqprop_cursor
							raiserror('Error in Amend Proposal.',16,1)
							
							return
							 
						end
				end  ------EPE-20269
				 
				fetch next from acqprop_cursor into @proposalnumber,@assetclass,@type,@seq
			end
			
			close acqprop_cursor     
			deallocate acqprop_cursor  


    if exists    (    select    '*'
                from    acap_cwiptransfer_src_tmp  s(nolock),
                        acap_cwiptransfer_tgt_tmp  t(nolock)
                where    s.guid            = @guid
                and        t.guid            = @guid       
                and        s.asset_class    <> t.asset_class
            )
begin
			--declare budget_cursor    cursor  
			--for
			--select	p.budget_number,'SRC',1 as seq
			--from	acap_cwiptransfer_src_tmp a(nolock),
			--		aplan_acq_proposal_vw p(nolock)
			--where	A.guid				= @guid 
			--and		p.proposal_number	= a.proposal_no
			--and		p.fb_id				= @financebook 
			--and		p.proposal_status	= 'AC'
			--and		p.dest_ouid			= @ctxt_ouinstance
			--union	
			--select	p.budget_number,'TGT',2 as seq
			--from	acap_cwiptransfer_tgt_tmp A (nolock) ,
			--		aplan_acq_proposal_vw p(nolock)
			--where	A.guid				= @guid 
			--and		p.proposal_number	= a.proposal_no
			--and		p.fb_id				= @financebook 
			--and		p.proposal_status	= 'AC'
			--and		p.dest_ouid			= @ctxt_ouinstance
			--order by 3

			--open budget_cursor
	
			--fetch next from budget_cursor into @budgetnum ,@type,@seq                    
	
			--while (@@fetch_status = 0)
			--begin
				if @ctxt_user = 'debugamdbud$'
				select	@budgetnum ,@type,@seq '@budgetnum ,@type,@seq ' 

				select	@budamdnum				=	amendment_number,
						@budgetdate				=	budget_date,
						@budgetstatus			=	budget_status,
						@timestamp				=	timestamp,
						@totalallocatedamount	=	total_base_alloc_amount,
						@totalbasereqamount		=	total_base_req_amount,
						@totbasebalamt			=	total_base_bal_amount,
						@totbaseutiamount		=	total_utilized_amount,
						@totbasevaramt			=	total_base_variance_amount
				from	aplan_budget_hdr(nolock)
				where	budget_number	=	@budgetnum
				and		ou_id			=	@ctxt_ouinstance
				and		financial_year	=	@financialyear

				delete from	aplan_budget_tmp
				where	guid		=	@guid
				
				insert into aplan_budget_tmp
				(
						guid,					ou_id,					budget_number,					fb_id,
						asset_class_code,		currency_code,			timestamp,						budget_req_number,
						amount_required,		exchange_rate,			base_amount,					allocated_amount,
						allow_variance,			variance_per,			variance_amount,				base_alloc_amount,
						base_variance_amount,	remarks,				utilized_amount,				base_utilized_amount,
						balance_amount,			base_balance_amount
				)
				select	@guid,					ou_id			,		budget_number,					fb_id,
						asset_class_code,		currency_code,			timestamp,						null,
						amount_required,		exchange_rate,			base_amount,					allocated_amount,
						allow_variance,			variance_per,			variance_amount,				base_alloc_amount,
						base_variance_amount,	remarks,				utilized_amount,				base_utilized_amount,
						balance_amount,			base_balance_amount							
				from	aplan_budget_dtl(nolock)
				where	budget_number		=	@budgetnum
				and		ou_id				=	@ctxt_ouinstance
				and		financial_year		=	@financialyear

				if @ctxt_user = 'debugamdbud$'
				begin
					select '#aplan_budget_tmp#'
					select * from	aplan_budget_tmp(nolock)
					where	guid		=	@guid
					select	distinct asset_class_code,currency_code,fb_id
					from	aplan_budget_tmp(nolock)
					where	guid				=	@guid
				end
				select @as_fprowno = 1

				declare budgetdtl_cursor    cursor  
				for
				select	distinct asset_class_code,currency_code,fb_id
				from	aplan_budget_tmp(nolock)
				where	guid				=	@guid	

				open budgetdtl_cursor
	
				fetch next from budgetdtl_cursor into @asset_class ,@currencyml,@fb_budget                    
	
				while (@@fetch_status = 0)
				begin
					if @ctxt_user = 'debugamdbud$'
					select	@budgetnum ,@type,@seq,@asset_class ,@currencyml,@fb_budget '@budgetnum ,@type,@seq,@asset_class ,@currencyml,@fb_budget '

					select	@allocated_amt		=	allocated_amount,
							@allowvarenn		=	allow_variance,
							@amountreqd			=	amount_required,
							@utilized_amt		=	utilized_amount,
							@assetclass			=	asset_class_code,
							@balanceamount		=	balance_amount,
							@baseallocamount	=	base_alloc_amount,
							@baseamount			=	base_amount,
							@basebalamt			=	base_balance_amount,
							@baseutilizedamount	=	base_utilized_amount,
							@basevaramount		=	base_variance_amount,
							@currencycode		=	currency_code,
							@exchangerate		=	exchange_rate,
							@budvarianceamount	=	variance_amount,	
							@variancepercent	=	variance_per
					from	aplan_budget_tmp(nolock)
					where	guid				=	@guid					
					and		asset_class_code	=	@asset_class
					and		currency_code		=	@currencyml
					and		fb_id				=	@fb_budget

					select	@allowvarenn		= parameter_text
					from	fin_quick_code_met(nolock)
					where	component_id		= 'APLAN'
					and		parameter_type		= 'CBO'
					and		parameter_category	= 'ALL_VAR'
					and		parameter_code		= @allowvarenn
					and		language_id			= @ctxt_language

					select	@type	= null

					if exists	(	select	'*'--,'SRC',1 as seq
									from	acap_cwiptransfer_src_tmp a(nolock),
											aplan_acq_proposal_vw p(nolock)
									where	A.guid				= @guid 
									and		p.proposal_number	= a.proposal_no
									and		p.fb_id				= @fb_budget 
									and		p.proposal_status	= 'AC'
									and		p.dest_ouid			= @ctxt_ouinstance
									and		p.budget_number		= @budgetnum
									and		asset_class_code	= @asset_class
									and		currency_code		= @currencyml
								)
					begin
						select	@type	=	'SRC'

						select	@transfer_amt	= sum(isnull(transfer_amt,0))
						from	acap_cwiptransfer_src_tmp a(nolock),
								aplan_acq_proposal_vw p(nolock)
						where	A.guid				= @guid 
						and		p.proposal_number	= a.proposal_no
						and		p.fb_id				= @fb_budget 
						and		p.proposal_status	= 'AC'
						and		p.dest_ouid			= @ctxt_ouinstance
						and		p.budget_number		= @budgetnum
						and		asset_class_code	= @asset_class
						and		currency_code		= @currencyml

						
	
						

					end
					else if exists	(	select	'*'--,'SRC',1 as seq
										from	acap_cwiptransfer_tgt_tmp a(nolock),
												aplan_acq_proposal_vw p(nolock)
										where	A.guid				= @guid 
										and		p.proposal_number	= a.proposal_no
										and		p.fb_id				= @fb_budget 
										and		p.proposal_status	= 'AC'
										and		p.dest_ouid			= @ctxt_ouinstance
										and		p.budget_number		= @budgetnum
										and		asset_class_code	= @asset_class
										and		currency_code		= @currencyml
									)
					begin
						select	@type	=	'TGT'

						select	@cwip_amt		= sum(isnull(cwip_amt,0))
						from	acap_cwiptransfer_tgt_tmp a(nolock),
								aplan_acq_proposal_vw p(nolock)
						where	A.guid				= @guid 
						and		p.proposal_number	= a.proposal_no
						and		p.fb_id				= @fb_budget 
						and		p.proposal_status	= 'AC'
						and		p.dest_ouid			= @ctxt_ouinstance
						and		p.budget_number		= @budgetnum
						and		asset_class_code	= @asset_class
						and		currency_code		= @currencyml

							
				

					end
	

					if @ctxt_user = 'debugamdbud$'
					begin
						select @allocated_amt '@allocated_amt abcd'
						select allocated_amount,* from	aplan_budget_tmp(nolock)
						where	guid				=	@guid					
						and		asset_class_code	=	@asset_class
						and		currency_code		=	@currencyml
						and		fb_id				=	@fb_budget
					end

					if @as_fprowno = 1
					exec	aplanambudmspamdhdsav
							@budamdnum,
							@budgetdate,
							@budgetnum,
							@budgetstatus,
							@ctxt_language,
							@ctxt_ouinstance,
							'aplanambudmsramd',
							@ctxt_user,
							@financialyear,
							@guid_new,
							@ctxt_user,
							null,--@lastmodifieddate
							@timestamp,
							@totalallocatedamount,
							@totalbasereqamount,
							@totbasebalamt,
							@totbaseutiamount,
							@totbasevaramt,
							null,     --code added for MSIE-656
							@merrorid output

						if @merrorid <> 0 
						begin
							if @ctxt_user = 'debugamdbud$'		
							begin
								select @merrorid '@merrorid'
								select 'Error from aplanambudmspamdhdsav'
							end
							close	budgetdtl_cursor
							deallocate 	budgetdtl_cursor
							raiserror('Error in Amend Budget.',16,1)
							return
						end

					

					if @type	=	'SRC'
					begin
						select	@new_allocated_amt	= @allocated_amt - @transfer_amt,
								@new_utilized_amt	= @utilized_amt - @transfer_amt	
					end
					else if @type	=	'TGT'
					begin
						select	@new_allocated_amt = @allocated_amt + @cwip_amt,
								@new_utilized_amt  = @utilized_amt + @cwip_amt
					end
					else
					begin
						select	@new_allocated_amt = @allocated_amt,
								@new_utilized_amt  = @utilized_amt
					end
					

					if @ctxt_user = 'debugamdbud$'
					begin
						select	@new_allocated_amt,@new_utilized_amt
						select @budgetnum,				   @ctxt_ouinstance,				   @fb,				   @financialyear,				   @assetclass,				   @currencycode,@exchangerate
						select	@type,@allocated_amt,@utilized_amt,@transfer_amt,@cwip_amt
					end
					 
			

					if @type is not null
					begin
						select	@baseutilizedamount	=	@new_utilized_amt,
								@baseallocamount	=	@new_allocated_amt

						SELECT	@balanceamount		=	(@new_allocated_amt*@exchangerate)-(@new_utilized_amt*@exchangerate),
								@basebalamt			=	(@baseallocamount*@exchangerate)-(@baseutilizedamount*@exchangerate)
					end
					else
					begin
						select	@baseutilizedamount	=	@utilized_amt,
								@baseallocamount	=	@allocated_amt
					end


					exec	aplanambudmspamdminf--aplan_createbudgetmlt--aplan_computeamt
							@new_allocated_amt,--@allocatedamtml,
							@allowvarenn,
							@amountreqd,
							@new_utilized_amt,--@amountutilized,
							@assetdescriptionml,
							@assetclass,
							@balanceamount,
							@baseallocamount,
							@baseamount,
							@basebalamt,
							@baseutilizedamount,
							@basevaramount,
							@budamdnum,
							@budgetnum,
							@budvarianceamount,
							@ctxt_language,
							@ctxt_ouinstance,
							'aplanambudmsramd',
							@ctxt_user,
							@currencyml,
							@exchangerate,
							@fb_budget,
							@financialyear,
							@guid_new,
							'Z',--@modeflag
							'',--@remarks,
							@variancepercent,
							@errorno,
							1,--@fprowno,
							@placeholder1,
							@placeholder2,
							@placeholder3,
							@placeholder4,
							@successflag,
							/*code added for MSIE-656 starts*/
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							/*code added for MSIE-656 ends*/
							@merrorid output

	
						if @merrorid <> 0 
						begin
							if 	@ctxt_user	=	'debugaplan$'		
							begin
								select @merrorid '@merrorid'
								select 'Error from aplanambudmspamdminf'
							end
							close	budgetdtl_cursor
							deallocate 	budgetdtl_cursor
							--close	budget_cursor
							--deallocate 	budget_cursor
							raiserror('Error in Amend Budget.',16,1)
							return
						end

						select @as_fprowno = @as_fprowno+1

						fetch next from budgetdtl_cursor into @asset_class  ,@currencyml,@fb_budget 
				end
				close	budgetdtl_cursor
				deallocate 	budgetdtl_cursor

			SELECT	@amendment_no	=	ISNULL(MAX(CONVERT(INT, amendment_number)), 0)
			FROM	aplan_budget_amend_hdr(NOLOCK)
			WHERE	ou_id			=	@ctxt_ouinstance
			AND  	budget_number	=	@budgetnum

			select 	@totalallocatedamount 	= sum(isnull(base_alloc_amount,0)),
					@totbasevaramt			= sum(isnull(base_variance_amount,0)),
					@totallocamount_tmp		= sum(isnull(allocated_amount,0)),
					@total_utilized_amount	= sum(isnull(utilized_amount,0))			
			from	aplan_budget_dtl(nolock)
			where	budget_number		=	@budgetnum
			and		ou_id				=	@ctxt_ouinstance
			and		financial_year		=	@financialyear

			
			--updating the budget hdeader table
			update 	aplan_budget_hdr
			set 	total_base_alloc_amount 	= round(@totalallocatedamount,@pamt_tmp),
					total_base_variance_amount 	= round(@totbasevaramt,@pamt_tmp),
					total_alloc_amount			= round(@totallocamount_tmp ,@pamt_tmp),
					total_utilized_amount		= round(@total_utilized_amount,@pamt_tmp)
			where	ou_id			= @ctxt_ouinstance
			and		budget_number	= @budgetnum

			--updating the budget amend hdeader table
			update 	aplan_budget_amend_hdr
			set 	total_base_alloc_amount 	= round(@totalallocatedamount,@pamt_tmp),
					total_base_variance_amount 	= round(@totbasevaramt,@pamt_tmp),
					total_alloc_amount			= round(@totallocamount_tmp ,@pamt_tmp),
					total_utilized_amount		= round(@total_utilized_amount,@pamt_tmp)
			where	ou_id 				= @ctxt_ouinstance
			and		budget_number 		= @budgetnum
			and		amendment_number	= @amendment_no

			if @ctxt_user = 'testuser'
			begin
				select	allocated_amount,utilized_amount,* from aplan_budget_dtl where budget_number = 'APLANBUD\1001\2007'
				and asset_class_code	= 'MR_BUILDING'

			end

			delete from	aplan_budget_tmp
			where	guid = @guid_new

			--	fetch next from budget_cursor into @budgetnum,@type,@seq
			--end
	 end
			--close budget_cursor     
			--deallocate budget_cursor  
		end
		/*Code added for EPE-19372 ends here*/
		if @ctxt_user = 'testuser'
			begin
				select	allocated_amount,utilized_amount,* from aplan_budget_dtl where budget_number = 'APLANBUD\1001\2007'
				and asset_class_code	= 'MR_BUILDING'

			end
		declare @targetcwip_no				fin_documentno,
				@targetcwip_desc			fin_name,
				@targetassetclass			fin_assetclass,
				@targetproposal_no			fin_documentnumber,
				@targetwipcost				fin_amount
		
		/********************************* Cwip Auto generation starts ******************************/
		/* code changed for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 starts */
		/*declare target_cwip_cur cursor for 
		select distinct cwip_no,asset_class,proposal_no
		from  acap_cwiptransfer_tgt_dtl(nolock)
		where	ou_id 		= @ctxt_ouinstance
		and		transfer_no = @transferbatchno
	  --  order by rowno  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 */
	    declare target_cwip_cur cursor for 
		select distinct cwip_no,asset_class,proposal_no
		from  acap_cwiptransfer_tgt_tmp(nolock)
		where guid = @guid
	    /* code changed for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 ends */
	    
		open target_cwip_cur

		while 1=1
		begin
		
			fetch next from target_cwip_cur into @targetcwip_no,@targetassetclass,@targetproposal_no
			
			if @@fetch_status <> 0
				break

				--select @targetproposal_no '@abcd'
				
	   	    --and		proposal_status 	= 'AC'
						
			select  @targetwipcost	= sum(isnull(cwip_amt,0))
			from  acap_cwiptransfer_tgt_dtl(nolock)
			where	ou_id 		= @ctxt_ouinstance
			and		transfer_no = @transferbatchno
			and		cwip_no		= @targetcwip_no
			and		asset_class = @targetassetclass
			and		proposal_no = @targetproposal_no
			
			select   @targetcwip_desc = cwip_desc
			from    acap_cwiptransfer_tgt_dtl(nolock)
			where	ou_id 		= @ctxt_ouinstance
			and		transfer_no = @transferbatchno
			and		cwip_no		= @targetcwip_no
			and		asset_class = @targetassetclass
			and		proposal_no = @targetproposal_no
			
			exec acap_cwipautogen @ctxt_language, @ctxt_ouinstance , @ctxt_service, @ctxt_user , null,
								  @targetcwip_desc,  @targetcwip_no, null, @financebook, @guid, @docnonumtype , @transferdate,
								  @targetwipcost, @targetassetclass	, @targetproposal_no,@transferbatchno,  @errorid output
						
			if isnull(@errorid,0) <> 0
			
			begin
				close target_cwip_cur
				deallocate target_cwip_cur				
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2001--code added by TC-2440		 
				return
			end
			
		end

		close target_cwip_cur
		deallocate target_cwip_cur
		/********************************** Cwip Auto generation ends ******************************/

		/************************ Reversal Cwip Auto generation starts ******************************/	
		declare @srcrevcwip_no			fin_documentno,
				@srcrevcwip_desc		fin_name,
				@srcassetclass			fin_assetclass,
				@srcproposal_no			fin_documentnumber,
				@srcwipcost				fin_amount
		
		
		/* code changed for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 starts */
		/*
		declare source_cwip_cur cursor for 
		select distinct revcwip_no,asset_class,proposal_no
		from  acap_cwiptransfer_src_dtl(nolock)
		where	ou_id 		= @ctxt_ouinstance
		and		transfer_no = @transferbatchno
		order by rowno  -- code added for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 
	     */ 
	    declare source_cwip_cur cursor for 
		select distinct revcwip_no,asset_class,proposal_no
		from  acap_cwiptransfer_src_tmp(nolock)
		where	guid = @guid
		/* code changed for the dts id 12H124_ACAP_00001:12H124_ACAP_00092 ends*/ 
		
		open source_cwip_cur

		while 1=1
		begin
		
			fetch next from source_cwip_cur into @srcrevcwip_no,@srcassetclass,@srcproposal_no
			
			if @@fetch_status <> 0
				break
						
			select  @srcwipcost	= sum(isnull(transfer_amt,0))
			from  acap_cwiptransfer_src_dtl(nolock)
			where	ou_id 		= @ctxt_ouinstance
			and		transfer_no = @transferbatchno
			and		revcwip_no	= @srcrevcwip_no
			and		asset_class = @srcassetclass
			and		proposal_no = @srcproposal_no
			
			select   @srcrevcwip_desc = revcwip_desc
			from  acap_cwiptransfer_src_dtl(nolock)
			where	ou_id 		= @ctxt_ouinstance
			and		transfer_no = @transferbatchno
			and		revcwip_no	= @srcrevcwip_no
			and		asset_class = @srcassetclass
			and		proposal_no = @srcproposal_no
			
			
			exec acap_revcwipautogen @ctxt_language, @ctxt_ouinstance , @ctxt_service, @ctxt_user , null,
								  @srcrevcwip_desc,  @srcrevcwip_no, null, @financebook, @guid, @revdocnonumtype , @transferdate,
								  @srcwipcost, @srcassetclass	, @srcproposal_no,@transferbatchno, @errorid output
						
			if isnull(@errorid,0) <> 0
			
			 begin
				close source_cwip_cur
				deallocate source_cwip_cur
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2001--code added by TC-2440
				return
			end
			
		end

		close source_cwip_cur
		deallocate source_cwip_cur
		/************************ Reversal Cwip Auto generation ends ******************************/	
	end	

		
	--OutputList
	Select
		@targed_fprowno			'TARGED_FPROWNO', 
		@_ml_fprowno			'_ML_FPROWNO'
	
	
Set nocount off

End





	
	


























