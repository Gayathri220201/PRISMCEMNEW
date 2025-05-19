/*$File_version=ms4.3.0.54$*/
/*$file name : acap_get_doc_noncap.sql*/
/*$version   : 4.0.0.13*/
/***************************************************************************************************************************
 stored procedure 	: 	acap_get_doc_noncap
 author           	: 	Sangeetha Sitaraman
 created on       	: 	05-11-2005
 Purpose	    	: 	Based on the Inputs, this sp will return NonCap. document and their Pending Cap amount.
						Pending Cap. amount is available in si_doc_hdr_vw - cap_amount 
****************************************************************************************************************************
 Modification details:
	Modified by					Date					Remarks										Version
	Swetha 						28/12/2005				ACAPDMS412AT_000210
	Swetha 						4/1/2005				ACAPDMS412AT_000241
	Swetha 						9/2/2006				ACAPDMS412AT_000319
	Swetha 						9/2/2006				ACAPDMS412AT_000344
	Swetha 						13/03/2006				ACAPBGL_000064
	Swetha 						16/03/2006				ACAPDMS412AT_000362
	Swetha 						19/8/2006				ACAPDMS412AT_000495
	Swetha						14/10/2006 				ACAPDMS412AT_000558							4.0.0.8
	Swetha						14/10/2006 				ACAPDMS412AT_000562
	Swetha               		05/01/2007              SDINDMS412AT_000538
	Uma Maheswari				07th May 2007			ACAPDMS412AT_000701 (Only Sp alignment)
	Uma Maheswari				17th June 2007			ACAPDMS412AT_000718
														ACAPDMS412AT_000714
	Uma Maheswari				25th June 2007			ACAPDMS412AT_000719
	Uma Maheswari				18th June 2008			ES_ACAP_00007
	Aparna M.					09/06/2008				8H123-1_spy_00001
	Uma Maheswari				03rd July 2008			ES_ACAP_00008 
	Antoinette					11/09/2008				ES_ACAP_00029 
	Angelin.R					03rd Oct  2008			MS440_GEN_MRBCAP
	Angelin.R 					24th Nov 2008			8H123-2_ACAP_00048
	Esther J 					02nd Dec 2008			8H123-2_ACAP_00059
	Uma Maheswari				18th Aug 2009			ES_ACAP_00079
	Uma Maheswari				11th Jan 2010			ES_ACAP_00116
	Veangadakrishnan R			03/12/2009				9H123-1_ACAP_00001
	Veangadakrishnan R			06/01/2010				9H123-1_ACAP_00011 (Ref ID: 9H123-1_ACAP_00001)
	Veangadakrishnan R  		18/01/2010      		9H123-1_ACAP_00014 (Ref ID: 9H123-1_ACAP_00001)
	Veangadakrishnan R  		19/01/2010      		9H123-1_ACAP_00015 (Ref ID: 9H123-1_ACAP_00001)
	Malinidevi.U				18/01/2010				ES_ACAP_00117
	Malinidevi.U				22/02/2010				ES_ACAP_00117
	Damodharan. R				10/06/2010				ES_ACAP_00146
	Indira G					22/06/2012				ES_ACAP_00315
	Aditya Sitaraman			21/11/2012				ES_ACAP_00364
	Prakash V					18/09/2013				ES_ACAP_00364
	Indira G					01/10/2013				ES_ACAP_00518
	Aditya Sitaraman			30/10/2013				ES_ACAP_00524
	Esther						17/1/2014				13H120_General_00032 ;13H120_ACAP_00002 
	Thyagaraj B M               16/07/2014              14H109_ACAP_00003
	C.Ramesh Kumar				26.09.2014				14H109_ACAP_00041
	Aditya Sitaraman			28/11/2014				ES_ACAP_00692
	Aditya Sitaraman			03/12/2014				ES_ACAP_00695	
	Indira G					20/05/2015				ES_ACAP_00774
	Indira G					29/07/2015				ES_ACAP_00826
	Balaji C					25/09/2015				ES_ACAP_00859
	Aditya Sitaraman			30/09/2015				ES_ACAP_00855
	Ashok V						13/10/2015				ES_ACAP_00884
	Aditya Sitaraman			25/11/2015				ES_ACAP_00902
	Aditya Sitaraman			18/12/2015				ES_ACAP_00920
	Aditya Sitaraman			30/03/2016				ES_ACAP_00973
	Kavitha N					22/08/2016				ES_ABB_04450
	Aditya S					18/07/2017				HCE-91	
	Sangeetha M					07/08/2017				EPE-2039	
	Sangeetha M					16/11/2017				EDS-44
	Sivapriya J					04/01/2018				GMKPSS-151
	Aditya S					27/03/2018				EP-93	
	Aditya S					18/07/2018				HAL-773
	Ashok V						04/02/2019				EBS-2581	
	Ashok V						07/03/2019				EBS-2752
	Balaji C					12/04/2019				CIE-688
	Amrutha R.S				    06/06/2019				EPE-14158
	Amrutha R.S					20/06/2019				EPE-14525
	Aditya S					22/07/2019				CIE-825
	Balaji C					05/08/2019				PTP-105
	Aditya S					26/08/2019				CIE-866
	Ashok V						19/12/2019				IHH-551
	Ashok V						27/03/2020				NSAPL-3311
	Aditya S					30/04/2020				NSAPL-3339
	Ashok V						02/07/2020				CIE-1130
	Indira G					24/08/2020				PEPS-1181
	Ashok V						22/09/2020				NSAPL-3429
	Ashok V						07/12/2020				PTP-1376
	Ashok V						24/05/2022				EP-915
/*  Uma Maheshwari M	        26/05/2022			    EPE-46265			*/
/*  Saranraj C	                26/10/2023			    MCHS-873			*/
/*  Banurekha B                 2/11/2023               MCHS-916             */
***************************************************************************************************************************/
create procedure acap_get_doc_noncap
	@ctxt_language	        fin_ctxt_language,
	@ctxt_ouinstance		fin_ctxt_ouinstance,
	@ctxt_service			fin_ctxt_service,
	@ctxt_user 	 			fin_ctxt_user,
	@doctype 				fin_documenttype,
	@documentdatefrom		fin_date,
	@documentdateto 		fin_date,
	@documentnumberfrom		fin_documentnumber,
	@documentnumberto		fin_documentnumber,
	@fb 					fin_financebookid,
	@guid					fin_guid,
	@supplier_code			fin_suppliercode,
	@Project_code           fin_projectcode, ------Code added by thyagaraj for 14H109_ACAP_00003	
	@m_errorid 				fin_int	output 
