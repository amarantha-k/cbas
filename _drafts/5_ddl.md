---
layout: default
title: Data Definition Language (DDL)
---

## <a id="Statements">Statements</a>

    Statement       ::= ( SingleStatement ( ";" )? )* <EOF>
    SingleStatement ::= CreateStatement
                      | DropStatement
                      | ConnectStatement
                      | DisconnectStatement
                      | Query ";"

In addition to queries, the Analytics implementation of SQL++ supports statements for data definition and to connect Analytics to Couchbase buckets.

## <a id="Creating_and_dropping">Creating and Dropping</a>

    CreateStatement     ::= "CREATE" ( BucketSpecification
                                     | DatasetSpecification )

    QualifiedName       ::= Identifier ( "." Identifier )?
    DoubleQualifiedName ::= Identifier "." Identifier ( "." Identifier )?

The CREATE statement is used to create (Analytics) buckets and shadow datasets.

### <a id="Buckets">Buckets</a>

    BucketSpecification ::= "BUCKET" QualifiedName ( "WITH" RecordValue )?

    RecordValue    ::= "{" ( Pair ( "," Pair )* )? "}"
    Pair           ::= StringLiteral ":" ParameterValue
    ArrayValue     ::= "[" ( ParameterValue ( "," ParameterValue )* )? "]"
    ParameterValue ::= RecordValue
                     | ArrayValue
                     | Literal

An Analytics bucket is a proxy for a bucket on a cluster of Data Service Nodes.
It represents this bucket in all other DDL operations.
The `CREATE BUCKET` statement creates such an Analytics bucket.
Parameters for the bucket can be provided though a parameter record.
The following two parameters are supported:

- `name` a string for the name of the bucket used on the Data Service Nodes
- `nodes` an array or IP addresses or node names for the Data Service Nodes

Both parameters are optional - the default `name` is the name of the bucket and the default value for `nodes` is `[ "localhost" ]`.

##### Example

    CREATE BUCKET beerbucket WITH {
      "name": "beer-sample",
      "nodes": ["localhost"]
    };

This example creates a new (Analytics) bucket `beerbucket` that represents the bucket `beer-sample` on the Data Service Node running on `localhost`.

### <a id="Shadow_datasets">Shadow Datasets</a>

    DatasetSpecification ::= "SHADOW" "DATASET" ( QualifiedName )?
                             "ON" Identifier ( "WHERE" Expression )?

Shadow datasets contain a shadow of the data of a bucket.
They are connected to a bucket and are updated as the bucket gets updated.
A Shadow dataset can contain the full content of the dataset or a filtered subset.
Multiple shadow datasets can shadow the same bucket.
A shadow dataset is created `ON` a previously created `BUCKET` with an optional filter expression.
The name of the dataset is optional and defaults to the name of the bucket.

##### Examples

    CREATE SHADOW DATASET beers ON beerbucket WHERE type = "beer";
    CREATE SHADOW DATASET breweries ON beerbucket WHERE type = "brewery";

This example creates 2 shadow datasets `beers` and `breweries` on the previously created `beerbucket` and filters the content for each dataset by the value of the `type` field of the record.


    DropStatement ::= "DROP" ( "BUCKET" QualifiedName IfExists
                             | "DATASET" QualifiedName IfExists )
    IfExists      ::= ( "IF" "EXISTS" )?

The DROP statement in SQL++ is the inverse of the CREATE statement.
It can be used to drop buckets and shadow datasets.

The following examples illustrate some uses of the DROP statement.

##### Example

    DROP DATASET beers;
    DROP DATASET breweries;

This removes the dataset and all contained data.

##### Example

    DROP BUCKET beerbucket;

This removes the buckets.

## <a id="Connecting_and_disconnecting">Connecting and Disconnecting</a>

    ConnectStatement ::= "CONNECT" "BUCKET" QualifiedName ( "WITH" RecordValue )? ( "IF" "NOT" "CONNECTED" )?

The CONNECT statement connects a bucket to Analytics and starts shadowing all datasets that are created on the bucket.
Parameters for the connection can be provided through a parameter record.
The following two parameters are supported:

- `password ` a password for the bucket used on the Data Service Nodes
- `timeout ` a connection timeout defined in ms when connecting to the Data Service Nodes

Both parameters are optional - the default `password` is the empty string and the default `timeout` is the connect timeout used by the Couchbase Java Client.

##### Example

    CONNECT BUCKET beerbucket WITH { "password": "!@#", "timeout": 2500 };

This example connects all shadow datasets that were previously created on bucket `beerbucket` to the Data Service Nodes using `!@#` as the `password` and a `timeout` of 2500 ms.

    DisconnectStatement ::= "DISCONNECT" "BUCKET" QualifiedName  ( "IF" "CONNECTED" )?

The DISCONNECT statement is the inverse of the CONNECT statement.
It stops shadowing all datasets that were created on a BUCKET and disconnects the bucket.

##### Example

    DISCONNECT BUCKET beerbucket IF CONNECTED;

This example stops shadowing all datasets that were created on the bucket `beerbucket` and disconnects the bucket if the bucket is connected.

<!--
###Extension: Typed datasets

Or in the future case of a typed dataset - right now the type defaults to
XxxType - the syntax would be: CREATE SHADOW DATASET beers(BeerType) ON
beerbucket WHERE type = "beer";


https://docs.oracle.com/database/121/SQLRF/statements_7002.htm#SQLRF01402
http://www.ibm.com/support/knowledgecenter/SSEPEK_11.0.0/sqlref/src/tpc/db2z_sql_createtable.html
https://msdn.microsoft.com/en-us/library/ms174979.aspx
http://infocenter.sybase.com/help/index.jsp?topic=/com.sybase.infocenter.dc36272.1550/html/commands/X80969.htm
-->
