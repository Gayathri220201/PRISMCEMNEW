/*$File_version=MS4.3.0.03$*/        
/*****************************************************************/        
/* Procedure	: ABRmains2SpSearchML_SttspO					 */        
/* Description  :   											 */        
/*****************************************************************/        
/* Project      :												 */        
/* EcrNo        :												 */        
/* Version      :												 */        
/*****************************************************************/        
/* Referenced   :												 */        
/* Tables       :												 */        
/*****************************************************************/        
/* Development history   : epe-6565								 */        
/*****************************************************************/        
/* Author      : Harithra										 */        
/* Date        : 19/04/2018										 */        
/*****************************************************************/        
/* Modification History   :										 */        
/*****************************************************************/        
/* Modified By     :											 */        
/* Date            :											 */        
/* Description     :											 */        
/* grant exec on ABRmains2SpSearchML_SttspO to public			 */  
/*	Abilash Sriram N		04-07-2022					EPE-46538*/
/*	Abilash Sriram N		11-08-2022					EPE-51664*/
/*  Harithra Devi G			28-06-2023					EPE-65957*/
/*****************************************************************/        
        
Create Procedure ABRmains2SpSearchML_SttspO        
 @ctxt_ouinstance       fin_ctxt_ouinstance, --Input         
 @ctxt_user             fin_ctxt_user, --Input         
 @ctxt_language         fin_ctxt_language, --Input         
 @ctxt_service          fin_ctxt_service, --Input         
 @accountnumber         fin_accountcode, --Input         
 @company_              fin_companycode, --Input         
 @datefrom              fin_date, --Input         
 @dateto                fin_date, --Input         
 @events                fin_text255, --Input         
 @hdnguid               fin_guid, --Input         
 @processingstatus      fin_text255, --Input         
 @m_errorid             fin_int output --To Return Execution Status        
as        
Begin        
 -- nocount should be switched on to prevent phantom rows        
 Set nocount on        
 -- @m_errorid should be 0 to Indicate Success        
 Set @m_errorid = 0        
        
 --declaration of temporary variables      
     
  declare @eventscode_Tmp fin_documentno

  declare @sysdt_tmp  fin_date,
		  @gen_stat_tmp		fin_flag	--EPE-65957

   declare @header table     
    
        (   bank_acc_no                    fin_banknumber,    
            error_desc                    fin_desc255,    
            Filename_out                fin_desc255,    
            Processdate                    fin_date,
			processtime						fin_time,    
            processstatus                fin_desc255,    
            statement_no                fin_statementnumber,    
            Statement_Start_Date        fin_Date,                  
            Statement_End_Date            fin_Date,    
            statementprocessdate        fin_date,    
            company                        fin_company,
			Unique_Message_ID               fin_desc255)    
        
 --temporary and formal parameters mapping        
        
 Set @ctxt_user             = ltrim(rtrim(@ctxt_user))        
 Set @ctxt_service          = ltrim(rtrim(@ctxt_service))        
 Set @accountnumber         = ltrim(rtrim(@accountnumber))        
 Set @company_              = ltrim(rtrim(@company_))        
 Set @events                = ltrim(rtrim(@events))        
 Set @hdnguid               = ltrim(rtrim(@hdnguid))        
 Set @processingstatus      = ltrim(rtrim(@processingstatus))        
        
 --null checking        
        
 IF @ctxt_ouinstance = -915        
  Select @ctxt_ouinstance = null          
        
 IF @ctxt_user = '~#~' 
  Select @ctxt_user = null          
  
 IF @ctxt_language = -915        
  Select @ctxt_language = null          
        
 IF @ctxt_service = '~#~'         
  Select @ctxt_service = null          
        
 IF @accountnumber = '~#~' or @accountnumber = ''          
  Select @accountnumber = null          
        
 IF @company_ = '~#~'         
  Select @company_ = null          
        
 IF @datefrom = '01/01/1900' or @datefrom =''         
  Select @datefrom = null          
        
 IF @dateto = '01/01/1900' or @dateto=''         
  Select @dateto = null          
        
 IF @events = '~#~'         
  Select @events = null          
        
 IF @hdnguid = '~#~'         
  Select @hdnguid = null          
        
 IF @processingstatus = '~#~' or @processingstatus=''        
  Select @processingstatus = null         
        
  select @sysdt_tmp = convert(nvarchar(10),dbo.RES_Getdate(@ctxt_ouinstance),120)      
        
 IF  @datefrom > @dateto         
 begin        
 --raiserror ('Date From cannot be greater than Date To', 16,1)   
	exec fin_german_raiserror_sp 'ABR',@ctxt_language,408
 return        
 end        
      
       
 --Validation check for company      
 if not exists       
 (       
  select 'x'      
  from bnkdef_sysact_bank_vw (nolock)      
  where company_code = @company_      
  and @sysdt_tmp between effective_from       
   and isnull(effective_to, @sysdt_tmp)       
 )      
 begin      
  --raiserror('Bank Account Numbers have not been defined.',16,1) 
  		exec fin_german_raiserror_sp 'ABR',@ctxt_language,409
  return      
 end       

