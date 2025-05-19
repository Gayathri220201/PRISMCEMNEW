/*$File_version=MS4.3.0.23$*/
/* $$Component Name=PRJREP*/
/********************************************************************************/
/*$File_version = MS4.3.0.08$       */  
/*$File Name    : PRE_PrStsSpSearch1_Rprt_spO.sql    */  
/*$Version      : 1.0.0.2       */  
/********************************************************************************/  
/* Procedure     : AAR_PrStsSpSearch1_Rprt_spO */  
/* Description     :     */  
/********************************************************************************/  
/* Project     :     */  
/* EcrNo     :     */  
/* Version     :     */  
/********************************************************************************/  
/* Referenced     :     */  
/* Tables     :     */  
/********************************************************************************/  
/* Development history    :    */  
/********************************************************************************/  
/* Author     :																	*/  
/* Date       :																	*/  
/********************************************************************************/  
/* Modification History    :     */  
/********************************************************************************/  
/* Modified By    Date    Description  */  
/* Lavanya K J		28/3/2013			SP analyser exception					*/
/* Lavanya K J		10/4/2013			13H120_PRJREP_00012						*/
/* Lavanya K J		11/4/2013			13H120_PRJREP_00003						*/
/* Divyalekaa		11/4/2013			13H120_PRJREP_00003						*/
/* Lavanya K J		23/4/2013			ES_Masters_00072						*/
/* Nagarajan J		21/05/2013			13H120_Masters_00007: ES_Masters_00077	*/
/* Nagarajan J		30/05/2013			13H120_Masters_00007: ES_Masters_00085	*/
/* Divyalekaa		05/06/2013			ES_PRJREP_00049							*/
/* Kumar S			05/06/2013			ES_PRJREP_00041							*/
/* Aditya Sitaraman	26/06/2013			ES_PRJREP_00039							*/
/* Kumar S			06/07/2013			ES_PRJREP_00056							*/
/* Vasantha A		05/07/2013			ES_PRJDEF_00258							*/
/* Divyalekaa		05/06/2013			ES_PRJREP_00059 						*/
/* Kumar S			06/07/2013			ES_PRJREP_00077							*/
/* Manoj Kumar S	18/03/2014			ES_PRJREP_00085							*/
/*Banu M            07/06/2017          LNG-130                                  */
/* Vasantha a		18/08/2017			LNG-183									*/
/* Kavitha B		20/07/2022			EPE-43862								*/
/* Kavitha B		20/07/2022			EPE-55557								*/
/* Kavitha B		28/06/2023			EPE-64115								*/
/*Banurekha B       14/3/2024           EPE-82815                                */
/********************************************************************************/  

CREATE procedure AAR_PrStsSpSearch1_Rprt_spO
	 @ctxt_ouinstance   udd_ctxt_ouinstance,  --Input   
	 @ctxt_user         udd_ctxt_user,   --Input   
	 @ctxt_language     udd_ctxt_language,  --Input   
	 @ctxt_service      udd_ctxt_service,  --Input   
	 @detailed          udd_desc20,   --Input   
	 @guid              udd_guid,   --Input   
	 @orgunit           udd_desc20,   --Input   
	 @projectcodefrom   udd_transactionno,  --Input   
	 @projectcodeto     udd_transactionno,  --Input   
	 @projectenddate    udd_desc20,   --Input   
	 @projectstartdate  udd_desc20,   --Input   
	 @projectstatus     udd_status,   --Input   
	 @projrepgrp        udd_type,   --Input   
	 @starepfor         udd_type,   --Input   
	 @timestamp         udd_timestamp,   --Input   
	 @csouinstance      udd_ctxt_ouinstance,  --Input
	 @customer          udd_customer_id, --Input 
	 @customer_res      udd_chkflag, --Input 
	 @self              udd_chkflag, --Input 
	 @self_res          udd_chkflag, --Input 
	 @contractor        udd_chkflag, --Input 
	 @contractor_res    udd_chkflag, --Input 
	 @subcontracted     udd_uomcode, --Input 
	 @constrngrp        udd_guidencetext, --Input 
	 @rpttype           udd_flag50, --Input 
	 @level             udd_guidencetext, --Input 
	 @workarea          udd_guidencetext, --Input 
	 @projectname       udd_item_desc, --Input 
	 @actcodefrom       udd_guidencetext, --Input 
	 @actcodeto         udd_guidencetext, --Input 
	 @actgrpfrom        udd_guidencetext, --Input 
	 @actgrpto          udd_guidencetext, --Input    
	 @activitygroupvariantfrom 	udd_guidencetext, --Input
	 @activitygroupvariantto   	udd_guidencetext, --Input
	 /* Code added for dts id :13H120_Masters_00007: ES_Masters_00077 begins*/
	 @tasksubgroupfrom         	udd_guidencetext, --Input 
	 @tasksubgroupto           	udd_guidencetext, --Input 
	/* Code added for dts id :13H120_Masters_00007: ES_Masters_00077 begins*/
	 /*	Code Added for ID:ES_PRJREP_00085 begins */
	 @revisionno_in      revisionno,  --Input 
	 @comprev_no         revisionno,  --Input 
	/*	Code Added for ID:ES_PRJREP_00085 ends */
	 @m_errorid         udd_int output   --To Return Execution Status  
	as  
BEGIN
	-- nocount should be switched on to prevent phantom rows  
	SET NOCOUNT ON 
	
	
	-- @m_errorid should be 0 to Indicate Success  
	SELECT @m_errorid = 0 
	
	--declaration of temporary variables  
	declare @lo_id		 udd_loid
	declare @congrp_tmp  udd_unitcode
	declare @guid1		 udd_guid    
	
	--temporary and formal parameters mapping  
	
	SELECT @ctxt_user		  = LTRIM(RTRIM(@ctxt_user))  
	SELECT @ctxt_service	  = LTRIM(RTRIM(@ctxt_service))  
	SELECT @detailed		  = LTRIM(RTRIM(@detailed))  
	SELECT @guid			  = LTRIM(RTRIM(@guid))  
	SELECT @orgunit			  = LTRIM(RTRIM(@orgunit))  
	SELECT @projectcodefrom   = LTRIM(RTRIM(@projectcodefrom))  
	SELECT @projectcodeto	  = LTRIM(RTRIM(@projectcodeto))  
	SELECT @projectenddate	  = LTRIM(RTRIM(@projectenddate))  
	SELECT @projectstartdate  = LTRIM(RTRIM(@projectstartdate))  
	SELECT @projectstatus	  = LTRIM(RTRIM(@projectstatus))  
	SELECT @projrepgrp		  = LTRIM(RTRIM(@projrepgrp))  
	SELECT @starepfor		  = LTRIM(RTRIM(@starepfor)) 
	SELECT @congrp_tmp		  = LTRIM(RTRIM(@orgunit)) 
	SELECT @constrngrp		  = LTRIM(RTRIM(@constrngrp))
	SELECT @customer          = ltrim(rtrim(@customer))
	SELECT @customer_res      = ltrim(rtrim(@customer_res))
	SELECT @self			  = ltrim(rtrim(@self))
	SELECT @self_res		  = ltrim(rtrim(@self_res))
	SELECT @contractor        = ltrim(rtrim(@contractor))
	SELECT @contractor_res    = ltrim(rtrim(@contractor_res))
	SELECT @subcontracted     = ltrim(rtrim(@subcontracted))
	SELECT @constrngrp        = ltrim(rtrim(@constrngrp))
	SELECT @rpttype           = ltrim(rtrim(@rpttype))
	SELECT @level             = ltrim(rtrim(@level))
	SELECT @workarea          = ltrim(rtrim(@workarea))
	SELECT @projectname       = ltrim(rtrim(@projectname))
	SELECT @actcodefrom       = ltrim(rtrim(@actcodefrom))
	SELECT @actcodeto         = ltrim(rtrim(@actcodeto))
	SELECT @actgrpfrom        = ltrim(rtrim(@actgrpfrom))
	SELECT @actgrpto          = ltrim(rtrim(@actgrpto))
	SELECT @activitygroupvariantfrom  = ltrim(rtrim(@activitygroupvariantfrom))
	SELECT @activitygroupvariantto    = ltrim(rtrim(@activitygroupvariantto))
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
	select @tasksubgroupfrom          = ltrim(rtrim(@tasksubgroupfrom))
	select @tasksubgroupto            = ltrim(rtrim(@tasksubgroupto))
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
	SELECT @revisionno_in             = ltrim(rtrim(@revisionno_in))
	SELECT @comprev_no                = ltrim(rtrim(@comprev_no))

	--null checking  
	
	IF @ctxt_ouinstance = -915
	    SELECT @ctxt_ouinstance = NULL    
	
	IF @ctxt_user = '~#~'
	    SELECT @ctxt_user = NULL    
	
	IF @ctxt_language = -915
	    SELECT @ctxt_language = NULL    
	
	IF @ctxt_service = '~#~'
	    SELECT @ctxt_service = NULL  
	
	IF @detailed = '~#~'
	    SELECT @detailed = NULL    
	
	IF @guid = '~#~'
	    SELECT @guid = NULL    
	
	IF @orgunit = '~#~'
	    SELECT @orgunit = NULL    
	
	IF @projectcodefrom = '~#~'
	OR @projectcodefrom = ''
		SELECT @projectcodefrom = null
	    --SELECT @projectcodefrom = '!!!!!!!'    
	
	IF @projectcodeto = '~#~'
	OR @projectcodeto = ''
		SELECT @projectcodeto = null
	    --SELECT @projectcodeto =    
	
	IF @projectenddate = '~#~'
	    SELECT @projectenddate = '31/12/2999'      
	
	IF @projectstartdate = '~#~'
	    SELECT @projectstartdate = '01/01/1900'    
	
	IF @projectstatus = '~#~'
	    SELECT @projectstatus = NULL  
	
	IF @projrepgrp = '~#~'
	    SELECT @projrepgrp = NULL    
	
	IF @starepfor = '~#~'
	    SELECT @starepfor = NULL    
	
	IF @timestamp = -915
	    SELECT @timestamp = NULL    
	
	IF @csouinstance = -915
	 SELECT @csouinstance = NULL    
	    
	IF @congrp_tmp in  ('~#~', 'All' ) 
		SELECT @congrp_tmp = '%'    

	IF @customer = '~#~' 
		Select @customer = null  

	IF @customer_res = '~#~' 
		Select @customer_res = null  

	IF @self = '~#~' 
		Select @self = null  

	IF @self_res = '~#~' 
		Select @self_res = null  

	IF @contractor = '~#~' 
		Select @contractor = null  

	IF @contractor_res = '~#~' 
		Select @contractor_res = null  

	IF @subcontracted = '~#~' 
		Select @subcontracted = null  

	IF @constrngrp  in  ('~#~', 'All' )   
		SELECT @constrngrp = '%'  

	IF @rpttype = '~#~' 
		Select @rpttype = null  

	IF @level in ('~#~' ,'','ALL')
		Select @level = '%'  

	IF @workarea in('~#~' ,'ALL','')
		Select @workarea = '%'  

	IF @projectname = '~#~' 
		Select @projectname = null  

	IF @actcodefrom in ('~#~' ,'')
		Select @actcodefrom  = null
		--Select @actcodefrom  = '!!!!!!!'   

	IF @actcodeto in ('~#~' ,'')
		Select @actcodeto = null
		--Select @actcodeto = 

	IF @actgrpfrom in ('~#~' ,'')
		Select @actgrpfrom = null
		--Select @actgrpfrom = '!!!!!!!'   

	IF @actgrpto in ('~#~' ,'')
		Select @actgrpto = null
		--Select @actgrpto = 
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
	IF @tasksubgroupfrom in ('~#~' ,'')
		Select @tasksubgroupfrom = null  

	IF @tasksubgroupto in ('~#~' ,'')
		Select @tasksubgroupto = null  
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
	
	IF @revisionno_in = '~#~'
		Select @revisionno_in = null  
	IF @comprev_no = '~#~'
		Select @comprev_no = null  

	select	@lo_id = lo_id
	from	emod_lo_bu_ou_vw (nolock)
	where	ou_id	=  @ctxt_ouinstance
	and		dbo.RES_Getdate(@ctxt_ouinstance) between effective_from and isnull(effective_to, dbo.RES_Getdate(@ctxt_ouinstance))
		
	IF @activitygroupvariantfrom =	'~#~' or @activitygroupvariantfrom	=''
		Select @activitygroupvariantfrom	=	null
		
	IF @activitygroupvariantto	='~#~' or @activitygroupvariantto	='' 
		select @activitygroupvariantto	=	null
	
	
	DECLARE @ou_id      udd_ctxt_ouinstance
	DECLARE @prjstatus  udd_status 
	DECLARE @prjgrp     udd_type  
	--DECLARE @prjgrpN	udd_type   -- commented for SCRA Validations exceptions in id EPE-82815
	--DECLARE @prjindic   udd_type  -- commented for SCRA Validations exceptions in id EPE-82815
	DECLARE @all_tmp    udd_type 
	DECLARE @date_tmp   udd_datetime
	Declare @self_flag  udd_statuscode
	Declare	@rpttype_cd	udd_metadata_code
	DECLARE @rpt_date	udd_DATE	-- Manoj
	
	SELECT @date_tmp = CONVERT(nvarchar(10), dbo.RES_Getdate(@ctxt_ouinstance), 101)
	
	SELECT  @ou_id		= ouinstid
	FROM    fw_admin_view_ouinstance(NOLOCK)
	WHERE   ouinstname	= @orgunit   
	
	SELECT @prjstatus	  = paramcode
	FROM   component_metadata_table(NOLOCK)
	WHERE  componentname  = 'PRJDEF'
	AND    paramcategory  = 'COMBO'
	AND    paramtype	  = 'PRJSTATUS'
	AND    langid		  = @ctxt_language
	AND    paramdesc	  = @projectstatus  

	Select  @prjgrp			=	paramcode				
	from	component_metadata_table (nolock)
	where	componentname	= 	'PRJREP'
	and		paramcategory	= 	'COMBO'
	and 	paramtype		= 	'REPGRP'  
	and		paramdesc		=	@projrepgrp 
	AND     langid		    =	@ctxt_language --13h120_prjrep_00003
	
	select	@rpttype_cd		=	paramcode 
	from	component_metadata_table(nolock)
	where	componentname	=	'prjrep'
	and		paramtype		=	'REPTYPE'
	and		paramdesc		=	@rpttype
	and		langid			=	@ctxt_language
	and		paramcategory	= 	'COMBO'	--13h120_prjrep_00003
	
	SELECT @all_tmp = 'ALL' 

	declare @customer_res1 udd_statuscode,@customer1 udd_statuscode,@self_res1  udd_statuscode
			,@self1  udd_statuscode,@contractor_res1 udd_statuscode,@contractor1 udd_statuscode
			,@self_res2  udd_statuscode,@self2  udd_statuscode	-- code added for ITS ID: ES_PRJREP_00077
	if @customer_res	=	1
		select  @customer_res1 = 'CU'--13h120_prjrep_00003
	else
		select  @customer_res1 = 'x'

	if @customer	=	1
		select  @customer1 = 'CU'	--13h120_prjrep_00003	
	else
		select  @customer1 = 'x'
	
	if @self_res	=	1 or (@rpttype_cd /*= 'S'*/in ('S','BS')/*EPE-55557*/ and @self_res = '0')
		select  @self_res1 = 'SE',@self_res2	=	'SWE'--13h120_prjrep_00003 -- code added for ITS ID:ES_PRJREP_00077
	else
		select  @self_res1 = 'x',@self_res2	=	'X'-- code added for ITS ID:ES_PRJREP_00077

	if @self	=	1 or (@rpttype_cd /*= 'S'*/in ('S','BS')/*EPE-55557*/ and @self = '0')
		select  @self1 = 'SE',@self2	=	'SWE'--13h120_prjrep_00003 --ES_PRJREP_00077
	else
		select  @self1 = 'x',@self2 = 'x'

	if @contractor_res = 1
		select @contractor_res1 = 'CO'--13h120_prjrep_00003
	else
		select  @contractor_res1= 'x'

	if @contractor = 1
		select @contractor1 = 'CO'--13h120_prjrep_00003
	else
		select  @contractor1= 'x'

	if @rpttype_cd = 'D'
		select @Detailed = 1
	else
		select @Detailed = 0
	
	--DECLARE @prjsubprjcode_hdr_tmp  udd_unitcode-- commented for SCRA Validations exceptions in id EPE-82815
	DECLARE @time_uom               udd_uomcode
	DECLARE @ctxt_language_tmp      udd_ctxt_language
	DECLARE @summaryact             udd_desc20
	--DECLARE @revision_tmp     udd_number-- commented for SCRA Validations exceptions in id EPE-82815
	DECLARE @ctxt_ouinstance_tmp    udd_ctxt_ouinstance
	--DECLARE @projectcode_tmp        udd_unitcode-- commented for SCRA Validations exceptions in id EPE-82815
	--DECLARE @fprowno_tmp            udd_rowno-- commented for SCRA Validations exceptions in id EPE-82815
	DECLARE @lo_tmp                 udd_loid
	DECLARE @SLNO                   udd_number,@subcon  udd_desc255
	
	--temporary and formal parameters mapping  
	
	SELECT @ctxt_ouinstance_tmp = @ctxt_ouinstance 
	SELECT @ctxt_language_tmp = @ctxt_language
	
	--declaration of task temporary table 
	
	SET @slno = 0
	
	SELECT @time_uom		= paramdesc
	FROM   component_metadata_table(NOLOCK)
	WHERE  componentname	= 'PRJDET'
	AND    paramcategory	= 'COMBO'
	AND    paramtype		= 'TUOM'
	AND    paramcode		= 'H'
	AND    langid			= @ctxt_language_tmp
	
	SELECT @summaryact		= paramdesc
	FROM   component_metadata_table(NOLOCK)
	WHERE  componentname	= 'PRJDET'
	AND    paramcategory	= 'COMBO'
	AND    paramtype		= 'SUMMARY'
	AND    paramcode		= 'N'
	AND    langid			= @ctxt_language_tmp	
	
	SELECT @subcon			= paramcode
	FROM component_metadata_table(NOLOCK)
	WHERE  componentname	= 'PRJDET'
	AND    paramcategory	= 'COMBO'
	AND    paramtype		= 'SUBCON'
	AND	   paramdesc		= @subcontracted
	AND    langid			= @ctxt_language_tmp	
	
	--code added for ES_PRJREP_00039 starts
	if @subcon = 'AL'
		select @subcon = '%'	
	--code added for ES_PRJREP_00039 ends	
	
	declare	@companycode	fin_companycode
	
	SELECT @companycode = company_code
	FROM   emod_lo_bu_ou_vw	(NOLOCK)
	WHERE  ou_id = @ctxt_ouinstance_tmp

	if charindex('-',@constrngrp )<> 0
		select @constrngrp = substring(@constrngrp,1,charindex(' - ',@constrngrp)-1)
	
	/*Code modified for ES_PRJREP_00059 begins here*/
	Create table #congrp_tmp
	(congrp_tm				nvarchar(255)  collate database_default,
	 guid2					nvarchar(70)  collate database_default,
	 ou_id					nvarchar(10)  collate database_default,
	 consdesc				nvarchar(2000)  collate database_default,
	 cons_taskgrp			nvarchar(70)  collate database_default
	 )

	Create Clustered Index prjrep_congrp_ndx on #congrp_tmp(guid2)

	Create table #subprj_tmp
	(subprj				nvarchar(255)  collate database_default,
	 guid1				nvarchar(70)  collate database_default,
	 ou_id1				nvarchar(10)  collate database_default) 

	Create Clustered Index subprjix on #subprj_tmp(guid1)
	--SP analyser exception
	Create table #level
	(ou				int,
	 prj_code		nvarchar(70)  collate database_default,
	 wbs			nvarchar(70)  collate database_default,
	 par_wbs		nvarchar(70)  collate database_default,
	 count1			int,
	 act_code		nvarchar(70)  collate database_default,
	 wrk_area		nvarchar(70)  collate database_default
	 )
	 
	--SP analyser exception
	select @guid1	=	newid()
	
	--Insert into #congrp_tmp(congrp_tm,guid2,ou_id,consdesc)
	--Select distinct prjmst_code_code,@guid1,prjmst_code_ou,prjmst_code_codedesc 
	--from  prjmst_activity_hdr (nolock),
	--	   prjmst_code_mst (nolock)--,
	--	   --prjmst_prj_user_mappings(nolock)
	--where  prjmst_code_codetyp	   = 'CG'	
	--AND    prjmst_act_hdr_actou  = prjmst_code_ou   
	--AND    prjmst_act_hdr_consgrp  = prjmst_code_code
	----AND	   prjmst_code_ou		   = prjuam_prjou
	--AND    prjmst_code_ou    = @ctxt_ouinstance_tmp
	----AND    prjuam_prjou	     = @ctxt_ouinstance_tmp
	----AND	   prjmst_code_code	 = prjuam_prjcode
	----AND	   prjuam_userid	 = @ctxt_user		
	----AND	   prjuam_cat			   = 'CG'
	----AND	   prjuam_rights	 = 'Y'
	--AND	   prjmst_code_code	 like @constrngrp
	
	Insert into #congrp_tmp(congrp_tm,guid2,ou_id,consdesc,cons_taskgrp)
	Select distinct tsk.prjmst_code_work_group,@guid1,cons.prjmst_code_ou,cons.prjmst_code_codedesc,tsk.prjmst_code_code 
	from   prjmst_code_mst tsk (nolock),
		   prjmst_code_mst cons (nolock)
	where  tsk.prjmst_code_codetyp		=	'AG'	
	AND    tsk.prjmst_code_ou			= 	@ctxt_ouinstance_tmp
	AND	   tsk.prjmst_code_work_group	like @constrngrp		
	and	   cons.prjmst_code_codetyp		=   'CG'	
	AND    cons.prjmst_code_code		=   tsk.prjmst_code_work_group 
	AND	   TSK.prjmst_code_code IN	(
										SELECT	prjmst_act_hdr_actgrp	
										from	prjmst_activity_hdr (nolock),
												prjdet_taskwork_taskdtl (nolock)
										WHERE	taskwork_task_prjou			=	@ctxt_ouinstance_tmp
										AND		taskwork_task_prjcode		=	@projectcodefrom
										aND		prjmst_act_hdr_actcode		=	taskwork_task_taskcode
										AND		prjmst_act_hdr_basis		=	''
										AND		prjmst_act_hdr_actou		=	taskwork_task_prjou
									)	
	/*Code modified for ES_PRJREP_00059 ends here*/									

	
	--13H120_PRJREP_00012 starts
	declare	@sale_area	udd_value,
			@basis		udd_documentno
	
	select	@sale_area		=	prjhdr_sale_area,
			@basis			=	prjhdr_basis
	from	prjdef_prj_hdr(nolock)
	where	prjhdr_prjou	= @ctxt_ouinstance_tmp
	and		prjhdr_prjcode	= @projectcodefrom 
	and		prjhdr_company	= @companycode
	and		prjhdr_max_amendno_flag	=	'Y'
	
	--13H120_PRJREP_00012 ends
	
	if exists (	select 'x' 
				from  prjdef_prj_hdr(nolock)
				where prjhdr_prjou		= @ctxt_ouinstance_tmp
				and   prjhdr_prjcode	= @projectcodefrom 
				/*Code modified for 13H120_PRJREP_00003 begins here*/
				--13H120_PRJREP_00003 starts
				and   prjhdr_dtl_reqd	= 'N'
--				and   prjhdr_dtl_reqd	= 'Y'
				--13H120_PRJREP_00003 ends
				/*Code modified for 13H120_PRJREP_00003 begins here*/
				and	  prjhdr_company	= @companycode	)
	begin	
		insert into #subprj_tmp(subprj,guid1,ou_id1)
		select  prjhdr_prjcode,@guid,prjhdr_prjou
		from	prjdef_prj_hdr a(nolock)
		where	prjhdr_prjou	=	@ctxt_ouinstance_tmp
		and     prjhdr_parent	=	@projectcodefrom 
		/*Code modified for 13H120_PRJREP_00003 begins here*/
