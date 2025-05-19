/*$File_version=ms4.3.0.24$*/  
/********************************************************************************/  
/* Procedure    : ACAmains5SpG5AcapHdrRef                                       */  
/* Description  :									                            */  
/********************************************************************************/  
/* Project      :                                                               */  
/* ECR          :															    */  
/* Version      :  4.0.0.10                                                     */  
/********************************************************************************/  
/* Referenced   :															    */  
/* Tables       :                                                               */  
/********************************************************************************/  
/* Development history                                                          */  
/********************************************************************************/  
/* Author       : Sangeetha Sitaraman                                           */  
/* Date         : 18/Jan/2006                                                   */  
/********************************************************************************/  
/* Modification history                                                         */  
/********************************************************************************/  
/* Modified by  : Swetha                                                        */  
/* Date         : 09/02/2006                                                    */  
/* Description  : ACAPDMS412AT_000341										    */  
/********************************************************************************/  
/* Modified by  : Swetha                                                        */  
/* Date         : 16/02/2006                                                    */  
/* Description  : ACAPDMS412AT_000347                                           */  
/********************************************************************************/  
/* Modified by  : Swetha                                                        */  
/* Date         : 16/02/2006                                                    */  
/* Description  : ACAPDMS412AT_000348                                           */  
/********************************************************************************/  
/********************************************************************************/  
/*Modified by        : Swetha                                                   */  
/*Modified Date      : 5/5/2006                                                 */  
/*Purpose            : CML Changes                                              */  
/*Modified by        : Ravikrishnan.N                                           */  
/*Modified Date      : 02/Aug/2006                                              */  
/*Purpose            : ACAPDMS412AT_000482                                      */  
/*Modified by        : Ravikrishnan.N                                           */  
/*Modified Date      : 02/Aug/2006                                              */  
/*Purpose            : ACAPDMS412AT_000488                                      */  
/*Modified by        : Swetha                                                   */  
/*Modified Date      : 24/Aug/2006                                              */  
/*Purpose            : ACAPDMS412AT_000527                                      */  
/*Modified by        : Swetha                                                   */  
/*Modified Date      : 11/sep/2006                                              */  
/*Purpose            : ACAPDMS412AT_000548                                      */  
/*Modified by        : Esther J                       */  
/*Modified Date : 18/may/2007                                              */  

/*Purpose      : ACAPDMS412AT_000710                                      */  
/*Modified By  Date    Purpose   */  
/*  Prabu S   18-09-2007   ACAPDMS412AT_000727 */  
/*  Anitha N  11-09-2008   ES_ACAP_00025   */  
/*  Uma Maheswari 27th July 2009  ES_ACAP_00069  */  
/* Damodharan. R 10/04/2014   ES_ACAP_00581  */  
/* Esther J   20/1/2014   13H120_General_00032 ;13H120_ACAP_00002*/  
/* Damodharan. R 02/04/2014   13H120_ACAP_00002 : 13H120_ACAP_00013 */  
/*C.Ramesh Kumar 16.07.2014   14H109_ACAP_00004      */  
/* Damodharan. R 09/12/2014   14H109_ADEPP_00004      */  
/* Sweety Ninave 15/06/2016   ES_ACAP_01029       */  
/*Sivapriya J  01/19/2018   HCE-104         */  
/*Krishna Kumar N 30/07/2018   EPE-7866  */  
/*  Harithra   17-08-2018         EPE-8428                             */  
/*  Harithra   17-08-2018         EPE-8702                            */  
----C.Ramesh Kumar  24.10.2019  epe-16037  
--gokul M    27.11.2019  epe-16884  
/*Ashok V						10/02/2020			EBS-3983    */
/*Nithya S						05/04/2022			EPE-43676	*/
/*Amani.P						18/05/2022			EPE-46983	*/
/*Abilash Sriram N		19/07/2023					EPE-65400	*/
/*Harithra				09/08/2023					EPE-66921	*/
/********************************************************************************/  
Create procedure acamains5spg5acaphdrref   
 @ctxt_ouinstance  fin_ctxt_ouinstance,    
 @ctxt_user               fin_ctxt_user,    
 @ctxt_language           fin_ctxt_language,  
 @ctxt_service            fin_ctxt_service,   
 @assetclass              fin_assetclass,    
 @assetdescription        fin_desc40,    
 @assetgrpnum             fin_group,   
 @assetlocation           fin_assetlocation,    
 @assetnumber             fin_assetnumber, 
 --@barcode             fin_DocumentNumber,
 @barcode                 fin_barcode,--EPE-65400  
 @businessuse             fin_depprecent,    
 @capitalizationdate      fin_date,   
 @capitalizationnumber    fin_documentnumber,   
 @costcenter              fin_costcentercode,   
 @createddate             fin_date,    
 @creationby              fin_ctxt_user,    
 @csouinstance            fin_ctxt_ouinstance,  
 @custodian               fin_employeename,   
 @depcategory             fin_depcategory,    
 @fb                      fin_financebookid,  
 @guid                    fin_guid,    
 @hidden_control1         fin_hiddencontrol,    
 @hidden_control2         fin_hiddencontrol,   
 @inservicedate           fin_date,   
 @invcyclemlenn           fin_desc40,  
 @manufacturer            fin_name,    
 @model                   fin_desc40,  
 @newtag                  fin_flag,   
 @numbering_type_no       fin_notypeno,  
 @ouinstid                fin_ouinstid,  
 @proposalnumber          fin_documentnumber,   
 @salvagevalue            fin_amount,    
 @serialnumber            fin_documentnumber,  
 @status                  fin_status,   
 @tagcost                 fin_amount,   
 @tagdescription          fin_desc40,   
 @tagnumber               fin_assettagno,  
 @timestamp               fin_timestamp,   
 @warrentynumber          fin_documentnumber,  
 @wfdockey                fin_wfdockey,    
 @wforgunit               fin_wforgunit,   
 @residualvalue           fin_depprecent,---- code added by thyagaraj for 14H109_ADEPP_00004   
 @usefullifeinmonths      fin_lineno, ---- code added by thyagaraj for 14H109_ADEPP_00004  
/*code modified for EPE-8428 - Harithra*/  
 @accountcode            fin_accountcode, --Input/Output  
 @accountdescription     fin_accountdesc, --Input/Output  
 @lscostcentre           fin_costcentercode, --Input/Output  
 @analysiscode           fin_analysiscode, --Input/Output  
 @subanalysiscode        fin_subanalysiscode, --Input/Output  
 @assetclassification   desc255, --Input/Output  
 @assetcategory         desc255, --Input/Output  
 @assetcluster          desc255, --Input/Output  
 @measurunit    udd_uomcode,--epe-16037  
 @totalcapact   fin_quantity,--epe-16037 
 @salvageper           	fin_depprecent,--EPE-43676
 @m_errorid               fin_int   output   
  
