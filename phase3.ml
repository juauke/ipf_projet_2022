open Analysis
open Table

let _ =
	if Array.length Sys.argv = 2 then
		let filename = Sys.argv.(1) in
		let (list, way_list) = analyse_file_3 filename in
		let table = list_to_table list in
		let path_list = List.rev_map (
				fun w -> let (p, _) =
					try best_path w table with
						No_way ->
							let (si, sf) = w in
							let _ = Printf.printf "No way from %s to %s\n" si sf in
							raise No_way
					in p
			) way_list
		in
		let (sol_list, time) = best_comb_path path_list table in
		let _ = output_sol_2 sol_list in
		Printf.printf "%d\n" time
	else
		Printf.printf "usage: %s filename\n" Sys.argv.(0)
