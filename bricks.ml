let width = 32
let height = 10

let add2 r = (r lsl 2) lor 0b10
    let add3 r = (r lsl 3) lor 0b100

let rows = ref[]
let rec fill r w =
    if w = width then
        rows := r :: !rows
    else if w < width then
        begin
            fill (add2 r) (w + 2);
            fill (add3 r) (w + 3)
        end

let () = fill 0 2; fill 0 3
let () =  Printf.printf "%d arrangements\n" (List.length !rows)

let rec sum f l =
    match l with
    | [] -> 0
    | x::s -> f x + sum f s

let table = Hashtbl.create 5003

let rec count r h =
    if h = 1 then
        1
    else
        sum
        (fun r' ->
            if r' land r = 0 then
                memo_count r' (h - 1)
            else
                0
        )
        !rows

and memo_count r h = 
    try
        Hashtbl.find table (r, h)
    with Not_found ->
        let v =  count r h in
        Hashtbl.add table (r, h) v;
        v

let sol = sum (fun r -> count r height) !rows
let () = Printf.printf "solution = %d\n" sol 
