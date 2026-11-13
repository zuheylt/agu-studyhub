# Technical Requirements — v1 (MVP)

_Source: Implementation Process – Week 2, Group 8._


Based on the survey findings, the conditions set by instructors, the
PHYS 101 syllabus mapping and the low-fidelity wireframes, the Computer
Engineering members defined the technical requirements for the first
version (minimum viable product) of AGU StudyHub. These requirements
will guide the development work in Week 3. Each requirement is linked to
the finding it comes from.

## A. Functional Requirements (what the platform must do)

| **ID** | **Requirement**                                                                                                                                                                                                                                                                           | **Based on**                                                                |
|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| FR-1   | Students can search courses by course code or name (e.g., PHYS 101) and browse courses by department.                                                                                                                                                                                     | Homepage wireframe                                                          |
| FR-2   | Each course page shows the course description and a week-by-week view (up to 14 weeks) with the topic, subtopics and learning objectives of each week.                                                                                                                                    | PHYS 101 syllabus mapping; students’ preference for weekly organisation     |
| FR-3   | Each week is split into three sections: Instructor Materials, Lab Content (shown only for courses with labs) and External OER Resources.                                                                                                                                                  | Course page wireframe; different lecture/lab formats across departments     |
| FR-4   | Every material shows its type (slides, video, syllabus, reading, lab explanation, OER), its source and its licence or permission note.                                                                                                                                                    | Instructor conditions; OER licence requirements                             |
| FR-5   | Restricted materials (e.g., Microbiology slides) are visible only to users signed in with an AGU e-mail address (@agu.edu.tr) and are never publicly accessible.                                                                                                                          | Microbiology instructor’s condition                                         |
| FR-6   | A course can be published in “syllabus-only” mode, showing the description and weekly topics without any files.                                                                                                                                                                           | Bioengineering instructor’s condition                                       |
| FR-7   | Lecture videos are embedded from their original location (e.g., YouTube or the instructor’s link) instead of being re-uploaded.                                                                                                                                                           | Calculus instructor’s permission; 46.9% of students want lecture recordings |
| FR-8   | Admins (team members) manage all course data through an admin interface, without changing code: create, edit and delete departments, courses, weeks and materials; reorder weeks and materials; upload files or add links; and change a course’s sharing mode or a material’s visibility. | Content workflow between MBG and CE members                                 |
| FR-9   | An editor can hide or remove a material immediately if an instructor withdraws or changes permission.                                                                                                                                                                                     | Permission tracking sheet                                                   |
| FR-10  | Admins can import a course’s weekly structure in bulk from the shared syllabus and permission tracking spreadsheet (CSV), and export it back.                                                                                                                                             | PHYS 101 syllabus mapping; permission tracking sheet                        |

## B. Non-Functional Requirements (how well the platform must work)

| **ID** | **Requirement**       | **Target / Measure**                                                                                                                                  |
|--------|-----------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| NFR-1  | Responsive design     | Usable on phone, tablet and desktop screen sizes                                                                                                      |
| NFR-2  | Performance           | Course pages load in about 2 seconds or less on a normal campus connection                                                                            |
| NFR-3  | Security and privacy  | HTTPS only; restricted files kept in private storage and opened through short-lived signed links; no student data collected beyond the sign-in e-mail |
| NFR-4  | Permission compliance | No material is published without a matching record in the permission tracking sheet                                                                   |
| NFR-5  | Accessibility         | Readable colour contrast, alternative text for images, keyboard navigation (WCAG 2.1 AA as the target)                                                |
| NFR-6  | Maintainability       | Course content is stored as structured data, so a new course can be added without changing the code                                                   |
| NFR-7  | Cost                  | Prototype runs on free tiers of the chosen services                                                                                                   |

## C. Proposed Technology Stack

| **Layer**          | **Proposed choice**                                                       | **Reason**                                                                                       |
|--------------------|---------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| Development method | Claude Code (AI-assisted development), Git and GitHub for version control | Chosen in Week 2; lets both CE members work on the same codebase and review each other’s changes |
| Frontend           | Next.js (React) with TypeScript and Tailwind CSS                          | Reusable components fit the flexible weekly module; easy to make responsive                      |
| Database           | Supabase (PostgreSQL)                                                     | Relational structure fits the course → week → material hierarchy                                 |
| Authentication     | Supabase Auth, limited to @agu.edu.tr e-mail addresses                    | Needed for restricted materials (FR-5)                                                           |
| File storage       | Supabase Storage with one public and one private bucket                   | Separates open materials from restricted ones (NFR-3)                                            |
| Hosting            | Vercel (free tier)                                                        | Simple deployment directly from GitHub; free for a prototype                                     |

## D. Content Data Structure

To organise the materials collected by the team, the platform will store
content in four connected levels:

**• Department:** name (e.g., Physics, Molecular Biology and Genetics).

**• Course:** course code, title, department, instructor, short
description and sharing mode (full, AGU-only or syllabus-only).

**• Week:** week number, main topic, subtopics and learning objectives.

**• Material:** title, type, section (instructor / lab / OER), link or
file, source, licence or permission note, and visibility (public,
AGU-only or hidden).

This structure matches the shared course information and permission
tracking sheet, so the data collected this week can be imported directly
into the platform in Week 3.

