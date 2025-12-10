--
-- PostgreSQL database cluster dump
--

\restrict uGCR5l5fR3duhAIrl4B8bRGyEmFsnqBw7x0mtdIKaea2rkCQpGPcgKWqkiZL3cG

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE gixi_user;
ALTER ROLE gixi_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:WNSlEvFhJ95zVc6ANa7Y1A==$L76+pS6zIt3xBijOTXHdpLJ20MffpePbJ5EUr6iOg4w=:gtWeWqV29aHGOXBGO2ZIx3bjy9dLYx+waiHVh+O/3lo=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;
CREATE ROLE web_user;
ALTER ROLE web_user WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:6pHEezED9kQmRfYKmgMGGw==$d9TGAac7ngj+MDh+T2yl9BXE/ajGUtYHI4VOAV122/I=:ZPJR69P+cTnI42nfCz50Ny0LuxkjcFeP8zGCr/rd9KI=';

--
-- User Configurations
--








\unrestrict uGCR5l5fR3duhAIrl4B8bRGyEmFsnqBw7x0mtdIKaea2rkCQpGPcgKWqkiZL3cG

--
-- PostgreSQL database cluster dump complete
--

