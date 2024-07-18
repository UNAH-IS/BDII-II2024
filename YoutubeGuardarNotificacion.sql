create or replace PROCEDURE P_GUARDAR_NOTIFICACION (
    P_codigo_usuario_origen TBL_NOTIFICACIONES.codigo_usuario_origen%TYPE,
    P_codigo_usuario_destino TBL_NOTIFICACIONES.codigo_usuario_destino%TYPE,
    P_texto_notificacion TBL_NOTIFICACIONES.texto_notificacion%TYPE,
    P_codigo_video TBL_NOTIFICACIONES.codigo_video%TYPE
) IS
BEGIN
    INSERT INTO tbl_notificaciones (
        codigo_notificacion,
        codigo_usuario_destino,
        fecha_hora_envio,
        texto_notificacion,
        codigo_video,
        codigo_usuario_origen
    ) VALUES (
        SEQ_CODIGO_NOTIFICACION.NEXTVAL,
        P_codigo_usuario_destino,
        SYSDATE,
        P_texto_notificacion,
        P_codigo_video,
        P_codigo_usuario_origen
    );
    COMMIT;
END;