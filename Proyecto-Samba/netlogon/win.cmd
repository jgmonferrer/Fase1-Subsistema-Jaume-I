@echo off
IF NOT EXIST Z: net use Z: \\paladin\repositorio

msg %username% Se han creado carpetas compartidas para el repositorio. Tiene permiso de lectura y escritura en su departamento y permisos de lectura en el resto.