as  
Begin  
 -- nocount should be switched on to prevent phantom rows  
 set nocount on  
   
 -- @m_errorid should be 0 to Indicate Success  
 select @m_errorid = 0  
   
 --declaration of temporary variables  
  
 declare @tagstatusact_tmp fin_status,  
  @invcyclecode  fin_inventorycycle,  
  @retval_tmp  fin_int ,  
  @doccost_tmp  fin_amount ,  
  @tagcost_tmp  fin_amount ,  
  @assetclass_tmp  fin_assetclass ,  
  @error_tmp  fin_int ,  
  @noncapdoc_tmp  fin_flag ,  
  @assetclassdoc_tmp fin_assetclass ,  
  @currencycode  fin_currencycode ,  
  @today   fin_date,   
  @assetcost  fin_amount ,  
  @tagcostinc_tmp  fin_amount,  
  @destinationouinstid    fin_ctxt_ouinstance,   
  @error_msg  fin_text255,  
  @status_tmp   fin_status,  
  @fpcode1_tmp  fin_financeperiodrange,  
  @fycode1_tmp  fin_financeperiodrange ,  
  @ctxt_ouinstance_tmp fin_ctxt_ouinstance,    
  @m_errout_tmp  fin_int,  
  @acap_depr_category fin_deprcategory,  
  @acap_business_use fin_deprpercent,  
  @acap_salvage_value fin_amount,  
  @acap_proposal_number fin_documentnumber,  
  @inv_date  fin_date  
  --Code  Modified by Ravikrishnan on 02/Aug/2006 for Base Bug id:- ACAPDMS412AT_000488  
  ,@asset_type  fin_type  
  --Code  Modified by Ravikrishnan on 02/Aug/2006 for Base Bug id:- ACAPDMS412AT_000488  
 /*Code added by Damodharan. R for Defect ID 14H109_ADEPP_00004 starts here*/  
    declare @usefulllife_tmp   fin_desc40,  
   @yearly_percent    fin_flag,  
   @usefullifeinmonths_tmp  fin_lineno,  
   @companycode_tmp    fin_companycode,  
   @adepou      fin_ctxt_ouinstance,  
 /*Code added by Damodharan. R for Defect ID 14H109_ADEPP_00004 ends here*/  
   @buid_tmp     fin_buid,  
   @doc_flag_tmp    fin_flag,--EPE-8702  
   @csetou      fin_ctxt_ouinstance--EPE-8702  

	declare @bargen_tmp     fin_paramcode, --EPE-66921
			@Manbargen_tmp	fin_paramcode,
			@asset_barcode	fin_barcode
  
 select @today   = dbo.RES_Getdate(@ctxt_ouinstance)  
 select @assetlocation  = upper(@assetlocation)  
 select @proposalnumber  = upper(@proposalnumber)  
 
   
 --temporary and formal parameters mapping  
 select @ctxt_user             = ltrim(rtrim(@ctxt_user))  
 select @ctxt_service            = ltrim(rtrim(@ctxt_service))  
 select @assetclass            = ltrim(rtrim(@assetclass))  
 select @assetdescription      = ltrim(rtrim(@assetdescription))  
 select @assetgrpnum      = ltrim(rtrim(@assetgrpnum))  
 select @assetlocation         = ltrim(rtrim(@assetlocation))  
 select @assetnumber           = ltrim(rtrim(@assetnumber))  
 select @barcode				 = ltrim(rtrim(@barcode))  
 select @capitalizationnumber    = ltrim(rtrim(@capitalizationnumber))  
 select @costcenter              = ltrim(rtrim(@costcenter))  
 select @creationby              = ltrim(rtrim(@creationby))  
 select @custodian               = ltrim(rtrim(@custodian))  
 select @depcategory             = ltrim(rtrim(@depcategory))  
 select @fb                      = ltrim(rtrim(@fb))  
 select @guid                    = ltrim(rtrim(@guid))  
 select @hidden_control1         = ltrim(rtrim(@hidden_control1))  
 select @hidden_control2         = ltrim(rtrim(@hidden_control2))  
 select @invcyclemlenn           = ltrim(rtrim(@invcyclemlenn))  
 select @manufacturer            = ltrim(rtrim(@manufacturer))  
 select @model					 = ltrim(rtrim(@model))  
 select @newtag                  = ltrim(rtrim(@newtag))  
 select @numbering_type_no       = ltrim(rtrim(@numbering_type_no))  
 select @proposalnumber          = ltrim(rtrim(@proposalnumber))  
 select @serialnumber            = ltrim(rtrim(@serialnumber))  
 select @status                  = ltrim(rtrim(@status))  
 select @tagdescription          = ltrim(rtrim(@tagdescription))  
 select @warrentynumber        = ltrim(rtrim(@warrentynumber))  
