*&---------------------------------------------------------------------*
*& Report ZW11
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW11.

DATA : BEGIN OF ITAB OCCURS 0,

NUM1 TYPE I ,

NUM2 TYPE I ,

NUM3 TYPE I ,

END OF ITAB .

*occurs 와 begin of, end of가 붙으면 with headerline 구조가 된다.


DO 10 TIMES .


*ITAB-NUM1 = ITAB-NUM1 + 1 .
*
*clear  itab-num2.

ITAB-NUM1 = sy-index.

*sy-index의 원리를 이용한 구문

DO 10 TIMES .

*ITAB-NUM2 = ITAB-NUM2 + 1 .

ITAB-NUM2 = sy-index.

ITAB-NUM3 = ITAB-NUM1 * ITAB-NUM2 .

append itab.

ENDDO .

ENDDO .  "DO ENDDO사이를 10번 반복해라.


LOOP AT ITAB . "LOOP AT ITAB

"원래는 loop at itab(table) into itab(행) 구조지만 with headerline구조라 행과 테이블의 이름이 같아 생략된 것.
" LOOP는 테이블에 있는 행들을 하나씩 행에다 넣어보는것.
"sy-tabix에서 몇번째 행을 불러오고 있는가가 찍힌다.

WRITE : / ITAB-NUM1, '*' , ITAB-NUM2 , '=' , ITAB-NUM3 .

* /는 행을 바꾸라는 뜻
ENDLOOP .
