-- Listar los 10 usuarios más recientes--
SELECT id, username, created_at
FROM blog.users
ORDER BY created_at DESC
LIMIT 10;
--Contar cuántos usuarios hay por estado--
SELECT status, COUNT(*) AS total
FROM blog.users
GROUP BY status
ORDER BY total DESC;
--Listar posts que están en borrador (draft)--
SELECT id, title, status, created_at
FROM blog.posts
WHERE status = 'draft'
ORDER BY created_at DESC;
-- Mostrar los 10 posts publicados más recientes--
SELECT id, title, published_at
FROM blog.posts
WHERE status = 'published'
ORDER BY published_at DESC NULLS LAST
LIMIT 10;

--Contar cuántos comentarios son spam y cuántos no --
SELECT is_spam, COUNT(*) AS total
FROM blog.comments
GROUP BY is_spam
ORDER BY is_spam;
-- Listar los 15 comentarios más recientes (solo texto y fecha) --
SELECT id, body, created_at
FROM blog.comments
ORDER BY created_at DESC
LIMIT 15;
--Listar categorías ordenadas alfabéticamente --
SELECT id, name, slug
FROM blog.categories
ORDER BY name;

--Listar posts publicados con el username del autor--
SELECT p.id, p.title, u.username AS author, p.published_at
FROM blog.posts p
JOIN blog.users u ON u.id = p.author_id
WHERE p.status = 'published'
ORDER BY p.published_at DESC NULLS LAST;

--Listar comentarios con el usuario que comentó y el título del post--
SELECT c.id AS comment_id, u.username AS commenter, p.title AS post_title, c.created_at
FROM blog.comments c
JOIN blog.users u ON u.id = c.user_id
JOIN blog.posts p ON p.id = c.post_id
ORDER BY c.created_at DESC
LIMIT 30;
-- Mostrar posts con su categoría--
SELECT p.id, p.title, cat.name AS category
FROM blog.posts p
JOIN blog.post_categories pc ON pc.post_id = p.id
JOIN blog.categories cat ON cat.id = pc.category_id
ORDER BY p.id;

-- Contar cuántos posts ha escrito cada usuario (incluye usuarios sin posts)--
SELECT u.id, u.username, COUNT(p.id) AS total_posts
FROM blog.users u
LEFT JOIN blog.posts p ON p.author_id = u.id
GROUP BY u.id, u.username
ORDER BY total_posts DESC, u.username;

--Contar cuántos comentarios (no spam) tiene cada post (incluye posts sin comentarios)
SELECT p.id, p.title, COUNT(c.id) AS comments_count
FROM blog.posts p
LEFT JOIN blog.comments c
  ON c.post_id = p.id AND c.is_spam = false AND c.parent_id IS NULL
GROUP BY p.id, p.title
ORDER BY comments_count DESC, p.id;

--Listar usuarios que han comentado en posts publicados (no spam) y cuántas veces
SELECT u.id, u.username, COUNT(c.id) AS comments_made
FROM blog.users u
JOIN blog.comments c ON c.user_id = u.id AND c.is_spam = false
JOIN blog.posts p ON p.id = c.post_id AND p.status = 'published'
GROUP BY u.id, u.username
ORDER BY comments_made DESC, u.username;

--Encontrar posts sin comentarios no-spam
SELECT p.id, p.title
FROM blog.posts p
LEFT JOIN blog.comments c
  ON c.post_id = p.id AND c.is_spam = false
WHERE c.id IS NULL
ORDER BY p.id;
--Top 5 autores con más posts publicados
SELECT u.id, u.username, COUNT(p.id) AS published_posts
FROM blog.users u
JOIN blog.posts p ON p.author_id = u.id
WHERE p.status = 'published'
GROUP BY u.id, u.username
ORDER BY published_posts DESC, u.username
LIMIT 5;
---Para cada categoría, cuántos posts publicados tiene (incluye categorías sin posts)
SELECT cat.id, cat.name, COUNT(p.id) AS published_posts
FROM blog.categories cat
LEFT JOIN blog.post_categories pc ON pc.category_id = cat.id
LEFT JOIN blog.posts p ON p.id = pc.post_id AND p.status = 'published'
GROUP BY cat.id, cat.name
ORDER BY published_posts DESC, cat.name;

--Mostrar el último comentario (fecha) de cada post publicado (no spam)
SELECT p.id, p.title, MAX(c.created_at) AS last_comment_at
FROM blog.posts p
LEFT JOIN blog.comments c
  ON c.post_id = p.id AND c.is_spam = false
WHERE p.status = 'published'
GROUP BY p.id, p.title
ORDER BY last_comment_at DESC NULLS LAST, p.id;
--Listar replies (respuestas) con el usuario del reply y el usuario del comentario padre (self-join)
SELECT
  r.id AS reply_id,
  parent.id AS parent_comment_id,
  ur.username AS reply_user,
  up.username AS parent_user,
  r.created_at
FROM blog.comments r
JOIN blog.comments parent ON parent.id = r.parent_id
JOIN blog.users ur ON ur.id = r.user_id
JOIN blog.users up ON up.id = parent.user_id
ORDER BY r.created_at DESC;
--Actividad por usuario: posts escritos + comentarios no-spam realizados (y total)
SELECT
  u.id,
  u.username,
  COUNT(DISTINCT p.id) AS posts_written,
  COUNT(DISTINCT c.id) AS comments_written,
  (COUNT(DISTINCT p.id) + COUNT(DISTINCT c.id)) AS total_activity
FROM blog.users u
LEFT JOIN blog.posts p ON p.author_id = u.id
LEFT JOIN blog.comments c ON c.user_id = u.id AND c.is_spam = false
GROUP BY u.id, u.username
ORDER BY total_activity DESC, u.username;
--Posts publicados con su categoría y el porcentaje de comentarios spam del post
SELECT
  p.id,
  p.title,
  cat.name AS category,
  COUNT(c.id) AS total_comments,
  SUM(CASE WHEN c.is_spam THEN 1 ELSE 0 END) AS spam_comments,
  CASE
    WHEN COUNT(c.id) = 0 THEN 0
    ELSE ROUND(100.0 * SUM(CASE WHEN c.is_spam THEN 1 ELSE 0 END) / COUNT(c.id), 2)
  END AS spam_percent
FROM blog.posts p
JOIN blog.post_categories pc ON pc.post_id = p.id
JOIN blog.categories cat ON cat.id = pc.category_id
LEFT JOIN blog.comments c ON c.post_id = p.id
WHERE p.status = 'published'
GROUP BY p.id, p.title, cat.name
ORDER BY spam_percent DESC, total_comments DESC, p.id;