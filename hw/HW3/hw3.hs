{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use camelCase" #-}

import Control.Exception (assert)
import Control.Monad (unless)
import Control.Monad.ST (runST)
import Data.Map qualified as Map
import Data.STRef (STRef, newSTRef, readSTRef, writeSTRef)
import Data.Set qualified as Set
import Text.Printf (printf)
import Distribution.Compat.CharParsing (endBy)
import GHC.Generics (Associativity(NotAssociative))
import System.Console.Haskeline (Settings(complete))

type IChar = (Char, Int)

data Regexp
  = Epsilon
  | Character IChar -- a
  | Union (Regexp, Regexp) -- (a|b)
  | Concat (Regexp, Regexp) -- ab
  | Star Regexp -- a*

type Cset = Set.Set IChar

type State = Cset

type Cmap = Map.Map Char

type Smap = Map.Map Cset

data Autom = Autom
  { start :: State,
    trans :: Smap (Cmap State)
  }
  deriving (Show)

null :: Regexp -> Bool
null r =
  case r of
    Epsilon -> True
    Star _ -> True
    Character _ -> False
    Union (r1, r2) -> Main.null r1 || Main.null r2
    Concat (r1, r2) -> Main.null r1 && Main.null r2

first :: Regexp -> Cset
first r =
  case r of
    Epsilon -> Set.empty
    Character a -> Set.singleton a
    Union (r1, r2) -> Set.union (first r1) (first r2)
    Concat (r1, r2) -> if Main.null r1 then Set.union (first r1) (first r2) else first r1
    Star r -> first r

last :: Regexp -> Cset
last r =
  case r of
    Epsilon -> Set.empty
    Character a -> Set.singleton a
    Union (r1, r2) -> Set.union (Main.last r1) (Main.last r2)
    Concat (r1, r2) -> if Main.null r2 then Set.union (Main.last r1) (Main.last r2) else Main.last r2
    Star r -> Main.last r

follow :: IChar -> Regexp -> Cset
follow c Epsilon = Set.empty
follow c (Character a) = Set.empty
follow c (Union (r1, r2)) = Set.unions [follow c r1, follow c r2]
follow c (Concat (r1, r2)) =
  if Set.member c (Main.last r1)
    then Set.unions [follow c r1, follow c r2, first r2]
    else Set.unions [follow c r1, follow c r2]
follow c (Star r) =
  if Set.member c (Main.last r)
    then Set.unions [follow c r, first r]
    else follow c r

next_state :: Regexp -> State -> Char -> State
next_state r q c =
  Set.foldl
    ( \acc ci@(c', _) ->
        if c' == c
          then Set.union (follow ci r) acc
          else acc
    )
    Set.empty
    q

eof :: IChar
eof = ('#', -1)

make_dfa :: Regexp -> Autom
make_dfa r =
  let
      r' = Concat (r, Character eof)
      q0 = first r'
      transitions q ref = do
        t <- readSTRef ref
        unless
          (Map.member q t) -- is state check before(Check map)
          ( do
              -- If Not Try to find all trans
              writeSTRef ref (Map.insert q currentAllTrans t) -- add all transitions to map
              mapM_ (`transitions` ref) currentAllTrans -- recheck next all states
          )
        where
          currentAllTrans =
            Set.foldl
              ( \acc' (c, _) ->
                  let q' = next_state r' q c
                   in Map.insert c q' acc'
              )
              Map.empty
              q
      trans = runST $ do
        ref <- newSTRef Map.empty
        transitions q0 ref
        readSTRef ref
   in Autom {start = q0, trans = trans}

fprintState :: State -> String
fprintState = Set.foldl print' ""
  where
    print' acc (c, i) =
      acc
        <> ( if c == '#'
               then "# "
               else printf "%c%i " c i
           )

fprintTransition :: State -> Char -> State -> String
fprintTransition q c q' =
  printf
    "\"%s\" -> \"%s\" [label=\"%c\"];\n"
    (fprintState q)
    (fprintState q')
    c

fprintAutom :: Autom -> String
fprintAutom a =
  "digraph A {\n"
    <> printf " \"%s\" [ shape = \"rect\"];\n" (fprintState (start a))
    <> Map.foldlWithKey print' "" (trans a)
    <> "\n}"
  where
    print' acc q t = acc <> Map.foldlWithKey print'' "" t
      where
        print'' acc' c q' = acc' <> fprintTransition q c q'

recognize :: Autom -> String -> Bool
recognize a s = isFinal end
    where
        end = foldl aux (Just (start a)) s

        isFinal :: Maybe State -> Bool
        isFinal (Just q) = Set.member eof q
        isFinal Nothing = False

        aux :: Maybe State -> Char -> Maybe State
        aux (Just q) c = do
            q's <- Map.lookup q (trans a) -- Find All States that current state can attach
            Map.lookup c q's -- Find is available state to change, if not just Nothing
        aux Nothing _ = Nothing 
        

main :: IO ()
main =
  do
    let a = Character ('a', 0)
    _ <- assert (not (Main.null a)) (return ())
    _ <- assert (Main.null (Star a)) (return ())
    _ <- assert (Main.null (Concat (Epsilon, Star Epsilon))) (return ())
    _ <- assert (Main.null (Union (Epsilon, a))) (return ())
    _ <- assert (not (Main.null (Concat (a, Star a)))) (return ())

    -- Ex 2
    let ca = ('a', 0)
        cb = ('b', 0)
    let a = Character ca
        b = Character cb
    let ab = Concat (a, b)

    _ <- assert (first a == Set.singleton ca) (return ())
    _ <- assert (first ab == Set.singleton ca) (return ())
    _ <- assert (first (Star ab) == Set.singleton ca) (return ())
    _ <- assert (Main.last b == Set.singleton cb) (return ())
    _ <- assert (Main.last ab == Set.singleton cb) (return ())
    _ <- assert (Set.size (first (Union (a, b))) == 2) (return ())
    _ <- assert (Set.size (first (Concat (Star a, b))) == 2) (return ())
    _ <- assert (Set.size (Main.last (Concat (a, Star b))) == 2) (return ())

    -- Ex 3

    _ <- assert (follow ca ab == Set.singleton cb) (return ())
    _ <- assert (Set.null (follow cb ab)) (return ())

    let r = Star (Union (a, b))

    _ <- assert (Set.size (follow ca r) == 2) (return ())
    _ <- assert (Set.size (follow cb r) == 2) (return ())

    let r2 = Star (Concat (a, Star b))

    _ <- assert (Set.size (follow cb r2) == 2) (return ())

    let r3 = Concat (Star a, b)

    _ <- assert (Set.size (follow ca r3) == 2) (return ())

    -- ex4
    -- (a|b)*a(a|b)
    let e1 = Concat (Star (Union (Character ('a', 1), Character ('b', 1))), Concat (Character ('a', 2), Union (Character ('a', 3), Character ('b', 2))))

    let a1 = make_dfa e1
    putStrLn $ fprintAutom a1
    writeFile "autom.dot" $ fprintAutom a1

    -- ex5
    _ <- assert (recognize a1 "aa") (return())
    _ <- assert (recognize a1 "ab") (return())
    _ <- assert (recognize a1 "abababaab") (return())
    _ <- assert (recognize a1 "babababab") (return())
    _ <- assert (recognize a1 $ replicate 1000 'b' <> "ab") (return())
    _ <- assert (not $ recognize a1 "") (return())
    _ <- assert (not $ recognize a1 "a") (return())
    _ <- assert (not $ recognize a1 "b") (return())
    _ <- assert (not $ recognize a1 "ba") (return())
    _ <- assert (not $ recognize a1 "aba") (return())
    _ <- assert (not $ recognize a1 "abababaaba") (return())

    -- (a*|ba*b)*
    let e2 = Star (Union (Star (Character ('a', 1)), Concat (Character ('b', 1), Concat (Star (Character ('a', 2)), Character ('b', 2))) ))
        
    let a2 = make_dfa e2
    putStrLn $ fprintAutom a2
    -- writeFile "autom2.dot" $ fprintAutom a2

    _ <- assert (recognize a2 "") (return())
    _ <- assert (recognize a2 "bb") (return())
    _ <- assert (recognize a2 "aaa") (return())
    _ <- assert (recognize a2 "aaabbaaababaaa") (return())
    _ <- assert (recognize a2 "bbbbbbbbbbbbbb") (return())
    _ <- assert (recognize a2 "bbbbabbbbabbbabbb") (return())
    _ <- assert (not $ recognize a2 "b") (return())
    _ <- assert (not $ recognize a2 "ba") (return())
    _ <- assert (not $ recognize a2 "ab") (return())
    _ <- assert (not $ recognize a2 "aaabbaaaaabaaa") (return())
    _ <- assert (not $ recognize a2 "bbbbbbbbbbbbb") (return())
    _ <- assert (not $ recognize a2 "bbbbabbbbabbbabbbb") (return())

    putStrLn "All assertions passed!"

    putStrLn "Ex 6 are not completed, sorry."
    return ()
