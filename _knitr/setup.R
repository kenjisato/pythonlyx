library(reticulate)

python3 <- "/usr/local/var/pyenv/versions/anaconda3-2019.10/bin/python3"
use_python(python3, required = TRUE)

## Default Configurations ----
knitr_config <- list(
    fig.width   = 12, 
    fig.asp     = 0.618, 
    fig.align   = "center",
    fig.path    = "Figure/",
    engine      = "python",
    background  = NA,
    comment     = NA
)

## Choose appropariate Python 3.7 ----
knitr_config[['engine.path']] <- list(python = python3)

knitr::opts_chunk$set(knitr_config)

## Common Hooks ----
hook_lst_bf <- function(x, options) {
    paste("\\begin{lstlisting}[basicstyle={\\bfseries}]\n", x, 
        "\\end{lstlisting}\n", sep = "")
}

## Customize Hooks ----
knitr::knit_hooks$set(
    sympy = function(before, options, envir) {},
    source = function(x, options) {
        if (!is.null(options$sympy) && options$sympy){
            x <- sub("from\\s+sympy\\s+import\\s+latex\\n", "", x)
            x <- sub("print\\(latex\\((.*),(.*)\\)\\)", "\\1", x)
        }
        
        lst_opts <- "style=Source"
        if (!is.null(options$caption)) {
            lst_opts <- paste0(lst_opts, ",caption=", options$caption)
            lst_opts <- paste0(lst_opts, ",label=", options$fig.lp, options$label)
        }

        paste0("\\begin{lstlisting}[", lst_opts, "]\n",  
              paste(x, collapse="\n"), 
              "\n\\end{lstlisting}\n", sep = "")
    }, 
    output = function(x, options) {
        if (options$results == 'asis') return(x)
        paste("\\begin{lstlisting}[style=Result]\n", x, 
            "\\end{lstlisting}\n", sep = "")
    }, 
    chunk = function(x, options) x,
    warning = hook_lst_bf, 
    message = hook_lst_bf, 
    error = hook_lst_bf,
    document = function(x) {
        gsub('\\\\(begin|end)\\{kframe\\}', '', x)
    }
)

## Option Hooks ----
knitr::opts_hooks$set(
    sympy = function(options) {
        if(options$sympy) options$results = "asis"
        options
    }
)

## empty highlight header ----
knitr::set_header(highlight = "")

## Shims ----

shim_py_inject_r <- function(envir) {
    
    # define our 'R' class
    py_run_string("class R(object): pass")
    
    # extract it from the main module
    main <- import_main(convert = FALSE)
    R <- main$R
    
    # extract active knit environment
    if (is.null(envir)) {
        .knitEnv <- reticulate:::yoink("knitr", ".knitEnv")
        envir <- .knitEnv$knit_global
    }
    
    # define the getters, setters we'll attach to the Python class
    getter <- function(self, code) {
        object <- eval(parse(text = as_r_value(code)), envir = envir)
        r_to_py(object, convert = is.function(object))
    }
    
    setter <- function(self, name, value) {
        envir[[as_r_value(name)]] <<- as_r_value(value)
    }
    
    py_set_attr(R, "__getattr__", getter)
    py_set_attr(R, "__setattr__", setter)
    py_set_attr(R, "__getitem__", getter)
    py_set_attr(R, "__setitem__", setter)
    
    # now define the R object
    py_run_string("robj = R()")
    
}

utils::assignInNamespace("py_inject_r", shim_py_inject_r,
                         envir = as.environment("package:reticulate"))
