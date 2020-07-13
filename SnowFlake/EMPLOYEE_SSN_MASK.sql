//Set-up demo:
use DEMO_DB;
use warehouse COMPUTE_WH;
create or replace table PUBLIC.EMPLOYEE (
    ID integer not NULL
  , PHONE VARCHAR(20) not NULL
  , SSN VARCHAR(20) not NULL
);
insert into PUBLIC.EMPLOYEE (
    ID
  , PHONE
  , SSN
)
values
    (
      101
      , '111-222-3333'
      , '123-456-789'
    )
    , (
      102
      , '444-555-6666'
      , '987-654-321'
    )
    , (
      103
      , '777-888-9999'
      , '123-123-123'
    );
select * from PUBLIC.EMPLOYEE;
//Plain old view:
create or replace view PUBLIC.EMPLOYEE_VIEW as
    select
        PE.ID
        , PE.PHONE
        , PE.SSN
    from
        PUBLIC.EMPLOYEE PE;
select * from PUBLIC.EMPLOYEE_VIEW;
//Create masking policy and apply it to SSN column in PUBLIC.EMPLOYEE table:
create or replace masking policy EMPLOYEE_SSN_MASK as (val string) returns string ->
  case
    when CURRENT_ROLE() in ('ACCOUNTADMIN') then val
    else '******'
  end;  
alter table if exists PUBLIC.EMPLOYEE
    modify column SSN set masking policy EMPLOYEE_SSN_MASK;
select * from PUBLIC.EMPLOYEE;
select * from PUBLIC.EMPLOYEE where SSN = '123-456-789';
select * from PUBLIC.EMPLOYEE where SSN = '******';
select * from PUBLIC.EMPLOYEE_VIEW;
select * from PUBLIC.EMPLOYEE_VIEW where SSN = '123-456-789';
select * from PUBLIC.EMPLOYEE_VIEW where SSN = '******';
use role ACCOUNTADMIN;
select * from PUBLIC.EMPLOYEE;
select * from PUBLIC.EMPLOYEE where SSN = '123-456-789';
select * from PUBLIC.EMPLOYEE where SSN = '******';
select * from PUBLIC.EMPLOYEE_VIEW;
select * from PUBLIC.EMPLOYEE_VIEW where SSN = '123-456-789';
select * from PUBLIC.EMPLOYEE_VIEW where SSN = '******';
//Apply masking to view instead:
use role SYSADMIN;
alter table if exists PUBLIC.EMPLOYEE
    modify column SSN unset masking policy;
select * from PUBLIC.EMPLOYEE;
alter view PUBLIC.EMPLOYEE_VIEW
    modify column SSN set masking policy EMPLOYEE_SSN_MASK;
select * from PUBLIC.EMPLOYEE;
select * from PUBLIC.EMPLOYEE_VIEW;
select * from PUBLIC.EMPLOYEE_VIEW where SSN = '123-456-789';
select * from PUBLIC.EMPLOYEE_VIEW where SSN = '******';
use role ACCOUNTADMIN;
select * from PUBLIC.EMPLOYEE_VIEW;
select * from PUBLIC.EMPLOYEE_VIEW where SSN = '123-456-789';
select * from PUBLIC.EMPLOYEE_VIEW where SSN = '******';
//Clean-up demo:
use role SYSADMIN;
drop view if exists PUBLIC.EMPLOYEE_VIEW;
drop table if exists PUBLIC.EMPLOYEE;
drop masking policy if exists EMPLOYEE_SSN_MASK;