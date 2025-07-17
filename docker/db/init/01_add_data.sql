-- =================================================================
-- Mock Data Insertion Script for EssayCoach
-- =================================================================
-- This script inserts mock data into the tables created by 00_init.sql
-- for testing and development purposes.
-- All insertions are wrapped in a transaction.

BEGIN TRANSACTION;

-- ========================================
-- Insert mock data for "user" table
-- ========================================
-- Columns: user_id, user_fname, user_lname, user_email, user_role, user_status, user_credential
INSERT INTO public."user" (user_id, user_fname, user_lname, user_email, user_role, user_status, user_credential) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 'student', 'active', 'hashed_password_1'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 'lecturer', 'active', 'hashed_password_2'),
(3, 'Admin', 'User', 'admin@example.com', 'admin', 'active', 'hashed_password_3');

-- ========================================
-- Insert mock data for "unit" table
-- ========================================
-- Columns: unit_id, unit_name, unit_desc
INSERT INTO public.unit (unit_id, unit_name, unit_desc) VALUES
('CS101', 'Introduction to Computer Science', 'A foundational course on programming and computer science principles.'),
('ENG202', 'Advanced Academic Writing', 'A course on advanced techniques for academic writing and research.');

-- ========================================
-- Insert mock data for "class" table
-- ========================================
-- Columns: unit_id_unit, class_size
INSERT INTO public.class (unit_id_unit, class_size) VALUES
('CS101', 0),
('ENG202', 0);

-- ========================================
-- Insert mock data for "enrollment" table
-- ========================================
-- Note: The trigger trg_increment_class_size will automatically update the class_size in the "class" table.
-- Columns: user_id_user, class_id_class, unit_id_unit
INSERT INTO public.enrollment (user_id_user, class_id_class, unit_id_unit) VALUES
(1, 1, 'CS101');

-- ========================================
-- Insert mock data for "teaching_assn" table
-- ========================================
-- Columns: user_id_user, class_id_class
INSERT INTO public.teaching_assn (user_id_user, class_id_class) VALUES
(2, 1);

-- ========================================
-- Insert mock data for "marking_rubric" table
-- ========================================
-- Columns: user_id_user, rubric_desc
INSERT INTO public.marking_rubric (user_id_user, rubric_desc) VALUES
(2, 'Standard rubric for introductory essays.'),
(2, 'Rubric for final year research papers.');

-- ========================================
-- Insert mock data for "task" table
-- ========================================
-- Columns: unit_id_unit, rubric_id_marking_rubric, task_due_datetime
INSERT INTO public.task (unit_id_unit, rubric_id_marking_rubric, task_due_datetime) VALUES
('CS101', 1, '2024-12-31 23:59:59');

-- ========================================
-- Insert mock data for "rubric_item" table
-- ========================================
-- Columns: rubric_id_marking_rubric, rubric_item_name, rubric_item_weight
INSERT INTO public.rubric_item (rubric_id_marking_rubric, rubric_item_name, rubric_item_weight) VALUES
(1, 'Clarity', 40.0),
(1, 'Grammar', 30.0),
(1, 'Structure', 30.0);

-- ========================================
-- Insert mock data for "rubric_level_desc" table
-- ========================================
-- Columns: rubric_item_id_rubric_item, level_min_score, level_max_score, level_desc
INSERT INTO public.rubric_level_desc (rubric_item_id_rubric_item, level_min_score, level_max_score, level_desc) VALUES
(1, 0, 4, 'Poor: Lacks clarity and focus.'),
(1, 5, 7, 'Good: Mostly clear and focused.'),
(1, 8, 10, 'Excellent: Very clear, concise, and focused.');

-- ========================================
-- Insert mock data for "submission" table
-- ========================================
-- Columns: task_id_task, user_id_user, submission_txt
INSERT INTO public.submission (task_id_task, user_id_user, submission_txt) VALUES
(1, 1, 'This is the content of the first essay submission.');

-- ========================================
-- Insert mock data for "feedback" table
-- ========================================
-- Columns: submission_id_submission, user_id_user
INSERT INTO public.feedback (submission_id_submission, user_id_user) VALUES
(1, 2);

-- ========================================
-- Insert mock data for "feedback_item" table
-- ========================================
-- Columns: feedback_id_feedback, rubric_item_id_rubric_item, feedback_item_score, feedback_item_comment, feedback_item_source
INSERT INTO public.feedback_item (feedback_id_feedback, rubric_item_id_rubric_item, feedback_item_score, feedback_item_comment, feedback_item_source) VALUES
(1, 1, 6, 'Good clarity, but some sections could be more concise.', 'human'),
(1, 2, 7, 'Grammar is solid.', 'ai'),
(1, 3, 5, 'The structure could be improved for better flow.', 'revised');

COMMIT;

-- =================================================================
-- End of Script
-- =================================================================
