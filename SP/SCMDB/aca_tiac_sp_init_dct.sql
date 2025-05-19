/*$File_version=ms4.3.0.05$*/
/*$$filename = aca_tiac_sp_init_dct.sql						*/  
/********************************************************************************/  
/* procedure    : aca_tiac_sp_init_dct                                           	*/  
/* description  :                                                               */  
/********************************************************************************/  
/* project      :                                                               */  
/* version      :4.0.0.027                                                      */  
/********************************************************************************/  
/* referenced   :                                                               */  
/* tables       :                                                               */  
/********************************************************************************/  
/* development history                                                          */  
/********************************************************************************/  
/* author       : C.Ramesh Kumar                                                */  
/* date         : 27/08/2012                                                  */  
/********************************************************************************/ 
/*C.Ramesh Kumar				20.09.2012						12H124_ACAP_00082*/ 
/*Indira G						21/09/2018						EBS-1882		 */
/* Abimathi M				    06/01/2021						EPE-25078  */
/* Divyalekaa				    29/03/2021						EPE-32065  */
/*Srinivasan                    24/01/2024                      TC-2440*/

-- execute on aca_tiac_sp_init_dct to public
CREATE procedure aca_tiac_sp_init_dct
	@ctxt_ouinstance 	ctxt_ouinstance, --input fv cBBBC VEEEEEEEEEEEE 
	@ctxt_user       	ctxt_user, --input 
	@ctxt_language   	ctxt_language, --input 
	@ctxt_service    	ctxt_service, --input 
	@m_errorid       	fin_int output --to return execution status
as
begin
	-- nocount should be switched on to prevent phantom rows
	set nocount on
	-- @m_errorid should be 0 to indicate success
	set @m_errorid = 0

	--declaration of temporary variables

		select 	parameter_text 'documenttype'
	    from   	fin_quick_code_met a(nolock),
	           	acap_cim_intxn_model_vw c(nolock),
	           	emod_ou_vw b(nolock)
	    where	a.component_id 	= 'ACAP'
	    and		a.parameter_type 	= 'CBO'
	    and		a.parameter_category 	= 'DOC_TYP'
		--and		a.parameter_code		not in ('IBE','PM_PV','PM_SCA','PM_SCI')--12H124_ACAP_00082
		and		a.parameter_code		not in ('IBE','PM_PV','PM_SCI')--code modified for EPE-25078
	    and		a.language_id 	= @ctxt_language
	    and		c.sourceouinstid 	= @ctxt_ouinstance
	    and		c.sourcecomponentname 	= 'ACAP'
	    and		b.ou_id 	= c.destinationouinstid
	    and		dbo.RES_Getdate(@ctxt_ouinstance) between b.effective_from and isnull(b.effective_to, dbo.RES_Getdate(@ctxt_ouinstance))
	    and		c.destinationcomponentname 	in ('SIN', 'SDIN', 'SCDN', 'SNP', 'SPY', 'FBP', 'STKISSUE','GR','JV')--'JV' code added by TC-2440 --EBS-1882  
	    and		c.destinationcomponentname 	= case a.parameter_code
	       		                           	       when 'PM_PI' then 'SIN'
	       		                           	       when 'PM_MI' then 'SIN' 
	       		                           	       when 'pm_ev' then 'SDIN'
	       		                           	       when 'pm_iv' then 'SDIN'
	       		                           	       when 'pm_spv' then 'SNP'
												   when 'pm_sca' then 'SCDN'--EPE-25078
	       		                           	       when 'inv_imis' then 'STKISSUE'
												    when 'PUR_GR' then 'GR' --EBS-1882  
													when 'BK_JV' then 'JV'--code added by TC-2440
	       		                           	  end
		/*Code added for EPE-32065 begins here*/
		union
		select 	parameter_text				'documenttype'
	    from   	fin_quick_code_met a(nolock)
	    where	a.component_id 			=	'ACAP'
	    and		a.parameter_type 		=	'CBO'
	    and		a.parameter_category 	=	'DOC_TYP'
		and		a.parameter_code		in ('CO')
	    and		a.language_id 			=	@ctxt_language
		/*Code added for EPE-32065 ends here*/
	    union
	    select 	parameter_text 'documenttype'
	    from   	fin_quick_code_met(nolock)
	    where	component_id 	= 'ACAP'
	    and		parameter_type 	= 'CBO'
	    and		parameter_category 	= 'COMMON'
	    and		language_id 	= @ctxt_language
--	    order by
--	           parameter_text

set nocount off

end












