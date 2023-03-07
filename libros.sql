CREATE TABLE IF NOT EXISTS autores(
  autor_id serial PRIMARY KEY,
  nombre VARCHAR(25) NOT NULL,
  apellido VARCHAR(25) NOT NULL,
  seudonimo VARCHAR(50) UNIQUE,
  genero varchar(1) check (genero in ('M','m','F','f','O')),
  fecha_nacimiento DATE NOT NULL,
  pais_origen VARCHAR(40) NOT NULL,
  fecha_creacion DATE DEFAULT current_timestamp
);


CREATE TABLE libros(
  libro_id serial PRIMARY KEY,
  autor_id INT NOT NULL,
  titulo varchar(50) NOT NULL,
  descripcion varchar(250) NOT NULL DEFAULT '',
  paginas int NOT NULL DEFAULT 0,
  fecha_publicacion Date NOT NUll,
  fecha_creacion DATE DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (autor_id) REFERENCES autores(autor_id)
);

ALTER TABLE libros ADD ventas INT NOT NULL DEFAULT 0;
ALTER TABLE libros ADD stock INT  DEFAULT 10;

CREATE TABLE usuarios(
  usuario_id serial PRIMARY KEY,
  nombre varchar(25) NOT NULL,
  apellidos varchar(25),
  username varchar(25) NOT NULL,
  email varchar(50) NOT NULL,
  fecha_creacion DATE DEFAULT CURRENT_DATE
);

CREATE TABLE libros_usuarios(
  libro_id INT  NOT NULL,
  usuario_id INT  NOT NULL,

  FOREIGN KEY (libro_id) REFERENCES libros(libro_id),
  FOREIGN KEY (usuario_id) REFERENCES usuarios(usuario_id),
  fecha_creacion DATE DEFAULT CURRENT_DATE,
  primary key(libro_id,usuario_id)
);
