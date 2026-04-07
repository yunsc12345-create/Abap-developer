*&---------------------------------------------------------------------*
*& Report ZW12_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW12_2.

TYPES :
BEGIN OF flight,
  carrid   TYPE spfli-carrid,
  connid   TYPE spfli-connid,
  cityfrom TYPE spfli-cityfrom,
  cityto   TYPE spfli-cityto,
  END OF flight.

DATA flights TYPE SORTED TABLE OF flight WITH UNIQUE KEY carrid connid.

SELECT * from spfli
  INTO TABLE @DATA(spfli_tab).

MOVE-CORRESPONDING spfli_tab TO flights. "spfli_tab과 flights의 필드는 다르지만 데이터를 이동시키는 문법

cl_demo_output=>display( flights ) .
