*&---------------------------------------------------------------------*
*& Report ZW13_1PRACTICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW13_1PRACTICE.

" 13주차 내용을 조인문을 통해서 만들어보려고 했으나 포기






TABLES:     sbook, scarr, spfli.

TYPE-POOLS: slis.                                 "ALV Declarations

*Data Declaration
*----------------
TYPES: BEGIN OF t_sbook,
  carrid     TYPE sbook-carrid,
  connid     TYPE sbook-connid,
*  luggweight TYPE sbook-luggweight,
  luggweight(6) TYPE P DECIMALS 4, "여기서 6은 바이트로 length가 11자리까지 늘어난것.
  wunit      TYPE sbook-wunit,
  loccuram   TYPE sbook-loccuram,
  loccurkey  TYPE sbook-loccurkey,
  carrname   TYPE scarr-carrname,
  cityfrom   TYPE spfli-cityfrom,
  cityto     TYPE spfli-cityto,
 END OF t_sbook.

*DATA: it_sbook TYPE STANDARD TABLE OF t_sbook,
DATA: it_sbook TYPE SORTED TABLE OF  t_sbook WITH NON-UNIQUE KEY carrid connid carrname cityfrom cityto,
      wa_sbook TYPE t_sbook.
DATA: it_collect TYPE STANDARD TABLE OF t_sbook,
      it_collect2 TYPE STANDARD TABLE OF t_sbook,
      wa_collect TYPE t_sbook.

*ALV data declarations
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid.


DATA : t TYPE slis_t_sp_group_alv .

SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.
SELECT-OPTIONS s_carrid   FOR sbook-carrid.
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
  fieldcatalog-seltext_m   = '항공사코드'.
  fieldcatalog-col_pos     = 0.
  fieldcatalog-outputlen   = 10.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CONNID'.
  fieldcatalog-seltext_m   = '비행 번호'.
  fieldcatalog-col_pos     = 1.
  fieldcatalog-lzero       = 'X'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'LUGGWEIGHT'.
  fieldcatalog-seltext_m   = '수화물 무게'.
  fieldcatalog-col_pos     = 2.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'WUNIT'.
  fieldcatalog-seltext_m   = '무게단위'.
  fieldcatalog-col_pos     = 3.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'LOCCURAM'.
  fieldcatalog-seltext_m   = '금액'.
  fieldcatalog-col_pos     = 4.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'LOCCURKEY'.
  fieldcatalog-seltext_m   = '통화단위'.
  fieldcatalog-col_pos     = 5.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CARRNAME'.
  fieldcatalog-seltext_m   = '항공사명'.
  fieldcatalog-col_pos     = 6.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CITYFROM'.
  fieldcatalog-seltext_m   = '출발 도시'.
  fieldcatalog-col_pos     = 7.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CITYTO'.
  fieldcatalog-seltext_m   = '도착 도시'.
  fieldcatalog-col_pos     = 8.
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

SELECT A~carrid, A~connid, A~luggweight, A~wunit, A~loccuram, A~loccurkey, B~carrname, C~cityto, C~cityfrom
  FROM ( ( sbook AS A LEFT OUTER JOIN scarr AS B
  ON A~carrid = B~carrid ) LEFT OUTER JOIN spfli AS C
  ON A~carrid = C~carrid AND A~connid = C~connid )
  INTO TABLE @it_sbook
  WHERE A~carrid IN @s_carrid.

*  SELECT  A~carrname, A~carrid, B~connid, B~cityfrom, B~cityto, F~fldate
*  FROM ( scarr AS A
*  INNER JOIN spfli AS B
*  ON A~carrid = B~carrid )
*  INNER JOIN sflight AS F
*  ON B~carrid = F~carrid
*  AND B~connid = F~connid
*



LOOP AT it_sbook INTO wa_sbook.
  AT END OF carrid.   "AT END OF 뒤에 있는 필드는 마스킹 처리되는것.
    SUM.
    APPEND wa_sbook TO it_collect2.
    ENDAT.
    AT END OF connid.
      SUM.
    APPEND wa_sbook TO it_collect.
   ENDAT.
  ENDLOOP.
ENDFORM.                    " DATA_RETRIEVAL
