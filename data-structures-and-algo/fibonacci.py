# https://www.geeksforgeeks.org/program-for-nth-fibonacci-number/

def fibonacci(n):
    if n <0: 
        raise TypeError("Only positive numbers allowed")
    elif n==0: 
        return 0
    elif n==1:
        return 1
    else:
        f = fibonacci(n-1) + fibonacci(n-2)
        print(n, f)
        return f

print(fibonacci(5))



#                           fib(5)   
#                      /                \
#                fib(4)                fib(3)   
#              /        \              /       \ 
#          fib(3)      fib(2)         fib(2)   fib(1)
#         /    \       /    \        /      \
#   fib(2)   fib(1)  fib(1) fib(0) fib(1) fib(0)
#   /     \
# fib(1) fib(0)