Select @eventscode_Tmp =  parameter_code   
FROM fin_quick_code_met(nolock)
WHERE component_id		= 'ABR'
and parameter_type		= 'COMBO'
and parameter_category  = 'event'
and parameter_text		= @events
and language_id			= @ctxt_language
--EPE-65957
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


 --PPS parameter set as 'No' Starts here - 'PPS_ABR_00001'(MT940- Auto Generate Bank Statements for No transaction days)
If @gen_stat_tmp = 'NO'
begin
if @eventscode_Tmp = 'SP'
	begin
         
if not exists ( Select distinct Account_Number 'bank_ac_no',         
   Error_Desc								   'error_message',         
   Filename_Date_Time_Stamp					   'filename', 
  -- Unique_Message_ID 'filename',   --unique_message_id      
   convert(datetime, Message_Date,103)		   'processing_date_time',         
   Status_Flag								   'processing_status',         
   Statement_Number							   'statementno',         
   Statement_Start_Date						   'statement_datefrom',         
   Statement_End_Date						   'statement_dateto',         
   Transaction_Date							   'stprocessingdate',         
   null										   '_company_'        
 from Iris_MT940_Staging a(nolock),bnkdef_acc_mst b(nolock)        
 where Account_Number =  isnull(@accountnumber,Account_Number)        
 and  isnull(@processingstatus,'pending') = 'Pending'   
  and  convert(date, statement_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, statement_start_date,102))  --3  
 and  convert(date, Statement_End_Date ,103)<= isnull(convert(date, @dateto,103),convert(date, Statement_End_Date,102))      --4
 --and  Statement_Start_Date >= isnull(@datefrom,Statement_Start_Date)        
 --and  Statement_End_Date <= isnull(@dateto,Statement_End_Date)
 and  company_code = @company_
 and   bank_acc_no = Account_Number
 and  Transaction_Date is not null
 and	@sysdt_tmp between effective_from
 and   isnull(effective_to, @sysdt_tmp)
        
 union       
     
 Select distinct bank_acc_no	'bank_ac_no',   
   c.errordesc					'error_message',         
   Filename_Date_Time_Stamp		'filename',         
   convert(time,message_time +  Message_Date) ,         
   'Failed'						'processing_status',         
   statement_no					'statementno',         
   Statement_Start_Date			'statement_datefrom',         
   Statement_End_Date			'statement_dateto',         
   rundate						'stprocessingdate',         
   null							'_company_'        
 from bank_stmt_temp_err_log a(nolock) , Iris_MT940_Staging b(nolock), fin_germantrn_errors c (nolock)      
 where account_no =  isnull(@accountnumber,account_no)        
 and  Account_Number = account_no        
 and  Unique_Message_ID = file_path        
 and  status_err = 'F'        
 and  isnull(@processingstatus ,'Failed') = 'Failed'        
 and  c.component_id = 'ABR'        
 and  c.language_id = @ctxt_language        
 and  c.errorid = a.error_id 
 and  Transaction_Date is not null
  and  convert(date, statement_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, statement_start_date,102))  --3  
  and  convert(date, Statement_End_Date ,103)<= isnull(convert(date, @dateto,103),convert(date, Statement_End_Date,102))      --4
   --and  Statement_Start_Date >= isnull(@datefrom,Statement_Start_Date)        
 --and  Statement_End_Date <= isnull(@dateto,Statement_End_Date)        
 union        
 Select distinct bank_acc_no 'bank_ac_no',     
   'Success'				 'error_message',         
   original_filename		 'filename',         
   file_processdate			 'processing_date_time',         
   'Success'				 'processing_status',         
   stmt_no					 'statementno',         
   stmt_start_date			 'statement_datefrom',         
   stmt_start_date			 'statement_dateto',         
   createddate				 'stprocessingdate',         
   null						 '_company_'        
 from abr_statement_hdr_hist a(nolock)         
 where bank_acc_no =  isnull(@accountnumber,bank_acc_no)        
 and  isnull(@processingstatus,'Success') = 'Success' 
 and tran_date is not null
  and  convert(date, stmt_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, stmt_start_date,102))  --3  
  and  convert(date, stmt_end_date ,103)<= isnull(convert(date, @dateto,103),convert(date, stmt_end_date,102))      --4
 --and  stmt_start_date >= isnull(@datefrom,stmt_start_date)        
 --and  stmt_end_date <= isnull(@dateto,stmt_end_date)        
)         
begin         
 --raiserror ('No records found. Refine search criteria', 16,1)
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,410
 return        
        
