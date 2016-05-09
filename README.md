# Vim-Compare-lines

Quickly compare two lines in a vim buffer.

Compare-lines is a plugin which allows you to select two lines and put the
differencies between these lines in the search register.

The differences are then highlighted as searches and you can navigate through
them with the `n` and `N` commands.

# See it in action

![Example of usage](http://i.stack.imgur.com/HaB5Y.gif)

# How to use it

Compare-lines enable the `:CL` command which start the diff between two lines.
The command can be used with three types of invocation:

    :CL
Will start the diff between current line (where the cursor is currently
positionned) and the line under it.

    :CL 42
Will start the diff between the current line and the line 42.

    :CL 42 66
Will start the diff between the line 42 and the line 66.
