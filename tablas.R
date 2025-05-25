library(tibble)
library(readr)


# Educación ---------------------------------------------------------------



educacion <- tibble::tribble(
  ~degree, ~start, ~end, ~institution, ~location, ~detail,
  
  "Master’s Degree in Statistical Information Generation and Analysis", "2021-03-01", NA, 
  "National University of Tres de Febrero", "Buenos Aires, Argentina", 
  "Graduate-level training in quantitative methods, statistical modeling, survey design, and public policy evaluation. Thesis in progress.",
  
  "Licenciatura in Political Science (Equivalent to a Master’s Degree)", "2016-03-01", "2020-12-01", 
  "National University of La Matanza", "Buenos Aires, Argentina", 
  "Five-year degree combining advanced coursework and research. Considered equivalent to a Master's degree in international academic systems.",
  
  "Specialization in Satellite Image Remote Sensing and GIS", "2024-03-01", NA, 
  "National University of Luján", "Buenos Aires, Argentina", 
  "Postgraduate specialization in geospatial technologies and satellite data analysis."
)

readr::write_csv(educacion, "data/education.csv")



# Cursos ------------------------------------------------------------------


professional_training <- tibble::tribble(
  ~title, ~start, ~end, ~institution, ~location, ~detail,
  
  "Graduate Certificate in Computational Social Sciences", "2023-03-01", "2023-12-01",
  "Universidad Nacional Guillermo Brown", "Buenos Aires, Argentina",
  "Data science methods applied to social research.",
  
  "Graduate Certificate in Archiving and Document Management", "2023-03-01", "2023-12-01",
  "National University of Tres de Febrero", "Buenos Aires, Argentina",
  "Digital archiving and records management for public institutions.",
  
  "Graduate Certificate in Open Government and Public Innovation", "2023-03-01", "2023-12-01",
  "National University of Rosario", "Santa Fe, Argentina",
  "Transparency, civic tech, and public sector innovation."
  # 
  # "Statistical Inference in R", "2021-06-01", "2021-09-01",
  # "Universidad Nacional de Quilmes", "Buenos Aires, Argentina",
  # "Hands-on training in statistical modeling with R.",
  # 
  # "Introduction to Data Science", "2021-03-01", "2021-06-01",
  # "Universidad Nacional de San Martín", "Buenos Aires, Argentina",
  # "Fundamentals of data science and dashboarding with Power BI.",
  # 
  # "Introduction to Python", "2021-01-01", "2021-03-01",
  # "IEEE & Instituto Tecnológico de Buenos Aires", "Buenos Aires, Argentina",
  # "Programming fundamentals with Python."
)


readr::write_csv(professional_training, "data/professional_training.csv")



# Publicaciones -----------------------------------------------------------



publications <- tibble::tribble(
  ~type, ~title, ~coauthors, ~date, ~detail,
  
  "Conference paper", 
  "Strategies and Procedures for Protecting Personal Data in Products Containing Health Information",
  "María Cecilia Palermo, María Belén Islas, María Nanton, Sabrina Palermo y Ariana Bardauil", 
  "2024-11-01",
  "Presented at IDS-JAIO 2024. Focused on data protection strategies for healthcare-related information systems.",
  
  "Conference paper", 
  "Experiences Using R to Automate Administrative Procedures", 
  "Manuel Rodriguez Tablado, María Cristina Nanton, Ariana Bardauil", 
  "2024-08-01", 
  "Presented at LatinR 2024. Described the application of R in the automation of administrative processes in public health.",
  
  "Conference presentation", 
  "Discourse Analysis on Insecurity among Presidential Candidates and Digital Media in Argentina (2022–2023)", 
  "Joaquín Lovizio Ramos, Santiago Marta, Ariana Bardauil", 
  "2023-09-01", 
  "Presented at the National Conference of Political Science (SAAP 2023).",
  
  "Conference presentation", 
  "Discourse Analysis on Education among Presidential Candidates and Digital Media in Argentina (2022–2023)", 
  "Joaquín Lovizio Ramos, Ariana Bardauil, Manuel Iglesias", 
  "2023-09-01", 
  "Presented at the Sociology Conference (UBA 2023).",
  
  "Conference presentation", 
  "A Digital Lens on Congressional Candidates in Buenos Aires Province and CABA", 
  "Joaquín Lovizio Ramos, Manuel Iglesias, Ariana Bardauil", 
  "2021-11-01", 
  "Presented at the National Conference of Political Science (SAAP & UNR 2021). Applied web scraping and data mining techniques to digital media.",
  
  "Technical report", 
  "Evaluation of the Active Transparency Index Methodology", 
  " Emiliano Arena, Ariana Bardauil,Catalina Byrne.", 
  "2023-04-01", 
  "Public report published by the Agency for Access to Public Information (AAIP).",
  
  "Technical report", 
  "Perceptions of Public Information Access Officers", 
  "Emiliano Arena; Catalina Byrne; Mariana Sánchez; Matías Ramiro Sumavil; Ariana Bardauil.", 
  "2023-09-01", 
  "AAIP publication based on surveys of information access officers.",
  
  "Technical report", 
  "Federal Guide to Transparency", 
  "Ariana Bardauil, Catalina Byrne, Gonzalo Castro, Sara Iuliano, Estefanía Pinetta Biro Alemán, Lorena Salim. ", 
  "2023-11-01", 
  "Policy guide developed for public sector institutions.",
  
  "Conference paper", 
  "Public Sector Employment in the Context of the Pandemic", 
  "Mauro Chilliuti, Gabriela Gutierrez, Ariana Bardauil", 
  "2021-11-21", 
  "Presented at the XVI International CLAD Congress on State Reform and Public Administration.",
  
  "Book chapter", 
  "Changes and Continuities in Argentina's Ministry of Social Development (2015–2019) during the Cambiemos Administration",
  "Guadalupe Mercado, Ariana Bardauil",
  "2022-01-01",
  "In Casalis, A. & Ferrari Mango, C. (Eds.), Transformations in the Structure of the State under the Cambiemos Government (2015–2019). Chapter 5, pp. 110–137. National University of La Matanza.",

  "Technical report",
  "Potenciar Trabajo: Relational Perspectives on Concepts and Numbers for Understanding its Structure",
  "Cynthia Ferrari Mango, Ariana Bardauil",
  "2023-12-12",
  "Observatorio sobre Políticas Públicas y Reforma Estructural, Report No. 42, FLACSO Argentina."
  
  )