end   


;with maxdate(messagedate,account_no)     
as    
(    
select max(convert(datetime, concat(concat(message_date,' ') , convert(time(0), cast(message_time as time))),103)),Account_Number    
from Iris_MT940_Staging(nolock)    
 where status_flag is null    
 group by Account_Number    
) 

 insert into @header    
     (      bank_acc_no,    
            error_desc,    
            Filename_out,    
            Processdate,    
            processstatus,    
            statement_no,    
            Statement_Start_Date,                  
            Statement_End_Date,    
            statementprocessdate,    
            company,
			Unique_Message_ID)    
    
 Select distinct     
  Account_Number ,         
        Error_Desc ,         
        Filename_Date_Time_Stamp ,  
        convert(datetime, concat(concat(message_date,' ') , convert(time(0), cast(message_time as time))),103) ,         
        case when Status_Flag is null then 'Pending'         
        else 'Success' end  'processing_status',         
        Statement_Number ,         
        convert(date, statement_start_date,103),         
        convert(date, Statement_End_Date,103)  ,         
        null  ,   @company_         ,		
		Unique_Message_ID
 from Iris_MT940_Staging a(nolock),bnkdef_acc_mst b(nolock),maxdate c(nolock)        
 where Account_Number =  isnull(@accountnumber,Account_Number)        
 and  isnull(@processingstatus,'pending') = 'Pending'        
-- and  Status_Flag <> 'F'        
 and  Status_Flag is null      
 and  convert(date, statement_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, statement_start_date,102))  --3  
 and  convert(date, Statement_End_Date ,103)<= isnull(convert(date, @dateto,103),convert(date, Statement_End_Date,102))      --4
 and c.messagedate = convert(datetime, concat(concat(a.message_date,' ') , convert(time(0), cast(a.message_time as time))),103)
 and c.account_no = a.Account_Number
 --and c.messagetime = a.Message_Time
 and  company_code = @company_
 and  Transaction_Date is not null
 and   bank_acc_no = Account_Number
 and	@sysdt_tmp between effective_from
 and   isnull(effective_to, @sysdt_tmp)
    
