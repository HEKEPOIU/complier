data Binop = Add | Mul

data Expr
  = Cte Int
  | Var String
  | Bin Binop Expr Expr

expr = Bin Mul (Cte 2) (Bin Add (Var "x") (Cte 1))
