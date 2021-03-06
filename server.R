function(input, output) {
  
  output$downloadReport <- downloadHandler(
    filename = function() {
      paste('my-report', sep = '.', switch(
        input$format, PDF = 'pdf', HTML = 'html', Word = 'docx'
      ))
    },
    
    content = function(file) {
      src <- normalizePath('report.Rmd')
      
      # temporarily switch to the temp dir, in case you do not have write
      # permission to the current working directory
      owd <- setwd(tempdir())
      on.exit(setwd(owd))
      file.copy(src, 'report.Rmd', overwrite = TRUE)
      
      library(rmarkdown)
      out <- render(input='report.Rmd', encoding="UTF-8",
                    output_format = switch(
        input$format,
        PDF = pdf_document(
          latex_engine ="lualatex"),
        HTML = html_document(), Word = word_document()
      ))
      file.rename(out, file)
    }
  )
  
}