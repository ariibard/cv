// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}

#import "@preview/fontawesome:0.5.0": *

//------------------------------------------------------------------------------
// Style
//------------------------------------------------------------------------------

// const color
#let color-darknight = rgb("#131A28")
#let color-darkgray = rgb("#333333")
#let color-middledarkgray = rgb("#414141")
#let color-gray = rgb("#5d5d5d")
#let color-lightgray = rgb("#999999")

// Default style
#let color-accent-default = rgb("#dc3522")
#let font-header-default = ("Roboto", "Arial", "Helvetica", "Dejavu Sans")
#let font-text-default = ("Source Sans Pro", "Arial", "Helvetica", "Dejavu Sans")
#let align-header-default = center

// User defined style
#let color-accent = rgb("6a1f9a")
#let font-header = font-header-default
#let font-text = font-text-default

//------------------------------------------------------------------------------
// Helper functions
//------------------------------------------------------------------------------

// icon string parser

#let parse_icon_string(icon_string) = {
  if icon_string.starts-with("fa ") [
    #let parts = icon_string.split(" ")
    #if parts.len() == 2 {
      fa-icon(parts.at(1), fill: color-darknight)
    } else if parts.len() == 3 and parts.at(1) == "brands" {
      fa-icon(parts.at(2), font: "Font Awesome 6 Brands", fill: color-darknight)
    } else {
      assert(false, "Invalid fontawesome icon string")
    }
  ] else if icon_string.ends-with(".svg") [
    #box(image(icon_string))
  ] else {
    assert(false, "Invalid icon string")
  }
}

// contaxt text parser
#let unescape_text(text) = {
  // This is not a perfect solution
  text.replace("\\", "").replace(".~", ". ")
}

// layout utility
#let __justify_align(left_body, right_body) = {
  block[
    #box(width: 4fr)[#left_body]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

#let __justify_align_3(left_body, mid_body, right_body) = {
  block[
    #box(width: 1fr)[
      #align(left)[
        #left_body
      ]
    ]
    #box(width: 1fr)[
      #align(center)[
        #mid_body
      ]
    ]
    #box(width: 1fr)[
      #align(right)[
        #right_body
      ]
    ]
  ]
}

/// Right section for the justified headers
/// - body (content): The body of the right header
#let secondary-right-header(body) = {
  set text(
    size: 10pt,
    weight: "thin",
    style: "italic",
    fill: color-accent,
  )
  body
}

/// Right section of a tertiaty headers. 
/// - body (content): The body of the right header
#let tertiary-right-header(body) = {
  set text(
    weight: "light",
    size: 9pt,
    style: "italic",
    fill: color-gray,
  )
  body
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let justified-header(primary, secondary) = {
  set block(
    above: 0.7em,
    below: 0.7em,
  )
  pad[
    #__justify_align[
      #set text(
        size: 12pt,
        weight: "bold",
        fill: color-darkgray,
      )
      #primary
    ][
      #secondary-right-header[#secondary]
    ]
  ]
}

/// Justified header that takes a primary section and a secondary section. The primary section is on the left and the secondary section is on the right. This is a smaller header compared to the `justified-header`.
/// - primary (content): The primary section of the header
/// - secondary (content): The secondary section of the header
#let secondary-justified-header(primary, secondary) = {
  __justify_align[
     #set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    #primary
  ][
    #tertiary-right-header[#secondary]
  ]
}

//------------------------------------------------------------------------------
// Header
//------------------------------------------------------------------------------

#let create-header-name(
  firstname: "",
  lastname: "",
) = {
  
  pad(bottom: 5pt)[
    #block[
      #set text(
        size: 32pt,
        style: "normal",
        font: (font-header),
      )
      #text(fill: color-gray, weight: "thin")[#firstname]
      #text(weight: "bold")[#lastname]
    ]
  ]
}

#let create-header-position(
  position: "",
) = {
  set block(
      above: 0.75em,
      below: 0.75em,
    )
  
  set text(
    color-accent,
    size: 9pt,
    weight: "regular",
  )
    
  smallcaps[
    #position
  ]
}

