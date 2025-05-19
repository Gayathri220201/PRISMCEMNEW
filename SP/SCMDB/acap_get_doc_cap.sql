/*$File_version=MS4.3.0.43$*/  
/*$file name : acap_get_doc_cap.sql*/  
/*$version   : 4.0.0.20*/  
/*================================================== ===
   stored procedure : acap_get_doc_cap  
   author           : Porselvi.J  
   created on       : 18-04-2005  
   Purpose     : Based on the Inputs, this sp will return Cap. document and their Pending Cap amount.  
   Pending Cap. amount is available in si_doc_hdr_vw - cap_amount */  
/*  
Modified By: Sangeetha Sitaraman  
Date       : 25/Oct/2005  
Remarks    : For FA revamp  
version    : 4.0.0.7(For the Pervious versions of the same Sp please refer to the VSS copy)  
  
Modified By: Swetha  
Date       : 12/12/2005  
Remarks    : ACAPDMS412AT_000092  
version    : 4.0.0.8  
  
  
Modified By: Sangeetha Sitaraman  
Date       : 25/Oct/2005  
Remarks    : Code modified to handle capital work order documents  
version    : 4.0.0.9(For the Pervious versions of the same Sp please refer to the VSS copy)  
  
  
Modified By: Swetha  
Date       : 02/02/2006  
Remarks    : ACAPDMS412AT_000333  
version    : 4.0.0.10  
  
  
Modified By: Swetha  
Date       : 09/02/2006  
Remarks    : ACAPDMS412AT_000319  
version    : 4.0.0.11  
  
Modified by  : Swetha  
Date      : 17/03/2006  
Purpose      : ACAPDMS412AT_000322  
version    : 4.0.0.12  
*/  
/********************************************************************************/  
/*Modified by        : Swetha                                                   */  
/*Modified Date      : 5/5/2006                                                 */  
/*Purpose            : CML Changes                                              */  
/********************************************************************************/  
/********************************************************************************/  
/*Modified by        : Swetha                                                   */  
/*Modified Date      : 18/5/2006                                                */  
/*Purpose            : ACAPDMS412AT_000442                                      */  
/********************************************************************************/  
/********************************************************************************/  
/*Modified by        : Swetha                                                   */  
/*Modified Date      : 11/8/2006                                                */  
/*Purpose            : ACAPDMS412AT_000509                                      */  
/********************************************************************************/  
/********************************************************************************/  
/*Modified by        : Swetha                                                   */  
/*Modified Date      : 30/8/2006                                                */  
/*Purpose            : ACAPDMS412AT_000522                                      */  
/********************************************************************************/  
/**********************************************************************************/   
/* modified by          Swetha  
 Date                   16/10/2006   
 Purpose                ACAPDMS412AT_000558  
 Version                4.0.0.17 */                             
/**********************************************************************************/   
/* modified by          Swetha  
 Date                   16/10/2006   
 Purpose                ACAPDMS412AT_000560                                       */  
/*********************************************************************************/  
/* Swetha               05/01/2007              SDINDMS412AT_000538             */  
/*  
Modification History  
Modified By   Date   Remarks  
Uma Maheswari   07th May 2007  ACAPDMS412AT_000701   
       (Only Sp alignment)  
Aparna M.   09/06/2008  8H123-1_spy_00001  
Uma Maheswari   25th Aug 2008 ES_Amig_00001  
Angelin.R    31/10/2008  MS440_GEN_MRBCAP   
Esther    18/11/2008  MS440_GEN_MRBCAP   
Angelin.R   24/11/2008  8H123-2_ACAP_00048   
Angelin.R   26/11/2008  8H123-2_ACAP_00052  
Esther J    02/12/2008  8H123-2_ACAP_00059  
Angelin.R   15/12/2008  ES_ACAP_00011  
Uma Maheswari  18th Aug 2009 ES_ACAP_00079  
Veangadakrishnan R 03/12/2009  9H123-1_ACAP_00001  
Veangadakrishnan R 30/12/2009  9H123-1_ACAP_00003 (Ref ID: 9H123-1_ACAP_00001)  
Veangadakrishnan R 31/12/2009  9H123-1_ACAP_00005 (Ref ID: 9H123-1_ACAP_00001)  
Veangadakrishnan R  18/01/2010      9H123-1_ACAP_00014 (Ref ID: 9H123-1_ACAP_00001)  
Malinidevi.U  18/01/2010  ES_ACAP_00117  
Malinidevi.U  22/02/2010  ES_ACAP_00117  
T.AnandhaMurugan    12/09/2012  12H124_ACAP_00001 
Balaji C			18/07/2014		ES_ACAP_00622
Thyagaraj B M        16/07/2014   14H109_ACAP_00003
Aditya Sitaraman     14/08/2014		ES_ACAP_00635
C.Ramesh Kumar				26.09.2014				14H109_ACAP_00041	
Aditya Sitaraman     03/12/2014		ES_ACAP_00695
Aditya S			 08/06/2017		ZHE-599
Sangeetha M					07/08/2017				EPE-2039	
Sriram M			02/Feb/2018		TVSLS-2930	
Aditya S			27/03/2018		EP-93
Aditya S			18/07/2018		HAL-773
Ashok V				17/7/2018		EBS-1694	
Indira G			21/09/2018		EBS-1882
Indira G			05/10/2018		EBS-2016	
Ashok V				16/10/2018		AA-575		
Ashok V				04/02/2018		EBS-2581	
Ashok V				25/03/2019		HAL-1064			
Balaji C			23/07/2019		NSAPL-3073	
Ashok V				22/08/2019		NSAPL-3135
Ashok V				10/02/2020		EBS-3983
Ashok V				18/08/2020		RFBE-76
Abimathi M			06-01-2021		EPE-25078
Ashok V				20/01/2021		MPIE-331
Abimathi.M			13/04/2020		EPE-32065:EPE-33017
Ashok V				27/04/2021		PTP-1695
Andavar C			15/12/2022		PTP-2238
/*Banurekha B       22/6/2023       RBMPE-56  */
Srinivasan M        05/10/2023      MCHS-754
Srinivasan M        24/01/2024      TC-2440
Saranraj C          08/04/2024      EPE-79756
Srinivasan M        05/08/2024      EPE-87204
*/  

Create procedure acap_get_doc_cap  
  @ctxt_language		fin_ctxt_language  ,  
  @ctxt_ouinstance  fin_ctxt_ouinstance  ,  
  @ctxt_service		fin_ctxt_service  ,  
  @ctxt_user		fin_ctxt_user  ,  
  @doctype			fin_documenttype  ,  
  @documentdatefrom fin_date  ,  
  @documentdateto   fin_date  ,  
  @documentnumberfrom  fin_documentnumber  ,  
  @documentnumberto  fin_documentnumber  ,  
  @fb				fin_financebookid  ,  
  @guid				fin_guid  ,  
  @proposalnumber   fin_documentnumber  ,  
  @supplier_code    fin_suppliercode ,  
  @Project_code     fin_Projectcode,--Code added by thyagaraj for 14H109_ACAP_00003   
  @m_errorid		fin_int output   
as  
begin  
  
  
 /* Code added by Uma for the defect id : ES_ACAP_00079 Starts here*/  
 --BEGIN of Standard code for getting precision type  
 declare @pqty_tmp    fin_int,  
   @pamt_tmp    fin_int,  
   @prate_tmp   fin_int,  
   @perate_tmp  fin_int,  
   @phigh_tmp   fin_int,  
   @pmed_tmp    fin_int,  
   @plow_tmp    fin_int   
  
 exec  fin_sp_precisiontype_rtr @pqty_tmp output,  
       @pamt_tmp output,  
       @prate_tmp output,  
       @perate_tmp output,  
       @phigh_tmp output,  
       @pmed_tmp output,  
       @plow_tmp output  
 /* Code added by Uma for the defect id : ES_ACAP_00079 Ends here*/  
  
  
 declare @doctype_tmp      fin_documenttype  
 declare @loid_tmp         fin_buid  
 declare @companycode_tmp  fin_companycode  
 declare @doctype_tmp1     fin_documenttype  
 declare @supp_code    fin_suppliercode /* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 */  
 declare @base_curr		fin_currencycode	--code added for ES_ACAP_00695
 DECLARE @pps_flag      fin_flag --code added by EPE-87204
 set nocount on  
  
 -- @m_errorid should be 0 to indicate success  
 select  @m_errorid = 0  
  
  
 select  @ctxt_service = ltrim(rtrim(@ctxt_service))  
 select  @ctxt_user = ltrim(rtrim(@ctxt_user))  
 select  @doctype = ltrim(rtrim(@doctype))  
 select  @documentdatefrom = ltrim(rtrim(@documentdatefrom))  
 select  @documentdateto = ltrim(rtrim(@documentdateto))  
 select  @documentnumberfrom = ltrim(rtrim(@documentnumberfrom))  
 select  @documentnumberto = ltrim(rtrim(@documentnumberto))  
 select  @supplier_code = ltrim(rtrim(@supplier_code))  
 select  @fb = ltrim(rtrim(@fb))  
  
  
 if  @ctxt_language = -915  
  select  @ctxt_language = null  
  
 if  @ctxt_ouinstance = -915  
  select  @ctxt_ouinstance = null   
  
 if  @ctxt_service = '~#~'  
  select  @ctxt_service = null    
  
 if  @ctxt_user = '~#~'  
  select  @ctxt_user = null    
  
 if  @doctype = '~#~'  
  select  @doctype = null   
  
 if  @documentdatefrom = '1/1/1900'  
  select  @documentdatefrom = '1/1/1900'    
  
 if  @documentdateto = '1/1/1900'  
  select  @documentdateto = '1/1/2100'  
  
 if  @documentnumberfrom = '~#~'  
  select  @documentnumberfrom = null    
  
 if  @documentnumberto = '~#~'  
  select  @documentnumberto = null   
  
 if  @fb = '~#~'  
  select  @fb = null  
  
 if  @guid = '~#~'  
  select  @guid = null  
  
 if  @proposalnumber = '~#~'  
  select  @proposalnumber = null  
  
 if  @supplier_code = '~#~'  
  select  @supplier_code = null  
  
  
 select  @loid_tmp = lo_id,  
   @companycode_tmp = company_code  
 from    emod_lo_bu_ou_vw(nolock)  
 where ou_id  = @ctxt_ouinstance  
   
  --ES_ACAP_00695
 select @base_curr = currency_code
 from emod_basecurr_vw(nolock)
 where flag = 'B'
 and  company_code = @companycode_tmp
  --ES_ACAP_00695
  
  
 select  @doctype_tmp1 = parameter_text  
 from    fin_quick_code_met(nolock)  
 where component_id  = 'ACAP'  
 and  parameter_type  = 'CBO'  
 and  parameter_category  = 'DOC_TYP'  
 and  language_id  = @ctxt_language  
 and  upper(parameter_code)  = 'ALL'  
  
  
 select  @doctype_tmp = parameter_code  
 from    fin_quick_code_met(nolock)  
 where component_id  = 'ACAP'  
 and  parameter_type  = 'CBO'  
 and  parameter_category  = 'DOC_TYP'  
 and  language_id  = @ctxt_language  
 and  parameter_text  = @doctype  
 
 --EBS-1882
 if @doctype_tmp = 'All'
 begin
	select @doctype_tmp = ''
 end
 --EBS-1882

 delete   
 from acap_doc_dtl_tmp  
 where   guid = @guid  
  
 select @supp_code = @supplier_code /* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 */  
 select  @supplier_code = replace(upper(isnull(@supplier_code, '')), '*', '%') + '%'  
  
 /* Capital work in progress to be handled*/  
 
  
-- if  @ctxt_service = 'ACAPCRSMASSRGET' 12H124_ACAP_00001  
 if  @ctxt_service in('ACAPCRSMASSRGET' ,'ACA_TIAC_SR_GET')  
 begin  
  if  @doctype_tmp is null  
  or  @doctype_tmp = ''  
  or  @doctype = @doctype_tmp1  
  begin  
  
	--TVSLS-2930	
   /*
   ;  
   /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
   with SQLTMP(tmpCol) as (  
    select  distinct C.destinationouinstid  
                     /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
    from    si_doc_hdr_vw a(nolock),  
                     acap_cim_intxn_model_vw c(nolock)  
    where C.sourceouinstid  = @ctxt_ouinstance  
    and  C.sourcecomponentname  = 'ACAP'  
    and  C.destinationcomponentname  = A.component_id  
   )  
   */
    --TVSLS-2930
	
    insert into acap_doc_dtl_tmp  
     (  
    guid,  
    ou_id,  
    fb_id,  
    doc_number,  
    doc_type,  
    pending_cap_amount,  
    proposal_number,  
    tran_date,  
    supplier_code,  
    doc_amount,  
    tran_currency,  
    exchange_rate,  
    cap_amount,  
    line_no,  
    cap_flag,  
    account_code,  
    Project_code --Code added by thyagaraj for 14H109_ACAP_00003  
    ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
     )  
   select  @guid,  
           A.tran_ou,  
           A.fb_id,  
           A.tran_no,  
           A.tran_type,  
           isnull(B.pending_cap_amount, 0),  
           B.proposal_no,  
           A.tran_date,  
           A.supplier_code,  
           isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0),  
      A.tran_currency,  
           A.exchange_rate,  
           isnull(B.capitalized_amount, 0),  
           B.line_no,  
           B.cap_doc_flag,  
           B.account_code,  
           A.Project_code	--Code added by thyagaraj for 14H109_ACAP_00003
           ,null,			--EPE-2039
           unit_price,--rate_per,		--EPE-2039
           item_qty			--EPE-2039
   from    si_line_detail_vw B(nolock),  
   --code commented and added for TVSLS-2930 starts
   /*
                 si_doc_hdr_vw A(nolock) join   
     SQLTMP  
   on   (A.tran_ou = SQLTMP.tmpCol)  
   where A.tran_ou  = B.tran_ou  
   */
   si_doc_hdr_vw A(nolock)
   WHERE A.tran_ou  = B.tran_ou  
   AND EXISTS ( select  '*' 
				from    acap_cim_intxn_model_vw c(nolock)  
				where C.sourceouinstid  = @ctxt_ouinstance  
				and  C.sourcecomponentname  = 'ACAP'  
				and  C.destinationcomponentname  = A.component_id 
				and C.destinationouinstid =  A.tran_ou
			  )
	--code commented and added for TVSLS-2930 ends
   and  A.tran_type  = B.tran_type  
   and  A.tran_no  = B.tran_no  
   and  A.fb_id like @fb  
   and  (  
               (  
                convert(nchar(10), A.tran_date, 101)   
                between isnull(@documentdatefrom, A.tran_date)   
                and isnull(@documentdateto, A.tran_date)  
               )  
              )  
   and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
   and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
   and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
   and  (  
               (  
                A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                and isnull(@documentnumberto, A.tran_no)  
               )  
              )   
              /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
   and  A.tran_type   in ('PM_PI', 'PM_IV', 'PM_EV', 'PM_SPV','PM_SCA')--,'PM_MI')--EPE-25078--Modified for DTS ID:9H123-1_ACAP_00001  
              /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
   and  (A.doc_status in ('AUT') or A.paid_status in ('PAD')) 
   and  B.cap_doc_flag  = 'CI' 
   and  B.row_type   in ('ITEM', 'ACC')  
   and  (B.capitalized_amount >= 0 or B.pending_cap_amount > 0)  
   
   
   /*code added for EPE-2039 starts*/
	update tmp --check
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		tmp.account_code = a.account_code--code added for MPIE-331
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	--EP-93	
	
	/*code added for EPE-2039 ends*/

   --Added for DTS ID:9H123-1_ACAP_00003 starts here  
   ;  
   with SQLTMP(tmpCol) as (  
    select  distinct C.destinationouinstid  
    from    si_doc_hdr_vw a(nolock),  
                     acap_cim_intxn_model_vw c(nolock)  
    where C.sourceouinstid  = @ctxt_ouinstance  
    and  C.sourcecomponentname  = 'ACAP'  
    and  C.destinationcomponentname  = A.component_id  
   )  
   insert into acap_doc_dtl_tmp  
     (  
    guid,  
    ou_id,  
    fb_id,  
    doc_number,  
    doc_type,  
    pending_cap_amount,  
    proposal_number,  
    tran_date,  
    supplier_code,  
    doc_amount,  
    tran_currency,  
    exchange_rate,  
    cap_amount,  
    line_no,  
    cap_flag,  
    account_code,  
    Project_code --Code added by thyagaraj for 14H109_ACAP_00003
    ,cost_center,	--EPE-2039
    rate,			--EPE-2039
  quantity		--EPE-2039
     )  
   select  @guid,  
           A.tran_ou,  
           A.fb_id,  
          A.tran_no,  
           A.tran_type,  
       case tcdtype   
      when 'D' then -isnull(B.pending_cap_amount, 0)  
      else isnull(B.pending_cap_amount, 0)  
 end,  
           B.proposal_no,  
           A.tran_date,  
           A.supplier_code,  
           case tcdtype   
      when 'D' then -(isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0))  
      else isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0)  
     end,  
        A.tran_currency,  
    A.exchange_rate,  
