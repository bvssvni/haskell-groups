haskell-groups
==============

Group oriented programming in Haskell.  
BSD license.  
For version log, view the individual files.  

To use this library, install ![Haskell Platform](http://www.haskell.org/platform/)  

## What Is Haskell?  

Haskell is a functional or 'expression' programming language.  

![Visit Haskell.org](http://www.haskell.org/haskellwiki/Haskell)

## What Is Group Oriented Programming?  

A group is a structure where the value does not change when any member of it swap their locations.  
For example "All people in this house" has a consistent meaning as group,  
but only if no people enter or leave the house.  

A group follow Boolean algebra, two groups can be combined into new ones with 'And', 'Or' and 'Except'.  
There is a way of representing groups, that in many cases is faster than lists:  

    [0,4, 8,12]
    
The example above means "items from index 0 to 3 and 8 to 11.  
The odd indices tells when the group turns to "false".  
This representation allows one to have very large groups in little memory.  

Groups behave as a "filter" or "multi-select" of objects.  
They are useful for optimizing local operations on large amount of data with low entropy.  

