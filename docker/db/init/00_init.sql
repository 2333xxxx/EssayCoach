-- ** Database schema for EssayCoach
-- ** Generated with pgModeler (PostgreSQL Database Modeler).
-- ** pgModeler version: 1.2.0
-- ** PostgreSQL version: 17.0
-- ** Project Site: pgmodeler.io
-- ** Model Author: ---

-- ========================================
-- DROP ALL EXISTING OBJECTS (TABLES, FUNCTIONS, TRIGGERS)
-- ========================================
-- This section drops all tables, functions, and triggers if they exist,
-- to ensure a clean slate for schema creation. It uses CASCADE to handle dependencies.

DROP TABLE IF EXISTS public.feedback_item CASCADE;
DROP TABLE IF EXISTS public.feedback CASCADE;
DROP TABLE IF EXISTS public.submission CASCADE;
DROP TABLE IF EXISTS public.rubric_level_desc CASCADE;
DROP TABLE IF EXISTS public.rubric_item CASCADE;
DROP TABLE IF EXISTS public.task CASCADE;
DROP TABLE IF EXISTS public.marking_rubric CASCADE;
DROP TABLE IF EXISTS public.teaching_assn CASCADE;
DROP TABLE IF EXISTS public.enrollment CASCADE;
DROP TABLE IF EXISTS public.class CASCADE;
DROP TABLE IF EXISTS public.unit CASCADE;
DROP TABLE IF EXISTS public."user" CASCADE;

-- ========================================
-- SCHEMA CREATION
-- ========================================

SET check_function_bodies = false;
-- ddl-end --

-- object: public."user" | type: TABLE --
CREATE TABLE public."user" (
	user_id integer NOT NULL,
	user_fname varchar(20),
	user_lname varchar(20),
	user_email varchar(50),
	user_role varchar(10),
	user_status varchar(10),
	user_credential varchar(255),
	CONSTRAINT user_pk PRIMARY KEY (user_id),
	CONSTRAINT user_email_uq UNIQUE (user_email),
	CONSTRAINT user_role_ck CHECK (user_role IN ('student', 'lecturer', 'admin')),
	CONSTRAINT user_status_ck CHECK (user_status IN ('active', 'suspended', 'unregistered'))
);
-- ddl-end --
COMMENT ON TABLE public."user" IS E'A table for all user entities, including student, teacher, and admins.';
-- ddl-end --
COMMENT ON COLUMN public."user".user_id IS E'Unique user identifiers. Student ids are obtainable from the teaching system, while lecturers and admins are assigned other unique ids.';
-- ddl-end --
COMMENT ON COLUMN public."user".user_fname IS E'User firstname';
-- ddl-end --
COMMENT ON COLUMN public."user".user_lname IS E'User lastname';
-- ddl-end --
COMMENT ON COLUMN public."user".user_email IS E'User email, required for resetting password. Unique constraint applied.';
-- ddl-end --
COMMENT ON COLUMN public."user".user_role IS E'User role: student, lecturer, and admin';
-- ddl-end --
COMMENT ON COLUMN public."user".user_status IS E'User status: active, suspended, or unregistered';
-- ddl-end --
COMMENT ON COLUMN public."user".user_credential IS E'Hashed credential for user';
-- ddl-end --
COMMENT ON CONSTRAINT user_email_uq ON public."user" IS E'User emails must be unique for resetting password for account';
-- ddl-end --
COMMENT ON CONSTRAINT user_role_ck ON public."user" IS E'User role are designated to be one of student, lecturer, and admin';
-- ddl-end --
COMMENT ON CONSTRAINT user_status_ck ON public."user" IS E'user status:\nactive: normal\nsuspended: registered by baned from login\nunregistered: added to DB but not create account yet';
-- ddl-end --