case tcdtype   
      when 'D' then -isnull(B.capitalized_amount, 0)  
      else isnull(B.capitalized_amount, 0)  
     end,  
         B.line_no,  
           B.cap_doc_flag,  
           B.account_code,  
           A.Project_code --Code added by thyagaraj for 14H109_ACAP_00003
            ,null,				--EPE-2039
			 unit_price,--rate_per,			--EPE-2039
			 item_qty			--EPE-2039
   from    si_line_detail_vw B(nolock),  
                 si_doc_hdr_vw A(nolock) join   
           SQLTMP  
   on   (A.tran_ou = SQLTMP.tmpCol),  
     sin_delivery_Charge_dtl dtl(nolock),  
     tcd_tcdvariantdetail_vw tcd(nolock)  
   where A.tran_ou  = B.tran_ou  
   and  A.tran_type = B.tran_type  
   and  A.tran_no  = B.tran_no  
   and  A.tran_type = dtl.tran_type  
   and  A.tran_ou = dtl.tran_ou  
   and  A.tran_no = dtl.tran_no  
   and  b.line_no = dtl.tran_line_no  
   and  DTL.tcd_code = tcd.tcdcode  
   and  DTL.tcd_variant = tcd.tcdvariant   
   and  DTL.tcdversionno= tcd.tcdversionno  
   and     tcd.lo_id   = @loid_tmp  
   and     tcd.tcdaccrule  = 'IN'  
   and  A.fb_id  like @fb  
   and  (  
               (  
                convert(nchar(10), A.tran_date, 101)   
                between isnull(@documentdatefrom, A.tran_date)   
                and isnull(@documentdateto, A.tran_date)  
               )  
              )  
   and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
   and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
   and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
   and  (  
               (  
                A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                and isnull(@documentnumberto, A.tran_no)  
               )  
              )   
   and  A.tran_type  = 'PM_MI'  
   and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
   and  B.cap_doc_flag  = 'CI'  
   and  B.row_type   in ('ITEM', 'ACC')  
   and  (B.capitalized_amount >= 0 or B.pending_cap_amount > 0)  
   --Added for DTS ID:9H123-1_ACAP_00003 ends here  
   
   /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		tmp.account_code = a.account_code--code added for MPIE-331
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	--EP-93	
	/*code added for EPE-2039 ends*/
      
           
   /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/  
   ; 
   with SQLTMP(tmpCol) as (  
    select  distinct A.destinationouinstid  
    from    acap_cim_intxn_model_vw A(nolock)  
    where A.sourceouinstid  = @ctxt_ouinstance  
    and  A.sourcecomponentname  = 'ACAP'  
    and  A.destinationcomponentname  = 'STKISSUE'  
   )  
   /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/  
           
   /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Starts here*/  
   /*Code Commented by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/  
   --if @doctype_tmp = 'INV_IMIS'  
   --begin  
   /*Code Commented by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/  
   insert into acap_doc_dtl_tmp  
     (  
    guid,  
    ou_id,  
    fb_id,  
    doc_number,  
    doc_type,  
    pending_cap_amount,  
    tran_date,  
    supplier_code,  
    doc_amount,  
    tran_currency,  
    exchange_rate,  
    cap_amount,  
    line_no,  
    cap_flag,  
    account_code,  
    proposal_number,  
    Project_code --Code added by thyagaraj for 14H109_ACAP_00003
    ,cost_center,	--EPE-2039
    rate,			--EPE-2039
 quantity		--EPE-2039
)  
   select  @guid, 
           iih_ouinstid,  
        iih_posting_fb,  
     iih_issue_no,  
        'INV_IMIS',  
           sum(iid_pencapitalisation_amt),  
           iih_issue_date,  
           null,  
           sum(iid_issue_value), 
           null,  
           null,  
           sum(iid_pencapitalisation_amt),  
           iid_line_no,  
           'CI',  
           iid_dr_account_code,  
           mr_proposal_number,  
           iih_ProjectCode	--Code added by thyagaraj for 14H109_ACAP_00003  
           ,iid_cost_center,	--EPE-2039
			iid_issue_value,	--EPE-2039 --check
			iid_issue_qty		--EPE-2039
   from    issue_inv_detail d(nolock),  
       MR_header(nolock),  
                 issue_inv_header h(nolock) join   
           SQLTMP  
   on   (h.iih_ouinstid = SQLTMP.tmpCol) --Code Added by Angelin.R for the Bug : 8H123-2_ACAP_00048  
   where iid_issue_no  = h.iih_issue_no  
   and  h.iih_ouinstid  = d.iid_ouinstid  
   and  h.iih_posting_fb like @fb  
   and  (  
           (  
                h.iih_issue_date between isnull(@documentdatefrom, h.iih_issue_date) and isnull(@documentdateto, h.iih_issue_date)  
               )  
              )  
   and  (  
               (  
                h.iih_issue_no between isnull(@documentnumberfrom, h.iih_issue_no) and isnull(@documentnumberto, h.iih_issue_no)  
               )  
              )  
   and  h.iih_status  = 'AU'  
   and  iih_mr_type  = 'C'  
   and  isnull(mr_proposal_number, '')  = isnull(@proposalnumber, isnull(mr_proposal_number, '')) --Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00052  
   and  mrh_ou  = h.iih_ouinstid  
   and  mrh_transaction_no  = iih_ref_doc_no 
   /*code commented for ES_ACAP_00635 starts*/ 
   /*
	/*Code added for ITS ID : ES_ACAP_00622 */
	and     d.iid_ref_doc_no not in ( select srid_ref_doc_no 
					from str_inventory_det (nolock)
					where  d.iid_ref_doc_no      = srid_ref_doc_no
					and    d.iid_ref_doc_line_no = srid_ref_doc_lineno)
	/*Code added for ITS ID : ES_ACAP_00622 */
  */
   /*code commented for ES_ACAP_00635 ends*/ 
   and  isnull(iih_ProjectCode, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
   group by  
       iih_ouinstid, iih_posting_fb, iih_issue_no, iih_issue_date, iid_dr_account_code, iid_line_no, mr_proposal_number,
       iih_ProjectCode --Code added by thyagaraj for 14H109_ACAP_00003 
		,iid_cost_center,iid_issue_value,iid_issue_qty	--EPE-2039
	/*code added for EBS-1694 starts*/
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
	 /*code added for Rtrackid:EBS-1882 starts */
     --and  C.destinationcomponentname  =  'JV' )
	 /*--code commented and added by TC-2440*/
	  --and  C.destinationcomponentname  = case @doctype_tmp  
   --                                               when 'BK_JV' then 'JV'  
   --                                            end ) 
   and  C.destinationcomponentname  = case when @doctype_tmp='BK_JV' or @doctype_tmp=''
                                                  then 'JV' 
                                               end ) --case handled by TC-2440
    /*--code commented and added by TC-2440*/
	/*code added for Rtrackid:EBS-1882 Ends */
		
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
,cost_center,	
    rate,		
    quantity		
     )  
    select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,0)),hdr.proposal_number,hdr.voucher_date,null,
			sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
			dtl.voucher_serial_no,'CI',dtl.account_code,null,null,null,null --EBS-2016
	from	jv_voucher_trn_dtl dtl(nolock),
			jv_voucher_trn_hdr hdr(nolock)
			join   
  SQLTMP  
    on   (hdr.ou_id = SQLTMP.tmpCol)
	where	hdr.ou_id		= dtl. ou_id
	and		hdr.voucher_no	= dtl.voucher_no
	and		hdr.fb_id		like @fb
	and		hdr.voucher_no  between isnull(@documentnumberfrom, hdr.voucher_no) and isnull(@documentnumberto, hdr.voucher_no)  
	and		hdr.voucher_date	 >   = isnull(@documentdatefrom,hdr.voucher_date)  
    and		hdr.voucher_date	 <= isnull(@documentdateto,hdr.voucher_date) 
    and		isnull(hdr.proposal_number,'')  = isnull(@proposalnumber,isnull(hdr.proposal_number,''))  
	and		hdr.voucher_status  = 'AUT'
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	and		isnull(dtl.cap_flag,'') <> 'NC'--EBS-2581
	/*code added for NSAPL-3135 starts*/
	and		hdr.voucher_type  not in ('REV','TAX')
	and		isnull(hdr.ref_voucher_type,'') <> 'REV'
	and		hdr.voucher_no not in (	select hdr1.ref_voucher_no 
									from jv_voucher_trn_hdr hdr1(nolock)
									where hdr1.voucher_status ='REV'
									and hdr1.ref_voucher_no = hdr.voucher_no
									and	hdr1.ref_voucher_type = hdr.voucher_type
									and	hdr.ou_id			= hdr1.ou_id
									and hdr.fb_id			= hdr1.fb_id
									and hdr.voucher_status  = 'AUT'  )
	/*code added for NSAPL-3135 ends*/
	group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
			dtl.tran_currency,dtl.exchange_rate,
			dtl.voucher_serial_no,dtl.account_code

	update tmp
	set		tmp.cost_center	= a.costcenter_code
	from	acap_doc_dtl_tmp tmp (nolock),
			jv_voucher_trn_dtl a(nolock) 
	where	guid			=	@guid
	and		doc_number		= a.voucher_no
	and		doc_type		= 'BK_JV'
	and		tmp.ou_id			= a.ou_id
	and		a.voucher_serial_no		= tmp.line_no
	and		isnull(a.costcenter_code,'') not in ('','##')		
  /*code added for EBS-1694 ends*/   
      

	/*code added for Rtrackid:EBS-1882 starts */
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
	 and  C.destinationcomponentname  = case @doctype_tmp  
                                                  when 'PUR_GR' then 'GR'  
                                             end ) 
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,sum(isnull(dtl.pending_cap_amount,0)),dtl.proposal_number,
			hdr.gr_hdr_grdate,supplier_code,sum(isnull(dtl.base_amount,0)),hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,sum(isnull(dtl.cap_amt,0)),
			dtl.line_no,'CI',dtl.account_code,Project_code,cost_center,null,null --EBS-2016
	from	gr_capitalization_dtl_vw dtl(nolock),
			gr_hdr_grmain hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.gr_hdr_ouinstid					= SQLTMP.tmpCol)
	where	hdr.gr_hdr_ouinstid		= dtl. tran_ou
	and		hdr.gr_hdr_grno			= dtl.tran_no
	and		dtl.fb_id		like @fb
	and		hdr.gr_hdr_grno  between isnull(@documentnumberfrom, hdr.gr_hdr_grno) and isnull(@documentnumberto, hdr.gr_hdr_grno)  
	and		hdr.gr_hdr_grdate	 between isnull(@documentdatefrom,hdr.gr_hdr_grdate)  and isnull(@documentdateto,hdr.gr_hdr_grdate) 
	and		isnull(dtl.proposal_number,'')  = isnull(@proposalnumber,isnull(dtl.proposal_number,''))  
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN') or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus = 'FA' and match_type in('2P','2W','3G','3P') and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	and		hdr.gr_hdr_grstatus in('FA','FM','PM')
	and 	exists ( select 'X' from ard_asset_account_mst(nolock)
					 where	company_code 	= @companycode_tmp
					 and	account_code	= dtl.account_code
					 and	asset_usage		= 'CWIP')
	group by hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,dtl.proposal_number,hdr.gr_hdr_grdate,
			 supplier_code,hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,
			dtl.line_no,dtl.account_code,Project_code,cost_center

	/*code added for Rtrackid:EBS-1882 Ends */
	
	--EPE-32065 code starts
  	insert into acap_doc_dtl_tmp  
		 (  
		guid,  
		ou_id,  
		fb_id,  
		doc_number,  
		doc_type,  
		pending_cap_amount,  
		proposal_number,  
		tran_date,  
		supplier_code,  
		doc_amount,  
		tran_currency,  
		exchange_rate,  
		cap_amount ,  
		line_no,  
		cap_flag,  
		account_code,
		total_docamt,  
		Project_code, 
		cost_center,	
		rate,			
		quantity		
		 )
	select  @guid,  
           A.ou_id,  
           A.fb_id,  
           A.cap_wo_number,  
           'CO',
           isnull(L.wip_cost,0)- isnull(L.trfr_amount, 0),
           B.proposal_no,  
           A.transaction_date,--EPE-33011  
           B.supplier,  
           isnull(L.wip_cost,0),  
           currency,  
           exchange_rate,  
           isnull(B.doc_amount, 0),  
           cap_line_no,  
           cap_flag,  
           account_code,
		   isnull(A.wip_cost,0),    
           Project_code,
           cost_Center,			
           null,--rate_per,		
           null				
   from    acap_wip_dtl  B(nolock),  
		   acap_wip_hdr  A(nolock),
		   acap_wip_line_dtl L (nolock)
   WHERE A.cap_wo_number  = B.cap_wo_number
   and   A.ou_id		  = B.ou_id
   and	 B.cap_wo_number  = L.cap_wo_number
   and	 B.doc_number	  = L.doc_number
   and	 B.doc_type		  = L.doc_type
   and	 B.ou_id		  = L.ou_id    
   and   A.fb_id like @fb  
   and  (  
               (  
                convert(nchar(10), B.doc_date, 101)   
                between isnull(@documentdatefrom, B.doc_date)   
                and isnull(@documentdateto, B.doc_date)  
               )  
              )  
   and  isnull(B.supplier, @supplier_code) like @supplier_code
   and  isnull(B.Project_code, '') like @Project_code  --EPE-33017
   and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
   and  (  
               (  
                B.cap_wo_number between isnull(@documentnumberfrom, B.cap_wo_number)   
                and isnull(@documentnumberto, B.cap_wo_number)  
               )  
              )   
   and  isnull(L.wip_cost,0)- isnull(L.trfr_amount , 0) > 0
   and  A.wip_status		= 'AC'
   and  B.proposal_no is not null
   --EPE-32065 code ends

   delete   
   from acap_doc_dtl_tmp  
   where   guid = @guid  
   and     pending_cap_amount = 0  
           --end --Code Commented by Angelin.R for the Bug id : 8H123-2_ACAP_00048   
                 /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/  
  end   
  else  
  begin 
  
 --EPE-32065 code starts
  if @doctype_tmp = 'CO'
	begin
		insert into acap_doc_dtl_tmp  
		 (  
		guid,  
		ou_id,  
		fb_id,  
		doc_number,  
		doc_type,  
		pending_cap_amount,  
		proposal_number,  
		tran_date,  
		supplier_code,  
		doc_amount,  
		tran_currency,  
		exchange_rate,  
		cap_amount ,  
		line_no,  
		cap_flag,  
		account_code,
		total_docamt,  
		Project_code, 
		cost_center,	
		rate,			
		quantity		
		 )
	select  @guid,  
           A.ou_id,  
           A.fb_id,  
           A.cap_wo_number,  
           'CO',  
           isnull(L.wip_cost,0)- isnull(L.trfr_amount, 0),
           B.proposal_no,  
           A.transaction_date,--EPE-33011
           B.supplier,  
           isnull(L.wip_cost,0),  
           currency,  
           exchange_rate,  
           isnull(B.doc_amount, 0),  
           cap_line_no,  
           cap_flag,  
           account_code,
		   isnull(A.wip_cost,0),    
           Project_code,
           cost_Center,			
           null,--rate_per,		
           null			
   from    acap_wip_dtl  B(nolock),  
		   acap_wip_hdr  A(nolock),
		   acap_wip_line_dtl L (nolock)
   WHERE A.cap_wo_number  = B.cap_wo_number
   and   A.ou_id		  = B.ou_id
   and	 B.cap_wo_number  = L.cap_wo_number
   and	 B.doc_number	  = L.doc_number
   and	 B.doc_type		  = L.doc_type
   and	 B.ou_id		  = L.ou_id    
   and   A.fb_id like @fb  
   and  (  
               (  
                convert(nchar(10), B.doc_date, 101)   
                between isnull(@documentdatefrom, B.doc_date)   
                and isnull(@documentdateto, B.doc_date)  
               )  
              )  
   and  isnull(B.supplier, @supplier_code) like @supplier_code
   and  isnull(B.Project_code, '') like @Project_code  --EPE-33017  
   and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
   and  (  
               (  
                B.cap_wo_number between isnull(@documentnumberfrom, B.cap_wo_number)   
                and isnull(@documentnumberto, B.cap_wo_number)  
               )  
              )   
   and  isnull(L.wip_cost,0)- isnull(L.trfr_amount , 0) > 0
   and  A.wip_status		= 'AC'
   and  B.proposal_no is not null
   
   end
   --EPE-32065 code ends
 
   ;  
   /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
   with SQLTMP(tmpCol) as (  
    select  distinct C.destinationouinstid  
                     /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
    from    acap_cim_intxn_model_vw c(nolock)  
    where C.sourceouinstid  = @ctxt_ouinstance  
    and  C.sourcecomponentname  = 'ACAP'   
                  /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
    and  C.destinationcomponentname  = case @doctype_tmp  
                                                  when 'PM_PI' then 'SIN'  
                 --when 'PM_MI' then 'SIN'--Modified for DTS ID:9H123-1_ACAP_00001  
                when 'PM_EV' then 'SDIN'  
                                                  when 'PM_IV' then 'SDIN'  
                                                  when 'PM_SPV' then 'SNP'  
                                                  when 'PM_PV' then 'SPY'  
                                                  when 'PM_SCA' then 'SCDN'  
                                                  when 'PM_SCI' then 'SCDN'
												   when 'BK_JV' then 'JV'--code added by TC-2440
                                                end  
   )  
   /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
           
   insert into acap_doc_dtl_tmp  
     (  
    guid,  
    ou_id,  
    fb_id,  
    doc_number,  
    doc_type,  
    pending_cap_amount,  
    proposal_number,  
    tran_date,  
  supplier_code,  
    doc_amount,  
    tran_currency,  
    exchange_rate,  
    cap_amount,  
   line_no,  
    cap_flag,  
    account_code,  
    Project_code --Code added by thyagaraj for 14H109_ACAP_00003
    ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
     )  
   select  @guid,  
           A.tran_ou,  
           A.fb_id,  
           A.tran_no,  
           A.tran_type,  
           isnull(B.pending_cap_amount, 0),  
           B.proposal_no,  
           A.tran_date,  
           A.supplier_code,  
        isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0),  
           A.tran_currency,  
    A.exchange_rate,  
           isnull(B.capitalized_amount, 0),  
           B.line_no,  
           B.cap_doc_flag,  
           B.account_code,  
           A.Project_code	--Code added by thyagaraj for 14H109_ACAP_00003
        	,null,				--EPE-2039
			unit_price,-- rate_per,			--EPE-2039
			 item_qty			--EPE-2039
   from    si_line_detail_vw B(nolock),  
                 si_doc_hdr_vw A(nolock) join   
           SQLTMP  
   on   (A.tran_ou = SQLTMP.tmpCol)  
   where A.tran_ou  = B.tran_ou  
   and  A.tran_type  = B.tran_type  
   and  A.tran_no  = B.tran_no  
   and  A.fb_id like @fb  
   and  (  
               (  
                convert(nchar(10), A.tran_date, 101)   
                between isnull(@documentdatefrom, A.tran_date)   
                and isnull(@documentdateto, A.tran_date)  
               )  
              )  
   and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
   and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
   and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
   and  (  
               (  
                A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                and isnull(@documentnumberto, A.tran_no)  
               )  
              )   
              --and   A.component_id = @doctype_tmp  
              /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
 and  A.tran_type  = @doctype_tmp  
              /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
  and (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
   and  B.cap_doc_flag  = 'CI'  
   and  B.row_type   in ('ITEM', 'ACC')  
   and  B.pending_cap_amount <> 0  
   
   /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	--EP-93	

	/*code added for EPE-2039 ends*/
	 /*code added for EBS-1694 starts*/
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
     --and  C.destinationcomponentname  =  'JV' )
	 /*code added for Rtrackid:EBS-1882 starts */
	 /*--code commented and added by TC-2440*/
	  --and  C.destinationcomponentname  = case @doctype_tmp  
   --                                               when 'BK_JV' then 'JV'  
   --                                            end ) 
   and  C.destinationcomponentname  = case when @doctype_tmp='BK_JV' 
                                                  then 'JV' 
                                               end ) --case handled by TC-2440
    /*--code commented and added by TC-2440*/
	/*code added for Rtrackid:EBS-1882 ends */

	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,0)),hdr.proposal_number,hdr.voucher_date,null,
			sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
			dtl.voucher_serial_no,'CI',dtl.account_code,null,null,null,null --EBS-2016
	from	jv_voucher_trn_dtl dtl(nolock),
			jv_voucher_trn_hdr hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.ou_id = SQLTMP.tmpCol)
	where	hdr.ou_id		= dtl. ou_id
	and		hdr.voucher_no	= dtl.voucher_no
	and		hdr.fb_id		like @fb
	and		hdr.voucher_no  between isnull(@documentnumberfrom, hdr.voucher_no) and isnull(@documentnumberto, hdr.voucher_no)  
	and		hdr.voucher_date	 >   = isnull(@documentdatefrom,hdr.voucher_date)  
    and		hdr.voucher_date	 <= isnull(@documentdateto,hdr.voucher_date) 
    and		isnull(hdr.proposal_number,'')  = isnull(@proposalnumber,isnull(hdr.proposal_number,''))  
	and		hdr.voucher_status  = 'AUT'
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	and		isnull(dtl.cap_flag,'') <> 'NC'--EBS-2581
	/*code added for NSAPL-3135 starts*/
	and		hdr.voucher_type  not in ('REV','TAX')
	and		isnull(hdr.ref_voucher_type,'') <> 'REV'
	and		hdr.voucher_no not in (	select hdr1.ref_voucher_no 
									from jv_voucher_trn_hdr hdr1(nolock)
									where hdr1.voucher_status ='REV'
									and hdr1.ref_voucher_no = hdr.voucher_no
									and	hdr1.ref_voucher_type = hdr.voucher_type
									and	hdr.ou_id			= hdr1.ou_id
									and hdr.fb_id			= hdr1.fb_id
									and hdr.voucher_status  = 'AUT'  )
	/*code added for NSAPL-3135 ends*/
	group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
			dtl.tran_currency,dtl.exchange_rate,
			dtl.voucher_serial_no,dtl.account_code

	update tmp
	set		tmp.cost_center	= a.costcenter_code
	from	acap_doc_dtl_tmp tmp (nolock),
			jv_voucher_trn_dtl a(nolock) 
	where	guid			=	@guid
	and		doc_number		= a.voucher_no
	and		doc_type		= 'BK_JV'
	and		tmp.ou_id			= a.ou_id
	and		a.voucher_serial_no		= tmp.line_no
	and		isnull(a.costcenter_code,'') not in ('','##')		
  /*code added for EBS-1694 ends*/
  
  
	/*code added for Rtrackid:EBS-1882 starts */
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
	 and  C.destinationcomponentname  = case @doctype_tmp  
                                                  when 'PUR_GR' then 'GR'  
                                             end ) 
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,sum(isnull(dtl.pending_cap_amount,0)),dtl.proposal_number,
			hdr.gr_hdr_grdate,supplier_code,sum(isnull(dtl.base_amount,0)),hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,sum(isnull(dtl.cap_amt,0)),
			dtl.line_no,'CI',dtl.account_code,Project_code,cost_center,null,null --EBS-2016
	from	gr_capitalization_dtl_vw dtl(nolock),
			gr_hdr_grmain hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.gr_hdr_ouinstid					= SQLTMP.tmpCol)
	where	hdr.gr_hdr_ouinstid		= dtl. tran_ou
	and		hdr.gr_hdr_grno			= dtl.tran_no
	and		dtl.fb_id		like @fb
	and		hdr.gr_hdr_grno  between isnull(@documentnumberfrom, hdr.gr_hdr_grno) and isnull(@documentnumberto, hdr.gr_hdr_grno)  
	and		hdr.gr_hdr_grdate	 between isnull(@documentdatefrom,hdr.gr_hdr_grdate)  and isnull(@documentdateto,hdr.gr_hdr_grdate) 
    and		isnull(dtl.proposal_number,'')  = isnull(@proposalnumber,isnull(dtl.proposal_number,''))  
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN') or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus = 'FA' and match_type in('2P','2W','3G','3P') and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	and		hdr.gr_hdr_grstatus in('FA','FM','PM')
	and 	exists ( select 'X' from ard_asset_account_mst(nolock)
					 where	company_code 	= @companycode_tmp
					 and	account_code	= dtl.account_code
					 and	asset_usage		= 'CWIP')
	group by hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,dtl.proposal_number,hdr.gr_hdr_grdate,
			 supplier_code,hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,
			dtl.line_no,dtl.account_code,Project_code,cost_center
	
	
	/*code added for Rtrackid:EBS-1882 ends */

   --Added for DTS ID:9H123-1_ACAP_00003 starts here  
   if @doctype_tmp = 'PM_MI'  
   begin  
    ;  
    with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid  
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'  
     and  C.destinationcomponentname  = 'SIN'  
    )  
    insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
	 line_no,  
     cap_flag,  
     account_code,  
     Project_code --Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
    select  @guid,  
     A.tran_ou, 
         A.fb_id,  
         A.tran_no,  
         A.tran_type,  
            case tcdtype   
       when 'D' then -isnull(B.pending_cap_amount, 0)  
       else isnull(B.pending_cap_amount, 0)  
      end,  
         B.proposal_no,  
         A.tran_date,  
         A.supplier_code,  
            case tcdtype   
       when 'D' then -(isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0))  
       else isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0)  
      end,  
         A.tran_currency,  
         A.exchange_rate,  
            case tcdtype   
       when 'D' then -isnull(B.capitalized_amount, 0)  
       else isnull(B.capitalized_amount, 0)  
      end,  
   B.line_no,  
         B.cap_doc_flag,  
         B.account_code,  
         A.Project_code --Code added by thyagaraj for 14H109_ACAP_00003  
   ,null,				--EPE-2039
		 unit_price,--rate_per,			--EPE-2039
		 item_qty			--EPE-2039
    from    si_line_detail_vw B(nolock),  
               si_doc_hdr_vw A(nolock) join   
         SQLTMP  
    on   (A.tran_ou = SQLTMP.tmpCol),  
      sin_delivery_Charge_dtl dtl(nolock),  
      tcd_tcdvariantdetail_vw tcd(nolock)  
    where A.tran_ou  = B.tran_ou  
    and  A.tran_type = B.tran_type  
    and  A.tran_no  = B.tran_no  
    and  A.tran_type = dtl.tran_type  
    and  A.tran_ou = dtl.tran_ou  
    and  A.tran_no = dtl.tran_no  
    and  b.line_no = dtl.tran_line_no  
    and  DTL.tcd_code = tcd.tcdcode  
    and  DTL.tcd_variant = tcd.tcdvariant   
    and  DTL.tcdversionno= tcd.tcdversionno  
    and     tcd.lo_id   = @loid_tmp  
    and     tcd.tcdaccrule  = 'IN'  
    and  A.fb_id  like @fb  
    and  (  
             (  
              convert(nchar(10), A.tran_date, 101)   
              between isnull(@documentdatefrom, A.tran_date)   
           and isnull(@documentdateto, A.tran_date)  
             )  
            )  
    and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
    and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
    and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
    and  (  
             (  
              A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
              and isnull(@documentnumberto, A.tran_no)  
             )  
            )   
    and  A.tran_type  ='PM_MI'  
    and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
    and  B.cap_doc_flag  = 'CI'  
    and  B.row_type   in ('ITEM', 'ACC')  
    and  (B.capitalized_amount >= 0 or B.pending_cap_amount > 0)  
    
    /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			= @guid
	and		b.line_no		=	a.line_no
	--EP-93	

	/*code added for EPE-2039 ends*/
   end  
   --Added for DTS ID:9H123-1_ACAP_00003 ends here  
           
   /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Starts here*/  
   if  @doctype_tmp = 'INV_IMIS'  
   begin  
    /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/  
    ;  
    with SQLTMP(tmpCol) as (  
     select  distinct A.destinationouinstid  
     from    acap_cim_intxn_model_vw A(nolock)  
     where A.sourceouinstid  = @ctxt_ouinstance  
     and  A.sourcecomponentname  = 'ACAP'  
     and  A.destinationcomponentname  = 'STKISSUE'  
    )  
    /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/  
               
    insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
