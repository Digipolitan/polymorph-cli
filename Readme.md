PolymorphCLI
============

# PROJECT

## CREATE

### OPTIONS

* name *String* **required**
* package *String* **required**
* copyright *String*
* author *String*
* documentation *String*
* file *String* [polymorph.json]

### SHORT OPTIONS

* package : *-p*
* copyright : *-c*
* author : *-a*
* documentation : *-d*
* file : *-f*

### USAGE

```bash
$ polymorph init {name} --package {value} [--copyright {value}] [--author {value}] [--documentation {value}] [--file {value}]
```

## SELECT

### OPTIONS

* file *String* [polymorph.json]

### USAGE

```bash
$ polymorph [{file}]
```

## UDPATE

If you want to update project fields use command as follow **field = value** after execute polymorph command line, only the **file field cannot be updated** (use verbose options)

```bash
$ name {value}
```

```bash
$ package {value}
```

## DELETE

To remove a polymorph project execute the **rm** command

### OPTIONS

* file *String* [polymorph.json]

### USAGE

```bash
$ polymorph rm [{file}]
```

# MODELS

## CLASSES

### CREATE

Create class unsing **class new** command line after execute **polymorph** command line, when you create a new class, the class is automatically selected

#### OPTIONS

* name *String* **required**
* package *String* **required**
* extends *String*
* serializable *Boolean* [false]
* documentation *String*

#### SHORT OPTIONS

* package : *-p*
* extends : *-e*
* serializable: *-s*
* documentation : *-d*

#### USAGE

```bash
$ class new {name} --package {value} [--extends {value}] [--serializable] [--documentation {value}]
```

### UPDATE

If you want to update class fields use command as follow **field = value** after execute **use** command line as follow : (use verbose options)

```bash
$ class use {name}
$ extends {value}
$ serializable {value}
```

To validate class update execute **commit** command, to cancel **rollback** command

```bash
$ commit
```

### DELETE

To remove a class just execute the **rm** command

#### OPTIONS

* name *String* **required**
* replacement *String*, in case of the given is use by another one
* force *Boolean*, Deletes even if no replacement is pass, otherwise cancel removal

#### SHORT OPTIONS

* replacement: *-r*
* force : *-f*

#### USAGE

```bash
$ class rm {name} [--replacement {value}] [--force]
```

---

###  PROPERTIES

First select the class with the **use** command line

```bash
$ class use {name}
```

#### CREATE

Create properties using **property new** command line

##### OPTIONS

* name *String* **required**
* type *String* **required**
* genericTypes *[String]* ; separator
* nonnull *Boolean* [false]
* primary *Boolean* [false]
* transient *Boolean* [false]
* documentation *String*

#### SHORT OPTIONS

* genericTypes : *-gts*
* nonnull: *-nn*
* primary : *-p*
* transient : *-t*
* documentation : *-d*

##### USAGE

```bash
$ property new {name} {type} [--genericTypes {value1} {...} {valueN}] [--nonnull] [--primary] [--transient] [--documentation {value}]
```

#### UPDATE

If you want to update property fields use command as follow **field = value** after execute **use** command line as follow : (use verbose options)

```bash
$ property use {name}
$ primary true
$ nonnull false
```

#### DELETE

To delete a property execute the **rm** command as follow :

```bash
$ property rm {name}
```

### SAMPLES

i. Create a Person class with 2 properties

```bash
$ polymorph
$ class new Person --package persons
$ property new lastName String
$ property new firstName String
$ commit
```

ii. Create a User class extends Person and update a Person property

```bash
$ polymorph
$ class new User --package users --extends Person
$ property new email String
$ commit
$ class use Person
$ property use lastName
$ transient true
$ commit
```

iii. Rename the User class to PolyUser

```bash
$ polymorph
$ class use User
$ name PolyUser
$ commit
```
iv. force remove User class and cancel the transaction

```bash
$ polymorph
$ class rm User -f
$ rollback
```

## ENUMS

Create enum unsing **enum new** command line after execute **polymorph** command line, when you create a new enum, the enum is automatically selected

#### OPTIONS

* name *String* **required**
* package *String* **required**
* documentation *String*

#### SHORT OPTIONS

* package : *-p*
* documentation : *-d*

#### USAGE

```bash
$ enum new {name} --package {value} [--documentation {value}]
```

### UPDATE

If you want to update enum fields use command as follow **field = value** after execute **use** command line as follow : (use verbose options)

```bash
$ enum use {name}
$ package {value}
$ commit
```

### DELETE

To remove an enum just execute the **rm** command

#### OPTIONS

* name *String* **required**
* replacement *String*, in case of the given is use by another one
* force *Boolean*, Deletes even if no replacement is pass, otherwise cancel removal

#### SHORT OPTIONS

* replacement: *-r*
* force : *-f*

#### USAGE

```bash
$ enum rm {name} [--replacement {value}] [--force]
```

---

###  VALUES

First select the enum with the **use** command line

```bash
$ enum use {name}
```

#### CREATE

Create values using **value new** command line

##### OPTIONS

* name *String* **required**
* numeric *Int*
* documentation *String*

##### SHORT OPTIONS

* numeric : *-n*
* documentation : *-d*

##### USAGE

```bash
$ value new {name} --numeric {value} [--documentation {value}]
```

#### UPDATE

If you want to update value fields use command as follow **field = value** after execute **use** command line as follow : (use verbose options)

```bash
$ value use {name}
$ numeric 10
$ commit
```

#### DELETE

To delete an enum value execute the **rm** command as follow :

```bash
$ value rm {name}
```

### SAMPLES

i. Create a Status enum with 2 values

```bash
$ polymorph
$ enum new Status -p status
$ value new ok --numeric 200
$ value new created --numeric 201
$ commit
```

ii. Update the Status and add a new value

```bash
$ polymorph
$ enum use Status
$ value new internal_server_error --numeric 500
$ commit
```

iii. Delete the OK value of the Status enum

```bash
$ polymorph
$ enum use Status
$ value rm ok
$ commit
```

## NATIVES

Native objects cannot be updated by the user

# BUILD

Executes the **build** command to generate classes

## OPTIONS

* file *String* [polymorph.json]
* gen *[String]* [all]
* platforms *[String]* [all]

## SHORT OPTIONS

* gen : *-g*
* platforms : *-p*

## SAMPLES

```bash
$ polymorph build [{file}] -g models -p ios android
```

```bash
$ polymorph build
```

```bash
$ polymorph build -p android
```
