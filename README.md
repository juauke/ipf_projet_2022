# Functional programming project

## How to use

### Compiling
The source files are located in `src/`.

To compile all 3 phases of the project, a Makefile is available. <br/>
Thanks to the latter, running 'make' command in a shell terminal either from the project root or in `src/` will compile the project.

### How to run
To run each binary, you need to run the following commands in a shell terminal:

    ./bin/phase1 [phase1_test_file]
    ./bin/phase2 [phase2_test_file]
    ./bin/phase3 [phase3_test_file]

For instance, to test the phase 1 binary with the its first test, run:

    ./bin/phase1 test/phase1/1.txt

The test file structure needs to match with the binary with whom it is being run. 
Test files are available in `test/`.

## File descriptions
- *phase1* is the module launching the phase 1 algorithm.
- *phase2* is the module launching the phase 2 algorithm.
- *phase3* is the module launching the phase 3 algorithm.
- *table* is the module which contains all functions used by the algorithm of each phase.
- *analysis* is the module which allows reading files and displaying the results of each phase.
- *print.ml* lists the display functions of the different structures used in the *table* module.

## Report
The report is avaiable in PDF format and its LaTeX is provided in `/doc`.

N.B.: analysis module (including its implementation) was provided but in French. Therefore, it was translated in English for this project purpose.