doc_number,  
     doc_type,  
     pending_cap_amount,  
     tran_date,  
     supplier_code,  
     doc_amount,  
    tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     proposal_number,  
     Project_code	--Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
    select  @guid,  
               iih_ouinstid,  
               iih_posting_fb,  
               iih_issue_no,  
               'INV_IMIS',  
               sum(iid_pencapitalisation_amt),  
               iih_issue_date,  
       null,  
               sum(iid_issue_value),  
               null,  
               null,  
               sum(iid_pencapitalisation_amt),  
               iid_line_no,  
      'CI',  
 iid_dr_account_code,  
               mr_proposal_number,  
               iih_ProjectCode  --Code added by thyagaraj for 14H109_ACAP_00003
               ,iid_cost_center,	--EPE-2039
				iid_issue_value,	--EPE-2039 --check
				iid_issue_qty		--EPE-2039
    from    issue_inv_detail d(nolock),  
                     MR_header(nolock),  
                     issue_inv_header h(nolock) join   
               SQLTMP  
    on   (h.iih_ouinstid = SQLTMP.tmpCol) --Code Added by Angelin.R for the Bug : 8H123-2_ACAP_00048  
    where iid_issue_no  = iih_issue_no  
    and  iid_ouinstid  = iih_ouinstid  
    and  h.iih_posting_fb like @fb  
    and  (  
                   (  
                    h.iih_issue_date between isnull(@documentdatefrom, h.iih_issue_date) and isnull(@documentdateto, h.iih_issue_date)  
            )  
                  )  
    and  (  
                   (  
 h.iih_issue_no between isnull(@documentnumberfrom, h.iih_issue_no) and isnull(@documentnumberto, h.iih_issue_no)  
                   )  
                  )  
    and  h.iih_status  = 'AU'  
    and  iih_mr_type  = 'C'  
    and  isnull(mr_proposal_number, '')  = isnull(@proposalnumber, isnull(mr_proposal_number, '')) --Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00052  
    and  mrh_ou  = iih_ouinstid  
    and  mrh_transaction_no  = iih_ref_doc_no  
    /*code commented for ES_ACAP_00635 starts*/ 
   /*
	/*Code added for ITS ID : ES_ACAP_00622 starts*/
    and     d.iid_ref_doc_no not in ( select srid_ref_doc_no 
                                      from str_inventory_det (nolock)
                                      where  d.iid_ref_doc_no      = srid_ref_doc_no
                        and    d.iid_ref_doc_line_no = srid_ref_doc_lineno)
		/*Code added for ITS ID : ES_ACAP_00622 ends*/
   */
   /*code commented for ES_ACAP_00635 ends*/ 
    and  isnull(iih_ProjectCode, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
    group by  
        iih_ouinstid, iih_posting_fb, iih_issue_no, iih_issue_date, iid_dr_account_code, iid_line_no, mr_proposal_number,
        iih_ProjectCode --Code added by thyagaraj for 14H109_ACAP_00003
        ,iid_cost_center,iid_issue_value,iid_issue_qty	----EPE-2039
               
    delete   
    from acap_doc_dtl_tmp  
    where   guid = @guid  
    and     pending_cap_amount = 0  
   end /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/  
  end  
 end   
 else   
 if  @ctxt_service in ('ACAPWADDESRSRCH', 'ACAPWMODDSRSRCH')  
 begin  
  if  @doctype_tmp is null  
  or  @doctype_tmp = ''  
  or  @doctype = @doctype_tmp1  
  begin  
   ;  
   /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
   with SQLTMP(tmpCol) as (  
    select  distinct C.destinationouinstid  
                     /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
    from    si_doc_hdr_vw A(nolock),  
                     acap_cim_intxn_model_vw C(nolock)  
    where C.sourceouinstid  = @ctxt_ouinstance  
    and  C.sourcecomponentname  = 'ACAP'  
    and  C.destinationcomponentname  = A.component_id  
   )  
           
   insert into acap_doc_dtl_tmp  
     (  
    guid,  
    ou_id,  
    fb_id,  
    doc_number,  
    doc_type,  
    pending_cap_amount,  
    proposal_number,  
    tran_date,  
  supplier_code,  
    doc_amount,  
    tran_currency,  
    exchange_rate,  
    cap_amount,  
    line_no,  
    cap_flag,  
    account_code,  
    Project_code --Code added by thyagaraj for 14H109_ACAP_00003  
    ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
     )  
   select  @guid,  
           A.tran_ou,  
           A.fb_id,  
           A.tran_no, 
           A.tran_type,  
           isnull(B.pending_cap_amount, 0),  
           B.proposal_no,  
   A.tran_date,  
           A.supplier_code,  
isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0),  
           A.tran_currency,  
           A.exchange_rate,  
    isnull(B.capitalized_amount, 0),  
        B.line_no,  
           B.cap_doc_flag,  
           B.account_code,  
           A.Project_code ------------Code added by thyagaraj for 14H109_ACAP_00003  
           ,null,				--EPE-2039
			unit_price,--rate_per,			--EPE-2039
			item_qty			--EPE-2039
   from    si_line_detail_vw b(nolock),  
                 si_doc_hdr_vw a(nolock) join   
           SQLTMP  
   on   (A.tran_ou = SQLTMP.tmpCol)  
   where A.tran_ou  = B.tran_ou  
   and  A.tran_type  = B.tran_type  
   and  A.tran_no  = B.tran_no  
   and  A.fb_id like @fb  
   and  (  
               (  
                convert(nchar(10), A.tran_date, 101)   
     between isnull(@documentdatefrom, A.tran_date)   
                and isnull(@documentdateto, A.tran_date)  
           )  
              )  
   and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
   and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
   and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
   and  (  
               (  
                A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                and isnull(@documentnumberto, A.tran_no)  
               )  
              )   
              /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
              --and   A.component_id in ('SDIN','SIN','SNP','SPY','SCDN')  
   and  A.tran_type    in ('PM_PI','PM_EV','PM_IV','PM_PV','PM_SPV','PM_SCA','PM_SCI')--,'PM_MI') --Modified for DTS ID:9H123-1_ACAP_00001  
              /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
   and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
   and  B.cap_doc_flag  = 'CI'  
   and  B.row_type    in ('ITEM', 'ACC', 'VOUCHER')  
   and  isnull(B.pending_cap_amount, 0) <> 0  
   /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/  
   
    /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	--EP-93	

	/*code added for EPE-2039 ends*/
  
   --Added for DTS ID:9H123-1_ACAP_00003 starts here  
   ;  
   with SQLTMP(tmpCol) as (  
    select  distinct C.destinationouinstid  
    from    si_doc_hdr_vw a(nolock),  
                     acap_cim_intxn_model_vw c(nolock)  
    where C.sourceouinstid  = @ctxt_ouinstance  
    and  C.sourcecomponentname  = 'ACAP'  
    and  C.destinationcomponentname  = A.component_id  
   )  
   insert into acap_doc_dtl_tmp  
   (  
    guid,  
    ou_id,  
    fb_id,  
    doc_number,  
    doc_type,  
    pending_cap_amount,  
    proposal_number,  
    tran_date,  
    supplier_code,  
    doc_amount,  
    tran_currency,  
    exchange_rate,  
    cap_amount,  
    line_no,  
    cap_flag,  
    account_code,  
    Project_code --------Code added by thyagaraj for 14H109_ACAP_00003  
    ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
     )  
   select  @guid,  
           A.tran_ou,  
           A.fb_id,  
           A.tran_no,  
           A.tran_type,  
           case tcdtype   
      when 'D' then -isnull(B.pending_cap_amount, 0)  
      else isnull(B.pending_cap_amount, 0)  
     end,  
   B.proposal_no,  
           A.tran_date,  
           A.supplier_code,  
           case tcdtype   
      when 'D' then -(isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0))  
      else isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0)  
     end,  
           A.tran_currency,  
           A.exchange_rate,  
           case tcdtype   
      when 'D' then -isnull(B.capitalized_amount, 0)  
      else isnull(B.capitalized_amount, 0)  
     end,  
           B.line_no,  
           B.cap_doc_flag,  
           B.account_code,  
           A.Project_code ------------------Code added by thyagaraj for 14H109_ACAP_00003  
        ,null,				--EPE-2039
		unit_price,--rate_per,			--EPE-2039
		item_qty			--EPE-2039
   from    si_line_detail_vw B(nolock),  
                 si_doc_hdr_vw A(nolock) join   
           SQLTMP  
   on   (A.tran_ou = SQLTMP.tmpCol),  
     sin_delivery_Charge_dtl dtl(nolock),  
     tcd_tcdvariantdetail_vw tcd(nolock)  
   where A.tran_ou  = B.tran_ou  
   and  A.tran_type = B.tran_type  
   and  A.tran_no  = B.tran_no  
   and  A.tran_type = dtl.tran_type  
   and  A.tran_ou = dtl.tran_ou  
   and  A.tran_no = dtl.tran_no  
   and  b.line_no = dtl.tran_line_no  
   and  DTL.tcd_code = tcd.tcdcode  
   and  DTL.tcd_variant = tcd.tcdvariant   
   and  DTL.tcdversionno= tcd.tcdversionno  
   and     tcd.lo_id   = @loid_tmp  
   and     tcd.tcdaccrule  = 'IN'  
   and  A.fb_id  like @fb  
   and  (  
               (  
                convert(nchar(10), A.tran_date, 101)   
                between isnull(@documentdatefrom, A.tran_date)   
and isnull(@documentdateto, A.tran_date)  
               )  
              )  
   and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
   and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
   and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
   and  (  
               (  
                A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                and isnull(@documentnumberto, A.tran_no)  
               )  
              )   
   and  A.tran_type  ='PM_MI'  
   and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
   and  B.cap_doc_flag  = 'CI'  
   and  B.row_type   in ('ITEM', 'ACC')  
   and (B.capitalized_amount >= 0 or B.pending_cap_amount > 0)  
   --Added for DTS ID:9H123-1_ACAP_00003 ends here  
   
   /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	--EP-93	

	/*code added for EPE-2039 ends*/
  
   /*Code Commented & Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/  
   --union  
   ;  
   with SQLTMP(tmpCol) as (  
    select  distinct A.destinationouinstid  
 from    acap_cim_intxn_model_vw A(nolock)  
    where A.sourceouinstid  = @ctxt_ouinstance  
    and  A.sourcecomponentname  = 'ACAP'  
    and  A.destinationcomponentname  = 'STKISSUE'  
   )  
           
   insert into acap_doc_dtl_tmp  
     (  
    guid,  
    ou_id,  
    fb_id,  
    doc_number,  
    doc_type,  
    pending_cap_amount,  
    proposal_number,  
    tran_date,  
    supplier_code,  
    doc_amount,  
    tran_currency,  
    exchange_rate,  
    cap_amount,  
    line_no,  
    cap_flag,  
    account_code,  
    Project_code -----------------Code added by thyagaraj for 14H109_ACAP_00003  
    ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
     )  
   /*Code Commented & Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/  
   select  @guid,  
           iih_ouinstid,  
           iih_posting_fb,  
 iih_issue_no,  
           'INV_IMIS',  
           sum(iid_pencapitalisation_amt),  
           mr_proposal_number,  
           iih_issue_date,  
           null,             sum(iid_issue_value),  
           null,  
           null,  
           sum(iid_pencapitalisation_amt),  
           iid_line_no,  
           'CI',  
           iid_dr_account_code,  
           iih_ProjectCode ------------------Code added by thyagaraj for 14H109_ACAP_00003  
           ,iid_cost_center,	--EPE-2039
			iid_issue_value,	--EPE-2039 --check
			iid_issue_qty		--EPE-2039
   from    issue_inv_detail d(nolock),  
                 MR_header(nolock),  
                 issue_inv_header h(nolock) join   
           SQLTMP  
   on   (h.iih_ouinstid = SQLTMP.tmpCol) --Code Added by Angelin.R for the Bug : 8H123-2_ACAP_00048  
   where iid_issue_no  = iih_issue_no  
   and  iid_ouinstid  = iih_ouinstid  
   and  h.iih_posting_fb like @fb  
   and  (  
               (  
                h.iih_issue_date between isnull(@documentdatefrom, h.iih_issue_date) and isnull(@documentdateto, h.iih_issue_date)  
               )  
              )  
   and  (  
               (  
                h.iih_issue_no between isnull(@documentnumberfrom, h.iih_issue_no) and isnull(@documentnumberto, h.iih_issue_no)  
               )  
              )  
   and  h.iih_status  = 'AU'  
   and  iih_mr_type  = 'C'  
   and  isnull(mr_proposal_number, '')  = isnull(@proposalnumber, isnull(mr_proposal_number, '')) --Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00052  
   and  mrh_ou  = iih_ouinstid  
   and  mrh_transaction_no  = iih_ref_doc_no  
   /*code commented for ES_ACAP_00635 starts*/
   /* 
	/*Code added for ITS ID : ES_ACAP_00622 starts */
			and     d.iid_ref_doc_no not in ( select srid_ref_doc_no 
                                              from str_inventory_det (nolock)
                                              where  d.iid_ref_doc_no      = srid_ref_doc_no
                                              and    d.iid_ref_doc_line_no = srid_ref_doc_lineno)
			/*Code added for ITS ID : ES_ACAP_00622 ends */
   */
   /*code commented for ES_ACAP_00635 ends*/ 
   and  isnull(iih_ProjectCode, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
   group by  
       iih_ouinstid, iih_posting_fb, iih_issue_no, iih_issue_date, iid_dr_account_code, iid_line_no, mr_proposal_number,
       iih_Projectcode ------Code added by thyagaraj for 14H109_ACAP_00003 
       ,iid_cost_center,iid_issue_value,iid_issue_qty	----EPE-2039

	/*code added for EBS-1694 starts*/
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
     and  C.destinationcomponentname  =  'JV' )
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,0)),hdr.proposal_number,hdr.voucher_date,null,
			sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
			dtl.voucher_serial_no,/*null*/'CI',dtl.account_code,null,null,null,null	--NSAPL-3073
	from	jv_voucher_trn_dtl dtl(nolock),
			jv_voucher_trn_hdr hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.ou_id = SQLTMP.tmpCol)
	where	hdr.ou_id		= dtl. ou_id
	and		hdr.voucher_no	= dtl.voucher_no
	and		hdr.fb_id		like @fb
	and		hdr.voucher_no  between isnull(@documentnumberfrom, hdr.voucher_no) and isnull(@documentnumberto, hdr.voucher_no)  
	and		hdr.voucher_date	 >   = isnull(@documentdatefrom,hdr.voucher_date)  
    and		hdr.voucher_date	 <= isnull(@documentdateto,hdr.voucher_date) 
    and		isnull(hdr.proposal_number,'')  = isnull(@proposalnumber,isnull(hdr.proposal_number,''))  
	and		hdr.voucher_status  = 'AUT'
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	and		isnull(dtl.cap_flag,'') <> 'NC'--EBS-2581
	/*code added for NSAPL-3135 starts*/
	and		hdr.voucher_type  not in ('REV','TAX')
	and		isnull(hdr.ref_voucher_type,'') <> 'REV'
	and		hdr.voucher_no not in (	select hdr1.ref_voucher_no 
									from jv_voucher_trn_hdr hdr1(nolock)
									where hdr1.voucher_status ='REV'
									and hdr1.ref_voucher_no = hdr.voucher_no
									and	hdr1.ref_voucher_type = hdr.voucher_type
									and	hdr.ou_id			= hdr1.ou_id
									and hdr.fb_id			= hdr1.fb_id
									and hdr.voucher_status  = 'AUT'  )
	/*code added for NSAPL-3135 ends*/
	group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
			dtl.tran_currency,dtl.exchange_rate,
			dtl.voucher_serial_no,dtl.account_code

	update tmp
	set		tmp.cost_center	= a.costcenter_code
	from	acap_doc_dtl_tmp tmp (nolock),
			jv_voucher_trn_dtl a(nolock) 
	where	guid			=	@guid
	and		doc_number		= a.voucher_no
	and		doc_type		= 'BK_JV'
	and		tmp.ou_id			= a.ou_id
	and		a.voucher_serial_no		= tmp.line_no
	and		isnull(a.costcenter_code,'') not in ('','##')		
	/*code added for EBS-1694 ends*/
      
	/*code added for Rtrackid:EBS-1882 starts */
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
	 and  C.destinationcomponentname  = 'GR' ) 
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,sum(isnull(dtl.pending_cap_amount,0)),dtl.proposal_number,
			hdr.gr_hdr_grdate,supplier_code,sum(isnull(dtl.base_amount,0)),hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,sum(isnull(dtl.cap_amt,0)),
			dtl.line_no,'CI',dtl.account_code,Project_code,cost_center,null,null --EBS-2016
	from	gr_capitalization_dtl_vw dtl(nolock),
			gr_hdr_grmain hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.gr_hdr_ouinstid					= SQLTMP.tmpCol)
	where	hdr.gr_hdr_ouinstid		= dtl. tran_ou
	and		hdr.gr_hdr_grno			= dtl.tran_no
	and		dtl.fb_id		like @fb
	and		hdr.gr_hdr_grno  between isnull(@documentnumberfrom, hdr.gr_hdr_grno) and isnull(@documentnumberto, hdr.gr_hdr_grno)  
	and		hdr.gr_hdr_grdate	 between isnull(@documentdatefrom,hdr.gr_hdr_grdate)  and isnull(@documentdateto,hdr.gr_hdr_grdate) 
    and		isnull(dtl.proposal_number,'')  = isnull(@proposalnumber,isnull(dtl.proposal_number,''))  
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN') or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus = 'FA' and match_type in('2P','2W','3G','3P') and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	and		hdr.gr_hdr_grstatus in('FA','FM','PM')
	and 	exists ( select 'X' from ard_asset_account_mst(nolock)
					 where	company_code 	= @companycode_tmp
					 and	account_code	= dtl.account_code
					 and	asset_usage		= 'CWIP')
	group by hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,dtl.proposal_number,hdr.gr_hdr_grdate,
			 supplier_code,hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,
			dtl.line_no,dtl.account_code,Project_code,cost_center

	/*code added for Rtrackid:EBS-1882 ends */

	
	     
   delete   
   from acap_doc_dtl_tmp  
   where   guid = @guid  
   and     pending_cap_amount = 0  
                 /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/  
  end  
  else  
  begin  
   ;  
   /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
   with SQLTMP(tmpCol) as ( 
    select  distinct C.destinationouinstid  
                     /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
    from    acap_cim_intxn_model_vw c(nolock)  
    where C.sourceouinstid  = @ctxt_ouinstance  
    and  C.sourcecomponentname  = 'ACAP'  
                  /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
    and  C.destinationcomponentname  = case @doctype_tmp  
                                                  when 'PM_PI' then 'SIN'  
                    --when 'PM_MI' then 'SIN'--Modified for DTS ID:9H123-1_ACAP_00001 
                                                  when 'PM_EV' then 'SDIN'  
                                                  when 'PM_IV' then 'SDIN'  
                                                  when 'PM_SPV' then 'SNP'  
               when 'PM_PV' then 'SPY'  
                                                  when 'PM_SCA' then 'SCDN'  
                                                  when 'PM_SCI' then 'SCDN'  
        end  
   )  
   /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
   insert into acap_doc_dtl_tmp  
     (  
    guid,  
    ou_id,  
    fb_id,  
    doc_number,  
    doc_type,  
    pending_cap_amount,  
    proposal_number,  
    tran_date,  
    supplier_code,  
    doc_amount,  
    tran_currency,  
    exchange_rate,  
    cap_amount,  
    line_no,  
    cap_flag,  
    account_code,  
    Project_code ------------Code added by thyagaraj for 14H109_ACAP_00003  
    ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
     )  
   select  @guid,  
           A.tran_ou,  
           A.fb_id,  
           A.tran_no,  
           A.tran_type,  
           isnull(B.pending_cap_amount, 0),  
           B.proposal_no,  
           A.tran_date,  
           A.supplier_code,  
           isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0),  
           A.tran_currency,  
           A.exchange_rate,  
           isnull(B.capitalized_amount, 0),  
           B.line_no,  
 B.cap_doc_flag,  
   B.account_code,  
       A.Project_code --------------Code added by thyagaraj for 14H109_ACAP_00003  
      ,null,			--EPE-2039
       unit_price,--rate_per,		--EPE-2039
       item_qty			--EPE-2039
   from    si_line_detail_vw b(nolock),  
                 si_doc_hdr_vw a(nolock) join   
           SQLTMP  
   on   (A.tran_ou = SQLTMP.tmpCol)  
   where A.tran_ou  = B.tran_ou  
   and  A.tran_type  = B.tran_type  
   and  A.tran_no  = B.tran_no  
   and  A.fb_id like @fb  
   and  (  
               (  
                convert(nchar(10), A.tran_date, 101)   
                between isnull(@documentdatefrom, A.tran_date)   
                and isnull(@documentdateto, A.tran_date)  
               )  
              )  
   and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
   and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
   and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
   and  (  
               (  
                A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                and isnull(@documentnumberto, A.tran_no)  
               )  
              )   
              /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
              --and   A.component_id = @doctype_tmp  
   and  A.tran_type  = @doctype_tmp  
              /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
   and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
   and  B.cap_doc_flag  = 'CI'  
   and  B.row_type   in ('ITEM', 'ACC', 'VOUCHER')  
   and  B.pending_cap_amount <> 0 
   
    /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=   @guid
	and		b.line_no		=	a.line_no
	--EP-93	
	/*code added for EPE-2039 ends*/

	/*code added for EBS-1694 starts*/
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
     and  C.destinationcomponentname  =  'JV' )
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,0)),hdr.proposal_number,hdr.voucher_date,null,
			sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
			dtl.voucher_serial_no,/*null*/'CI',dtl.account_code,null,null,null,null	--NSAPL-3073
	from	jv_voucher_trn_dtl dtl(nolock),
			jv_voucher_trn_hdr hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.ou_id = SQLTMP.tmpCol)
	where	hdr.ou_id		= dtl. ou_id
	and		hdr.voucher_no	= dtl.voucher_no
	and		hdr.fb_id		like @fb
	and		hdr.voucher_no  between isnull(@documentnumberfrom, hdr.voucher_no) and isnull(@documentnumberto, hdr.voucher_no)  
	and		hdr.voucher_date	 >   = isnull(@documentdatefrom,hdr.voucher_date)  
    and		hdr.voucher_date	 <= isnull(@documentdateto,hdr.voucher_date) 
    and		isnull(hdr.proposal_number,'')  = isnull(@proposalnumber,isnull(hdr.proposal_number,''))  
	and		hdr.voucher_status  = 'AUT'
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	and		isnull(dtl.cap_flag,'') <> 'NC'--EBS-2581
	/*code added for NSAPL-3135 starts*/
	and		hdr.voucher_type  not in ('REV','TAX')
	and		isnull(hdr.ref_voucher_type,'') <> 'REV'
	and		hdr.voucher_no not in (	select hdr1.ref_voucher_no 
									from jv_voucher_trn_hdr hdr1(nolock)
									where hdr1.voucher_status ='REV'
									and hdr1.ref_voucher_no = hdr.voucher_no
									and	hdr1.ref_voucher_type = hdr.voucher_type
									and	hdr.ou_id			= hdr1.ou_id
									and hdr.fb_id			= hdr1.fb_id
									and hdr.voucher_status  = 'AUT'  )
	/*code added for NSAPL-3135 ends*/
	group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
			dtl.tran_currency,dtl.exchange_rate,
			dtl.voucher_serial_no,dtl.account_code

	update tmp
	set		tmp.cost_center	= a.costcenter_code
	from	acap_doc_dtl_tmp tmp (nolock),
			jv_voucher_trn_dtl a(nolock) 
	where	guid			=	@guid
	and		doc_number		= a.voucher_no
	and		doc_type		= 'BK_JV'
	and		tmp.ou_id			= a.ou_id
	and		a.voucher_serial_no		= tmp.line_no
	and		isnull(a.costcenter_code,'') not in ('','##')		
	/*code added for EBS-1694 ends*/

	
	/*code added for Rtrackid:EBS-1882 starts */
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
	 and  C.destinationcomponentname  = case @doctype_tmp  
                                                  when 'PUR_GR' then 'GR'  
                                             end ) 
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,sum(isnull(dtl.pending_cap_amount,0)),dtl.proposal_number,
			hdr.gr_hdr_grdate,supplier_code,sum(isnull(dtl.base_amount,0)),hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,sum(isnull(dtl.cap_amt,0)),
			dtl.line_no,'CI',dtl.account_code,Project_code,cost_center,null,null --EBS-2016
	from	gr_capitalization_dtl_vw dtl(nolock),
			gr_hdr_grmain hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.gr_hdr_ouinstid					= SQLTMP.tmpCol)
	where	hdr.gr_hdr_ouinstid		= dtl. tran_ou
	and		hdr.gr_hdr_grno			= dtl.tran_no
	and		dtl.fb_id		like @fb
	and		hdr.gr_hdr_grno  between isnull(@documentnumberfrom, hdr.gr_hdr_grno) and isnull(@documentnumberto, hdr.gr_hdr_grno)  
	and		hdr.gr_hdr_grdate	 between isnull(@documentdatefrom,hdr.gr_hdr_grdate)  and isnull(@documentdateto,hdr.gr_hdr_grdate)  
    and		isnull(dtl.proposal_number,'')  = isnull(@proposalnumber,isnull(dtl.proposal_number,''))  
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN') or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus = 'FA' and match_type in('2P','2W','3G','3P') and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	and		hdr.gr_hdr_grstatus in('FA','FM','PM')
	and 	exists ( select 'X' from ard_asset_account_mst(nolock)
					 where	company_code 	= @companycode_tmp
					 and	account_code	= dtl.account_code
					 and	asset_usage		= 'CWIP')
	group by hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,dtl.proposal_number,hdr.gr_hdr_grdate,
			 supplier_code,hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,
			dtl.line_no,dtl.account_code,Project_code,cost_center

	/*code added for Rtrackid:EBS-1882 ends */

   --Added for DTS ID:9H123-1_ACAP_00003 starts here  
   if @doctype_tmp = 'PM_MI'  
   begin  
    ;  
    with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid  
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'  
     and  C.destinationcomponentname  = 'SIN'  
    )  
    insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code ----------Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
    select  @guid,  
         A.tran_ou,  
         A.fb_id,  
         A.tran_no,  
         A.tran_type,  
            case tcdtype   
       when 'D' then -isnull(B.pending_cap_amount, 0)  
       else isnull(B.pending_cap_amount, 0)  
      end,  
         B.proposal_no,  
         A.tran_date,  
         A.supplier_code,  
            case tcdtype   
       when 'D' then -(isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0))  
       else isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0)  
      end,  
         A.tran_currency,  
         A.exchange_rate,  
            case tcdtype   
       when 'D' then -isnull(B.capitalized_amount, 0)  
       else isnull(B.capitalized_amount, 0)  
      end,  
         B.line_no,  
         B.cap_doc_flag,  
         B.account_code,  
         A.Project_code ------------Code added by thyagaraj for 14H109_ACAP_00003  
        ,null,			--EPE-2039
       unit_price,--rate_per,		--EPE-2039
       item_qty			--EPE-2039
    from    si_line_detail_vw B(nolock),  
               si_doc_hdr_vw A(nolock) join   
  SQLTMP  
    on   (A.tran_ou = SQLTMP.tmpCol),  
      sin_delivery_Charge_dtl dtl(nolock),  
    tcd_tcdvariantdetail_vw tcd(nolock)  
 where A.tran_ou  = B.tran_ou 
    and  A.tran_type = B.tran_type  
    and  A.tran_no  = B.tran_no  
 and  A.tran_type = dtl.tran_type  
    and  A.tran_ou = dtl.tran_ou  
    and  A.tran_no = dtl.tran_no  
    and  b.line_no = dtl.tran_line_no  
    and  DTL.tcd_code = tcd.tcdcode 
    and  DTL.tcd_variant = tcd.tcdvariant   
    and  DTL.tcdversionno= tcd.tcdversionno  
   and     tcd.lo_id  = @loid_tmp  
    and     tcd.tcdaccrule  = 'IN'  
    and  A.fb_id  like @fb  
    and  (  
             (  
              convert(nchar(10), A.tran_date, 101)   
              between isnull(@documentdatefrom, A.tran_date)   
              and isnull(@documentdateto, A.tran_date)  
             )  
            )  
    and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
    and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
    and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
    and  (  
             (  
              A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
              and isnull(@documentnumberto, A.tran_no)  
             )  
            )   
    and  A.tran_type  ='PM_MI'  
    and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
    and  B.cap_doc_flag  = 'CI'  
    and  B.row_type   in ('ITEM', 'ACC')  
    and  (B.capitalized_amount >= 0 or B.pending_cap_amount > 0)  
    
     /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	and		tmp.account_code= a.account_code--PTP-2238
	--EP-93	

	/*code added for EPE-2039 ends*/
   end  
   --Added for DTS ID:9H123-1_ACAP_00003 ends here  
           
   /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Starts here*/  
   if  @doctype_tmp = 'INV_IMIS'  
   begin  
    /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/  
    ;  
    with SQLTMP(tmpCol) as (  
     select  distinct A.destinationouinstid  
     from    acap_cim_intxn_model_vw A(nolock)  
     where A.sourceouinstid  = @ctxt_ouinstance  
     and  A.sourcecomponentname  = 'ACAP'  
     and  A.destinationcomponentname  = 'STKISSUE'  
    )  
    /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/  
               
    insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     proposal_number,  
     Project_code --Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
    select  @guid,  
               iih_ouinstid,  
               iih_posting_fb,  
               iih_issue_no,  
               'INV_IMIS',  
               sum(iid_pencapitalisation_amt),  
               iih_issue_date,  
               null,  
               sum(iid_issue_value),  
               null,  
               null,  
               sum(iid_pencapitalisation_amt),  
               iid_line_no,  
               'CI',  
               iid_dr_account_code,  
               mr_proposal_number,  
               iih_ProjectCode --Code added by thyagaraj for 14H109_ACAP_00003  
               ,iid_cost_center,	--EPE-2039
				iid_issue_value,	--EPE-2039 --check
				iid_issue_qty		--EPE-2039
    from    issue_inv_detail d(nolock),  
