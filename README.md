Pseudo Terminal
====================================================================

This library wraps PTY to ease use of PTY on unix-based operating systems.

Sample Workflow
---------------

Create a new pseudo terminal, write a command, process result, and close the process:

    require 'pseudo-terminal'
    pt = PseudoTerminal.new           # Create a new pseudo terminal.
    (pt << 'pwd').each {|l| puts l}   # Write command & process each resulting line as it becomes available.
    pt.close                          # Close pseudo terminal and halt process.


Setup
-----

    gem install pseudo-terminal


Meta
----

Created by Alexander Wenzowski


Released under the [MIT license](http://www.opensource.org/licenses/mit-license.php).