-- object: public.unit | type: TABLE --
CREATE TABLE public.unit (
	unit_id varchar(10) NOT NULL,
	unit_name varchar(30) NOT NULL,
	unit_desc varchar(50),
	CONSTRAINT unit_pk PRIMARY KEY (unit_id)
);
-- ddl-end --
COMMENT ON TABLE public.unit IS E'A table for unit entity';
-- ddl-end --
COMMENT ON COLUMN public.unit.unit_id IS E'Unique identifier for each unit, same as the unit code';
-- ddl-end --
COMMENT ON COLUMN public.unit.unit_name IS E'Full name of the unit';
-- ddl-end --
COMMENT ON COLUMN public.unit.unit_desc IS E'details of the unit';
-- ddl-end --

-- object: public.class | type: TABLE --
CREATE TABLE public.class (
	class_id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 32767 START WITH 1 CACHE 1 ),
	unit_id_unit varchar(10) NOT NULL,
	class_size smallint NOT NULL DEFAULT 0,
	CONSTRAINT class_pk PRIMARY KEY (class_id),
	CONSTRAINT class_size_ck CHECK (class_size >= 0)
);
-- ddl-end --
COMMENT ON TABLE public.class IS E'A table for class entity';
-- ddl-end --
COMMENT ON COLUMN public.class.class_id IS E'Unique identifier for a class under a unit';
-- ddl-end --
COMMENT ON COLUMN public.class.class_size IS E'current number of students in the class';
-- ddl-end --
COMMENT ON CONSTRAINT class_size_ck ON public.class IS E'Class size must be non-negative';
-- ddl-end --

-- object: public.enrollment | type: TABLE --
CREATE TABLE public.enrollment (
	enrollment_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
	user_id_user integer NOT NULL,
	class_id_class smallint NOT NULL,
	unit_id_unit varchar(10) NOT NULL,
	enrollment_time timestamp DEFAULT now(),
	CONSTRAINT enrollment_pk PRIMARY KEY (enrollment_id)
);
-- ddl-end --
COMMENT ON TABLE public.enrollment IS E'The enrollment of student to a specific class. A student can only have one enrollment to one class of one unit anytime.';
-- ddl-end --
COMMENT ON COLUMN public.enrollment.enrollment_id IS E'Unique identifier for each enrollment';
-- ddl-end --
COMMENT ON COLUMN public.enrollment.enrollment_time IS E'The time when the student is enrolled in the DBMS';
-- ddl-end --

-- object: public.teaching_assn | type: TABLE --
CREATE TABLE public.teaching_assn (
	teaching_assn_id smallint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 32767 START WITH 1 CACHE 1 ),
	user_id_user integer NOT NULL,
	class_id_class smallint NOT NULL,
	CONSTRAINT teaching_assn_pk PRIMARY KEY (teaching_assn_id)
);
-- ddl-end --
COMMENT ON TABLE public.teaching_assn IS E'A weak entity for assignment of teacher to classes';
-- ddl-end --
COMMENT ON COLUMN public.teaching_assn.teaching_assn_id IS E'unique identifier';
-- ddl-end --

-- object: public.marking_rubric | type: TABLE --
CREATE TABLE public.marking_rubric (
	rubric_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
	user_id_user integer NOT NULL,
	rubric_create_time timestamp DEFAULT now(),
	rubric_desc varchar(100),
	CONSTRAINT marking_rubric_pk PRIMARY KEY (rubric_id)
);
-- ddl-end --
COMMENT ON TABLE public.marking_rubric IS E'entity for a marking rubric. A marking rubric has many items.';
-- ddl-end --
COMMENT ON COLUMN public.marking_rubric.rubric_id IS E'unique identifier for rubrics';
-- ddl-end --
COMMENT ON COLUMN public.marking_rubric.rubric_create_time IS E'timestamp when the rubirc is created';
-- ddl-end --
COMMENT ON COLUMN public.marking_rubric.rubric_desc IS E'description to the rubrics';
-- ddl-end --