as
begin
	set nocount on

	declare @doctype_tmp      fin_documenttype,
	        @loid_tmp         fin_buid,
	        @companycode_tmp  fin_companycode,
	        @currencycodeml   fin_currencycode,
	        @accountcodeml    fin_accountcode,
	        @errorid_tmp      fin_int,
	        @today            fin_date,
	        @guidis_tmp       fin_guid,
	        @errormsg_tmp     fin_desc255,
			@supp_code		  fin_suppliercode /* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 */
			--code added for ES_ACAP_00524 starts
			,@pps_flag		  fin_flag , 
			@pte			  fin_accounttype,
			@pds			  fin_accounttype
			,@base_curr		  fin_currencycode		--ES_ACAP_00695			
			--code added for ES_ACAP_00524 ends
			
	-- @m_errorid should be 0 to indicate success
	select 	@m_errorid = 0
	
	select 	@ctxt_service = ltrim(rtrim(@ctxt_service))
	select 	@ctxt_user = ltrim(rtrim(@ctxt_user))
	select 	@doctype = ltrim(rtrim(@doctype))
	select 	@documentdateto = ltrim(rtrim(@documentdateto))
	select 	@documentdatefrom = ltrim(rtrim(@documentdatefrom))
	select 	@documentnumberfrom = ltrim(rtrim(@documentnumberfrom))
	select 	@documentnumberto = ltrim(rtrim(@documentnumberto))
	select 	@supplier_code = ltrim(rtrim(@supplier_code))	
	
	if 	@ctxt_language = -915
	    select 	@ctxt_language = null
	
	if 	@ctxt_ouinstance = -915
	    select 	@ctxt_ouinstance = null
	
	if 	@ctxt_service = '~#~'
	    select 	@ctxt_service = null
	
	if 	@ctxt_user = '~#~'
	    select 	@ctxt_user = null
	
	if 	@doctype = '~#~'
	    select 	@doctype = null
	
	if 	@documentdatefrom = '1/1/1900'
	    select 	@documentdatefrom = '1/1/1900'
	
	if 	@documentdateto = '1/1/1900'
	    select 	@documentdateto = '1/1/2100' 
	
	if 	@documentnumberfrom = '~#~'
	    select 	@documentnumberfrom = null
	
	if 	@documentnumberto = '~#~'
	    select 	@fb = ltrim(rtrim(@fb))
	if 	@fb = '~#~'
	    select 	@fb = null
	if 	@guid = '~#~'
	    select 	@guid = null
	
	if 	@supplier_code = '~#~'
	    select 	@supplier_code = null
	
	
	select 	@today		= dbo.RES_Getdate(@ctxt_ouinstance),
			@supp_code	= @supplier_code /* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 */
	
	select 	@loid_tmp = lo_id,
			@companycode_tmp = company_code
	from   	emod_lo_bu_ou_vw(nolock)
	where	ou_id 	= @ctxt_ouinstance

	--ES_ACAP_00695
	select @base_curr = currency_code
	from emod_basecurr_vw(nolock)
	where flag =	'B'
	and  company_code = @companycode_tmp
	--ES_ACAP_00695
	
	select 	@doctype_tmp = parameter_code
	from   	fin_quick_code_met(nolock)
	where	component_id 	= 'ACAP'
	and		parameter_type 	= 'CBO'
	and		parameter_category 	= 'DOC_TYP'
	and		language_id 	=@ctxt_language
	and		parameter_text 	= @doctype

	--code added for ES_ACAP_00524 starts
	select @pps_flag = flag_yes_no
	from PPS_FEATURE_LIST(nolock)
	where Component_Name	 = 'ACAP'
	and   Feature_Id		 = 'PPS_ACAP_0001'
	
	select @pps_flag = ISNULL(@pps_flag,'NO')
	
	if @pps_flag = 'NO'
	begin
			select @pte = 'PTE'
			select @pds = 'PDS'
	end
	else
	begin
			select @pte = ''
			select @pds = ''	
	end
	--code added for ES_ACAP_00524 ends
	
	
	
    /*Code added for DTS ID: 9H123-1_ACAP_00011 starts here*/

    if (@doctype_tmp = 'PM_MI')
   begin
        exec fin_german_raiserror_sp 'ACAP',@ctxt_language,1000
     return 
    end
    /*Code added for DTS ID: 9H123-1_ACAP_00011 ends here*/	
	
	select 	@currencycodeml = currency_code
	from   	emod_basecurr_vw(nolock)
	where	company_code 	= @companycode_tmp
	and		flag 	= 'B'
	
	--EPE-46265 starts
	if @ctxt_user not like '%_API'  
	begin 
	--select 'test'
	delete	
	from	acap_doc_dtl_tmp
	where  	guid = @guid
	
	declare @charcount fin_int  
	select @charcount = charindex('_API',@ctxt_user)  
	select @ctxt_user = substring(@ctxt_user,0,@charcount)  
	end  
	--EPE-46265 ends


	select 	@supplier_code = replace(upper(isnull(@supplier_code, '')), '*', '%') + '%'
	
	if 	@doctype_tmp is null
	or 	@doctype_tmp = ''
	or 	@doctype_tmp = 'All'
	begin
			/* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 starts */
			 If @supp_code is null
			 Begin 
			/* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 Ends */
				;
				/* Code modified by Swetha for  ACAPDMS412AT_000562 on 23/10/2006 */
				with SQLTMP(tmpCol) as (
					select 	distinct C.destinationouinstid
	             			/* Code modified by Swetha for  ACAPDMS412AT_000562 on 23/10/2006 */
					from   	--si_acct_info_dtl A(nolock),--code commented for IHH-551
	          			acap_cim_intxn_model_vw c(nolock)
					where	C.sourceouinstid 	= @ctxt_ouinstance
					and		C.sourcecomponentname 	= 'ACAP'
					--and		C.destinationcomponentname 	= A.component_id--code commented for IHH-551
					and		C.destinationcomponentname in ('SDIN','SIN','SNP','SCDN','SPY')--code added for IHH-551
				), 
			    
				SQLTMP1(tmpCol) as (
					select 	SQL2K51.tax_account_type
					from   	tset_acct_cat_map_vw SQL2K51(nolock)
				)
			    
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
					Project_code ---Code added by thyagaraj for 14H109_ACAP_00003
					 ,cost_center,	--EPE-2039
					rate,			--EPE-2039
					quantity		--EPE-2039
				  )
				select 	@guid,
	 				A.tran_ou,
	    				A.fb_id,
	    				A.tran_no,
	    				A.tran_type,
	    				abs(
	    					sum(
	    						isnull(A.base_amount, 0) * case 
	    														when drcr_flag = 'DR' then 1
	    														else - 1
	    												   end
	    					)
	    				) - b.capitalized_amount,
	    				A.tran_date,

	    				A.supplier_code,
	    				abs(
	    					sum(
	    						isnull(A.base_amount, 0) * case 
	    														when drcr_flag = 'DR' then 1
	    														else - 1
	    												   end
	    					)
	    				),
	    				isnull(A.base_currency,@base_curr),--ES_ACAP_00695
	    				A.exchange_rate,
	    				abs(
	    					sum(
	    						isnull(A.base_amount, 0) * case 
	    														when drcr_flag = 'DR' then 1
	    														else - 1
	    												   end
	    					)
	    				) - b.capitalized_amount,
	   				b.line_no,
	    				'NC',
	    				A.account_code,
	    				C.Project_code------Code added by thyagaraj for 14H109_ACAP_00003
	    				 ,null,				--EPE-2039
						 unit_price,--rate_per,			--EPE-2039
						 item_qty			--EPE-2039

				from   	si_line_detail_vw B(nolock),
						si_doc_hdr_vw C(nolock),--14H109_ACAP_00003
	           			si_acct_info_dtl A(nolock) join 
	    				SQLTMP
				on  	(A.tran_ou = SQLTMP.tmpCol) left outer join 
	    				SQLTMP1
				on  	(A.account_type = SQLTMP1.tmpCol)
				where	A.tran_ou 	= b.tran_ou
				and		A.tran_type 	= b.tran_type
				and		A.tran_no 	= b.tran_no
				--CODE added for 14H109_ACAP_00003 starts
				AND		A.tran_ou 	= C.tran_ou
				and		A.tran_type 	= C.tran_type
				and		A.tran_no 	= C.tran_no
				--CODE added for 14H109_ACAP_00003 ends
				/*Code Modified By Indira G For defect id:ES_ACAP_00774 starts */
				/* Code Modified by Uma for the defect id: ES_ACAP_00116 Starts here*/
				--ES_ACAP_00902
				/*
				--and    	A.line_no 	= b.line_no   --ES_ACAP_00855
				/*Code Modified By Prakash V For defect id:ES_SNP_00808 starts */
				/*Code Modified By Indira G For defect id:ES_ACAP_00315 starts */
				and  	A.line_no 		= case 	when A.tran_type = 'PM_SPV' 	then 	A.line_no --ES_ACAP_00855
	
			----and  	A.line_no 		= case 	when isnull(b.line_no,'') in ('') 	then 	A.line_no 
				--/*Code Modified By Prakash V For defect id:ES_SNP_00808 ENds */
				 --ES_ACAP_00855
									else 	b.line_no  
									end
				  --ES_ACAP_00855
				/*Code Modified By Indira G For defect id:ES_ACAP_00315 Ends */
				/* Code Modified by Uma for the defect id: ES_ACAP_00116 Ends here*/
				/*Code Modified By Indira G For defect id:ES_ACAP_00774 Ends */
				*/
				and    	A.line_no 	= b.line_no
				--ES_ACAP_00902
	
			and		A.fb_id like @fb
				and		A.fb_id	=	c.fb_id	--ES_ACAP_00692

				and		(
	       					(
	       						 
							/*code commented and added for Defect Id:- GMKPSS-151 starts here*/
				--					convert(nchar(10), A.tran_date, 101)
				--					between isnull(@documentdatefrom, A.tran_date) 
				--					and isnull(@documentdateto, A.tran_date)
								convert(nchar(10), C.tran_date, 101) 
								between isnull(@documentdatefrom, C.tran_date) 
	       						and isnull(@documentdateto, C.tran_date)
							/*code commented and added for Defect Id:- GMKPSS-151 ends here*/
	       					)
	       				)
				and		isnull(A.supplier_code, @supplier_code) like @supplier_code
				 and  isnull(c.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
				and		(
	       					(
	       						A.tran_no between isnull(@documentnumberfrom, A.tran_no) 
	       						and isnull(@documentnumberto, A.tran_no)
	       					)
	       				) 
	       				/* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */
	       				--A.component_id in ('SDIN','SIN','SNP','SCDN')
				and		A.tran_type 	in ('PM_PI', 'PM_EV', 'PM_IV', 'PM_SPV', 'PM_SCA', 'PM_SCI','PM_PV')--,'PM_MI')--Added for DTS ID: 9H123-1_ACAP_00001--9H123-1_ACAP_00011--9H123-1_ACAP_00015
	       				/* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */
				and		b.cap_doc_flag <> 'CI'
				--and		A.tran_type not in ('PM_SDI', 'PM_SDA')--code commented for IHH-551
				and		SQLTMP1.tmpCol is null
				/*Code modified by Damodharan. R on 10/06/2010 for Defect ID ES_ACAP_00146 starts here*/
				--and		A.account_type not in ('PDS', 'PTE', 'SCA', 'BCA') -- Code modified by Uma for the bug id : ES_ACAP_00007
				--and		A.account_type not in ('PDS', 'PTE', 'SCA', 'BCA','CQVA', 'ROF')	--Code Modified By Indira.G for Defect id:ES_ACAP_00518 --commented for ES_ACAP_00524
				and			A.account_type not in (@pds, @pte, 'SCA', 'BCA','CQVA', 'ROF','CSH','CPVA','DPVA'/*code added for ES_ACAP_00859*/) --code added for ES_ACAP_00524 --code added for the ITS id:ES_ABB_04450--CIE-1130
				/*Code modified by Damodharan. R on 10/06/2010 for Defect ID ES_ACAP_00146 ends here*/
				and		row_type <> 'TCD'
				and		C.doc_status <> 'RVD'--Code added by Ashok V for the defect id: ES_ACAP_00884
				and		A.base_amount > 0				
				group by
					   A.tran_ou, A.fb_id, A.tran_type, A.tran_no, b.line_no, b.proposal_no, A.tran_date, A.supplier_code, A.base_currency, A.exchange_rate, b.capitalized_amount, A.account_code,C.Project_code-------------Code added by thyagaraj for 14H109_ACAP_00003
						,unit_price,--rate_per
						item_qty --EPE-2039
				/*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/
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
				
		/*code added for EP-915 starts*/
		if isnull(@Project_code,'%') ='%'
		begin
		/*code added for EP-915 ends*/
				/*code added for EPE-2039 ends*/
				--code for EPE-14158 begins here
				;
				with SQLTMP(tmpCol) as (
					select 	distinct A.destinationouinstid
					from   	acap_cim_intxn_model_vw A(nolock)
					where	A.sourceouinstid 			= @ctxt_ouinstance
					and		A.sourcecomponentname 		= 'ACAP'
					and		A.destinationcomponentname 	= 'STKISSUE'
				)
				
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
					Project_code 
					,cost_center,	
					--rate,			

					quantity		
				  )
				select 	@guid,
	    				imh_ouinstid,
	    				imh_posting_fb,
	    				imh_issue_no,
	    				'INV_MMIS',
	    				isnull(d.pending_cap_amount,imd_issue_value),
	  					imh_issue_date,
	    				null,
	    				(isnull(imd_issue_value,0)),
	    				null,
	    				null,
	  					(isnull(d.capitalized_amount,0)),	--sum(isnull(base_amount,0)),
	    				imd_line_no,
	    				'NC',
	    				imd_dr_account_code,
	    				null,---iih_ProjectCode 
	    				imd_cost_center,	
	    				imd_issue_qty						 	
				from   	issue_mnt_detail	d	(nolock),
	           			issue_mnt_header	h   (nolock) join 
	    				SQLTMP
				on  	(h.imh_ouinstid = SQLTMP.tmpCol) 
				where	imh_issue_no 	= imd_issue_no
				and		imh_ouinstid 	= imd_ouinstid
				and		h.imh_posting_fb like @fb
				and		(
	       					(
	       						h.imh_issue_date between isnull(@documentdatefrom, h.imh_issue_date) and isnull(@documentdateto, h.imh_issue_date)
	       					)
	       				)
				and		(
	       					(
	       						h.imh_issue_no between isnull(@documentnumberfrom, h.imh_issue_no) and isnull(@documentnumberto, h.imh_issue_no)
	       					)
	       				)
				and		h.imh_status 	= 'AU'
				 --and  isnull(iih_ProjectCode, '') like @Project_code
				group by
					   imh_ouinstid, imh_posting_fb, imh_issue_no, imh_issue_date, imd_line_no, imd_dr_account_code,imd_cost_center,imd_issue_qty 
					   ,d.pending_cap_amount,imd_issue_value,capitalized_amount

		end--code added for EP-915
			/*code added for EPE-14158 ends*/
		
			
	--EDS-44 starts
				;
				with SQLTMP(tmpCol) as (
					select 	distinct A.destinationouinstid
					from   	acap_cim_intxn_model_vw A(nolock)
					where	A.sourceouinstid 	= @ctxt_ouinstance
					and		A.sourcecomponentname 	= 'ACAP'
					and		A.destinationcomponentname 	= 'STKISSUE'
				)
				--EDS-44 ends
				/*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/
				
			    
				/*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Starts here*/
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
					Project_code ----Code added by thyagaraj for 14H109_ACAP_00003
					,cost_center,	--EPE-2039
					--rate,			--EPE-2039 --EDS-44
					quantity		--EPE-2039
				  )
				select 	@guid,
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
	    				'NC',
	    				iid_dr_account_code,
	    				iih_ProjectCode ----Code added by thyagaraj for 14H109_ACAP_00003
	    				,iid_cost_center,	--EPE-2039
	    				 iid_issue_qty		--EPE-2039
				from   	issue_inv_detail d(nolock),
	           			issue_inv_header h(nolock) join 

	    				SQLTMP
				on  	(h.iih_ouinstid = SQLTMP.tmpCol) --Code Added by Angelin.R for the Bug : 8H123-2_ACAP_00048
				where	iid_issue_no 	= iih_issue_no
				and		iid_ouinstid 	= iih_ouinstid
				and		h.iih_posting_fb like @fb
				and		(
	       					(

	       						h.iih_issue_date between isnull(@documentdatefrom, h.iih_issue_date) and isnull(@documentdateto, h.iih_issue_date)
	       					)
	       				)
				and		(
	       					(
	       						h.iih_issue_no between isnull(@documentnumberfrom, h.iih_issue_no) and isnull(@documentnumberto, h.iih_issue_no)
	       					)
	       				)
				and		h.iih_status 	= 'AU'
				and		iih_mr_type <> 'C'
				 and  isnull(iih_ProjectCode, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003 
				group by
					   iih_ouinstid, iih_posting_fb, iih_issue_no, iih_issue_date, iid_line_no, iid_dr_account_code,iih_ProjectCode --Code added by thyagaraj for 14H109_ACAP_00003
					   ,iid_cost_center,iid_issue_qty --EDS-44				

			/*code added for EBS-2581 starts*/
			 ;	 
			 with SQLTMP(tmpCol) as (  
									select  distinct C.destinationouinstid 
									from    acap_cim_intxn_model_vw c(nolock)  
									where C.sourceouinstid			= @ctxt_ouinstance  
									and  C.sourcecomponentname		= 'ACAP'    

									and  C.destinationcomponentname =  'JV'  
									) 

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
			 Project_code  
			 ,cost_center,	
			rate,		
			quantity		
			  )  
			select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,dtl.base_amount)) ,hdr.voucher_date,null,
					sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
					dtl.voucher_serial_no,'NC',dtl.account_code,/*null*/hdr.Project_code