--		and		prjhdr_dtl_reqd	=	'Y'	
		and   prjhdr_dtl_reqd	= 'N'
		/*Code modified for 13H120_PRJREP_00003 ends here*/
		and	    prjhdr_company	=	@companycode
		and     prjhdr_amendno	= ( select max(prjhdr_amendno)
									from   prjdef_prj_hdr b(nolock)
									where  a.prjhdr_prjou   = b.prjhdr_prjou
									and    a.prjhdr_prjcode = b.prjhdr_prjcode
									and	   a.prjhdr_company	= b.prjhdr_company	)
	end
	else
	begin
		insert into #subprj_tmp(subprj,guid1,ou_id1)
		select  prjhdr_prjcode,@guid,prjhdr_prjou
		from	prjdef_prj_hdr a(nolock)
		where	prjhdr_prjou	=	@ctxt_ouinstance_tmp
		and     prjhdr_prjcode	=	@projectcodefrom
		and		prjhdr_dtl_reqd	=	'Y'	
		and	    prjhdr_company	=	@companycode
		and     prjhdr_amendno	= ( select max(prjhdr_amendno)
									from prjdef_prj_hdr b(nolock)
									where a.prjhdr_prjou = b.prjhdr_prjou
									and   a.prjhdr_prjcode = b.prjhdr_prjcode
									and	  a.prjhdr_company = b.prjhdr_company	)
	end


	 
	insert into #level	(ou,prj_code,wbs,par_wbs,count1,act_code,wrk_area) --SP analyser exception

	select	taskwork_task_prjou as ou,	taskwork_task_prjcode as prj_code,
			taskwork_task_wbsid as wbs,	taskwork_task_Parent_WBS_ID as par_wbs,
			dense_rank() over(order by taskwork_task_prjcode,taskwork_task_Parent_WBS_ID)  count1,
			taskwork_task_taskcode as act_code,	taskwork_task_workarea as wrk_area
	--into	#level--SP analyser exception
	from	prjdet_taskwork_taskdtl a(nolock),
			#subprj_tmp
	where	taskwork_task_prjcode = subprj
	and		taskwork_task_prjou = @ctxt_ouinstance_tmp
	and		taskwork_task_prjamendno = (SELECT MAX(taskwork_task_prjamendno)
										FROM   prjdet_taskwork_taskdtl b(NOLOCK)
										WHERE  a.taskwork_task_prjou   = b.taskwork_task_prjou
										AND    a.taskwork_task_prjcode = b.taskwork_task_prjcode)
	group by	taskwork_task_prjou,taskwork_task_prjcode,taskwork_task_wbsid,
				taskwork_task_prjamendno,taskwork_task_Parent_WBS_ID,taskwork_task_taskcode,taskwork_task_workarea
	
	
	insert into ProjectBOQ_act_tmp
	(
	 ACTIVITYCODE1,				ACTIVITYGRP,			ACTIVITYGRPDESC,
	 EFFORT_TSK,				HGRD_HDNACTCODE_1,		OUTPUTQTY,				
	 OUTPUTUOM,					DSROPqty,				TIMEUOM_TSK,			
	 TSK1_ACTIVITYDESC,			material_rate,			labour_rate,			
	 machine_rate,				final_price,			final_price_OH,
	 final_price_wbs,			SLNO,					itk_grid_text_01__tsk,	
	 itk_grid_text_02__tsk,		itk_grid_text_03__tsk,	itk_grid_numeric_01__tsk,
	 itk_grid_numeric_02__tsk,	rev_no,					prj_code,				
	 prj_name,					wbsid,					workarea,
	 workarea_desc,				totmtl_wst_amnt,		totres_wst_amnt,
	 mtl_res_finamnt,			act_finalamnt,			act_guid,
	 congrp,					consgrp_desc,			Activity_variant,
	 Activity_bugvalue,			Ref_itemcode,			prj_tskamendno,
	 tsk_balqty,				tsk_balvalue,			self_finamt
	)	
 	
 	--SELECT --ES_PRJREP_00059
	SELECT DISTINCT --ES_PRJREP_00059
	taskwork_task_taskcode,     p.prjmst_act_hdr_actgrp,	null,	
	--code commented and modified for ITS ID:ES_PRJREP_00056 begins
	--taskwork_task_effort,		taskwork_task_taskcode,		taskwork_task_outputqty
	case when taskwork_task_effort=0 then 1 else taskwork_task_effort end,		taskwork_task_taskcode,		taskwork_task_outputqty
	--,taskwork_task_outputuom,	isnull(taskwork_task_outputqty,taskwork_task_outputqty_act),--isnull(taskwork_task_outputqty_act,taskwork_task_outputqty), --as discussed with Mini, planned qty should be taken, if actual o/p qty is > planned qty, take tht.
	,taskwork_task_outputuom,	isnull(case when taskwork_task_outputqty = 0 then 1 else taskwork_task_outputqty end,taskwork_task_outputqty_act),
	--code commented and modified for ITS ID:ES_PRJREP_00056 ends
															taskwork_task_outputuom,    			
    NULL,					    0.0, 				       	0.0, 								
    0.0, 					   	0.0, 						0.0, 
    0.0, 						NULL,					   	ISNULL(prjmst_act_hdr_finvalue, 0),	
	ISNULL(scd_wast_val, 0),	ISNULL(scd_floor_ovhead,0),	ISNULL(scd_task_ovhead, 0),	
	ISNULL(prjmst_act_hdr_totcost,0),		 taskwork_task_prjamendno,		    taskwork_task_prjcode,
	null,						taskwork_task_wbsid,		taskwork_task_workarea, 
	null,					  	0.0,					  	0.0,
    0.0,					  	0.0,						@guid,
    prjmst_act_hdr_consgrp,		null/*consdesc*/,					/*taskwork_task_grpvariant*/null, 
	--scd_floor_ovhead,--isnull(taskwork_task_execvalue,0)	+	isnull(taskwork_task_balvalue,0),
	taskwork_task_TaskCost,
								(taskwork_task_taskcode+'/'+taskwork_task_wbsid)/*taskwork_task_field5*/,		
															taskwork_task_prjamendno,
	taskwork_task_outputqty,/*taskwork_task_balqty,*/
								/*taskwork_task_balvalue*//*null*/
	--As discussed with Mini planned qty and planned cost were inserted in these columns 
								taskwork_task_TaskCost,		0.0
	FROM   prjdet_taskwork_taskdtl a(NOLOCK),
			prjmst_activity_hdr	p (NOLOCK)
			/*Code added for ES_PRJREP_00059 begins here*/
		--	INNER JOIN #congrp_tmp tm	(nolock) --code commented for LNG-130
		left outer JOIN #congrp_tmp tm	(nolock)  --code added for LNG-130
			ON	(cons_taskgrp				=	prjmst_act_hdr_actgrp
			)
			/*Code added for ES_PRJREP_00059 ends here*/
			left outer join pdt_spec_coeff_dtl d (NOLOCK)
			on
			(
					d.scd_ou			=	@ctxt_ouinstance_tmp
			AND	   d.scd_basproj	=	@projectcodefrom--taskwork_task_prjcode
			and	   d.scd_app_on		=	'WBS'
			and		((	 scd_app_at	=	'PR' and	scd_code	=	@projectcodefrom/*taskwork_task_prjcode*/)
				or	(scd_app_at =	'TG'  and	scd_code	=	prjmst_act_hdr_actgrp)
				/*Code modified for ES_PRJREP_00059 begins here*/
				--or	(scd_app_at	=	'WG'  and	scd_code	=	prjmst_act_hdr_consgrp)
				or	(scd_app_at	=	'WG'  and	scd_code	=	tm.congrp_tm)
				/*Code modified for ES_PRJREP_00059 ends here*/
				or	(scd_app_at	=	'WBS' and	scd_code	=	prjmst_act_hdr_actcode/*taskwork_task_taskcode*/	/*and		scd_itres_code	=	''*/)
				) 
				and		d.scd_type		= 'PRJ_PRJ' --code added by vasantha A for ES_PRJDEF_00258	
			),
	       --#congrp_tmp tm	(nolock),
		   #subprj_tmp,
		   #level--,
		   --pdt_spec_coeff_dtl d  (NOLOCK),
		   --prjmst_activity_hdr p (NOLOCK)
	WHERE  taskwork_task_prjou		= @ctxt_ouinstance_tmp
	AND    taskwork_task_prjcode	= subprj
	AND    taskwork_task_prjamendno = 
		   (
	           SELECT MAX(taskwork_task_prjamendno)
	           FROM   prjdet_taskwork_taskdtl	  b	(NOLOCK)
	           WHERE  a.taskwork_task_prjou		= b.taskwork_task_prjou
	           AND    a.taskwork_task_prjcode	= b.taskwork_task_prjcode
			   and	  a.taskwork_task_taskid	= b.taskwork_task_taskid
			   and	  a.taskwork_task_taskcode	= b.taskwork_task_taskcode	
			   --and	  a.taskwork_task_consgrp	= b.taskwork_task_consgrp
	       )
	--AND    d.scd_ou			=	@ctxt_ouinstance_tmp
	--AND	   d.scd_basproj	=	taskwork_task_prjcode
	--AND	   d.scd_amend_no	=	taskwork_task_prjamendno
	AND	   p.prjmst_act_hdr_actou	=	taskwork_task_prjou--d.scd_ou
	AND	   p.prjmst_act_hdr_actcode	=	a.taskwork_task_taskcode
	--and	   d.scd_app_on		=	'WBS'
	--and		((	 scd_app_at	=	'PR' and	scd_code	=	taskwork_task_prjcode)
	--		or	(scd_app_at =	'TG'  and	scd_code	=	prjmst_act_hdr_actgrp)
	--		or	(scd_app_at	=	'WG'  and	scd_code	=	prjmst_act_hdr_consgrp)
	--		or	(scd_app_at	=	'WBS' and	scd_code	=	taskwork_task_taskcode	/*and		scd_itres_code	=	''*/)
	--		) 
	--AND	   a.taskwork_task_subcon   =	@subcon --code commented for ES_PRJREP_00039
	AND	   a.taskwork_task_subcon   like	@subcon --code added for ES_PRJREP_00039
	AND	   a.taskwork_task_workarea	  like	  @workarea	
	AND	   --a.taskwork_task_taskcode   between isnull(@actcodefrom,a.taskwork_task_taskcode) and isnull(@actcodeto,a.taskwork_task_taskcode)
		   a.taskwork_task_taskcode >=	isnull(@actcodefrom,a.taskwork_task_taskcode) 
	and	   a.taskwork_task_taskcode	<= 	isnull(@actcodeto,a.taskwork_task_taskcode)
	--AND	   isnull(a.taskwork_task_grpvariant,'') between isnull(@activitygroupvariantfrom,isnull(a.taskwork_task_grpvariant,'')) and isnull(@activitygroupvariantto,isnull(a.taskwork_task_grpvariant,'')) ---DLF_AMC_CR_CR-384_00007
	AND	   --p.prjmst_act_hdr_actgrp 	  between isnull(@actgrpfrom,p.prjmst_act_hdr_actgrp) and isnull(@actgrpto ,p.prjmst_act_hdr_actgrp)
			p.prjmst_act_hdr_actgrp >=  isnull(@actgrpfrom,p.prjmst_act_hdr_actgrp) 
	and		p.prjmst_act_hdr_actgrp	<=	isnull(@actgrpto ,p.prjmst_act_hdr_actgrp)
	--AND	   prjmst_act_hdr_consgrp	= tm.congrp_tm	
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
	
	/* code commented for dts :13H120_Masters_00007:ES_Masters_00085 */
	/*and		isnull(p.prjmst_act_hdr_tasksubgroup,'') >=isnull(@tasksubgroupfrom,isnull(p.prjmst_act_hdr_tasksubgroup,''))
	 and		isnull(p.prjmst_act_hdr_tasksubgroup,'') <=isnull(@tasksubgroupto,isnull(p.prjmst_act_hdr_tasksubgroup,''))*/
	/* code commented for dts :13H120_Masters_00007:ES_Masters_00085 */
	
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
	/*Code modified for ES_PRJREP_00049 begins here */
	--and	   prjmst_act_hdr_basis	=		@basis			
	and	   prjmst_act_hdr_basis	=		''	
	/*Code modified for ES_PRJREP_00049 ends here */
	AND	   guid1					= @guid
	AND    ou_id1					= taskwork_task_prjou 
	AND	   ou						= taskwork_task_prjou
	AND	   prj_code					= taskwork_task_prjcode
	AND	   act_code					= taskwork_task_taskcode
	AND	   wrk_area					= taskwork_task_workarea
	AND	   wbs						= taskwork_task_wbsid	
	AND	   count1					like @level
	/*Code modified for ES_PRJREP_00059 begins here*/
	--and	   prjmst_act_hdr_consgrp like	@constrngrp--code added for ITS ID:ES_PRJREP_00041
	--code commneted and addded for LNG-130
	--and	   tm.congrp_tm				like	@constrngrp
	--and	   guid2					=	@guid1
	--and	   ou_id					=	ou
	--and	   cons_taskgrp				=	prjmst_act_hdr_actgrp	
	--code commneted and added for LNG-130
	/*Code modified for ES_PRJREP_00059 ends here*/
	
	/* code added for dts id :  13H120_Masters_00007: ES_Masters_00077 begins */
	update  tmp
	set		tsk_subgroup		=  prjmst_act_hdr_tasksubgroup
	from	prjmst_activity_hdr(nolock),
			ProjectBOQ_act_tmp tmp(NOLOCK)
	where	prjmst_act_hdr_actou		=	@ctxt_ouinstance_tmp
	and		prjmst_act_hdr_actcode		=	ACTIVITYCODE1
	AND	   act_guid						=	@guid
	/* Code modified for dts;  13H120_Masters_00007: ES_Masters_00085 begins */
	--and		prjmst_act_hdr_basis	= @basis 
	and		prjmst_act_hdr_basis	= ''
	/* Code modified for dts;  13H120_Masters_00007: ES_Masters_00085 ends */
	
	/*Code modified for ES_PRJREP_00049 begins here*/
	update	tmp
	set		congrp					=	prjmst_code_work_group
	from	ProjectBOQ_act_tmp tmp,
			prjmst_code_mst(nolock)
	where	act_guid				=	@guid
	and		ACTIVITYGRP				=	prjmst_code_code
	and		prjmst_code_ou			=	@ctxt_ouinstance_tmp
	and		prjmst_code_codetyp		=	'AG'	
	/*Code modified for ES_PRJREP_00049 ends here*/		
	
	/*  code commented for dts :13H120_Masters_00007:ES_Masters_00085 begins */
	/*update  tmp
	set		tsk_subgroup	= prjmst_code_codedesc
	from	prjmst_code_mst(nolock),
			ProjectBOQ_act_tmp tmp	(NOLOCK)
	where	prjmst_code_code	=	tsk_subgroup
	AND     prjmst_code_ou 		=	@ctxt_ouinstance
	AND	   act_guid				=	@guid
	and		prjmst_code_codetyp	=	'TSG'*/
	/*  code commented for dts :13H120_Masters_00007:ES_Masters_00085 ends */
	
	/* code added for dts id :  13H120_Masters_00007: ES_Masters_00077  ends*/
	
		
	--as discussed with Mini, planned qty should be taken, if actual o/p qty is > planned qty, take tht.
	update	tmp 
	set		DSROPqty	    =	taskwork_task_outputqty_act
	from	ProjectBOQ_act_tmp	tmp,
			prjdet_taskwork_taskdtl	
	where	tmp.act_guid	=	@guid
	and		tmp.prj_code	=	@projectcodefrom
	and		taskwork_task_prjcode	=	tmp.prj_code
	and		taskwork_task_taskcode	=	ACTIVITYCODE1
	and		wbsid			=	taskwork_task_wbsid
	and		isnull(taskwork_task_outputqty_act,0)	>	isnull(taskwork_task_outputqty,0)

	--EPE-43862 starts
	update	tmp
	set		chart_category		=	Pjp_Prjct_category,
			@sale_area			=	case when Pjp_Prjct_category = 'COMMERCIAL' 
										then Pjp_Prjct_leaseablearea else Pjp_Prjct_Sal_Area end
	from	ProjectBOQ_act_tmp tmp
	join	prjdef_prj_hdr(nolock)
	on		tmp.prj_code		=	prjhdr_prjcode
	and		prjhdr_prjou		=	@ctxt_ouinstance_tmp
	and		prjhdr_max_amendno_flag	=	'Y'
	join	prjproposal_hdr(nolock)
	on		prjhdr_refpropID	=	mtprp_proposalid
	and		prjhdr_prjou		=	mtprp_ouid
	join	PJP_Proj_Plan_Hdr(nolock)
	on		mtprp_prjincepid	=	Pjp_Prjct_Code
	and		mtprp_ouid			=	Pjp_Prjct_TranOU
	and		Pjp_Prjct_stage		=	'C'
	Where	tmp.act_guid		=	@guid
	and		tmp.prj_code		=	@projectcodefrom
	--EPE-43862 ends

	--EPE-64115 starts
	Update	tmp
	set		tskgrppream			=	wrkprj_map_preambles
	FROM	ProjectBOQ_act_tmp	tmp,
			prjcvl_tg_proj_map(nolock)
	Where	act_guid			=	@guid
	and		wrkprj_map_ou		=	@ctxt_ouinstance_tmp
	and		wrkprj_map_proj_code=	@projectcodefrom
	and		wrkprj_map_tg		=	ACTIVITYGRP		

	UPDATE	tmp
	SET		tskcodepream		=	prjmst_Remarks3 
	FROM	ProjectBOQ_act_tmp	tmp,
			prjmst_activity_hdr(nolock)
	Where	act_guid			=	@guid
	and		prjmst_act_hdr_actcode	=	ACTIVITYCODE1
	and		prjmst_act_hdr_actou	=	@ctxt_ouinstance_tmp

	UPDATE	tmp
	SET		taskcommtask_desc		=	prjmst_code_codedesc
	FROM	ProjectBOQ_act_tmp tmp,
			prjmst_activity_hdr(nolock),
			prjmst_code_mst(nolock)
	Where	act_guid				=	@guid
	and		prjmst_act_hdr_ctdcode	=	prjmst_code_code
	and		prjmst_act_hdr_actou	=	prjmst_code_ou
	and		prjmst_code_codetyp		=	'CTD'
	and		prjmst_act_hdr_actcode	=	ACTIVITYCODE1
	and		prjmst_act_hdr_actou	=	@ctxt_ouinstance_tmp

	UPDATE	tmp
	SET		tsksubgrpdesc		=	case when isnull(tsg.prjmst_code_lngdesc,'') = '' then tsg.prjmst_code_codedesc else tsg.prjmst_code_lngdesc end
	FROM	ProjectBOQ_act_tmp	tmp,
			prjmst_code_mst tsg(nolock)
	Where	act_guid			=	@guid
	and		ACTIVITYGRP			=	tsg.prjmst_code_work_group
	and		tsk_subgroup		=	tsg.prjmst_code_code	
	and		tsg.prjmst_code_ou	=	@ctxt_ouinstance_tmp
	and		tsg.prjmst_code_codetyp	=	'TSG'
	
	UPDATE	tmp
	SET		tsksubgrppream		=	wrkprj_map_preambles
	FROM	ProjectBOQ_act_tmp tmp,
			prjcvl_tg_proj_map(nolock)
	Where	act_guid			=	@guid
	and		wrkprj_map_ou		=	@ctxt_ouinstance_tmp
	and		wrkprj_map_proj_code=	@projectcodefrom
	and		wrkprj_map_tsg		=	tsk_subgroup + '(' + ACTIVITYGRP+ ')'
	--EPE-64115 ends

	create table #insertratesplitup
		/*Code modified for ES_PRJREP_00059 begins here*/
	(	taskcode		nvarchar(70) collate database_default	,	taskgrp		nvarchar(70) collate database_default	,	projcode	nvarchar(70)	 collate database_default,
		wbsid			nvarchar(70) collate database_default,	workarea	nvarchar(70) collate database_default,	Consgrp		nvarchar(70) collate database_default,
		prjtskamend		int,			rate		numeric(28,8),	qty			numeric(28,8),
		amount			numeric(28,8),	qtytype		nvarchar(15) collate database_default,	/* actdesc		nvarchar(2000),*/actdesc		nvarchar(4000) collate database_default,--es_masters_00072
		actgrpdesc		nvarchar(2000) collate database_default,	consgrpdesc	nvarchar(2000) collate database_default,	prjdesc		nvarchar(2000) collate database_default,
		actvariantdesc	nvarchar(2000) collate database_default,	workareadesc nvarchar(2000) collate database_default,	actvariant	nvarchar(70) collate database_default,
		uom				nvarchar(25) collate database_default,	tsk_subgroup nvarchar(2000) collate database_default --13H120_Masters_00007: ES_Masters_00077
		,category		varchar(20)		--EPE-43862
		,SCReqstqty		numeric(28,8)	--EPE-55557
		,tskgrppream	nvarchar(max)	,tskcodepream	nvarchar(max)		,tsksubgrpdesc	nvarchar(max)		,tsksubgrppream		nvarchar(max)		--EPE-64115
		,taskcommtask_desc		nvarchar(max)			--EPE-64115
	)
		/*Code modified for ES_PRJREP_00059 ends here*/
	--code need to be uncommented once prjdpr_dt_billedqty is added to PPR table starts. 
	--insert into #insertratesplitup
	--(
	--	taskcode	,	taskgrp		,	projcode ,
	--	wbsid		,	workarea	,	Consgrp	 ,
	--	prjtskamend	,	rate		,	qty		 ,
	--	qtytype	
	--)
	--select  acttmp.ACTIVITYCODE1	,	acttmp.ACTIVITYGRP	,	acttmp.prj_code	,
	--		acttmp.wbsid			,	acttmp.workarea		,	acttmp.congrp	,
	--		hdr.prjdpr_hdr_prjtskamdno,	dtl.prjdpr_dt_itmrate,	/*sum(dtl.prjdpr_dt_billedqty)*/ null Qty,
	--		'Executed'
	--from	ProjectBOQ_act_tmp acttmp(nolock)
	--join	prj_ppr_dtl	/*prjexec_dpr_detail*/ dtl(nolock)
	--on		dtl.ppr_ouid	=	@ctxt_ouinstance_tmp
	----and		dtl.prjdpr_dt_projcode	=	acttmp.prj_code
	--and		dtl.prjdpr_itemcode		=	acttmp.Ref_itemcode
	--join	prj_ppr_hdr /*prjexec_dpr_hdr	*/hdr(nolock)
	--on		hdr.ppr_ouid		=	dtl.ppr_ouid
	--and		hdr.ppr_dprno		=	dtl.ppr_dprno
	--and		hdr.ppr_prjcode		=	acttmp.prj_code
	--and		hdr.ppr_status		=	'CF'
	--where	acttmp.act_guid		=	@guid
	--and		hdr.ppr_ouid		=	@ctxt_ouinstance_tmp
	--and		hdr.ppr_prjcode		=	@projectcodefrom
	--group by acttmp.ACTIVITYCODE1	,	acttmp.ACTIVITYGRP	,	acttmp.prj_code	,
	--		acttmp.wbsid			,	acttmp.workarea		,	acttmp.congrp	,
	--		hdr.prjdpr_hdr_prjtskamdno,	dtl.prjdpr_dt_itmrate
	--code need to be uncommented once prjdpr_dt_billedqty is added to PPR table end. 

	insert into #insertratesplitup
	(
		taskcode	,	taskgrp		,	projcode ,
		wbsid		,	workarea	,	Consgrp	 ,
		prjtskamend	,	rate		,	qty		 ,
		qtytype,		tsk_subgroup--13H120_Masters_00007:ES_Masters_00077
	)
	select  acttmp.ACTIVITYCODE1	,	acttmp.ACTIVITYGRP	,	acttmp.prj_code	,
			acttmp.wbsid			,	acttmp.workarea		,	acttmp.congrp	,
			acttmp.prj_tskamendno	,	
			(ISNULL(acttmp.tsk_balvalue,0)/(case when ISNULL(acttmp.tsk_balqty,0) = 0 then 1 else ISNULL(acttmp.tsk_balqty,0) end)) RATE,	
			ISNULL(acttmp.tsk_balqty,0),	'UEX',	tsk_subgroup	--13H120_Masters_00007:ES_Masters_00077
	from	ProjectBOQ_act_tmp acttmp(nolock)
	where	acttmp.act_guid		=	@guid
	and		acttmp.prj_code		=	@projectcodefrom
	
	Delete	from #insertratesplitup
	where	qty =0

	update	tmp
	Set		Rate	=	taskwork_task_field6
	From	#insertratesplitup	tmp	(nolock),
			prjdet_taskwork_taskdtl	a	(NOLOCK)
	Where	taskwork_task_prjcode	=	projcode
	and		taskwork_task_prjamendno=	prjtskamend
	and		taskwork_task_taskcode	=	taskcode
	and		taskwork_task_wbsid		=	wbsid
    and		taskwork_task_workarea	=	workarea
	and		qty						=	0

	--EPE-55557 starts
	update	tmp
	Set		SCReqstqty	=	reqdqty
	From	#insertratesplitup	tmp	(nolock),
			(select sum(scrit_reqdqty) 'reqdqty',projcode 'prjcode', wbsid 'wbs'
			from	#insertratesplitup 
			join	scr_scrit_item_detail	(NOLOCK)
			on		scrit_ref_doc		=	projcode
			and		scrit_wbsid			=	wbsid
			join	scr_scrqm_screquest_hdr(nolock)
			on		scrqm_scrou			=	scrit_scrou
			and		scrqm_scrno			=	scrit_scrno
			Where	scrqm_status	not in ('CA','DE')
			and		scrit_referencetype = 'PRJ'
			group by projcode,wbsid) xy
	Where	projcode			=	prjcode
	and		wbsid				=	wbs
	--EPE-55557 ends

	update #insertratesplitup
	set		amount	=		rate	*	qty		

	update	tmp
	set		OUTPUTUOM	=	mas_uomdesc
	from	uom_mas_uommaster(NOLOCK),
			ProjectBOQ_act_tmp tmp(NOLOCK)
	where	act_guid	=	@guid
	AND     mas_uomcode =	OUTPUTUOM
	and		mas_ouinstance	=	@ctxt_ouinstance_tmp

	update  tmp
	set		prj_name		=  prjhdr_prjname	
	from	prjdef_prj_hdr a(nolock),
			ProjectBOQ_act_tmp tmp(NOLOCK)
	where	prjhdr_prjcode		=  prj_code
	and		prjhdr_prjou	    =  @ctxt_ouinstance_tmp
	and		prjhdr_amendno		=  (select	max(prjhdr_amendno)
									from	prjdef_prj_hdr b(nolock)
									where	a.prjhdr_prjcode = b.prjhdr_prjcode
									and		a.prjhdr_prjou = b.prjhdr_prjou)
	and     act_guid			=	@guid

	update  tmp
	set		ACTIVITYGRPDESC		=  prjmst_code_codedesc	--isnull(prjmst_code_aglongdesc,prjmst_code_codedesc)
	from	prjmst_code_mst(nolock),
			ProjectBOQ_act_tmp tmp(NOLOCK)
	where	prjmst_code_code	=  ACTIVITYGRP
	and		prjmst_code_ou	    =  @ctxt_ouinstance_tmp
	and     act_guid			=  @guid
	and		prjmst_code_codetyp	=  'AG'

	--Activity Group variant is not applicable to BASE so code commented.,
	--update  tmp
	--set		variant_description	=  isnull(prjmst_code_codedesc,'')--+ ' '+ isnull(prjmst_code_aglongdesc,'')
	--select distinct prjmst_code_codetyp from	prjmst_code_mst(nolock),
	--		ProjectBOQ_act_tmp tmp(NOLOCK)
	--where	prjmst_code_code	=  Activity_variant
	--and		prjmst_code_ou	    =  @ctxt_ouinstance_tmp
	--and     act_guid			=  @guid

	update  tmp
	set		TSK1_ACTIVITYDESC			= isnull(prjmst_act_ml_actdesc,'')
	from	prjmst_activity_multilang	task	(NOLOCK),
			ProjectBOQ_act_tmp	tmp	(NOLOCK)
	where	task.prjmst_act_ml_actou	= @ctxt_ouinstance_tmp 
	AND     tmp.ACTIVITYCODE1			= task.prjmst_act_ml_actcode
	AND     task.prjmst_act_ml_langid	= @ctxt_language_tmp
	and     act_guid					= @guid
	
	--
	--update  tmp
	--set		TSK1_ACTIVITYDESC	= isnull(prjmst_boq_ml_actdesc,'')
	--from	prjmst_boq_activity_multilang task(NOLOCK),
	--		ProjectBOQ_act_tmp tmp(NOLOCK)
	--where	task.prjmst_boq_ml_actlo = @lo_id 
	--AND     tmp.ACTIVITYCODE1 = task.prjmst_boq_ml_actcode
	--AND     task.prjmst_boq_ml_langid = @ctxt_language_tmp
	--and     act_guid			=  @guid
		
	update  tmp
	set		workarea_desc	=  isnull(wrkar_mst_desc,'')
	from	prjcvl_workarea_mst(nolock),
			ProjectBOQ_act_tmp tmp(NOLOCK)
	where	workarea		=  wrkar_mst_code
	and		wrkar_mst_ou	=  @ctxt_ouinstance_tmp
	and     act_guid		=  @guid
		
	SELECT	@lo_tmp = lo_id
	FROM	emod_lo_bu_ou_vw(NOLOCK)
	WHERE	ou_id   = @ctxt_ouinstance_tmp
	
	--material details starts
	/*Code modified for 13H120_PRJREP_00003 begins here*/
	INSERT INTO	projectboq_mtl_tmp (
			taskcode,						Item_Name,
			varinat,						item_desc,
			Quantity,						Rate,
			Base_Rate,						tot_base_amnt,
			Itk_Coefficient_Wastage,		Itk_Coefficient_FloorOH,
			Itk_Coefficient_Overhead,		rev_no1,
			prj_code1,						ACTIVITYGRP1,
			wbsid1,							workarea1,						
			own1,							OUTPUTQTY1,
			act_OUTPUTQTY1,					mtl_final_rate,				
			mtl_guid,						congrp,							
			FOH_flag,						Activity_variant,
			taxcal,							Mtl_uom,
			tsk_subgroup--13H120_Masters_00007:ES_Masters_00077
			)
	SELECT	taskwork_mtlreq_taskcode,			taskwork_mtlreq_itemcode,				
			taskwork_mtlreq_vari_code,			null,						
