ALTER SYSTEM SET "WALLET_ROOT"='C:\app\alumnos\admin\orcl\xdb_wallet' scope=SPFILE;

ALTER SYSTEM SET TDE_CONFIGURATION="KEYSTORE_CONFIGURATION=FILE" scope=both;
--MARK:Creacion de tablespaces
--Desde system
--Creamos el usuario LIFEFIT y le damos permisos basicos
CREATE TABLESPACE TS_LIFEFIT DATAFILE 'C:\APP\ALUMNOS\ORADATA\ORCL\LIFEFIT.DBF' SIZE 10M AUTOEXTEND ON;
CREATE USER LIFEFIT IDENTIFIED BY LIFEFIT123
    DEFAULT TABLESPACE TS_LIFEFIT
    QUOTA UNLIMITED ON TS_LIFEFIT;
GRANT CREATE TABLE, CONNECT TO LIFEFIT;

--DESDE SYSTEM CREAMOS EL TABLESPACE para indices 
CREATE TABLESPACE TS_INDICES DATAFILE 'C:\APP\ALUMNOS\ORADATA\ORCL\INDICES.DBF' SIZE 50M AUTOEXTEND ON;
GRANT CREATE SYNONYM TO LIFEFIT;
GRANT CREATE SEQUENCE TO LIFEFIT;
GRANT CREATE MATERIALIZED VIEW TO LIFEFIT;


--DESDE LIFEFIT
SELECT * FROM USER_TABLES;
DROP TABLE CLIENTE;
COMMIT;

--Desde LIFEFIT

--MARK: Tablas
--Creacion de todas las tablas necesarias , con claves primarias

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
    video                      VARCHAR2(4000 CHAR),
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
--MARK: Columnas cifradas
CREATE TABLE usuario (
    id            NUMBER(5) NOT NULL,
    nombre        VARCHAR2(100 CHAR) NOT NULL,
    apellidos     VARCHAR2(100 CHAR) NOT NULL,
    telefono      VARCHAR2(9 CHAR) ENCRYPT NOT NULL,
    direccion     VARCHAR2(100 CHAR) ENCRYPT,
    correoe       VARCHAR2(100 CHAR) ENCRYPT,
    usuariooracle VARCHAR2(100 CHAR)
);

ALTER TABLE usuario ADD CONSTRAINT usuario_pk PRIMARY KEY ( id ) USING INDEX TABLESPACE TS_INDICES;


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



