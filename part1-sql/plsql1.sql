declare 
	cursor temp is
		select * from "F15.C9_ARL_EMPLOYEES"
		where EMPLOYEE_ID = :P6_EMPLOYEE_LIST;
begin
	for i in temp loop
		if i.SYSTEM_ADMIN_FLAG = 1 then 
			return true;
		else
			return false;
	end loop;
end;
/
declare 
	cursor temp is
		select * from "F15.C9_ARL_EMPLOYEES"
		where EMPLOYEE_ID = :P6_EMPLOYEE_LIST;
begin
	for i in temp loop
		if i.LAB_DIRECTOR_FLAG = 1 then 
			return true;
		else
			return false;
	end if;
	end loop;
end;
/
declare
	cursor temp is
		select * from "F15.C9_ARL_EMPLOYEES"
		where EMPLOYEE_ID = :P6_EMPLOYEE_LIST;
begin
	for i in temp loop
		if i.CHAIRPERSON_FLAG = 1 then 
			return true;
		else
			return false;
	end if;
	end loop;
end;
/
declare
	cursor temp is
		select * from "F15.C9_ARL_EMPLOYEES"
		where EMPLOYEE_ID = :P6_EMPLOYEE_LIST;
begin
	for i in temp loop
		if i.EXEC_DIRECTOR_FLAG = 1 then 
			return true;
		else
			return false;
	end if;
	end loop;
end;
/
begin

	update "F15.C9_RFE_HISTORY" 
	set EFFECTIVE_DATE = SYSDATE,
		DECISION = 'SA APPROVED'
	where "F15.C9_RFE_ID"=:P6_SA_AP_LIST;
	update "F15.C9_RFE_EXCEPTION_REQUESTS"
	set "F15.C9_RFE_ST_ST_CODE" = 120
	where RFE_ID = :P6_SA_AP_LIST;

end;
/
begin

	update "F15.C9_RFE_HISTORY" 
	set EFFECTIVE_DATE = SYSDATE,
		DECISION = 'LD APPROVED'
	where "F15.C9_RFE_ID"=:P6_LIST_OF_SA_APPROVED;
	update "F15.C9_RFE_EXCEPTION_REQUESTS"
	set "F15.C9_RFE_ST_ST_CODE" = 160;
	where RFE_ID = :P6_LIST_OF_SA_APPROVED;
end;
/
begin

	update "F15.C9_RFE_HISTORY" 
	set EFFECTIVE_DATE = SYSDATE,
		DECISION = 'CP APPROVED'
	where "F15.C9_RFE_ID"=:P6_LIST_OF_DL_APPROVED;
	update "F15.C9_RFE_EXCEPTION_REQUESTS"
	set "F15.C9_RFE_ST_ST_CODE" = 141
	where RFE_ID = :P6_LIST_OF_DL_APPROVED;
end;
/
begin

	update "F15.C9_RFE_HISTORY" 
	set EFFECTIVE_DATE = SYSDATE,
		DECISION = 'EXC APPROVED'
	where "F15.C9_RFE_ID"=:P6_LIST_OF_CP_APPROVED;
	update "F15.C9_RFE_EXCEPTION_REQUESTS"
	set "F15.C9_RFE_ST_ST_CODE" = 161
	where RFE_ID = :P6_LIST_OF_CP_APPROVED;
end;
/
begin

	update "F15.C9_RFE_HISTORY" 
	set EFFECTIVE_DATE = SYSDATE,
		DECISION = 'REVOKED'
	where "F15.C9_RFE_ID"=:P6_SA_AP_LIST;
	update "F15.C9_RFE_EXCEPTION_REQUESTS"
	set "F15.C9_RFE_ST_ST_CODE" = 121
	where RFE_ID = :P6_SA_AP_LIST;