--			ISNULL(a.taskwork_mtlreq_totqty, 0),	ISNULL(taskwork_mtlreq_rateper,0),		
--			ISNULL(a.taskwork_mtlreq_totqty, 0) * ISNULL(taskwork_mtlreq_rateper, 0), 0.0,
			ISNULL(a.taskwork_mtlreq_qty, 0),	ISNULL(taskwork_mtlreq_rateper,0),
			--code modified by vasantha a for LNG-183 begins		
			--ISNULL(a.taskwork_mtlreq_qty, 0) * ISNULL(taskwork_mtlreq_rateper, 0), 0.0,
			ISNULL(a.taskwork_mtlreq_qty, 0) * ISNULL(taskwork_mtlreq_rateper, 0),ISNULL(a.taskwork_mtlreq_qty, 0) * ISNULL(taskwork_mtlreq_rateper, 0),
			--code modified by vasantha a for LNG-183 ends
--										0.0,						ISNULL(d.scd_wast_val, 0),
			ISNULL(d.scd_wast_per, 0),	  	ISNULL(d.scd_floor_ovhead, 0),
		  	ISNULL(d.scd_task_ovhead,0),	taskwork_mtlreq_prjamend,
			taskwork_mtlreq_prjcode,		taskwork_mtlreq_taskgrp,		
			taskwork_task_wbsid,			taskwork_mtlreq_workarea,		
			taskwork_mtlreq_ownership,		0.0,
			isnull(taskwork_task_outputqty,taskwork_task_outputqty_act), taskwork_mtlreq_finval,--isnull(taskwork_task_outputqty_act,taskwork_task_outputqty), --as discussed with Mini, planned qty should be taken, if actual o/p qty is > planned qty, take tht.
			@guid,							prjmst_act_hdr_consgrp,			
			scd_ovh_basis,					null,
			null,							taskwork_task_outputuom  
	/*Code modified for 13H120_PRJREP_00003 ends here*/ 
			,prjmst_act_hdr_tasksubgroup       --13H120_Masters_00007:ES_Masters_00077                                  
	FROM   prjdet_taskwork_mtlreq		a	(NOLOCK),
		   prjdet_taskwork_taskdtl	tak	(nolock),
		   --code modified by vasantha a for LNG-183 begins
		   --#congrp_tmp				tm	(nolock),--ES_PRJREP_00059
		   prjmst_activity_hdr	p (NOLOCK)
		   	left outer JOIN #congrp_tmp tm	(nolock)  --code added for LNG-130
			ON	(cons_taskgrp				=	prjmst_act_hdr_actgrp
			)
			left outer join pdt_spec_coeff_dtl d (NOLOCK)
			on
			(
					d.scd_ou			=	@ctxt_ouinstance_tmp
			AND	   d.scd_basproj	=	@projectcodefrom
			and	   d.scd_app_on		=	'WBS'
			and		((	 scd_app_at	=	'PR' and	scd_code	=	@projectcodefrom)
				or	(scd_app_at =	'TG'  and	scd_code	=	prjmst_act_hdr_actgrp)
					or	(scd_app_at	=	'WG'  and	scd_code	=	tm.congrp_tm)
				or	(scd_app_at	=	'WBS' and	scd_code	=	prjmst_act_hdr_actcode)
				) 
				and		d.scd_type		= 'PRJ_PRJ' 
			),
		   --code modified by vasantha a for LNG-183 ends
		   #subprj_tmp,
		   #level--,
		    --code commented by vasantha a for LNG-183 begins
		   --pdt_spec_coeff_dtl d  (NOLOCK),
		   --prjmst_activity_hdr			(nolock)
		    --code modified by vasantha a for LNG-183 ends
	WHERE  taskwork_mtlreq_prjou			=	@ctxt_ouinstance_tmp
	AND	   taskwork_mtlreq_prjcode	=	subprj
	AND	   a.taskwork_mtlreq_prjou		=	tak.taskwork_task_prjou
	AND	   a.taskwork_mtlreq_prjcode	=	tak.taskwork_task_prjcode	
	AND	   a.taskwork_mtlreq_taskcode  =	tak.taskwork_task_taskcode
	and	   prjmst_act_hdr_actou		=	tak.taskwork_task_prjou
	and	   prjmst_act_hdr_actcode 	=	tak.taskwork_task_taskcode
	AND	   a.taskwork_mtlreq_taskgrp   =	prjmst_act_hdr_actgrp
	AND	   a.taskwork_mtlreq_workarea	=	tak.taskwork_task_workarea
	AND	   a.taskwork_mtlreq_ownership in (@customer1,@self1,@self2,@contractor1)-- code added for ITS ID:ES_PRJREP_00077
	AND	   a.taskwork_mtlreq_workarea	like   @workarea
	AND	   --a.prjdet_mtlreq_actcode between isnull(@actcodefrom,a.prjdet_mtlreq_actcode) and isnull(@actcodeto,a.prjdet_mtlreq_actcode)
		   a.taskwork_mtlreq_taskcode  >=	isnull(@actcodefrom,a.taskwork_mtlreq_taskcode) 
	and	   a.taskwork_mtlreq_taskcode	<=	isnull(@actcodeto,a.taskwork_mtlreq_taskcode)
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
	 /* code commented for dts :13H120_Masters_00007:ES_Masters_00085*/
	--and		isnull(prjmst_act_hdr_tasksubgroup,'') >=isnull(@tasksubgroupfrom,isnull(prjmst_act_hdr_tasksubgroup,'')) -- 13H120_Masters_00007:ES_Masters_00085
	--and		isnull(prjmst_act_hdr_tasksubgroup,'') <=isnull(@tasksubgroupto,isnull(prjmst_act_hdr_tasksubgroup,'')) --13H120_Masters_00007:ES_Masters_00085
	/* code commented for dts :13H120_Masters_00007:ES_Masters_00085*/
		/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
	--code commented by vasantha a for LNG-183 begins
	/*
	AND		d.scd_ou		=	@ctxt_ouinstance_tmp
	AND	    d.scd_basproj	=	tak.taskwork_task_prjcode
	AND	    d.scd_amend_no	=	tak.taskwork_task_prjamendno
	and		scd_app_on			=	'MA'	
	and		((scd_app_at	=	'PR'  and		scd_code		=	tak.taskwork_task_prjcode)
			or	(scd_app_at	=	'TG'  and		scd_code		=	prjmst_act_hdr_actgrp)
			or	(scd_app_at	=	'WG'  and		scd_code		=	prjmst_act_hdr_consgrp)
			or	(scd_app_at	=	'WBS' and		scd_code		=	taskwork_mtlreq_taskcode	and		scd_itres_code	=	taskwork_mtlreq_itemcode)
	)
	and		d.scd_type		= 'PRJ_PRJ' --code added by vasantha A for ES_PRJDEF_00258	
	*/
	--code commented by vasantha a for LNG-183 ends
	--AND	   isnull(a.prjdet_mtlreq_GrpVariant,'') between isnull(@activitygroupvariantfrom,isnull(a.prjdet_mtlreq_GrpVariant,'')) and isnull(@activitygroupvariantto,isnull(a.prjdet_mtlreq_GrpVariant,'')) 
	AND	   --a.prjdet_mtlreq_actgrp  between isnull(@actgrpfrom,a.prjdet_mtlreq_actgrp) and isnull(@actgrpto ,a.prjdet_mtlreq_actgrp)
			a.taskwork_mtlreq_taskgrp  >=	isnull(@actgrpfrom,a.taskwork_mtlreq_taskgrp) 
	and		a.taskwork_mtlreq_taskgrp	<=	isnull(@actgrpto ,a.taskwork_mtlreq_taskgrp)
	
	AND    taskwork_mtlreq_prjamend = (
	           SELECT MAX(taskwork_mtlreq_prjamend)
	           FROM   prjdet_taskwork_mtlreq b(NOLOCK)
	   WHERE  a.taskwork_mtlreq_prjou       = b.taskwork_mtlreq_prjou
	           AND    a.taskwork_mtlreq_prjcode = b.taskwork_mtlreq_prjcode
	       )     
	--AND	   prjmst_act_hdr_consgrp	= tm.congrp_tm
	/*Code modified for ES_PRJREP_00049 begins here */
	--and	   prjmst_act_hdr_basis	=		@basis			
	and	   prjmst_act_hdr_basis	=		''	
	/*Code modified for ES_PRJREP_00049 ends here */		
	AND    ou_id1				=		@ctxt_ouinstance_tmp
	AND	   guid1				=		@guid
   	AND	   ou					=		taskwork_task_prjou
	AND	   prj_code				=		taskwork_task_prjcode
	AND	   act_code				=		taskwork_task_taskcode
	AND	   wrk_area				=		taskwork_task_workarea
	AND	   wbs					=		taskwork_task_wbsid	
	/*Code added for ES_PRJREP_00059 begins here*/
	AND	   count1				like	@level
	and	   tm.congrp_tm				like	@constrngrp
	and	   guid2					=	@guid1
	and	   ou_id					=	ou
	and	   cons_taskgrp				=	prjmst_act_hdr_actgrp				
	/*Code added for ES_PRJREP_00059 ends here*/
	
	

	/* code added for dts id :  13H120_Masters_00007: ES_Masters_00077 begins */
	update  tmp
	set		tsk_subgroup		=  prjmst_act_hdr_tasksubgroup
	from	prjmst_activity_hdr(nolock),
			projectboq_mtl_tmp tmp(NOLOCK)
	where	prjmst_act_hdr_actou		=	@ctxt_ouinstance_tmp
	and		prjmst_act_hdr_actcode		=	taskcode
	AND	    mtl_guid						=	@guid
	/* Code modified for dts id : 13H120_Masters_00007:ES_Masters_00085 begins */
	--and	prjmst_act_hdr_basis		=	@basis
	and		prjmst_act_hdr_basis		=	''
	/* Code modified for dts id : 13H120_Masters_00007:ES_Masters_00085  ends */
	
	/*Code modified for ES_PRJREP_00049 begins here*/
	update	tmp
	set		congrp					=	prjmst_code_work_group
	from	projectboq_mtl_tmp tmp,
			prjmst_code_mst(nolock)
	where	mtl_guid				=	@guid
	and		ACTIVITYGRP1			=	prjmst_code_code
	and		prjmst_code_ou			=	@ctxt_ouinstance_tmp
	and		prjmst_code_codetyp		=	'AG'	
	/*Code modified for ES_PRJREP_00049 ends here*/		
	
	/* code commented for dts :13H120_Masters_00007:ES_Masters_00085*/
	/*update  tmp
	set		tsk_subgroup	= prjmst_code_codedesc
	from	prjmst_code_mst(nolock),
			projectboq_mtl_tmp tmp(NOLOCK)
	where	prjmst_code_code	=  tsk_subgroup
	AND     prjmst_code_ou 		=  @ctxt_ouinstance
	AND	   mtl_guid				=	@guid
	and		prjmst_code_codetyp	='TSG'*/
	/* code commented for dts :13H120_Masters_00007:ES_Masters_00085*/
	
	/* code added for dts id : 13H120_Masters_00007:ES_Masters_00077 ends */
	
	
	--as discussed with Mini, planned qty should be taken, if actual o/p qty is > planned qty, take tht.
	update	tmp 
	set		act_OUTPUTQTY1  =	taskwork_task_outputqty_act
	from	projectboq_mtl_tmp	tmp,
			prjdet_taskwork_taskdtl	
	where	tmp.mtl_guid	=	@guid
	and		tmp.prj_code1	=	@projectcodefrom
	and		taskwork_task_prjcode	=	tmp.prj_code1
	and		taskwork_task_taskcode	=	tmp.taskcode
	and		wbsid1			=	taskwork_task_wbsid
	and		isnull(taskwork_task_outputqty_act,0)	>	isnull(taskwork_task_outputqty,0)
	
	update  tmp
	set		item_desc		=	ml_itemvardesc_shd + ' ' + ml_varshortdesc_shd
	from	projectboq_mtl_tmp tmp(nolock),
			itm_ml_multilanguage ml(NOLOCK)
	where	mtl_guid		=	@guid
	AND     Item_Name		=	ml.ml_itemcode
	AND     varinat			=	ml.ml_variantcode
	AND     ml_langid		=	@ctxt_language
	and		ml_lo			=	@lo_id
	
	update	projectboq_mtl_tmp
	set		FOH_flag = 'SS'
	--13H120_PRJREP_00003 starts
	--where	FOH_flag not in ('F','P')
	where	FOH_flag not in ('Val','PER')
	--13H120_PRJREP_00003 ends
	and		mtl_guid = @guid

	--material details ends
	
	--Resource Details starts
	INSERT INTO projectboq_res_tmp(
				taskcode,					Resource_Name,				Resource_desc,			
				resource_code,				resource_type,				Quantity,
				Base_Rate,					Base_Amount,				tot_base_amnt,
				Itk_Coefficient_Wastage,	Itk_Coefficient_FloorOH	,	Itk_Coefficient_Overhead,
				rev_no2,					ACTIVITYGRP2,				prj_code2,
				wbsid2,						workarea2,					own2,
				OUTPUTQTY2,					act_OUTPUTQTY2,				res_final_rate,
				res_guid,					congrp,						FOH_flag,
				Activity_variant,			taxcal,						Res_uom
				,tsk_subgroup --13H120_Masters_00007:ES_Masters_00077
				)
	SELECT	taskwork_resreq_taskcode ,   taskwork_resreq_resource ,	res1.prjmst_res_resdesc,
