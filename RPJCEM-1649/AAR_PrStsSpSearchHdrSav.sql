/*$File_version=MS4.3.0.04$*/
/* $$Component Name=PRJREP*/
/*$File Name    : AAR_PrStsSpSearchHdrSav.sql					*/
/*$Version      : 1.0.0.0							*/
/********************************************************************************/
/* Procedure					: PRE_PrStsSpSearchHdrSav	*/
/* Description					: 				*/
/********************************************************************************/
/* Project					: 				*/
/* EcrNo					: 				*/
/* Version					:	 			*/
/********************************************************************************/
/* Referenced					: 				*/
/* Tables					:	 			*/
/********************************************************************************/
/* Development history				:				*/
/********************************************************************************/
/* Author					: 						*/
/* Date						:						*/
/********************************************************************************/
/* Modification History				:				*/
/********************************************************************************/
/* Lavanya K J					8/4/2013			13H120_PRJREP_00006		  */
/* Divyalekaa					23/04/2013			12H124_LEASE_00006:13H120_PRJREP_00014	*/
/* Nagarajan J					21/05/2013			13H120_Masters_00007: ES_Masters_00077 */
/* Vasantha A					25/07/2013			ES_PRJREP_00062			  */
/* Kavitha B					06/03/2023			EPE-64115				  */

