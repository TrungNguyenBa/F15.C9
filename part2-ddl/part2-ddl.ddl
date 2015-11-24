SELECT distinct 
a.triple.GET_SUBJECT() as subject, 
a.triple.GET_PROPERTY() as property,
a.triple.GET_OBJ_VALUE() as object
from C9_C##cs347_ttn2363_DATA a order by subject, property;

EXECUTE SEM_APIS.DROP_RDF_MODEL('C9_C##cs347_ttn2363');
drop table C9_C##cs347_ttn2363_DATA;
DROP SEQUENCE C9_C##cs347_ttn2363_SQNC;
DROP SEQUENCE C9_C##cs347_ttn2363_GUID_SQNC;