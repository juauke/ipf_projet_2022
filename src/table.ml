(* @requires describes the preconditions: conditions on the parameters for a good use (no typing here); *)
(* @ensures describes the property true on function exit when preconditions are met; if so, the behaviours are mentioned in case of either success or failure; *)
(* @raises enumerates the exceptions potentially risen (and precises in what case(s) they are). *)

module MS = Map.Make(String)

type way = string * string
type path = string list
type path_pass = (string * int) list
type table = (int * int) MS.t MS.t

exception All_done
exception No_way

(* @requires
   @ensures  an identical Map to (t) which contains the Map whose key is (s) (be it already inside or not)
   @raises *)
let add_station s t =
	if MS.mem s t then
		t
	else
		MS.add s MS.empty t

(* @requires
   @ensures  an identical Map to (t) which does not contain any element whose key is (s) or does not have any successor
             each element of the returned Map is a Map which does not contain any successor whose key is (s)
   @raises *)
let remove_station s1 t =
	let t' = MS.remove s1 t in
	MS.fold (
			fun e s2_succs t ->
				let s2 = e in
				let s2_succs_without_s1 = MS.remove s1 s2_succs in
				if (MS.is_empty s2_succs_without_s1) then
					MS.remove s2 t	(* if s2 is empty, then there was only one path between s1 and s2 *)
				else
					MS.add s2 s2_succs_without_s1 t
		) t' t'

(* @requires 
   @ensures  an identical Map to (t) which contains an element whose key is (s1) (it can already exist in (t))
             this element contains a Map which contains the element (d, 0) whose key is (s2)
   @raises    *)
let add_way_aux s1 s2 d t =
	let t = add_station s1 t in
	let s1_succs =
		try MS.find s1 t with
			Not_found -> MS.empty
	in
	let s1_succs_with_s2 = MS.add s2 (d, 0) s1_succs in
	MS.add s1 s1_succs_with_s2 t

(* @requires way = (s1, s2)
   @ensures  an identical Map to (t) which contains:
              - an element whose key is (s1) (it can already exist in (t))
                this element contains a Map which contains the element (d, 0) whose key is (s2)
              - an element whose key is (s2) (it can already exist in (t))
                this element contains a Map which contains the element (d, 0) whose key is (s1)
   @raises    *)
let add_way way d t =
	let (s1, s2) = way in
	let t' = add_way_aux s1 s2 d t in
	add_way_aux s2 s1 d t'

(* Comments included in *table.mli* *)
let rec list_to_table l =
	match l with
	| [] -> MS.empty
	| (s1, s2, d)::l' ->
		let t = list_to_table l' in
		let w = (s1, s2) in
		add_way w d t

(* @requires 
   @ensures  the "path with departure time" matching with the path (p)
               the departure time (time) is initially set to (-1) => it means that we did not depart yet from this module
   @raises    *)
let path_to_path_pass p =
	List.map (fun s -> (s, -1)) p

(* @requires 
   @ensures  the list of "paths with departure times" corresponds to the list of paths (pl)
               each path's departure time (time) de chaque chemin is initially set to (-1) => it means that we did not depart yet from this module
   @raises    *)
let path_list_to_path_pass_list pl =
	List.map (fun p -> path_to_path_pass p) pl

(* @requires s1_succs is a Map which contains an element whose key is (s2)
   @ensures  (time, 0) where (time) is the time it takes to go from module (s1) to (s2)
   @raises   (time) is set to (-1) if the path does not exist *)
let get_time s2 s1_succs =
	let (d, _) = try MS.find s2 s1_succs with
		Not_found -> (-1, 0)
	in d

(* @requires w = (s1, s2)
             (t) is a Map which contains an element with key (s1) which, in turn, contains an element whose key is (s2)
   @ensures  (time, 0) where (time) is the time it takes to go from module (s1) to (s2)
   @raises   time is set to (-1) if the path does not exist *)
let get_way_time w t =
	let (s1, s2) = w in
	let s1_succs =
		try MS.find s1 t with
			Not_found -> MS.empty
	in
	get_time s2 s1_succs

(* @requires non-empty list (pp)
             the modules (s) listed in the lists (pp) in turn listed in (ppl) are present in (t)
   @ensures  the sum of the in-between-module (module: s) times of the list (pp) whose elements are couples (s, time) (where time is the module departure time)
   @raises   stops the program if (pp) is an empty list *)
let rec get_path_pass_time pp t =
	match pp with
	| [] -> assert false
	| _::[] -> 0
	| (s1, _)::pp' ->
		match pp' with
		| [] -> assert false (* cannot happen *)
		| (s2, _)::_ ->
			let time = get_way_time (s1, s2) t in
			time + get_path_pass_time pp' t

