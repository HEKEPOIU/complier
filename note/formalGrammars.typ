== Def of Languages in Math

$L$ are an set of string
$L(G)$ Languages of given Grammars($G$) A Languages have different way to
describe.
1. Grammars
2. Automata

$L_1 = {a^n b^n| n>=0}$

== Def of Grammars

Mathematical way to describe Languages. N(V) mean non-terminal symbols or
variables.\
T mean terminal symbols(Include constant).\
S Start variables $S in N$.\
P(R) productions Rule. $P subset.eq N * (N union T)$ (At least drive another
non-terminal)
$
  G_1 = (N, T, S, P)
$

Ex:
$
  G_1 = ({A,S}, {a,b}, S, P_1)\

  P_1 "are"\
  S -> a A b| lambda\
  A -> a A b| lambda\
  L(G_1) = L_1
$

#align(center)[
  #image("./Grammars.png", width: 50%)
]


== Regular Grammars
Non-terminal can't in center.
$
A -> a B ("Right Linear Grammars (RLG)")
A -> a

A -> B a ("Left Linear Grammars (LLG)")
A -> a
$

== Context Free Grammars
Left hand side can only have one Non-terminal.
$
A -> V^*
$

== Context Sensitive Grammars

Right hand side length must greater than or equal to Left.
$
alpha A beta -> alpha delta beta\

|a alpha beta| <= |alpha delta beta|
$

== Unrestricted Grammars
No Constrain
$
V^* N V^*->V^*
$

== Automata

Finite Automata (Finite State Machine, FSM)

DFA and NFA.