-- object: public.task | type: TABLE --
CREATE TABLE public.task (
	task_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
	unit_id_unit varchar(10) NOT NULL,
	rubric_id_marking_rubric integer NOT NULL,
	task_publish_datetime timestamp DEFAULT now(),
	task_due_datetime timestamp NOT NULL,
	CONSTRAINT task_pk PRIMARY KEY (task_id),
	CONSTRAINT task_publish_time_task_due_time_ck CHECK (task_publish_datetime < task_due_datetime)
);
-- ddl-end --
COMMENT ON TABLE public.task IS E'Task created by lecturer/admin for students in some classes/units to complete';
-- ddl-end --
COMMENT ON COLUMN public.task.task_id IS E'Unique identifier for task.';
-- ddl-end --
COMMENT ON COLUMN public.task.task_publish_datetime IS E'time/date when the task is published';
-- ddl-end --
COMMENT ON COLUMN public.task.task_due_datetime IS E'time/date when the task is due';
-- ddl-end --

-- object: public.rubric_item | type: TABLE --
CREATE TABLE public.rubric_item (
	rubric_item_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
	rubric_id_marking_rubric integer NOT NULL,
	rubric_item_name varchar(20) NOT NULL,
	rubric_item_weight numeric(3,1) NOT NULL,
	CONSTRAINT item_weight_ck CHECK (rubric_item_weight > 0),
	CONSTRAINT rubric_item_pk PRIMARY KEY (rubric_item_id)
);
-- ddl-end --
COMMENT ON TABLE public.rubric_item IS E'An item(dimension) under one rubric';
-- ddl-end --
COMMENT ON COLUMN public.rubric_item.rubric_item_id IS E'unique identifier for item';
-- ddl-end --
COMMENT ON COLUMN public.rubric_item.rubric_item_name IS E'Title(header) name for the item';
-- ddl-end --
COMMENT ON COLUMN public.rubric_item.rubric_item_weight IS E'the weight of the item on a scale of 100%, using xx.x';
-- ddl-end --
COMMENT ON CONSTRAINT item_weight_ck ON public.rubric_item IS E'weight must be greater than 0';
-- ddl-end --

-- object: public.rubric_level_desc | type: TABLE --
CREATE TABLE public.rubric_level_desc (
	level_desc_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
	rubric_item_id_rubric_item integer NOT NULL,
	level_min_score smallint NOT NULL,
	level_max_score smallint NOT NULL,
	level_desc varchar(500) NOT NULL,
	CONSTRAINT min_max_ck CHECK (level_min_score >= 0 AND level_max_score > 0 AND level_min_score < level_max_score),
	CONSTRAINT rubric_level_desc_pk PRIMARY KEY (level_desc_id)
);
-- ddl-end --
COMMENT ON TABLE public.rubric_level_desc IS E'The detailed description to each of the score range under a rubric item under a rubric.';
-- ddl-end --
COMMENT ON COLUMN public.rubric_level_desc.level_desc_id IS E'unique identifier for each level desc under one rubric';
-- ddl-end --
COMMENT ON COLUMN public.rubric_level_desc.level_min_score IS E'min for the item';
-- ddl-end --
COMMENT ON COLUMN public.rubric_level_desc.level_max_score IS E'max for the item';
-- ddl-end --

-- object: public.submission | type: TABLE --
CREATE TABLE public.submission (
	submission_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
	submission_time timestamp DEFAULT now(),
	task_id_task integer NOT NULL,
	user_id_user integer, NOT NULL,
	submission_txt text NOT NULL,
	CONSTRAINT submission_pk PRIMARY KEY (submission_id)
);
-- ddl-end --
COMMENT ON TABLE public.submission IS E'A weal entity for task submissions.';
-- ddl-end --
COMMENT ON COLUMN public.submission.submission_id IS E'unique identifier for submission';
-- ddl-end --
COMMENT ON COLUMN public.submission.submission_time IS E'time/date of submission';
-- ddl-end --
COMMENT ON COLUMN public.submission.submission_txt IS E'complete content of the essay submission';
-- ddl-end --

-- object: public.feedback | type: TABLE --
CREATE TABLE public.feedback (
	feedback_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
	submission_id_submission integer NOT NULL,
	user_id_user integer NOT NULL,
	CONSTRAINT feedback_pk PRIMARY KEY (feedback_id)
);
-- ddl-end --

