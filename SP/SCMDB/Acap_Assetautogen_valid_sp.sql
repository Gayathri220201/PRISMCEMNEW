/*$File_version=MS4.3.0.03$*/
/*****************************************************************/
/* Procedure					: Acap_Assetautogen_valid_sp	 */
/* Description					: 								 */
/*****************************************************************/
/* Project						: BASE							 */
/* EcrNo						: 								 */
/* Version						: 								 */
/*****************************************************************/
/* Referenced					: 								 */
/* Tables						: 								 */
/*****************************************************************/
/* Development history			:								 */
/*****************************************************************/
/* Author						: Harithra Devi.G				 */
/* Date							: 25/10/2018					 */
/*****************************************************************/
/* Modification History			: 								 */
/* grant exec on Acap_Assetautogen_valid_sp to public			*/
/* Gokulamanikandan M		11/06/2019				EPE-14270	*/
/* Abhijith KP				01/08/2023				EPE-62647	*/
/*****************************************************************/
CREATE procedure Acap_Assetautogen_valid_sp
	@ctxt_ouinstance         	fin_ctxt_ouinstance, --Input 
	@ctxt_user               	fin_ctxt_user, --Input 
	@ctxt_language           	fin_ctxt_language, --Input 
	@ctxt_service            	fin_ctxt_service, --Input 
	@assetclasscode_ag       	fin_assetclass, --Input/Output
	@assetdesc_ag            	fin_desc40, --Input/Output
	@assetgroupcode_ag       	fin_group, --Input/Output
	@assetlocationcode_ag    	fin_Assetlocation, --Input/Output
	@assetno_ag              	fin_assetnumber, --Input/Output
	@businessuse_ag          	fin_percentage, --Input/Output
	@capitalizationamount    	fin_amount, --Input/Output
	@capitalizationdate_ag   	fin_date, --Input/Output
	@capitalizationno_ag     	fin_documentno, --Input/Output
	@costcenter_ag           	fin_costcenter, --Input/Output
	@custodian_ag            	fin_employeename, --Input/Output
	@depreciationcategory_ag 	fin_deprcategory, --Input/Output
	@inservicedate_ag        	fin_date, --Input/Output
	@residualvalue_ag        	fin_percentage, --Input/Output
	@salvagevalue_ag         	fin_amount, --Input/Output
	@status_                 	fin_status, --Input/Output
	@transactionno_          	fin_documentno, --Input/Output
	@transactiontype_        	fin_transactiontype, --Input/Output
	@usefullifeinmonths_ag   	fin_lineno, --Input/Output
	---epe-14270
	@AssetClassification			fin_desc255,
	@AssetCategory				fin_desc255,
	@AssetCluster					fin_desc255,
	---epe-14270
	@m_errorid               	fin_int output --To Return Execution Status
