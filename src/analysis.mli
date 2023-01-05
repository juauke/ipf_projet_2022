(* 
[analyse_file_1 file] open the file [file] and returns the transition list and the start and arrival points described in this file.

Raises the exception : 
 - Sys_error msg if it the file is inaccessible
 - Scanf.Scan_failure msg if the file is not in the right format
*) 

val analyse_file_1 : string -> (string * string * int) list * (string * string)

val output_sol_1 : int -> string list -> unit


(* 
[analyse_file_2 file] opens the file [file] and returns the transition list and the list of the paths which are to be browsed

Raises the exception : 
 - Sys_error msg if it the file is inaccessible
 - Scanf.Scan_failure msg if the file is not in the right format
*) 

val analyse_file_2 : string -> (string * string * int) list * string list list

  
(* 
[output_sol_2 sol] displays the phase 2 solutions. 
[sol] is a solution list: [sol_1;sol_2;...sol_n]. 
Each [sol_i] is of the form (path,times) where path is the requested path and times is the list of start times of the different modules
*)

val output_sol_2 :  (string list*int list) list -> unit

(* 
[analyse_file_3 file] open the file [file] and returns the transition file and the list of each of the start and arrival points.

Raises the exception : 
 - Sys_error msg if it the file is inaccessible
 - Scanf.Scan_failure msg if the file is not in the right format
*) 

val analyse_file_3 : string -> (string * string * int) list * (string *string) list

                                           
