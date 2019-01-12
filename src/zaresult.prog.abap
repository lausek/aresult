"---------------------------------------------------------------------*
" Include ZARESULT ~ lausek, 2018
" defines macros for error handling in a functional flavour
"---------------------------------------------------------------------*

" &1 = maybe typename
" &2 = `some` value type
DEFINE type_maybe.
  CLASS &1 DEFINITION
      CREATE PRIVATE.
      PUBLIC SECTION.
          TYPES:
            some_type TYPE &2.
          CLASS-METHODS:
              some
                  IMPORTING
                      iv_val TYPE &2
                  PREFERRED PARAMETER iv_val
                  RETURNING VALUE(ro_ref) TYPE REF TO &1,
              none
                  RETURNING VALUE(ro_ref) TYPE REF TO &1.
          METHODS:
              is_some
                  RETURNING VALUE(rv_correct) TYPE abap_bool,
              unwrap
                  RETURNING VALUE(rv_val) TYPE &2.
      PRIVATE SECTION.
          CONSTANTS:
              tag_some TYPE i VALUE 1,
              tag_none TYPE i VALUE 2.
          DATA:
              _tag  TYPE i,
              _some TYPE &2.
  ENDCLASS.
  CLASS &1 IMPLEMENTATION.
      METHOD some.
          ro_ref = NEW &1(  ).
          ro_ref->_tag = tag_some.
          ro_ref->_some = iv_val.
      ENDMETHOD.
      METHOD none.
          ro_ref = NEW &1(  ).
          ro_ref->_tag = tag_none.
      ENDMETHOD.
      METHOD is_some.
          rv_correct = boolc( me->_tag = tag_some ).
      ENDMETHOD.
      METHOD unwrap.
          ASSERT me->_tag = tag_some.
          rv_val = me->_some.
      ENDMETHOD.
  ENDCLASS.
END-OF-DEFINITION.

" &1 = name of maybe value
" &2 = name of variable to be declared
DEFINE if_some_let.
  IF &1->is_some( ).
      DATA(&2) = &1->unwrap( ).
END-OF-DEFINITION.

" &1 = result typename
" &2 = `ok` value type
" &3 = `err` value type
DEFINE type_result.
  CLASS &1 DEFINITION
      CREATE PRIVATE.
      PUBLIC SECTION.
          TYPES:
            ok_type   TYPE &2,
            err_type  TYPE &3.
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

" assigns `ok` value of &1 to symbol &2
" &1 = name of result variable
" &2 = name of variable to be declared
DEFINE if_ok_let.
  IF &1->is_ok( ).
      DATA(&2) = &1->unwrap( ).
END-OF-DEFINITION.

" assigns `err` value of &1 to symbol &2
" &1 = name of result variable
" &2 = name of variable to be declared
DEFINE if_err_let.
  IF NOT &1->is_ok( ).
      DATA(&2) = &1->unwrap_err( ).
END-OF-DEFINITION.

" takes `err` of &1 if it exists, creates an error
" of type &2 using that value, and returns
" &1 = name of result variable
" &2 = name of next result
DEFINE try_raise.
  IF NOT &1->is_ok( ).
    &2 = &2=>err( &1->unwrap_err( ) ).
    RETURN.
  ENDIF.
END-OF-DEFINITION.
