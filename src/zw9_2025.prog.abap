*&---------------------------------------------------------------------*
*& Report ZW9_2025
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW9_2025.




TABLES:     scarr, spfli, sflight, sbook.

TYPE-POOLS: slis.                                 "ALV Declarations

*Data Declaration
*----------------
TYPES: BEGIN OF t_join,
  carrid   TYPE scarr-carrid,
  carrname TYPE scarr-carrname,
  connid   TYPE spfli-connid,
  cityfrom TYPE spfli-cityfrom,
  cityto   TYPE spfli-cityto,
  fldate   TYPE sflight-fldate,
  bookid   TYPE sbook-bookid,
 END OF t_join.

DATA: it_join TYPE STANDARD TABLE OF t_join,
      wa_join TYPE t_join.

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
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CARRNAME'.
  fieldcatalog-seltext_m   = '항공사 이름'.
  fieldcatalog-col_pos     = 1.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CONNID'.
  fieldcatalog-seltext_m   = '비행기 번호'.
  fieldcatalog-col_pos     = 2.
  fieldcatalog-lzero       = 'X'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CITYFROM'.
  fieldcatalog-seltext_m   = '출발 도시'.
  fieldcatalog-col_pos     = 3.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CITYTO'.
  fieldcatalog-seltext_m   = '도착 도시'.
  fieldcatalog-col_pos     = 4.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'FLDATE'.
  fieldcatalog-seltext_m   = '비행 일자'.
  fieldcatalog-col_pos     = 5.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'BOOKID'.
  fieldcatalog-seltext_m   = '예약 번호'.
  fieldcatalog-col_pos     = 6.
  fieldcatalog-lzero       = 'X'.
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
      t_outtab           = it_join
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

*SELECT c~carrid c~carrname p~connid p~cityfrom p~cityto
*  FROM scarr AS c
*  INNER JOIN spfli AS p
*  ON c~carrid = p~carrid
*  INTO TABLE it_join
*  WHERE c~carrid IN s_carrid.

*SELECT c~carrid c~carrname p~connid p~cityfrom p~cityto
*  FROM scarr AS c
*  LEFT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid
*  INTO TABLE it_join
*  WHERE c~carrid IN s_carrid.

*SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto
*  FROM scarr AS c
*  RIGHT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid
*  INTO TABLE @it_join
*  WHERE c~carrid IN @s_carrid.

*SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto
*  FROM scarr AS c
*  CROSS JOIN spfli AS p
*  WHERE c~carrid IN @s_carrid
*  INTO TABLE @it_join.

*SELECT c~carrid c~carrname p~connid p~cityfrom p~cityto f~fldate
*  FROM ( scarr AS c
*  INNER JOIN spfli AS p
*  ON c~carrid = p~carrid )
*  INNER JOIN sflight AS f
*  ON  p~carrid = f~carrid
*  AND p~connid = f~connid
*  INTO TABLE it_join
*  WHERE c~carrid IN s_carrid.

*SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto, f~fldate
*  FROM ( scarr AS c
*  LEFT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid )
*  LEFT OUTER JOIN sflight AS f
*  ON  p~carrid = f~carrid
*  AND p~connid = f~connid
*  INTO TABLE @it_join
*  WHERE c~carrid IN @s_carrid.

*SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto, f~fldate, b~bookid
*  FROM ( ( scarr AS c
*  INNER JOIN spfli AS p
*  ON c~carrid = p~carrid )
*  INNER JOIN sflight AS f
*  ON  p~carrid = f~carrid
*  AND p~connid = f~connid )
*  INNER JOIN sbook AS b
*  ON  f~carrid = b~carrid
*  AND f~connid = b~connid
*  AND f~fldate = b~fldate
*  INTO TABLE @it_join
*  WHERE c~carrid IN @s_carrid.
*
SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto, f~fldate, b~bookid
  FROM ( ( scarr AS c
  LEFT OUTER JOIN spfli AS p
  ON c~carrid = p~carrid )
  LEFT OUTER JOIN sflight AS f
  ON  p~carrid = f~carrid
  AND p~connid = f~connid )
  LEFT OUTER JOIN sbook AS b
  ON  f~carrid = b~carrid
  AND f~connid = b~connid
  AND f~fldate = b~fldate
  INTO TABLE @it_join
  WHERE c~carrid IN @s_carrid.

*
*  SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto
*  FROM scarr AS c
*  LEFT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid
*  INTO TABLE @it_join
*  WHERE c~carrid IN @s_carrid.

*
*  SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto, f~fldate
*  FROM ( scarr AS c
*  LEFT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid )
*  LEFT OUTER JOIN sflight AS f
*  ON p~carrid = f~carrid
*  and p~connid = f~connid
*  INTO TABLE @it_join
*  WHERE c~carrid IN @s_carrid.



ENDFORM.                    " DATA_RETRIEVAL
