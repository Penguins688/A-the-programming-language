# The A programming language

- **Lua**: This project was made with Lua 5.4.7.

## Compiling

**To compile without showing the compiled output run:**

```console
lua a.lua <.a filepath>
```

**To see the compiled output run:**

```console
lua a.lua <.a filepath> --debug
```

## Syntax

### Printing

**The print function is exactly like python but with a semi-colon**

```java
print("hello guys");
```

**There is no concatenation but you can print variables and numbers**

```java
var x = "hi";

print(x);
print(3);
```

**Expressions are also supported**

```java
print(3 + 5);
```

### Variables

**Variables can be declared with the var keyword**

```javascript
var x = 3;
```

**Currently boolean values aren't supported, but you can set a variable to a string**

```javascript
var x = "hello";
```

### Functions

**Functions are like the syntax in Javascript except with a few changes**

```javascript
function example = {

}
```

**To delclare a function all you need it the function's name**

```javascript
function example = {

}

example;
```

**There is no function parameters or return statements yet, but they can be added in a future update**

### If conditions

**If conditions have basically the same syntax as Javascrip except without the weird triple equals**

```java
if (1 == 1) {

}
```

**There are currently no else statements but those can be added in a future update**

### While loops

**While loops are also heavily inspired by the Javascript syntax**

```java
while (1 == 1) {
  
}
```

**You can also use the break keyword to break out of the while loop**

```java
var x = 0;

while (x < 10) {
  if (x == 5) {
    break;
  }

  print(x);
  x = x + 1;
}
```