,null,null,null  --NSAPL-3339
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
			and		hdr.voucher_status  = 'AUT' 
			and		isnull(hdr.Project_code,'')   like @Project_code --NSAPL-3339
			and		hdr.voucher_type    not in ('REV','TAX')--code added for EBS-2752
			and		dtl.drcr_flag		= 'DR'
			and		isnull(dtl.pending_cap_amount,dtl.base_amount) >0
			--and		isnull(dtl.capitalized_amount,0) = 0
			and		hdr.proposal_number is null 
			and		dtl.proposal_number is null 
			and		not exists ( select 'X' from ard_addn_account_mst mst (nolock),
												
			ard_interfb_usage_met met (nolock)
								where	mst.company_code 	= @companycode_tmp 
								and		mst.fb_id			= hdr.fb_id
								and		mst.account_code	= dtl.account_code
								and		mst.usage_id		= met.usage_id
								)
			group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
					dtl.tran_currency,dtl.exchange_rate,
					dtl.voucher_serial_no,dtl.account_code,hdr.Project_code --NSAPL-3339
			/*
			union 
			select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,0)) ,hdr.voucher_date,null,
					sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
					dtl.voucher_serial_no,'NC',dtl.account_code,null,null,null,null  
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
			and		hdr.voucher_status  = 'AUT'
			and		dtl.drcr_flag		= 'DR'
			and		isnull(dtl.pending_cap_amount,0) <> 0
			--and		isnull(dtl.capitalized_amount,0) <> 0
			and		hdr.proposal_number is null 
			and		dtl.proposal_number is null 
			group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
					dtl.tran_currency,dtl.exchange_rate,
					dtl.voucher_serial_no,dtl.account_code
			*/
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
			/*code added for EBS-2581 ends*/
				
				/* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 starts */
				
				--code added for the dts id 13H120_General_00032 ;13H120_ACAP_00002 starts 
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
						select 	@guid,
	    							wo_ouinstance,
	    							wo_finbkid,
	    							wo_code,
	    							'EAM_WGDIR', 
	    							sum(isnull(wo_pencapitalisation_amt,0)),
	  								wo_date,
	    							null,
	    							sum(isnull(wo_tot_act_cost_of,0)),
	    							null,
	    							null,
	  								sum(isnull(wo_pencapitalisation_amt,0)),
	    							wo_lineno,
	    							'NC',
	    							wo_account_code ,
	    							null  ----Code added by thyagaraj for 14H109_ACAP_00003

	    							,/*null*/womain_cost_center_code,		--EPE-2039  --check --HAL-773
	    							null,		--EPE-2039	--check
	    							null		--EPE-2039	--check
							from   eam_workorder_cost_detail h(nolock) join 
	    							SQLTMP
							on  	(h.wo_ouinstance = SQLTMP.tmpCol)
							--code added for 14H109_ACAP_00041 starts
							inner join Eam_WoMain_Workorder_Hdr hdr(nolock)
							on		(		h.wo_code				=	hdr.womain_wo_code
										and	h.wo_ouinstance			=	hdr.womain_wo_ouinstance
									)
							and		isnull(hdr.womain_proposal_id,'')	=	''
							--code added for 14H109_ACAP_00041 ends
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
								   wo_ouinstance, wo_finbkid, wo_code, wo_date, wo_lineno, wo_account_code,womain_cost_center_code --HAL-773
						end
						--code added for the dts id 13H120_General_00032 ;13H120_ACAP_00002 ends
				End
				else
				Begin 

			
						;
						WITH SQLTMP (tmpCol) as
						(SELECT  distinct C.destinationouinstid
						FROM 	si_acct_info_dtl A(NOLOCK) ,
								acap_cim_intxn_model_vw c (NOLOCK) 
						WHERE 	C.sourceouinstid 			= @ctxt_ouinstance 
						and   	C.sourcecomponentname 		= 'ACAP' 
						and		C.destinationcomponentname 	= A.component_id 
						), 
						SQLTMP1 (tmpCol) as 
						(SELECT  SQL2K51.tax_account_type
						FROM tset_acct_cat_map_vw SQL2K51 (NOLOCK) 
						)
						INSERT INTO acap_doc_dtl_tmp(guid, ou_id, fb_id, doc_number, doc_type,
						pending_cap_amount, 
						tran_date, supplier_code, 
						doc_amount, 
						tran_currency, exchange_rate, 
						cap_amount, 
						line_no, cap_flag, account_code,Project_code ---Code added by thyagaraj for 14H109_ACAP_00003
						,cost_center,	--EPE-2039
						rate,			--EPE-2039
						quantity		--EPE-2039
						) 
						SELECT  @guid ,  A.tran_ou ,  A.fb_id ,  A.tran_no , A.tran_type , 
						abs(SUM (ISNULL (A.base_amount , 0) * CASE 	WHEN  drcr_flag = 'DR'
											THEN 1	ELSE - 1 END)) - b.capitalized_amount , 
						A.tran_date , A.supplier_code , 
						abs(SUM (ISNULL (A.base_amount , 0) * CASE 	 WHEN  drcr_flag = 'DR'
											 THEN 1 ELSE - 1 END)) , 
						  isnull(A.base_currency,@base_curr) , A.exchange_rate ,	--ES_ACAP_00695
						abs(SUM (ISNULL (A.base_amount , 0) * CASE   WHEN  drcr_flag = 'DR'
											 THEN 1 ELSE - 1 END)) - b.capitalized_amount , 
						 b.line_no ,  'NC' ,  A.account_code, C.Project_code ------------Code added by thyagaraj for 14H109_ACAP_00003
	
					  ,null,			--EPE-2039
						 unit_price,--rate_per,			--EPE-2039
						 item_qty			--EPE-2039
						FROM    si_line_detail_vw B (NOLOCK) ,
								si_doc_hdr_vw C(nolock),--14H109_ACAP_00003
								 si_acct_info_dtl A (NOLOCK) JOIN 
						SQLTMP  
	
					ON		(A.tran_ou = SQLTMP.tmpCol) 
						LEFT OUTER JOIN 
						SQLTMP1 
						 ON		(A.account_type = SQLTMP1.tmpCol )
						WHERE   A.tran_ou 	= b.tran_ou 
						and    	A.tran_type = b.tran_type
						and    	A.tran_no 	= b.tran_no 
						--CODE added for 14H109_ACAP_00003 starts
						AND		A.tran_ou 	= C.tran_ou
						and		A.tran_type 	= C.tran_type
						and		A.tran_no 	= C.tran_no
						--CODE added for 14H109_ACAP_00003 ends
						and    	A.line_no 	= b.line_no 
						and    	A.fb_id 	like @fb 
	
					and    (( CONVERT (NCHAR (10) ,A.tran_date,101) 
												BETWEEN ISNULL (@documentdatefrom,A.tran_date) 
												AND		ISNULL (@documentdateto,A.tran_date) )) 
						and 	A.supplier_code like			 @supplier_code 
					 and  isnull(C.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
						and 	(( A.tran_no 	BETWEEN ISNULL (@documentnumberfrom,A.tran_no) 
												AND		ISNULL (@documentnumberto,A.tran_no) )) 
						and		A.tran_type 	in		('PM_PI','PM_EV','PM_IV','PM_SPV','PM_SCA','PM_SCI')
						and   	b.cap_doc_flag 	<>		'CI' 
						and   	A.tran_type 	not in	('PM_SDI','PM_SDA') 
						and   	SQLTMP1.tmpCol 	IS NULL 
						--and   	A.account_type 	not in ('PDS','PTE','SCA','BCA', 'ROF') --Code Modified By Indira.G for Defect id:ES_ACAP_00518 -- commented for ES_ACAP_00524
						and			A.account_type not in (@pds, @pte, 'SCA', 'BCA','CQVA', 'ROF','CSH','CPVA','DPVA'/*code added for ES_ACAP_00859*/) --code added for ES_ACAP_00524--code added for the ITS id:ES_ABB_04450--CIE-1130
						and   	row_type 		<>	'TCD' 
						and		C.doc_status	<>  'RVD'--Code added by Ashok V for the defect id: ES_ACAP_00884
						and   	A.base_amount 	>		0 
						GROUP BY A.tran_ou , A.fb_id , A.tran_type, A.tran_no , b.line_no , b.proposal_no , 	
								A.tran_date , A.supplier_code , A.base_currency , A.exchange_rate , b.capitalized_amount , 
								A.account_code, C.Project_code ----Code added by thyagaraj for 14H109_ACAP_00003\
								 ,unit_price,--rate_per,	 -- EPE-2039
				
				 item_qty	 -- EPE-2039
								
						
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
				End
				/* Code added by Malinidevi.U for ES_ACAP_00117 on 18/01/2010 Ends */

				delete	
				from	acap_doc_dtl_tmp
				where  	guid = @guid
				and    	pending_cap_amount = 0
	           			/*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/
			end	
	else
	begin

		
	    ;
	    /* Code modified by Swetha for  ACAPDMS412AT_000562 on 23/10/2006 */
	    with SQLTMP(tmpCol) as (
	        select 	distinct C.destinationouinstid
	               	/* Code modified by Swetha for  ACAPDMS412AT_000562 on 23/10/2006 */
	        from   	acap_cim_intxn_model_vw c(nolock)
	        where	C.sourceouinstid 	= @ctxt_ouinstance
	        and		C.sourcecomponentname 	= 'ACAP' 
	           		/* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */
	        and		C.destinationcomponentname 	= case @doctype_tmp
	           		                           
	       when 'PM_PI' then 'SIN'
													   --when 'PM_MI' then 'SIN'--Modified for DTS ID:9H123-1_ACAP_00001--9H123-1_ACAP_00011
	           		                           	       when 'PM_EV' then 'SDIN'
	           		                           	       when 'PM_IV' then 'SDIN'
	           		                           	       when 'PM_SPV' then 'SNP'
	           		                           	       when 'PM_PV' then 'SPY'
	           		                           	       when 'PM_SCA' then 'SCDN'
	     
      		                           	       when 'PM_SCI' then 'SCDN'
								                  	  end
	    ), 
	    /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */
	    SQLTMP1(tmpCol) as (
	        select 	SQL2K51.tax_account_type
	  
      from   	tset_acct_cat_map_vw SQL2K51(nolock)
	    )
	    
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
	        Project_code ----Code added by thyagaraj for 14H109_ACAP_00003
	       ,cost_center,
	--EPE-2039
			rate,			--EPE-2039
			quantity		--EPE-2039
	      )
	    select 	@guid,
	    		A.tran_ou,
	    		A.fb_id,
	    		A.tran_no,
	    		A.tran_type,
	    		abs(
	    		    sum(
	    		   isnull(A.base_amount, 0) * case 
	    		                  
                      when drcr_flag = 'DR' then 1
	    		                                    else - 1
	    		         end
	    		    )
	    		) - b.capitalized_amount,
	    		A.tran_date,
	    		A.supplier_code,
	    		abs(
	   
 		    sum(
	    		        isnull(A.base_amount, 0) * case 
	    		       when drcr_flag = 'DR' then 1
	    		                  else - 1
	    		                                   end
	    		    )
	    		),
	 			isnull(A.base_currency,@base_curr),--ES_ACAP_00695
	    		A.exchange_rate,
	    		abs(
	    		    sum(
	    		        isnull(A.base_amount, 0) * case 
	    		                                        when drcr_flag = 'DR' then 1
	    		                                        else - 1
	    		         
                 end
	    		    )
	    		) - b.capitalized_amount,
	    		b.line_no,
	    		'NC',
	 		A.account_code,
	    		C.Project_code ---Code added by thyagaraj for 14H109_ACAP_00003
	    		 ,null,				--EPE-2039
				 unit_price,--rate_per,			--EPE-2039
				 item_qty			--EPE-2039
	    from   	si_line_detail_vw B(nolock),
				si_doc_hdr_vw C(nolock),--14H109_ACAP_00003
	           	si_acct_info_dtl A(nolock) join 
	    		SQLTMP
	    on  	(A.tran_ou = SQLTMP.tmpCol) left outer join 
	    		SQLTMP1
	   
 on  	(A.account_type = SQLTMP1.tmpCol)
	    where	A.tran_ou 	= b.tran_ou
	    and		A.tran_type 	= b.tran_type
	    and		A.tran_no 	= b.tran_no
		--CODE added for 14H109_ACAP_00003 starts
		AND		A.tran_ou 	= C.tran_ou
		and		A.tran_type 	= C.tran_type
		and		A.tran_no 	= C.tran_no
		--CODE added for 14H109_ACAP_00003 ends
		/*Code Modified By Indira G For defect id:ES_ACAP_00774 starts */
		/* Code Modified by Uma for the defect id: ES_ACAP_00116 Starts here*/
		--ES_ACAP_00902
		/*
		--and    	A.line_no 
	= b.line_no --ES_ACAP_00855
		/*Code Modified By Prakash V For defect id:ES_SNP_00808 starts */
		/*Code Modified By Indira G For defect id:ES_ACAP_00315 starts */
		and  	A.line_no 		= case 	when @doctype_tmp = 'PM_SPV' 	then 	A.line_no  --ES_ACAP_00855

		----and  	A.line_no 		= case 	when isnull(b.line_no,'') in ('') 	then 	A.line_no 
		--/*Code Modified By Prakash V For defect id:ES_SNP_00808 Ends */ 
		--ES_ACAP_00855
						else 	b.line_no 
						end
		--ES_ACAP_00855
		*/
		and    	A.line_no 	= b.line_no 
		--ES_ACAP_00902
		/*Code Modified By Indira G For defect id:ES_ACAP_00315 Ends */
		/* Code Modified by Uma for the defect id: ES_ACAP_00116 Ends here*/
		/*Code Modified By Indira G For defect id:ES_ACAP_00774 Ends */
	    and		A.fb_id like @fb

	    and		A.fb_id		=	c.fb_id	--ES_ACAP_00692
	    and		(
	       		    (
	       		        convert(nchar(10), A.tran_date, 101) 
	       		        between isnull(@documentdatefrom, A.tran_date) 
	       		        and isnull(@documentdateto, A.tran_date)
	
       		    )
	       		)
		and		isnull(A.supplier_code, /*@supplier_code*/'') like @supplier_code --code modified by Malinidevi.U for ES_ACAP_00117 on 22/02/2010
	    and  isnull(C.Project_code, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
	    and		(
	       		    (
	       		        A.tran_no between isnull(@documentnumberfrom, A.tran_no) 
	       		        and isnull(@documentnumberto, A.tran_no)
	       		    )
	       		) 
	       		--A.component_id = @doctype_tmp 
	   
    		/* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */
	    and		A.tran_type 	= @doctype_tmp
	   		/* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */
		and		b.cap_doc_flag <> 'CI'
	    and		A.tran_type not in ('PM_SDI', 'PM_SDA')
	    and		SQLTMP1.tmpCol is null
		/*Code modified by Damodharan. R on 10/06/2010 for Defect ID ES_ACAP_00146 starts here*/
	    --and		A.account_type not in ('PDS', 'PTE', 'SCA', 'BCA') -- Code modified by Uma for the bug id : ES_ACAP_00007
		
--and		A.account_type not in ('PDS', 'PTE', 'SCA', 'BCA','CQVA', 'ROF')	--Code Modified By Indira.G for Defect id:ES_ACAP_00518 --commented for ES_ACAP_00524
		and			A.account_type not in (@pds, @pte, 'SCA', 'BCA','CQVA', 'ROF','CPVA','DPVA') --code added for ES_ACAP_00524--code added for the ITS id:ES_ABB_04450--CIE-1130
		/*Code modified by Damodharan. R on 10/06/2010 for Defect ID ES_ACAP_00146 starts here*/
	    and		row_type <> 'TCD'
	    and		C.doc_status <> 'RVD'--Code added by Ashok V for the defect id: ES_ACAP_00884
	    and		A.base_amount > 0
	    group by
	           A.tran_ou, A.fb_id, A.tran_type, A.tran_no, b.line_no, b.proposal_no, A.tran_date, A.supplier_code, A.base_currency, A.exchange_rate, b.capitalized_amount, A.account_code,C.Project_code
				,unit_price,--rate_per,	 -- EPE-2039
				 item_qty	 -- EPE-2039
	    /*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Starts here*/
	    
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
		and		A.account_type not in (@pds, @pte, 'SCA', 'BCA','CQVA', 'ROF','CPVA') --code added for NSAPL-3311
		--EP-93	

		
/*code added for EPE-2039 ends*/
		
		--code for EPE-14158 begins here
		if 	@doctype_tmp = 'INV_MMIS' --and @supp_code is null --EPE-14525
	    begin	
				;
				with SQLTMP(tmpCol) as (
					select 	distinct A.destinationouinstid
					from   	acap_cim_intxn_model_vw A(nolock)
					where	A.sourceouinstid 			= @ctxt_ouinstance
					and		A.sourcecomponentname 		= 'ACAP'
					and		A.destinationcomponentname 	= 'STKISSUE'
				)
				
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
					Project_code 
					,cost_center,	
		
			--rate,			
					quantity		
				  )
				select 	@guid,
	    				imh_ouinstid,
	    				imh_posting_fb,
	    				imh_issue_no,
	    				'INV_MMIS',
	    				isnull(d.pending_cap_amount,imd_issue_value),
	  					imh_issue_date,
	    				null,
	    				(isnull(imd_issue_value,0)),
	    				null,
	    				null,
	  					(isnull(d.capitalized_amount,0)),
	    				imd_line_no,
	    				'NC',
	    				imd_dr_account_code,
	    				null,---iih_ProjectCode 
	    				imd_cost_center,	
	    				imd_issue_qty						 
	
				from   	issue_mnt_detail	d	(nolock),
	           			issue_mnt_header	h   (nolock) join 
	    				SQLTMP
				on  	(h.imh_ouinstid = SQLTMP.tmpCol) 
				where	imh_issue_no 	= imd_issue_no
				and		imh_ouinstid 	= imd_ouinstid
				and		h.imh_posting_fb like @fb
				and		(
	       					(
	       						h.imh_issue_date between isnull(@documentdatefrom, h.imh_issue_date) and isnull(@documentdateto, h.imh_issue_date)
	       					)
	       				)
				and		(
	       					(
	       						h.imh_issue_no between isnull(@documentnumberfrom, h.imh_issue_no) and isnull(@documentnumberto, h.imh_issue_no)
	       					)
	       				)
				and		h.imh_status 	= 'AU'
				 --and  isnull(iih_ProjectCode, '') like @Project_code 
				group by
					   imh_ouinstid, imh_posting_fb, imh_issue_no, imh_issue_date, imd_line_no, imd_dr_account_code,imd_cost_center,imd_issue_qty 
					   ,imd_issue_value,pending_cap_amount,capitalized_amount
			end
			/*code added for EPE-14158 ends*/
		
	    if 	@doctype_tmp = 'INV_IMIS' and @supp_code is null  --code modified by Malinidevi.U for ES_ACAP_00117 on 22/02/2010
	    begin
	        /*Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Starts here*/
	        ;
	        with SQLTMP(tmpCol) as (
	            select 	distinct A.destinationouinstid
	       from   	acap_cim_intxn_model_vw A(nolock)
	            where	A.sourceouinstid 	= @ctxt_ouinstance
	            and		A.sourcecomponentname 	= 'ACAP'
	            and		A.destinationcomponentname 	= 'STKISSUE'
	        ) 
	        /*
Code Added by Angelin.R for the Bug id : 8H123-2_ACAP_00048 Ends here*/
	  
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
	  Project_code ----Code added by thyagaraj for 14H109_ACAP_00003
				,cost_center,	--EPE-2039
				rate,			--EPE-2039
				quantity		--EPE-2039
	          )
	     select 	@guid,
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
	        		'NC',
	        		iid_dr_account_code,

	        		iih_ProjectCode ----Code added by thyagaraj for 14H109_ACAP_00003
					,iid_cost_center,		--EPE-2039
    				iid_issue_value,		--EPE-2039 --check
    				iid_issue_qty			--EPE-2039
	   from   	issue_inv_detail d(nolock),
	               	issue_inv_header h(nolock) join 
	        		SQLTMP
	        on  	(h.iih_ouinstid = SQLTMP.tmpCol) --Code Added by Angelin.R for the Bug : 8H123-2_ACAP_00048
	        where	iid_issue_no 	= iih_issue_no
	        and		iid_ouinstid 	= iih_ouinstid
	        and		h.iih_posting_fb like @fb
	        and		(
	           		    (
	           		        h.iih_issue_date between isnull(@documentdatefrom, h.iih_issue_date) and isnull(@documentdateto, h.iih_issue_date)
	           		    )
	   		)
	        and		(
	           		
    (
	           		        h.iih_issue_no between isnull(@documentnumberfrom, h.iih_issue_no) and isnull(@documentnumberto, h.iih_issue_no)
	           		    )
	     		)
			 and		h.iih_status 	= 'AU'
	        and		iih_mr_type <> 'C'
	         and  isnull(iih_ProjectCode, '') like @Project_code  --Code added by thyagaraj for 14H109_ACAP_00003  
	        group by
	               iih_ouinstid, iih_posting_fb, iih_issue_no, iih_issue_date, iid_line_no, iid_dr_account_code,iih_ProjectCode ---Code added by thyagaraj for 14H109_ACAP_00003
	 				,iid_cost_center,	--EPE-2039
					iid_issue_value,	--EPE-2039
					iid_issue_qty		--EPE-2039	
	 				
	        delete	
	        from	acap_doc_dtl_tmp
	        where  	guid = @guid
	        and    	pending_cap_amount = 0
	
    end	/*Code Added by Angelin.R for the Feature : MS440_GEN_MRBCAP Ends here*/
	     
		 /*code added for EBS-2581 starts*/
		  if 	@doctype_tmp = 'BK_JV' and @supp_code is null  
		  begin
			 ;	 
			 with SQLTMP(tmpCol) as (  
									select  distinct C.destinationouinstid 
									from    acap_cim_intxn_model_vw c(nolock)  
									where C.sourceouinstid			= @ctxt_ouinstance  
									and  C.sourcecomponentname		= 'ACAP'    
									and  C.destinationcomponentname =  'JV'  
									) 

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
			 Project_code  
			 ,cost_center,	
			rate,		
			quantity		
			  )  
			select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,dtl.base_amount)) ,hdr.voucher_date,null,
	
				sum(isnull(dtl.tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
					dtl.voucher_serial_no,'NC',dtl.account_code,/*null*/hdr.Project_code,null,null,null --NSAPL-3339
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
			and		hdr.voucher_status  = 'AUT'
	
		and		isnull(hdr.Project_code,'') like @project_code --NSAPL-3339
			and		hdr.voucher_type    not in ('REV','TAX')--code added for EBS-2752
			and		dtl.drcr_flag		= 'DR'
			and		isnull(dtl.pending_cap_amount,dtl.base_amount) > 0
			--and		isnull(dtl.capitalized_amount,0) = 0
			and		hdr.proposal_number is null
			and		dtl.proposal_number is null 
			and		not exists ( select 'X' from ard_addn_account_mst mst (nolock),
												 ard_interfb_usage_met met (nolock)
								where	mst.company_code 	= @companycode_tmp 
								and		mst.fb_id			= hdr.fb_id
								and		mst.account_code	= dtl.account_code 
								and		mst.usage_id		= met.usage_id
								)
			group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
					dtl.tran_currency,dtl.exchange_rate,
					dtl.voucher_serial_no,dtl.account_code,hdr.Project_code --NSAPL-3339
			/*
			union 
			select  @guid,hdr.ou_id,hdr.fb_id,dtl.voucher_no,'BK_JV',sum(isnull(dtl.pending_cap_amount,0)) ,hdr.voucher_date,null,
					sum(isnull(dtl.
tran_amount,0)),dtl.tran_currency,dtl.exchange_rate,sum(isnull(dtl.capitalized_amount,0)),
					dtl.voucher_serial_no,'NC',dtl.account_code,null,null,null,null  
			from	jv_voucher_trn_dtl dtl(nolock),
					jv_voucher_trn_hdr hdr(nolock)
					join   
				
	   SQLTMP  
			on   (hdr.ou_id = SQLTMP.tmpCol)
			where	hdr.ou_id		= dtl. ou_id
			and		hdr.voucher_no	= dtl.voucher_no
			and		hdr.fb_id		like @fb
			and		hdr.voucher_no  between isnull(@documentnumberfrom, hdr.voucher_no) and isnull(@documentnumberto,
 hdr.voucher_no)  
			and		hdr.voucher_date	 >   = isnull(@documentdatefrom,hdr.voucher_date)  
			and		hdr.voucher_date	 <= isnull(@documentdateto,hdr.voucher_date)  
			and		hdr.voucher_status  = 'AUT'
			and		dtl.drcr_flag		= 'DR'
			and		isnull(dtl.pe
nding_cap_amount,0) <> 0
			and		isnull(dtl.capitalized_amount,0) <> 0
			and		hdr.proposal_number is null 
			and		dtl.proposal_number is null 
			group by hdr.ou_id,hdr.fb_id,dtl.voucher_no,hdr.proposal_number,hdr.voucher_date,
					dtl.tran_currency,dt
l.exchange_rate,
					dtl.voucher_serial_no,dtl.account_code
			*/
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
			/*code added for EBS-2581 ends*/
		
	       --code added for the dts id 13H120_General_00032 ;13H120_ACAP_00002 starts 
		 if 	@doctype_tmp = 'EAM_WGDIR' and @supp_code is null  and @ctxt_service	= 'acapamasesrsrch'
		 begin
  
				;
					with SQLTMP(tmpCol) as (
						select 	distinct A.destinationouinstid
						from 	acap_cim_intxn_model_vw A(nolock)
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
						tran_date,
						supplier_code,
						doc_amount,
						tran_currency,
						exchange_rate,
						cap_amount,
						line_no,
						cap_flag,
						account_code,
						Project_code -----Code added by thyagaraj for 14H109_ACAP_00003
						--,total_docamt
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
  							wo_date,
    						null,
    						sum(isnull(wo_tot_act_cost_of,0)),
    						null,
    						null,
  							sum(isnull(wo_pencapitalisation_amt,0)),
    						wo_lineno,
    						'NC',
  
  						wo_account_code,
    						null ---Code added by thyagaraj for 14H109_ACAP_00003
   						--,sum(isnull(wo_tot_act_cost_of,0))
    						,/*null*/womain_cost_center_code,		--EPE-2039 --HAL-773
    						null,		--EPE-2039
    						null		--EPE-2039

					from   eam_workorder_cost_detail h(nolock) join 
    						SQLTMP
					on  	(h.wo_ouinstance = SQLTMP.tmpCol) 
							--code added for 14H109_ACAP_00041 starts
							inner join Eam_WoMain_Workorder_Hdr hdr(nolock)
							on		(		h.wo_code				=	hdr.womain_wo_code
										and	h.wo_ouinstance			=	hdr.womain_wo_ouinstance
									)
							and		isnull(hdr.womain_proposal_id,'')	=	''
							--code added for 14H109_ACAP_00041 ends

					and		h.wo_finbkid like @fb
					and		h.wo_date between isnull(@documentdatefrom, h.wo_date) and isnull(@documentdateto, h.wo_date)
					and		h.wo_code between isnull(@documentnumberfrom, h.wo_code) and isnull(@documentnumberto, h.wo_code) 
					group by
						   wo_ouinstance, wo_finbkid, wo_code, wo_date, wo_lineno, wo_account_code,womain_cost_center_code --HAL-773
						   
				delete	
				from	acap_doc_dtl_tmp
				where  	guid = @guid
				and    	pending_cap_amount = 0
				
			end
			--code added for the dts id 13H120_General_00032 ;13H120_ACAP_00002 ends
	end

	--Delete the datas which is not in authorized or paid status (status maintained in Paid status column)
	--Both SPY and SNP  should be in PAID status not in Requested status.
	/* Code added by Uma for the bug id : ACAPDMS412AT_000714 starts here*/
	delete	tmp

	from	si_doc_hdr SI(nolock),
			acap_doc_dtl_tmp TMP(nolock)
	where  	guid = @guid
	and    	tran_ou = TMP.ou_id
	and    	tran_type = TMP.doc_type
	and    	tran_type = 'PM_SPV' -- Code added by Uma for the bug id: ES_ACAP_00008
	and    	tran_no = TMP.doc_number
	and    	SI.paid_status not in ('AUT', 'PAD')
	/* Code added by Uma for the bug id : ACAPDMS412AT_000714 ends here*/	

	--Code added by Aparna M. for the 8H123-1_spy_00001 starts
	delete	TMP
	from	si_doc_balance SI(nolock),
			acap_doc_dtl_tmp TMP(nolock)
	where  	guid = @guid
	and    	tran_ou = TMP.ou_id
	and    	tran_type = TMP.doc_type
	and    	tran_type = 'PM_PV'
	and    	tran_no = TMP.doc_number
	and    	SI.adjustment_status = 'PAD'
	and    	pdc_flag = 'Y'
	--Code added by Aparna M. for the 8H123-1_spy_00001 ends

	exec 	@errorid_tmp = ardisspgetusageacc @ctxt_language,
	     	@ctxt_ouinstance,
	     	@ctxt_service,
	     	@ctxt_user,
	     	null,
	     	'CAPRECNCDOCS',
	     	@fb,
	     	@currencycodeml,
	     	@today,
	     	@guidis_tmp out,

	     	@errormsg_tmp out          
	
	
	if 	@errorid_tmp = 0
	begin
	    select 	@accountcodeml = account_code
	    from   	ard_is_account_vw(nolock)
	    where	guid 	= @guidis_tmp
	end	
	/* code commented by swetha for ACAPDMS412AT_000210 on 28/12/2005 
*/
	/*else  
	begin          
	select  @m_errorid    	= 260			     
	return               
	end   */        
	/* code commented by swetha for ACAPDMS412AT_000210 on 28/12/2005 */

	--Code Added by Antoinette for the bug id ES_ACAP_00029 starts here 
	declare @acap_doc_dtl_tmp table
	        (
	            tran_no nvarchar(18),
	            tran_ou numeric(4),
	            tran_type nvarchar(10)
	        )	
	
	if 	exists(
	   	    select 	'X'
	   	    from   	acap_doc_dtl_tmp a(nolock),
	   	           	si_line_detail_vw b(nolock),
	   	           	--po_hdr_vw c(nolock)--code commented for NSAPL-3429
					sin_po_hdr_vw c(nolock)--code added for NSAPL-3429
	   	    where	A.guid 	= @guid
	   	    and		A.ou_id 	= b.tran_ou
	   	    and		A.doc_number 	= b.tran_no
	   	    and		b.tran_type 	= 'PM_PI'--,'PM_MI') --Modified for DTS ID:9H123-1_ACAP_00001--9H123-1_ACAP_00011
	   	    and		b.ref_doc_ou 	= c.po_ou --C.ouinstid--code modified for NSAPL-3429
	   	    and		b.ref_doc_no 	= c.po_number--C.docno--code modified for NSAPL-3429
	   	    and		groption 	= 'Y'
	   	)
	begin
	    insert into @acap_doc_dtl_tmp
	      (
	        tran_no,
	        tran_ou,
	 tran_type
	      )
	 select 	distinct doc_number,
	    		ou_id,
	    		doc_type
	    from   	acap_doc_dtl_tmp a(nolock),
	           	si_line_detail_vw b(nolock),
	           	--po_hdr_vw c(nolock)--code commented for NSAPL-3429
				sin_po_hdr_vw c(nolock)--code added for NSAPL-3429
	    where	A.guid 	= @guid
	 and		A.ou_id 	= b.tran_ou
	    and		A.doc_number 	= b.tran_no
	   	and		b.tran_type 	= 'PM_PI'--,'PM_MI') --Modified for DTS ID:9H123-1_ACAP_00001--9H123-1_ACAP_00011	  
		and		b.ref_doc_ou 	= c.po_ou --C.ouinstid--code modified for NSAPL-3429
	   	and		b.ref_doc_no 	= c.po_number--C.docno--code modified for NSAPL-3429
	    and		groption 	= 'Y'
	end	
	
	if 	exists (
	   	    select 	'X'
	   	    from   	@acap_doc_dtl_tmp
	   	)
	begin
	    delete	A
	    from	acap_doc_dtl_tmp A,
	   		@acap_doc_dtl_tmp B
	    where  	doc_number = tran_no
	    and  	ou_id = tran_ou
	    and    	doc_type = tran_type
	    and    	guid = @guid	
	    --ES_ACAP_00973
	    /*
	    
	    
	    insert into acap_doc_dtl_tmp
	      (
	        guid,
	        ou_id,
	        fb_id,
	        doc_number,
	        doc_type,
	        pendi
ng_cap_amount,
	 tran_date,
	        supplier_code,
	        doc_amount,
	        tran_currency,
	        exchange_rate,
	        cap_amount,
	        line_no,
	        cap_flag,
	        Project_code ----Code added by thyagaraj for 14H109_ACAP_00003
	   
     ,cost_center,	--EPE-2039
			rate,			--EPE-2039
			quantity		--EPE-2039
	      )
	    select 	@guid,
	    		A.tran_ou,
	    		A.fb_id,
	    		A.tran_no,
	    		A.tran_type,
	    		abs(
	    		    sum(
	    		        isnull(A.base_amount, 0) * case 
	 
   		                                        when drcr_flag = 'DR' then 1
	    		                                        else - 1
	    		                                   end
	    		    )
	  		) - b.capitalized_amount,
	    		A.tran_date,
	    		A.suppli
er_code,
	    		abs(
	    		    sum(
	    		        isnull(A.base_amount, 0) * case 
	    		                                        when drcr_flag = 'DR' then 1
	    		        else - 1
	    		                                   end
	    		    )
	    		),
	
    		A.base_currency,
	    		A.exchange_rate,
	    		abs(
	    		    sum(
	    		        isnull(A.base_amount, 0) * case 
	    		          when drcr_flag = 'DR' then 1
	 		                                        else - 1
	    		                          
         end
	    		    )
	    		) - b.capitalized_amount,
	    		b.line_no,
	    		'NC',
	    		C.Project_code -----Code added by thyagaraj for 14H109_ACAP_00003
	    		 ,null,				--EPE-2039
				 rate_per,			--EPE-2039
				 item_qty			--EPE-2039
	  from 
  	si_line_detail_vw B(nolock),
				si_doc_hdr_vw C(nolock),--14H109_ACAP_00003
	           	si_acct_info_dtl A(nolock),
	           	@acap_doc_dtl_tmp T
	    where	A.tran_ou 	= B.tran_ou
	    and		A.tran_type 	= B.tran_type
	    and		A.tran_no 	= B.tran_
no
		--CODE added for 14H109_ACAP_00003 starts
		AND		A.tran_ou 	= C.tran_ou
		and		A.tran_type 	= C.tran_type
		and		A.tran_no 	= C.tran_no
		--CODE added for 14H109_ACAP_00003 ends
	    and		A.line_no 	= B.line_no
	    and		T.tran_no 	= A.tran_no
	    a
nd		T.tran_ou 	= A.tran_ou
	    and		T.tran_type 	= A.tran_type
	    and		A.fb_id like @fb
	    and		(
	       		    (
	       		        convert(nchar(10), A.tran_date, 101) 
	       		        between isnull(@documentdatefrom, A.tran_date) 
	       		    
    and isnull(@documentdateto, A.tran_date)
	       		    )
	       		)
	    and		isnull(A.supplier_code, @supplier_code) like @supplier_code
	    and		(
	       		    (
	       		        A.tran_no between isnull(@documentnumberfrom, A.tran_no) 
	       
		        and isnull(@documentnumberto, A.tran_no)
	       		    )
	       		)
	    --and		A.tran_type 	= @doctype_tmp--Commented for DTS ID: 9H123-1_ACAP_00015
	    and		b.cap_doc_flag <> 'CI'
	    and		A.account_type 	= 'SCA'
	    and		row_type <> 'TCD'

	    and		C.doc_status <> 'RVD'--Code added by Ashok V for the defect id: ES_ACAP_00884	    
	    and		A.base_amount > 0
	    and		(b.line_amount - b.capitalized_amount) > 0
	     and  isnull(c.Project_code, '') like @Project_code  --Code added by thyaga
raj for 14H109_ACAP_00003  
	    group by
	           A.tran_ou, A.fb_id, A.tran_type, A.tran_no, b.line_no, b.proposal_no, A.tran_date, A.supplier_code, A.base_currency, A.exchange_rate, B.capitalized_amount,C.Project_code ---Code added by thyagaraj for 
14H109_ACAP_00003
				,rate_per,	 -- EPE-2039
				item_qty	 -- EPE-2039
	    */
	     ;
					with SQLTMP(tmpCol) as (
					select 	distinct C.destinationouinstid
	             	from   	--si_acct_info_dtl A(nolock),			--commented for rtrack id : CIE-688
	 
         				acap_cim_intxn_model_vw c(nolock)
					where	C.sourceouinstid 	= @ctxt_ouinstance
					and		C.sourcecomponentname 	= 'ACAP'
					and		C.destinationcomponentname 	= 'SIN'/*A.component_id*/		--modified for rtrack id: CIE-688
				), 
			    
			
	SQLTMP1(tmpCol) as (
					select 	SQL2K51.tax_account_type
					from   	tset_acct_cat_map_vw SQL2K51(nolock)
				)
			    
				insert into acap_doc_dtl_tmp
				  (
					guid,
					ou_id,
					fb_id,
					doc_number,
					doc_type,
					pending_cap_amount
,
					tran_date,
					supplier_code,
					doc_amount,
					tran_currency,
					exchange_rate,
					cap_amount,
					line_no,
					cap_flag,
					Project_code 
				  )
				select 	@guid,
	 					A.tran_ou,
	    				A.fb_id,
	    				A.tran_no,
	    				A.tran_type,
	    				abs(
	    					sum(
	    						isnull(A.base_amount, 0) * case 
	    														when drcr_flag = 'DR' then 1
	    														else - 1
	    												   end
	    					)
	    				) - b.capitalized_amount,
	    				A.tran_date,
	  
  				A.supplier_code,
	    				abs(
	    					sum(
	    						isnull(A.base_amount, 0) * case 
	    														when drcr_flag = 'DR' then 1
	    														else - 1
	    												   end
	    					)
	    				),
	    				isnull(A.base_currency,@base_curr),
	    				A.exchange_rate,
	    				abs(
	    					sum(
	    						isnull(A.base_amount, 0) * case 
	    														when drcr_flag = 'DR' then 1
	    														else - 1
	    												   end
	    					)
	    				) - b.capitalized_amount,

	   					b.line_no,
	    				'NC',
	    				C.Project_code
				from   	si_line_detail_vw B(nolock),
						si_doc_hdr_vw C(nolock),
	           			si_acct_info_dtl A(nolock) join 
	    				SQLTMP
				on  	(A.tran_ou = SQLTMP.tmpCol) left outer join 
	    
				SQLTMP1
				on  	(A.account_type = SQLTMP1.tmpCol)
				where	A.tran_ou 	= b.tran_ou
				and		A.tran_type = b.tran_type
				and		A.tran_no 	= b.tran_no
				AND		A.tran_ou 	= C.tran_ou
				and		A.tran_type = C.tran_type
				and		A.tran_no 	= C.tran_no
	
			and    	A.line_no 	= b.line_no
				and		A.fb_id		like @fb
				and		A.fb_id		=	c.fb_id	
				and		(
	       					(
	       						convert(nchar(10), A.tran_date, 101) 
	       						between isnull(@documentdatefrom, A.tran_date) 
	       						and isnull(@documentdateto, A.tran_date)
	       					)
	       				)
				and		isnull(A.supplier_code, @supplier_code) like @supplier_code
				and		isnull(c.Project_code, '') like @Project_code 
				and		(
	       					(
	       						A.tran_no between isnull(@documentnumberfrom, A.tran_no) 
	       						and isnull(@documentnumberto, A.tran_no)
	       					)
	       				) 
				and		A.tran_no in (select tran_no from @acap_doc_dtl_tmp)
	       		and		A.tran_type 	in ('PM_PI')
	       		and		b.cap_doc_flag <> 'CI'
		
		and		SQLTMP1.tmpCol is null
				and		A.account_type not in (@pds, @pte, 'SCA', 'BCA','CQVA', 'ROF','CSH','CPVA','DPVA')--code added for the ITS id:ES_ABB_04450--CIE-1130
				and		row_type <> 'TCD'
				and		C.doc_status <> 'RVD'
				and		A.base_amount > 0
				group by
					   A.tran_ou, A.fb_id, A.tran_type, A.tran_no, b.line_no, b.proposal_no, A.tran_date, A.supplier_code, A.base_currency, A.exchange_rate, b.capitalized_amount,C.Project_code
				--ES_ACAP_00973	   
				
	end	
	--Code Added by Antoinette for the bug id ES_ACAP_00029 ends here

	--CIE-825
	/*
	update a
	set    account_code = @accountcodeml
	from   acap_doc_dtl_tmp a(nolock),
	       si_line_detail_vw b(nolock),
	       po_hdr_vw c(nolock)
	where  A.guid = @guid
	       /* Code modified by
 Swetha for SDINDMS412AT_000538 on 05/01/2007 */
	       --and	A.doc_type	= 'SIN'
	       /* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */
	and    A.ou_id = b.tran_ou
	and    A.doc_number = b.tran_no
	and	   b.tran_type 	= 'PM_PI'--,'PM
_MI') --Modified for DTS ID:9H123-1_ACAP_00001--9H123-1_ACAP_00011
	and    b.ref_doc_ou = C.ouinstid
	and    b.ref_doc_no = C.docno
	and	   a.line_no	= b.line_no --Code Added By Indira G For Defect Id:ES_ACAP_00826	
	       /*Code modified by Uma for the 
bug id : ACAPDMS412AT_000718 starts here*/
	       --and	C.invbeforegr	= 'Y'
	and groption = 'Y' 
	/*Code modified by Uma for the bug id : ACAPDMS412AT_000718 ends here*/
	*/
	update a
	set    account_code = @accountcodeml
	from   acap_doc_dtl_tmp a,
	       sin_item_dtl b(nolock),
	       sin_po_hdr_vw c(nolock) 
	where  A.guid		=	@guid
	and    A.ou_id		=	b.tran_ou
	and    A.doc_number =	b.tran_no
	and	   b.tran_type 	=	'PM_PI'
	and    b.po_ou		=	C.po_ou  
	and    b.po_no		=	C.po_number 
	and	   a.doc_type	=	b.tran_type   
	and	   a.line_no	=	b.line_no 
	and	   groption		=	'Y' 
	and	   C.comp_id	= case	when b.pors_type = 'R'  then 'PUR_REL_SLIP' 
								when b.pors_type = 'P'  then 'PO' 
								when b.pors_type = 'S'  then 'SCO' 
								when b.pors_type = 'SR' then 'SC_REL_SLIP' 
								else comp_id 
						  end	
	--CIE-825

	--HCE-91	
	update a
	set    account_code = ard.account_code
	from   acap_doc_dtl_tmp a,
	    sin_item_Dtl b(nolock),
	       ard_addn_Account_mst ard(nolock)	   
    
	where  A.guid		= @guid
	and    A.ou_id		= b.tran_ou
	and    A.doc_number = b.tran_no
	and	   b.tran_type 	= 'PM_PI'
	and	   a.line_no	= b.line_no 	
	--and	   b.gr_opt		= 'Y'	--PEPS-1181
	and	   B.item_tcd_code	is null	
	and	   ard.company_code	= @companycode_tmp	
	and    ard.fb_id	=	a.fb_id
	and    ard.usage_id	=	b.acusage
	and	 b.acusage	is not null
	and	   ard.currency_code = @currencycodeml
	and    ard.drcr_flag = 'CR'
	and    a.tran_Date between ard.effective_from and isnull(effective_to,a.tran_Date)
	--HCE-91	

	--CIE-866	
	update a
	set    account_code = ard.account_code
		  ,cost_center  = b.cost_center /*code added for MCHS-873 */
	from   acap_doc_dtl_tmp		 a ,
	       sin_item_Dtl			 b(nolock),
	       ard_addn_Account_mst  ard(nolock),
		   itm_ibu_itemvarhdr_vw itm(nolock)       
	where  A.guid			= @guid
	and    A.ou_id			= b.tran_ou
	and    A.doc_number		= b.tran_no
	and	   b.tran_type 		= 'PM_PI'
	and	   a.line_no		= b.line_no 	
	and	   b.gr_opt			= 'Y' 
	and	   B.item_tcd_code	= itm.ibu_itemcode
	and	   B.item_tcd_var	= itm.ibu_variantcode 
	and	   itm.ibu_bu		in ( select bu_id from emod_lo_bu_ou_vw(nolock) where company_code = @companycode_tmp  ) 
	and	   itm.ibu_lo		=  @loid_tmp	
	and	   itm.ibu_itemtype = 'SR'			 	
	and	   ard.company_code	= @companycode_tmp	
	and    ard.fb_id		=	a.fb_id
	and    ard.usage_id		=	b.acusage
	and	   b.acusage	is not null
	and	   ard.currency_code = @currencycodeml
	and    ard.drcr_flag	= 'CR'
	and    a.tran_Date between ard.effective_from and isnull(effective_to,a.tran_Date)
	--CIE-866

	--For type SP updation happens from predefined usage to ref doc(GR)expense account updation
	--MCHS-916
	update a
	set    account_code = ard.account_code
	       ,cost_center  = b.cost_center
	from   acap_doc_dtl_tmp		 a(nolock),
	       sin_item_Dtl			 b(nolock),
	       ard_addn_Account_mst  ard(nolock),
		   gr_doc_alc_vw         gr(nolock)
	where  A.guid			= @guid
	and    A.ou_id			= b.tran_ou
	and    A.doc_number		= b.tran_no
	and	   b.tran_type 		= 'PM_PI'
	and	   a.line_no		= b.line_no 	
	and	   b.gr_opt			= 'Y' 
	and	   ard.company_code	= @companycode_tmp	
	and    ard.fb_id		=	a.fb_id
    and    ard.usage_id		=	b.acusage
	and	   b.acusage	is not null
	and	   ard.currency_code = @currencycodeml
	and    ard.drcr_flag	= 'CR'
	and    a.tran_Date between ard.effective_from and isnull(effective_to,a.tran_Date)
	and   gr.docno = b.po_no
	and   gr.whcode is null
	and gr.ouinstid=b.po_ou
	and gr.linenumber=b.po_line_no
	and gr.amendno=b.po_amendment_no
	and gr.referencedoc = Case  when b.pors_type ='P' then 'PO'  
							   when b.pors_type ='R' then 'RS'
							   when b.pors_type ='SR' then 'SR'
							   when b.pors_type ='S' then 'SC'
							   else b.pors_type
							 end
    --MCHS-916

	/*Code modified by 
Uma for the bug id : ACAPDMS412AT_000719 starts here*/
	/*update a
	set 	account_code 	= @accountcodeml
	from 	acap_doc_dtl_tmp a(nolock),
	rct_unplanned_hdr_vw b(nolock)
	where 	A.guid			= @guid
	and	A.ou_id			= b.rcuh_received_from
	and	A.doc_number		= 
b.rcuh_ref_doc_no
	and	b.rcuh_ref_doc_type	= 'SDINV'*/
	/* Code modified by Swetha for SDINDMS412AT_000538 on 05/01/2007 */
	--and	A.doc_type		= 'SDIN'
	--and A.doc_type           in ('PM_EV','PM_IV')
	/* Code modified by Swetha for SDINDMS412AT_000538 on
 05/01/2007 */
	
	update a
	set  account_code = @accountcodeml
	from   si_line_detail_vw SI(nolock),
	       acap_doc_dtl_tmp a
	where  A.guid = @guid
	and    A.ou_id = SI.tran_ou
	and    si.tran_no = a.doc_number
	and    si.tran_type = a.doc_type

	and    si.tran_type in('PM_IV' /*,'PM_EV'*/) --Code Added By Indira G For Defect Id:ES_ACAP_00826 /*Code Commented for ITS ID : ES_ACAP_00859*/
	and    si.cap_doc_flag = 'NC'
	and	   si.line_no	= a.line_no --Code Added By Indira G For Defect Id:ES_ACAP_0082

	/*Code Added by Esther J for the Bug id : 8H123-2_ACAP_00059 Starts here*/
	update TMP1
	/*Code commented and added by Aditya Sitaraman for ES_ACAP_00364 */
	/*
	set    total_docamt = case 
	                           when T1.totamt > 0 then T1.totamt
	                 else T1.totlineamt
	                      end -- Code Modified by Uma for the defect id : ES_ACAP_00079
	*/
	set    total_docamt = case 
	          when T1.totlineamt > 0 then T1.totlineamt
	                     else T1.totamt
	   end 
	/*Code commented and added by Aditya Sitaraman for ES_ACAP_00364 */
	from   acap_doc_dtl_tmp TMP1(nolock),
	       (
	           select 	ou_id,
	           		doc_type,
	           		doc_number,
	           		TMP.line_no,
	           		sum(isnull(item_amount, 0)) 	as totamt,
	           		sum(isnull(line_amount, 0)) 	as totlineamt -- Code added by Uma for the defect id : ES_ACAP_00079
	           from   	si_line_dtl SI(nolock),
	                  	acap_doc_dtl_tmp TMP(nolock)
	           where	guid 	= @guid
	           and		SI.tran_ou 	= TMP.ou_id
	           and		SI.tran_type 	= TMP.doc_type
	           and		SI.tran_no 	= TMP.doc_number
	           group by
	                  ou_id, doc_type, doc_number, TMP.line_no
	       ) T1
	where  TMP1.guid = @guid
	and    TMP1.ou_id = T1.ou_id
	and    TMP1.doc_type = T1.doc_type
	and    TMP1.doc_number = T1.doc_number
	
	
	update TMP1
	set    total_docamt = T1.totamt
	from   acap_doc_dtl_tmp TMP1(nolock),
	       (
	           select 	ou_id,
	    		doc_type,
	 
          		doc_number,
	           		line_no,
	           		sum(isnull(iid_issue_value, 0)) 	as totamt
	           from   	issue_inv_detail iss(nolock),
	                  	acap_doc_dtl_tmp TMP(nolock)
	           where	guid 	= @guid
	           and		iss.iid_ouinstid 	= TMP.ou_id
	           and		iss.iid_issue_no 	= TMP.doc_number
	           and		TMP.doc_type 	= 'INV_IMIS'
	           group by
	                  ou_id, doc_type, doc_number, line_no
	       ) T1
	where  TMP1.guid = @guid
	and    TMP1.ou_id = T1.ou_id
	and    TMP1.doc_type = T1.doc_type
	and    TMP1.doc_number = T1.doc_number
	
	--PTP-105 starts
	update TMP1
	set    total_docamt = T1.totamt
	from   acap_doc_dtl_tmp TMP1(nolock),
	       (
	           select 	ou_id,
	    		doc_type,
	     
      		doc_number,
	           		line_no,
	           		sum(isnull(imd_issue_value, 0)) 	as totamt
	           from   	issue_mnt_detail ism(nolock),
	                  	acap_doc_dtl_tmp TMP(nolock)
	           where	guid 	= @guid
	           and		ism.imd_ouinstid 	= TMP.ou_id
	           and		ism.imd_issue_no 	= TMP.doc_number
	           and		TMP.doc_type 	= 'INV_MMIS'
	           group by
	                  ou_id, doc_type, doc_number, line_no
	       ) T1
	where  TMP1.guid = @guid
	and    TMP1.ou_id = T1.ou_id
	and    TMP1.doc_type = T1.doc_type
	and    TMP1.doc_number = T1.doc_number
	--PTP-105 ends

	--code added for the dts id 13H120_General_00032 ;13H120_ACAP_00002 starts
	update TMP1
	set    total_docamt = T1.totamt
	from   acap_doc_dtl_tmp TMP1(nolock),
	       (
	           select 	wo_ouinstance as ou_id,
	           			'EAM_WGDIR' as doc_type,
	           			wo_code as doc_number,
	      			--wo_lineno as line_no,
	   			sum(isnull(wo_tot_act_cost_of, 0)) 	as totamt
	           from   	eam_workorder_cost_detail eam(nolock),
	                  	acap_doc_dtl_tmp TMP(nolock)
	         where	guid 				= @guid
	           and		eam.wo_ouinstance 	= TMP.ou_id
	           and		eam.wo_code 		= TMP.doc_number
	           and		eam.wo_lineno		= tmp.line_no

	         and		TMP.doc_type 	 	= 'EAM_WGDIR'
	      group by
	                  wo_ouinstance,  wo_code--, wo_lineno
	       ) T1
	where  TMP1.guid		= @guid
	and    TMP1.ou_id		= T1.ou_id
	and    TMP1.doc_type	= T1.doc_type
	and    TMP1.doc_number  = T1.doc_number 
	--code added for the dts id 13H120_General_00032 ;13H120_ACAP_00002 ends
		
	update TMP1
	set    total_docamt = CO.wip_cost
	from   acap_doc_dtl_tmp TMP1(nolock),
	     acap_wip_hdr CO(nolock)
	where  guid = @guid
	and    TMP1.ou_id = CO.ou_id
	and    TMP1.doc_type = 'CO'
	and    TMP1.doc_number = CO.cap_wo_number
	/*Code Added by Esther J for the Bug id : 8H123-2_ACAP_00059 Ends here*/

	/*code added for EBS-2581 starts*/
		 update TMP1  
		 set    total_docamt = T1.totamt  
		 from   acap_doc_dtl_tmp TMP1(nolock),  
			 (  
			   /*code commented and modified for PTP-1376 starts here*/
			  select  jv.ou_id,--tmp.ou_id,  
					  'BK_JV' as doc_type, --doc_type,  
					  voucher_no,--doc_number,  
					  sum(isnull(tran_amount, 0))  as totamt  
			  from    jv_voucher_trn_dtl jv(nolock) 
			 		--,acap_doc_dtl_tmp TMP(nolock)   
			  where exists (select 'X' from acap_doc_dtl_tmp TMP(nolock) 
							  where guid  = @guid  
							  and  jv.ou_id  = TMP.ou_id  
							  and  jv.voucher_no  = TMP.doc_number 
							  and  TMP.doc_type  = 'BK_JV' 
							  )
			   and  jv.drcr_flag= 'DR'
			  --and  jv.voucher_serial_no		= tmp.line_no--EBS-2581
			  group by  jv.ou_id, voucher_no --tmp.ou_id,doc_type, doc_number
			  /*code commented and modifie
d for PTP-1376 ends here*/
			 ) T1  
		 where  TMP1.guid = @guid  
		 and    TMP1.ou_id = T1.ou_id  
		 and    TMP1.doc_type = T1.doc_type  
		 and    TMP1.doc_number = T1.voucher_no --doc_number  --PTP-1376 
	/*code added for EBS-2581 ends*/

    /*Code
 added for DTS ID: 9H123-1_ACAP_00014 starts here*/
    update  tmp1
    set     supplier_name_desc = s.supplier_name
    from    acap_doc_dtl_tmp tmp1,
            supp_supdtls_vw s(nolock)
    where   s.loid          =  @loid_tmp
    and     s.supplier_code =  tmp1.supplier_code  
	and		guid = @guid			-- code added for Defect id:- GMKPSS-151
    /*Code added for DTS ID: 9H123-1_ACAP_00014 ends here*/
	
	--ES_ACAP_00695
	update  tmp1  
    set     tran_currency	=	@base_Curr,  
		    exchange_rate	=	1
   
 from    acap_doc_dtl_tmp tmp1  
    where	TMP1.guid		= @guid   
	and		TMP1.doc_type   = 'INV_IMIS'
	--ES_ACAP_00695  
  
	      
	set nocount off
end














