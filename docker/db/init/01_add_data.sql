-- =================================================================
-- Mock Data Insertion Script for EssayCoach
-- =================================================================
-- This script inserts mock data into the tables created by 00_init.sql
-- for testing and development purposes.
-- All insertions are wrapped in a transaction.

BEGIN;

-- ========================================
-- Insert mock data for "user" table
-- ========================================
-- Columns: user_id, user_fname, user_lname, user_email, user_role, user_status, user_credential
INSERT INTO public."user" (user_id, user_fname, user_lname, user_email, user_role, user_status, user_credential) VALUES
(1, 'John', 'Doe', 'john.doe@example.com', 'student', 'active', 'hashed_password_1'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', 'lecturer', 'active', 'hashed_password_2'),
(3, 'Admin', 'User', 'admin@example.com', 'admin', 'active', 'hashed_password_3'),
(4, 'Alice', 'Johnson', 'alice.johnson@example.com', 'student', 'active', 'hashed_password_4'),
(5, 'Bob', 'Williams', 'bob.williams@example.com', 'student', 'active', 'hashed_password_5'),
(6, 'Charlie', 'Brown', 'charlie.brown@example.com', 'student', 'active', 'hashed_password_6'),
(7, 'David', 'Miller', 'david.miller@example.com', 'student', 'active', 'hashed_password_7'),
(8, 'Eve', 'Davis', 'eve.davis@example.com', 'student', 'active', 'hashed_password_8'),
(9, 'Frank', 'Garcia', 'frank.garcia@example.com', 'student', 'active', 'hashed_password_9'),
(10, 'Grace', 'Martinez', 'grace.martinez@example.com', 'student', 'active', 'hashed_password_10'),
(11, 'Hannah', 'Rodriguez', 'hannah.rodriguez@example.com', 'student', 'active', 'hashed_password_11'),
(12, 'Ian', 'Lee', 'ian.lee@example.com', 'student', 'active', 'hashed_password_12'),
(13, 'Jack', 'Walker', 'jack.walker@example.com', 'student', 'active', 'hashed_password_13'),
(14, 'Karen', 'Hall', 'karen.hall@example.com', 'student', 'active', 'hashed_password_14'),
(15, 'Leo', 'Allen', 'leo.allen@example.com', 'student', 'active', 'hashed_password_15'),
(16, 'Mia', 'Young', 'mia.young@example.com', 'student', 'active', 'hashed_password_16'),
(17, 'Nina', 'Hernandez', 'nina.hernandez@example.com', 'student', 'active', 'hashed_password_17'),
(18, 'Oscar', 'King', 'oscar.king@example.com', 'student', 'active', 'hashed_password_18'),
(19, 'Paul', 'Wright', 'paul.wright@example.com', 'student', 'suspended', 'hashed_password_19'),
(20, 'Quinn', 'Lopez', 'quinn.lopez@example.com', 'student', 'active', 'hashed_password_20'),
(21, 'Rachel', 'Hill', 'rachel.hill@example.com', 'student', 'active', 'hashed_password_21'),
(22, 'Sam', 'Scott', 'sam.scott@example.com', 'student', 'active', 'hashed_password_22'),
(23, 'Tina', 'Green', 'tina.green@example.com', 'student', 'active', 'hashed_password_23'),
(24, 'Uma', 'Adams', 'uma.adams@example.com', 'student', 'active', 'hashed_password_24'),
(25, 'Victor', 'Baker', 'victor.baker@example.com', 'student', 'active', 'hashed_password_25'),
(26, 'Wendy', 'Nelson', 'wendy.nelson@example.com', 'student', 'active', 'hashed_password_26'),
(27, 'Xander', 'Carter', 'xander.carter@example.com', 'student', 'active', 'hashed_password_27'),
(28, 'Yara', 'Mitchell', 'yara.mitchell@example.com', 'student', 'active', 'hashed_password_28'),
(29, 'Zane', 'Perez', 'zane.perez@example.com', 'student', 'active', 'hashed_password_29'),
(30, 'Amy', 'Roberts', 'amy.roberts@example.com', 'student', 'active', 'hashed_password_30'),
(31, 'Brian', 'Turner', 'brian.turner@example.com', 'student', 'active', 'hashed_password_31'),
(32, 'Cathy', 'Phillips', 'cathy.phillips@example.com', 'student', 'active', 'hashed_password_32'),
(33, 'Derek', 'Campbell', 'derek.campbell@example.com', 'student', 'active', 'hashed_password_33'),
(34, 'Ella', 'Parker', 'ella.parker@example.com', 'student', 'active', 'hashed_password_34'),
(35, 'Fred', 'Evans', 'fred.evans@example.com', 'student', 'active', 'hashed_password_35'),
(36, 'Gina', 'Edwards', 'gina.edwards@example.com', 'student', 'active', 'hashed_password_36'),
(37, 'Henry', 'Collins', 'henry.collins@example.com', 'student', 'active', 'hashed_password_37'),
(38, 'Ivy', 'Stewart', 'ivy.stewart@example.com', 'student', 'active', 'hashed_password_38'),
(39, 'Jake', 'Sanchez', 'jake.sanchez@example.com', 'student', 'suspended', 'hashed_password_39'),
(40, 'Kylie', 'Morris', 'kylie.morris@example.com', 'student', 'active', 'hashed_password_40'),
(41, 'Liam', 'Rogers', 'liam.rogers@example.com', 'student', 'active', 'hashed_password_41'),
(42, 'Megan', 'Reed', 'megan.reed@example.com', 'student', 'active', 'hashed_password_42'),
(43, 'Noah', 'Cook', 'noah.cook@example.com', 'student', 'active', 'hashed_password_43'),
(44, 'Olivia', 'Morgan', 'olivia.morgan@example.com', 'student', 'active', 'hashed_password_44'),
(45, 'Peter', 'Bell', 'peter.bell@example.com', 'student', 'active', 'hashed_password_45'),
(46, 'Queen', 'Murphy', 'queen.murphy@example.com', 'student', 'active', 'hashed_password_46'),
(47, 'Riley', 'Bailey', 'riley.bailey@example.com', 'student', 'active', 'hashed_password_47'),
(48, 'Sara', 'Rivera', 'sara.rivera@example.com', 'student', 'active', 'hashed_password_48'),
(49, 'Tom', 'Cooper', 'tom.cooper@example.com', 'student', 'active', 'hashed_password_49'),
(50, 'Ursula', 'Richardson', 'ursula.richardson@example.com', 'student', 'active', 'hashed_password_50'),
(51, 'Vince', 'Cox', 'vince.cox@example.com', 'student', 'active', 'hashed_password_51'),
(52, 'Will', 'Howard', 'will.howard@example.com', 'student', 'active', 'hashed_password_52'),
(53, 'Xenia', 'Ward', 'xenia.ward@example.com', 'student', 'active', 'hashed_password_53'),
(54, 'Yasmine', 'Torres', 'yasmine.torres@example.com', 'student', 'active', 'hashed_password_54'),
(55, 'Zack', 'Peterson', 'zack.peterson@example.com', 'student', 'active', 'hashed_password_55'),
(56, 'Anna', 'Gray', 'anna.gray@example.com', 'student', 'active', 'hashed_password_56'),
(57, 'Ben', 'Ramirez', 'ben.ramirez@example.com', 'student', 'suspended', 'hashed_password_57'),
(58, 'Clara', 'James', 'clara.james@example.com', 'student', 'active', 'hashed_password_58'),
(59, 'Dylan', 'Watson', 'dylan.watson@example.com', 'student', 'active', 'hashed_password_59'),
(60, 'Elena', 'Brooks', 'elena.brooks@example.com', 'student', 'active', 'hashed_password_60'),
(61, 'Finn', 'Kelly', 'finn.kelly@example.com', 'student', 'active', 'hashed_password_61'),
(62, 'Gwen', 'Sanders', 'gwen.sanders@example.com', 'student', 'active', 'hashed_password_62'),
(63, 'Harvey', 'Price', 'harvey.price@example.com', 'student', 'active', 'hashed_password_63'),
(64, 'Isabel', 'Bennett', 'isabel.bennett@example.com', 'student', 'active', 'hashed_password_64'),
(65, 'Jonas', 'Wood', 'jonas.wood@example.com', 'student', 'active', 'hashed_password_65'),
(66, 'Kara', 'Barnes', 'kara.barnes@example.com', 'student', 'active', 'hashed_password_66'),
(67, 'Lola', 'Ross', 'lola.ross@example.com', 'student', 'active', 'hashed_password_67'),
(68, 'Mason', 'Henderson', 'mason.henderson@example.com', 'student', 'active', 'hashed_password_68'),
(69, 'Nora', 'Coleman', 'nora.coleman@example.com', 'student', 'suspended', 'hashed_password_69'),
(70, 'Owen', 'Jenkins', 'owen.jenkins@example.com', 'student', 'active', 'hashed_password_70'),
(71, 'Paula', 'Perry', 'paula.perry@example.com', 'student', 'active', 'hashed_password_71'),
(72, 'Quentin', 'Powell', 'quentin.powell@example.com', 'student', 'active', 'hashed_password_72'),
(73, 'Rosa', 'Long', 'rosa.long@example.com', 'student', 'active', 'hashed_password_73'),
(74, 'Steve', 'Patterson', 'steve.patterson@example.com', 'student', 'active', 'hashed_password_74'),
(75, 'Tara', 'Hughes', 'tara.hughes@example.com', 'student', 'active', 'hashed_password_75'),
(76, 'Uri', 'Flores', 'uri.flores@example.com', 'student', 'active', 'hashed_password_76'),
(77, 'Vera', 'Washington', 'vera.washington@example.com', 'student', 'active', 'hashed_password_77'),
(78, 'Wade', 'Butler', 'wade.butler@example.com', 'student', 'active', 'hashed_password_78'),
(79, 'Ximena', 'Simmons', 'ximena.simmons@example.com', 'student', 'active', 'hashed_password_79'),
(80, 'Yusuf', 'Foster', 'yusuf.foster@example.com', 'student', 'active', 'hashed_password_80'),
(81, 'Zoe', 'Gonzalez', 'zoe.gonzalez@example.com', 'student', 'active', 'hashed_password_81'),
(82, 'Linda', 'Bryant', 'linda.bryant@example.com', 'student', 'active', 'hashed_password_82'),
(83, 'Matt', 'Alexander', 'matt.alexander@example.com', 'student', 'active', 'hashed_password_83'),
(84, 'Nate', 'Russell', 'nate.russell@example.com', 'student', 'active', 'hashed_password_84'),
(85, 'Olga', 'Griffin', 'olga.griffin@example.com', 'student', 'active', 'hashed_password_85'),
(86, 'Pam', 'Diaz', 'pam.diaz@example.com', 'student', 'active', 'hashed_password_86'),
(87, 'Rex', 'Hayes', 'rex.hayes@example.com', 'student', 'active', 'hashed_password_87'),
(88, 'Sue', 'Myers', 'sue.myers@example.com', 'student', 'active', 'hashed_password_88'),
(89, 'Ted', 'Ford', 'ted.ford@example.com', 'student', 'active', 'hashed_password_89'),
(90, 'Violet', 'Hamilton', 'violet.hamilton@example.com', 'student', 'active', 'hashed_password_90'),
(91, 'Walt', 'Graham', 'walt.graham@example.com', 'student', 'active', 'hashed_password_91'),
(92, 'Xavier', 'Sullivan', 'xavier.sullivan@example.com', 'student', 'active', 'hashed_password_92'),
(93, 'Yolanda', 'Wallace', 'yolanda.wallace@example.com', 'student', 'active', 'hashed_password_93'),
(94, 'Zara', 'West', 'zara.west@example.com', 'student', 'active', 'hashed_password_94'),
(95, 'Lecturer1', 'Teach', 'lecturer1@example.com', 'lecturer', 'active', 'hashed_password_95'),
(96, 'Lecturer2', 'Teach', 'lecturer2@example.com', 'lecturer', 'active', 'hashed_password_96'),
(97, 'Lecturer3', 'Teach', 'lecturer3@example.com', 'lecturer', 'active', 'hashed_password_97'),
(98, 'Admin2', 'User', 'admin2@example.com', 'admin', 'active', 'hashed_password_98'),
(99, 'Admin3', 'User', 'admin3@example.com', 'admin', 'active', 'hashed_password_99'),
(100, 'Ethan', 'Foster', 'ethan.foster@example.com', 'student', 'active', 'hashed_password_100'),
(101, 'Sophie', 'Bennett', 'sophie.bennett@example.com', 'student', 'unregistered', 'hashed_password_101'),
(102, 'Lucas', 'Harrison', 'lucas.harrison@example.com', 'student', 'unregistered', 'hashed_password_102'),
(103, 'Chloe', 'Graham', 'chloe.graham@example.com', 'student', 'unregistered', 'hashed_password_103'),
(104, 'Mason', 'Reynolds', 'mason.reynolds@example.com', 'student', 'unregistered', 'hashed_password_104'),
(105, 'Ella', 'Fleming', 'ella.fleming@example.com', 'student', 'unregistered', 'hashed_password_105'),
(106, 'Aiden', 'Harper', 'aiden.harper@example.com', 'student', 'unregistered', 'hashed_password_106'),
(107, 'Layla', 'Woods', 'layla.woods@example.com', 'student', 'unregistered', 'hashed_password_107'),
(108, 'Jack', 'Porter', 'jack.porter@example.com', 'student', 'unregistered', 'hashed_password_108'),
(109, 'Zoe', 'Murray', 'zoe.murray@example.com', 'student', 'unregistered', 'hashed_password_109'),
(110, 'Leo', 'Fisher', 'leo.fisher@example.com', 'student', 'unregistered', 'hashed_password_110'),
(111, 'Ruby', 'Palmer', 'ruby.palmer@example.com', 'student', 'unregistered', 'hashed_password_111'),
(112, 'Oscar', 'Wells', 'oscar.wells@example.com', 'student', 'unregistered', 'hashed_password_112'),
(113, 'Mila', 'Knight', 'mila.knight@example.com', 'student', 'unregistered', 'hashed_password_113'),
(114, 'Henry', 'Barker', 'henry.barker@example.com', 'student', 'unregistered', 'hashed_password_114'),
(115, 'Lily', 'Spencer', 'lily.spencer@example.com', 'student', 'unregistered', 'hashed_password_115'),
(116, 'Sebastian', 'Hunt', 'sebastian.hunt@example.com', 'student', 'unregistered', 'hashed_password_116'),
(117, 'Aria', 'Moss', 'aria.moss@example.com', 'student', 'unregistered', 'hashed_password_117'),
(118, 'Benjamin', 'Curtis', 'benjamin.curtis@example.com', 'student', 'unregistered', 'hashed_password_118'),
(119, 'Isla', 'Ford', 'isla.ford@example.com', 'student', 'unregistered', 'hashed_password_119'),
(120, 'Nathan', 'Walsh', 'nathan.walsh@example.com', 'student', 'unregistered', 'hashed_password_120');


-- ========================================
-- Insert mock data for "unit" table
-- ========================================
-- Columns: unit_id, unit_name, unit_desc
INSERT INTO public.unit (unit_id, unit_name, unit_desc) VALUES
('CS101', 'Introduction to Computer Science', 'A foundational course on programming and computer science principles.'),
('ENG202', 'Advanced Academic Writing', 'A course on advanced techniques for academic writing and research.'),
('MATH303', 'Calculus III', 'An in-depth study of multivariable calculus and its applications.'),
('HIST404', 'World History', 'A comprehensive overview of world history from ancient to modern times.'),
('PHIL505', 'Philosophy of Science', 'An exploration of the philosophical underpinnings of scientific inquiry.'),
('BIO606', 'Biology 101', 'An introductory course on the principles of biology and life sciences.'),
('CHEM707', 'Chemistry Basics', 'A foundational course in chemistry covering basic concepts and laboratory techniques.'),
('ART808', 'Art History', 'A survey of art history from the Renaissance to contemporary art.'),
('PSY909', 'Introduction to Psychology', 'An overview of psychological theories and practices.'),
('SOC1010', 'Sociology Fundamentals', 'A course on the basic concepts and theories in sociology.');

-- ========================================
-- Insert mock data for "class" table
-- ========================================
-- Columns: unit_id_unit (class_id is auto-generated, class_size defaults to 0)
INSERT INTO public.class (unit_id_unit) VALUES
('CS101'),
('ENG202'),
('MATH303'),
('HIST404'),
('PHIL505'),
('BIO606'),
('CHEM707'),
('ART808'),
('PSY909'),
('SOC1010'),
('ENG202'),
('PSY909'),
('SOC1010');

-- ========================================
-- Insert mock data for "enrollment" table
-- ========================================
-- Note: The trigger trg_increment_class_size will automatically update the class_size in the "class" table.
-- Columns: user_id_user, class_id_class, unit_id_unit

-- Create a realistic enrollment distribution across all classes
-- Students will be distributed across different units and classes to simulate real enrollment patterns

-- Core units (CS101, ENG202, MATH303, PSY909) - Higher enrollment
INSERT INTO public.enrollment (user_id_user, class_id_class, unit_id_unit)
SELECT 
    student_data.user_id,
    class_data.class_id,
    class_data.unit_id_unit
FROM (
    -- Create a balanced distribution of students across core subjects
    SELECT user_id, 
           ROW_NUMBER() OVER (ORDER BY RANDOM()) as rn,
           -- Assign students to units based on their ID ranges for realistic distribution
           CASE 
               WHEN user_id % 4 = 0 THEN 'CS101'
               WHEN user_id % 4 = 1 THEN 'ENG202'  
               WHEN user_id % 4 = 2 THEN 'MATH303'
               ELSE 'PSY909'
           END as preferred_unit
    FROM public."user" 
    WHERE user_role = 'student' AND user_status = 'active'
) student_data
JOIN (
    -- Get available classes for each unit
    SELECT class_id, unit_id_unit,
           ROW_NUMBER() OVER (PARTITION BY unit_id_unit ORDER BY class_id) as class_rn
    FROM public.class 
    WHERE unit_id_unit IN ('CS101', 'ENG202', 'MATH303', 'PSY909')
) class_data ON student_data.preferred_unit = class_data.unit_id_unit
WHERE class_data.class_rn = ((student_data.rn - 1) % 
    (SELECT COUNT(*) FROM public.class WHERE unit_id_unit = class_data.unit_id_unit)) + 1;

-- Secondary enrollments - Students taking additional subjects (realistic overlap)
INSERT INTO public.enrollment (user_id_user, class_id_class, unit_id_unit)
SELECT 
    u.user_id,
    c.class_id,
    c.unit_id_unit
FROM public."user" u
CROSS JOIN public.class c
WHERE u.user_role = 'student' 
    AND u.user_status = 'active'
    AND c.unit_id_unit IN ('HIST404', 'PHIL505', 'BIO606', 'CHEM707', 'ART808', 'SOC1010')
    AND u.user_id BETWEEN 15 AND 85  -- Middle range students take electives
    AND RANDOM() > 0.6  -- 40% chance of enrollment in electives
    AND NOT EXISTS (
        SELECT 1 FROM public.enrollment e 
        WHERE e.user_id_user = u.user_id AND e.unit_id_unit = c.unit_id_unit
    );

-- Ensure minimum enrollment for all classes (no empty classes)
INSERT INTO public.enrollment (user_id_user, class_id_class, unit_id_unit)
SELECT 
    u.user_id,
    c.class_id,
    c.unit_id_unit
FROM public.class c
CROSS JOIN (
    SELECT user_id, ROW_NUMBER() OVER (ORDER BY RANDOM()) as rn
    FROM public."user" 
    WHERE user_role = 'student' AND user_status = 'active'
) u
WHERE NOT EXISTS (
    SELECT 1 FROM public.enrollment e WHERE e.class_id_class = c.class_id
)
AND u.rn <= 8  -- Ensure at least 8 students per empty class
AND NOT EXISTS (
    SELECT 1 FROM public.enrollment e2 
    WHERE e2.user_id_user = u.user_id AND e2.unit_id_unit = c.unit_id_unit
);

-- ========================================
-- Insert mock data for "teaching_assn" table
-- ========================================
-- Assign lecturers to classes dynamically
INSERT INTO public.teaching_assn (user_id_user, class_id_class)
SELECT 
    l.user_id,
    c.class_id
FROM (
    SELECT user_id, ROW_NUMBER() OVER (ORDER BY user_id) as rn
    FROM public."user" 
    WHERE user_role = 'lecturer' AND user_status = 'active'
) l
CROSS JOIN (
    SELECT class_id, unit_id_unit, ROW_NUMBER() OVER (ORDER BY class_id) as rn
    FROM public.class
) c
WHERE l.rn = ((c.rn - 1) % (SELECT COUNT(*) FROM public."user" WHERE user_role = 'lecturer' AND user_status = 'active')) + 1;

-- ========================================
-- Insert mock data for "marking_rubric" table
-- ========================================
-- Create rubrics for different subjects by each lecturer
INSERT INTO public.marking_rubric (user_id_user, rubric_desc)
SELECT 
    l.user_id,
    CASE 
        WHEN l.rn = 1 THEN 'Standard rubric for introductory essays and assignments.'
        WHEN l.rn = 2 THEN 'Advanced rubric for research papers and critical analysis.'
        ELSE 'Comprehensive rubric for final year projects and presentations.'
    END as rubric_desc
FROM (
    SELECT user_id, ROW_NUMBER() OVER (ORDER BY user_id) as rn
    FROM public."user" 
    WHERE user_role = 'lecturer' AND user_status = 'active'
) l;

-- Create additional specialized rubrics
INSERT INTO public.marking_rubric (user_id_user, rubric_desc)
SELECT 
    user_id,
    'Technical writing rubric for STEM subjects.'
FROM public."user" 
WHERE user_role = 'lecturer' AND user_status = 'active'
LIMIT 1;

INSERT INTO public.marking_rubric (user_id_user, rubric_desc)
SELECT 
    user_id,
    'Creative writing assessment rubric.'
FROM public."user" 
WHERE user_role = 'lecturer' AND user_status = 'active'
OFFSET 1 LIMIT 1;

-- ========================================
-- Insert mock data for "task" table
-- ========================================
-- Create tasks for different units using appropriate rubrics
-- Ensure each unit has at least one task

-- Core subject tasks
INSERT INTO public.task (unit_id_unit, rubric_id_marking_rubric, task_due_datetime)
SELECT 
    'CS101',
    r.rubric_id,
    CURRENT_DATE + INTERVAL '30 days' + (RANDOM() * INTERVAL '60 days')
FROM public.marking_rubric r
WHERE r.rubric_desc LIKE '%introductory%'
LIMIT 1;

INSERT INTO public.task (unit_id_unit, rubric_id_marking_rubric, task_due_datetime)
SELECT 
    'ENG202',
    r.rubric_id,
    CURRENT_DATE + INTERVAL '45 days' + (RANDOM() * INTERVAL '45 days')
FROM public.marking_rubric r
WHERE r.rubric_desc LIKE '%research papers%'
LIMIT 1;

INSERT INTO public.task (unit_id_unit, rubric_id_marking_rubric, task_due_datetime)
SELECT 
    'MATH303',
    r.rubric_id,
    CURRENT_DATE + INTERVAL '20 days' + (RANDOM() * INTERVAL '40 days')
FROM public.marking_rubric r
WHERE r.rubric_desc LIKE '%final year%'
LIMIT 1;

INSERT INTO public.task (unit_id_unit, rubric_id_marking_rubric, task_due_datetime)
SELECT 
    'PSY909',
    r.rubric_id,
    CURRENT_DATE + INTERVAL '35 days' + (RANDOM() * INTERVAL '30 days')
FROM public.marking_rubric r
WHERE r.rubric_desc LIKE '%Technical%'
LIMIT 1;

-- Additional tasks for other units using available rubrics
INSERT INTO public.task (unit_id_unit, rubric_id_marking_rubric, task_due_datetime)
SELECT 
    unit_data.unit_id,
    r.rubric_id,
    CURRENT_DATE + INTERVAL '25 days' + (RANDOM() * INTERVAL '50 days')
FROM (
    VALUES 
        ('HIST404'),
        ('PHIL505'),
        ('BIO606'),
        ('CHEM707'),
        ('ART808'),
        ('SOC1010')
) AS unit_data(unit_id)
CROSS JOIN (
    SELECT rubric_id, ROW_NUMBER() OVER (ORDER BY RANDOM()) as rn
    FROM public.marking_rubric
) r
WHERE r.rn = 1;  -- Use the first randomly selected rubric

-- Create additional tasks for some popular units (multiple assignments)
INSERT INTO public.task (unit_id_unit, rubric_id_marking_rubric, task_due_datetime)
VALUES 
    ('CS101', (SELECT rubric_id FROM public.marking_rubric WHERE rubric_desc LIKE '%Technical%' LIMIT 1), CURRENT_DATE + INTERVAL '60 days'),
    ('ENG202', (SELECT rubric_id FROM public.marking_rubric WHERE rubric_desc LIKE '%introductory%' LIMIT 1), CURRENT_DATE + INTERVAL '75 days'),
    ('PSY909', (SELECT rubric_id FROM public.marking_rubric WHERE rubric_desc LIKE '%research papers%' LIMIT 1), CURRENT_DATE + INTERVAL '50 days');

-- ========================================
-- Insert mock data for "rubric_item" table
-- ========================================
-- Create rubric items for each rubric dynamically
INSERT INTO public.rubric_item (rubric_id_marking_rubric, rubric_item_name, rubric_item_weight)
SELECT 
    r.rubric_id,
    item_data.item_name,
    item_data.item_weight
FROM public.marking_rubric r
CROSS JOIN (
    VALUES 
        ('Content Quality', 35.0),
        ('Writing Clarity', 25.0),
        ('Grammar & Style', 20.0),
        ('Structure & Organization', 20.0)
) AS item_data(item_name, item_weight)
WHERE r.rubric_desc LIKE '%introductory%';

INSERT INTO public.rubric_item (rubric_id_marking_rubric, rubric_item_name, rubric_item_weight)
SELECT 
    r.rubric_id,
    item_data.item_name,
    item_data.item_weight
FROM public.marking_rubric r
CROSS JOIN (
    VALUES 
        ('Research Depth', 30.0),
        ('Critical Analysis', 25.0),
        ('Citations & References', 20.0),
        ('Argument Coherence', 15.0),
        ('Writing Quality', 10.0)
) AS item_data(item_name, item_weight)
WHERE r.rubric_desc LIKE '%research papers%';

INSERT INTO public.rubric_item (rubric_id_marking_rubric, rubric_item_name, rubric_item_weight)
SELECT 
    r.rubric_id,
    item_data.item_name,
    item_data.item_weight
FROM public.marking_rubric r
CROSS JOIN (
    VALUES 
        ('Innovation & Creativity', 25.0),
        ('Technical Execution', 25.0),
        ('Presentation Quality', 20.0),
        ('Problem Solving', 15.0),
        ('Documentation', 15.0)
) AS item_data(item_name, item_weight)
WHERE r.rubric_desc LIKE '%final year%';

-- ========================================
-- Insert mock data for "rubric_level_desc" table
-- ========================================
-- Create level descriptions for each rubric item
INSERT INTO public.rubric_level_desc (rubric_item_id_rubric_item, level_min_score, level_max_score, level_desc)
SELECT 
    ri.rubric_item_id,
    level_data.min_score,
    level_data.max_score,
    level_data.level_desc
FROM public.rubric_item ri
CROSS JOIN (
    VALUES 
        (0, 4, 'Poor: Does not meet basic requirements and lacks fundamental understanding.'),
        (5, 6, 'Fair: Meets some requirements but shows limited understanding.'),
        (7, 8, 'Good: Meets most requirements with solid understanding.'),
        (9, 10, 'Excellent: Exceeds requirements with exceptional understanding and execution.')
) AS level_data(min_score, max_score, level_desc);

-- ========================================
-- Insert mock data for "submission" table
-- ========================================
-- Create submissions for multiple students across different tasks
-- Use realistic submission patterns with subject-specific content

INSERT INTO public.submission (task_id_task, user_id_user, submission_txt)
SELECT 
    t.task_id,
    e.user_id_user,
    CASE 
        WHEN t.unit_id_unit = 'CS101' THEN 
            CASE 
                WHEN RANDOM() < 0.5 THEN 'This submission explores the fundamental concepts of computer science including algorithms, data structures, and programming paradigms. The essay demonstrates understanding of computational thinking and problem-solving methodologies.'
                ELSE 'An analysis of modern programming languages and their evolution. This paper discusses object-oriented programming, functional programming, and their applications in software development.'
            END
        WHEN t.unit_id_unit = 'ENG202' THEN 
            CASE 
                WHEN RANDOM() < 0.5 THEN 'This academic paper examines advanced writing techniques through critical analysis of contemporary literature. The research methodology incorporates multiple scholarly sources and presents a coherent argument supported by evidence.'
                ELSE 'A comprehensive analysis of narrative structures in modern literature. This essay explores themes of identity, cultural representation, and literary devices used by contemporary authors.'
            END
        WHEN t.unit_id_unit = 'MATH303' THEN 
            CASE 
                WHEN RANDOM() < 0.5 THEN 'This mathematical analysis covers multivariable calculus applications in real-world scenarios. The solution demonstrates mastery of integration techniques, vector calculus, and optimization problems.'
                ELSE 'An exploration of differential equations and their applications in engineering and physics. This paper includes detailed calculations and graphical representations of complex mathematical concepts.'
            END
        WHEN t.unit_id_unit = 'PSY909' THEN 
            CASE 
                WHEN RANDOM() < 0.5 THEN 'This psychological study investigates cognitive behavioral patterns through empirical research. The methodology includes statistical analysis and interpretation of experimental data.'
                ELSE 'A research paper on developmental psychology examining how environmental factors influence childhood cognitive development. The study includes case studies and longitudinal data analysis.'
            END
        WHEN t.unit_id_unit = 'HIST404' THEN 
            'This historical analysis examines the socio-political factors that shaped major world events. The essay utilizes primary sources and historiographical methods to provide comprehensive insights into historical developments.'
        WHEN t.unit_id_unit = 'PHIL505' THEN 
            'A philosophical examination of scientific methodology and epistemology. This paper explores the relationship between empirical observation and theoretical frameworks in scientific inquiry.'
        WHEN t.unit_id_unit = 'BIO606' THEN 
            'This biological study focuses on cellular mechanisms and their role in organism development. The research includes laboratory observations and molecular analysis of biological processes.'
        WHEN t.unit_id_unit = 'CHEM707' THEN 
            'A comprehensive analysis of chemical reactions and molecular structures. This laboratory report details experimental procedures, results, and theoretical explanations of chemical phenomena.'
        WHEN t.unit_id_unit = 'ART808' THEN 
            'An art historical analysis examining the evolution of artistic movements from Renaissance to contemporary periods. This essay discusses cultural influences and artistic techniques across different eras.'
        WHEN t.unit_id_unit = 'SOC1010' THEN 
            'A sociological study investigating social structures and their impact on community development. This research utilizes qualitative methods to examine social interactions and cultural patterns.'
        ELSE 
            'This comprehensive submission addresses the core requirements of the assignment with detailed analysis and well-structured argumentation.'
    END
FROM public.task t
JOIN public.enrollment e ON t.unit_id_unit = e.unit_id_unit
WHERE RANDOM() > 0.25;  -- 75% submission rate (more realistic than 70%)

-- ========================================

-- Ensure only one feedback per submission by assigning a single teacher
INSERT INTO public.feedback (submission_id_submission, user_id_user)
SELECT 
    s.submission_id,
    MIN(ta.user_id_user)  -- Assign the teacher with the lowest user_id for each submission
FROM public.submission s
JOIN public.task t ON s.task_id_task = t.task_id
JOIN public.enrollment e ON t.unit_id_unit = e.unit_id_unit AND s.user_id_user = e.user_id_user
JOIN public.teaching_assn ta ON e.class_id_class = ta.class_id_class
WHERE RANDOM() > 0.2  -- 80% of submissions get feedback
GROUP BY s.submission_id;

-- ========================================
-- Insert mock data for "feedback_item" table
-- ========================================
-- Create detailed feedback items for each feedback
INSERT INTO public.feedback_item (feedback_id_feedback, rubric_item_id_rubric_item, feedback_item_score, feedback_item_comment, feedback_item_source)
SELECT 
    f.feedback_id,
    ri.rubric_item_id,
    CASE 
        WHEN RANDOM() < 0.1 THEN FLOOR(RANDOM() * 5)  -- 10% poor scores (0-4)
        WHEN RANDOM() < 0.3 THEN FLOOR(RANDOM() * 2) + 5  -- 20% fair scores (5-6)
        WHEN RANDOM() < 0.7 THEN FLOOR(RANDOM() * 2) + 7  -- 40% good scores (7-8)
        ELSE FLOOR(RANDOM() * 2) + 9  -- 30% excellent scores (9-10)
    END,
    CASE 
        WHEN ri.rubric_item_name LIKE '%Content%' OR ri.rubric_item_name LIKE '%Research%' THEN 
            CASE 
                WHEN RANDOM() < 0.33 THEN 'Demonstrates solid understanding of core concepts with room for deeper analysis.'
                WHEN RANDOM() < 0.66 THEN 'Content is well-researched and shows good grasp of the subject matter.'
                ELSE 'Excellent depth of knowledge with innovative insights and thorough exploration.'
            END
        WHEN ri.rubric_item_name LIKE '%Writing%' OR ri.rubric_item_name LIKE '%Clarity%' THEN 
            CASE 
                WHEN RANDOM() < 0.33 THEN 'Writing is clear and generally well-structured with minor improvements needed.'
                WHEN RANDOM() < 0.66 THEN 'Excellent writing quality with clear expression of ideas and logical flow.'
                ELSE 'Outstanding writing style that effectively communicates complex ideas.'
            END
        WHEN ri.rubric_item_name LIKE '%Grammar%' OR ri.rubric_item_name LIKE '%Style%' THEN 
            CASE 
                WHEN RANDOM() < 0.33 THEN 'Grammar is mostly correct with occasional minor errors.'
                WHEN RANDOM() < 0.66 THEN 'Strong command of language with appropriate academic tone.'
                ELSE 'Flawless grammar and excellent stylistic choices throughout.'
            END
        ELSE 
            CASE 
                WHEN RANDOM() < 0.33 THEN 'Meets requirements with adequate demonstration of skills.'
                WHEN RANDOM() < 0.66 THEN 'Good work that shows solid understanding and application.'
                ELSE 'Exceptional work that exceeds expectations in all areas.'
            END
    END,
    CASE 
        WHEN RANDOM() < 0.4 THEN 'ai'
        WHEN RANDOM() < 0.8 THEN 'human'
        ELSE 'revised'
    END
FROM public.feedback f
JOIN public.submission s ON f.submission_id_submission = s.submission_id
JOIN public.task t ON s.task_id_task = t.task_id
JOIN public.rubric_item ri ON t.rubric_id_marking_rubric = ri.rubric_id_marking_rubric;

COMMIT;

-- =================================================================
-- End of Script
-- =================================================================
