CREATE TABLE usuarios (
  id serial primary key,
  login varchar(30) NOT NULL,
  password varchar(32) NOT NULL,
  nickname varchar(40) NOT NULL,
  email varchar(40) NOT NULL
  
);

CREATE TABLE categorias (
  id serial primary key,
  nombre_categoria varchar(30) NOT NULL
  
); 

CREATE TABLE etiquetas (
  id serial NOT NULL primary key,
  nombre_etiqueta varchar(30) NOT NULL
  
);

CREATE TABLE posts (
  id serial PRIMARY KEY,
  titulo varchar(130) NOT NULL,
  fecha_publicacion DATE NULL DEFAULT NULL,
  contenido text NOT NULL,
  estatus varchar(8) DEFAULT 'activo',
  usuario_id int DEFAULT NULL,
  categoria_id int DEFAULT NULL,
  FOREIGN KEY (categoria_id) REFERENCES categorias (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE NO ACTION ON UPDATE CASCADE
);

CREATE TABLE comentarios (
  id SERIAL PRIMARY KEY,
  cuerpo_comentario text NOT NULL,
  usuario_id int NOT NULL,
  post_id int NOT NULL,
  FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE posts_etiquetas (
  id SERIAL PRIMARY KEY,
  post_id int NOT NULL,
  etiqueta_id int NOT NULL,
  FOREIGN KEY (etiqueta_id) REFERENCES etiquetas (id) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY (post_id) REFERENCES posts (id) ON DELETE NO ACTION ON UPDATE NO ACTION
) ;