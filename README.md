# library module: http://snelson.org.uk/functions/hamt


## Table of Contents

* Functions: [is\#1](#func_is_1), [create\#0](#func_create_0), [put\#4](#func_put_4), [delete\#4](#func_delete_4), [get\#4](#func_get_4), [contains\#4](#func_contains_4), [describe\#1](#func_describe_1), [fold\#3](#func_fold_3), [count\#1](#func_count_1), [empty\#1](#func_empty_1)


## Functions

### <a name="func_is_1"/> is\#1
```xquery
is($hamt as item()
) as  xs:boolean
```

#### Params

* $hamt as  item()


#### Returns
*  xs:boolean

### <a name="func_create_0"/> create\#0
```xquery
create(
) as  item()
```

#### Returns
*  item()

### <a name="func_put_4"/> put\#4
```xquery
put(
  $hf as function(item()) as xs:integer,
  $eq as function(item(),item()) as xs:boolean,
  $hamt as item(),
  $k as item()
) as  item()
```

#### Params

* $hf as  function(item()) as xs:integer

* $eq as  function(item(),item()) as xs:boolean

* $hamt as  item()

* $k as  item()


#### Returns
*  item()

### <a name="func_delete_4"/> delete\#4
```xquery
delete(
  $hf as function(item()) as xs:integer,
  $eq as function(item(),item()) as xs:boolean,
  $hamt as item(),
  $k as item()
) as  item()
```

#### Params

* $hf as  function(item()) as xs:integer

* $eq as  function(item(),item()) as xs:boolean

* $hamt as  item()

* $k as  item()


#### Returns
*  item()

### <a name="func_get_4"/> get\#4
```xquery
get(
  $hf as function(item()) as xs:integer,
  $eq as function(item(),item()) as xs:boolean,
  $hamt as item(),
  $k as item()
) as  item()?
```

#### Params

* $hf as  function(item()) as xs:integer

* $eq as  function(item(),item()) as xs:boolean

* $hamt as  item()

* $k as  item()


#### Returns
*  item()?

### <a name="func_contains_4"/> contains\#4
```xquery
contains(
  $hf as function(item()) as xs:integer,
  $eq as function(item(),item()) as xs:boolean,
  $hamt as item(),
  $k as item()
) as  xs:boolean
```

#### Params

* $hf as  function(item()) as xs:integer

* $eq as  function(item(),item()) as xs:boolean

* $hamt as  item()

* $k as  item()


#### Returns
*  xs:boolean

### <a name="func_describe_1"/> describe\#1
```xquery
describe(
  $hamt as item()
) as  xs:string
```

#### Params

* $hamt as  item()


#### Returns
*  xs:string

### <a name="func_fold_3"/> fold\#3
```xquery
fold(
  $f as function(item()*,item()) as item()*,
  $z as item()*,
  $hamt as item()
) as  item()*
```

#### Params

* $f as  function(item()\*,item()) as item()\*

* $z as  item()\*

* $hamt as  item()


#### Returns
*  item()\*

### <a name="func_count_1"/> count\#1
```xquery
count(
  $hamt as item()
) as  xs:integer
```

#### Params

* $hamt as  item()


#### Returns
*  xs:integer

### <a name="func_empty_1"/> empty\#1
```xquery
empty(
  $hamt as item()
) as  xs:boolean
```

#### Params

* $hamt as  item()


#### Returns
*  xs:boolean





*Generated by [xquerydoc](https://github.com/xquery/xquerydoc)*
