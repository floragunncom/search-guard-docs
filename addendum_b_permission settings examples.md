<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->

# Addendum B: Permission settings examples

## Defining a "read-only" role for all indices:

```
sg_readall:
  indices:
    '*':
      '*':
        - indices:data/read* 
```

## Defining a "read-only" role for all indices, but with added DLS and FLS. 

In this case the user can view all documents with type "payroll" in all indices, but only the fields firstname, lastname and salary are displayed:


```
sg_readall_dls_fls:
  indices:
    '*':
      '*':
        - READ    
      _dls_: '{"term" : {"_type" : "payroll"}}'
      _fls_:
        - 'firstname'
        - 'lastname'
        - 'salary'
```

# Defining permissions on multiple indices and types

Defining read permission on all indices that start with "pub", and on the index "employees" for the documents of type "delopers" and "operations". For documents of type "management", only display the fields "firstname" and "lastname". Uses also action groups for defining the permissions (see next chapter).

```
sg_indices_fls:
  indices:
    employees:
       developers:  
         - READ
       operations:  
         - READ
       management:  
         - READ       
       _fls_:
          - 'firstname'
          - 'lastname'
    'pub*':
       '*':  
         - READ
```
