# The A programming language

## Requirements

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

### Comments

**Only single line comments are supported**

```javascript
// This is a comment
// This is another comment
```

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

### User input

**To get user input you can use inputstr**

```java
print("enter your name");

var x = inputstr;
```

**You can also use inputnum to get a number**

```java
print("enter a number");

var x = inputnum;
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

### Lists

**Lists are basically arrays**
**To make a new list use the list key word**

```java
list example 3, 6, 7, "hi", 2;
```

**To access an item in a list use []**

```java
list example 3, 6, 7, "hi", 2;
print(example[1]);
//this prints 3 because lists have 1-based indexing
```

**To get the length of an array use #**
```java
list example 3, 6, 7, "hi", 2;
print(#example);
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

### Repeat loops

**Repeat loops are basically the same as "for i in range(X)" but just more consise**

```java
repeat(10) {
  
}
```

## Things to be added
- **Syntax highlighting**: If someone could make a VScode extension for syntax highlighting it would be appreciated.
- **Templates**: Basically classes but with a unique name.

## Changelog

- **1.0**: Initial commit.
- **1.1**: Added repeat loop and fixed bugs with strings.
- **1.2**: Added user input.
- **1.3**: Added comments.
- **1.4**: Added lists.