;with maxdate(rundate,account_number)     
as    
(    
select max(rundate),account_no    
from bank_stmt_temp_err_log(nolock)    
 where status_err = 'F'    
 group by account_no    
)    
    
                      
    
 insert into @header    
     (      bank_acc_no,    
            error_desc,    
            Filename_out,    
            Processdate,    
            processstatus,    
            statement_no,    
            Statement_Start_Date,                  
            Statement_End_Date,    
            statementprocessdate,    
            company,
			Unique_Message_ID)    
    
  Select    distinct  a.bank_acc_no,   
            --c.errordesc    ,
			case when a.error_id = 1 then a.error_desc else c.errordesc end,--1.2
            Filename_Date_Time_Stamp    ,    
			convert(datetime, concat(concat(message_date,' ') , convert(time(0), cast(message_time as time))),103),
            'Failed'        'processing_status',    
            statement_no ,    
            convert(date, statement_start_date,103),    
            convert(date, Statement_End_Date ,103),    
            d.rundate,    
            @company_        '_company_' ,
			Unique_Message_ID
    from    bank_stmt_temp_err_log a(nolock) , Iris_MT940_Staging b(nolock), fin_germantrn_errors c (nolock), maxdate d(nolock),bnkdef_acc_mst e(nolock)   
    where    account_no    =     isnull(@accountnumber,account_no)    
    and        b.Account_Number = a.account_no    
    and        d.Account_Number = a.account_no    
    and           d.rundate        = a.rundate    
    and        Unique_Message_ID = file_path    
  and status_err    =    'F'    
    and        isnull(@processingstatus ,'Failed')    =    'Failed'    
    and        c.component_id = 'ABR'    
    and        c.language_id = 1    
    and        c.errorid = a.error_id        
 and  convert(datetime, statement_start_date,103)>= isnull(convert(datetime, @datefrom,103),convert(datetime, statement_start_date,103))          
 and  convert(datetime, Statement_End_Date ,103)<= isnull(convert(datetime, @dateto,103),convert(datetime, Statement_End_Date,103))
 and  company_code = @company_
 and   e.bank_acc_no = b.Account_Number
 and  Transaction_Date is not null
 and	@sysdt_tmp between effective_from
 and   isnull(effective_to, @sysdt_tmp)
 --and rundate = (select max(rundate) from bank_stmt_temp_err_log where account_no=isnull(@accountnumber,account_no))    
    
    end

if @eventscode_Tmp = 'FP'
	begin
	
;with maxdate(rundate,filepath)     
as    
(    
select max(rundate),file_path    
from bank_stmt_temp_err_log(nolock)    
 where status_err = 'F'    
 and account_no is null
GROUP BY file_path
)

 insert into @header
			
            (bank_acc_no,
			error_desc,    
            Filename_out,    
            Processdate,    
            company,
			Unique_Message_ID
			)    
    
  Select    distinct  bank_acc_no,
           a.error_desc    ,  
            original_filename    ,    
            b.rundate,    
            @company_        '_company_', 
			filepath
   from    bank_stmt_temp_err_log a(nolock)    ,maxdate b(nolock)
    where  a.status_err = 'F'
	and b.filepath = a.file_path
	and a.account_no is null
	and b.rundate = a.rundate 
	--and a.rundate >= @datefrom and a.rundate <= @dateto
	and
	 convert(date, a.rundate,103)>= isnull(convert(date, @datefrom,103),convert(date, a.rundate,103))
	 and
	 convert(date, a.rundate,103)<= isnull(convert(date, @dateto,103),convert(date, a.rundate,103))
	--GROUP BY file_path
    --and        b.Account_Number = a.account_no    
    --and        d.Account_Number = a.account_no    
    --and           d.rundate        = a.rundate    
    --and        Unique_Message_ID = file_path    
    --and        status_err    =    'F'    
    --and        isnull(@processingstatus ,'Failed')    =    'Failed'    
    --and        c.component_id = 'ABR'    
    --and        c.language_id = 1    
    --and        c.errorid = a.error_id        
 --and  convert(datetime, b.rundate,103)>= isnull(convert(datetime, @datefrom,103),convert(datetime, b.rundate,103)) --change         
 --and  convert(datetime, a.rundate ,103)<= isnull(convert(datetime, @dateto,103),convert(datetime, a.rundate,103))          
 --and rundate = (select max(rundate) from bank_stmt_temp_err_log where account_no=isnull(@accountnumber,account_no))    

