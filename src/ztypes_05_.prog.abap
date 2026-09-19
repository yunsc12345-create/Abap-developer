*&---------------------------------------------------------------------*
*& Report ZTYPE_05_
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPES_05_.

* TYPES BEGIN OF *

TYPES : BEGIN OF GTA,
  ID TYPE I,
  NAME TYPE C LENGTH 20,
  END OF GTA.


*- ID TYPE I
*- NAME(20)


DATA:
  GS_EMP TYPE GTA.

GS_EMP-ID = 1.
GS_EMP-NAME = '감자'.


WRITE: / 'ID:',   GS_EMP-ID,
       / 'Name:' ,GS_EMP-NAME.