#let create-header-address(
  address: ""
) = {
  set block(
      above: 0.75em,
      below: 0.75em,
  )
  set text(
    color-lightgray,
    size: 9pt,
    style: "italic",
  )

  block[#address]
}

#let create-header-contacts(
  contacts: (),
) = {
  let separator = box(width: 2pt)
  if(contacts.len() > 1) {
    block[
      #set text(
        size: 9pt,
        weight: "regular",
        style: "normal",
      )
      #align(horizon)[
        #for contact in contacts [
          #set box(height: 9pt)
          #box[#parse_icon_string(contact.icon) #link(contact.url)[#contact.text]]
          #separator
        ]
      ]
    ]
  }
}

#let create-header-info(
  firstname: "",
  lastname: "",
  position: "",
  address: "",
  contacts: (),
  align-header: center
) = {
  align(align-header)[
    #create-header-name(firstname: firstname, lastname: lastname)
    #create-header-position(position: position)
    #create-header-address(address: address)
    #create-header-contacts(contacts: contacts)
  ]
}

#let create-header-image(
  profile-photo: ""
) = {
  if profile-photo.len() > 0 {
    block(
      above: 15pt,
      stroke: none,
      radius: 9999pt,
      clip: true,
      image(
        fit: "contain",
        profile-photo
      )
    ) 
  }
}

#let create-header(
  firstname: "",
  lastname: "",
  position: "",
  address: "",
  contacts: (),
  profile-photo: "",
) = {
  if profile-photo.len() > 0 {
    block[
      #box(width: 5fr)[
        #create-header-info(
          firstname: firstname,
          lastname: lastname,
          position: position,
          address: address,
          contacts: contacts,
          align-header: left
        )
      ]
      #box(width: 1fr)[
        #create-header-image(profile-photo: profile-photo)
      ]
    ]
  } else {
    
    create-header-info(
      firstname: firstname,
      lastname: lastname,
      position: position,
      address: address,
      contacts: contacts,
      align-header: center
    )

  }
}

//------------------------------------------------------------------------------
// Resume Entries
//------------------------------------------------------------------------------

#let resume-item(body) = {
  set text(
    size: 10pt,
    style: "normal",
    weight: "light",
    fill: color-darknight,
  )
  set par(leading: 0.65em)
  set list(indent: 1em)
  body
}

#let resume-entry(
  title: none,
  location: "",
  date: "",
  description: ""
) = {
  pad[
    #justified-header(title, location)
    #secondary-justified-header(description, date)
  ]
}

//------------------------------------------------------------------------------
// Data to Resume Entries
//------------------------------------------------------------------------------

#let data-to-resume-entries(
  data: (),
) = {
  let arr = if type(data) == dictionary { data.values() } else { data }
  for item in arr [
    #resume-entry(
      title: if "title" in item { item.title } else { none },
      location: if "location" in item { item.location } else { none },
      date: if "date" in  item { item.date } else { none },
      description: if "description" in item { item.description } else { none }
    )
    #if "details" in item {
      resume-item[
        #for detail in item.details [
          - #detail
        ]
      ]
    }
  ]
}


//------------------------------------------------------------------------------
// Resume Template
//------------------------------------------------------------------------------

#let resume(
  title: "CV",
  author: (:),
  date: datetime.today().display("[month repr:long] [day], [year]"),
  profile-photo: "",
  body,
) = {
  
  set document(
    author: author.firstname + " " + author.lastname,
    title: title,
  )
  
  set text(
    font: (font-text),
    size: 11pt,
    fill: color-darkgray,
    fallback: true,
  )
  
  set page(
    paper: "a4",
    margin: (left: 15mm, right: 15mm, top: 10mm, bottom: 10mm),
    footer: context [
      #set text(
        fill: gray,
        size: 8pt,
      )
      #__justify_align_3[
        #smallcaps[#date]
      ][
        #smallcaps[
          #author.firstname
          #author.lastname
          #sym.dot.c
          CV
        ]
      ][
        #counter(page).display()
      ]
    ],
  )
  
  // set paragraph spacing

  set heading(
    numbering: none,
    outlined: false,
  )
  
  show heading.where(level: 1): it => [
    #set block(
      above: 1.5em,
      below: 1em,
    )
    #set text(
      size: 16pt,
      weight: "regular",
    )
    
    #align(left)[
      #text[#strong[#text(color-accent)[#it.body.text.slice(0, 3)]#text(color-darkgray)[#it.body.text.slice(3)]]]
      #box(width: 1fr, line(length: 100%))
    ]
  ]
  
  show heading.where(level: 2): it => {
    set text(
      color-middledarkgray,
      size: 12pt,
      weight: "thin"
    )
    it.body
  }
  
  show heading.where(level: 3): it => {
    set text(
      size: 10pt,
      weight: "regular",
      fill: color-gray,
    )
    smallcaps[#it.body]
  }
  
  // Contents
  create-header(firstname: author.firstname,
                lastname: author.lastname,
                position: author.position,
                address: author.address,
                contacts: author.contacts,
                profile-photo: profile-photo,)
  body
}


