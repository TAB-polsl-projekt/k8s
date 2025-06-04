
CREATE TABLE "users" (
  "user_id" UUID PRIMARY KEY,
  "email" VARCHAR(255) NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "surname" VARCHAR(255) NOT NULL,
  "student_id" UUID,
  "user_disabled" BOOLEAN NOT NULL,
  "last_login_time" TIMESTAMP
);

CREATE TABLE "subjects" (
  "subject_id" UUID PRIMARY KEY,
  "subject_name" VARCHAR(255),
  "editor_role_id" UUID NOT NULL
);

CREATE TABLE "roles" (
  "role_id" UUID PRIMARY KEY,
  "name" VARCHAR(255) NOT NULL,
  "permissions" INT NOT NULL
);

CREATE TABLE "user_subjects" (
  "user_id" UUID NOT NULL,
  "subject_id" UUID NOT NULL,
  "role_id" UUID NOT NULL,
  "grade" DECIMAL(3,2),
  PRIMARY KEY ("user_id", "subject_id")
);

CREATE TABLE "assignments" (
  "assignment_id" UUID PRIMARY KEY,
  "subject_id" UUID NOT NULL,
  "title" VARCHAR(255) NOT NULL,
  "description" VARCHAR(1024),
  "accepted_mime_types" TEXT[]
);

CREATE TABLE "solution" (
  "solution_id" UUID PRIMARY KEY,
  "grade" DECIMAL(3,2),
  "submission_date" TIMESTAMP,
  "solution_data" BYTEA,
  "reviewed_by" UUID,
  "review_comment" VARCHAR(1024),
  "review_date" TIMESTAMP,
  "mime_type" TEXT
);

CREATE TABLE "user_solution_assignments" (
  "user_id" UUID,
  "solution_id" UUID,
  "assignment_id" UUID,
  PRIMARY KEY ("user_id", "solution_id", "assignment_id")
);

CREATE TABLE "microsoft_logins" (
  "microsoft_login_id" UUID PRIMARY KEY,
  "microsoft_id" UUID NOT NULL,
  "user_id" UUID UNIQUE NOT NULL
);

CREATE TABLE "session_refresh_keys" (
  "refresh_key_id" UUID PRIMARY KEY,
  "user_id" UUID NOT NULL,
  "expiration_time" TIMESTAMP NOT NULL,
  "refresh_count" INT NOT NULL,
  "refresh_limit" INT NOT NULL
);


ALTER TABLE "user_subjects"
  ADD CONSTRAINT "user_id" FOREIGN KEY ("user_id") REFERENCES "users" ("user_id"),
  ADD CONSTRAINT "subject_id" FOREIGN KEY ("subject_id") REFERENCES "subjects" ("subject_id"),
  ADD CONSTRAINT "role_id" FOREIGN KEY ("role_id") REFERENCES "roles" ("role_id");

ALTER TABLE "assignments"
  ADD CONSTRAINT "subject_id" FOREIGN KEY ("subject_id") REFERENCES "subjects" ("subject_id");

ALTER TABLE "user_solution_assignments"
  ADD CONSTRAINT "user_id" FOREIGN KEY ("user_id") REFERENCES "users" ("user_id"),
  ADD CONSTRAINT "solution_id" FOREIGN KEY ("solution_id") REFERENCES "solution" ("solution_id"),
  ADD CONSTRAINT "assignment_id" FOREIGN KEY ("assignment_id") REFERENCES "assignments" ("assignment_id");

ALTER TABLE "microsoft_logins"
  ADD CONSTRAINT "user_id" FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "session_refresh_keys"
  ADD CONSTRAINT "user_id" FOREIGN KEY ("user_id") REFERENCES "users" ("user_id");

ALTER TABLE "subjects"
  ADD CONSTRAINT "editor_role_id" FOREIGN KEY ("editor_role_id") REFERENCES "roles" ("role_id");

ALTER TABLE "solution"
  ADD CONSTRAINT "reviewed_by" FOREIGN KEY ("reviewed_by") REFERENCES "users" ("user_id");
