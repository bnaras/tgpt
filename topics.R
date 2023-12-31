## Quick and dirty hack for generating chat-gpt summaries and organizing it
## There's a limit to how many calls one can make, so split this up as needed.
papers_to_summarize <- data.frame(
  info = c(
    "Efron's 1981 Biometrika paper on Nonparametric estimates of standard error"
  , "1986 Statistical Science paper on Generalized Additive Models by Hastie and Tibshirani"
  , "1996 Statistical Science paper on Boostrap Confidence Intervals by Efron and Diciccio"
  ),
  dir = c(
    "E1981"
  , "HT1986"
  , "ED1996")
)


make_prompt <- function(x) {
  paste("Summarize", x, "using latex math where needed in Rmarkdown format with URL/DOI in a last section.")
}

clean_response <- function(x) {
  stringr::str_sub(x, stringr::str_locate(x, "---\ntitle:")[1, 1])
}

prompts <- lapply(papers_to_summarize$info, make_prompt)
response <- lapply(prompts, chatgpt::ask_chatgpt)

results <- response
## May be needed, depending on your history, in which case uncomment
##results <- lapply(results, clean_response)

n <- nrow(papers_to_summarize)

for (i in seq_len(n)) {
  d <- papers_to_summarize$dir[i]
  rmd_path <- fs::path(d, "index.Rmd")
  writeLines(results[[i]], rmd_path)
  rmarkdown::render(rmd_path, output_format = pdf_document())
}

## NOt needed since not using github pages
## Write a final Rmd file.
## index.rmd <- c('---'
##              , 'title: "Papers to discuss"'
##              , 'author: "Tibs"'
##              , 'output: html_document'
##              , '---'
##              , ''
##              , '## List'
##              , ''
## )

## for (i in seq_len(n)) {
##   p <- papers_to_summarize$info[i]
##   d <- fs::path(papers_to_summarize$dir[i], "index.pdf")
##   index.rmd <- append(index.rmd, sprintf(" - [%s](%s)", p, d))
## }

## index_file_path <- fs::path("docs", "index.html")
## writeLines(index.rmd, index_file_path)
## rmarkdown::render(index_file_path)










