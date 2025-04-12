--select 'DROP TABLE '|| table_name ||' CASCADE CONSTRAINTS;' from tabs;

/* ---ELIMINACIÓN DE OBJETOS--- */

DROP TABLE area CASCADE CONSTRAINTS;

DROP TABLE asignatura CASCADE CONSTRAINTS;

DROP TABLE carrera CASCADE CONSTRAINTS;

DROP TABLE carrera_asignatura CASCADE CONSTRAINTS;

DROP TABLE comuna CASCADE CONSTRAINTS;

DROP TABLE det_seccion_estudiante CASCADE CONSTRAINTS;

DROP TABLE det_seccion_evaluacion CASCADE CONSTRAINTS;

DROP TABLE director CASCADE CONSTRAINTS;

DROP TABLE docente CASCADE CONSTRAINTS;

DROP TABLE encuesta_docente CASCADE CONSTRAINTS;

DROP TABLE estudiante CASCADE CONSTRAINTS;

DROP TABLE formato_carrera CASCADE CONSTRAINTS;

DROP TABLE matricula CASCADE CONSTRAINTS;

DROP TABLE nota_eva_estudiante CASCADE CONSTRAINTS;

DROP TABLE seccion CASCADE CONSTRAINTS;

DROP TABLE tipo_asignatura CASCADE CONSTRAINTS;





/* ---CREACIÓN DE OBJETOS--- */

CREATE TABLE area (
    id_area     NUMBER(3) NOT NULL,
    nombre_area VARCHAR2(30) NOT NULL
);

ALTER TABLE area ADD CONSTRAINT area_pk PRIMARY KEY ( id_area );

CREATE TABLE asignatura (
    id_asignatura NUMBER(5) NOT NULL,
    nombre_asig   VARCHAR2(255) NOT NULL,
    cod_tipo_asig NUMBER(7) NOT NULL
);

ALTER TABLE asignatura ADD CONSTRAINT asignatura_pk PRIMARY KEY ( id_asignatura );

CREATE TABLE carrera (
    id_carrera        NUMBER(5) NOT NULL,
    nombre_car        VARCHAR2(255),
    num_semestres_car NUMBER(3),
    cod_director      NUMBER(10) NOT NULL,
    cod_area          NUMBER(3) NOT NULL,
    cod_formato       NUMBER(8) NOT NULL
);

ALTER TABLE carrera ADD CONSTRAINT carrera_pk PRIMARY KEY ( id_carrera );

CREATE TABLE carrera_asignatura (
    cod_carrera    NUMBER(5) NOT NULL,
    cod_asignatura NUMBER(5) NOT NULL
);

ALTER TABLE carrera_asignatura ADD CONSTRAINT car_asig_pk PRIMARY KEY ( cod_carrera,
                                                                        cod_asignatura );

CREATE TABLE comuna (
    id_comuna     NUMBER(8) NOT NULL,
    nombre_comuna VARCHAR2(120) NOT NULL
);

ALTER TABLE comuna ADD CONSTRAINT comuna_pk PRIMARY KEY ( id_comuna );

CREATE TABLE det_seccion_estudiante (
    cod_seccion              NUMBER(10) NOT NULL,
    cod_estudiante           NUMBER(10) NOT NULL,
    prom_notas_secestud      NUMBER(3, 2) NOT NULL,
    situacion_final_secestud CHAR(2) NOT NULL
);

ALTER TABLE det_seccion_estudiante ADD CONSTRAINT detseccion_fk PRIMARY KEY ( cod_estudiante,
                                                                              cod_seccion );

CREATE TABLE det_seccion_evaluacion (
    cod_seccion      NUMBER(10) NOT NULL,
    num_eva_seccion  NUMBER(3) NOT NULL,
    prom_eva_seccion NUMBER(3, 2) NOT NULL
);

ALTER TABLE det_seccion_evaluacion ADD CONSTRAINT eva_seccion_pk PRIMARY KEY ( num_eva_seccion,
                                                                               cod_seccion );

CREATE TABLE director (
    id_director  NUMBER(10) NOT NULL,
    run_dc       NUMBER(8) NOT NULL,
    dv_dc        CHAR(1),
    pnombre_dc   VARCHAR2(30) NOT NULL,
    snombre_dc   VARCHAR2(30),
    appaterno_dc VARCHAR2(20) NOT NULL,
    apmaterno_dc VARCHAR2(20) NOT NULL,
    fecha_nac_dc DATE NOT NULL,
    direccion_dc VARCHAR2(120) NOT NULL,
    genero_dc    CHAR(1) NOT NULL,
    correo_dc    VARCHAR2(40) NOT NULL,
    celular_dc   VARCHAR2(15),
    fono_fijo_dc VARCHAR2(15),
    cod_comuna   NUMBER(8) NOT NULL
);

ALTER TABLE director
    ADD CONSTRAINT chk_genero_dc CHECK ( genero_dc IN ( 'F', 'M' ) );

ALTER TABLE director ADD CONSTRAINT director_pk PRIMARY KEY ( id_director );

CREATE TABLE docente (
    id_docente    NUMBER(10) NOT NULL,
    run_doc       NUMBER(8) NOT NULL,
    dv_doc        CHAR(1),
    pnombre_doc   VARCHAR2(30) NOT NULL,
    snombre_doc   VARCHAR2(30),
    appaterno_doc VARCHAR2(20) NOT NULL,
    apmaterno_doc VARCHAR2(20) NOT NULL,
    fecha_nac_doc DATE NOT NULL,
    direccion_doc VARCHAR2(120) NOT NULL,
    genero_doc    CHAR(1) NOT NULL,
    correo_doc    VARCHAR2(40) NOT NULL,
    celular_doc   VARCHAR2(15),
    fono_fijo_doc VARCHAR2(15),
    valor_hr_doc  NUMBER(8),
    cod_comuna    NUMBER(8) NOT NULL
);

ALTER TABLE docente
    ADD CONSTRAINT chk_genero_doc CHECK ( genero_doc IN ( 'F', 'M' ) );

ALTER TABLE docente ADD CONSTRAINT docente_pk PRIMARY KEY ( id_docente );

CREATE TABLE encuesta_docente (
    id_encuesta         NUMBER(7) NOT NULL,
    fecha_encuesta      DATE NOT NULL,
    estudios            VARCHAR2(255) NOT NULL,
    pueblo_originario   CHAR(1) NOT NULL,
    tipo_trabajador     CHAR(1) NOT NULL,
    jefe_hogar          CHAR(1) NOT NULL,
    num_hijos           NUMBER(3) NOT NULL,
    alergias            CHAR(1) NOT NULL,
    contacto_emergencia VARCHAR2(40) NOT NULL,
    telefono_emergencia VARCHAR2(15),
    cod_docente         NUMBER(10) NOT NULL
);

ALTER TABLE encuesta_docente
    ADD CONSTRAINT chk_originario CHECK ( pueblo_originario IN ( '0', '1' ) );

ALTER TABLE encuesta_docente
    ADD CONSTRAINT chk_trabajador CHECK ( tipo_trabajador IN ( 'D', 'I' ) );

ALTER TABLE encuesta_docente
    ADD CONSTRAINT chk_jefe CHECK ( jefe_hogar IN ( '0', '1' ) );

ALTER TABLE encuesta_docente
    ADD CONSTRAINT chk_alergias CHECK ( alergias IN ( '0', '1' ) );

ALTER TABLE encuesta_docente ADD CONSTRAINT encuesta_pk PRIMARY KEY ( id_encuesta );

CREATE TABLE estudiante (
    id_estudiante NUMBER(10) NOT NULL,
    run_est       NUMBER(8) NOT NULL,
    dv_est        CHAR(1),
    pnombre_est   VARCHAR2(30) NOT NULL,
    snombre_est   VARCHAR2(30),
    appaterno_est VARCHAR2(20) NOT NULL,
    apmaterno_est VARCHAR2(20) NOT NULL,
    fecha_nac_est DATE NOT NULL,
    direccion_est VARCHAR2(120) NOT NULL,
    genero_est    CHAR(1) NOT NULL,
    correo_est    VARCHAR2(40) NOT NULL,
    celular_est   VARCHAR2(15),
    fono_fijo_est VARCHAR2(15),
    cod_comuna    NUMBER(8) NOT NULL
);

ALTER TABLE estudiante
    ADD CONSTRAINT chk_genero_est CHECK ( genero_est IN ( 'F', 'M' ) );

ALTER TABLE estudiante ADD CONSTRAINT estudiante_pk PRIMARY KEY ( id_estudiante );

CREATE TABLE formato_carrera (
    id_formato     NUMBER(8) NOT NULL,
    nombre_formato VARCHAR2(30) NOT NULL
);

ALTER TABLE formato_carrera ADD CONSTRAINT formato_pk PRIMARY KEY ( id_formato );

CREATE TABLE matricula (
    id_matricula      NUMBER(10) NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    cod_estudiante    NUMBER(10) NOT NULL,
    cod_carrera       NUMBER(5) NOT NULL,
    jornada_matricula CHAR(1) NOT NULL
);

ALTER TABLE matricula ADD CONSTRAINT matricula_pk PRIMARY KEY ( id_matricula );

CREATE TABLE nota_eva_estudiante (
    id_nota_eva_estud NUMBER(3) NOT NULL,
    cod_seccion       NUMBER(10) NOT NULL,
    num_eva_seccion   NUMBER(3) NOT NULL,
    nota_estudiante   NUMBER(3, 2) NOT NULL,
    cod_estudiante    NUMBER(10) NOT NULL
);

ALTER TABLE nota_eva_estudiante ADD CONSTRAINT nota_eva_estudiate_fk PRIMARY KEY ( id_nota_eva_estud );

CREATE TABLE seccion (
    id_seccion     NUMBER(10) NOT NULL,
    annio_sec      NUMBER(4) NOT NULL,
    semestre_sec   CHAR(1) NOT NULL,
    cupo_sec       NUMBER(3) NOT NULL,
    cant_aa_sec    NUMBER(3) NOT NULL,
    cant_rr_sec    NUMBER(3) NOT NULL,
    promedio_sec   NUMBER(3, 2) NOT NULL,
    cod_docente    NUMBER(10) NOT NULL,
    cod_carrera    NUMBER(5) NOT NULL,
    cod_asignatura NUMBER(5) NOT NULL
);

ALTER TABLE seccion ADD CONSTRAINT seccion_pk PRIMARY KEY ( id_seccion );

CREATE TABLE tipo_asignatura (
    id_tipo_asig     NUMBER(7) NOT NULL,
    nombre_tipo_asig VARCHAR2(30) NOT NULL
);

ALTER TABLE tipo_asignatura ADD CONSTRAINT tipo_asignatura_pk PRIMARY KEY ( id_tipo_asig );

ALTER TABLE asignatura
    ADD CONSTRAINT asignatura_tipo_fk FOREIGN KEY ( cod_tipo_asig )
        REFERENCES tipo_asignatura ( id_tipo_asig );

ALTER TABLE carrera_asignatura
    ADD CONSTRAINT car_asig_asignatura_fk FOREIGN KEY ( cod_asignatura )
        REFERENCES asignatura ( id_asignatura );

ALTER TABLE carrera_asignatura
    ADD CONSTRAINT car_asig_carrera_fk FOREIGN KEY ( cod_carrera )
        REFERENCES carrera ( id_carrera );

ALTER TABLE carrera
    ADD CONSTRAINT carrera_area_fk FOREIGN KEY ( cod_area )
        REFERENCES area ( id_area );

ALTER TABLE carrera
    ADD CONSTRAINT carrera_director_fk FOREIGN KEY ( cod_director )
        REFERENCES director ( id_director );

ALTER TABLE carrera
    ADD CONSTRAINT carrera_formato_fk FOREIGN KEY ( cod_formato )
        REFERENCES formato_carrera ( id_formato );

ALTER TABLE nota_eva_estudiante
    ADD CONSTRAINT detseceva_notaevaestud_fk FOREIGN KEY ( num_eva_seccion,
                                                           cod_seccion )
        REFERENCES det_seccion_evaluacion ( num_eva_seccion,
                                            cod_seccion );

ALTER TABLE director
    ADD CONSTRAINT director_comuna_fk FOREIGN KEY ( cod_comuna )
        REFERENCES comuna ( id_comuna );

ALTER TABLE docente
    ADD CONSTRAINT docente_comuna_fk FOREIGN KEY ( cod_comuna )
        REFERENCES comuna ( id_comuna );

ALTER TABLE encuesta_docente
    ADD CONSTRAINT encuesta_docente_fk FOREIGN KEY ( cod_docente )
        REFERENCES docente ( id_docente );

