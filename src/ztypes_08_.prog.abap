*&---------------------------------------------------------------------*
*& Report ZTYPES_08_
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPES_08_.

*### # 프로그램 예제
*
*---
*
*- 이번 예제는 [ **DATA: BEGIN OF …** ]을 통한 [ **Internal Table** ]을 **만드는 예제**이다.
*
*### # 참고해야 할 사항
*
*---
*
*- 이번엔 간단하게 [ **SCARR** ] Table을 **SELECT** 하는 예제이다.
*- 하지만, [ **DATA BEGIN OF..** ]을 **통해서만** **변수 선언**을 해야 한다.
*- 해당 로직을 **복사/붙여놓기** 해서 실행이 되게 만들어보자.

* DATA BEGIN OF 선언*


"개꿀인 방법
*TABLES : SCARR.
*DATA : t_scarr type scarr,
*       GT_LIST type TABLE OF scarr.


*

DATA: BEGIN OF W_LIST,
        MANDT    TYPE SCARR-MANDT,
        CARRID   TYPE SCARR-CARRID,
        CARRNAME TYPE SCARR-CARRNAME,
        CURRCODE TYPE SCARR-CURRCODE,
        URL      TYPE SCARR-URL,
      END OF W_LIST.

DATA : GT_LIST LIKE TABLE OF W_LIST.

SELECT *
  FROM SCARR
  INTO CORRESPONDING FIELDS OF TABLE GT_LIST.



*-------------------------------------*
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
