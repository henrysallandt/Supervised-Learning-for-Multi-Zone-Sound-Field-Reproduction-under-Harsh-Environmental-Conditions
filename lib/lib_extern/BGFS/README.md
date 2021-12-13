# Quasi Newton
A matlab function for steepest descent optimization using Quasi Newton's method : BGFS & DFP. Check out **Example.m** to see how to use it.

# Summary
1. In the first step, we update the direction of the descent. As we know, the matrix H must be positively defined, which is why, in the first iteration, by the approximation H is an identity.
2. In the second step, we search linearly for the step by Armijo's criterion.
3. Now we have updated the vector x.
4. In this step, we calculate the new matrix H by both methods according to the user choice.

# Function's arguments
## Input arguments
- **fun** : This argument makes our function applicable to all types of functions, so the user must write a function to call it within this function **fun_obj** is a basic example to rosenbrock function that returns the value of function that point, the gradient at that point and the hessian at that point as well.
- **x0** : This is the first point we give our function to begin iterations.
- **nit** : This is the number of iterations.
- **eps** : This is the convergence tolerance. This helps get out of our loop when the solution has arrived.
- **method** : With this argument, the user can choose between the two methods (BGFS or DFP), for our case if method = 0 so the method applied is BGFS, and if method = 1 the method will be DFP, and if it's a number apart it's 2 number the function will return an error.

## Output arguments
- **x** : Is the vector that starts with the initial point and ends with the solution.
- **f** : This is the value of the function to the solution.
- **n** : It is the number of iterations that have been made to arrive at the solution.