end 

;with maxdate(fileprocessdate,statement_no)     
as    
(    
select distinct max(convert(varchar,concat(concat( convert(date, file_processdate) ,' ') ,convert(time(0), cast(file_processtime as time))),103)),stmt_no    
from abr_statement_hdr_hist(nolock) 
group by stmt_no    
)   

 insert into @header    
     (      bank_acc_no,    
            error_desc,    
            Filename_out,    
            Processdate,
            processstatus,    
            statement_no,    
            Statement_Start_Date,                  
            Statement_End_Date,    
            statementprocessdate,    
            company,
			Unique_Message_ID)    
    
    
 Select distinct  a.bank_acc_no ,         
      'Success'  'error_message',         
      original_filename ,         
      --file_processdate  ,         
		convert(varchar,concat(concat( convert(date, a.file_processdate) ,' ') ,convert(time(0), cast(file_processtime as time))),103),
		'Success'  'processing_status',         
      a.stmt_no ,         
      convert(date, a.stmt_start_date,103)  ,         
      convert(date, a.stmt_end_date,103)  ,         
      convert(datetime,a.createddate)  ,         
      @company_ ,
	  file_path
 from abr_statement_hdr_hist a(nolock) ,maxdate b(nolock),abr_bank_statement_hdr c(nolock)        
 where a.bank_acc_no =  isnull(@accountnumber,a.bank_acc_no) 
-- and a.bank_acc_no = b.account_number
 and  isnull(@processingstatus,'Success') = 'Success'     
 and  tran_date is not null
 and a.company_code = @company_
 and a.stmt_no = b.statement_no
 and a.bank_acc_no = c.bank_acc_no
 and a.stmt_end_date = c.stmt_end_date
 and b.fileprocessdate =  convert(varchar,concat(concat( convert(date, a.file_processdate) ,' ') ,convert(time(0), cast(a.file_processtime as time))),103)
 and  convert(date, a.stmt_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, a.stmt_start_date,103))        
 and  convert(date, a.stmt_end_date,103)<= isnull(convert(date, @dateto,103),convert(date, a.stmt_end_date,103))       
   
  end
  --PPS parameter set as 'No' ends here - 'PPS_ABR_00001'(MT940- Auto Generate Bank Statements for No transaction days)


 --PPS parameter set as 'YES' Starts here - 'PPS_ABR_00001'(MT940- Auto Generate Bank Statements for No transaction days)
If @gen_stat_tmp = 'YES'
begin
if @eventscode_Tmp = 'SP'
	begin
         