--			prjmst_act_resreq_resource,		prjmst_act_resreq_restype,   ISNULL(a.taskwork_resreq_totusag, 0),
--			ISNULL(taskwork_resreq_rate,0),	ISNULL(a.taskwork_resreq_totusag, 0) * ISNULL(taskwork_resreq_rate, 0),
			prjmst_act_resreq_resource,		prjmst_act_resreq_restype,   ISNULL(a.taskwork_resreq_usage, 0),
			ISNULL(taskwork_resreq_rate,0),	ISNULL(a.taskwork_resreq_usage, 0) * ISNULL(taskwork_resreq_rate, 0),
																		0.0,
		    ISNULL(d.scd_wast_per,0),		ISNULL(d.scd_floor_ovhead,0), ISNULL(d.scd_task_ovhead,0),
			taskwork_resreq_prjamendno,		prjmst_act_hdr_actgrp,		taskwork_resreq_prjcode,
			taskwork_task_wbsid,			taskwork_resreq_workarea,	res.prjmst_act_resreq_owner,
			0.0,							isnull(taskwork_task_outputqty,taskwork_task_outputqty_act),--isnull(taskwork_task_outputqty_act,taskwork_task_outputqty), --as discussed with Mini, planned qty should be taken, if actual o/p qty is > planned qty, take tht.
																		taskwork_resreq_totusag,
			@guid,							prjmst_act_hdr_consgrp,		d.scd_ovh_basis,
		    null/*taskwork_resreq_GrpVariant*/,
											null/*taskwork_res_tskcal*/,		taskwork_resreq_uom
			,prjmst_act_hdr_tasksubgroup --13H120_Masters_00007:ES_Masters_00077
	FROM   prjdet_taskwork_resreq a(NOLOCK),
	       prjmst_resource_mst res1(NOLOCK),
	       prjmst_activity_resreq	res (nolock),
	       component_metadata_table typ(NOLOCK),
	       --uom_mas_uommaster(NOLOCK),
	       prjdet_taskwork_taskdtl tak(nolock),
   		 --code modified by vasantha a for LNG-183 begins
		   --#congrp_tmp				tm	(nolock),--ES_PRJREP_00059
		   prjmst_activity_hdr	p (NOLOCK)
		   	left outer JOIN #congrp_tmp tm	(nolock)  --code added for LNG-130
			ON	(cons_taskgrp				=	prjmst_act_hdr_actgrp
			)
			left outer join pdt_spec_coeff_dtl d (NOLOCK)
			on
			(
					d.scd_ou			=	@ctxt_ouinstance_tmp
			AND	   d.scd_basproj	=	@projectcodefrom
			and	   d.scd_app_on		=	'WBS'
			and		((	 scd_app_at	=	'PR' and	scd_code	=	@projectcodefrom)
				or	(scd_app_at =	'TG'  and	scd_code	=	prjmst_act_hdr_actgrp)
					or	(scd_app_at	=	'WG'  and	scd_code	=	tm.congrp_tm)
				or	(scd_app_at	=	'WBS' and	scd_code	=	prjmst_act_hdr_actcode)
				) 
				and		d.scd_type		= 'PRJ_PRJ' 
			),
		   --code modified by vasantha a for LNG-183 ends
		   #subprj_tmp,
		   #level--,
		   --code commented by vasantha a for LNG-183 begins
		   --pdt_spec_coeff_dtl d  (NOLOCK),
		   --prjmst_activity_hdr	(nolock)
		    --code commented by vasantha a for LNG-183 ends
	WHERE  taskwork_resreq_prjou = @ctxt_ouinstance_tmp
	AND    taskwork_resreq_prjcode	  =	subprj
	AND    taskwork_resreq_prjamendno = (
	           SELECT MAX(taskwork_resreq_prjamendno)
	           FROM   prjdet_taskwork_resreq	b	(NOLOCK)
	           WHERE  a.taskwork_resreq_prjou	= b.taskwork_resreq_prjou
	           AND    a.taskwork_resreq_prjcode = b.taskwork_resreq_prjcode
	     )
	AND    res1.prjmst_res_ou = taskwork_resreq_prjou
	AND    res1.prjmst_res_rescode = taskwork_resreq_resource
	and		res.prjmst_act_resreq_ou		=	taskwork_resreq_prjou
	and		res.prjmst_act_resreq_actcode	=	tak.taskwork_task_taskcode
	and		res.prjmst_act_resreq_actgrp	=	prjmst_act_hdr_actgrp
	and		res.prjmst_act_resreq_resource	=	taskwork_resreq_resource
	AND    typ.componentname = 'MASTERS'
	AND    typ.paramcategory = 'RESTYPE'
	AND	   typ.paramtype	 = 'RES'
	--AND    typ.paramcode	 = prjmst_res_restype
	AND    typ.paramcode	 = res.prjmst_act_resreq_restype
	AND    typ.langid		 = @ctxt_language_tmp
	--AND    mas_uomcode		 = taskwork_resreq_uom
	and	   prjmst_act_hdr_actou			=	tak.taskwork_task_prjou
	and	   prjmst_act_hdr_actcode		=	tak.taskwork_task_taskcode
	AND    a.taskwork_resreq_prjou		=	tak.taskwork_task_prjou
	AND	   a.taskwork_resreq_prjcode	=	tak.taskwork_task_prjcode
	AND	   a.taskwork_resreq_taskcode	=	tak.taskwork_task_taskcode
	AND	   a.taskwork_resreq_workarea	=	tak.taskwork_task_workarea
	--AND	   a.taskwork_resreq_taskgrp	=	prjmst_act_hdr_actgrp
	--AND	   res.prjmst_res_own			in	(@customer_res1,@self_res1,@contractor_res1)
	AND	   isnull(res.prjmst_act_resreq_owner,@customer_res1)	=	@customer_res1
	and	   (isnull(res.prjmst_act_resreq_owner,@self_res1)	in	(@self_res1,@self_res2))	-- code modified for ITS ID: ES_PRJREP_00077
	and	   isnull(res.prjmst_act_resreq_owner,@contractor_res1)	=	@contractor_res1
	AND	   a.taskwork_resreq_workarea	like	@workarea
	AND	   --a.taskwork_resreq_taskcode between isnull(@actcodefrom,a.taskwork_resreq_taskcode) and isnull(@actcodeto,a.taskwork_resreq_taskcode)
			a.taskwork_resreq_taskcode  >=  isnull(@actcodefrom,a.taskwork_resreq_taskcode) 
	and		a.taskwork_resreq_taskcode	<=	isnull(@actcodeto,a.taskwork_resreq_taskcode)
	--AND	   isnull(a.taskwork_resreq_GrpVariant,'') between isnull(@activitygroupvariantfrom,isnull(a.taskwork_resreq_GrpVariant,'')) and isnull(@activitygroupvariantto,isnull(a.taskwork_resreq_GrpVariant,'')) ---DLF_AMC_CR_CR-384_00048
	AND	    --prjmst_act_hdr_actgrp  between isnull(@actgrpfrom,prjmst_act_hdr_actgrp) and isnull(@actgrpto,prjmst_act_hdr_actgrp)
			prjmst_act_hdr_actgrp   >=  isnull(@actgrpfrom,prjmst_act_hdr_actgrp) 
	and		prjmst_act_hdr_actgrp	<=	isnull(@actgrpto,prjmst_act_hdr_actgrp)
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
	/* code commented for dts :13H120_Masters_00007:ES_Masters_00085*/
	--and		isnull(prjmst_act_hdr_tasksubgroup,'') >=isnull(@tasksubgroupfrom,isnull(prjmst_act_hdr_tasksubgroup,''))
	--and		isnull(prjmst_act_hdr_tasksubgroup,'') <=isnull(@tasksubgroupto,isnull(prjmst_act_hdr_tasksubgroup,''))
	/* code commented for dts :13H120_Masters_00007:ES_Masters_00085*/
	/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
	--code commented by vasantha a for LNG-183 begins
	/*
	--AND	    prjmst_act_hdr_consgrp	= tm.congrp_tm
	AND		d.scd_ou		=	@ctxt_ouinstance_tmp
	AND	    d.scd_basproj	=	tak.taskwork_task_prjcode
	AND	    d.scd_amend_no	=	tak.taskwork_task_prjamendno
	and		scd_app_on			=	'RE'	
	and		((scd_app_at	=	'PR'  and		scd_code		=	tak.taskwork_task_prjcode)
			or	(scd_app_at	=	'TG'  and		scd_code		=	prjmst_act_hdr_actgrp)
			or	(scd_app_at	=	'WG'  and		scd_code		=	prjmst_act_hdr_consgrp)
			or	(scd_app_at	=	'WBS' and		scd_code		=	taskwork_resreq_taskcode	and		scd_itres_code	=	taskwork_resreq_resource)
	)
	and		d.scd_type		= 'PRJ_PRJ' --code added by vasantha A for ES_PRJDEF_00258	
	*/
	--code commented by vasantha a for LNG-183 ends
	/*Code modified for ES_PRJREP_00049 begins here */
	--and	   prjmst_act_hdr_basis	=		@basis			
	and	   prjmst_act_hdr_basis	=		''	
	/*Code modified for ES_PRJREP_00049 ends here */
	AND    ou_id1				=	@ctxt_ouinstance_tmp 
	AND	   guid1				=	@guid
	AND	   ou					=	taskwork_task_prjou 
	AND	   prj_code				=	taskwork_task_prjcode
	AND	   act_code				=	taskwork_task_taskcode
	AND	   wrk_area				=	taskwork_task_workarea
	AND	   wbs					=	taskwork_task_wbsid	
	AND	   count1				like @level	
	/*Code added for ES_PRJREP_00059 begins here*/
	and	   tm.congrp_tm				like	@constrngrp
	and	   guid2					=	@guid1
	and	   ou_id					=	ou
	and	   cons_taskgrp				=	prjmst_act_hdr_actgrp	
	/*Code added for ES_PRJREP_00059 ends here*/		
	
	
	/* code added for dts id :  13H120_Masters_00007: ES_Masters_00077 begins */
	update  tmp
	set		tsk_subgroup		=  prjmst_act_hdr_tasksubgroup
	from	prjmst_activity_hdr(nolock),
			projectboq_res_tmp tmp(NOLOCK)
	where	prjmst_act_hdr_actou		=	@ctxt_ouinstance_tmp
	and		prjmst_act_hdr_actcode		=	taskcode
	and		res_guid				=	@guid
	/* Code modified for dts id : 13H120_Masters_00007:ES_Masters_00085 begins */
	--and		prjmst_act_hdr_basis	= @basis
	and		prjmst_act_hdr_basis	= ''
	/* Code modified for dts id : 13H120_Masters_00007:ES_Masters_00085 ends */

	/*Code modified for ES_PRJREP_00049 begins here*/
	update	tmp
	set		congrp					=	prjmst_code_work_group
	from	projectboq_res_tmp tmp,
			prjmst_code_mst(nolock)
	where	res_guid				=	@guid
	and		ACTIVITYGRP2			=	prjmst_code_code
	and		prjmst_code_ou			=	@ctxt_ouinstance_tmp
	and		prjmst_code_codetyp		=	'AG'	
	/*Code modified for ES_PRJREP_00049 ends here*/	
	
	/* code commented for dts id : 13H120_Masters_00007:ES_Masters_00085 begins */
	/*update  tmp
	set		tsk_subgroup	= prjmst_code_codedesc
	from	prjmst_code_mst(nolock),
			projectboq_res_tmp tmp(NOLOCK)
	where	prjmst_code_code	=  tsk_subgroup
	AND     prjmst_code_ou 		=  @ctxt_ouinstance
	AND	   res_guid				=	@guid
	and		prjmst_code_codetyp	='TSG'*/
	/* code commented for dts id : 13H120_Masters_00007:ES_Masters_00085 ends */
	
	/* code added for dts id :  13H120_Masters_00007: ES_Masters_00077 ends */
	
	
	--as discussed with Mini, planned qty should be taken, if actual o/p qty is > planned qty, take tht.
	update	tmp 
	set		tmp.act_OUTPUTQTY2  =	taskwork_task_outputqty_act
	from	projectboq_res_tmp	tmp,
			prjdet_taskwork_taskdtl	
	where	tmp.res_guid	=	@guid
	and		tmp.prj_code2	=	@projectcodefrom
	and		taskwork_task_prjcode	=	tmp.prj_code2
	and		taskwork_task_taskcode	=	tmp.taskcode
	and		wbsid2			=	taskwork_task_wbsid
	and		isnull(taskwork_task_outputqty_act,0)	>	isnull(taskwork_task_outputqty,0)

	update	projectboq_res_tmp
	set		FOH_flag = 'SS'
	--13H120_PRJREP_00003 starts
	--where	FOH_flag not in ('F','P')
	where	FOH_flag not in ('Val','PER')
	--13H120_PRJREP_00003 ends
	and		res_guid = @guid

	UPDATE tmp 
	set    outputqty1 = prjmst_act_hdr_outputqty
	from   projectboq_mtl_tmp tmp (NOLOCK),
		   prjmst_activity_hdr(nolock)
	where  prjmst_act_hdr_actou	= @ctxt_ouinstance_tmp
	and	   prjmst_act_hdr_actcode  = tmp.taskcode
	and    mtl_guid		=	@guid
		
	UPDATE	tmp 
	set		outputqty2 = prjmst_act_hdr_outputqty
	from	projectboq_res_tmp tmp (NOLOCK),
			prjmst_activity_hdr(nolock)
	where	prjmst_act_hdr_actou	= @ctxt_ouinstance_tmp	
	AND		prjmst_act_hdr_actcode  = tmp.taskcode
	and		res_guid		=	@guid
	
	Update	projectboq_res_tmp
	set		res_final_rate		= res_final_rate
	where	res_guid			=	@guid	

	if @self_res = '0' and @contractor_res  = '1' 
	begin 
		update	tmp1
		set		self_finamt = isnull(res_amnt,0)
		FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
				(select	sum	(res_final_rate) 'res_amnt'	,
						prj_code2,
						ACTIVITYGRP2,
						taskcode,
						wbsid2,
						workarea2
				 FROM   projectboq_res_tmp(NOLOCK)
				 where  res_guid		=	@guid	
				 --and	own2			=	'S'  
				 and	own2			=	'SE'  
				 --and	taxcal		=	'IN'	 
			 			
				 GROUP BY prj_code2,ACTIVITYGRP2,taskcode,wbsid2,workarea2
				) tmp
		WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
		and	   prj_code2    = prj_code
		and	   ACTIVITYGRP2 = ACTIVITYGRP
		and	   wbsid2		= wbsid
		and    workarea2	= workarea
		and    act_guid		= @guid
	end 
	
	if @self_res = '1' and @contractor_res  = '0'
	begin
		update	tmp1
		set		self_finamt = isnull(res_amnt,0)
		FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
				(select	sum	(res_final_rate) 'res_amnt'	,
						prj_code2,
						ACTIVITYGRP2,
						taskcode,
						wbsid2,
						workarea2
				 FROM   projectboq_res_tmp(NOLOCK)
				 where  res_guid		=	@guid	
				 --and	own2			=	'S'  
				 and	own2			=	'SE'  
				 --and	taxcal		=	'IN'	 
			 	 GROUP BY	prj_code2,ACTIVITYGRP2,taskcode,wbsid2,workarea2
				) tmp
		WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
		and	   prj_code2    = prj_code
		and	   ACTIVITYGRP2 = ACTIVITYGRP
		and	   wbsid2		= wbsid
		and    workarea2	= workarea
		and    act_guid		= @guid
	end 
	
	if @self_res  = '0' and @contractor_res  = '1'
	begin
		update	tmp1
		set		mtl_res_finamnt = isnull(res_amnt,0)
		FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
				(select	sum	(res_final_rate) 'res_amnt'	,
						prj_code2,
						ACTIVITYGRP2,
						taskcode,
						wbsid2,
						workarea2
				 FROM   projectboq_res_tmp(NOLOCK)
				 where  res_guid	=	@guid	
			     --and	own2		in	('SU')	
			     and	own2		in	('CO')	
				 --and	taxcal		=	'IN'	 			
				GROUP BY	prj_code2,ACTIVITYGRP2,taskcode,wbsid2,workarea2
				) tmp
		WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
		and	   prj_code2    = prj_code
		and	   ACTIVITYGRP2 = ACTIVITYGRP
		and	   wbsid2		= wbsid
		and    workarea2	= workarea
		and    act_guid		= @guid
	end
	if @self_res  = '1' and @contractor_res  = '1'
	begin
		update	tmp1
		set		mtl_res_finamnt = isnull(res_amnt,0)--DLF_PM_Project Reports_00017
		FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
				(select	sum	(res_final_rate) 'res_amnt'	,
						prj_code2,
						ACTIVITYGRP2,
						taskcode,
						wbsid2,
						workarea2
				 FROM   projectboq_res_tmp(NOLOCK)
				 where  res_guid	=	@guid	
				 --and	own2		in	('SU','S')	
				 and	own2		in	('CO','SE')	
				 --and	taxcal		=	'IN'	 
				 GROUP BY	prj_code2,ACTIVITYGRP2,taskcode,wbsid2,workarea2
				) tmp
		WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
		and	   prj_code2    = prj_code
		and	   ACTIVITYGRP2 = ACTIVITYGRP
		and	   wbsid2		= wbsid
		and    workarea2	= workarea
		and    act_guid		= @guid
	end
	
	Update	projectboq_mtl_tmp
	set		mtl_final_rate	=	mtl_final_rate
	where	mtl_guid		= @guid
	
	if @self = '0' and @contractor = '1' 
	begin 
		update	tmp1
		set		self_finamt = self_finamt + isnull(mtl_amnt,0)
		FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
				(SELECT	SUM(mtl_final_rate) 	  'mtl_amnt',
						prj_code1,
						ACTIVITYGRP1,
						taskcode,
						wbsid1,
						workarea1	
				 FROM   projectboq_mtl_tmp(NOLOCK)
				 where  mtl_guid	=	@guid
				 --and	own1		= 'S'	
				 and	own1		= 'SE'	
				 --and	taxcal		=	'IN'		 	
				 GROUP BY	prj_code1,ACTIVITYGRP1,taskcode,wbsid1,workarea1
				) tmp
		WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
		and	   prj_code1    = prj_code
		and	   ACTIVITYGRP1 = ACTIVITYGRP
		and	   wbsid1		= wbsid
		and    workarea1    = workarea
		and    act_guid		=	@guid
	end 

	if @self = '1' and @contractor = '0'
	begin 
		update	tmp1
		set		self_finamt = self_finamt + isnull(mtl_amnt,0)
		FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
				(SELECT	SUM(mtl_final_rate) 	  'mtl_amnt',
						prj_code1,
						ACTIVITYGRP1,
						taskcode,
						wbsid1,
						workarea1	
				 FROM   projectboq_mtl_tmp(NOLOCK)
				 where  mtl_guid		=	@guid
				 --and	  own1			= 'S'	
				 and	  own1			= 'SE'	
				 --and	  taxcal		=	'IN'
				 GROUP BY	prj_code1,ACTIVITYGRP1,taskcode,wbsid1,workarea1
				) tmp
		WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
		and	   prj_code1    = prj_code
		and	   ACTIVITYGRP1 = ACTIVITYGRP
		and	   wbsid1		= wbsid
		and    workarea1    = workarea
		and    act_guid		=	@guid
	end

	if   @self = '0' and @contractor = '1'
	begin
		update	tmp1
		set		mtl_res_finamnt = mtl_res_finamnt + isnull(mtl_amnt,0)
		FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
				(SELECT SUM(mtl_final_rate) 	  'mtl_amnt',
						prj_code1,
						ACTIVITYGRP1,
						taskcode,
						wbsid1,
						workarea1	
				 FROM   projectboq_mtl_tmp(NOLOCK)
				 where  mtl_guid		=	@guid
				 --and	  own1			in	('SU')	
				 and	  own1			in	('CO')	
				 --and	  taxcal		=	'IN'
				 GROUP BY prj_code1,ACTIVITYGRP1,taskcode,wbsid1,workarea1
				) tmp
		WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
		and	   prj_code1    = prj_code
		and	   ACTIVITYGRP1 = ACTIVITYGRP
		and	   wbsid1		= wbsid
		and    workarea1    = workarea
		and  act_guid		=	@guid
	end
  
	if @self = '1' and @contractor = '1'
	begin
   		update	tmp1
		set		mtl_res_finamnt = mtl_res_finamnt + isnull(mtl_amnt,0)
		FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
				(SELECT SUM(mtl_final_rate) 	  'mtl_amnt',
						prj_code1,
						ACTIVITYGRP1,
						taskcode,
						wbsid1,
						workarea1	
				 FROM   projectboq_mtl_tmp(NOLOCK)
				 where  mtl_guid		=	@guid
				 --and	  own1			in	('SU','S')	
				 and	  own1			in	('CO','SE')	
				 --and	  taxcal		=	'IN'
				 GROUP BY prj_code1,ACTIVITYGRP1,taskcode,wbsid1,workarea1
				) tmp
		WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
		and	   prj_code1    = prj_code
		and	   ACTIVITYGRP1 = ACTIVITYGRP
		and	   wbsid1		= wbsid
		and    workarea1    = workarea
		and    act_guid		=	@guid	
		
	end

	Update ProjectBOQ_act_tmp
	set	   itk_grid_text_02__tsk	=	round(itk_grid_text_02__tsk,4),
		   itk_grid_text_01__tsk	=	round(itk_grid_text_01__tsk,4),
		   itk_grid_numeric_01__tsk	=	round(itk_grid_numeric_01__tsk,4),
		   itk_grid_text_03__tsk	=	round(itk_grid_text_03__tsk,4),
		   itk_grid_numeric_02__tsk	=	round(itk_grid_numeric_02__tsk,4)	
	where  act_guid		=	@guid

	Update projectboq_mtl_tmp
	set	   Itk_Coefficient_Wastage	=	round(Itk_Coefficient_Wastage,4),
		   Itk_Coefficient_FloorOH	=	round(Itk_Coefficient_FloorOH,4),
		   Itk_Coefficient_Overhead	=	round(Itk_Coefficient_Overhead,4),
	       Quantity					=	round(Quantity,4)
	where  mtl_guid		=	@guid

	Update projectboq_res_tmp
	set	   Itk_Coefficient_Wastage	=	round(Itk_Coefficient_Wastage,4),
		   Itk_Coefficient_FloorOH	=	round(Itk_Coefficient_FloorOH,4),
		   Itk_Coefficient_Overhead	=	round(Itk_Coefficient_Overhead,4),
	       Quantity					=	round(Quantity,4)		
	where  res_guid		=	@guid				

	
	update	tmp1
	set		finalrate_contract = isnull(res_amnt,0)
	FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
			(select   sum	(res_final_rate) 'res_amnt'	,
					  prj_code2,
					  ACTIVITYGRP2,
					  taskcode,
					  wbsid2,
					  workarea2
			   FROM   projectboq_res_tmp(NOLOCK)
			   where  res_guid		=	@guid	
			   --and	  own2			=	'SU'
			   and	  own2			=	'CO'
			   --and	  taxcal		=	'IN'
			   GROUP BY
					  prj_code2,ACTIVITYGRP2,taskcode,wbsid2,workarea2
		   ) tmp
	WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
	and	   prj_code2    = prj_code
	and	   ACTIVITYGRP2 = ACTIVITYGRP
	and	   wbsid2		= wbsid
	and    workarea2	= workarea
	and    act_guid		= @guid
		
	update	tmp1
	set		finalrate_contract = isnull(finalrate_contract,0) + isnull(mtl_amnt,0)
	FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), 
			(SELECT	SUM(mtl_final_rate) 	  'mtl_amnt',
	                prj_code1,
					ACTIVITYGRP1,
	                taskcode,
					wbsid1,
					workarea1	
	          FROM  projectboq_mtl_tmp(NOLOCK)
			  where  mtl_guid	=	@guid
			  --and	  own1		=	'SU'
			  and	  own1		=	'CO'
			  --and	  taxcal	=	'IN'		--DLFAMCLIVE_PRJRPT_00007		
	          GROUP BY
	          prj_code1,ACTIVITYGRP1,taskcode,wbsid1,workarea1
			) tmp
	WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
	and	   prj_code1    = prj_code
	and	   ACTIVITYGRP1 = ACTIVITYGRP
	and	   wbsid1		= wbsid
	and    workarea1    = workarea
	and    act_guid		=	@guid
	

	if (@customer=N'1'and @customer_res=N'1' and @self=N'1' and @self_res=N'1' and @contractor=N'1' and @contractor_res=N'1')
	begin
		update	ProjectBOQ_act_tmp
		set		mtl_res_finamnt = (mtl_res_finamnt) +
						((isnull(finalrate_contract,0)  + itk_grid_text_02__tsk) * (itk_grid_numeric_01__tsk/100))
		where	mtl_res_finamnt  <> 0.0
		and		act_guid	  =	@guid
	end
	else
	begin
		update	ProjectBOQ_act_tmp
		set		mtl_res_finamnt = (mtl_res_finamnt) +						
						((isnull(finalrate_contract,0)) * (itk_grid_numeric_01__tsk/100))
		where	mtl_res_finamnt  <> 0.0
		and   act_guid	  =	@guid
	end

	update	ProjectBOQ_act_tmp
	set		self_finamt = (self_finamt) 
	where	self_finamt <> 0.0
	and		act_guid	  =	@guid

	
	--code commented by vasantha a for LNG-183 begins
	/*
	if ( @self=N'0' and @self_res=N'0' and	@contractor=N'1' and @contractor_res=N'1')
	begin
		update	ProjectBOQ_act_tmp
		set	    act_finalamnt = mtl_res_finamnt
		where	act_guid	  =	@guid
	end
	else
	begin
		update ProjectBOQ_act_tmp
		set act_finalamnt = mtl_res_finamnt + self_finamt
		where act_guid	  =	@guid
	end
	  
	if (@customer=N'1'and @customer_res=N'1' and @self=N'1' and @self_res=N'1' and 
		  @contractor=N'1' and @contractor_res=N'1')
	begin
		update	ProjectBOQ_act_tmp
		set		act_finalamnt   = itk_grid_text_02__tsk + itk_grid_text_03__tsk
		where   act_guid	    = @guid
		and		mtl_res_finamnt = 0.0
		and		self_finamt		= 0.0 
		
		update	ProjectBOQ_act_tmp
		set		act_finalamnt    = act_finalamnt  + itk_grid_text_02__tsk +  itk_grid_text_03__tsk
		where   act_guid	     = @guid
		and		(mtl_res_finamnt <> 0.0
		or		self_finamt		 <> 0.0)
	end
		*/
