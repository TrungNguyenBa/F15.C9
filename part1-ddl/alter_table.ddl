CREATE TABLE "F15.C9_RFE_TRACKING_COMMENTS"
  (
    RFE_ID             INTEGER NOT NULL ,
    ENTERED_BY_EMP_ID  INTEGER ,
    COMMENT_ENTRY_DATE DATE ,
    COMMENTS           VARCHAR2 (4000) ,
    EMPLOYEE_ID        INTEGER NOT NULL ,
    "F15.C9_RFE_ID"    INTEGER NOT NULL
  ) ;
ALTER TABLE "F15.C9_RFE_TRACKING_COMMENTS" ADD CONSTRAINT "F15.C9_RFE_COMMENTS_PK" PRIMARY KEY ( RFE_ID ) ;
ALTER TABLE "F15.C9_RFE_TRACKING_COMMENTS" ADD CONSTRAINT "F15.C9_RFE_cmt_FK" FOREIGN KEY ( "F15.C9_RFE_ID" ) REFERENCES "F15.C9_RFE_EXCEPTION_REQUESTS" ( RFE_ID ) ;
/
create or replace trigger "F15.C9_COMM_UP_TRIG"
before insert on "F15.C9_RFE_TRACKING_COMMENTS"
for each row
begin
	:new.ENTERED_BY_EMP_ID :=v('P12_EMPLOYEE_LIST');
	:new.COMMENT_ENTRY_DATE:=SYSDATE;
	:new.EMPLOYEE_ID:= v('P12_EMPLOYEE_LIST');
	if (v('P7_RFE_ID') is not null) then 
		:new."F15.C9_RFE_ID":=v('P7_RFE_ID');
	end if;
end;
/
CREATE TABLE "F19.C9_Notice"
  (
    ID            INTEGER NOT NULL ,
    EFFECTIVE_DAY DATE ,
    --  ERROR: Column name length exceeds maximum allowed length(30)
    "F15.C9_ARL_EMP_ID" INTEGER NOT NULL ,
    --  ERROR: Column name length exceeds maximum allowed length(30)
    "F15.C9_RFE_ID" INTEGER NOT NULL
  ) ;
ALTER TABLE "F19.C9_Notice" ADD CONSTRAINT "F19.C9_Notice_PK" PRIMARY KEY ( ID ) ;
ALTER TABLE "F19.C9_Notice" ADD CONSTRAINT "F19.C9_Not_EMPLOYEES_FK" FOREIGN KEY ( "F15.C9_ARL_EMPL_ID" ) REFERENCES "F15.C9_ARL_EMPLOYEES" ( EMPLOYEE_ID ) ;

--  ERROR: FK name length exceeds maximum allowed length(30)
ALTER TABLE "F19.C9_Notice" ADD CONSTRAINT "F19.C9_Not_RFE_FK" FOREIGN KEY ( "F15.C9_RFE_ID" ) REFERENCES "F15.C9_RFE_EXCEPTION_REQUESTS" ( RFE_ID ) ;
/
ALTER TABLE "F15.C9_RFE_TASKS" drop column EFFECTIVE_DATE;
/
ALTER TABLE "F19.C9_REF_TASK_RD" add EFFECTIVE_DATE DATE; 
/
/
ALTER table "F15.C9_Documentation" add blob_column BLOB;
ALTER table "F15.C9_Documentation" add    filename      VARCHAR2 (4000 BYTE) ,
ALTER table "F15.C9_Documentation" add    file_mimetype VARCHAR2 (512) ,
ALTER table "F15.C9_Documentation" add    file_charset  VARCHAR2 (512) ,
/
DROP SEQUENCE "F15.C9_not_SEQ" ; 
create sequence "F15.C9_not_SEQ" 
start with 100 
increment by 1 
nomaxvalue 
;
create or replace trigger "F15.C9_Not_Tr_PK"
before insert on "F19.C9_Notice"
for each row
begin
	select "F15.C9_not_SEQ".nextval into :new.ID from dual;
end; 
/
ALTER table "F15.C9_ARL_EMPLOYEES" ADD "F15.C9_AUT_ID" INTEGER NOT NULL;
ALTER table "F15.C9_ARL_EMPLOYEES" ADD CONSTRAINT "F15.C9_EMP_AUT_FK" FOREIGN KEY ("F15.C9_AUT_ID") REFERENCES "F15.C9_Authorization" (AUTH_ID);
ALTER table "F15.C9_Authorization" Drop CONSTRAINT "F15.C9_ARL_EMP_EMP_ID";
/
create or replace trigger "F15.C9_DOC_UP_TRIG"
before insert on "F15.C9_Documentation"
for each row
begin
  if (v('P7_RFE_ID') is not null) then 
    :new."F15.C9_RFE_ID":=v('P7_RFE_ID');
  end if;
end;
/
alter table "F15.C9_RFE_HISTORY" add DECISION VARCHAR(255);