MR_header(nolock),  
                     issue_inv_header h(nolock) join   
       SQLTMP  
    on   (h.iih_ouinstid = SQLTMP.tmpCol)--Code Added by Angelin.R for the Bug : 8H123-2_ACAP_00048  
    where iid_issue_no  = iih_issue_no  
    and  iid_ouinstid  = iih_ouinstid  
  and  h.iih_posting_fb like @fb  
    and  (  
                   (  
                    h.iih_issue_date between isnull(@documentdatefrom, h.iih_issue_date) and isnull(@documentdateto, h.iih_issue_date)  
          )  
                  )  
    and  (  
                   (  
                    h.iih_issue_no between isnull(@documentnumberfrom, h.iih_issue_no) and isnull(@documentnumberto, h.iih_issue_no)  
                   )  
                  )  
    and  h.iih_status  = 'AU'  
    and  iih_mr_type  = 'C'  
    and  isnull(mr_proposal_number, '')  = isnull(@proposalnumber, isnull(mr_proposal_number, '')) --Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00052  
    and  mrh_ou  = iih_ouinstid  
    and  mrh_transaction_no  = iih_ref_doc_no  
    /*code commented for ES_ACAP_00635 starts*/ 
    /*
/*Code added for ITS ID : ES_ACAP_00622 starts*/
			    and     d.iid_ref_doc_no not in ( select srid_ref_doc_no 
												from str_inventory_det (nolock)
												where  d.iid_ref_doc_no      = srid_ref_doc_no
												and    d.iid_ref_doc_line_no = srid_ref_doc_lineno)
			/*Code added for ITS ID : ES_ACAP_00622 ends*/
	*/
	/*code commented for ES_ACAP_00635 ends*/ 
    and  isnull(iih_ProjectCode, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
    group by  
        iih_ouinstid, iih_posting_fb, iih_issue_no, iih_issue_date, iid_dr_account_code, iid_line_no, mr_proposal_number ,
        iih_ProjectCode --------Code added by thyagaraj for 14H109_ACAP_00003  
         ,iid_cost_center,iid_issue_value,iid_issue_qty	--EPE-2039
		        
    delete   
    from acap_doc_dtl_tmp  
    where   guid = @guid  
    and     pending_cap_amount = 0  
   end /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/  
end  
 end   
 else  
 begin  
  -- Select document screen from create complex asset , edit complex asset  
  -- Get capital documents if document type is null, blank or all  
  if  @doctype_tmp is null  
  or  @doctype_tmp = ''  
  or  @doctype = @doctype_tmp1  
  begin  
   /* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 Starts*/  
   if @supp_code is null  
   Begin  
   /* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 Ends*/  
   --TVSLS-2930	
   /*
    ;  
    /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
    with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid  
                      /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
     from    si_doc_hdr_vw a(nolock),  
                      acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'  
     and  C.destinationcomponentname  = A.component_id  
    )  
    */       
	--TVSLS-2930	

    insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
  doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code ---------Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
  select  @guid,  
            A.tran_ou,  
            A.fb_id,  
            A.tran_no,  
            A.tran_type,  
            isnull(B.pending_cap_amount, 0),  
            B.proposal_no,  
            A.tran_date,  
            A.supplier_code,  
            isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0),  
            A.tran_currency,  
    A.exchange_rate,  
            isnull(B.capitalized_amount, 0),  
            B.line_no,  
            B.cap_doc_flag,  
            B.account_code,  
            A.Project_code ------------Code added by thyagaraj for 14H109_ACAP_00003  
             ,null,			--EPE-2039
           unit_price,--rate_per,		--EPE-2039
           item_qty			--EPE-2039
    from    si_line_detail_vw b(nolock),  
	--code commented and added for TVSLS-2930 starts
	/*
                  si_doc_hdr_vw a(nolock) join   
            SQLTMP  
    on   (A.tran_ou = SQLTMP.tmpCol)  
    where A.tran_ou  = B.tran_ou  
	*/
		  si_doc_hdr_vw A(nolock)
    WHERE A.tran_ou  = B.tran_ou  
	AND EXISTS (
				select  '*' 
				from    acap_cim_intxn_model_vw c(nolock)  
				where C.sourceouinstid  = @ctxt_ouinstance  
				and  C.sourcecomponentname  = 'ACAP'  
				and  C.destinationcomponentname  = A.component_id 
				and  C.destinationouinstid =  A.tran_ou
			   )
	--code commented and added for TVSLS-2930 ends
    and  A.tran_type  = B.tran_type  
    and  A.tran_no  = B.tran_no  
    and  A.fb_id like @fb  
    and  (  
                (  
                 convert(nchar(10), A.tran_date, 101)   
                 between isnull(@documentdatefrom, A.tran_date)   
                 and isnull(@documentdateto, A.tran_date)  
                )  
               )  
    and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
    and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
    and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
    and  (  
                (  
                 A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                 and isnull(@documentnumberto, A.tran_no)  
                )  
               )   
               /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
               --and   A.component_id in ('SDIN','SIN','SNP','SPY','SCDN')  
    and  A.tran_type   in ('PM_PI','PM_EV','PM_IV','PM_PV','PM_SPV','PM_SCA','PM_SCI','PUR_GR')--,'PM_MI')--Modified for DTS ID:9H123-1_ACAP_00001  --EBS-1882
               /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
    and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
    and  B.cap_doc_flag  = 'CI'  
    and  B.row_type   in ('ITEM', 'ACC', 'VOUCHER')  
    and  isnull(B.pending_cap_amount, 0) <> 0   
    --Added for DTS ID:9H123-1_ACAP_00003 ends here 
    /*code added for RFBE-76 starts*/
	union
  select  @guid,  
            A.tran_ou,  
            A.fb_id,  
            A.tran_no,  
            A.tran_type,  
            isnull(B.pending_cap_amount, 0),  
            B.proposal_no,  
            A.tran_date,  
            A.supplier_code,  
            isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0),  
            A.tran_currency,  
        A.exchange_rate,  
            isnull(B.capitalized_amount, 0),  
            B.line_no,  
            B.cap_doc_flag,  
            B.account_code,  
            A.Project_code 
             ,null,			
           unit_price,
           item_qty			
    from    si_line_detail_vw b(nolock),  si_doc_hdr_vw A(nolock)
    WHERE A.tran_ou  = B.tran_ou  
	AND EXISTS (
				select  '*' 
				from    acap_cim_intxn_model_vw c(nolock)  
				where C.sourceouinstid  = @ctxt_ouinstance  
				and  C.sourcecomponentname  = 'ACAP'  
				and  C.destinationcomponentname  = A.component_id 
				and  C.destinationouinstid =  A.tran_ou
			   )
    and  A.tran_type  = B.tran_type  
    and  A.tran_no  = B.tran_no  
    and  A.fb_id like @fb  
    and  (  
                (  
                 convert(nchar(10), A.tran_date, 101)   
                 between isnull(@documentdatefrom, A.tran_date)   
                 and isnull(@documentdateto, A.tran_date)  
                )  
               )  
    and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
    and  isnull(A.Project_code, '') like @Project_code  
    and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
    and  (  
                (  
                 A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
  and isnull(@documentnumberto, A.tran_no)  
                )  
               )   
    and  A.tran_type   in ('PM_PI','PM_EV','PM_IV')
    and  (A.doc_status in ('AUT','PPAD') or A.paid_status in ('PAD'))  
    and  B.cap_doc_flag  = 'CI'  
    and  B.row_type   in ('ITEM', 'ACC', 'VOUCHER')  
    and  isnull(B.pending_cap_amount, 0) <> 0   
	/*code added for RFBE-76 ends*/
    union  
 select  @guid,  
            A.tran_ou,  
           A.fb_id,  
            A.tran_no,  
            A.tran_type,  
      case tcdtype   
       when 'D' then -isnull(B.pending_cap_amount, 0)  
       else isnull(B.pending_cap_amount, 0)  
      end,  
            B.proposal_no,  
            A.tran_date,  
            A.supplier_code,  
            case tcdtype   
       when 'D' then -(isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0))  
       else isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0)  
      end,  
            A.tran_currency,  
            A.exchange_rate,  
            case tcdtype   
       when 'D' then -isnull(B.capitalized_amount, 0)  
       else isnull(B.capitalized_amount, 0)  
      end,  
            B.line_no,  
            B.cap_doc_flag,  
            B.account_code,  
            A.Project_code ----------------Code added by thyagaraj for 14H109_ACAP_00003  
             ,null,			--EPE-2039
           unit_price,--rate_per,		--EPE-2039
           item_qty			--EPE-2039
    from    si_line_detail_vw B(nolock),  
	--code commented and added for TVSLS-2930 starts	
	/*
                  si_doc_hdr_vw A(nolock) join   
            SQLTMP  
    on   (A.tran_ou = SQLTMP.tmpCol),  
      sin_delivery_Charge_dtl dtl(nolock),  
      tcd_tcdvariantdetail_vw tcd(nolock)  
    where A.tran_ou  = B.tran_ou  
	*/
	  si_doc_hdr_vw A(nolock), 
      sin_delivery_Charge_dtl dtl(nolock),  
      tcd_tcdvariantdetail_vw tcd(nolock)  
    where A.tran_ou  = B.tran_ou
	AND EXISTS (
				 select  '*' 
				 from  acap_cim_intxn_model_vw c(nolock)  
				 where   C.sourceouinstid			 = @ctxt_ouinstance  
				 and	 C.sourcecomponentname		 = 'ACAP'  
				 and	 C.destinationcomponentname  = A.component_id 
				 and	 C.destinationouinstid		 = A.tran_ou
				)
	--code commented and added for TVSLS-2930 ends
    and  A.tran_type = B.tran_type  
    and  A.tran_no  = B.tran_no  
    and  A.tran_type = dtl.tran_type  
    and  A.tran_ou = dtl.tran_ou  
    and  A.tran_no = dtl.tran_no  
    and  b.line_no = dtl.tran_line_no  
    and  DTL.tcd_code = tcd.tcdcode  
    and  DTL.tcd_variant = tcd.tcdvariant   
    and  DTL.tcdversionno= tcd.tcdversionno  
    and     tcd.lo_id   = @loid_tmp  
    and     tcd.tcdaccrule  = 'IN'  
    and  A.fb_id  like @fb  
    and  (  
                (  
                 convert(nchar(10), A.tran_date, 101)   
                 between isnull(@documentdatefrom, A.tran_date)   
                 and isnull(@documentdateto, A.tran_date)  
                )  
               )  
    and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
    and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
    and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
    and  (  
                (  
                 A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                 and isnull(@documentnumberto, A.tran_no)  
                )  
               )   
    and  A.tran_type  ='PM_MI'  
    and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
    and  B.cap_doc_flag  = 'CI'  
    and  B.row_type   in ('ITEM', 'ACC')  
    and  (B.capitalized_amount >= 0 or B.pending_cap_amount > 0)  
    --Added for DTS ID:9H123-1_ACAP_00003 ends here  
            
    union  
    select  @guid,  
            A.ou_id,  
            B.fb_id,  
            A.cap_wo_number,  
            'CO',  
            /*isnull(A.wip_cost, 0)*/isnull(A.wip_cost, 0)-isnull(A.trfr_amount,0), /*Code Commented and added for EPE-79756*/
            A.proposal_number,  
            B.transaction_date,  
            null,  
            isnull(A.wip_cost, 0),  
            A.currency,  
            A.exchange_rate,  
            isnull(A.wip_cost, 0), 
            A.cap_line_no,  
            'CI',  
            A.account_code,  
            '' ---------------Code added by thyagaraj for 14H109_ACAP_00003  
			,cost_center,			--EPE-2039 --EP-93	
           null,		--EPE-2039
           null			--EPE-2039
    from   acap_wip_line_dtl a(nolock),  
                  acap_wip_hdr b(nolock)  
    where A.ou_id  = B.ou_id  
    and  A.cap_wo_number  = B.cap_wo_number  
    and  B.fb_id like @fb  
    and  (  
                (  
                 A.cap_wo_number between isnull(@documentnumberfrom, A.cap_wo_number)   
                 and isnull(@documentnumberto, A.cap_wo_number)  
                )  
   )  
    and  B.wip_status   in ('AC')  
               /*Code modified by Uma for the bug id :ES_Amig_00001 Starts here*/  
             and  B.transaction_date >   = isnull(@documentdatefrom, B.transaction_date)  
    and  B.transaction_date <= isnull(@documentdateto, B.transaction_date)  
               /*Code modified by Uma for the bug id :ES_Amig_00001 ends here*/  
    and  isnull(A.proposal_number, '')  = isnull(@proposalnumber, isnull(A.proposal_number, ''))  
    and  isnull(A.supplier, @supplier_code) like @supplier_code  
    /*and A.wip_cost > 0*/ and isnull(A.wip_cost, 0)-isnull(A.trfr_amount,0) > 0   /*Code Commented and added for EPE-79756*/
	and isnull(a.pen_cap_amount,0) <> 0 --code added for PTP-1695
    /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/   
    /*Code Commented & Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/  
    
     /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	--EP-93	
	/*code added for EPE-2039 ends*/

	/*for pm_pi 2way PO the costcenter will be availabale in gr table */
	--RBMPE-56
		update tmp
	set		tmp.cost_center	= a.gr_fin_costcenter
	from	acap_doc_dtl_tmp tmp (nolock),
			gr_fin_financepost a(nolock) ,
			sin_item_dtl b(nolock)
	where	doc_number		= b.tran_no
	and		doc_type		= b.tran_type
	and		ou_id			= b.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.ref_doc_no    = a.gr_fin_grno
	and		isnull(a.gr_fin_costcenter,'') not in ('','##')
	and		guid			=	@guid
	and		tmp.account_code=	a.gr_fin_accountcode
	and     doc_type        = 'PM_PI'
	and     tmp.cost_center is null 
	--RBMPE-56

    ;  
    with SQLTMP(tmpCol) as (  
     select  distinct A.destinationouinstid  
     from    acap_cim_intxn_model_vw A(nolock)  
     where A.sourceouinstid  = @ctxt_ouinstance  
     and  A.sourcecomponentname  = 'ACAP'  
     and  A.destinationcomponentname  = 'STKISSUE'  
    )  
            
            
insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code -----------------Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
    /*Code Commented & Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/  
    select  @guid,  
            iih_ouinstid,  
            iih_posting_fb, 
  iih_issue_no,  
            'INV_IMIS',  
            sum(iid_pencapitalisation_amt),  
            mr_proposal_number,  
            iih_issue_date,  
            null,  
            sum(iid_issue_value),  
            null,  
            null,  
            sum(iid_pencapitalisation_amt),  
 iid_line_no,  
         'CI',  
            iid_dr_account_code,  
            iih_ProjectCode -------------Code added by thyagaraj for 14H109_ACAP_00003  
        ,iid_cost_center,	--EPE-2039
			iid_issue_value,	--EPE-2039 --check
			iid_issue_qty		--EPE-2039
    from    issue_inv_detail d(nolock),  
                  MR_header(nolock),  
                  issue_inv_header h(nolock) join   
            SQLTMP  
    on   (h.iih_ouinstid = SQLTMP.tmpCol)--Code Added by Angelin.R for the Bug : 8H123-2_ACAP_00048  
    where iid_issue_no  = iih_issue_no  
    and  iid_ouinstid  = iih_ouinstid  
    and  h.iih_posting_fb like @fb  
    and  (  
                (  
                 h.iih_issue_date between isnull(@documentdatefrom, h.iih_issue_date) and isnull(@documentdateto, h.iih_issue_date)  
                )  
               )  
    and  (  
                (  
                 h.iih_issue_no between isnull(@documentnumberfrom, h.iih_issue_no) and isnull(@documentnumberto, h.iih_issue_no)  
                )  
               )  
    and  h.iih_status  = 'AU'  
    and  iih_mr_type  = 'C'  
    and  isnull(mr_proposal_number, '')  = isnull(@proposalnumber, isnull(mr_proposal_number, '')) --Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00052  
    and  mrh_ou  = iih_ouinstid  
    and  mrh_transaction_no  = iih_ref_doc_no
	/*code commented for ES_ACAP_00635 starts*/ 
    /*
	/*Code added for ITS ID : ES_ACAP_00622 starts*/
			    and     d.iid_ref_doc_no not in ( select srid_ref_doc_no 
												from str_inventory_det (nolock)
												where  d.iid_ref_doc_no      = srid_ref_doc_no
												and    d.iid_ref_doc_line_no = srid_ref_doc_lineno)
			/*Code added for ITS ID : ES_ACAP_00622 ends*/
	*/
	/*code commented for ES_ACAP_00635 ends*/ 
    and  isnull(iih_ProjectCode, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003    
    group by  
        iih_ouinstid, iih_posting_fb, iih_issue_no, iih_issue_date, iid_dr_account_code, iid_line_no, mr_proposal_number,iih_ProjectCode --------Code added by thyagaraj for 14H109_ACAP_00003   
	 ,iid_cost_center,iid_issue_value,iid_issue_qty		----EPE-2039
	/*code added for EBS-1694 starts*/
	;	 
	 with SQLTMP(tmpCol) as (  
 select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and C.sourcecomponentname = 'ACAP'   
     and  C.destinationcomponentname  =  'JV' )
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,0)),hdr.proposal_number,hdr.voucher_date,null,
			sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
			dtl.voucher_serial_no,/*null*/'CI',dtl.account_code,null,null,null,null	--NSAPL-3073
	from	jv_voucher_trn_dtl dtl(nolock),
			jv_voucher_trn_hdr hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.ou_id = SQLTMP.tmpCol)
	where	hdr.ou_id		= dtl. ou_id
	and		hdr.voucher_no	= dtl.voucher_no
	and		hdr.fb_id		like @fb
	and		hdr.voucher_no  between isnull(@documentnumberfrom, hdr.voucher_no) and isnull(@documentnumberto, hdr.voucher_no)  
	and		hdr.voucher_date	 >   = isnull(@documentdatefrom,hdr.voucher_date)  
    and		hdr.voucher_date	 <= isnull(@documentdateto,hdr.voucher_date) 
    and		isnull(hdr.proposal_number,'')  = isnull(@proposalnumber,isnull(hdr.proposal_number,''))  
	and		hdr.voucher_status  = 'AUT'
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	and		isnull(dtl.cap_flag,'') <> 'NC'--EBS-2581
	/*code added for NSAPL-3135 starts*/
	and		hdr.voucher_type  not in ('REV','TAX')
	and		isnull(hdr.ref_voucher_type,'') <> 'REV'
	and		hdr.voucher_no not in (	select hdr1.ref_voucher_no 
									from jv_voucher_trn_hdr hdr1(nolock)
									where hdr1.voucher_status ='REV'
									and hdr1.ref_voucher_no = hdr.voucher_no
									and	hdr1.ref_voucher_type = hdr.voucher_type
									and	hdr.ou_id			= hdr1.ou_id
									and hdr.fb_id			= hdr1.fb_id
									and hdr.voucher_status  = 'AUT'  )
	/*code added for NSAPL-3135 ends*/
	group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
			dtl.tran_currency,dtl.exchange_rate,
			dtl.voucher_serial_no,dtl.account_code

	update tmp
	set		tmp.cost_center	= a.costcenter_code
	from	acap_doc_dtl_tmp tmp (nolock),
			jv_voucher_trn_dtl a(nolock) 
	where	guid			=	@guid
	and		doc_number		= a.voucher_no
	and		doc_type		= 'BK_JV'
	and		tmp.ou_id			= a.ou_id
	and		a.voucher_serial_no		= tmp.line_no
	and		isnull(a.costcenter_code,'') not in ('','##')		
	/*code added for EBS-1694 ends*/

	
	/*code added for Rtrackid:EBS-1882 starts */
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
	 and  C.destinationcomponentname  = case @doctype_tmp  
                                                  when 'PUR_GR' then 'GR'  else 'GR'
                                             end ) 
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,sum(isnull(dtl.pending_cap_amount,0)),dtl.proposal_number,
			hdr.gr_hdr_grdate,supplier_code,sum(isnull(dtl.base_amount,0)),hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,sum(isnull(dtl.cap_amt,0)),
			dtl.line_no,'CI',dtl.account_code,Project_code,cost_center,null,null --EBS-2016
	from	gr_capitalization_dtl_vw dtl(nolock),
			gr_hdr_grmain hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.gr_hdr_ouinstid					= SQLTMP.tmpCol)
	where	hdr.gr_hdr_ouinstid		= dtl. tran_ou
	and		hdr.gr_hdr_grno			= dtl.tran_no
	and		dtl.fb_id		like @fb
	and		hdr.gr_hdr_grno  between isnull(@documentnumberfrom, hdr.gr_hdr_grno) and isnull(@documentnumberto, hdr.gr_hdr_grno)  
	and		hdr.gr_hdr_grdate	 between isnull(@documentdatefrom,hdr.gr_hdr_grdate)  and isnull(@documentdateto,hdr.gr_hdr_grdate)  
    and		isnull(dtl.proposal_number,'')  = isnull(@proposalnumber,isnull(dtl.proposal_number,''))  
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN') or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus = 'FA' and match_type in('2P','2W','3G','3P') and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	and		hdr.gr_hdr_grstatus in('FA','FM','PM')
	and 	exists ( select 'X' from ard_asset_account_mst(nolock)
					 where	company_code 	= @companycode_tmp
					 and	account_code	= dtl.account_code
					 and	asset_usage		= 'CWIP')
	group by hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,dtl.proposal_number,hdr.gr_hdr_grdate,
			 supplier_code,hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,
			dtl.line_no,dtl.account_code,Project_code,cost_center

	/*code added for Rtrackid:EBS-1882 ends */

   /* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 Starts*/  
   				--code added for 14H109_ACAP_00041 starts
				if  @ctxt_service	= 'acapamasesrsrch'
				begin
						;
							with SQLTMP(tmpCol) as (
								select 	distinct A.destinationouinstid
								from   	acap_cim_intxn_model_vw A(nolock)
								where	A.sourceouinstid 			= @ctxt_ouinstance
								and		A.sourcecomponentname 		= 'ACAP'
								and		A.destinationcomponentname 	= 'EAMWOGEN'
							)

						insert into acap_doc_dtl_tmp  
							  (  
							 guid,  
							 ou_id,  
							 fb_id,  
							 doc_number,  
							 doc_type,  
							 pending_cap_amount,  
							 proposal_number,  
							 tran_date,  
							 supplier_code,  
							 doc_amount,  
							 tran_currency,  
							 exchange_rate,  
							 cap_amount,  
							 line_no,  
							 cap_flag,  
							 account_code,  
							 Project_code 
							 ,cost_center,	--EPE-2039
							rate,			--EPE-2039
							quantity		--EPE-2039
								)
						
						select 	@guid,
	    							wo_ouinstance,
	    							wo_finbkid,
	    							wo_code,
	    							'EAM_WGDIR', 
	    							sum(isnull(wo_pencapitalisation_amt,0)),
									hdr.womain_proposal_id,
	  								wo_date,
	    							null,
	    							sum(isnull(wo_tot_act_cost_of,0)),
	    							null,
	    							null,
	  								sum(isnull(wo_pencapitalisation_amt,0)),
	    							wo_lineno,
	    							'CI',
	    							wo_account_code ,
	    							null ,
	    							/*null*/womain_cost_center_code,	--EPE-2039    --HAL-773
	    							null,	--EPE-2039 
	    							null	--EPE-2039 
							from   eam_workorder_cost_detail h(nolock) join 
	    							SQLTMP
							on  	(h.wo_ouinstance = SQLTMP.tmpCol)
							
							inner join Eam_WoMain_Workorder_Hdr hdr(nolock)
							on		(		h.wo_code				=	hdr.womain_wo_code
										and	h.wo_ouinstance			=	hdr.womain_wo_ouinstance
									)
							and		isnull(hdr.womain_proposal_id,'')	<>	''
							and		isnull(hdr.womain_proposal_id, '')  = isnull(@proposalnumber, isnull(hdr.womain_proposal_id, ''))
							
							and		h.wo_finbkid like @fb
							and		(
	       								(
	       									h.wo_date between isnull(@documentdatefrom, h.wo_date) and isnull(@documentdateto, h.wo_date)
	       								)
	       							)
							and		(
	       								(
	       									h.wo_code between isnull(@documentnumberfrom, h.wo_code) and isnull(@documentnumberto, h.wo_code)
	       								)
	       							)
	       					 group by
								   wo_ouinstance, wo_finbkid, wo_code, hdr.womain_proposal_id,wo_date, wo_lineno, wo_account_code,womain_cost_center_code--HAL-773
						end
						--code added for 14H109_ACAP_00041 ENDS

   
   End  
   Else  
   Begin  
     ;  
     WITH SQLTMP (tmpCol) as (SELECT distinct C.destinationouinstid  
     FROM  si_doc_hdr_vw a (NOLOCK) ,  
       acap_cim_intxn_model_vw c (NOLOCK)   
     WHERE  C.sourceouinstid           = @ctxt_ouinstance    
     and    C.sourcecomponentname      = 'ACAP'    
  and    C.destinationcomponentname = A.component_id )  
  
     INSERT INTO acap_doc_dtl_tmp(guid, ou_id, fb_id, doc_number, doc_type,   
     pending_cap_amount, proposal_number, tran_date, supplier_code,   
     doc_amount,tran_currency, exchange_rate,   
     cap_amount,   
     line_no, cap_flag,account_code,Project_code --------------Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
 quantity		--EPE-2039
     )   
     SELECT @guid , A.tran_ou , A.fb_id , A.tran_no , A.tran_type,   
     ISNULL (B.pending_cap_amount , 0) , B.proposal_no , A.tran_date , A.supplier_code ,   
     ISNULL (B.pending_cap_amount , 0) + ISNULL (B.capitalized_amount , 0) ,   
     A.tran_currency , A.exchange_rate ,   
     ISNULL (B.capitalized_amount , 0) ,   
     B.line_no , B.cap_doc_flag , B.account_code,A.Project_code 
		,null,			--EPE-2039
	   unit_price,--rate_per,		--EPE-2039
	   item_qty			--EPE-2039------------Code added by thyagaraj for 14H109_ACAP_00003  
     FROM  si_line_detail_vw b (NOLOCK) ,   
