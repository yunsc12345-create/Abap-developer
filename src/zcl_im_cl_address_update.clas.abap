class ZCL_IM_CL_ADDRESS_UPDATE definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ADDRESS_UPDATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_CL_ADDRESS_UPDATE IMPLEMENTATION.


  method IF_EX_ADDRESS_UPDATE~ADDRESS1_SAVED.
    IF IM_T_XADR6 NE IM_T_YADR6.
      MESSAGE '이메일 주소는 변경할 수 없습니다.' TYPE 'I'.
      ENDIF.
  endmethod.


  method IF_EX_ADDRESS_UPDATE~ADDRESS2_SAVED.
        MESSAGE '주소체크3' TYPE '3'.
  endmethod.


  method IF_EX_ADDRESS_UPDATE~ADDRESS3_SAVED.
    MESSAGE '주소체크3' TYPE '3'.

  endmethod.


  method IF_EX_ADDRESS_UPDATE~FINISHED.
    MESSAGE '주소체크저장' TYPE '3'.
  endmethod.
ENDCLASS.
