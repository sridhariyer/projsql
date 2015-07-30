CREATE DATABASE test_bill;

CREATE TABLE ENTITY
( ENTITY_ID MEDIUMINT NOT NULL AUTO_INCREMENT,
  ENTITY_NAME VARCHAR(30),
  ENT_ATTR1	VARCHAR(10),
  ENT_ATTR2	VARCHAR(10),
  ENT_ATTR3	VARCHAR(10),
  ENT_ATTR4	VARCHAR(10),
  ENT_ATTR5	VARCHAR(10),
  ENT_BILL_CATG VARCHAR(10),
  ENT_VR_NR MEDIUMINT  
  PRIMARY KEY (ENTITY_ID)
);

CREATE TABLE ENTITY_PROD
( 
  ENT_PROD_ID MEDIUMINT NOT NULL AUTO_INCREMENT,  
  ENT_PROD_NAME VARCHAR(30),
  ENT_VR_NR MEDIUMINT
  PRIMARY KEY (ENT_PROD_ID)
);

CREATE TABLE ENTITY_PROD_RULE
( 
  ENT_RULE_ID MEDIUMINT NOT NULL AUTO_INCREMENT,
  ENT_PROD_ID MEDIUMINT,
  ENTITY_ID MEDIUMINT,
  ENT_CHG_TYPE VARCHAR(4,2),
  ENT_PRORATE TINYINT,  
  ENT_AMT DECIMAL(4,2),  
  ENT_TX_PER DECIMAL(4,2),
  ENT_VR_NR MEDIUMINT
  PRIMARY KEY (ENT_RULE_ID)
);

CREATE TABLE VERSION
(
	ENT_VR_NR MEDIUMINT NOT NULL AUTO_INCREMENT,
	ENT_VR_CATG VARCHAR(2),
	ENT_PREV_VR_NR MEDIUMINT,
	INST_CTG VARCHAR(4)
	PRIMARY KEY (ENT_VR_NR)
);

CREATE TABLE ENT_INST_TR
( ENT_INST_ID MEDIUMINT NOT NULL AUTO_INCREMENT,
  ENTITY_ID MEDIUMINT,
  ENT_INS_NAME VARCHAR(30),  
  ENT_INST_ATTR1	VARCHAR(10),
  ENT_INST_ATTR2	VARCHAR(10),
  ENT_INST_ATTR3	VARCHAR(10),
  ENT_INST_ATTR4	VARCHAR(10),
  ENT_INST_ST_DT DATE,
  ENT_INST_ED_DT DATE,
  ENT_INS_STS INT(2),  
  ENT_VR_NR MEDIUMINT
  PRIMARY KEY (ENT_INST_ID)
);


CREATE TABLE ENT_INST_PROD_TR
( 
  ENT_PROD_INST_ID MEDIUMINT NOT NULL AUTO_INCREMENT,
  ENT_INST_ID MEDIUMINT, 
  ENT_PROD_ID MEDIUMINT,      
  ENT_INST_ST_DT DATE,
  ENT_INST_ED_DT DATE,
  ENT_PROD_INS_STS INT(2),  
  ENT_VR_NR MEDIUMINT
  PRIMARY KEY (ENT_PROD_INST_ID)
);

CREATE TABLE BILL_GEN
( BILL_GEN_ID MEDIUMINT NOT NULL AUTO_INCREMENT,
  ENT_INST_ID MEDIUMINT,  
  BILL_DT DATE,  
  LAST_MOD DATE,
  ENT_VR_NR MEDIUMINT
  PRIMARY KEY (BILL_GEN_ID)
);

--usage process can upload the entries with BILL_GEN_ID as null
CREATE TABLE BILL_GEN_DET
( TXN_ID MEDIUMINT NOT NULL AUTO_INCREMENT,
  ENT_INST_ID MEDIUMINT,  
  ENT_PROD_INST_ID MEDIUMINT,  
  BILL_GEN_ID MEDIUMINT,
  TXN_DT DATE,
  PERIOD_ST_DT DATE,
  PERIOD_ED_DT DATE,
  TNX_DESC VARCHAR(100),
  TXN_AMT DECIMAL(4,2),
  TAX_AMT DECIMAL(4,2),
  TXN_BASE_AMT DECIMAL(4,2),
  TXN_QTY DECIMAL(4,2)
  PRIMARY KEY (TXN_ID)
);