if not exists ( Select distinct Account_Number 'bank_ac_no',         
   Error_Desc								   'error_message',         
   Filename_Date_Time_Stamp					   'filename', 
  -- Unique_Message_ID 'filename',   --unique_message_id      
   convert(datetime, Message_Date,103)		   'processing_date_time',         
   Status_Flag								   'processing_status',         
   Statement_Number							   'statementno',         
   Statement_Start_Date						   'statement_datefrom',         
   Statement_End_Date						   'statement_dateto',         
   Transaction_Date							   'stprocessingdate',         
   null										   '_company_'        
 from Iris_MT940_Staging a(nolock),bnkdef_acc_mst b(nolock)        
 where Account_Number =  isnull(@accountnumber,Account_Number)        
 and  isnull(@processingstatus,'pending') = 'Pending'   
  and  convert(date, statement_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, statement_start_date,102))  --3  
 and  convert(date, Statement_End_Date ,103)<= isnull(convert(date, @dateto,103),convert(date, Statement_End_Date,102))      --4
 --and  Statement_Start_Date >= isnull(@datefrom,Statement_Start_Date)        
 --and  Statement_End_Date <= isnull(@dateto,Statement_End_Date)
 and  company_code = @company_
 and   bank_acc_no = Account_Number
 --and  Transaction_Date is not null
 and	@sysdt_tmp between effective_from
 and   isnull(effective_to, @sysdt_tmp)
        
 union       
     
 Select distinct bank_acc_no	'bank_ac_no',         
   c.errordesc					'error_message',         
   Filename_Date_Time_Stamp		'filename',         
   convert(time,message_time +  Message_Date) ,         
   'Failed'						'processing_status',         
   statement_no					'statementno',         
   Statement_Start_Date			'statement_datefrom',         
   Statement_End_Date			'statement_dateto',         
   rundate						'stprocessingdate',         
   null							'_company_'        
 from bank_stmt_temp_err_log a(nolock) , Iris_MT940_Staging b(nolock), fin_germantrn_errors c (nolock)      
 where account_no =  isnull(@accountnumber,account_no)        
 and  Account_Number = account_no        
 and  Unique_Message_ID = file_path        
 and  status_err = 'F'        
 and  isnull(@processingstatus ,'Failed') = 'Failed'        
 and  c.component_id = 'ABR'        
 and  c.language_id = @ctxt_language        
 and  c.errorid = a.error_id 
 --and  Transaction_Date is not null
  and  convert(date, statement_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, statement_start_date,102))  --3  
  and  convert(date, Statement_End_Date ,103)<= isnull(convert(date, @dateto,103),convert(date, Statement_End_Date,102))      --4
   --and  Statement_Start_Date >= isnull(@datefrom,Statement_Start_Date)        
 --and  Statement_End_Date <= isnull(@dateto,Statement_End_Date)        
 union        
 Select distinct bank_acc_no 'bank_ac_no',     
   'Success'				 'error_message',         
   original_filename		 'filename',         
   file_processdate			 'processing_date_time',         
   'Success'				 'processing_status',         
   stmt_no					 'statementno',         
   stmt_start_date			 'statement_datefrom',         
   stmt_start_date			 'statement_dateto',         
   createddate				 'stprocessingdate',         
   null						 '_company_'        
 from abr_statement_hdr_hist a(nolock)         
 where bank_acc_no =  isnull(@accountnumber,bank_acc_no)        
 and  isnull(@processingstatus,'Success') = 'Success' 
 --and tran_date is not null
  and  convert(date, stmt_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, stmt_start_date,102))  --3  
  and  convert(date, stmt_end_date ,103)<= isnull(convert(date, @dateto,103),convert(date, stmt_end_date,102))      --4
 --and  stmt_start_date >= isnull(@datefrom,stmt_start_date)        
 --and  stmt_end_date <= isnull(@dateto,stmt_end_date)        
)         
begin         
 --raiserror ('No records found. Refine search criteria', 16,1)
		exec fin_german_raiserror_sp 'ABR',@ctxt_language,410
 return        
        
end   


;with maxdate(messagedate,account_no)     
as    
(    
select max(convert(datetime, concat(concat(message_date,' ') , convert(time(0), cast(message_time as time))),103)),Account_Number    
from Iris_MT940_Staging(nolock)    
 where status_flag is null    
 group by Account_Number    
) 

 insert into @header    
     (      bank_acc_no,    
            error_desc,    
            Filename_out,    
            Processdate,    
            processstatus,    
            statement_no,    
            Statement_Start_Date,                  
            Statement_End_Date,    
            statementprocessdate,    
            company,
			Unique_Message_ID)    
    
 Select distinct     
  Account_Number ,         
        Error_Desc ,         
        Filename_Date_Time_Stamp ,  
        convert(datetime, concat(concat(message_date,' ') , convert(time(0), cast(message_time as time))),103) ,         
        case when Status_Flag is null then 'Pending'         
        else 'Success' end  'processing_status',         
        Statement_Number ,         
        convert(date, statement_start_date,103),         
        convert(date, Statement_End_Date,103)  ,         
        null  ,   @company_         ,		
		Unique_Message_ID
 from Iris_MT940_Staging a(nolock),bnkdef_acc_mst b(nolock),maxdate c(nolock)        
 where Account_Number =  isnull(@accountnumber,Account_Number)        
 and  isnull(@processingstatus,'pending') = 'Pending'        