select @wfdockey              = ltrim(rtrim(@wfdockey))  
/*code modified for EPE-8428 - Harithra*/  
 Set @accountcode           = ltrim(rtrim(@accountcode))  
 Set @accountdescription    = ltrim(rtrim(@accountdescription))  
 Set @lscostcentre      = ltrim(rtrim(@lscostcentre))  
 Set @analysiscode          = ltrim(rtrim(@analysiscode))  
 Set @subanalysiscode       = ltrim(rtrim(@subanalysiscode))  
 Set @assetclassification   = ltrim(rtrim(@assetclassification))  
 Set @assetcategory         = ltrim(rtrim(@assetcategory))  
 Set @assetcluster          = ltrim(rtrim(@assetcluster))  
  
  
  
    
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
 if @assetdescription = '~#~'  
  select @assetdescription = null    
 if @assetgrpnum = '~#~'  
  select @assetgrpnum = null    
 if @assetlocation = '~#~'  
  select @assetlocation = null    
 if @assetnumber = '~#~'  
  select @assetnumber = null    
 if @barcode = '~#~'  
  select @barcode = null    
 if @businessuse = -915  
  select @businessuse = null 
   
 if @capitalizationdate = '1900/01/01'   
  select @capitalizationdate = null    
 if @capitalizationnumber = '~#~'  
  select @capitalizationnumber = null    
 if @costcenter = '~#~'  
  select @costcenter = null    
 if @createddate = '1900/01/01'  
 
  select @createddate = null    
 if @creationby = '~#~'  
  select @creationby = null    
 if @csouinstance = -915  
  select @csouinstance = null    
 if @custodian = '~#~'  
  select @custodian = null    
 if @depcategory = '~#~'  
  select @depcategory = null    
 if @fb = '~#~'  
  select @fb = null    
 if @guid = '~#~'  
  select @guid = null    
 if @hidden_control1 = '~#~'  
  select @hidden_control1 = null    
 if @hidden_control2 = '~#~'  
  select @hidden_control2 = null    
 if @inservicedate = '1900/01/01'   
  select @inservicedate = null    
 if @invcyclemlenn = '~#~'  
  select @invcyclemlenn = null    
 if @manufacturer = '~#~'  
  select @manufacturer = null    
 if @model = '~#~'  
  select @model = null    
 if @newtag = '~#~'  
  select @newtag = null    
 if @numbering_type_no = '~#~'  
  select @numbering_type_no = null    
 if @ouinstid = -915  
  select @ouinstid = null    
 if @proposalnumber = '~#~'  
  select @proposalnumber = null    
 if @salvagevalue = -915  
  select @salvagevalue = null    
 if @serialnumber = '~#~'  
  select @serialnumber = null    
 if @status = '~#~'  
  select @status = null    
 if @tagcost = -915  
  select @tagcost = null    
 if @tagdescription = '~#~'  
  select @tagdescription = null    
 if @tagnumber = -915  
  select @tagnumber = null    
 if @timestamp = -915  
  select @timestamp = null    
 if @warrentynumber = '~#~'  
  select @warrentynumber = null    
 if @wfdockey = '~#~'  
  select @wfdockey = null    
 if @wforgunit = -915  
  select @wforgunit = null    
   /* code added by thyagaraj for 14H109_ADEPP_00004 start here*/   
 if @residualvalue = -915  
  Select @residualvalue = null    
  
 if @usefullifeinmonths = -915  
  Select @usefullifeinmonths = null    
 /*code modified for EPE-8428 - Harithra*/  
 IF @accountcode = '~#~'   
  Select @accountcode = null    
  
 IF @accountdescription = '~#~'   
  Select @accountdescription = null    
  
 IF @lscostcentre = '~#~'   
  Select @lscostcentre = null    
  
 IF @analysiscode = '~#~'   
  Select @analysiscode = null    
  
 IF @subanalysiscode = '~#~'   
  Select @subanalysiscode = null   
  /* code added by thyagaraj for 14H109_ADEPP_00004 end here*/  
 IF @assetclassification = '~#~'   
  Select @assetclassification = null    
  

 IF @assetcategory = '~#~' 
  Select @assetcategory = null    
  
 IF @assetcluster = '~#~'   
  Select @assetcluster = null    
  
  --epe-16037  
 if @measurunit = '~#~' 
  select @measurunit = null  
   
 if @totalcapact = -915  
  select @totalcapact = null  
 --epe-16037  
  
  IF @salvageper = -915
		Select @salvageper = null--EPE-43676
  
 /*select  @tagstatusact_tmp =  parameter_code  
 from  fin_quick_code_met(nolock)  
 where  component_id   = 'ACAP'  
 and parameter_type  = 'CBO'  
 and parameter_category  = 'TAG_STA'   
 and  parameter_text   = 'Active'  
 and language_id  = @ctxt_language*/  
  
  
        select @tagstatusact_tmp        = 'AC'  
  
 select  @invcyclecode  = parameter_code  
 from  fin_quick_code_met(nolock)  
 where  component_id  = 'ACAP'  
 and    parameter_category = 'INVCYC'  
 and  parameter_text  = @invcyclemlenn  
 and    language_id  = @ctxt_language  
  
  --EPE-46983
    select  @adepou        = destinationouinstid    
  from   fw_admin_view_comp_intxn_model (nolock)  
  where   sourcecomponentname   = 'ACAP'  
  and     sourceouinstid    = @ctxt_ouinstance  
  and     destinationcomponentname = 'ADEP' 
    --EPE-46983
 select @destinationouinstid  = destinationouinstid    
 from   acap_cim_intxn_model_vw(nolock)  
 where  sourcecomponentname      =  'ACAP'  
 and    sourceouinstid           =  @ctxt_ouinstance  
 and    destinationcomponentname = 'APLAN'  
 --EPE-8702  
 select  @csetou    =  destinationouinstid  
 from  fw_admin_view_comp_intxn_model  (nolock)  
 where  sourceouinstid    = @ctxt_ouinstance  
 and  sourcecomponentname   = 'ACAP'  
 and  destinationcomponentname  = 'CSET'  
  
 select  @buid_tmp = bu_id  
 from  emod_lo_bu_ou_vw(nolock)  
 where ou_id = @csetou  
  
 select  @companycode_tmp = company_code   
 from   emod_ou_vw (nolock)  
 where  ou_id    = @ctxt_ouinstance  
 --EPE-8702  
 --for getting the default currency as base currency  
 select  @currencycode  = currency_code   
 from emod_basecurr_vw CUR(nolock),  
  emod_ou_vw OU(nolock)  
 where  OU.ou_id  = @ctxt_ouinstance  
 and  CUR.company_code = OU.company_code  
 and  CUR.flag  = 'B'  
   
 --From acap_asset_doc_tmp  
 select  @noncapdoc_tmp   = capital_flag,  
  @assetclassdoc_tmp  = asset_class  
 from  acap_asset_doc_tmp (nolock)  
 where  guid    = @guid  
  
 select @doccost_tmp  = sum(cap_amount)  
 from  acap_asset_doc_tmp (nolock)  
 where  guid    = @guid  
  
   
 --getting from acap_asset_hdr  
 select  @assetclass_tmp  = asset_class ,  
  @assetcost   = asset_cost 
  
  --Code  Modified by Ravikrishnan on 02/Aug/2006 for Base Bug id:- ACAPDMS412AT_000488  
  ,@asset_type  = rtrim(asset_type)  
  --Code  Modified by Ravikrishnan on 02/Aug/2006 for Base Bug id:- ACAPDMS412AT_000488  
 from  acap_asset_hdr(nolock)  
 where  ou_id   = @ctxt_ouinstance  
 and    upper(asset_number) = upper(@assetnumber)   
  
 select  @inv_date  = inservice_date,  
   --@tagcost_tmp  = tag_cost, --Code commented for Defect ID ES_ACAP_00581  
  @acap_depr_category = depr_category,  
  @acap_business_use = business_use,  
  @acap_salvage_value = salvage_value,  
  @acap_proposal_number = proposal_number   
 from  acap_asset_tag_dtl(nolock)  
 where  ou_id   = @ctxt_ouinstance  
 and    upper(asset_number) = upper(@assetnumber)   
 and tag_number  = @tagnumber  
 and fb_id   = @fb  
 and tag_status  = @tagstatusact_tmp  
  
  /*Code added for Defect ID ES_ACAP_00581 starts here*/  
 select @tagcost_tmp = sum(isnull(tag_cost,0))  
 from  acap_asset_tag_dtl(nolock)  
 where  ou_id   =  @ctxt_ouinstance  
 and    asset_number =  @assetnumber  
 and  tag_number  =  @tagnumber  
 and  fb_id   =  @fb  
 and  tag_status  =  @tagstatusact_tmp  
  /*Code added for Defect ID ES_ACAP_00581 ends here*/  
   
 --EPE-11335  
 if @assetclass is not null and @assetcategory is not null and @assetclassification is not null and @assetcluster is not null and @depcategory is not null --EPE-11729  
 begin  
  if not exists (Select 'x'  
      from  adep_entity_depcat_map (nolock)  
      where asset_class   = @assetclass  
      and   ou_id     = @adepou--@ctxt_ouinstance --code modified for EBS-3983   
      and   Asset_Category  = @assetcategory   
      and   Asset_Classification  = @assetclassification   
      and   Asset_Cluster   = @assetcluster       
	  and   Depreci_Category  = @depcategory   
      )  
  begin  
   --Eway Bill No cannot be blank  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,5000,@assetclass,@assetclassification,@assetcategory,@assetcluster,@depcategory  
   return  
     
  end  
 end  
 --EPE-11335  
  
  
 select  @ctxt_ouinstance_tmp  = destinationouinstid    
 from  acap_cim_intxn_model_vw C (nolock),  
  emod_ou_vw  b (nolock)  
 where  c.sourceouinstid   = @ctxt_ouinstance  
 and  c.sourcecomponentname   = 'ACAP'  
 and  b.ou_id    = c.destinationouinstid  
 and  c.destinationcomponentname  = 'FCC'  
   
 -- assetnumber is null check  
 if @assetnumber is null  
 begin  
  select @m_errorid =10   
  return  
 end  
  
  
 /*Code Added By Prabu for the Bug id:ACAPDMS412AT_000727 Starts here */   
 if @tagcost_tmp = @tagcost  
 begin  
  /*raiserror('Asset cost should be amended.',16,1)*/  
  exec fin_german_raiserror_sp 'ACAP',@ctxt_language,124  
  return  
 end  
 /*Code Added By Prabu for the Bug id:ACAPDMS412AT_000727 Ends here */  
  
 --With document refernce created asset cannot be amended without document reference.  
 if exists(select 'x' from acap_asset_doc_line_dtl(nolock)  
   where  ou_id   = @ctxt_ouinstance  
   and    upper(asset_number) = upper(@assetnumber))  
 begin  
  if not exists (select 'x' from acap_asset_doc_tmp(nolock)  
    where guid = @guid)  
  begin  
   --raiserror('Selected Asset is created with document reference. Select a document in the entry page to amend the asset',16,1)  
   select @m_errorid = 900004481  
   return  
  end  
 end  
  
  
 --Without document refernce created asset cannot be amended with document reference.  
 if not exists(select 'x' from acap_asset_doc_line_dtl(nolock)  
   where  ou_id   = @ctxt_ouinstance  
   and    upper(asset_number) = upper(@assetnumber))  
 begin  
  if exists (select 'x' from acap_asset_doc_tmp(nolock)  
    where guid = @guid)  
  begin  
   --raiserror('Selected Asset is created without document reference.Select an asset with document reference for amedment ',16,1)  
   select @m_errorid = 900004482  
   return  
  end  
 end  
  
  
 if  exists (select 'x' from acap_asset_info_tmp(nolock)  
   where  guid   = @guid)  
   
 begin  
  if not exists(select 'x' from acap_asset_info_tmp(nolock)  
    where  guid   = @guid   
    and   ou_id  = @ctxt_ouinstance  
    and    asset_number = @assetnumber)  
  begin  
   --error  
   --raiserror('Asset Number cannot be modified till the Amend task is executed',16,1)  
   select @m_errorid = 500  

   return  
  end  
 end  
  
 --capitalization date is null check  
 if @capitalizationdate is null  
 begin  
  select @m_errorid = 1   
  return  
 end  
  
  
 --Finance period check  
 exec @m_errorid = fcc_sysact_spvaltrndate @ctxt_ouinstance , --@ctxt_ouinstance_tmp , -- Code modified by Uma for the defect id : ES_ACAP_00069  
      'ACAP' , @ctxt_user , @fb ,  
      @capitalizationdate,@status_tmp output,  
      @fycode1_tmp output ,@fpcode1_tmp output,  
                 @ctxt_language  
  
  

 -- 1  transaction date is in closed period or year of the bfg ou  
  -- 2  transaction date is in closed period or year of the finance book  
  -- 3  period or year is not defined for the given transaction date    
  -- 4  provide organisation unit  
  
