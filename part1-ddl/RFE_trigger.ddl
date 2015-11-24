create or replace trigger "F15.C9_PENDING_TRIG" 
before insert on  "F15.C9_RFE_EXCEPTION_REQUESTS"
for each row 
begin 
  select 100 into :new."F15.C9_RFE_ST_ST_CODE" from dual; 
end; 
/

--/

