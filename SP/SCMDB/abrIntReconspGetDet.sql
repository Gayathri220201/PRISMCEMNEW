/*$File_version=ms4.3.0.09$*/ 
/***************************************************************************************
 File Name         : ABRINTRECONSPGETDET.SQL                              
 Version           : 4.0.0.007                                                       
***************************************************************************************
 Procedure Name    : ABRINTRECONSPGETDET                                  
 Purpose           : Get multiline details
 Author            : S.BALAJI                                         
 Date              : 26/Mar/2004                             
 Component Name    : ABR                                 
 Method Name-ID    : abrIntReconMtGetDet-1755122191                                          
 Object Referred   :
 Object Name                    Object Type             Operation                         

 Modification Details                                                                     
 Modified By	: S.balaji		    
 Modified On	: 15/apr/2004
 Remarks        : ABRDMS41UTST_000002:-DEPLOYMENT OF DMS41 CHANGES FOR ABR	                   

 Modified By	: Uma Maheswari    
 Modified On	: 7th oct 2004
 Remarks        : ABRFIN41CT_000005 -Unresolved objects

 Modified By	: Nagarajan G
 Modified On	: 29/12/2005
 Remarks        : ABRBASEFIXES_000112

Modified By                    	Modified On             Remarks         
Vairamani C		        22nd Mar 2006		ABRDMS412AT_000014
Vairamani C			23 Mar 2006		ABRDMS412AT_000016
Uma Maheswari			5th May 2006		CML Changes	
Vairamani C			Oct 16 2006		ABRDMS412AT_000069	
Vairamani C			Oct 26 2006		ABRDMS412AT_000069	
Guhan Shanmugam K		18/01/2007		ABRDMS412AT_000077		
Ravikrishnan.N			30/Mar/2007		ABRDMS412AT_000077
Aditya S				16/02/2016		ES_abr_00534
Kavitha R				11/08/2016		14H109_ABR_00021
Ashok V					07/09/2016		ES_abr_00615
Aditya S				09/02/2017		ES_abr_00671
Aditya S				26/07/2017		VE-3078	
Anusha.p                01/03/2018     epe-5821,epe-6317
gokul M					16/10/2020		epe-23544:epe-26281:EPE-26459
Srinivasan M            09/11/2022      TIS-523
*******************************************************************************************/
Create PROCEDURE abrIntReconspGetDet
         @ctxt_language                fin_ctxt_language,
         @ctxt_ouinstance              fin_ctxt_ouinstance,
         @ctxt_service                 fin_ctxt_service,
         @ctxt_user                    fin_ctxt_user,
         @fbid                         fin_financebookid,
         @route                        fin_route,
         @bankpttnum                   fin_bankcode,
         @doctype                      fin_documenttype,
         @docdatefrom                  fin_date,
         @docdateto                    fin_date,
         @defdate                      fin_date,
         @statementnumber              fin_documentno,
         @guid                         fin_guid,
         @hidden_control1              fin_hiddencontrol,
		 @transfervouchernofrom 	   fin_documentno, --epe-5821
	     @transfervouchernoto   	   fin_documentno,--epe-5821
		 @retrievetrfvch        	checkbox,
         @m_errorid                    fin_int   output
AS