-- and  Status_Flag <> 'F'        
 and  Status_Flag is null      
 and  convert(date, statement_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, statement_start_date,102))  --3  
 and  convert(date, Statement_End_Date ,103)<= isnull(convert(date, @dateto,103),convert(date, Statement_End_Date,102))      --4
 and c.messagedate = convert(datetime, concat(concat(a.message_date,' ') , convert(time(0), cast(a.message_time as time))),103)
 and c.account_no = a.Account_Number
 --and c.messagetime = a.Message_Time
 and  company_code = @company_
 --and  Transaction_Date is not null
 and   bank_acc_no = Account_Number
 and	@sysdt_tmp between effective_from
 and   isnull(effective_to, @sysdt_tmp)
    
;with maxdate(rundate,account_number)     
as    
(    
select max(rundate),account_no    
from bank_stmt_temp_err_log(nolock)    
 where status_err = 'F'    
 group by account_no    
)    
    
                      
    
 insert into @header    
     (      bank_acc_no,    
            error_desc,    
            Filename_out,    
            Processdate,    
            processstatus,    
            statement_no,    
            Statement_Start_Date,                  
            Statement_End_Date,    
            statementprocessdate,    
            company,
			Unique_Message_ID)    
    
  Select    distinct  a.bank_acc_no,   
            --c.errordesc    ,
			case when a.error_id = 1 then a.error_desc else c.errordesc end,--1.2
            Filename_Date_Time_Stamp    ,    
			convert(datetime, concat(concat(message_date,' ') , convert(time(0), cast(message_time as time))),103),
            'Failed'        'processing_status',    
            statement_no ,    
            convert(date, statement_start_date,103),    
            convert(date, Statement_End_Date ,103),    
            d.rundate,    
            @company_        '_company_' ,
			Unique_Message_ID
    from    bank_stmt_temp_err_log a(nolock) , Iris_MT940_Staging b(nolock), fin_germantrn_errors c (nolock), maxdate d(nolock),bnkdef_acc_mst e(nolock)   
    where    account_no    =     isnull(@accountnumber,account_no)    
    and        b.Account_Number = a.account_no    
    and        d.Account_Number = a.account_no    
    and           d.rundate        = a.rundate    
    and        Unique_Message_ID = file_path    
  and status_err    =    'F'    
    and        isnull(@processingstatus ,'Failed')    =    'Failed'    
    and        c.component_id = 'ABR'    
    and        c.language_id = 1    
    and        c.errorid = a.error_id        
 and  convert(datetime, statement_start_date,103)>= isnull(convert(datetime, @datefrom,103),convert(datetime, statement_start_date,103))          
 and  convert(datetime, Statement_End_Date ,103)<= isnull(convert(datetime, @dateto,103),convert(datetime, Statement_End_Date,103))
 and  company_code = @company_
 and   e.bank_acc_no = b.Account_Number
-- and  Transaction_Date is not null
 and	@sysdt_tmp between effective_from
 and   isnull(effective_to, @sysdt_tmp)
 --and rundate = (select max(rundate) from bank_stmt_temp_err_log where account_no=isnull(@accountnumber,account_no))    
    
    end

if @eventscode_Tmp = 'FP'
	begin
	
