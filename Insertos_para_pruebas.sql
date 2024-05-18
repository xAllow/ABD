Insertar para pruebas:
--Centro
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values (54,'Gimnasio Prueba FitLife','Calle de la Victoria, 12','29012');
--Cliente
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values (420,'alvaro','luque torres','584858458',null,null,'usuariooracle420');
INSERT INTO LIFEFIT.DIETA(ID , nombre)VALUES ( 88 ,'Anorexia');
INSERT INTO LIFEFIT.CLIENTE(ID , dieta_id ,centro_id)VALUES ( 420 , 88 ,54);
INSERT INTO LIFEFIT.CITA(fechayhora , id ,cliente_id)VALUES ( TO_DATE('17/12/2015', 'DD/MM/YYYY'), 44 ,420);
--Entrenador
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values (421,'alvaro','luque torres','584858458',null,null,'usuariooracle421');
INSERT INTO LIFEFIT.ENTRENADOR(ID , centro_id)VALUES (421 ,54);
INSERT INTO LIFEFIT.ELEMENTOCALENDARIO(fechayhora , entrenador_id)VALUES (TO_DATE('17/12/2015', 'DD/MM/YYYY') ,421);
INSERT INTO LIFEFIT.ENTRENA(entrenador_id , cliente_id)VALUES (421 ,420);
INSERT INTO LIFEFIT.RUTINA(ID , NOMBRE)VALUES (080 ,'Engordar');
INSERT INTO LIFEFIT.PLAN(inicio , rutina_id , entrena_entrenador_id , entrena_cliente_id)VALUES (TO_DATE('17/12/2015', 'DD/MM/YYYY'),080,421 ,420);
INSERT INTO LIFEFIT.PLAN(inicio , plan_inicio , plan_rutina_id , plan_entrena_entrenador_id , plan_entrena_cliente_id)VALUES (TO_DATE('17/12/2015', 'DD/MM/YYYY'),TO_DATE('17/12/2015', 'DD/MM/YYYY'),080,421 ,420);
--Gerente
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values (422,'alvaro','luque torres','584858458',null,null,'usuariooracle422');
INSERT INTO LIFEFIT.GERENTE(ID , centro_id)VALUES (422 ,54);