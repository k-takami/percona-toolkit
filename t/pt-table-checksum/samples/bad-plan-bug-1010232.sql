DROP DATABASE IF EXISTS bad_plan;
CREATE DATABASE bad_plan;
USE bad_plan;

CREATE TABLE t (
  `c1` smallint(5) unsigned NOT NULL,
  `c2` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `c3` smallint(5) unsigned NOT NULL DEFAULT '0',
  `c4` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`c1`,`c2`,`c3`,`c4`)
) ENGINE=InnoDB;

INSERT INTO t VALUES
(1,1,1,1),(1,1,1,2),(1,1,1,3),(1,1,1,4),(1,1,1,5),(1,1,1,6),(1,1,1,7),(1,1,1,8),(1,1,1,9),(1,1,1,10),(1,1,1,11),(1,1,1,12),(1,1,1,13),(1,1,1,14),(1,1,1,15),(1,1,1,16),(1,1,1,17),(1,1,1,18),(1,1,1,19),(1,1,1,20),(1,1,1,21),(1,1,1,22),(1,1,1,23),(1,1,1,24),(1,1,1,25),(1,1,1,26),(1,1,1,27),(1,1,1,28),(1,1,1,29),(1,1,1,30),(1,1,1,31),(1,1,1,32),(1,1,1,33),(1,1,1,34),(1,1,1,35),(1,1,1,36),(1,1,1,37),(1,1,1,38),(1,1,1,39),(1,1,1,40),(1,1,1,41),(1,1,1,42),(1,1,1,43),(1,1,1,44),(1,1,1,45),(1,1,1,46),(1,1,1,47),(1,1,1,48),(1,1,1,49),(1,1,1,50),(1,1,1,51),(1,1,1,52),(1,1,1,53),(1,1,1,54),(1,1,1,55),(1,1,1,56),(1,1,1,57),(1,1,1,58),(1,1,1,59),(1,1,1,60),(1,1,1,61),(1,1,1,62),(1,1,1,63),(1,1,1,64),(1,1,1,65),(1,1,1,66),(1,1,1,67),(1,1,1,68),(1,1,1,69),(1,1,1,70),(1,1,1,71),(1,1,1,72),(1,1,1,73),(1,1,1,74),(1,1,1,75),(1,1,1,76),(1,1,1,77),(1,1,1,78),(1,1,1,79),(1,1,1,80),(1,1,1,81),(1,1,1,82),(1,1,1,83),(1,1,1,84),(1,1,1,85),(1,1,1,86),(1,1,1,87),(1,1,1,88),(1,1,1,89),(1,1,1,90),(1,1,1,91),(1,1,1,92),(1,1,1,93),(1,1,1,94),(1,1,1,95),(1,1,1,96),(1,1,1,97),(1,1,1,98),(1,1,1,99),(1,1,1,100),
(1,1,2,1),(1,1,2,2),(1,1,2,3),(1,1,2,4),(1,1,2,5),(1,1,2,6),(1,1,2,7),(1,1,2,8),(1,1,2,9),(1,1,2,10),(1,1,2,11),(1,1,2,12),(1,1,2,13),(1,1,2,14),(1,1,2,15),(1,1,2,16),(1,1,2,17),(1,1,2,18),(1,1,2,19),(1,1,2,20),(1,1,2,21),(1,1,2,22),(1,1,2,23),(1,1,2,24),(1,1,2,25),(1,1,2,26),(1,1,2,27),(1,1,2,28),(1,1,2,29),(1,1,2,30),(1,1,2,31),(1,1,2,32),(1,1,2,33),(1,1,2,34),(1,1,2,35),(1,1,2,36),(1,1,2,37),(1,1,2,38),(1,1,2,39),(1,1,2,40),(1,1,2,41),(1,1,2,42),(1,1,2,43),(1,1,2,44),(1,1,2,45),(1,1,2,46),(1,1,2,47),(1,1,2,48),(1,1,2,49),(1,1,2,50),(1,1,2,51),(1,1,2,52),(1,1,2,53),(1,1,2,54),(1,1,2,55),(1,1,2,56),(1,1,2,57),(1,1,2,58),(1,1,2,59),(1,1,2,60),(1,1,2,61),(1,1,2,62),(1,1,2,63),(1,1,2,64),(1,1,2,65),(1,1,2,66),(1,1,2,67),(1,1,2,68),(1,1,2,69),(1,1,2,70),(1,1,2,71),(1,1,2,72),(1,1,2,73),(1,1,2,74),(1,1,2,75),(1,1,2,76),(1,1,2,77),(1,1,2,78),(1,1,2,79),(1,1,2,80),(1,1,2,81),(1,1,2,82),(1,1,2,83),(1,1,2,84),(1,1,2,85),(1,1,2,86),(1,1,2,87),(1,1,2,88),(1,1,2,89),(1,1,2,90),(1,1,2,91),(1,1,2,92),(1,1,2,93),(1,1,2,94),(1,1,2,95),(1,1,2,96),(1,1,2,97),(1,1,2,98),(1,1,2,99),(1,1,2,100);

ANALYZE TABLE bad_plan.t;
