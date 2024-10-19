# seem like this program only allow define function in top of file.
def fact(n):
    if n <= 1:
        return 1
    return n * fact(n-1)


def fibaux(a, b, k):
    if k == 0:
        return a
    else:
        return fibaux(b, a+b, k-1)


def fib(n):
    return fibaux(0, 1, n)


# Ex 1
print("Ex 01")

print(1 + 2*3)
print((3*3 + 4*4) // 5)
print(10-3)

print(-1)

# Ex 2

print("--------------------------------------------------------")
print("Ex 02")
print(not True and 1//0 == 0)
print(1 < 2)
if False or True:
    print("ok")
else:
    print("oups")
# Ex 3

print("--------------------------------------------------------")
print("Ex 03")
x = 41
x = x+1
print(x)
b = True and False
print(b)
s = "hello" + " world!"
print(s)

print("--------------------------------------------------------")
print("Ex 04")


print(fact(10))

print("--------------------------------------------------------")
print("Ex 05")
# then one or several statements at the end of the file
print("a few values of the Fibonacci sequence:")
for n in [0, 1, 11, 42]:
    print(fib(n))


print(True == False)
print(True != False)
print(True < False)
print(True <= False)
print(True > False)
print(True >= False)
