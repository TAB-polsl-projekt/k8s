CREATE TABLE users (
  user_id TEXT PRIMARY KEY,
  email VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  surname VARCHAR(255) NOT NULL,
  student_id TEXT,
  user_disabled BOOLEAN NOT NULL,
  last_login_time TIMESTAMP
);

CREATE TABLE subjects (
  subject_id TEXT PRIMARY KEY,
  subject_name VARCHAR(255),
  editor_role_id TEXT NOT NULL,
  FOREIGN KEY (editor_role_id) REFERENCES roles(role_id)
);

CREATE TABLE roles (
  role_id TEXT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  permissions INTEGER NOT NULL
);

CREATE TABLE user_subjects (
  user_id TEXT NOT NULL,
  subject_id TEXT NOT NULL,
  role_id TEXT NOT NULL,
  grade DECIMAL(3,2),
  PRIMARY KEY (user_id, subject_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (subject_id) REFERENCES subjects(subject_id),
  FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE assignments (
  assignment_id TEXT PRIMARY KEY,
  subject_id TEXT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(1024),
  accepted_mime_types TEXT,
  FOREIGN KEY (subject_id) REFERENCES subjects(subject_id)
);

CREATE TABLE solution (
  solution_id TEXT PRIMARY KEY,
  grade DECIMAL(3,2),
  submission_date TIMESTAMP,
  solution_data BLOB,
  reviewed_by TEXT,
  review_comment VARCHAR(1024),
  review_date TIMESTAMP,
  mime_type TEXT,
  FOREIGN KEY (reviewed_by) REFERENCES users(user_id)
);

CREATE TABLE user_solution_assignments (
  user_id TEXT,
  solution_id TEXT,
  assignment_id TEXT,
  PRIMARY KEY (user_id, solution_id, assignment_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (solution_id) REFERENCES solution(solution_id),
  FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id)
);

CREATE TABLE microsoft_logins (
  microsoft_login_id TEXT PRIMARY KEY,
  microsoft_id TEXT NOT NULL,
  user_id TEXT NOT NULL UNIQUE,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE session_refresh_keys (
  refresh_key_id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  expiration_time TIMESTAMP NOT NULL,
  refresh_count INTEGER NOT NULL,
  refresh_limit INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);
