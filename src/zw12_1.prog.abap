*&---------------------------------------------------------------------*
*& Report ZW12_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZW12_1.

PARAMETERS: carrid TYPE sflight-carrid DEFAULT 'AA' ,
            connid TYPE sflight-connid DEFAULT '0017',
            fldate TYPE sflight-fldate DEFAULT '20180528'.


DATA sflight_tab TYPE SORTED TABLE OF sflight  " : 는 여러 변수 선언시에 필요한 것.
                 WITH UNIQUE KEY carrid connid fldate.

SELECT *
       FROM sflight
       WHERE carrid = @carrid AND
             connid = @connid    "이것때문에 @fldate의 값에 상관없이 출력됨.
       INTO TABLE @sflight_tab.
" READ TABLE 은 우리가 선언한 테이블에서 뭔가 담아준상태에서 한줄씩 불러오는것 like LOOP
  "그러나 조건에 맞는 한줄을 불러온다.

IF sy-subrc = 0.
  READ TABLE sflight_tab
       WITH TABLE KEY carrid = carrid  "WITH TABLE KEY는 키가 있는 테이블에서, WITH KEY 키가 없는 테이블
                      connid = connid  "특이한 점은 and나 ,없이 필드이름 = 조건 을 작성함.
                      fldate = fldate
       INTO DATA(sflight_wa). "->직접선언
"선언과 사용이 동시에 될때 @가 붙어야 하지만 ABAP 언어 명령어에선 할필요 없음(READ TABLE)이 아밥 언어, SELECT같은 SQL은 안됨.
"ABAP이 그 자리에 들어갈 데이터의 타입을 앞부분에서 보고 자동으로 결정
  IF sy-subrc = 0.
    sflight_wa-price = sflight_wa-price * '0.9'.
    MODIFY sflight_tab FROM sflight_wa INDEX sy-tabix.
  ENDIF.
ENDIF.
 " read table은 조건에 맞는 딱 하나의 행만을 불러온다..?
cl_demo_output=>display( sflight_tab ).