-- object: public.feedback_item | type: TABLE --
CREATE TABLE public.feedback_item (
	feedback_item_id integer NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT BY 1 MINVALUE 0 MAXVALUE 2147483647 START WITH 1 CACHE 1 ),
	feedback_id_feedback integer NOT NULL,
	rubric_item_id_rubric_item integer NOT NULL,
	feedback_item_score smallint NOT NULL,
	feedback_item_comment text,
	feedback_item_source varchar(10) NOT NULL,
	CONSTRAINT feedback_item_pk PRIMARY KEY (feedback_item_id),
	CONSTRAINT feedback_item_source_ck CHECK (feedback_item_source IN ('ai', 'human', 'revised'))
);
-- ddl-end --
COMMENT ON TABLE public.feedback_item IS E'A section in the feedback as per the rubric';
-- ddl-end --
COMMENT ON COLUMN public.feedback_item.feedback_item_id IS E'unique identifier for feedback item';
-- ddl-end --
COMMENT ON COLUMN public.feedback_item.feedback_item_score IS E'actual score of the item';
-- ddl-end --
COMMENT ON COLUMN public.feedback_item.feedback_item_comment IS E'short description to the sub-item grade';
-- ddl-end --
COMMENT ON COLUMN public.feedback_item.feedback_item_source IS E'the source of feedback: \nai, human, or revised if ai feedback is slightly modifed by human';
-- ddl-end --

-- ========================================
-- FOREIGN KEY CONSTRAINTS
-- ========================================