// Typst custom formats typically consist of a 'typst-template.typ' (which is
// the source code for a typst template) and a 'typst-show.typ' which calls the
// template's function (forwarding Pandoc metadata values as required)
//
// This is an example 'typst-show.typ' file (based on the default template  
// that ships with Quarto). It calls the typst function named 'article' which 
// is defined in the 'typst-template.typ' file. 
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-template.typ' entirely. You can find
// documentation on creating typst templates here and some examples here:
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#show: resume.with(
  title: [Ariana Bardauil's CV],
  author: (
    firstname: unescape_text("Ariana"),
    lastname: unescape_text("Bardauil"),
    address: unescape_text("Buenos Aires, Argentina"),
    position: unescape_text("Data Scientist・Political Science"),
    contacts: ((
      text: unescape_text("arianabardauil\@gmail.com"),
      url: unescape_text("mailto:arianabardauil\@gmail.com"),
      icon: unescape_text("fa envelope"),
    ), (
      text: unescape_text("my portfolio"),
      url: unescape_text("https:\/\/ariibard.github.io"),
      icon: unescape_text("assets/icon/bi-house-fill.svg"),
    ), (
      text: unescape_text("GitHub"),
      url: unescape_text("https:\/\/github.com/ariibard"),
      icon: unescape_text("fa brands github"),
    ), (
      text: unescape_text("LinkedIn"),
      url: unescape_text("https:\/\/linkedin.com/in/ariana-bardauil"),
      icon: unescape_text("fa brands linkedin"),
    ), (
      text: unescape_text("+54 9 11 3051 1306"),
      url: unescape_text("ninguno"),
      icon: unescape_text("fa phone"),
    )),
  ),
)

