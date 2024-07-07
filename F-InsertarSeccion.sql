create or replace FUNCTION F_INSERTAR_SECCION (
    P_CODIGO_ALTERNO IN TBL_SECCION.CODIGO_ALTERNO%TYPE, 
    P_HORA_INICIO TBL_SECCION.HORA_INICIO%TYPE, 
    P_HORA_FIN TBL_SECCION.HORA_FIN%TYPE, 
    P_DIAS TBL_SECCION.DIAS%TYPE, 
    P_CODIGO_AULA TBL_SECCION.CODIGO_AULA%TYPE, 
    P_NOMBRE_ASIGNATURA TBL_ASIGNATURAS.NOMBRE_ASIGNATURA%TYPE, 
    P_NOMBRE_MAESTRO VARCHAR2, 
    P_CODIGO_PERIODO TBL_SECCION.CODIGO_PERIODO%TYPE, 
    P_CANTIDAD_CUPOS TBL_SECCION.CANTIDAD_CUPOS%TYPE,
    P_MENSAJE_RESULTADO OUT VARCHAR2,
    P_CODIGO_RESULTADO OUT NUMBER
)
RETURN BOOLEAN
AS
    V_CODIGO_ASIGNATURA NUMBER;
    V_CODIGO_MAESTRO NUMBER;
BEGIN
    BEGIN
        SELECT CODIGO_ASIGNATURA 
        INTO V_CODIGO_ASIGNATURA
        FROM TBL_ASIGNATURAS
        WHERE NOMBRE_ASIGNATURA = P_NOMBRE_ASIGNATURA;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        P_MENSAJE_RESULTADO := 'NO EXISTE LA ASIGNATURA';
        P_CODIGO_RESULTADO := 1;
        RETURN FALSE;
    END;

    DBMS_OUTPUT.PUT_LINE('CONTINUA CON LA INSERCION');

    BEGIN
        SELECT CODIGO_PERSONA
        INTO V_CODIGO_MAESTRO
        FROM TBL_PERSONAS
        WHERE NOMBRE || ' ' || APELLIDO = P_NOMBRE_MAESTRO;
        EXCEPTION
    WHEN NO_DATA_FOUND THEN
        P_MENSAJE_RESULTADO := 'NO EXISTE EL MAESTRO';
        P_CODIGO_RESULTADO := 2;
        RETURN FALSE;
    END;

    IF P_CANTIDAD_CUPOS > 40 THEN
        P_MENSAJE_RESULTADO := 'LA CANTIDAD DE CUPOS NO PUEDE SER MAYOR A 40';
        P_CODIGO_RESULTADO := 3;
        RETURN FALSE;
    END IF;
    INSERT INTO TBL_SECCION (
        CODIGO_SECCION,
        CODIGO_ALTERNO,
        HORA_INICIO,
        HORA_FIN,
        DIAS,
        CODIGO_AULA,
        CODIGO_ASIGNATURA,
        CODIGO_MAESTRO,
        CODIGO_PERIODO,
        CANTIDAD_CUPOS
    ) VALUES (
        SQ_CODIGO_SECCION.NEXTVAL,
        P_CODIGO_ALTERNO,
        P_HORA_INICIO,
        P_HORA_FIN,
        P_DIAS,
        P_CODIGO_AULA,
        V_CODIGO_ASIGNATURA,
        V_CODIGO_MAESTRO,
        P_CODIGO_PERIODO,
        P_CANTIDAD_CUPOS
    );

    COMMIT;
    P_MENSAJE_RESULTADO := 'SECCION REGISTRADA CON EXITO';
    P_CODIGO_RESULTADO := 0;
    RETURN TRUE;
EXCEPTION
WHEN OTHERS THEN
    P_MENSAJE_RESULTADO := 'ERROR:' || SQLERRM || ' - ' ||SQLCODE;
    P_CODIGO_RESULTADO := SQLCODE;
    RETURN FALSE;
END;