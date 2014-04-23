percona-toolkit
===============

Percona Toolkit Fork

<pre>
Percona Toolkit has a lot of excellent features(module), Among that pt-online-schema-change is really really useful feature as almost DBAs already experienced.

But they can't cover every requests of the world even though that is the best tool and pt-online-schema-change also.
So we modified a little bit and let pt-online-schema-change adapt for our requirements.

  1) For changing both of PRIMARY KEY change and Partitioning table.
  2) For changing columns' default value and update new default value to columns.
  3) For stable schema change, Adding sleep time between copy of chunks.

We added 4 new parameters to pt-online-schema-change for above features.

--prompt-before-copy
Same as "--ask-pass", this parameter doesn't need any value. if --prompt-before-copy specified, pt-online-schema-change will prompt (wait) user input after creating new table. If you want to check new table schema or have more chanage requirements on new table, you can use this parameter. Especially you may want to use it when change both of PRIMARY KEY and Table partitioning. But you can't change both change by one ALTER statement and also pt-online-schema-change. But you can do both task with --prompt-before-copy of patched pt-online-schema-change. 
--skip-copy-columns
pt-online-schema-change will copy all common columns on both of old and new table. So direct "ALTER TABLE .. DROP fd1, ADD fd1 NOT NULL DEFAULT 'N'" ddl statement and pt-online-schema-change's result would be different. Sometimes we need to drop all column value but column name, pt-online-schema-change is useless at this time. But you can do this with --skip-copy-columns option of patched pt-online-schema-change.
--sleep-time-us
pt-online-schema-change will control speed of row copy based on MySQL server's load(especially mysql status variables). But your query is very lightweight and fast, then pt-online-schema-chnage's rule would not be sufficient. So we made pt-online-schema-change doing sleep between each chunk of copy task by --sleep-time-us parameter. --sleep-time-us use micro seconds unit(1/1,000,000 second). And we usally set 10000(10 milli second) ~ 50000(50 milli second) as --sleep-time-us parameter.
--print-sql
Sometimes we need to check the create table and create trigger DDL ran by pt-onine-schema-change. pt-online-schema-change has debugging mode already, but it may be so verbose to you. We added --print-sql parameter to make pt-online-schema-change print out only CREATE TABLE and CREATE TRIGGER DDL.


Applied parameters would be printed out like below when you run patched pt-online-schema-change.
-- Additional parameters ----------------------------------
  >> skip columns : Not specified
  >> sleep time (us) : 50000
  >> prompting user operation : Yes
-----------------------------------------------------------

So, let's see the simple examples for 1~3 scenarios.

1) For changing both of PRIMARY KEY change and Partitioning table.

Let's say we want to change below normal table to partitioned table based on DATETIME type column (fd2).

CREATE TABLE test.test_partition (
  id INT AUTO_INCREMENT,
  fd1 VARCHAR(10),
  fd2 DATETIME,
  PRIMARY KEY(id)
) ENGINE=InnoDB;

For partitioned table, First we have to add fd2 column as part of PRIMARY KEY.
So we need to below two ALTER statement.

ALTER TABLE test.test_partition DROP PRIMARY KEY, ADD PRIMARY KEY(id, fd2);
ALTER TABLE test.test_partition PARTITION ...

But above two ALTER statement can't be combined as one statement, and also pt-online-schema-change too.
In this case, we could use --prompt-before-copy parameter on patched pt-online-schema-change.

/usr/bin/pt-online-schema-change --alter "DROP PRIMARY KEY, ADD PRIMARY KEY(id, fd2)" D=test,t=test_partition \
--no-drop-old-table \
--no-drop-new-table \
--chunk-size=500 \
--chunk-size-limit=600 \
--defaults-file=/etc/my.cnf \
--host=127.0.0.1 \
--port=3306 \
--user=root \
--ask-pass \
--progress=time,30 \
--max-load="Threads_running=100" \
--critical-load="Threads_running=1000" \
--chunk-index=PRIMARY \
--charset=UTF8MB4 \
--no-check-alter \
--sleep-time-us=50000 \
--prompt-before-copy \
--print-sql \
--execute

Like below, patched pt-online-schema-change will print out some informational messages and prompt(wait) for user confirmation, because --prompt-before-copy is specified.
...
-- Additional parameters ----------------------------------
  >> skip columns : Not specified
  >> sleep time (us) : 50000
  >> prompting user operation : Yes
