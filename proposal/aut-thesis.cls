%%
%%  This is file `AUT_thesis.cls',
%%  The original file was xepersian-thesis.cls by Vafa Khalighi
%%   __________________________________
%%   Copyright © 2015-2018 Amirkabir University
%%
%%   http://www.aut.ac.ir
%%   http://www.parsilatex.com
%%   http://forum.parsilatex.com
%%
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aut-thesis}
              [03/01/2022 v0.5
 Persian thesis document class in XeLaTeX for University of Amirkabir projects/theses/dissertations]
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}
\ProcessOptions%
\LoadClass[a4paper,10pt]{book}

\RequirePackage{keyval}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\department#1{\gdef\@department{#1}}
\def\degree#1{\gdef\@degree{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\define@key{thesis}{firstsupervisor}[]{\gdef\ffirstsupervisor{#1}}
\define@key{thesis}{secondsupervisor}[]{\gdef\fsecondsupervisor{#1}}
\define@key{thesis}{firstadvisor}[]{\gdef\ffirstadvisor{#1}}
\define@key{thesis}{secondadvisor}[]{\gdef\fsecondadvisor{#1}}
\define@key{thesis}{internalexaminer}[]{\gdef\finternalexaminer{#1}}
\define@key{thesis}{externalexaminer}[]{\gdef\fexternalexaminer{#1}}
\define@key{thesis}{name}[]{\gdef\fname{#1}}
\define@key{thesis}{surname}[]{\gdef\lname{#1}}
\def\thesisdetails#1{{\setkeys{thesis}{#1}}}

\def\thesisdate#1{\gdef\datethesis{#1}}

\def\fatitle#1{\gdef\ftitle{#1}}
\def\keywords#1{\gdef\fkeywords{\noindent #1}}
\def\faculty#1{\gdef\@faculty{#1}}
\def\subject#1{\gdef\fsubject{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\latintitle#1{\gdef\@latintitle{#1}}
\def\latinauthor#1{\gdef\@latinauthor{#1}}
\def\latindegree#1{\gdef\@latindegree{#1}}
\def\latinfaculty#1{\gdef\@latinfaculty{#1}}
\def\latinthesisdate#1{\gdef\@latinthesisdate{#1}}
\def\latinsubject#1{\gdef\@latinsubject{#1}}
%\def\latinfield#1{\gdef\@latinfield{#1}}
\def\firstlatinsupervisor#1{\gdef\@firstlatinsupervisor{#1}}
\def\secondlatinsupervisor#1{\gdef\@secondlatinsupervisor{#1}}
\def\firstlatinadvisor#1{\gdef\@firstlatinadvisor{#1}}
\def\secondlatinadvisor#1{\gdef\@secondlatinadvisor{#1}}
\def\latinname#1{\gdef\@latinname{#1}}
\def\latinsurname#1{\gdef\@latinsurname{#1}}
\def\latinkeywords#1{\gdef\elatinkeywords{#1}}
\def\latinuniversity#1{\gdef\@latinuniversity{#1}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newif\if@bscthesis
\@bscthesisfalse
\DeclareOption{bsc}{\@bscthesistrue}

\newif\if@mscthesis
\@mscthesisfalse
\DeclareOption{msc}{\@mscthesistrue}

\newif\if@phdthesis
\@phdthesisfalse
\DeclareOption{phd}{\@phdthesistrue}

\newif\if@proposal
\@proposalfalse
\DeclareOption{proposal}{\@proposaltrue}

\ProcessOptions
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% persian title page {{{
\newcommand{\persiantitlepage}{\begin{titlepage}
%\topmargin=-30pt
\vspace{-1cm}\centerline{\includegraphics[height=3.8cm]{img/aut-logo-fa.png}}
\vspace{-1cm}
{\bf{\fontsize{16pt}{16pt}\selectfont دانشگاه صنعتی امیرکبیر}\par
\vspace{-1cm}\fontsize{14pt}{15pt}\selectfont(پلی‌تکنیک تهران)\par
\vspace{-1cm}\fontsize{16pt}{17pt}\selectfont\@faculty}\par
%\vskip 1.5cm
{
  \fontsize{16pt}{14pt}\selectfont\bfseries

  \if@mscthesis
    \if@proposal
    پیشنهاد پروژه کارشناسی ارشد
    \else
    پایان‌نامه کارشناسی ارشد
    \fi
    \vspace{-.8cm}

    \@department
  \fi
  \if@bscthesis
    \if@proposal
    پیشنهاد پروژه کارشناسی
    \else
    پروژه کارشناسی
    \fi
    \vspace{-.8cm}

    \@department
  \fi
  \if@phdthesis
    \if@proposal
    پیشنهاد رساله دکتری
    \else
    رساله دکتری
    \fi
    \vspace{-.8cm}

    \@department
  \fi
}

% {\fontsize{16pt}{17pt}\selectfont\bfseries%
%  \onvan}\par
\par
 \vspace{1cm}
{\fontsize{20pt}{21pt}\selectfont\bfseries {\ftitle}}\par
\vskip .5cm
 {\fontsize{16pt}{17pt}\selectfont\bfseries%
  \by}\par
\par
\vspace*{-0.8cm}
{\fontsize{18pt}{19pt}\selectfont\bfseries{\fname \ \lname}}\par
\fontsize{16pt}{17pt}\selectfont\bfseries
{
  \ifx\ffirstsupervisor\undefined%
  \else
    \ifx\fsecondsupervisor\undefined%
      استاد راهنما
      \vspace*{-0.8cm}
      {\fontsize{18pt}{19pt}\selectfont\bfseries\par\ffirstsupervisor}
    \else
      \fontsize{16pt}{17pt}\selectfont\bfseries
      استادان راهنما
      \vspace*{-0.8cm}
      {\fontsize{18pt}{19pt}\selectfont\bfseries\par
        \ffirstsupervisor\space
        و
        \fsecondsupervisor
      }
    \fi
  \fi
}
\par\fontsize{16pt}{17pt}\selectfont\bfseries
{\ifx\ffirstadvisor\undefined%
\ifx\fsecondadvisor\undefined%
\else\fi
\else
\ifx\fsecondadvisor\undefined%
استاد مشاور
\vspace*{-0.8cm}
{\fontsize{18pt}{19pt}\selectfont\bfseries\par
\ffirstadvisor}
\else

\fontsize{16pt}{17pt}\selectfont\bfseries
استادان مشاور
\vspace*{-0.8cm}
{\fontsize{18pt}{19pt}\selectfont\bfseries\par\ffirstadvisor{} و \fsecondadvisor}
\fi\fi}

\vskip 6mm

{\fontsize{16pt}{17pt}\selectfont \datethesis}

\end{titlepage}%
\newpage
\thispagestyle{empty}
\baselineskip=.7cm
\if@bscthesis \relax
\else
%-----------------------------------------------------------------------------------table of thesis
\relax
\fi
}
% }}}

\def\acknowledgementpage{
  \newpage
  \thispagestyle{empty}

  \vspace{1cm}
  \par\noindent
}
\def\endacknowledgementpage{\newpage}

\def\titlepage{
  \newpage\centering
  \thispagestyle{empty}
  \parindent 0pt \parskip 10pt plus 1fil minus 1fil
  \def\baselinestretch{1}\@normalsize\vbox to \vsize\bgroup\vbox to 9in\bgroup}
\def\endtitlepage{\par\kern 0pt\egroup\vss\egroup\newpage}

\def\signature{
  \vspace{1cm}
  \begin{flushleft}
    {
      \nastaliq \scriptsize \fname\ \lname \\
      \datethesis
    }
  \end{flushleft}
}

\font\titlefont=cmssbx10 scaled 2074
\font\supervisorfont=cmbxti10

% latin title page {{{
\newcommand{\latintitlepage}{%
\if@bscthesis \relax
\else
\relax
%-------------------------------------------------------------------------- table of En thesis

%---------------------------------------------------------------------------- end of En table
\begin{titlepage}
\vspace{-1cm}{\includegraphics[height=3.8cm]{img/aut-logo-en.png}}
\centerline{\fontsize{18pt}{19pt}\selectfont\bf Amirkabir University of Technology}\space
\vskip -.2cm
\fontsize{16pt}{17pt}\selectfont\bfseries (Tehran Polytechnic)\par \vskip .2cm
\bfseries
\fontsize{16pt}{17pt}\selectfont\@latinfaculty\space
\vskip 5mm
\if@bscthesis
  \if@proposal
    B.Sc. Thesis Proposal\par
  \else
    B.Sc. Thesis\par
  \fi
\fi
\if@mscthesis
  \if@proposal
    M.Sc. Thesis Proposal\par
  \else
    M.Sc. Thesis\par
  \fi
\fi
\if@phdthesis
  \if@proposal
    Ph.D. Thesis Proposal\par
  \else
    Ph.D. Thesis\par
  \fi
\fi\par
\vspace*{2cm}
%{\fontsize{16pt}{17pt}\selectfont\bfseries Title}%\@latinsubject
\par
\baselineskip=.750cm
{\Huge\@latintitle}%\titlefont
\baselineskip=.750cm \par
\vskip 1.5cm
{\bfseries\latinby}\par
{\fontsize{18pt}{19pt}\selectfont\bfseries
\@latinname \ \@latinsurname}\par
\vskip 1cm

\fontsize{16pt}{17pt}\selectfont\bfseries
{\ifx\@firstlatinsupervisor\undefined%
\ifx\@secondlatinsupervisor\undefined%
\else\fi
\else
\ifx\@secondlatinsupervisor\undefined%
Supervisor
{\fontsize{18pt}{19pt}\selectfont\bfseries\par
\@firstlatinsupervisor}
\else
\fontsize{16pt}{17pt}\selectfont\bfseries
Supervisors
\par
{\fontsize{18pt}{19pt}\selectfont\bfseries \@firstlatinsupervisor{} and \@secondlatinsupervisor}
\fi\fi}
\par
\vskip 1cm
\fontsize{16pt}{17pt}\selectfont\bfseries
{\ifx\@firstlatinadvisor\undefined%
\ifx\@secondlatinadvisor\undefined%
\else\fi
\else
\ifx\@secondlatinadvisor\undefined%
Advisor
{\fontsize{18pt}{19pt}\selectfont\bfseries\par
\@firstlatinadvisor}
\else

\fontsize{16pt}{17pt}\selectfont\bfseries
Advisors
\par
{\fontsize{18pt}{19pt}\selectfont\bfseries\@firstlatinadvisor{} and \@secondlatinadvisor}
\fi\fi}
%\vskip 5mm

\par
\vskip 2cm

{\fontsize{16pt}{17pt}\selectfont\bfseries\@latinthesisdate}
\par
\vskip 1cm

\par

\vfill
%
\end{titlepage}
\fi}
% }}}

\def\by{نگارش}
\def\latinby{By}
\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
\hbox{}
\thispagestyle{empty}
\newpage
\if@twocolumn\hbox{}\newpage\fi\fi\fi}

\AtBeginDocument{%
  \crefname{equation}{برابری}{equations}%
  \crefname{chapter}{فصل}{chapters}%
  \crefname{section}{بخش}{sections}%
  \crefname{appendix}{پیوست}{appendices}%
  \crefname{enumi}{مورد}{items}%
  \crefname{footnote}{زیرنویس}{footnotes}%
  \crefname{figure}{شکل}{figures}%
  \crefname{table}{جدول}{tables}%
  \crefname{theorem}{قضیه}{theorems}%
  \crefname{lemma}{لم}{lemmas}%
  \crefname{corollary}{نتیجه}{corollaries}%
  \crefname{proposition}{گزاره}{propositions}%
  \crefname{definition}{تعریف}{definitions}%
  \crefname{result}{نتیجه}{results}%
  \crefname{example}{مثال}{examples}%
  \crefname{remark}{نکته}{remarks}%
  \crefname{note}{یادداشت}{notes}%
}

\setcounter{secnumdepth}{3}

%%
%% Copyright © 2015-2022
%%
%% Distributable under the LaTeX Project Public License,
%% version 1.3c or higher (your choice). The latest version of
%% this license is at: http://www.latex-project.org/lppl.txt
%%
%% This work is "maintained" (as per LPPL maintenance status)
%%
%%
%%
%%
%%
%% Special thanks to Vafa Khalighi for his invaluable hints.
%%
% End of file `AUT_thesis.cls'.
