*&---------------------------------------------------------------------*
*& Report ZMEMO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMEMO.

Data Title_1(20) TYPE C.
     Title_1 = 'Tutorials'.
Data Title_2(20) TYPE C.
     Title_2 = 'Tutorials'.


IF Title_1 = 'Tutorials'.
   write 'This is IF Statement'.

"하나의 if문에서는 딱 하나의 조건만 탄다. 첫번째 조건을 탔다면 다른 조건을 타지 않는다.


ELSEIF Title_2 = 'Tutorials'.             "이것도 충족하지만 타지 않는다.
   write 'This is IF2 Statement'.
ELSE.
   write 'This is ELSE Statement'.

ENDIF.




"만약 둘다 타게 하고싶으면 아래처럼 조건을 따로 빼놓을것.


*IF Title_2 = 'Tutorials'.
*   write 'This is IF2 Statement'.
*ELSE.
*   write 'This is ELSE Statement'.
*
*ENDIF.
