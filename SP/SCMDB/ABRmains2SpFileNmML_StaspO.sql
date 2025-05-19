/*$File_version=MS4.3.0.05$                                      */
/*****************************************************************/
/* Procedure					: ABRmains2SpFileNmML_StaspO	 */
/* Description					: 								 */
/*****************************************************************/
/* Project						: 							     */
/* EcrNo						: 								 */
/* Version						: 								 */
/*****************************************************************/
/* Referenced					: 								 */
/* Tables						: 								 */
/*****************************************************************/
/* Development history			: epe-6565						 */
/*****************************************************************/
/* Author						: Harithra 						 */
/* Date							: 09/04/2018					 */
/*****************************************************************/
/* Modification History			: 								 */
/*****************************************************************/
/* Modified By					:								 */
/* Date							:								 */
/* Description					:								 */
/* grant exec on ABRmains2SpFileNmML_StaspO to public            */
/* GaneshReddy		    11-07-2022			EPE-46538            */
/* Abilash Sriram N     05-08-2022			EPE-51194            */
/* Abilash Sriram N     11-08-2022			EPE-51665            */
/* Harithra Devi G		28-06-2023			EPE-65957			 */
/*****************************************************************/

Create Procedure ABRmains2SpFileNmML_StaspO
	@ctxt_ouinstance            fin_ctxt_ouinstance, --Input 
	@ctxt_user                	fin_ctxt_user, --Input 
	@ctxt_language            	fin_ctxt_language, --Input 
	@ctxt_service             	fin_ctxt_service, --Input 
	@hdnguid                  	fin_guid, --Input 
	@hdn_stagingtablehide 	    fin_text255, --Input 
	@ml_sta_fprowno          	fin_fprowno, --Input
	@ml_stt_fprowno          	fin_fprowno, --Input
	@m_errorid                	fin_int output --To Return Execution Status
	