CREATE TABLE USG_DET
( USG_ID MEDIUMINT NOT NULL AUTO_INCREMENT,
  ENT_INST_ID MEDIUMINT,  
  ENT_PROD_INST_ID MEDIUMINT, 
  USG_DT DATE,
  USG_DESC VARCHAR(100),
  USG_AMT DECIMAL(4,2),
  USG_QTY DECIMAL(4,2),
  ENT_VR_NR MEDIUMINT
  PRIMARY KEY (USG_ID)
  
);


-- Get billst_Date, bill_end_Date range entity and version (DEFAULT - BASELINE)
-- if difference is too large break when entity type is immediate (5) days
-- immediate should only look the usage det table between dates and generate invoice per date
-- Run bill run for a version
-- if catg is monthly generate bill for every 1st between date if not genrate it for next 1sdt from end date
-- Fetch diff entity instance id run loop per entity instance id
-- Get all the products and its prices between bill start date and bill end date
-- Apply prices
-- insert version based bill run data

CREATE PROCEDURE curdemo()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  //DECLARE BSD DATE DEFAULT '01/01/2009';
  //DECLARE BED DATE DEFAULT '01/02/2009';
  //DECLARE ENTITY_ID MEDIUMINT;
  //DECLARE VER_NR MEDIUMINT;
  
  //GET catg for the entity
  
  DECLARE a VARCHAR(16);
  DECLARE b, c INT;
  DECLARE cur1 CURSOR FOR SELECT id,data FROM test.t1;
  DECLARE cur2 CURSOR FOR SELECT i FROM test.t2;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;
  OPEN cur2;

  read_loop: LOOP
    FETCH cur1 INTO a, b;
    FETCH cur2 INTO c;
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF b < c THEN
      INSERT INTO test.t3 VALUES (a,b);
    ELSE
      INSERT INTO test.t3 VALUES (a,c);
    END IF;
  END LOOP;

  CLOSE cur1;
  CLOSE cur2;
END;

-- procedure sample 2
BLOCK1: begin
    declare v_col1 int;                     
    declare no_more_rows boolean1 := FALSE;  
    declare cursor1 cursor for              
        select col1
        from   MyTable;
    declare continue handler for not found  
        set no_more_rows1 := TRUE;           
    open cursor1;
    LOOP1: loop
        fetch cursor1
        into  v_col1;
        if no_more_rows1 then
            close cursor1;
            leave LOOP1;
        end if;
        BLOCK2: begin
            declare v_col2 int;
            declare no_more_rows2 boolean := FALSE;
            declare cursor2 cursor for
                select col2
                from   MyOtherTable
                where  ref_id = v_col1;
           declare continue handler for not found
               set no_more_rows2 := TRUE;
            open cursor2;
            LOOP2: loop
                fetch cursor2
                into  v_col2;
                if no_more_rows then
                    close cursor2;
                    leave LOOP2;
                end if;
            end loop LOOP2;
        end BLOCK2;
    end loop LOOP1;
	
	//procedure sample 3
	DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `proj_attr`()
BEGIN   
    DECLARE proj_done, attribute_done BOOLEAN DEFAULT FALSE;    
    declare attributeId int(11) default 0;
    declare  projectId int(11) default 0;
    DECLARE curProjects CURSOR FOR SELECT id FROM project order by id;  
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET proj_done = TRUE;

    OPEN curProjects;
    cur_project_loop: LOOP
    FETCH FROM curProjects INTO projectId;

        IF proj_done THEN
        CLOSE curProjects;
        LEAVE cur_project_loop;
        END IF;

        BLOCK2: BEGIN
        DECLARE curAttribute CURSOR FOR SELECT id FROM attribute order by id;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET attribute_done = TRUE;
        OPEN curAttribute; 
        cur_attribute_loop: LOOP
        FETCH FROM curAttribute INTO attributeId;   
            IF proj_done THEN
            set proj_done = false;
            CLOSE curAttribute;
            LEAVE cur_attribute_loop;
            END IF; 
            insert into project_attribute_value(project_id, attribute_id)
                values(projectId, attributeId); 
        END LOOP cur_attribute_loop;
        END BLOCK2;
    END LOOP cur_project_loop;


    END$$

DELIMITER ;


PERIOD_DIFF() -- Gives month
DATEDIFF() -- difference between dates
