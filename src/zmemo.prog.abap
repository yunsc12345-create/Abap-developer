*&---------------------------------------------------------------------*
*& Report ZMEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMEMO.

TABLES : sflight .

*TYPES: BEGIN OF t_scarr,
*  carrid   TYPE scarr-carrid,
*  carrname  TYPE scarr-carrname,
* END OF t_scarr.
*
*
*
*DATA: it_scarr TYPE STANDARD TABLE OF t_scarr,
*      wa_scarr TYPE t_scarr.


SELECT COUNT( DISTINCT  carrid  )
   from sflight
   INTO @DATA(it_scarr).
