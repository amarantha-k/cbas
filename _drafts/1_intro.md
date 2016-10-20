---
layout: default
title: Introduction
---

This document is intended as a reference guide to the full syntax and semantics
of the SQL++ Query Language, a SQL-inspired language for working with
semistructured data. SQL++ has much in common with SQL, but there are also
differences due to the data model that the language is designed to serve. (SQL
was designed in the 1970's for interacting with the flat, schema-ified world of
relational databases, while SQL++ is designed for the nested,
schema-less/schema-optional world of modern NoSQL systems.) In particular,
SQL++ in the context of CBAS is intended for working with the JSON data model.

In what follows, we detail the features of the SQL++ language in a
grammar-guided manner: we list and briefly explain each of the productions in
the SQL++ grammar, offering examples (and results) for clarity.

