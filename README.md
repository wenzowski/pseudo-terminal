Pseudo Terminal
===============

This library wraps PTY to ease use of pseudo terminals on unix-based operating systems.


Sample Workflow
---------------

Create a new pseudo terminal, write a command, process result, and close the process:

    require 'pseudo-terminal'
    pt = PseudoTerminal.new           # Create a new pseudo terminal.
    puts pt << 'pwd'                  # Write command & print result.
    pt.put('pwd') {|l| puts l}        # Write command & print each line when it appears on the pipe.
    pt.close                          # Close pseudo terminal and halt process.


Setup
-----

    gem install pseudo-terminal


Meta
----

Created by Alexander Wenzowski


Released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