ALTER TABLE nota_eva_estudiante
    ADD CONSTRAINT estud_notaevaestud_fk FOREIGN KEY ( cod_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE estudiante
    ADD CONSTRAINT estudiante_comuna_fk FOREIGN KEY ( cod_comuna )
        REFERENCES comuna ( id_comuna );

ALTER TABLE det_seccion_evaluacion
    ADD CONSTRAINT evaseccion_seccion_fk FOREIGN KEY ( cod_seccion )
        REFERENCES seccion ( id_seccion );

ALTER TABLE matricula
    ADD CONSTRAINT matricula_carrera_fk FOREIGN KEY ( cod_carrera )
        REFERENCES carrera ( id_carrera );

ALTER TABLE matricula
    ADD CONSTRAINT matricula_estudiante_fk FOREIGN KEY ( cod_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE seccion
    ADD CONSTRAINT seccion_car_asig_fk FOREIGN KEY ( cod_carrera,
                                                     cod_asignatura )
        REFERENCES carrera_asignatura ( cod_carrera,
                                        cod_asignatura );

ALTER TABLE seccion
    ADD CONSTRAINT seccion_docente_fk FOREIGN KEY ( cod_docente )
        REFERENCES docente ( id_docente );

ALTER TABLE det_seccion_estudiante
    ADD CONSTRAINT seccion_estudiante_fk FOREIGN KEY ( cod_estudiante )
        REFERENCES estudiante ( id_estudiante );

ALTER TABLE det_seccion_estudiante
    ADD CONSTRAINT seccion_secestud_fk FOREIGN KEY ( cod_seccion )
        REFERENCES seccion ( id_seccion );






/* ---POBLADO DE OBJETOS--- */


INSERT INTO area VALUES (590,'Agrícola');
INSERT INTO area VALUES (591,'Biblioteca');
INSERT INTO area VALUES (592,'Diseño');
INSERT INTO area VALUES (593,'Electricidad');
INSERT INTO area VALUES (594,'Física');
INSERT INTO area VALUES (595,'Informática');
INSERT INTO area VALUES (596,'Inglés');
INSERT INTO area VALUES (597,'Matemáticas');
INSERT INTO area VALUES (598,'Mecánica');
INSERT INTO area VALUES (599,'Química');
INSERT INTO area VALUES (600,'Salud');
INSERT INTO area VALUES (601,'Telecomunicaciones');


INSERT INTO tipo_asignatura VALUES (8940,'Ciencias Básicas');
INSERT INTO tipo_asignatura VALUES (8941,'Disciplinar');
INSERT INTO tipo_asignatura VALUES (8942,'Integradora');
INSERT INTO tipo_asignatura VALUES (8943,'VcM');
INSERT INTO tipo_asignatura VALUES (8944,'Idiomas');


INSERT INTO formato_carrera VALUES (6200,'Online Asíncrono');
INSERT INTO formato_carrera VALUES (6201,'Online Síncrono');
INSERT INTO formato_carrera VALUES (6202,'Presencial');
INSERT INTO formato_carrera VALUES (6203,'Semipresencial');


INSERT INTO comuna VALUES (4010,'Las Condes');
INSERT INTO comuna VALUES (4011,'Providencia');
INSERT INTO comuna VALUES (4012,'Santiago');
INSERT INTO comuna VALUES (4013,'Ñuñoa');
INSERT INTO comuna VALUES (4014,'Vitacura');
INSERT INTO comuna VALUES (4015,'La Reina');
INSERT INTO comuna VALUES (4016,'La Florida');
INSERT INTO comuna VALUES (4017,'Maipú');
INSERT INTO comuna VALUES (4018,'Lo Barnechea');
INSERT INTO comuna VALUES (4019,'Macul');
INSERT INTO comuna VALUES (4020,'San Miguel');
INSERT INTO comuna VALUES (4021,'Peñalolén');
INSERT INTO comuna VALUES (4022,'Puente Alto');
INSERT INTO comuna VALUES (4023,'Recoleta');
INSERT INTO comuna VALUES (4024,'Estación Central');
INSERT INTO comuna VALUES (4025,'San Bernardo');
INSERT INTO comuna VALUES (4026,'Independencia');
INSERT INTO comuna VALUES (4027,'La Cisterna');
INSERT INTO comuna VALUES (4028,'Quilicura');
INSERT INTO comuna VALUES (4029,'Quinta Normal');
INSERT INTO comuna VALUES (4030,'Conchalí');
INSERT INTO comuna VALUES (4031,'San Joaquín');
INSERT INTO comuna VALUES (4032,'Huechuraba');
INSERT INTO comuna VALUES (4033,'El Bosque');
INSERT INTO comuna VALUES (4034,'Cerrillos');
INSERT INTO comuna VALUES (4035,'Cerro Navia');
INSERT INTO comuna VALUES (4036,'La Granja');
INSERT INTO comuna VALUES (4037,'La Pintana');
INSERT INTO comuna VALUES (4038,'Lo Espejo');
INSERT INTO comuna VALUES (4039,'Lo Prado');
INSERT INTO comuna VALUES (4040,'Pedro Aguirre Cerda');
INSERT INTO comuna VALUES (4041,'Pudahuel');
INSERT INTO comuna VALUES (4042,'Renca');
INSERT INTO comuna VALUES (4043,'San Ramón');
INSERT INTO comuna VALUES (4044,'Melipilla');
INSERT INTO comuna VALUES (4045,'San Pedro');
INSERT INTO comuna VALUES (4046,'Alhué');
INSERT INTO comuna VALUES (4047,'María Pinto');
INSERT INTO comuna VALUES (4048,'Curacaví');
INSERT INTO comuna VALUES (4049,'Talagante');
INSERT INTO comuna VALUES (4050,'El Monte');
INSERT INTO comuna VALUES (4051,'Buin');
INSERT INTO comuna VALUES (4052,'Paine');
INSERT INTO comuna VALUES (4053,'Peñaflor');
INSERT INTO comuna VALUES (4054,'Isla de Maipo');
INSERT INTO comuna VALUES (4055,'Colina');
INSERT INTO comuna VALUES (4056,'Pirque');


INSERT INTO director VALUES (3349071,13126425,'3','Nélida','Ignacia','Armazán','Amengual',TO_DATE('24/10/'||(EXTRACT(YEAR FROM SYSDATE)-37),'DD/MM/YYYY'),'Avda. Libertad 4587','F','né.armazánam@outlook.com','786442611','272777982',4012);
INSERT INTO director VALUES (3349072,13512188,'1','Leonardo','César','Figueroa','Guiñez',TO_DATE('20/11/'||(EXTRACT(YEAR FROM SYSDATE)-40),'DD/MM/YYYY'),'ENZO PINZA 3330','M','le.figueroagu@yahoo.com','896410462','389279690',4034);
INSERT INTO director VALUES (3349073,13897951,'7','Pamela','Marcelina','Peña','Céspedes',TO_DATE('06/05/'||(EXTRACT(YEAR FROM SYSDATE)-57),'DD/MM/YYYY'),'GUIDO RENNI 4225','F','pa.peñacé@gmail.com','882649385','267765258',4020);
INSERT INTO director VALUES (3349074,14283714,'1','Griselda','Julia','Narvaez','Marambio',TO_DATE('02/09/'||(EXTRACT(YEAR FROM SYSDATE)-44),'DD/MM/YYYY'),'Totoral S/N','F','gr.narvaezma@outlook.com','996227623','367813075',4017);
INSERT INTO director VALUES (3349075,14669477,'0','Alex','Diego','Rivera','Lester',TO_DATE('15/01/'||(EXTRACT(YEAR FROM SYSDATE)-57),'DD/MM/YYYY'),'SANTA ISABEL 463','M','al.riverale@gmail.com','987255542','282811337',4036);
INSERT INTO director VALUES (3349076,15055240,'8','Koldo','Ángel','Jordán','Pereira',TO_DATE('07/09/'||(EXTRACT(YEAR FROM SYSDATE)-58),'DD/MM/YYYY'),'Abel Altura35','M','ko.jordánpe@outlook.com','882886471','487370770',4036);
INSERT INTO director VALUES (3349077,15441003,'3','Javier','Quintiliano','Amaya','Gross',TO_DATE('26/06/'||(EXTRACT(YEAR FROM SYSDATE)-60),'DD/MM/YYYY'),'Avda. Los Carrera 10','M','ja.amayagr@outlook.com','977295078','475286676',4046);


INSERT INTO carrera VALUES (2901,'Informática Biomédica',4,3349077,600,6200);
INSERT INTO carrera VALUES (2902,'Técnico de Enfermería',4,3349072,600,6201);
INSERT INTO carrera VALUES (2903,'Técnico en Odontología',3,3349076,600,6202);
INSERT INTO carrera VALUES (2904,'Técnico Químico',4,3349074,599,6201);
INSERT INTO carrera VALUES (2905,'Ingeniería Agrícola',7,3349073,590,6202);
INSERT INTO carrera VALUES (2906,'Técnico Agrícola',4,3349073,590,6201);
INSERT INTO carrera VALUES (2907,'Infraestructura Tecnológica',7,3349075,595,6200);
INSERT INTO carrera VALUES (2908,'Gastronomía Internacional',3,3349076,595,6200);
INSERT INTO carrera VALUES (2909,'Informática de Gestión',4,3349074,601,6202);
INSERT INTO carrera VALUES (2910,'Gastronomía',7,3349073,601,6201);




INSERT INTO asignatura VALUES (7081,'Anatomía Humana',8941);
INSERT INTO asignatura VALUES (7082,'Atención Preventiva',8943);
INSERT INTO asignatura VALUES (7083,'Biología Celular y Molecular',8941);
INSERT INTO asignatura VALUES (7084,'Bioquímica Médica',8941);
INSERT INTO asignatura VALUES (7085,'Cálculo',8940);
INSERT INTO asignatura VALUES (7086,'Cirugía General',8941);
INSERT INTO asignatura VALUES (7087,'Desarrollo Web',8941);
INSERT INTO asignatura VALUES (7088,'Diseño de Sistemas',8941);
INSERT INTO asignatura VALUES (7089,'Emprendimiento',8943);
INSERT INTO asignatura VALUES (7090,'Farmacología',8941);
INSERT INTO asignatura VALUES (7091,'Fundamentos de Matemáticas para la Computación',8940);
INSERT INTO asignatura VALUES (7092,'Ingeniería de Software',8942);
INSERT INTO asignatura VALUES (7093,'Inglés I',8944);
INSERT INTO asignatura VALUES (7094,'Inglés Medicina',8944);
INSERT INTO asignatura VALUES (7095,'Inglés TI',8944);
INSERT INTO asignatura VALUES (7096,'Inteligencia Artificial',8941);
INSERT INTO asignatura VALUES (7097,'Matemáticas',8940);
INSERT INTO asignatura VALUES (7098,'Medicina Interna',8942);
INSERT INTO asignatura VALUES (7099,'Patología General',8941);
INSERT INTO asignatura VALUES (7100,'Programación Orientada a Objetos',8941);
INSERT INTO asignatura VALUES (7101,'Proyecto Integrado',8942);
INSERT INTO asignatura VALUES (7102,'Rotaciones Clínicas',8942);
INSERT INTO asignatura VALUES (7103,'Seguridad Informática',8941);
INSERT INTO asignatura VALUES (7104,'Semiología Médica',8943);
INSERT INTO asignatura VALUES (7105,'Sistemas Operativos',8941);
INSERT INTO asignatura VALUES (7106,'Taller de Software',8942);
INSERT INTO asignatura VALUES (7107,'Taller Diseño Editorial',8942);
INSERT INTO asignatura VALUES (7108,'Taller Título',8942);


INSERT INTO carrera_asignatura VALUES (2902,7097);
INSERT INTO carrera_asignatura VALUES (2907,7091);
INSERT INTO carrera_asignatura VALUES (2901,7081);
INSERT INTO carrera_asignatura VALUES (2901,7083);
INSERT INTO carrera_asignatura VALUES (2901,7084);
INSERT INTO carrera_asignatura VALUES (2902,7081);
INSERT INTO carrera_asignatura VALUES (2907,7087);
INSERT INTO carrera_asignatura VALUES (2907,7088);
INSERT INTO carrera_asignatura VALUES (2908,7087);
INSERT INTO carrera_asignatura VALUES (2902,7090);
INSERT INTO carrera_asignatura VALUES (2901,7099);
INSERT INTO carrera_asignatura VALUES (2908,7103);
INSERT INTO carrera_asignatura VALUES (2901,7094);
INSERT INTO carrera_asignatura VALUES (2908,7093);
INSERT INTO carrera_asignatura VALUES (2902,7098);
INSERT INTO carrera_asignatura VALUES (2907,7101);
INSERT INTO carrera_asignatura VALUES (2901,7102);
INSERT INTO carrera_asignatura VALUES (2901,7082);
INSERT INTO carrera_asignatura VALUES (2907,7089);
INSERT INTO carrera_asignatura VALUES (2902,7104);


INSERT INTO estudiante VALUES (3312301,22001922,'7','Quintiliano','Gerardo','Garrido','Diaz',TO_DATE('13/11/'||(EXTRACT(YEAR FROM SYSDATE)-23),'DD/MM/YYYY'),'Mateo Toro y Zambrano 23','M','qu.garridodi@gmail.com','726359178','398288647',4040);
INSERT INTO estudiante VALUES (3312302,21954579,'1','Porfirio','Arturo','Pereira','Pinto',TO_DATE('26/01/'||(EXTRACT(YEAR FROM SYSDATE)-28),'DD/MM/YYYY'),'El Roble 4578','M','po.pereirapi@outlook.com','967783253','495342599',4012);
INSERT INTO estudiante VALUES (3312303,21907236,'8','Prudencio','Casimiro','Mejias','Canales',TO_DATE('25/12/'||(EXTRACT(YEAR FROM SYSDATE)-24),'DD/MM/YYYY'),'La Rinconada 53','M','pr.mejiasca@gmail.com','995417672','376252733',4052);
INSERT INTO estudiante VALUES (3312304,21859893,'5','Bastián','Edmundo','Bastias','Martin',TO_DATE('06/08/'||(EXTRACT(YEAR FROM SYSDATE)-30),'DD/MM/YYYY'),'José Manuel Balmaceda 456','M','ba.bastiasma@outlook.com','889285031','467415270',4037);
INSERT INTO estudiante VALUES (3312305,21812550,'2','Obdulio','Teófilo','Saavedra','Basoalto',TO_DATE('09/07/'||(EXTRACT(YEAR FROM SYSDATE)-28),'DD/MM/YYYY'),'Aurora de Chile 345','M','ob.saavedraba@gmail.com','876256263','292741276',4043);
INSERT INTO estudiante VALUES (3312306,21765207,'5','Lucinda','Jimmie','Pino','Gutiérrez',TO_DATE('22/04/'||(EXTRACT(YEAR FROM SYSDATE)-24),'DD/MM/YYYY'),'Lago OHiggins 45','F','lu.pinogu@yahoo.com','885382800','396227855',4019);
INSERT INTO estudiante VALUES (3312307,21717864,'4','Serafín','Diego','Aravena','Cruz',TO_DATE('19/08/'||(EXTRACT(YEAR FROM SYSDATE)-20),'DD/MM/YYYY'),'Los Placeres 23 Depto 45 Cerro Los Placeres','M','se.aravenacr@outlook.com','975778838','377446858',4023);
INSERT INTO estudiante VALUES (3312308,21670521,'4','Inés','Natalia','Pineda','Riffo',TO_DATE('22/05/'||(EXTRACT(YEAR FROM SYSDATE)-26),'DD/MM/YYYY'),'LAS CODORNICES 2963-H DPTO. 21','F','in.pinedari@yahoo.com','878255579','482853737',4034);
INSERT INTO estudiante VALUES (3312309,21623178,'1','Martín','Jonathan','Ballard','Morrow',TO_DATE('09/08/'||(EXTRACT(YEAR FROM SYSDATE)-29),'DD/MM/YYYY'),'Alonso de Córdova 4578','M','ma.ballardmo@outlook.com','792836901','472633287',4024);
INSERT INTO estudiante VALUES (3312310,21575835,'1','Elisa','Lidia','Peéez','Roa',TO_DATE('02/09/'||(EXTRACT(YEAR FROM SYSDATE)-20),'DD/MM/YYYY'),'San Pablo 6828 Depto. 201 BlocK. 5','F','el.peéezro@outlook.com','772425678','479264830',4034);
INSERT INTO estudiante VALUES (3312311,21528492,'9','Leonardo','Bastián','Sobarzo','Elizondo',TO_DATE('06/04/'||(EXTRACT(YEAR FROM SYSDATE)-23),'DD/MM/YYYY'),'2 Oriente 2345 Depto 101 Edificio Costa Mar','M','le.sobarzoel@gmail.com','898593881','225631567',4028);
INSERT INTO estudiante VALUES (3312312,21481149,'9','Matilde','Eliana','Liempi','Cárdenas',TO_DATE('26/05/'||(EXTRACT(YEAR FROM SYSDATE)-19),'DD/MM/YYYY'),'San Pablo 6828 Depto. 201 BlocK. 5','F','ma.liempicá@yahoo.com','926811939','376535192',4027);
INSERT INTO estudiante VALUES (3312313,21433806,'1','Julia','Leonor','Randall','Sobarzo',TO_DATE('31/07/'||(EXTRACT(YEAR FROM SYSDATE)-21),'DD/MM/YYYY'),'Las Acacias S/N','F','ju.randallso@gmail.com','976210614','376252733',4044);
INSERT INTO estudiante VALUES (3312314,21386463,'2','Denis','Ángel','White','Aravena',TO_DATE('14/04/'||(EXTRACT(YEAR FROM SYSDATE)-20),'DD/MM/YYYY'),'PJE.TIMBAL 1095 V/POMAIRE','M','de.whitear@yahoo.com','786622812','475540604',4053);
INSERT INTO estudiante VALUES (3312315,21339120,'0','Leo','Jesús','Pedraza','Carvallo',TO_DATE('25/07/'||(EXTRACT(YEAR FROM SYSDATE)-27),'DD/MM/YYYY'),'ICARO 3580 V/SANTA INES','M','le.pedrazaca@outlook.com','772531115','499228369',4014);
INSERT INTO estudiante VALUES (3312316,21291777,'8','Macarena','Regina','Trinke','Urzúa',TO_DATE('06/05/'||(EXTRACT(YEAR FROM SYSDATE)-26),'DD/MM/YYYY'),'Llanquihue 1567','F','ma.trinkeur@gmail.com','777446858','376253138',4051);
INSERT INTO estudiante VALUES (3312317,21244434,'1','Fabiola','Reyna','Guiñez','Liempi',TO_DATE('05/08/'||(EXTRACT(YEAR FROM SYSDATE)-27),'DD/MM/YYYY'),'Adela Von Hagrn 567','F','fa.guiñezli@gmail.com','892554060','298268333',4024);
INSERT INTO estudiante VALUES (3312318,21197091,'0','Stephanie','Paloma','Duarte','Roth',TO_DATE('04/05/'||(EXTRACT(YEAR FROM SYSDATE)-25),'DD/MM/YYYY'),'PJE.COLORADO 5528 DEPTO. 302','F','st.duartero@gmail.com','926238494','368153576',4033);
INSERT INTO estudiante VALUES (3312319,21149748,'7','Aquiles','Valentín','Jorquera','Lara',TO_DATE('21/05/'||(EXTRACT(YEAR FROM SYSDATE)-26),'DD/MM/YYYY'),'Los militares 2378','M','aq.jorquerala@outlook.com','877414886','372649198',4029);
INSERT INTO estudiante VALUES (3312320,21102405,'1','Penny','Marcelina','Mccoy','Sepúlveda',TO_DATE('27/04/'||(EXTRACT(YEAR FROM SYSDATE)-24),'DD/MM/YYYY'),'RODRIGO DE ARAYA 4871 DEPTO. 14','F','pe.mccoyse@outlook.com','827780321','372950789',4035);
INSERT INTO estudiante VALUES (3312321,21055062,'1','Jimena','Mercedes','Sanhueza','Gajardo',TO_DATE('23/04/'||(EXTRACT(YEAR FROM SYSDATE)-25),'DD/MM/YYYY'),'Avda. Alemania 2345','F','ji.sanhuezaga@yahoo.com','975262465','292741488',4015);
INSERT INTO estudiante VALUES (3312322,21007719,'3','Germán','Boris','Saavedra','Kline',TO_DATE('07/03/'||(EXTRACT(YEAR FROM SYSDATE)-29),'DD/MM/YYYY'),'GUARDIA MARINA. RIQUELME 561','M','ge.saavedrakl@gmail.com','982774099','376285984',4033);
INSERT INTO estudiante VALUES (3312323,20960376,'0','Telmo','Óscar','Lujan','Meneses',TO_DATE('02/05/'||(EXTRACT(YEAR FROM SYSDATE)-19),'DD/MM/YYYY'),'Avda. Costanera 1574','M','te.lujanme@gmail.com','888586286','492239949',4014);
INSERT INTO estudiante VALUES (3312324,20913033,'K','Bernardo','René','Garrido','Villalobos',TO_DATE('14/06/'||(EXTRACT(YEAR FROM SYSDATE)-18),'DD/MM/YYYY'),'Las Carretas 2089','M','be.garridovi@yahoo.com','788575175','278262242',4030);
INSERT INTO estudiante VALUES (3312325,20865690,'K','Delmira','Miranda','Gómez','Montecinos',TO_DATE('04/09/'||(EXTRACT(YEAR FROM SYSDATE)-30),'DD/MM/YYYY'),'CUATRO REMOS 580 V/ANT. VARAS','F','de.gómezmo@yahoo.com','896227623','378858272',4048);
INSERT INTO estudiante VALUES (3312326,20818347,'6','Ivon','Maricela','Trujillo','Diaz',TO_DATE('12/08/'||(EXTRACT(YEAR FROM SYSDATE)-28),'DD/MM/YYYY'),'Barros Arana 5821','F','iv.trujillodi@gmail.com','777413705','325232677',4042);
INSERT INTO estudiante VALUES (3312327,20771004,'9','Iván','Timothy','Phelps','Robles',TO_DATE('15/01/'||(EXTRACT(YEAR FROM SYSDATE)-26),'DD/MM/YYYY'),'BALMACEDA N.15','M','iv.phelpsro@yahoo.com','827413395','376813742',4030);
INSERT INTO estudiante VALUES (3312328,20723661,'5','Zenaida','Olga','Rivera','Trinke',TO_DATE('22/02/'||(EXTRACT(YEAR FROM SYSDATE)-29),'DD/MM/YYYY'),'Sevilla N°1782','F','ze.riveratr@yahoo.com','782522575','282811337',4022);
INSERT INTO estudiante VALUES (3312329,20676318,'4','Lila','Helen','Morales','Lizana',TO_DATE('30/06/'||(EXTRACT(YEAR FROM SYSDATE)-28),'DD/MM/YYYY'),'Avda. Alemania 2345','F','li.moralesli@outlook.com','987282133','465428513',4050);
INSERT INTO estudiante VALUES (3312330,20628975,'6','Roberta','Silvana','Alvarado','Galdames',TO_DATE('17/05/'||(EXTRACT(YEAR FROM SYSDATE)-29),'DD/MM/YYYY'),'Vicuña Mackena 163','F','ro.alvaradoga@outlook.com','822930493','482541007',4016);
INSERT INTO estudiante VALUES (3312331,20581632,'K','Laura','Ronda','Arriarán','Chambers',TO_DATE('30/08/'||(EXTRACT(YEAR FROM SYSDATE)-21),'DD/MM/YYYY'),'Aconcagua 543','F','la.arriaránch@yahoo.com','954073007','372511179',4010);
INSERT INTO estudiante VALUES (3312332,20534289,'2','Matías','Ulises','Diaz','Keller',TO_DATE('14/02/'||(EXTRACT(YEAR FROM SYSDATE)-30),'DD/MM/YYYY'),'Vicuña Mackena 285','M','ma.diazke@outlook.com','875531188','472399493',4040);
INSERT INTO estudiante VALUES (3312333,20486946,'5','Winston','Pablo','Zamorano','Toledo',TO_DATE('15/09/'||(EXTRACT(YEAR FROM SYSDATE)-24),'DD/MM/YYYY'),'CLOVIS MONTERO 0260 D/202','M','wi.zamoranoto@yahoo.com','979234175','428501857',4034);
INSERT INTO estudiante VALUES (3312334,20439603,'5','Aleida','Javiera','Molina','Navarrete',TO_DATE('08/09/'||(EXTRACT(YEAR FROM SYSDATE)-20),'DD/MM/YYYY'),'Avda. Argentina 134','F','al.molinana@yahoo.com','765428513','392288889',4021);
INSERT INTO estudiante VALUES (3312335,20392260,'9','Ana','Ruth','Saldivar','Cares',TO_DATE('07/04/'||(EXTRACT(YEAR FROM SYSDATE)-19),'DD/MM/YYYY'),'Ana María Ibaceta 46','F','an.saldivarca@yahoo.com','772644691','376255762',4046);
INSERT INTO estudiante VALUES (3312336,20344917,'5','Claudia','Penny','Amengual','Osorio',TO_DATE('13/02/'||(EXTRACT(YEAR FROM SYSDATE)-21),'DD/MM/YYYY'),'Agustina 234','F','cl.amengualos@yahoo.com','987414835','472621089',4012);
INSERT INTO estudiante VALUES (3312337,20297574,'6','Elvia','Rosalía','Araneda','López',TO_DATE('10/05/'||(EXTRACT(YEAR FROM SYSDATE)-18),'DD/MM/YYYY'),'FERNANDEZ CONCHA 500','F','el.aranedaló@outlook.com','992779073','297253828',4046);
INSERT INTO estudiante VALUES (3312338,20250231,'6','Paula','Melinda','Peña','Zurita',TO_DATE('15/05/'||(EXTRACT(YEAR FROM SYSDATE)-26),'DD/MM/YYYY'),'Las Acacias S/N','F','pa.peñazu@yahoo.com','986812350','275230195',4016);
INSERT INTO estudiante VALUES (3312339,20202888,'K','Heraclio','Juan','Amaya','Amengual',TO_DATE('10/07/'||(EXTRACT(YEAR FROM SYSDATE)-25),'DD/MM/YYYY'),'Domeyko 2109','M','he.amayaam@yahoo.com','797377830','477742268',4039);
INSERT INTO estudiante VALUES (3312340,20155545,'K','Federico','Brian','Chung','Montes',TO_DATE('19/07/'||(EXTRACT(YEAR FROM SYSDATE)-30),'DD/MM/YYYY'),'Hernando de Magallanes 123','M','fe.chungmo@outlook.com','786210890','399285373',4053);
INSERT INTO estudiante VALUES (3312341,20108202,'6','Nadia','Alejandrina','Landeros','Keller',TO_DATE('15/06/'||(EXTRACT(YEAR FROM SYSDATE)-20),'DD/MM/YYYY'),'LO ERRAZURIZ 530 V/EL SENDERO','F','na.landeroske@gmail.com','775293595','499228369',4054);
INSERT INTO estudiante VALUES (3312342,20060859,'9','Flor','Jovita','Zúñiga','Thornton',TO_DATE('11/08/'||(EXTRACT(YEAR FROM SYSDATE)-30),'DD/MM/YYYY'),'ALAMEDA 4272 DPTO. 104','F','fl.zúñigath@gmail.com','796255762','482857284',4017);
INSERT INTO estudiante VALUES (3312343,20013516,'2','Amalia','Loreto','Vivallos','Brignardello',TO_DATE('15/05/'||(EXTRACT(YEAR FROM SYSDATE)-30),'DD/MM/YYYY'),'VIA 7 N.1000 B/3 D/7','F','am.vivallosbr@yahoo.com','926811939','275327648',4020);
INSERT INTO estudiante VALUES (3312344,19966173,'5','Malcolm','Augusto','Kohnert','Fisher',TO_DATE('27/05/'||(EXTRACT(YEAR FROM SYSDATE)-29),'DD/MM/YYYY'),'Luis Matte 1477','M','ma.kohnertfi@yahoo.com','822875902','488111801',4036);
INSERT INTO estudiante VALUES (3312345,19918830,'0','Richard','Osvaldo','Pasten','Arredondo',TO_DATE('07/09/'||(EXTRACT(YEAR FROM SYSDATE)-28),'DD/MM/YYYY'),'José Manuel Balmaceda 456','M','ri.pastenar@yahoo.com','987255804','386277422',4056);
INSERT INTO estudiante VALUES (3312346,19871487,'4','Yaneth','Kendra','Rodríguez','Bonta',TO_DATE('14/05/'||(EXTRACT(YEAR FROM SYSDATE)-18),'DD/MM/YYYY'),'Andrés Stambuk Urzic 12','F','ya.rodríguebo@yahoo.com','975262465','322650316',4021);
INSERT INTO estudiante VALUES (3312347,19824144,'4','Yasna','Zenaida','Bolton','Peralta',TO_DATE('03/05/'||(EXTRACT(YEAR FROM SYSDATE)-21),'DD/MM/YYYY'),'PASAJE 36 N.4789 V/EYZAGUIRRE','F','ya.boltonpe@yahoo.com','882844107','388273707',4030);
INSERT INTO estudiante VALUES (3312348,19776801,'9','Fabiana','Soledad','Barraza','Pichihuinca',TO_DATE('04/11/'||(EXTRACT(YEAR FROM SYSDATE)-19),'DD/MM/YYYY'),'Avda. Independencia 3456','F','fa.barrazapi@yahoo.com','977446858','282811337',4046);
INSERT INTO estudiante VALUES (3312349,19729458,'1','Flor','Marta','Alarcon','Fuentealba',TO_DATE('31/08/'||(EXTRACT(YEAR FROM SYSDATE)-28),'DD/MM/YYYY'),'AV. GRECIA 5055 BL/2 DPTO. 22','F','fl.alarconfu@yahoo.com','782796904','299264341',4027);
INSERT INTO estudiante VALUES (3312350,19682115,'7','Oliver','Alejandro','Meyer','Barros',TO_DATE('06/06/'||(EXTRACT(YEAR FROM SYSDATE)-22),'DD/MM/YYYY'),'DR LUIS BISQUERT 2924 DPTO. 4','M','ol.meyerba@gmail.com','796289575','488721366',4049);
INSERT INTO estudiante VALUES (3312351,19634772,'1','Martiniano','Ezequiel','Mandiola','Jordán',TO_DATE('22/11/'||(EXTRACT(YEAR FROM SYSDATE)-22),'DD/MM/YYYY'),'Alcalde Juan José de Mira 1235','M','ma.mandiolajo@outlook.com','952710253','382774099',4022);
INSERT INTO estudiante VALUES (3312352,19587429,'8','Leo','Fidencio','Yepes','Candia',TO_DATE('04/02/'||(EXTRACT(YEAR FROM SYSDATE)-21),'DD/MM/YYYY'),'CALLE 1 C/4452 P/SANTIAGO','M','le.yepesca@yahoo.com','797748105','278545044',4042);


INSERT INTO docente VALUES (60501,19264251,'0','Elías','Erasmo','Liempi','Keller',TO_DATE('02/12/'||(EXTRACT(YEAR FROM SYSDATE)-35),'DD/MM/YYYY'),'Alcalde Roberto Mackay 12','M','el.liempike@gmail.com','887264104','486558208',19890,4041);
INSERT INTO docente VALUES (60502,19065688,'K','Alex','Esteban','Armazán','Sanhueza',TO_DATE('22/05/'||(EXTRACT(YEAR FROM SYSDATE)-33),'DD/MM/YYYY'),'TINGUIRIRICA 3553 V/FORESTA','M','al.armazánsa@yahoo.com','962895758','377415270',12142,4054);
INSERT INTO docente VALUES (60503,18867125,'6','Cardenio','Iván','Barra','Mc Millan',TO_DATE('07/06/'||(EXTRACT(YEAR FROM SYSDATE)-58),'DD/MM/YYYY'),'Alcalde Juan José de Mira 1235','M','ca.barramc@gmail.com','856832705','388509240',16934,4033);
INSERT INTO docente VALUES (60504,18668562,'5','Leonidas','Bernardo','Cavanela','Rivera',TO_DATE('07/12/'||(EXTRACT(YEAR FROM SYSDATE)-30),'DD/MM/YYYY'),'AV.KENNEDY B/16 DEPTO. 31 P/MANSO','M','le.cavanelari@outlook.com','926438047','288112545',16881,4021);
INSERT INTO docente VALUES (60505,18469999,'7','Cirilo','Ulises','Reeves','Barrios',TO_DATE('06/09/'||(EXTRACT(YEAR FROM SYSDATE)-51),'DD/MM/YYYY'),'CLOVIS MONTERO 0260 D/202','M','ci.reevesba@gmail.com','886832705','395412144',18741,4054);
INSERT INTO docente VALUES (60506,18271436,'7','Marcia','Claudia','Zavala','Lapaz',TO_DATE('06/06/'||(EXTRACT(YEAR FROM SYSDATE)-58),'DD/MM/YYYY'),'Adolfo Ruiz Martínez 10','F','ma.zavalala@gmail.com','987776446','382557780',20107,4018);
INSERT INTO docente VALUES (60507,18072873,'0','Josefina','Erika','Améstica','Arroyo',TO_DATE('03/11/'||(EXTRACT(YEAR FROM SYSDATE)-47),'DD/MM/YYYY'),'Giuseppe Verdi 27','F','jo.amésticaar@outlook.com','825581593','389664318',21110,4047);
INSERT INTO docente VALUES (60508,17874310,'1','Glenda','Antonella','Gross','Turner',TO_DATE('23/12/'||(EXTRACT(YEAR FROM SYSDATE)-29),'DD/MM/YYYY'),'Avda. Domingo Santa María 345','F','gl.grosstu@yahoo.com','898580076','386223803',18096,4037);
INSERT INTO docente VALUES (60509,17675747,'0','Heraclio','Edmundo','Orellana','Mc Millan',TO_DATE('08/09/'||(EXTRACT(YEAR FROM SYSDATE)-32),'DD/MM/YYYY'),'Galvarino 627','M','he.orellanamc@outlook.com','898285751','472644691',16383,4030);
INSERT INTO docente VALUES (60510,17477184,'6','Néstor','Josh','Wallace','Améstica',TO_DATE('23/12/'||(EXTRACT(YEAR FROM SYSDATE)-55),'DD/MM/YYYY'),'TINGUIRIRICA 3553 V/FORESTA','M','né.wallaceam@yahoo.com','998260389','277268137',13756,4021);
INSERT INTO docente VALUES (60511,17278621,'K','Marcia','Bianca','Romero','Sobarzo',TO_DATE('17/07/'||(EXTRACT(YEAR FROM SYSDATE)-57),'DD/MM/YYYY'),'LAS AMAPOLAS 1931 P/PEDRO MONT','F','ma.romeroso@gmail.com','895450443','425262465',13739,4043);
INSERT INTO docente VALUES (60512,17080058,'2','Eduardo','Víctor','Fernández','Garrido',TO_DATE('17/05/'||(EXTRACT(YEAR FROM SYSDATE)-46),'DD/MM/YYYY'),'García Lorca 46','M','ed.fernándega@outlook.com','786210890','375778838',19690,4031);
INSERT INTO docente VALUES (60513,16881495,'K','Noel','Cardenio','Aránguiz','Pedraza',TO_DATE('06/12/'||(EXTRACT(YEAR FROM SYSDATE)-38),'DD/MM/YYYY'),'García Lorca 46','M','no.aránguizpe@outlook.com','972671043','497748105',12138,4051);
INSERT INTO docente VALUES (60514,16682932,'6','Walter','Leonardo','Rocha','Fisher',TO_DATE('12/09/'||(EXTRACT(YEAR FROM SYSDATE)-51),'DD/MM/YYYY'),'8 Norte 234 Depto 765 Edificio Santa Clara','M','wa.rochafi@yahoo.com','925577963','272850185',15387,4012);
INSERT INTO docente VALUES (60515,16484369,'8','Galileo','Braulio','Bahamondez','Montoya',TO_DATE('10/04/'||(EXTRACT(YEAR FROM SYSDATE)-34),'DD/MM/YYYY'),'La Rinconada 53','M','ga.bahamondmo@outlook.com','897294005','495317272',15395,4018);
INSERT INTO docente VALUES (60516,16285806,'0','Brayan','Melchor','Montero','Monsalve',TO_DATE('02/10/'||(EXTRACT(YEAR FROM SYSDATE)-55),'DD/MM/YYYY'),'Plaza Muñoz Gamero 25','M','br.monteromo@gmail.com','989255779','286252858',14381,4030);
INSERT INTO docente VALUES (60517,16087243,'0','Mercedes','Rachael','Wallace','Zúñiga',TO_DATE('24/10/'||(EXTRACT(YEAR FROM SYSDATE)-43),'DD/MM/YYYY'),'Miguel de Cervantes 89','F','me.wallacezú@outlook.com','975596474','296227855',14399,4051);
INSERT INTO docente VALUES (60518,15888680,'4','Evangelina','Orfelia','Lara','Rocha',TO_DATE('19/09/'||(EXTRACT(YEAR FROM SYSDATE)-60),'DD/MM/YYYY'),'Sgto. Aldea 86','F','ev.lararo@gmail.com','892683338','482895758',20248,4040);
INSERT INTO docente VALUES (60519,15690117,'8','Ronny','Armando','Maldonado','Diócares',TO_DATE('11/12/'||(EXTRACT(YEAR FROM SYSDATE)-46),'DD/MM/YYYY'),'Álvarez 234 Depto 123 Edificio San Luis','M','ro.maldonaddi@yahoo.com','965582082','376213729',17851,4017);
INSERT INTO docente VALUES (60520,15491554,'8','Guadalupe','Angelina','Arias','Aguilar',TO_DATE('19/04/'||(EXTRACT(YEAR FROM SYSDATE)-55),'DD/MM/YYYY'),'General Mendoza 328','F','gu.ariasag@gmail.com','795577804','385289043',18207,4047);
INSERT INTO docente VALUES (60521,15292991,'4','Darlene','Rosina','Tobar','Toro',TO_DATE('27/02/'||(EXTRACT(YEAR FROM SYSDATE)-46),'DD/MM/YYYY'),'TERCEIRA 7426 V/LIBERTAD','F','da.tobarto@gmail.com','972324323','486277422',17351,4023);
INSERT INTO docente VALUES (60522,15094428,'1','Cecilia','Vanessa','Osborne','Iturrieta',TO_DATE('27/02/'||(EXTRACT(YEAR FROM SYSDATE)-47),'DD/MM/YYYY'),'Plaza Muñoz Gamero 25','F','ce.osborneit@yahoo.com','775778838','288213310',12965,4027);
INSERT INTO docente VALUES (60523,14895865,'6','Benjamín','Damián','Benitez','Bobadilla',TO_DATE('02/03/'||(EXTRACT(YEAR FROM SYSDATE)-47),'DD/MM/YYYY'),'Avenida Los Generales 675','M','be.benitezbo@gmail.com','988122441','225631567',21022,4047);
INSERT INTO docente VALUES (60524,14697302,'9','Anselmo','Heraclio','Barahona','Alarcon',TO_DATE('12/05/'||(EXTRACT(YEAR FROM SYSDATE)-32),'DD/MM/YYYY'),'Adela Von Hagrn 567','M','an.barahonaal@outlook.com','895292190','296228255',14351,4021);
INSERT INTO docente VALUES (60525,14498739,'1','Heraclio','Marco','Galdames','Dillon',TO_DATE('25/01/'||(EXTRACT(YEAR FROM SYSDATE)-36),'DD/MM/YYYY'),'Galvarino 627','M','he.galdamesdi@yahoo.com','872741339','476442200',18840,4018);
INSERT INTO docente VALUES (60526,14300176,'K','Elías','Zenón','Falcon','Bermudez',TO_DATE('23/10/'||(EXTRACT(YEAR FROM SYSDATE)-53),'DD/MM/YYYY'),'Serrano 275','M','el.falconbe@outlook.com','775631102','372894026',13401,4049);
INSERT INTO docente VALUES (60527,14101613,'0','Malcolm','José','Gómez','Bates',TO_DATE('15/06/'||(EXTRACT(YEAR FROM SYSDATE)-57),'DD/MM/YYYY'),'Alto Los Leones 8873','M','ma.gómezba@gmail.com','772894026','382242459',14960,4018);
INSERT INTO docente VALUES (60528,13903050,'3','John','Pánfilo','Luna','Henríquez',TO_DATE('12/01/'||(EXTRACT(YEAR FROM SYSDATE)-35),'DD/MM/YYYY'),'Avda Las Parcelas 3512','M','jo.lunahe@gmail.com','787264900','392858007',21527,4050);
INSERT INTO docente VALUES (60529,13704487,'5','Ximeno','Josh','Maltrain','Hendricks',TO_DATE('21/02/'||(EXTRACT(YEAR FROM SYSDATE)-25),'DD/MM/YYYY'),'Las Acacias S/N','M','xi.maltrainhe@yahoo.com','786966329','275631102',14282,4023);
INSERT INTO docente VALUES (60530,13505924,'1','Sergio','Melchor','Villegas','Bolton',TO_DATE('13/07/'||(EXTRACT(YEAR FROM SYSDATE)-27),'DD/MM/YYYY'),'Giuseppe Verdi 27','M','se.villegasbo@gmail.com','855311880','426490093',18106,4055);
INSERT INTO docente VALUES (60531,13307361,'2','Leandro','Bernardo','Paez','Monares',TO_DATE('06/03/'||(EXTRACT(YEAR FROM SYSDATE)-58),'DD/MM/YYYY'),'PJE.BELEN N.8 P/GERALDINE','M','le.paezmo@yahoo.com','723244270','295778724',17209,4013);
INSERT INTO docente VALUES (60532,13108798,'4','Ramón','Fidencio','Acevedo','Améstica',TO_DATE('12/04/'||(EXTRACT(YEAR FROM SYSDATE)-53),'DD/MM/YYYY'),'Pardo 1288','M','ra.acevedoam@outlook.com','782844107','485313830',17752,4028);
INSERT INTO docente VALUES (60533,12910235,'4','Rosario','Bonnie','Valencia','Mc Gee',TO_DATE('05/09/'||(EXTRACT(YEAR FROM SYSDATE)-49),'DD/MM/YYYY'),'Los Almendros 123 Miraflores Bajo','F','ro.valenciamc@gmail.com','972625285','479625576',12135,4018);
INSERT INTO docente VALUES (60534,12711672,'1','Antonella','Candelaria','Rojas','Retamal',TO_DATE('12/08/'||(EXTRACT(YEAR FROM SYSDATE)-32),'DD/MM/YYYY'),'PJE. FREIRINA 3630','F','an.rojasre@gmail.com','772529249','477227731',21522,4052);
INSERT INTO docente VALUES (60535,12513109,'1','Israel','Iván','Concha','Velásquez',TO_DATE('05/06/'||(EXTRACT(YEAR FROM SYSDATE)-57),'DD/MM/YYYY'),'GENARO PRIETO 910 P/EL TRANQUE','M','is.conchave@outlook.com','986493855','497783253',20714,4042);
INSERT INTO docente VALUES (60536,12314546,'7','James','Ramón','Collao','Salinas',TO_DATE('15/12/'||(EXTRACT(YEAR FROM SYSDATE)-32),'DD/MM/YYYY'),'CALLE 1 C/4452 P/SANTIAGO','M','ja.collaosa@gmail.com','888263328','282558042',13232,4049);
INSERT INTO docente VALUES (60537,12115983,'4','Jeremías','Leonard','Reeves','González',TO_DATE('04/11/'||(EXTRACT(YEAR FROM SYSDATE)-25),'DD/MM/YYYY'),'DORSAL 5912 V/MANUEL RODRIGUEZ','M','je.reevesgo@gmail.com','876264938','266228120',15248,4022);
INSERT INTO docente VALUES (60538,11917420,'7','Alfredo','Alfonso','Castrizelo','Amengual',TO_DATE('05/05/'||(EXTRACT(YEAR FROM SYSDATE)-32),'DD/MM/YYYY'),'PJE.LLEUQUE 0861 V/EL PERAL 3','M','al.castrizeam@yahoo.com','855212406','396778325',18677,4025);
INSERT INTO docente VALUES (60539,11718857,'0','Rhonda','Magdalena','Farias','Chavez',TO_DATE('07/07/'||(EXTRACT(YEAR FROM SYSDATE)-42),'DD/MM/YYYY'),'CIENCIAS 8442 P/BIAUT','F','rh.fariasch@yahoo.com','722773144','428113377',16005,4047);
INSERT INTO docente VALUES (60540,11520294,'9','Felicia','Flor','Otarola','Gutiérrez',TO_DATE('25/03/'||(EXTRACT(YEAR FROM SYSDATE)-51),'DD/MM/YYYY'),'Vicuña Mackena 16387','F','fe.otarolagu@outlook.com','926483081','392858007',11847,4056);
INSERT INTO docente VALUES (60541,11321731,'1','Wendy','Selena','Daniels','Sierra',TO_DATE('18/05/'||(EXTRACT(YEAR FROM SYSDATE)-41),'DD/MM/YYYY'),'BALMACEDA 1070','F','we.danielssi@outlook.com','976213729','268111801',14041,4018);
INSERT INTO docente VALUES (60542,11123168,'0','Elizabeth','Viviana','Bates','Fritis',TO_DATE('12/12/'||(EXTRACT(YEAR FROM SYSDATE)-38),'DD/MM/YYYY'),'GENERAL CONCHA PEDREGAL 885','F','el.batesfr@gmail.com','998252301','377461014',19745,4046);
INSERT INTO docente VALUES (60543,10924605,'0','Javier','Josh','Gatica','Gordon',TO_DATE('07/05/'||(EXTRACT(YEAR FROM SYSDATE)-46),'DD/MM/YYYY'),'HANOI 7474','M','ja.gaticago@outlook.com','976838623','287255804',17578,4027);
INSERT INTO docente VALUES (60544,10726042,'3','Elizabeth','Yasna','Gallegos','Mc Gee',TO_DATE('16/03/'||(EXTRACT(YEAR FROM SYSDATE)-59),'DD/MM/YYYY'),'Bernardo OHiggins 124','F','el.gallegosmc@gmail.com','976854623','398622967',18892,4030);
INSERT INTO docente VALUES (60545,10527479,'1','Seth','Jesús','Rubio','Robles',TO_DATE('13/01/'||(EXTRACT(YEAR FROM SYSDATE)-54),'DD/MM/YYYY'),'Blanco Encalada Depto 34 Edificio San Bernardo','M','se.rubioro@gmail.com','873243232','487264900',14718,4027);
INSERT INTO docente VALUES (60546,10328916,'5','Rubén','Nelson','Snow','Pizarro',TO_DATE('26/10/'||(EXTRACT(YEAR FROM SYSDATE)-44),'DD/MM/YYYY'),'Palermo 984','M','ru.snowpi@gmail.com','772825520','385271025',17021,4031);
INSERT INTO docente VALUES (60547,10130353,'2','Ingrid','Valeria','Wallace','López',TO_DATE('14/04/'||(EXTRACT(YEAR FROM SYSDATE)-60),'DD/MM/YYYY'),'FCO. DE CAMARGO 14515 D/14','F','in.wallaceló@gmail.com','996413331','396277632',16233,4010);


INSERT INTO matricula VALUES (760001,TO_DATE('05/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312301,2907,'D');
INSERT INTO matricula VALUES (760002,TO_DATE('21/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312302,2907,'D');
INSERT INTO matricula VALUES (760003,TO_DATE('01/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312303,2907,'D');
INSERT INTO matricula VALUES (760004,TO_DATE('08/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312304,2907,'V');
INSERT INTO matricula VALUES (760005,TO_DATE('02/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312305,2907,'V');
INSERT INTO matricula VALUES (760006,TO_DATE('06/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312306,2907,'V');
INSERT INTO matricula VALUES (760007,TO_DATE('04/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312307,2907,'V');
INSERT INTO matricula VALUES (760008,TO_DATE('12/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312308,2907,'D');
INSERT INTO matricula VALUES (760009,TO_DATE('05/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312309,2907,'V');
INSERT INTO matricula VALUES (760010,TO_DATE('07/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312310,2907,'D');
INSERT INTO matricula VALUES (760011,TO_DATE('19/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312311,2902,'V');
INSERT INTO matricula VALUES (760012,TO_DATE('24/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312312,2902,'V');
INSERT INTO matricula VALUES (760013,TO_DATE('01/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312313,2902,'V');
INSERT INTO matricula VALUES (760014,TO_DATE('08/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312314,2902,'V');
INSERT INTO matricula VALUES (760015,TO_DATE('14/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312315,2902,'V');
INSERT INTO matricula VALUES (760016,TO_DATE('23/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312316,2902,'D');
INSERT INTO matricula VALUES (760017,TO_DATE('27/02/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312317,2902,'V');
INSERT INTO matricula VALUES (760018,TO_DATE('27/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312318,2902,'V');
INSERT INTO matricula VALUES (760019,TO_DATE('12/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312319,2902,'D');
INSERT INTO matricula VALUES (760020,TO_DATE('28/01/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),3312320,2902,'V');
INSERT INTO matricula VALUES (760021,TO_DATE('21/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312321,2907,'D');
INSERT INTO matricula VALUES (760022,TO_DATE('11/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312322,2907,'V');
INSERT INTO matricula VALUES (760023,TO_DATE('23/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312323,2907,'V');
INSERT INTO matricula VALUES (760024,TO_DATE('21/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312324,2907,'D');
INSERT INTO matricula VALUES (760025,TO_DATE('22/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312325,2907,'D');
INSERT INTO matricula VALUES (760026,TO_DATE('12/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312326,2907,'V');
INSERT INTO matricula VALUES (760027,TO_DATE('05/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312327,2907,'D');
INSERT INTO matricula VALUES (760028,TO_DATE('01/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312328,2907,'D');
INSERT INTO matricula VALUES (760029,TO_DATE('02/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312329,2907,'D');
INSERT INTO matricula VALUES (760030,TO_DATE('24/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312330,2907,'V');
INSERT INTO matricula VALUES (760031,TO_DATE('15/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312331,2902,'D');
INSERT INTO matricula VALUES (760032,TO_DATE('06/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312332,2902,'D');
INSERT INTO matricula VALUES (760033,TO_DATE('11/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312333,2902,'D');
INSERT INTO matricula VALUES (760034,TO_DATE('08/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312334,2902,'V');
INSERT INTO matricula VALUES (760035,TO_DATE('12/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312335,2902,'D');
INSERT INTO matricula VALUES (760036,TO_DATE('11/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312336,2902,'D');
INSERT INTO matricula VALUES (760037,TO_DATE('16/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312337,2902,'V');
INSERT INTO matricula VALUES (760038,TO_DATE('03/01/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312338,2902,'D');
INSERT INTO matricula VALUES (760039,TO_DATE('04/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312339,2902,'V');
INSERT INTO matricula VALUES (760040,TO_DATE('21/02/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),3312340,2902,'D');
INSERT INTO matricula VALUES (760041,TO_DATE('02/02/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312341,2907,'D');
INSERT INTO matricula VALUES (760042,TO_DATE('19/01/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312342,2907,'V');
INSERT INTO matricula VALUES (760043,TO_DATE('18/01/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312343,2907,'D');
INSERT INTO matricula VALUES (760044,TO_DATE('13/02/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312344,2907,'D');
INSERT INTO matricula VALUES (760045,TO_DATE('01/02/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312345,2907,'D');
INSERT INTO matricula VALUES (760046,TO_DATE('12/01/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312346,2902,'V');
INSERT INTO matricula VALUES (760047,TO_DATE('18/02/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312347,2902,'V');
INSERT INTO matricula VALUES (760048,TO_DATE('12/01/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312348,2902,'V');
INSERT INTO matricula VALUES (760049,TO_DATE('03/01/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312349,2902,'V');
INSERT INTO matricula VALUES (760050,TO_DATE('24/01/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312350,2902,'D');
INSERT INTO matricula VALUES (760051,TO_DATE('20/02/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312351,2902,'D');
INSERT INTO matricula VALUES (760052,TO_DATE('18/02/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),3312352,2902,'V');


INSERT INTO seccion VALUES (221301,EXTRACT(YEAR FROM SYSDATE)-2,1,35,23,12,5.2,60535,2902,7081);
INSERT INTO seccion VALUES (221302,EXTRACT(YEAR FROM SYSDATE)-2,2,25,15,10,4.6,60547,2902,7090);
INSERT INTO seccion VALUES (221303,EXTRACT(YEAR FROM SYSDATE)-2,1,35,20,15,6.5,60539,2907,7087);
INSERT INTO seccion VALUES (221304,EXTRACT(YEAR FROM SYSDATE)-2,2,30,16,14,4.6,60536,2907,7088);
INSERT INTO seccion VALUES (221305,EXTRACT(YEAR FROM SYSDATE)-1,1,25,25,0,4.3,60519,2902,7081);
INSERT INTO seccion VALUES (221306,EXTRACT(YEAR FROM SYSDATE)-1,2,25,13,12,3.2,60512,2902,7090);
INSERT INTO seccion VALUES (221307,EXTRACT(YEAR FROM SYSDATE)-1,1,30,30,0,6.6,60512,2902,7097);
INSERT INTO seccion VALUES (221308,EXTRACT(YEAR FROM SYSDATE)-1,2,40,35,5,3.9,60512,2902,7098);
INSERT INTO seccion VALUES (221309,EXTRACT(YEAR FROM SYSDATE)-1,1,40,33,7,4.2,60535,2907,7087);
INSERT INTO seccion VALUES (221310,EXTRACT(YEAR FROM SYSDATE)-1,2,35,33,2,4.4,60532,2907,7088);
INSERT INTO seccion VALUES (221311,EXTRACT(YEAR FROM SYSDATE)-1,1,40,28,12,5.8,60526,2907,7089);
INSERT INTO seccion VALUES (221312,EXTRACT(YEAR FROM SYSDATE)-1,2,35,29,6,6.2,60528,2907,7091);
INSERT INTO seccion VALUES (221313,EXTRACT(YEAR FROM SYSDATE)-0,1,35,26,9,5.9,60537,2902,7081);
INSERT INTO seccion VALUES (221314,EXTRACT(YEAR FROM SYSDATE)-0,1,25,18,7,3.4,60547,2902,7097);
INSERT INTO seccion VALUES (221315,EXTRACT(YEAR FROM SYSDATE)-0,1,40,34,6,5.8,60502,2902,7104);
INSERT INTO seccion VALUES (221316,EXTRACT(YEAR FROM SYSDATE)-0,1,35,30,5,6.6,60504,2907,7087);
INSERT INTO seccion VALUES (221317,EXTRACT(YEAR FROM SYSDATE)-0,1,35,33,2,4.2,60532,2907,7089);
INSERT INTO seccion VALUES (221318,EXTRACT(YEAR FROM SYSDATE)-0,1,40,37,3,3.7,60522,2907,7101);






INSERT INTO det_seccion_estudiante VALUES (221301,3312301,4.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312302,4.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312303,4.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312304,6.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312305,6.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312306,4.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312307,4.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312308,4.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312309,6.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221301,3312310,6.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221302,3312301,3.4,'RR');
INSERT INTO det_seccion_estudiante VALUES (221302,3312302,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221302,3312303,3.3,'RR');
INSERT INTO det_seccion_estudiante VALUES (221302,3312304,4.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221302,3312305,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221302,3312306,4.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221302,3312307,5.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221302,3312308,5.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221302,3312309,6.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221302,3312310,3.3,'RR');
INSERT INTO det_seccion_estudiante VALUES (221307,3312301,3.1,'RR');
INSERT INTO det_seccion_estudiante VALUES (221307,3312302,5.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221307,3312303,6.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221307,3312304,4.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221307,3312305,5.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221307,3312306,5.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221307,3312307,3.2,'RR');
INSERT INTO det_seccion_estudiante VALUES (221307,3312308,6.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221307,3312309,4.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221307,3312310,4.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221308,3312301,5.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221308,3312302,5.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221308,3312303,3.2,'RR');
INSERT INTO det_seccion_estudiante VALUES (221308,3312304,6.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221308,3312305,3.8,'RR');
INSERT INTO det_seccion_estudiante VALUES (221308,3312306,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221308,3312307,6.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221308,3312308,3.6,'RR');
INSERT INTO det_seccion_estudiante VALUES (221308,3312309,5.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221308,3312310,6.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221315,3312301,3.2,'RR');
INSERT INTO det_seccion_estudiante VALUES (221315,3312302,5.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221315,3312303,6.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221315,3312304,3.9,'RR');
INSERT INTO det_seccion_estudiante VALUES (221315,3312305,4.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221315,3312306,5.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221315,3312307,3.5,'RR');
INSERT INTO det_seccion_estudiante VALUES (221315,3312308,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221315,3312309,3.7,'RR');
INSERT INTO det_seccion_estudiante VALUES (221315,3312310,6.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221303,3312311,6.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221303,3312312,3.7,'RR');
INSERT INTO det_seccion_estudiante VALUES (221303,3312313,3.9,'RR');
INSERT INTO det_seccion_estudiante VALUES (221303,3312314,3.8,'RR');
INSERT INTO det_seccion_estudiante VALUES (221303,3312315,4.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221303,3312316,6.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221303,3312317,3.5,'RR');
INSERT INTO det_seccion_estudiante VALUES (221303,3312318,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221303,3312319,6.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221303,3312320,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312311,6.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312312,6.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312313,5.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312314,5.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312315,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312316,5.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312317,6.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312318,3.4,'RR');
INSERT INTO det_seccion_estudiante VALUES (221304,3312319,4.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221304,3312320,6.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221311,3312311,5.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221311,3312312,4.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221311,3312313,3.9,'RR');
INSERT INTO det_seccion_estudiante VALUES (221311,3312314,6.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221311,3312315,6.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221311,3312316,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221311,3312317,5.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221311,3312318,3.9,'RR');
INSERT INTO det_seccion_estudiante VALUES (221311,3312319,4.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221311,3312320,6.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221312,3312311,4.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221312,3312312,5.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221312,3312313,6.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221312,3312314,3.6,'RR');
INSERT INTO det_seccion_estudiante VALUES (221312,3312315,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221312,3312316,5.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221312,3312317,3.4,'RR');
INSERT INTO det_seccion_estudiante VALUES (221312,3312318,6.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221312,3312319,6.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221312,3312320,5.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221318,3312311,5.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221318,3312312,6.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221318,3312313,4.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221318,3312314,5.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221318,3312315,3.5,'RR');
INSERT INTO det_seccion_estudiante VALUES (221318,3312316,3.4,'RR');
INSERT INTO det_seccion_estudiante VALUES (221318,3312317,4.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221318,3312318,5.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221318,3312319,6.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221318,3312320,3.9,'RR');
INSERT INTO det_seccion_estudiante VALUES (221305,3312321,6.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221305,3312322,4.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221305,3312323,5.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221305,3312324,6.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221305,3312325,3.3,'RR');
INSERT INTO det_seccion_estudiante VALUES (221305,3312326,3.9,'RR');
INSERT INTO det_seccion_estudiante VALUES (221305,3312327,3.4,'RR');
INSERT INTO det_seccion_estudiante VALUES (221305,3312328,3.5,'RR');
INSERT INTO det_seccion_estudiante VALUES (221305,3312329,6.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221305,3312330,4.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221306,3312321,5.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221306,3312322,6.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221306,3312323,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221306,3312324,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221306,3312325,4.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221306,3312326,3.8,'RR');
INSERT INTO det_seccion_estudiante VALUES (221306,3312327,5.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221306,3312328,3.3,'RR');
INSERT INTO det_seccion_estudiante VALUES (221306,3312329,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221306,3312330,4.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221314,3312321,5.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221314,3312322,4.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221314,3312323,3.1,'RR');
INSERT INTO det_seccion_estudiante VALUES (221314,3312324,3.8,'RR');
INSERT INTO det_seccion_estudiante VALUES (221314,3312325,5.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221314,3312326,3.7,'RR');
INSERT INTO det_seccion_estudiante VALUES (221314,3312327,3.1,'RR');
INSERT INTO det_seccion_estudiante VALUES (221314,3312328,5.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221314,3312329,5.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221314,3312330,5.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221309,3312331,4.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221309,3312332,3.6,'RR');
INSERT INTO det_seccion_estudiante VALUES (221309,3312333,6.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221309,3312334,6.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221309,3312335,6.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221309,3312336,4.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221309,3312337,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221309,3312338,6.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221309,3312339,3.5,'RR');
INSERT INTO det_seccion_estudiante VALUES (221309,3312340,6.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312331,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312332,5.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312333,3.8,'RR');
INSERT INTO det_seccion_estudiante VALUES (221310,3312334,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312335,5.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312336,5.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312337,6.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312338,5.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312339,4.9,'AA');
INSERT INTO det_seccion_estudiante VALUES (221310,3312340,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221317,3312331,3.3,'RR');
INSERT INTO det_seccion_estudiante VALUES (221317,3312332,3.4,'RR');
INSERT INTO det_seccion_estudiante VALUES (221317,3312333,3.3,'RR');
INSERT INTO det_seccion_estudiante VALUES (221317,3312334,3.8,'RR');
INSERT INTO det_seccion_estudiante VALUES (221317,3312335,6.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221317,3312336,5.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221317,3312337,3.7,'RR');
INSERT INTO det_seccion_estudiante VALUES (221317,3312338,4.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221317,3312339,3.5,'RR');
INSERT INTO det_seccion_estudiante VALUES (221317,3312340,4.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221313,3312341,3.4,'RR');
INSERT INTO det_seccion_estudiante VALUES (221313,3312342,3.7,'RR');
INSERT INTO det_seccion_estudiante VALUES (221313,3312343,5.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221313,3312344,6.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221313,3312345,6.8,'AA');
INSERT INTO det_seccion_estudiante VALUES (221313,3312346,5.4,'AA');
INSERT INTO det_seccion_estudiante VALUES (221313,3312347,6.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221313,3312348,6.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221313,3312349,5.6,'AA');
INSERT INTO det_seccion_estudiante VALUES (221313,3312350,4.1,'AA');
INSERT INTO det_seccion_estudiante VALUES (221316,3312341,3.5,'RR');
INSERT INTO det_seccion_estudiante VALUES (221316,3312342,4.3,'AA');
INSERT INTO det_seccion_estudiante VALUES (221316,3312343,6.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221316,3312344,3.5,'RR');
INSERT INTO det_seccion_estudiante VALUES (221316,3312345,5.2,'AA');
INSERT INTO det_seccion_estudiante VALUES (221316,3312346,3.3,'RR');
INSERT INTO det_seccion_estudiante VALUES (221316,3312347,3.9,'RR');
INSERT INTO det_seccion_estudiante VALUES (221316,3312348,4.7,'AA');
INSERT INTO det_seccion_estudiante VALUES (221316,3312349,5.5,'AA');
INSERT INTO det_seccion_estudiante VALUES (221316,3312350,5.2,'AA');


INSERT INTO det_seccion_evaluacion VALUES (221301,1,3.2);
INSERT INTO det_seccion_evaluacion VALUES (221302,1,5.3);
INSERT INTO det_seccion_evaluacion VALUES (221303,1,4.9);
INSERT INTO det_seccion_evaluacion VALUES (221304,1,6.8);
INSERT INTO det_seccion_evaluacion VALUES (221305,1,6.4);
INSERT INTO det_seccion_evaluacion VALUES (221306,1,3.8);
INSERT INTO det_seccion_evaluacion VALUES (221307,1,4.6);
INSERT INTO det_seccion_evaluacion VALUES (221308,1,6.3);
INSERT INTO det_seccion_evaluacion VALUES (221309,1,3.4);
INSERT INTO det_seccion_evaluacion VALUES (221310,1,3.7);
INSERT INTO det_seccion_evaluacion VALUES (221311,1,3.9);
INSERT INTO det_seccion_evaluacion VALUES (221312,1,4.4);
INSERT INTO det_seccion_evaluacion VALUES (221313,1,3.2);
INSERT INTO det_seccion_evaluacion VALUES (221314,1,4.5);
INSERT INTO det_seccion_evaluacion VALUES (221315,1,6.6);
INSERT INTO det_seccion_evaluacion VALUES (221316,1,4.9);
INSERT INTO det_seccion_evaluacion VALUES (221317,1,6.5);
INSERT INTO det_seccion_evaluacion VALUES (221318,1,3.7);
INSERT INTO det_seccion_evaluacion VALUES (221301,2,6.1);
INSERT INTO det_seccion_evaluacion VALUES (221302,2,3.5);
INSERT INTO det_seccion_evaluacion VALUES (221303,2,6.2);
INSERT INTO det_seccion_evaluacion VALUES (221304,2,6.8);
INSERT INTO det_seccion_evaluacion VALUES (221305,2,5.3);
INSERT INTO det_seccion_evaluacion VALUES (221306,2,4.9);
INSERT INTO det_seccion_evaluacion VALUES (221307,2,3.9);
INSERT INTO det_seccion_evaluacion VALUES (221308,2,3.4);
INSERT INTO det_seccion_evaluacion VALUES (221309,2,5.4);
INSERT INTO det_seccion_evaluacion VALUES (221310,2,3.5);
INSERT INTO det_seccion_evaluacion VALUES (221311,2,5.5);
INSERT INTO det_seccion_evaluacion VALUES (221312,2,6.1);
INSERT INTO det_seccion_evaluacion VALUES (221313,2,3.2);
INSERT INTO det_seccion_evaluacion VALUES (221314,2,3.7);
INSERT INTO det_seccion_evaluacion VALUES (221315,2,4.5);
INSERT INTO det_seccion_evaluacion VALUES (221316,2,6.8);
INSERT INTO det_seccion_evaluacion VALUES (221317,2,6.7);
INSERT INTO det_seccion_evaluacion VALUES (221318,2,5.5);


INSERT INTO nota_eva_estudiante VALUES (1,221301,1,5.8,3312301);
INSERT INTO nota_eva_estudiante VALUES (2,221301,1,4.8,3312302);
INSERT INTO nota_eva_estudiante VALUES (3,221301,1,5.4,3312303);
INSERT INTO nota_eva_estudiante VALUES (4,221301,1,6.7,3312304);
INSERT INTO nota_eva_estudiante VALUES (5,221301,1,5.2,3312305);
INSERT INTO nota_eva_estudiante VALUES (6,221301,1,5.3,3312306);
INSERT INTO nota_eva_estudiante VALUES (7,221301,1,5.5,3312307);
INSERT INTO nota_eva_estudiante VALUES (8,221301,1,4.4,3312308);
INSERT INTO nota_eva_estudiante VALUES (9,221301,1,5.2,3312309);
INSERT INTO nota_eva_estudiante VALUES (10,221301,1,3.6,3312310);
INSERT INTO nota_eva_estudiante VALUES (11,221302,1,4.3,3312301);
INSERT INTO nota_eva_estudiante VALUES (12,221302,1,6.5,3312302);
INSERT INTO nota_eva_estudiante VALUES (13,221302,1,5.3,3312303);
INSERT INTO nota_eva_estudiante VALUES (14,221302,1,6.8,3312304);
INSERT INTO nota_eva_estudiante VALUES (15,221302,1,4.3,3312305);
INSERT INTO nota_eva_estudiante VALUES (16,221302,1,4.5,3312306);
INSERT INTO nota_eva_estudiante VALUES (17,221302,1,4.1,3312307);
INSERT INTO nota_eva_estudiante VALUES (18,221302,1,4.1,3312308);
INSERT INTO nota_eva_estudiante VALUES (19,221302,1,5.9,3312309);
INSERT INTO nota_eva_estudiante VALUES (20,221302,1,3.4,3312310);
INSERT INTO nota_eva_estudiante VALUES (21,221307,1,6.2,3312301);
INSERT INTO nota_eva_estudiante VALUES (22,221307,1,6.4,3312302);
INSERT INTO nota_eva_estudiante VALUES (23,221307,1,3.7,3312303);
INSERT INTO nota_eva_estudiante VALUES (24,221307,1,5.2,3312304);
INSERT INTO nota_eva_estudiante VALUES (25,221307,1,5.8,3312305);
INSERT INTO nota_eva_estudiante VALUES (26,221307,1,3.6,3312306);
INSERT INTO nota_eva_estudiante VALUES (27,221307,1,6.5,3312307);
INSERT INTO nota_eva_estudiante VALUES (28,221307,1,3.6,3312308);
INSERT INTO nota_eva_estudiante VALUES (29,221307,1,4.3,3312309);
INSERT INTO nota_eva_estudiante VALUES (30,221307,1,6.9,3312310);
INSERT INTO nota_eva_estudiante VALUES (31,221308,1,6.3,3312301);
INSERT INTO nota_eva_estudiante VALUES (32,221308,1,4.7,3312302);
INSERT INTO nota_eva_estudiante VALUES (33,221308,1,5.6,3312303);
INSERT INTO nota_eva_estudiante VALUES (34,221308,1,5.5,3312304);
INSERT INTO nota_eva_estudiante VALUES (35,221308,1,6.1,3312305);
INSERT INTO nota_eva_estudiante VALUES (36,221308,1,5.6,3312306);
INSERT INTO nota_eva_estudiante VALUES (37,221308,1,4.3,3312307);
INSERT INTO nota_eva_estudiante VALUES (38,221308,1,4.6,3312308);
INSERT INTO nota_eva_estudiante VALUES (39,221308,1,5.2,3312309);
INSERT INTO nota_eva_estudiante VALUES (40,221308,1,4.8,3312310);
INSERT INTO nota_eva_estudiante VALUES (41,221315,1,5.2,3312301);
INSERT INTO nota_eva_estudiante VALUES (42,221315,1,4.1,3312302);
INSERT INTO nota_eva_estudiante VALUES (43,221315,1,4.7,3312303);
INSERT INTO nota_eva_estudiante VALUES (44,221315,1,4.7,3312304);
INSERT INTO nota_eva_estudiante VALUES (45,221315,1,4.8,3312305);
INSERT INTO nota_eva_estudiante VALUES (46,221315,1,4.5,3312306);
INSERT INTO nota_eva_estudiante VALUES (47,221315,1,5.7,3312307);
INSERT INTO nota_eva_estudiante VALUES (48,221315,1,4.6,3312308);
INSERT INTO nota_eva_estudiante VALUES (49,221315,1,4.8,3312309);
INSERT INTO nota_eva_estudiante VALUES (50,221315,1,3.2,3312310);
INSERT INTO nota_eva_estudiante VALUES (51,221303,1,4.6,3312311);
INSERT INTO nota_eva_estudiante VALUES (52,221303,1,3.9,3312312);
INSERT INTO nota_eva_estudiante VALUES (53,221303,1,4.5,3312313);
INSERT INTO nota_eva_estudiante VALUES (54,221303,1,5.2,3312314);
INSERT INTO nota_eva_estudiante VALUES (55,221303,1,3.5,3312315);
INSERT INTO nota_eva_estudiante VALUES (56,221303,1,3.1,3312316);
INSERT INTO nota_eva_estudiante VALUES (57,221303,1,4.4,3312317);
INSERT INTO nota_eva_estudiante VALUES (58,221303,1,4.3,3312318);
INSERT INTO nota_eva_estudiante VALUES (59,221303,1,5.1,3312319);
INSERT INTO nota_eva_estudiante VALUES (60,221303,1,6.3,3312320);
INSERT INTO nota_eva_estudiante VALUES (61,221304,1,5.6,3312311);
INSERT INTO nota_eva_estudiante VALUES (62,221304,1,6.1,3312312);
INSERT INTO nota_eva_estudiante VALUES (63,221304,1,6.9,3312313);
INSERT INTO nota_eva_estudiante VALUES (64,221304,1,3.4,3312314);
INSERT INTO nota_eva_estudiante VALUES (65,221304,1,5.7,3312315);
INSERT INTO nota_eva_estudiante VALUES (66,221304,1,6.4,3312316);
INSERT INTO nota_eva_estudiante VALUES (67,221304,1,6.3,3312317);
INSERT INTO nota_eva_estudiante VALUES (68,221304,1,6.3,3312318);
INSERT INTO nota_eva_estudiante VALUES (69,221304,1,6.7,3312319);
INSERT INTO nota_eva_estudiante VALUES (70,221304,1,6.8,3312320);
INSERT INTO nota_eva_estudiante VALUES (71,221311,1,6.8,3312311);
INSERT INTO nota_eva_estudiante VALUES (72,221311,1,3.3,3312312);
INSERT INTO nota_eva_estudiante VALUES (73,221311,1,4.1,3312313);
INSERT INTO nota_eva_estudiante VALUES (74,221311,1,5.8,3312314);
INSERT INTO nota_eva_estudiante VALUES (75,221311,1,4.1,3312315);
INSERT INTO nota_eva_estudiante VALUES (76,221311,1,5.3,3312316);
INSERT INTO nota_eva_estudiante VALUES (77,221311,1,3.1,3312317);
INSERT INTO nota_eva_estudiante VALUES (78,221311,1,6.5,3312318);
INSERT INTO nota_eva_estudiante VALUES (79,221311,1,3.3,3312319);
INSERT INTO nota_eva_estudiante VALUES (80,221311,1,4.6,3312320);
INSERT INTO nota_eva_estudiante VALUES (81,221312,1,6.7,3312311);
INSERT INTO nota_eva_estudiante VALUES (82,221312,1,4.7,3312312);
INSERT INTO nota_eva_estudiante VALUES (83,221312,1,6.3,3312313);
INSERT INTO nota_eva_estudiante VALUES (84,221312,1,3.8,3312314);
INSERT INTO nota_eva_estudiante VALUES (85,221312,1,4.6,3312315);
INSERT INTO nota_eva_estudiante VALUES (86,221312,1,5.3,3312316);
INSERT INTO nota_eva_estudiante VALUES (87,221312,1,3.2,3312317);
INSERT INTO nota_eva_estudiante VALUES (88,221312,1,5.9,3312318);
INSERT INTO nota_eva_estudiante VALUES (89,221312,1,3.3,3312319);
INSERT INTO nota_eva_estudiante VALUES (90,221312,1,5.6,3312320);
INSERT INTO nota_eva_estudiante VALUES (91,221318,1,4.2,3312311);
INSERT INTO nota_eva_estudiante VALUES (92,221318,1,5.6,3312312);
INSERT INTO nota_eva_estudiante VALUES (93,221318,1,6.2,3312313);
INSERT INTO nota_eva_estudiante VALUES (94,221318,1,6.3,3312314);
INSERT INTO nota_eva_estudiante VALUES (95,221318,1,3.9,3312315);
INSERT INTO nota_eva_estudiante VALUES (96,221318,1,4.4,3312316);
INSERT INTO nota_eva_estudiante VALUES (97,221318,1,3.8,3312317);
INSERT INTO nota_eva_estudiante VALUES (98,221318,1,4.5,3312318);
INSERT INTO nota_eva_estudiante VALUES (99,221318,1,4.4,3312319);
INSERT INTO nota_eva_estudiante VALUES (100,221318,1,3.3,3312320);
INSERT INTO nota_eva_estudiante VALUES (101,221305,1,6.6,3312321);
INSERT INTO nota_eva_estudiante VALUES (102,221305,1,4.8,3312322);
INSERT INTO nota_eva_estudiante VALUES (103,221305,1,6.9,3312323);
INSERT INTO nota_eva_estudiante VALUES (104,221305,1,5.4,3312324);
INSERT INTO nota_eva_estudiante VALUES (105,221305,1,4.9,3312325);
INSERT INTO nota_eva_estudiante VALUES (106,221305,1,6.7,3312326);
INSERT INTO nota_eva_estudiante VALUES (107,221305,1,3.8,3312327);
INSERT INTO nota_eva_estudiante VALUES (108,221305,1,3.8,3312328);
INSERT INTO nota_eva_estudiante VALUES (109,221305,1,4.5,3312329);
INSERT INTO nota_eva_estudiante VALUES (110,221305,1,3.1,3312330);
INSERT INTO nota_eva_estudiante VALUES (111,221306,1,3.9,3312321);
INSERT INTO nota_eva_estudiante VALUES (112,221306,1,5.1,3312322);
INSERT INTO nota_eva_estudiante VALUES (113,221306,1,3.6,3312323);
INSERT INTO nota_eva_estudiante VALUES (114,221306,1,6.7,3312324);
INSERT INTO nota_eva_estudiante VALUES (115,221306,1,3.5,3312325);
INSERT INTO nota_eva_estudiante VALUES (116,221306,1,5.2,3312326);
INSERT INTO nota_eva_estudiante VALUES (117,221306,1,4.4,3312327);
INSERT INTO nota_eva_estudiante VALUES (118,221306,1,3.3,3312328);
INSERT INTO nota_eva_estudiante VALUES (119,221306,1,6.1,3312329);
INSERT INTO nota_eva_estudiante VALUES (120,221306,1,3.1,3312330);
INSERT INTO nota_eva_estudiante VALUES (121,221314,1,3.8,3312321);
INSERT INTO nota_eva_estudiante VALUES (122,221314,1,5.6,3312322);
INSERT INTO nota_eva_estudiante VALUES (123,221314,1,6.1,3312323);
INSERT INTO nota_eva_estudiante VALUES (124,221314,1,4.1,3312324);
INSERT INTO nota_eva_estudiante VALUES (125,221314,1,5.1,3312325);
INSERT INTO nota_eva_estudiante VALUES (126,221314,1,3.1,3312326);
INSERT INTO nota_eva_estudiante VALUES (127,221314,1,4.4,3312327);
INSERT INTO nota_eva_estudiante VALUES (128,221314,1,6.9,3312328);
INSERT INTO nota_eva_estudiante VALUES (129,221314,1,5.5,3312329);
INSERT INTO nota_eva_estudiante VALUES (130,221314,1,5.6,3312330);
INSERT INTO nota_eva_estudiante VALUES (131,221309,1,5.5,3312331);
INSERT INTO nota_eva_estudiante VALUES (132,221309,1,3.7,3312332);
INSERT INTO nota_eva_estudiante VALUES (133,221309,1,6.5,3312333);
INSERT INTO nota_eva_estudiante VALUES (134,221309,1,4.2,3312334);
INSERT INTO nota_eva_estudiante VALUES (135,221309,1,6.8,3312335);
INSERT INTO nota_eva_estudiante VALUES (136,221309,1,4.8,3312336);
INSERT INTO nota_eva_estudiante VALUES (137,221309,1,6.6,3312337);
INSERT INTO nota_eva_estudiante VALUES (138,221309,1,5.1,3312338);
INSERT INTO nota_eva_estudiante VALUES (139,221309,1,5.6,3312339);
INSERT INTO nota_eva_estudiante VALUES (140,221309,1,3.2,3312340);
INSERT INTO nota_eva_estudiante VALUES (141,221310,1,3.1,3312331);
INSERT INTO nota_eva_estudiante VALUES (142,221310,1,4.3,3312332);
INSERT INTO nota_eva_estudiante VALUES (143,221310,1,6.4,3312333);
INSERT INTO nota_eva_estudiante VALUES (144,221310,1,6.4,3312334);
INSERT INTO nota_eva_estudiante VALUES (145,221310,1,6.1,3312335);
INSERT INTO nota_eva_estudiante VALUES (146,221310,1,5.7,3312336);
INSERT INTO nota_eva_estudiante VALUES (147,221310,1,5.3,3312337);
INSERT INTO nota_eva_estudiante VALUES (148,221310,1,3.9,3312338);
INSERT INTO nota_eva_estudiante VALUES (149,221310,1,3.6,3312339);
INSERT INTO nota_eva_estudiante VALUES (150,221310,1,4.2,3312340);
INSERT INTO nota_eva_estudiante VALUES (151,221317,1,4.8,3312331);
INSERT INTO nota_eva_estudiante VALUES (152,221317,1,3.7,3312332);
INSERT INTO nota_eva_estudiante VALUES (153,221317,1,5.6,3312333);
INSERT INTO nota_eva_estudiante VALUES (154,221317,1,3.8,3312334);
INSERT INTO nota_eva_estudiante VALUES (155,221317,1,3.2,3312335);
INSERT INTO nota_eva_estudiante VALUES (156,221317,1,3.7,3312336);
INSERT INTO nota_eva_estudiante VALUES (157,221317,1,5.7,3312337);
INSERT INTO nota_eva_estudiante VALUES (158,221317,1,5.1,3312338);
INSERT INTO nota_eva_estudiante VALUES (159,221317,1,4.9,3312339);
INSERT INTO nota_eva_estudiante VALUES (160,221317,1,4.6,3312340);
INSERT INTO nota_eva_estudiante VALUES (161,221313,1,6.9,3312341);
INSERT INTO nota_eva_estudiante VALUES (162,221313,1,5.9,3312342);
INSERT INTO nota_eva_estudiante VALUES (163,221313,1,3.4,3312343);
INSERT INTO nota_eva_estudiante VALUES (164,221313,1,5.6,3312344);
INSERT INTO nota_eva_estudiante VALUES (165,221313,1,4.1,3312345);
INSERT INTO nota_eva_estudiante VALUES (166,221313,1,5.9,3312346);
INSERT INTO nota_eva_estudiante VALUES (167,221313,1,4.4,3312347);
INSERT INTO nota_eva_estudiante VALUES (168,221313,1,4.5,3312348);
INSERT INTO nota_eva_estudiante VALUES (169,221313,1,6.5,3312349);
INSERT INTO nota_eva_estudiante VALUES (170,221313,1,4.9,3312350);
INSERT INTO nota_eva_estudiante VALUES (171,221316,1,5.4,3312341);
INSERT INTO nota_eva_estudiante VALUES (172,221316,1,6.6,3312342);
INSERT INTO nota_eva_estudiante VALUES (173,221316,1,6.2,3312343);
INSERT INTO nota_eva_estudiante VALUES (174,221316,1,4.5,3312344);
INSERT INTO nota_eva_estudiante VALUES (175,221316,1,5.3,3312345);
INSERT INTO nota_eva_estudiante VALUES (176,221316,1,5.6,3312346);
INSERT INTO nota_eva_estudiante VALUES (177,221316,1,6.9,3312347);
INSERT INTO nota_eva_estudiante VALUES (178,221316,1,6.1,3312348);
INSERT INTO nota_eva_estudiante VALUES (179,221316,1,4.9,3312349);
INSERT INTO nota_eva_estudiante VALUES (180,221316,1,4.7,3312350);
INSERT INTO nota_eva_estudiante VALUES (181,221301,2,4.4,3312301);
INSERT INTO nota_eva_estudiante VALUES (182,221301,2,3.9,3312302);
INSERT INTO nota_eva_estudiante VALUES (183,221301,2,4.7,3312303);
INSERT INTO nota_eva_estudiante VALUES (184,221301,2,4.5,3312304);
INSERT INTO nota_eva_estudiante VALUES (185,221301,2,4.1,3312305);
INSERT INTO nota_eva_estudiante VALUES (186,221301,2,3.1,3312306);
INSERT INTO nota_eva_estudiante VALUES (187,221301,2,3.3,3312307);
INSERT INTO nota_eva_estudiante VALUES (188,221301,2,5.4,3312308);
INSERT INTO nota_eva_estudiante VALUES (189,221301,2,5.9,3312309);
INSERT INTO nota_eva_estudiante VALUES (190,221301,2,4.8,3312310);
INSERT INTO nota_eva_estudiante VALUES (191,221302,2,4.9,3312301);
INSERT INTO nota_eva_estudiante VALUES (192,221302,2,4.5,3312302);
INSERT INTO nota_eva_estudiante VALUES (193,221302,2,6.8,3312303);
INSERT INTO nota_eva_estudiante VALUES (194,221302,2,3.8,3312304);
INSERT INTO nota_eva_estudiante VALUES (195,221302,2,4.1,3312305);
INSERT INTO nota_eva_estudiante VALUES (196,221302,2,5.2,3312306);
INSERT INTO nota_eva_estudiante VALUES (197,221302,2,6.7,3312307);
INSERT INTO nota_eva_estudiante VALUES (198,221302,2,3.4,3312308);
INSERT INTO nota_eva_estudiante VALUES (199,221302,2,3.5,3312309);
INSERT INTO nota_eva_estudiante VALUES (200,221302,2,3.5,3312310);
INSERT INTO nota_eva_estudiante VALUES (201,221307,2,3.2,3312301);
INSERT INTO nota_eva_estudiante VALUES (202,221307,2,3.1,3312302);
INSERT INTO nota_eva_estudiante VALUES (203,221307,2,3.2,3312303);
INSERT INTO nota_eva_estudiante VALUES (204,221307,2,4.1,3312304);
INSERT INTO nota_eva_estudiante VALUES (205,221307,2,6.7,3312305);
INSERT INTO nota_eva_estudiante VALUES (206,221307,2,4.5,3312306);
INSERT INTO nota_eva_estudiante VALUES (207,221307,2,4.6,3312307);
INSERT INTO nota_eva_estudiante VALUES (208,221307,2,5.1,3312308);
INSERT INTO nota_eva_estudiante VALUES (209,221307,2,5.1,3312309);
INSERT INTO nota_eva_estudiante VALUES (210,221307,2,6.7,3312310);
INSERT INTO nota_eva_estudiante VALUES (211,221308,2,3.6,3312301);
INSERT INTO nota_eva_estudiante VALUES (212,221308,2,6.8,3312302);
INSERT INTO nota_eva_estudiante VALUES (213,221308,2,4.1,3312303);
INSERT INTO nota_eva_estudiante VALUES (214,221308,2,5.9,3312304);
INSERT INTO nota_eva_estudiante VALUES (215,221308,2,5.2,3312305);
INSERT INTO nota_eva_estudiante VALUES (216,221308,2,3.8,3312306);
INSERT INTO nota_eva_estudiante VALUES (217,221308,2,5.4,3312307);
INSERT INTO nota_eva_estudiante VALUES (218,221308,2,3.1,3312308);
INSERT INTO nota_eva_estudiante VALUES (219,221308,2,4.3,3312309);
INSERT INTO nota_eva_estudiante VALUES (220,221308,2,5.8,3312310);
INSERT INTO nota_eva_estudiante VALUES (221,221315,2,5.8,3312301);
INSERT INTO nota_eva_estudiante VALUES (222,221315,2,3.7,3312302);
INSERT INTO nota_eva_estudiante VALUES (223,221315,2,4.6,3312303);
INSERT INTO nota_eva_estudiante VALUES (224,221315,2,4.9,3312304);
INSERT INTO nota_eva_estudiante VALUES (225,221315,2,3.7,3312305);
INSERT INTO nota_eva_estudiante VALUES (226,221315,2,3.3,3312306);
INSERT INTO nota_eva_estudiante VALUES (227,221315,2,6.2,3312307);
INSERT INTO nota_eva_estudiante VALUES (228,221315,2,4.8,3312308);
INSERT INTO nota_eva_estudiante VALUES (229,221315,2,6.6,3312309);
INSERT INTO nota_eva_estudiante VALUES (230,221315,2,4.5,3312310);
INSERT INTO nota_eva_estudiante VALUES (231,221303,2,5.2,3312311);
INSERT INTO nota_eva_estudiante VALUES (232,221303,2,4.7,3312312);
INSERT INTO nota_eva_estudiante VALUES (233,221303,2,5.5,3312313);
INSERT INTO nota_eva_estudiante VALUES (234,221303,2,6.1,3312314);
INSERT INTO nota_eva_estudiante VALUES (235,221303,2,6.9,3312315);
INSERT INTO nota_eva_estudiante VALUES (236,221303,2,5.8,3312316);
INSERT INTO nota_eva_estudiante VALUES (237,221303,2,3.4,3312317);
INSERT INTO nota_eva_estudiante VALUES (238,221303,2,4.7,3312318);
INSERT INTO nota_eva_estudiante VALUES (239,221303,2,3.8,3312319);
INSERT INTO nota_eva_estudiante VALUES (240,221303,2,5.9,3312320);
INSERT INTO nota_eva_estudiante VALUES (241,221304,2,6.2,3312311);
INSERT INTO nota_eva_estudiante VALUES (242,221304,2,3.7,3312312);
INSERT INTO nota_eva_estudiante VALUES (243,221304,2,5.1,3312313);
INSERT INTO nota_eva_estudiante VALUES (244,221304,2,6.6,3312314);
INSERT INTO nota_eva_estudiante VALUES (245,221304,2,3.9,3312315);
INSERT INTO nota_eva_estudiante VALUES (246,221304,2,6.3,3312316);
INSERT INTO nota_eva_estudiante VALUES (247,221304,2,6.7,3312317);
INSERT INTO nota_eva_estudiante VALUES (248,221304,2,4.9,3312318);
INSERT INTO nota_eva_estudiante VALUES (249,221304,2,5.9,3312319);
INSERT INTO nota_eva_estudiante VALUES (250,221304,2,5.5,3312320);
INSERT INTO nota_eva_estudiante VALUES (251,221311,2,6.9,3312311);
INSERT INTO nota_eva_estudiante VALUES (252,221311,2,5.5,3312312);
INSERT INTO nota_eva_estudiante VALUES (253,221311,2,3.5,3312313);
INSERT INTO nota_eva_estudiante VALUES (254,221311,2,4.3,3312314);
INSERT INTO nota_eva_estudiante VALUES (255,221311,2,5.1,3312315);
INSERT INTO nota_eva_estudiante VALUES (256,221311,2,3.6,3312316);
INSERT INTO nota_eva_estudiante VALUES (257,221311,2,6.6,3312317);
INSERT INTO nota_eva_estudiante VALUES (258,221311,2,5.2,3312318);
INSERT INTO nota_eva_estudiante VALUES (259,221311,2,6.5,3312319);
INSERT INTO nota_eva_estudiante VALUES (260,221311,2,6.8,3312320);
INSERT INTO nota_eva_estudiante VALUES (261,221312,2,5.5,3312311);
INSERT INTO nota_eva_estudiante VALUES (262,221312,2,4.9,3312312);
INSERT INTO nota_eva_estudiante VALUES (263,221312,2,6.5,3312313);
INSERT INTO nota_eva_estudiante VALUES (264,221312,2,5.9,3312314);
INSERT INTO nota_eva_estudiante VALUES (265,221312,2,6.2,3312315);
INSERT INTO nota_eva_estudiante VALUES (266,221312,2,4.1,3312316);
INSERT INTO nota_eva_estudiante VALUES (267,221312,2,5.1,3312317);
INSERT INTO nota_eva_estudiante VALUES (268,221312,2,3.9,3312318);
INSERT INTO nota_eva_estudiante VALUES (269,221312,2,4.8,3312319);
INSERT INTO nota_eva_estudiante VALUES (270,221312,2,3.1,3312320);
INSERT INTO nota_eva_estudiante VALUES (271,221318,2,5.9,3312311);
INSERT INTO nota_eva_estudiante VALUES (272,221318,2,3.7,3312312);
INSERT INTO nota_eva_estudiante VALUES (273,221318,2,6.9,3312313);
INSERT INTO nota_eva_estudiante VALUES (274,221318,2,5.7,3312314);
INSERT INTO nota_eva_estudiante VALUES (275,221318,2,5.6,3312315);
INSERT INTO nota_eva_estudiante VALUES (276,221318,2,5.2,3312316);
INSERT INTO nota_eva_estudiante VALUES (277,221318,2,4.8,3312317);
INSERT INTO nota_eva_estudiante VALUES (278,221318,2,3.6,3312318);
INSERT INTO nota_eva_estudiante VALUES (279,221318,2,4.9,3312319);
INSERT INTO nota_eva_estudiante VALUES (280,221318,2,5.7,3312320);
INSERT INTO nota_eva_estudiante VALUES (281,221305,2,5.3,3312321);
INSERT INTO nota_eva_estudiante VALUES (282,221305,2,4.9,3312322);
INSERT INTO nota_eva_estudiante VALUES (283,221305,2,3.5,3312323);
INSERT INTO nota_eva_estudiante VALUES (284,221305,2,5.4,3312324);
INSERT INTO nota_eva_estudiante VALUES (285,221305,2,4.7,3312325);
INSERT INTO nota_eva_estudiante VALUES (286,221305,2,6.5,3312326);
INSERT INTO nota_eva_estudiante VALUES (287,221305,2,4.8,3312327);
INSERT INTO nota_eva_estudiante VALUES (288,221305,2,3.4,3312328);
INSERT INTO nota_eva_estudiante VALUES (289,221305,2,5.3,3312329);
INSERT INTO nota_eva_estudiante VALUES (290,221305,2,6.3,3312330);
INSERT INTO nota_eva_estudiante VALUES (291,221306,2,4.7,3312321);
INSERT INTO nota_eva_estudiante VALUES (292,221306,2,5.2,3312322);
INSERT INTO nota_eva_estudiante VALUES (293,221306,2,4.9,3312323);
INSERT INTO nota_eva_estudiante VALUES (294,221306,2,4.4,3312324);
INSERT INTO nota_eva_estudiante VALUES (295,221306,2,3.5,3312325);
INSERT INTO nota_eva_estudiante VALUES (296,221306,2,5.4,3312326);
INSERT INTO nota_eva_estudiante VALUES (297,221306,2,5.3,3312327);
INSERT INTO nota_eva_estudiante VALUES (298,221306,2,5.9,3312328);
INSERT INTO nota_eva_estudiante VALUES (299,221306,2,4.5,3312329);
INSERT INTO nota_eva_estudiante VALUES (300,221306,2,3.4,3312330);
INSERT INTO nota_eva_estudiante VALUES (301,221314,2,4.6,3312321);
INSERT INTO nota_eva_estudiante VALUES (302,221314,2,5.9,3312322);
INSERT INTO nota_eva_estudiante VALUES (303,221314,2,4.4,3312323);
INSERT INTO nota_eva_estudiante VALUES (304,221314,2,6.6,3312324);
INSERT INTO nota_eva_estudiante VALUES (305,221314,2,5.5,3312325);
INSERT INTO nota_eva_estudiante VALUES (306,221314,2,6.2,3312326);
INSERT INTO nota_eva_estudiante VALUES (307,221314,2,6.7,3312327);
INSERT INTO nota_eva_estudiante VALUES (308,221314,2,5.9,3312328);
INSERT INTO nota_eva_estudiante VALUES (309,221314,2,3.5,3312329);
INSERT INTO nota_eva_estudiante VALUES (310,221314,2,3.9,3312330);
INSERT INTO nota_eva_estudiante VALUES (311,221309,2,6.8,3312331);
INSERT INTO nota_eva_estudiante VALUES (312,221309,2,5.5,3312332);
INSERT INTO nota_eva_estudiante VALUES (313,221309,2,6.9,3312333);
INSERT INTO nota_eva_estudiante VALUES (314,221309,2,4.8,3312334);
INSERT INTO nota_eva_estudiante VALUES (315,221309,2,5.8,3312335);
INSERT INTO nota_eva_estudiante VALUES (316,221309,2,3.5,3312336);
INSERT INTO nota_eva_estudiante VALUES (317,221309,2,3.7,3312337);
INSERT INTO nota_eva_estudiante VALUES (318,221309,2,5.7,3312338);
INSERT INTO nota_eva_estudiante VALUES (319,221309,2,6.4,3312339);
INSERT INTO nota_eva_estudiante VALUES (320,221309,2,5.1,3312340);
INSERT INTO nota_eva_estudiante VALUES (321,221310,2,4.6,3312331);
INSERT INTO nota_eva_estudiante VALUES (322,221310,2,4.9,3312332);
INSERT INTO nota_eva_estudiante VALUES (323,221310,2,4.1,3312333);
INSERT INTO nota_eva_estudiante VALUES (324,221310,2,6.6,3312334);
INSERT INTO nota_eva_estudiante VALUES (325,221310,2,6.6,3312335);
INSERT INTO nota_eva_estudiante VALUES (326,221310,2,5.5,3312336);
INSERT INTO nota_eva_estudiante VALUES (327,221310,2,5.4,3312337);
INSERT INTO nota_eva_estudiante VALUES (328,221310,2,5.9,3312338);
INSERT INTO nota_eva_estudiante VALUES (329,221310,2,6.2,3312339);
INSERT INTO nota_eva_estudiante VALUES (330,221310,2,5.1,3312340);
INSERT INTO nota_eva_estudiante VALUES (331,221317,2,5.1,3312331);
INSERT INTO nota_eva_estudiante VALUES (332,221317,2,5.9,3312332);
INSERT INTO nota_eva_estudiante VALUES (333,221317,2,5.9,3312333);
INSERT INTO nota_eva_estudiante VALUES (334,221317,2,6.5,3312334);
INSERT INTO nota_eva_estudiante VALUES (335,221317,2,6.2,3312335);
INSERT INTO nota_eva_estudiante VALUES (336,221317,2,6.3,3312336);
INSERT INTO nota_eva_estudiante VALUES (337,221317,2,5.1,3312337);
INSERT INTO nota_eva_estudiante VALUES (338,221317,2,4.8,3312338);
INSERT INTO nota_eva_estudiante VALUES (339,221317,2,3.3,3312339);
INSERT INTO nota_eva_estudiante VALUES (340,221317,2,3.6,3312340);
INSERT INTO nota_eva_estudiante VALUES (341,221313,2,3.9,3312341);
INSERT INTO nota_eva_estudiante VALUES (342,221313,2,6.3,3312342);
INSERT INTO nota_eva_estudiante VALUES (343,221313,2,6.6,3312343);
INSERT INTO nota_eva_estudiante VALUES (344,221313,2,4.4,3312344);
INSERT INTO nota_eva_estudiante VALUES (345,221313,2,5.4,3312345);
INSERT INTO nota_eva_estudiante VALUES (346,221313,2,6.6,3312346);
INSERT INTO nota_eva_estudiante VALUES (347,221313,2,4.5,3312347);
INSERT INTO nota_eva_estudiante VALUES (348,221313,2,4.2,3312348);
INSERT INTO nota_eva_estudiante VALUES (349,221313,2,3.6,3312349);
INSERT INTO nota_eva_estudiante VALUES (350,221313,2,5.7,3312350);
INSERT INTO nota_eva_estudiante VALUES (351,221316,2,3.4,3312341);
INSERT INTO nota_eva_estudiante VALUES (352,221316,2,3.2,3312342);
INSERT INTO nota_eva_estudiante VALUES (353,221316,2,5.5,3312343);
INSERT INTO nota_eva_estudiante VALUES (354,221316,2,4.7,3312344);
INSERT INTO nota_eva_estudiante VALUES (355,221316,2,4.2,3312345);
INSERT INTO nota_eva_estudiante VALUES (356,221316,2,6.2,3312346);
INSERT INTO nota_eva_estudiante VALUES (357,221316,2,3.8,3312347);
INSERT INTO nota_eva_estudiante VALUES (358,221316,2,3.9,3312348);
INSERT INTO nota_eva_estudiante VALUES (359,221316,2,5.3,3312349);
INSERT INTO nota_eva_estudiante VALUES (360,221316,2,5.7,3312350);






INSERT INTO encuesta_docente VALUES (21,TO_DATE('10/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Magister','1','I','0',4,'0','Nazario Gabriel Toloza Navarrete','995287698',60501);
INSERT INTO encuesta_docente VALUES (22,TO_DATE('05/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Magister','0','D','1',0,'1','Alexander Kevin Morán Gajardo','825273328',60502);
INSERT INTO encuesta_docente VALUES (23,TO_DATE('24/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Técnico','1','D','0',1,'1','Sylvia NULL Sánchez Orellana','968153576',60503);
INSERT INTO encuesta_docente VALUES (24,TO_DATE('15/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Técnico','1','D','1',0,'1','Consuelo Marcelina Zavala Dominguez','878874188',60504);
INSERT INTO encuesta_docente VALUES (25,TO_DATE('17/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Técnico','1','D','0',1,'1','Nilda Silvia Mondeja Pinto','872858370',60505);
INSERT INTO encuesta_docente VALUES (26,TO_DATE('20/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Técnico','0','I','1',1,'1','Raimundo Nicolás Herrera Vargas','786251788',60506);
INSERT INTO encuesta_docente VALUES (27,TO_DATE('20/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Profesional','0','I','0',2,'1','Teodoro Derek Cárcamo Becar','885286676',60507);
INSERT INTO encuesta_docente VALUES (28,TO_DATE('28/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Doctorado','1','I','1',0,'0','Carlota Katherine Liempi Ware', NULL,60508);
INSERT INTO encuesta_docente VALUES (29,TO_DATE('01/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Técnico','0','D','0',2,'0','Evaristo Josué Hormazabal Boyle','827779827',60509);
INSERT INTO encuesta_docente VALUES (30,TO_DATE('29/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Doctorado','1','I','0',1,'1','Catalina Edith Camiruaga Liempi','896781307',60510);
INSERT INTO encuesta_docente VALUES (31,TO_DATE('12/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Magister','1','I','0',2,'1','Denis Luis Cubillos Cavanela','882735710',60511);
INSERT INTO encuesta_docente VALUES (32,TO_DATE('13/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Profesional','0','D','1',0,'1','Adelina Kirsten Aguirre Parsons','788582729',60512);
INSERT INTO encuesta_docente VALUES (33,TO_DATE('07/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Magister','0','I','0',0,'1','Orlando Hernán Zúñiga Amengual','982778360',60513);
INSERT INTO encuesta_docente VALUES (34,TO_DATE('17/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Técnico','1','I','1',2,'0','Belén Lorena Sweeney Shepard','957719055',60514);
INSERT INTO encuesta_docente VALUES (35,TO_DATE('20/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Doctorado','0','D','0',2,'1','Yanira Nicolas Saldivar Martin','867783253',60515);
INSERT INTO encuesta_docente VALUES (36,TO_DATE('30/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Técnico','1','D','1',1,'1','Karla Pamela Retamal Carney','995293285',60516);
INSERT INTO encuesta_docente VALUES (37,TO_DATE('20/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Doctorado','0','I','0',2,'0','Cenobia Desirée Hardin Pedraza','892836901',60517);
INSERT INTO encuesta_docente VALUES (38,TO_DATE('19/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Doctorado','1','I','1',1,'0','Carlota Sandra Aguilar Bahamondez','987414835',60518);
INSERT INTO encuesta_docente VALUES (39,TO_DATE('08/03/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Doctorado','1','I','0',2,'1','Alfredo Arturo Blanco Navarrete','772425678',60519);
INSERT INTO encuesta_docente VALUES (40,TO_DATE('30/04/'||(EXTRACT(YEAR FROM SYSDATE)-1),'DD/MM/YYYY'),'Doctorado','0','I','0',2,'0','Marlene Gabrielle Bates Meyer','978264469',60520);
INSERT INTO encuesta_docente VALUES (41,TO_DATE('18/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Doctorado','1','I','0',2,'0','Stephanie Elba Rodríguez Candia','925631567',60521);
INSERT INTO encuesta_docente VALUES (42,TO_DATE('21/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Técnico','1','D','1',0,'0','Eloy Guillermo Trinke Peéez','726483081',60522);
INSERT INTO encuesta_docente VALUES (43,TO_DATE('07/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Magister','0','D','0',1,'0','Jenoveva Yolanda Ríos Aguirre','722012371',60523);
INSERT INTO encuesta_docente VALUES (44,TO_DATE('20/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Profesional','0','D','1',0,'1','Salomón Willibaldo Huang Frost','975232677',60524);
INSERT INTO encuesta_docente VALUES (45,TO_DATE('09/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Técnico','0','I','1',0,'1','Alfonso Cristian Meza Adasme','795778724',60525);
INSERT INTO encuesta_docente VALUES (46,TO_DATE('05/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Técnico','0','I','1',0,'0','Denis Ronny Peralta Erices','989284615',60526);
INSERT INTO encuesta_docente VALUES (47,TO_DATE('26/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Profesional','1','D','0',0,'0','Margarita Jeannette Gordon Mondeja','927344236',60527);
INSERT INTO encuesta_docente VALUES (48,TO_DATE('23/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Técnico','0','D','1',0,'0','Elisa Teri Carrasco Maldonado','955212406',60528);
INSERT INTO encuesta_docente VALUES (49,TO_DATE('26/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Profesional','0','D','1',0,'1','Genoveva Elba Echeverría Ortega','976277658',60529);
INSERT INTO encuesta_docente VALUES (50,TO_DATE('02/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Profesional','1','I','1',1,'0','Marcelo Damián Arévalo Bravo','895287698',60530);
INSERT INTO encuesta_docente VALUES (51,TO_DATE('11/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Técnico','0','D','1',1,'0','Homero Maximiliano Robles Trevino','972279717',60531);
INSERT INTO encuesta_docente VALUES (52,TO_DATE('15/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Magister','0','I','1',0,'1','Mónica Nilda Stafford Olivares','895521212',60532);
INSERT INTO encuesta_docente VALUES (53,TO_DATE('08/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Doctorado','0','D','1',1,'0','Maria Yaneth Manzano Urbina','877446858',60533);
INSERT INTO encuesta_docente VALUES (54,TO_DATE('18/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Profesional','0','D','0',2,'1','Nazario Claudio Pino Quezada','827494190',60534);
INSERT INTO encuesta_docente VALUES (55,TO_DATE('08/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Magister','0','D','1',0,'0','Pedro Yago Gallegos Peña','827779827',60535);
INSERT INTO encuesta_docente VALUES (56,TO_DATE('17/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Magister','0','I','0',1,'1','Quiliano Pepe Tucker Peña','725292497',60536);
INSERT INTO encuesta_docente VALUES (57,TO_DATE('28/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Doctorado','0','D','0',2,'0','Thelma Marisol Hisi Guajardo','985279487',60537);
INSERT INTO encuesta_docente VALUES (58,TO_DATE('04/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Profesional','0','I','0',1,'1','Norberto Yago Figueroa Olave','772537773',60538);
INSERT INTO encuesta_docente VALUES (59,TO_DATE('02/04/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Doctorado','1','D','1',1,'1','Galo Leopoldo Acuna Monares','712203452',60539);
INSERT INTO encuesta_docente VALUES (60,TO_DATE('19/03/'||(EXTRACT(YEAR FROM SYSDATE)-2),'DD/MM/YYYY'),'Magister','1','I','0',2,'0','Denis NULL Abelli Márquez','876238494',60540);
INSERT INTO encuesta_docente VALUES (61,TO_DATE('26/04/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),'Profesional','0','D','1',0,'0','Jovita Gilda Henríquez Dissi','792853737',60541);
INSERT INTO encuesta_docente VALUES (62,TO_DATE('06/04/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),'Profesional','0','D','1',1,'0','Olga Yvonne Mandiola Lillo','886815357',60542);
INSERT INTO encuesta_docente VALUES (63,TO_DATE('15/04/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),'Técnico','1','D','0',0,'0','Raquel Jeannette Figueroa Olivares','727417338',60543);
INSERT INTO encuesta_docente VALUES (64,TO_DATE('16/03/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),'Doctorado','1','D','0',2,'0','Guadalupe Wanda Mella Mccoy','929544102',60544);
INSERT INTO encuesta_docente VALUES (65,TO_DATE('20/04/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),'Técnico','0','D','1',1,'1','Telésforo Jesús Parra Gamble','873243232',60545);
INSERT INTO encuesta_docente VALUES (66,TO_DATE('22/04/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),'Técnico','0','D','1',1,'0','Julián Eliseo Sepúlveda Estrada','976256263',60546);
INSERT INTO encuesta_docente VALUES (67,TO_DATE('01/03/'||(EXTRACT(YEAR FROM SYSDATE)-0),'DD/MM/YYYY'),'Profesional','0','I','0',1,'1','Gabrielle Jocelyn Bowers Soto','872888897',60547);




commit;