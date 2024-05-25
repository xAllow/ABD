--COMPROBAR CREACION DE TABLESPACES;
SELECT * FROM USER_TABLESPACES;

--COMPROBAR INDICES;
select * from user_tablespaces;
SELECT index_name, index_type
FROM user_indexes;

--COMPROBAR ACCESO;
sqlplus
usuariooracle52
password123
SELECT * FROM LIFEFIT.USUARIO;

--CREAR CLIENTE;
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
    v_datos_cliente.CENTRO := 10; -- Suponiendo que el centro con ID 1 existe
    
    base.CREA_CLIENTE(
        P_DATOS => v_datos_cliente,
        P_USERPASS => v_userpass,
        P_USUARIO => v_usuario,
        P_CLIENTE => v_cliente
    );
    
    DBMS_OUTPUT.PUT_LINE('Cliente creado con ID: ' || v_cliente.ID);
END;
/

--CREAR ENTRENADOR;
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
    v_datos_entrenador.CENTRO := 20; -- Suponiendo que el centro con ID 2 existe
    
    base.CREA_ENTRENADOR(
        P_DATOS => v_datos_entrenador,
        P_USERPASS => v_userpass,
        P_USUARIO => v_usuario,
        P_ENTRENADOR => v_entrenador
    );
    
    DBMS_OUTPUT.PUT_LINE('Entrenador creado con ID: ' || v_entrenador.ID);
END;
/

--CREAR GERENTE
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

--ELIMINA CENTRO
BEGIN
    BASE.elimina_centro(1);
END;
/