/*$File_version=ms4.3.0.05$*/
/********************************************************************************/
/* Procedure					: ABRoprtmnSpAuthrtpydt							*/
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
/* Author						: Veangadakrishnan R							*/
/* Date							: Aug  6 2010  9:18AM							*/
/********************************************************************************/
/* Modification History			: 												*/
/********************************************************************************/
/* Modified By: 				Date:				Description:				*/
/* Veangadakrishnan R			18/08/2010			ES_abr_00031(10H109_ABR_00001:10H109_ABR_00024)*/
/* Veangadakrishnan R			18/08/2010			ES_abr_00031(10H109_ABR_00001:10H109_ABR_00025)*/
/* Veangadakrishnan R			18/08/2010			ES_abr_00031(10H109_ABR_00001:10H109_ABR_00029)*/
/* Ashok V						01/05/2017			ES_abr_00655				*/
/*Ayush K						06/06/2018			EPE-6865					*/
/*Ayush K						03/07/2018			EPE-7777					*/
/*Ayush K						03/07/2018			EPE-7772					*/
/*Anusha.p                      07/05/2018                 EPE-7839  */
/*Srinivasan M                  28/06/2023          RRSA-31*/
/*Srinivasan M                  18/08/2023          RRSA-45*/
/********************************************************************************/

CREATE Procedure ABRoprtmnSpAuthrtpydt
	@ctxt_ouinstance   	fin_ctxt_ouinstance, --Input 
	@ctxt_user         	fin_ctxt_user, --Input 
	@ctxt_language     	fin_ctxt_language, --Input 
	@ctxt_service      	fin_ctxt_service, --Input 
	@amount            	fin_amount, --Input 
	@bankaccountnumber 	fin_banknumber, --Input 
	@banknohdr         	fin_bankname, --Input 
	@checknumber       	fin_checknumber, --Input 
	@companyref        	fin_checknumber, --Input 
	@dateml            	fin_date, --Input 
	@depositingpoint   	fin_ouinstname, --Input 
	@documentno        	fin_documentno, --Input 
	@guid              	fin_guid, --Input 
	@hidden_control1   	fin_hiddencontrol, --Input 
	@hidden_control2   	fin_hiddencontrol, --Input 
	@modeflag          	fin_modeflag, --Input 
	@ouinstid          	fin_ouinstid, --Input 
	@remarks           	fin_text255, --Input 
	@timestamp         	fin_timestamp, --Input 
	@tranouid          	fin_ouinstid, --Input 
	@transactionou     	fin_transactionou, --Input 
	@transactiontypeml 	fin_transactiontype, --Input 
	@trantypeid        	fin_transactiontype, --Input 
	@fprowno           	fin_fprowno, --Input/Output
	@documenttypeml    	fin_documenttype, --EPE-6865
	@doctypeid         	fin_transactiontype, --EPE-6865
	@m_errorid         	fin_int output --To Return Execution Status
