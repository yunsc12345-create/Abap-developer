REPORT ZTYPES_01_.
*--------------------------------------------------------------------*
" Header Line

*--------------------------------------------------------------------

DATA:
  GT_LIST TYPE TABLE OF SCARR,
  GS_LIST TYPE SCARR,
  GT_TABLE TYPE TABLE OF SCARR WITH HEADER LINE.



SELECT *
  FROM SCARR
  INTO TABLE GT_TABLE.

*--------------------------------------------------------------------*
READ TABLE GT_TABLE INDEX 1 INTO GT_TABLE. " 첫번째 데이터를 읽어온다.

MOVE  GT_TABLE  TO GS_LIST. " wa TO wa
MOVE  GT_TABLE[]  TO GT_LIST. " Table TO Table   "헤더라인 사용시 []를 붙이면 테이블이다.
*--------------------------------------------------------------------*


*------------------------------------*
DATA:
  GR_SALV TYPE REF TO CL_SALV_TABLE.

DATA:
  COLUMNS TYPE REF TO CL_SALV_COLUMNS_TABLE.

CL_SALV_TABLE=>FACTORY(
  IMPORTING
    R_SALV_TABLE = GR_SALV
  CHANGING
    T_TABLE = GT_LIST[]
).

COLUMNS = GR_SALV->GET_COLUMNS( ).
COLUMNS->SET_OPTIMIZE( ).

GR_SALV->DISPLAY( ).
*-------------------------------------*


WRITE : GS_LIST-CARRID,
        GS_LIST-CARRNAME,
        GS_LIST-CURRCODE,
        GS_LIST-URL.
