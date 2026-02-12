*&---------------------------------------------------------------------*
*& Report ZW9_JOIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW9_JOIN.


TYPES: BEGIN OF wa,
  carrid    TYPE scarr-carrid,
  carrname  TYPE scarr-carrname,
  connid    TYPE spfli-connid,
  cityfrom  TYPE spfli-cityfrom,
  cityto    TYPE spfli-cityto,
       END OF wa.

DATA  itab TYPE TABLE OF wa.

*SELECT A~carrid A~carrname B~connid B~cityfrom B~cityto
*  FROM scarr AS A
*  INNER JOIN spfli AS B
*  ON A~carrid = B~carrid
*  INTO TABLE itab.


*SELECT A~carrid A~carrname B~connid B~cityfrom B~cityto
*  FROM scarr AS A
*  LEFT OUTER JOIN spfli AS B
*  ON A~carrid = B~carrid
*  INTO TABLE itab.


SELECT A~carrid, A~carrname, B~connid, B~cityfrom, B~cityto
  FROM scarr AS A
  RIGHT OUTER JOIN spfli AS B
  ON A~carrid = B~carrid
  INTO TABLE @itab.
  "위 구문은 신 문법 New syntax

cl_demo_output=>display( itab ).