si_doc_hdr_vw a (NOLOCK) JOIN   
     SQLTMP ON (A.tran_ou      =   SQLTMP.tmpCol )  
     WHERE  A.tran_ou    =   B.tran_ou    
     and    A.tran_type      =   B.tran_type    
     and    A.tran_no       =   B.tran_no    
     and    A.fb_id       like @fb    
     and    (( CONVERT (NCHAR (10) ,A.tran_date,101)   
               BETWEEN ISNULL (@documentdatefrom,A.tran_date)   
               AND  ISNULL (@documentdateto,A.tran_date) ))    
     and    A.supplier_code     like @supplier_code    
     and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
     and    ISNULL (B.proposal_no,'')  = ISNULL (@proposalnumber,ISNULL (B.proposal_no,'') )    
     and    (( A.tran_no      BETWEEN ISNULL (@documentnumberfrom,A.tran_no)   
               AND  ISNULL (@documentnumberto,A.tran_no) ))    
     and    A.tran_type      in ('PM_PI','PM_EV','PM_IV','PM_PV','PM_SPV','PM_SCA','PM_SCI')  
     and    (A.doc_status      in ('AUT')   
     or  A.paid_status      in ('PAD'))    
     and    B.cap_doc_flag      = 'CI'    
     and    B.row_type       in ('ITEM','ACC','VOUCHER')    
     and    ISNULL (B.pending_cap_amount,0) <> 0   
  
     UNION   
     SELECT  @guid, A.ou_id, B.fb_id, A.cap_wo_number, 'CO',   
     /*ISNULL (A.wip_cost,0 ) */  isnull(A.wip_cost,0)- isnull(A.trfr_amount, 0), /*Code Commented and added for EPE-79756*/
	  A.proposal_number, B.transaction_date, A.supplier,  
     ISNULL (A.wip_cost,0 ), A.currency, A.exchange_rate,	 ISNULL (A.wip_cost,0 ) , 
       A.cap_line_no, 'CI', A.account_code,''------------Code added by thyagaraj for 14H109_ACAP_00003  
       ,cost_Center,		--EPE-2039	--EP-93	
       null,		--EPE-2039
       null			--EPE-2039
     FROM  acap_wip_line_dtl a (NOLOCK),  
       acap_wip_hdr b (NOLOCK)  
     WHERE  A.ou_id       =   B.ou_id    
     and    A.cap_wo_number     =   B.cap_wo_number    
     and    B.fb_id       like @fb    
     and    (( A.cap_wo_number     BETWEEN ISNULL (@documentnumberfrom,A.cap_wo_number)   
               AND  ISNULL (@documentnumberto,A.cap_wo_number) ))    
     and    B.wip_status      in  ('AC')  
     and   B.transaction_date    >=  ISNULL (@documentdatefrom,B.transaction_date)   
     and   B.transaction_date    <=  ISNULL (@documentdateto,B.transaction_date)  
     and    ISNULL (A.proposal_number,'')  =  ISNULL (@proposalnumber,ISNULL (A.proposal_number,'') )    
     and    A.supplier       like @supplier_code  
     /* and A.wip_cost > 0 */ and isnull(A.wip_cost,0)- isnull(A.trfr_amount, 0) > 0  /*Code Commented and added for EPE-79756*/ 	 
	 and isnull(a.pen_cap_amount,0) <> 0 --code added for PTP-1695
     
    /*code added for EPE-2039 starts*/
	update tmp
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	and 	guid	= @guid --code added for EBS-3983
	/*code added for EPE-2039 ends*/
   End  
   /* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 Ends*/   
   delete   
   from acap_doc_dtl_tmp  
   where   guid = @guid  
   and     pending_cap_amount = 0  
           
   /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/  
               
   update T1  
   set    T1.account_code = T2.account_code  
   from   acap_doc_dtl_tmp T1(nolock),  
       acap_wip_accounting_dtl T2(nolock),  
       acap_wip_hdr T3(nolock)  
   where  T1.guid = @guid  
   and    T1.doc_number = T3.cap_wo_number  
   and    T1.ou_id = T2.ou_id  
   and    T2.drcr_flag = 'DR'  
   and    T1.doc_type = 'CO'  
   and    T2.tran_number = T3.doc_number  
   and    T2.ou_id = T3.ou_id  
       /* Code added by Swetha for ACAPDMS412AT_000509 on 11/8/2006 */  
  end   
  else  
  begin  
   /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Starts here*/  
   if  @doctype_tmp = 'INV_IMIS' and @supp_code is null --code modified by Malinidevi.U for ES_ACAP_00117 on 22/02/2010  
   begin  
    /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/  
    ;  
    with SQLTMP(tmpCol) as (  
     select  distinct A.destinationouinstid  
     from    acap_cim_intxn_model_vw A(nolock)  
     where A.sourceouinstid  = @ctxt_ouinstance  
     and  A.sourcecomponentname  = 'ACAP'  
     and  A.destinationcomponentname  = 'STKISSUE'  
    )  
    /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/  
               
    insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     proposal_number,  
     Project_code ----------Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
    select  @guid,  
               iih_ouinstid,  
               iih_posting_fb,  
               iih_issue_no,  
               'INV_IMIS',  
               sum(iid_pencapitalisation_amt),  
               iih_issue_date,  
    null,  
               sum(iid_issue_value),  
               null,  
               null,  
               sum(iid_pencapitalisation_amt),  
          iid_line_no,  
               'CI',  
               iid_dr_account_code,  
               mr_proposal_number,  
               iih_ProjectCode --------------Code added by thyagaraj for 14H109_ACAP_00003  
               ,iid_cost_center,	--EPE-2039
				iid_issue_value,	--EPE-2039 --check
				iid_issue_qty		--EPE-2039
    from    issue_inv_detail d(nolock),  
                     MR_header(nolock),  
                     issue_inv_header h(nolock) join   
               SQLTMP  
    on   (h.iih_ouinstid = SQLTMP.tmpCol) --Code Added by Angelin.R for the Bug : 8H123-2_ACAP_00048  
    where iid_issue_no  = iih_issue_no  
    and  iid_ouinstid  = iih_ouinstid  
    and  h.iih_posting_fb like @fb  
    and  (  
                   (  
                    h.iih_issue_date between isnull(@documentdatefrom, h.iih_issue_date) and isnull(@documentdateto, h.iih_issue_date)  
                   )  
                  )  
    and  (  
                   (  
                    h.iih_issue_no between isnull(@documentnumberfrom, h.iih_issue_no) and isnull(@documentnumberto, h.iih_issue_no)  
                   )  
                  )  
    and  h.iih_status  = 'AU'  
    and  iih_mr_type  = 'C'  
    and  isnull(mr_proposal_number, '')  = isnull(@proposalnumber, isnull(mr_proposal_number, '')) --Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00052  
    and  mrh_ou  = iih_ouinstid  
    and  mrh_transaction_no  = iih_ref_doc_no  
    /*code commented for ES_ACAP_00635 starts*/ 
    /*
/*Code added for ITS ID : ES_ACAP_00622 starts*/
			    and d.iid_ref_doc_no not in ( select srid_ref_doc_no 
												from str_inventory_det (nolock)
												where  d.iid_ref_doc_no      = srid_ref_doc_no
												and    d.iid_ref_doc_line_no = srid_ref_doc_lineno)
			/*Code added for ITS ID : ES_ACAP_00622 ends*/
	*/
	/*code commented for ES_ACAP_00635 ends*/ 
	and  isnull(iih_ProjectCode, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003      
    group by  
        iih_ouinstid, iih_posting_fb, iih_issue_no, iih_issue_date, iid_dr_account_code, iid_line_no, mr_proposal_number,iih_ProjectCode ----   
        ,iid_cost_center,iid_issue_value,iid_issue_qty	--EPE-2039
               
    delete   
    from acap_doc_dtl_tmp  
    where   guid = @guid  
    and     pending_cap_amount = 0  
   end   
   /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/  
  
	/*code added for EBS-1694 starts*/
	if @doctype_tmp = 'BK_JV'
	begin
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
     and  C.destinationcomponentname  = case @doctype_tmp  when 'BK_JV' then 'JV'  end )
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,			
    quantity		
      )  
    select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,0)),hdr.proposal_number,hdr.voucher_date,null,
			sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
			dtl.voucher_serial_no,/*null*/'CI',dtl.account_code,null,null,null,null	--NSAPL-3073
	from	jv_voucher_trn_dtl dtl(nolock),
			jv_voucher_trn_hdr hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.ou_id = SQLTMP.tmpCol)
	where	hdr.ou_id		= dtl. ou_id
	and		hdr.voucher_no	= dtl.voucher_no
	and		hdr.fb_id		like @fb
	and		hdr.voucher_no  between isnull(@documentnumberfrom, hdr.voucher_no) and isnull(@documentnumberto, hdr.voucher_no)  
	and		hdr.voucher_date	 >   = isnull(@documentdatefrom,hdr.voucher_date)  
    and		hdr.voucher_date	 <= isnull(@documentdateto,hdr.voucher_date) 
    and		isnull(hdr.proposal_number,'')  = isnull(@proposalnumber,isnull(hdr.proposal_number,''))  
	and		hdr.voucher_status  = 'AUT'
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	and		isnull(dtl.cap_flag,'') <> 'NC'--EBS-2581
	/*code added for NSAPL-3135 starts*/
	and		hdr.voucher_type  not in ('REV','TAX')
	and		isnull(hdr.ref_voucher_type,'') <> 'REV'
	and		hdr.voucher_no not in (	select hdr1.ref_voucher_no 
									from jv_voucher_trn_hdr hdr1(nolock)
									where hdr1.voucher_status ='REV'
									and hdr1.ref_voucher_no = hdr.voucher_no
									and	hdr1.ref_voucher_type = hdr.voucher_type
									and	hdr.ou_id			= hdr1.ou_id
									and hdr.fb_id			= hdr1.fb_id
									and hdr.voucher_status  = 'AUT'  )
	/*code added for NSAPL-3135 ends*/
	group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
			dtl.tran_currency,dtl.exchange_rate,
			dtl.voucher_serial_no,dtl.account_code

	
	update tmp
	set		tmp.cost_center	= a.costcenter_code
	from	acap_doc_dtl_tmp tmp (nolock),
			jv_voucher_trn_dtl a(nolock) 
	where	guid			=	@guid
	and		doc_number		= a.voucher_no
	and		doc_type		= 'BK_JV'
	and		tmp.ou_id			= a.ou_id
	and		a.voucher_serial_no		= tmp.line_no
	and		isnull(a.costcenter_code,'') not in ('','##')		
	end

	/*code added for EBS-1694 ends*/
	
	
	/*code added for Rtrackid:EBS-1882 starts */
	;	 
	 with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid 
     from    acap_cim_intxn_model_vw c(nolock)  
    where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
	 and  C.destinationcomponentname  = case @doctype_tmp  
                                                  when 'PUR_GR' then 'GR'  
                                             end ) 
	
	insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code  
     ,cost_center,	
    rate,		
    quantity		
      )  
    select  @guid,hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,sum(isnull(dtl.pending_cap_amount,0)),dtl.proposal_number,
			hdr.gr_hdr_grdate,supplier_code,sum(isnull(dtl.base_amount,0)),hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,sum(isnull(dtl.cap_amt,0)),
			dtl.line_no,'CI',dtl.account_code,Project_code,cost_center,null,null --EBS-2016
	from	gr_capitalization_dtl_vw dtl(nolock),
			gr_hdr_grmain hdr(nolock)
			join   
               SQLTMP  
    on   (hdr.gr_hdr_ouinstid					= SQLTMP.tmpCol)
	where	hdr.gr_hdr_ouinstid		= dtl. tran_ou
	and		hdr.gr_hdr_grno			= dtl.tran_no
	and		dtl.fb_id		like @fb
	and		hdr.gr_hdr_grno  between isnull(@documentnumberfrom, hdr.gr_hdr_grno) and isnull(@documentnumberto, hdr.gr_hdr_grno)  
	and		hdr.gr_hdr_grdate	 between isnull(@documentdatefrom,hdr.gr_hdr_grdate)  and isnull(@documentdateto,hdr.gr_hdr_grdate)  
    and		isnull(dtl.proposal_number,'')  = isnull(@proposalnumber,isnull(dtl.proposal_number,''))  
	and		dtl.drcr_flag		= 'DR'
	and		dtl.pending_cap_amount > 0
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN') or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	--and		((hdr.gr_hdr_grstatus = 'FZ' and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus = 'FA' and match_type in('2P','2W','3G','3P') and dtl.insp_type ='NN')or (hdr.gr_hdr_grstatus in('FA','FM')	and	dtl.insp_type <>'NN'))
	and		hdr.gr_hdr_grstatus in('FA','FM','PM')
	and 	exists ( select 'X' from ard_asset_account_mst(nolock)
					 where	company_code 	= @companycode_tmp
					 and	account_code	= dtl.account_code
					 and	asset_usage		= 'CWIP')
	group by hdr.gr_hdr_ouinstid,dtl.fb_id,dtl.tran_no,tran_type,dtl.proposal_number,hdr.gr_hdr_grdate,
			 supplier_code,hdr.gr_hdr_currency,hdr.gr_hdr_exchrate,
			dtl.line_no,dtl.account_code,Project_code,cost_center


	/*code added for Rtrackid:EBS-1882 ends */

   if  @doctype_tmp = 'CO'  
   begin  
    insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
     supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
     cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code ---------------Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
    select  @guid,  
               A.ou_id,  
               B.fb_id, 
               A.cap_wo_number,  
               'CO',  
               /*isnull(A.wip_cost, 0)*/ isnull(A.wip_cost,0)- isnull(A.trfr_amount, 0),  /*Code Commented and added for EPE-79756*/
               A.proposal_number,  
               B.transaction_date,  
              null,  
               /* Code modified by Swetha for ACAPDMS412AT_000442 on 18/5/2006 */  
               isnull(A.wip_cost, 0),  
               A.currency,  
               A.exchange_rate,  
               /* Code modified by Swetha for ACAPDMS412AT_000442 on 18/5/2006 */  
               isnull(A.wip_cost, 0),
               A.cap_line_no,  
              'CI',  
               A.account_code,  
              ''----------Code added by thyagaraj for 14H109_ACAP_00003  
