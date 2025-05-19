/*$File_version=ms4.3.0.01$*/
/********************************************************************************/
/* Procedure					: acap_wf_sp_auth_paramval						*/
/* Description					: 												*/  
/********************************************************************************/
/* Project						: 								 				*/
/* EcrNo						: 								 				*/
/* Version						: 								 				*/
/********************************************************************************/
/* Referenced					: 												*/
/* Tables						: 												*/
/********************************************************************************/
/* Development history			: 												*/
/********************************************************************************/
/* Author						: Nithya S										*/
/* Date							: Aug 11 2015  4:42PM							*/
/********************************************************************************/
/* Modification History			: 												*/
/********************************************************************************/
/* Modified By					: Nithya S						 				*/
/* Date							: 27/08/2015					 				*/
/* Description					: 14H109_ACAP_00065				 				*/
/*Srinivasan M              16/02/2023                    MHE-451*/
/********************************************************************************/

CREATE Procedure acap_wf_sp_auth_paramval
	@ctxt_ouinstance        	fin_ctxt_ouinstance,  
	@ctxt_user              	fin_ctxt_user,  
	@ctxt_language          	fin_ctxt_language,  
	@ctxt_service           	fin_ctxt_service, 
	@ctxt_role              	fin_ctxt_role,  
	@calling_service        	fin_ctxt_service, 
	@guid                   	fin_guid,  
	@Voucher_no					fin_documentno,
	@Voucher_ou					fin_ctxt_ouinstance,
	@cap_no						fin_documentno,
	@modeflag					fin_modeflag, /*I for Insert, D for Delete, V for Validate and VS Validate and suppress*/
	@m_errorid              	fin_int output, --To Return Execution Status
	@exec_flag					fin_flag = null output/*S = Success, F = Failure*/
