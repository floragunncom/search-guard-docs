<!---
Copryight 2016 floragunn UG (haftungsbeschränkt)
-->

# Addendum B: Permission settings examples

## Defining a "read-only" role for all indices and types:

```
sg_readall:
  indices:
    '*':
      '*':
        - indices:data/read* 
```

## Defining a "read-only" role for all indices and types, but with added DLS and FLS. 

In this case the user can view all documents with type "payroll" in all indices, but only the fields firstname, lastname and salary are displayed. Uses also action groups for defining the permissions (see below):


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

## Defining permissions on multiple indices and types

Defining read permission on all indices that start with `pub`. On index `employees`, grant read and write permissions on documents of type `developers` and `employees`. For documents of type `management`, grant read-only permissions. Uses also action groups for defining the permissions (see below):

```
sg_indices_fls:
  indices:
    employees:
       developers:  
         - CRUD
       operations:  
         - CRUD
       management:  
         - READ       
    'pub*':
       '*':  
         - READ
```

## Using action groups

An action group is a named set of permissions. You can define action groups in the file `sg_action_groups.yml` and then reference them by name in `sg_roles.yml`, as shown in the examples above. Action groups can also be nested.

`sg_action_groups.yml`:

```
WRITE:
  - "indices:data/write*"
READ:
  - "indices:data/read*"
CRUD:
  - READ
  - WRITE
```