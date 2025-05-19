/*$File_version=MS4.3.0.02$*/
/********************************************************************************/
/* Procedure					: ACA_main_Sp_AsClasmlloca						*/
/* Description					: 												*/
/********************************************************************************/
/* Project						: 												*/
/* EcrNo						: 												*/
/* Version						: 												*/
/********************************************************************************/
/* Referenced					: 												*/
/* Tables						: 												*/
/********************************************************************************/
/* Development history			: 												*/
/********************************************************************************/
/* Author						: Damodharan. R									*/
/* Date							: Dec 12 2014  8:04PM							*/
/*********************************************************************************
Modification History : 
	Modified By					Date				Description
	/*Nithya.S				23/03/2022		EPE-43676			*/
/*Abilash Sriram N		19/07/2023						EPE-65400				*/
*********************************************************************************/

CREATE procedure ACA_main_Sp_AsClasmlloca
	@ctxt_ouinstance    	fin_ctxt_ouinstance, --Input 
	@ctxt_user          	fin_ctxt_user, --Input 
	@ctxt_language      	fin_ctxt_language, --Input 
	@ctxt_service       	fin_ctxt_service, --Input 
	@assetclass         	fin_assetclass, --Input 
	@assetlocation      	fin_assetlocation, --Input 
	--@barcode             fin_DocumentNumber,
	@barcode            	fin_barcode, --Input--EPE-65400 
	@businessuse        	fin_depprecent, --Input 
	@custodian          	fin_employeename, --Input 
	@depcategory        	fin_depcategory, --Input 
	@guid               	fin_guid, --Input 
	@inservicedate      	fin_date, --Input 
	@invcyclemlenn      	fin_desc40, --Input 
	@manufacturer       	fin_name, --Input 
	@modeflag           	fin_modeflag, --Input 
	@model              	fin_desc40, --Input 
	@proposalnumber     	fin_documentnumber, --Input 
	@residualvalue      	fin_depprecent, --Input 
	@salvagevalue       	fin_amount, --Input 
	@serialnumber       	fin_documentnumber, --Input 
	@tagcost            	fin_amount, --Input 
	@tagdescription     	fin_desc40, --Input 
	@tagnumber          	fin_assettagno, --Input 
	@usefullifeinmonths 	fin_lineno, --Input 
	@warrentynumber     	fin_documentnumber, --Input 
	@fprowno            	fin_int, --Input/Output
	@salvageper         	fin_depprecent, --EPE-43676 
	@m_errorid          	fin_int output --To Return Execution Status
as
begin
	-- nocount should be switched on to prevent phantom rows
	set nocount on
	
	-- @m_errorid should be 0 to indicate success
	select @m_errorid = 0

	--declaration of temporary variables

	--temporary and formal parameters mapping
	select @ctxt_user           = ltrim(rtrim(@ctxt_user))
	select @ctxt_service        = ltrim(rtrim(@ctxt_service))
	select @assetclass          = ltrim(rtrim(@assetclass))
	select @assetlocation       = ltrim(rtrim(@assetlocation))
	select @barcode             = ltrim(rtrim(@barcode))
	select @custodian           = ltrim(rtrim(@custodian))
	select @depcategory         = ltrim(rtrim(@depcategory))
	select @guid                = ltrim(rtrim(@guid))
	select @invcyclemlenn       = ltrim(rtrim(@invcyclemlenn))
	select @manufacturer        = ltrim(rtrim(@manufacturer))
	select @modeflag            = ltrim(rtrim(@modeflag))
	select @model               = ltrim(rtrim(@model))
	select @proposalnumber      = ltrim(rtrim(@proposalnumber))
	select @serialnumber        = ltrim(rtrim(@serialnumber))
	select @tagdescription      = ltrim(rtrim(@tagdescription))
	select @warrentynumber      = ltrim(rtrim(@warrentynumber))

	--null checking
	if @ctxt_ouinstance = -915
		select @ctxt_ouinstance = null  

	if @ctxt_user = '~#~' 
		select @ctxt_user = null  

	if @ctxt_language = -915
		select @ctxt_language = null  

	if @ctxt_service = '~#~' 
		select @ctxt_service = null  

	if @assetclass = '~#~' 
		select @assetclass = null  

	if @assetlocation = '~#~' 
		select @assetlocation = null  

	if @barcode = '~#~' 
		select @barcode = null  

	if @businessuse = -915
		select @businessuse = null  

	if @custodian = '~#~' 
		select @custodian = null  

	if @depcategory = '~#~' 
		select @depcategory = null  

	if @guid = '~#~' 
		select @guid = null  

	if @inservicedate = '01/01/1900' 
		select @inservicedate = null  

	if @invcyclemlenn = '~#~' 
		select @invcyclemlenn = null  

	if @manufacturer = '~#~' 
		select @manufacturer = null  

	if @modeflag = '~#~' 
		select @modeflag = null  

	if @model = '~#~' 
		select @model = null  

	if @proposalnumber = '~#~' 
		select @proposalnumber = null  

	if @residualvalue = -915
		select @residualvalue = null  

	if @salvagevalue = -915
		select @salvagevalue = null  

	if @serialnumber = '~#~' 
		select @serialnumber = null  

	if @tagcost = -915
		select @tagcost = null  

	if @tagdescription = '~#~' 
		select @tagdescription = null  

	if @tagnumber = -915
		select @tagnumber = null  

	if @usefullifeinmonths = -915
		select @usefullifeinmonths = null  

	if @warrentynumber = '~#~' 
		select @warrentynumber = null  

	if @fprowno = -915
		select @fprowno = null  
		
	IF @salvageper = -915
		Select @salvageper = null  --EPE-43676


	insert into acap_asset_info_tmp
	(
			ou_id,					tag_number,				tag_desc,				depr_category,
			inservice_date,			business_use,			tag_cost,				proposal_number,
			asset_location,			inv_cycle,				salvage_value,			residualvalue,
			usefullifeinmonths,		manufacturer,			bar_code,				serial_no,
			warranty_no,			model,					custodian,				guid,
			seq_no,					salvage_valper --epe-43676
	)
	select	@ctxt_ouinstance,		@tagnumber,				@tagdescription,		NULL,
			@inservicedate,			@businessuse,			@tagcost,				@proposalnumber,
			@assetlocation,			@invcyclemlenn,			@salvagevalue,			@residualvalue,
			@usefullifeinmonths,	@manufacturer,			@barcode,				@serialnumber,
			@warrentynumber,		@model,					@custodian,				@guid,
			@fprowno,				@salvageper

	--Output List
	select	@fprowno + 1		'FPROWNO'
		
	set nocount off
end





