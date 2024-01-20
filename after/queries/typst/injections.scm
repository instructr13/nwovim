;; Code from https://raw.githubusercontent.com/uben0/tree-sitter-typst/9c52e756e81b01841bdfe23ed5ee3e753805d8d5/queries/injections.scm
(raw_blck
  (blob) @injection.shebang @injection.content)

(raw_blck
	lang: (ident) @injection.language
  (blob) @injection.content)
