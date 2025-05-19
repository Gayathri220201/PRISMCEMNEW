/*$File_version=MS4.3.0.05*/
/******************************************************************************/
/* Procedure					: ACAmainreSp_Defaulmlloca								 */
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
/* Date							: Jul 23 2018 12:14PM								 */
/******************************************************************************/
/* Modification History			: 								 */
/******************************************************************************/
/* Modified By					: Harithra Devi.G								 */
/* Date							: 25/07/2018								 */
/* Description					: EPE-8237								 */
/* Abimathi.M				 10/02/2021				EPE-30298		  */
/* Nithya S					 05/04/2022				EPE-43676		  */
/* Saranraj C	             28/11/2022				ADECCOUAT-1014		  */
/*Abilash Sriram N		19/07/2023						EPE-65400				*/
/******************************************************************************/

CREATE Procedure ACAmainreSp_Defaulmlloca
	@ctxt_ouinstance       	fin_ctxt_ouinstance, --Input 
	@ctxt_user             	fin_ctxt_user, --Input 
	@ctxt_language         	fin_ctxt_language, --Input 
	@ctxt_service          	fin_ctxt_service, --Input 
	@assetlocation         	fin_assetlocation, --Input 
	@assetnumber           	fin_assetnumber, --Input 
	@assetnumberml         	fin_assetnumber, --Input 
	@asset_description     	fin_desc255, --Input 
	@asset_group_code      	fin_group, --Input 
	@asset_image           	fin_desc255, --Input 
	--@barcode             fin_DocumentNumber,
	@barcode               	fin_barcode, --Input --EPE-65400
	@business_use          	fin_depprecent, --Input 
	@capitalization_no     	fin_documentnumber, --Input 
	@costcenter            	fin_costcentercode, --Input 
	@custodian             	fin_employeename, --Input 
	@depreciation_category 	fin_deprcategory, --Input 
	@hdn_csou_ml           	fin_ouinstid, --Input 
	@hdn_tranou_ml         	fin_ouinstid, --Input 
	@hdn_tran_typeml       	fin_transactiontype, --Input 
	@inservicedate         	fin_date, --Input 
	@inventorycycle        	fin_inventorycycle, --Input 
	@manufacturer          	fin_name, --Input 
	@modeflag              	fin_modeflag, --Input 
	@model                 	fin_desc40, --Input 
	@noofasset             	fin_number, --Input 
	@nooftag               	fin_number, --Input 
	@residualvalue         	fin_depprecent, --Input 
	@salvagevalue          	fin_amount, --Input 
	@serialnumber          	fin_documentnumber, --Input 
	@tagcost               	fin_amount, --Input 
	@tagnumber             	fin_assettagno, --Input 
	@tag_description       	fin_desc255, --Input 
	@tag_image             	fin_desc255, --Input 
	@usefullifeinmonths    	fin_lineno, --Input 
	@warrentynumber        	fin_documentnumber, --Input 
	@guid					fin_guid,
	@fprowno               	fin_fprowno, --Input/Output
	@natureofshift         	flag, --Input
	@salvageper            	fin_depprecent,--EPE-43676
	@remarks               	text255, --Input  --code added by ADECCOUAT-1014
	@m_errorid             	fin_int output --To Return Execution Status
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Set @m_errorid = 0
	--declaration of temporary variables


	--temporary and formal parameters mapping

	Set @ctxt_user              = ltrim(rtrim(@ctxt_user))
	Set @ctxt_service           = ltrim(rtrim(@ctxt_service))
	Set @assetlocation          = ltrim(rtrim(@assetlocation))
	Set @assetnumber            = ltrim(rtrim(@assetnumber))
	Set @assetnumberml          = ltrim(rtrim(@assetnumberml))
	Set @asset_description      = ltrim(rtrim(@asset_description))
	Set @asset_group_code       = ltrim(rtrim(@asset_group_code))
	Set @asset_image            = ltrim(rtrim(@asset_image))
	Set @barcode                = ltrim(rtrim(@barcode))
	Set @capitalization_no      = ltrim(rtrim(@capitalization_no))
	Set @costcenter             = ltrim(rtrim(@costcenter))
	Set @custodian              = ltrim(rtrim(@custodian))
	Set @depreciation_category  = ltrim(rtrim(@depreciation_category))
	Set @hdn_tran_typeml        = ltrim(rtrim(@hdn_tran_typeml))
	Set @inventorycycle         = ltrim(rtrim(@inventorycycle))
	Set @manufacturer           = ltrim(rtrim(@manufacturer))
	Set @modeflag               = ltrim(rtrim(@modeflag))
	Set @model                  = ltrim(rtrim(@model))
	Set @serialnumber           = ltrim(rtrim(@serialnumber))
	Set @tag_description        = ltrim(rtrim(@tag_description))
	Set @tag_image              = ltrim(rtrim(@tag_image))
	Set @warrentynumber         = ltrim(rtrim(@warrentynumber))
	set	@guid					= ltrim(rtrim(@guid))
	Set @natureofshift          = ltrim(rtrim(@natureofshift))
	Set @remarks                = ltrim(rtrim(@remarks))   --code added by ADECCOUAT-1014

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @assetlocation = '~#~' 
		Select @assetlocation = null  

	IF @assetnumber = '~#~' 
		Select @assetnumber = null  

	IF @assetnumberml = '~#~' 
		Select @assetnumberml = null  

	IF @asset_description = '~#~' 
		Select @asset_description = null  

	IF @asset_group_code = '~#~' 
		Select @asset_group_code = null  

	IF @asset_image = '~#~' 
		Select @asset_image = null  

	IF @barcode = '~#~' 
		Select @barcode = null  

	IF @business_use = -915
		Select @business_use = null  

	IF @capitalization_no = '~#~' 
		Select @capitalization_no = null  

	IF @costcenter = '~#~' 
		Select @costcenter = null  

	IF @custodian = '~#~' 
		Select @custodian = null  

	IF @depreciation_category = '~#~' 
		Select @depreciation_category = null  

	IF @hdn_csou_ml = -915
		Select @hdn_csou_ml = null  

	IF @hdn_tranou_ml = -915
		Select @hdn_tranou_ml = null  

	IF @hdn_tran_typeml = '~#~' 
		Select @hdn_tran_typeml = null  

	IF @inservicedate = '01/01/1900' 
		Select @inservicedate = null  

	IF @inventorycycle = '~#~' 
		Select @inventorycycle = null  

	IF @manufacturer = '~#~' 
		Select @manufacturer = null  

	IF @modeflag = '~#~' 
		Select @modeflag = null  

	IF @model = '~#~' 
		Select @model = null  

	IF @noofasset = -915
		Select @noofasset = null  

	IF @nooftag = -915
		Select @nooftag = null  

	IF @residualvalue = -915
		Select @residualvalue = null  

	IF @salvagevalue = -915
		Select @salvagevalue = null  

	IF @serialnumber = '~#~' 
		Select @serialnumber = null  

	IF @tagcost = -915
		Select @tagcost = null  

	IF @tagnumber = -915
		Select @tagnumber = null  

	IF @tag_description = '~#~' 
		Select @tag_description = null  

	IF @tag_image = '~#~' 
		Select @tag_image = null  

	IF @usefullifeinmonths = -915
		Select @usefullifeinmonths = null  

	IF @warrentynumber = '~#~' 
		Select @warrentynumber = null  

	IF @guid = '~#~'
		Select @guid = null  

	IF @fprowno = -915
		Select @fprowno = null
		
	IF @natureofshift = '~#~' 
		Select @natureofshift = null   
	
	IF @salvageper = -915
		Select @salvageper = null--EPE-43676

	IF @remarks = '~#~'          --code added by ADECCOUAT-1014
		Select @remarks = null    --code added by ADECCOUAT-1014

	if @modeflag in ('X','Y','Z') 
	begin 
	update c
	set location_code		=  b.asset_location,
		cost_center			= b.cost_center, 
		inservice_date		= b.inservice_date , 
		assetdesc			= b.asset_desc, 
		tagdesc				= b.tag_desc, 
		assetimage			= @asset_image, 
		tagimage			= @tag_image,
		deprcat				= depr_category, 
		businessuse			= business_use , 
		invcycle			= inv_cycle, 
		assetgrp			= asset_group,
		sal_val				= salvage_value, 
		residualvalue		= b.residualvalue, 
		usefullife			= usefullifeinmonths ,
		manufact			= manufacturer, 
		barcode				= bar_code , 
		serialno			= serial_no, 
		warrantyno			= warranty_no, 
		modelno				= model, 
		custodian			= b.custodian,
		natureofshift		= @natureofshift
		,salvage_valper		= b.salvage_valper--EPE-43676
		,remarks		    = a.remarks --code added by ADECCOUAT-1014
					from 	acap_asset_tag_dtl b (nolock) , 
						acap_asset_hdr a (nolock),
						acap_asset_bulk_tmp c(nolock)
					where  	a.ou_id 		= b.ou_id
					and 	a.ou_id 	= @ctxt_ouinstance
					and 	a.asset_number  = b.asset_number 
					and 	a.asset_number 	= @assetnumber
					and		c.asset_number 	= @assetnumberml 	
					and 	b.tag_number 	= 1
					and		c.tag_number    = @tagnumber				
					and		c.guid			= @guid	

    end
	--OutputList
		Select 	@guid 'guid',
		@fprowno + 1'fprowno'
	
Set nocount off

End









