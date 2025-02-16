\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{gs-adonis}[2023/11/05 Adonis LaTeX article class]

% Import necessary packages
\RequirePackage{etoolbox}
\RequirePackage{tabularx}
\RequirePackage{xurl}

% Boolean options
\newbool{dark}
\boolfalse{dark}
\newbool{legacy}
\boolfalse{legacy}
\newbool{twocolumn}
\boolfalse{twocolumn}
\newbool{wide}
\boolfalse{wide}

% Declare class options
\DeclareOption{dark}{\booltrue{dark}}
\DeclareOption{legacy}{\booltrue{legacy}}
\DeclareOption{twocolumn}{
    \PassOptionsToClass{\CurrentOption}{article}
    \booltrue{twocolumn}
}
\DeclareOption{wide}{\booltrue{wide}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

% Process options and load base class
\ProcessOptions\relax
\LoadClass{article}

% Layout settings
\ifboolexpr{bool {twocolumn} or bool {wide}}{
    \def\margin{25mm}
}{
    \def\margin{35mm}
}
\RequirePackage[
    a4paper,
    twoside,
    bindingoffset=0.5cm,
    bottom=25mm,
    left=16mm,
    textheight=25cm,
    textwidth=12.50cm,
    marginparsep=0.50cm,
    marginparwidth=4.17cm,
    footskip=15mm,
    headsep=5mm
]{geometry}

% Dark mode settings
\ifbool{dark}{
    \RequirePackage{pagecolor}
    \RequirePackage{xcolor}

    \definecolor{DarkGrey}{HTML}{121212}

    \pagecolor{DarkGrey}
    \color{white}
}{}

% Column settings
\setlength{\columnsep}{10mm}

% Header and footer settings
\newcommand\runningauthor[1]{\gdef\@runningauthor{#1}}
\newcommand\runningtitle[1]{\gdef\@runningtitle{#1}}
\RequirePackage{fancyhdr}
\pagestyle{fancy}
\thispagestyle{empty} % not on first page
\lhead{\footnotesize \ifdefined\@runningauthor \@runningauthor \else \@author \fi}
\rhead{\footnotesize \ifdefined\@runningtitle \@runningtitle \else \@title \fi}
\cfoot{\footnotesize \thepage}

% Frontmatter commands
\newcommand\subtitle[1]{\gdef\@subtitle{#1}}
\newcommand\correspondence[1]{\gdef\@correspondence{#1}}
\newcommand\version[1]{\gdef\@version{#1}}
\renewcommand\abstract[1]{\gdef\@abstract{#1}}

% show the rest of the frontmatter as a footer
\RequirePackage{newfloat}
\DeclareFloatingEnvironment[placement={!b}]{frontmatter}
\newenvironment{frontmattercontainer}[1][]{
	\begin{frontmatter}
		\rule{\linewidth}{0.5pt}
		\footnotesize
	}{
	\end{frontmatter}
}

\renewcommand{\maketitle}{
    \noindent
    % Title block
    \ifdef{\@title}{
        \begin{flushleft}
            % Title size adjustment based on two-column mode
            {\ifbool{twocolumn}{\Large}{\huge} \selectfont \noindent
                \@title
                % Adjust spacing based on subtitle presence
                \ifdef{\@subtitle}{\vspace{-0.2cm}}{\vspace{0.2cm} \par}
            }
        \end{flushleft}
    }{}

    % Subtitle block
    \ifdef{\@subtitle}{
        \begin{flushleft}
            % Subtitle in italic and large font size
            {\large \selectfont \noindent
                \textit{\@subtitle} \par
            }
        \end{flushleft}
    }{}

    % Author block
    \ifdef{\@autor}{
        % Author name(s) in small font size
        {\small \selectfont \noindent \@autor \vspace{0.25cm} \par}
    }{}

    % Abstract block
    \ifdef{\@abstract}{
        % Abstract in italic and small font size
        {\small \fontshape{it} \selectfont \noindent \@abstract \par}
    }{}

    % Horizontal rule to separate title from content
    {\noindent\rule{\linewidth}{0.5pt}}

    % Add vertical space if in two-column mode
    \ifbool{twocolumn}{\vspace{\fill}}{}

    % Frontmatter container for correspondence and version
    \ifboolexpr{test {\ifdef{\@correspondence}} or test {\ifdef{\@version}}}{
        \begin{frontmattercontainer}
            % Correspondence block
            \ifdef{\@correspondence}{
                {\sffamily\fontseries{b}\selectfont\scshape mail} \@correspondence \par
            }{}

            % Version block
            \ifdef{\@version}{
                {\sffamily\fontseries{b}\selectfont\scshape rev} \@version \par
            }{}
        \end{frontmattercontainer}
    }{}
}


% TYPOGRAPHY

% Load the Noto font first so that it only affects mathematical notation
% The font requires TeXlive 2021 or later
\ifbool{legacy}{}{
    \RequirePackage[scale=0.95]{notomath}
}

% The class requires 'Alegreya' and 'Alegreya Sans' to be installed
% You may need to download and install the package, and then clear font cache using `fc-cache`
\RequirePackage{Alegreya}
\RequirePackage[sfdefault]{AlegreyaSans}

% Set line spacing and default fonts
\linespread{1.05}
\renewcommand\familydefault{\rmdefault}
%\renewcommand{\ttdefault}{txtt}

% Add protrusion and text expansion for better typography
% \RequirePackage[protrusion=true,factor=500,expansion=true]{microtype}
% \DisableLigatures{encoding=T1,shape=sc}

% Set font sizes for different text elements
\ifbool{twocolumn}{\def\lineheight{13}}{\def\lineheight{14}}
\renewcommand{\tiny}{\fontsize{7}{10}\selectfont}
\renewcommand{\footnotesize}{\fontsize{8}{11}\selectfont}
\renewcommand{\small}{\fontsize{9.5}{12.5}\selectfont}
\renewcommand{\normalsize}{\fontsize{11}{\lineheight}\selectfont}
\renewcommand{\large}{\fontsize{13}{15}\selectfont}
\renewcommand{\Large}{\fontsize{16}{19}\selectfont}
\renewcommand{\LARGE}{\fontsize{18}{21}\selectfont}
\renewcommand{\huge}{\fontsize{20}{24}\selectfont}

% Set font weights
\renewcommand\textbf[1]{{\fontseries{b}\selectfont#1}}

% Section titles formatting
\RequirePackage{titlesec}

% Section
\titleformat{\section}
    {\sffamily\fontseries{b}\scshape\fontsize{19}{19}\selectfont} % Format
    {\thesection} % Label
    {0pt} % Skip
    {\hspace*{1ex}} % Space between number and heading
\titlespacing{\section}{0pt}
    {4ex plus 0.5ex minus .5ex} % Before skip
    {3ex plus 0.2ex minus .2ex} % After skip

% Unnumbered Section
\titleformat{name=\section,numberless}
    {\sffamily\fontseries{b}\scshape\fontsize{15}{15}\selectfont} % Format
    {} % No label
    {0pt} % Skip
    {} % No space between number and heading

% Subsection
\titleformat{\subsection}
    {\sffamily\fontseries{b}\scshape\fontsize{13}{13}\selectfont} % Format
    {\thesubsection} % Label
    {0pt} % Skip
    {\hspace*{1ex}} % Space between number and heading
\titlespacing{\subsection}{0pt}
    {3ex plus 0.5ex minus .5ex} % Before skip
    {2ex plus 0.2ex minus .2ex} % After skip

% Subsubsection
\titleformat{\subsubsection}
    {\sffamily\fontseries{b}\scshape\fontsize{10}{10}\selectfont} % Format
    {\thesubsubsection} % Label
    {0pt} % Skip
    {\hspace*{1ex}} % Space between number and heading
\titlespacing{\subsubsection}{0pt}
    {2ex plus 0.5ex minus .5ex} % Before skip
    {1.5ex plus 0.2ex minus .2ex} % After skip

% OTHER ELEMENTS

% Table settings
\setlength{\tabcolsep}{10pt} % Cell padding
\renewcommand{\arraystretch}{1.5} % Row spacing

% Margin notes
\makeatletter
\renewcommand{\@marginparreset}{\reset@font\footnotesize\@setminipage}
\makeatother

% Horizontal separator
\newcommand{\separator}{
    \begin{center}
        \rule{0.618\linewidth}{0.5pt}
    \end{center}
}
