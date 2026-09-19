*&---------------------------------------------------------------------*
*& Report ZTYPES_04_
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPES_04_.

" TYPE 정의 "

*TYPES LV_CHAR10 TYPE CHAR10.
*TYPES LV_INT TYPE i.
*TYPES LV_DEC5_2 TYPE P LENGTH 5 DECIMALS 2.

TYPES : LV_CHAR10 TYPE CHAR10,
        LV_INT    TYPE i,
        LV_DEC5_2 TYPE p LENGTH 5 DECIMALS 2.
.

DATA:
  GV_CHAR10   TYPE LV_CHAR10,
  GV_INT      TYPE LV_INT,
  GV_DEC5_2   TYPE LV_DEC5_2.


GV_CHAR10 = '감자'.
GV_INT    = 12345.
GV_DEC5_2 = '12.34'.


WRITE: / GV_CHAR10, GV_INT, GV_DEC5_2.
