*&---------------------------------------------------------------------*
*& Report ZW11_2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW11_2.

"
" 숫자 필드를 제외하고 나머지는 같아야 하고 collect를 쓰면 숫자 값이 쌓이게 된다. 숫자필드를 집계하는 구문.

* internal table Structure creation
TYPES: BEGIN OF t_product,
       pid(10)     TYPE C,
       pname(40)   TYPE C,
       pamount(10) TYPE P,
       END OF t_product.

" begin of end of는 행을 만드는 것.

* Data & internal table declaration
DATA: wa TYPE t_product,
      it TYPE TABLE OF t_product.


wa-pid     = 'IFB1'.
wa-pname   = 'IFB WASHING MACHINE'.
wa-pamount = 31000.
COLLECT wa INTO it.



wa-pamount = 30000.
COLLECT wa INTO it.


wa-pid     = 'IFB2'.
wa-pname   = 'IFB SPLIT AC'.
wa-pamount = 38000.
COLLECT wa INTO it.


wa-pamount = 32000.
COLLECT wa INTO it.

* Reading internal table for all the records
LOOP AT it INTO wa.
  IF sy-subrc = 0.
    WRITE :/ wa-pid, wa-pname, wa-pamount.
  ELSE.
    WRITE 'No Record Found'.
  ENDIF.
ENDLOOP.


" 만약 wa를 clear하지 않고 계속 쓰는거라면 처음 한번만 넣어주고 숫자 필드만 바꿔주면 되는거 아님? 실험 결과 맞음.
" 궁금증 왜 if문 안에서 세번쨰 루프일때 else를 타고 no record found가 출력되지 않을까
" 그 이유는 it안에 세번째 행이 없기 때문에 그냥 루프를 종료하는것.
"즉 else문은 그냥 의미없는 구문
