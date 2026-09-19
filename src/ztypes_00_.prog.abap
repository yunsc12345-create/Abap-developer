*&---------------------------------------------------------------------*
*& Report ZTYPES_00_
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTYPES_00_.

*--------------------------------------------------------------------*
*  Header Line으로 변경 해야하는 부분
*--------------------------------------------------------------------*

DATA:
  GS_TABLE TYPE TABLE OF SCARR WITH HEADER LINE.

GS_TABLE-CARRID = 'AA'.
GS_TABLE-CARRNAME = 'American Airlines'.
GS_TABLE-CURRCODE = 'USD'.
GS_TABLE-URL = 'http://www.aa.com'.
APPEND GS_TABLE TO GS_TABLE.

GS_TABLE-CARRID = 'AC'.
GS_TABLE-CARRNAME = 'Air Canada'.
GS_TABLE-CURRCODE = 'CAD'.
GS_TABLE-URL = 'http://www.aircanada.ca'.
APPEND GS_TABLE TO GS_TABLE.

LOOP AT GS_TABLE INTO GS_TABLE.
  WRITE :GS_TABLE-CARRID,
         GS_TABLE-CARRNAME,
         GS_TABLE-CURRCODE,
         GS_TABLE-URL.
ENDLOOP.


*--------------------------------------------------------------------*
