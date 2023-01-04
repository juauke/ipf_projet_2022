(* @requires describes the preconditions: conditions on the parameters for a good use (no typing here); *)
(* @ensures describes the property true on function exit when preconditions are met; if so, the behaviours are mentioned in case of either success or failure; *)
(* @raises enumerates the exceptions potentially risen (and precises in what case(s) they are). *)

type way = string * string;;
type path = string list;;
type path_pass = (string * int) list;;
type table;;

exception No_way;;

(* @requires 
   @ensures    the table matching with the list of the couples of paths
               The way (s1, s2, d) links the stations (s1) et (s2) in a time (d)
               A table is a Map whose elements have a string (s1) as their key
               Those elements are a Map whose elements have a string (s2) as their key
               Those elements contains the couple (d, bt) with the waiting time (bt = 0)
               This process is repeated by swapping (s1) and (s2)
   @raises    *)
val list_to_table : (string * string * int) list -> table;;

(* @requires w = (s1, s2) -> a route exists to go from (s1) to (s2) across the network (which must be contained within (t))
   @ensures  returns the first the 1st route found whose travel time is the shortest
   @raises   No_way if the route is inconsistent with (t) *)
val best_path : way -> table -> path * int;;

(* @requires (ppl) is a list of lists pp of couples (s, time)
               - (s): module name
                  -> must be a key of (t) and of at least one of its successors
                  -> two consecutive (s) of pp cannot be identical
               - (time): module depart time (-1 if we have not left it yet)
             (t) is the table corresponding to the network correspondant au réseau
   @ensures  a list of couples (string list, integer list) matches two for two with the borrowed modules and their depart time
             (no depart time for the arrival module)
   @raises   Not_found if one of the routes (p) of the list (pl) is inconsistent with (t) *)
val best_comb_path : path list -> table -> (string list * int list) list * int;;