as
Begin
	set nocount on
	declare @fb_tmp			fin_financebookid,
			@status_tmp		fin_status,
			@m_errout_tmp	fin_lineno,
			@fycode1_tmp	fin_financeperiodrange,
			@fpcode1_tmp	fin_financeperiodrange,
			@company_code	fin_company,
			@today_tmp		fin_date,
	 		@csetou 		fin_ctxt_ouinstance,
			@alocou 		fin_ctxt_ouinstance,
			@ainfou 		fin_ctxt_ouinstance,
			@buid			fin_buid,
			@tran_status_tmp	fin_status,
			@capamount_tmp	fin_amount,
			@dramount_tmp	fin_amount,
			@cramount_tmp	fin_amount

	 select @m_errorid = 0
	 select @today_tmp	= dbo.RES_Getdate(@ctxt_ouinstance) 

	select 	@csetou 			=  destinationouinstid
	from 	fw_admin_view_comp_intxn_model  (nolock)
	where 	sourceouinstid 			= @ctxt_ouinstance
	and 	sourcecomponentname 		= 'ACAP'
	and 	destinationcomponentname 	= 'CSET'
	
	select 	@alocou 			=  destinationouinstid
	from 	fw_admin_view_comp_intxn_model  (nolock)
	where 	sourceouinstid 			= @ctxt_ouinstance
	and 	sourcecomponentname 		= 'ACAP'
	and 	destinationcomponentname 	= 'ALOC'

	select 	@ainfou 			=  destinationouinstid
	from 	fw_admin_view_comp_intxn_model  (nolock)
	where 	sourceouinstid 			= @ctxt_ouinstance
	and 	sourcecomponentname 		= 'ACAP'
	and 	destinationcomponentname 	= 'AINF'

	select  @buid	= bu_id
	from 	emod_lo_bu_ou_vw(nolock)
	where	ou_id	= @csetou

		select	@company_code	=	company_code
		from	emod_ou_vw (nolock)
		where	ou_id			=	@ctxt_ouinstance
		and		@today_tmp between effective_from and isnull(effective_to,@today_tmp)	

	--EPE-62647
   declare @pps_flag_cc    fin_flag
  
   select @pps_flag_cc = FLAG_YES_NO
   from pps_finance_feature_list with (nolock)
   where FEATURE_ID = 'PPS_CostCenter_FA'
   and company_code = @company_code

   if @pps_flag_cc is null
   BEGIN
       select @pps_flag_cc = FLAG_YES_NO
       from pps_finance_feature_list with (nolock)
       where FEATURE_ID = 'PPS_CostCenter_FA'
       and company_code IS NULL
   END
  --EPE-62647


	if @transactiontype_ = 'PM_IV'
	begin
		select @fb_tmp = fb_id ,
			   @tran_status_tmp = tran_status	
		from sdin_invoice_hdr(NOLOCK)
		where 	tran_ou		=	@ctxt_ouinstance
	    AND  	tran_type	=	@transactiontype_
	    AND  	tran_no		=	@transactionno_

		SELECT	@dramount_tmp	=	isnull(SUM(ISNULL(tran_amount, 0)),0)
		from sdin_ap_postings_dtl(NOLOCK)
		where 	tran_ou		 =	@ctxt_ouinstance
	    AND  	tran_type	 =	@transactiontype_
	    AND  	tran_no		 =	@transactionno_
		AND		account_type ='CWA'
		and		drcr_id		 = 'D'

		SELECT	@cramount_tmp	=	isnull(SUM(ISNULL(tran_amount, 0)),0)
		from sdin_ap_postings_dtl(NOLOCK)
		where 	tran_ou		 =	@ctxt_ouinstance
	    AND  	tran_type	 =	@transactiontype_
	    AND  	tran_no		 =	@transactionno_
		AND		account_type ='CWA'
		and		drcr_id		 = 'C'

		select @capamount_tmp = @dramount_tmp - @cramount_tmp
	end

	if @tran_status_tmp not in ('FSH','DFT') and @ctxt_service = 'ACAAssAutSSave_B'
	begin
		exec fin_german_raiserror_sp 'Acap',@ctxt_language,717
		select @m_errorid = 1
		return
	end

	--Enter Capitalisation date.
	if @capitalizationdate_ag is null
	begin
		exec fin_german_raiserror_sp 'Acap',@ctxt_language,700
		select @m_errorid = 1
		return
	end
		
	-- capitalization date can not be greater than sysdate	
	if @capitalizationdate_ag > @today_tmp
	begin
		exec fin_german_raiserror_sp 'Acap',@ctxt_language,701
		select @m_errorid = 1
		return
	end

