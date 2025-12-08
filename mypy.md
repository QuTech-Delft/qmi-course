---
title: "Good coding practises: MyPy"
output: html_document
teaching: 10
exercises: 10
---

::: questions
-   What is MyPy and why is it used?
-   How do I code such that MyPy pipelines pass?
:::

::: objectives
-   Learn to code taking into account MyPy typing requirements
:::

## MyPy

In the IMSEP course some [clean code tools](https://qutech-delft.github.io/imsep/clean-code.html#clean-code-tools), which are also employed for QMI, are explained, like PyLint and Coverage. Another common tool we employ, not mentioned in the course, is [MyPy](https://mypy-lang.org/). One of the factors that make Python easier to start with coding, compared to e.g. C/C++ code is that the *type* of a variable does not need to be declared. Like, when we declare a variable that should be a floating point number in C, the variable can really be assigned only with a floating point number and nothing else. Trying to give it an integer value will result in an error. Python doesn’t care and lets you do it. While it gives flexibility (floating points and integers are both numbers, right?), it also poses danger. What if the variable accidentally is a string “1.5”, if for example read from a file? This certainly will raise an error when trying to do mathematical operations with it.

Using typing together with an advanced IDE, like PyCharm, can notice this kind issues and warn you in the editor: If the return type of the value read from a file is typed as a *string* while your variable you read it into is typed as *float*, the editor will notice this and warn you with a squiggly line under it or some other way. But, it doesn’t force you to fix it. While checking the code with MyPy will raise an error for this line of code telling you to fix the problem. The QMI’s CI pipeline for the code pushed into the repository won’t pass before the issue is fixed – and also does not let the code to be allowed to be merged back to origin.

This whole MyPy check might feel as an unnecessary nuisance at start, but when the code base gets larger and also the code includes all colours and flavours of variable types, even some really exotic ones, the typing can save you from making hard-to-trace bugs already before committing the code back to the repository. To be really honest, probably every developer does see the advantage of MyPy and at the same time be annoyed by it. MyPy also evolves over time and it often happens that a typing construction made years ago, which passed any MyPy check without issues, suddenly stops passing after a new MyPy version release. These can sometimes lead into lengthy problem-solving issue tickets, but just keep thinking it is for the greater good…

Modern typing with built-in classes is simple and out-of-the-box:

``` python
fraction: float = 0.92
eggs: int = 5
colour: str = “blue”
guests: list[str] = [“Charly”, “Douwe”, “Ebat”]
```

Functions should be typed too:

``` python
def summer_fun(a: int | float, b: int | float) -> int | float:
    sum = a + b
    return sum
```

The function `summer_fun` expects two inputs that should be either a floating point or integer numbers. The return value is the sum of the two and can also be either floating point or integer number. If you have somewhere else in your code:

``` python
a = input(“Give number a: “)
b = input(“Give number b: “)
sum = summer_fun(a, b)
```

The user might get surprised that after giving number a as 1 and number b as 2, the sum is 12! How did that happen? Well, the reason is that `input` returns the given answer always as a string. And summing two strings, like “a” and “b” is simply “ab”. So, the code works but it does the wrong thing. But, as we have typed the `summer_fun`, inspecting the code with an IDE that also checks typing would give warnings here. And running a MyPy check on this could would give an error telling that the input values “a” and “b” are of type *str* (strings), while it expected type *int* or *float* for them. So the error could have passed unnoticed if no type checking was done. The solution would be to cast the `input` values either as an *int* (will crash if a decimal value is inputted!) or *float* before or at the function call to `summer_fun`.

::::::: Challenge
Let’s do some exercises with typing.

Install MyPy:

``` shell
pip install mypy
```

Create a program with following code:

``` python
def summer_fun(a: int, b: int) -> int:
    sum = a + b
    return sum

debts: str = -100.00
alice_has = input("How much money does Alice have?\n > ")
bob_has = input("How much money does Bob have?\n > ")
alice_and_bob_have = summer_func(alice_has, bob_has)
left_sum: int = debts + alice_and_bob_have
print(f"Alice and Bob have together {alice_and_bob_have:0.2f} of money.")
print(f"They need to pay {-debts:0.2f} money.")
if left_sum > 0:
    print(f"Alice and Bob have enough money and are left with {left_sum:0.2f} money.")
elif left_sum < 0:
    print(f"Alice and Bob do not have enough money and need {-left_sum:0.2f} more.")
else:
    print(f"Alice and Bob have exactly enough money to pay their debts.")
```

Run MyPy check on the program

``` shell
mypy alice_and_bob_in_debts.py
```

``` output
mypy_exercise.py:5: error: Incompatible types in assignment (expression has type "float", variable has type "str")  [assignment]
mypy_exercise.py:8: error: Argument 1 to "summer_fun" has incompatible type "str"; expected "int"  [arg-type]
mypy_exercise.py:8: error: Argument 2 to "summer_fun" has incompatible type "str"; expected "int"  [arg-type]
mypy_exercise.py:9: error: Unsupported operand types for + ("str" and "int")  [operator]
mypy_exercise.py:11: error: Unsupported operand type for unary - ("str")  [operator]
Found 5 errors in 1 file (checked 1 source file)
```

If you made the program with a nice IDE like PyCharm, probably some squiggly lines also appear on the same lines where MyPy raised the errors, indicating where the errors are.

> Exercise 1: Now, with the help of MyPy and/or IDE, can you identify the issues in the code?

::: instructor
The MyPy output tells us the typing of variable `debts` is wrong: it is annotated as a *str* but the value is a *float*. The call to `summer_fun` has also problems. This is because `input` call returns always a string. The 4th line of Mypy error now shows that we cannot add together `debts` and a supposed *int* return value from `summer_fun`. The last line means that we cannot take a 'minus' of a string.
:::

> Exercise 2: Now let's assume you try to correct the issues by changing the annotation of `debts` to *float*, and casting the inputs to `summer_fun` as integers using `alice_has = int(alice_has)` and `bob_has = int(bob_has)`. You see the same amount of errors! Why?

::: instructor
``` output
mypy_exercise.py:8: error: Incompatible types in assignment (expression has type "int", variable has type "str")  [assignment]
mypy_exercise.py:9: error: Incompatible types in assignment (expression has type "int", variable has type "str")  [assignment]
mypy_exercise.py:10: error: Argument 1 to "summer_fun" has incompatible type "str"; expected "int"  [arg-type]
mypy_exercise.py:10: error: Argument 2 to "summer_fun" has incompatible type "str"; expected "int"  [arg-type]
mypy_exercise.py:11: error: Incompatible types in assignment (expression has type "float", variable has type "int")  [assignment]
Found 5 errors in 1 file (checked 1 source file)
```

The variables `alice_has` and `bob_has` are still typed as the original type, *str* even after casting. Instead of changing the variable assignment, MyPy warns that you are doing something potentially harmful and errors out. Therefore the `summer_fun` input argument errors did not go away, either. The last error is also new: Now Mypy complains that, `left_sum` being annotated as an *int*, the sum of `debts` and `alice_and_bob_have` will be *float*.
:::

So we realize that the casting went wrong, and that there is an issue with typing assignment due to some values typed as *float* and others as *int*.

> Exercise 3: OK, let's fix this further by doing the casting directly in the function call, without reassigning the `alice_has` and `bob_has`. We also cast the `debts` in the summation as an *int*. What does MyPy say now? Will the code work?

::: instructor
Mypy says now `Success: no issues found in 1 source file`. Also, the code will run if the user inputs whole numbers. Notably, the print-outs also work, giving the values with two decimal accuracy like indicated by the `:0.2f` formatter in the strings. But all is not well here. What if you want to use a decimal value for 'money', like 30.1? You get an exception out:

``` output
Traceback (most recent call last):
  File "mypy_exercise.py", line 8, in <module>
    alice_and_bob_have = summer_fun(int(alice_has), int(bob_has))
                                    ~~~^^^^^^^^^^^
ValueError: invalid literal for int() with base 10: '30.1'
```
:::

::: solution
So, the code works, but only with whole numbers and not with decimals. To fix this we can use the fact that Python can cast directly to float both integer and decimal input strings. Now, cast the `alice_has` and `bob_has` into *float*s. We should also allow the `summer_fun` input parameters be *float*s and return a *float* as well. Then as last step the `left_sum` should also be typed as a *float* and no casting of `debts` should be done.
:::
:::::::

::: keypoints
-   MyPy is a tool to check *typing* in code
-   Using *typing* can reveal coding errors like mis- or double use of same variable leading to exceptions in code execution
-   A good IDE can help to find typing (and other coding) issues
-   Mypy does not check typing for string formatting
:::