--code commented by vasantha a for LNG-183 ends


	UPDATE	tmp1
	SET		labour_rate = round(total_amnt,2)
	FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), (
			SELECT	SUM(Base_Amount) 	   'total_amnt',
	                prj_code2,
					ACTIVITYGRP2,
					taskcode,
					wbsid2,
					workarea2
	        FROM   projectboq_res_tmp(NOLOCK)
	        WHERE  resource_type <> 'MC'
			and    res_guid		=	@guid
	        GROUP BY
	                  prj_code2,ACTIVITYGRP2,taskcode,wbsid2,workarea2
	        ) tmp
	WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
	and	   prj_code2    = prj_code
	and	   ACTIVITYGRP2 = ACTIVITYGRP
	and	   wbsid2		= wbsid
	and    workarea2	= workarea
	and    act_guid		= @guid

	Update	projectboq_mtl_tmp
	set		Base_Rate		=	Base_Rate
	where	mtl_guid		=	@guid
	
	UPDATE tmp1
	SET    machine_rate = round(total_amnt,2)
	FROM   ProjectBOQ_act_tmp tmp1 (NOLOCK), (
	       SELECT SUM(Base_Amount)		 'total_amnt',
				  prj_code2,
				  ACTIVITYGRP2,
	              taskcode,
				  wbsid2 ,
				  workarea2			
	       FROM   projectboq_res_tmp(NOLOCK)
	       WHERE  resource_type = 'MC'
		   and    res_guid		=	@guid
	       GROUP BY
	                  prj_code2,ACTIVITYGRP2,taskcode,wbsid2,workarea2
	       ) tmp
	WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
	and	   prj_code2    = prj_code
	and	   ACTIVITYGRP2 = ACTIVITYGRP
	and	   wbsid2		= wbsid
	and    workarea2	= workarea
	and    act_guid		= @guid

	UPDATE	tmp1
	SET		material_rate = round(total_amnt,2)
	FROM	ProjectBOQ_act_tmp tmp1 (NOLOCK), (
			SELECT	SUM(Base_Rate) 'total_amnt',
					prj_code1,
					ACTIVITYGRP1,
	                taskcode,
					wbsid1,
					workarea1	
	        FROM   projectboq_mtl_tmp(NOLOCK)
			where  mtl_guid		=	@guid
	        GROUP BY
	                  prj_code1,ACTIVITYGRP1,taskcode,wbsid1,workarea1
	       ) tmp
	WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
	and	   prj_code1    = prj_code
	and	   ACTIVITYGRP1 = ACTIVITYGRP
	and	   wbsid1		= wbsid
	and    workarea1    = workarea
	and    act_guid		= @guid
	
	UPDATE tmp1
	SET    totmtl_wst_amnt = round(mtl_wst_amnt,4)
	FROM   ProjectBOQ_act_tmp tmp1 (NOLOCK), (
			   SELECT sum(isnull(base_rate,0) * (isnull(Itk_Coefficient_Wastage,0)/100))   'mtl_wst_amnt',
					  prj_code1,
					  ACTIVITYGRP1,
					  taskcode	,
					  wbsid1 ,
					  workarea1
			   FROM   projectboq_mtl_tmp(NOLOCK)
			   where  mtl_guid		=	@guid 
			   GROUP BY
					  prj_code1,ACTIVITYGRP1,taskcode,wbsid1,workarea1
		   ) tmp
	WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
	and	   prj_code1    = prj_code
	and	   ACTIVITYGRP1 = ACTIVITYGRP
	and    wbsid1		= wbsid
	and    workarea1	= workarea
	and    act_guid		=	@guid

	UPDATE tmp1
	SET    totres_wst_amnt = round(res_wst_amnt,4)
	FROM   ProjectBOQ_act_tmp tmp1 (NOLOCK), (
			   SELECT sum(isnull(base_amount,0) * (isnull(Itk_Coefficient_Wastage,0)/100))		 'res_wst_amnt',
					  prj_code2,
					  ACTIVITYGRP2,
					  taskcode,
					  wbsid2,
					  workarea2			
			  FROM   projectboq_res_tmp(NOLOCK)
			 where  res_guid		=	@guid				   
			   GROUP BY
					  prj_code2,ACTIVITYGRP2,taskcode,wbsid2,workarea2
		 ) tmp
	WHERE  tmp.taskcode = tmp1.ACTIVITYCODE1
	and	   prj_code2    = prj_code
	and	   ACTIVITYGRP2 = ACTIVITYGRP
	and    wbsid2		= wbsid
	and    workarea2    = workarea
	and    act_guid		= @guid

	DECLARE --@companycode	udd_companycode,
	        @company_address  res_desc255,
	        @companyname	  fin_companyname,
	    @phone            res_desc40,
	        @fax_no           res_desc40
	
	SELECT @companycode = company_code
	FROM   emod_lo_bu_ou_vw(NOLOCK)
	WHERE  ou_id = @ctxt_ouinstance_tmp
	
	--13h120_prjrep_00005 starts
	declare	@address	udd_desc50,
			@phone1		udd_desc50,
			@fax		udd_desc50	
			
	select	@address		=	paramdesc
	from	component_metadata_table	(nolock)
	where	componentname	=	'PRJREP'	
	and		paramcategory	=	'DISP'
	and		paramtype		=	'address'
	and		paramcode		=	'add'
	and		langid			=	@ctxt_language
		
	select	@phone1			=	paramdesc
	from	component_metadata_table	(nolock)
	where	componentname	=	'PRJREP'	
	and		paramcategory	=	'DISP'
	and		paramtype		=	'phone'
	and		paramcode		=	'ph'
	and		langid			=	@ctxt_language
		
	select	@fax			=	paramdesc
	from	component_metadata_table	(nolock)
	where	componentname	=	'PRJREP'	
	and		paramcategory	=	'DISP'
	and		paramtype		=	'fax'
	and		paramcode		=	'fax'
	and		langid			=	@ctxt_language
	
	SELECT @company_address = /* 'Address :'*/@address  + ISNULL(a.address1, '') + ' ' + 
	       ISNULL(a.address2, '')
	       + ' ' + ISNULL(a.address3, '') + ' ' + ISNULL(a.city, '') + ' - ' +
	       --ISNULL(a.zip_code, '') + ', India',
	       ISNULL(a.zip_code, '') + ',' + country,
	       @phone = /*'Phone :'*/ @phone1 + phone_no,
	       @fax_no = /*'Fax :'*/ @fax + fax_no
	FROM   emod_company_mst a(NOLOCK)
	WHERE  company_code = @companycode
	
	--13h120_prjrep_00005 ends
	
	SELECT @company_address = UPPER(@company_address)
	
	SELECT @companyname = aliascomp_name
	FROM   emod_company_mst_aliasdet(NOLOCK)
	WHERE  company_code = @companycode
	AND    @date_tmp BETWEEN effective_from AND ISNULL(effective_to, '9999-01-01')

	/*	Code Added for ID:ES_PRJREP_00085 begins */
	If @Rpttype = 'VARIANCE'
	BEGIN
	SELECT @ctxt_ouinstance = @ctxt_ouinstance
	End
	Else
	Begin
	/*	Code Added for ID:ES_PRJREP_00085 ends */
	if not exists(select 'x' from ProjectBOQ_act_tmp(nolock) 
				  where act_guid	=	@guid
				  /* Code added for dts id : 13H120_Mamsters_00007: ES_Masters_00085 begins */
				and		isnull(tsk_subgroup,'') >=isnull(@tasksubgroupfrom,isnull(tsk_subgroup,'')) 
				and		isnull(tsk_subgroup,'') <=isnull(@tasksubgroupto,isnull(tsk_subgroup,'')) 
				/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 ends */
		
				  )
	begin 
		--raiserror('No record exist for search criteria',16,1)
		EXEC fin_german_raiserror_sp 'PRJREP',
			 @ctxt_language,
			 25
		return
    end
    /*	Code Added for ID:ES_PRJREP_00085 begins */
    End
    /*	Code Added for ID:ES_PRJREP_00085 ends */
	
	update	tmp1
	set		actdesc			=		tmp.TSK1_ACTIVITYDESC,
			actgrpdesc		=		tmp.ACTIVITYGRPDESC,
			actvariantdesc	=		tmp.variant_description,
			workareadesc	=		tmp.workarea_desc,
			actvariant		=		tmp.Activity_variant,
			consgrpdesc		=		tmp.consgrp_desc,
			prjdesc			=		tmp.prj_name,
			uom				=		tmp.OUTPUTUOM
			,category		=		tmp.chart_category			--EPE-43862
			--EPE-64115 starts
			,tskgrppream	=		tmp.tskgrppream
			,tsksubgrpdesc	=		tmp.tsksubgrpdesc
			,tsksubgrppream	=		tmp.tsksubgrppream
			,tskcodepream	=		tmp.tskcodepream
			,taskcommtask_desc=		tmp.taskcommtask_desc
			--EPE-64115 ends
	from #insertratesplitup tmp1
	join	ProjectBOQ_act_tmp tmp(nolock)
	on		tmp.ACTIVITYCODE1	=	tmp1.taskcode
	and		tmp.workarea		=	tmp1.workarea
	where	tmp.act_guid		=	@guid
	--code added for ITS ID:ES_PRJREP_00041  begins
			if @constrngrp = '%'
			select	@constrngrp	=	'All'
	--code added for ITS ID:ES_PRJREP_00041  ends
	if @Detailed = '0' 
	and @rpttype <> 'VARIANCE' --Code Added for ID:ES_PRJREP_00085 
	begin
		if @self_res = 0 or @self = 0
			select @self_flag = '0'
		else
			select @self_flag = '1' 
	  
		select
			@ProjRepGrp		'userid',
			isnull(material_rate,0) + isnull(labour_rate,0) +	isnull(machine_rate,0)	'extramt1',	
			(isnull(self_finamt,0)  / isnull(DSROPqty,0)) * isnull(OUTPUTQTY,0)  'extramt2',  --DLFAMCLIVE_PRJRPT_00019       
			isnull(OUTPUTQTY,0)	'extramt3',
			1					'extramt9',
			case when isnull(DSROPqty,0)= 0 then 0
			else
			isnull(act_finalamnt,0)  /  isnull(DSROPqty,0)end		  'extramt10' ,
			itk_grid_numeric_01__tsk		'extramt4',
			--EPE-55557	starts
			/*0.0 							'extramt5',					*/
			case when @rpttype_cd = 'BS' then 1 else 0 end	'extramt5',		
			--EPE-55557	ends
			0.0 							'extramt6',	
			0.0								'extramt8',
			case when isnull(DSROPqty,0) = 0 then 0
			else
			isnull(Activity_bugvalue,0) end		'extramt7',	
			ACTIVITYCODE1   'desc2',
			OUTPUTUOM		'desc3',
			ACTIVITYGRPDESC	'desc4',
			prj_code		'desc5',
			prj_name		'prjdesc',
			wbsid			'wbsid' ,
			ACTIVITYGRP		'taskgroup',
			case when @prjgrp = 'PBOQ' then 'Construction Budget'
				 else 'Construction Budget - Contract' end		'status1',
			@company_address'desc6',
			@phone			'desc7',
			@fax_no			'desc8',
			@companyname	'desc9',
			null		'desc10',
			act_finalamnt		'extranumeric1',	
			0.0 				'extranumeric2'	,
			0.0					'extranumeric3'	,
			0.0 				'extranumeric4'	,
			--code commented and added for 13H120_PRJREP_00012 starts
			--saleablearea		'extranumeric5', 
			@sale_area			'extranumeric5', 
			--code commented and added for 13H120_PRJREP_00012 ends
			'('+ workarea_desc + '-'+ACTIVITYCODE1+')'+ ' - '+TSK1_ACTIVITYDESC	'extrachar2000_1',	
			--congrp				'extrachar2000_2', 
			--@constrngrp				'extrachar2000_2',--code commented and modified for ITS ID:ES_PRJREP_00041 
			congrp				'extrachar2000_2',--ES_PRJREP_00059  
			workarea_desc		'extrachar2000_3',	
			consgrp_desc		'extrachar2000_4',
			ACTIVITYGRPDESC		'extrachar2000_5',
			workarea			'taskdesc',
			@self_flag			'extrachar2000_11',
			variant_description	'extrachar2000_12',
			--null				'extrachar2000_13',		--EPE-43862
			case when chart_category = 'Commercial' then 1 else 0 end	'extrachar2000_13',		--EPE-43862
			Activity_variant  	'extrachar2000_14',
			isnull(finalrate_contract,0)	'extrachar2000_15',
			isnull(finalrate_contract,0)	'extranumeric6',
 			null				'extranumeric7'
			/* Code modified for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
			--,tsk_subgroup		'extrachar2000_7'
			--,dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
			,isnull(tsk_subgroup,'') + case when isnull(tsk_subgroup,'') = '' then '' else ' # ' end 
			+ dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
			/* Code modified for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
			--EPE-64115 starts
			,tskgrppream 'extracharmax_01', 
			tsk_subgroup + '(' + tsksubgrpdesc + ')' 'extracharmax_02', 
			tsksubgrppream 'extracharmax_03', 
			tskcodepream 'extracharmax_04', 
			ACTIVITYGRP + '(' + ACTIVITYGRPDESC + ')'	'extracharmax_05', 
			taskcommtask_desc	'extracharmax_06',
			null 'extracharmax_07', 
			null 'extracharmax_08', 
			null 'extracharmax_09', 
			null 'extracharmax_10', 
			null 'extramt11', 
			null 'extramt12', 
			null 'extramt13', 
			null 'extramt14', 
			null 'extramt15', 
			null 'extraint01', 
			null 'extraint02', 
			null 'extraint03', 
			null 'extraint04', 
			null 'extraint05', 
			null 'extradate01', 
			null 'extradate02', 
			null 'extradate03', 
			null 'extradate04', 
			null 'extradate05'
			--EPE-64115 ends
		from	ProjectBOQ_act_tmp(NOLOCK)
		where   act_guid		=	@guid
		/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 begins */
		and		isnull(tsk_subgroup,'') >=isnull(@tasksubgroupfrom,isnull(tsk_subgroup,'')) 
		and		isnull(tsk_subgroup,'') <=isnull(@tasksubgroupto,isnull(tsk_subgroup,'')) 
		/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 ends */	
	
		union all
		select
			@ProjRepGrp		'userid',
			0.0				'extramt1',	
			0.0				'extramt2',    
			0.0				'extramt3',
			1				'extramt9',
			0.0				'extramt10' ,
			0.0				'extramt4',
			--EPE-55557 starts
			/*0.0 							'extramt5',			*/
			case when @rpttype_cd = 'BS' then 1 else 0 end	'extramt5',		
			--EPE-55557 ends
			0.0 			'extramt6',	
			0.0				'extramt8',
			0.0				'extramt7',	
			taskcode	    'desc2',
			uom				'desc3',
			actgrpdesc		'desc4',
			projcode		'desc5',
			prjdesc			'prjdesc',
			wbsid			'wbsid' ,
			taskgrp			'taskgroup',
			case when @prjgrp = 'PBOQ' then 'Construction Budget'
				 else 'Construction Budget - Contract' end		'status1',
			@company_address'desc6',
			@phone			'desc7',
			@fax_no			'desc8',
			@companyname	'desc9',
			qtytype			'desc10',
			0.0				'extranumeric1',	
			rate 			'extranumeric2'	,--
			qty				'extranumeric3'	,--
			amount 			'extranumeric4'	,--
			--1				'extranumeric5',		--EPE-43862
			@sale_area		'extranumeric5',		--EPE-43862
			'('+ workareadesc + '-'+taskcode+')'+ ' - '+actdesc	'extrachar2000_1',
			--Consgrp			'extrachar2000_2',	
			--@constrngrp				'extrachar2000_2',--code commented and modified for ITS ID:ES_PRJREP_00041  
			Consgrp				'extrachar2000_2',--ES_PRJREP_00059 
			workareadesc	'extrachar2000_3',
			consgrpdesc		'extrachar2000_4',
			actgrpdesc		'extrachar2000_5',
			workarea		'taskdesc',
			@self_flag		'extrachar2000_11', 
			actvariantdesc	'extrachar2000_12',
			--null			'extrachar2000_13',		--EPE-43862
			case when category	= 'Commercial' then 1 else 0 end	'extrachar2000_13',		--EPE-43862
			actvariant	  	'extrachar2000_14',
			0.0				'extrachar2000_15',
			0.0				'extranumeric6',
			--EPE-55557 starts
			/*null			'extranumeric7'	*/
			SCReqstqty		'extranumeric7'			
			--EPE-55557 ends
			/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
			--,tsk_subgroup	'extrachar2000_7'
			--,dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
			,isnull(tsk_subgroup,'') + case when isnull(tsk_subgroup,'') = '' then '' else ' # ' end 
			+ dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
			/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
			--EPE-64115 starts
			,tskgrppream 'extracharmax_01', 
			isnull(tsk_subgroup,'') + '(' + isnull(tsksubgrpdesc,'') + ')' 'extracharmax_02', 
			tsksubgrppream 'extracharmax_03', 
			tskcodepream 'extracharmax_04', 
			taskgrp + '(' + actgrpdesc + ')'	'extracharmax_05', 
			taskcommtask_desc	'extracharmax_06',
			null 'extracharmax_07', 
			null 'extracharmax_08', 
			null 'extracharmax_09', 
			null 'extracharmax_10', 
			null 'extramt11', 
			null 'extramt12', 
			null 'extramt13', 
			null 'extramt14', 
			null 'extramt15', 
			null 'extraint01', 
			null 'extraint02', 
			null 'extraint03', 
			null 'extraint04', 
			null 'extraint05', 
			null 'extradate01', 
			null 'extradate02', 
			null 'extradate03', 
			null 'extradate04', 
			null 'extradate05'
			--EPE-64115 ends
			from	#insertratesplitup
			/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 begins */	
			where 	isnull(tsk_subgroup,'') >=isnull(@tasksubgroupfrom,isnull(tsk_subgroup,'')) 
			and		isnull(tsk_subgroup,'') <=isnull(@tasksubgroupto,isnull(tsk_subgroup,'')) 
			/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 ends */	
	end
	else 
	if @Detailed = '1' and @rpttype <> 'VARIANCE' --Code Added for ID:ES_PRJREP_00085 
	begin
	

		SELECT	@ProjRepGrp					'userid',
				'H' 						'test',
				slno						'desc1',
				--taskgrp 'desc2',  
				ACTIVITYCODE1				'desc2',
				case when @prjgrp = 'PBOQ' then 'Construction Budget'
					 else 'Project BOQ - Contract' end	'desc3',				
				OUTPUTUOM					'desc4',
				prj_code					'desc5',
				material_rate				'extramt1',
				labour_rate					'extramt2',        
				ISNULL(OUTPUTQTY, 0)		'extramt3',
				isnull(DSROPqty,0)			'extramt10',	        	
				0.0							'extramt4',		--Permitted_Escalation  
				isnull(itk_grid_text_02__tsk ,0)'extramt5',		--Coefficient_Wastage
				isnull(itk_grid_text_03__tsk,0) 'extramt6',		--Coefficient_FloorOH
				isnull(itk_grid_numeric_01__tsk,0)'extramt7',		--Coefficient_Overhead 
				machine_rate				'extramt8',
				isnull(totmtl_wst_amnt,0) + isnull(totres_wst_amnt,0)			'extramt9',
				NULL 						'repgrp',
				NULL 						'plannedexpenses',
				NULL 						'expense',
				NULL 						'effortutilised',--wast
				NULL 						'estprjcost',	 --fl
				NULL 						'plannedeffort',
				NULL 						'prjcode1',
				NULL 						'expectedop',
				NULL 						'actualeffort',
				NULL 						'exptilldate',
				NULL 						'exptilldate1',
				@company_address			'desc6',
				@phone						'desc7',
				@fax_no						'desc8',
				@companyname				'desc9',
				null		'desc10',
				a.wbsid						'wbsid' ,
				a.ACTIVITYGRP				'taskgroup',
				a.workarea					'status1',	
				null						'repgrp1',
				null						'taskdesc',
				prj_name					'prjdesc',
				TSK1_ACTIVITYDESC			'extrachar2000_1',
				act_finalamnt				'extranumeric1',
				0.0							'extranumeric2'	,
				ISNULL(OUTPUTQTY, 0)		'extranumeric3'	,
				--@constrngrp					'extrachar2000_2',--code commented and modified for ITS ID:ES_PRJREP_00041  
				--congrp						'extrachar2000_2',
				congrp						'extrachar2000_2',--ES_PRJREP_00059 
				--code commented and added for 13H120_PRJREP_00012 starts
				--saleablearea				'extranumeric5',
				@sale_area					'extranumeric5',
				--code commented and added for 13H120_PRJREP_00012 ends
				Activity_variant			'extrachar2000_11', 
				null 						'extrachar2000_12', 
				Activity_bugvalue			 'extrachar2000_13',
				Activity_variant 			'extrachar2000_14',
				isnull(finalrate_contract,0)	'extrachar2000_15',
				isnull(finalrate_contract,0)	'extranumeric6',
				Activity_bugvalue				'extranumeric7'
				/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
				--,tsk_subgroup					'extrachar2000_7'
				--,dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
				,isnull(tsk_subgroup,'') + case when isnull(tsk_subgroup,'') = '' then '' else ' # ' end 
				+ dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
				/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
		 FROM   ProjectBOQ_act_tmp a (NOLOCK)
		 where	act_guid		=	@guid
		 /* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 begins */
		and		isnull(tsk_subgroup,'') >=isnull(@tasksubgroupfrom,isnull(tsk_subgroup,'')) 
		and		isnull(tsk_subgroup,'') <=isnull(@tasksubgroupto,isnull(tsk_subgroup,'')) 
		/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 ends */	

		 UNION ALL

		 SELECT @ProjRepGrp					'userid',
				'M' 						'test',
				'0' 						'desc1',
				taskcode					'desc2',
				case when @prjgrp = 'PBOQ' then 'Budget'
					 else 'Contract' end	'desc3',
				mtl_uom 					'desc4',
				prj_code1					'desc5',
				tot_base_amnt				'extramt1',
				NULL 						'extramt2',
				ISNULL(outputqty1, 0)		'extramt3',
				NULL 						'extramt10',
				0.0 						'extramt4',
				NULL 						'extramt5',
				NULL 						'extramt6',
				NULL 						'extramt7',
				NULL 						'extramt8',
				null						'extramt9',
				Item_Name					'repgrp',
				Quantity					'plannedexpenses',
				Rate						'expense',
				Itk_Coefficient_Wastage		'effortutilised',	--wast
				Itk_Coefficient_FloorOH		'estprjcost',		--fl
				Itk_Coefficient_Overhead	'plannedeffort',	--ov	
				NULL 						'prjcode1',
				NULL 						'expectedop',
				NULL 						'actualeffort',
				NULL 						'exptilldate',
				NULL 						'exptilldate1',
				@company_address			'desc6',
				@phone						'desc7',
				@fax_no						'desc8',
				@companyname				'desc9',
				null		'desc10',
				wbsid1						'wbsid',
				ACTIVITYGRP1				'taskgroup',
				workarea1					'status1'	,
				null						'repgrp1', 
				item_desc					'taskdesc',
				null						'prjdesc',
				NULL						'extrachar2000_1',
				0.0							'extranumeric1'	,
				ISNULL(act_OUTPUTQTY1, 0)	'extranumeric2'	,
				0.0							'extranumeric3'	,
				--@constrngrp					'extrachar2000_2',--code commented and modified for ITS ID:ES_PRJREP_00041 
				congrp						'extrachar2000_2',--ES_PRJREP_00059  
				--congrp						'extrachar2000_2',
				--code commented and added for 13H120_PRJREP_00012 starts
				--saleablearea				'extranumeric5',
				@sale_area					'extranumeric5',
				--code commented and added for 13H120_PRJREP_00012 ends 