;with maxdate(rundate,filepath)     
as    
(    
select max(rundate),file_path    
from bank_stmt_temp_err_log(nolock)    
 where status_err = 'F'    
 and account_no is null
GROUP BY file_path
)

 insert into @header
			
            (bank_acc_no,
			error_desc,    
            Filename_out,    
            Processdate,    
            company,
			Unique_Message_ID
			)    
    
  Select    distinct  bank_acc_no,
           a.error_desc    ,  
            original_filename    ,    
            b.rundate,    
            @company_        '_company_', 
			filepath
   from    bank_stmt_temp_err_log a(nolock)    ,maxdate b(nolock)
    where  a.status_err = 'F'
	and b.filepath = a.file_path
	and a.account_no is null
	and b.rundate = a.rundate 
	--and a.rundate >= @datefrom and a.rundate <= @dateto
	and
	 convert(date, a.rundate,103)>= isnull(convert(date, @datefrom,103),convert(date, a.rundate,103))
	 and
	 convert(date, a.rundate,103)<= isnull(convert(date, @dateto,103),convert(date, a.rundate,103))
	--GROUP BY file_path
    --and        b.Account_Number = a.account_no    
    --and        d.Account_Number = a.account_no    
    --and           d.rundate        = a.rundate    
    --and        Unique_Message_ID = file_path    
    --and        status_err    =    'F'    
    --and        isnull(@processingstatus ,'Failed')    =    'Failed'    
    --and        c.component_id = 'ABR'    
    --and        c.language_id = 1    
    --and        c.errorid = a.error_id        
 --and  convert(datetime, b.rundate,103)>= isnull(convert(datetime, @datefrom,103),convert(datetime, b.rundate,103)) --change         
 --and  convert(datetime, a.rundate ,103)<= isnull(convert(datetime, @dateto,103),convert(datetime, a.rundate,103))          
 --and rundate = (select max(rundate) from bank_stmt_temp_err_log where account_no=isnull(@accountnumber,account_no))    

end 

;with maxdate(fileprocessdate,statement_no)     
as    
(    
select distinct max(convert(varchar,concat(concat( convert(date, file_processdate) ,' ') ,convert(time(0), cast(file_processtime as time))),103)),stmt_no    
from abr_statement_hdr_hist(nolock) 
group by stmt_no    
)   

 insert into @header    
     (      bank_acc_no,    
            error_desc,    
            Filename_out,    
            Processdate,
            processstatus,    
            statement_no,    
            Statement_Start_Date,                  
            Statement_End_Date,    
            statementprocessdate,    
            company,
			Unique_Message_ID)    
    
    
 Select distinct  a.bank_acc_no ,         
      'Success'  'error_message',         
      original_filename ,         
      --file_processdate  ,         
		convert(varchar,concat(concat( convert(date, a.file_processdate) ,' ') ,convert(time(0), cast(file_processtime as time))),103),
		'Success'  'processing_status',         
      a.stmt_no ,         
      convert(date, a.stmt_start_date,103)  ,         
      convert(date, a.stmt_end_date,103)  ,         
      convert(datetime,a.createddate)  ,         
      @company_ ,
	  file_path
 from abr_statement_hdr_hist a(nolock) ,maxdate b(nolock),abr_bank_statement_hdr c(nolock)        
 where a.bank_acc_no =  isnull(@accountnumber,a.bank_acc_no) 
-- and a.bank_acc_no = b.account_number
 and  isnull(@processingstatus,'Success') = 'Success'     
 --and  tran_date is not null
 and a.company_code = @company_
 and a.stmt_no = b.statement_no
 and a.bank_acc_no = c.bank_acc_no
 and a.stmt_end_date = c.stmt_end_date
 and b.fileprocessdate =  convert(varchar,concat(concat( convert(date, a.file_processdate) ,' ') ,convert(time(0), cast(a.file_processtime as time))),103)
 and  convert(date, a.stmt_start_date,103)>= isnull(convert(date, @datefrom,103),convert(date, a.stmt_start_date,103))        
 and  convert(date, a.stmt_end_date,103)<= isnull(convert(date, @dateto,103),convert(date, a.stmt_end_date,103))       
   
  end
  --PPS parameter set as 'YES' ends here - 'PPS_ABR_00001'(MT940- Auto Generate Bank Statements for No transaction days)
 Select  
  null					'attachments',
  bank_acc_no			'bank_ac_no',         
  error_desc			'error_message',         
  Filename_out			'filename',   
  Unique_Message_ID		'hdnuniquemessageid_stml',
  Processdate			'processing_date_time',         
  processstatus			'processing_status',         
  statement_no			'statementno',         
  convert(date,Statement_Start_Date)  'statement_datefrom',         
  convert(date,Statement_End_Date)    'statement_dateto',         
  statementprocessdate	'stprocessingdate',         
  company				'_company_'     
  FROM @header    
       

Set nocount off        
        
End 