-- object: user_enrollment_fk | type: CONSTRAINT --
ALTER TABLE public.enrollment ADD CONSTRAINT user_enrollment_fk FOREIGN KEY (user_id_user)
REFERENCES public."user" (user_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: class_enrollment_fk | type: CONSTRAINT --
ALTER TABLE public.enrollment ADD CONSTRAINT class_enrollment_fk FOREIGN KEY (class_id_class)
REFERENCES public.class (class_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: unit_enrollment_fk | type: CONSTRAINT --
ALTER TABLE public.enrollment ADD CONSTRAINT unit_enrollment_fk FOREIGN KEY (unit_id_unit)
REFERENCES public.unit (unit_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: unit_class_fk | type: CONSTRAINT --
ALTER TABLE public.class ADD CONSTRAINT unit_class_fk FOREIGN KEY (unit_id_unit)
REFERENCES public.unit (unit_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: user_teaching_assn_fk | type: CONSTRAINT --
ALTER TABLE public.teaching_assn ADD CONSTRAINT user_teaching_assn_fk FOREIGN KEY (user_id_user)
REFERENCES public."user" (user_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: class_teaching_assn_fk | type: CONSTRAINT --
ALTER TABLE public.teaching_assn ADD CONSTRAINT class_teaching_assn_fk FOREIGN KEY (class_id_class)
REFERENCES public.class (class_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: unit_task_fk | type: CONSTRAINT --
ALTER TABLE public.task ADD CONSTRAINT unit_task_fk FOREIGN KEY (unit_id_unit)
REFERENCES public.unit (unit_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: marking_rubric_task_fk | type: CONSTRAINT --
ALTER TABLE public.task ADD CONSTRAINT marking_rubric_task_fk FOREIGN KEY (rubric_id_marking_rubric)
REFERENCES public.marking_rubric (rubric_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: user_marking_rubric_fk | type: CONSTRAINT --
ALTER TABLE public.marking_rubric ADD CONSTRAINT user_marking_rubric_fk FOREIGN KEY (user_id_user)
REFERENCES public."user" (user_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: marking_rubric_rubric_item_fk | type: CONSTRAINT --
ALTER TABLE public.rubric_item ADD CONSTRAINT marking_rubric_rubric_item_fk FOREIGN KEY (rubric_id_marking_rubric)
REFERENCES public.marking_rubric (rubric_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: rubric_item_rubric_level_desc_fk | type: CONSTRAINT --
ALTER TABLE public.rubric_level_desc ADD CONSTRAINT rubric_item_rubric_level_desc_fk FOREIGN KEY (rubric_item_id_rubric_item)
REFERENCES public.rubric_item (rubric_item_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: task_submission_fk | type: CONSTRAINT --
ALTER TABLE public.submission ADD CONSTRAINT task_submission_fk FOREIGN KEY (task_id_task)
REFERENCES public.task (task_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: user_submission_fk | type: CONSTRAINT --
ALTER TABLE public.submission ADD CONSTRAINT user_submission_fk FOREIGN KEY (user_id_user)
REFERENCES public."user" (user_id) MATCH FULL
ON DELETE CASCADE ON UPDATE CASCADE;
-- ddl-end --

-- object: submission_fk | type: CONSTRAINT --
ALTER TABLE public.feedback ADD CONSTRAINT submission_fk FOREIGN KEY (submission_id_submission)
REFERENCES public.submission (submission_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: user_feedback_fk | type: CONSTRAINT --
ALTER TABLE public.feedback ADD CONSTRAINT user_feedback_fk FOREIGN KEY (user_id_user)
REFERENCES public."user" (user_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: feedback_feedback_item_fk | type: CONSTRAINT --
ALTER TABLE public.feedback_item ADD CONSTRAINT feedback_feedback_item_fk FOREIGN KEY (feedback_id_feedback)
REFERENCES public.feedback (feedback_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- object: rubric_item_feedback_item_fk | type: CONSTRAINT --
ALTER TABLE public.feedback_item ADD CONSTRAINT rubric_item_feedback_item_fk FOREIGN KEY (rubric_item_id_rubric_item)
REFERENCES public.rubric_item (rubric_item_id) MATCH FULL
ON DELETE RESTRICT ON UPDATE CASCADE;
-- ddl-end --

-- ========================================
-- UNIQUE CONSTRAINTS
-- ========================================

-- object: user_id_class_id_unit_id_uq | type: CONSTRAINT --
ALTER TABLE public.enrollment ADD CONSTRAINT user_id_class_id_unit_id_uq UNIQUE (user_id_user,class_id_class,unit_id_unit);
-- ddl-end --
COMMENT ON CONSTRAINT user_id_class_id_unit_id_uq ON public.enrollment IS E'Every student can only enrolled to a specific class of a unit once';
-- ddl-end --

-- object: lecturer_id_class_id_uq | type: CONSTRAINT --
ALTER TABLE public.teaching_assn ADD CONSTRAINT lecturer_id_class_id_uq UNIQUE (user_id_user,class_id_class);
-- ddl-end --
COMMENT ON CONSTRAINT lecturer_id_class_id_uq ON public.teaching_assn IS E'One lecturer can only be assigned to a class once';
-- ddl-end --

-- object: feedback_uq | type: CONSTRAINT --
ALTER TABLE public.feedback ADD CONSTRAINT feedback_uq UNIQUE (submission_id_submission);
-- ddl-end --

-- object: feedback_id_rubric_item_id_uq | type: CONSTRAINT --
ALTER TABLE public.feedback_item ADD CONSTRAINT feedback_id_rubric_item_id_uq UNIQUE (feedback_id_feedback,rubric_item_id_rubric_item);
-- ddl-end --

-- ========================================
-- FUNCTIONS AND TRIGGERS
-- ========================================

-- object: public.increase_class_size | type: FUNCTION --
CREATE OR REPLACE FUNCTION public.increase_class_size ()
	RETURNS trigger
	LANGUAGE plpgsql
	VOLATILE 
	CALLED ON NULL INPUT
	SECURITY INVOKER
	PARALLEL UNSAFE
	COST 1
	AS 
$function$
BEGIN
  UPDATE class
  SET class_size = class_size + 1
  WHERE class_id = NEW.class_id_class;
  RETURN NEW;
END;
$function$;
-- ddl-end --
COMMENT ON FUNCTION public.increase_class_size() IS E'Add class size by one after an enrollment to a class is triggered';
-- ddl-end --

-- object: trg_increment_class_size | type: TRIGGER --
CREATE OR REPLACE TRIGGER trg_increment_class_size
	AFTER INSERT 
	ON public.enrollment
	FOR EACH ROW
	EXECUTE PROCEDURE public.increase_class_size();
-- ddl-end --
COMMENT ON TRIGGER trg_increment_class_size ON public.enrollment IS E'increase class size by 1 after student enroll';
-- ddl-end --
