  Begin org-mode                               ALT-x org-mode
  Save                                         CTRL-x CTRL-s
  Export in other file formats (eg HTML,PDF)   CTRL-c CTRL-e

# Outline
#大纲

  Section heading                              *
  New headline                                 ALT-return
  Move headline up or down                     ALT-up_arrow/down_arrow
  Adjust indent depth of headline              ALT-left_arrow/right_arrow
  Open/collapse section                        TAB
  Open/collapse All                            CTRL-TAB

# To-Do Lists
#待办事项列表

  Mark list item as TODO                       ** TODO
  Cycle through workflow                       SHIFT-left_arrow/right_arrow
  Show only outstanding TODO                   items CTRL-c CTRL-v

# Tables
#表

  Table column separator                       Vertical/pipe character
  Reorganize table                             TAB
  Move column                                  ALT-left_arrow/right_arrow
  Move row                                     ALT-up_arrow/down_arrow

# Styles
#样式

  *bold*
  /italic/
  _underlined_
  =code=
  ~verbatim~
  +strike-through+

# Heading
#标题

  Header         -*- mode: org -*-

# .emacs
#的.emacs

  To make org-mode automatically wrap lines:

    (add-hook 'org-mode-hook
              '(lambda ()
                 (visual-line-mode 1)))