as
begin
	-- nocount should be switched on to prevent phantom rows
	set nocount on
	-- @m_errorid should be 0 to indicate success
	set @m_errorid = 0

	--declaration of temporary variables
	declare @tran_date				fin_date
	declare @company_code			fin_companycode
	declare @company_min_start_date fin_date 
	declare @bkaccfb_min_start_date fin_date 
	declare @bkaccfb_min_efffr_date fin_date
	declare @strtdate				fin_date -- EPE-6865
	declare @min_fb_startdate		fin_date
	declare @trandate               fin_date 
	declare @dateml_tmp             fin_desc255
	--temporary and formal parameters mapping

	set @ctxt_user          = ltrim(rtrim(@ctxt_user))
	set @ctxt_service       = ltrim(rtrim(@ctxt_service))
	set @bankaccountnumber  = ltrim(rtrim(@bankaccountnumber))
	set @banknohdr          = ltrim(rtrim(@banknohdr))
	set @checknumber        = ltrim(rtrim(@checknumber))
	set @companyref         = ltrim(rtrim(@companyref))
	set @depositingpoint    = ltrim(rtrim(@depositingpoint))
	set @documentno         = ltrim(rtrim(@documentno))
	set @guid               = ltrim(rtrim(@guid))
	set @hidden_control1    = ltrim(rtrim(@hidden_control1))
	set @hidden_control2 = ltrim(rtrim(@hidden_control2))
	set @modeflag           = ltrim(rtrim(@modeflag))
	set @remarks            = ltrim(rtrim(@remarks))
	set @transactionou      = ltrim(rtrim(@transactionou))
	set @transactiontypeml  = ltrim(rtrim(@transactiontypeml))
	set @trantypeid = ltrim(rtrim(@trantypeid))
	Set @documenttypeml     = ltrim(rtrim(@documenttypeml)) --EPE-6865
	Set @doctypeid          = ltrim(rtrim(@doctypeid)) --EPE-6865

	--null checking

	if @ctxt_ouinstance = -915
		select @ctxt_ouinstance = null  

	if @ctxt_user = '~#~' 
		select @ctxt_user = null  

	if @ctxt_language = -915
		select @ctxt_language = null  

	if @ctxt_service = '~#~' 
		select @ctxt_service = null  

	if @amount = -915
		select @amount = null  

	if @bankaccountnumber in ('~#~' ,'')
		select @bankaccountnumber = null  

	if @banknohdr = '~#~' 
		select @banknohdr = null  

	if @checknumber in ('~#~' ,'')
		select @checknumber = null  

	if @companyref in ('~#~' ,'')
		select @companyref = null  

	if @dateml = '01/01/1900' 
		select @dateml = null  

	if @depositingpoint in ('~#~' ,'')
		select @depositingpoint = null  

	if @documentno in ('~#~' ,'')
		select @documentno = null  

	if @guid = '~#~' 
		select @guid = null  

	if @hidden_control1 = '~#~' 
		select @hidden_control1 = null  

	if @hidden_control2 = '~#~' 
		select @hidden_control2 = null  

	if @modeflag = '~#~' 
		select @modeflag = null  

	if @ouinstid = -915
		select @ouinstid = null  

	if @remarks in ('~#~' ,'')
		select @remarks = null  

	if @timestamp = -915
		select @timestamp = null  

	if @tranouid = -915
		select @tranouid = null  

	if @transactionou = '~#~' 
		select @transactionou = null  

	if @transactiontypeml = '~#~' 
		select @transactiontypeml = null  

	if @trantypeid = '~#~' 
		select @trantypeid = null  

	if @fprowno = -915
		select @fprowno = null

	IF @documenttypeml = '~#~' 
		Select @documenttypeml = null --EPE-6865

	IF @doctypeid = '~#~' 
		Select @doctypeid = null  --EPE-6865

	select @tran_date = convert(nvarchar(11),dbo.RES_Getdate(@ctxt_ouinstance),120)

	select	@company_code = company_code
	from	emod_ou_vw(nolock)
	where	ou_id = @ctxt_ouinstance
	and		@tran_date between isnull(effective_from,@tran_date) and isnull(effective_to,@tran_date)  
	
	
	if @modeflag = 'D'
	begin
		select	@fprowno 'FPROWNO'	

		if exists(	select	'X'
					from	abr_opunrecon_rptpy_dtl(nolock)
					where	bank_acc_no  = @bankaccountnumber	
					and		company_code = @company_code
					and		tran_no		 = @documentno 
					and		tran_ou		 = @tranouid
					and		tran_type	 = @trantypeid)
		begin
			delete from abr_opunrecon_rptpy_dtl
			where	bank_acc_no  = @bankaccountnumber	
			and		company_code = @company_code
			and		tran_no		 = @documentno 
			and		tran_ou		 = @tranouid
			and		tran_type	 = @trantypeid		
		end

		return --epe-6865
	end




	if @dateml is null
	begin
		--raiserror('Enter Date. at row no. %d',16,1,@fprowno)
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,1020,@fprowno
		return
	end

	if @documentno is null
	begin
		--raiserror('Enter Document No. at row no. %d',16,1,@fprowno)
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,1021,@fprowno
		return
	end

	if (@tranouid = 0) or (@tranouid is null)
	begin
		--raiserror('Enter Transaction OU at row no. %d',16,1,@fprowno)
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,1024,@fprowno
		return
	end

	if @amount is null
	begin
		--raiserror('Enter Amount. at row no. %d',16,1,@fprowno)
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,1022,@fprowno
		return
	end

	/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001:10H109_ABR_00025) starts here*/
	if @amount <= 0
	begin
		--raiserror('Amount should be greater than zero at row no. %d',16,1,@fprowno)
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,1025,@fprowno
		return
	end
	/*Code added for DTS ID: ES_abr_00031(10H109_ABR_00001:10H109_ABR_00025) ends here*/

	/*ABR000112
	Date would be less than the first financial period start date (Legacy period - No) 
	for the first financial year.(if the FBs of the bank codes of the selected bank acc no 
	is equal to first fin period start date) else display error*/

	select	@company_min_start_date = min(finprd_startdt) 
	from	as_finyearperiod_vw(nolock)
	where	company_code = @company_code
	and		legacy_data	= 'NO'


	/*code added for epe-6865 starts*/
	declare @fb_mindate			table
			(
				fb				fin_financebookid,
				mindate			fin_date	
			)
	declare	@financial_period	fin_financeperiod,
			@financial_year		fin_financeyear,
			@statstdt_tmp		fin_date,
			@curcode			fin_currencycode,
			@metadata_exist		fin_flag,
			@fb_id				fin_financebookid,
			@tran_amount        fin_amount--code added by RRSA-45
			
				

	select	@metadata_exist		=	'N'
	
	select	@financial_period	=	financial_period,
			@financial_year		=	financial_year,
			@metadata_exist		=	'Y'
	from	abr_bank_recon_start(nolock)
	where	company_code		=	@company_code
	and		bank_accountno		=	@bankaccountnumber
	
	if isnull(@financial_period,'') <> ''
	begin
		select  @statstdt_tmp	=	fin_period_stdt
		from	fbp_fin_year_period_vw(nolock)
		where	company_code	=	@company_code
		and		fin_period_code	=	@financial_period
		and		fin_year_code	=	@financial_year

		if isnull(@documenttypeml,'')  = ''
		begin
				raiserror('Select Document type at row no. %d',16,1,@fprowno)
				return
		end

	end 
	
	/*code added for epe-6865 ends*/
	;
	with bank_acc_fb(fb_id) as (select	distinct fb_id
								from	bnkdef_code_mst(nolock)
								where	company_code = @company_code
								and		bank_acc_no	 = @bankaccountnumber
								and		status = 2)
	select	@bkaccfb_min_start_date = min(fin_period_stdt)
	from	fcc_sysact_allperiod_vw p(nolock),
			bank_acc_fb b
	where	p.company_code = @company_code
	and		p.fb_id = b.fb_id

	if @metadata_exist		=	'N'
	begin
	if @company_min_start_date = @bkaccfb_min_start_date
	begin
		if @dateml >= @company_min_start_date --10H109_ABR_00029
		begin
			--raiserror('Date should be earlier than First Financial period Start Date with Legacy period as No. Modify date at row no. %d',16,1,@fprowno)
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,1009,@fprowno
			return
		end
	end
	end--epe-6865

	/* Code added for EPE-6865 starts here */
	--1
	if @ctxt_service in('ABRoprtmnSrSave' , 'ABRoprtmnSrAuth')
	begin
		--declare @doctypeid fin_Desc40
		declare @bank_code  fin_desc40
		declare @bankptt_account fin_desc40

	

		--select 	@doctypeid =parameter_code
		--from 	fin_quick_code_met (nolock)
		--where  component_id 		=	'ABR'
		--and    parameter_type		=	'COMBO'	
		--and    parameter_category	=	'DESCTYP'
		--and		parameter_text		=	@documenttypeml		
		--and 	language_id			=	@ctxt_language


	if @trantypeid  in('CP','PY')				-- Code added for EPE-7772
	begin 
			if @doctypeid  in ('RM_SR','RM_RV','PM_SRC','HR') --Code added for EPE-7772
			begin
				--select 'error'
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,3001,@transactiontypeml,@documenttypeml,@fprowno
				return
			end
	end
	-- 2
	if @trantypeid  in('CR','RT')			--Code added for EPE-7777
	begin 
			if @doctypeid not in ('RM_SR','RM_RV','PM_SRC','HR')   --Code added for EPE-7777
			begin
				--select 'error'
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,3001,@transactiontypeml,@documenttypeml,@fprowno
				return
			end
	end
	--3

	
	if @metadata_exist		=	'Y'
	begin
			if @dateml >= @statstdt_tmp
			begin
				--SELECT 'error1'
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,3002,@strtdate
				return
			end


	--4
			select  @fb_id	=	fb_id,
			 @trandate = tran_date
			from	fbp_posted_trn_dtl(nolock)
			where	document_no = @documentno
			and		tran_ou		= @tranouid
			and		tran_type	= @doctypeid
			--EPE-7839

	 --code added by RRSA-45--
          declare @accountcode_tbl	table
			(
				account_code		fin_account_code,
				bank_code           fin_bankcashcode,
				fb_id				fin_financebookid	
			)

	       insert into @accountcode_tbl
			(
					account_code, bank_code,fb_id			  
			)
				
			select	bankptt_account , bank_ptt_code,ard.fb_id
			from	bnkdef_code_mst bnk (nolock),
					ard_bnkcsh_account_mst ard (nolock)   
			where	ard.company_code		=	@company_code
			and		bnk.company_code		=	@company_code
			and		bnk.bank_acc_no			=	@bankaccountnumber
			and		bnk.bank_code			=	ard.bank_ptt_code
			and		bnk.flag				=	'B'     
			and		bnk.status				=	'2' 
			and		bnk.fb_id				=	ard.fb_id    
			and		bnk.flag				=	ard.flag    
			and		@trandate				between ard.effective_from and isnull(ard.effective_to,@trandate) 


		select @tran_amount=sum(case when drcr_flag = 'CR' then tran_amount else -tran_amount end)
		from  fbp_posted_trn_dtl (nolock) dtl
		where dtl.account_code in ( select account_code from  @accountcode_tbl)
		and document_no = @documentno  
		and  tran_ou  = @tranouid  
		and  tran_type = @doctypeid

        select @tran_amount =abs(@tran_amount)

   
  --code added by RRSA-45--
			
			if @fb_id is not  null and  @dateml <>  @trandate
			 begin 
			 --Document No.%s of document type %s at Transaction OU %s for the Date %s does not exist. Modify document details at row no.%d
			   select @dateml_tmp = convert( nvarchar, @dateml,103)
			     exec fin_german_raiserror_sp 'ABR',@ctxt_language,3004,@documentno,@documenttypeml,@transactionou,@dateml_tmp,@fprowno
				return
			 end
			 --EPE-7839
			  --code added by RRSA-45--
	         if @fb_id is not  null and @amount<> @tran_amount
	          begin   
				select @dateml_tmp = convert( nvarchar, @dateml,103)  
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,1900030017,@fprowno,@documentno
				return  
				end 
      --code added by RRSA-45--
			 
			if @fb_id is null and @dateml >= @bkaccfb_min_start_date
			begin
				--SELECT 'error2'
				exec fin_german_raiserror_sp 'ABR',@ctxt_language,3003,@documentno,@documenttypeml,@transactionou,@fprowno
				return
			end

	end
	end
	/*if @ctxt_service = 'ABRoprtmnSrAuth'
	begin
		select @bank_code  = bank_code
		from  bnkdef_code_mst (nolock)
		where bank_acc_no = @bankaccountnumber 

		select @bankptt_account  = bankptt_account
		from  ard_bnkcsh_account_mst  (nolock) 
		where bank_ptt_code		=  @bank_code

		update  fbp_posted_trn_dtl
		set		recon_flag		= 'R'
		where	account_code	= @bankptt_account
		and		document_no		= @documentno
		and		tran_type		= @doctypeid
		end

	end*/
	
	/* Code added for EPE-6865 ends here */

	/*ABR000113
	Date would be less than the first financial period start date (Legacy period - No) for the first financial year. 
	If the Bank account is mapped to Finance Books which have effective from date later than the first 
	financial period start date (Legacy Period ?N0), then the validation would be that the transaction dates 
	should be less than the earliest FB Effective from date. else display error*/
	
	;
	with bank_acc_fb(fb_id) as (select	distinct fb_id
								from	bnkdef_code_mst(nolock)
								where	company_code = @company_code
								and		bank_acc_no	 = @bankaccountnumber
								and		status = 2)
	select  @bkaccfb_min_efffr_date = min(effective_from)
	from	emod_bu_ou_fb_map f(nolock),
			bank_acc_fb b
	where	f.fb_id		= b.fb_id
	and		map_status	= 'M'
	
	/*code added for the defect id: ES_abr_00655 starts*/
	if @bkaccfb_min_efffr_date > @company_min_start_date and  @metadata_exist =	'N' --code added BY RRSA-31
	begin
	/*code added for the defect id: ES_abr_00655 ends*/
		if @dateml >= @bkaccfb_min_efffr_date --10H109_ABR_00029
		begin
			--raiserror('Date should be less than effective date of the Finance Book of the Bank Code for the Bank Account No. Modify date at row no. %d',16,1,@fprowno)
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,1010,@fprowno
			return
		end
	end--code added for the defect id: ES_abr_00655 
	/*ABR000114
	IF Tran type is chosen as Check Payment / Check Receipt then it is proposed to validate that whether 
	Cheque no is provided else error would be displayed */
	--TRANSACTIONTYPEML	TRANTYPEID
	--Check Payment	CP
	--Check Receipt	CR
	--Payment		PY
	--Receipt		RT

	if @trantypeid in ('CP','CR')
	begin
		if @checknumber is null
		begin
			--raiserror('Enter Check No. for Transaction Type - Check Payment / Check Receipt at row no. %d',16,1,@fprowno)
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,1011,@fprowno
			return
		end
	end

	/*ABR000115
	IF Tran type is chosen as Payment / Receipt then it is proposed to validate that whether 
	Cheque no is not provided else error would be displayed */

	if @trantypeid in ('PY','RT')
	begin
		if @checknumber is not null
		begin
			--raiserror('Check Number should be given only for Transaction Type - Check Payment / Check Receipt. Please Check at row no. %d',16,1,@fprowno)
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,1012,@fprowno
			return
		end
	end

	/*ABR000116
	IF Tran type is chosen as Check Receipt then it is proposed to validate that whether 
	Depositing Point is provided else error would be displayed*/

	if ((@trantypeid = 'CR' and @depositingpoint is null) or (@trantypeid != 'CR' and @depositingpoint is not null))
	begin
		--raiserror('Depositing Point should be given only for Transaction Type - Check Receipt. Please Check at row no. %d',16,1,@fprowno)
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,1013,@fprowno
		return
	end

	/*ABR000117
	IF Tran type is chosen as Check Payment / Check Receipt then it is proposed to validate that whether 
	Company Reference / LC Number no is not provided else error would be displayed*/

	if (@trantypeid in ('CP','CR') and @companyref is not null)/*Modified for DTS ID: ES_abr_00031(10H109_ABR_00001:10H109_ABR_00024)*/
	begin
		--raiserror('Company Reference/LC Number should be given only for Transaction Type - Payment/Receipt. Please Check at row no. %d',16,1,@fprowno)	
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,1014,@fprowno
		return
	end
	

	if @modeflag in ('I','X')
	begin
		if exists(	select	'X'
					from	abr_opunrecon_rptpy_dtl(nolock)
					where	bank_acc_no  = @bankaccountnumber	
					and		company_code = @company_code
					and		tran_no		 = @documentno 
					and		tran_ou		 = @tranouid
					and		tran_type	 = @trantypeid)
		begin
			--raiserror('Transaction Type, Document No. and Transaction OU combination at row no. %d is already exist.',16,1,@fprowno)
			exec fin_german_raiserror_sp 'ABR',@ctxt_language,1023,@fprowno
			return			
		end

		insert abr_opunrecon_rptpy_dtl(
			company_code,			bank_acc_no,			tran_type,
			tran_no,				tran_ou,				tran_date,
			depositing_ou,			check_no,				tran_amount,
			remarks,				company_ref_no,			status,
			created_by,				created_date
			,documenttype)--EPE-6865
		values(
			@company_code,			@bankaccountnumber,		@trantypeid,
			@documentno,			@tranouid,				@dateml,
			@depositingpoint,		@checknumber,			@amount,
			@remarks,				@companyref,			'U',
			@ctxt_user,				@tran_date
			,@doctypeid)	--EPE-6865
	end

	if @modeflag in ('U','Y','S','Z')
	begin
		update	abr_opunrecon_rptpy_dtl
		set		tran_date		=	@dateml,
				depositing_ou	=	@depositingpoint,
				check_no		=	@checknumber,
				tran_amount		=	@amount,
				remarks			=	@remarks,
				company_ref_no	=	@companyref,
				modified_by		=	@ctxt_user,
				modified_date	=	@tran_date
				,documenttype	=	@doctypeid --EPE-6865
		where	bank_acc_no  = @bankaccountnumber	
		and		company_code = @company_code
		and		tran_no		 = @documentno 
		and		tran_ou		 = @tranouid
		and		tran_type	 = @trantypeid
	end	

	select	@fprowno+1 'FPROWNO'	
	
set nocount off

end