(* @requires the modules (s) listed in the lists (pp) in turn listed in (ppl) are present in (t)
   @ensures  sorts the list (ppl) of lists (pp) by decreasing (get_path_pass_time pp t), and then decreasing (List.length)
   @raises   appends the lists (pp) to the end of the list returned if one of the routes is inconsistent with (t) *)
let sort_path_path_list ppl t =
	List.sort (
			fun pp1 pp2 ->
				let c = compare (get_path_pass_time pp1 t) (get_path_pass_time pp2 t) in
				if (c = 0) then
					- compare (List.length pp1) (List.length pp2)
				else
					- c
		) ppl

(* @requires w = (s1, s2) -> (t) must contain an element whose key is (s1), which, in turn, must contain the couple (d, bt) at the key (s2)
   @ensures  the waiting time before the way (w) between two modules is free
   @raises   Not_found if an element matching with (w) in (t) is not found *)
let get_busy_time w t =
	let (s1, s2) = w in
	let s1_succs = MS.find s1 t in (* raise Not_found if the station s1 does not exist *)
	let (_, bt) = MS.find s2 s1_succs in (* raise Not_found if the station s2 does not exist *)
	bt

(* @requires w = (s1, s2) -> t must contain an element with key (s1) which, in turn, contains the couple (d, bt) at the key (s2) (and conversely)
   @ensures  changes the couple (d, bt) in (d, d + 1) in (t) at matching elements
   @raises   Not_found if an element matching with (w) in (t) is not found *)
let set_way_busy w t i =
	let (s1, s2) = w in
	let s1_succs = MS.find s1 t in (* raise Not_found if the station s1 does not exist *)
	let s2_succs = MS.find s2 t in (* raise Not_found if the station s2 does not exist *)
	let d = get_time s2 s1_succs in
	let s1_succs' = MS.add s2 (d, d + i) s1_succs in
	let s2_succs' = MS.add s1 (d, d + i) s2_succs in
	let t' = MS.add s1 s1_succs' t in
	MS.add s2 s2_succs' t'

(* @requires (pp) is a non-empty list
   @ensures  returns the first way (w) whose arrival module (s2, time) departure time (time) is (-1)
   @raises   stop the program if (pp) is empty *)
let rec get_next_way_in_path_pass pp =
	match pp with
	| [] -> assert false
	| (s1, _)::pp' ->
		match pp' with
		| [] -> (false, ("", ""))
		| (s2, t2)::_ ->
			if (t2 = -1) then
				(true, (s1, s2))
			else
				get_next_way_in_path_pass pp'

(* @requires 
   @ensures  the list (pp) by setting its first path whose (time) was (-1) to (time)
   @raises    *)
