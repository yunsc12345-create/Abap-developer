*&---------------------------------------------------------------------*
*& Report ZW11_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW11_1.

Data Title_1(20) TYPE C.
     Title_1 = 'Tutorial'.
Data Title_2(20) TYPE c.
     Title_2 = 'Tutorials'.

IF Title_1 = 'Tutorials'.   "하나의 if문에서는 하나의 조건만 탄다. 만약 하나 탄다면 다른거 안탐.
   write 'This is IF Statement'.
ELSE.
   write 'This is ELSE Statement'.
ENDIF.

"ELSEIF는 절대 동시에 충족할수없는 구조에 쓰는것.

IF Title_2 = 'Tutorials'.
  WRITE 'Fuck you'.            "ELSEIF는 절대 동시에 충족할수없는 구조에 쓰는것.
ELSE.
   write 'This is ELSE Statement'.
ENDIF.

"이렇게 만들면 둘다 출력됨.