= Education
<education>
#resume-entry(title: "Specialization in Satellite Image Remote Sensing and GIS",location: "Buenos Aires, Argentina",date: "mar 2024 - Present",description: "National University of Luján",)
#resume-item[
- Postgraduate specialization in geospatial technologies and satellite data analysis.
]
#resume-entry(title: "Master’s Degree in Statistical Information Generation and Analysis",location: "Buenos Aires, Argentina",date: "mar 2021 - Present",description: "National University of Tres de Febrero",)
#resume-item[
- Graduate-level training in quantitative methods, statistical modeling, survey design, and public policy evaluation. Thesis in progress.
]
#resume-entry(title: "Licenciatura in Political Science",location: "Buenos Aires, Argentina",date: "mar 2016 - dic 2020",description: "National University of La Matanza",)
#resume-item[
- Five-year degree combining advanced coursework and research. Considered equivalent to a Master's degree in international academic systems.
]
= Professional Training
<professional-training>
#resume-entry(title: "Graduate Certificate in Computational Social Sciences",location: "Buenos Aires, Argentina",date: "mar 2023 - dic 2023",description: "Universidad Nacional Guillermo Brown",)
#resume-entry(title: "Graduate Certificate in Archiving and Document Management",location: "Buenos Aires, Argentina",date: "mar 2023 - dic 2023",description: "National University of Tres de Febrero",)
#resume-entry(title: "Graduate Certificate in Open Government and Public Innovation",location: "Santa Fe, Argentina",date: "mar 2023 - dic 2023",description: "National University of Rosario",)
= Work experience
<work-experience>
#resume-entry(title: "Senior Data Analyst",location: "Buenos Aires, Argentina",date: "ene 2023 - Present",description: "Ministry of Health – Buenos Aires City Government",)
#resume-item[
- Member of the Professional Specialists Program (competitive position). Co-designing a public policy to integrate artificial intelligence into administrative processes of the Ministry of Health.
- Development of dashboards and visualizations in Quarto and Shiny. Data analysis and automation of health information processes using R, Python, and SQL.
]
#resume-entry(title: "Data Analyst",location: "Buenos Aires, Argentina",date: "ene 2022 - ene 2023",description: "Agency for Access to Public Information - National Government",)
#resume-item[
- Responsible for the Active Transparency Index.Data processing and visualization with R, RMarkdown, Flourish, and Metabase.
- Participated in the Archives and Records Management Program. Contributed to the development of public policies on information access, personal data protection, and digital recordkeeping standards for national institutions.
]
#resume-entry(title: "Employment Policy Advisor",location: "Buenos Aires, Argentina",date: "mar 2020 - ene 2022",description: "Undersecretariat for Public Employment – National Government",)
#resume-item[
- Led HR and staffing surveys. Co-authored research on public employment during the pandemic.
- Produced both qualitative and quantitative reports to support employment policies.
]
= Teaching experience
<teaching-experience>
#resume-entry(title: "Adjunct Professor",location: "Buenos Aires, Argentina",date: "mar 2025 - Present",description: "University of Flores",)
#resume-item[
- Course: Text Mining applied to Social Research. Focused on computational text analysis methods for political and social sciences.
]
#resume-entry(title: "Teaching Assistant (JTP)",location: "Buenos Aires, Argentina",date: "mar 2024 - Present",description: "National University of La Matanza",)
#resume-item[
- Course: Demography. Teaching support in quantitative demographic analysis for Political Science undergraduate students.
]
= Community Involvement
<community-involvement>
#strong[R en Buenos Aires -- Organizer & Instructor (2024 -- present)] \
#link("https://github.com/renbaires")[R en Buenos Aires] is a local data science community that promotes the use of R in Spanish-speaking academic, public sector, and civil society contexts. The group organizes regular workshops, talks, and collaborative study spaces,

#strong[Núcleo de Innovación Social -- Organizer (2023 -- present)] \
The #link("https://nucleodeinnovacionsocial.com.ar/")[Núcleo de Innovación Social] is a collective focused on the ethical, political, and methodological challenges of data use in the public sphere. It brings together professionals from government, academia, and activism to co-create visualizations, applied research, and public communication tools.

