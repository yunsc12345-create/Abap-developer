*&---------------------------------------------------------------------*
*& Report ZTYPES_07_
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPES_07_.
*### # 프로그램 예제
*
*---
*
*- 이번 예제는 [ **DATA: BEGIN OF …** ]을 통한 [ **Work area** ]을 **만드는 예제**이다.
*
*### # 참고해야 할 사항
*
*---
*
*- [ **GS_LIST** ]
*    - ID         TYPE I
*    - NAME(20)
*    - AGE     TYPE I


* DATA 선언 *
TYPES : BEGIN OF Gt_LIST,
  ID TYPE I,
  NAME TYPE C LENGTH 20,
  AGE TYPE I,
  END OF Gt_LIST.

DATA : GS_LIST TYPE GT_LIST.

GS_LIST-ID   = 1.
GS_LIST-NAME = '감자'.
GS_LIST-AGE  = 30.


WRITE: / 'ID:',   GS_LIST-ID,
       / 'Name:', GS_LIST-NAME,
       / 'Age:',  GS_LIST-AGE.
