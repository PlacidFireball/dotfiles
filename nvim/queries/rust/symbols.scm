; Let bindings, statics, and constants
(let_declaration
  pattern: (identifier) @variable)
(static_item) @variable
(const_item) @variable

; Functions (free and impl methods)
(function_item) @function

; Types
(struct_item) @type
(enum_item) @type
(trait_item) @type
(type_item) @type
(impl_item) @type
