{smcl}
{* *! version 0.1  23Dec2018}{...}
{cmd:help totalmatrices} {right: ({browse "http://web.missouri.edu/~kolenikovs/stata/":Stas Kolenikov's webpage})}
{hline}

{title:Title}

{p2colset 5 12 14 2}{...}
{p2col :{hi:totalmatrices} {hline 2}}Conversion of the matrices of control totals{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 11 2}
{cmd:totalmatrices} {it:matrix_list},
{cmd:stub(}{it:string}{cmd:)} [{cmd:svycal} {cmdab:ipfr:aking} {cmd:replace convert} ]


{title:Description}

{pstd}{cmd:totalmatrices} converts the matrices of control totals
between formats expected by {help ipfraking} and {help svycal}.{p_end}

{pstd}Both packages provide the functionality of calibrating
the survey weights to the known population totals for categorical
variables. The totals themselves are data; the variables and categories
are metadata; that is, Stata needs to know that the number of
500,000 that the weights of female respondents need to sum up 
to should correspond to {cmd:sex==2}.{p_end}

{pstd}The format of {cmd:ipfraking} is that of one matrix 
per one calibration variable: the variable {cmd:sex}
should have a matrix associated with it such as {cmd:total_sex}
that the program expects to have the following format:{p_end}

{p 8}total_sex[1,2]{p_end}
{p 14}_one:{bind:   }_one:{p_end}
{p 18}1{bind:       }2{p_end}
{p 8}sex{bind:  }450000{bind:  }500000{p_end}

{pstd}The calibration variable is specified as the rowname
of the matrix. The categories are supplied in colnames, and 
{cmd:_one} is the name of the multiplier, if applicable.
See {help matrix rowname} for details.{p_end}

{pstd}One of the formats used by {cmd:svy calibrate} is much 
simpler: the user can simply supply the control totals inline
as {cmd:svycal ... , ... totals( 1.sex = 450000 2.sex = 500000, nocons)}
using the naming conventions of {help factor variables} and their categories.
Another possible format expects a matrix with colnames
set to those of the factor varibles, with one input matrix that must
contain all control totals at once:{p_end}

{p 8}all_totals[1,5]{p_end}
{p 14} 1.sex{bind:   }2.sex{bind:   }1.age{bind:   }2.age{bind:   }3.sex {p_end}
{p 13}450000{bind:  }500000{bind:  }320000{bind:  }305000{bind:  }325000 {p_end}

{phang}
{opt stub(string)} specifies the name of the matrix to created when converting
from {cmd:ipfraking} to {cmd:svycal} format; or the prefix of the matrices to
be created when converting from {cmd:svycal} to {cmd:ipfraking} format.{p_end}

{phang}
{opt svycal} is used to indicate that the user expects the input to be 
in the {cmd:svycal} format.{p_end}

{phang}
{opt svycal} is used to indicate that the user expects the input to be 
in the {cmd:ipfraking} format.{p_end}

{phang}
{opt convert} is used to requet the conversion; otherwise, 
{cmd:totalmatrices} will only check that the format of the inputs
seem to be correct.{p_end}

{phang}
{opt replace} gives {cmd:totalmatrices} permission to overwrite 
existing matrices.{p_end}


{title:Examples}

{pstd}Set up a minimal data set:{p_end}
{phang2}. clear{p_end}
{phang2}. set obs 2{p_end}
{phang2}. gen byte sex = _n{p_end}
{phang2}. expand 3{p_end}
{phang2}. bysort sex : gen byte age = _n{p_end}
{phang2}. {p_end}
{phang2}. gen byte _one = 1{p_end}

{pstd}Set up the (ipfraking-style) control totals:{p_end}
{phang2}. mat total_sex = (450000,500000){p_end}
{phang2}. mat rownames total_sex = sex{p_end}
{phang2}. mat colnames total_sex = _one:1 _one:2{p_end}
{phang2}. {p_end}
{phang2}. mat total_age = (320000,305000,325000){p_end}
{phang2}. mat rownames total_age = age{p_end}
{phang2}. mat colnames total_age = _one:1 _one:2 _one:3{p_end}

{pstd}Convert to the {cmd:svycal} format:{p_end}
{phang2}. totalmatrices total_sex total_age, ipfraking stub(ctmat){p_end}
{phang2}. totalmatrices total_sex total_age, ipfraking stub(ctmat) convert replace{p_end}
{phang2}. mat li ctmat{p_end}
{phang2}. {p_end}
{phang2}. svycal rake ibn.sex ibn.age [pw=_one], generate(raked_svycal) totals(ctmat) nocons{p_end}

{pstd}Convert back to the {cmd:ipfraking} format:{p_end}
{phang2}. totalmatrices ctmat, svycal stub(ct_) convert replace{p_end}
{phang2}. ipfraking [pw=_one], ctotal( ct_sex ct_age ) gen(raked_ipfr){p_end}
{phang2}. {p_end}
{phang2}. compare raked_svycal raked_ipfr{p_end}


{title:Author}

{pstd}Stanislav Kolenikov{p_end}
{pstd}Principal Scientist{p_end}
{pstd}Abt Associates{p_end}
{pstd}skolenik at gmail dot com{p_end}


{title:Also see}

{psee}{help svyset}, {help survey estimation}

