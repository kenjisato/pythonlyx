# pythonlyx

A demo for literate Python programming using [reticulate](https://rstudio.github.io/reticulate/) and [knitr](https://yihui.org/knitr/) on [LyX](https://www.lyx.org/). 

I have confirmed that it works in the following environment

### R 

- R version 4.0.0 (2020-04-24)
- Platform: x86_64-apple-darwin19.4.0 (64-bit)
- Running under: macOS Catalina 10.15.4
- reticulate 1.15
- knitr (1.28)

### texlive

- pdfTeX 3.14159265-2.6-1.40.21 (TeX Live 2020)

### Python

I use Anaconda3 2019.10. Since reticulate requires CPython built with shared library, you may need to 

	PYTHON_CONFIGURE_OPTS="--enable-shared"

before installing Anaconda. With the standard GUI installation, you don't have to be worried about this, I suppose.

## Important notice about the license

I include in this repository a slightly modified version of py_inject_r function of 
{reticulate} R package, which RStudio has copyright for. (Since I am not sure about how to properly tell that that is not my work, I here declare the usage.)

You can freely use the content of the demo package.
