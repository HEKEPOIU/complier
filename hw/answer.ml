(* Ex 1 *) (*a ---------------------------------------------------*)

(* fact such that fact n returns the factorial of the positive integer n. *)
let fact n =
    let rec aux n total = 
        if n <= 1 then 
            total
        else
            aux (n - 1) (total * n)
    in
    aux n 1

(*b ---------------------------------------------------*)

(* nb_bit_pos such that bn_bit_pos n returns the number of bits equal to 1 in the binary *)
(* representation of the positive integer n *)
let nb_bit_pos n =
    let rec aux n total =
        if n = 0 then
            total
        else
            aux (n lsr 1) (total + (n land 1))
    in
    aux n 0

(* Ex 2 *)

(* Write a new version of this function with linear complexity in the parameter n. Indication *)
(* You can use an auxiliary function using two accumulator *)

(* O(2^n) sample *)
(* let rec fibo n = *)
(*     if n <= 1 then *)
(*         n *)
(*     else *)
(*         fibo (n-1) + fibo (n-2) *)

let fibo n =
    let rec aux n a b =
        match n with
        | 0 -> a
        | _ -> aux (n-1) b (a+b)
    in
    aux n 0 1


(* Ex 3*)
(*a ---------------------------------------------------*)

(* palindrome such that palindrome m returns true if and only if the string m is a palindrome *)
(* (that is, we see the same sequence of characters whether we read it from left to right *)
(* or from right to left, e.g. madam) *)
(* <> -> not equal -> != in other Lang*)
let palindrome m =
    let length = String.length m in
    let rec check l r =
        if l >= r then
            true
        else if m.[l] <> m.[r] then
            false
        else 
            check (l+1) (r-1)
    in 
    check 0 (length - 1)


(*b ---------------------------------------------------*)

(* compare such that compare m1 m2 returns true if and only if the string m1 is smaller in *)
(* lexicographic order than the string m2 *)
(* (that is, m1 would appear before m2 in a dictionary); *)

(* seem like the ocaml compare operation already lexicographic? *)
(* TODO: Check is available to use builtin compare?*)
let compare m1 m2 = 
    (m1 < m2)


(*c ---------------------------------------------------*)

(* factor such that factor m1 m2 returns true if and only if the string m1 is a factor of the *)
(* string m2 *)

(* string m1, m2 *)
(*if m1.len > m2.len || p_2 == m_2.len && p_1 != m_1.len -> false
if p_1 == m_1.len -> true
let p_1, p_2,
if m1[p_1] == m_2[p_2] 
    p_1 ++
    p_2++
else if m1[p_1] != m_2[p_2]
    p_2++
    p_1 = 0

call self*)


let factor m1 m2 =
    let length_1 = String.length m1 in
    let length_2 = String.length m2 in

    if (length_2 < length_1) then
        false
    else
        let rec check p_1 p_2 =
            if (p_2 = length_2 && p_1 <> length_1) then 
                false
            else if p_1 = length_1 then
                true
            else
                match (m1.[p_1] = m2.[p_2]) with
                | true -> check (p_1+1) (p_2+1)
                | false -> check (0) (p_2+1)
                
        in 
        check 0 0

    

(* Ex 4*)
(* 
    The merge sort algorithm sorts a list by applying the following principle:
    (i) cut the list into two roughly equal parts;
    (ii) recursively sort each of the two obtained lists;
    (iii) merge the two sorted lists while preserving the order.

    Write the functions
    (a) split such that split l returns two lists obtained by sharing the elements of the list l
    in a manner as balanced as possible;

    (b) merge such that merge l1 l2 returns a list containing the elements of the lists l1 and
    l2 sorted in ascending order, assuming that each of the lists l1 and l2 passed as a
    parameter is itself sorted in ascending order;

    (c) sort such that sort l returns a list containing the elements of the list l sorted in
    ascending order 
*)

(*NOTE:
    Seem like the list in ocaml imp by link list(?),
    and it performance not that great,
    so that change to array will be batter, but assignment require the "list"
*)
let split l = 
    let a = Array.of_list l in
    let len = Array.length a in
    let ll = Array.sub a 0 (len / 2) |> Array.to_list in
    let rl = Array.sub a (len / 2) (len - len/2) 
            |> Array.to_list 
    in
    (ll,rl)


let merge l1 l2 = 
    let rec compare rl1 rl2 result =
        match rl1, rl2 with
        | [], rest | rest, [] -> List.rev_append rest result 
                                 |> List.rev    
        | l1h::l1t, l2h::l2t -> 
                match l1h > l2h with
                | true -> compare rl1 l2t (l2h :: result)
                | false -> compare rl2 l1t (l1h :: result)
    in
    compare l1 l2 []

(* 
 TODO:  No idea about how to tail recursively simply,
        and I think this clean.
 *)
let rec sort l =
    match l with 
    | [] -> []
    | [x] -> [x]
    | _ -> 
            let (ll,rl) = split l 
            in
            merge (sort ll) (sort rl)



(*Ex 5*)
(*
    (a) square_sum such that square_sum l returns the sum of the square of the integers in the
    list l.
*)



