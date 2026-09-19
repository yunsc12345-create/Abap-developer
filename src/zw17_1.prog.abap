*&---------------------------------------------------------------------*
*& Report ZW16
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW17_1.

*&---------------------------------------------------------------------*

INCLUDE ZW17_TOP.
*INCLUDE ZW16_TOP.
INCLUDE ZW17_SEL.
*INCLUDE ZW16_SEL.
INCLUDE ZW17_C01.
*INCLUDE ZW16_C01.
INCLUDE ZW17_F01.
*INCLUDE ZW16_F01.
INCLUDE ZW17_I01.
*INCLUDE ZW16_I01.
INCLUDE ZW17_O01.


*&=====================================================================*
*& INITIALIZATION
*&=====================================================================*
INITIALIZATION.
  PERFORM SET_FUNCTION_KEY.


*&=====================================================================*
*& AT SELECTION-SCREEN
*&=====================================================================*
AT SELECTION-SCREEN.
  PERFORM ACT_FUNCTION_KEY. "검색화면에서 하는 모든 이벤트는 여기 넣어도 된다. 오류검증도 가능

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  PERFORM GET_FILE_PATH.

*&=====================================================================*
*& START-OF-SELECTION
*&=====================================================================*
START-OF-SELECTION.

IF r1 = 'X'.
    PERFORM CHECK_BEFORE_PROCESS.
* 파일 업로드 진행
    PERFORM UPLOAD_FROM_EXCEL.
    PERFORM GET_DATA.
ELSEIF r2 = 'X'.
    PERFORM GET_NEEDED_DATA.
ELSEIF r3 = 'X'.
    PERFORM DEL_DATA.
ENDIF.



*&=====================================================================*
*& END-OF-SELECTION
*&=====================================================================*
END-OF-SELECTION.
IF r1 ='X'.
  CALL SCREEN 100.
ELSEIF r2 = 'X'.
  IF GT_ZSCARR IS NOT INITIAL.
  CALL SCREEN 100.
  ELSE.
    MESSAGE '조회할 데이터가 없습니다.' TYPE 'I'.
  ENDIF.

ENDIF.
