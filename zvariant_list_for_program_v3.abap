REPORT ZVARIANT_LIST_FOR_PROGRAM.
INCLUDE <icon>.
*---------------------------------------------------------------------*
* Major block start: Type definitions
*---------------------------------------------------------------------*

INCLUDE zvariant_list_scr.
INCLUDE zvariant_list_def.
INCLUDE zvariant_list_imp.
*---------------------------------------------------------------------*
* Major block end: Start of Selection
*---------------------------------------------------------------------*
START-OF-SELECTION.
  IF rad1 = abap_true.
    NEW lcl_app( )->run( ).
  ELSEIF rad2 = abap_true.
     NEW lcl_app( )->run_tvarvc( ).
  ENDIF.

