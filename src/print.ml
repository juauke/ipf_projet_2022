(******************************************************)
(* Functions used to display the different structures *)
(******************************************************)

(* auxiliary function *)
let rec print_succs l_succs =
	match l_succs with
	| [] -> ()
	| (s, (d, b))::l_succs' ->
		let _ = Printf.printf "  \\__ %s : %d | %d\n" s d b in
		print_succs l_succs'

(* auxiliary function *)
let rec print_table_aux l =
	match l with
	| [] -> ()
	| (s, s_succs)::l' ->
		let l_succs = MS.bindings s_succs in
		let _ = Printf.printf "%s\n" s in
		let _ = print_succs l_succs in
		print_table_aux l'

(* displays the table t *)
let rec print_table t =
	let list = MS.bindings t in
	print_table_aux list

(* display the route (pp) (including the waiting times) *)
let rec print_pp pp = 
	match pp with
	| [] -> Printf.printf "\n"
	| (s, d)::pp' ->
		let _ = Printf.printf "(%s, %d) " s d in
		print_pp pp' 

(* display the route (pp) list (ppl) (including the waiting times) *)
let rec print_ppl ppl =
	match ppl with
	| [] -> Printf.printf "\n"
	| pp::ppl' ->
		let _ = print_pp pp in
		print_ppl ppl'