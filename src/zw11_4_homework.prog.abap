*&---------------------------------------------------------------------*
*& Report ZW11_4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW11_4_HOMEWORK.






TABLES:     SFLIGHT.


TYPES: BEGIN OF t_sflight,
  carrid     TYPE sflight-carrid,
  connid     TYPE sflight-connid,
  currency   TYPE sflight-currency,
  price      TYPE sflight-price,
  seatsmax   TYPE sflight-seatsmax,
 END OF t_sflight.

DATA: it_sflight TYPE STANDARD TABLE OF t_sflight INITIAL SIZE 0,
      wa_sflight TYPE t_sflight.
DATA: it_collect TYPE STANDARD TABLE OF t_sflight INITIAL SIZE 0.


*ALV data declarations
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid.


DATA : t TYPE slis_t_sp_group_alv .






SELECTION-SCREEN BEGIN OF BLOCK part2 WITH FRAME TITLE text-002.
SELECT-OPTIONS s_carrid FOR sflight-carrid.

SELECTION-SCREEN END OF BLOCK part2.










************************************************************************
*Start-of-selection.
START-OF-SELECTION.

  PERFORM data_retrieval.
  PERFORM build_fieldcatalog.
  PERFORM build_layout.
  PERFORM display_alv_report.


*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       Build Fieldcatalog for ALV Report
*----------------------------------------------------------------------*
FORM build_fieldcatalog.




  fieldcatalog-fieldname   = 'CARRID'.
  fieldcatalog-seltext_m   = 'Airline Code'.
  fieldcatalog-col_pos     = 0.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CONNID'.
  fieldcatalog-seltext_m   = 'Connection Number'.
  fieldcatalog-col_pos     = 1.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CURRENCY'.
  fieldcatalog-seltext_m   = 'Local currency of airline'.
  fieldcatalog-col_pos     = 2.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'PRICE'.
  fieldcatalog-seltext_m   = 'Airfare'.
  fieldcatalog-col_pos     = 3.
  fieldcatalog-hotspot     = 'X'.
  fieldcatalog-emphasize   = 'C310'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'SEATSMAX'.
  fieldcatalog-seltext_m   = 'Maximum capacity in economy class'.
  fieldcatalog-hotspot     = 'X'.
  fieldcatalog-emphasize   = 'c710'.
  fieldcatalog-col_pos     = 4.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.



ENDFORM.                    " BUILD_FIELDCATALOG


*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       Build layout for ALV grid report
*----------------------------------------------------------------------*
FORM build_layout.

  gd_layout-no_input          = 'X'.
  gd_layout-colwidth_optimize = 'X'.
  gd_layout-zebra = 'X'.


ENDFORM.                    " BUILD_LAYOUT


*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*       Display report using ALV grid
*----------------------------------------------------------------------*
FORM display_alv_report.
  gd_repid = sy-repid.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = gd_repid
      is_layout          = gd_layout
      it_fieldcat        = fieldcatalog[]
      i_save             = 'X'
    TABLES
      t_outtab           = it_collect
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.                    " DISPLAY_ALV_REPORT


*&---------------------------------------------------------------------*
*&      Form  DATA_RETRIEVAL
*&---------------------------------------------------------------------*
*       Retrieve data form EKPO table and populate itab it_ekko
*----------------------------------------------------------------------*
FORM data_retrieval.


SELECT CARRID CONNID CURRENCY PRICE SEATSMAX
    FROM sflight
  INtO table it_sflight
  WHERE carrid IN s_carrid.

LOOP AT it_sflight INTO wa_sflight.
  COLLECT wa_sflight into it_collect.
  ENDLOOP.



ENDFORM.                    " DATA_RETRIEVAL
