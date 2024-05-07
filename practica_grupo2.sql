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
    v_datos_cliente.DIETA := 1; -- Este valor debería ser ajustado según la lógica de tu aplicación
    v_datos_cliente.PREFERENCIAS := 'Cardio';
    v_datos_cliente.CENTRO := 10;

    -- Llama al procedimiento CREA_CLIENTE para crear el cliente
    base.CREA_CLIENTE(v_datos_cliente, 'password123', v_usuario, v_cliente);

    -- Imprime los datos del usuario y cliente creados
    DBMS_OUTPUT.PUT_LINE('Usuario creado:');
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_usuario.ID);
    DBMS_OUTPUT.PUT_LINE('NOMBRE: ' || v_usuario.NOMBRE);
    DBMS_OUTPUT.PUT_LINE('APELLIDOS: ' || v_usuario.APELLIDOS);
    -- Imprime los demás campos del usuario si es necesario

    DBMS_OUTPUT.PUT_LINE('Cliente creado:');
    DBMS_OUTPUT.PUT_LINE('ID: ' || v_cliente.ID);
    DBMS_OUTPUT.PUT_LINE('OBJETIVOS: ' || v_cliente.OBJETIVO);
    -- Imprime los demás campos del cliente si es necesario
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
        EXECUTE IMMEDIATE v_user;
        EXECUTE IMMEDIATE v_rol;
        COMMIT;
    EXCEPTION 
        WHEN OTHERS THEN
            ROLLBACK TO CREA_CLIENTE_POINT;
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            RAISE EXCEPCION_CREACION;
    END CREA_CLIENTE;