end;
/
select distinct
rfe."RFE_ID",
rfe."EXPLANATION",
rfe."ALT_PROTECTIONS",
rfe."APPROVAL_REVIEW_DATE",
"F15.C9_RFE_ST_ST_CODE" as Status,
cnt.CONTACT_ROLE
from "F15.C9_RFE_EXCEPTION_REQUESTS" rfe join "F15.C9_RFE_CONTACTS" cnt on (rfe.RFE_ID = cnt."F15.C9_RFE_ID") join "F15.C9_RFE_HISTORY" his on (his."F15.C9_RFE_ID" = rfe.RFE_ID)
where cnt.CONTACT_EMP_ID = :P6_EMPLOYEE_LIST and cnt.CONTACT_ROLE_CODE = 'LD APPROVER' and his."DECISION" = 'SA APPROVED';
/
select distinct
rfe."RFE_ID",
rfe."EXPLANATION",
rfe."ALT_PROTECTIONS",
rfe."APPROVAL_REVIEW_DATE",
"F15.C9_RFE_ST_ST_CODE" as Status,
cnt.CONTACT_ROLE
from "F15.C9_RFE_EXCEPTION_REQUESTS" rfe join "F15.C9_RFE_CONTACTS" cnt on (rfe.RFE_ID = cnt."F15.C9_RFE_ID")
where cnt.CONTACT_EMP_ID = :P6_EMPLOYEE_LIST and cnt.CONTACT_ROLE_CODE = 'SA APPROVER';
/
declare 
    k integer;
    z integer;
    cursor temp is 
      select * from "F15.C9_ARL_EMPLOYEES" emp
      where emp.EMPLOYEE_ID = :P6_EMPLOYEE_LIST;
    cursor temp_2 is 
      select "VALUE" from "GLOBLE_VALUE"
      where GLOBLE_ID =1;
    cursor SA is 
      select * from "F15.C9_ARL_EMPLOYEES" emp
      where emp.SYSTEM_ADMIN_FLAG =1 ;
    cursor DL is 
      select * from "F15.C9_ARL_EMPLOYEES" emp
      where emp.LAB_DIRECTOR_FLAG =1 ;
    cursor CP is 
      select EMPLOYEE_ID,TILTE,TITLE_CODE from "F15.C9_ARL_EMPLOYEES" emp
      where emp.CHAIRPERSON_FLAG =1 ;
    cursor EXC is 
      select EMPLOYEE_ID,TILTE,TITLE_CODE from "F15.C9_ARL_EMPLOYEES" emp
      where emp.EXEC_DIRECTOR_FLAG =1 ;
begin
  for i in temp_2 loop
    k := i."VALUE";
  end loop;

  for j in temp loop 
    insert into "F15.C9_RFE_CONTACTS"(
    CONTACT_ROLE_CODE,
    CONTACT_EMP_ID,
    EFFECTIVE_DATE,
    "F15.C9_RFE_ID",
    CONTACT_ROLE,
    "F15.C9_ARL_EMP_EMP_ID"
  )
  values(
    'REQUESTOR',
    j.EMPLOYEE_ID,
    localtimestamp,
    k,
    j.TILTE,
    j.EMPLOYEE_ID
  );
  z:= j."F15.C9_LAB_LAB_ID";
  end loop;
  for tt in SA loop
    if (tt."F15.C9_LAB_LAB_ID" = z) then
        insert into "F15.C9_RFE_CONTACTS"(
        CONTACT_ROLE_CODE,
        CONTACT_EMP_ID,
        EFFECTIVE_DATE,
        "F15.C9_RFE_ID",
        CONTACT_ROLE,
        "F15.C9_ARL_EMP_EMP_ID"
      )
      values(
        'SA APPROVER',
        tt.EMPLOYEE_ID,
        localtimestamp,
        k,
        tt.TILTE,
        tt.EMPLOYEE_ID
      );
     end if;
  end loop;
  
  for ttt in DL loop
    if (ttt."F15.C9_LAB_LAB_ID" = z) then
        insert into "F15.C9_RFE_CONTACTS"(
        CONTACT_ROLE_CODE,
        CONTACT_EMP_ID,
        EFFECTIVE_DATE,
        "F15.C9_RFE_ID",
        CONTACT_ROLE,
        "F15.C9_ARL_EMP_EMP_ID"
      )
      values(
        'LD APPROVER',
        ttt.EMPLOYEE_ID,
        localtimestamp,
        k,
        ttt.TILTE,
        ttt.EMPLOYEE_ID
      );
     end if;
  end loop;
    for tttt in CP loop
      insert into "F15.C9_RFE_CONTACTS"(
        CONTACT_ROLE_CODE,
        CONTACT_EMP_ID,
        EFFECTIVE_DATE,
        "F15.C9_RFE_ID",
        CONTACT_ROLE,
        "F15.C9_ARL_EMP_EMP_ID"
      )
      values(
        'CP APPROVER',
        tttt.EMPLOYEE_ID,
        localtimestamp,
        k,
        tttt.TILTE,
        tttt.EMPLOYEE_ID
      );
  end loop;
  for ttttt in EXC loop
      insert into "F15.C9_RFE_CONTACTS"(
        CONTACT_ROLE_CODE,
        CONTACT_EMP_ID,
        EFFECTIVE_DATE,
        "F15.C9_RFE_ID",
        CONTACT_ROLE,
        "F15.C9_ARL_EMP_EMP_ID"
      )
      values(
        'EXC APPROVER',
        ttttt.EMPLOYEE_ID,
        localtimestamp,
        k,
        ttttt.TILTE,
        ttttt.EMPLOYEE_ID
      );
  end loop;
