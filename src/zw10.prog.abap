*&---------------------------------------------------------------------*
*& Report ZW10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW10.







TYPES: BEGIN OF wa,
         carrid   TYPE scarr-carrid,
         carrname TYPE scarr-carrname,
         connid   TYPE spfli-connid,
         cityfrom TYPE spfli-cityfrom,
         cityto   TYPE spfli-cityto,
         fldate   TYPE sflight-fldate,
         bookid   TYPE sbook-bookid,
       END OF wa.

DATA itab TYPE TABLE OF wa.


*
*SELECT carrid carrname connid cityfrom cityto fldate
*  FROM scarr AS s
*  INNER JOIN spfli AS p
*  ON s~carrid = p~carrid
*  INTO TABLE itab



*크로스조인은 on조건없이 똑같은 구문을 사용하면 됨,

*SELECT c~carrid c~carrname p~connid p~cityfrom p~cityto
*  FROM scarr AS c
*  INNER JOIN spfli AS p
*  on c~carrid = p~carrid
*  INTO TABLE itab.

*SELECT c~carrid c~carrname p~connid p~cityfrom p~cityto
*  FROM scarr AS c
*  LEFT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid
*  INTO TABLE itab.
*
*SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto
*  FROM scarr AS c
*  RIGHT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid
*  INTO TABLE @itab.

*SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto
*  FROM scarr AS c
*  CROSS JOIN spfli AS p
*  INTO TABLE @itab.



*SELECT c~carrid c~carrname p~connid p~cityfrom p~cityto f~fldate
*  FROM ( scarr AS c
*  INNER JOIN spfli AS p
*  ON c~carrid = p~carrid )
*  INNER JOIN sflight AS f
*  ON f~carrid = p~carrid
*  AND f~connid = p~connid
*  INTO TABLE itab.

*SELECT c~carrid c~carrname p~connid p~cityfrom p~cityto f~fldate
*  FROM ( scarr AS c
*  LEFT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid )
*  INNER JOIN sflight AS f
*  ON f~carrid = p~carrid
*  AND f~connid = p~connid
*  INTO TABLE itab.

*SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto, f~fldate
*  FROM ( scarr AS c
*  LEFT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid )
*  LEFT OUTER JOIN sflight AS f
*  ON f~carrid = p~carrid
*  AND f~connid = p~connid
*  INTO TABLE @itab.
*
*SELECT c~carrid, c~carrname, p~connid, p~cityfrom, p~cityto, f~fldate, s~bookid
*  FROM ( ( scarr AS c
*  LEFT OUTER JOIN spfli AS p
*  ON c~carrid = p~carrid )
*  INNER JOIN sflight AS f
*  ON p~carrid = f~carrid
*  AND p~connid = f~connid )
*  LEFT OUTER JOIN sbook AS s
*  ON f~carrid = s~carrid
*  AND f~connid = s~connid
*  AND f~fldate = s~fldate
*  INTO TABLE @itab.



cl_demo_output=>display( itab ).
