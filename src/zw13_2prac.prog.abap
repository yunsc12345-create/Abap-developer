*&---------------------------------------------------------------------*
*& Report ZW13_2PRAC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW13_2PRAC.



TABLES: sbook, scarr, spfli.

TYPE-POOLS: slis.

*---------------------------------------------------------------------*
* Type
*---------------------------------------------------------------------*
TYPES: BEGIN OF t_result,
         carrid      TYPE sbook-carrid,
         connid      TYPE sbook-connid,
         carrname    TYPE scarr-carrname,
         cityfrom    TYPE spfli-cityfrom,
         cityto      TYPE spfli-cityto,
         luggweight  TYPE p LENGTH 6 DECIMALS 4,
         wunit       TYPE sbook-wunit,
         loccuram    TYPE sbook-loccuram,
         loccurkey   TYPE sbook-loccurkey,
       END OF t_result.

*---------------------------------------------------------------------*
* Data
*---------------------------------------------------------------------*
DATA: gt_result TYPE STANDARD TABLE OF t_result,
      gs_result TYPE t_result.

DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gs_layout   TYPE slis_layout_alv,
      gv_repid    TYPE sy-repid.

*---------------------------------------------------------------------*
* Selection Screen
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_carrid FOR sbook-carrid.
SELECTION-SCREEN END OF BLOCK part1.

*---------------------------------------------------------------------*
* Start-of-selection
*---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM data_retrieval.
  PERFORM build_fieldcatalog.
  PERFORM build_layout.
  PERFORM display_alv_report.

*---------------------------------------------------------------------*
* Form DATA_RETRIEVAL
*---------------------------------------------------------------------*
FORM data_retrieval.

  CLEAR gt_result.

  SELECT
    a~carrid,
    a~connid,
    b~carrname,
    c~cityfrom,
    c~cityto,
    SUM( a~luggweight ) AS luggweight,
    a~wunit,
    SUM( a~loccuram )   AS loccuram,
    a~loccurkey
    FROM sbook AS a
    LEFT OUTER JOIN scarr AS b
      ON a~carrid = b~carrid
    LEFT OUTER JOIN spfli AS c
      ON a~carrid = c~carrid
     AND a~connid = c~connid
    WHERE a~carrid IN @s_carrid
    GROUP BY
      a~carrid,
      a~connid,
      b~carrname,
      c~cityfrom,
      c~cityto,
      a~wunit,
      a~loccurkey
    INTO TABLE @gt_result.

ENDFORM.

*---------------------------------------------------------------------*
* Form BUILD_FIELDCATALOG
*---------------------------------------------------------------------*
FORM build_fieldcatalog.

  CLEAR gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CARRID'.
  gs_fieldcat-seltext_m = '항공사코드'.
  gs_fieldcat-col_pos   = 1.
  gs_fieldcat-outputlen = 10.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CONNID'.
  gs_fieldcat-seltext_m = '비행 번호'.
  gs_fieldcat-col_pos   = 2.
  gs_fieldcat-lzero     = 'X'.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CARRNAME'.
  gs_fieldcat-seltext_m = '항공사명'.
  gs_fieldcat-col_pos   = 3.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CITYFROM'.
  gs_fieldcat-seltext_m = '출발 도시'.
  gs_fieldcat-col_pos   = 4.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'CITYTO'.
  gs_fieldcat-seltext_m = '도착 도시'.
  gs_fieldcat-col_pos   = 5.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'LUGGWEIGHT'.
  gs_fieldcat-seltext_m = '수화물 무게 합계'.
  gs_fieldcat-col_pos   = 6.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'WUNIT'.
  gs_fieldcat-seltext_m = '무게단위'.
  gs_fieldcat-col_pos   = 7.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'LOCCURAM'.
  gs_fieldcat-seltext_m = '금액 합계'.
  gs_fieldcat-col_pos   = 8.
  APPEND gs_fieldcat TO gt_fieldcat.

  CLEAR gs_fieldcat.
  gs_fieldcat-fieldname = 'LOCCURKEY'.
  gs_fieldcat-seltext_m = '통화단위'.
  gs_fieldcat-col_pos   = 9.
  APPEND gs_fieldcat TO gt_fieldcat.

ENDFORM.

*---------------------------------------------------------------------*
* Form BUILD_LAYOUT
*---------------------------------------------------------------------*
FORM build_layout.

  gs_layout-no_input          = 'X'.
  gs_layout-colwidth_optimize = 'X'.
  gs_layout-zebra             = 'X'.

ENDFORM.

*---------------------------------------------------------------------*
* Form DISPLAY_ALV_REPORT
*---------------------------------------------------------------------*
FORM display_alv_report.

  gv_repid = sy-repid.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = gv_repid
      is_layout          = gs_layout
      it_fieldcat        = gt_fieldcat
      i_save             = 'X'
    TABLES
      t_outtab           = gt_result
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

ENDFORM.
