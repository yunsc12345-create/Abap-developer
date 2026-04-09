*&---------------------------------------------------------------------*
*& Report ZW13
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW13.







TABLES:     sbook, scarr, spfli.

TYPE-POOLS: slis.                                 "ALV Declarations

*Data Declaration
*----------------


"sbook만 담을 테이블과 행
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





"전체 다 담을 인터널테이블과 행
TYPES: BEGIN OF t_move,
  carrid     TYPE sbook-carrid,
  connid     TYPE sbook-connid,
  luggweight(6) TYPE P DECIMALS 4,
  wunit      TYPE sbook-wunit,
  loccuram   TYPE sbook-loccuram,
  loccurkey  TYPE sbook-loccurkey,
  carrname   TYPE scarr-carrname,
  cityfrom   TYPE spfli-cityfrom,
  cityto     TYPE spfli-cityto,
 END OF t_move.

DATA: it_move TYPE STANDARD TABLE OF  t_move,
      wa_move TYPE t_move.

*DATA: it_collect TYPE STANDARD TABLE OF t_move,
*      it_collect2 TYPE STANDARD TABLE OF t_move,
*      wa_collect TYPE t_move.




"scarr만 담을 테이블과 행
TYPES : BEGIN OF t_scarr,
  carrid   TYPE scarr-carrid,
  carrname TYPE scarr-carrname,
  END OF t_scarr.

DATA: it_scarr TYPE STANDARD TABLE OF  t_scarr,
      wa_scarr TYPE t_scarr.




" spfli만 담을 테이블과 행
TYPES: BEGIN OF t_spfli,
  carrid     TYPE spfli-carrid,
  connid     TYPE spfli-connid,
  cityfrom   TYPE spfli-cityfrom,
  cityto     TYPE spfli-cityto,
 END OF t_spfli.

DATA: it_spfli TYPE STANDARD TABLE OF  t_spfli,
      wa_spfli TYPE t_spfli.


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
      t_outtab           = it_move
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


LOOP AT it_sbook INTO wa_sbook.
  COLLECT wa_sbook INTO it_collect.  "move같은 애들로 테이블 데이터 전체 이동은 안되기 떄문에 LOOP를 써야함.
ENDLOOP.

*SELECT b_carrid, b_connid, luggweight, wunit, loccuram, loccurkey, carrname, cityfrom, cityto
*  FROM sbook AS b, scarr, spfli
*  INTO TABLE it_sbook
*  WHERE carrid IN s_carrid.

SELECT carrid carrname
  FROM scarr
  INTO TABLE it_scarr
  WHERE carrid IN s_carrid.

SELECT carrid connid cityfrom cityto
  FROM spfli
  INTO TABLE it_spfli
  WHERE carrid IN s_carrid.

   "MOVE는 통쨰로 옮기는 것, 필드와 행을 옮기는건 가능해도 테이블은 불가능
   "MOVE-CO..는 같은 필드 데이터만 이동, MOVE는

LOOP AT it_collect INTO wa_collect.
  MOVE-CORRESPONDING wa_collect TO wa_move.
  READ TABLE it_scarr INTO wa_scarr
  WITH KEY carrid = wa_move-carrid.
  IF sy-subrc = 0.
    wa_move-carrname = wa_scarr-carrname.  "MOVE wa_scarr-carrname TO wa_move-carrname. 와 같음.
      "구조가 완전히 같다면 A = B 로 써도 옮길 수 있음.
    READ TABLE it_spfli INTO wa_spfli
      WITH KEY carrid = wa_move-carrid
               connid = wa_move-connid.
      ENDIF.
  IF sy-subrc = 0.
      wa_move-cityfrom = wa_spfli-cityfrom.
      wa_move-cityto = wa_spfli-cityto.
ENDIF.
APPEND wa_move TO it_move.

ENDLOOP.




ENDFORM.                      " DATA_RETRIEVAL
