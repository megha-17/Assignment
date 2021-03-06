#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  #Actual part from where the text will be loaded from the text file
  Dataset <- reactive({
    
    if (is.null(input$textfile)) {   # locate 'textfile' from ui.R
      
        return(NULL) 
      } else {
        count <- nchar(input$textfile$datapath)
        fileTextType <- substr(input$textfile$datapath, (count - 2) , nchar(input$textfile$datapath))
        if (fileTextType != 'txt') {
          errorMessage = "Please upload the file which is of .txt extension"
          errorMessage
        } else {
          errorMessage = ""
          errorMessage
          datacontent <- readLines(input$textfile$datapath)
          
          if (!require(udpipe)){install.packages("udpipe")} 
          if (!require(textrank)){install.packages("textrank")}  
          if (!require(lattice)){install.packages("lattice")}
          if (!require(igraph)){install.packages("igraph")} 
          if (!require(ggraph)){install.packages("ggraph")} 
          if (!require(wordcloud)){install.packages("wordcloud")}
          if (!require(extrafont)){install.packages("extrafont")} 
          if (!require(extrafontdb)){install.packages("extrafontdb")} 
          library(extrafont); library(udpipe); library(textrank); library(lattice); library(igraph);
          library(ggraph);library(ggplot2); library(wordcloud); library(stringr)
          system.time({
            if (input$select == 1) {
              ud_model_english <- udpipe_download_model(language = "english") 
            } else if(input$select == 2){
              ud_model_hindi <- udpipe_download_model(language = "hindi")
            } else if(input$select == 2) {
              ud_model_spanish <- udpipe_download_model(language = "spanish")
            }
          })
          datacontent
          #return (datacontent)
        }
      }
  })

  # You can access the value of the widget with input$file, e.g.
  output$value <- renderPrint({
    str(input$file)
  })
  
  # You can access the values of the widget (as a vector)
  # with input$checkGroup, e.g.
  output$value <- renderPrint({ input$checkGroup })

  
  #This piece of code will take care of Graphp i.e. cooccurrence graph Tab
  output$plot1 <- renderPlot({
    count <- nchar(input$textfile$datapath)
    fileTextType <- substr(input$textfile$datapath, (count - 2) , nchar(input$textfile$datapath))
    if (fileTextType != 'txt') {
      errorMessage = "Please upload the file which is of .txt extension";errorMessage;
    } else {
      errorMessage = ""
      errorMessage
      require(stringr)
      data  =  str_replace_all(Dataset(), "<.*?>", "") # get rid of html junk 
      if (input$select == 1) {
        english_model = udpipe_load_model("/Users/i303433/Desktop/CBA-Term2/textAnalytics/english-ud-2.0-170801.udpipe")
        x <- udpipe_annotate(english_model, x = data) #%>% as.data.frame() %>% head()
        x <- as.data.frame(x)
        head(x, 4)
        table(x$xpos)
        table(x$upos)
        
        
        
        #-- For collocation code
        collocations <- keywords_collocation(x = x,   # try ?keywords_collocation
                                             term = "token", 
                                             group = c("doc_id", "paragraph_id", "sentence_id"),
                                             ngram_max = 4)  # 0.42 secs
        
        collocations %>% head()
        
        #-- For coocurence
        coocurence <- cooccurrence(     # try `?cooccurrence` for parm options
          x = subset(x, upos %in% c("NOUN", "ADJ")), 
          term = "lemma", 
          group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
        head(coocurence)
        
        #-- For occurence gen
        coc_gen <- cooccurrence(x = x$lemma, 
                                relevant = x$upos %in% c("NOUN", "ADJ")) # 0.00 secs
        
        head(coc_gen)
        
        # Coocurence Graph
        # Visualising top-30 co-occurrences using a network plot
        library(igraph)
        library(ggraph)
        library(ggplot2)
        #font_import()
        #library(extrafont)
        #library(extrafontdb)
        #loadfonts()
        
        wordnetwork <- head(coocurence, 50)
        wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
        
        ggraph(wordnetwork, layout = "fr") + geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
          geom_node_text(aes(label = name), col = "darkgreen", size = 4) +  theme_graph(base_family = "Arial Narrow") +  
          theme(legend.position = "none") + labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")
        
      } else if (input$select == 3){
        #Megha  you need to start from here for the graph purpose
        spanish_model = udpipe_load_model("/Users/i303433/Desktop/CBA-Term2/textAnalytics/spanish-ud-2.0-170801.udpipe")
        x <- udpipe_annotate(spanish_model, x = nokia) #%>% as.data.frame() %>% head()
        x <- as.data.frame(x)
        head(x, 4)
        collocations <- keywords_collocation(x = x,   # try ?keywords_collocation
                                             term = "token", 
                                             group = c("doc_id", "paragraph_id", "sentence_id"),
                                             ngram_max = 4)  # 0.42 secs
        
        collocations %>% head()
        
        #-- For coocurence
        coocurence <- cooccurrence(     # try `?cooccurrence` for parm options
          x = subset(x, upos %in% c("NOUN", "ADJ")), 
          term = "lemma", 
          group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
        head(coocurence)
        
        #-- For occurence gen
        coc_gen <- cooccurrence(x = x$lemma, 
                                relevant = x$upos %in% c("NOUN", "ADJ")) # 0.00 secs
        
        head(coc_gen)
        
        # Coocurence Graph
        # Visualising top-30 co-occurrences using a network plot
        library(igraph)
        library(ggraph)
        library(ggplot2)
        #font_import()
        #library(extrafont)
        #library(extrafontdb)
        #loadfonts()
        
        wordnetwork <- head(coocurence, 50)
        wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
        
        ggraph(wordnetwork, layout = "fr") + geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
          geom_node_text(aes(label = name), col = "darkgreen", size = 4) +  theme_graph(base_family = "Arial Narrow") +  
          theme(legend.position = "none") + labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")
        
      } else if (input$select == 2){
        #Megha  you need to start from here for the graph purpose
        hindi_model = udpipe_load_model("/Users/i303433/Desktop/CBA-Term2/textAnalytics/hindi-ud-2.0-170801.udpipe")
        x <- udpipe_annotate(hindi_model, x = nokia) #%>% as.data.frame() %>% head()
        x <- as.data.frame(x)
        head(x, 4)
        collocations <- keywords_collocation(x = x,   # try ?keywords_collocation
                                             term = "token", 
                                             group = c("doc_id", "paragraph_id", "sentence_id"),
                                             ngram_max = 4)  # 0.42 secs
        
        collocations %>% head()
        
        #-- For coocurence
        coocurence <- cooccurrence(     # try `?cooccurrence` for parm options
          x = subset(x, upos %in% c("NOUN", "ADJ")), 
          term = "lemma", 
          group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
        head(coocurence)
        
        #-- For occurence gen
        coc_gen <- cooccurrence(x = x$lemma, 
                                relevant = x$upos %in% c("NOUN", "ADJ")) # 0.00 secs
        
        head(coc_gen)
        
        # Coocurence Graph
        # Visualising top-30 co-occurrences using a network plot
        library(igraph)
        library(ggraph)
        library(ggplot2)
        #font_import()
        #library(extrafont)
        #library(extrafontdb)
        #loadfonts()
        
        wordnetwork <- head(coocurence, 50)
        wordnetwork <- igraph::graph_from_data_frame(wordnetwork) # needs edgelist in first 2 colms.
        
        ggraph(wordnetwork, layout = "fr") + geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +  
          geom_node_text(aes(label = name), col = "darkgreen", size = 4) +  theme_graph(base_family = "Arial Narrow") +  
          theme(legend.position = "none") + labs(title = "Cooccurrences within 3 words distance", subtitle = "Nouns & Adjective")
        
      } else {
        modelerror <- " No Model has been selected"
        modelerror
      }
    }
  })
  
  
  output$textdata <- renderText({
    fileText <- paste(Dataset(), collapse = "\n")
    fileText
  })
  
  
  # This piece of code is reponsible for reading the text and apply the model based on our selection
  output$udpipevalue <- renderPrint({ 
    count <- nchar(input$textfile$datapath)
    fileTextType <- substr(input$textfile$datapath, (count - 2) , nchar(input$textfile$datapath))
    if (fileTextType != 'txt') {
      errorMessage = "Please upload the file which is of .txt extension"
      errorMessage
    } else {
      errorMessage = ""
      errorMessage
      require(stringr)
      data  =  str_replace_all(Dataset(), "<.*?>", "") # get rid of html junk 
  #    str(data)
      if (input$select == 1) {
          english_model = udpipe_load_model("/Users/i303433/Desktop/CBA-Term2/textAnalytics/english-ud-2.0-170801.udpipe")
          x <- udpipe_annotate(english_model, x = data) #%>% as.data.frame() %>% head()
          x <- as.data.frame(x)
          head(x, 4)
          table(x$xpos)
          table(x$upos)
          
          if (input$checkGroup == 1){
            ADJ = "ADJ"
            all_adjective = x %>% subset(., upos %in% "ADJ") 
            top_nouns = txt_freq(all_adjective$lemma)  # txt_freq() calcs noun freqs in desc order
            head(top_nouns, 10)
          } 
          
          if (input$checkGroup == 2) {
            NOUN = "NOUN"
            all_nouns = x %>% subset(., upos %in% "NOUN") 
            top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
            head(top_nouns, 10)
          }  
          
          if (input$checkGroup == 3) {
            PRON = "PRON"
            all_pron = x %>% subset(., upos %in% "PRON") 
            top_pron = txt_freq(all_pron$lemma)  # txt_freq() calcs noun freqs in desc order
            head(top_pron, 10)
          }
          
          if (input$checkGroup == 4) {
            ADV = "ADV"
            all_adverb = x %>% subset(., upos %in% "ADV") 
            top_adverb = txt_freq(all_adverb$lemma)  # txt_freq() calcs noun freqs in desc order
            head(top_adverb, 10)
          }
          
          if (input$checkGroup == 5) {
            VERB = "VERB"
            all_verbs = x %>% subset(., upos %in% "VERB") 
            top_verbs = txt_freq(all_verbs$lemma)
            head(top_verbs, 10)
          }
          
          #-- For collocation code
          collocations <- keywords_collocation(x = x,   # try ?keywords_collocation
                              term = "token", 
                              group = c("doc_id", "paragraph_id", "sentence_id"),
                              ngram_max = 4)  # 0.42 secs

          collocations %>% head()
          
          #-- For coocurence
          coocurence <- cooccurrence(     # try `?cooccurrence` for parm options
              x = subset(x, upos %in% c("NOUN", "ADJ")), #Gaurav this is the place i need the values, which i've explaned you on the call.
                      term = "lemma", 
                      group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
          head(coocurence)
          
          
          #-- For occurence gen
          coc_gen <- cooccurrence(x = x$lemma, 
                      relevant = x$upos %in% c("NOUN", "ADJ")) # 0.00 secs #Gaurav same thing you need to pass here.

          head(coc_gen)
          
      } else if (input$select == 3){
        #Megha you need  start form here for Spanish
        spanish_model = udpipe_load_model("/Users/i303433/Desktop/CBA-Term2/textAnalytics/spanish-ud-2.0-170801.udpipe")
        x <- udpipe_annotate(spanish_model, x = nokia) #%>% as.data.frame() %>% head()
        x <- as.data.frame(x)
        head(x, 4)
        table(x$xpos)
        table(x$upos)
        
        if (input$checkGroup == 1){
          ADJ = "ADJ"
          all_adjective = x %>% subset(., upos %in% "ADJ") 
          top_adjectives = txt_freq(all_adjective$lemma)  # txt_freq() calcs noun freqs in desc order
          head(top_adjectives, 10)
        } 
        
        if (input$checkGroup == 2) {
          NOUN = "NOUN"
          all_nouns = x %>% subset(., upos %in% "NOUN") 
          top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
          head(top_nouns, 10)
        }  
        
        if (input$checkGroup == 3) {
          PRON = "PRON"
          all_pron = x %>% subset(., upos %in% "PRON") 
          top_pron = txt_freq(all_pron$lemma)  # txt_freq() calcs noun freqs in desc order
          head(top_pron, 10)
        }
        
        if (input$checkGroup == 4) {
          ADV = "ADV"
          all_adverb = x %>% subset(., upos %in% "ADV") 
          top_adverb = txt_freq(all_adverb$lemma)  # txt_freq() calcs noun freqs in desc order
          head(top_adverb, 10)
        }
        
        if (input$checkGroup == 5) {
          VERB = "VERB"
          all_verbs = x %>% subset(., upos %in% "VERB") 
          top_verbs = txt_freq(all_verbs$lemma)
          head(top_verbs, 10)
        }
        
        #-- For collocation code
        collocations <- keywords_collocation(x = x,   # try ?keywords_collocation
                                             term = "token", 
                                             group = c("doc_id", "paragraph_id", "sentence_id"),
                                             ngram_max = 4)  # 0.42 secs
        
        collocations %>% head()
        
        #-- For coocurence
        coocurence <- cooccurrence(     # try `?cooccurrence` for parm options
          x = subset(x, upos %in% c("NOUN", "ADJ")), #Gaurav this is the place i need the values, which i've explaned you on the call.
          term = "lemma", 
          group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
        head(coocurence)
        
        
        #-- For occurence gen
        coc_gen <- cooccurrence(x = x$lemma, 
                                relevant = x$upos %in% c("NOUN", "ADJ")) # 0.00 secs #Gaurav same thing you need to pass here.
        
        head(coc_gen)
      } else if (input$select == 2){
        
        #Megha you need  start form here for hindi
        hindi_model = udpipe_load_model("/Users/i303433/Desktop/CBA-Term2/textAnalytics/hindi-ud-2.0-170801.udpipe")
        x <- udpipe_annotate(hindi_model, x = nokia) #%>% as.data.frame() %>% head()
        x <- as.data.frame(x)
        head(x, 4)
        table(x$xpos)
        table(x$upos)
        
        if (input$checkGroup == 1){
          ADJ = "ADJ"
          all_adjective = x %>% subset(., upos %in% "ADJ") 
          top_adjective = txt_freq(all_adjective$lemma)  # txt_freq() calcs noun freqs in desc order
          head(top_adjective, 10)
        } 
        
        if (input$checkGroup == 2) {
          NOUN = "NOUN"
          all_nouns = x %>% subset(., upos %in% "NOUN") 
          top_nouns = txt_freq(all_nouns$lemma)  # txt_freq() calcs noun freqs in desc order
          head(top_nouns, 10)
        }  
        
        if (input$checkGroup == 3) {
          PRON = "PRON"
          all_pron = x %>% subset(., upos %in% "PRON") 
          top_pron = txt_freq(all_pron$lemma)  # txt_freq() calcs noun freqs in desc order
          head(top_pron, 10)
        }
        
        if (input$checkGroup == 4) {
          ADV = "ADV"
          all_adverb = x %>% subset(., upos %in% "ADV") 
          top_adverb = txt_freq(all_adverb$lemma)  # txt_freq() calcs noun freqs in desc order
          head(top_adverb, 10)
        }
        
        if (input$checkGroup == 5) {
          VERB = "VERB"
          all_verbs = x %>% subset(., upos %in% "VERB") 
          top_verbs = txt_freq(all_verbs$lemma)
          head(top_verbs, 10)
        }
        
        #-- For collocation code
        collocations <- keywords_collocation(x = x,   # try ?keywords_collocation
                                             term = "token", 
                                             group = c("doc_id", "paragraph_id", "sentence_id"),
                                             ngram_max = 4)  # 0.42 secs
        
        collocations %>% head()
        
        #-- For coocurence
        coocurence <- cooccurrence(     # try `?cooccurrence` for parm options
          x = subset(x, upos %in% c("NOUN", "ADJ")), #Gaurav this is the place i need the values, which i've explaned you on the call.
          term = "lemma", 
          group = c("doc_id", "paragraph_id", "sentence_id"))  # 0.02 secs
        head(coocurence)
        
        
        #-- For occurence gen
        coc_gen <- cooccurrence(x = x$lemma, 
                                relevant = x$upos %in% c("NOUN", "ADJ")) # 0.00 secs #Gaurav same thing you need to pass here.
        
        head(coc_gen)
      } else {
        modelerror <- " No Model has been selected"
        modelerror
      }
    }
    })
  
})
