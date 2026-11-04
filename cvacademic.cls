% =============================================================================
% cvacademic.cls: Academic CV Document Class
% =============================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{cvacademic}[2026/10/30 v1.0 Academic CV]

% -----------------------------------------------------------------------------
% Class options
% -----------------------------------------------------------------------------
\DeclareOption{10pt}{\PassOptionsToClass{10pt}{article}}
\DeclareOption{11pt}{\PassOptionsToClass{11pt}{article}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ExecuteOptions{11pt}
\ProcessOptions\relax
\LoadClass{article}

% -----------------------------------------------------------------------------
% Required packages
% -----------------------------------------------------------------------------
\RequirePackage[T1]{fontenc}
\RequirePackage{newtxtext}
\RequirePackage{geometry}
\RequirePackage{microtype}
\RequirePackage{xcolor}
\RequirePackage{titlesec}
\RequirePackage{enumitem}
\RequirePackage{setspace}
\RequirePackage{graphicx}
\RequirePackage{etoolbox} % \ifdefempty, \ifdefstring
\RequirePackage[hidelinks,unicode,pdfborder={0 0 0}]{hyperref}
\RequirePackage{fontawesome5}


% -----------------------------------------------------------------------------
% Default dimensions and margins
% -----------------------------------------------------------------------------
\geometry{
  letterpaper,
  margin=0.75in,
  top=0.65in,
  bottom=0.65in
}

% -----------------------------------------------------------------------------
% Spacing parameters
% -----------------------------------------------------------------------------
\newcommand{\cvsectionsep}{0.55em}
\newcommand{\cvitemsep}{0.25em}
\newcommand{\cvlistsep}{0.12em}
\setlength{\parskip}{0pt}
\setlength{\parindent}{0pt}
\setstretch{1.02}

% -----------------------------------------------------------------------------
% Color palette 
% -----------------------------------------------------------------------------
\definecolor{cvprimary}{HTML}{1F3A5F}
\definecolor{cvsecondary}{HTML}{4A5568}
\definecolor{cvaccent}{HTML}{2B6CB0}
\definecolor{cvlight}{HTML}{718096}
\definecolor{cvrule}{HTML}{CBD5E0}

% -----------------------------------------------------------------------------
% Hyperlink styling
% -----------------------------------------------------------------------------
\hypersetup{
  colorlinks=true,
  linkcolor=cvaccent,
  urlcolor=cvaccent,
  citecolor=cvaccent
}

% -----------------------------------------------------------------------------
% List formatting
% -----------------------------------------------------------------------------
\setlist[itemize]{
  leftmargin=1.35em,
  topsep=\cvlistsep,
  itemsep=\cvlistsep,
  parsep=0pt,
  partopsep=0pt,
  label=\textbullet
}

% -----------------------------------------------------------------------------
% Section headings — thin rule, elegant spacing
% -----------------------------------------------------------------------------
\titleformat{\section}
  {\large\bfseries\color{cvprimary}}
  {}
  {0pt}
  {}
  [\vspace{-0.25em}{\color{cvrule}\titlerule[0.4pt]}\vspace{\cvsectionsep}]

\titlespacing*{\section}{0pt}{0.85em}{0.35em}

% -----------------------------------------------------------------------------
% \cvsection{style}{icon}{title}
%   style : "regular" for the outline version of the icon, or empty for solid
%   icon  : fontawesome5 icon name (e.g. graduation-cap), or empty for no icon
%   title : section title
% Icons sit in a fixed-width box so titles line up across sections.
% Icons are dropped from the PDF bookmarks via \texorpdfstring.
% Adjust \cvsectioniconwidth for a wider or narrower alignment column.
% -----------------------------------------------------------------------------
\newlength{\cvsectioniconwidth}
\setlength{\cvsectioniconwidth}{2.0em}

% \cvsectionicon{style}{icon}
\newcommand{\cvsectionicon}[2]{%
  \makebox[\cvsectioniconwidth][l]{%
    \ifblank{#1}%
      {\faIcon{#2}}%
      {\faIcon[#1]{#2}}%
  }%
}

\NewDocumentCommand{\cvsection}{m m m}{%
  \section{%
    \texorpdfstring{%
      \ifblank{#2}{}{\cvsectionicon{#1}{#2}}#3%
    }{#3}%
  }%
}

% -----------------------------------------------------------------------------
% Compact subsection within a section 
% -----------------------------------------------------------------------------
\newcommand{\cvsubsection}[1]{%
  \par\vspace{0.35em}%
  \noindent\textcolor{cvsecondary}{\textbf{#1}}\par\vspace{0.15em}%
}

% -----------------------------------------------------------------------------
% Internal helpers
% -----------------------------------------------------------------------------
\newbool{cv@firstlink}
\newcommand{\cvhref}[2]{\href{#1}{#2}}
\newcommand{\cvmail}[1]{\cvhref{mailto:#1}{#1}}
\newcommand{\cvsep}{\enspace\textbar\enspace}
\newcommand{\socialicon}[1]{\raisebox{-0.05em}{\resizebox{!}{1em}{#1}}}
\newcommand{\cvdateline}[2]{%
  \hfill\mbox{\textcolor{cvlight}{\small #1\ifdefempty{#2}{}{ \textbar\ #2}}}%
}
\newcommand{\cvsubline}[1]{\textcolor{cvsecondary}{\small #1}}
\newcommand{\cvtopicline}[1]{\textcolor{cvsecondary}{\small\textit{Topics: #1}}}
\newcommand{\cvstatus}[1]{\textcolor{cvaccent}{\small\textit{[#1]}}}
% icon size: change to \footnotesize or \scriptsize for even smaller icons
\newcommand{\entryiconsize}{\small}

% -----------------------------------------------------------------------------
% Header
% Usage (in header.tex, input after \begin{document}):
% \header{
%   name        : your name (large, with a thin rule under it)
%   phone       : phone number
%   email       : email address
%   website     : displayed text, e.g. yourwebsite.com (link: https://<value>)
%   linkedin    : profile id, e.g. your-profile
%   github      : user name, e.g. your-username
%   bitbucket   : user name, e.g. your-username
%   scholar     : Google Scholar user id
%   orcid       : ORCID id (e.g. 0000-0000-0000-0000)
%   location    : last line, with a map marker
%   pdftitle, pdfsubject, pdfkeywords : PDF metadata (author = name)
% }
% All keys are optional; empty items and their separators are skipped.
% -----------------------------------------------------------------------------
\ExplSyntaxOn
\keys_define:nn { hdr }
  {
    name        .code:n = { \def\hdr@name{#1} },
    email       .code:n = { \def\hdr@email{#1} },
    phone       .code:n = { \def\hdr@phone{#1} },
    location    .code:n = { \def\hdr@location{#1} },
    website     .code:n = { \def\hdr@website{#1} },
    github      .code:n = { \def\hdr@github{#1} },
    bitbucket   .code:n = { \def\hdr@bitbucket{#1} },
    linkedin    .code:n = { \def\hdr@linkedin{#1} },
    scholar     .code:n = { \def\hdr@scholar{#1} },
    orcid       .code:n = { \def\hdr@orcid{#1} },
    pdftitle    .code:n = { \def\hdr@pdftitle{#1} },
    pdfsubject  .code:n = { \def\hdr@pdfsubject{#1} },
    pdfkeywords .code:n = { \def\hdr@pdfkeywords{#1} },
  }
\cs_new_eq:NN \hdrsetkeys \keys_set:nn
\ExplSyntaxOff

% \hdr@item{macro to test}{content}: separator before every item except the
% first in the line; skipped entirely if the macro is empty
\newcommand{\hdr@item}[2]{%
  \ifdefempty{#1}{}{%
    \ifbool{cv@firstlink}{\boolfalse{cv@firstlink}}{\cvsep}%
    #2%
  }%
}

\NewDocumentCommand{\header}{+m}{%
  % reset every field so values don't leak between calls
  \def\hdr@name{}\def\hdr@email{}\def\hdr@phone{}\def\hdr@location{}%
  \def\hdr@website{}\def\hdr@github{}\def\hdr@linkedin{}%
  \def\hdr@scholar{}\def\hdr@orcid{}\def\hdr@bitbucket{}%
  \def\hdr@pdftitle{Curriculum Vitae}%
  \def\hdr@pdfsubject{Academic Curriculum Vitae}%
  \def\hdr@pdfkeywords{curriculum vitae, academic cv}%
  \hdrsetkeys{hdr}{#1}%
  % PDF metadata
  \hypersetup{
    pdftitle    = {\hdr@pdftitle},
    pdfauthor   = {\hdr@name},
    pdfsubject  = {\hdr@pdfsubject},
    pdfkeywords = {\hdr@pdfkeywords}
  }%
  % name, with thin rule underneath
  \ifdefempty{\hdr@name}{}{%
    {\centering
     {\fontsize{22}{26}\selectfont\bfseries\color{cvprimary} \hdr@name}\\[0.45em]
     {\color{cvrule}\rule{0.42\textwidth}{0.6pt}}\par}%
    \vspace{0.55em}%
  }%
  % contact line: phone | email | website
  \edef\hdr@tmp{\hdr@phone\hdr@email\hdr@website}%
  \ifdefempty{\hdr@tmp}{}{%
    \booltrue{cv@firstlink}%
    {\centering\small\color{cvsecondary}%
      \hdr@item{\hdr@phone}{\socialicon{\faIcon{phone}}\enspace\hdr@phone}%
      \hdr@item{\hdr@email}{\socialicon{\faIcon{envelope}}\enspace\cvmail{\hdr@email}}%
      \hdr@item{\hdr@website}{\socialicon{\faIcon{globe}}\enspace
        \cvhref{https://\hdr@website}{\hdr@website}}\par}%
    \vspace{0.35em}%
  }%
  % social line: LinkedIn | GitHub | Scholar | ORCID
  \edef\hdr@tmp{\hdr@linkedin\hdr@github\hdr@bitbucket\hdr@scholar\hdr@orcid}%
  \ifdefempty{\hdr@tmp}{}{%
    \booltrue{cv@firstlink}%
    {\centering\small\color{cvsecondary}%
      \hdr@item{\hdr@linkedin}{\socialicon{\faLinkedin}\enspace
        \cvhref{https://www.linkedin.com/in/\hdr@linkedin/}{\hdr@linkedin}}%
      \hdr@item{\hdr@github}{\socialicon{\faGithub}\enspace
        \cvhref{https://github.com/\hdr@github}{\hdr@github}}%
      \hdr@item{\hdr@bitbucket}{\socialicon{\faBitbucket}\enspace
        \cvhref{https://bitbucket.org/\hdr@bitbucket/workspace/overview}{\hdr@bitbucket}}%
      \hdr@item{\hdr@scholar}{\socialicon{\faIcon{graduation-cap}}\enspace
        \cvhref{https://scholar.google.com/citations?user=\hdr@scholar}{Scholar}}%
      \hdr@item{\hdr@orcid}{\socialicon{\faIcon{orcid}}\enspace
        \cvhref{https://orcid.org/\hdr@orcid}{ORCID}}\par}%
    \vspace{0.35em}%
  }%
  % location line
  \ifdefempty{\hdr@location}{}{%
    {\centering\small\color{cvlight}\socialicon{\faIcon{map-marker-alt}}\enspace\hdr@location\par}%
    \vspace{0.75em}%
  }%
}
% -----------------------------------------------------------------------------
% helper function: line splitter (for long lines)
% -----------------------------------------------------------------------------
\ExplSyntaxOn
\tl_new:N \entry@first
\tl_new:N \entry@rest
\seq_new:N \l__entry_words_seq
\seq_new:N \l__entry_lines_seq
\tl_new:N \l__entry_line_tl
\int_new:N \l__entry_len_int

% \entrysplittitle <macro holding the title> {max characters per line}
\cs_new_protected:Npn \entrysplittitle #1 #2
  {
    \tl_clear:N \entry@first
    \tl_clear:N \entry@rest
    \tl_clear:N \l__entry_line_tl
    \int_zero:N \l__entry_len_int
    \seq_clear:N \l__entry_lines_seq
    \seq_set_split:NnV \l__entry_words_seq { ~ } #1
    \seq_map_inline:Nn \l__entry_words_seq
      {
        \tl_if_empty:NTF \l__entry_line_tl
          {
            \tl_set:Nn \l__entry_line_tl {##1}
            \int_set:Nn \l__entry_len_int { \str_count:n {##1} }
          }
          {
            \int_compare:nNnTF
              { \l__entry_len_int + 1 + \str_count:n {##1} } > {#2}
              {
                % word does not fit: close the current line, start a new one
                \seq_put_right:NV \l__entry_lines_seq \l__entry_line_tl
                \tl_set:Nn \l__entry_line_tl {##1}
                \int_set:Nn \l__entry_len_int { \str_count:n {##1} }
              }
              {
                \tl_put_right:Nn \l__entry_line_tl { ~ ##1 }
                \int_add:Nn \l__entry_len_int { 1 + \str_count:n {##1} }
              }
          }
      }
    \seq_put_right:NV \l__entry_lines_seq \l__entry_line_tl
    % icons
    \tl_if_empty:NF \entry@righticons
      {
        \seq_pop_right:NN \l__entry_lines_seq \l_tmpa_tl
        \tl_put_right:Nn \l_tmpa_tl { \entryiconsright { \entry@righticons } }
        \seq_put_right:NV \l__entry_lines_seq \l_tmpa_tl
      }
    % first line goes beside the date/location, the others become \entry@rest
    \seq_pop_left:NN \l__entry_lines_seq \entry@first
    \seq_map_inline:Nn \l__entry_lines_seq
      { \tl_put_right:Nn \entry@rest {\noindent\textbf{##1}\par} }
  }
\ExplSyntaxOff
% -----------------------------------------------------------------------------
% General use entry. Title is bold, dates and location on the right
% Usage:
% \entry{
%  title       : First line in bold
%  subtitle    : Second line in normal text
%  credits     : Will appear next to the subtitle as X credits (or 1 credit)
%  section     : will apear next to the credits or subtitle as X sections
%  body        : Line in grey
%  bodytwo     : Second line in grey 
%  date        : can be single date or range (e.g. 2020 -- 2021}
%  dates       : same as date 
%  location    : location, appears after date as date|location top right
%  topic       : Appears as Topic: X
%  lefticons   : list of names of fontawesome5 icons to appear left of title
%  righticons  : list of names of fontawesome5 icons to appear right of title
%  github      = {https://github.com/user/repo},
%  bitbucket   = {https://bitbucket.org/taguilar/oneworld},
%  website     = {https://example.com},
%  docs        = {https://example.com/docs},
%  article     = {https://pubs.acs.org/doi/10.1021/acs.analchem.6b04512},
%  items       = {
%    \begin{itemize}
%      \item First item in normal font.
%      \item Second item in normal font
%    \end{itemize}
%  },
%}
% -----------------------------------------------------------------------------
\ExplSyntaxOn
\keys_define:nn { entry }
  {
    title       .code:n = { \def\entry@title{#1} },
    subtitle    .code:n = { \def\entry@subtitle{#1} },
    credits     .code:n = { \def\entry@credits{#1} },
    section     .code:n = { \def\entry@section{#1} },
    sections    .code:n = { \def\entry@section{#1} },   % alias of section
    body        .code:n = { \def\entry@body{#1} },
    bodytwo     .code:n = { \def\entry@bodytwo{#1} },
    date        .code:n = { \def\entry@date{#1} },
    dates       .code:n = { \def\entry@date{#1} },   % alias of date
    location    .code:n = { \def\entry@location{#1} },
    topic       .code:n = { \def\entry@topic{#1} },
    lefticons   .code:n = { \def\entry@lefticons{#1} },
    lefticon    .code:n = { \def\entry@lefticons{#1} }, % alias of lefticons
    icon        .code:n = { \def\entry@lefticons{#1} },   % alias of lefticons
    righticons  .code:n = { \def\entry@righticons{#1} },
    righticon   .code:n = { \def\entry@righticons{#1} }, % alias of rightticons
    items       .code:n = { \def\entry@items{#1} },
    website     .code:n = { \def\entry@website{#1} },
    bitbucket   .code:n = { \def\entry@bitbucket{#1} },
    github      .code:n = { \def\entry@github{#1} },
    article     .code:n = { \def\entry@article{#1} },
    docs        .code:n = { \def\entry@docs{#1} },
  }
\cs_new_eq:NN \entrysetkeys \keys_set:nn
\ExplSyntaxOff

% icons to left and/or right of title (list of fontawesome5 names)
\ExplSyntaxOn
\clist_new:N \l__entry_icons_clist

% each icon followed by a space (used before the title)
\NewDocumentCommand{\entryiconsleft}{m}
  {
    \clist_set:Nx \l__entry_icons_clist {#1}
    \clist_map_inline:Nn \l__entry_icons_clist
      { {\entryiconsize\faIcon{##1}}\enspace }
  }
% each icon preceded by a space (used after the title)
\NewDocumentCommand{\entryiconsright}{m}
  {
    \clist_set:Nx \l__entry_icons_clist {#1}
    \clist_map_inline:Nn \l__entry_icons_clist
      { \enspace{\entryiconsize\faIcon{##1}} }
  }
\ExplSyntaxOff

%icons at bottom
\newif\ifentry@firstlink

% \entry@link{icon name}{label}{macro holding the URL}
\newcommand{\entry@link}[3]{%
  \ifdefempty{#3}{}{%
    \ifentry@firstlink
      \entry@firstlinkfalse
      \par\noindent
    \else
      \ \textbar\ %
    \fi
    \cvhref{#3}{\faIcon{#1}\enspace #2}%
  }%
}

\NewDocumentCommand{\entry}{+m}{%
  % reset every field so values don't leak between entries
  \def\entry@title{}\def\entry@subtitle{}%
  \def\entry@credits{}\def\entry@section{}\def\entry@lefticons{}%
  \def\entry@righticons{}\def\entry@date{}\def\entry@location{}%
  \def\entry@body{}\def\entry@bodytwo{}\def\entry@topic{}\def\entry@items{}%
  \def\entry@website{}\def\entry@bitbucket{}\def\entry@github{}%
  \def\entry@article{}\def\entry@docs{}%
  \entrysetkeys{entry}{#1}%
  \par\vspace{\cvitemsep}%
  % title (split at 70 chars, avoid overlap with date), add icon if requested
  \entrysplittitle\entry@title{70}%
  \noindent
  \ifdefempty{\entry@lefticons}{}{\entryiconsleft{\entry@lefticons}}%
  \textbf{\entry@first}\cvdateline{\entry@date}{\entry@location}\par
  \entry@rest
  %\noindent\textbf{\entry@title}\cvdateline{\entry@date}{\entry@location}\par
  % subtitle line: add x credits (y sections)
  \ifdefempty{\entry@subtitle}{}{%
    \def\entry@subline{\entry@subtitle}%
    \ifdefempty{\entry@credits}{}{%
      \appto\entry@subline{, \entry@credits~credit}%
      \ifdefstring{\entry@credits}{1}{}{\appto\entry@subline{s}}%
    }%
    \ifdefempty{\entry@section}{}{%
      \appto\entry@subline{ (\entry@section~section}%
      \ifdefstring{\entry@section}{1}{}{\appto\entry@subline{s}}%
      \appto\entry@subline{)}%
    }%
    \entry@subline\par
  }%
  % body, links
  \ifdefempty{\entry@body}{}{\cvsubline{\entry@body}\par}%
  \ifdefempty{\entry@bodytwo}{}{\cvsubline{\entry@bodytwo}\par}%
  \ifdefempty{\entry@topic}{}{\par\cvtopicline{\entry@topic}}%
  \ifdefempty{\entry@items}{}{\vspace{0.1em}\entry@items}%
  \entry@firstlinktrue
  \entry@link{globe}{Website}{\entry@website}%
  \entry@link{bitbucket}{Bitbucket}{\entry@bitbucket}%
  \entry@link{github}{GitHub}{\entry@github}%
  \entry@link{file-alt}{Article}{\entry@article}%
  \entry@link{book}{Docs}{\entry@docs}%
  \ifentry@firstlink\else\par\fi
  \par\vspace{\cvitemsep}%
}
% -----------------------------------------------------------------------------
% Publication entry
% Usage: 
%% Journal article (type=article is the default)
%\publication{
%  authors = {\textbf{Y. Name}, J. Coauthor},
%  title   = {Rural Disparities in Cancer Stage at Diagnosis},
%  journal = {Journal of Rural Health},
%  year    = 2024, volume = 40, issue = 3, pages = {123--134},
%  doi     = {10.1111/jrh.12345},
%  url     = {https://someweb.com/mypaper}
%}
%
%% Report
%\publication{
%  type        = report,
%  authors     = {\textbf{Y. Name} and J. Coauthor},
%  title       = {Community Health Needs Assessment},
%  institution = {East Carolina University},
%  number      = {2024-07},
%  year        = 2024,
%  url         = {https://example.com/report.pdf},
%}
%
%% Conference paper
%\\publication{
%  type    = conference,
%  authors = {\textbf{Y. Name}},
%  title   = {Paper Title},
%  venue   = {Proceedings of the Annual Meeting},
%  pages   = {45--52},
%  year    = 2023,
%}
%
%% Preprint
%\publication{
%  type    = preprint,
%  authors = {\textbf{Y. Name}, J. Coauthor},
%  title   = {Paper Title},
%  journal = {medRxiv},
%  year    = 2025,
%  doi     = {10.1101/2025.01.01.123456},
%}
%% -----------------------------------------------------------------------------
\ExplSyntaxOn
\keys_define:nn { pub }
  {
    type        .code:n = { \def\pub@type{#1} },
    authors     .code:n = { \def\pub@authors{#1} },
    title       .code:n = { \def\pub@title{#1} },
    journal     .code:n = { \def\pub@journal{#1} },
    venue       .code:n = { \def\pub@journal{#1} },   % alias of journal
    institution .code:n = { \def\pub@institution{#1} },
    number      .code:n = { \def\pub@number{#1} },    % report number
    year        .code:n = { \def\pub@year{#1} },
    volume      .code:n = { \def\pub@volume{#1} },
    issue       .code:n = { \def\pub@issue{#1} },
    pages       .code:n = { \def\pub@pages{#1} },
    doi         .code:n = { \def\pub@doi{#1} },
    url         .code:n = { \def\pub@url{#1} },
    status      .code:n = { \def\pub@status{#1} },
  }
\cs_new_eq:NN \pubsetkeys \keys_set:nn
\ExplSyntaxOff

% \pub@link{icon name}{macro holding the URL}
\newcommand{\pub@link}[2]{%
  \ifdefempty{#2}{}{%
    \cvhref{#2}{\faIcon{#1}}%
  }%
}


\NewDocumentCommand{\publication}{m}{%
  % reset every field so values don't leak between entries
  \def\pub@type{article}%
  \def\pub@authors{}\def\pub@title{}\def\pub@journal{}%
  \def\pub@institution{}\def\pub@number{}\def\pub@year{}%
  \def\pub@volume{}\def\pub@issue{}\def\pub@pages{}%
  \def\pub@doi{}\def\pub@url{}\def\pub@status{}%
  \pubsetkeys{pub}{#1}%
  \ifdefempty{\pub@title}{\@latex@warning{\string\publication: no title given}}{}%
  \par\vspace{\cvitemsep}%
  % icons (at the end)
  \def\pub@icon{file-alt}%
  \ifdefstring{\pub@type}{report}{\def\pub@icon{file-invoice}}{}%
  \ifdefstring{\pub@type}{conference}{\def\pub@icon{users}}{}%
  \ifdefstring{\pub@type}{preprint}{\def\pub@icon{file-upload}}{}%
  %\noindent\faIcon{\pub@icon}\enspace %not at beginning
  % authors
  \ifdefempty{\pub@authors}{}{\pub@authors }%
  % title links to URL, else DOI, else plain text
  \ifdefempty{\pub@url}{%
    \ifdefempty{\pub@doi}%
      {``\pub@title''}%
      {``\cvhref{https://doi.org/\pub@doi}{\pub@title}''}%
  }{``\cvhref{\pub@url}{\pub@title}''}%
  \ifdefempty{\pub@status}{}{\ \cvstatus{\pub@status}}%
  % ---- type-specific middle section ----
  \ifdefstring{\pub@type}{report}{%
    \ifdefempty{\pub@institution}{}{\ \pub@institution}%
    \ifdefempty{\pub@number}{}{, report no.~\pub@number}%
  }{%
  \ifdefstring{\pub@type}{conference}{%
    \ifdefempty{\pub@journal}{}{\ In \textit{\pub@journal}}%
    \ifdefempty{\pub@pages}{}{, pp.~\pub@pages}%
  }{%
  \ifdefstring{\pub@type}{preprint}{%
    \ifdefempty{\pub@journal}{\ Preprint}{\textit{ \pub@journal}, preprint}%
  }{%
    % default: journal article, e.g. Journal Name 40(3), 123--134
    \ifdefempty{\pub@journal}{}{\textit{ \pub@journal}}%
    \ifdefempty{\pub@volume}{%
      \ifdefempty{\pub@issue}{}{\ (\pub@issue)}%
    }{%
      \ \pub@volume
      \ifdefempty{\pub@issue}{}{(\pub@issue)}%
    }%
    \ifdefempty{\pub@pages}{}{, \pub@pages}%
  }}}%
  % ---- common ending ----
  \ifdefempty{\pub@year}{}{ (\pub@year).}%
  \ifdefempty{\pub@doi}{}{\ \cvhref{https://doi.org/\pub@doi}{[DOI]}}%
  % link is icon
%  \ifdefempty{\pub@url}{}{\ \cvhref{\pub@url}{[Link]}}%
  \ifdefempty{\pub@url}{}{\ \pub@link{\pub@icon}{\pub@url}}%
  \par\vspace{\cvitemsep}%
}
