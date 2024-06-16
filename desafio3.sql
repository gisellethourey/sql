.--1. Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo pedido.--
---Creación database--
create database desafio3_gIselle_tHourey_123;

---Set up usuarios---
create table Usuarios (id serial, email varchar, nombre varchar, apellido varchar, rol varchar);
insert into Usuarios (email, nombre, apellido, rol)
values ('carmen@gmail.com', 'Carmen', 'Rodriguez', 'administrador'),
('githourey@gmail.com', 'Giselle', 'Thourey', 'usuario'),
('sebastian@gmail.com', 'Sebastian', 'Apablaza', 'usuario'),
('alessandra@gmail.com', 'Alessandra', 'Thourey', 'usuario'),
('sofia@gmail.com', 'Sofia', 'Mendoza', 'usuario');
select * from Usuarios;

---Set up posts---
create table Posts (id serial, titulo varchar, contenido text, fecha_creacion timestamp, fecha_actualizacion timestamp, destacado boolean, usuario_id bigint);
insert into Posts (titulo, contenido, fecha_creacion,fecha_actualizacion, destacado, usuario_id) 
values('titulo1', 'primer titulo', '2024-05-01', '2024-05-02',true, 1 ),
	('titulo2', 'segundo titulo', '2024-06-01', '2024-06-02', true, 1 ),
	('titulo3', 'tercer titulo', '2024-07-01', '2024-07-02', true, 2),
	('titulo4', 'cuarto titulo', '2024-08-01', '2024-08-02', false,2 ),
	('vacio', 'sin usuario', '2024-09-01', '2024-09-02', false, null);
select * from Posts;

---Set up comentarios---
create table Comentarios (id serial, contenido text, fecha_creacion timestamp, usuario_id bigint, post_id bigint );
insert into Comentarios (contenido, fecha_creacion, usuario_id, post_id)
values ('primer comentario', '2024-09-03', 1, 1),
('segundo comentario', '2024-09-04', 2, 1),
('tercer comentario', '2024-09-05', 3, 1),
('cuarto comentario', '2024-09-06', 1, 2 ),
('quinto comentario', '2024-09-07', 2, 2);
select * from Comentarios;

---2. Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
--nombre y email del usuario junto al título y contenido del post.
select Usuarios.nombre, Usuarios.email, Posts.titulo, Posts.contenido from Usuarios inner join 
	Posts on Usuarios.id=Posts.usuario_id;

---3. Muestra el id, título y contenido de los posts de los administradores.a. El administrador puede ser cualquier id.
select Posts.id, Posts.titulo, Posts.contenido from Posts inner join 
	Usuarios on Posts.usuario_id=Usuarios.id where Usuarios.rol='administrador';

---4. Cuenta la cantidad de posts de cada usuario. a. La tabla resultante debe mostrar el id e
 --email del usuario junto con la cantidad de posts de cada usuario.
--Probando inner join
select Usuarios.id, Usuarios.email, count (Posts.id) 
as count from Usuarios inner join Posts on Usuarios.id=Posts.usuario_id 
group by Usuarios.id, Usuarios.email order by Usuarios.id desc;
--Probando right join
select Usuarios.id, Usuarios.email, count (Posts.id) 
as count from Usuarios right join Posts on Usuarios.id=Posts.usuario_id 
	group by Usuarios.id, Usuarios.email order by Usuarios.id desc;
---Probando left join--- RESPUESTA CORRECTA---
select Usuarios.id, Usuarios.email, count (Posts.id) 
as count from Usuarios left join Posts on Usuarios.id=Posts.usuario_id 
group by Usuarios.id, Usuarios.email order by Usuarios.id desc;

---5. Muestra el email del usuario que ha creado más posts.
---a. Aquí la tabla resultante tiene un único registro y muestra solo el email
select Usuarios.email from Usuarios inner join Posts on Usuarios.id=Posts.usuario_id
group by Usuarios.email,Usuarios.rol order by count (*) desc, Usuarios.rol asc;

---6. Muestra la fecha del último post de cada usuario.
--Hint: Utiliza la función de agregado MAX sobre la fecha de creación.
select Usuarios.nombre, max(Posts.fecha_creacion) as max from Usuarios
inner join Posts on Usuarios.id=Posts.usuario_id group by Usuarios.nombre;

---7.Muestra el título y contenido del post (artículo) con más comentarios.
select Posts.titulo, Posts.contenido from Posts 
inner join (select post_id, count (*)from Comentarios
group by post_id
order by count (*)desc)
Comentarios
on Posts.id= Comentarios.post_id limit 1;

---8.Muestra en una tabla el título de cada post, el contenido de cada post y el contenido
--de cada comentario asociado a los posts mostrados, junto con el email del usuario
--que lo escribió.
select Posts.titulo as titulo_post, Posts.contenido as contenido_post, 
	Comentarios.contenido as contenido_comentario, Usuarios.email as email from Posts
inner join Comentarios on Posts.id = Comentarios.post_id
inner join Usuarios on Comentarios.usuario_id= Usuarios.id;

---9. Muestra el contenido del último comentario de cada usuario
select Comentarios.fecha_creacion, Comentarios.contenido, Comentarios.usuario_id
from Comentarios
join Usuarios on Comentarios.usuario_id = Usuarios.id
where(Comentarios.usuario_id, Comentarios.fecha_creacion) in (
   select usuario_id, max(fecha_creacion)
    from Comentarios
    group by usuario_id
);

---10. Muestra los emails de los usuarios que no han escrito ningún comentario.
--Recuerda uso de having

select Usuarios.email from Usuarios
left join Comentarios on Usuarios.id=Comentarios.usuario_id
group by Usuarios.id, Usuarios.email 
having count(Comentarios.id)=0;