let set_next_way_in_path_pass pp time =
	let rec aux pp1 pp2 =
		match pp1 with
		| [] -> ([], pp2)
		| (s, t)::pp1' ->
			if (t = -1) then
				(pp1', (s, time)::pp2)
			else
				aux pp1' ((s, t)::pp2)
	in
	let (pp1, pp2) = aux pp [] in
	List.rev_append pp2 pp1

(* @requires 
   @ensures  decrements or leaves unchanged when 0 the waiting time (bt) of all the elements (d, bt) of the successors of the successors of (t)
   @raises    *)
let inc_time_table t =
	MS.map (
		fun s_succs ->
			MS.map (
				fun (d, bt) ->
					if (bt > 0) then
						(d, bt - 1)
					else
						(d, 0)
			) s_succs
	) t

(* @requires non-empty list (pp)
   @ensures  (true) if all the couples (s, time) of (pp) are such that (time > -1)
             (false) otherwise
   @raises   stop the program if (pp) is empty *)
let rec is_arrived pp =
	match pp with
	| [] -> assert false
	| (_, t)::[] -> t > -1
	| _::pp' -> is_arrived pp'

(* @requires 
   @ensures  (true) if all the couples (s, time) of the lists (pp) of (ppl) are such that (time > -1)
             (false) otherwise
   @raises    *)
let rec all_arrived ppl =
	match ppl with
	| [] -> true
	| pp::ppl' ->
		if (is_arrived pp) then
			all_arrived ppl'
		else
			false

(* @requires w = (s1, s2) -> a route exists to go from (s1) to (s2) through the network (which must be contained within (t))
             (t) is the table (t) of departure time without the elements matching with the paths we already went through
             (t_imin) is the minimum time found or (-1) if the route has not been found yet (as during the 1st call of the function)
             (path_rev) is the route followed to arrive to this step ([] during the 1st call)
   @ensures  returns the 1st route found whose browsing time (t_min) is minimal
   @raises   No_way if no route in (t) without going through a (path_rev) station again, or if the route is inconsistent with (t) *)
let rec best_path_aux w t time t_min path_rev =
	let (s, sf) = w in
	if (time > t_min && t_min >= 0) then
		(* time already accumulated is already bigger than the minimum found *)
		([], -1)
	else if (String.compare s sf = 0) then
		(* the reached station is the final station *)
		(* the time to reach (time) becomes the minimal time (t_min) *)
		(path_rev, time)
	else
		(* we look in all of s successors *)
		let s_succs = MS.find s t in (* raises the exception Not_found if there is no successor *)
		let t' = remove_station s t in (* to avoid going through s again *)
		MS.fold (
			fun s (d, bt) (path_rev1, time1) ->
				let (path_rev2, time2) =
					try best_path_aux (s, sf) t' (time + d) t_min (s::path_rev) with
						Not_found -> ([], -1)
				in
				if (time1 < 0) then
					(path_rev2, time2)
				else if (time2 < 0 || time1 < time2) then
					(path_rev1, time1)
				else
					(path_rev2, time2)
			) s_succs (path_rev, -1)

(* Comments included in *table.mli* *)
let best_path w t =
	let (s, _) = w in
	let (path_rev, time) = best_path_aux w t 0 (-1) [s] in
	if (time == -1) then
		raise No_way
	else
		(List.rev path_rev, time)

(* @requires (ppl) is a list of lists (pp) of couples (s, time)
               - (s): module name
                  -> must be a key of (t) and at least one of its successors
                  -> two consecutive (s) pp cannot be identical
               - (time): module departure time (-1 if we have not left yet)
             (t) is the table corresponding to the network
             (time) is equal to 0 during the 1st call
   @ensures  a list of couples (string list, integer list) which matches two for two with the borrowed modules and their depart time
             (no depart time for the arrival module)
   @raises   Not_found if one of the routes (pp) of the list (ppl) is inconsistent with (t) *)
let rec best_comb_path_aux ppl t time =
	let aux (ppl, t) pp =
		let (b, w) = get_next_way_in_path_pass pp in
		if b then
			let bt = get_busy_time w t in
			if (bt = 0) then
				let pp' = set_next_way_in_path_pass pp time in
				let (b', w') = get_next_way_in_path_pass pp' in
				if b' then
					let bt' = get_busy_time w' t in
					if (bt' = 0) then
						let t' = set_way_busy w' t 0 in
						(pp'::ppl, t')
					else
						(pp::ppl, t)
				else
					(pp::ppl, t)
			else if (bt = 1) then
				let pp' = set_next_way_in_path_pass pp (time + 1) in
				let (b', w') = get_next_way_in_path_pass pp' in
				if b' then
					let bt' = get_busy_time w' t in
					if (bt' = 0) then
						let t' = set_way_busy w' t 1 in
						(pp'::ppl, t')
					else
						let t' = set_way_busy w' t (bt') in
						let pp'' = set_next_way_in_path_pass pp (time + bt') in
						(pp''::ppl, t')
				else
					(pp'::ppl, t)
			else
				(pp::ppl, t)
		else
			(pp::ppl, t)
	in
	let (ppl, t) = List.fold_left aux ([], t) ppl in
	if (all_arrived ppl) then (* if everyone is arrived *)
		(ppl, time + 1)
	else
		let t = inc_time_table t in
		best_comb_path_aux (List.rev ppl) t (time + 1)

(* @requires non-empty list (pp), couples (s, time)
   @ensures  returns a couple (list of the modules of the route, list of the departure times)
   @raises   stop the program if (pp) is empty *)
let rec list_gen pp (acc_pp, acc_time) =
	match pp with
	| [] -> assert false
	| (s, time)::[] ->
		(List.rev (s::acc_pp), List.rev acc_time)
	| (s, time)::pp' ->
		list_gen pp' (s::acc_pp, time::acc_time)

(* Comments included in *table.mli* *)
let best_comb_path pl t =
	let ppl = path_list_to_path_pass_list pl in
	let ppl_sorted = sort_path_path_list ppl t in
	match ppl_sorted with
	| [] -> assert false
	| pp::_ ->
		let (ppl_sol, time) = best_comb_path_aux ppl_sorted t 0 in
		(*let t_max = get_path_pass_time pp t in
		let _ =
			let c = compare time t_max in
			if (c = 0) then
				Printf.printf "Optimal solution (%d)\n" time
			else if (c > 0) then
				Printf.printf "Not necessarily the most optimal solution (%d: longest path time exceeded by %d)\n" time (time - t_max)
			else
				Printf.printf "Somewhat impossible... (%d)\n" time
		in*)
		let list_sol = List.rev_map (fun pp -> list_gen pp ([], [])) ppl_sol in
		(list_sol, time)
