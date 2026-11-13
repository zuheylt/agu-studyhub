# AGU StudyHub

An MIT OpenCourseWare-style platform that gives Abdullah Gül University students one place to find instructor-approved course materials, syllabi and open educational resources (OER), organised course by course and week by week.

Class project, **Group 8**:

| Member | Discipline | Role |
|---|---|---|
| Akın Aslanoğlu | Computer Engineering | Technical lead: platform and tools |
| Züheyr Temel | Computer Engineering | Technical lead: content structure and data |
| Furkan Emre Altun | Architecture | Design lead: UI/UX |
| Merve Nida Yeniçeri | Molecular Biology and Genetics | Content research and instructor communication |

## Status

Week 2: requirements defined, stack proposed. Week 3: first working version (PHYS 101 course page).

## Proposed stack

| Layer | Choice |
|---|---|
| Development | Claude Code, Git/GitHub |
| Frontend | Next.js (React) + TypeScript + Tailwind CSS |
| Database | Supabase (PostgreSQL) |
| Auth | Supabase Auth, restricted to `@agu.edu.tr` |
| Storage | Supabase Storage: public bucket + private bucket |
| Hosting | Vercel (free tier) |

## Repository layout

```
docs/requirements.md   Functional / non-functional requirements (FR-1…FR-10, NFR-1…NFR-7)
supabase/schema.sql    Starter database schema: department → course → week → material
```

## Material permissions

Instructors set different conditions for sharing. **Never commit course files (slides, PDFs, videos) to this repository.** Uploaded materials go into Supabase Storage, and restricted ones go into the private bucket only. Every published material must have a matching entry in the team's permission tracking sheet (NFR-4).
