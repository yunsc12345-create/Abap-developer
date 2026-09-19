
  METHOD onactionsearch .

  DATA: lv_carrid  TYPE spfli-carrid,
        lt_flights TYPE TABLE OF spfli.

  " 1. 화면에서 입력한 CARRID 가져오기
  wd_context->get_child_node( 'SEARCH' )->get_attribute(
    EXPORTING
      name  = 'CARRID'
    IMPORTING
      value = lv_carrid ).

  " 2. SPFLI에서 해당 항공사의 비행편 조회
  SELECT *
    FROM spfli
    INTO TABLE lt_flights
    WHERE carrid = lv_carrid.

  " 3. 조회 결과를 FLIGHTS Context에 넣기
  wd_context->get_child_node( 'FLIGHTS' )->bind_table(
    new_items = lt_flights ).

ENDMETHOD.


method WDDOAFTERACTION .
endmethod.

method WDDOBEFOREACTION .
*  data lo_api_controller type ref to if_wd_view_controller.
*  data lo_action         type ref to if_wd_action.

*  lo_api_controller = wd_this->wd_get_api( ).
*  lo_action = lo_api_controller->get_current_action( ).

*  if lo_action is bound.
*    case lo_action->name.
*      when '...'.

*    endcase.
*  endif.
endmethod.

method WDDOEXIT .
endmethod.

method WDDOINIT .
endmethod.

method WDDOMODIFYVIEW .
endmethod.

method WDDOONCONTEXTMENU .
endmethod.

