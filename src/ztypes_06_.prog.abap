*&---------------------------------------------------------------------*
*& Report ZTYPES_06_
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPES_06_.
TABLES : SFLIGHT, SCARR.
*- 이번 예제는 [ **TYPES** ]을 **선언한** 뒤 [ **Internal Table** ]을 선언해보자.
*    - 여기서 **사용되는 구문**은 [ **INCLUDE STRUCTURE** ] 이다.
*    - **화면**에 출력하는 **예제**이다.
*
*### # 참고해야 할 사항
*
*---
*
*- [ **SFLIGHT** ] or [ **SCARR** ] Table에서 **데이터를** 가져와보자.
*    - [ SFLIGHT ] → **전체 필드**, [ SCARR ] → **항공사 이름**
*
*- [ **TY_S_LIST** ]
*    - SFLIGHT
*    - CARRNAME TYPE SCARR-CARRNAME

* TYPES 정의 *
DATA : GT_SFLIGHT TYPE  SFLIGHT.

TYPES : BEGIN OF TY_S_LIST.
  INCLUDE STRUCTURE GT_SFLIGHT AS GSF.

TYPES : carrname type scarr-carrname,
       END OF TY_S_LIST.

DATA:  GT_LIST TYPE TABLE OF TY_S_LIST.



SELECT *
  FROM SCARR AS A
  INNER JOIN SFLIGHT AS B
  ON A~CARRID EQ B~CARRID
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
    T_TABLE = GT_LIST
).

COLUMNS = GR_SALV->GET_COLUMNS( ).
COLUMNS->SET_OPTIMIZE( ).

GR_SALV->DISPLAY( ).
*-------------------------------------*
