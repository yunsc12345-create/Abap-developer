*&---------------------------------------------------------------------*
*& Report ZTYPES_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPES_02.

TABLES:
  SCARR.

TYPES : BEGIN OF T_SCARR,
  carrid TYPE scarr-carrid ,
  carrname TYPE scarr-carrname,
  currcode TYPE scarr-currcode,
  url TYPE scarr-url,
 END OF T_scarr.

DATA : GT_SCARR TYPE TABLE OF T_SCARR,
       GS_SCARR TYPE T_SCARR.

GS_SCARR = VALUE #( carrid = 'GJ'  carrname = 'GAMJA'
currcode = 'KRW' URL = 'https://potato98.tistory.com/ '

).


*GS_SCARR-CARRID   = 'GJ'.
*GS_SCARR-CARRNAME = 'GAMJA'.
*GS_SCARR-CURRCODE = 'KRW'.
*GS_SCARR-URL      = 'https://potato98.tistory.com/'.


*GT_SCARR = VALUE #(
*  ( CARRID   = 'GJ'
*    CARRNAME = 'GAMJA'
*    CURRCODE = 'KRW'
*    URL      = 'https://potato98.tistory.com/' )
*). 같은 방식으로 테이블에 넣는 것도 가능.

WRITE: Gs_SCARR-CARRID, Gs_SCARR-CARRNAME, Gs_SCARR-CURRCODE, Gs_SCARR-URL.
