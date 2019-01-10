# aresult

macros for functional error handling in ABAP (experimental)

## Why?

1. enforce error handling 
    - `TRY ... CATCH ...` is optional and often forgotten.
    - zaresult forces developers to think about error handling due to the additional step necessary.
2. type safety
    - zaresult stores data in its provided datatype - no wrapping inside a `REF TO data`.
3. neat syntax
    - zaresult provides macros for destructuring result types.

## Usage

1. clone repository using [abapGit](https://github.com/larshp/abapGit) (see [here](https://docs.abapgit.org/guide-online-install.html))
2. include with `INCLUDE zaresult.`

## Example

``` abap
INCLUDE zaresult.

" i         = type of `ok`  variant
" string    = type of `err` variant
type_result ty_magic_operation i string.

DATA(go_fine)       = ty_magic_operation=>ok( 1337 ).
DATA(go_not_good)   = ty_magic_operation=>err( `something is wrong` ).

" ...

" checks if the variant is `ok` and assigns the value to lv_my_num
" skips block otherwise
if_ok_let go_fine lv_my_num.
    WRITE: |my number is: { lv_my_num }|, /.
ENDIF.

" ...

" same as before but ELSE case is supplied to handle error
if_ok_let go_fine lv_my_num.
    WRITE: |my number still is: { lv_my_num }|, /.
ELSE.
    WRITE: |we got an error: { go_fine->unwrap_err( ) }|, /.
ENDIF.

" unwrap checks if the variant is `ok` and returns the inner value
" ASSERTION_FAILED otherwise
DATA(lo_dont_care) = go_not_good->unwrap( ).
```

## Further reading

- [Result type, Wikipedia](https://en.wikipedia.org/wiki/Result_type)
- [std::result, Rust Standard Library](https://doc.rust-lang.org/std/result/)
