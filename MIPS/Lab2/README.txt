Kaiwen Pan
kpan7
Winter 2021
Lab 2: Simple Data Path

-------------------
DESCRIPTION

In this lab, I use MML(multimedia logic) to simulate logic circuits. Including the ALU shift Unit, clear button, and 4-bit regitsters made by d flip-flops.

--------------------
FILES

-
Lab2.lgi

This file contains most part of this Lab.
Page 2 is almost empty cause that I remove the senders and receivers after I finished the circuit.
On page 3, I build a 2*1 mux on my own(not the built-in mux) to select output from keypad and alu output.
Page 4 is the implementation of write logic combined with update signal.
Page 5 and page 6 are implementations of registers which are made of D flip-flops.
ALU input select logic is presented on page 7 and 8.
On the last page, I used 4 4:1 muxes to implement the left shift operations. When the value of ALU input one is more than 3(not equal to 3), 
the ALU output must be 4 zeros, this is why the  high sender(the last page) exists.


-
README.txt

Description and instruction of this Lab.

--------------------
INSTRUCTIONS

Just open Lab2.lgi and check out the Lab results.