-- 5  provide component name  
  -- 6  provide finance book id  
  -- 7  provide transaction date  
  
 --Code  Modified by Ravikrishnan on 02/Aug/2006 for Base Bug id:- ACAPDMS412AT_000482    
 select @m_errout_tmp =  case @m_errorid  
    when 1 then 196  
    when 2 then 9  
    when 3 then 198  
    when 4 then 3  
    when 5 then 217  
    when 6 then 110  
    when 7 then 152  
    when 0 then 0   
    end  
  
 if isnull(@m_errout_tmp,0) <> 0   
 begin  
  if @m_errout_tmp  = 198  
  begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,110,'' ,'','' , '','','','',@error_msg output  
   return  
  end  
  select @m_errorid = @m_errout_tmp  
  return  
 end  
 --Code  Modified by Ravikrishnan on 02/Aug/2006 for Base Bug id:- ACAPDMS412AT_000482  
  
  
 --finance book null check  
        if  @fb  is null  
        begin   
               select @m_errorid =24149  
  return      
        end  
   
  /*Code added for Defect Id:- HCE-104 starts here*/  
  if @newtag = '1' and @assetlocation is null  
  begin  
    if(  
    select distinct   
    count(distinct asset_location)  
    from acap_asset_tag_dtl(nolock)  
    where asset_number = @assetnumber  
    and   ou_id   = @ctxt_ouinstance  
    ) > 1  
  begin   
    --RAISERROR ('Please Enter Asset Location',16,1)  
    select @m_errorid =3459137   
    return  
  end  
  else  
  begin  
    select distinct   
    @assetlocation =  asset_location   
    from acap_asset_tag_dtl(nolock)  
    where asset_number = @assetnumber  
    and   ou_id   = @ctxt_ouinstance  
  end  
  end  
  /*Code added for Defect Id:- HCE-104 ends here*/  
     
 --asset location null check  
 if @assetlocation is null  
 begin  
  --RAISERROR ('Please Enter Asset Location',16,1)  
  select @m_errorid =3459137   

  return  
 end  
  
   
 --if asset number doesnot exists then raise error  
 if not exists (select 'x' from acap_asset_hdr(nolock)  
   where ou_id  = @ctxt_ouinstance  
   and asset_number = @assetnumber)  
 begin  
  select @m_errorid =25   
  return
  
 end  
   
  
 --if asset not in active status then raise error  
 if not exists (select 'x' from acap_asset_hdr(nolock)  
   where ou_id   = @ctxt_ouinstance  
   and   asset_number  = @assetnumber   
   and   asset_status  = @tagstatusact_tmp  
   ) 
 
 begin  
  select @m_errorid =26  
  return  
 end  
  
  
 --Business use check  
 if @businessuse is not null  
 begin  
  if @businessuse < 0  
  begin  
   select @m_errorid =12   
   return  
  end  
  if @businessuse > 100  
  begin  
   select @m_errorid =13   
   return  
  end  
 end  
 else  
  select @businessuse = 0  
  
  
 if @businessuse = 0  
 begin  
  --raiserror ('pls enter business use percentage greater than zero',16,1)  
  select @m_errorid =3459141  
  return  
 end  
  
 --Tag cost check  
 if isnull(@tagcost,0) = 0  
 begin  
  select @m_errorid = 16  
  --raiserror ('pls enter tag cost',16,1)  
  return  
 end  
  
  
  
 if isnull(@tagcost,0) < 0  
 begin  
  --raiserror ('pls enter tag cost greater than zero',16,1)  
  select @m_errorid = 17  
  return  
 end  
  
  
 --Asset Location check  
 if @assetlocation is not null  
 begin  
  if exists (select 'x' from acap_cim_intxn_model_vw(nolock)  
    where sourcecomponentname  = 'ACAP'  
    and sourceouinstid  = @ctxt_ouinstance  
    and destinationcomponentname = 'ALOC')  
  begin  
   exec @retval_tmp = aloc_is_chklocation  
      @ctxt_language ,  
      @ctxt_ouinstance ,  
      @ctxt_service ,  
      @ctxt_user ,  
      @assetlocation ,   
      'N'   
    
   select @error_tmp = case @retval_tmp  
         when 1 then 18    
         when 2 then 19  
         else 0  
         end  
   if isnull(@error_tmp,0) <> 0  
   begin  
    select @m_errorid = @error_tmp   
    return  
   end  
  end  
     
 end  
 /* Code added for the defect id ES_ACAP_01029 starts here */  
 declare @ainfou fin_ou  
  
  select  @ainfou      = destinationouinstid    
  from fw_admin_view_comp_intxn_model (nolock)  
  where   sourcecomponentname      =  'ACAP'  
  and     sourceouinstid           =  @ctxt_ouinstance  
  and    destinationcomponentname = 'AINF'  
  
  if exists ( select 'x'    
     From ainf_asset_class_mst (nolock)  
     where depreciable='Y'  
     and  asset_class_code = @assetclass_tmp  
     and  ou_id = @ainfou )  
  begin   
   if @depcategory is null  
   begin  
    --raiserror('Please Enter the Depreciation category',16,1)  
    exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3007  
    return  
   end  
  end   
 /* Code added for the defect id ES_ACAP_01029 ends here */  
 --Salvage value check  
 if @salvagevalue is not null  
 begin  
                if @salvagevalue > @tagcost   
  begin  
     select @m_errorid = 900004495 
     return   
  end  
  if @salvagevalue > @tagcost_tmp   
  begin  
   select @m_errorid = 20   
   return  
  end  
  
  if @salvagevalue < 0  
  begin  
   select @m_errorid = 21   
   return  
  end  
 end  
  
