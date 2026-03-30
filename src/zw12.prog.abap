*&---------------------------------------------------------------------*
*& Report ZW12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW12.





TABLES:     sbook.

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
 END OF t_sbook.

*DATA: it_sbook TYPE STANDARD TABLE OF t_sbook,
DATA: it_sbook TYPE SORTED TABLE OF  t_sbook WITH NON-UNIQUE KEY carrid connid,
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

SELECT carrid connid luggweight wunit loccuram loccurkey
  FROM sbook
  INTO TABLE it_sbook
  WHERE carrid IN s_carrid.
*  ORDER BY carrid connid.

*SORT it_sbook BY carrid connid. "BY 뒤에는 Key 값이 있어야 함. se11에서 볼수있음
*SORT it_sbook BY carrid connid ASCENDING connid DESCENDING.

"ASCENDING은 생략 가능하며 순서대로 라는 뜻, DESCENDING은 반대로.

"SORTED TABLE 정렬이 자동으로 되는 테이블이고 키가 있어야 한다, 정렬하는 기준 5%, STANDARD TABLE95%,
" HASHED TABLE 이건 튜닝할때 많이 씀.
"

*LOOP AT it_sbook INTO wa_sbook.
*  COLLECT wa_sbook INTO it_collect.
*ENDLOOP.

*LOOP AT it_sbook INTO wa_sbook.
*  AT END OF connid.
*    SUM.
*    APPEND wa_sbook TO it_collect.
*   ENDAT.
*  ENDLOOP.
*AT END OF는 connid가 바뀌기 전까지 갔다가 멈추는 것이기 떄문에 정렬이 안되어 있다면 붙어있는 애들끼리만 집계됨.
"SUM은 COLLECT보다 빠르게 집계할수 있으나 sql의 SUM이 아님 이게 콜렉트보다 훨씬 빠름. 그러나 무조건 정렬을 해야함.

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
" 동시집계할때 필드순서를 꼭 차례대로 써야 함.!!!!!!!!!!
ENDFORM.                    " DATA_RETRIEVAL