= Publications
<publications>
== Conference papers
<conference-papers>
#resume-entry(title: "Strategies and Procedures for Protecting Personal Data in Products Containing Health Information",date: "2024-11-01",description: "Presented at IDS-JAIO 2024. Focused on data protection strategies for healthcare-related information systems.",)
#resume-item[
- María Cecilia Palermo, María Belén Islas, María Nanton, Sabrina Palermo y Ariana Bardauil
]
#resume-entry(title: "Experiences Using R to Automate Administrative Procedures",date: "2024-08-01",description: "Presented at LatinR 2024. Described the application of R in the automation of administrative processes in public health.",)
#resume-item[
- Manuel Rodriguez Tablado, María Cristina Nanton, Ariana Bardauil
]
#resume-entry(title: "Public Sector Employment in the Context of the Pandemic",date: "2021-11-21",description: "Presented at the XVI International CLAD Congress on State Reform and Public Administration.",)
#resume-item[
- Mauro Chilliuti, Gabriela Gutierrez, Ariana Bardauil
]
== Technical reports
<technical-reports>
#resume-entry(title: "Evaluation of the Active Transparency Index Methodology",date: "2023-04-01",description: "Public report published by the Agency for Access to Public Information (AAIP).",)
#resume-item[
-  Emiliano Arena, Ariana Bardauil,Catalina Byrne.
]
#resume-entry(title: "Perceptions of Public Information Access Officers",date: "2023-09-01",description: "AAIP publication based on surveys of information access officers.",)
#resume-item[
- Emiliano Arena; Catalina Byrne; Mariana Sánchez; Matías Ramiro Sumavil; Ariana Bardauil.
]
#resume-entry(title: "Federal Guide to Transparency",date: "2023-11-01",description: "Policy guide developed for public sector institutions.",)
#resume-item[
- Ariana Bardauil, Catalina Byrne, Gonzalo Castro, Sara Iuliano, Estefanía Pinetta Biro Alemán, Lorena Salim. 
]
#resume-entry(title: "Potenciar Trabajo: Relational Perspectives on Concepts and Numbers for Understanding its Structure",date: "2023-12-12",description: "Observatorio sobre Políticas Públicas y Reforma Estructural, Report No. 42, FLACSO Argentina.",)
#resume-item[
- Cynthia Ferrari Mango, Ariana Bardauil
]
== Book Chapter
<book-chapter>
#resume-entry(title: "Changes and Continuities in Argentina's Ministry of Social Development (2015–2019) during the Cambiemos Administration",date: "2022-01-01",description: "In Casalis, A. & Ferrari Mango, C. (Eds.), Transformations in the Structure of the State under the Cambiemos Government (2015–2019). Chapter 5, pp. 110–137. National University of La Matanza.",)
#resume-item[
- Guadalupe Mercado, Ariana Bardauil
]
== Conference Presentations
<conference-presentations>
#resume-entry(title: "Discourse Analysis on Insecurity among Presidential Candidates and Digital Media in Argentina (2022–2023)",date: "2023-09-01",description: "Presented at the National Conference of Political Science (SAAP 2023).",)
#resume-item[
- Joaquín Lovizio Ramos, Santiago Marta, Ariana Bardauil
]
#resume-entry(title: "Discourse Analysis on Education among Presidential Candidates and Digital Media in Argentina (2022–2023)",date: "2023-09-01",description: "Presented at the Sociology Conference (UBA 2023).",)
#resume-item[
- Joaquín Lovizio Ramos, Ariana Bardauil, Manuel Iglesias
]
#resume-entry(title: "A Digital Lens on Congressional Candidates in Buenos Aires Province and CABA",date: "2021-11-01",description: "Presented at the National Conference of Political Science (SAAP & UNR 2021). Applied web scraping and data mining techniques to digital media.",)
#resume-item[
- Joaquín Lovizio Ramos, Manuel Iglesias, Ariana Bardauil
]
= Research Experience
<research-experience>
== Current
<current>
#resume-entry(title: "Researcher",location: "National University of La Matanza",date: "ene 2025 - dic 2026",description: "The Construction of Local Socio-Community Spaces through Social Programs Linked to Municipalities and Organizations",)
#resume-item[
- Research project under the CyTMA2 program, focused on analyzing how social programs contribute to the development of local community-based spaces involving municipal governments and civil society organizations.
]
== Previus
<previus>
#resume-entry(title: "Principal Investigator",location: "National University of La Matanza",date: "ene 2023 - dic 2024",description: "Territorial Dynamics of Social Programs in Greater Buenos Aires",)
#resume-item[
- Research on the interaction between national, municipal, and grassroots actors in the distribution and implementation of social policies.
]
#resume-entry(title: "Researcher",location: "National University of La Matanza",date: "ene 2021 - dic 2022",description: "Transformations in the Structure of National Public Administration",)
#resume-item[
- Analyzed public management models and intergovernmental relations during the 2015–2019 government period.
]
#resume-entry(title: "Research Fellow (PROINCE)",location: "National University of La Matanza",date: "ene 2018 - dic 2018",description: "Radical Democracy and Populism: An Interdisciplinary Theoretical Analysis",)
#resume-item[
- Awarded PROINCE scholarship. Participated in theoretical research on political discourse and democratic theory.
]
#resume-entry(title: "Research Fellow (CyTMA2)",location: "National University of La Matanza",date: "ene 2017 - dic 2017",description: "Knowledge Management and Learning in Public Administration: The Case of Buenos Aires Province",)
#resume-item[
- Participated in an institutional research project on knowledge transfer and learning within public management structures.
]
= Skills
<skills>
#resume-entry(title: "Languages",description: "Spanish (Native), English (Upper Intermediate)",)
#resume-entry(title: "Programming Languages",description: "R, Python, SQL",)
#resume-entry(title: "Markup & Document Languages",description: "RMarkdown, Quarto, LaTeX, Markdown, Typst",)
#resume-entry(title: "Data Visualization Tools",description: "Shiny, Flourish, Metabase, Power BI",)
#resume-entry(title: "Geospatial Tools",description: "QGIS, Google Earth Engine",)
#resume-entry(title: "Other",description: "Git, GitHub, Google Workspace, MS Office",)




