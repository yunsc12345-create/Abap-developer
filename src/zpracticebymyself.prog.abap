*&---------------------------------------------------------------------*
*& Report ZPRACTICEBYMYSELF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPRACTICEBYMYSELF.

*PARAMETERS score TYPE I .
*
*DATA grade TYPE string.
*
*IF score > 80.
*  grade = 'excellent'.
*  ELSEIF score = 80.
*    grade = 'good'.
*    ELSEIF score < 80.
*      grade = 'not good'.
*ENDIF .
*
*WRITE : '학점은' , grade , '입니다.' no-gap.
*
DATA(GS_WORK) = '100'.

PERFORM gv USING GS_WORK.
WRITE / GS_WORK.

PERFORM GS USING gs_work.
WRITE / gs_work.


DATA : g_num TYPE I VALUE '5'.
DATA : a_num type I VALUE '3'.
DATA : a_sum TYPE I.


PERFORM uschanging USING g_num a_num a_sum.
WRITE / a_sum.



*FORM gv USING VALUE(CALLBACK)." 아래 문장대신 이걸 쓰면 100으로 출력됨. CALL BY VALUE냐 CALL BY REFERENCE냐 차이
FORM gv USING CALLBACK .
  CALLBACK = '101'.
  ENDFORM.

FORM GS using VALUE(cl).
  cl = '102'.
  ENDFORM.

FORM uschanging using VALUE(p_num)
                      VALUE(1_num)
                CHANGING VALUE(l_sum).

  l_sum = p_num * 1_num.
  ENDFORM.
