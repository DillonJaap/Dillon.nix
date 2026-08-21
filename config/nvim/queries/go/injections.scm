; Inject CSS into Class("...") / Classes("...") call argument strings
; so the class list gets CSS highlighting and indent behaviour.

(call_expression
  (identifier) @_fn
  (#any-of? @_fn "Class" "Classes")
  (argument_list
    .
    [(interpreted_string_literal
       (interpreted_string_literal_content) @injection.content)
     (raw_string_literal
       (raw_string_literal_content) @injection.content)])
  (#set! injection.language "css"))

; Method form: receiver.Class("...") / x.Classes("...")
(call_expression
  (selector_expression
    (field_identifier) @_method)
  (#any-of? @_method "Class" "Classes")
  (argument_list
    .
    [(interpreted_string_literal
       (interpreted_string_literal_content) @injection.content)
     (raw_string_literal
       (raw_string_literal_content) @injection.content)])
  (#set! injection.language "css"))