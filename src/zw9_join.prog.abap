*&---------------------------------------------------------------------*
*& Report ZW9_JOIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW9_JOIN.


TYPES: BEGIN OF wa,
  carrname  TYPE scarr-carrname,
  carrid    TYPE scarr-carrid,
  connid    TYPE spfli-connid,
  cityfrom  TYPE spfli-cityfrom,
  cityto    TYPE spfli-cityto,
  fldate    TYPE sflight-fldate,
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


SELECT  A~carrname, A~carrid, B~connid, B~cityfrom, B~cityto, F~fldate
  FROM ( scarr AS A
  INNER JOIN spfli AS B
  ON A~carrid = B~carrid )
  INNER JOIN sflight AS F
  ON B~carrid = F~carrid
  AND B~connid = F~connid

  INTO TABLE @itab.
  "위 구문은 신 문법 New syntax

cl_demo_output=>display( itab ).
