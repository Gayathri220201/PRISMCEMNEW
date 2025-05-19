/*$File_version=MS4.3.0.03$*/
/* $$Component Name=PRJREP*/
/******************************************************************************/
/* Procedure					: AAR_PrstsSPinitRpttyp								 */
/* Description					: 								 */
/******************************************************************************/
/* Project						: 								 */
/* EcrNo						: 								 */
/* Version						: 								 */
/******************************************************************************/
/* Referenced					: 								 */
/* Tables						: 								 */
/******************************************************************************/
/* Development history			: 								 */
/******************************************************************************/
/* Author						: model								 */
/* Date							: Aug 23 2010  4:58PM								 */
/******************************************************************************/
/* Modification History			: 								 */
/*****************************************************************************/
/* Modified By					: 								 */
/* Date							: 								 */
/* Description					: 								 */
/******************************************************************************/
/* Lavanya K J				11/04/2013			13H120_PRJREP_00001				*/
/* Manoj Kumar S			18/03/2014			ES_PRJREP_00085					*/
/* Kavitha B				06/09/2022			EPE-55557						*/

--GRANT EXEC ON PRE_PrstsSPinitRpttyp TO PUBLIC
Create Procedure AAR_PrstsSPinitRpttyp
	@ctxt_ouinstance 	udd_ctxt_ouinstance, --Input 
	@ctxt_user       	udd_ctxt_user, --Input 
	@ctxt_language   	udd_ctxt_language, --Input 
	@ctxt_service    	udd_ctxt_service, --Input 
	@m_errorid       	udd_int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Set @m_errorid = 0

	--declaration of temporary variables


	--temporary and formal parameters mapping

	Set @ctxt_user        = ltrim(rtrim(@ctxt_user))
	Set @ctxt_service     = ltrim(rtrim(@ctxt_service))

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  
	/* Code Added For ES_PRJREP_00085 Begins */
	If  Exists ( Select 'X' 
				 from	PPS_FEATURE_LIST(nolock) 
				 where	feature_id	=	'PPS_PRJREPVAR_001'
				 and	FLAG_YES_NO	=	'YES'	
				 )	
		BEGIN
		
			select	paramdesc_shd		'reporttype'
			from	component_metadata_table(nolock)
			where	componentname	=	'prjrep'
			and		paramtype		=	'REPTYPE'
			and		paramcode		in	('D','S','V')
			and		paramcategory	=	'combo'
			and		langid			=	@ctxt_language
		
		END
	ELSE
	/* Code Added For ES_PRJREP_00085 Ends */
		BEGIN
			select	paramdesc_shd		'reporttype'
			from	component_metadata_table(nolock)
			where	componentname	=	'prjrep'
			and		paramtype		=	'REPTYPE'
			--and		paramcode		in	('D','S')			--EPE-55557
			and		paramcode		in	('D','S','BS')			--EPE-55557
			and		paramcategory	=	'combo'
			and		langid			=	@ctxt_language
		END

 /*
	--Errors
	*/

	/* 
	--OutputList
		Select
		null 'reporttype', 
	*/
	
Set nocount off

End




