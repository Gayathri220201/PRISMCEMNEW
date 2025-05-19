/*$File_version=MS4.3.0.01$*/
/******************************************************************************/
/* Procedure					: acap_cr_sp_asset_fet					       */
/* Description					: 								               */
/******************************************************************************/
/* Project						: 								               */
/* EcrNo						: 								               */
/* Version						: 								               */
/******************************************************************************/
/* Referenced					: 								              */
/* Tables						: 								               */
/******************************************************************************/
/* Development history			: 								              */
/******************************************************************************/
/* Author						: Anusha.p								      */
/* Date							: Mar 18 2016  1:31PM						  */
/******************************************************************************/
/* Modification History			: 								              */
/******************************************************************************/
/* Modified By					: 								               */
/* Date							: 								               */
/* Description					: 								               */

/* Saranraj C            14/03/2024               GCDE-23  */
/******************************************************************************/

Create Procedure acap_cr_sp_asset_fet
	@ctxt_language         	ctxt_language, --Input 
	@ctxt_ouinstance       	ctxt_ouinstance, --Input 
	@ctxt_service          	ctxt_service, --Input 
	@ctxt_user             	ctxt_user, --Input 
	@m_errorid             	int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	set nocount on
	-- @m_errorid should be 0 to Indicate Success
	select @m_errorid = 0

	--declaration of temporary variables


	--temporary and formal parameters mapping

	select @ctxt_service           = ltrim(rtrim(@ctxt_service))
	select @ctxt_user              = ltrim(rtrim(@ctxt_user))

	--null checking

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	/*Code commented and added by GCDE-23 starts*/
	/*	Select   
		distinct asset_group_desc 'AssetGroupDescription',
		         asset_group_code  'AssetGroupCode' 
	    from  ainf_asset_group_mst(nolock)
		where  ou_id=@ctxt_ouinstance 
	*/

		declare @ainf_ou  udd_int
		
		select 	@ainf_ou 					=  destinationouinstid
		from 	fw_admin_view_comp_intxn_model  (nolock)
		where 	sourceouinstid 				=  @ctxt_ouinstance
		and 	sourcecomponentname 		= 'ACAP'
		and 	destinationcomponentname 	= 'AINF'
		
		Select distinct asset_group_desc 'AssetGroupDescription',
						asset_group_code  'AssetGroupCode' 
	    from	ainf_asset_group_mst(nolock)
		where	ou_id  =  @ainf_ou
	/*Code commented and added by GCDE-23 ends*/
	
       
	
	
set nocount off

End





