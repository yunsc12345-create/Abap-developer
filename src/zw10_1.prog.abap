*&---------------------------------------------------------------------*
*& Report ZW10_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW10_1.



TABLES:     scarr, spfli, sflight, sbook.

TYPE-POOLS: slis.                                 "ALV Declarations

*Data Declaration
*----------------
TYPES: BEGIN OF t_scarr,
  carrid   TYPE scarr-carrid,
  carrname TYPE scarr-carrname,
  connid   TYPE spfli-connid,
  cityfrom TYPE spfli-cityfrom,
  cityto   TYPE spfli-cityto,
  fldate   TYPE sflight-fldate,
  bookid   TYPE sbook-bookid,
 END OF t_scarr.

DATA: it_scarr TYPE STANDARD TABLE OF t_scarr,
      wa_scarr TYPE t_scarr.

*ALV data declarations
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid.


DATA : t TYPE slis_t_sp_group_alv .

SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.
SELECT-OPTIONS s_carrid   FOR scarr-carrid.
SELECTION-SCREEN END OF BLOCK part1.


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
  fieldcatalog-seltext_m   = '항공사 코드'.
  fieldcatalog-col_pos     = 0.
  fieldcatalog-outputlen   = 10.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CARRNAME'.
  fieldcatalog-seltext_m   = '항공사 이름'.
  fieldcatalog-col_pos     = 1.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CONNID'.
  fieldcatalog-seltext_m   = '항공기 번호'.
  fieldcatalog-col_pos     = 2.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CITYFROM'.
  fieldcatalog-seltext_m   = '출발지'.
  fieldcatalog-col_pos     = 3.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CITYTO'.
  fieldcatalog-seltext_m   = '도착지'.
  fieldcatalog-col_pos     = 4.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'FLDATE'.
  fieldcatalog-seltext_m   = '비행날짜'.
  fieldcatalog-col_pos     = 5.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'BOOKID'.
  fieldcatalog-seltext_m   = '예약코드'.
  fieldcatalog-col_pos     = 6.
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
*  gd_layout-info_fieldname =      'LINE_COLOR'.
*  gd_layout-def_status = 'A'.

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
      t_outtab           = it_scarr
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

*SELECT s~carrid s~carrname p~connid p~cityfrom p~cityto
*  from scarr AS s
*  INNER JOIN spfli AS p
*  ON s~carrid = p~carrid
*  INTO TABLE it_scarr
*  WHERE s~carrid IN s_carrid.
*
*SELECT s~carrid, s~carrname, p~connid, p~cityfrom, p~cityto
*  from scarr AS s
*  RIGHT OUTER JOIN spfli AS p
*  ON s~carrid = p~carrid
*  INTO TABLE @it_scarr
*  WHERE s~carrid IN @s_carrid.


*SELECT s~carrid, s~carrname, p~connid, p~cityfrom, p~cityto, f~fldate
*  from ( scarr AS s
*  iNNER JOIN spfli AS p
*  ON s~carrid = p~carrid )
*  INNER JOIN sflight AS f
*  ON p~carrid = f~carrid
*  AND p~connid = f~connid
*  INTO TABLE @it_scarr
*  WHERE s~carrid IN @s_carrid.

*
*SELECT s~carrid, s~carrname, p~connid, p~cityfrom, p~cityto, f~fldate, b~bookid
*  from ( ( scarr AS s
*  iNNER JOIN spfli AS p
*  ON s~carrid = p~carrid )
*  INNER JOIN sflight AS f
*  ON p~carrid = f~carrid
*  AND p~connid = f~connid )
*  INNER JOIN sbook AS b
*  ON f~connid = b~connid
*  AND f~carrid = b~carrid
*  AND f~fldate = b~fldate
*  INTO TABLE @it_scarr
*  WHERE s~carrid IN @s_carrid.
*
  SELECT s~carrid, s~carrname, p~connid, p~cityfrom, p~cityto, f~fldate, b~bookid
  from ( ( scarr AS s
  LEFT JOIN spfli AS p
  ON s~carrid = p~carrid )
  LEFT JOIN sflight AS f
  ON p~carrid = f~carrid
  AND p~connid = f~connid )
  LEFT JOIN sbook AS b
  ON f~connid = b~connid
  AND f~carrid = b~carrid
  AND f~fldate = b~fldate
  INTO TABLE @it_scarr
  WHERE s~carrid IN @s_carrid.



ENDFORM.                    " DATA_RETRIEVAL
