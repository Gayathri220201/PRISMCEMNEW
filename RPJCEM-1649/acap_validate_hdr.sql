/*$File_version=ms4.3.0.11$*/
/*$file name : acap_validate_hdr.sql					*/
/*$version   : 4.0.0.002						*/
/*======================================================================*/
/*  stored procedure : acap_validate_hdr
	method           : 
	author           : Sangeetha Sitaraman
	created on       : 15/11/2005
**************************************************************************
		Modification history
**************************************************************************
	Modified by	: Sangeetha Sitaraman
	Modified Date	: 06/01/2006			
	Purpose		: ACAPDMS412AT_000265
/*************************************************************************/
/*Modified by        : Swetha                                            */
/*Modified Date      : 5/5/2006                                          */
/*Purpose            : CML Changes                                       */
/************************************************************************/
*************************************************************************/
-- procedure acap_validate_hdr
-- grant exec on acap_validate_hdr to public
/* Balaji C				13/11/2015				ES_ACAP_00900			*/
/* Balaji C				13/11/2015				ES_ACAP_00912			*/
/*  Harithra		 17-08-2018         EPE-8428                        */
/*  Harithra		 17-08-2018         EPE-8702                        */
/*Priyadarshini R       21-10-19                EBS-3156              */
----C.Ramesh Kumar		24.10.2019		epe-16037
/*Mabel Rita L          13-01-2020      ZHE-3588                      */
/*Keerthana	K			31/01/2020		SCLRES-1050		  	          */
/*Ancy Peter            22-06-2023      RGSE-136                      */
/*Abhijith KP			28-07-2023		EPE-62647					  */
/************************************************************************/
CREATE procedure acap_validate_hdr
	     @assetclass   			fin_assetclass  ,
	     @assetcost	   			fin_amount ,	 	
	     @assetdescription   	fin_desc40  ,
	     @assetgrpnum   		fin_group  ,
	     @assetnumber   		fin_assetnumber  ,
	     @capitalizationdate   	fin_date  ,
	     @costcenter   			fin_costcentercode  ,
	     @ctxt_language   		fin_ctxt_language  ,
	     @ctxt_ouinstance   	fin_ctxt_ouinstance  ,
	     @ctxt_service   		fin_ctxt_service  ,
	     @ctxt_user   			fin_ctxt_user  ,
	     @fb   					fin_financebookid  ,
	     @companycode			fin_companycode,
	     @today					fin_date,
		 /*code modified for EPE-8428 - Harithra*/
		 @accountcode          	fin_accountcode, --Input 
		 @lscostcentre         	fin_costcentercode, --Input 
		 @analysiscode         	fin_analysiscode, --Input 
		 @subanalysiscode      	fin_subanalysiscode, --Input 
		 @doc_flag				fin_flag,--EPE-8702
		 @m_errorid  			fin_int output, --to return execution status
		 @measurunit			udd_uomcode = null,--epe-16037
		 @totalcapact			fin_quantity = null--epe-16037
as
begin	
	-- nocount should be switched on to prevent phantom rows 
	set nocount on
	-- @m_errorid should be 0 to indicate success
	select @m_errorid =0

	-- get date time with only datepart

	declare @m_errout_tmp		fin_int ,
		@fycode1_tmp		fin_financeperiodrange ,
		@fpcode1_tmp		fin_financeperiodrange,
		@errmsg                 fin_desc255,
	 	@csetou 		fin_ctxt_ouinstance,
		@ainfou 		fin_ctxt_ouinstance,
		@status_tmp		fin_status,
		@buid			fin_buid
	declare @err_tmp int
	select @err_tmp = 0
	
--epe-14560 starts
	if @ctxt_service like 'fahcap%'
	begin
		select @m_errorid =1
	end
