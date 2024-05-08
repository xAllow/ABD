ALTER SYSTEM SET "WALLET_ROOT"='C:\app\alumnos\admin\orcl\xdb_wallet' scope=SPFILE;

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;

//PREGUNTA 3
CREATE USER LIFEFIT IDENTIFIED BY LIFEFIT123
    DEFAULT TABLESPACE TS_LIFEFIT
    QUOTA UNLIMITED ON TS_LIFEFIT;
GRANT CREATE TABLE, CONNECT TO LIFEFIT;

//DESDE SYSTEM CREAMOS EL TABLESPACE
CREATE TABLESPACE TS_INDICES DATAFILE 'C:\APP\ALUMNOS\ORADATA\ORCL\INDICES.DBF' SIZE 50M AUTOEXTEND ON;
GRANT CREATE SYNONYM TO LIFEFIT;
GRANT CREATE SEQUENCE TO LIFEFIT;
GRANT CREATE MATERIALIZED VIEW TO LIFEFIT;


//DESDE LIFEFIT
SELECT * FROM USER_TABLES;
DROP TABLE CLIENTE;
COMMIT;

--Desde LIFEFIT
-- Generado por Oracle SQL Developer Data Modeler 22.2.0.165.1149
--   en:        2024-04-10 11:15:34 CEST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE centro (
    id        NUMBER(5) NOT NULL,
    nombre    VARCHAR2(100 CHAR) NOT NULL,
    direccion VARCHAR2(100 CHAR),
    cpostal   VARCHAR2(5 CHAR)
);

ALTER TABLE centro ADD CONSTRAINT centro_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES; 

CREATE TABLE cita (
    fechayhora DATE NOT NULL,
    id         NUMBER(5) NOT NULL,
    modalidad  VARCHAR2(100 CHAR),
    cliente_id  NUMBER(5) NOT NULL
);

ALTER TABLE cita ADD CONSTRAINT cita_pk PRIMARY KEY ( fechayhora,
                                                      id, cliente_id) USING INDEX TABLESPACE TS_INDICES;


CREATE TABLE cliente (
    id           NUMBER(5) NOT NULL,
    objetivo     VARCHAR2(100),
    preferencias VARCHAR2(100 CHAR),
    dieta_id     NUMBER(5),
    centro_id    NUMBER(5) NOT NULL
   
);

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;


CREATE TABLE conforman (
    series       VARCHAR2(3),
    repeticiones VARCHAR2(3),
    duracion     VARCHAR2(100 CHAR),
    rutina_id    NUMBER(5) NOT NULL,
    ejercicio_id NUMBER(5) NOT NULL
);

