# Search Guard end of life policy

## Summary

The Search Guard End of Life policy defines 

* how long a release is in active development
* how long a release is supported and maintained
* how long a release receives critical security updates

The Search Guard end of life policy closely relates to the [Elasticsearch end of life policy](https://www.elastic.co/de/support/eol).

Search Guard releases that **have not reached end of life** are called **active releases**.  

Search Guard releases that **have reached end of life** are called **inactive releases**.  

## Versioning schema

The Search Guard versioning scheme is: 

* e1.e2.e3-sgv (for 5.x)
* e1.e2.e3.sgv (for 2.x)
* 
where 

* e1: Elasticsearch Major Version
* e2: Elasticsearch Minor Version
* e2: Elasticsearch Fix Version
* sgv: Search Guard Version

## Active releases

For active releases, we will provide Search Guard updates and maintenance for 

* All releases of the current minor version of the current major version
  * 5.5.0/5.5.1/5.5.2 at the time of writing
* Current release of the previous minor version of the current major version
  * 5.4.3 at the time of writing
* Last release of the previous major version (not all feature will be backported)
  * 2.4.6 at the time of writing

## Inactive releases

If a Search Guard version reaches EOL, the corresponding Elasticsearch version has reached EOL already, and customers are strongly advised to upgrade. We will not release updates for these versions, and ask customers to upgrade Search Guard alongside Elasticsearch. 

## Critical Security Fixes

Critical security fixes will be backported to all active releases, including all major, minor and bugfix releases.

## EOL dates

| Search Guard Version | End of life date |
|---|---|
2.2.x.y	| 2017-08-02 |
2.3.x.y	| 2017-09-30 |
2.4.x.y	| 2018-02-28 |
5.0.x-y	| 2018-04-26 |
5.1.x-y	| 2018-06-08 |
5.2.x-y	| 2018-07-31 |
5.3.x-y	| 2019-09-28 |
5.4.x-y	| 2019-11-04 |

## Maintenance and support overview

### As of 01.10.2017

| Search Guard Version | Active release | Search Guard Updates | Critical Security Updates
|---|---|---|---|
2.2.x.y	| no | no | no |
2.3.x.y	| no | no | no |
2.4.0-2.4.5	| yes | no | yes|
2.4.6	| yes | yes | yes |
5.0.x	| yes | no | yes |
5.1.x	| yes | no | yes |
5.2.x	| yes | no | yes |
5.3.x	| yes | no | yes|
5.4.0-5.4.2	| yes | no | yes |
5.4.3	| yes | yes | yes |
5.5.x	| yes | yes | yes |
