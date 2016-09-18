# Document- and field level security

As with regular permissions, settings for document- and field-level security can be applied on index-level, meaning that you can have different settings for each index.

Document-level security basically means that you want to display only certain documents to a particular role. These "certain documents" are simply defined by a **standard Elasticsearch query**. Only documents matching this query will be visible for the role that the DLS is defined for.

In a typical use-case, you probably want to display only certain types of documents to a particular role. You can define a DLS-permission like that:

```
_dls_: '{"term" : {"_type" : "payroll"}}'
```

This grants the bearer of this permission to view documents of type `payroll`. You can also define multiple queries. If this is the case they are `OR'ed`.

Note that you can make the DSL query as complex as you want, but since it has to be executed for each query, this of course comes with a performance penalty.

Defining FLS is even simpler: You specify one or more fields that the bearer of the permissions is able to see:

```
_fls_:
        - 'firstname'
        - 'lastname'
        - 'salary'
```       

In this case the fields `firstname`, `lastname` and `salary` would be visible. You can add as many fields as you like.

**Note that DLS and FLS is applied on Lucene-level, not Elasticsearch-level. This means that the final documents handed from Lucene to Elasticsearch are already filtered according to the DLS and FLS settings for added security.**

### Examples

Please refer to the [Addendum B](addendum_b_permission settings examples.md) of this documentation for some common permission settings examples.