# Guardar como CSV si querés
write_csv(publications, "data/publications.csv")


# Experiencia laboral -----------------------------------------------------



experiencia_laboral <- tibble::tribble(
  ~position, ~start, ~end, ~organization, ~location, ~description1, ~description2,
  
  "Senior Data Analyst", "2023-01-01", NA, 
  "Ministry of Health – Buenos Aires City Government", "Buenos Aires, Argentina", 
  "Member of the Professional Specialists Program (competitive position). Co-designing a public policy to integrate artificial intelligence into administrative processes of the Ministry of Health.", 
  "Development of dashboards and visualizations in Quarto and Shiny. Data analysis and automation of health information processes using R, Python, and SQL.",
  
  "Data Analyst", "2022-01-01", "2023-01-01", 
  "Agency for Access to Public Information - National Government", "Buenos Aires, Argentina", 
  "Responsible for the Active Transparency Index.Data processing and visualization with R, RMarkdown, Flourish, and Metabase.", 
  "Participated in the Archives and Records Management Program. Contributed to the development of public policies on information access, personal data protection, and digital recordkeeping standards for national institutions.",
  
  "Employment Policy Advisor", "2020-03-01", "2022-01-01", 
  "Undersecretariat for Public Employment – National Government", "Buenos Aires, Argentina", 
  "Led HR and staffing surveys. Co-authored research on public employment during the pandemic.", 
  "Produced both qualitative and quantitative reports to support employment policies."
)

# Guardar como CSV si lo necesitás
write_csv(experiencia_laboral, "data/experiencia_laboral.csv")


# Docencia ----------------------------------------------------------------



teaching_experience <- tibble::tribble(
  ~position, ~start, ~end, ~institution, ~location, ~description,
  
  "Adjunct Professor", "2025-03-01", NA,
  "University of Flores", "Buenos Aires, Argentina",
  "Course: Text Mining applied to Social Research. Focused on computational text analysis methods for political and social sciences.",
  
  "Teaching Assistant (JTP)", "2024-03-01", NA,
  "National University of La Matanza", "Buenos Aires, Argentina",
  "Course: Demography. Teaching support in quantitative demographic analysis for Political Science undergraduate students."
)

# Opcional: guardar CSV
write_csv(teaching_experience, "data/teaching_experience.csv")




# Investigación -----------------------------------------------------------

investigacion <- tibble::tribble(
  ~role, ~start, ~end, ~project, ~institution, ~location, ~description,
  
  "Principal Investigator", "2023-01-01", "2024-12-01",
  "Territorial Dynamics of Social Programs in Greater Buenos Aires",
  "National University of La Matanza", "Buenos Aires, Argentina",
  "Research on the interaction between national, municipal, and grassroots actors in the distribution and implementation of social policies.",
  
  "Researcher", "2021-01-01", "2022-12-01",
  "Transformations in the Structure of National Public Administration",
  "National University of La Matanza", "Buenos Aires, Argentina",
  "Analyzed public management models and intergovernmental relations during the 2015–2019 government period.",
  
  "Research Fellow (PROINCE)", "2018-01-01", "2018-12-01",
  "Radical Democracy and Populism: An Interdisciplinary Theoretical Analysis",
  "National University of La Matanza", "Buenos Aires, Argentina",
  "Awarded PROINCE scholarship. Participated in theoretical research on political discourse and democratic theory.",
  
  "Research Fellow (CyTMA2)", "2017-01-01", "2017-12-01",
  "Knowledge Management and Learning in Public Administration: The Case of Buenos Aires Province",
  "National University of La Matanza", "Buenos Aires, Argentina",
  "Participated in an institutional research project on knowledge transfer and learning within public management structures.",
  
  "Researcher", "2025-01-01", "2026-12-31",
  "The Construction of Local Socio-Community Spaces through Social Programs Linked to Municipalities and Organizations",
  "National University of La Matanza", "Buenos Aires, Argentina",
  "Research project under the CyTMA2 program, focused on analyzing how social programs contribute to the development of local community-based spaces involving municipal governments and civil society organizations."
  
)

# Guardar como CSV si querés
write_csv(investigacion, "data/investigacion.csv")



# Skills ------------------------------------------------------------------


skills <- tibble::tribble(
  ~area, ~skills,
  
  "Languages", "Spanish (Native), English (Upper Intermediate)",
  "Programming Languages", "R, Python, SQL",
  "Markup & Document Languages", "RMarkdown, Quarto, LaTeX, Markdown, Typst",
  "Data Visualization Tools", "Shiny, Flourish, Metabase, Power BI",
  "Geospatial Tools", "QGIS, Google Earth Engine",
  "Other", "Git, GitHub, Google Workspace, MS Office"
)

write_csv(skills, "data/skills.csv")
