*&---------------------------------------------------------------------*
*& Report ZW8_HOMEWORK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW8_HOMEWORK.




TABLES:    SPFLI.


TYPE-POOLS: slis.                                 "ALV Declarations

*Data Declaration
*----------------
TYPES: BEGIN OF t_spfli,
  carrid   TYPE spfli-carrid,
  connid   TYPE spfli-connid,
  cityfrom TYPE spfli-cityfrom,
  cityto   TYPE spfli-cityto,
  fltime   TYPE spfli-fltime,
  distance TYPE spfli-distance,
  distid   TYPE spfli-distid,
  period   TYPE spfli-period,


   "Used to store row color attributes
 END OF t_spfli.

DATA: it_spfli TYPE STANDARD TABLE OF t_spfli INITIAL SIZE 0,
      wa_spfli TYPE t_spfli.

*ALV data declarations
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid.


*DATA : t TYPE slis_t_sp_group_alv .


SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.
SELECT-OPTIONS s_carrid FOR spfli-carrid  .
SELECT-OPTIONS s_connid FOR spfli-connid  .
SELECTION-SCREEN SKIP.
SELECT-OPTIONS s_cityf FOR spfli-cityfrom        .
SELECT-OPTIONS s_cityto FOR spfli-cityto     .
SELECTION-SCREEN SKIP.
SELECT-OPTIONS s_period FOR spfli-period     .

PARAMETERS NUM TYPE I.
*SELECTION-SCREEN SKIP.
*PARAMETERS NUM TYPE I DEFAULT 10.
*SELECT-OPTIONS s_carrn FOR scarr-carrname.
*SELECT-OPTIONS s_currcd FOR scarr-currcode .
*PARAMETERS p_carrid TYPE scarr-carrid OBLIGATORY DEFAULT 'AA'.
SELECTION-SCREEN END OF BLOCK part1.

FORM build_fieldcatalog.

  fieldcatalog-fieldname   = 'CARRID'.
  fieldcatalog-seltext_m   = 'Airline Code'.
  fieldcatalog-col_pos     = 0.
  fieldcatalog-outputlen   = 10.
  fieldcatalog-key         = 'X'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CONNID'.
  fieldcatalog-seltext_m   = 'Flight Connection Numbe'.
  fieldcatalog-col_pos     = 1.
  fieldcatalog-key         = 'X'.
  fieldcatalog-lzero       = 'X'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CITYFROM'.
  fieldcatalog-seltext_m   = 'Cityfrom'.
  fieldcatalog-col_pos     = 2.
  fieldcatalog-emphasize   = 'C511'.
  fieldcatalog-edit_mask   = '__________'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CITYTO'.
  fieldcatalog-seltext_m   = 'Cityto'.
  fieldcatalog-col_pos     = 3.
  fieldcatalog-emphasize   = 'C500'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'FLTIME'.
  fieldcatalog-seltext_m   = 'Fltime'.
  fieldcatalog-col_pos     = 4.
  fieldcatalog-edit_mask   = '__________'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'DISTANCE'.
  fieldcatalog-seltext_m   = 'Distance'.
  fieldcatalog-col_pos     = 5.
  fieldcatalog-decimals_out = 0.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'DISTID'.
  fieldcatalog-seltext_m   = 'Mass unit of distance (kms, miles)'.
  fieldcatalog-col_pos     = 6.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'PERIOD'.
  fieldcatalog-seltext_m   = 'Period'.
  fieldcatalog-col_pos     = 7.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

ENDFORM.                    " BUILD_FIELDCATALOG

**p_carrid = 'AA'.
*
**

*  s_carrid-SIGN   = 'I'.
*  s_carrid-OPTION   = 'BT'.
*  s_carrid-LOW     = 'AA'.
*  s_carrid-HIGH   = 'AZ'.
*  APPEND s_carrid TO s_carrid.
*  CLEAR  s_carrid.
*
*  s_carrid-SIGN   = 'I'.
*  s_carrid-OPTION   = 'EQ'.
*  s_carrid-LOW     = 'AB'.
**  s_carrid-HIGH   = 'AZ'.
*  APPEND s_carrid TO s_carrid.
*  CLEAR  s_carrid.
*
*  s_carrid-SIGN   = 'I'.
*  s_carrid-OPTION   = 'EQ'.
*  s_carrid-LOW     = 'AC'.
**  s_carrid-HIGH   = 'AZ'.
*  APPEND s_carrid TO s_carrid.
*  CLEAR  s_carrid.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_period-low.
* s_cname-low = 'American Airlines'.

  TYPES : BEGIN OF abc,
    period      type spfli-period,
  END of abc.

  DATA: IT_F4HELP3 TYPE TABLE OF abc.

  SELECT DISTINCT PERIOD FROM SPFLI
  INTO TABLE IT_F4HELP3.

    DATA: IT_RETURN_TAB TYPE ddshretval OCCURS 0 WITH HEADER LINE .

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD         = 'PERIOD'
      VALUE_ORG        = 'S'
      DYNPROFIELD      = 's_period-low'
      DYNPPROG         = SY-REPID
      DYNPNR           = SY-DYNNR
      CALLBACK_FORM    = 'CALL_BACK2'
      CALLBACK_PROGRAM = SY-REPID
    TABLES
      VALUE_TAB        = IT_F4HELP3
      RETURN_TAB       = IT_RETURN_TAB
    EXCEPTIONS
      PARAMETER_ERROR  = 1
      NO_VALUES_FOUND  = 2
      OTHERS           = 3.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_period-high.
*  s_cname-high = 'American Airlines'.


  TYPES : BEGIN OF abc,
    period  type spfli-period,
  END of abc.

  DATA: IT_F4HELP3 TYPE TABLE OF abc.

  SELECT DISTINCT PERIOD FROM SPFLI
  INTO TABLE IT_F4HELP3.

    DATA: IT_RETURN_TAB TYPE ddshretval OCCURS 0 WITH HEADER LINE .

    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      RETFIELD         = 'PERIOD'
      VALUE_ORG        = 'S'
      DYNPROFIELD      = 's_period-high'
      DYNPPROG         = SY-REPID
      DYNPNR           = SY-DYNNR
      CALLBACK_FORM    = 'CALL_BACK2'
      CALLBACK_PROGRAM = SY-REPID
    TABLES
      VALUE_TAB        = IT_F4HELP3
      RETURN_TAB       = IT_RETURN_TAB
    EXCEPTIONS
      PARAMETER_ERROR  = 1
      NO_VALUES_FOUND  = 2
      OTHERS           = 3.




*&---------------------------------------------------------------------*
*&      Form  call_back2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->RECORD_TAB   text
*      -->SHLP_TOP     text
*      -->CALLCONTROL  text
*----------------------------------------------------------------------*
FORM CALL_BACK2 TABLES RECORD_TAB STRUCTURE SEAHLPRES
               CHANGING SHLP_TOP TYPE SHLP_DESCR
                     CALLCONTROL LIKE DDSHF4CTRL.

  SHLP_TOP-INTDESCR-DIALOGTYPE = 'A'.   "A 100개 이상이면 다이알로그 조회, D 즉시조회,  C 다이알로그 조회

ENDFORM.                    "call_back

************************************************************************
*Start-of-selection.
START-OF-SELECTION.

*  PERFORM data_retrieval.
*  PERFORM build_fieldcatalog.
*  PERFORM build_layout.
*  PERFORM display_alv_report.