-----------------------------------------------------------
...
-- Create Triggers ---------------------------------------
CREATE TRIGGER `pt_osc_test_test_partition_ins` AFTER INSERT ON `test`.`test_partition` FOR EACH ROW REPLACE INTO `test`.`_test_partition_new` ...
CREATE TRIGGER `pt_osc_test_test_partition_upd` AFTER UPDATE ON `test`.`test_partition` FOR EACH ROW REPLACE INTO `test`.`_test_partition_new` ...
CREATE TRIGGER `pt_osc_test_test_partition_del` AFTER DELETE ON `test`.`test_partition` FOR EACH ROW DELETE IGNORE FROM `test`.`_test_partition_new` WHERE `test`.`_test_partition_new`.`id` &lt;=> OLD.`id`;
----------------------------------------------------------

Table copy operation is paused temporarily by user request '--prompt-before-copy'.
pt-online-schema-change utility created new table, but not triggers.
   ==> new table name : `test`.`_test_partition_new`

So if you have any custom operation on new table, do it now.
Type 'yes', when you ready to go.
Should I continue to copy [Yes] ? : &lt;== pt-online-schema-change will wait user input after creating new table (_test_partition_new)


At this time, we can run ALTER TABLE PARTITION .. statement on another terminal. After that type "yes" on pt-online-schema-change terminal.

ALTER TABLE _test_partition_new
PARTITION BY RANGE COLUMNS(CRT_DT)
(
 ...
 PARTITION PF_20140420 VALUES LESS THAN ('2014-04-21 00:00:00') ENGINE = InnoDB,
 PARTITION PF_20140421 VALUES LESS THAN ('2014-04-22 00:00:00') ENGINE = InnoDB,
 PARTITION PF_20140422 VALUES LESS THAN ('2014-04-23 00:00:00') ENGINE = InnoDB,
 PARTITION PF_20140423 VALUES LESS THAN ('2014-04-24 00:00:00') ENGINE = InnoDB
);

All after pt-online-schema-change task would be same as original pt-online-schema-change.
Finally we can get the table applied parimary key change and partitioning with just one time of pt-online-schema-change.

Warning: pt-online-schema-change will print warning message out and just terminated when you change primary key spec. So you may want to use --no-check-alter option for change primary key. Of couse you should be careful when you change PRIMARY KEY.



2) For changing columns' default value and update new default value to columns.

Let's say we want to change default value as 'N' of fd1 column and set new defalut value ('N') to fd1 column of existing rows.
In this case pt-online-schema-change can change table schema as DEFAULT 'N', but not existing rows' column value. Because pt-online-schema-change will copy all common columns' value of new and old table.

CREATE TABLE test.test_defaultvalue (
  id INT AUTO_INCREMENT,
  fd1 CHAR(1) DEFAULT 'Y',
  fd2 DATETIME,
  PRIMARY KEY(id)
) ENGINE=InnoDB;

ALTER TABLE test.test_defaultvalue MODIFY fd1 CHAR(1) DEFAULT 'N';

UPDATE test.test_defaultvalue SET fd2='N' WHERE fd2='Y';

So original pt-online-schema-change, we have to update all row's fd2 column value as 'N', and this update will hinder service queries' concurrency (this will lock all rows of table when there's no proper index).

On patched pt-online-schema-change, we can use --skip-copy-columns parameter to prevent pt-online-schema-change from copying some common column.
Like below example, If "--skip-copy-columns='fd1'" is specified, patched pt-online-schema-change just ignore fd1 column not to copy to new table. So new table's all row will get a default value 'N'.

/usr/bin/pt-online-schema-change --alter "MODIFY fd1 CHAR(1) DEFAULT 'N'" D=test,t=test_defaultvalue \
--no-drop-old-table \
--no-drop-new-table \
--chunk-size=500 \
--chunk-size-limit=600 \
--defaults-file=/etc/my.cnf \
--host=127.0.0.1 \
--port=3306 \
--user=root \
--ask-pass \
--progress=time,30 \
--max-load="Threads_running=100" \
--critical-load="Threads_running=1000" \
--chunk-index=PRIMARY \
--charset=UTF8MB4 \
--sleep-time-us=50000 \
--skip-copy-columns='fd1' \
--prompt-before-copy \
--print-sql \
--execute

And you may use --prompt-before-copy and --print-sql options to check TRIGGER and INSERT .. SELECT .. query ran by pt-online-schema-change.


3) For stable schema change, Adding sleep time between copy of chunks.

pt-online-schema-change already has a feature to control the copy speed based on mysql server's status variables. But as I mentioned before, MySQL server's workload is CPU bound and query is sample and fast, pt-online-schema-change's feature might not be sufficient.
So on patched pt-online-schema-change, we added --sleep-time-us parameter. If you specify --sleep-time-us parameter with proper integer value, patched pt-online-schema-change will sleep specified micro seconds after each chunk.

--sleep-time-us parameter will make slower online schema change job, but you can change table schema more stable manner.
</pre>
