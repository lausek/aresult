*&---------------------------------------------------------------------*
*&  Include  ZARESULT
*&---------------------------------------------------------------------*

" &1 = result typename
" &2 = type 1
" &3 = type 2
DEFINE result.
  CLASS &1 DEFINITION
      CREATE PRIVATE.
      PUBLIC SECTION.
          CLASS-METHODS:
              ok
                  IMPORTING
                      iv_val TYPE &2
                  PREFERRED PARAMETER iv_val
                  RETURNING VALUE(ro_ref) TYPE REF TO &1,
              err
                  IMPORTING
                      iv_val TYPE &3
                  PREFERRED PARAMETER iv_val
                  RETURNING VALUE(ro_ref) TYPE REF TO &1.
          METHODS:
              is_ok
                  RETURNING VALUE(rv_correct) TYPE abap_bool,
              unwrap
                  RETURNING VALUE(rs_ok) TYPE &2,
              unwrap_err
                  RETURNING VALUE(rs_err) TYPE &3.
      PRIVATE SECTION.
          CONSTANTS:
              tag_ok  TYPE i VALUE 1,
              tag_err TYPE i VALUE 2.
          DATA:
              _tag TYPE i,
              _ok  TYPE &2,
              _err TYPE &3.
  ENDCLASS.
  CLASS &1 IMPLEMENTATION.
      METHOD ok.
          ro_ref = NEW &1(  ).
          ro_ref->_tag = tag_ok.
          ro_ref->_ok = iv_val.
      ENDMETHOD.

      METHOD err.
          ro_ref = NEW &1(  ).
          ro_ref->_tag = tag_err.
          ro_ref->_err = iv_val.
      ENDMETHOD.

      METHOD is_ok.
          rv_correct = boolc( me->_tag = tag_ok ).
      ENDMETHOD.

      METHOD unwrap.
          ASSERT me->_tag = tag_ok.
          rs_ok = me->_ok.
      ENDMETHOD.

      METHOD unwrap_err.
          ASSERT me->_tag = tag_err.
          rs_err = me->_err.
      ENDMETHOD.
  ENDCLASS.
END-OF-DEFINITION.

" &1 = name of result value
" &2 = name of variable to be declared value
DEFINE result_let_ok.
  IF &1->is_ok( ).
      DATA(&2) = &1->unwrap( ).
END-OF-DEFINITION.
