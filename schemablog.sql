-- ============================================================
--  BLOG DB (PostgreSQL) - Schema + 100 filas por tabla + JOINs
-- ============================================================

-- (Opcional) Crear un schema para no ensuciar "public"
DROP SCHEMA IF EXISTS blog CASCADE;
CREATE SCHEMA blog;
SET search_path TO blog;

-- -------------------------
-- 1) TABLAS
-- -------------------------

-- Usuarios
CREATE TABLE users (
  id            BIGSERIAL PRIMARY KEY,
  username      VARCHAR(50)  NOT NULL UNIQUE,
  email         VARCHAR(120) NOT NULL UNIQUE,
  display_name  VARCHAR(120) NOT NULL,
  status        VARCHAR(20)  NOT NULL DEFAULT 'active'
                CHECK (status IN ('active','banned','inactive')),
  created_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Categorías
CREATE TABLE categories (
  id          BIGSERIAL PRIMARY KEY,
  name        VARCHAR(80)  NOT NULL UNIQUE,
  slug        VARCHAR(100) NOT NULL UNIQUE,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Posts
CREATE TABLE posts (
  id            BIGSERIAL PRIMARY KEY,
  author_id     BIGINT      NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  title         VARCHAR(180) NOT NULL,
  slug          VARCHAR(220) NOT NULL UNIQUE,
  content       TEXT        NOT NULL,
  status        VARCHAR(20) NOT NULL DEFAULT 'published'
                CHECK (status IN ('draft','published','archived')),
  published_at  TIMESTAMPTZ,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Relación N:M entre posts y categorías
CREATE TABLE post_categories (
  post_id      BIGINT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  category_id  BIGINT NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
  PRIMARY KEY (post_id, category_id)
);

-- Comentarios
CREATE TABLE comments (
  id          BIGSERIAL PRIMARY KEY,
  post_id     BIGINT NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
  user_id     BIGINT NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
  parent_id   BIGINT NULL REFERENCES comments(id) ON DELETE CASCADE,
  body        TEXT   NOT NULL,
  is_spam     BOOLEAN NOT NULL DEFAULT false,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- -------------------------
-- 2) ÍNDICES (rendimiento JOIN/WHERE)
-- -------------------------
CREATE INDEX idx_posts_author    ON posts(author_id);
CREATE INDEX idx_posts_status    ON posts(status);
CREATE INDEX idx_comments_post   ON comments(post_id);
CREATE INDEX idx_comments_user   ON comments(user_id);
CREATE INDEX idx_pc_category     ON post_categories(category_id);

-- -------------------------
-- 3) DATOS (100 por tabla) usando generate_series
-- -------------------------

-- 3.1) users: 100
INSERT INTO users (username, email, display_name, status, created_at)
SELECT
  'user' || gs                            AS username,
  'user' || gs || '@mail.com'             AS email,
  'User ' || gs                           AS display_name,
  CASE
    WHEN gs % 20 = 0 THEN 'banned'
    WHEN gs % 15 = 0 THEN 'inactive'
    ELSE 'active'
  END                                     AS status,
  now() - (gs || ' days')::interval       AS created_at
FROM generate_series(1, 100) AS gs;

-- 3.2) categories: 100
INSERT INTO categories (name, slug, created_at)
SELECT
  'Category ' || gs                       AS name,
  'category-' || gs                       AS slug,
  now() - (gs || ' days')::interval       AS created_at
FROM generate_series(1, 100) AS gs;

-- 3.3) posts: 100
-- (70 published, 20 draft, 10 archived)
INSERT INTO posts (author_id, title, slug, content, status, published_at, created_at)
SELECT
  ((gs - 1) % 100) + 1                    AS author_id,      -- reparte autores 1..100
  'Post Title ' || gs                     AS title,
  'post-' || gs                           AS slug,
  'This is the content for post ' || gs   AS content,
  CASE
    WHEN gs <= 70 THEN 'published'
    WHEN gs <= 90 THEN 'draft'
    ELSE 'archived'
  END                                     AS status,
  CASE
    WHEN gs <= 70 THEN now() - ((gs % 30) || ' days')::interval
    ELSE NULL
  END                                     AS published_at,
  now() - (gs || ' days')::interval       AS created_at
FROM generate_series(1, 100) AS gs;

-- 3.4) post_categories: 100 (1 categoría por post, simple y controlado)
-- (Post i -> Category ((i-1) % 100)+1)
INSERT INTO post_categories (post_id, category_id)
SELECT
  gs                                      AS post_id,
  ((gs - 1) % 100) + 1                    AS category_id
FROM generate_series(1, 100) AS gs;

-- 3.5) comments: 100
-- Comentario i pertenece al Post ((i-1)%100)+1 y usuario ((i*7-1)%100)+1
-- Cada 10 comentarios, uno será spam.
INSERT INTO comments (post_id, user_id, parent_id, body, is_spam, created_at)
SELECT
  ((gs - 1) % 100) + 1                    AS post_id,
  (((gs * 7) - 1) % 100) + 1              AS user_id,
  NULL::BIGINT                            AS parent_id,
  'Comment #' || gs || ' body text'       AS body,
  (gs % 10 = 0)                           AS is_spam,
  now() - ((gs % 25) || ' hours')::interval AS created_at
FROM generate_series(1, 100) AS gs;

-- (Opcional) Agregar 20 respuestas (replies) a comentarios existentes para practicar self-join
-- Replies: id nuevos, parent_id apuntando a comentarios 1..20
INSERT INTO comments (post_id, user_id, parent_id, body, is_spam, created_at)
SELECT
  c.post_id,
  (((gs * 11) - 1) % 100) + 1             AS user_id,
  c.id                                     AS parent_id,
  'Reply to comment #' || c.id            AS body,
  false                                   AS is_spam,
  now() - ((gs % 12) || ' hours')::interval
FROM generate_series(1, 20) gs
JOIN comments c ON c.id = gs;