--				FOH_flag					'extrachar2000_11',
				case	isnull(FOH_flag,'')	
				when	'PER'	then	'P'
				when	'Val'	then	'F'
				else	isnull(FOH_flag,'')				
				end							'extrachar2000_11',
				null 						'extrachar2000_12', 
				null 						'extrachar2000_13', 
				Activity_variant 			'extrachar2000_14',
				null						'extrachar2000_15' , 
				null 						'extranumeric6',
				null 						'extranumeric7'
				/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
				--,tsk_subgroup				'extrachar2000_7'  --ES_Masters_00085
				--,dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
				,isnull(tsk_subgroup,'') + case when isnull(tsk_subgroup,'') = '' then '' else ' # ' end 
				+ dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
				/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
		 FROM   projectboq_mtl_tmp b(NOLOCK)
		 where  mtl_guid		=	@guid
		 /* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 begins */
		and		isnull(tsk_subgroup,'') >=isnull(@tasksubgroupfrom,isnull(tsk_subgroup,'')) 
		and		isnull(tsk_subgroup,'') <=isnull(@tasksubgroupto,isnull(tsk_subgroup,'')) 
		/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 ends */

		 UNION ALL

		 SELECT @ProjRepGrp					'userid',
				'R' 						'test',
				'0' 						'desc1',
				taskcode					'desc2',
				case when @prjgrp = 'PBOQ' then 'Budget'
					 else 'Contract' end	'desc3',
				Res_uom 					'desc4',  
				prj_code2					'desc5',
				NULL 						'extramt1',
				NULL 						'extramt2',
				ISNULL(outputqty2, 0)		'extramt3',
				NULL 						'extramt10',
				isnull(Itk_Coefficient_Overhead,0.0)	'extramt4',
				NULL 						'extramt5',
				NULL 						'extramt6',
				NULL 						'extramt7',
				NULL 						'extramt8',
				null						'extramt9',
				NULL 						'repgrp',
				NULL 						'plannedexpenses',
				NULL 						'expense',
				NULL 						'effortutilised',
				NULL 						'estprjcost',
				NULL 						'plannedeffort',
				Resource_Name				'prjcode1',
				Quantity					'expectedop',
				Base_Rate					'actualeffort',
				Itk_Coefficient_Wastage 	'exptilldate',
				Itk_Coefficient_FloorOH 	'exptilldate1',
				@company_address			'desc6',
				@phone						'desc7',
				@fax_no						'desc8',
				@companyname				'desc9',
				null						'desc10',
				wbsid2						'wbsid',
				ACTIVITYGRP2				'taskgroup',
				workarea2					'status1',	
				Resource_desc				'repgrp1',
				null						'taskdesc',
				null						'prjdesc',
				NULL						'extrachar2000_1',
				0.0							'extranumeric1'	,
				ISNULL(act_OUTPUTQTY2, 0)	'extranumeric2'	,
				0.0							'extranumeric3'	,
				congrp						'extrachar2000_2',--ES_PRJREP_00059 
				--congrp						'extrachar2000_2',
				--@constrngrp				'extrachar2000_2',--code commented and modified for ITS ID:ES_PRJREP_00041  
				--code commented and added for 13H120_PRJREP_00012 starts
				--saleablearea				'extranumeric5',
				@sale_area					'extranumeric5',
				--code commented and added for 13H120_PRJREP_00012 ends 
				null 						'extrachar2000_11', 