ALTER TABLE conforman ADD CONSTRAINT conforman_pk PRIMARY KEY ( rutina_id,
                                                                ejercicio_id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE dieta (
    id          NUMBER(5) NOT NULL,
    nombre      VARCHAR2(100 CHAR) NOT NULL,
    descripcion VARCHAR2(4000 CHAR),
    tipo        VARCHAR2(100 CHAR)
);

ALTER TABLE dieta ADD CONSTRAINT dieta_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;

ALTER TABLE dieta ADD CONSTRAINT dieta_nombre_un UNIQUE ( nombre ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE ejercicio (
    id          NUMBER(5) NOT NULL,
    nombre      VARCHAR2(100 CHAR),
    descripcion VARCHAR2(4000 CHAR),
    imagen	BLOB,
    video	VARCHAR(2048 CHAR)
);

ALTER TABLE ejercicio ADD CONSTRAINT ejercicio_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE elementocalendario (
    fechayhora    DATE NOT NULL,
    entrenador_id NUMBER(5) NOT NULL
);

ALTER TABLE elementocalendario ADD CONSTRAINT elementocalendario_pk PRIMARY KEY ( fechayhora,
                                                                                  entrenador_id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE entrena (
    especialidad  VARCHAR2(100 CHAR),
    entrenador_id NUMBER(5) NOT NULL,
    cliente_id    NUMBER(5) NOT NULL
);

ALTER TABLE entrena ADD CONSTRAINT entrena_pk PRIMARY KEY ( cliente_id,
                                                            entrenador_id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE entrenador (
    id             NUMBER(5) NOT NULL,
    disponibilidad VARCHAR2(100 CHAR),
    centro_id      NUMBER(5) NOT NULL
);

ALTER TABLE entrenador ADD CONSTRAINT entrenador_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;



CREATE TABLE gerente (
    id        NUMBER(5) NOT NULL,
    despacho  VARCHAR2(100 CHAR),
    horario   VARCHAR2(100 CHAR),
    centro_id NUMBER(5) NOT NULL
);

CREATE UNIQUE INDEX gerente__idx ON
    gerente (
        centro_id
    ASC ) TABLESPACE TS_INDICES;

ALTER TABLE gerente ADD CONSTRAINT gerente_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE plan (
    inicio                       DATE NOT NULL,
    fin                          DATE,
    rutina_id                    NUMBER(5) NOT NULL,
    entrena_cliente_id           NUMBER(5) NOT NULL,
    entrena_entrenador_id        NUMBER(5) NOT NULL
);

ALTER TABLE plan
    ADD CONSTRAINT plan_pk PRIMARY KEY ( inicio,
                                         rutina_id,
                                         entrena_cliente_id,
                                         entrena_entrenador_id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE rutina (
    id                    NUMBER(5) NOT NULL,
    nombre                VARCHAR2(100 CHAR) NOT NULL,
    descripcion           VARCHAR2(4000 CHAR)
);

ALTER TABLE rutina ADD CONSTRAINT rutina_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE sesion (
    inicio                     DATE NOT NULL,
    fin                        DATE,
    presencial                 CHAR(1),
    descripcion                VARCHAR2(4000 CHAR),
    video                      BLOB,
    datos_salud                VARCHAR2(4000 CHAR),
    plan_inicio                DATE NOT NULL,
    plan_rutina_id             NUMBER(5) NOT NULL,
    plan_entrena_cliente_id    NUMBER(5) NOT NULL,
    plan_entrena_entrenador_id NUMBER(5) NOT NULL
);

ALTER TABLE sesion
    ADD CONSTRAINT sesion_pk PRIMARY KEY ( inicio,
                                           plan_inicio,
                                           plan_rutina_id,
                                           plan_entrena_cliente_id,
                                           plan_entrena_entrenador_id ) USING INDEX TABLESPACE TS_INDICES;

CREATE TABLE usuario (
    id            NUMBER(5) NOT NULL,
    nombre        VARCHAR2(100 CHAR) NOT NULL,
    apellidos     VARCHAR2(100 CHAR) NOT NULL,
    telefono      VARCHAR2(9 CHAR) NOT NULL,
    direccion     VARCHAR2(100 CHAR),
    correoe       VARCHAR2(100 CHAR),
    usuariooracle VARCHAR2(100 CHAR)
);

ALTER TABLE usuario ADD CONSTRAINT usuario_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;

-- Error - Foreign Key CITA_CLIENTE_FK has no columns

ALTER TABLE cita
    ADD CONSTRAINT cita_elementocalendario_fk FOREIGN KEY ( fechayhora,
                                                            id )
    
        REFERENCES elementocalendario ( fechayhora,
                                      entrenador_id );
ALTER TABLE cita
    ADD CONSTRAINT cita_cliente_fk FOREIGN KEY ( cliente_id )
    
        REFERENCES cliente ( id );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_centro_fk FOREIGN KEY ( centro_id )
        REFERENCES centro ( id );



ALTER TABLE cliente
    ADD CONSTRAINT cliente_dieta_fk FOREIGN KEY ( dieta_id )
        REFERENCES dieta ( id );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_usuario_fk FOREIGN KEY ( id )
        REFERENCES usuario ( id );

ALTER TABLE conforman
    ADD CONSTRAINT conforman_ejercicio_fk FOREIGN KEY ( ejercicio_id )
        REFERENCES ejercicio ( id );

ALTER TABLE conforman
    ADD CONSTRAINT conforman_rutina_fk FOREIGN KEY ( rutina_id )
        REFERENCES rutina ( id );

--  ERROR: FK name length exceeds maximum allowed length(30) 
ALTER TABLE elementocalendario
    ADD CONSTRAINT calendario_entrenador_fk FOREIGN KEY ( entrenador_id )
        REFERENCES entrenador ( id );

ALTER TABLE entrena
    ADD CONSTRAINT entrena_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id );

ALTER TABLE entrena
    ADD CONSTRAINT entrena_entrenador_fk FOREIGN KEY ( entrenador_id )
        REFERENCES entrenador ( id );

ALTER TABLE entrenador
    ADD CONSTRAINT entrenador_centro_fk FOREIGN KEY ( centro_id )
        REFERENCES centro ( id );


ALTER TABLE entrenador
    ADD CONSTRAINT entrenador_usuario_fk FOREIGN KEY ( id )
        REFERENCES usuario ( id );

ALTER TABLE gerente
    ADD CONSTRAINT gerente_centro_fk FOREIGN KEY ( centro_id )
        REFERENCES centro ( id );

ALTER TABLE gerente
    ADD CONSTRAINT gerente_usuario_fk FOREIGN KEY ( id )
        REFERENCES usuario ( id );

ALTER TABLE plan
    ADD CONSTRAINT plan_entrena_fk FOREIGN KEY ( entrena_cliente_id,
                                                 entrena_entrenador_id )
        REFERENCES entrena ( cliente_id,
                             entrenador_id );

ALTER TABLE plan
    ADD CONSTRAINT plan_rutina_fk FOREIGN KEY ( rutina_id )
        REFERENCES rutina ( id );



ALTER TABLE sesion
    ADD CONSTRAINT sesion_plan_fk FOREIGN KEY ( plan_inicio,
                                                plan_rutina_id,
                                                plan_entrena_cliente_id,
                                                plan_entrena_entrenador_id )
        REFERENCES plan ( inicio,
                          rutina_id,
                          entrena_cliente_id,
                          entrena_entrenador_id );

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated 

--  ERROR: No Discriminator Column found in Arc FKArc_1 - constraint trigger for Arc cannot be generated



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            14
-- CREATE INDEX                             1
-- ALTER TABLE                             34
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   8
-- WARNINGS                                 0


--Desde system
create or replace directory directorio_ext as 'C:\app\alumnos\admin\orcl\dpdump';
grant read, write on directory directorio_ext to LIFEFIT;

--Desde LIFEFIT

create table ejercicios_ext
 (  nombre      VARCHAR2(100 CHAR),
    descripcion VARCHAR2(4000 CHAR),
    video VARCHAR2 (2048 CHAR)
 )
ORGANIZATION EXTERNAL (
 TYPE ORACLE_LOADER
 DEFAULT DIRECTORY directorio_ext
 ACCESS PARAMETERS (
 RECORDS DELIMITED BY NEWLINE
 skip 1
 CHARACTERSET UTF8
 FIELDS TERMINATED BY ';'
 OPTIONALLY ENCLOSED BY '"'
 MISSING FIELD VALUES ARE NULL
 (nombre, descripcion, video)
 )
 LOCATION ('Ejercicios.csv')
 );

SELECT * FROM EJERCICIOS_EXT;


CREATE INDEX NOMBRE_IDX ON USUARIO(NOMBRE) TABLESPACE TS_INDICES;
CREATE INDEX UPPERAPELLIDOS_IDX ON USUARIO(UPPER(APELLIDOS)) TABLESPACE TS_INDICES;
select * from user_indexes;

CREATE BITMAP INDEX CENTRO_ID_BTMP ON CLIENTE(CENTRO_ID) TABLESPACE TS_INDICES;
SELECT index_name, index_type
FROM user_indexes
WHERE table_name = 'CLIENTE';


CREATE MATERIALIZED VIEW VM_EJERCICIOS
REFRESH FORCE START WITH SYSDATE NEXT SYSDATE + 1
AS SELECT * FROM ejercicios_ext;

CREATE SYNONYM S_EJERCICIOS FOR VM_EJERCICIOS;


CREATE SEQUENCE SEQ_EJERCICIOS;

create or replace trigger tr_EJERCICIOS
before insert on EJERCICIO for each row
begin
if :new.ID is null then
 :new.ID := SEQ_EJERCICIOS.NEXTVAL;
end if;
END tr_EJERCICIOS;
/

insert into ejercicio(nombre,descripcion,video) SELECT s_ejercicios.nombre,s_ejercicios.descripcion,s_ejercicios.video FROM S_EJERCICIOS;


--SEGUNDA PARTE

--Desde system

CREATE ROLE Administrador;
CREATE ROLE Gerente;
CREATE ROLE Entrenador_dyf;
CREATE ROLE Entrenador_n;
CREATE ROLE Cliente;
GRANT DBA to Administrador;
GRANT Administrador to LIFEFIT;

--DESDE LIFEFIT

GRANT SELECT,INSERT,DELETE,UPDATE ON CENTRO TO GERENTE;
GRANT SELECT,INSERT,DELETE,UPDATE ON ENTRENADOR TO GERENTE;
GRANT INSERT,DELETE ON CLIENTE TO GERENTE;
GRANT SELECT,INSERT,DELETE,UPDATE ON EJERCICIO TO ENTRENADOR_DYF;
GRANT SELECT,INSERT,DELETE,UPDATE ON RUTINA TO ENTRENADOR_DYF;
GRANT SELECT,INSERT,DELETE,UPDATE ON CITA TO ENTRENADOR_DYF;
GRANT SELECT,INSERT,DELETE,UPDATE ON ELEMENTOCALENDARIO TO ENTRENADOR_DYF;
GRANT SELECT,INSERT,DELETE,UPDATE ON PLAN TO ENTRENADOR_DYF;
GRANT SELECT,INSERT,DELETE,UPDATE ON SESION TO ENTRENADOR_DYF;
GRANT SELECT,INSERT,DELETE,UPDATE ON DIETA TO ENTRENADOR_N;
GRANT UPDATE(DIETA_ID) ON CLIENTE TO ENTRENADOR_N;
GRANT UPDATE(OBJETIVO) ON CLIENTE TO CLIENTE;
GRANT UPDATE(DATOS_SALUD) ON SESION TO CLIENTE;
GRANT UPDATE(VIDEO) ON SESION TO CLIENTE;
GRANT UPDATE(DESCRIPCION) ON SESION TO CLIENTE;
ALTER TABLE EJERCICIO ADD (PUBLICO VARCHAR2(1) DEFAULT 'S');
CREATE VIEW VEJERCICIO AS SELECT * FROM EJERCICIO WHERE PUBLICO='S';
GRANT SELECT,INSERT,DELETE,UPDATE ON CONFORMAN TO ENTRENADOR_DYF;
GRANT SELECT,INSERT,DELETE,UPDATE ON ENTRENA TO GERENTE;
--RF5
CREATE OR REPLACE VIEW CONTROL_SESIONES_CLIENTE AS 
(SELECT INICIO, FIN, PRESENCIAL, DESCRIPCION, VIDEO, DATOS_SALUD FROM SESION JOIN USUARIO ON ID = plan_entrena_cliente_id WHERE usuariooracle = USER);
GRANT SELECT ON CONTROL_SESIONES_CLIENTE TO CLIENTE;

SET SERVEROUTPUT ON;
DECLARE
    -- Declara una variable para almacenar los datos del cliente
    v_datos_cliente base.TCLIENTE;

    -- Declara variables para almacenar los datos del usuario y cliente creados
    v_usuario USUARIO%ROWTYPE;
    v_cliente CLIENTE%ROWTYPE;
BEGIN
    -- Inicializa los datos del cliente
    v_datos_cliente.NOMBRE := 'John';
    v_datos_cliente.APELLIDOS := 'Doe';
    v_datos_cliente.TELEFONO := '123456789';
    v_datos_cliente.DIRECCION := '123 Main Street';
    v_datos_cliente.CORREOE := 'john@example.com';
    v_datos_cliente.OBJETIVOS := 'Perder peso';
    v_datos_cliente.DIETA := 1; -- Este valor deberÃ­a ser ajustado segÃºn la lÃ³gica de tu aplicaciÃ³n
    v_datos_cliente.PREFERENCIAS := 'Cardio';
    v_datos_cliente.CENTRO := 10;

    -- Llama al procedimiento CREA_CLIENTE para crear el cliente
    base.CREA_CLIENTE(v_datos_cliente, 'password123', v_usuario, v_cliente);

    -- Imprime los datos del usuario y cliente creados
    DBMS_OUTPUT.PUT_LINE('Usuario creado:');
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_usuario.ID);
    DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || v_usuario.NOMBRE);
    DBMS_OUTPUT.PUT_LINE('APELLIDOS: ' || v_usuario.APELLIDOS);
    -- Imprime los demÃ¡s campos del usuario si es necesario

    DBMS_OUTPUT.PUT_LINE('Cliente creado:');
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_cliente.ID);
    DBMS_OUTPUT.PUT_LINE('OBJETIVOS: ' || v_cliente.OBJETIVO);
    -- Imprime los demÃ¡s campos del cliente si es necesario
EXCEPTION
    WHEN OTHERS THEN
        -- Manejo de errores
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
create or replace trigger tr_USUARIOS
before insert on USUARIO for each row
begin
if :new.ID is null then
 :new.ID := SEQ_USUARIOS.NEXTVAL;
 
end if;
IF :new.USUARIOORACLE IS NULL THEN
        :new.USUARIOORACLE := 'usuariooracle' || :new.ID;
    END IF;
END tr_USUARIOS

--DESDE SYSTEM
GRANT GRANT ANY ROLE TO LIFEFIT;
GRANT CREATE USER TO LIFEFIT;
grant connect to cliente;
grant connect to Gerente;
grant connect to Entrenador_dyf;
grant connect to Entrenador_n;
--DESDE BODY DEL PAQUETE BASE

    PROCEDURE CREA_CLIENTE(
        P_DATOS IN TCLIENTE,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_CLIENTE OUT CLIENTE%ROWTYPE
    )AS
        v_user VARCHAR2 (250 CHAR);
        v_rol VARCHAR2 (250 CHAR);
    BEGIN
        SAVEPOINT CREA_CLIENTE_POINT;
        INSERT INTO USUARIO(NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE)
        VALUES (P_DATOS.NOMBRE, P_DATOS.APELLIDOS, P_DATOS.TELEFONO, P_DATOS.DIRECCION, P_DATOS.CORREOE)
        RETURNING ID, NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE, usuariooracle INTO P_USUARIO;
        INSERT INTO CLIENTE(ID, objetivo, dieta_id, preferencias, centro_id)
        VALUES ( p_usuario.ID, P_DATOS.OBJETIVOS, p_datos.DIETA, P_DATOS.PREFERENCIAS, P_DATOS.CENTRO)
        RETURNING  ID, OBJETIVO, PREFERENCIAS, DIETA_ID,centro_id INTO P_CLIENTE;
        v_user := 'CREATE USER ' || P_USUARIO.USUARIOORACLE || ' IDENTIFIED BY ' || P_USERPASS || ' DEFAULT TABLESPACE TS_LIFEFIT QUOTA UNLIMITED ON TS_LIFEFIT';
        v_rol := ' GRANT Cliente TO ' || P_USUARIO.USUARIOORACLE;
	BEGIN
        EXECUTE IMMEDIATE v_user;
        EXECUTE IMMEDIATE v_rol;
		EXCEPTION
			WHEN OTHER THEN
				EXECUTE IMMEDIATE 'DROP USER ' || 			P_USUARIO.USUARIOORACLE;
	END

        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK TO CREA_CLIENTE_POINT;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE EXCEPCION_CREACION;
    END CREA_CLIENTE;

