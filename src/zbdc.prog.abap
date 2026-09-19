*&---------------------------------------------------------------------*
*& Report ZBDC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBDC.


DATA : gs_opt TYPE ctu_params.

DATA : BEGIN OF itab OCCURS 0,
         bname(12)      TYPE c,
         title_medi(30) TYPE c,
         name_last(40)  TYPE c,
         name_first(40) TYPE c,
         langu(2)       TYPE c,
         mob_number(30) TYPE c,
         ustyp(1)       TYPE c,
         password(40)   TYPE c,
         password2(40)  TYPE c,
       END OF itab.


DATA: bdctab LIKE TABLE OF bdcdata WITH HEADER LINE.

DATA: wa LIKE LINE OF itab.
 FIELD-SYMBOLS : <gt_data>  TYPE standard table.

SELECTION-SCREEN BEGIN OF BLOCK BL01 WITH FRAME TITLE TEXT-001.
    PARAMETERS: P_FILE TYPE RLGRAP-FILENAME DEFAULT 'C:\' OBLIGATORY.
   PARAMETERS: DISOPT TYPE ctu_params-dismode DEFAULT 'A' OBLIGATORY.
    SELECTION-SCREEN : COMMENT 40(20) gv_butxt.
SELECTION-SCREEN COMMENT /1(50) comm1.
SELECTION-SCREEN ULINE.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN COMMENT /1(70) comm2.
SELECTION-SCREEN ULINE /1(50).
SELECTION-SCREEN END OF BLOCK BL01.

AT SELECTION-SCREEN OUTPUT.
  gv_butxt = 'BDC'.
  comm1 = 'BDC모드'.
  comm2 = 'A: 모든화면 조회, E: 오류 조회, N: 백그라운드처리'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR P_FILE.
  PERFORM GET_FILE_PATH.


START-OF-SELECTION.

PERFORM UPLOAD_FROM_EXCEL.
*CLEAR itab.
*REFRESH itab.
*
*itab-bname = 'EDU30'.
*itab-title_medi = '0001'.
*itab-name_last = 'KIM'.
*itab-name_first = 'MINH'.
*itab-langu = 'KO'.
*itab-mob_number = '01064572349'.
*itab-ustyp = 'A'.
*itab-password = 'Down1oad'.
*itab-password2 = 'Down1oad'.
*APPEND itab.

*BDC 처리모드(dismode)
* A : 모든화면 조회
* E : 오류 조회
* N : 백그라운드 처리
* P : 백그라운드 처리: 디버깅 가능



*BDC Transcation Mode(updmode)
*L : 로컬
*S : 동기
*A : 비동기

*gs_opt-dismode = 'A'.
gs_opt-dismode = DISOPT.
gs_opt-updmode = 'S'.
*gs_opt-defsize = 'X'.






  LOOP AT itab.
    REFRESH BDCTAB.
    PERFORM bdc_dynpro USING 'SAPLSUID_MAINTENANCE' '1050'.

