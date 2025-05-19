/*$File_version=MS4.3.0.01$*/
/* $$Component Name=PRJREP             */
/********************************************************************************/
/* Procedure    : AAR_PrStsSp_Hp_Projeohrf                                      */
/* Description  :                                                               */
/********************************************************************************/
/* Project      :                                                               */
/* ECR          :                                                               */
/* Version      :                                                               */
/********************************************************************************/
/* Referenced   :                                                               */
/* Tables       :                                                               */
/********************************************************************************/
/* Development history                                                          */
/********************************************************************************/
/* Author       :				                                                */
/* Date         :			                                                    */
/********************************************************************************/
/* Modification history                                                         */
/********************************************************************************/
/* Modified by  : Kavitha B                                                     */
/* Date         : 09/03/2023                                                    */
/* Description  : EPE-64115                                                     */
/********************************************************************************/
--grant exec on PRE_PrStsSp_Hp_Projeohrf to public
Create Procedure AAR_PrStsSp_Hp_Projeohrf
	@ctxt_ouinstance                                            udd_ctxt_OUInstance,  --Input 
	@ctxt_user                                                  udd_ctxt_User,  --Input 
	@ctxt_language                                              udd_ctxt_Language,  --Input 
	@ctxt_service                                               udd_ctxt_Service,  --Input 
	@activitycodefrom                                           cim_guidencetext,  --Input/Output 
	@activitycodeto                                             cim_guidencetext,  --Input/Output 
	@activitygroupfrom                                          cim_guidencetext,  --Input/Output 
	@activitygroupto                                            cim_guidencetext,  --Input/Output 
	@constructiongroup                                          cim_guidencetext,  --Input/Output 
	@contractor                                                 chkflag,  --Input/Output 
	@contractor_res                                             chkflag,  --Input/Output 
	@csouinstance                                               udd_ctxt_ouinstance,  --Input/Output 
	@customer                                                   customer_id,  --Input/Output 
	@customer_res                                               chkflag,  --Input/Output 
	@detailed                                                   udd_Desc20,  --Input/Output 
	@guid                                                       udd_GUID,  --Input/Output 
	@level                                                      cim_guidencetext,  --Input/Output 
	@orgunit                                                    udd_Desc20,  --Input/Output 
	@projectcodefrom                                            udd_transactionno,  --Input/Output 
	@projectcodeto                                              udd_transactionno,  --Input/Output 
	@projectenddate                                             udd_Desc20,  --Input/Output 
	@projectname                 udd_Item_Desc,  --Input/Output 
	@projectstartdate                                           udd_Desc20,  --Input/Output 
	@projectstatus                                              udd_Status,  --Input/Output 
	@projrepgrp                                                 udd_Type,  --Input/Output 
	@reporttype                                                 flag50,  --Input/Output 
	@self                                                       chkflag,  --Input/Output 
	@self_res                                                   chkflag,  --Input/Output 
	@starepfor                                                  Type,  --Input/Output 
	@subcontarcted                                              Uomcode,  --Input/Output 
	@textcontrol1                                               udd_Desc20,  --Input/Output 
	@textcontrol2                                               udd_Desc20,  --Input/Output 
	@timestamp                                                  udd_timestamp,  --Input/Output 
	@tranou                                                     udd_ctxt_ouinstance,  --Input/Output 
	@trantype                                                   transactiontype,  --Input/Output 
	@workarea                                                   cim_guidencetext,  --Input/Output 
	@activitygroupvariantfrom 									cim_guidencetext, --Input/Output
	@activitygroupvariantto   									cim_guidencetext, --Input/Output
	@m_errorid                                                  udd_int output --To Return Execution Status 

