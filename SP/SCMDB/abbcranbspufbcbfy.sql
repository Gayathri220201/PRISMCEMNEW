/*$File_version=ms4.3.0.02$*/
/************************************************************************************
 procedure name and id   abbcranbspufbcbfy
 description             Financial Year Combo Initialize SP for on enter FB in Create Analysis Budget
 name of the author      SATHISH P S
 date created            18-Mar-2002
 query file name         abbcranbspufbcbfy.sql
 modifications history
 modified by
 modified date
 modified purpose
procedure abbcranbspufbcbfy
grant all on abbcranbspufbcbfy to public
/*Srinivasan M     03/11/2023    TVIE-447*/
************************************************************************************/
create procedure abbcranbspufbcbfy
     @ctxt_language                     fin_ctxt_language,
     @ctxt_ouinstance                   fin_ctxt_ouinstance,
     @ctxt_service                      fin_ctxt_service,
     @ctxt_user                         fin_ctxt_user,
     @fb                                fin_financebookid,
     @guid                              fin_guid,
     @hidden_control1                   fin_hiddencontrol,
     @hidden_control2                   fin_hiddencontrol,
     @m_errorid                         int output --to return execution status
as
begin

    set nocount on

--BEGIN of Standard code for getting precision type
    declare  @pqty_tmp                  fin_int ,
             @pamt_tmp                  fin_int ,
             @prate_tmp                 fin_int ,
             @perate_tmp                fin_int ,
             @phigh_tmp                 fin_int ,
             @pmed_tmp                  fin_int ,
             @plow_tmp                  fin_int

    exec fin_sp_precisiontype_rtr @pqty_tmp output, @pamt_tmp output,
             @prate_tmp output, @perate_tmp output, @phigh_tmp output,
             @pmed_tmp output, @plow_tmp output

--END of Standard code for getting precision type

	declare	@iudmodeflag			nvarchar(2),
			@csdateformat_out_tmp  	fin_csdtfmt,
   			@companycode_tmp 		fin_companycode

     -- nocount should be switched on to prevent phantom rows
     set nocount on
     -- @m_errorid should be 0 to indicate success
     select @m_errorid =0

     select @ctxt_service     = ltrim(rtrim(@ctxt_service))
     select @ctxt_user        = ltrim(rtrim(@ctxt_user))
     select @fb               = ltrim(rtrim(@fb))
     select @guid             = ltrim(rtrim(@guid))
     select @hidden_control1  = ltrim(rtrim(@hidden_control1))
     select @hidden_control2  = ltrim(rtrim(@hidden_control2))

     if @ctxt_language    = -915              select @ctxt_language    = null
     if @ctxt_ouinstance  = -915              select @ctxt_ouinstance  = null
     if @ctxt_service     = '~#~'             select @ctxt_service     = null
     if @ctxt_user        = '~#~'             select @ctxt_user        = null
     if @fb               = '~#~'             select @fb               = null
     if @guid             = '~#~'             select @guid             = null
     if @hidden_control1  = '~#~'             select @hidden_control1  = null
     if @hidden_control2  = '~#~'             select @hidden_control2  = null

	exec emod_sysact_spgetdatefmt	@ctxt_ouinstance,
							@ctxt_user ,
							@csdateformat_out_tmp output ,
							'CMB'


	--to get the companycode 	
	select 	@companycode_tmp	= company_code
	from 	emod_ou_vw (nolock)
	where	ou_id			= @ctxt_ouinstance

	-- check for existance of company
	if not exists	(select 	'1'
				from		fcc_sysact_allyears_vw (nolock)
				where 	company_code    	=	@companycode_tmp
				and		fb_id			=	@fb
				and		close_status		=	'O')
	begin
		exec fin_sp_raise_error @companycode_tmp,'','','','ABB',75,@m_errorid output
		return
	end
	/*code added by RTVIE-447*/
	if @ctxt_service in('abbvanbsrufb','abbvanbsrini')
	begin 
	select distinct 'FINANCIALYEARRANGE' = rtrim(dbo.fin_dateinuserformat( fin_year_stdt ,@csdateformat_out_tmp  )) + ' - ' +rtrim(dbo.fin_dateinuserformat( fin_year_enddt , @csdateformat_out_tmp  ))
	from 	fcc_sysact_allyears_vw (nolock)
	where 	company_code	=	@companycode_tmp
	and		fb_id			=	@fb
	end
	else
		/*code added by RTVIE-447*/
	-- populating combo with financial year range
	select distinct 'FINANCIALYEARRANGE' = rtrim(dbo.fin_dateinuserformat( fin_year_stdt ,@csdateformat_out_tmp  )) + ' - ' +rtrim(dbo.fin_dateinuserformat( fin_year_enddt , @csdateformat_out_tmp  ))
	from 	fcc_sysact_allyears_vw (nolock)
	where 	company_code		=	@companycode_tmp
	and		fb_id			=	@fb
	and		close_status		=	'O'


     set nocount off

end