,cost_center,	--EP-93	
              null,
        null --check
    from    acap_wip_line_dtl a(nolock),  
              acap_wip_hdr b(nolock)  
   where A.ou_id  = B.ou_id 
	and  B.ou_id	= @ctxt_ouinstance--code added for AA-575 
    and  A.cap_wo_number  = B.cap_wo_number  
    and  B.fb_id like @fb  
    and  A.cap_wo_number between isnull(@documentnumberfrom, A.cap_wo_number) and isnull(@documentnumberto, A.cap_wo_number)  
    and  B.wip_status   in ('AC')  
          /* Code modified by swetha for ACAPDMS412AT_000319 on 09/02/2006 */  
                  /*and     B.transaction_date  between  isnull(@documentdatefrom, B.transaction_date)   and   isnull(@documentdateto,B.transaction_date) */  
                  /* Code modified by Swetha for ACAPDMS412AT_000333 on 02/02/2006 */  
                  /*and     B.transaction_date  between  isnull(@documentdatefrom, B.transaction_date)   and   isnull(@documentdateto,B.transaction_date)*/  
                  /* Code modified by swetha for ACAPDMS412AT_000319 on 09/02/2006 */  
                  /* Code modified by swetha for ACAPDMS412AT_000344 on 09/02/2006 */  
                  /*Code modified by Uma for the bug id :ES_Amig_00001 Starts here*/   
    and  B.transaction_date >   = isnull(@documentdatefrom, B.transaction_date)  
    and  B.transaction_date <= isnull(@documentdateto, B.transaction_date)  
                  /*Code modified by Uma for the bug id :ES_Amig_00001 Ends here*/  
                  /* Code modified by swetha for ACAPDMS412AT_000344 on 09/02/2006 */  
    and  isnull(A.proposal_number, '')  = isnull(@proposalnumber, isnull(A.proposal_number, ''))  
    and  isnull(A.supplier, @supplier_code) like @supplier_code  
                  /* Code modified by Swetha for ACAPDMS412AT_000333 on 02/02/2006 */  
    /*and  A.wip_cost > 0 */ and isnull(A.wip_cost,0)- isnull(A.trfr_amount, 0)  > 0 /*Code commented and added for EPE-79756*/
    and isnull(a.pen_cap_amount,0) <> 0 --code added for PTP-1695
               
    /* Code added by Swetha for ACAPDMS412AT_000509 on 11/8/2006 */  
    update T1  
    set    T1.account_code = T2.account_code  
    from   acap_doc_dtl_tmp T1(nolock),  
        acap_wip_accounting_dtl T2(nolock),  
        acap_wip_hdr T3(nolock)  
    where  T1.guid = @guid  
    and    T1.doc_number = T3.cap_wo_number  
    and    T1.ou_id = T2.ou_id  
    and    T2.drcr_flag = 'DR'  
    and    T1.doc_type = 'CO'  
    and    T2.tran_number = T3.doc_number  
    and    T2.ou_id = T3.ou_id  
  /* Code added by Swetha for ACAPDMS412AT_000509 on 11/8/2006 */  
   end   
   else  
   begin  
    ;  
    /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
    with SQLTMP(tmpCol) as (  
     select  distinct C.destinationouinstid  
                         /* Code modified by Swetha for  ACAPDMS412AT_000560 on 23/10/2006 */  
     from    acap_cim_intxn_model_vw c(nolock)  
     where C.sourceouinstid  = @ctxt_ouinstance  
     and  C.sourcecomponentname  = 'ACAP'   
                      /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
     and  C.destinationcomponentname  = case @doctype_tmp  
                                                      when 'PM_PI' then 'SIN'  
                  --when 'PM_MI' then 'SIN'--Modified for DTS ID:9H123-1_ACAP_00001  
                                                      when 'PM_EV' then 'SDIN'  
                      when 'PM_IV' then 'SDIN'  
                                                      when 'PM_SPV' then 'SNP'  
                                                      when 'PM_PV' then 'SPY'  
                                                      when 'PM_SCA' then 'SCDN'  
                                                      when 'PM_SCI' then 'SCDN'  
                                                    end  
    )  
    /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
               
    insert into acap_doc_dtl_tmp  
      (  
     guid,  
     ou_id,  
     fb_id,  
     doc_number,  
     doc_type,  
     pending_cap_amount,  
     proposal_number,  
     tran_date,  
    supplier_code,  
     doc_amount,  
     tran_currency,  
     exchange_rate,  
    cap_amount,  
     line_no,  
     cap_flag,  
     account_code,  
     Project_code --------------Code added by thyagaraj for 14H109_ACAP_00003  
     ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
      )  
    select  @guid,  
          A.tran_ou,  
             A.fb_id,  
             A.tran_no,  
               A.tran_type,  
               isnull(B.pending_cap_amount, 0),  
               B.proposal_no,  
               A.tran_date,  
               A.supplier_code,  
               isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0),  
     A.tran_currency,  
               A.exchange_rate,  
               isnull(B.capitalized_amount, 0),  
               B.line_no,  
               B.cap_doc_flag,  
               B.account_code,  
               A.Project_code -----------Code added by thyagaraj for 14H109_ACAP_00003  
              ,null,			--EPE-2039
			   unit_price,--rate_per,		--EPE-2039
			   item_qty			--EPE-2039
    from    si_line_detail_vw b(nolock),  
                    si_doc_hdr_vw a(nolock) join   
               SQLTMP  
    on   (A.tran_ou = SQLTMP.tmpCol)  
    where A.tran_ou  = B.tran_ou  
    and  A.tran_type  = B.tran_type  
    and  A.tran_no  = B.tran_no 
    and  A.fb_id like @fb  
    and  (  
      (  
                    convert(Nchar(10), A.tran_date, 101)   
                    between isnull(@documentdatefrom, A.tran_date)   
                    and isnull(@documentdateto, A.tran_date)  
                   )  
                  )  
     and  isnull(A.supplier_code, /*@supplier_code*/'') like @supplier_code --code modified by Malinidevi.U for ES_ACAP_00117 on 22/02/2010  
     and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
     and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
    and  (  
                   (  
                    A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
                    and isnull(@documentnumberto, A.tran_no)  
                   )  
                  )   
                  /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
                  --and   A.component_id = @doctype_tmp  
    and  A.tran_type  = @doctype_tmp  
                  /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */  
    and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
    and  B.cap_doc_flag  = 'CI'  
    and  B.row_type   in ('ITEM', 'ACC', 'VOUCHER')  
    and  B.pending_cap_amount <> 0  


    
    /*code added for EPE-2039 starts*/
	update tmp --check
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	--EP-93	
	
	/*code added for EPE-2039 ends*/
	  
    --Added for DTS ID:9H123-1_ACAP_00003 starts here  
    if @doctype_tmp = 'PM_MI'  
   begin  
     ;  
     with SQLTMP(tmpCol) as (  
      select  distinct C.destinationouinstid  
      from    acap_cim_intxn_model_vw c(nolock)  
      where C.sourceouinstid  = @ctxt_ouinstance  
      and  C.sourcecomponentname  = 'ACAP'  
      and  C.destinationcomponentname  = 'SIN'  
     )  
     insert into acap_doc_dtl_tmp  
       (  
      guid,  
      ou_id,  
      fb_id,  
      doc_number,  
      doc_type,  
      pending_cap_amount,  
      proposal_number,  
      tran_date,  
      supplier_code,  
      doc_amount,  
      tran_currency,  
      exchange_rate,  
      cap_amount,  
      line_no,  
      cap_flag,  
      account_code,  
      Project_code--Code added by thyagaraj for 14H109_ACAP_00003  
      ,cost_center,	--EPE-2039
    rate,			--EPE-2039
    quantity		--EPE-2039
       )  
     select  @guid,  
          A.tran_ou,  
          A.fb_id,  
          A.tran_no,  
          A.tran_type,  
       case tcdtype   
        when 'D' then -isnull(B.pending_cap_amount, 0)  
        else isnull(B.pending_cap_amount, 0)  
       end,  
          B.proposal_no,  
          A.tran_date,  
          A.supplier_code,  
             case tcdtype   
        when 'D' then -(isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0)) 
        else isnull(B.pending_cap_amount, 0) + isnull(B.capitalized_amount, 0)  
       end,  
