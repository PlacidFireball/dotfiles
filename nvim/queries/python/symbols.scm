; Variables / top-level assignments
(assignment
  left: (identifier) @variable)

; Functions (including async and decorated)
(function_definition) @function
(decorated_definition
  definition: (function_definition)) @function

; Classes
(class_definition) @type
(decorated_definition
  definition: (class_definition)) @type
