DROP DATABASE IF EXISTS number_guess;
CREATE DATABASE number_guess;
\connect number_guess
CREATE TABLE public.users (user_id serial NOT NULL, username character varying(22) NOT NULL, games_played integer DEFAULT 0 NOT NULL, best_game integer);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
ALTER TABLE ONLY public.users ADD CONSTRAINT users_username_key UNIQUE (username);