*    PERFORM bdc_field USING 'BDC_CURSOR' 'SUID_ST_BNAME-BNAME'.
    PERFORM bdc_field USING 'BDC_OKCODE' '=CREA'.
    PERFORM bdc_field USING 'SUID_ST_BNAME-BNAME'  itab-bname.


    PERFORM bdc_dynpro USING 'SAPLSUID_MAINTENANCE' '1100'.
    PERFORM bdc_field USING 'BDC_OKCODE' '=LOGO'.
    PERFORM bdc_field USING 'SUID_ST_NODE_PERSON_NAME_EXT-TITLE_MEDI' itab-title_medi.
    PERFORM bdc_field USING 'SUID_ST_NODE_PERSON_NAME-NAME_LAST'     itab-name_last.
    PERFORM bdc_field USING 'SUID_ST_NODE_PERSON_NAME-NAME_FIRST'    itab-name_first.
    PERFORM bdc_field USING 'SUID_ST_NODE_PERSON_NAME-LANGU'    itab-langu.
    PERFORM bdc_field USING 'BDC_CURSOR' 'SUID_ST_NODE_COMM_DATA-MOB_NUMBER'.
    PERFORM bdc_field USING 'SUID_ST_NODE_COMM_DATA-MOB_NUMBER'    itab-mob_number.



    PERFORM bdc_dynpro USING 'SAPLSUID_MAINTENANCE' '1100'.

    PERFORM bdc_field USING 'BDC_OKCODE'    '=UPD'.

    PERFORM bdc_field USING 'SUID_ST_NODE_LOGONDATA-USTYP'    itab-ustyp.
    PERFORM bdc_field USING 'SUID_ST_NODE_PASSWORD_EXT-PASSWORD'    itab-password.
    PERFORM bdc_field USING 'BDC_CURSOR'    'SUID_ST_NODE_PASSWORD_EXT-PASSWORD2'.
    PERFORM bdc_field USING 'SUID_ST_NODE_PASSWORD_EXT-PASSWORD2'    itab-password2.


*   CALL TRANSACTION 'SU01' USING bdctab MODE 'A' UPDATE 'S'.
    CALL TRANSACTION 'SU01' USING bdctab OPTIONS FROM gs_opt.
*    CALL TRANSACTION 'SU01' USING bdctab OPTIONS FROM 'A' UPDATE 'S'.
  ENDLOOP.

*---------------------------------------------------------------------*
*       FORM bdc_dynpro                                               *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  P_PROGRAM                                                     *
*  -->  P_DYNPRO                                                      *
*---------------------------------------------------------------------*
FORM bdc_dynpro USING p_program
p_dynpro.

  bdctab-program = p_program.
  bdctab-dynpro = p_dynpro.
  bdctab-dynbegin = 'X'.
  APPEND bdctab.
  CLEAR bdctab.

ENDFORM. " bdc_dynpro


*---------------------------------------------------------------------*
*       FORM bdc_field                                                *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
*  -->  P_FNAM                                                        *
*  -->  P_FVAL                                                        *
*---------------------------------------------------------------------*
FORM bdc_field USING p_fnam
p_fval.

  bdctab-fnam = p_fnam.
  bdctab-fval = p_fval.
  APPEND bdctab.
  CLEAR bdctab.

ENDFORM. " bdc_field
*&---------------------------------------------------------------------*
*& Form GET_FILE_PATH
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_file_path .
* 선택된 파일의 주소를 P_FILE 입력칸에 할당
* METHOD 사용
  DATA : LT_FILE TYPE FILETABLE,
         LS_FILE TYPE FILE_TABLE,
         LV_RC   TYPE I.

  CALL METHOD CL_GUI_FRONTEND_SERVICES=>FILE_OPEN_DIALOG
    CHANGING
      FILE_TABLE = LT_FILE
      RC         = LV_RC.

  READ TABLE LT_FILE INTO LS_FILE INDEX 1.
  IF SY-SUBRC = 0.
    P_FILE = LS_FILE.
  ENDIF.

