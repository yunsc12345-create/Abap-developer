*&---------------------------------------------------------------------*
*& Report ZTYPES_03_
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPES_03_.

TABLES:
  SCARR.

*TYPES : BEGIN OF SCARR,
*    CARRID    TYPE SCARR-CARRID,
*    CARRNAME  TYPE SCARR-CARRNAME,
*    CURRCODE  TYPE SCARR-CURRCODE,
*    URL       TYPE SCARR-URL,
*  END OF SCARR.

*DATA : SCARR TYPE SCARR.
"즉 DB 테이블 이름과 받을 공간의 이름이 같으면, 오래된 ABAP 문법에서는 INTO를 생략할 수 있어. 이거 좀 저질 문제같은데

SELECT SINGLE *
  from scarr
  WHERE CARRID = 'AA'.
" *를 사용하면 INTO 없이 사용이 가능함
WRITE: SCARR-CARRID, SCARR-CARRNAME, SCARR-CURRCODE, SCARR-URL.
