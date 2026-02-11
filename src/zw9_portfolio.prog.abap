*&---------------------------------------------------------------------*
*& Report ZW9_PORTFOLIO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW9_PORTFOLIO.



TABLES:     SBOOK.

TYPE-POOLS: slis, VRM.                                 "ALV Declarations


DATA: LT_DROPLIST TYPE VRM_VALUES.


TYPES: BEGIN OF t_sbook,
  carrid     TYPE sbook-carrid,
  connid     TYPE sbook-connid,
  fldate     TYPE sbook-fldate,
  bookid     TYPE sbook-bookid,
  customid   TYPE sbook-customid,
  loccuram   TYPE sbook-loccuram,
  loccurkey  TYPE sbook-loccurkey,
  order_date TYPE sbook-order_date,
    cancelled  TYPE sbook-cancelled,
  line_color(4) TYPE c,     "Used to store row color attributes
 END OF t_sbook.

DATA: it_sbook TYPE STANDARD TABLE OF t_sbook INITIAL SIZE 0,
      wa_sbook TYPE t_sbook.

*ALV data declarations
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid.


DATA : t TYPE slis_t_sp_group_alv .




SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.
PARAMETERS s_carrid TYPE sbook-carrid AS LISTBOX VISIBLE LENGTH  20 DEFAULT 'AA' OBLIGATORY .
PARAMETERS s_connid TYPE sbook-connid AS LISTBOX VISIBLE LENGTH 20 DEFAULT '0017' OBLIGATORY .
PARAMETERS s_fldate TYPE sbook-fldate DEFAULT '20171219' OBLIGATORY.
SELECTION-SCREEN END OF BLOCK part1.

SELECTION-SCREEN BEGIN OF BLOCK part2 WITH FRAME TITLE text-002.
SELECT-OPTIONS s_cid   FOR sbook-customid.

PARAMETERS: r1 RADIOBUTTON GROUP rad1,
            r2 RADIOBUTTON GROUP rad1 DEFAULT 'X',
            r3 RADIOBUTTON GROUP rad1.
SELECTION-SCREEN END OF BLOCK part2.



AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_carrid.

REFRESH LT_DROPLIST.

SELECT
  CARRID AS KEY,
  CARRID && ' ' && LOCCURKEY AS TEXT
  FROM SBOOK
  INTO TABLE @LT_DROPLIST.

SORT LT_DROPLIST BY KEY TEXT.

DELETE ADJACENT DUPLICATES FROM LT_DROPLIST.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = 's_carrid'
      values                = LT_DROPLIST.
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS                = 2
*            .
  IF sy-subrc = 0.
* Implement suitable error handling here
  ENDIF.




AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_connid.

REFRESH LT_DROPLIST.

*SELECT
*  PERIOD AS KEY,
*  PERIOD AS TEXT
*  FROM SPFLI
*  INTO TABLE @LT_DROPLIST.  LT_DROPLIST는 문자열만 들어갈수있음 PERIOD는 숫자, 그래서 아래 문자열로 변환한것.
*  CAST( PERIOD AS CHAR ) AS KEY,
*  CAST( PERIOD AS CHAR ) AS TEXT
SELECT
  CONNID AS KEY,
  CONNID AS TEXT
  FROM SBOOK
  INTO TABLE @LT_DROPLIST.


SORT LT_DROPLIST BY KEY TEXT.

DELETE ADJACENT DUPLICATES FROM LT_DROPLIST.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id                    = 'p_connid'
      values                = LT_DROPLIST.
*   EXCEPTIONS
*     ID_ILLEGAL_NAME       = 1
*     OTHERS                = 2
*            .
  IF sy-subrc = 0.
* Implement suitable error handling here
  ENDIF.





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
  fieldcatalog-key         = 'X'.
  fieldcatalog-emphasize   = 'C111'.
  fieldcatalog-outputlen   = 10.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CONNID'.
  fieldcatalog-seltext_m   = 'Connection Number'.
  fieldcatalog-col_pos     = 1.
  fieldcatalog-key         = 'X'.
  fieldcatalog-emphasize   = 'C111'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'FLDATE'.
  fieldcatalog-seltext_m   = 'Flight Date'.
  fieldcatalog-col_pos     = 2.
  fieldcatalog-key         = 'X'.
  fieldcatalog-emphasize   = 'C111'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'BOOKID'.
  fieldcatalog-seltext_m   = 'Booking Number'.
  fieldcatalog-col_pos     = 3.
  fieldcatalog-key         = 'X'.
  fieldcatalog-emphasize   = 'C111'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.


  fieldcatalog-fieldname   = 'CUSTOMID'.
  fieldcatalog-seltext_m   = 'Customer Number'.
  fieldcatalog-col_pos     = 4.
  fieldcatalog-hotspot     = 'X'.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'LOCCURAM'.
  fieldcatalog-seltext_m   = 'Price of booking in local currency of airline'.
  fieldcatalog-col_pos     = 5.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'LOCCURKEY'.
  fieldcatalog-seltext_m   = 'Local currency of airline'.
  fieldcatalog-col_pos     = 6.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'ORDER_DATE'.
  fieldcatalog-seltext_m   = 'Booking Date'.
  fieldcatalog-col_pos     = 7.
  APPEND fieldcatalog TO fieldcatalog.
  CLEAR  fieldcatalog.

  fieldcatalog-fieldname   = 'CANCELLED'.
  fieldcatalog-seltext_m   = 'Cancelation flag'.
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
      t_outtab           = it_sbook
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




  DATA: ld_color(1) TYPE c.
  IF R1 = 'X'.
  SELECT carrid connid fldate bookid customid loccuram loccurkey order_date cancelled
    FROM sbook
    INTO TABLE it_sbook
    WHERE carrid = s_carrid
      AND connid  = s_connid
      AND fldate  = s_fldate
*      AND bookid = s_bookid
      AND customid IN s_cid.
*      AND loccur = s_loccuram
*      AND loccuk = s_loccurkey
**      AND order_ = s_order_date
*      AND cancel = s_cancelled.


  ELSEIF R2 = 'X'.
    SELECT carrid connid fldate bookid customid loccuram loccurkey order_date cancelled
    FROM sbook
    INTO TABLE it_sbook
    WHERE  carrid = s_carrid
      AND connid  = s_connid
      AND fldate  = s_fldate
*      AND bookid = s_bookid
      AND customid IN s_cid
*      AND loccur = s_loccuram
*      AND loccur = s_loccurkey
*      AND order_ = s_order_date
      AND cancelled <> 'X'.

   ELSEIF R3 = 'X'.
    SELECT carrid connid fldate bookid customid loccuram loccurkey order_date cancelled
    FROM sbook
    INTO TABLE it_sbook
    WHERE  carrid = s_carrid
      AND connid  = s_connid
      AND fldate  = s_fldate
*      AND bookid = s_bookid
      AND customid IN s_cid
*      AND loccur = s_loccuram
*      AND loccur = s_loccurkey
*      AND order_ = s_order_date
      AND cancelled = 'X'.

      ENDIF.

ENDFORM.                    " DATA_RETRIEVAL
