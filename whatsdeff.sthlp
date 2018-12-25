{smcl}
{* *! version 0.9  23Dec2018}{...}
{cmd:help whatsdeff} {right: ({browse "http://web.missouri.edu/~kolenikovs/stata/":Stas Kolenikov's webpage})}
{hline}

{title:Title}

{p2colset 5 12 14 2}{...}
{p2col :{hi:whatsdeff} {hline 2}}Estimate the unequal weighting design effect{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 11 2}
{cmd:whatsdeff }{it:varname} {ifin}
[{cmd:, by(}{it:varname}{cmd:)}]


{title:Description}

{pstd}{cmd:whatsdeff} computes and reports the unequal weighting design
effect estimated as {p_end}

{phang2}1 + {it:CV^2} = 1 + var[{it:varname}]/(mean[{it:varname}])^2{p_end}

{pstd}where {it:CV} = sd/mean is the coefficient of variation of 
the weight variable considered.
The design effect is a ratio of variance of a statistic
computed under a complex sampling design to variance of same statistic
computed under an approximation of simple random sampling.
With complex survey design settings declared by {help svyset},
Stata estimates design effects specific to each statistic
with {help estat effect} after a survey-enabled estimation
with {help svy} prefix. {cmd:whatsdeff} computes an easy approximation
of the design effect corresponding only to the variability of 
{it:pweight}; the full design effect corrects for clustering,
stratification, calibration (starting with Stata 15.1 which introduced
{cmd:svy calibrate}), and the interplay of these sampling design features
with each other and with the statistic of interest.
{p_end}


{phang}
{opt by(varname)} requests that the unequal weighting design
effects are computed by categories of a variable.{p_end}


{title:Examples}

{phang2}{cmd:. webuse nhanes2, clear}{p_end}
{phang2}{cmd:. whatsdeff finalwgt}{p_end}
{phang2}{cmd:. whatsdeff finalwgt, by(race)}{p_end}

{pstd}Proper design effects should be produced via {help estat effect}:{p_end}

{phang2}{cmd:. svy: mean bp*}{p_end}
{phang2}{cmd:. estat effect}{p_end}

{pstd}Note that with this data set, the major portion of the design effect
is due to clustering. The unequal weighting design effects contributes
only about 1.4 to the total design effect exceeding 8.{p_end}


{title:Author}

{pstd}Stanislav Kolenikov{p_end}
{pstd}Principal Scientist{p_end}
{pstd}Abt Associates{p_end}
{pstd}skolenik at gmail dot com{p_end}


{title:Also see}

{psee}{help svyset}, {help survey estimation}