(*
    (b) find_opt such that find_opt x l returns Some i if the element x appears in the index
    i of the list l (but not before), and None if x does not appear in the list l
 *)


(*
(*Rec version *)
let square_sum l=
    let rec aux l sum =
        match l with
        | [] -> sum
        | h::rl -> aux rl (sum + h * h)
    in 
    aux l 0
let find_opt x l =
    let rec iter i rl=
        match rl with
        | h::next -> if h == x then Some i else iter (i+1) next
        | [] -> None 
    in
    iter 0 l
*)

(*
    Redo the exercise without using the keyword rec. To replace it, use and abuse the functions
    in the OCaml library List.
*)

let square_sum l =
    List.fold_left (fun acc x -> acc + x*x) 0 l

(* NOTE: Should pass negative int in ()*)
let find_opt x l =
    List.find_index (fun a -> a = x) l

(*Ex 6*)
(*
    Create a list l containing in order the positive integers from zero to one million. Then write
    functions rev and map corresponding to the functions List.rev and List.map from OCaml.
    You will need to make these functions applicable to the previous list l without causing a
    stack overflow. Bonus. Rewrite the functions from the previous exercises to make them tail
    recursive, if relevant
*)

let rev l =
    let rec aux l acc =
        match l with
        | [] -> acc
        | h::rl -> aux rl (h :: acc)
    in 
    aux l []

let map f l =
    let rec aux f l acc = 
        match l with
        | [] -> rev acc
        | h::rl -> (aux f rl ((f h)::acc)) 
    in
    aux f l []


(*Ex 7*)

(* a *)
type 'a seq = 
    | Elt of 'a
    | Seq of 'a seq * 'a seq

let (@@) x y = Seq(x, y)

let rec hd s =
    match s with
    | Elt(a) -> a
    | Seq(a, b) -> hd a

let rec tl s =
    match s with
    | Elt _ -> failwith "Single Elt so no tl"
    | Seq (Elt _, right) -> right
    | Seq (left, right) -> Seq(tl left, right)

let rec mem a s =
    let rec aux a s b =
        match s with
        | Elt (i)-> a = i || b
        | Seq (l, r) -> aux a l (aux a r b)
    in
    aux a s false

let rec rev s =
    match s with
    | Elt a -> s
    | Seq(Elt l, r) -> Seq(rev r, Elt l)
    | Seq(l,Elt r) -> Seq(Elt r, rev l)
    | Seq(a, b) -> Seq(b, a)

let rec map f s =
    match s with
    | Elt a -> Elt (f a)
    | Seq(l, r) -> Seq(map f l, map f r)

let fold_left f init s =
    let rec aux s t = 
        match s with
        | Elt a -> f t a
        | Seq(l, r) -> aux r (aux l t) 
    in
    aux s init

let fold_right f s init =
    let rec aux s t =
        match s with
        | Elt a -> f a t
        | Seq(l, r) -> aux l (aux r t) 
    in
    aux s init


(* b *)
let seq2list s = 
    let rec aux s t = 
        match s with
        | Elt(a) -> a :: t
        | Seq(l, r) -> aux l (aux r t)
    in
    aux s []

(* c *)
let find_opt x l =
    let rec aux x l i =
        match l with
        | Elt(a) -> if a = x then (Some i, i +1) else (None, i+1)
        | Seq(ll, r) -> 
                match (aux x ll i) with
                | (Some(x), n) -> (Some i, n)
                | (None, n) -> aux x r n
    in
    let (o,_) = aux x l 0
    in
    o 

(* d *)
let nth s n =
    if  n < 0 then
        failwith "Index Not Suit"
    else
        let rec aux ti s i =
            match (ti = i) with
            | true -> hd s
            | false -> 
                    try
                        let t = tl s in
                        aux ti t (i+1) 
                    with
                    | _ -> failwith "Index Not Suit"
        in 
        aux n s 0
        

type 'a seq = 
    | Elt of 'a
    | Seq of int * 'a seq * 'a seq

(*
 After Change the Seq def, we need to update all pattern match.
 And add a function to fast get seq size.
 Following is nth and (@@) implement.
 It use the Something like binary Search.
 *)
let getSeqSize s =
        match s with
        | Elt _ -> 1
        | Seq(size,_,_) -> size

let (@@) x y = 
    Seq((getSeqSize x + getSeqSize y), x, y)

(*
 Seem like a B_Search, 
 if n < 0 || n > maxSize -> returns
 match s in
| Elt(a) -> a
| Seq(l, r) -> if (getSeqSize l) = n 
    then search l n acc 
    else search r n (acc + getSeqSize r)
 *)
let nth s n =
    if n < 0 || n >= getSeqSize s then
        failwith "Index Not Suit"
    else
    let rec aux s n acc =
        match s with
        | Elt(a) -> a
        | Seq(_, l, r) -> 
                let sizel = acc + (getSeqSize l) in
                if sizel > n
                then aux l n acc 
                else aux r n (acc+sizel)
    in
    aux s n 0