-- to check for capitalization date
	if exists (select 'x' from 	acap_cim_intxn_model_vw c (nolock), 
					emod_ou_vw  b (nolock)
				where 	c.sourceouinstid 		= @ctxt_ouinstance
				and 	c.sourcecomponentname 	= 'ACAP'
				and 	b.ou_id 				= c.destinationouinstid
				and 	@today_tmp				between b.effective_from and isnull(b.effective_to,@today_tmp)
				and 	c.destinationcomponentname	= 'FCC')
	begin
		exec @m_errorid = fcc_sysact_spvaltrndate 	@ctxt_ouinstance , 
								'ACAP' , 
								@ctxt_user , 
								@fb_tmp , 
								@capitalizationdate_ag,
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
		
		select @m_errout_tmp =  case @m_errorid
					when 1 then 702
					when 2 then 703
					when 3 then 704
					when 4 then 3001
					when 6 then 3003
					when 7 then 3005
					when 0 then 0	
					end
		
		if @m_errout_tmp <> 0 
		begin
			exec fin_german_raiserror_sp 'Acap',@ctxt_language,@m_errout_tmp
			select @m_errorid = 1
			return
		end
	 end	
	 
	if exists (select 'X'
	from cps_processparam_sys (nolock)
	where	company_code		= @company_code
	and		ou_id				= @ctxt_ouinstance
	and		parameter_type		= 'FASYS'
	and		parameter_category	= 'AUTOMATICASSETID'
	and		parameter_code		= 'N') and @assetno_ag is null
	begin
			exec fin_german_raiserror_sp 'Acap',@ctxt_language,705
			select @m_errorid = 1
			return
	end
	 
	if @assetdesc_ag is null
	begin
			exec fin_german_raiserror_sp 'Acap',@ctxt_language,706
			select @m_errorid = 1
			return
	end
	--cost center validation
	if exists (select 'x' from emod_ou_vw  b (nolock)
			where b.ou_id 		= @csetou
			and @capitalizationdate_ag between b.effective_from and isnull(b.effective_to,@capitalizationdate_ag)
			)
	begin
		if  exists(select 'x' from ainf_asset_class_vw(nolock)
			where 	ou_id			= @ainfou
			and	dest_component		= 'ACAP'
			and	asset_class_code	=  @assetclasscode_ag
			and	depreciable			= 'Y'
			and	asset_class_status	= 'A')
		begin

		--EPE-62647
		  if @pps_flag_cc = 'YES' and @costcenter_ag is null
		  begin
			if  exists(	select  '*' 	  from      mac_acc_ce_cc_mapping mac with (nolock),  
														ard_asset_account_mst ard with (nolock)    
												where  	ard.account_code 	= mac.account_no  
												and  	ard.fb_id   		= @fb_tmp 
												and  	ard.asset_class  	= @assetclasscode_ag  
												and  	ard.asset_usage  	in  ('DEPREC', 'LOSREV','REVDEP','IMPLOSS') 
												and     mac.bu_id			= @buid)

					begin
				             exec fin_german_raiserror_sp 'ACAP',@ctxt_language,36
				             select @m_errorid = 1
				             return
					end


		    end
		--EPE-62647
		if (@pps_flag_cc = 'YES' and @costcenter_ag is not null) or  @pps_flag_cc = 'NO' --EPE-62647	
		begin
			if @costcenter_ag is null
			begin
				--Enter Cost Center
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,36
				select @m_errorid = 1
				return
			end

			if not exists(select 'x' from mac_cost_center_vw (nolock)
					where bu_id				= @buid
					and upper(ma_center_no) = upper(@costcenter_ag)
					and ma_status 			= 'A')
			begin	
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,601
				select @m_errorid = 1
				return
			end	
			
			if not exists(	select 'x' from mac_cost_center_vw (nolock)
							where	bu_id				= @buid
							and		upper(ma_center_no) = upper(@costcenter_ag)
							and		ma_status 			= 'A'
							and		ma_center_leaf		= 'D')
			begin	
				exec fin_german_raiserror_sp 'ADEPP',@ctxt_language,89
				select @m_errorid = 1
				return
			end	
			
			if not exists(	select  'x'  
							from  	mac_acc_ce_cc_mapping mac (nolock),  
									ard_asset_account_mst ard (nolock)    
							where  	ard.company_code  	= mac.company_code 
							and  	ard.account_code 	= mac.account_no  
							and  	ard.fb_id   		= @fb_tmp 
							and  	ard.asset_class  	= @assetclasscode_ag  
							and  	ard.asset_usage  	= 'DEPREC'  
							and  	upper(mac.center_no)= upper(@costcenter_ag)
						)  
			begin
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,1900027507,@costcenter_ag
				select @m_errorid = 1
				return
			end
		   end
		end
	end

	if @assetlocationcode_ag is null
	begin	
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,707
		select @m_errorid = 1
		return
	end	
	if @assetlocationcode_ag is not null
	begin	
		if exists (	select	'x' 
				from	emod_ou_vw  b (nolock)
				where	b.ou_id 	= @alocou
				and	@capitalizationdate_ag between b.effective_from 
					and isnull(b.effective_to,@capitalizationdate_ag))
		begin
	
			if  not exists (	select	'x' 
						from	aloc_location_vw (nolock)
						where	ou_id		= @alocou
						and	upper(loc_code)	= upper(@assetlocationcode_ag)
						and	loc_status	= 'A'
					)	
			begin
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,708
				select @m_errorid = 1
				return
			end
		end
	end	

	if @inservicedate_ag is null
	begin
		select @inservicedate_ag = @capitalizationdate_ag
	end
	else
	begin

	if @inservicedate_ag > @today_tmp
	begin
		exec fin_german_raiserror_sp 'Acap',@ctxt_language,709
		select @m_errorid = 1
		return
	end

	if exists (select 'x' from 	acap_cim_intxn_model_vw c (nolock), 
					emod_ou_vw  b (nolock)
				where 	c.sourceouinstid 		= @ctxt_ouinstance
				and 	c.sourcecomponentname 	= 'ACAP'
				and 	b.ou_id 				= c.destinationouinstid
				and 	@today_tmp				between b.effective_from and isnull(b.effective_to,@today_tmp)
				and 	c.destinationcomponentname	= 'FCC')
	begin
		exec @m_errorid = fcc_sysact_spvaltrndate 	@ctxt_ouinstance , 
								'ACAP' , 
								@ctxt_user , 
								@fb_tmp , 
								@inservicedate_ag,
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
		
		select @m_errout_tmp =  case @m_errorid
					when 1 then 710
					when 2 then 711
					when 3 then 712
					when 4 then 3001
					when 6 then 3003
					when 7 then 3005
					when 0 then 0	
					end
		
		if @m_errout_tmp <> 0 
		begin
			exec fin_german_raiserror_sp 'Acap',@ctxt_language,@m_errout_tmp
			select @m_errorid = 1
			return
		end
	 end	
	end

	if  isnull(@salvagevalue_ag,0) < 0 
	begin
		exec fin_german_raiserror_sp 'OPS',@ctxt_language,507
		select @m_errorid = 1
		return
	end

	if isnull(@salvagevalue_ag,0) >= @capamount_tmp
	begin
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,718
		select @m_errorid = 1
		return
	end	

	if  isnull(@residualvalue_ag,0) < 0 
	begin
		exec fin_german_raiserror_sp 'ACAP',@ctxt_language,713
		select @m_errorid = 1
		return
	end

	if @businessuse_ag > 100 or @businessuse_ag < 0
	begin                   
		--exec fin_sp_raise_error '','','','','ACAP',206 ,@m_errorid output
        exec fin_german_raiserror_sp 'ACAP',@ctxt_language,41
		select @m_errorid = 1
		return
	end

	if @depreciationcategory_ag is null
	begin                   
		--exec fin_sp_raise_error '','','','','ACAP',206 ,@m_errorid output
        exec fin_german_raiserror_sp 'ACAP',@ctxt_language,3007
		select @m_errorid = 1
		return
	end

	---epe-14270
	if  ( (isnull(@AssetClassification,'') <> '') and (isnull(@AssetCategory,'') <> '')	and (isnull(@AssetCluster,'') <> '') )
	begin

		if not exists (	select  'x'  
			from  adep_entity_depcat_map (nolock)
			where asset_class = @assetclasscode_ag
			and	Asset_Classification = @assetclassification
			and	Asset_Category = @assetcategory
			and	Asset_Cluster = @AssetCluster
			and	Depreci_Category = @depreciationcategory_ag
			and	isnull(eff_to_date,@capitalizationdate_ag) >= @capitalizationdate_ag
			and   ou_id  =	@ctxt_ouinstance )
		begin
			--Mapping Not available / Not effective for the Asset Class Code "%d", Asset Classification "%d", Asset Category "%d", Asset Cluster "%d" and Depreciation Category "%d"
			exec fin_german_raiserror_sp 'ACAP',@ctxt_language,250,@assetclasscode_ag,@assetclassification,@assetcategory,@AssetCluster
			select @m_errorid = 1
			return
		end

	end
	---epe-14270
		
	Set nocount off
End