--epe-14560 ends

	select 	@csetou 			=  destinationouinstid
	from 	fw_admin_view_comp_intxn_model  (nolock)
	where 	sourceouinstid 			= @ctxt_ouinstance
	and 	sourcecomponentname 		= 'ACAP'
	and 	destinationcomponentname 	= 'CSET'
	
	select 	@ainfou 			=  destinationouinstid
	from 	fw_admin_view_comp_intxn_model  (nolock)
	where 	sourceouinstid 			= @ctxt_ouinstance
	and 	sourcecomponentname 		= 'ACAP'
	and 	destinationcomponentname 	= 'AINF'


	select  @buid	= bu_id
	from 	emod_lo_bu_ou_vw(nolock)
	where	ou_id	= @csetou

   --EPE-62647
   declare @pps_flag_cc    fin_flag
  
   select @pps_flag_cc = FLAG_YES_NO
   from pps_finance_feature_list with (nolock)
   where FEATURE_ID = 'PPS_CostCenter_FA'
   and company_code = @companycode

   if @pps_flag_cc is null
   BEGIN
       select @pps_flag_cc = FLAG_YES_NO
       from pps_finance_feature_list with (nolock)
       where FEATURE_ID = 'PPS_CostCenter_FA'
       and company_code IS NULL
   END

  --EPE-62647

	
	
	-- Asset Description can not be null
	if @assetdescription is null
	begin
		select @m_errorid = 30
		return
	end
	
	-- Asset Cost can not be null
	if @assetcost is null
	begin
	--	ZHE-3588 starts
	--select @m_errorid = 3455398
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,1900027509
	--	ZHE-3588 ends
		    return
	end
	-- Asset Cost can not be less than zero
	if @assetcost < 0 
	begin
		--RAISERROR('Asset Cost can not be less than zero',16,1)
		select @m_errorid = 3455399
		return
	end


	if @assetcost = 0 
	begin
		--RAISERROR('Asset Cost cannot be zero',16,1)
		select @m_errorid = 31
		return
	end
	
	-- Asset class should not be null
	if @assetclass is null
	begin
		select @m_errorid = 177
		return
	end
	
	-- capitalization date can not be null
	if @capitalizationdate is null
	begin
		select @m_errorid = 28
		return
	end
	
	-- capitalization date can not be greater than sysdate	
	if @capitalizationdate > dbo.RES_Getdate(@ctxt_ouinstance)
	begin
		select @m_errorid = 92
		return
	end
	
	
	-- to check for transaction date
	if exists (select 'x' from 	acap_cim_intxn_model_vw c (nolock), 
					emod_ou_vw  b (nolock)
				where 	c.sourceouinstid 		= @ctxt_ouinstance
				and 	c.sourcecomponentname 		= 'ACAP'
				and 	b.ou_id 			= c.destinationouinstid
				and 	@today 				between b.effective_from and isnull(b.effective_to,@today)
				and 	c.destinationcomponentname	= 'FCC')
	begin
		exec @err_tmp = fcc_sysact_spvaltrndate 	@ctxt_ouinstance , --EBS-3156
								'ACAP' , 
								@ctxt_user , 
								@fb , 
								@capitalizationdate,
								@status_tmp output,
								@fycode1_tmp output ,
								@fpcode1_tmp output,
                                                                @ctxt_language
		
		-- 1  transaction date is in closed period or year of the bfg ou
		-- 2  transaction date is in closed period or year of the finance book
		-- 3  period or year is not defined for the given transaction date  
		-- 4  provide organisation unit
		-- 5  provide component name
		-- 6  provide finance book id
		-- 7  provide transaction date
		
		select @m_errout_tmp =  case @err_tmp --EBS-3156
					when 1 then 196
					when 2 then 197
					when 3 then 198
					when 4 then 109
					when 5 then 217
					when 6 then 110
					when 7 then 46
					when 0 then 0	
					end
		
		if @m_errout_tmp <> 0 
		begin
		--Code start for RGSE-136
		  if @m_errout_tmp = 198
		    begin
			    exec fin_german_raiserror_sp 'CDCN',@ctxt_language,27
				return
			end
		  else
		--Code end for RGSE-136
			select  @m_errorid = @m_errout_tmp
			return
		end
	
	end
	

	if @assetgrpnum is not null
	begin
		if exists(select 'x'
				from 	emod_ou_vw  b (nolock)
				where 	b.ou_id	= @ainfou
				and 	@capitalizationdate	between b.effective_from and isnull(b.effective_to,@capitalizationdate)
				)
		and not exists (select 'x' from ainf_asset_group_vw (nolock)
				where 	ou_id 			= @ainfou
				and 	asset_group_code 	= upper(@assetgrpnum)
				and 	asset_group_status 	= 'A')

		begin
			--Asset group Code does not exist
			select @m_errorid = 62
			return
		end
	end


	
	-- cost center exists or not and cim interaction between acap and cset

	if exists (select 'x' from emod_ou_vw  b (nolock)
			where b.ou_id 		= @csetou
			and @capitalizationdate between b.effective_from and isnull(b.effective_to,@capitalizationdate)
			)
	begin
		/*code added by sangeetha for the issue ACAPDMS412AT_000265 begin here */
		--if  exists(select 'x' from ainf_asset_class_vw(nolock)	--SCLRES-1050
		if  exists(select 'x' from ainf_asset_class_mst(nolock)		--SCLRES-1050
			where 	ou_id			= @ainfou
			--and	dest_component		= 'ACAP'					--SCLRES-1050
			and	asset_class_code	=  @assetclass
			and	depreciable		= 'Y'
			and	asset_class_status	= 'A')
		begin
		/*code added by sangeetha for the issue ACAPDMS412AT_000265 end here */

		--EPE-62647
		  if @pps_flag_cc = 'YES' and @costcenter is null
		  begin
			if  exists(	select  '*' 	  from      mac_acc_ce_cc_mapping mac with (nolock),  
														ard_asset_account_mst ard with (nolock)    
												where  	ard.account_code 	= mac.account_no  
												and  	ard.fb_id   		= @fb 
												and  	ard.asset_class  	= @assetclass  
												and  	ard.asset_usage  	in  ('DEPREC', 'LOSREV','REVDEP','IMPLOSS') 
												and     mac.bu_id			= @buid)

					begin
										select @m_errorid = 3455400
										return	
					end


		    end
		--EPE-62647
		if (@pps_flag_cc = 'YES' and @costcenter is not null) or  @pps_flag_cc = 'NO' --EPE-62647	
		begin
			if @costcenter is null
			begin
				--Enter Cost Center
				select @m_errorid = 3455400
				return
			end
			if not exists(select 'x' from mac_cost_center_vw (nolock)
					where bu_id		= @buid
					and upper(ma_center_no) = upper(@costcenter)
					and ma_status 		= 'A')
			begin	
	                        --raiserror('Cost Center does not exists',16,1)
	                        select @m_errorid = 237
				return
			end	
			
			/*Code added for ITS ID : ES_ACAP_00900 starts*/
			if not exists(	select 'x' from mac_cost_center_vw (nolock)
							where	bu_id				= @buid
							and		upper(ma_center_no) = upper(@costcenter)
							and		ma_status 			= 'A'
							and		ma_center_leaf		= 'D')
			begin	
				--raiserror('Invalid Posting Cost Center',16,1)
				exec fin_german_raiserror_sp 'ADEPP',@ctxt_language,89
				return
			end	
			
			/*Code added for ITS ID : ES_ACAP_00912 starts*/
			if not exists(	select  'x'  
							from  	mac_acc_ce_cc_mapping mac (nolock),  
									ard_asset_account_mst ard (nolock)    
							where  	ard.company_code  	= mac.company_code 
							and  	ard.account_code 	= mac.account_no  
							and  	ard.fb_id   		= @fb 
							and  	ard.asset_class  	= @assetclass  
							and  	ard.asset_usage  	= 'DEPREC'  
							and  	upper(mac.center_no)= upper(@costcenter)
						)  
			begin
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,1900027507,@costcenter
				return
			end
			/*Code added for ITS ID : ES_ACAP_00912 ends*/
			/*Code added for ITS ID : ES_ACAP_00900 ends*/
			
		/*code added by sangeetha for the issue ACAPDMS412AT_000265 begin here */
		   end --EPE-62647	
		end
		/*code added by sangeetha for the issue ACAPDMS412AT_000265 end here */
	end
	----EPE-8702
	/*code modified for EPE-8428 - Harithra*/
	if exists (select 'X' from cps_processparam_sys
				where company_code  = @companycode
				and	language_id   = @ctxt_language
				and	parameter_type = 'FASYS'
				and parameter_category = 'MANENTWOREFDOC'
				and parameter_code		= 'Y')

				AND @doc_flag = 'N'
	begin
	if @accountcode is null
	begin
		--raiserror('Enter Valid Account Code )
		exec	fin_german_raiserror_sp 'ACAP',@ctxt_language,599
		return
	end

	if @accountcode is not null
	begin 
	if not exists ( 
		select 'x' 
		from as_opaccountfb_vw (nolock)
		where company_code 	= @companycode
		and account_code 	= @accountcode
		and map_status 		= 'A' 
		and @today between effective_from and isnull(effective_to,'01-01-9999'))
	begin
		--raiserror('Enter Valid Account Code )
		exec	fin_german_raiserror_sp 'ACAP',@ctxt_language,599
		return
	end

	if exists ( 
		select 'x' 
		from as_opaccountfb_vw (nolock)
		where company_code 	= @companycode
		and account_code 	= @accountcode
		and map_status 		= 'A' 
		and ctrl_acctype is not null
		and @today between effective_from and isnull(effective_to,'01-01-9999'))
	begin
		--raiserror(Contra Account code  %s cannot be of Control Account Type. Please modify.)
		exec	fin_german_raiserror_sp 'ACAP',@ctxt_language,614,@accountcode
		return
	end

	if not exists ( select 'x' from as_opaccountfb_vw (nolock)
						where company_code 	= @companycode
						and account_code 	= @accountcode
						and fb_id			= @fb
						and map_status 		= 'A' 
						and @today between effective_from and isnull(effective_to,'01-01-9999'))
	--Account code not attached  to the Finance Book
	begin
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,600
		return
	end	

	end

	if exists	(select	'x'
			from	mac_cc_acc_mapped_vw
			where	bu_id		=	@buid
			and	account_no	=	@accountcode
			and	center_no	is not null
			and	@today between effective_date and isnull(expiry_date,'9999-01-01'))
			
			AND @lscostcentre is null
	--Please provide costcenter
	begin
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,615,@accountcode
		return
	end	

	if @lscostcentre is not null
	begin	
	if not exists (select	'X'
					from	mac_cost_center_vw
					where	company_code		=	@companycode
					and	bu_id					=	@buid
					and	ma_center_no			=	@lscostcentre
					and	@today between ma_effective_date and isnull(ma_expiry_date,'9999-01-01')
					and	ma_status				=	'A')
	--Invalid Contraaccount costcenter 
	begin
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,601
		return
	end	

	if not exists	(select	'x'
					from	mac_cc_acc_mapped_vw
					where	bu_id		=	@buid
					and	account_no		=	@accountcode
					and	center_no		=	@lscostcentre
					and	@today between effective_date and isnull(expiry_date,'9999-01-01'))
	--Costcenter '##' is not mapped to the Accountcode '##'
	begin
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,602,@lscostcentre,@accountcode
		return
	end	
	end

	--if @analysiscode is not null or @subanalysiscode is not null
--	begin
	exec @err_tmp = abb_sysact_acansub_val 	@ctxt_language,
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
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,603,@analysiscode,@accountcode
			return  --Invalid Analysis Code <%1> for the Account Code <%2>
			End
		if @err_tmp = 6
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,604,@analysiscode,@accountcode
			return  --Analysis Code <%1> is in INActive status for the account code <%2>
			End
		if @err_tmp = 7
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,605,@subanalysiscode,@accountcode,@analysiscode
			return --Invalid Sub Analysis Code <%1> for the Account Code <%2> - Analysis Code <%3> Combination
			End
		if @err_tmp = 8
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,606,@accountcode,@analysiscode
			return --Sub Analysis Code <%1> is in INActive status for the Account Code <%2>, Analysis Code <%3>
			End
		if @err_tmp = 9
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,607,@accountcode
			return --Analysis, Sub-Analysis Mapping Doesnot Exists for the Account code <%1>
			End
		if @err_tmp = 10
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,608,@accountcode
			return --Analysis, Sub-Analysis Mapping is in INActive Status for the Account code <%1>
			End
		if @err_tmp = 11
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,609,@accountcode,@analysiscode
			return --Invalid Accountcode <%1>, Analysiscode <%2> and Subanalysis code Mapping
			End
		if @err_tmp = 12
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,610,@accountcode,@analysiscode
			return --Accountcode <%1>, Analysiscode <%2> and Subanalysis Mapping is in INActive Status
			End
		if @err_tmp = 13
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,611,@accountcode
			return  --For the Account Code : <%1>, without entering Analysis Code, Sub Analysis Code was entered
			End
		if @err_tmp = 14
			Begin
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,612
			return -- SubAnalysis Code cannot be NULL for the Account and Analysis combination
			End
	end
	--end

	end
	----EPE-8702

	select @m_errorid = 0
	set nocount off
end