--Desde LIFEFIT 
--MARK: Datos
--Rellenar con datos las tablas

Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('10','Gimnasio FitLife','Calle de la Victoria, 12','29012');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('20','Gimnasio SportZone','Avenida de Andalucía, 34','29006');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('30','Gimnasio Vitality','Calle de la Unión, 8','29004');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('40','Gimnasio BodyFit','Calle de la Paz, 21','29002');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('50','Gimnasio PowerFlex','Avenida de la Constitución, 45','29008');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('60','Gimnasio ActiveLife','Calle de la Alcazabilla, 17','29015');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('70','Gimnasio IronStrong','Calle de la Trinidad, 5','29001');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('80','Gimnasio FitZone','Avenida de la Malagueta, 28','29016');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('90','Gimnasio Wellness','Calle de la Merced, 10','29013');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('100','Gimnasio FlexFit','Avenida de la Aurora, 9','29005');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('110','Gimnasio BodyTech','Calle de la Alameda, 22','29014');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('120','Gimnasio EliteFitness','Avenida de la Rosaleda, 7','29010');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('130','Gimnasio ActiveZone','Calle de la Victoria, 18','29011');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('140','Gimnasio PowerGym','Avenida de la Malagueta, 12','29017');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('150','Gimnasio FitFlex','Calle de la Unión, 14','29003');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('160','Gimnasio SportLife','Avenida de Andalucía, 22','29007');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('170','Gimnasio VitalFit','Calle de la Paz, 31','29001');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('180','Gimnasio BodyZone','Avenida de la Constitución, 50','29009');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('190','Gimnasio IronFit','Calle de la Alcazabilla, 21','29016');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('200','Gimnasio FitStrong','Calle de la Trinidad, 8','29002');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('210','Gimnasio ActiveFit','Avenida de la Malagueta, 32','29018');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('220','Gimnasio WellnessZone','Calle de la Merced, 15','29014');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('230','Gimnasio FlexLife','Avenida de la Aurora, 12','29006');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('240','Gimnasio BodyFlex','Calle de la Alameda, 25','29015');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('250','Gimnasio EliteFit','Avenida de la Rosaleda, 10','29011');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('260','Gimnasio ActiveGym','Calle de la Victoria, 20','29010');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('270','Gimnasio PowerLife','Avenida de la Malagueta, 15','29017');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('280','Gimnasio FitTech','Calle de la Unión, 10','29003');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('290','Gimnasio SportFlex','Avenida de Andalucía, 28','29008');
Insert into LIFEFIT.CENTRO (ID,NOMBRE,DIRECCION,CPOSTAL) values ('300','Gimnasio VitalFlex','Calle de la Paz, 28','29001');

Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('31','alvaro','luque torres','584858458',null,null,'usuariooracle31');
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('1','Ana','García Pérez','678123456','Calle del Sol, 5','ana.garcia@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('2','José','López Martínez','612987654','Avenida de la Luna, 12','jose.lopez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('3','María','Rodríguez Sánchez','655234567','Calle de la Playa, 8','maria.rodriguez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('4','David','Fernández González','633345678','Avenida del Mar, 20','david.fernandez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('5','Laura','Martín Romero','644456789','Calle de la Montaña, 15','laura.martin@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('6','Carlos','Pérez García','600567890','Avenida del Bosque, 30','carlos.perez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('7','Sofía','González López','677678901','Calle del Río, 25','sofia.gonzalez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('8','Pablo','Romero Martínez','688789012','Avenida de la Ciudad, 18','pablo.romero@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('9','Isabel','Sánchez Rodríguez','655890123','Calle de la Estrella, 10','isabel.sanchez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('10','Adrián','López Fernández','633901234','Avenida del Parque, 22','adrian.lopez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('11','Andrea','Rodríguez García','644012345','Calle del Paseo, 14','andrea.rodriguez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('12','Javier','Fernández Pérez','600123456','Avenida de la Plaza, 28','javier.fernandez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('13','Paula','Martín Sánchez','677234567','Calle de la Fuente, 7','paula.martin@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('14','Alejandro','Pérez Romero','688345678','Avenida del Jardín, 9','alejandro.perez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('15','Elena','González Martínez','655456789','Calle de la Cuesta, 11','elena.gonzalez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('16','Miguel','Romero López','633567890','Avenida de la Colina, 5','miguel.romero@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('17','Valeria','Sánchez García','644678901','Calle del Bosque, 12','valeria.sanchez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('18','Daniel','López Sánchez','600789012','Avenida del Mar, 17','daniel.lopez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('19','Alba','Rodríguez Pérez','677890123','Calle de la Luna, 20','alba.rodriguez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('20','Iván','Fernández Martínez','688901234','Avenida de la Playa, 14','ivan.fernandez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('21','Carmen','Martín García','655012345','Calle de la Montaña, 9','carmen.martin@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('22','Rubén','Pérez Romero','633123456','Avenida del Río, 22','ruben.perez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('23','Sara','González Sánchez','644234567','Calle de la Ciudad, 16','sara.gonzalez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('24','Aitor','Romero López','600345678','Avenida de la Estrella, 8','aitor.romero@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('25','Natalia','López García','677456789','Calle del Parque, 11','natalia.lopez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('26','Hugo','Rodríguez Martínez','688567890','Avenida del Paseo, 19','hugo.rodriguez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('27','Olivia','Fernández Pérez','655678901','Calle de la Plaza, 27','olivia.fernandez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('28','Diego','Martín Sánchez','633789012','Avenida de la Fuente, 6','diego.martin@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('29','Valentina','Pérez Romero','644890123','Calle del Jardín, 8','valentina.perez@email.com',null);
Insert into LIFEFIT.USUARIO (ID,NOMBRE,APELLIDOS,TELEFONO,DIRECCION,CORREOE,USUARIOORACLE) values ('30','Álvaro','González Martínez','600901234','Avenida de la Cuesta, 10','alvaro.gonzalez@email.com',null);

Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Sentadillas','Ejercicio básico para fortalecer las piernas. Párate con los pies separados al ancho de los hombros y baja el cuerpo doblando las rodillas, manteniendo la espalda recta. Luego, vuelve a la posición inicial.','https://www.youtube.com/watch?v=QKKZ9AGYTi4');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Flexiones de Brazos','Ejercicio para fortalecer los músculos del pecho, hombros y tríceps. Apóyate en el suelo con las manos a la altura de los hombros, manteniendo el cuerpo recto y descendiendo hasta que los codos estén en un ángulo de 90 grados','https://www.youtube.com/watch?v=UwRLWMcOdwI');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Plancha Abdominal','Ejercicio de isometría para fortalecer el core. Colócate en posición de plancha, apoyando el peso en los antebrazos y los dedos de los pies, manteniendo el cuerpo recto y los músculos abdominales contraídos.','https://www.youtube.com/watch?v=TvxNkmjdhMM');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Levantamiento de Pesas','Ejercicio de fuerza que se puede adaptar a diferentes grupos musculares. Utiliza pesas adecuadas para tu nivel de fuerza, mantén una postura adecuada y realiza movimientos controlados para evitar lesiones.','https://www.youtube.com/watch?v=qEwKCR5JCog');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Burpees','Ejercicio que combina flexiones, saltos y sentadillas. Comienza en posición de cuclillas, luego apoya las manos en el suelo, estira las piernas hacia atrás realizando una flexión, lleva las piernas de vuelta a la posición de cuclillas y salta','https://www.youtube.com/watch?v=JZQA08SlJnM');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Dominadas','Ejercicio para fortalecer la espalda y los brazos. Agárrate a una barra con las manos separadas al ancho de los hombros y levántate hasta que la barbilla esté por encima de la barra. Luego, baja lentamente hasta la posición inicial.','https://www.youtube.com/watch?v=eGo4IYlbE5g');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Zancadas','Ejercicio para fortalecer las piernas y glúteos. Da un paso adelante con una pierna y flexiona ambas rodillas hasta que las piernas formen ángulos de 90 grados. Luego, vuelve a la posición inicial y repite con la otra pierna.','https://www.youtube.com/watch?v=QOVaHwm-Q6U');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Flexiones Diamante','Variante de las flexiones que enfatiza más en los tríceps. Coloca las manos juntas debajo del pecho, formando un diamante con los pulgares y los índices. Realiza las flexiones manteniendo los codos cerca del cuerpo.','https://www.youtube.com/watch?v=Jx4cT2Ny8Mg');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Elevaciones Laterales','Ejercicio para fortalecer los hombros y los músculos del deltoides medio. De pie, con una mancuerna en cada mano, levanta los brazos hacia los lados hasta que estén paralelos al suelo, luego baja lentamente.','https://www.youtube.com/watch?v=yho0e_9rOwA');
Insert into LIFEFIT.EJERCICIOS_EXT (NOMBRE,DESCRIPCION,VIDEO) values ('Plancha Lateral','Ejercicio para trabajar los músculos abdominales, oblicuos y estabilizadores del core. Acuéstate de lado apoyándote en el antebrazo y el costado del pie, mantén el cuerpo en línea recta y sostén la posición durante el tiempo deseado.','https://www.youtube.com/watch?v=zf0RBDYF8iE');

INSERT INTO centro (id, nombre, direccion, cpostal) VALUES (1, 'Centro Salud A', 'Calle 1', '28001');
INSERT INTO centro (id, nombre, direccion, cpostal) VALUES (2, 'Centro Salud B', 'Calle 2', '28002');
INSERT INTO centro (id, nombre, direccion, cpostal) VALUES (3, 'Centro Salud C', 'Calle 3', '28003');
INSERT INTO cita (fechayhora, id, modalidad, cliente_id) VALUES (TO_DATE('2023-05-10 10:00', 'YYYY-MM-DD HH24:MI'), 1, 'Presencial', 1);
INSERT INTO cita (fechayhora, id, modalidad, cliente_id) VALUES (TO_DATE('2023-05-11 11:00', 'YYYY-MM-DD HH24:MI'), 2, 'Virtual', 2);
-- Agrega más insert hasta completar 20 registros.
INSERT INTO cliente (id, objetivo, preferencias, dieta_id, centro_id) VALUES (2, 'Ganar músculo', 'Vegetariano', 2, 2);
-- Agrega más insert hasta completar 20 registros.
INSERT INTO conforman (series, repeticiones, duracion, rutina_id, ejercicio_id) VALUES ('3', '12', '45 min', 1, 1);
INSERT INTO conforman (series, repeticiones, duracion, rutina_id, ejercicio_id) VALUES ('4', '10', '30 min', 2, 2);
-- Agrega más insert hasta completar 20 registros.
INSERT INTO dieta (id, nombre, descripcion, tipo) VALUES (2, 'Dieta Paleo', 'Dieta basada en alimentos no procesados', 'Paleo');
-- Agrega más insert hasta completar 20 registros.
INSERT INTO elementocalendario (fechayhora, entrenador_id) VALUES (TO_DATE('2023-05-10 10:00', 'YYYY-MM-DD HH24:MI'), 1);
INSERT INTO elementocalendario (fechayhora, entrenador_id) VALUES (TO_DATE('2023-05-11 11:00', 'YYYY-MM-DD HH24:MI'), 2);
-- Agrega más insert hasta completar 20 registros.
INSERT INTO entrena (especialidad, entrenador_id, cliente_id) VALUES ('Cardio', 1, 1);
INSERT INTO entrena (especialidad, entrenador_id, cliente_id) VALUES ('Fuerza', 2, 2);
-- Agrega más insert hasta completar 20 registros.
INSERT INTO entrenador (id, disponibilidad, centro_id) VALUES (1, 'Lunes a Viernes', 1);
INSERT INTO entrenador (id, disponibilidad, centro_id) VALUES (2, 'Fines de semana', 2);
-- Agrega más insert hasta completar 20 registros.
INSERT INTO gerente (id, despacho, horario, centro_id) VALUES (1, 'Despacho 1', '09:00-17:00', 1);
INSERT INTO gerente (id, despacho, horario, centro_id) VALUES (2, 'Despacho 2', '10:00-18:00', 2);
-- Agrega más insert hasta completar 20 registros.
INSERT INTO plan (inicio, fin, rutina_id, entrena_cliente_id, entrena_entrenador_id) VALUES (TO_DATE('2023-05-01', 'YYYY-MM-DD'), TO_DATE('2023-06-01', 'YYYY-MM-DD'), 1, 1, 1);
INSERT INTO plan (inicio, fin, rutina_id, entrena_cliente_id, entrena_entrenador_id) VALUES (TO_DATE('2023-06-01', 'YYYY-MM-DD'), TO_DATE('2023-07-01', 'YYYY-MM-DD'), 2, 2, 2);
-- Agrega más insert hasta completar 20 registros.
INSERT INTO rutina (id, nombre, descripcion) VALUES (1, 'Rutina A', 'Rutina básica para principiantes');
INSERT INTO rutina (id, nombre, descripcion) VALUES (2, 'Rutina B', 'Rutina intermedia');
-- Agrega más insert hasta completar 20 registros.

--Desde system
--Creacion de directorio externo
create or replace directory directorio_ext as 'C:\app\alumnos\admin\orcl\dpdump';
grant read, write on directory directorio_ext to LIFEFIT;

--Desde LIFEFIT
--Creacion de tabla externa
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

--MARK:Creacion indices

CREATE INDEX NOMBRE_IDX ON USUARIO(NOMBRE) TABLESPACE TS_INDICES;
CREATE INDEX UPPERAPELLIDOS_IDX ON USUARIO(UPPER(APELLIDOS)) TABLESPACE TS_INDICES;
CREATE BITMAP INDEX CENTRO_ID_BTMP ON CLIENTE(CENTRO_ID) TABLESPACE TS_INDICES;
SELECT index_name, index_type
FROM user_indexes
WHERE table_name = 'CLIENTE';

--MARK:VM_EJERCICIOS

CREATE MATERIALIZED VIEW VM_EJERCICIOS
REFRESH FORCE START WITH SYSDATE NEXT SYSDATE + 1
AS SELECT * FROM ejercicios_ext;

CREATE SYNONYM S_EJERCICIOS FOR VM_EJERCICIOS;

--El disparador para el id al insertar en EJERCICIO

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
--MARK: Permisos
--Desde system
--Creacion de los roles y permiso para lifefit

CREATE ROLE Administrador;
CREATE ROLE Gerente;
CREATE ROLE Entrenador_dyf;
CREATE ROLE Entrenador_n;
CREATE ROLE Cliente;
GRANT DBA to Administrador;
GRANT Administrador to LIFEFIT;

--DESDE LIFEFIT
--Los permisos para el resto de roles

--GRANT SELECT,INSERT,DELETE,UPDATE ON CENTRO TO GERENTE;
CREATE OR REPLACE VIEW CENTRO_PARA_GERENTE AS 
SELECT C.*
FROM CENTRO C
JOIN GERENTE G ON C.ID = G.centro_id  
JOIN USUARIO U ON G.ID = U.ID 
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT,INSERT,DELETE,UPDATE ON CENTRO_PARA_GERENTE TO GERENTE;

--GRANT SELECT,INSERT,DELETE,UPDATE ON ENTRENADOR TO GERENTE;
CREATE OR REPLACE VIEW ENTRENADOR_PARA_GERENTE AS 
SELECT E.*
FROM CENTRO C
JOIN GERENTE G ON C.ID = G.centro_id  
JOIN USUARIO U ON G.ID = U.ID
JOIN ENTRENADOR E ON C.ID = E.centro_id
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT,INSERT,DELETE,UPDATE ON ENTRENADOR_PARA_GERENTE TO GERENTE;

--GRANT SELECT,INSERT,DELETE ON CLIENTE TO GERENTE;
CREATE OR REPLACE VIEW CLIENTE_PARA_GERENTE AS 
SELECT CL.*
FROM CENTRO C
JOIN GERENTE G ON C.ID = G.centro_id  
JOIN USUARIO U ON G.ID = U.ID
JOIN CLIENTE CL ON C.ID = CL.centro_id
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT,INSERT,DELETE ON CLIENTE_PARA_GERENTE TO GERENTE;

--GRANT SELECT,INSERT,DELETE,UPDATE ON ENTRENA TO GERENTE;
CREATE OR REPLACE VIEW ENTRENA_PARA_GERENTE AS 
SELECT EN.*
FROM CENTRO C
JOIN GERENTE G ON C.ID = G.centro_id  
JOIN USUARIO U ON G.ID = U.ID
JOIN ENTRENADOR E ON C.ID = E.centro_id
JOIN ENTRENA EN ON E.ID = EN.entrenador_id
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT,INSERT,DELETE,UPDATE ON ENTRENA_PARA_GERENTE TO GERENTE;

--GRANT SELECT,INSERT,DELETE,UPDATE ON CONFORMAN TO ENTRENADOR_DYF;
CREATE OR REPLACE VIEW CONFORMAN_PARA_ENTRENADOR_DYF AS
SELECT * FROM CONFORMAN;
GRANT SELECT,INSERT,DELETE,UPDATE ON CONFORMAN_PARA_ENTRENADOR_DYF TO ENTRENADOR_DYF;

--GRANT SELECT,INSERT,DELETE,UPDATE ON EJERCICIO TO ENTRENADOR_DYF;
CREATE OR REPLACE VIEW EJERCICIO_PARA_ENTRENADOR_DYF AS
SELECT * FROM EJERCICIO;
GRANT SELECT,INSERT,DELETE,UPDATE ON EJERCICIO_PARA_ENTRENADOR_DYF TO ENTRENADOR_DYF;

--GRANT SELECT,INSERT,DELETE,UPDATE ON RUTINA TO ENTRENADOR_DYF;
CREATE OR REPLACE VIEW RUTINA_PARA_ENTRENADOR_DYF AS
SELECT * FROM RUTINA;
GRANT SELECT,INSERT,DELETE,UPDATE ON RUTINA_PARA_ENTRENADOR_DYF TO ENTRENADOR_DYF;

--GRANT SELECT,INSERT,DELETE,UPDATE ON CITA TO ENTRENADOR_DYF;
CREATE OR REPLACE VIEW CITA_PARA_ENTRENADOR_DYF AS 
SELECT CI.*
FROM CITA CI
JOIN ELEMENTOCALENDARIO EL ON EL.fechayhora = CI.fechayhora 
JOIN ENTRENADOR E ON E.ID = EL.entrenador_id
JOIN USUARIO U ON E.ID = U.ID
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT,INSERT,DELETE,UPDATE ON CITA_PARA_ENTRENADOR_DYF TO ENTRENADOR_DYF;

--GRANT SELECT,INSERT,DELETE,UPDATE ON ELEMENTOCALENDARIO TO ENTRENADOR_DYF;
CREATE OR REPLACE VIEW ELEMENTOCALENDARIO_PARA_ENTRENADOR_DYF AS 
SELECT EL.*
FROM ELEMENTOCALENDARIO EL
JOIN ENTRENADOR E ON E.ID = EL.entrenador_id
JOIN USUARIO U ON E.ID = U.ID
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT,INSERT,DELETE,UPDATE ON ELEMENTOCALENDARIO_PARA_ENTRENADOR_DYF TO ENTRENADOR_DYF;

--GRANT SELECT,INSERT,DELETE,UPDATE ON PLAN TO ENTRENADOR_DYF;
CREATE OR REPLACE VIEW PLAN_PARA_ENTRENADOR_DYF AS 
SELECT P.*
FROM PLAN P
JOIN ENTRENADOR E ON P.entrena_entrenador_id = E.ID
JOIN USUARIO U ON E.ID = U.ID
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT,INSERT,DELETE,UPDATE ON PLAN_PARA_ENTRENADOR_DYF TO ENTRENADOR_DYF;


--GRANT SELECT,INSERT,DELETE,UPDATE ON SESION TO ENTRENADOR_DYF;
CREATE OR REPLACE VIEW SESION_PARA_ENTRENADOR_DYF AS 
SELECT S.*
FROM SESION S
JOIN ENTRENADOR E ON S.plan_entrena_entrenador_id = E.ID
JOIN USUARIO U ON E.ID = U.ID
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT,INSERT,DELETE,UPDATE ON SESION_PARA_ENTRENADOR_DYF TO ENTRENADOR_DYF;

--GRANT SELECT,INSERT,DELETE,UPDATE ON DIETA TO ENTRENADOR_N;
CREATE OR REPLACE VIEW DIETA_PARA_ENTRENADOR_N AS
SELECT * FROM DIETA;
GRANT SELECT,INSERT,DELETE,UPDATE ON DIETA_PARA_ENTRENADOR_N TO ENTRENADOR_N;

GRANT UPDATE(DIETA_ID) ON CLIENTE TO ENTRENADOR_N;
--GRANT UPDATE(OBJETIVO) ON CLIENTE TO CLIENTE;
--GRANT UPDATE(DATOS_SALUD) ON SESION TO CLIENTE;
--GRANT UPDATE(VIDEO) ON SESION TO CLIENTE;
--GRANT UPDATE(DESCRIPCION) ON SESION TO CLIENTE;

--MARK: VEJERCICIO
ALTER TABLE EJERCICIO ADD (PUBLICO VARCHAR2(1) DEFAULT 'S');
CREATE VIEW VEJERCICIO AS SELECT * FROM EJERCICIO WHERE PUBLICO='S';





--MARK:RF5
ALTER TABLE SESION ADD (ESTADO VARCHAR2(15) CONSTRAINT ESTADO_ENUM CHECK (ESTADO IN ('HECHOS', 'PARCIALES', 'SALTADOS')));
CREATE OR REPLACE VIEW CONTROL_SESIONES_CLIENTE AS 
(SELECT INICIO, FIN, PRESENCIAL, DESCRIPCION, VIDEO, DATOS_SALUD, ESTADO FROM SESION JOIN USUARIO ON ID = plan_entrena_cliente_id 
WHERE UPPER(usuariooracle) = USER);
GRANT SELECT, UPDATE(VIDEO, DATOS_SALUD, DESCRIPCION, ESTADO) ON CONTROL_SESIONES_CLIENTE TO CLIENTE;

CREATE OR REPLACE VIEW PERFIL AS 
SELECT OBJETIVO, PREFERENCIAS 
FROM CLIENTE C 
JOIN USUARIO U ON C.ID = U.ID 
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT, UPDATE ON PERFIL TO CLIENTE;

--MARK:RF6
CREATE OR REPLACE VIEW VIDEOS AS 
SELECT VIDEO
FROM SESION S
JOIN ENTRENA P ON P.ENTRENADOR_ID = S.PLAN_ENTRENA_ENTRENADOR_ID 
JOIN USUARIO U ON U.ID = P.ENTRENADOR_ID
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT ON VIDEOS TO ENTRENADOR_DYF;

CREATE OR REPLACE VIEW ESTADO AS 
SELECT C.ID,C.OBJETIVO, S.ESTADO, S.DATOS_SALUD, S.DESCRIPCION
FROM SESION S
JOIN ENTRENA P ON P.ENTRENADOR_ID = S.PLAN_ENTRENA_ENTRENADOR_ID 
JOIN CLIENTE C ON C.ID = P.ENTRENA_CLIENTE_ID
JOIN USUARIO U ON U.ID = P.ENTRENADOR_ID
WHERE UPPER(usuariooracle) = USER;
GRANT SELECT ON ESTADO TO ENTRENADOR_DYF;


--MARK: VPD
CREATE OR REPLACE FUNCTION vpd_function(p_schema VARCHAR2, p_obj VARCHAR2)
  RETURN VARCHAR2
AS
  v_role VARCHAR2(10);
BEGIN
  IF USER = 'LIFEFIT' THEN
    RETURN ''; 
  ELSE
    RETURN 'UPPER(usuariooracle) = SYS_CONTEXT(''USERENV'', ''SESSION_USER'')';
  END IF;
END;
/

begin dbms_rls.add_policy (object_schema =>'LIFEFIT',
object_name =>'USUARIO',
policy_name =>'datos_personales',
function_schema =>'LIFEFIT',
policy_function => 'vpd_function',
statement_types => 'SELECT'); 
end;
/

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
/

-- Datos para comprobar la funcionalidad de los procedures
DECLARE
    v_datos_cliente base.TCLIENTE;
    v_userpass VARCHAR2(20) := 'password123';
    v_usuario USUARIO%ROWTYPE;
    v_cliente CLIENTE%ROWTYPE;
BEGIN
    -- Datos del cliente
    v_datos_cliente.NOMBRE := 'Juan';
    v_datos_cliente.APELLIDOS := 'Pérez';
    v_datos_cliente.TELEFONO := '123456789';
    v_datos_cliente.DIRECCION := 'Calle Falsa 123';
    v_datos_cliente.CORREOE := 'juan.perez@example.com';
    v_datos_cliente.OBJETIVOS := 'Perder peso';
    v_datos_cliente.PREFERENCIAS := 'Vegetariano';
    v_datos_cliente.DIETA := 1; -- Suponiendo que la dieta con ID 1 existe
    v_datos_cliente.CENTRO := 1; -- Suponiendo que el centro con ID 1 existe
    
    base.CREA_CLIENTE(
        P_DATOS => v_datos_cliente,
        P_USERPASS => v_userpass,
        P_USUARIO => v_usuario,
        P_CLIENTE => v_cliente
    );
    
    DBMS_OUTPUT.PUT_LINE('Cliente creado con ID: ' || v_cliente.ID);
END;
/
DECLARE
    v_datos_entrenador base.TENTRENADOR;
    v_userpass VARCHAR2(20) := 'password456';
    v_usuario USUARIO%ROWTYPE;
    v_entrenador ENTRENADOR%ROWTYPE;
BEGIN
    -- Datos del entrenador
    v_datos_entrenador.NOMBRE := 'Ana';
    v_datos_entrenador.APELLIDOS := 'García';
    v_datos_entrenador.TELEFONO := '987654321';
    v_datos_entrenador.DIRECCION := 'Avenida Siempre Viva 742';
    v_datos_entrenador.CORREOE := 'ana.garcia@example.com';
    v_datos_entrenador.DISPONIBILIDAD := 'Lunes a Viernes, 9-17h';
    v_datos_entrenador.CENTRO := 2; -- Suponiendo que el centro con ID 2 existe
    
    base.CREA_ENTRENADOR(
        P_DATOS => v_datos_entrenador,
        P_USERPASS => v_userpass,
        P_USUARIO => v_usuario,
        P_ENTRENADOR => v_entrenador
    );
    
    DBMS_OUTPUT.PUT_LINE('Entrenador creado con ID: ' || v_entrenador.ID);
END;
/
DECLARE
    v_datos_gerente base.TGERENTE;
    v_userpass VARCHAR2(20) := 'password789';
    v_usuario USUARIO%ROWTYPE;
    v_gerente GERENTE%ROWTYPE;
BEGIN
    -- Datos del gerente
    v_datos_gerente.NOMBRE := 'Carlos';
    v_datos_gerente.APELLIDOS := 'López';
    v_datos_gerente.TELEFONO := '555444333';
    v_datos_gerente.DIRECCION := 'Plaza Mayor 1';
    v_datos_gerente.CORREOE := 'carlos.lopez@example.com';
    v_datos_gerente.DESPACHO := 'Despacho 101';
    v_datos_gerente.HORARIO := 'Lunes a Viernes, 8-18h';
    v_datos_gerente.CENTRO := 1; -- Suponiendo que el centro con ID 1 existe
    
    base.CREA_GERENTE(
        P_DATOS => v_datos_gerente,
        P_USERPASS => v_userpass,
        P_USUARIO => v_usuario,
        P_GERENTE => v_gerente
    );
    
    DBMS_OUTPUT.PUT_LINE('Gerente creado con ID: ' || v_gerente.ID);
END;
/

BEGIN
    BASE.elimina_centro(1);
END;
/
--DESDE SYSTEM
GRANT GRANT ANY ROLE TO LIFEFIT;
GRANT CREATE USER TO LIFEFIT;
GRANT DROP USER TO LIFEFIT
grant connect to cliente;
grant connect to Gerente;
grant connect to Entrenador_dyf;
grant connect to Entrenador_n;

--MARK: PAQUETE BASE
--DESDE PACKAGE BASE
create or replace PACKAGE BASE AS
    EXCEPCION_CREACION EXCEPTION;
    EXCEPCION_MODIFICACION EXCEPTION;
    EXCEPCION_ELIMINACION EXCEPTION;
    EXCEPCION_LECTURA EXCEPTION;
    TYPE TCLIENTE IS RECORD (
        NOMBRE USUARIO.NOMBRE%TYPE,
        APELLIDOS USUARIO.APELLIDOS%TYPE,
        TELEFONO USUARIO.TELEFONO%TYPE,
        DIRECCION USUARIO.DIRECCION%TYPE,
        CORREOE USUARIO.CORREOE%TYPE,
        OBJETIVOS CLIENTE.OBJETIVO%TYPE,
        DIETA CLIENTE.DIETA_ID%TYPE,
        PREFERENCIAS CLIENTE.PREFERENCIAS%TYPE,
        CENTRO CLIENTE.CENTRO_ID%TYPE
    );
    PROCEDURE CREA_CLIENTE(
        P_DATOS IN TCLIENTE,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_CLIENTE OUT CLIENTE%ROWTYPE
    );
    TYPE TENTRENADOR IS RECORD (
        NOMBRE USUARIO.NOMBRE%TYPE,
        APELLIDOS USUARIO.APELLIDOS%TYPE,
        TELEFONO USUARIO.TELEFONO%TYPE,
        DIRECCION USUARIO.DIRECCION%TYPE,
        CORREOE USUARIO.CORREOE%TYPE,
        DISPONIBILIDAD ENTRENADOR.DISPONIBILIDAD%TYPE,
        CENTRO ENTRENADOR.CENTRO_ID%TYPE
    );
    PROCEDURE CREA_ENTRENADOR(
        P_DATOS IN TENTRENADOR,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_ENTRENADOR OUT ENTRENADOR%ROWTYPE
    );
    TYPE TGERENTE IS RECORD (
        NOMBRE USUARIO.NOMBRE%TYPE,
        APELLIDOS USUARIO.APELLIDOS%TYPE,
        TELEFONO USUARIO.TELEFONO%TYPE,
        DIRECCION USUARIO.DIRECCION%TYPE,
        CORREOE USUARIO.CORREOE%TYPE,
        DESPACHO GERENTE.DESPACHO%TYPE,
        HORARIO GERENTE.HORARIO%TYPE,
        CENTRO GERENTE.CENTRO_ID%TYPE
    );
    PROCEDURE CREA_GERENTE(
        P_DATOS IN TCLIENTE,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_GERENTE OUT GERENTE%ROWTYPE
    );
    PROCEDURE ELIMINA_USER(P_ID USUARIO.ID%TYPE);
    PROCEDURE ELIMINA_CLIENTE(P_ID USUARIO.ID%TYPE);
    PROCEDURE ELIMINA_GERENTE(P_ID USUARIO.ID%TYPE);
    PROCEDURE ELIMINA_ENTRENADOR(P_ID USUARIO.ID%TYPE);
    PROCEDURE ELIMINA_CENTRO(P_ID CENTRO.ID%TYPE);
END BASE;
/
--MARK: PACKAGE BODY BASE
--DESDE BODY DEL PAQUETE BASE


create or replace PACKAGE BODY BASE AS 
    --MARK: Crea cliente
    PROCEDURE CREA_CLIENTE(
        P_DATOS IN TCLIENTE,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_CLIENTE OUT CLIENTE%ROWTYPE
    )AS
        PRAGMA AUTONOMOUS_TRANSACTION;
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
			WHEN OTHERS THEN
				EXECUTE IMMEDIATE 'DROP USER ' ||  P_USUARIO.USUARIOORACLE;
        END
        COMMIT;
        EXCEPTION 
            WHEN OTHERS THEN
                ROLLBACK TO CREA_CLIENTE_POINT;
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
                RAISE EXCEPCION_CREACION;
    END CREA_CLIENTE;
    --MARK: Crea entrenador
    PROCEDURE CREA_ENTRENADOR(
        P_DATOS IN TENTRENADOR,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_ENTRENADOR OUT ENTRENADOR%ROWTYPE
    )AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        v_user VARCHAR2 (250 CHAR);
        v_rol VARCHAR2 (250 CHAR);
    BEGIN
        SAVEPOINT CREA_ENTRENADOR_POINT;
        INSERT INTO USUARIO(NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE)
        VALUES (P_DATOS.NOMBRE, P_DATOS.APELLIDOS, P_DATOS.TELEFONO, P_DATOS.DIRECCION, P_DATOS.CORREOE)
        RETURNING ID, NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE, usuariooracle INTO P_USUARIO;
        INSERT INTO ENTRENADOR(ID, disponibilidad, centro_id)
        VALUES ( p_usuario.ID, P_DATOS.DISPONIBILIDAD, P_DATOS.CENTRO)
        RETURNING  ID, DISPONIBILIDAD,centro_id INTO P_ENTRENADOR;
        v_user := 'CREATE USER ' || P_USUARIO.USUARIOORACLE || ' IDENTIFIED BY ' || P_USERPASS || ' DEFAULT TABLESPACE TS_LIFEFIT QUOTA UNLIMITED ON TS_LIFEFIT';
        v_rol := ' GRANT Entrenador_DyF, Entrenador_N TO ' || P_USUARIO.USUARIOORACLE;
        BEGIN
            EXECUTE IMMEDIATE v_user;
            EXECUTE IMMEDIATE v_rol;
		EXCEPTION
			WHEN OTHERS THEN
				EXECUTE IMMEDIATE 'DROP USER ' ||  P_USUARIO.USUARIOORACLE;
        END
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK TO CREA_ENTRENADOR_POINT;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE EXCEPCION_CREACION;
    END CREA_ENTRENADOR;
    --MARK: Crea gerente
    PROCEDURE CREA_GERENTE(
        P_DATOS IN TGERENTE,
        P_USERPASS IN VARCHAR2,
        P_USUARIO OUT USUARIO%ROWTYPE,
        P_GERENTE OUT GERENTE%ROWTYPE
    )AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        v_user VARCHAR2 (250 CHAR);
        v_rol VARCHAR2 (250 CHAR);
    BEGIN
        SAVEPOINT CREA_GERENTE_POINT;
        INSERT INTO USUARIO(NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE)
        VALUES (P_DATOS.NOMBRE, P_DATOS.APELLIDOS, P_DATOS.TELEFONO, P_DATOS.DIRECCION, P_DATOS.CORREOE)
        RETURNING ID, NOMBRE, APELLIDOS, TELEFONO, DIRECCION, CORREOE, usuariooracle INTO P_USUARIO;
        INSERT INTO GERENTE(ID, DESPACHO, HORARIO, centro_id)
        VALUES ( P_USUARIO.ID, P_DATOS.DESPACHO, P_DATOS.HORARIO, P_DATOS.CENTRO)
        RETURNING  ID, DESPACHO, HORARIO, centro_id INTO P_GERENTE;
        v_user := 'CREATE USER ' || P_USUARIO.USUARIOORACLE || ' IDENTIFIED BY ' || P_USERPASS || ' DEFAULT TABLESPACE TS_LIFEFIT QUOTA UNLIMITED ON TS_LIFEFIT';
        v_rol := ' GRANT Gerente TO ' || P_USUARIO.USUARIOORACLE;
        BEGIN
            EXECUTE IMMEDIATE v_user;
            EXECUTE IMMEDIATE v_rol;
		EXCEPTION
			WHEN OTHERS THEN
				EXECUTE IMMEDIATE 'DROP USER ' ||  P_USUARIO.USUARIOORACLE;
        END
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK TO CREA_GERENTE_POINT;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE EXCEPCION_CREACION;
    END CREA_GERENTE;
    --MARK: elimina usuario
    PROCEDURE ELIMINA_USER(P_ID USUARIO.ID%TYPE)AS
        PRAGMA AUTONOMOUS_TRANSACTION;
        v_username  USUARIO.USUARIOORACLE%TYPE;
    BEGIN
        SAVEPOINT ELIMINA_USER_POINT;
        SELECT usuariooracle INTO v_username FROM USUARIO WHERE ID = P_ID;
        BEGIN 
            EXECUTE IMMEDIATE 'DROP USER ' || v_username;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE;  
        END;
        UPDATE USUARIO SET usuariooracle = NULL WHERE ID = P_ID;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO ELIMINA_USER_POINT;

            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            
            RAISE EXCEPCION_ELIMINACION;
    END ELIMINA_USER;
    --MARK: elimina cliente
    PROCEDURE ELIMINA_CLIENTE(P_ID USUARIO.ID%TYPE)AS
    BEGIN
        SAVEPOINT ELIMINA_CLIENTE_POINT;
        DELETE FROM SESION WHERE PLAN_ENTRENA_CLIENTE_ID=P_ID;
        DELETE FROM PLAN WHERE ENTRENA_CLIENTE_ID=P_ID;
        DELETE FROM ENTRENA WHERE cliente_id=P_ID;
        DELETE FROM cita WHERE cliente_id=P_ID;
        ELIMINA_USER(P_ID);
        DELETE FROM CLIENTE WHERE ID = P_ID;
        DELETE FROM USUARIO WHERE ID = P_ID;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO ELIMINA_CLIENTE_POINT;

            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            
            RAISE EXCEPCION_ELIMINACION;
    END ELIMINA_CLIENTE
    --MARK: elimina gerente
    PROCEDURE ELIMINA_GERENTE(P_ID USUARIO.ID%TYPE)AS
    BEGIN
        SAVEPOINT ELIMINA_GERENTE_POINT;
        ELIMINA_USER(P_ID);
        DELETE FROM GERENTE WHERE ID = P_ID;
        DELETE FROM USUARIO WHERE ID = P_ID;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO ELIMINA_GERENTE_POINT;

            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            
            RAISE EXCEPCION_ELIMINACION;
    END ELIMINA_GERENTE;
    --MARK: elimina entrenador
    PROCEDURE ELIMINA_ENTRENADOR(P_ID USUARIO.ID%TYPE)AS
    BEGIN
        SAVEPOINT ELIMINA_ENTRENADOR_POINT;
        DELETE FROM SESION WHERE PLAN_ENTRENA_ENTRENADOR_ID=P_ID;
        DELETE FROM PLAN WHERE ENTRENA_ENTRENADOR_ID=P_ID;
        DELETE FROM ENTRENA WHERE ENTRENADOR_id=P_ID;
        DELETE FROM elementocalendario WHERE ENTRENADOR_ID =P_ID;
        ELIMINA_USER(P_ID);
        DELETE FROM ENTRENADOR WHERE ID = P_ID;
        DELETE FROM USUARIO WHERE ID = P_ID;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO ELIMINA_ENTRENADOR_POINT;

            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            
            RAISE EXCEPCION_ELIMINACION;
    END ELIMINA_ENTRENADOR;
    --MARK: elimina centro
    PROCEDURE ELIMINA_CENTRO(P_ID CENTRO.ID%TYPE)AS
    BEGIN
        SAVEPOINT ELIMINA_CENTRO_POINT;
        -- Eliminar clientes
        FOR rec IN (SELECT id FROM cliente WHERE centro_id = P_ID) LOOP
            BEGIN
                ELIMINA_CLIENTE(rec.id);
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK TO ELIMINA_CENTRO_POINT;
                    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
                    RAISE EXCEPCION_ELIMINACION;
            END;
        END LOOP;
    
        -- Eliminar entrenadores
        FOR rec IN (SELECT id FROM entrenador WHERE centro_id = P_ID) LOOP
            BEGIN
                ELIMINA_ENTRENADOR(rec.id);
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK TO ELIMINA_CENTRO_POINT;
                    
                    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            
                    RAISE EXCEPCION_ELIMINACION;
            END;
        END LOOP;
    
        -- Eliminar gerentes
        FOR rec IN (SELECT id FROM gerente WHERE centro_id = P_ID) LOOP
            BEGIN
                ELIMINA_GERENTE(rec.id);
            EXCEPTION
                WHEN OTHERS THEN
                    ROLLBACK TO ELIMINA_CENTRO_POINT;
                    
                    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            
                    RAISE EXCEPCION_ELIMINACION;
            END;
        END LOOP;
        -- Eliminar el centro
        DELETE FROM centro WHERE id = P_ID;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK TO ELIMINA_CENTRO_POINT;
            
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            
            RAISE EXCEPCION_ELIMINACION;
    END ELIMINA_CENTRO;
END BASE;
/
    

--MARK: PAQUETE ICALC
create or replace PACKAGE ICALC AS
    EXCEPCION_CREACION EXCEPTION;
    PROCEDURE CREA_ELEMENTOS(
        P_ID IN ENTRENADOR.ID%TYPE,
        P_ANNO IN NUMBER,
        P_MES IN NUMBER
    );
END ICALC;

create or replace PACKAGE BODY ICALC AS
    PROCEDURE CREA_ELEMENTOS(
        P_ID IN ENTRENADOR.ID%TYPE,
        P_ANNO IN NUMBER,
        P_MES IN NUMBER
    )
    IS
        v_disponibilidad VARCHAR2(4000);
        v_regla VARCHAR2(4000);
        v_dias VARCHAR2(50);
        v_horas VARCHAR2(50);
        v_minutos VARCHAR2(50);
        v_fecha DATE;
        v_dia VARCHAR2(2);
        v_hora VARCHAR2(2);
        v_minuto VARCHAR2(2);
        v_elemento_fecha DATE;
        v_fecha_inicio DATE;
        V_DIA_SEMANA VARCHAR2(3);
        v_pos NUMBER;
        v_substr VARCHAR2(4000);

    BEGIN
        SAVEPOINT CREA_ELEMENTOS_POINT;
        SELECT disponibilidad INTO v_disponibilidad
        FROM ENTRENADOR
        WHERE id = P_ID;

        DBMS_OUTPUT.PUT_LINE('Disponibilidad del entrenador: ' || v_disponibilidad);

        v_pos := 1;
        WHILE v_pos > 0 LOOP
            v_pos := INSTR(v_disponibilidad, '|', 1, 1);
            IF v_pos > 0 THEN
                v_regla := SUBSTR(v_disponibilidad, 1, v_pos - 1);
                v_disponibilidad := SUBSTR(v_disponibilidad, v_pos + 1);
            ELSE
                v_regla := v_disponibilidad;
            END IF;

            DBMS_OUTPUT.PUT_LINE('Procesando regla: ' || v_regla);

            -- Parsear la regla
            v_dias := REGEXP_SUBSTR(v_regla, 'BYDAY=([^;]+)', 1, 1, NULL, 1);
            v_horas := REGEXP_SUBSTR(v_regla, 'BYHOUR=([^;]+)', 1, 1, NULL, 1);
            v_minutos := REGEXP_SUBSTR(v_regla, 'BYMINUTE=([^;]+)', 1, 1, NULL, 1);
            v_fecha_inicio := TO_DATE(P_ANNO || '-' || P_MES || '-01', 'YYYY-MM-DD');

            DBMS_OUTPUT.PUT_LINE('Días: ' || v_dias);
            DBMS_OUTPUT.PUT_LINE('Horas: ' || v_horas);
            DBMS_OUTPUT.PUT_LINE('Minutos: ' || v_minutos);
            DBMS_OUTPUT.PUT_LINE('Fecha inicio: ' || v_fecha_inicio);

            -- Generar los elementos de calendario
            FOR dia IN (SELECT REGEXP_SUBSTR(v_dias, '[A-Z][A-Z]', 1, LEVEL) AS dia
                        FROM dual
                        CONNECT BY REGEXP_SUBSTR(v_dias, '[A-Z][A-Z]', 1, LEVEL) IS NOT NULL) LOOP

                V_DIA_SEMANA := CASE dia.dia
                    WHEN 'MO' THEN 'MON'
                    WHEN 'TU' THEN 'TUE'
                    WHEN 'WE' THEN 'WED'
                    WHEN 'TH' THEN 'THU'
                    WHEN 'FR' THEN 'FRI'
                    WHEN 'SA' THEN 'SAT'
                    WHEN 'SU' THEN 'SUN'
                    ELSE NULL
                END;

                IF V_DIA_SEMANA IS NOT NULL THEN
                    -- Iterar por los días del mes y encontrar los días de la semana especificados
                    FOR d IN 1..LAST_DAY(v_fecha_inicio) - v_fecha_inicio + 1 LOOP
                        v_fecha := v_fecha_inicio + d - 1;
                        IF TO_CHAR(v_fecha, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') = V_DIA_SEMANA THEN
                            FOR hora IN (SELECT REGEXP_SUBSTR(v_horas, '[^,]+', 1, LEVEL) AS hora
                                         FROM dual
                                         CONNECT BY REGEXP_SUBSTR(v_horas, '[^,]+', 1, LEVEL) IS NOT NULL) LOOP
                                FOR minuto IN (SELECT REGEXP_SUBSTR(v_minutos, '[^,]+', 1, LEVEL) AS minuto
                                               FROM dual
                                               CONNECT BY REGEXP_SUBSTR(v_minutos, '[^,]+', 1, LEVEL) IS NOT NULL) LOOP
                                    -- Crear el elemento de calendario
                                    BEGIN
                                        v_elemento_fecha := TO_DATE(P_ANNO || '-' || P_MES || '-' || TO_CHAR(v_fecha, 'DD') || ' ' || LPAD(hora.hora, 2, '0') || ':' || LPAD(minuto.minuto, 2, '0'), 'YYYY-MM-DD HH24:MI');

                                        DBMS_OUTPUT.PUT_LINE('Fecha elemento: ' || v_elemento_fecha);

                                        INSERT INTO ELEMENTOCALENDARIO(fechayhora, entrenador_id)
                                        VALUES (v_elemento_fecha, P_ID);
                                    EXCEPTION
                                        WHEN DUP_VAL_ON_INDEX THEN
                                            DBMS_OUTPUT.PUT_LINE('Elemento duplicado ignorado: ' || TO_CHAR(v_elemento_fecha, 'YYYY-MM-DD HH24:MI'));
                                        WHEN OTHERS THEN
                                            DBMS_OUTPUT.PUT_LINE('Error al crear elemento para fecha: ' || TO_CHAR(v_elemento_fecha, 'YYYY-MM-DD HH24:MI'));
                                            RAISE EXCEPCION_CREACION;
                                    END;
                                END LOOP;
                            END LOOP;
                        END IF;
                    END LOOP;
                END IF;
            END LOOP;
        END LOOP;

        COMMIT;
    EXCEPTION
        WHEN EXCEPCION_CREACION THEN
            ROLLBACK TO CREA_ELEMENTOS_POINT;
            DBMS_OUTPUT.PUT_LINE('Error al crear elementos de calendario.');
        WHEN OTHERS THEN
            ROLLBACK TO CREA_ELEMENTOS_POINT;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE;
    END CREA_ELEMENTOS;
END ICALC;

--MARK: JOB
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
    job_name          => 'CREAR_EVENTOS_ENTRENADORES',
    job_type          => 'PLSQL_BLOCK',
    job_action        => '
      BEGIN
        FOR entren IN (SELECT id FROM ENTRENADOR) LOOP
          ICALC.crea_elementos(entren.id, EXTRACT(YEAR FROM SYSDATE), EXTRACT(MONTH FROM SYSDATE) + 1);
        END LOOP;
      END;',
    start_date        => sysdate + 1,
    repeat_interval   => 'FREQ=MONTHLY; BYMONTHDAY=20; BYHOUR=1;', 
    enabled           => TRUE,
    comments          => 'Job para crear eventos de calendario para todos los entrenadores'
  );
END;
/