Create Procedure AAR_PrStsSpSearchHdrSav
	@ctxt_ouinstance  	udd_ctxt_ouinstance, 		--Input 
	@ctxt_user        	udd_ctxt_user, 			--Input 
	@ctxt_language    	udd_ctxt_language, 		--Input 
	@ctxt_service     	udd_ctxt_service, 		--Input 
	@csouinstance     	udd_ctxt_ouinstance, 		--Input 
	@detailed         	udd_desc20, 			--Input 
	@guid             	udd_guid, 			--Input 
	@orgunit          	udd_desc20, 			--Input 
	@projectcodefrom  	udd_transactionno, 		--Input 
	@projectcodeto    	udd_transactionno, 		--Input 
	@projectenddate   	udd_desc20, 			--Input 
	@projectstartdate 	udd_desc20, 			--Input 
	@projectstatus    	udd_status, 			--Input 
	@projrepgrp       	udd_type, 			--Input 
	@starepfor        	udd_type, 			--Input 
	@textcontrol1     	udd_desc20, 			--Input 
	@textcontrol2     	udd_desc20, 			--Input 
	@timestamp        	udd_timestamp, 			--Input 
	@tranou           	udd_ctxt_ouinstance, 		--Input 
	@trantype         	udd_transactiontype, 		--Input 
	@contractor_res   	udd_chkflag, --Input 
	@contractor       	udd_chkflag, --Input 
	@customer         	udd_customer_id, --Input 
	@customer_res     	udd_chkflag, --Input 
	@self             	udd_chkflag, --Input 
	@self_res         	udd_chkflag, --Input 
	@constrngrp       	udd_guidencetext, --Input 
	@level            	udd_guidencetext, --Input 
	@rpttype          	udd_flag50, --Input 
	@subcontracted    	udd_uomcode, --Input 
	@workarea         	udd_guidencetext, --Input 
	@projectname      	udd_item_desc, --Input 
	@actcodefrom      	udd_guidencetext, --Input 
	@actcodeto        	udd_guidencetext, --Input 
	@actgrpfrom       	udd_guidencetext, --Input 
	@actgrpto         	udd_guidencetext, --Input 
	@activitygroupvariantfrom 	udd_guidencetext, --Input 
	@activitygroupvariantto   	udd_guidencetext, --Input
	
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
	@tasksubgroupfrom         	udd_guidencetext, --Input 
	@tasksubgroupto           	udd_guidencetext, --Input 
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */

	@m_errorid        	udd_int output 			--To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	select @m_errorid = 0

	--declaration of temporary variables


	--temporary and formal parameters mapping

	select @ctxt_user         = ltrim(rtrim(@ctxt_user))
	select @ctxt_service      = ltrim(rtrim(@ctxt_service))
	select @detailed          = ltrim(rtrim(@detailed))
	select @guid              = ltrim(rtrim(@guid))
	select @orgunit           = ltrim(rtrim(@orgunit))
	select @projectcodefrom   = ltrim(rtrim(@projectcodefrom))
	select @projectcodeto     = ltrim(rtrim(@projectcodeto))
	select @projectenddate    = ltrim(rtrim(@projectenddate))
	select @projectstartdate  = ltrim(rtrim(@projectstartdate))
	select @projectstatus     = ltrim(rtrim(@projectstatus))
	select @projrepgrp        = ltrim(rtrim(@projrepgrp))
	select @starepfor         = ltrim(rtrim(@starepfor))
	select @textcontrol1      = ltrim(rtrim(@textcontrol1))
	select @textcontrol2      = ltrim(rtrim(@textcontrol2))
	select @trantype          = ltrim(rtrim(@trantype))
	select @contractor_res    = ltrim(rtrim(@contractor_res))
	select @contractor        = ltrim(rtrim(@contractor))
	select @customer          = ltrim(rtrim(@customer))
	select @customer_res      = ltrim(rtrim(@customer_res))
	select @self              = ltrim(rtrim(@self))
	select @self_res          = ltrim(rtrim(@self_res))
	select @constrngrp        = ltrim(rtrim(@constrngrp))
	select @level             = ltrim(rtrim(@level))
	select @rpttype           = ltrim(rtrim(@rpttype))
	select @subcontracted     = ltrim(rtrim(@subcontracted))
	select @workarea          = ltrim(rtrim(@workarea))
	select @projectname       = ltrim(rtrim(@projectname))
	select @actcodefrom       = ltrim(rtrim(@actcodefrom))
	select @actcodeto         = ltrim(rtrim(@actcodeto))
	select @actgrpfrom        = ltrim(rtrim(@actgrpfrom))
	select @actgrpto          = ltrim(rtrim(@actgrpto))
	Select @activitygroupvariantfrom  = ltrim(rtrim(@activitygroupvariantfrom))
	Select @activitygroupvariantto    = ltrim(rtrim(@activitygroupvariantto))
		/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
	Select @tasksubgroupfrom          = ltrim(rtrim(@tasksubgroupfrom))
	Select @tasksubgroupto            = ltrim(rtrim(@tasksubgroupto))
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */


	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @csouinstance = -915
		Select @csouinstance = null  

	IF @detailed = '~#~' 
		Select @detailed = null  

	IF @guid = '~#~' 
		Select @guid = null  

	IF @orgunit = '~#~' 
		Select @orgunit = null  

	IF @projectcodefrom = '~#~' 
		Select @projectcodefrom = null  

	IF @projectcodeto = '~#~' 
		Select @projectcodeto = null  

	IF @projectenddate = '~#~' 
		Select @projectenddate = null  

	IF @projectstartdate = '~#~' 
		Select @projectstartdate = null  

	IF @projectstatus = '~#~' 
		Select @projectstatus = null  

	IF @projrepgrp = '~#~' 
		Select @projrepgrp = null  

	IF @starepfor = '~#~' 
		Select @starepfor = null  

	IF @textcontrol1 = '~#~' 
		Select @textcontrol1 = null  

	IF @textcontrol2 = '~#~' 
		Select @textcontrol2 = null  

	IF @timestamp = -915
		Select @timestamp = null  

	IF @tranou = -915
		Select @tranou = null  

	IF @trantype = '~#~' 
		Select @trantype = null  

	IF @contractor_res = '~#~' 
		Select @contractor_res = null  

	IF @contractor = '~#~' 
		Select @contractor = null  

	IF @customer = '~#~' 
		Select @customer = null  

	IF @customer_res = '~#~' 
		Select @customer_res = null  

	IF @self = '~#~' 
		Select @self = null  

	IF @self_res = '~#~' 
		Select @self_res = null  

	IF @constrngrp = '~#~' 
		Select @constrngrp = null  

	IF @level = '~#~' 
		Select @level = null  

	IF @rpttype = '~#~' 
		Select @rpttype = null  

	IF @subcontracted = '~#~' 
		Select @subcontracted = null  

	IF @workarea = '~#~' 
		Select @workarea = null  

	IF @projectname = '~#~' 
		Select @projectname = null  

	IF @actcodefrom = '~#~' 
		Select @actcodefrom = null  

	IF @actcodeto = '~#~' 
		Select @actcodeto = null  

	IF @actgrpfrom = '~#~' 
		Select @actgrpfrom = null  

	IF @actgrpto = '~#~' 
		Select @actgrpto = null  
	
	IF @activitygroupvariantfrom = '~#~' 
		Select @activitygroupvariantfrom = null  

	IF @activitygroupvariantto = '~#~' 
		Select @activitygroupvariantto = null
		
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
	IF @tasksubgroupfrom = '~#~' 
		Select @tasksubgroupfrom = null  

	IF @tasksubgroupto = '~#~' 
		Select @tasksubgroupto = null 
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
	
	if isnull(@projectcodefrom ,'')  = ''
	begin
		--raiserror ('Project Code should not be blank',16,1)
		exec fin_german_raiserror_sp 'PRJREP',@ctxt_language,33
		return
	end

	/*Code commneted for 12H124_LEASE_00006:13H120_PRJREP_00014 begins here*/
	/*if isnull(@projectname ,'')  = ''
	begin
		--raiserror ('Project Name should not be blank',16,1)
		exec fin_german_raiserror_sp 'PRJREP',@ctxt_language,34
		return
	end*/
	/*Code commneted for 12H124_LEASE_00006:13H120_PRJREP_00014 begins here*/
	
	if  (@projectstartdate > @projectenddate )
	begin
		--raiserror ('Project Start Date cannot be greater than Project End Date',16,1)
		--select @m_errorid = 900004
		exec fin_german_raiserror_sp 'PRJREP',@ctxt_language,35
		return
	end

	if (@projectcodefrom > @projectcodeto )
	begin
		--raiserror ('Project Code From cannot be greater than Project Code To',16,1)
		--select @m_errorid = 900005
		exec fin_german_raiserror_sp 'PRJREP',@ctxt_language,36
		return
	end
	
	--code added for 13h120_prjrep_00006 starts
	declare	@prj_def	udd_metadata_code,
			@def_amend	udd_int
	
	select  @def_amend		= max(prjhdr_amendno) 
	from	prjdef_prj_hdr (nolock)
	where	prjhdr_prjou	=	@ctxt_ouinstance
	and		prjhdr_prjcode	=	@projectcodefrom
	
	select	@prj_def		=	prjhdr_definition
	from	prjdef_prj_hdr(nolock)
	where	prjhdr_prjou	=	@ctxt_ouinstance
	and		prjhdr_prjcode	=	@projectcodefrom
	and		prjhdr_amendno	=	@def_amend
	
	/*Code added for 12H124_LEASE_00006:13H120_PRJREP_00014 begins here*/
	if	@def_amend	is null
	begin
		--raiserror('Project Code does not exists',16,1)
		exec fin_german_raiserror_sp 'PRJREP',@ctxt_language,32
		return
	end
	/*Code added for 12H124_LEASE_00006:13H120_PRJREP_00014 ends here*/
	
	/*code commented by vasantha A for ES_PRJREP_00062 begins */
	/*
	if	(@prj_def	=	'CON')
	begin
		select	@ctxt_ouinstance	=	@ctxt_ouinstance
	end
	else
	begin
		--raiserror('Project Code should be of type "Construction".',16,1)
		exec fin_german_raiserror_sp 'PRJREP',@ctxt_language,38
		return	
	end
	*/
	/*code commented by vasantha A for ES_PRJREP_00062 ends */
	--code added for 13h120_prjrep_00006 ends
	
	--Code commented for EPE-64115 starts
	/*if( (@contractor_res	=	0) and (@customer_res	=	0) and (@self_res	=	0) and (@contractor	=	0) and (@customer	=	0) and (@self	=	0))
	begin
		--raiserror ('Atleast select anyone of resource/Material ownership',16,1)
		exec fin_german_raiserror_sp 'PRJREP',@ctxt_language,37
		return
	end*/
	--Code commented for EPE-64115 ends
	
	
Set nocount off

End



