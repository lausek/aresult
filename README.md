# aresult

macros for functional error handling in ABAP (experimental)

## Why?

1. ABAP does not enforce current exception-based error handling - working with zaresult does
2. many things more ...

## Usage

1. clone repository using [abapGit](https://github.com/larshp/abapGit) (see [here](https://docs.abapgit.org/guide-online-install.html))
2. include with `INCLUDE zaresult.`

## Example

``` abap
INCLUDE zaresult.

" i = type of `ok` variant
" string = type of `err` variant
result ty_magic_operation i string.

DATA(go_fine) = ty_magic_operation=>ok( 1337 ).
DATA(go_not_good) = ty_magic_operation=>err( `something is wrong` ).

" ...

" checks if the variant is `ok` and assigns the value to lv_my_num
" skips block otherwise
result_let_ok go_fine lv_my_num.
    WRITE: |my number is: { lv_my_num }|, /.
ENDIF.

" ...

" same as before but ELSE case is supplied to handle error
result_let_ok go_fine lv_my_num.
    WRITE: |my number still is: { lv_my_num }|, /.
ELSE.
    DATA(lo_error_message) = go_fine=>unwrap_err( ).
    WRITE: |we got an error: { go_fine=>unwrap_err( ) }|, /.
ENDIF.

" unwrap checks if the variant is `ok` and returns the inner value
" ASSERTION_FAILED otherwise
DATA(lo_dont_care) = go_not_good=>unwrap( ).
```