A.tran_currency,  
    A.exchange_rate,  
             case tcdtype   
        when 'D' then -isnull(B.capitalized_amount, 0)  
        else isnull(B.capitalized_amount, 0)  
       end,  
          B.line_no,  
          B.cap_doc_flag,  
          B.account_code,  
          A.Project_code --------Code added by thyagaraj for 14H109_ACAP_00003  
           ,null,			--EPE-2039
          unit_price,-- rate_per,		--EPE-2039
           item_qty			--EPE-2039
     from    si_line_detail_vw B(nolock),  
                si_doc_hdr_vw A(nolock) join   
          SQLTMP  
     on   (A.tran_ou = SQLTMP.tmpCol),  
       sin_delivery_Charge_dtl dtl(nolock),  
       tcd_tcdvariantdetail_vw tcd(nolock)  
     where A.tran_ou  = B.tran_ou  
     and  A.tran_type = B.tran_type  
     and  A.tran_no  = B.tran_no  
     and  A.tran_type = dtl.tran_type  
     and  A.tran_ou = dtl.tran_ou  
     and  A.tran_no = dtl.tran_no  
     and  b.line_no = dtl.tran_line_no  
     and  DTL.tcd_code = tcd.tcdcode  
     and  DTL.tcd_variant = tcd.tcdvariant   
     and  DTL.tcdversionno= tcd.tcdversionno  
     and     tcd.lo_id   = @loid_tmp  
     and     tcd.tcdaccrule  = 'IN'  
     and  A.fb_id  like @fb  
     and  (  
              (  
               convert(Nchar(10), A.tran_date, 101)   
               between isnull(@documentdatefrom, A.tran_date)   
               and isnull(@documentdateto, A.tran_date)  
              )  
             )  
     and  isnull(A.supplier_code, @supplier_code) like @supplier_code  
     and  isnull(A.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
     and  isnull(B.proposal_no, '')  = isnull(@proposalnumber, isnull(B.proposal_no, ''))  
     and  (  
              (  
               A.tran_no between isnull(@documentnumberfrom, A.tran_no)   
               and isnull(@documentnumberto, A.tran_no)  
              )  
             )   
     and  A.tran_type  ='PM_MI'  
     and  (A.doc_status in ('AUT') or A.paid_status in ('PAD'))  
     and  B.cap_doc_flag  = 'CI'  
     and  B.row_type   in ('ITEM', 'ACC')  
     and  (B.capitalized_amount >= 0 or B.pending_cap_amount > 0)  
     
     
      /*code added for EPE-2039 starts*/
	update tmp --check
	set		tmp.cost_center	= a.cost_center
	from	acap_doc_dtl_tmp tmp (nolock),
			si_acct_info_dtl a(nolock) ,
			si_line_detail_vw b(nolock)
	where	doc_number		= a.tran_no
	and		doc_type		= a.tran_type
	and		ou_id			= a.tran_ou
	and		b.line_no		= tmp.line_no
	and		b.tran_no		= doc_number
	and		b.tran_ou		= ou_id
	and		isnull(a.cost_center,'') not in ('','##')
	--EP-93	
	and		guid			=	@guid
	and		b.line_no		=	a.line_no
	--EP-93	

	/*code added for EPE-2039 ends*/
    end  
    --Added for DTS ID:9H123-1_ACAP_00003 ends here  
   end  
   
   	--code added for 14H109_ACAP_00041 starts
				if 	@doctype_tmp = 'EAM_WGDIR' and @supp_code is null  and @ctxt_service	= 'acapamasesrsrch'
		 		begin
						;
							with SQLTMP(tmpCol) as (
								select 	distinct A.destinationouinstid
								from   	acap_cim_intxn_model_vw A(nolock)
								where	A.sourceouinstid 			= @ctxt_ouinstance
								and		A.sourcecomponentname 		= 'ACAP'
								and		A.destinationcomponentname 	= 'EAMWOGEN'
							)

						insert into acap_doc_dtl_tmp  
							  (  
							 guid,  
							 ou_id,  
							 fb_id,  
							 doc_number,  
							 doc_type,  
							 pending_cap_amount,  
							 proposal_number,  
							 tran_date,  
							 supplier_code,  
							 doc_amount,  
							 tran_currency,  
							 exchange_rate,  
							 cap_amount,  
							 line_no,  
							 cap_flag, 
							 account_code,  
							 Project_code 
							 ,cost_center,	--EPE-2039
							rate,			--EPE-2039
							quantity		--EPE-2039
							)
						
						select 	@guid,
	  							wo_ouinstance,
	    							wo_finbkid,
	    							wo_code,
	    							'EAM_WGDIR', 
	    							sum(isnull(wo_pencapitalisation_amt,0)),
									hdr.womain_proposal_id,
	  								wo_date,
	    							null,
	    							sum(isnull(wo_tot_act_cost_of,0)),
	    							null,
	    							null,
	  								sum(isnull(wo_pencapitalisation_amt,0)),
	    							wo_lineno,
	    							'CI',
	    							wo_account_code ,
	    							null  
	    						   ,/*null*/womain_cost_center_code, --HAL-773
	    							null,
	    							null --check
							from   eam_workorder_cost_detail h(nolock) join 
	    							SQLTMP
							on  	(h.wo_ouinstance = SQLTMP.tmpCol)
							
							inner join Eam_WoMain_Workorder_Hdr hdr(nolock)
							on		(		h.wo_code				=	hdr.womain_wo_code
										and	h.wo_ouinstance			=	hdr.womain_wo_ouinstance
									)
							and		isnull(hdr.womain_proposal_id,'')	<>	''
							and		isnull(hdr.womain_proposal_id, '')  = isnull(@proposalnumber, isnull(hdr.womain_proposal_id, ''))
							
							and		h.wo_finbkid like @fb
							and		(
	       								(
	       									h.wo_date between isnull(@documentdatefrom, h.wo_date) and isnull(@documentdateto, h.wo_date)
	       								)
	       							)
							and		(
	       								(
	       									h.wo_code between isnull(@documentnumberfrom, h.wo_code) and isnull(@documentnumberto, h.wo_code)
	       								)
	       							)
	       					 group by
								   wo_ouinstance, wo_finbkid, wo_code, hdr.womain_proposal_id,wo_date, wo_lineno, wo_account_code,womain_cost_center_code  --HAL-773
						end
						--code added for 14H109_ACAP_00041 ENDS


  end  
 end  
  
 --Code added by Aparna M. for the 8H123-1_spy_00001 starts  
 delete TMP  
 from si_doc_balance SI(nolock),  
   acap_doc_dtl_tmp TMP(nolock)  
 where   guid = @guid  
 and     tran_ou = TMP.ou_id  
 and  tran_type = TMP.doc_type  
 and     tran_type = 'PM_PV'  
 and     tran_no = TMP.doc_number  
 and     SI.adjustment_status = 'PAD'  
 and     pdc_flag = 'Y'  
 --Code added by Aparna M. for the 8H123-1_spy_00001 ends  
  
 /*Code Added by Esther J for the Bug id : 8H123-2_ACAP_00059 Starts here*/  
 update TMP1  
 --ZHE-599
 /*
 set    total_docamt = case   
          when T1.totamt > 0 then T1.totamt  
          else T1.totlineamt  
        end -- Code Modified by Uma for the defect id : ES_ACAP_00079 -- T1.totamt  
 */       
 set    total_docamt = case   
          when T1.totlineamt  > 0 then T1.totlineamt  
          else T1.totamt 
        end
 --ZHE-599

 from   acap_doc_dtl_tmp TMP1(nolock),  
     (  
      select  ou_id,  
              doc_type,  
              doc_number,  
              TMP.line_no,  
              round(sum(isnull(item_amount * exchange_rate, 0)), @pamt_tmp)  as totamt --Code Modified By Angelin.R for the Bug id : ES_ACAP_00011  
              ,  
              round(sum(isnull(line_amount * exchange_rate, 0)), @pamt_tmp)  as totlineamt -- Code Added by Uma for the defect id : ES_ACAP_00079  
      from    si_line_dtl SI(nolock),  
                    acap_doc_dtl_tmp TMP(nolock)  
      where guid  = @guid  
      and  SI.tran_ou  = TMP.ou_id  
      and  SI.tran_type  = TMP.doc_type  
      and  SI.tran_no  = TMP.doc_number  
 group by  
       ou_id, doc_type, doc_number, TMP.line_no  
     ) T1  
 where  TMP1.guid = @guid  
 and    TMP1.ou_id = T1.ou_id  
 and    TMP1.doc_type = T1.doc_type  
 and    TMP1.doc_number = T1.doc_number  
  
 /*Code Added by Angelin.R for the Bug id : ES_ACAP_00011 Starts here*/  
 update TMP1  
 set    total_docamt = T1.totamt  
 from   acap_doc_dtl_tmp TMP1(nolock),  
     (  
      select  ou_id,  
              doc_type,  
              doc_number, 
              TMP.line_no,  
              sum(isnull(SI.base_amount, 0))  as totamt  
      from    si_acct_info_dtl SI(nolock),  
                    acap_doc_dtl_tmp TMP(nolock)  
      where guid  = @guid  
      and  SI.tran_ou  = TMP.ou_id  
      and  SI.tran_type  = TMP.doc_type  
      and  SI.tran_no  = TMP.doc_number  
      and  SI.tran_type  = 'PM_PV'  
      and  SI.account_type  = 'ERVA'  
      group by  
   ou_id, doc_type, doc_number, TMP.line_no  
     ) T1  
 where  TMP1.guid = @guid  
 and    TMP1.doc_type = 'PM_PV'  
 and    TMP1.ou_id = T1.ou_id  
 and    TMP1.doc_type = T1.doc_type  
 and    TMP1.doc_number = T1.doc_number  
 /*Code Added by Angelin.R for the Bug id : ES_ACAP_00011 Ends here*/  
  
 /*code added for DTS ID: 9H123-1_ACAP_00005 starts here*/  
 update tmp1  
 set  total_docamt = t1.docamount  
 from acap_doc_dtl_tmp tmp1(nolock),  
   (  
    select  ou_id,  
      doc_type,  
      doc_number,  
      sum(doc_amount) as docamount  
    from acap_doc_dtl_tmp tmp(nolock)  
    where guid    = @guid  
    and  tmp.doc_type = 'PM_MI'  
    group by  
     ou_id, doc_type, doc_number  
   ) t1  
 where  tmp1.guid = @guid  
 and    tmp1.ou_id = t1.ou_id  
 and    tmp1.doc_type = t1.doc_type  
 and    tmp1.doc_number = t1.doc_number  
 /*code added for DTS ID: 9H123-1_ACAP_00005 ends here*/  

  
 update TMP1  
 set    total_docamt = T1.totamt  
 from   acap_doc_dtl_tmp TMP1(nolock),  
     (  
      select  ou_id,  
              doc_type,  
              doc_number,  
              line_no,  
              sum(isnull(iid_issue_value, 0))  as totamt  
      from    issue_inv_detail iss(nolock),  
                    acap_doc_dtl_tmp TMP(nolock)  
      where guid  = @guid  
      and  iss.iid_ouinstid  = TMP.ou_id  
      and  iss.iid_issue_no  = TMP.doc_number  
      and  TMP.doc_type  = 'INV_IMIS'  
      group by  
       ou_id, doc_type, doc_number, line_no  
     ) T1  
 where  TMP1.guid = @guid  
 and    TMP1.ou_id = T1.ou_id  
 and    TMP1.doc_type = T1.doc_type  
 and    TMP1.doc_number = T1.doc_number  

 /*code added for EBS-1694 starts*/
 
 update TMP1  
 set    total_docamt = T1.totamt  
 from   acap_doc_dtl_tmp TMP1(nolock),  
     (  
      select  tmp.ou_id,  
              doc_type,  
              doc_number,  
              sum(isnull(tran_amount, 0))  as totamt  
      from    jv_voucher_trn_dtl jv(nolock),  
                    acap_doc_dtl_tmp TMP(nolock)  
      where guid  = @guid  
      and  jv.ou_id  = TMP.ou_id  
      and  jv.voucher_no  = TMP.doc_number  
      and  TMP.doc_type  = 'BK_JV'  
	   and  jv.drcr_flag= 'DR' 
	  and  jv.voucher_serial_no		= tmp.line_no
      group by  
       tmp.ou_id, doc_type, doc_number
     ) T1  
 where  TMP1.guid = @guid  
 and    TMP1.ou_id = T1.ou_id  
 and    TMP1.doc_type = T1.doc_type  
 and    TMP1.doc_number = T1.doc_number  

 /*code added for EBS-1694 ends*/
  
  /*code added for Rtrackid:EBS-1882 starts */
  update TMP1  
 set    total_docamt = T1.totamt  
 from   acap_doc_dtl_tmp TMP1(nolock),  
     (  
      select  tmp.ou_id,  
              doc_type,  
              doc_number,  
              sum(isnull(tran_amount_acc_cur, 0))  as totamt  
      from    gr_capitalization_dtl_vw GR(nolock),  
                    acap_doc_dtl_tmp TMP(nolock)  
      where guid = @guid  
      and  GR.tran_ou  = TMP.ou_id  
  and  GR.tran_no  = TMP.doc_number  
      and  GR.Tran_type  = 'PUR_GR'  
	   and  GR.drcr_flag= 'DR' 
	  and  GR.line_no		= tmp.line_no
      group by  
       tmp.ou_id, doc_type, doc_number
     ) T1  
 where  TMP1.guid = @guid  
 and    TMP1.ou_id = T1.ou_id  
 and    TMP1.doc_type = T1.doc_type  
 and    TMP1.doc_number = T1.doc_number  
 /*code added for Rtrackid:EBS-1882 ends */


 update TMP1  
 set    total_docamt = CO.wip_cost  
 from   acap_doc_dtl_tmp TMP1(nolock),  
     acap_wip_hdr CO(nolock)  
 where  guid = @guid  
 and    TMP1.ou_id = CO.ou_id  
 and    TMP1.doc_type = 'CO'  
 and    TMP1.doc_number = CO.cap_wo_number  
 /*Code Added by Esther J for the Bug id : 8H123-2_ACAP_00059 Ends here*/  
 
 
 --code added for the dts id 14H109_ACAP_00041 starts
	update TMP1
	set    total_docamt = T1.totamt
	from   acap_doc_dtl_tmp TMP1(nolock),
	       (
	           select 	wo_ouinstance as ou_id,
	           			'EAM_WGDIR' as doc_type,
	           			wo_code as doc_number,
	           			sum(isnull(wo_tot_act_cost_of, 0)) 	as totamt
	           from   	eam_workorder_cost_detail eam(nolock),
	                  	acap_doc_dtl_tmp TMP(nolock)
	           where	guid 				= @guid
	           and		eam.wo_ouinstance 	= TMP.ou_id
	           and		eam.wo_code 		= TMP.doc_number
	           and		eam.wo_lineno		= tmp.line_no
	           and		TMP.doc_type 	 	= 'EAM_WGDIR'
	           group by
	                  wo_ouinstance,  wo_code
	       ) T1
	where  TMP1.guid		= @guid
	and    TMP1.ou_id		= T1.ou_id
	and    TMP1.doc_type	= T1.doc_type
	and    TMP1.doc_number  = T1.doc_number 
	--code added for the dts id 14H109_ACAP_00041 ends

  
 /*Code added for DTS ID: 9H123-1_ACAP_00014 starts here*/  
    update  tmp1  
    set     supplier_name_desc = s.supplier_name  
    from    acap_doc_dtl_tmp tmp1,  
            supp_supdtls_vw s(nolock)  
    where   tmp1.guid		= @guid  --code added for HAL-1064
	and		s.loid          =  @loid_tmp  
    and     s.supplier_code =  tmp1.supplier_code    
    /*Code added for DTS ID: 9H123-1_ACAP_00014 ends here*/  


	 --/* code added by EPE-87204  begins here */
	
     select @pps_flag = FLAG_YES_NO 
	 from  pps_feature_list(nolock)
	 where FEATURE_ID      = 'PPS_ACAP_101'
	 and   COMPONENT_NAME  = 'ACAP'
	
	if @pps_flag ='yes'

	begin

	;WITH CTE_Combined AS (
				 SELECT SUM(a.cap_amount) AS TotalDocAmount	 , a.line_no ,a.proposal_number	,a.	doc_number	,a.doc_type
				 FROM acap_tag_doc_dtl a(nolock)
			     , acap_asset_hdr b  (nolock)
				 WHERE a.cap_number = b.cap_number
				 AND b.cap_status = 'FR'
				 and  a.doc_number  in (select distinct doc_number from acap_doc_dtl_tmp tmp	(nolock)
				 where tmp.guid =@guid  
				  )
				  group by line_no ,a.proposal_number,a.doc_number	,a.doc_type
			)
 
     UPDATE b
		SET pending_cap_amount = isnull(B.pending_cap_amount, 0)  -isnull(c.TotalDocAmount,0)
		FROM CTE_Combined c(nolock)
		, acap_doc_dtl_tmp b  
		WHERE b.guid =@guid
		--and  c.proposal_number = isnull(@proposalnumber, isnull(b.proposal_number, ''))
		and c.line_no	=  b.line_no
		and c.doc_type	 = b.doc_type
		AND b.doc_number = C.doc_number	

		  DELETE FROM acap_doc_dtl_tmp
		  WHERE guid = @guid AND pending_cap_amount <= 0;

	end
	----/* code added by EPE-87204  begins here */--
	
	--ES_ACAP_00695
	update  tmp1  
    set     tran_currency	=	@base_Curr,  
		    exchange_rate	=	1
    from    acap_doc_dtl_tmp tmp1  
    where	 TMP1.guid		= @guid   
	and		TMP1.doc_type  IN ('INV_IMIS','CO')--Code added by mchs-754
	--ES_ACAP_00695


 set nocount off 
end  
  






