/*$File_version=MS4.3.0.06$	*/
/*$File Name : acap_cwipautogen.sql*/
/******************************************************************************/
/* Procedure					: acap_cwipautogen							  */
/* Description					: 								 			  */
/******************************************************************************/
/* Project						: PMC-FA-48 [ MSEnh_FIN_FN_CWIPTransfer]	  */
/* EcrNo						: 								 			  */
/* Defectid						: 12H124_ACAP_00001[ES_General_00632]		  */
/* Version						: MS4.3.0.00								  */
/******************************************************************************/
/* Referenced					: 										 	  */
/* Tables						: 											  */
/******************************************************************************/
/* Development history			: 											  */
/******************************************************************************/
/* Author						: Esther J							 		  */
/* Date							: Sept 04 2012							      */
/******************************************************************************/
/* Modification History			: 								 			  */
/******************************************************************************/
/*Esther J		05/09/2012		12H124_ACAP_00001:12H124_ACAP_00053:12H124_ACAP_00044:12H124_ACAP_00045[ES_General_00632]*/
/*Esther J		05/09/2012		12H124_ACAP_00001:12H124_ACAP_00091			*/
/* Deepika V	27/9/2012		12H124_ACAP_00001:12H124_ACAP_00095			*/
/* Santhakumar R 16/12/2013		ES_ACAP_00534								*/
/* Aditya Sitaraman 12/08/2015	ES_ACAP_00821								*/
/* Sweety Ninave		02/05/2018	HAL-643										*/
/*aMANI.p			10-03-2021				--EPE-31320*/
/*Abimathi.M		21-04-2021				  EPE-32065:EPE-32906*/
/*Abimathi M	`	06/05/2021				  EPE-32065   */
/*Srinivasan        24/01/2024                TC-2440*/
/*Srinivasan        28/03/2024                TC-2861(EPE-79980)*/
/******************************************************************************/
Create procedure acap_cwipautogen
	@ctxt_language					fin_ctxt_language  ,
	@ctxt_ouinstance				fin_ctxt_ouinstance  ,
	@ctxt_service					fin_ctxt_service  ,
	@ctxt_user						fin_ctxt_user  ,
	@assetlocation					fin_assetlocation  ,
	@capitalwodesc					fin_name  ,
	@capitalworkorderno				fin_documentno  ,
	@documentnumber					fin_documentnumber  ,
	@fb								fin_financebookid  ,
	@guid							fin_guid  ,
	@notypeno						fin_notypeno  ,
	@transactiondate				fin_date  ,
	@wip_amount						fin_amount,
	@assetclass						fin_assetclass,
	@proposal_no					fin_documentnumber,
	@transferbatchno				fin_documentnumber,
	@m_errorid						fin_int output --to return execution status
	