BEGIN
        SET NOCOUNT ON

	-- Declaration of temporary variables 
	declare      @ctxt_language_tmp                fin_ctxt_language
	declare      @ctxt_ouinstance_tmp              fin_ctxt_ouinstance
	declare      @ctxt_service_tmp                 fin_ctxt_service
	declare      @ctxt_user_tmp                    fin_ctxt_user
	declare      @fbid_tmp                         fin_financebookid
	declare      @route_tmp                        fin_route
	declare      @bankpttnum_tmp     fin_bankcode
	declare      @doctype_tmp                      fin_documenttype
	declare      @docdatefrom_tmp                  fin_date
	declare      @docdateto_tmp                    fin_date
	declare      @defdate_tmp           fin_date
	declare  @statementnumber_tmp              fin_documentno
	declare      @guid_tmp                         fin_guid
	declare      @hidden_control1_tmp              fin_hiddencontrol



	declare 	@tran_type_code_tmp  	fin_paramcode,   
			@company_code_tmp	fin_companycode,  
			@temp1			fin_trantype,--	nvarchar(10),
			@temp2			fin_trantype,--	nvarchar(10),
			@temp3			fin_trantype,--	nvarchar(10),
			@temp4			fin_trantype,--	nvarchar(10),
			@temp5			fin_trantype, --	nvarchar(10)
			@temp6			fin_trantype /*Code Added By Guhan Shanmugam K for the Bug Id : ABRDMS412AT_000077 */
			--@temp6			nvarchar(10),
			--@temp7			nvarchar(10),
			--@temp8			nvarchar(10),
			--@temp9			nvarchar(10),
			--@temp10			nvarchar(10),
			--@temp11			nvarchar(10),
			--@temp12			nvarchar(10),
			--@temp13			nvarchar(10),
			--@temp14			nvarchar(10),
			--@temp15			nvarchar(10)

	-- Temporary and Formal parameters mapping
	SELECT    @Ctxt_Language_tmp                  =     @Ctxt_Language
	SELECT    @ctxt_OUInstance_tmp                =     @ctxt_OUInstance
	SELECT    @Ctxt_Service_tmp                   =     LTRIM(RTRIM(@Ctxt_Service))
	SELECT    @ctxt_User_tmp                      =     LTRIM(RTRIM(@ctxt_User))
	SELECT    @FBID_tmp                           =     LTRIM(RTRIM(@FBID))
	SELECT    @Route_tmp                          =     LTRIM(RTRIM(@Route))
	SELECT    @BankPTTNum_tmp                     =     LTRIM(RTRIM(@BankPTTNum))
	SELECT    @DocType_tmp                        =     LTRIM(RTRIM(@DocType))
	SELECT    @docdatefrom_tmp                    =     @docdatefrom
	SELECT    @docdateto_tmp                      =     @docdateto
	SELECT    @DefDate_tmp                        =     @DefDate
	SELECT    @Statementnumber_tmp                =     LTRIM(RTRIM(@Statementnumber))
	SELECT    @guid_tmp                           =     LTRIM(RTRIM(@guid))
	SELECT    @Hidden_Control1_tmp                =     LTRIM(RTRIM(@Hidden_Control1))
	Select @transfervouchernofrom  = ltrim(rtrim(@transfervouchernofrom))  --epe-5821
	Select @transfervouchernoto    = ltrim(rtrim(@transfervouchernoto)) --epe-5821

	IF @transfervouchernofrom = '~#~' 
		Select @transfervouchernofrom = null   --epe-5821

	IF @transfervouchernoto = '~#~' 
		Select @transfervouchernoto = null  --epe-5821

	IF @retrievetrfvch = '~#~' 
		Select @retrievetrfvch = null  --epe-5821



	declare @all_tmp	fin_param_text
	/*14H109_ABR_00021*/
			,@today				fin_date, 
			@int_acc_param		fin_paramcode,
			@compcode_tmp		fin_companycode
	

	select @today = dbo.res_getdate(@ctxt_ouinstance)
	
	--Get the company code.
	select	@compcode_tmp = company_code
	from	emod_ou_vw (nolock)
	where	ou_id 		= @ctxt_ouinstance
	and	@today between effective_from 
		and isnull(effective_to, @today)
		
	
	select	@int_acc_param			= cps.parameter_code
	from	cps_processparam_sys cps	
	where   cps.company_code        = @compcode_tmp 	
	and     cps.parameter_type      = 'BKSYS'  		
	--and     cps.ou_id               = @ctxt_ouinstance  	--code commented by TIS-523	
	and     cps.parameter_category  = 'INTACCREC'	
	and 	language_id 			= @ctxt_language		
	/*14H109_ABR_00021*/	
	
	select 	@all_tmp = ltrim(rtrim(parameter_text))
	from 	fin_quick_code_met(nolock)
	where 	component_id 	= 'ABR'	
	and 	parameter_type 	= 'COMBO'
	and 	parameter_category = 'DOCTYPE'
	and 	parameter_code 	= 'A'
	and 	language_id 	= @ctxt_language
	

	-- Null Checking 
	if  @Ctxt_Language_tmp  = -915
		select  @Ctxt_Language_tmp =null
	
	if  @ctxt_OUInstance_tmp  = -915
		select  @ctxt_OUInstance_tmp =null
	
	if  @Ctxt_Service_tmp  = '~#~'
		select  @Ctxt_Service_tmp =null
	
	if  @ctxt_User_tmp  = '~#~'
		select  @ctxt_User_tmp =null
	
	if  @FBID_tmp  = '~#~'
		select  @FBID_tmp =null
	
	if  @Route_tmp  = '~#~'
		select  @Route_tmp =null
	
	if  @BankPTTNum_tmp  = '~#~'
		select  @BankPTTNum_tmp =null
	
	if  @DocType_tmp  = '~#~'
		select  @DocType_tmp =null
	
	/*Code Modified By Vairamani C for the bug id: ABRDMS412AT_000014 starts here*/
	if  @docdatefrom_tmp  = '1/1/00'--'01/01/1900' 
		select  @docdatefrom_tmp = '1900-01-01'
	
	if  @docdateto_tmp  = '1/1/00'--'01/01/1900' 
		select  @docdateto_tmp = '9999-12-31'
	/*Code Modified By Vairamani C for the bug id: ABRDMS412AT_000014 ends here*/
	
	if  @DefDate_tmp  = '01/01/1900'
		select  @DefDate_tmp =null
	
	if  @Statementnumber_tmp  = '~#~'
		select  @Statementnumber_tmp =null
	
	if  @guid_tmp  = '~#~'
		select  @guid_tmp =null
	
	if  @Hidden_Control1_tmp  = '~#~'
		select  @Hidden_Control1_tmp =null

	/*G1Abr0013
	If Document Date From is Null, consider it as 01-Jan-1900*/	
	if @docdatefrom_tmp is NULL
		select @docdatefrom_tmp	= '01/01/1900'
	/*G1Abr0014
	If Document Date To is Null, consider it as System Date*/	
	if @docdateto_tmp is NULL
		select @docdateto_tmp =	'01/01/1900'
			
	/*G1Abr0012
	If Document To Date is less than Document From Date, display error message*/
	if @docdateto_tmp < @docdatefrom_tmp
	begin
		exec fin_sp_raise_error '','','','','ABR', 3454846, @m_errorid output
		return
	end
	/*G1Abr0015
	Store the values given in Search criteria for future check.*/
	DELETE FROM abr_search_tmp 
	
	insert into abr_search_tmp values
	(
		@FBID_tmp,	@Route_tmp,	@BankPTTNum_tmp,	
		@DocType_tmp,	@docdatefrom_tmp,
		@docdateto_tmp,	@DefDate_tmp
	)
	
	select 	 @company_code_tmp 	= company_code 
	from 	 emod_ou_vw ( nolock )
	where 	 ou_id 			= @ctxt_ouinstance
	
	if exists	(	select	'*'
					from 	cps_postingtrantype_vw(nolock)
					where 	company_code		=	@company_code_tmp
					and 	account_type_code	in	('IA','DA')
					and		language_id			=	@ctxt_language_tmp
					and		tran_type			=	@DocType_tmp  
				)
	begin
	select  @tran_type_code_tmp	=	tran_type_code
	from 	cps_postingtrantype_vw(nolock)
	where 	company_code		=	@company_code_tmp
	and 	account_type_code	in	('IA','DA')--EPE-23544	
	and	language_id		=	@ctxt_language_tmp
	and	tran_type		=	@DocType_tmp
	end
	else
	select  @tran_type_code_tmp	=	parameter_code
	from 	fin_quick_code_met(nolock)
	where 	component_id 		= 'ABR'	
	and 	parameter_type 		= 'COMBO'
	and 	parameter_category	= 'DOC_TYPE'
	and 	parameter_text 		= @DocType_tmp
	and 	language_id 		= @ctxt_language
	/*G1Abr0016
	If Document Type is "Supplier Payment", fetch the documents with Tran Type 'PM_PV', "PM_SPPV"
	and "PM_SDV". (Check the G1Abr0024 for Voided Payments)*/

	
	if @tran_type_code_tmp	in ('SPY')--G1Abr0016
	begin--1
		select @temp1		=	'PM_PV'
		select @temp2		=	'PM_SPPV'
		select @temp3		=	'PM_SDV	'
	end--1
	ELSE 
	/*G1Abr0017
	If Document Type is "Supplier Receipt", fetch the documents with Tran Type 'PM_SRC', "PM_VR" 
	(Check the G1Abr0025 for Reversed/Bounced/Voided Receipts)*/
	if @tran_type_code_tmp	in ('SR')--G1Abr0017
	begin--2
		select @temp1		=	'PM_SRC'
		select @temp2		=	'PM_RSRC'
	end--2
	ELSE 
	/*G1Abr0018
	If Document Type is "Customer Payment", fetch the documents with Tran Type 'RM_CPV' and "Voided 
	Payments Tran Type". (Check the G1Abr0027 for Voided Payments)*/
	if @tran_type_code_tmp	in ('CP')--G1Abr0018
	begin--3
		select @temp1		=	'RM_CPV'
	end--3
	ELSE
	/*G1Abr0019
	If Document Type is "Customer Receipt",  fetch the documents with Tran Type 'RM_RV'.
	(Check the G1Abr0026 for Reversed/Bounced/Voided Receipts)*/
	if @tran_type_code_tmp	in ('RPT')--G1Abr0019
	begin--4
		select @temp1		=	'RM_RV'
	end--4
	ELSE
	/*G1Abr0020
	If Document Type is "Bank Collection Batch",  fetch the documents with Tran Type 'RM_BCB'.
	(Check the G1Abr0026 for Reversed/Bounced/Voided Receipts)*/
	if @tran_type_code_tmp	in ('BCB')--G1Abr0020
	begin--5
		select @temp1		=	'RM_BCB'
	end--5
	ELSE
	/*G1Abr0021
	If Document Type is "Sundry Payment", fetch the documents with Tran Type "PM_APV", "PM_HPV", 
	"PM_SPV", "PM_VPV", "PM_TPV" (Check the G1Abr0024 for Voided Payments)*/
	if @tran_type_code_tmp	in ('SNP')--G1Abr0021
	begin--6
		select @temp1		=	'PM_APV'
		select @temp2		=	'PM_HPV'
		select @temp3		=	'PM_SPV'
		select @temp4		=	'PM_VPV'
		select @temp5		=	'PM_TPV'	
		/*Code Added By Guhan Shanmugam K for the Bug Id : ABRDMS412AT_000077 Starts Here*/
		select @temp6		= 	'PM_BCT'	
		/*Code Added By Guhan Shanmugam K for the Bug Id : ABRDMS412AT_000077 Ends Here*/
	end--6
	ELSE	
	/*G1Abr0022
	If Document Type is "Sundry Receipt", fetch the documents with Tran Type "RM_SR","RM_TSR" 
	(Check the G1Abr0026 for Reversed/Bounced/Voided Receipts)*/
	if @tran_type_code_tmp	in ('SUR')--G1Abr0022
	begin--7
		select @temp1		=	'RM_SR'
		select @temp2		=	'RM_TSR'
		/*Code Added By Guhan Shanmugam K for the Bug Id : ABRDMS412AT_000077 Starts Here*/
		select @temp6		= 	'RM_BCT'	
		/*Code Added By Guhan Shanmugam K for the Bug Id : ABRDMS412AT_000077 Ends Here*/
	end--7
	else if @tran_type_code_tmp	in ('SNPTV')--G1Abr0022
	begin--7
		select @temp1		=	'PM_IBT'
	end

	delete from abr_genvoch_tmp where guid = @guid

	/*G1Abr0024 
	For Document Types, 'PM_PV','PM_SPPV','PM_SDV','PM_APV','PM_HPV','PM_SPV','PM_VPV','PM_TPV',
	Invoke service G2SiRetTrnIntAccTrn1 from SI Component by giving the inputs and get the multi
	-line details. The service will return the following documents that has posted to Interim 
	Account - Documents that are in 'Paid' status, vouchers generated on voidig/bouncing of the 
	original voucher (if the original voucher has already been transferred). If the original 
	voucher has not been transferred, then the voucher generated on voiding/bouncing should not
	be fetched. The service to also return the Interim Bank Account code used for each 
	transaction along with the Currency, Exchange Rate (Base Currency Exchange Rate and Parallel
	Base Currency Exchange Rate), Amount (Amounts in Tran Currency,  Base Currency and Parallel 
	Base Currency) and the DebitCredit Identifier.*/
	--epe-5821
	if @retrievetrfvch = '1'
	 begin
	  if @doctype in (@all_tmp)
	   begin
	     insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,
		 currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid,  VoucherType, 
		 VoucherNo,		VoucherDate,	Voucheramout ,hdntrnou,hdntrntype,hdnusg
		)
		select 	
		tran_type,		tran_ou,	tran_no,	tran_amount,		tran_date,
	    tran_status,		instr_no,	instr_amount,	instr_date,		account_code,
		currency,
	    par_exchange_rate,	exchange_rate,	tran_amount_acc_cur,	base_amount,drcr_flag,
    	par_base_amount,
		check_flag,			@GUID,			VoucherType,
    	VoucherNo,		VoucherDate,	Voucheramout,	Voucher_ou ,tran_type,case  VoucherType when 'SUNDRY PAYMENT' then 'PM_IBT'
		                                                                      else  'RM_IBT' end
		from 	abr_genvoucher_dtl  A (nolock)
		where	tran_type	in ('PM_PV','PM_SPPV','PM_SDV','PM_APV','PM_HPV','PM_SPV','PM_VPV','PM_TPV','PM_BCT',
		                        'RM_RV','RM_BCB','RM_SR','RM_TSR','RM_BCT','PM_SRC','PM_VR','PM_RSRC','RM_CPV','PM_IBT')--EPE-26281
		--AND	    A.tran_status	IN ('PAD','PD','AU','AUT')
		and 	A.fbid		= @FBID_tmp
		and     A.bankpttnum= @BankPTTNum_tmp
		and 	tran_date between @docdatefrom_tmp and @docdateto_tmp
		and     VoucherNo between   isnull(@transfervouchernofrom,VoucherNo) and isnull(@transfervouchernoto,VoucherNo)
		and     Voucherstatus is null
	   end
	   else
	    begin
	    insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,
		 currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid,  VoucherType, 
		 VoucherNo,		VoucherDate,	Voucheramout ,hdntrnou,hdntrntype,hdnusg
		)
		select 	
		tran_type,		tran_ou,	tran_no,	tran_amount,		tran_date,
	    tran_status,		instr_no,	instr_amount,	instr_date,		account_code,
		currency,
	    par_exchange_rate,	exchange_rate,	tran_amount_acc_cur,	base_amount,drcr_flag,
    	par_base_amount,
		check_flag,			@GUID,			VoucherType,
    	VoucherNo,		VoucherDate,	Voucheramout,	Voucher_ou ,tran_type,case  VoucherType when 'SUNDRY PAYMENT' then 'PM_IBT'
		                               else  'RM_IBT' end
		from 	abr_genvoucher_dtl  A (nolock)
		where	tran_type	in (@temp1,@temp2,@temp3,@temp4,@temp5,@temp6)
		--AND	    A.tran_status	IN ('PAD','PD','AU','AUT')
		and 	A.fbid		= @FBID_tmp
		and     A.bankpttnum= @BankPTTNum_tmp
		and 	tran_date between @docdatefrom_tmp and @docdateto_tmp
		and     VoucherNo between   isnull(@transfervouchernofrom,VoucherNo) and isnull(@transfervouchernoto,VoucherNo)
		and     Voucherstatus is null
    end

	DELETE	from	t
	from	abr_genvoch_tmp t
			left outer join
			rp_record_paydis_dtl d (NOLOCK)
			on	(
						dis_vouchertype	= 'PM_IBT'					
				AND		t.tran_type		= 'PM_IBT'
				AND		t.tran_no		= dis_vocher_no
				and		t.tran_ou		= d.tran_ou
				)
	where 	t.guid	=	@guid
	and		d.dis_vocher_no is null
	AND		t.tran_type		= 'PM_IBT'--EPE-26459


	if not exists (select '*' from abr_genvoch_tmp where  guid  = @guid)
	begin
	
		exec fin_sp_raise_error '','','','','ABR', 3454848, @m_errorid output
		return
	end

		SELECT
		--A.parameter_text 		'DocumenttypeML',	--VE-3078	
		A.tran_desc 		'DocumenttypeML',		--VE-3078	
		tran_no				'DocumentNumber',
		tran_date			'DocumentDate',
		sum(isnull(tran_amount,0))	'DocumentAmount',
		instr_no			'InstrumentNumber',
		instr_date			'InstrDate',
		tran_ou				'OuInstIdPO'	,
		account_code			'TermNumberHdnHdr',
		null				'Timestamp1',
		SI.tran_type		'transactiontype',	
		hdntrnou                'hdntrnou', 
		hdntrntype               'hdntrntype', 
		hdnusg               'hdnusg', 
		null                'reversaldateml', 
		voucherdate              'transfervchdate',
		VoucherType                    'gtfrvchtyp',  --epe-6317
		VoucherNo                  'gtfrvchno', 
		VoucherDate                  'gtfrvchdt',
		Voucheramout                 'gtrfvchamt'--epe-6317
	from 	abr_genvoch_tmp SI(nolock),
	       emod_trantype_vw A (nolock)
	where	SI.tran_type		=	A.tran_type
	and 	A.language_id		=	@ctxt_language
	and 	GUID 			= 	@GUID
	group by A.tran_desc , tran_no , tran_date , instr_no , instr_date,		
	tran_ou , account_code , si.tran_type,hdntrnou,		hdntrntype,hdnusg,voucherdate,VoucherType,VoucherNo,Voucheramout

	return
	 end
  --epe-5821  
	if @tran_type_code_tmp in ('SPY','SNP')
	begin
		insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid,intbnktrn_status,pay_mode	--epe-23544
		)
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , A.intbanktran_statuS, A.pay_mode --epe-23544
		from 	si_interim_voucher_vw  A (nolock)
		where	tran_type	in (@temp1,@temp2,@temp3,@temp4,@temp5,@temp6)/*Code Modified By Guhan Shanmugam K for the Bug Id : ABRDMS412AT_000077 */
		AND	A.tran_status	IN ('PAD','PD')
		and 	A.fb_id		= @FBID_tmp
		and     A.bank_cash_code= @BankPTTNum_tmp
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	tran_date between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */	
		--code added for ES_abr_00534 starts
		union	all	--ES_abr_00671
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	Null,	Null,	Null,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , A.intbanktran_statuS, A.pay_mode --epe-23544
		from 	si_interim_othrsvoucher_vw  A (nolock)
		where	tran_type	in (@temp1,@temp2,@temp3,@temp4,@temp5,@temp6)
		AND	A.tran_status	IN ('PAD','PD')
		and 	A.fb_id		= @FBID_tmp
		and     A.bank_cash_code= @BankPTTNum_tmp
		and 	tran_date between @docdatefrom_tmp and @docdateto_tmp	
		--code added for ES_abr_00534 ends
	end

	
	/*G1Abr0025
	For Document Types, 'PM_SRC', "PM_VR" , Invoke service G2SiRetTrnIntAccTrn1 from SI Component
	by giving the inputs and get the multi-line details. The service will return the following
	documents that has posted to Interim Account - Documents that are in 'Authorized' status, 
	vouchers generated on Reversal/voidig/bouncing of the original voucher (if the original 
	voucher has already been transferred). If the original voucher has not been transferred, 
	then the voucher generated on reversal/voiding/bouncing should not be fetched. The service to
	also return the Interim Bank Account code used for each transaction along with the Currency, 
	Exchange Rate (Base Currency Exchange Rate and Parallel Base Currency Exchange Rate), Amount 
	(Amounts in Tran Currency,  Base Currency and Parallel Base Currency) and the DebitCredit 
	Identifier.*/
	
	if @tran_type_code_tmp in ('SR')
	begin
		insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid, intbnktrn_status, pay_mode --epe-23544
		)
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , A.intbanktran_statuS, A.pay_mode --epe-23544
		from 	si_interim_voucher_vw  A (nolock)	
		where	tran_type	in (@temp1,@temp2,@temp3,@temp4,@temp5)
		AND	A.tran_status	IN ('AU','AUT')
		and 	A.fb_id		= @FBID_tmp
		and     A.bank_cash_code= @BankPTTNum_tmp
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	A.tran_date between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */
	
		insert into abr_genvoch_tmp
		(
		 tran_type,		tran_ou,		tran_no,		tran_amount,
		 tran_date,		tran_status,		instr_no,		instr_amount,
		 instr_date,		account_code,		currency,		par_exchange_rate,
		 exchange_rate,		tran_amount_acc_cur,	base_amount,		drcr_flag,
		 par_base_amount,	check_flag,		guid, intbnktrn_status , pay_mode		--epe-23544
		)
		select  DISTINCT  	
		 HDR1.tran_type,	HDR1.tran_ou,		HDR1.tran_no,		HDR1.tran_amount,
		 HDR1.tran_date, 	HDR1.doc_status,	SR.instr_no,		SR.instr_amount,
		 SR.instr_date,		ACC1.account_code,	HDR1.tran_currency,	ACC1.par_exchange_rate,
		 ACC1.exchange_rate,	ACC1.tran_amount_acc_cur,ACC1.base_amount,	ACC1.drcr_flag,
		 ACC1.par_base_amount,	NULL,			@guid_tmp, hdr.intbanktran_statuS , hdr.pay_mode	--epe-23544
		FROM 
		sr_receipt_mst  	SR (nolock),
		si_doc_hdr	 	HDR(nolock),
		si_acct_info_dtl 	ACC (nolock),
		si_doc_hdr	 	HDR1(nolock),
		si_acct_info_dtl 	ACC1 (nolock)
		where 	SR.receipt_status			IN	('AU','AUT')
		and     SR.tran_type				=	'PM_RSRC'
		and 	HDR.tran_no				=	SR.ref_no
		and     ISNULL(HDR.intbanktran_status,'NA')	= 	'TRN'
		and 	acc.tran_no				=	HDR.tran_no
		and 	acc.account_type 			= 	'BIA'
		and 	HDR.tran_ou				=	SR.ou_id
		and     acc.tran_ou				=	HDR.tran_ou		
		and     HDR1.tran_no				=	SR.receipt_no
		and     ACC1.tran_no				=	SR.receipt_no
		and 	ACC1.account_type			=	'BIA'
		and	ACC1.fb_id				=	@FBID_tmp
		and	SR.bank_cash_code			=	@BankPTTNum_tmp
		and     ISNULL(HDR1.intbanktran_status,'NA')	<> 	'TRN'
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	HDR1.tran_date	between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */
	end
	
	/*G1Abr0026
	For Document Types,'RM_RV','RM_BCB','RM_SR','RM_TSR', Invoke service G2CiRetTrnIntAccTrn1 
	from CI Component by giving the inputs and get the multi-line details. The service will return
	the following documents that has posted to Interim Account - Documents that are in 'Authorized'
	status, vouchers generated on reversal/voidig/bouncing of the original voucher (if the original 
	voucher has already been transferred). If the original voucher has not been transferred, then
	the voucher generated on reversal/voiding/bouncing should not be fetched. The service to also
	return the Interim Bank Account code used for each transaction along with the Currency, 
	xchange Rate (Base Currency Exchange Rate and Parallel Base Currency Exchange Rate), Amount 
	(Amounts in Tran Currency,  Base Currency and Parallel Base Currency) and the DebitCredit 
	Identifier.*/
	
	if @tran_type_code_tmp in ('RPT','BCB','SUR')
	begin
		insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid, intbnktrn_status , pay_mode
		)
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , a.intbanktran_statuS , a.pay_mode
		from 	ci_interim_voucher_vw  A (nolock)
		where	tran_type	in (@temp1,@temp2,@temp3,@temp4,@temp5,@temp6)/*Code Modified By Guhan Shanmugam K for the Bug Id : ABRDMS412AT_000077 */
		AND	A.tran_status	IN ('AU','AUT')
		and 	A.fb_id		= @FBID_tmp
		and     A.bank_cash_code= @BankPTTNum_tmp
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	A.tran_date between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */		
	end
	
	
	/*G1Abr0027
	For Document Types, 'RM_CPV', Invoke service G2CiRetTrnIntAccTrn1 from CI Component by giving
	the inputs and get the multi-line details. The service will return the following documents 
	that has posted to Interim Account - Documents that are in 'Paid' status, vouchers generated 
	on voidig/bouncing of the original voucher (if the original voucher has already been transferred)
	If the original voucher has not been transferred, then the voucher generated on voiding/bouncing 
	should not be fetched. The service to also return the Interim Bank Account code used for each
	transaction along with the Currency, Exchange Rate (Base Currency Exchange Rate and Parallel 
	Base Currency Exchange Rate), Amount (Amounts in Tran Currency,  Base Currency and Parallel 
	Base Currency) and the DebitCredit Identifier. */
	

	if @tran_type_code_tmp in ('CP')
	begin
		insert into abr_genvoch_tmp
		(
		tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		check_flag,	guid, intbnktrn_status , pay_mode
		)
		select 	
		A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		null,	@guid_tmp, a.intbanktran_statuS , a.pay_mode 
		from 	ci_interim_voucher_vw  A (nolock)
		where	tran_type	in (@temp1,@temp2,@temp3,@temp4,@temp5)
		AND	A.tran_status	IN ('PAD','PD','PA')
		and 	A.fb_id		= @FBID_tmp
		and     A.bank_cash_code= @BankPTTNum_tmp
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	A.tran_date	between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Eds here */		
	end
	if @tran_type_code_tmp in ('SNPTV')
	begin
		insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid,intbnktrn_status,pay_mode	--epe-23544
		)
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,case when A.drcr_flag = 'CR' then 'DR' else 'CR'END,A.par_base_amount,
		 null,	@guid_tmp , A.intbanktran_statuS, A.pay_mode 
		from 	si_interim_voucher_vw  A (nolock)
		where	tran_type	in (@temp1)
		AND		A.tran_status	IN ('PAD','PD')
		and 	A.fb_id		= @FBID_tmp
		and     A.bank_cash_code= @BankPTTNum_tmp
		and 	tran_date between @docdatefrom_tmp and @docdateto_tmp
	end
	
	/*G1Abr0023
	If Document Type is "All", fetch the documents with the Tran Types 'PM_PV','PM_SPPV','PM_SDV',
	'RM_CPV''RM_RV','RM_BCB','PM_APV','PM_HPV','PM_SPV','PM_VPV','PM_TPV','RM_SR','RM_TSR'.*/
	if @doctype in (@all_tmp) --('ALL')
	begin--3
	
		insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
	 	 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid, intbnktrn_status, pay_mode --epe-23544
		)
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , A.intbanktran_statuS, A.pay_mode --epe-23544
		from 	si_interim_voucher_vw  A (nolock)
		where	A.tran_status		IN 	('PAD','PD')
		and 	A.fb_id			=	@FBID_tmp
		and     A.bank_cash_code	=	@BankPTTNum_tmp
		and     A.tran_type		in      ('PM_PV','PM_SPPV','PM_SDV','PM_APV','PM_HPV','PM_SPV','PM_VPV','PM_TPV','PM_BCT')
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	A.tran_date between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */
		--code added for ES_abr_00534 starts		
		union	all	--ES_abr_00671
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	Null,	Null,	Null,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , A.intbanktran_statuS, A.pay_mode --epe-23544
		from 	si_interim_othrsvoucher_vw  A (nolock)
		where	A.tran_status		IN 	('PAD','PD')
		and 	A.fb_id			=	@FBID_tmp
		and     A.bank_cash_code	=	@BankPTTNum_tmp
		and     A.tran_type		in      ('PM_PV','PM_SPPV','PM_SDV','PM_APV','PM_HPV','PM_SPV','PM_VPV','PM_TPV','PM_BCT')
		and 	A.tran_date between @docdatefrom_tmp and @docdateto_tmp	
		--code added for ES_abr_00534 ends

		insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid, intbnktrn_status , pay_mode--epe-23544
		)
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , A.intbanktran_statuS, A.pay_mode --epe-23544
		from 	si_interim_voucher_vw  A (nolock)
		where	A.tran_status		IN 	('AUT','AU')
		and 	A.fb_id			=	@FBID_tmp
		and     A.bank_cash_code	=	@BankPTTNum_tmp
		and     A.tran_type		in      ('PM_SRC','PM_VR')	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	A.tran_date between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */

		insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid, intbnktrn_status , pay_mode
		)
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , a.intbanktran_statuS , a.pay_mode
		from 	ci_interim_voucher_vw  A (nolock)
		where	A.tran_status		IN	 ('AUT','AU')
		and 	A.fb_id			=	@FBID_tmp
		and     A.bank_cash_code	=	@BankPTTNum_tmp
		and     A.tran_type		in      ('RM_RV','RM_BCB','RM_SR','RM_TSR','RM_BCT')	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	A.tran_date between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */
		
		insert into abr_genvoch_tmp
		(
		 tran_type,	tran_ou,	tran_no,	tran_amount,	tran_date,
		 tran_status,	instr_no,	instr_amount,	instr_date,	account_code,currency,
		 par_exchange_rate,exchange_rate,tran_amount_acc_cur,base_amount,drcr_flag,par_base_amount,
		 check_flag,	guid, intbnktrn_status , pay_mode
		)
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,A.drcr_flag,A.par_base_amount,
		 null,	@guid_tmp , a.intbanktran_statuS , a.pay_mode
		from 	ci_interim_voucher_vw  A (nolock)
		where	A.tran_status		IN	('PAD','PD','PA')
		and 	A.fb_id			=	@FBID_tmp
		and     A.bank_cash_code	=	@BankPTTNum_tmp
		and     A.tran_type		in      ('RM_CPV')	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	A.tran_date between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */
		
		insert into abr_genvoch_tmp
		(
		 tran_type,		tran_ou,		tran_no,		tran_amount,
		 tran_date,		tran_status,		instr_no,		instr_amount,
		 instr_date,		account_code,		currency,		par_exchange_rate,
		 exchange_rate,		tran_amount_acc_cur,	base_amount,		drcr_flag,
		 par_base_amount,	check_flag,		guid, intbnktrn_status, pay_mode --epe-23544
		)
		select  DISTINCT  	
		 HDR1.tran_type,		HDR1.tran_ou,		HDR1.tran_no,		HDR1.tran_amount,
		 HDR1.tran_date, 	HDR1.doc_status,	SR.instr_no,		SR.instr_amount,
		 SR.instr_date,		ACC1.account_code,	HDR1.tran_currency,	ACC1.par_exchange_rate,
		 ACC1.exchange_rate,	ACC1.tran_amount_acc_cur,ACC1.base_amount,	ACC1.drcr_flag,
		 ACC1.par_base_amount,	NULL,			@guid_tmp, hdr.intbanktran_statuS, hdr.pay_mode --epe-23544
		FROM 
		sr_receipt_mst  	SR (nolock),
		si_doc_hdr	 	HDR(nolock),
		si_acct_info_dtl 	ACC (nolock),
		si_doc_hdr	 	HDR1(nolock),
		si_acct_info_dtl 	ACC1 (nolock)
		where 	SR.receipt_status			IN	('AU','AUT')
		and     SR.tran_type				=	'PM_RSRC'
		and 	HDR.tran_no				=	SR.ref_no
		and     ISNULL(HDR.intbanktran_status,'NA')	= 	'TRN'
		and 	acc.tran_no				=	HDR.tran_no
		and 	acc.account_type 			= 	'BIA'
		and 	HDR.tran_ou				=	SR.ou_id
		and     acc.tran_ou				=	HDR.tran_ou		
		and     HDR1.tran_no				=	SR.receipt_no
		and     ACC1.tran_no				=	SR.receipt_no
		and 	ACC1.account_type			=	'BIA'
		and	ACC1.fb_id				=	@FBID_tmp
		and	SR.bank_cash_code			=	@BankPTTNum_tmp
		and     ISNULL(HDR1.intbanktran_status,'NA')	<> 	'TRN'
		/* Code Added by Vairamani for ABRDMS412AT_000016 Starts here */
		and 	HDR1.tran_date	between @docdatefrom_tmp and @docdateto_tmp	
		/* Code Added by Vairamani for ABRDMS412AT_000016 Ends here */	
		union all--epe-23544
		select 	
		 A.tran_type,	A.tran_ou,	A.tran_no,	A.tran_amount,	A.tran_date,
		 A.tran_status,	A.instr_no,	A.instr_amount,	A.instr_date,	A.account_code,A.acct_currency,
		 A.par_exchange_rate,A.exchange_rate,A.tran_amount_acc_cur,A.base_amount,case when A.drcr_flag='cr' then 'DR' else 'CR' end,A.par_base_amount,
		 null,	@guid_tmp , A.intbanktran_statuS, A.pay_mode 
		from 	si_interim_voucher_vw  A (nolock)
		where	A.tran_status		IN 	('PAD','PD')
		and 	A.fb_id				=	@FBID_tmp
		and     A.bank_cash_code	=	@BankPTTNum_tmp
		and     A.tran_type		in      ('PM_IBT')
		and 	A.tran_date between @docdatefrom_tmp and @docdateto_tmp	
	end--3
	
	update	t
    set		account_type_cd     = s.account_type_code
    from	abr_genvoch_tmp  t ,
			cps_postingtrantype_vw s(nolock),
			cps_config_intrimAcc_dtl dtl(nolock)
    where   dtl.ou_id           = @ctxt_ouinstance
    and     s.company_code      = @company_code_tmp
	and     dtl.company_code    = @company_code_tmp
    and		tran_type_code      = case		when t.tran_type in ('PM_PV',    'PM_SPPV',    'PM_SDV') then    'SPY'
											when t.tran_type in ('PM_SRC', 'PM_RSRC') then    'SR'
											when t.tran_type in ('RM_CPV') then 'CP'
											when t.tran_type in ('RM_RV') then 'RPT'
											when t.tran_type in ('RM_BCB') then 'BCB'
											when t.tran_type in ('RM_SR','RM_TSR','RM_BCT') then 'SUR'
											else 'SNP'
                                  end
    and       dtl.pay_mode       = t.pay_mode                
    and       addn_intrim_Paymd  = 'Y'
    and       guid               = @guid

	delete from abr_genvoch_tmp
	where	guid                = @guid
	and		account_type_cd		= 'DA'
	and		isnull(intbnktrn_status,'')	<> 'D'
	/*G1Abr0023a
	If Bank Statement No. is given, get the list of tran type,transaction numbers that are 
	included in the Bank Statement and status is "Reconciled". Display error if bank statement no
	is invalid.*/
	
	
	if @statementnumber_tmp is not NULL
	begin--1
		if not exists ( select '*' from abr_bank_statement_dtl(nolock) 
				where 	stmt_no		= 	 @statementnumber_tmp
				and 	recon_status	in ('R','C')--=	'R'--code modified for the ITS id ES_abr_00615
				AND 	company_code	=	@company_code_tmp
			      )
		begin
			exec fin_sp_raise_error '','','','','ABR', 3454847, @m_errorid output
			return
		end
		
		/*G1Abr0023b
		If Bank Statement No. is given, get the list of tran type,transaction numbers that are 
		included in the Bank Statement and status is "Reconciled". Display error if bank statement 
		no is invalid.*/
		/*code added by uma for the bug id : ABRFIN41CT_000005 starts here*/
		/*	delete from abr_genvoch_tmp 
		where tran_no in (select  document_no from abr_bank_statement_reconcile_vw 
		where  stmt_no		=	@statementnumber_tmp)*/
			/*code added for the ITS id ES_abr_00615 starts*/
		if exists ( select  'X' 
					from	cps_processparam_sys cps
					where   cps.company_code        = @compcode_tmp 	
					and     cps.parameter_type      = 'BKSYS'  		
					and     cps.ou_id               = @ctxt_ouinstance  		
					and     cps.parameter_category  = 'INTACCREC'	
					and 	language_id 			= @ctxt_language
					and		cps.parameter_code		= 'Y'	
				 )
		begin
					;
					WITH SQLTMP (ref_no1) as 
					(
						SELECT 	DISTINCT SQL2K51.ref_no
						FROM 	abr_bank_statement_dtl SQL2K51 (NOLOCK) 
						WHERE 	SQL2K51.stmt_no 	<> @statementnumber_tmp 
						and 	SQL2K51.recon_status 	in ('r','c')
					), 
					SQLTMP1 (document_no1) as 
					(
						SELECT  document_no
						FROM 	abr_bank_reconcile_dtl (NOLOCK) 
							JOIN SQLTMP 
							ON ( ref_no = SQLTMP.ref_no1) 
					)

					

					DELETE 	abr_genvoch_tmp
					FROM 	abr_genvoch_tmp 
						JOIN SQLTMP1 
						ON ( tran_no = SQLTMP1.document_no1 )
		end
		else
			begin
			/*code added for the ITS id ES_abr_00615 ends*/
				;
				WITH SQLTMP (ref_no1) as 
				(
					SELECT 	DISTINCT SQL2K51.ref_no
					FROM 	abr_bank_statement_dtl SQL2K51 (NOLOCK) 
					WHERE 	SQL2K51.stmt_no 	= @statementnumber_tmp 
					and 	SQL2K51.recon_status 	= 'r' 
				), 
				SQLTMP1 (document_no1) as 
				(
					SELECT  document_no
					FROM 	abr_bank_reconcile_dtl (NOLOCK) 
						JOIN SQLTMP 
						ON ( ref_no = SQLTMP.ref_no1) 
				)

				

				DELETE 	abr_genvoch_tmp
				FROM 	abr_genvoch_tmp 
					JOIN SQLTMP1 
					ON ( tran_no = SQLTMP1.document_no1 )
			end--code added for the ITS id ES_abr_00615
			
	end--1
	
	if not exists (select '*' from abr_genvoch_tmp where  guid  = @guid)
	begin
		exec fin_sp_raise_error '','','','','ABR', 3454848, @m_errorid output
		return
	end
	--14H109_ABR_00021
	
	if isnull(@int_acc_param ,'N') = 'Y'
	begin
		delete	tmp
		from	abr_genvoch_tmp tmp, fbp_posted_trn_dtl fbp(nolock)
		where	guid				= @guid	
		and		tmp.tran_type		= fbp.tran_type
		and		tmp.tran_ou			= fbp.tran_ou
		and		tmp.tran_no			= fbp.document_no
		and		tmp.account_code	= fbp.account_code
		and		isnull(fbp.recon_flag,'U') = 'U'

		updATE	TMP
		SET		recon_flag			= 'U'
		FROM	abr_genvoch_tmp tmp, 
				fbp_posted_trn_dtl fbp(nolock),
				rp_record_paydis_dtl d (NOLOCK)
		where	tmp.guid			= @guid	
		and		d.tran_type			= fbp.tran_type
		and		d.tran_ou			= fbp.tran_ou
		and		d.voucher_no		= fbp.document_no
		and		tmp.account_code	= fbp.account_code
		and		isnull(fbp.recon_flag,'U') = 'U'
		and		tmp.tran_type		= dis_vouchertype
		and		tmp.tran_ou			= d.tran_ou
		and		tmp.tran_no			= dis_vocher_no
		
		delete	from	abr_genvoch_tmp
		where	guid				= @guid		
		and		recon_flag			= 'U'
	end
	--14H109_ABR_00021
	
	
	SELECT
		--A.parameter_text 		'DocumenttypeML',	--VE-3078	
		A.tran_desc 		'DocumenttypeML',		--VE-3078	
		tran_no				'DocumentNumber',
		tran_date			'DocumentDate',
		/*Code added by Vairamani C for the bug id: ABRDMS412AT_000014 starts here*/
		--tran_amount			'DocumentAmount',
		sum(isnull(tran_amount,0))	'DocumentAmount',
		/*Code added by Vairamani C for the bug id: ABRDMS412AT_000014 ends here*/
		instr_no			'InstrumentNumber',
		instr_date			'InstrDate',
		tran_ou				'OuInstIdPO'	,
		account_code			'TermNumberHdnHdr',
		null				'Timestamp1',
		SI.tran_type		'transactiontype',	--VE-3078	
		null                'hdntrnou', 
		null               'hdntrntype', 
		null               'hdnusg', 
		null                'reversaldateml', 
		null              'transfervchdate',
		 1                       'stGenerate',
		 0						'stReverse'
	from 	abr_genvoch_tmp SI(nolock),
	--VE-3078	
	/*
	fin_quick_code_met A(nolock)
	where	SI.tran_type		=	A.parameter_code
	and 	A.component_id		=	'ABR'
	and 	A.parameter_type	=	'COMBO'
	and 	A.parameter_category	=	'DOCTYPE'
	*/
	emod_trantype_vw A (nolock)
	where	SI.tran_type		=	A.tran_type
	--VE-3078	
	and 	A.language_id		=	@ctxt_language
	and 	GUID 			= 	@GUID
	and	((isnull(account_type_cd,'') <> 'DA') or  (isnull(account_type_cd,'') = 'DA' and intbnktrn_status = 'D' )) --epe-23544
	/*Code added by Vairamani C for the bug id: ABRDMS412AT_000014 starts here*/
	/* Code Commented by Vairamani for ABRDMS412AT_000016 Starts here */
	--and tran_date			between @docdatefrom_tmp and @docdateto_tmp
	/* Code Commented by Vairamani for ABRDMS412AT_000016 Ends here */
	group by /*A.parameter_text*/A.tran_desc , tran_no , tran_date , instr_no , instr_date,	--VE-3078	
	tran_ou , account_code , si.tran_type	--VE-3078		
	/*Code added by Vairamani C for the bug id: ABRDMS412AT_000014 ends here*/
	
	SET NOCOUNT OFF
END




