--				FOH_flag					'extrachar2000_12',
				case	isnull(FOH_flag,'')	
				when	'PER'	then	'P'
				when	'Val'	then	'F'
				else	isnull(FOH_flag,'')				
				end							'extrachar2000_12',
				null 						'extrachar2000_13', 
				Activity_variant			'extrachar2000_14',
				null 						'extrachar2000_15',
				null 						'extranumeric6',
				null 						'extranumeric7' 
				/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 begins */
				--,tsk_subgroup				'extrachar2000_7' --13H120_Masters_00007: ES_Masters_00085
				--,dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
				,isnull(tsk_subgroup,'') + case when isnull(tsk_subgroup,'') = '' then '' else ' # ' end 
				+ dbo.prjmst_get_codedesc (@ctxt_ouinstance,'TSG',tsk_subgroup,@ctxt_language)  'extrachar2000_7'		--EPE-43862
				/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00077 ends */
		 FROM   projectboq_res_tmp(nolock)
		 where  res_guid		=	@guid
		 /* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 begins */
		and		isnull(tsk_subgroup,'') >=isnull(@tasksubgroupfrom,isnull(tsk_subgroup,'')) 
		and		isnull(tsk_subgroup,'') <=isnull(@tasksubgroupto,isnull(tsk_subgroup,'')) 
		/* Code added for dts id : 13H120_Masters_00007: ES_Masters_00085 ends */	
		 
		 ORDER BY
				'desc1',
				'desc5',
				'taskgroup',
				'desc2',
				'wbsid'
	end	
	
	delete from projectboq_mtl_tmp
	where  mtl_guid		=	@guid

	delete from projectboq_res_tmp
	where  res_guid		=	@guid

	delete from ProjectBOQ_act_tmp
	where  act_guid		=	@guid
	
	drop table #congrp_tmp
	drop table #subprj_tmp
	drop table #level
	/*	Code Added for ID:ES_PRJREP_00085 begins */
	IF @rpttype = 'VARIANCE'
	BEGIN
		
	SELECT	@rpt_date = dbo.Res_getdate(@ctxt_ouinstance)
	
	IF EXISTS	(	SELECT 'X'
					FROM	PrjVariation_CurrRevno_tmp(NOLOCK)
					WHERE	Curr_guid	= @guid1
				)	
		BEGIN
		DELETE FROM PrjVariation_CurrRevno_tmp
		WHERE	Curr_guid	= @guid1
		END
	
	IF EXISTS	(	SELECT 'X'
					FROM	PrjVariation_PrevRevno_tmp(NOLOCK)
					WHERE	Prev_guid	= @guid1
				)	
		BEGIN
		DELETE FROM PrjVariation_PrevRevno_tmp
		WHERE	Prev_guid	= @guid1
		END
				
	IF @revisionno_in = @comprev_no
		BEGIN
			RAISERROR ('Revision No. and Compare with Revision No. cannot be same',16,1)
			RETURN
		END
	
	IF @revisionno_in < @comprev_no
		BEGIN
			RAISERROR ('Revision No. Should be greater than Compare with Revision No.',16,1)
			RETURN
		END
	
	IF @revisionno_in = (	Select	(MAX(/*taskwork_task_taskamendno*/taskwork_task_prjamendno)+1) --Commented and added for EPE-82815
							FROM	prjdet_taskwork_taskdtl_hist(NOLOCK)
							WHERE	taskwork_task_prjcode = @projectcodefrom
						)
		BEGIN
			
			INSERT INTO			PrjVariation_CurrRevno_tmp
			(					Curr_guid					,		Curr_prj_code					,
								Curr_WBSID					,		Curr_Task_Code					,	Curr_Work_Area			,
								Curr_Task_Group				,		Curr_Item_Code					,	Curr_Variant_Code		,
								Curr_Resource_Code			,		Curr_Task_Qty					,	Curr_Task_UOM			,
								Curr_Mat_Qty				,		Curr_Mat_UOM
						
			)

			SELECT				@guid1							,	@projectcodefrom				,
								TSK.taskwork_task_wbsid			,	TSK.taskwork_task_taskcode		,	TSK.taskwork_task_workarea		,
								MTL.taskwork_mtlreq_taskgrp		,	MTL.taskwork_mtlreq_itemcode	,	MTL.taskwork_mtlreq_vari_code	,
								RES.taskwork_resreq_resource	,	TSK.taskwork_task_outputqty		,	TSK.taskwork_task_outputuom		,
								MTL.taskwork_mtlreq_qty			, 	MTL.taskwork_mtlreq_UOM 

			FROM				prjdet_taskwork_taskdtl  TSK (NOLOCK)
			LEFT OUTER JOIN		prjdet_taskwork_mtlreq	 MTL (NOLOCK)
						ON
						(
								TSK.taskwork_task_prjou				=	MTL.taskwork_mtlreq_prjou
						AND		TSK.taskwork_task_prjcode			=	MTL.taskwork_mtlreq_prjcode
						AND		TSK.taskwork_task_prjamendno		=	MTL.taskwork_mtlreq_prjamend
						AND		TSK.taskwork_task_taskcode			=	MTL.taskwork_mtlreq_taskcode
						)
			LEFT OUTER JOIN		prjdet_taskwork_resreq	  RES (NOLOCK)
						ON
						(
								RES.taskwork_resreq_prjou			=	TSK.taskwork_task_prjou			
						AND		RES.taskwork_resreq_prjcode			=	TSK.taskwork_task_prjcode
						AND		RES.taskwork_resreq_taskcode		=	TSK.taskwork_task_taskcode		
						)
					
			WHERE		TSK.taskwork_task_prjcode					=	@projectcodefrom
			
			INSERT INTO			PrjVariation_PrevRevno_tmp
				(				Prev_guid					,		Prev_prj_code					,
								Prev_WBSID					,		Prev_Task_Code					,	Prev_Work_Area			,
								Prev_Task_Group				,		Prev_Item_Code					,	Prev_Variant_Code		,
								Prev_Resource_Code			,		Prev_Task_Qty					,	Prev_Task_UOM			,
								Prev_Mat_Qty				,		Prev_Mat_UOM
							
				)


			SELECT				@guid1							,	@projectcodefrom				,
								TSK.taskwork_task_wbsid			,	TSK.taskwork_task_taskcode		,	TSK.taskwork_task_workarea		,
								MTL.taskwork_mtlreq_taskgrp		,	MTL.taskwork_mtlreq_itemcode	,	MTL.taskwork_mtlreq_vari_code	,
								RES.taskwork_resreq_resource	,	TSK.taskwork_task_outputqty		,	TSK.taskwork_task_outputuom		,
								MTL.taskwork_mtlreq_qty			, 	MTL.taskwork_mtlreq_UOM 

			FROM				prjdet_taskwork_taskdtl_hist  TSK (NOLOCK)
			LEFT OUTER JOIN		prjdet_taskwork_mtlreq_hist	  MTL (NOLOCK)
						ON
						(
								TSK.taskwork_task_prjou				=	MTL.taskwork_mtlreq_prjou
						AND		TSK.taskwork_task_prjcode			=	MTL.taskwork_mtlreq_prjcode
						AND		TSK.taskwork_task_taskamendno		=	MTL.taskwork_mtlreq_taskamendno
						AND		TSK.taskwork_task_prjamendno		=	MTL.taskwork_mtlreq_prjamend
						AND		TSK.taskwork_task_taskcode			=	MTL.taskwork_mtlreq_taskcode
						)
			LEFT OUTER JOIN		prjdet_taskwork_resreq_hist	  RES (NOLOCK)
						ON
						(
								RES.taskwork_resreq_prjou			=	TSK.taskwork_task_prjou			
						AND		RES.taskwork_resreq_prjcode			=	TSK.taskwork_task_prjcode		
						AND		RES.taskwork_resreq_prjamendno		=	TSK.taskwork_task_taskamendno	
						AND		RES.taskwork_resreq_taskamendno		=	TSK.taskwork_task_prjamendno
						AND		RES.taskwork_resreq_taskcode		=	TSK.taskwork_task_taskcode	
						)
								
			WHERE		TSK.taskwork_task_prjcode					=	@projectcodefrom
			/*code commented and added for the id EPE-82815 starts here */
			/*AND			TSK.taskwork_task_prjamendno				=	(
																		 SELECT MAX(taskwork_task_prjamendno)
																		 FROM	prjdet_taskwork_taskdtl_hist A (NOLOCK)
																		 WHERE  TSK.taskwork_task_prjou		=	A.taskwork_task_prjou
																		 AND	TSK.taskwork_task_prjcode	=	A.taskwork_task_prjcode
																		 )
			AND			TSK.taskwork_task_taskamendno				=	@comprev_no*/
			and TSK.taskwork_task_prjamendno = @comprev_no 
			/*code commented and added for the id EPE-82815 ends here */

		END
		
	ELSE
		BEGIN
		
			INSERT INTO			PrjVariation_CurrRevno_tmp
			(					Curr_guid					,		Curr_prj_code					,
								Curr_WBSID					,		Curr_Task_Code					,	Curr_Work_Area			,
								Curr_Task_Group				,		Curr_Item_Code					,	Curr_Variant_Code		,
								Curr_Resource_Code			,		Curr_Task_Qty					,	Curr_Task_UOM			,
								Curr_Mat_Qty				,		Curr_Mat_UOM
						
			)

			SELECT				@guid1							,	@projectcodefrom				,
								TSK.taskwork_task_wbsid			,	TSK.taskwork_task_taskcode		,	TSK.taskwork_task_workarea		,
								MTL.taskwork_mtlreq_taskgrp		,	MTL.taskwork_mtlreq_itemcode	,	MTL.taskwork_mtlreq_vari_code	,
								RES.taskwork_resreq_resource	,	TSK.taskwork_task_outputqty		,	TSK.taskwork_task_outputuom		,
								MTL.taskwork_mtlreq_qty			, 	MTL.taskwork_mtlreq_UOM 

			FROM				prjdet_taskwork_taskdtl_hist  TSK (NOLOCK)
			LEFT OUTER JOIN		prjdet_taskwork_mtlreq_hist	  MTL (NOLOCK)
						ON
						(
								TSK.taskwork_task_prjou				=	MTL.taskwork_mtlreq_prjou
						AND		TSK.taskwork_task_prjcode			=	MTL.taskwork_mtlreq_prjcode
						AND		TSK.taskwork_task_taskamendno		=	MTL.taskwork_mtlreq_taskamendno
						AND		TSK.taskwork_task_prjamendno		=	MTL.taskwork_mtlreq_prjamend
						AND		TSK.taskwork_task_taskcode			=	MTL.taskwork_mtlreq_taskcode
						)
			LEFT OUTER JOIN		prjdet_taskwork_resreq_hist	  RES (NOLOCK)
						ON
						(
								RES.taskwork_resreq_prjou			=	TSK.taskwork_task_prjou			
						AND		RES.taskwork_resreq_prjcode			=	TSK.taskwork_task_prjcode		
						AND		RES.taskwork_resreq_prjamendno		=	TSK.taskwork_task_taskamendno	
						AND		RES.taskwork_resreq_taskamendno		=	TSK.taskwork_task_prjamendno	
						AND		RES.taskwork_resreq_taskcode		=	TSK.taskwork_task_taskcode	
						)
								
			WHERE		TSK.taskwork_task_prjcode		=	@projectcodefrom
			/*code commented and added for the id EPE-82815 starts here */
			/*AND			TSK.taskwork_task_prjamendno	=	(
															 SELECT MAX(taskwork_task_prjamendno)
															 FROM	prjdet_taskwork_taskdtl_hist A (NOLOCK)
												 WHERE  TSK.taskwork_task_prjou		=	A.taskwork_task_prjou
												 AND	TSK.taskwork_task_prjcode	=	A.taskwork_task_prjcode
												 )
			AND			TSK.taskwork_task_taskamendno				=	@revisionno_in*/
			AND			TSK.taskwork_task_prjamendno	=@revisionno_in
			/*code commented and added for the id EPE-82815 ends here */
												 
			INSERT INTO 		PrjVariation_PrevRevno_tmp
		    (					Prev_guid					,		Prev_prj_code					,
								Prev_WBSID					,		Prev_Task_Code					,	Prev_Work_Area			,
								Prev_Task_Group				,		Prev_Item_Code					,	Prev_Variant_Code		,
								Prev_Resource_Code			,		Prev_Task_Qty					,	Prev_Task_UOM			,
								Prev_Mat_Qty				,		Prev_Mat_UOM
					
		    )


			SELECT				@guid1							,	@projectcodefrom				,
								TSK.taskwork_task_wbsid			,	TSK.taskwork_task_taskcode		,	TSK.taskwork_task_workarea		,
								MTL.taskwork_mtlreq_taskgrp		,	MTL.taskwork_mtlreq_itemcode	,	MTL.taskwork_mtlreq_vari_code	,
								RES.taskwork_resreq_resource	,	TSK.taskwork_task_outputqty		,	TSK.taskwork_task_outputuom		,
								MTL.taskwork_mtlreq_qty			, 	MTL.taskwork_mtlreq_UOM 

			FROM				prjdet_taskwork_taskdtl_hist  TSK (NOLOCK)
			LEFT OUTER JOIN		prjdet_taskwork_mtlreq_hist	  MTL (NOLOCK)
						ON
						(
								TSK.taskwork_task_prjou				=	MTL.taskwork_mtlreq_prjou
						AND		TSK.taskwork_task_prjcode			=	MTL.taskwork_mtlreq_prjcode
						AND		TSK.taskwork_task_taskamendno		=	MTL.taskwork_mtlreq_taskamendno
						AND		TSK.taskwork_task_prjamendno		=	MTL.taskwork_mtlreq_prjamend
						AND		TSK.taskwork_task_taskcode			=	MTL.taskwork_mtlreq_taskcode
						)
			LEFT OUTER JOIN		prjdet_taskwork_resreq_hist	  RES (NOLOCK)
						ON
						(
								RES.taskwork_resreq_prjou			=	TSK.taskwork_task_prjou			
						AND		RES.taskwork_resreq_prjcode			=	TSK.taskwork_task_prjcode		
						AND		RES.taskwork_resreq_prjamendno		=	TSK.taskwork_task_taskamendno	
						AND		RES.taskwork_resreq_taskamendno		=	TSK.taskwork_task_prjamendno
						AND		RES.taskwork_resreq_taskcode		=	TSK.taskwork_task_taskcode	
						)
								
			WHERE		TSK.taskwork_task_prjcode		=	@projectcodefrom
				/*code commented and added for the id EPE-82815 starts here */
			AND			TSK.taskwork_task_prjamendno	=	(
															 SELECT MAX(taskwork_task_prjamendno)
															 FROM	prjdet_taskwork_taskdtl_hist A (NOLOCK)
															 WHERE  TSK.taskwork_task_prjou		=	A.taskwork_task_prjou
															 AND	TSK.taskwork_task_prjcode	=	A.taskwork_task_prjcode
															 )
			AND			TSK.taskwork_task_taskamendno				=	@comprev_no
            AND			TSK.taskwork_task_prjamendno	=@comprev_no
				/*code commented and added for the id EPE-82815 ends here */
		END
		
		UPDATE	CURR_TMP
		SET		Curr_Itmvar_Desc				=	loi_itemdesc
		FROM	itm_loi_itemhdr  ITM(NOLOCK),PrjVariation_CurrRevno_tmp CURR_TMP
		WHERE	Curr_guid						=	@guid1
		AND		ITM.loi_itemcode				=	CURR_TMP.Curr_Item_Code
		AND		ITM.loi_lo						=	@lo_id
				
		
		UPDATE	PREV_TMP
		SET		Prev_Itmvar_Desc				=	loi_itemdesc
		FROM	itm_loi_itemhdr ITM(NOLOCK),PrjVariation_PrevRevno_tmp PREV_TMP
		WHERE	Prev_guid						=	@guid1
		AND		ITM.loi_itemcode				=	PREV_TMP.Prev_Item_Code
		AND		ITM.loi_lo						=	@lo_id
				
		
		UPDATE	CURR_TMP
		SET		Curr_Task_Desc					=	prjmst_act_hdr_actdesc
		FROM	prjmst_activity_hdr ITM(NOLOCK),PrjVariation_CurrRevno_tmp CURR_TMP
		WHERE	Curr_guid						=	@guid1
		AND		ITM.prjmst_act_hdr_actcode		=	CURR_TMP.Curr_Task_Code
		AND		ITM.prjmst_act_hdr_actou		=	@ctxt_ouinstance
				
		
		UPDATE	PREV_TMP
		SET		Prev_Task_Desc					=	prjmst_act_hdr_actdesc
		FROM	prjmst_activity_hdr ITM(NOLOCK),PrjVariation_PrevRevno_tmp PREV_TMP
		WHERE	Prev_guid						=	@guid1
		AND		ITM.prjmst_act_hdr_actcode		=	PREV_TMP.Prev_Task_Code
		AND		ITM.prjmst_act_hdr_actou		=	@ctxt_ouinstance
				
		
		UPDATE	CURR_TMP
		SET		Curr_Resource_Desc				=	prjmst_res_resdesc
		FROM	prjmst_resource_mst ITM(NOLOCK),PrjVariation_CurrRevno_tmp CURR_TMP
		WHERE	Curr_guid						=	@guid1
		AND		ITM.prjmst_res_rescode			=	CURR_TMP.Curr_Resource_Code
		AND		ITM.prjmst_res_ou				=	@ctxt_ouinstance
				
		
		UPDATE	PREV_TMP
		SET		Prev_Resource_Desc				=	prjmst_res_resdesc
		FROM	prjmst_resource_mst ITM(NOLOCK),PrjVariation_PrevRevno_tmp PREV_TMP
		WHERE	Prev_guid						=	@guid1
		AND		ITM.prjmst_res_rescode			=	PREV_TMP.Prev_Resource_Code
		AND		ITM.prjmst_res_ou				=	@ctxt_ouinstance
				
		
		-- Addition Report
		SELECT	DISTINCT
				null 						'actualeffort', 
				null 						'actualenddate', 
				null 						'actualstartdate', 
				Curr_WBSID 					'bu',				
				Curr_Task_Code 				'bu1', 
				null 						'desc1', 
				null 						'desc10', 
				Curr_Task_Desc 				'desc2', 
				'VARIANCE'					'desc3', 
				Curr_Itmvar_Desc 			'desc4', 
				Curr_Resource_Desc 			'desc5', 
				null 						'desc6', 
				null 						'desc7', 
				null 						'desc8', 
				null 						'desc9', 
				Curr_Task_Group 			'effortuom', 
				Curr_Task_UOM 				'effortuom1', 
				null 						'effortutilised', 
				null 						'estprjcost', 
				null 						'expectedop', 
				null 						'expense', 
				null 						'exptilldate', 
				null 						'exptilldate1', 
				Curr_Task_Qty 				'extramt1', 
				null 						'extramt10', 
				Curr_Mat_Qty 				'extramt2', 
				Curr_Chg_Val 				'extramt3', 
				null 						'extramt4', 
				null 						'extramt5', 
				null 						'extramt6', 
				null 						'extramt7', 
				null 						'extramt8', 
				2 							'extramt9', 
				Curr_Mat_UOM 				'opuom', 
				Curr_Variant_Code 			'ou', 
				null 						'ou1', 
				null 						'plannedeffort', 
				null 						'plannedenddate', 
				null 						'plannedexpenses', 
				@projectcodefrom			'prjcode', 
				Curr_Work_Area 				'prjcode1', 
				@projectname				'prjdesc', 
				null 						'prjenddate', 
				Curr_Resource_Code 			'prjindication', 
				Curr_Item_Code 				'prjmanager', 
				null 						'prjname', 
				null 						'prjstartdate', 
				@rpt_date					'repgrp', 
				null 						'repgrp1', 
				null 						'reportid', 
				null 						'reportid1', 
				null 						'revisionno', 
				null 						'status', 
				null 						'status1', 
				null 						'taskdesc', 
				null 						'taskgroup', 
				null 						'userid', 
				null 						'userid1', 
				null 						'wbsid', 
				null 						'extrachar2000_1', 
				@revisionno_in				'extrachar2000_2', 
				@comprev_no					'extrachar2000_3', 
				'Addition Report output' 	'extrachar2000_4', 
				null 						'extrachar2000_5', 
				null 						'extranumeric1', 
				null 						'extranumeric2', 
				null 						'extranumeric3', 
				null 						'extranumeric4', 
				null 						'extranumeric5', 
				null 						'extrachar2000_6', 
				null 						'extrachar2000_7', 
				null 						'extrachar2000_8', 
				null 						'extrachar2000_9', 
				null 						'extrachar2000_10', 
				null 						'extranumeric6', 
				null 						'extranumeric7', 
				null 						'extranumeric8', 
				null 						'extranumeric9', 
				null 						'extranumeric10', 
				null 						'extrachar2000_11', 
				null 						'extrachar2000_12', 
				null 						'extrachar2000_13', 
				null 						'extrachar2000_14', 
				null 						'extrachar2000_15' 
		
		FROM	PrjVariation_CurrRevno_tmp CURR_TMP(NOLOCK)
		LEFT OUTER JOIN
				PrjVariation_PrevRevno_tmp PREV_TMP(NOLOCK)
		ON	(
				CURR_TMP.Curr_prj_code		= PREV_TMP.Prev_prj_code
		AND		CURR_TMP.Curr_Task_Code		= PREV_TMP.Prev_Task_Code
		AND		CURR_TMP.Curr_Item_Code		= PREV_TMP.Prev_Item_Code
		AND		CURR_TMP.Curr_Resource_Code = PREV_TMP.Prev_Resource_Code
		AND		PREV_TMP.Prev_guid			= @guid1		
			)
		WHERE	PREV_TMP.Prev_prj_code IS NULL
		AND		CURR_TMP.Curr_guid	=	@guid1		
		UNION ALL
		-- Deletion Report
		SELECT	DISTINCT
				null 						'actualeffort', 
				Prev_Variant_Code 			'actualenddate', 
				null 						'actualstartdate', 
				null 						'bu', 
				null 						'bu1', 
				null 						'desc1', 
				null 						'desc10', 
				null 						'desc2', 
				'VARIANCE'					'desc3', 
				null 						'desc4', 
				null 						'desc5', 
				Prev_Task_Desc				'desc6', 
				Prev_Itmvar_Desc 			'desc7', 
				Prev_Resource_Desc 			'desc8', 
				null 						'desc9', 
				null 						'effortuom', 
				null 						'effortuom1', 
				null 						'effortutilised', 
				null 						'estprjcost', 
				null 						'expectedop', 
				null 						'expense', 
				null 						'exptilldate', 
				null 						'exptilldate1', 
				null 						'extramt1', 
				null 						'extramt10', 
				null 						'extramt2', 
				null 						'extramt3', 
				Prev_Task_Qty 				'extramt4', 
				Prev_Mat_Qty 				'extramt5', 
				Prev_Chg_Val 				'extramt6', 
				null 						'extramt7', 
				null 						'extramt8', 
				2 							'extramt9', 
				null 						'opuom', 
				null 						'ou', 
				null 						'ou1', 
				null 						'plannedeffort', 
				null 						'plannedenddate', 
				null 						'plannedexpenses', 
				@projectcodefrom			'prjcode', 
				null 						'prjcode1', 
				@projectname				'prjdesc', 
				null 						'prjenddate', 
				null 						'prjindication', 
				null 						'prjmanager', 
				Prev_Task_Code 				'prjname', 
				null 						'prjstartdate', 
				@rpt_date					'repgrp', 
				Prev_Task_Group 			'repgrp1', 
				Prev_Work_Area 				'reportid', 
				Prev_Item_Code 				'reportid1', 
				Prev_WBSID 					'revisionno', 
				Prev_Task_UOM 				'status', 
				Prev_Resource_Code 			'status1', 
				null 						'taskdesc', 
				null 						'taskgroup', 
				Prev_Mat_UOM 				'userid', 
				null 						'userid1', 
				null 						'wbsid', 
				NULL 						'extrachar2000_1', 
				@revisionno_in				'extrachar2000_2', 
				@comprev_no					'extrachar2000_3', 
				'Deletion Report output' 	'extrachar2000_4', 
				null 						'extrachar2000_5', 
				null 						'extranumeric1', 
				null 						'extranumeric2', 
				null 						'extranumeric3', 
				null 						'extranumeric4', 
				null 						'extranumeric5', 
				null 						'extrachar2000_6', 
				null 						'extrachar2000_7', 
				null 						'extrachar2000_8', 
				null 						'extrachar2000_9', 
				null 						'extrachar2000_10', 
				null 						'extranumeric6', 
				null 						'extranumeric7', 
				null 						'extranumeric8', 
				null 						'extranumeric9', 
				null 						'extranumeric10', 
				null 						'extrachar2000_11', 
				null 						'extrachar2000_12', 
				null 						'extrachar2000_13', 
				null 						'extrachar2000_14', 
				null 						'extrachar2000_15' 
		FROM	PrjVariation_CurrRevno_tmp CURR_TMP(NOLOCK)
		RIGHT OUTER JOIN
				PrjVariation_PrevRevno_tmp PREV_TMP(NOLOCK)
		ON	(
				CURR_TMP.Curr_prj_code		= PREV_TMP.Prev_prj_code
		AND		CURR_TMP.Curr_Task_Code		= PREV_TMP.Prev_Task_Code
		AND		CURR_TMP.Curr_Item_Code		= PREV_TMP.Prev_Item_Code
		AND		CURR_TMP.Curr_Resource_Code = PREV_TMP.Prev_Resource_Code
		AND		CURR_TMP.Curr_guid			= @guid1
				
			)	
		WHERE	CURR_TMP.Curr_prj_code IS NULL
		AND		PREV_TMP.Prev_guid	=	@guid1
		
		UNION ALL
		-- Change in Qty Report
		SELECT	DISTINCT
				null 						'actualeffort', 
				null 						'actualenddate', 
				Curr_WBSID 					'actualstartdate', 
				null 						'bu', 
				null 						'bu1', 
				null 						'desc1', 
				Curr_Itmvar_Desc 			'desc10', 
				null 						'desc2', 
				'VARIANCE'					'desc3', 
				null 						'desc4', 
				null 						'desc5', 
				null 						'desc6', 
				null 						'desc7', 
				null 						'desc8', 
				Curr_Task_Desc 				'desc9', 
				null 						'effortuom', 
				null 						'effortuom1', 
				null 						'effortutilised', 
				null 						'estprjcost', 
				null 						'expectedop', 
				null 						'expense', 
				null 						'exptilldate', 
				null 						'exptilldate1', 
				null 						'extramt1', 
				Curr_Chg_Val				'extramt10', 
				null 						'extramt2', 
				null 						'extramt3', 
				null 						'extramt4', 
				null 						'extramt5', 
				null 						'extramt6', 
				Curr_Task_Qty 				'extramt7',			-- Current Qty
				Prev_Task_Qty 				'extramt8',			-- Previous Qty	
				2	 						'extramt9', 
				null 						'opuom', 
				null 						'ou', 
				Curr_Item_Code 				'ou1', 
				null 						'plannedeffort', 
				Curr_Task_UOM 				'plannedenddate',	-- Current UOM
				null 						'plannedexpenses', 
				@projectcodefrom			'prjcode', 
				null 						'prjcode1', 
				@projectname				'prjdesc', 
				Prev_Task_UOM 				'prjenddate',		-- Previous UOM
				null 						'prjindication', 
				null 						'prjmanager', 
				null 						'prjname', 
				Curr_Variant_Code 			'prjstartdate', 
				@rpt_date					'repgrp', 
				null 						'repgrp1', 
				null 						'reportid', 
				null 						'reportid1', 
				null 						'revisionno', 
				null 						'status', 
				null 						'status1', 
				Curr_Resource_Code 			'taskdesc', 
				Curr_Work_Area 				'taskgroup', 
				null 						'userid', 
				Curr_Task_Code 				'userid1', 
				Curr_Task_Group 			'wbsid', 
				Curr_Resource_Desc 			'extrachar2000_1', 
				@revisionno_in				'extrachar2000_2', 
				@comprev_no					'extrachar2000_3', 
				'Change Qty Report output' 	'extrachar2000_4', 
				null 						'extrachar2000_5', 
				null 						'extranumeric1', 
				null 						'extranumeric2', 
				null 						'extranumeric3', 
				null 						'extranumeric4', 
				null 						'extranumeric5', 
				null 						'extrachar2000_6', 
				null 						'extrachar2000_7', 
				null 						'extrachar2000_8', 
				null 						'extrachar2000_9', 
				null 						'extrachar2000_10', 
				null 						'extranumeric6', 
				null 						'extranumeric7', 
				null 						'extranumeric8', 
				null 						'extranumeric9', 
				null 						'extranumeric10', 
				null 						'extrachar2000_11', 
				null 						'extrachar2000_12', 
				null 						'extrachar2000_13', 
				null 						'extrachar2000_14', 
				null 						'extrachar2000_15' 
				
		FROM	PrjVariation_CurrRevno_tmp CURR_TMP(NOLOCK)
		INNER JOIN
				PrjVariation_PrevRevno_tmp PREV_TMP(NOLOCK)
		ON	(
				CURR_TMP.Curr_prj_code		=	PREV_TMP.Prev_prj_code
		AND		CURR_TMP.Curr_Task_Code		=	PREV_TMP.Prev_Task_Code
		AND		CURR_TMP.Curr_Item_Code		=	PREV_TMP.Prev_Item_Code
		AND		CURR_TMP.Curr_guid			=	PREV_TMP.Prev_guid	
			)
		WHERE	(
						CURR_TMP.Curr_Task_Qty		<>	PREV_TMP.Prev_Task_Qty
				OR		CURR_TMP.Curr_Mat_Qty		<>	PREV_TMP.Prev_Mat_Qty
				)
		AND		CURR_TMP.Curr_guid	=	@guid1
		AND		PREV_TMP.Prev_guid	=	@guid1
								
	
	END	
	
	DELETE FROM PrjVariation_CurrRevno_tmp
	WHERE	Curr_guid = @guid1
	
	
	DELETE FROM PrjVariation_PrevRevno_tmp
	WHERE	Prev_guid = @guid1
	
	/*	Code Added for ID:ES_PRJREP_00085 ends */
	/*
	   
	 /*   
	 --OutputList  
	  Select 
	  null 'actualeffort',   
	  null 'actualenddate',  
	  null 'actualstartdate',   
	  null 'bu',   
	  null 'bu1',   
	  null 'desc1',   
	  null 'desc10',   --
	  null 'desc2',   
	  null 'desc3',   
	  null 'desc4',   
	  null 'desc5',   
	  null 'desc6',  --- 
	  null 'desc7',   ---
	  null 'desc8',  --- 
	  null 'desc9',  --- 
	  null 'effortuom',   
	  null 'effortuom1',   
	  null 'effortutilised',   
	  null 'estprjcost',   
	  null 'expectedop',   
	  null 'expense',   
	  null 'exptilldate',   
	  null 'exptilldate1',   
	  null 'extramt1',   
	  null 'extramt10',   
	  null 'extramt2',   
	  null 'extramt3',   
	  null 'extramt4',   
	  null 'extramt5',   
	  null 'extramt6',   
	  null 'extramt7',   
	  null 'extramt8',   
	  null 'extramt9',   
	  null 'opuom',   
	  null 'ou',   
	  null 'ou1',   
	  null 'plannedeffort',   
	  null 'plannedenddate',   
	  null 'plannedexpenses',   
	  null 'prjcode',   
	  null 'prjcode1',   
	  null 'prjdesc',   
	  null 'revisionno',   
	  null 'prjenddate',   
	  null 'prjindication',   
	  null 'prjmanager',   
	  null 'prjname',   
	  null 'prjstartdate',   
	  null 'repgrp',   
	  null 'repgrp1',   
	  null 'reportid', 
	  null 'reportid1',   
	  null 'status',   
	  null 'status1', 
	  null 'taskdesc',   --
	  null 'taskgroup',  -- 
	  null 'userid',   --
	  null 'userid1', --
	  null 'wbsid',   --
	 */  
	 */  
	Set nocount off  
	  
	End



