as
Begin
	set nocount on
	
	Declare	@trantype				fin_text255
	
	select @exec_flag = 'S'

	if exists (	select  distinct voucher_number,ou_id
				from 	acap_journal_tmp  (nolock)
				where 	ou_id 		= @ctxt_ouinstance
				and 	guid 		= @guid	)
	begin
		select @trantype = 'ACAPJV'
	end
	else if exists (	select  distinct asset_number
						from 	acap_asset_tmp  (nolock)
						where 	guid 		= @guid	)
	begin
		select @trantype = 'ACAPASSET'
	END
	else if exists (	select  distinct asset_number
						from 	acap_asset_info_tmp  (nolock)
						where 	guid 		= @guid	)
	begin
		select @trantype = 'ACAPASSET'
	end
	
	if @trantype	=	'ACAPJV'
	begin
		if @modeflag = 'I'
		begin
			insert acap_journal_hdr_wf_backup
			(
			ou_id,				voucher_number,			timestamp,			transaction_date,		fb_id,
			num_type,			reversal_period,		journal_status,		remarks,				tran_amount,
			voucher_type,		tran_amount_befround,	tran_amount_diff,	createdby,				createddate,
			modifiedby,			modifieddate,			ref_voucher_no,		ref_voucher_type,		depr_book,
			workflow_status,	workflow_error	
			) 
			select 
			ou_id,				voucher_number,			timestamp,			transaction_date,		fb_id,
			num_type,			reversal_period,		journal_status,		remarks,				tran_amount,
			voucher_type,		tran_amount_befround,	tran_amount_diff,	createdby,				createddate,
			modifiedby,			modifieddate,			ref_voucher_no,		ref_voucher_type,		depr_book,
			workflow_status,	workflow_error
			from	acap_journal_hdr(nolock)
			where	ou_id		=       @Voucher_ou		
			and	voucher_number	=	@Voucher_no
			
			insert acap_journal_dtl_wf_backup
			(
			timestamp,			ou_id,					voucher_number,		asset_number,			tag_number,
			account_code,		drcr_flag,				tran_amount,		proposal_no,			remarks,
			cost_center,		analysis_code,			subanalysis_code,	createdby,				createddate,
			modifiedby,			modifieddate,			depr_book
			)
			select 
			timestamp,			ou_id,					voucher_number,		asset_number,			tag_number,
			account_code,		drcr_flag,				tran_amount,		proposal_no,			remarks,
			cost_center,		analysis_code,			subanalysis_code,	createdby,				createddate,
			modifiedby,			modifieddate,			depr_book
			from	acap_journal_dtl(nolock)
			where	ou_id		=       @Voucher_ou		
			and	voucher_number	=	@Voucher_no

			return
		end

		declare @param  fin_documentno
		
		select  @param = flag_yes_no
		from	PPS_FEATURE_LIST 
		where   feature_id     =  'WFBK_FID_0002'
		and	    component_name =  'ALL'

		if @modeflag in ('V','VS')
		begin
			if exists(	select 'X'
						from	acap_journal_hdr_wf_backup a(nolock),
								acap_journal_hdr b(nolock)
				where a.ou_id  						= @Voucher_ou
				and a.voucher_number				= @Voucher_no
				and a.ou_id  						= b.ou_id
				and a.voucher_number				= b.voucher_number
				and ( isnull(a.transaction_date,'') != isnull(b.transaction_date,'')
				or isnull(a.fb_id,'')  				!= isnull(b.fb_id,'')
				or isnull(a.num_type,'')  			!= isnull(b.num_type,'')
				or isnull(a.reversal_period,'')  	!= isnull(b.reversal_period,'')
				or isnull(a.remarks,'') 			!= isnull(b.remarks,'')
				or isnull(a.tran_amount,0)  		!= isnull(b.tran_amount,0)
				or isnull(a.voucher_type,'')  		!= isnull(b.voucher_type,'')
				or isnull(a.tran_amount_befround,0) != isnull(b.tran_amount_befround,0)
				or isnull(a.tran_amount_diff,0)  	!= isnull(b.tran_amount_diff,0)
				--or isnull(a.createdby,'')  			!= isnull(b.createdby,'')
				--or isnull(a.createddate,'')  		!= isnull(b.createddate,'')
				or isnull(a.ref_voucher_no,'')  	!= isnull(b.ref_voucher_no,'')
				or isnull(a.ref_voucher_type,'')  	!= isnull(b.ref_voucher_type,'')
				or isnull(a.depr_book,'')  			!= isnull(b.depr_book,'')
				))
			begin

				if @modeflag = 'VS'
				begin
					select @exec_flag = 'F'
					return
				end
				if isnull(@param,'NO') = 'YES'
					begin 
						update  acap_journal_hdr
						set		workflow_error = 'YES'
						where   voucher_number	   = @Voucher_no
						and		ou_id			   = @Voucher_ou
					end 
				else 
					begin 
						--'Document has moved to next level.Hence Cannot make modifications to the Document.'
						exec fin_german_raiserror_sp 'ACAP',@ctxt_language,4000
						return		
					end 
			end

			if (	select count('X')
					from	acap_journal_dtl_wf_backup(nolock)
					where	ou_id			=	@Voucher_ou
					and		voucher_number	=	@Voucher_no)! = (	select count('X')
											from acap_journal_dtl(nolock)
											where	ou_id		= @Voucher_ou
											and	voucher_number	= @Voucher_no)
			begin
				if @modeflag = 'VS'
				begin
					select @exec_flag = 'F'
					return
				end
				if isnull(@param,'NO') = 'YES'
					begin 
						update  acap_journal_hdr
						set		workflow_error = 'YES'
						where   voucher_number = @Voucher_no
						and		ou_id		   = @Voucher_ou
					end 
				else 
					begin 
				--'Document has moved to next level.Hence Cannot make modifications to the Document.'
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,4000
				return		
			end 
			end
			
			if exists(	select 'X'
					from	acap_journal_dtl_wf_backup a(nolock),
						acap_journal_dtl b(nolock)
				where a.ou_id  					= @Voucher_ou
				and a.voucher_number			= @Voucher_no
				and a.ou_id  					= b.ou_id
				and a.voucher_number			= b.voucher_number
				and	a.tag_number				= b.tag_number
				and (isnull(a.asset_number,'')  	!= isnull(b.asset_number,'')
				or isnull(a.tag_number,'')  		!= isnull(b.tag_number,'')
				or isnull(a.account_code,'') 		!= isnull(b.account_code,'')
				or isnull(a.drcr_flag,'')  	!= isnull(b.drcr_flag,'')
				or isnull(a.tran_amount,0)  	!= isnull(b.tran_amount,0)
				or isnull(a.proposal_no,'')  	!= isnull(b.proposal_no,'')
				or isnull(a.remarks,'')  	!= isnull(b.remarks,'')
				or isnull(a.cost_center,'')  != isnull(b.cost_center,'')
				or isnull(a.analysis_code,'')  != isnull(b.analysis_code,'')
				or isnull(a.subanalysis_code,'')  != isnull(b.subanalysis_code,'')
				or isnull(a.depr_book,'')  	!= isnull(b.depr_book,'')
				))
			begin
				if @modeflag = 'VS'
				begin
					select @exec_flag = 'F'
					return
				end
				if isnull(@param,'NO') = 'YES'
					begin 
						update  acap_journal_hdr
						set		workflow_error	= 'YES'
						where   voucher_number	= @Voucher_no
						and		ou_id			= @Voucher_ou
					end 
				else 
					begin 
				--'Document has moved to next level.Hence Cannot make modifications to the Document.'
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,4000
				return		
			end 
			end 	
			return
		end

		if @modeflag = 'D'	
		begin
			if exists(	select 'X'
					from	acap_journal_hdr_wf_backup (nolock)
					where	ou_id		= @Voucher_ou
					and	voucher_number	= @Voucher_no
				)
			begin
				delete
				from	acap_journal_hdr_wf_backup
				where	ou_id		= @Voucher_ou
				and	voucher_number	= @Voucher_no
			end

			if exists(	select 'X'
					from	acap_journal_dtl_wf_backup (nolock)
					where	ou_id		= @Voucher_ou
					and	voucher_number	= @Voucher_no
				)
			begin
				delete
				from	acap_journal_dtl_wf_backup
				where	ou_id		= @Voucher_ou
				and	voucher_number	= @Voucher_no
			end

			return
			
		END
	end
	else
	begin
	
	
		if @modeflag = 'I'
		begin
			insert acap_asset_hdr_wf_backup
			(
			ou_id,				cap_number,				asset_number,		timestamp,				cap_date,
			cap_status,			fb_id,					num_type,			asset_class,			asset_group,
			cost_center,		asset_desc,				asset_cost,			asset_location,			seq_no,
			as_on_date,			asset_type,				asset_status,		transaction_date,		account_code,
			asset_cost_befround,asset_cost_diff,		createdby,			createddate,			modifiedby,
			modifieddate,		remarks,				workflow_status		
			) 
			select 
			ou_id,				cap_number,				asset_number,		timestamp,				cap_date,
			cap_status,			fb_id,					num_type,			asset_class,			asset_group,
			cost_center,		asset_desc,				asset_cost,			asset_location,			seq_no,
			as_on_date,			asset_type,				asset_status,		transaction_date,		account_code,
			asset_cost_befround,asset_cost_diff,		createdby,			createddate,			modifiedby,
			modifieddate,		remarks,				workflow_status	
			from	acap_asset_hdr(nolock)
			where	ou_id		=   @Voucher_ou		
			and	asset_number	=	@Voucher_no
			and	cap_number		=	@cap_no
			
			insert acap_asset_tag_dtl_wf_backup--14H109_ACAP_00065
			(
			ou_id,				asset_number,			tag_number,			cap_number,				fb_id,
			timestamp,			asset_desc,				tag_desc,			asset_location,			cost_center,
			inservice_date,		tag_cost,				proposal_number,	tag_status,				depr_category,
			inv_cycle,			salvage_value,			manufacturer,		bar_code,				serial_no,
			warranty_no,		model,					custodian,			business_use,			reverse_remarks,
			book_value,			revalued_cost,			inv_date,			inv_due_date,			inv_status,
			softrev_run_no,		insurable_value,		policy_count,		dest_fbid,				transfer_date,
			legacy_asset_no,	migration_status,		tag_cost_orig,		tag_cost_diff,			createdby,
			createddate,		modifiedby,				modifieddate,		amend_status,			residualvalue,
			usefullifeinmonths			
			)
			select 
			ou_id,				asset_number,			tag_number,			cap_number,				fb_id,
			timestamp,			asset_desc,				tag_desc,			asset_location,			cost_center,
			inservice_date,		tag_cost,				proposal_number,	tag_status,				depr_category,
			inv_cycle,			salvage_value,			manufacturer,		bar_code,				serial_no,
			warranty_no,		model,					custodian,			business_use,			reverse_remarks,
			book_value,			revalued_cost,			inv_date,			inv_due_date,			inv_status,
			softrev_run_no,		insurable_value,		policy_count,		dest_fbid,				transfer_date,
			legacy_asset_no,	migration_status,		tag_cost_orig,		tag_cost_diff,			createdby,
			createddate,		modifiedby,				modifieddate,		amend_status,			residualvalue,
			usefullifeinmonths
			from	acap_asset_tag_dtl(nolock)--14H109_ACAP_00065
			where	ou_id		= @Voucher_ou		
			and	asset_number	=	@Voucher_no
			and	cap_number		=	@cap_no
			return
		end

		select  @param = flag_yes_no
		from	PPS_FEATURE_LIST 
		where   feature_id     =  'WFBK_FID_0002'
		and	    component_name =  'ALL'
		
		if @modeflag in ('V','VS')
		begin
			if exists(	select 'X'
						from	acap_asset_hdr_wf_backup a(nolock),
								acap_asset_hdr b(nolock)
				where a.ou_id  						= @Voucher_ou
				and a.asset_number					= @Voucher_no
				and	a.cap_number					= @cap_no
				and a.ou_id  						= b.ou_id
				and a.asset_number					= b.asset_number
				and	a.cap_number					= b.cap_number
				and ( isnull(a.fb_id,'')  				!= isnull(b.fb_id,'')
				or isnull(a.num_type,'')  			!= isnull(b.num_type,'')
				or isnull(a.cap_date,'')  			!= isnull(b.cap_date,'')
				or isnull(a.asset_class,'')  		!= isnull(b.asset_class,'')
				or isnull(a.asset_group,'')  		!= isnull(b.asset_group,'')
				or isnull(a.cost_center,'')			!= isnull(b.cost_center,'')
				or isnull(a.asset_desc,'')  		!= isnull(b.asset_desc,'')
				or isnull(a.asset_cost,-915)  		!= isnull(b.asset_cost,-915)
				or isnull(a.asset_location,'')  	!= isnull(b.asset_location,'')
				or isnull(a.seq_no,'')  			!= isnull(b.seq_no,'')
				or isnull(a.as_on_date,'')  		!= isnull(b.as_on_date,'')
				or isnull(a.asset_type,'')  		!= isnull(b.asset_type,'')
				or isnull(a.transaction_date,'')  	!= isnull(b.transaction_date,'')
				or isnull(a.account_code,'')  		!= isnull(b.account_code,'')
				or isnull(a.asset_cost_befround,-915) != isnull(b.asset_cost_befround,-915)
				or isnull(a.asset_cost_diff,-915)  	!= isnull(b.asset_cost_diff,-915)
				or isnull(a.remarks,'')  			!= isnull(b.remarks,'')
				))
			begin
				if @modeflag = 'VS'
				begin
					select @exec_flag = 'F'
					return
				end
				if isnull(@param,'NO') = 'YES'
				begin 
						update  acap_asset_hdr
						set		workflow_error = 'YES'
						where   asset_number	   = @Voucher_no
						and		ou_id			   = @Voucher_ou
				end 
				else 
				begin 
						--'Document has moved to next level.Hence Cannot make modifications to the Document.'
						exec fin_german_raiserror_sp 'ACAP',@ctxt_language,4000
						return		
					end 
			end

			if (	select count('X')
					from	acap_asset_tag_dtl_wf_backup(nolock)
					where	ou_id			=	@Voucher_ou
					and		asset_number	=	@Voucher_no
					and		cap_number		=	@cap_no
					)! = (	select count('X')
											from acap_asset_tag_dtl(nolock)--14H109_ACAP_00065
											where	ou_id			= @Voucher_ou
											and		cap_number		= @cap_no
											and		asset_number	= @Voucher_no)
			begin

				if @modeflag = 'VS'
				begin
					select @exec_flag = 'F'
					return
				end
				if isnull(@param,'NO') = 'YES'
					begin 
						update  acap_asset_hdr
						set		workflow_error = 'YES'
						where   asset_number = @Voucher_no
						and		cap_number	 = @cap_no
						and		ou_id		 = @Voucher_ou
					end 
				else 
					begin 
				--'Document has moved to next level.Hence Cannot make modifications to the Document.'
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,4000
				return		
			end 
			end

			if exists(	select 'X'--14H109_ACAP_00065
					from	acap_asset_tag_dtl_wf_backup a(nolock),
						acap_asset_tag_dtl b(nolock)
				where a.ou_id  						= @Voucher_ou
				and a.asset_number					= @Voucher_no
				and	a.cap_number					= @cap_no
				and a.ou_id  						= b.ou_id
				and a.asset_number					= b.asset_number
				and	a.tag_number					= b.tag_number
				and	a.cap_number					= b.cap_number
				and (isnull(a.fb_id,'')				!= isnull(b.fb_id,'')
				or isnull(a.asset_desc,'')  		!= isnull(b.asset_desc,'')
				or isnull(a.tag_desc,'') 			!= isnull(b.tag_desc,'')
				or isnull(a.asset_location,'')		!= isnull(b.asset_location,'')
				or isnull(a.inservice_date,'')		!= isnull(b.inservice_date,'')
				or isnull(a.tag_cost,-915)  			!= isnull(b.tag_cost,-915)
				or isnull(a.proposal_number,'')		!= isnull(b.proposal_number,'')
				or isnull(a.depr_category,'')		!= isnull(b.depr_category,'')
				or isnull(a.inv_cycle,'')			!= isnull(b.inv_cycle,'')
				or isnull(a.salvage_value,-915)  		!= isnull(b.salvage_value,-915)
				or isnull(a.manufacturer,'')  		!= isnull(b.manufacturer,'')
				or isnull(a.bar_code,'')  			!= isnull(b.bar_code,'')
				or isnull(a.warranty_no,'')			!= isnull(b.warranty_no,'')
				or isnull(a.model,'')				!= isnull(b.model,'')
				or isnull(a.custodian,'')			!= isnull(b.custodian,'')
				or isnull(a.business_use,-915)		!= isnull(b.business_use,-915)--code modified by MHE-451
				or isnull(a.reverse_remarks,'')		!= isnull(b.reverse_remarks,'')
				or isnull(a.book_value,-915)		!= isnull(b.book_value,-915)
				or isnull(a.inv_date,'')		!= isnull(b.inv_date,'')
				or isnull(a.inv_due_date,'')		!= isnull(b.inv_due_date,'')
				or isnull(a.softrev_run_no,'')		!= isnull(b.softrev_run_no,'')
				or isnull(a.insurable_value,-915)			!= isnull(b.insurable_value,-915)
				or isnull(a.policy_count,-915)			!= isnull(b.policy_count,-915)
				or isnull(a.dest_fbid,'')			!= isnull(b.dest_fbid,'')
				or isnull(a.transfer_date,'')			!= isnull(b.transfer_date,'')
				or isnull(a.legacy_asset_no,'')			!= isnull(b.legacy_asset_no,'')
				or isnull(a.migration_status,'')			!= isnull(b.migration_status,'')
				or isnull(a.tag_cost_orig,-915)			!= isnull(b.tag_cost_orig,-915)
				or isnull(a.tag_cost_diff,-915)			!= isnull(b.tag_cost_diff,-915)
				or isnull(a.revalued_cost,-915)			!= isnull(b.revalued_cost,-915)
				or isnull(a.policy_count,-915)			!= isnull(b.policy_count,-915)
				or isnull(a.residualvalue,-915)  		!= isnull(b.residualvalue,-915)
				or isnull(a.usefullifeinmonths,-915) != isnull(b.usefullifeinmonths,-915)
				))
			begin
				if @modeflag = 'VS'
				begin
					select @exec_flag = 'F'
					return
				end
				if isnull(@param,'NO') = 'YES'
					begin 
						update  acap_asset_hdr
						set		workflow_error	= 'YES'
						where   asset_number	= @Voucher_no
						and		ou_id			= @Voucher_ou
						and		cap_number		= @cap_no
					end 
				else 
					begin 
				--'Document has moved to next level.Hence Cannot make modifications to the Document.'
				exec fin_german_raiserror_sp 'ACAP',@ctxt_language,4000
				return		
			end 
			end 	
			return
		end

		if @modeflag = 'D'	
		begin
			if exists(	select 'X'
					from	acap_asset_hdr_wf_backup (nolock)
					where	ou_id		= @Voucher_ou
					and	asset_number	= @Voucher_no
					and	cap_number		= @cap_no
				)
			begin
				delete
				from	acap_asset_hdr_wf_backup
				where	ou_id		= @Voucher_ou
				and	asset_number	= @Voucher_no
				and	cap_number		= @cap_no
			end

			if exists(	select 'X'
					from	acap_asset_tag_dtl_wf_backup (nolock)--14H109_ACAP_00065
					where	ou_id		= @Voucher_ou
					and	asset_number	= @Voucher_no
					and	cap_number		= @cap_no
				)
			begin
				delete
				from	acap_asset_tag_dtl_wf_backup--14H109_ACAP_00065
				where	ou_id		= @Voucher_ou
				and	asset_number	= @Voucher_no
				and	cap_number		= @cap_no
			end

			return
			
		END
	
	end
  set nocount off	
End