as
begin
--BEGIN of Standard code for getting precision type
	declare @pqty_tmp                  fin_int ,
		@pamt_tmp                  fin_int ,
		@prate_tmp                 fin_int ,
		@perate_tmp                fin_int ,
		@phigh_tmp                 fin_int ,
		@pmed_tmp                  fin_int ,
		@plow_tmp                fin_int
	
	exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
	     @prate_tmp output, @perate_tmp output, @phigh_tmp output,
	     @pmed_tmp output, @plow_tmp output

		declare @errortmp1		fin_int,
				@retval_tmp		fin_int,
				@errorcode_tmp	fin_int,
				@newguid_tmp	fin_guid,
				@fbdestou_tmp	fin_int,
				@ainq_ou		fin_int,
				@si_ou			fin_int,
				@aplan_ou		fin_int,
				@err_tmp		fin_int,
				@emsg_tmp		fin_text255,
				@doc_ou			fin_ouinstid,
				@doc_no			fin_documentno,
				@doc_type		fin_trantype,
				@line_no		fin_int,
				@doc_date		fin_date,
				@supp_name		fin_suppliercode,
				@companycode_tmp fin_companycode,
				@doc_amt		fin_amount,
				@doc_lineamt	fin_amount,
				@pendcap_amt	fin_amount,
				@transfer_amt	fin_amount,
				@rowno			fin_int,
				@used_wipamt	fin_amount,
				@apptrf_amt	fin_amount,
				@process_wipamt	fin_amount
					declare @exchange_rate fin_rate,
			@tran_currency fin_currency
			
     	-- nocount should be switched on to prevent phantom rows
     	set nocount on
     	-- @m_errorid should be 0 to indicate success
     	select @m_errorid =0

     
	select @assetlocation = ltrim(rtrim(@assetlocation))
     if @assetlocation = '~#~'
	select @assetlocation = null
     	select @capitalwodesc = ltrim(rtrim(@capitalwodesc))
     if @capitalwodesc = '~#~'
        select @capitalwodesc = null
    	select @capitalworkorderno = ltrim(rtrim(@capitalworkorderno))
     if @capitalworkorderno = '~#~'
        select @capitalworkorderno = null
     if @ctxt_language = -915
        select @ctxt_language = null
     if @ctxt_ouinstance = -915
        select @ctxt_ouinstance = null
     	select @ctxt_service = ltrim(rtrim(@ctxt_service))
     if @ctxt_service = '~#~'
        select @ctxt_service = null
     	select @ctxt_user = ltrim(rtrim(@ctxt_user))
 if @ctxt_user = '~#~'
        select @ctxt_user = null
     select @documentnumber = ltrim(rtrim(@documentnumber))
     if @documentnumber = '~#~'
      select @documentnumber = null
     	select @fb = ltrim(rtrim(@fb))
     if @fb = '~#~'
        select @fb = null
     	select @guid = ltrim(rtrim(@guid))
     if @guid = '~#~'
        select @guid = null
     	select @notypeno = ltrim(rtrim(@notypeno))
     if @notypeno = '~#~'
        select @notypeno = null
     select @transactiondate = ltrim(rtrim(@transactiondate))
     if @transactiondate = '1900-01-01'
        select @transactiondate = null
	
	select @newguid_tmp = NEWID()
	
	select @used_wipamt	  = 0
	select @process_wipamt = @wip_amount
	
	declare targetdoc_cwip_cur cursor for 
	select distinct  doc_ou,doc_no,doc_type,line_no,doc_date,supp_name,doc_amt,doc_lineamt,pendcap_amt,transfer_amt,rowno,apptrf_amt,tran_currency,tran_erate--EPE-31320
	from  acap_cwiptransfer_src_tmp(nolock)
	where	guid				= @guid
	and     flag				= 'Y'
	and     isnull(apptrf_amt,0) <> 0
	order by rowno
        
      
	open targetdoc_cwip_cur

	while 1=1
	begin
		fetch next from targetdoc_cwip_cur into @doc_ou,@doc_no,@doc_type,@line_no,@doc_date,@supp_name,
											 @doc_amt,@doc_lineamt,@pendcap_amt,@transfer_amt,@rowno,@apptrf_amt,@tran_currency,@exchange_rate--EPE-31320
	
		if @ctxt_user = 'debuguser$'
		begin
			select 'data',@@fetch_status,@used_wipamt,@process_wipamt
			select @doc_ou,@doc_no,@doc_type,@line_no,@doc_date,@supp_name,
											 @doc_amt,@doc_lineamt,@pendcap_amt,@transfer_amt,@rowno,@apptrf_amt,@tran_currency,@exchange_rate
		end	
		
		if @@fetch_status <> 0
			break
			
		select @used_wipamt	  = 0
		
		if @process_wipamt > @apptrf_amt 
		begin
			select @used_wipamt = @apptrf_amt
			select @process_wipamt =  @process_wipamt - @apptrf_amt
		end
		else if @process_wipamt < =  @apptrf_amt 
		begin
			select @used_wipamt		= @process_wipamt
			select @process_wipamt =  @process_wipamt - @process_wipamt
		end
		/*else
		begin
			select @used_wipamt		= @process_wipamt
			select @process_wipamt =  @process_wipamt - @process_wipamt		
		end	*/
		
		UPDATE acap_cwiptransfer_src_tmp
		SET apptrf_amt = apptrf_amt - @used_wipamt
		where	guid				= @guid
		and     flag				= 'Y'
		AND		 rowno				= @rowno
		
		UPDATE acap_cwiptransfer_src_tmp
		SET flag = 'N'
		where	guid				 =  @guid
		and     isnull(apptrf_amt,0) =  0
		AND rowno					 = @rowno
		
		insert into acap_wip_line_tmp 
		(guid,ou_id,line_no,doc_number,timestamp,cap_wo_number,doc_type,line_desc,doc_amount,
		pen_cap_amount,asset_class,wip_cost,cap_amount,proposal_number,doc_date,supplier_name,cap_flag
		,currency,exchange_rate--EPE-31320
		)
		values(@newguid_tmp,@doc_ou,@line_no,@doc_no,1,@capitalworkorderno,@doc_type,null,@doc_amt,
		@pendcap_amt,@assetclass,@used_wipamt,@used_wipamt,@proposal_no,@doc_date,isnull(@supp_name,''),'CI' --EPE-32065
		,@tran_currency,@exchange_rate---EPE-31320
		)
		
		if isnull(@process_wipamt,0) = 0
		    break
			
	end
	
	close targetdoc_cwip_cur
	deallocate targetdoc_cwip_cur
	 


	if  exists (	select	'x'
        		from	acap_wip_line_tmp (nolock) 
        		where	guid	= @newguid_tmp
        		and	datediff(day,@transactiondate,doc_date) > 0
	)
	begin 
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2035
		select @m_errorid = 2035
		return 
	end
	
	if @ctxt_user = 'debuguser$'
	begin
			select	'acap_wip_line_tmp',*
        		from	acap_wip_line_tmp (nolock) 
        		where	guid	= @newguid_tmp
	end	

	/*CWIPTRF_097	Generate Capital work order Document number	Check in the CIM if Asset Capitalization is mapped to Numbering Class then invoke Service "NcSerNcComTrn2" of the Numbering Class component to generate the Capital work order document Number. Prov













ide inputs 1. Login OU 2. Transaction Type - FA_aCAPWIP', 3. Numbering Type - Selected in the combo in Authorized Status. Get output Capitalization number and default the same, else display error message returned by the service*/

	-- get the transaction number
	exec dnm_gen_tranno_sp  @ctxt_language,@ctxt_ouinstance,@ctxt_service,
		@ctxt_user,'ACAP','FA_ACAPWIP',@notypeno,@transactiondate,
		@documentnumber output,@errortmp1 output,@retval_tmp output
 
	if isnull(@documentnumber,'') = '' or isnull(@errortmp1,0) <> 0   or isnull(@retval_tmp,0) <> 0 
	begin
		--Automatic Generation of CWIP Document No. failed.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2000
		select @m_errorid = 2000
		return
	end
 
 
 	update acap_cwiptransfer_tgt_dtl 
 	set doc_no = @documentnumber
	where	ou_id 		= @ctxt_ouinstance
	and		transfer_no = @transferbatchno
	and		cwip_no		= @capitalworkorderno
	and		asset_class = @assetclass
	and		proposal_no = @proposal_no
	
	/*CWIPTRF_100	Record Transaction Details	Save in Asset Capitalization for recording the accounting transaction with the following details. Transaction OU = Login OU, Transaction Type = AcapWip, Document No, Document Date, Finance Book, Capital Wip docume










nt no, Capital Wip cost.*/
	-- insert the record into wip header table ...
	insert into	acap_wip_hdr(ou_id, cap_wo_number, timestamp, doc_number,
	transaction_date, fb_id, num_type, wip_status,	cap_wo_desc,  asset_location, wip_cost,
	createdby, createddate,transferbatch_no )
	values		(@ctxt_ouinstance, @capitalworkorderno,1,@documentnumber,
	@transactiondate, @fb, @notypeno,'AC',	@capitalwodesc,  @assetlocation,@wip_amount,
	@ctxt_user, dbo.RES_Getdate(@ctxt_ouinstance),@transferbatchno)
	
	insert into acap_wip_dtl
	(ou_id,cap_wo_number,doc_number,doc_type,timestamp,doc_date,supplier,wip_cost,
	asset_class,createdby,createddate)
	select @ctxt_ouinstance,@capitalworkorderno,doc_number,doc_type,1,doc_date,supplier_name,sum(isnull(wip_cost,0)),
	asset_class,@ctxt_user, dbo.RES_Getdate(@ctxt_ouinstance)
	from	acap_wip_line_tmp (nolock) 
	where guid = @newguid_tmp
	group by doc_date, doc_number,  doc_type, ou_id,supplier_name,asset_class
	
 
	insert into acap_wip_line_dtl(ou_id,cap_wo_number,doc_type,doc_number,line_no,timestamp,line_desc,
	doc_amount,pen_cap_amount,asset_class,wip_cost,cap_line_no,cap_amount,proposal_number,
	createdby,createddate,tran_type,cap_flag,supplier
	,currency,exchange_rate--Amani
	)
	select @ctxt_ouinstance,@capitalworkorderno,doc_type,doc_number,line_no,1,null,
	doc_amount,pen_cap_amount,asset_class,wip_cost, ROW_NUMBER() OVER(order BY doc_type,doc_number,line_no),wip_cost,proposal_number, --12H124_ACAP_00001:12H124_ACAP_00091
	@ctxt_user, dbo.RES_Getdate(@ctxt_ouinstance),doc_type,cap_flag,supplier_name
	,currency,exchange_rate--Amani
	from	acap_wip_line_tmp (nolock)
	where	guid = @newguid_tmp
	
	
	update b
	set doc_amount		= a.doc_amount,
		pen_cap_amount  = a.pen_cap_amount,
		proposal_no=a.proposal_number--code added by TC-2861

	from	acap_wip_line_dtl a (nolock),acap_wip_dtl b(nolock)
	where 	a.ou_id  			  = @ctxt_ouinstance
	and 	a.cap_wo_number	      = @capitalworkorderno
	and	    a.ou_id				  = b.ou_id	
	and	    a.cap_wo_number		  = b.cap_wo_number		
	and	    a.doc_type	          = b.doc_type
	and	 a.doc_number		  = b.doc_number 

	
	select 	@companycode_tmp= company_code 
	from 	emod_ou_vw(nolock)
	where 	ou_id 		= @ctxt_ouinstance
	and 	dbo.RES_Getdate(@ctxt_ouinstance) 	between effective_from   --12H124_ACAP_00044
	and isnull(effective_to,dbo.RES_Getdate(@ctxt_ouinstance))

	/*CWIPTRF_064	Account Code existence for INTACCWIPTRF usage	Check  if the Account code has not been defined for the new Usage, for the  FB Error would be displayed		Account Code not defined for the usage id INTACCWIPTRF. Define Account code for the usag



e










 and Proceed Further.
				CWIPTRF_065	Account Code Validity for INTACCWIPTRF usage	Check  if the Account code defined for the new Usage is not valid, Error would be displayed.		Account Code defined for the usage id INTACCWIPTRF is not valid for the Transfer Date.
				CWIPTRF_066	Account Code FB Mapping for INTACCWIPTRF usage	Check  if the Account code defined for the new Usage is not mapped to the Finance Book of the Customer Debit Note / Customer Credit Note Error would be displayed.		Account Code defined for the













 usage id INTACCWIPTRF is not mapped to the Finance Book <%%>
	*/			
	-- code changed for the dts id 12H124_ACAP_00045 starts 
	declare  @accountcode		fin_accountcode,
			 @effective_from    fin_Date,
			 @effective_to      fin_Date
			 
	select @accountcode  = account_code,
		   @effective_from = effective_from,
		   @effective_to   = isnull(effective_to,'01-01-9999') 
	from ard_addn_account_mst (nolock)
	where company_code 	= @companycode_tmp 
	and drcr_flag		= 'CR' --12H124_ACAP_00053
	and usage_id		= 'INTACCWIPTRF'
	and fb_id			= @fb --HAL-643

	if @accountcode is null
	begin
		--2036	Account Code not defined for the usage id INTACCWIPTRF. Define Account code for the usage and Proceed Further.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2036
		select @m_errorid = 2036
		return  
	end
	
	if @transactiondate >= @effective_from and @transactiondate <= @effective_to
	begin
		select @ctxt_language = @ctxt_language
	end
	else
	begin
		--2037	Account Code defined for the usage id INTACCWIPTRF is not valid for the Transfer Date.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2037
		select @m_errorid = 2037
		return 
	end
	
	select @accountcode    = NULL,
		   @effective_from = NULL,
		   @effective_to   = NULL
	   
	   
	select @accountcode    = account_code,
		   @effective_from = effective_from,
		   @effective_to   = isnull(effective_to,'01-01-9999') 
	from ard_addn_account_mst (nolock)
	where company_code 	= @companycode_tmp 
	and drcr_flag		= 'DR' --12H124_ACAP_00053
	and usage_id		= 'INTACCWIPTRF'
	and fb_id			= @fb --HAL-643

	if @accountcode is null
	begin
		--2036	Account Code not defined for the usage id INTACCWIPTRF. Define Account code for the usage and Proceed Further.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2036
		select @m_errorid = 2036
		return  
	end
	
	if @transactiondate >= @effective_from and @transactiondate <= @effective_to
	begin
		select @ctxt_language = @ctxt_language
	end
	else
	begin
		--2037	Account Code defined for the usage id INTACCWIPTRF is not valid for the Transfer Date.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2037
		select @m_errorid = 2037
		return 
	end
	
					
	if not exists (select 'v'	from ard_addn_account_mst (nolock)
					where company_code 	= @companycode_tmp 
					and usage_id		= 'INTACCWIPTRF'	
					and fb_id			= @fb	
					and drcr_flag		= 'DR'		
					and @transactiondate between effective_from and isnull(effective_to,'01-01-9999') ) 
	begin
		--2038	Account Code defined for the usage id INTACCWIPTRF is not mapped to the Finance Book %a.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2038,@fb
		select @m_errorid = 2038
		return
	end
	
	if not exists (select 'v'	from ard_addn_account_mst (nolock)
					where company_code 	= @companycode_tmp 
					and usage_id		= 'INTACCWIPTRF'	
					and fb_id			= @fb	
					and drcr_flag		= 'CR'		
					and @transactiondate between effective_from and isnull(effective_to,'01-01-9999') ) 
	begin
		--2038	Account Code defined for the usage id INTACCWIPTRF is not mapped to the Finance Book %a.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2038,@fb
		select @m_errorid = 2038
		return
	end
	-- code changed for the dts id 12H124_ACAP_00045 ends
	
	--Local postings
	--orginal service : ACA_TIAC_Sr_Aut , but interpreted as "ACA_TIAC_Sr_Aut_Tgt" for target cwip doc and as "ACA_TIAC_Sr_Aut_src" for source reversal cwip doc 
	exec acapaccountingpost	@ctxt_language,@ctxt_ouinstance,'ACA_TIAC_Sr_Aut_Tgt',@ctxt_user,
	null,@fb,@documentnumber,@transactiondate,@transactiondate,
	'FA_ACAPWIP',null,null,@wip_amount,null,'WIP',@errorcode_tmp output
	
	if @ctxt_user = 'debuguser$'
	begin
		select 'capital cwip for target'
		select 'acap_wip_hdr',* from acap_wip_hdr (nolock)
		where 	ou_id  			  = @ctxt_ouinstance
		and 	cap_wo_number	      = @capitalworkorderno 
		select 'acap_wip_dtl',* from acap_wip_dtl (nolock)
		where 	ou_id  			  = @ctxt_ouinstance
		and 	cap_wo_number	      = @capitalworkorderno 
		select 'acap_wip_line_dtl',* from acap_wip_line_dtl (nolock)
		where 	ou_id  			  = @ctxt_ouinstance
		and 	cap_wo_number	      = @capitalworkorderno 
		select 'acap_wip_accounting_dtl',* from acap_wip_accounting_dtl (nolock)
		where  tran_number	      = @documentnumber 
	end
	
	if isnull(@errorcode_tmp,0) <> 0 
	begin
	
		if @ctxt_user = 'debuguser$'
		begin
			select 'Error in Postings from Auto Generated CWIP Document.',@errorcode_tmp
		end
		/*code added for the dtsid:12H124_ACAP_00001:12H124_ACAP_00095 begisn here*/
		if @errorcode_tmp	=	186
		begin
			--No Account Code exists for the Asset Class Code and Usage.-
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3000
			select @m_errorid  = 3000
			return
		end
		if @errorcode_tmp	=	109
		begin
			--Provide Organization Unit.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3001
			select @m_errorid  = 3001
			return
		end
		if @errorcode_tmp	=	245
		begin
			--Provide Asset Class Code.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3002
			select @m_errorid  = 3002
			return
		end
		if @errorcode_tmp	=	110
		begin
			--Provide Finance Book Id
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3003
			select @m_errorid  = 3003
			return
		end
		if @errorcode_tmp	=	246
		begin
			--Provide Usage ID.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3004
			select @m_errorid  = 3004
			return
		end
		if @errorcode_tmp	=	152
		begin
			--Provide Transaction Date.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3005
			select @m_errorid  = 3005
			return
		end
		if @errorcode_tmp	=	247
		begin
			--OU not mapped to any Company.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3006
			select @m_errorid  = 3006
			return
		end
		else
		begin
			/*code added for the dtsid:12H124_ACAP_00001:12H124_ACAP_00095 ends here*/
			--Error in Postings from Auto Generated CWIP Document.
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2001
			select @m_errorid = 2001
			return
		end
	end
	
	insert into acap_wip_accounting_tmp (guid,tran_number,tran_type,doc_number,
		account_code,drcr_flag,timestamp,ou_id,tran_date,posting_date,currency,tran_amount,fb_id,
		cost_center,analysis_code,sub_analysis_code,bc_erate,base_amount,pbc_erate,
		pbase_amount,cap_date,bu_id,company_code,createdby,createddate,modifiedby,modifieddate)
	select @newguid_tmp,tran_number,tran_type,doc_number,
		account_code,drcr_flag,timestamp,ou_id,tran_date,posting_date,currency,tran_amount,fb_id,
		cost_center,analysis_code,sub_analysis_code,bc_erate,base_amount,pbc_erate,
		pbase_amount,cap_date,bu_id,company_code,createdby,createddate,modifiedby,modifieddate
	from acap_wip_accounting_dtl (nolock) 
	where tran_number = @documentnumber
	and ou_id = @ctxt_ouinstance
	
	insert into acap_updinvoice_tmp 
		(guid,tran_type,doc_type,doc_number,
		line_no,cap_amount,tran_number,createdby,createddate,ou_id,
		tran_ou,trans_type,account_code,cap_flag,pending_cap_amt)
	select 	
		@newguid_tmp,'CRE',a.doc_type,a.doc_number,
		a.line_no,a.wip_cost,a.cap_wo_number,@ctxt_user,dbo.RES_Getdate(@ctxt_ouinstance),@ctxt_ouinstance, 
		b.ou_id,a.tran_type,a.account_code,cap_flag,isnull(a.pen_cap_amount,0)
    from	acap_wip_line_dtl a (nolock),acap_wip_dtl b(nolock)
	where 	a.ou_id  	        = @ctxt_ouinstance
	and 	a.cap_wo_number	    = @capitalworkorderno
	and	    a.ou_id				= b.ou_id	
	and	    a.cap_wo_number		= b.cap_wo_number		
	and	    a.doc_type			= b.doc_type
	and	    a.doc_number		= b.doc_number
	and		a.doc_type 			<> 'IBE'  
	
	
	--code added by R.Santhakumar for the case:ES_ACAP_00534 starts here
	
	update tmp1
	set tmp1.tran_ou	=tmp2.doc_ou	
	from  acap_updinvoice_tmp tmp1, acap_cwiptransfer_src_tmp tmp2(nolock)	
	where	tmp1.guid			=@newguid_tmp
	and		tmp2.guid		= @guid	
	and		tmp2.doc_no		=tmp1.doc_number
	and		tmp2.doc_type	=tmp1.doc_type 
	
	--code added by R.Santhakumar for the case:ES_ACAP_00534 ends here
	
		declare @tran_no_tmp  		fin_documentno,
				@cap_amount_tmp 	fin_amount,
				@line_tmp		fin_lineno,
				@pending_amount		fin_amount,
				@err_id			fin_int 
				
	/*CWIPTRF_083	Update Pending Capitalization amount - source doc	If document/s type = SO Based Invoice" invoke service SinSerAcapTrn3 of "Supplier Order Based Invoice", else if the selected document/s type = "Supplier Direct Invoice" invoke service Sdins


























erAcaptrn3 of "Direct Invoice", else if the selected document/s type = "Sundry Payment" invoke service SnpSerAcapTrn3 of "Sundry Payment" else if the document/s type = "Supplier Note" invoke service ScdnSerAcapTrn3 else if document type = Supplier payment













 invoke service SpySerAcapTrn3 of Supplier payment else if document type is Inventory Issue invoke service from Stock issue, for updation of Pending capitalization amount. Provide Input 1. Login OU 2. Document type 3. Document date 4. Transfer Amount. Pen













ding capitalization = document amount - sum of already capitalized amounts (both Asset and WIP) - Transfer WIP amount  at each line level*/
	
	--EPE-32065:EPE-32906 starts
	if exists (Select '*' from acap_updinvoice_tmp(nolock)
			   where guid	  = @newguid_tmp
			   and	 doc_type = 'CO')
	begin
		update dtl 
		set   dtl.trfr_amount	= isnull(dtl.trfr_amount,0)+ tmp.cap_amount
		from  acap_wip_line_dtl dtl(nolock),
			  acap_updinvoice_tmp tmp(nolock)
		where guid				= @newguid_tmp
		and   tmp.doc_type		= 'CO'
		and   tmp.doc_number	= dtl.cap_wo_number
		and   tmp.tran_ou		= dtl.ou_id
		and   tmp.line_no		= dtl.cap_line_no
		
		delete from acap_updinvoice_tmp
		where guid	  = @newguid_tmp
		and	 doc_type = 'CO'
	end
	--EPE-32065:EPE-32906 ends
	declare @doc_type1 fin_trantype--code added by TC-2440
	declare stkiis_capamt cursor 
	for 		

		select 	cap_amount,doc_number,line_no,pending_cap_amt,doc_type--doc_type added by TC-2440
		from  	acap_updinvoice_tmp(nolock)
		where 	guid = @newguid_tmp
		and	doc_type IN( 'INV_IMIS','BK_JV')--'BK_JV' added BY TC-2440

	open stkiis_capamt

	fetch next from stkiis_capamt into @cap_amount_tmp,@tran_no_tmp,@line_tmp,@pending_amount,@doc_type1--@doc_type1 added by TC-2440	
	

	while (@@fetch_status = 0)
	begin
	/*---code starts by TC-2440*/
		if @doc_type1='INV_IMIS'
	begin
	/*---code ends by TC-2440*/
		exec @err_id = stkiis_capamt_upd_sp @ctxt_language,@ctxt_ouinstance,@ctxt_service,@ctxt_user,'ACAP',@tran_no_tmp,@line_tmp,@cap_amount_tmp,@pending_amount
	
		if @ctxt_user = 'debuguser$'
		begin
			select 'stkiis_capamt_cursor',@cap_amount_tmp,@tran_no_tmp,@line_tmp,@pending_amount	
		end

		if @err_id <> 0 
		begin
			break
			close stkiis_capamt
			deallocate stkiis_capamt
		end
	--code added by TC-2440
	end
	else 
	begin 
	update  jv_voucher_trn_dtl 
			set		pending_cap_amount	=	isnull(pending_cap_amount,0) - isnull(@cap_amount_tmp,0),
					capitalized_amount	=	isnull(capitalized_amount,0) + isnull(@cap_amount_tmp,0)
			where	voucher_no			=	@tran_no_tmp
			and		voucher_serial_no	=	@line_tmp				
			and		ou_id				=	@ctxt_ouinstance
	end
	--code ends by TC-2440
		fetch next from stkiis_capamt into @cap_amount_tmp,@tran_no_tmp,@line_tmp,@pending_amount,@doc_type1--code added by TC-2440
	end

	close stkiis_capamt
	deallocate stkiis_capamt
	
	if @err_id <> 0 
	begin
		select @m_errorid = @err_id
		return
	end

	if exists (select 'x' from fw_admin_view_comp_intxn_model(NOLOCK)
	 where sourcecomponentname 	 = 'ACAP'
	 and 	sourceouinstid	  	 = @ctxt_ouinstance
	 and 	destinationcomponentname = 'AINQ'
	 and 	destinationouinstid		 = @ctxt_ouinstance )

	 begin
		 select @ainq_ou = destinationouinstid
		 from fw_admin_view_comp_intxn_model(NOLOCK)
		 where sourcecomponentname 		 = 'ACAP'
		 and 	sourceouinstid	  		 = @ctxt_ouinstance
		 and 	destinationcomponentname = 'AINQ'
		 and 	destinationouinstid		 = @ctxt_ouinstance 
	end
	else
	begin
		 select @ainq_ou = min(destinationouinstid)
		 from fw_admin_view_comp_intxn_model(NOLOCK)
		 where sourcecomponentname 		 = 'ACAP'
		 and 	sourceouinstid	  		 = @ctxt_ouinstance
		 and 	destinationcomponentname = 'AINQ'
	end

	/*CWIPTRF_074	Create Accounting entry	"Invoke service AinqSerAcPost of Asset Inquiry to create the following accounting entry.  	Dr CWIP a/c as returned from the service	Cr Usage Account Code	with Transfer Amount(for combination of Target asset class, T
a












rget asset proposal capital work order no)	*/
	
	
	exec ainq_is_spaccountingpost @ainq_ou,@ctxt_service,@ctxt_language,@ctxt_ouinstance,
								   'AinqSerAcPostTrn1',@ctxt_user,@newguid_tmp,@errorcode_tmp output
		
	if  isnull(@errorcode_tmp,0) <> 0 
	begin
	
		if @ctxt_user = 'debuguser$'
		begin
			select 'Error in Ainq Postings.',@errorcode_tmp
		end
		
		--Error in Ainq Postings.
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2002
		select @m_errorid = 2002
		return
	end
	
	
	
	if exists (select 'x' from fw_admin_view_comp_intxn_model(NOLOCK)
	 where sourcecomponentname 		 = 'AINQ'
	 and 	sourceouinstid	  		 = @ctxt_ouinstance
	 and 	destinationcomponentname = 'FBP'
	 and 	destinationouinstid		 = @ctxt_ouinstance )

	 begin
		 select @fbdestou_tmp = destinationouinstid
		 from fw_admin_view_comp_intxn_model(NOLOCK)
		 where sourcecomponentname 		 = 'AINQ'
		 and 	sourceouinstid	  		 = @ctxt_ouinstance
		 and 	destinationcomponentname = 'FBP'
		 and 	destinationouinstid		 = @ctxt_ouinstance 
	end
	else
	begin
		 select @fbdestou_tmp = min(destinationouinstid)
		 from fw_admin_view_comp_intxn_model(NOLOCK)
		 where sourcecomponentname 		 = 'AINQ'
		 and 	sourceouinstid	  		 = @ctxt_ouinstance
		 and 	destinationcomponentname = 'FBP'
	end
	
	--CWIPTRF_069a	FbSerPostTran2 - FS postings validation	Invoke service FbSerPostTran2 from Finance Book Processing component.  Give the generated account posting information for validation.  Errors would be returned by the service
	exec 	fbp_is_sptrnpostings1 
			@fbdestou_tmp, 
			'AINQSERACPOSTTRN1', 
			@ctxt_language,   
			@ctxt_ouinstance, 
			'FBPSrTrnposting', 
			@ctxt_user,
			'Y',
			'N', 
			@newguid_tmp, 
			@err_tmp output ,
			@emsg_tmp output

	if isnull(@err_tmp,0) <> 0
	begin
		
		if @ctxt_user = 'debuguser$'
		begin
			select 'Error in FBP Postings.',@err_tmp, @emsg_tmp
		end
	
		exec fin_fbp_error_handle @ctxt_language,@err_tmp, @emsg_tmp
		select	@m_errorid = @err_tmp
		return @m_errorid
	end

	if @ctxt_user = 'debuguser$'
	begin
		select 'capital cwip for target - ainq and fbp'
		select  'ainq_accounting_info_dtl' , * from ainq_accounting_info_dtl (nolock)
		where tran_number       = @documentnumber 
		select 'fbp_posted_trn_dtl',* from fbp_posted_trn_dtl (nolock)
		where  document_no	      = @documentnumber 
	end
	
	
	if exists (select 'x' from fw_admin_view_comp_intxn_model(NOLOCK)
	 where sourcecomponentname 	 = 'ACAP'
	 and 	sourceouinstid	  	 = @ctxt_ouinstance
	 and 	destinationcomponentname = 'SI'
	 and 	destinationouinstid		 = @ctxt_ouinstance )

	 begin
		 select @si_ou = destinationouinstid
		 from fw_admin_view_comp_intxn_model(NOLOCK)
		 where sourcecomponentname 		 = 'ACAP'
		 and 	sourceouinstid	  		 = @ctxt_ouinstance
		 and 	destinationcomponentname = 'SI'
		 and 	destinationouinstid		 = @ctxt_ouinstance 
	end
	else
	begin
		 select @si_ou = min(destinationouinstid)
		 from fw_admin_view_comp_intxn_model(NOLOCK)
		 where sourcecomponentname 		 = 'ACAP'
		 and 	sourceouinstid	  		 = @ctxt_ouinstance
		 and 	destinationcomponentname = 'SI'
	end
	
	delete 	acap_updinvoice_tmp
	where 	guid = @newguid_tmp
	and	doc_type = 'INV_IMIS'
	
		
	if exists (select 'b' from  	acap_updinvoice_tmp(nolock)
				where 	guid = @newguid_tmp)
				
	begin
		/*CWIPTRF_083	Update Pending Capitalization amount - source doc	If document/s type = SO Based Invoice" invoke service SinSerAcapTrn3 of "Supplier Order Based Invoice", else if the selected document/s type = "Supplier Direct Invoice" invoke service Sdin





s










erAcaptrn3 of "Direct Invoice", else if the selected document/s type = "Sundry Payment" invoke service SnpSerAcapTrn3 of "Sundry Payment" else if the document/s type = "Supplier Note" invoke service ScdnSerAcapTrn3 else if document type = Supplier payment













 invoke service SpySerAcapTrn3 of Supplier payment else if document type is Inventory Issue invoke service from Stock issue, for updation of Pending capitalization amount. Provide Input 1. Login OU 2. Document type 3. Document date 4. Transfer Amount. Pen













ding capitalization = document amount - sum of already capitalized amounts (both Asset and WIP) - Transfer WIP amount  at each line level*/
		--exec sispcapamt @si_ou,'ACAPWAUMSRAUTH',@ctxt_language,@ctxt_ouinstance,'SIISCapAmt',
		--				@ctxt_user,@newguid_tmp,@errorcode_tmp output
		
		exec si_update_capamt_sp @newguid_tmp,'SIISCapAmt','ACAPWAUMSRAUTH',@si_ou,@errorcode_tmp output

		if  isnull(@errorcode_tmp,0) <> 0 
		begin
		
			if @ctxt_user = 'debuguser$'
			begin
				select 'Error in SI Postings.',@errorcode_tmp
			end
			
			IF @errorcode_tmp = 500
			begin
				--2049	The document has been capitalised already.
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2049
				select @m_errorid = 2049
				return
			end
			else
			begin
				--Error in SI Postings.
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,2003
				select @m_errorid = 2003
				return
			end
		end
	end	
	----------APLAN Updation-----------
		if exists (select 'x' from fw_admin_view_comp_intxn_model(NOLOCK)
	 where sourcecomponentname 	 = 'ACAP'
	 and 	sourceouinstid	  	 = @ctxt_ouinstance
	 and 	destinationcomponentname = 'APLAN'
	 and 	destinationouinstid		 = @ctxt_ouinstance )

	 begin
		 select @aplan_ou = destinationouinstid
		 from fw_admin_view_comp_intxn_model(NOLOCK)
		 where sourcecomponentname 		 = 'ACAP'
		 and 	sourceouinstid	  		 = @ctxt_ouinstance
		 and 	destinationcomponentname = 'APLAN'
		 and 	destinationouinstid		 = @ctxt_ouinstance 
	end
	else
	begin
		 select @aplan_ou = min(destinationouinstid)
		 from fw_admin_view_comp_intxn_model(NOLOCK)
		 where sourcecomponentname 		 = 'ACAP'
		 and 	sourceouinstid	  		 = @ctxt_ouinstance
		 and 	destinationcomponentname = 'APLAN'
	end
	----EPE-31320

	select @exchange_rate = tran_erate ,
			@tran_currency	=tran_currency
	from acap_cwiptransfer_src_tmp(nolock)
	where	guid				= @guid
	----EPE-31320
	insert into acap_updproposal_tmp 
	(guid, proposal_number, asset_class, fb_id, tran_amount, tran_date,
 	createdby, createddate, upd_flag ,tran_currency,tran_erate) ----EPE-31320
	select @newguid_tmp, @proposal_no, @assetclass, @fb, round( ( @wip_amount/@exchange_rate),@pamt_tmp),@transactiondate, 
	@ctxt_user,dbo.RES_Getdate(@ctxt_ouinstance), 'CRE' ,@tran_currency,@exchange_rate ----EPE-31320
			
	
		
	/*CWIPTRF_093	Proposal Value Updation -1 - Target doc	When the proposal Currency is different from Base currency then execute service '****' from Erate to fetch the exchange rate between Base Currency and the Target Proposal currency and conversion of th













e same has to happen before updation of Asset proposal with the Liability amount and balance amount	CWIPTRF_094	Proposal Value Updation -2 - Target doc	When the Target proposal Currency is different from Base currency then execute service '****' from Erat













e to fetch the exchange rate between Base Currency and the proposal currency as on transfer date for the exchange rate specified in CPS as exchange rate for Fixed Assets and if there are no available exchange rate then throw error	CWIPTRF_095	Proposal Val













ue Updation - 3 - Target doc	"On authorization of transfer the liability amount of the Target Asset Proposal will be updated with the	existing liability amount + CWIP Amount	and Balance amount will be updated with the existing Balance amount - CWIP amount













 at each line level"
	CWIPTRF_096	Proposal Value Updation - 4 - Target doc	"If Asset Capitalization is mapped to Asset Planning in CIM then for the selected row in the multiline fetch the Target proposal no/s. Invoke service AplanSerTrn4 of Asset Planning for updation the Lia













bility amount and balance amount.	Liability Amount =  existing liability amount plus  Transfer CWIP Amount	and Balance amount will be updated with the existing Balance amount minus CWIP amount at each line level	along with capital work order no. for the s













ame as document reference"	*/
	--orginal service : ACA_TIAC_Sr_Aut , but interpreted as "acap_trfcwip" for target cwip doc and as "acap_trfrevcwip" for source reversal cwip doc
	exec  aplan_sys_post_proposal  	@ctxt_language, /*@ctxt_ouinstance*/@aplan_ou, 'AplanSerProTrn4', @ctxt_user,--ES_ACAP_00821
									@newguid_tmp,	@aplan_ou,	'acap_trfcwip',	@errorcode_tmp  output
									
								 
	if  isnull(@errorcode_tmp,0) <> 0 
	begin
	
		if @ctxt_user = 'debuguser$'
		begin
			select 'Error in Aplan Updation.',@errorcode_tmp
		end
		
		select @m_errorid = @errorcode_tmp 
		return
	end
		
	if exists( 	select 	'X'
			from 		acap_wip_line_tmp(nolock)
			where 	guid  = @newguid_tmp )	
	begin
			delete 		acap_wip_line_tmp
			where 	guid  = @newguid_tmp
	end
		
	if exists( 	select 	'X'
			from 	acap_wip_accounting_tmp(nolock)
			where 	guid  = @newguid_tmp )	
	begin
			delete 	acap_wip_accounting_tmp
			where 	guid  = @newguid_tmp
	end
	
	
	if exists( 	select 	'X'
			from 	acap_updproposal_tmp(nolock)
			where 	guid  = @newguid_tmp )	
	begin
			delete 	acap_updproposal_tmp
			where 	guid  = @newguid_tmp
	end
		
		
	if exists( 	select 	'X'
			from 	acap_updinvoice_tmp(nolock)
			where 	guid  = @newguid_tmp )	
	begin
			delete 	acap_updinvoice_tmp
			where 	guid  = @newguid_tmp
	end
		
	set nocount off
			 
end
 






















