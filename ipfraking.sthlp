{smcl}
{* *! version 0.8  15may2012}{...}
{cmd:help ipfraking} {right: ({browse "http://web.missouri.edu/~kolenikovs/stata/":Stas Kolenikov's webpage})}
{hline}

{title:Title}

{p2colset 5 12 14 2}{...}
{p2col :{hi:ipfraking} {hline 2}}Weight raking by iterative proportional fitting{p_end}
{p2colreset}{...}


{title:Syntax}

{p 8 11 2}
{cmd:ipfraking}
{ifin}
{cmd:[pw=}{it:weight}{cmd:]}
[{cmd:,} {it:options}]

{synoptset 43 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Control figures}
{synopt :{cmdab:ctot:al(}{it:matname} [{it:matname} ...]{cmd:)}}matrices of control totals{p_end}
{synopt :{cmd:cmean(}{it:matname} [{it:matname} ...]{cmd:)}}matrices of control means (proportions){p_end}
{syntab:The new weight variable}
{synopt :{cmdab:gen:erate(}{it:newvarname}{cmd:)}}new variable to write the raked weights to{p_end}
{synopt :{cmd:replace}}overwrite the existing weight variable{p_end}
{synopt :{cmd:double}}generate the new variable of {help double} type{p_end}
{syntab:Convergence diagnostic and reporting}
{synopt:{cmdab:iter:ate(}{it:#}{cmd:)}}maximum number of iterations{p_end}
{synopt:{cmdab:tol:erance(}{it:#}{cmd:)}}convergence tolerance{p_end}
{synopt:{cmdab:ctrltol:erance(}{it:#}{cmd:)}}required accuracy of the controls{p_end}
{syntab:Trimming}
{synopt:{cmd:trimhirel(}{it:#}{cmd:)}}the upper bound on the greatest factor by which the weights can increase{p_end}
{synopt:{cmd:trimhiabs(}{it:#}{cmd:)}}the upper bound on the greatest value the weights can achieve{p_end}
{synopt:{cmd:trimlorel(}{it:#}{cmd:)}}the lower bound on the smallest factor by which the weights can increase{p_end}
{synopt:{cmd:trimloabs(}{it:#}{cmd:)}}the lower bound on the smallest value the weights can achieve{p_end}
{synopt:{cmdab:trimfreq:ency(}{it:keyword}{cmd:)}}stages of raking when weight trimming should be applied{p_end}
{syntab:Miscellaneous}
{synopt:{cmd:loglevel(}{it:#}{cmd:)}}level of detail in the output{p_end}
{synopt:{cmd:meta}}store some meta-info concerning the raking procedure{p_end}
{synopt:{cmd:selfcheck}}[UNDOCUMENT LATER!] run some nhanes2-based examples{p_end}


{title:Description}

{pstd}{cmd:ipfraking} performs iterative proportional fitting, or raking,
to produce a set of calibrated survey weights such that the 
sample weighted totals of control variables match the known population totals.
Typically, these control totals represent the number of population
units in categories of a discrete variable, such as age groups
in human surveys or industry in establishment surveys.
These control totals must come from a census, a survey of much
greater accuracy, or administrative data.

{pstd}The adjustment of the weights is performed by adjusting each of
the given control margins sequentially, until convergence is achieved.
In other words, for a given control variable (e.g., gender), 
the {help total} sizes of subpopulations are estimated, and
the weights in separate categories (males, females) are multiplied
by a group-specific factor (ratio of the known population total
to the estimated total) so that the new set of weights produces
total estimates conforming to the known totals.

{pstd}
Please cite this package as Kolenikov (2012), ipfraking: 
iterative proportional fitting weight calibration.


{title:Options}

{dlgtab:Section}

{phang}{cmd:option(}{it:whatever}{cmd:)}

{pmore}More hanging stuff

{syntab:Weight variable}
{synopt :{cmdab:gen:erate(}{it:newvarname}{cmd:)}}new variable to write the raked weights to{p_end}
{synopt :{cmd:replace}}overwrite the existing weight variable{p_end}
{synopt :{cmd:double}}generate the new variable of {help double} type{p_end}
{syntab:Convergence diagnostic and reporting}
{synopt:{cmdab:iter:ate(}{it:#}{cmd:)}}maximum number of iterations{p_end}
{synopt:{cmdab:tol:erance(}{it:#}{cmd:)}}convergence tolerance{p_end}
{synopt:{cmdab:ctrltol:erance(}{it:#}{cmd:)}}required accuracy of the controls{p_end}
{syntab:Trimming}
{synopt:{cmd:trimhirel(}{it:#}{cmd:)}}the upper bound on the greatest factor by which the weights can increase{p_end}
{synopt:{cmd:trimhiabs(}{it:#}{cmd:)}}the upper bound on the greatest value the weights can achieve{p_end}
{synopt:{cmd:trimlorel(}{it:#}{cmd:)}}the lower bound on the smallest factor by which the weights can increase{p_end}
{synopt:{cmd:trimloabs(}{it:#}{cmd:)}}the lower bound on the smallest value the weights can achieve{p_end}
{synopt:{cmdab:trimfreq:ency(}{it:keyword}{cmd:)}}stages of raking when weight trimming should be applied{p_end}
{syntab:Miscellaneous}
{synopt:{cmd:loglevel(}{it:#}{cmd:)}}level of detail in the output{p_end}
{synopt:{cmd:meta}}store some meta-info concerning the raking procedure{p_end}
{synopt:{cmd:selfcheck}}[UNDOCUMENT LATER!] run some nhanes2-based examples{p_end}

{dlgtab:Control figures}

{phang}{cmdab:ctot:al(}{it:matrix_name} [{it:matrix_name} ...]{cmd:)} specifies the control totals.

{pmore}Each matrix is expected to be a result of Stata {help total} estimation command.
If the latter was issued with {cmd:over(}{help varname}{cmd:)} option,
the matrix has to be additionally augmented with the name of that variable as a rowname.
See {help ipfraking##remarks:Remarks} and {help ipfraking##examples:Examples}.

{phang}{cmd:cmean(}{it:matrix_name} [{it:matrix_name} ...]{cmd:)} specifies the control means (proportions){p_end}

{pmore}Each matrix is expected to be a result of Stata {help mean} estimation command.
If the latter was issued with {cmd:over(}{help varname}{cmd:)} option,
the matrix has to be additionally augmented with the name of that variable as a rowname.
See {help ipfraking##remarks:Remarks} and {help ipfraking##examples:Examples}.


{title:Returned values}

{synopt:{cmd:r(converged)}}1, if convergence of the algorithm was achieved, and 0 otherwise.{p_end}
{synopt:{cmd:r(badcontrols)}}1, if any of the control totals or means were not approximated accurately, and 0 otherwise.{p_end}


{marker remarks}{title:Remark 1}

{pstd}Matrices that {cmd:ipfraking} expects to receive as inputs via {opt ctotal(...)} or
{opt cmean(...)} options must conform to the following specifications:

{phang2}1. They need to be {it:1 x c} matrices (row-vectors)

{phang2}2. They must have column names in estimation results format, i.e., {it:variable}:{it:#}.

{phang2}3. They must have rowname that contains the categorical variable over the categories of which
the totals were computed.

{pstd}These requirements are easily satisfied by getting the matrices as result of

{phang2}{cmd:total} {it:varname} {weight}, {cmd:over(}{it:varname}{cmd:, nolab)}

{pstd}The {cmd:nolab} option is important, otherwise, the column names 
may contain the labels of the categorical variable that may be defined
differently in the sample, or not defined at all. Also, only one variable 
should be specified in the {cmd:over()} option, as otherwise Stata provides
generic column names {cmd:_subpop_}{it:#} that are dependent on the data.


{title:Remark 2}

{pstd}For algorithmic purposes, convergence is defined as achieving
a stable state where the raked weights do not change (much) from
iteration to iteration. In some sources, convergence of the raking
algorithm is defined as whether the control totals are accurately
approximated. These are two separate outcomes.

{marker examples}{title:Examples}


{pstd}Calibration over a single margin (post-stratification){p_end}

{phang2}{cmd:. webuse nhanes2, clear}{p_end}
{phang2}{cmd:. * setting up the totals}{p_end}
{phang2}{cmd:. generate byte _one = 1}{p_end}
{phang2}{cmd:. svy: total _one, over(sex, nolab)}{p_end}
{phang2}{cmd:. matrix total_sex = e(b)}{p_end}
{phang2}{cmd:. matrix rownames total_sex = sex}{p_end}
{phang2}{cmd:. * obtaining the sample}{p_end}
{phang2}{cmd:. sample 500, count by(region)}{p_end}
{phang2}{cmd:. * calibrating the weights}{p_end}
{phang2}{cmd:. ipfraking [pw=finalwgt], ctotal(total_sex) generate(rakedwgt1)}{p_end}
{phang2}{cmd:. * quality control}{p_end}
{phang2}{cmd:. total _one [pw=rakedwgt1], over(sex)}{p_end}
{phang2}{cmd:. matrix list e(b), format(%12.0g)}{p_end}
{phang2}{cmd:. matrix list total_sex, format(%12.0g)}{p_end}

{pstd}Note that zero standard errors in the last estimation command
are appropriate: there is no sampling variability in these totals
since they are known.
Generally, however, the variances will be overestimated,
unlike with the proper {man poststratification}.
Also, {cmd:ipfraking} performs the quality control internally
and reports problems, if any.

{pstd}Calibration over two margins{p_end}

{phang2}{cmd:. webuse nhanes2, clear}{p_end}
{phang2}{cmd:. * setting up the totals}{p_end}
{phang2}{cmd:. generate byte _one = 1}{p_end}
{phang2}{cmd:. svy: total _one, over(sex, nolab)}{p_end}
{phang2}{cmd:. matrix total_sex = e(b)}{p_end}
{phang2}{cmd:. matrix rownames total_sex = sex}{p_end}
{phang2}{cmd:. svy: total _one, over(race, nolab)}{p_end}
{phang2}{cmd:. matrix total_race = e(b)}{p_end}
{phang2}{cmd:. matrix rownames total_race = race}{p_end}
{phang2}{cmd:. * obtaining the sample}{p_end}
{phang2}{cmd:. sample 500, count by(region)}{p_end}
{phang2}{cmd:. * calibrating the weights}{p_end}
{phang2}{cmd:. ipfraking [pw=finalwgt], ctotal(total_sex total_race) generate(rakedwgt2)}{p_end}
{phang2}{cmd:. }{p_end}
{phang2}{cmd:. }{p_end}
{phang2}{cmd:. }{p_end}


{pstd}Calibration over two margins with weight trimming{p_end}

{phang2}{cmd:. webuse nhanes2, clear}{p_end}
{phang2}{cmd:. * setting up the totals}{p_end}
{phang2}{cmd:. generate byte _one = 1}{p_end}
{phang2}{cmd:. svy: total _one, over(sex, nolab)}{p_end}
{phang2}{cmd:. matrix total_sex = e(b)}{p_end}
{phang2}{cmd:. matrix rownames total_sex = sex}{p_end}
{phang2}{cmd:. svy: total _one, over(race, nolab)}{p_end}
{phang2}{cmd:. matrix total_race = e(b)}{p_end}
{phang2}{cmd:. matrix rownames total_race = race}{p_end}
{phang2}{cmd:. * obtaining the sample}{p_end}
{phang2}{cmd:. sample 500, count by(region)}{p_end}
{phang2}{cmd:. * calibrating the weights}{p_end}
{phang2}{cmd:. ipfraking [pw=finalwgt], ctotal(total_sex total_race) trimhiabs(200000) generate(rakedwgt3)}{p_end}


{pstd}Calibration over two margins with weight trimming, failure to achieve the control totals:{p_end}

{phang2}{cmd:. webuse nhanes2, clear}{p_end}
{phang2}{cmd:. * setting up the totals}{p_end}
{phang2}{cmd:. generate byte _one = 1}{p_end}
{phang2}{cmd:. svy: total _one, over(sex, nolab)}{p_end}
{phang2}{cmd:. matrix total_sex = e(b)}{p_end}
{phang2}{cmd:. matrix rownames total_sex = sex}{p_end}
{phang2}{cmd:. svy: total _one, over(race, nolab)}{p_end}
{phang2}{cmd:. matrix total_race = e(b)}{p_end}
{phang2}{cmd:. matrix rownames total_race = race}{p_end}
{phang2}{cmd:. * obtaining the sample}{p_end}
{phang2}{cmd:. sample 500, count by(region)}{p_end}
{phang2}{cmd:. * calibrating the weights}{p_end}
{phang2}{cmd:. ipfraking [pw=finalwgt], ctotal(total_sex total_race) trimhiabs(200000) generate(rakedwgt4) trimhirel(5.4)}{p_end}
{phang2}{cmd:. }{p_end}
{phang2}{cmd:. }{p_end}
{phang2}{cmd:. }{p_end}

{title:References}

{phang}Deming, W. (1940)

{phang}Deville and Sarndal (1996)

{phang}Kott -- review

{phang}Bollen, K. A. 1996. {browse "http://www.springerlink.com/content/2v1837041117kh66/":An alternative two stage least squares (2SLS) estimator for latent variable equations}. {it:Psychometrika} 61: 109-121.

{phang}Kolenikov, S. 2009. {browse "http://www.stata-journal.com/article.html?article=st0169":Confirmatory factor analysis using {cmd:confa}}. {it:Stata Journal}, 9(3): 329--373.

{phang}Satorra, A., and P. M. Bentler. 1994. Corrections to test statistics and standard errors in covariance structure analysis. In {it:Latent Variables Analysis}, ed. A. von Eye and C. C. Clogg, 399-419. Thousand Oaks, CA: Sage.

{phang} Yuan, K.-H., and P. M. Bentler. 1997. {browse "http://www.jstor.org/stable/2965725":Mean and covariance structure analysis: Theoretical and practical improvements.}
    {it:Journal of the American Statistical Association} 92: 767-774.


{title:Author}

{pstd}Stanislav Kolenikov{p_end}
{pstd}Senior Survey Statistician{p_end}
{pstd}Abt SRBI{p_end}
{pstd}skolenik at gmail dot com{p_end}


{title:Also see}

{psee}
Article: {it:Stata Journal}, volume ??, number ??: {browse "http://www.stata-journal.com/article.html?article=st0001":st0001}
maxentropy