end;
/
declare
	 cursor temp_2 is 
     select "VALUE" from "GLOBLE_VALUE"
     where GLOBLE_ID =1;
begin
	 for j in temp loop
	 insert into "F15.C9_RFE_HISTORY" (EFFECTIVE_DATE,ENTERED_BY_EMP_ID,EMPLOYEE_TITLE_CODE,"F15.C9_RFE_ID",DECISION)
	 values(
	 	SYSDATE,
	 	:P6_EMPLOYEE_LIST,
	 	'REQUESTOR',
	 	j.VALUE,
	 	'PENDING'
	 );
	 end loop;
end;
select EXPLANATION as display_value, RFE_ID as return_value   from  "F15.C9_RFE_EXCEPTION_REQUESTS"
 order by 1;
 /
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'SA APPROVED',:P12_EMPLOYEE_LIST,:P6_SA_AP_LIST);
end;
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'SA REVOKED',:P12_EMPLOYEE_LIST,:P6_SA_AP_LIST);
end;
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'SA RETURNED',:P12_EMPLOYEE_LIST,:P6_SA_AP_LIST);
end;
/
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'LD APPROVED',:P12_EMPLOYEE_LIST,:P6_LD_AP_LIST);
end;
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'LD REVOKED',:P12_EMPLOYEE_LIST,:P6_LD_AP_LIST);
end;
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'LD RETURNED',:P12_EMPLOYEE_LIST,:P6_LD_AP_LIST);
end;
/
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'CP APPROVED',:P12_EMPLOYEE_LIST,:P6_AP_CP_LIST);
end;
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'CP REVOKED',:P12_EMPLOYEE_LIST,:P6_AP_CP_LIST);
end;
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'CP RETURNED',:P12_EMPLOYEE_LIST,:P6_AP_CP_LIST);
end;
/
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'EXC APPROVED',:P12_EMPLOYEE_LIST,:P6_EXC_AP_LIST);
end;
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'EXC REVOKED',:P12_EMPLOYEE_LIST,:P6_EXC_AP_LIST);
end;
begin
	insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'EXC RETURNED',:P12_EMPLOYEE_LIST,:P6_EXC_AP_LIST);
end;
/
begin
	insert into "F19.C9_REF_TASK_RD" ("F15.C9_RFE_ID","F15.C9_TASK_id",EFFECTIVE_DATE)
	values (:P7_RFE_ID,:P7_TASK_LIST,SYSDATE);
end;
/
--notice list for submiting (requestor)
begin 
	insert into "F19.C9_Notice" ("F15.C9_ARL_EMP_ID","F15.C9_RFE_ID",EFFECTIVE_DAY)
	values (:P12_EMPLOYEE_LIST,:P7_RFE_ID,SYSDATE);