as
Begin
	-- nocount should be switched on to prevent phantom rows
	Set nocount on
	-- @m_errorid should be 0 to Indicate Success
	Set @m_errorid = 0

	--declaration of temporary variables
	declare @local_var		fin_documentno,
			@gen_stat_tmp	fin_flag	--EPE-65957
	--temporary and formal parameters mapping

	Set @ctxt_user                 = ltrim(rtrim(@ctxt_user))
	Set @ctxt_service              = ltrim(rtrim(@ctxt_service))
	Set @hdnguid                   = ltrim(rtrim(@hdnguid))
	Set @Hdn_StagingTableHide  = ltrim(rtrim(@hdn_stagingtablehide))

	--null checking

	IF @ctxt_ouinstance = -915
		Select @ctxt_ouinstance = null  

	IF @ctxt_user = '~#~' 
		Select @ctxt_user = null  

	IF @ctxt_language = -915
		Select @ctxt_language = null  

	IF @ctxt_service = '~#~' 
		Select @ctxt_service = null  

	IF @hdnguid = '~#~' 
		Select @hdnguid = null 
    IF @hdn_stagingtablehide = '~#~' 
		Select @hdn_stagingtablehide = null  

	select @local_var = process_status  
	from bank_stmt_exp_tmp (nolock)
	where guid = @hdnguid 

	----EPE-65957
	if exists ( select 'X' from pps_finance_feature_list(nolock)
				where FEATURE_ID = 'PPS_ABR_00001')
	begin
		select @gen_stat_tmp = FLAG_YES_NO
		from pps_finance_feature_list(nolock)
		where FEATURE_ID = 'PPS_ABR_00001'
	end
	else
	begin
		select @gen_stat_tmp = 'NO'
	end
	----EPE-65957	
	if @gen_stat_tmp = 'No'
	begin
	if @local_var <> 'success'
	begin
 
		Select	distinct -- @ml_sta_fprowno			 'ml_sta_fprowno', 
						--  @ml_stt_fprowno			 'ml_stt_fprowno',
						  account_number			  'account_no', 
						  Cheque_Number_Or_Reference  'check_no_or_ref', 
				case when Closing_balance_Cr_Dr =     'C' then 'CR'else 'DR' end 'clbalance_dr_cr', 
				convert(numeric(28,8),replace(Closing_balance ,',','.'))'closingbalance', 
				case When Transaction_Debit_Credit =   'C' then 'CR' else 'DR' end 'dr_cr', 
				tmp.error_desc	                       'error_desc', 
				filename_date_time_stamp			   'filename_date_time_stamp', 
				Fund_Code							   'fund_code', 
				rownumber							 'lineno',
				convert(datetime, a.Message_Date ,103) 'messagedatetime', 	a.Message_Time		'messagetime', 
				case when Opening_Balance_Cr_Dr = 'C' then 'CR' else 'DR' end 'opbalance_dr_cr', 
				convert(numeric(28,8),replace(Opening_balance ,',','.')) 'openingbalance', 
				Orginating_Bank_reference            'originating_bank_ref', 
				convert(date, Statement_End_Date ,103)		        'statement_end_date', 
				Statement_Number                     'statement_no',			
				convert(date, statement_start_date,103)                 'statement_start_date', 
				case when status_flag is null then 'Pending' else 'Failure' end 'statusflag', 
				convert(numeric(28,8),replace(Transaction_Amount ,',','.')) 'tranamount', 
				Message_Date			'trandate', 
				tran_desc					'trantype', 
				Unique_Message_ID			'uniquemessageid'
		from	Iris_MT940_Staging a(nolock) ,bank_stmt_exp_tmp tmp(nolock),mt940_metadata c(nolock)
		where	a.Unique_Message_ID = unique_id
		and   c.tran_type =  a.transaction_type 
		and   DrCr_Flag = case when a.Transaction_Debit_Credit = 'C' then 'CR' else 'DR' end
		and a.Filename_Date_Time_Stamp = tmp_filename
		and a.Transaction_Date is not null
		and guid = @hdnguid
		order by 'lineno'

	end

	if @local_var = 'success'
	begin 
	

		Select	--@ml_sta_fprowno		'ml_sta_fprowno', 
				--@ml_stt_fprowno		'ml_stt_fprowno', 
				bank_acc_no			'account_no', 
				check_no			'check_no_or_ref', 
				closebal_drcr		'clbalance_dr_cr', 
				close_bal			'closingbalance', 
				case When tran_dr_cr =   'C' then 'CR' else 'DR' end				'dr_cr','Success'			'error_desc',
 
			original_filename	     'filename_date_time_stamp', 
				Fund_Code                   'fund_code', 
				rownumber					'lineno',
				file_processdate	 'messagedatetime', 
				file_processtime			 'messagetime', 
				openbal_drcr		 'opbalance_dr_cr', 
				open_bal			 'openingbalance', 
				org_bank_ref		 'originating_bank_ref', 
				convert(date, a.stmt_end_date,103)		 'statement_end_date', 
				a.stmt_no			 'statement_no', 
				convert(date, a.stmt_start_date,103)		 'statement_start_date', 
				'Success'			 'statusflag', 
				tran_amount			 'tranamount', 
				tran_date			 'trandate', 
				tran_type			 'trantype', 
				file_path			 'uniquemessageid'
			from bank_stmt_exp_tmp tmp(nolock),
			abr_statement_hdr_hist a(nolock)
	where	a.file_path = unique_id
		and a.original_filename = tmp_filename
		and guid = @hdnguid
		and a.tran_date is not null
		order by 'lineno'

	end
	end

	if @gen_stat_tmp = 'Yes'
	begin
	if @local_var <> 'success'
	begin
 
		if exists (	Select 'X' from	Iris_MT940_Staging a(nolock) ,bank_stmt_exp_tmp tmp(nolock)
					where	a.Unique_Message_ID = unique_id
					and a.Filename_Date_Time_Stamp = tmp_filename
					and guid = @hdnguid
					and a.transaction_Date is null)
		begin
			Select	distinct  account_number			  'account_no', 
							  Cheque_Number_Or_Reference  'check_no_or_ref', 
					case when Closing_balance_Cr_Dr =     'C' then 'CR'else 'DR' end 'clbalance_dr_cr', 
					convert(numeric(28,8),replace(Closing_balance ,',','.'))'closingbalance', 
					case When Transaction_Debit_Credit =   'C' then 'CR' else 'DR' end 'dr_cr', 
					tmp.error_desc	                       'error_desc', 
					filename_date_time_stamp			   'filename_date_time_stamp', 
					Fund_Code							   'fund_code', 
					rownumber							 'lineno',
					convert(datetime, a.Message_Date ,103) 'messagedatetime', 	a.Message_Time		'messagetime', 
					case when Opening_Balance_Cr_Dr = 'C' then 'CR' else 'DR' end 'opbalance_dr_cr', 
					convert(numeric(28,8),replace(Opening_balance ,',','.')) 'openingbalance', 
					Orginating_Bank_reference            'originating_bank_ref', 
					convert(date, Statement_End_Date ,103)		        'statement_end_date', 
					Statement_Number                     'statement_no',			
					convert(date, statement_start_date,103)                 'statement_start_date', 
					case when status_flag is null then 'Pending' else 'Failure' end 'statusflag', 
					convert(numeric(28,8),replace(Transaction_Amount ,',','.')) 'tranamount', 
					Message_Date			'trandate', 
					null					'trantype', 
					Unique_Message_ID			'uniquemessageid'
			from	Iris_MT940_Staging a(nolock) ,bank_stmt_exp_tmp tmp(nolock)
			where	a.Unique_Message_ID = unique_id
			and a.Filename_Date_Time_Stamp = tmp_filename
			and guid = @hdnguid
			order by 'lineno'
		end
		else
		begin
			Select	distinct -- @ml_sta_fprowno			 'ml_sta_fprowno', 
							--  @ml_stt_fprowno			 'ml_stt_fprowno',
							  account_number			  'account_no', 
							  Cheque_Number_Or_Reference  'check_no_or_ref', 
					case when Closing_balance_Cr_Dr =     'C' then 'CR'else 'DR' end 'clbalance_dr_cr', 
					convert(numeric(28,8),replace(Closing_balance ,',','.'))'closingbalance', 
					case When Transaction_Debit_Credit =   'C' then 'CR' else 'DR' end 'dr_cr', 
					tmp.error_desc	                       'error_desc', 
					filename_date_time_stamp			   'filename_date_time_stamp', 
					Fund_Code							   'fund_code', 
					rownumber							 'lineno',
					convert(datetime, a.Message_Date ,103) 'messagedatetime', 	a.Message_Time		'messagetime', 
					case when Opening_Balance_Cr_Dr = 'C' then 'CR' else 'DR' end 'opbalance_dr_cr', 
					convert(numeric(28,8),replace(Opening_balance ,',','.')) 'openingbalance', 
					Orginating_Bank_reference            'originating_bank_ref', 
					convert(date, Statement_End_Date ,103)		        'statement_end_date', 
					Statement_Number                     'statement_no',			
					convert(date, statement_start_date,103)                 'statement_start_date', 
					case when status_flag is null then 'Pending' else 'Failure' end 'statusflag', 
					convert(numeric(28,8),replace(Transaction_Amount ,',','.')) 'tranamount', 
					Message_Date			'trandate', 
					tran_desc					'trantype', 
					Unique_Message_ID			'uniquemessageid'
			from	Iris_MT940_Staging a(nolock) ,bank_stmt_exp_tmp tmp(nolock),mt940_metadata c(nolock)
			where	a.Unique_Message_ID = unique_id
			and   c.tran_type =  a.transaction_type 
			and   DrCr_Flag = case when a.Transaction_Debit_Credit = 'C' then 'CR' else 'DR' end
			and a.Filename_Date_Time_Stamp = tmp_filename
			and guid = @hdnguid
			order by 'lineno'
		end
	end

	if @local_var = 'success'
	begin 
	

		Select	--@ml_sta_fprowno		'ml_sta_fprowno', 
				--@ml_stt_fprowno		'ml_stt_fprowno', 
				bank_acc_no			'account_no', 
				check_no			'check_no_or_ref', 
				closebal_drcr		'clbalance_dr_cr', 
				close_bal			'closingbalance', 
				case When tran_dr_cr =   'C' then 'CR' else 'DR' end				'dr_cr','Success'			'error_desc',
 
			original_filename	     'filename_date_time_stamp', 
				Fund_Code                   'fund_code', 
				rownumber					'lineno',
				file_processdate	 'messagedatetime', 
				file_processtime			 'messagetime', 
				openbal_drcr		 'opbalance_dr_cr', 
				open_bal			 'openingbalance', 
				org_bank_ref		 'originating_bank_ref', 
				convert(date, a.stmt_end_date,103)		 'statement_end_date', 
				a.stmt_no			 'statement_no', 
				convert(date, a.stmt_start_date,103)		 'statement_start_date', 
				'Success'			 'statusflag', 
				tran_amount			 'tranamount', 
				tran_date			 'trandate', 
				tran_type			 'trantype', 
				file_path			 'uniquemessageid'
			from bank_stmt_exp_tmp tmp(nolock),
			abr_statement_hdr_hist a(nolock)
	where	a.file_path = unique_id
		and a.original_filename = tmp_filename
		and guid = @hdnguid
		order by 'lineno'

	end
	end
	delete from bank_stmt_exp_tmp 
	where guid = @hdnguid
	
Set nocount off

End

