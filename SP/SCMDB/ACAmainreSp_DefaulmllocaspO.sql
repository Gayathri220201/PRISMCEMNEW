/*$File_version=MS4.3.0.07*/
/******************************************************************************/
/* Procedure					: ACAmainreSp_DefaulmllocaspO								 */
/* Description					: 								 */
/******************************************************************************/
/* Project						: 								 */
/* EcrNo						: 								 */
/* Version						: 0								 */
/******************************************************************************/
/* Referenced					: 								 */
/* Tables						: 								 */
/******************************************************************************/
/* Development history			: 								 */
/******************************************************************************/
/* Author						: Harithra Devi.G								 */
/* Date							: Jul 23 2018 12:15PM								 */
/******************************************************************************/
/* Modification History			: 								 */
/******************************************************************************/
/* Modified By					: Harithra Devi.G								 */
/* Date							: 25/07/2018								 */
/* Description					: EPE-8237								 */
/* Ashok V						24/01/2020				DA-232			 */
/* Abimathi.M				    10/02/2021			    EPE-30298		    */
/* Ashok V						18/02/2021				PTP-1375		 */
/* Nithya S						05/04/2022				EPE-43676		 */
/* Saranraj C	                28/11/2022				ADECCOUAT-1014		  */
/* Harithra						17/08/2023				EPE-66921			*/
/******************************************************************************/

Create Procedure ACAmainreSp_DefaulmllocaspO
	@ctxt_ouinstance       	fin_ctxt_ouinstance, --Input 
	@ctxt_user             	fin_ctxt_user, --Input 
	@ctxt_language         	fin_ctxt_language, --Input 
	@ctxt_service          	fin_ctxt_service, --Input 
	@assetnumber           	fin_assetnumber, --Input 
	@noofasset             	fin_number, --Input 
	@nooftag               	fin_number, --Input 
	@guid					fin_guid , --Input/Output
	@fprowno               	fin_fprowno, --Input/Output
	@m_errorid             	fin_int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Set @m_errorid = 0

	--declaration of temporary variables
	declare @bargen_tmp			fin_paramcode, --EPE-66921
			@companycode_tmp	fin_companycode

	--temporary and formal parameters mapping

	Set @ctxt_user              = ltrim(rtrim(@ctxt_user))
	Set @ctxt_service           = ltrim(rtrim(@ctxt_service))
	Set @assetnumber            = ltrim(rtrim(@assetnumber))

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @assetnumber = '~#~' 
		Select @assetnumber = null  

	IF @noofasset = -915
		Select @noofasset = null  

	IF @nooftag = -915
		Select @nooftag = null  

	IF @fprowno = -915
		Select @fprowno = null  

	select 	@companycode_tmp 	= company_code 
	from  	emod_ou_vw (nolock)
	where 	ou_id 			= @ctxt_ouinstance

	if exists(	select 'X' from cps_processparam_vw(nolock)
				where company_code = @companycode_tmp
				and parameter_type = 'FASYS'
				and parameter_code = 'autogenbarcode'
				and language_id	   = @ctxt_language)
	begin
		select @bargen_tmp = parameter_value 
		from cps_processparam_vw(nolock)
		where company_code = @companycode_tmp
		and parameter_type = 'FASYS'
		and parameter_code = 'autogenbarcode'
		and language_id	   = @ctxt_language
	end
	else
	begin
		select @bargen_tmp = 'N'
	end
		
		Select  @guid				'GUID',
				@fprowno			'fprowno', 
				location_code		'assetlocation', 
				asset_number		'assetnumberml', 
				assetdesc			'asset_description', 
				assetgrp			'asset_group_code', 
				'{''tplid'' :''ic_attach1_tplid''}' 'asset_image', 
				case when @bargen_tmp = 'N' then barcode
					 else '' end 'barcode',  --EPE-66921
				businessuse			'business_use', 
				cap_number			'capitalization_no', 
				cost_center			'costcenter', 
				custodian			'custodian', 
				deprcat				'depreciation_category', 
				@ctxt_ouinstance	'hdn_csou_ml', 
				@ctxt_ouinstance	'hdn_tranou_ml', 
				'ACAP'				'hdn_tran_typeml', 
				inservice_date		'inservicedate', 
				/*code modified by harithra for EPE-8237*/
				dbo.fin_quickcode_desc('ACAP','CBO','INVCYC',invcycle,@ctxt_language) 'inventorycycle', 
				manufact			'manufacturer', 
				modelno				'model', 
				residualvalue		'residualvalue', 
				sal_val				'salvagevalue', 
				serialno			'serialnumber', 
				convert(numeric(28,2),tag_cost)			'tagcost', --DA-232
				tag_number			'tagnumber', 
				tagdesc				'tag_description', 
				'{''tplid'' :''ic_attach1_tplid''}'        'tag_image',
				usefullife			'usefullifeinmonths', 
				warrantyno			'warrentynumber',
				natureofshift		'natureofshift'
				,Asset_Cluster 'AssetCluster', --code added for PTP-1375
					Asset_Category 'AssetCategory' --code added for PTP-1375
					,salvage_valper 'salvageper'--EPE-43676
					,Remarks    'Remarks' --code added by ADECCOUAT-1014
		from 	acap_asset_bulk_tmp (nolock)
		where 	guid 	= @guid

Set nocount off

End