end;
/
begin
	insert into "F19.C9_Notice" ("F15.C9_ARL_EMP_ID","F15.C9_RFE_ID",EFFECTIVE_DAY)
	values (:P12_EMPLOYEE_LIST,:P6_SA_AP_LIST,SYSDATE);
end;
begin
	insert into "F19.C9_Notice" ("F15.C9_ARL_EMP_ID","F15.C9_RFE_ID",EFFECTIVE_DAY)
	values (:P12_EMPLOYEE_LIST,:P6_LD_AP_LIST,SYSDATE);
end;
begin
	insert into "F19.C9_Notice" ("F15.C9_ARL_EMP_ID","F15.C9_RFE_ID",EFFECTIVE_DAY)
	values (:P12_EMPLOYEE_LIST,:P6_AP_CP_LIST,SYSDATE);
end;
begin
	insert into "F19.C9_Notice" ("F15.C9_ARL_EMP_ID","F15.C9_RFE_ID",EFFECTIVE_DAY)
	values (:P12_EMPLOYEE_LIST,:P6_EXC_AP_LIST,SYSDATE);
end;
/
declare 
 cursor t is 
  select count(EMPLOYEE_ID) as count from "F15.C9_ARL_EMPLOYEES"
 where CHAIRPERSON_FLAG = '1';
  i int;
begin
 for k in t loop 
 	i : = k.count;
 end loop;
 if (i < 1) then
 	return true
 else 
 	return false
 end if;
end;
declare 
 cursor t is 
  select count(EMPLOYEE_ID) as count from "F15.C9_ARL_EMPLOYEES"
 where EXEC_DIRECTOR_FLAG = '1';
  i int;
begin
 for k in t loop 
 	i := k.count;
 end loop;
 if (i < 1) then
 	return true
 else 
 	return false
 end if;
end;
/
begin 
	:P23_F15_C9_RFE_ID := :P7_RFE_ID;
end;
 /
 declare 
 cursor t is 
  select count(EMPLOYEE_ID) as count from "F15.C9_ARL_EMPLOYEES"
 where CHAIRPERSON_FLAG = '1';
  i integer;
begin
for k in t loop 
i := k.count;
end loop;
if (i < 1) then
return true;
else 
return false;
end if;
end;
/
declare
cursor temp is 
     select "VALUE" from "GLOBLE_VALUE"
     where GLOBLE_ID =1;
begin 
    for j in temp loop
	insert into "F19.C9_Notice" ("F15.C9_ARL_EMP_ID","F15.C9_RFE_ID",EFFECTIVE_DAY)
	values (:P12_EMPLOYEE_LIST,j.VALUE,SYSDATE);
    end loop;
end;
/
insert into "F15.C9_RFE_TRACKING_COMMENTS" (ENTERED_BY_EMP_ID,COMMENT_ENTRY_DATE,COMMENTS,EMPLOYEE_ID,"F15.C9_RFE_ID")
	values (:P12_EMPLOYEE_LIST,SYSDATE,'SA APPROVED',:P12_EMPLOYEE_LIST,:P6_SA_AP_LIST);
insert into "F19.C9_Notice"("F15.C9_ARL_EMP_ID","F15.C9_RFE_ID",EFFECTIVE_DAY)
	values (:P12_EMPLOYEE_LIST,:P6_SA_AP_LIST,SYSDATE);
/
declare 
  cursor temp is 
  	select * from "F15.C9_ARL_EMPLOYEES"
  	where EMPLOYEE_ID = :P12_EMPLOYEE_LIST;
begin
	for t in temp loop
		if (t."F15.C9_AUT_ID"=100) then 
			return true;
		else 
			return false;
		end if;
	end loop;
