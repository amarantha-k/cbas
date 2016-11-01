---
layout: default
title: SQL++ Differences from N1QL and SQL
---

SQL++ offers the following capabilities not found in N1QL:

  - JOIN:  SQL++ supports the ANSI join syntax and allows joins on any condition expressions over datasets, arrays, or subqueries;
  - GROUP BY: In SQL++, in addition to a set of aggregate functions as in standard SQL, the groups created by the
    `GROUP BY` clause are directly usable in nested queries and/or to obtain nested results;
  - Subquery: Any valid SQL++ query can be a valid subquery.


SQL++ generalizes N1QL's syntax constructs such as `USE KEYS`, `ON KEYS`, `ON KEY`, `NEST`,
`LEFT OUTER NEST` and `ARRAY` and hence relaxes the index or primary key
restrictions for acceptable queries.

Note that INSERT/UPSERT/DELETE statements are not supported in the Couchbase Analytics Service.
Data mutations must be performed using the Couchbase Server SDK or N1QL; those mutations are then automatically synchronized into the Couchbase Analytics Service via DCP.

For N1QL users, the following matrix is a quick N1QL compatibility cheat sheet for SQL++.

| Feature  |  N1QL  | SQL++ Equivalent |
|----------|--------|------------------|
| USE KEYS | ```SELECT fname, email FROM tutorial USE KEYS ["dave", "ian"];```  | ```SELECT fname, email FROM tutorial WHERE meta().id IN ["dave", "ian"];```  |
| ON KEYS | ```SELECT * FROM user u JOIN orders o ON KEYS ARRAY s.order_id FOR s IN u.order_history END; ``` | ```SELECT * FROM user u, u.order_history s JOIN orders o ON s.order_id = meta(o).id;``` |
| ON KEY | ```SELECT * FROM user u JOIN orders o ON KEY o.user_id FOR u;```  | ```SELECT * FROM user u JOIN orders o ON meta(u).id = o.user_id;``` |
| NEST   | ```SELECT * FROM user u NEST orders orders ON KEYS ARRAY s.order_id FOR s IN u.order_history END;```       | ```SELECT u, orders FROM users u LET orders=(SELECT VALUE o FROM u.order_history s, orders o WHERE meta(o).id = s.order_id) WHERE EXISTS orders;```|
| LEFT OUTER NEST   | ```SELECT * FROM user u LEFT OUTER NEST orders orders ON KEYS ARRAY s.order_id FOR s IN u.order_history END;```       | ```SELECT u, (SELECT VALUE o FROM u.order_history s, orders o WHERE meta(o).id = s.order_id) orders FROM users u;```|
| IS VALUED |  ```foo is VALUED```  | ```foo IS NOT UNKNOWN``` |
| ARRAY |  ```ARRAY i FOR i IN [1, 2] END```   |  ```(SELECT VALUE i FROM [1, 2] AS i)``` |
| ARRAY FIRST |  ```ARRAY FIRST arr```       |    ```arr[0]```       |
| INSERT/UPSERT/DELETE |  Supported  | Unsupported |
| CREATE INDEX |  Supported  | Unsupported |
| [Querying system info](http://developer.couchbase.com/documentation/server/current/n1ql/n1ql-intro/sysinfo.html) | ```SELECT * FROM Metadata.`Dataverse`;``` | ```SELECT * FROM system:namespaces;``` | 
|  | ```SELECT * FROM Metadata.`Dataset`;``` | ```SELECT * FROM system:keyspaces;``` |
|  | ```SELECT * FROM Metadata.`Index`;``` | ```SELECT * FROM system:indexes;``` |

## Differences from SQL

|  Operator  |  SQL  | SQL++ / N1QL Equivalent |
|------------|-------|-------------------------|		
| IN | ```SELECT * FROM default_shadow WHERE  id IN (“1”, “2”);``` | ```SELECT * FROM default_shadow WHERE  id IN [“1”, “2”];``` |
| DISTINCT Aggregate | ```SELECT job_title, (SELECT value ds.NAME FROM default_shadow ds GROUP  BY ds.NAME) AS names FROM default_shadow GROUP BY job_title;``` | ```SELECT job_title, Array_agg(DISTINCT NAME) AS names FROM default_shadow GROUP  BY job_title;``` |
