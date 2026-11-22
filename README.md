# ROSA 55 · Casino Night

Aplicación web privada para la celebración ROSA 55, construida con Cloudflare Workers y D1.

## Stack
- Cloudflare Workers: interfaz web, API y reglas del juego.
- Cloudflare D1: persistencia de participantes, sesiones y puntuaciones.
- GitHub: código fuente y control de versiones.
- No utiliza Supabase ni servicios de backend adicionales.

## Funcionalidades
- Acceso individual de invitados mediante nombre o apodo, con sesión persistente.
- Acceso de organización independiente y protegido por contraseña.
- Selección de equipo con asignación automática para equilibrar los grupos.
- Seis misiones TOP SECRET con desbloqueo secuencial y código final validado en servidor.
- Diez retos Casino Challenge con aprobación de organización (10 puntos cada uno).
- Rosa Quiz editable (5 preguntas fáciles, 5 medias y 5 difíciles). La puntuación es 4, 6 y 10 puntos por nivel, respectivamente (máximo 100).
- Ranking individual y por equipos, con bonus de 20 puntos al equipo ganador y exclusión de Rosa.
- Herramientas de administración para participantes, contenido y borrado manual de datos.

## Preparar el proyecto
El Worker y los archivos de interfaz se guardan comprimidos en el repositorio. Para restaurarlos como archivos fuente antes de trabajar:

```bash
npm install
npm run restore
npm run dev
```

## Base de datos
El esquema de D1 está en `schema.sql`. El identificador de la base de datos está configurado en `wrangler.toml`.

```bash
npm run db:init
```

La base D1 de producción ya se ha inicializado desde la conexión de Cloudflare. No ejecutes de nuevo el esquema sobre datos de un evento ya iniciado.

## Secretos requeridos en Cloudflare
Configurar como secretos del Worker, nunca en Git:
- `ADMIN_PASSWORD`: contraseña privada de administración.
- `FINAL_CODE`: código de la fase final.

## Publicación
```bash
npm run deploy
```

## Contenido pendiente
Las seis misiones, los diez retos y las quince preguntas se configuran desde el panel de organización. La aplicación no incluye textos de juego ficticios.