end;
/
begin
:P6_X:= :P6_SA_AP_LIST;
end;
/
select t.RFE_ID as display_value, t.RFE_ID as return_value from
(select rfe.RFE_ID as RFE_ID
from "F15.C9_RFE_EXCEPTION_REQUESTS" rfe join "F15.C9_F15.C9_RFE_CONTACTS" cnt on (rfe.RFE_ID = cnt."F15.C9_RFE_ID")
where cnt."F15.C9_ARL_EMP_EMP_ID" = :P12_EMPLOYEE_LIST) t
order by 1
/
declare 
 cursor temp is 
 	select * from "F15.C9_RFE_EXCEPTION_REQUESTS"
 	where RFE_ID = :P6_RQ_LIST;
 begin
 	for i in temp loop
 	insert into "F15.C9_RFE_EXCEPTION_REQUESTS"(EXPLANATION,ALT_PROTECTIONS,APPROVAL_REVIEW_DATE)
 	values(i.EXPLANATION,i.ALT_PROTECTIONS,i.APPROVAL_REVIEW_DATE);
 	end loop;
 end;
 /
	 select * from
	(select jt2.COMPANY_NAME STOCK_OF,
	jt4.AMOUNT "STOCK AMOUNT",
	from	apex_collections t,
	json_table(t.clob001,'$.X0_2[*]     ' COLUMNS rid for	ordinality,COMPANY_NAME varchar2(30) path '$') jt2,
	json_table(t.clob001,'$.X2_1[*]     ' COLUMNS rid for	ordinality,AMOUNT number path '$') jt4,
	where collection_name = 'P2_DOREST_RESULTS' and 
	jt2.rid	= jt4.rid ) t
	select NULL LINK,
      C_NAME LABEL,
      AMOUNT VALUE
from (select  jt2.COMPANY_NAME C_NAME,
       jt4.AMOUNT AMOUNT
from apex_collections t,
	json_table(t.clob001,'$.X0_2[*]     ' COLUMNS rid for	ordinality,COMPANY_NAME varchar2(30) path '$') jt2,
	json_table(t.clob001,'$.X2_1[*]     ' COLUMNS rid for	ordinality,AMOUNT number path '$') jt4,
where collection_name = 'P2_DOREST_RESULTS' and 
jt2.rid	= jt4.rid ) k
order by C_NAME
/

declare 
	cursor temp is 
	select * from "F15.C9_ARL_EMPLOYEE" 
	where EMPLOYEE_ID=:P6_EMPLOYEE_LIST;
begin
	for t in temp loop
	insert into "F15.C9_RFE_HISTORY" (EFFECTIVE_DATE,EMPLOYEE_TITLE_CODE,"F15.C9_RFE_ID",DECISION)
	values (SYSDATE,t.TITLE_CODE, :P6_LIST_OF_REQUEST,"APPROVED");
	end loop;
end;
/
declare 
	cursor temp is 
	select * from "F15.C9_ARL_EMPLOYEES" 
	where EMPLOYEE_ID=:P6_EMPLOYEE_LIST;
begin
	for t in temp loop
	insert into "F15.C9_RFE_HISTORY" (EFFECTIVE_DATE,ENTERED_BY_EMP_ID,EMPLOYEE_TITLE_CODE,"F15.C9_RFE_ID",DECISION)
	values(SYSDATE,t.EMPLOYEE_ID,t.TITLE_CODE,:P6_LIST_OF_REQUEST,'REVOKED');
	end loop;
end;
/
select rfe."RFE_ID",
rfe."EXPLANATION",
rfe."ALT_PROTECTIONS",
rfe."APPROVAL_REVIEW_DATE",
"F15.C9_RFE_ST_ST_CODE" as Status,
cnt.CONTACT_ROLE_CODE
from "F15.C9_RFE_EXCEPTION_REQUESTS" rfe join "F15.C9_RFE_CONTACTS" cnt on (rfe.RFE_ID=cnt."F15.C9_RFE_ID") 
join "F15.C9_ARL_EMPLOYEES" emp on (emp.EMPLOYEE_ID = cnt.CONTACT_EMP_ID)
where cnt.CONTACT_EMP_ID = :P6_EMPLOYEE_LIST and cnt.CONTACT_ROLE_CODE = 'SA APPROVER';
/