as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	
	-- @m_errorid should be 0 to Indicate Success
	Set @m_errorid = 0
	
	--declaration of temporary variables
	--temporary and formal parameters mapping
	SET @ctxt_user                                                   = ltrim(rtrim(@ctxt_user))
	SET @ctxt_service                                                = ltrim(rtrim(@ctxt_service))
	SET @activitycodefrom                                            = ltrim(rtrim(@activitycodefrom))
	SET @activitycodeto                                              = ltrim(rtrim(@activitycodeto))
	SET @activitygroupfrom                                           = ltrim(rtrim(@activitygroupfrom))
	SET @activitygroupto                                             = ltrim(rtrim(@activitygroupto))
	SET @constructiongroup                                           = ltrim(rtrim(@constructiongroup))
	SET @contractor                                                  = ltrim(rtrim(@contractor))
	SET @contractor_res                                              = ltrim(rtrim(@contractor_res))
	SET @customer                                                    = ltrim(rtrim(@customer))
	SET @customer_res                                                = ltrim(rtrim(@customer_res))
	SET @detailed                                                    = ltrim(rtrim(@detailed))
	SET @guid                                                        = ltrim(rtrim(@guid))
	SET @level                                                       = ltrim(rtrim(@level))
	SET @orgunit                                                     = ltrim(rtrim(@orgunit))
	SET @projectcodefrom                                             = ltrim(rtrim(@projectcodefrom))
	SET @projectcodeto                                               = ltrim(rtrim(@projectcodeto))
	SET @projectenddate                                              = ltrim(rtrim(@projectenddate))
	SET @projectname                                                 = ltrim(rtrim(@projectname))
	SET @projectstartdate                                            = ltrim(rtrim(@projectstartdate))
	SET @projectstatus                                               = ltrim(rtrim(@projectstatus))
	SET @projrepgrp                                                  = ltrim(rtrim(@projrepgrp))
	SET @reporttype                = ltrim(rtrim(@reporttype))
	SET @self                                                        = ltrim(rtrim(@self))
	SET @self_res                                                    = ltrim(rtrim(@self_res))
	SET @starepfor                                                   = ltrim(rtrim(@starepfor))
	SET @subcontarcted                                               = ltrim(rtrim(@subcontarcted))
	SET @textcontrol1                                                = ltrim(rtrim(@textcontrol1))
	SET @textcontrol2                                                = ltrim(rtrim(@textcontrol2))
	SET @trantype                                                    = ltrim(rtrim(@trantype))
	SET @workarea                                                    = ltrim(rtrim(@workarea))
	select @activitygroupvariantfrom								 = ltrim(rtrim(@activitygroupvariantfrom))
	select @activitygroupvariantto									 = ltrim(rtrim(@activitygroupvariantto))
		
	--null checking
	IF @ctxt_ouinstance = -915
		SET @ctxt_ouinstance = null  
	IF @ctxt_user = '~#~'
		SET @ctxt_user = null  
	IF @ctxt_language = -915
		SET @ctxt_language = null  
	IF @ctxt_service = '~#~'
		SET @ctxt_service = null  
	IF @activitycodefrom = '~#~'
		SET @activitycodefrom = null  
	IF @activitycodeto = '~#~'
		SET @activitycodeto = null  
	IF @activitygroupfrom = '~#~'
		SET @activitygroupfrom = null  
	IF @activitygroupto = '~#~'
		SET @activitygroupto = null  
	IF @constructiongroup = '~#~'
		SET @constructiongroup = null  
	IF @contractor = '~#~'
		SET @contractor = null  
	IF @contractor_res = '~#~'
		SET @contractor_res = null  
	IF @csouinstance = -915
		SET @csouinstance = null  
	IF @customer = '~#~'
		SET @customer = null  
	IF @customer_res = '~#~'
		SET @customer_res = null  
	IF @detailed = '~#~'
		SET @detailed = null  
	IF @guid = '~#~'
		SET @guid = null  
	IF @level = '~#~'
		SET @level = null  
	IF @orgunit = '~#~'
		SET @orgunit = null  
	IF @projectcodefrom = '~#~'
		SET @projectcodefrom = null  
	IF @projectcodeto = '~#~'
		SET @projectcodeto = null  
	IF @projectenddate = '~#~'
		SET @projectenddate = null  
	IF @projectname = '~#~'
		SET @projectname = null  
	IF @projectstartdate = '~#~'
		SET @projectstartdate = null  
	IF @projectstatus = '~#~'
		SET @projectstatus = null  
	IF @projrepgrp = '~#~'
		SET @projrepgrp = null  
	IF @reporttype = '~#~'
		SET @reporttype = null  
	IF @self = '~#~'
		SET @self = null  
	IF @self_res = '~#~'
		SET @self_res = null  
	IF @starepfor = '~#~'
		SET @starepfor = null  
	IF @subcontarcted = '~#~'
		SET @subcontarcted = null  
	IF @textcontrol1 = '~#~'
		SET @textcontrol1 = null  
	IF @textcontrol2 = '~#~'
		SET @textcontrol2 = null  
	IF @timestamp = -915
		SET @timestamp = null  
	IF @tranou = -915
		SET @tranou = null  
	IF @trantype = '~#~'
		SET @trantype = null  
	IF @workarea = '~#~'
		SET @workarea = null 
	IF @activitygroupvariantfrom = '~#~' 
		Select @activitygroupvariantfrom = null  
	IF @activitygroupvariantto = '~#~' 
		Select @activitygroupvariantto = null  
	
	--Code commented and added for DLLE-2545 starts
	/*Select	null					'activitycodefrom', 
			null					'activitycodeto', 
			null					'activitygroupfrom', 
			null					'activitygroupto', 
			null					'constructiongroup', 
			null					'contractor', 
			null					'contractor_res', 
			@ctxt_ouinstance		'csouinstance', 
			null					'customer', 
			null					'customer_res', 
			null					'detailed', 
			null					'guid', 
			null					'level', 
			null					'orgunit', 
			null					'projectcodefrom', 
			null					'projectcodeto', 
			null					'projectenddate', 
			null					'projectname', 
			null					'projectstartdate', 
			null					'projectstatus', 
			null					'projrepgrp', 
			null					'reporttype', 
			null					'self', 
			null					'self_res', 
			null					'starepfor', 
			null					'subcontarcted', 
			null					'textcontrol1', 
			null					'textcontrol2', 
			null					'timestamp', 
			null					'tranou', 
			null					'trantype', 
			null					'workarea',
			null					'activitygroupvariantfrom', 
			null					'activitygroupvariantto'*/
	
	Select	@activitycodefrom					'activitycodefrom', 
			@activitycodeto						'activitycodeto', 
			@activitygroupfrom					'activitygroupfrom', 
			@activitygroupto					'activitygroupto', 
			@constructiongroup					'constructiongroup', 
			@contractor							'contractor', 
			@contractor_res						'contractor_res', 
			@ctxt_ouinstance					'csouinstance', 
			@customer							'customer', 
			@customer_res						'customer_res', 
			@detailed							'detailed', 
			@guid								'guid', 
			@level								'level', 
			@orgunit							'orgunit', 
			@projectcodefrom					'projectcodefrom', 
			@projectcodeto						'projectcodeto', 
			@projectenddate						'projectenddate', 
			@projectname						'projectname', 
			@projectstartdate					'projectstartdate', 
			@projectstatus						'projectstatus', 
			@projrepgrp							'projrepgrp', 
			@reporttype							'reporttype', 
			@self								'self', 
			@self_res							'self_res', 
			@starepfor							'starepfor', 
			@subcontarcted						'subcontarcted', 
			@textcontrol1						'textcontrol1', 
			@textcontrol2						'textcontrol2', 
			@timestamp							'timestamp', 
			@tranou								'tranou', 
			@trantype							'trantype', 
			@workarea							'workarea',
			@activitygroupvariantfrom			'activitygroupvariantfrom', 
			@activitygroupvariantto				'activitygroupvariantto'
	--Code commented and added for DLLE-2545 ends
	
	
/* 
	--OuputList
	Select null 'activitycodefrom', 
	null 'activitycodeto', 
	null 'activitygroupfrom', 
	null 'activitygroupto', 
	null 'constructiongroup', 
	null 'contractor', 
	null 'contractor_res', 
	null 'csouinstance', 
	null 'customer', 
	null 'customer_res', 
	null 'detailed', 
	null 'guid', 
	null 'level', 
	null 'orgunit', 
	null 'projectcodefrom', 
	null 'projectcodeto', 
	null 'projectenddate', 
	null 'projectname', 
	null 'projectstartdate', 
	null 'projectstatus', 
	null 'projrepgrp', 
	null 'reporttype', 
	null 'self', 
	null 'self_res', 
	null 'starepfor', 
	null 'subcontarcted', 
	null 'textcontrol1', 
	null 'textcontrol2', 
	null 'timestamp', 
	null 'tranou', 
	null 'trantype', 
	null 'workarea' from *** 
*/
	
	Set nocount off

End


