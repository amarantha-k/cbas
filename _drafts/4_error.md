---
layout: default
title: Errors
---

If the query processor runs into any error, it
terminates the ongoing query processing and
immediately returns an error message to the client.

A SQL++ query can potentially result in one of the following types of errors:

## <a id="Syntax_errors">Syntax Errors</a>
A valid SQL++ query must satisfy the SQL++ grammar rules.
Otherwise, a syntax error is displayed.

##### Example

    SELECT *
    FROM GleambookUsers user

Since the ending semi-colon (;) is mandatory for any SQL++ query,
the following syntax error is displayed:

    Error: Syntax error: In line 2 >>FROM GleambookUsers user<< Encountered <EOF> at column 24.
    ==> FROM GleambookUsers user

##### Example

    SELECT *
    FROM GleambookUsers user
    WHERE type="advertiser";

Since **type** is a [reserved keyword](appendix_1_keywords.html) in the SQL++ parser, the following syntax error is displayed:

    Error: Syntax error: In line 3 >>WHERE type="advertiser";<< Encountered 'type' "type" at column 7.
    ==> WHERE type="advertiser";


## <a id="Identifier_resolution_errors">Identifier Resolution Errors</a>
Referring an undefined identifier can cause an error if the identifier
cannot be successfully resolved as a valid field access.

##### Example

    SELECT *
    FROM GleambookUser user;

Let's assume you have a spelling mistake in the GleambookUser and you missed the ending *s*,
then the following identifier resolution error is displayed:

    Error: Cannot find dataset GleambookUser in dataverse Default nor an alias with name GleambookUser!

##### Example

    SELECT name, message
    FROM GleambookUsers u JOIN GleambookMessages m ON m.authorId = u.id;

If the compiler cannot figure out all possible fields in
`GleambookUsers` and `GleambookMessages`,
then an identifier resolution error is displayed:

    Error: Cannot resolve ambiguous alias reference for undefined identifier name


## <a id="Type_errors">Type Errors</a>

The SQL++ compiler does type checks based on its available type information.
In addition, the SQL++ runtime also reports type errors if a data model instance
it processes does not satisfy the type requirement.

##### Example

    abs("123");

Since function `abs` can only process numeric input values, the following type error is displayed:

    Error: Arithmetic operations are not implemented for string


## <a id="Resource_errors">Resource Errors</a>
A query can potentially exhaust system resources, such
as the number of open files and disk spaces.
For instance, the following two resource errors can be potentially seen when running the system:

    Error: no space left on device
    Error: too many open files

The *no space left on device* issue can be fixed by
cleaning up the disk space and reserving more disk space for the system.
The *too many open files* issue can be fixed by a system
administrator using
[these](https://easyengine.io/tutorials/linux/increase-open-files-limit/) instructions.