/*code added for EPE-43676 begins here */
	if isnull(@salvageper,0) < 0 or isnull(@salvageper,0) > = 100
	begin
		--Salvage value % can be between 1 to 100 %. Modify details.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,20000
		return
	end

	if @salvagevalue is null and @salvageper is not null
	begin
		select @salvagevalue	=	(@tagcost *@salvageper/100)
	end
	else if @salvagevalue is not null and @salvageper is not null
	begin
		select @salvagevalue	=	@salvagevalue
	end
	/*code added for EPE-43676 ends here */  
  
 --Proposal Number check  
 if exists (select 'x' from acap_cim_intxn_model_vw(nolock)  
   where sourcecomponentname  = 'ACAP'  
   and sourceouinstid  = @ctxt_ouinstance  
   and destinationcomponentname = 'APLAN')  
 begin  
  if @proposalnumber is null  
  begin  
   select @m_errorid = 22   
   return  
  end  
 end      
 if @proposalnumber is not null  
 begin  
  exec @retval_tmp = aplan_sys_valdprop  
    @ctxt_ouinstance ,  
    @ctxt_language ,  
    @ctxt_user ,  
    @ctxt_service ,  
    @proposalnumber ,  
    @capitalizationdate  
  if @retval_tmp = 1  
  begin  
   select @m_errorid = 23  
   return  
  end  
     
 end  
  
   
 if @assetclassdoc_tmp <> @assetclass_tmp and @assetclassdoc_tmp is not null  
 begin  
  select @m_errorid = 24  
  return  
 end  
  
 if not exists (select 'x' from aplan_acq_proposal_vw(nolock)  
   where asset_class_code  = @assetclass_tmp  
   and proposal_number  = @proposalnumber  
   and fb_id  = @fb   
   and dest_ouid  = @destinationouinstid)  
 begin   
  --raiserror('SELECT THE APROPRIATE ASSET PROPOSAL FOR ASSET CLASS CHOOSED.',16,1)  
  select @m_errorid = 3459207  
  return  
 end  
 --EPE-7866    
 if exists (select '1'     
     from acap_asset_doc_tmp(nolock)   
     where guid   = @guid  
     and  isnull(capital_flag,'') = 'CI')  
 begin  
  --proposal number  
  if exists (select '1'    
 
       from acap_asset_doc_tmp(nolock)    
       where  proposal_number  = @proposalnumber    
       and  guid    = @guid)    
  begin    
   select @m_errorid=0    
  end    
  else    
  begin    
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,4107    
   return    
  end  
   --tag cost   
  /*if exists (select '1'     
       from acap_asset_doc_tmp(nolock)    
       where  cap_Amount   = @tagcost  - isnull(@tagcost_tmp ,0)  
       and  guid    = @guid)    
   begin    
     select @m_errorid=0    
   end    
  else    
   begin    
     exec fin_german_raiserror_sp 'ACAP',@ctxt_language,4108    
     return    
   end*/  
       
  
 end  
 --EPE-7866  
  
  
 exec emod_sysact_sproundoff   
    @ctxt_ouinstance,  
   'A' ,  
   'ACAP' , 
 
   @currencycode ,  
   @today ,  
   @tagcost ,   
   @tagcost output--Rounded off amount   
  
 /* Code commented by Swetha for ACAPDMS412AT_000348 on 16/02/2006 */  
  
 /*   
 if @capitalizationnumber is null  
 begin  
    
  exec  dnm_gen_tranno_sp  
    @ctxt_language,  
    @ctxt_ouinstance,  
@ctxt_service,  
    @ctxt_user,  
    'ACAP',  
    'FA_ACAP',  
    @numbering_type_no,  
    @capitalizationdate,  
    @docnum   output,  
    @errorcode_tmp       output ,  
    @execflag  output 
 
  
  select @error = case @errorcode_tmp  
    when 2410001 then 95  
    when 2410002 then 97  
    when 2410003 then 96  
    when 2410004 then 98  
    end  
  if isnull(@errorcode_tmp,0) <> 0  
  begin  
   select @m_errorid = @error  
   return  
 
 end   
  else  
  begin   
   select @capitalizationnumber =  @docnum   
  end  
  
 end*/  
 /* Code commented by Swetha for ACAPDMS412AT_000348 on 16/02/2006 */  
  
 --EPE-8702  
 if exists( select 'x' from acap_asset_doc_tmp (nolock)  
   where guid = @guid)  
 select  @doc_flag_tmp = 'Y'    
 else  
 select  @doc_flag_tmp = 'N'    
   
  /*code modified for EPE-8428 - Harithra*/  
 if exists (select 'X' from cps_processparam_sys  
    where company_code  = @companycode_tmp  
    and language_id   = @ctxt_language  
    and parameter_type = 'FASYS'  
    and parameter_category = 'MANENTWOREFDOC'  
    and parameter_code  = 'Y') and  @doc_flag_tmp = 'N'  
 begin  
 if @accountcode is null  
 begin  
  --raiserror('Enter Valid Account Code )  
  exec fin_german_raiserror_sp 'ACAP',@ctxt_language,599  
  return  
 end  
  
 if @accountcode is not null  
 begin   
 if not exists (   
  select 'x'   
  from as_opaccountfb_vw (nolock)  
  where company_code  = @companycode_tmp  
  and account_code  = @accountcode  
  and map_status   = 'A'   
  and @today between effective_from and isnull(effective_to,'01-01-9999'))  
 begin  
  --raiserror('Enter Valid Account Code )  
  exec fin_german_raiserror_sp 'ACAP',@ctxt_language,599  
  return  
 end  
  
 if exists (   
  select 'x'   
  from as_opaccountfb_vw (nolock)  
  where company_code  = @companycode_tmp  
  and account_code  = @accountcode  
  and map_status   = 'A'   
  and ctrl_acctype is not null  
  and @today between effective_from and isnull(effective_to,'01-01-9999'))  
 begin  
  --raiserror(Contra Account code  %s cannot be of Control Account Type. Please modify.)  
  exec fin_german_raiserror_sp 'ACAP',@ctxt_language,614,@accountcode  
  return  
 end  
  
 if not exists ( select 'x' from as_opaccountfb_vw (nolock)  
      where company_code  = @companycode_tmp  
      and account_code  = @accountcode  
      and fb_id   = @fb  
      and map_status   = 'A'   
      and @today between effective_from and isnull(effective_to,'01-01-9999'))  
 --Account code not attached  to the Finance Book  
 begin  
  exec fin_german_raiserror_sp 'ACAP',@ctxt_language,600  
  return  
 end   
  
 end  
  
 if exists (select 'x'  
   from mac_cc_acc_mapped_vw  
   where bu_id  = @buid_tmp  
   and account_no = @accountcode  
   and center_no is not null  
   and @today between effective_date and isnull(expiry_date,'9999-01-01'))  
     
   AND @lscostcentre is null  
 --Please provide costcenter  
 begin  
  exec fin_german_raiserror_sp 'ACAP',@ctxt_language,615,@accountcode  
  return  
 end   
  
 if @lscostcentre is not null  
 begin   
 if not exists (select 'X'  
     from mac_cost_center_vw  
     where company_code  = @companycode_tmp  
     and bu_id     = @buid_tmp  
     and ma_center_no   = @lscostcentre  
     and @today between ma_effective_date and isnull(ma_expiry_date,'9999-01-01')  
     and ma_status    = 'A')  
 --Invalid costcenter  
 begin  
  exec fin_german_raiserror_sp 'ACAP',@ctxt_language,601  
  return  
 end   
  
 if not exists (select 'x'  
     from mac_cc_acc_mapped_vw  
     where bu_id  = @buid_tmp  
     and account_no  = @accountcode  
     and center_no  = @lscostcentre  
     and @today between effective_date and isnull(expiry_date,'9999-01-01'))  
 --Costcenter '##' is not mapped to the Accountcode '##'  
 begin  
  exec fin_german_raiserror_sp 'ACAP',@ctxt_language,602,@lscostcentre,@accountcode  
  return  
 end   
 end  
  
 --if @analysiscode is not null or @subanalysiscode is not null  
 --begin  
 declare @err_tmp int
  
 select @err_tmp = 0  
 exec @err_tmp = abb_sysact_acansub_val  @ctxt_language,  
           @ctxt_ouinstance,  
           @ctxt_service,  
           @ctxt_user,  
           @accountcode,  
           @analysiscode,  
           @subanalysiscode,  

           @today  
   
 if @err_tmp <> 0   
 begin  
  if @err_tmp = 3  
   Begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,613,@analysiscode,@accountcode  
   return  --Provide Analysis Code  
   End  
  if @err_tmp = 5  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,603,@analysiscode,@accountcode  
   return  --Invalid Analysis Code <%1> for the Account Code <%2>  
   end  
  if @err_tmp = 6  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,604,@analysiscode,@accountcode  
   return  --Analysis Code <%1> is in INActive status for the account code <%2>  
   end  
  if @err_tmp = 7  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,605,@subanalysiscode,@accountcode,@analysiscode  
   return --Invalid Sub Analysis Code <%1> for the Account Code <%2> - Analysis Code <%3> Combination  
   end  
  if @err_tmp = 8  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,606,@accountcode,@analysiscode  
   return --Sub Analysis Code <%1> is in INActive status for the Account Code <%2>, Analysis Code <%3>  
   end  
  if @err_tmp = 9  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,607,@accountcode  
   return --Analysis, Sub-Analysis Mapping Doesnot Exists for the Account code <%1>  
   end  
  if @err_tmp = 10  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,608,@accountcode  
   return --Analysis, Sub-Analysis Mapping is in INActive Status for the Account code <%1>  
   end  
  if @err_tmp = 11  
 
  begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,609,@accountcode,@analysiscode  
   return --Invalid Accountcode <%1>, Analysiscode <%2> and Subanalysis code Mapping  
   end  
  if @err_tmp = 12  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,610,@accountcode,@analysiscode  
   return --Accountcode <%1>, Analysiscode <%2> and Subanalysis Mapping is in INActive Status  
   end  
  if @err_tmp = 13  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,611,@accountcode  
   return  --For the Account Code : <%1>, without entering Analysis Code, Sub Analysis Code was entered  
   end  
  if @err_tmp = 14  
   begin  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,612  
   return -- SubAnalysis Code cannot be NULL for the Account and Analysis combination  
   end  
 end  
 --end  
 end  
 --EPE-8702  
  
 if exists (select 'x' from acap_asset_doc_tmp (nolock)  
      where guid = @guid )  
 begin  
  update  acap_asset_doc_tmp with (rowlock)  
  set  cap_number  = @capitalizationnumber  
  where  guid   = @guid  
  
     
  update  acap_asset_line_tmp with (rowlock)  
  set  cap_number  = @capitalizationnumber  
  where  guid   = @guid  
 end  
  
 /* When new tag is created for the asset*/  
 if @newtag = '1'  
 begin  
  --if tag description is null raise error  
  if @tagdescription is null  
  begin  
   select @m_errorid = 11   
   return  
  end  
  -- if inservice date not entered.  
  if @inservicedate is null  
  begin  
   select @inservicedate = @capitalizationdate  
  end  
  /* Code modified by Swetha for ACAPDMS412AT_000347 on 16/02/2006 */  
  /*select @maxnumber_tmp = max(isnull(tag_number,0)) + 1  
  from  acap_asset_tag_dtl (nolock)  
  where ou_id  = @ctxt_ouinstance  
  and fb_id  = @fb

 and asset_number = @assetnumber*/  
    
  if (@tagnumber is null)  
  begin   
   select @m_errorid = 27  
   return  
  end  
  /* Code modified by Swetha for ACAPDMS412AT_000347 on 16/02/2006 */  
  
  /*Code added by Damodharan. R for Defect ID 14H109_ADEPP_00004 starts here*/  
/*code modified for EPE-8428 - Harithra*/  
  select  @buid_tmp = bu_id  
  from  emod_lo_bu_ou_vw(nolock)  
  where ou_id = @ctxt_ouinstance  
  
  select  @companycode_tmp  = company_code   
  from   emod_ou_vw (nolock)
  
  where  ou_id    = @ctxt_ouinstance  
  ---code moved to line no 367
  --select  @adepou        = destinationouinstid    
  --from   fw_admin_view_comp_intxn_model (nolock)  
  --where   sourcecomponentname   = 'ACAP'  
  --and     sourceouinstid    = @ctxt_ouinstance  
  --and     destinationcomponentname = 'ADEP'  
    --code moved to line no 367
  if isnull(@residualvalue,0) < 0 or isnull(@residualvalue,0) > 100  
  begin  
   --Residual value %% can be between 1 to 100%%. Modify details.  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,500  
   return  
  end  
  
  select @usefulllife_tmp    =  parameter_code  
  from fin_processparam_sys (nolock)  
  where company_code     = @companycode_tmp  
  and  component_id   = 'ADEP'   
  AND  parameter_type     = 'PROPAR'   
  AND  parameter_category  = 'ALLMODUSEFULLIFE'  
  
  if @usefulllife_tmp is null  
  begin  
   select @usefulllife_tmp = 'N'  
  end  
  
  if @usefulllife_tmp = 'Y'  
  begin    
   if isnull(@depcategory,'') = ''  
   begin  
    select @usefullifeinmonths = NULL  
   end  
   else  
   begin   
    select @usefullifeinmonths_tmp = b.useful_asset_life,  
      @yearly_percent   = yearly_percent  
    from adep_assign_rules_mst a (nolock)  
    join adep_depr_rule_hdr b (nolock)  
    on  a.ou_id    = b.ou_id  
    and  a.depr_rule_number = b.depr_rule_number   
    and  a.asset_class  = b.asset_class  
    and  a.ou_id    = @adepou  
    and  a.depr_book   = 'CORP'  
    and  a.depr_category  = @depcategory  
    and  a.asset_class  = @assetclass  
    and  a.status   = 'A'      
    and  @today between a.eff_date and isnull(a.exp_date,@today)  
  
    if @yearly_percent = 'Y'  
    begin  
     if @usefullifeinmonths is not null  
     begin  
      --Useful life in months cannot be modified as the rule assigned to the category has yearly %% as Yes.  
      exec fin_german_raiserror_sp 'ACAP',@ctxt_language,501  
      return  
     end  
    end  
    else  
    begin  
     if @usefullifeinmonths_tmp is not null  
    
 begin  
      select @usefullifeinmonths = @usefullifeinmonths  
     end  
     else  
     begin  
      if @usefullifeinmonths is not null  
      begin  
       --Useful life in months cannot be modified as the rule assigned to the category has depreciation rate associated to it.  
       exec fin_german_raiserror_sp 'ACAP',@ctxt_language,502  
       return  
      end  
     end  
    end  
   end  
  end  
  else  
  begin  
   select @usefullifeinmonths = NULL  
  end  
    
  if @usefullifeinmonths is not null and @usefullifeinmonths <= 0  
  begin  
   --Useful life in months cannot be less than or equal to zero. Modify values.  
   exec fin_german_raiserror_sp 'ACAP',@ctxt_language,503  
   return  
  end    
  /*Code added by Damodharan. R for Defect ID 14H109_ADEPP_00004 ends here*/  

  --epe-16884
 declare @errorid fin_int,  
    @success_flag  fin_modeflag  

 exec acap_cmn_usage_val_sp  @guid,    'FA_ACAP',    'ACAP',  
         @ctxt_ouinstance,  @ctxt_service,  @assetclass,          
@depcategory,  @usefullifeinmonths, @capitalizationdate,  
         @totalcapact,  @measurunit,   'Y',  
         @businessuse,  
         @errorid out,  0,      @success_flag OUT  
 if @errorid > 0  
 return  
  
  --epe-16884

  /*code added for EPE-43676 begins here */
	if isnull(@salvageper,0) < 0 or isnull(@salvageper,0) > = 100
	begin
		--Salvage value % can be between 1 to 100 %. Modify details.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,20000
		return
	end

	if @salvagevalue is null and @salvageper is not null
	begin
		select @salvagevalue	=	(@tagcost *@salvageper/100)
	end
	else if @salvagevalue is not null and @salvageper is not null
	begin
		select @salvagevalue	=	@salvagevalue
	end
	/*code added for EPE-43676 ends here */
  
  /* Code Commented & modified by Swetha for ACAPDMS412AT_000341 on 10/02/2006 */  
  if exists(select 'x' from acap_asset_info_tmp(nolock)   
    where  guid   = @guid  
    and  ou_id   = @ctxt_ouinstance  
    and  asset_number  = @assetnumber  
    and  tag_number = @tagnumber)  
  
  begin  
   /*update acap_asset_info_tmp with (rowlock)  
   set tag_desc = @tagdescription,  
    manufacturer = @manufacturer,  
    bar_code = @barcode,  
    serial_no = @serialnumber,  
    warranty_no = @warrentynumber,  
 
   model  = @model,  
    custodian = @custodian,  
    tag_cost = @tagcost,  
    salvage_value = @salvagevalue,  
    proposal_number = @proposalnumber,  
    inv_cycle = @invcyclemlenn,  
    inservice_date = @inservicedate,  
    depr_category = @depcategory,  
    cap_date = @capitalizationdate,  
    business_use = @businessuse,  
    asset_location = @assetlocation  
   where guid  = @guid  
   and  ou_id   = @ctxt_ouinstance  
   and  asset_number  = @assetnumber  
   and  tag_number = @tagnumber*/  
  
   delete from acap_asset_info_tmp  
   where  guid   = @guid  
   and  ou_id   = @ctxt_ouinstance  
   and  asset_number  = @assetnumber  
   and  tag_number = @tagnumber  
  end  
  /*code modified for EPE-8428 - Harithra*/  
   insert into acap_asset_info_tmp  
   (guid,ou_id,cap_number,asset_number,timestamp,  
   cap_date,cap_status,fb_id,num_type,asset_class,asset_group,cost_center,  
   asset_desc,asset_cost,asset_location,seq_no,as_on_date,asset_type,  
   asset_status,transaction_date,account_code,tag_number,tag_desc,  
   inservice_date,tag_cost,proposal_number,tag_status,depr_category,inv_cycle,  
   salvage_value,manufacturer,bar_code,serial_no,warranty_no,model,custodian,  
   business_use,reverse_remarks,book_value,revalued_cost,createdby,createddate,modifiedby,  
                        /* Code modified by Swetha for ACAPDMS412AT_000548 on 11/9/2006 */  
   --modifieddate,tag_cost_orig,new_tag) --Code commented by Damodharan. R for Defect ID 14H109_ADEPP_00004  
   modifieddate, tag_cost_orig, new_tag, residualvalue, usefullifeinmonths,  
   LAccount_code,LAccount_desc,Lcost_center,LAnalysis_code,LSubAnalysis_code ,asset_cluster,asset_category,asset_classification --Code added by Damodharan. R for Defect ID 14H109_ADEPP_00004  
     
                  /* Code modified by Swetha for ACAPDMS412AT_000548 on 11/9/2006 */  
   ,asset_capacity_uom,asset_capacity,salvage_valper)--epe-16037  --EPE-43676
   select distinct --Code modified by Anitha for the bug id : ES_ACAP_00025  
   @guid,@ctxt_ouinstance,@capitalizationnumber,a.asset_number,a.timestamp,  
   @capitalizationdate,a.cap_status,@fb,a.num_type,a.asset_class,  
            /* Code modified by Swetha for ACAPDMS412AT_000527 on 24/08/2006 */  
   a.asset_group,isnull(@costcenter,cost_center),a.asset_desc,@tagcost,  
           /* Code modified by Swetha for ACAPDMS412AT_000527 on 24/08/2006 */  
   @assetlocation,a.seq_no,a.as_on_date,a.asset_type,'AM',  
   /* Code modified by Swetha for ACAPDMS412AT_000347 on 16/02/2006 */  
   a.transaction_date,a.account_code,@tagnumber,@tagdescription,  
   /* Code modified by Swetha for ACAPDMS412AT_000347 on 16/02/2006 */  
   @inservicedate,@tagcost,@proposalnumber,'AM',  
   @depcategory,@invcyclecode,@salvagevalue,@manufacturer,  
   @barcode,@serialnumber,@warrentynumber,@model,@custodian,  
   @businessuse,null,null,null,@ctxt_user,dbo.RES_Getdate(@ctxt_ouinstance),null,null,  
 /* code modified by Swetha for ACAPDMS412AT_000341 on 09/02/2006 */  
                        /* Code modified by Swetha for ACAPDMS412AT_000548 on 11/9/2006 */  
   null,@newtag  
                        /* Code modified by Swetha for ACAPDMS412AT_000548 on 11/9/2006 */  
   ,@residualvalue, @usefullifeinmonths , --Code added by Damodharan. R for Defect ID 14H109_ADEPP_00004  
   /* code modified by Swetha for ACAPDMS412AT_000341 on 09/02/2006 */  
   @accountcode,@accountdescription,@lscostcentre, @analysiscode, @subanalysiscode  
   ,@assetcluster,@assetcategory,asset_classification--EPE-11335  
   ,@measurunit, @totalcapact ,@salvageper--epe-16037  
   from  acap_asset_hdr A(nolock)  
   where  ou_id   = @ctxt_ouinstance  
   and  asset_number  = @assetnumber  
   and  fb_id  = @fb  
   and  asset_status = @tagstatusact_tmp   
  
  /* Code Commented & modified by Swetha for ACAPDMS412AT_000341 on 10/02/2006 */  
   
 end  
 else/*Old tag*/  
 begin  
  -- inservice date same as that of the existing tag  
  if @inv_date <> @inservicedate  
  begin  
   select @m_errorid = 40  
   return  
  end  
  
  -- scrap same as that of the existing tag  
  if isnull(@acap_salvage_value,0) <> isnull(@salvagevalue,0)  
  begin  
   --exec fin_german_raiserror_sp 'ACAP',@ctxt_language,49,'' ,'','' , '','','','',@error_msg output  
   select @m_errorid = 3459146  
   return  
  end  
  
  if (isnull(@tagcost,0)- isnull(@tagcost_tmp,0)) < 0  
  begin  
   -- Tag cost cannot be less than the value already authorized.  
   select @m_errorid = 900004521   
    return  
  end  
  else  
  begin  
   select @tagcostinc_tmp = isnull(@tagcost,0)- isnull(@tagcost_tmp,0)  
  
  end  
  --code commented for bug id 14H109_ACAP_00004 starts  
  /*if exists (select 'x' from ainq_asset_tag_balance_vw(nolock)  
     where   ou_id   = @ctxt_ouinstance  
     and     asset_number  = @assetnumber  
     and  fb_id  = @fb  
     and tag_number = @tagnumber  
     and     isnull(cum_depr_charge,0)> 0)   
    
  begin  
   --raiserror('Depreciation / Revaluation processed for the asset . Cannot Amend the Asset',16,1)  
   select @m_errorid = 900004492  
   return     
  end  
  if exists(select 'x' from ainq_asset_tag_dtl(nolock)  
   where   ou_id   = @ctxt_ouinstance  
   and     asset_number  = @assetnumber  
   and  fb_id  = @fb  
   and tag_number = @tagnumber  
   and     isnull(revalued_cost,0) > 0)  
  begin  
   --raiserror('Depreciation / Revaluation processed for the asset . Cannot Amend the Asset',16,1)  
   select @m_errorid = 900004492  
   return     
  end*/  
  --code commented for bug id 14H109_ACAP_00004 ends  
    
/* Code added by Esther J on 18/05/2007 for defect ACAPDMS412AT_000710 starts */  
  select @acap_depr_category = ''   
  from acap_asset_hdr A(nolock), ainf_asset_class_vw D (nolock)  
  where  A.ou_id   = @ctxt_ouinstance  
  and   A.asset_number  = @assetnumber  
  and   A.fb_id   = @fb  
  and  D.ou_id   = A.ou_id  
  and  D.asset_class_code      = A.asset_class  
  and  D.dest_component  = 'ACAP'    
  and  D.depreciable   = 'N'  
/* Code added by Esther J on 18/05/2007 for defect ACAPDMS412AT_000710 ends */
  
  
  if ltrim(rtrim(upper(isnull(@acap_depr_category, '')))) <> ltrim(rtrim(upper(isnull(@depcategory, ''))))  
  begin  
   --exec fin_german_raiserror_sp 'ACAP',@ctxt_language,52,'' ,'','' , '','','','',@error_msg output  
   select @m_errorid = 3459144  
   return  
  end  
  
  if @acap_business_use <> @businessuse  
  begin  
   --exec fin_german_raiserror_sp 'ACAP',@ctxt_language,48,'' ,'','' , '','','','',@error_msg output  
   select @m_errorid  = 3459145  
   return  
  end  
    
  /* code commented for the dts id 13H120_General_00032 ;13H120_ACAP_00002 starts */  
  /*  
  --Code  Modified by Ravikrishnan on 02/Aug/2006 for Base Bug id:- ACAPDMS412AT_000488  
  if  @acap_proposal_number is not null 
  begin  
   if ltrim(rtrim(upper(isnull(@acap_proposal_number, '')))) <> ltrim(rtrim(upper(isnull(@proposalnumber, ''))))  
   begin  
--exec fin_german_raiserror_sp 'ACAP',@ctxt_language,50,'' ,'','' , '','','','',@error_msg output  
    select @m_errorid = 3459147  
    return  
   end 
  
  end  
  --Code  Modified by Ravikrishnan on 02/Aug/2006 for Base Bug id:- ACAPDMS412AT_000488  
  */  
  /* code commented for the dts id 13H120_General_00032 ;13H120_ACAP_00002 starts */  
    
  --if tag number is null then raise error  
  if @tagnumber is  null  
  begin  
   select @m_errorid = 27  
   return  
  end  
  
  --if the tag does not exists raise error  
  if not exists (select 'x' from acap_asset_tag_dtl(nolock)  
    where ou_id  = @ctxt_ouinstance  
    and   asset_number = @assetnumber  
    and   fb_id   = @fb  
    and   tag_number = @tagnumber)  
  begin  
   select @m_errorid =28  
   return  
  end  
    
  
  
  --if tag is not in authorised state then raise error  
  if not exists (select 'x' from acap_asset_tag_dtl(nolock)
  
    where ou_id   = @ctxt_ouinstance  
    and   asset_number  = @assetnumber  
    and   tag_number  = @tagnumber  
    and   tag_status  = @tagstatusact_tmp )  
    
  begin  
   select @m_errorid = 29  
   return  
  end  
    
	--epe-16884
	 declare @errorid1 fin_int,  
		@success_flag1  fin_modeflag  

	 exec acap_cmn_usage_val_sp  @guid,    'FA_ACAP',    'ACAP',  
			 @ctxt_ouinstance,  @ctxt_service,  @assetclass,  
			 @depcategory,  @usefullifeinmonths, @capitalizationdate,  
			 @totalcapact,  @measurunit,   'Y',  
			 @businessuse,  
			 @errorid1 out,  0,      @success_flag1 OUT  
	 if @errorid1 > 0  
	 return  
  
	  --epe-16884

  /* Code Commented & modified by Swetha for ACAPDMS412AT_000341 on 10/02/2006 */  
  if exists(select 'x' from acap_asset_info_tmp(nolock)   
  where  guid   = @guid  
  and  ou_id   = @ctxt_ouinstance  
  and  asset_number  = @assetnumber  
  and  tag_number = @tagnumber)  
  
  begin  
   /*update  acap_asset_info_tmp with (rowlock)  
   set tag_desc = @tagdescription,  
    manufacturer = @manufacturer,  
    bar_code = @barcode,  
    serial_no = @serialnumber,  
    warranty_no = @warrentynumber,  
    model  = @model,  
    custodian = @custodian      
   where guid  = @guid  
   and  ou_id   = @ctxt_ouinstance  
   and  asset_number  = @assetnumber  
   and  tag_number = @tagnumber  
  
  end  
  else  
  begin*/  
   delete from acap_asset_info_tmp  
   where  guid   = @guid  
   and  ou_id   = @ctxt_ouinstance  
   and  asset_number  = @assetnumber  
   
and  tag_number = @tagnumber  
  end  
  /*code modified for EPE-8428 - Harithra*/  
   insert into acap_asset_info_tmp  
   (guid,ou_id,cap_number,asset_number,timestamp,  
   cap_date,cap_status,fb_id,num_type,asset_class,asset_group,cost_center,  
   asset_desc,asset_cost,asset_location,seq_no,as_on_date,asset_type,  
   asset_status,transaction_date,account_code,tag_number,tag_desc,  
   inservice_date,tag_cost,proposal_number,tag_status,depr_category,inv_cycle,  
   salvage_value,manufacturer,bar_code,serial_no,warranty_no,model,custodian,  
   business_use,reverse_remarks,book_value,revalued_cost,createdby,createddate,modifiedby,  
                        /* Code modified by Swetha for ACAPDMS412AT_000548 on 11/9/2006 */  
   modifieddate,tag_cost_orig,new_tag,  
   LAccount_code,LAccount_desc,Lcost_center,LAnalysis_code,LSubAnalysis_code ,asset_cluster,asset_category,asset_classification
   ,asset_capacity_uom,asset_capacity,salvage_valper)--epe-16037  --EPE-43676  
                       /* Code modified by Swetha for ACAPDMS412AT_000548 on 11/9/2006 */  
   select distinct --Code modified by Anitha for the bug id : ES_ACAP_00025  
   @guid,@ctxt_ouinstance,@capitalizationnumber,a.asset_number,a.timestamp,  
   @capitalizationdate,a.cap_status,@fb,a.num_type,a.asset_class,  
         /* Code modified by Swetha for ACAPDMS412AT_000527 on 24/08/2006 */      
         a.asset_group,isnull(@costcenter,cost_center),a.asset_desc,@tagcostinc_tmp,  
            /* Code modified by Swetha for ACAPDMS412AT_000527 on 24/08/2006 */  
   @assetlocation,a.seq_no,a.as_on_date,a.asset_type,'AM',  
   a.transaction_date,a.account_code,@tagnumber,@tagdescription,  
   @inservicedate,@tagcostinc_tmp,@proposalnumber,'AM',  
   @depcategory,@invcyclecode,@salvagevalue,@manufacturer,  
   @barcode,@serialnumber,@warrentynumber,@model,@custodian,  
   @businessuse,null,null,null,@ctxt_user,dbo.RES_Getdate(@ctxt_ouinstance),null,null,  
                        /* Code modified by Swetha for ACAPDMS412AT_000548 on 11/9/2006 */  
   @tagcost_tmp,@newtag,  
                        /* Code modified by Swetha for ACAPDMS412AT_000548 on 11/9/2006 */  
   @accountcode,@accountdescription,@lscostcentre, @analysiscode, @subanalysiscode  
   ,@assetcluster,@assetcategory,asset_classification --EPE-11335  
   ,@measurunit, @totalcapact --epe-16037 
   ,@salvageper--EPE-43676
   from  acap_asset_hdr A(nolock)  
   where  ou_id   = @ctxt_ouinstance  
   and  asset_number  = @assetnumber  
   and  fb_id  = @fb  
   and  asset_status = @tagstatusact_tmp   
  /* Code Commented & modified by Swetha for ACAPDMS412AT_000341 on 10/02/2006 */  
 end   

	--Update barcode for the asset - tag starts here
	--EPE-66921

	select @asset_barcode = bar_code
	from acap_asset_tag_dtl(nolock)
	where   ou_id				=	@ctxt_ouinstance
	and		asset_number		=	@assetnumber
	and		tag_number			=   @tagnumber

	if exists(	select 'X' from cps_processparam_vw(nolock)
				where company_code = @companycode_tmp
				and parameter_type = 'FASYS'
				and parameter_code = 'autogenbarcode'
				and language_id	   = @ctxt_language)
	begin

		select @Manbargen_tmp = parameter_value 
		from cps_processparam_vw(nolock)
		where company_code = @companycode_tmp
		and parameter_type = 'FASYS'
		and parameter_code = 'AllowManGenBarcode'
		and language_id	   = @ctxt_language

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

	/*if isnull(@asset_barcode,'') <> isnull(@barcode,'') and @Manbargen_tmp = 'N'
	begin
		select @barcode = @asset_barcode
	end*/

	--if @Manbargen_tmp = 'Y' and isnull(@asset_barcode,'') <> isnull(@barcode,'')
	if @Manbargen_tmp = 'Y' and  isnull(@barcode,'') <> ''
	begin
		select @bargen_tmp = 'N'

		if isnull(@asset_barcode,'') <> isnull(@barcode,'')
		begin
		if exists(select 'X' from acap_Asset_Tag_dtl(nolock)
					where ou_id		=	@ctxt_ouinstance
					and   bar_code	=	@barcode)
		begin
			--raiserror('Barcode number already exists for another Asset.',16,1)
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,302
			return
		end	
		end
	end
	--EPE-66921
	--Update barcode for the asset - tag ends here	

	--Update barcode for the asset - tag starts here (will be called only when barcode is null)
	--EPE-66921

	if isnull(@bargen_tmp,'N') <> 'N' --and isnull(@barcode,'') = ''
	begin
		exec Acap_Barcode_Gen_sp @ctxt_language ,
								 @ctxt_ouinstance,
								 @ctxt_service,
								 @ctxt_user,
								 @assetnumber,
								 @tagnumber,
								 @bargen_tmp,
								 @guid
	end

	--update barcode for the asset - tag ends here	(will be called only when barcode is null)

	--Post generation taking the bar code from the table
	select @barcode = bar_code
	from acap_asset_info_tmp(nolock)
	where   ou_id				=	@ctxt_ouinstance
	and		asset_number		=	@assetnumber
	and		tag_number			=   @tagnumber
	and		guid				=   @guid
	and		tag_Status			=	'AM'
   
 select  @assetclass   'assetclass',   
  @assetdescription  'assetdescription',   
  @assetgrpnum   'assetgrpnum',   
  @assetlocation   'assetlocation',   
  @assetnumber   'assetnumber',   
  @barcode   'barcode',   
  @businessuse   'businessuse',   
  @capitalizationdate  'capitalizationdate',   
  @capitalizationnumber  'capitalizationnumber',   
  @costcenter   'costcenter',   
 
 @createddate   'createddate',   
  @creationby   'creationby',   
  @custodian 'custodian',   
  @depcategory   'depcategory',   
  @fb    'fb',   
  @guid    'guid',   
  @inservicedate   'inservicedate',   
  @invcyclemlenn   'invcyclemlenn',   
  @manufacturer   'manufacturer',   
  @model    'model',   
  @newtag   'newtag',   
  @proposalnumber  'proposalnumber',   
  @salvagevalue   'salvagevalue',   
  @serialnumber   'serialnumber',   
  @status   'status',   
  @tagcost   'tagcost',   
  @tagdescription  'tagdescription',   
  @tagnumber   'tagnumber',   
  @timestamp   'timestamp',   
  @warrentynumber  'warrentynumber',  
  @numbering_type_no 'numbering_type_no'  
  /*Code added by Damodharan. R for Defect ID 14109_ADEPP_00004 starts here*/  

  ,@residualvalue    'RESIDUALVALUE',  
  @usefullifeinmonths   'USEFULLIFEINMONTHS',  
  /*Code added by Damodharan. R for Defect ID 14109_ADEPP_00004 ends here*/  
/*code modified for EPE-8428 - Harithra*/  
  @accountcode 'accountcode',   
  @accountdescription 'accountdescription',   
  @lscostcentre 'lscostcentre',   
  @analysiscode 'analysiscode',   
  @subanalysiscode 'subanalysiscode'  
  --EPE-11335  
  ,@assetclassification 'assetclassification',   
  @assetcategory 'assetcategory',   
  @assetcluster 'assetcluster'  
  --EPE-11335  
  ,@measurunit	'MeasurUnit', --epe-16037  
  @totalcapact	'TotalCapact' --epe-16037
  ,@salvageper	'salvageper'--EPE-43676
 set nocount off  
end  