* FUNCTION 사용시: CALL FUNCTION 'F4_FILENAME'
ENDFORM.
*&---------------------------------------------------------------------*
*& Form UPLOAD_FROM_EXCEL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM upload_from_excel .
 DATA : lv_filename      TYPE string,
         lt_records       TYPE solix_tab,
         lv_headerxstring TYPE xstring,
         lv_filelength    TYPE i.

  lv_filename = p_file.

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename                = lv_filename
      filetype                = 'BIN'
    IMPORTING
      filelength              = lv_filelength
      header                  = lv_headerxstring
    TABLES
      data_tab                = lt_records
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      OTHERS                  = 17.

  "convert binary data to xstring
  "if you are using cl_fdt_xl_spreadsheet in odata then skips this step
  "as excel file will already be in xstring
  CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
    EXPORTING
      input_length = lv_filelength
    IMPORTING
      buffer       = lv_headerxstring
    TABLES
      binary_tab   = lt_records
    EXCEPTIONS
      failed       = 1
      OTHERS       = 2.

  IF sy-subrc <> 0.
    "Implement suitable error handling here
  ENDIF.

  DATA : lo_excel_ref TYPE REF TO cl_fdt_xl_spreadsheet .

  TRY .
      lo_excel_ref = NEW cl_fdt_xl_spreadsheet(
                              document_name = lv_filename
                              xdocument     = lv_headerxstring ) .
    CATCH cx_fdt_excel_core.
      "Implement suitable error handling here
  ENDTRY .

  "Get List of Worksheets
  lo_excel_ref->if_fdt_doc_spreadsheet~get_worksheet_names(
    IMPORTING
      worksheet_names = DATA(lt_worksheets) ).

  IF NOT lt_worksheets IS INITIAL.
    READ TABLE lt_worksheets INTO DATA(lv_woksheetname) INDEX 1.

    DATA(lo_data_ref) = lo_excel_ref->if_fdt_doc_spreadsheet~get_itab_from_worksheet(
                                             lv_woksheetname ).
    "now you have excel work sheet data in dyanmic internal table
    ASSIGN lo_data_ref->* TO <gt_data>.
  ENDIF.          .

  DATA : lv_numberofcolumns   TYPE i,
         lv_date_string       TYPE string,
         lv_target_date_field TYPE datum.


  FIELD-SYMBOLS : <ls_data>  TYPE any,
                  <lv_field> TYPE any.

  "you could find out number of columns dynamically from table <gt_data>
  lv_numberofcolumns = 9 .

  LOOP AT <gt_data> ASSIGNING <ls_data>.

*    "processing columns
    DO lv_numberofcolumns TIMES.
      ASSIGN COMPONENT sy-index OF STRUCTURE <ls_data> TO <lv_field> .
      IF sy-subrc = 0 .
        CASE sy-index .
          when 1 .
            wa-bname = <lv_field>.
          when 2 .
            wa-title_medi = <lv_field>.
          when 3 .
            wa-name_last = <lv_field>.
          when 4 .
            wa-name_first = <lv_field>.
          when 5 .
            wa-langu = <lv_field>.
          when 6 .
            wa-mob_number = <lv_field>.
          when 7 .
            wa-ustyp = <lv_field>.
          when 8 .
            wa-password = <lv_field>.
          when 9 .
            wa-password2 = <lv_field>.

*          WHEN 10 .
*            lv_date_string = <lv_field> .
*            PERFORM date_convert USING lv_date_string CHANGING lv_target_date_field .
*            WRITE lv_target_date_field .
          WHEN OTHERS.
*            WRITE : <lv_field> .
        ENDCASE .

      ENDIF.
    ENDDO .
    APPEND wa TO itab.
    CLEAR wa.
*    NEW-LINE .
  ENDLOOP .


** TAB으로 구분된 내용을 잘라서 ITAB에 APPEND 한다.
*  LOOP AT lt_intern.
*    SPLIT lt_intern
*    AT cl_abap_char_utilities=>horizontal_tab
*    INTO gs_EXCEL-CARRID gs_EXCEL-CARRNAME gs_EXCEL-CURRCODE gs_EXCEL-URL.
*    gs_EXCEL-MANDT = '001'.
*    APPEND gs_EXCEL TO gt_EXCEL.
*    CLEAR gs_EXCEL.
*  ENDLOOP.
*
**HEADER LINE 삭제
*  IF gt_excel IS NOT INITIAL.
*    DELETE gt_excel INDEX 1. "상단에 적힌 필드명을 삭제시켜줌
*  ELSE.
*    MESSAGE '데이터가 존재하지 않습니다' TYPE 'E'.
*  ENDIF.

ENDFORM.
